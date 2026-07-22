// Comprehensive functional test of the BizApps Committees object model on PostgreSQL.
//
// Exercises the WRITE path (CodeGen-generated CRUD functions), the READ path (FK-join base
// views), the distinctive model features (the THREE recursive root-parent hierarchies:
// Committee.ParentCommitteeID, AgendaItem.ParentAgendaItemID, Comment.ParentCommentID),
// cross-schema joins into bizapps-common (Person, Organization) and bizapps-tasks (Task),
// DB-level CHECK enforcement (Committee.Status, Membership.RenewalIntent, Vote.VoteValue,
// Ballot ClosesAt>OpensAt window) plus the UQ_Vote one-vote-per-member rule, the voting
// model defaults, and full CRUD round-trips. Self-cleaning. Committees analog of
// bizapps-tasks' scripts/pg-objectmodel-test.mjs.
//
// PREREQUISITE: the FULL three-stage install from
// migrations-pg/docs/PG_INSTALL_VERIFICATION.md — `mj migrate` alone is NOT enough.
// Committees' PG migrations are legacy-converted (not baked), so the spCreate*/spUpdate*/
// spDelete* functions this test calls only exist after `mj codegen` has run, and section
// [1] only passes after `mj sync push` has seeded metadata/.
//
// Run: node scripts/pg-objectmodel-test.mjs
// Connection via env: PGHOST/PGPORT/PGDATABASE/PGUSER/PGPASSWORD
import { Pool } from 'pg';

const S = '__mj_bizappscommittees';
const C = '__mj_bizappscommon';
const T = '__mj_bizappstasks';
const pool = new Pool({
  host: process.env.PGHOST ?? 'localhost',
  port: +(process.env.PGPORT ?? 5439),
  user: process.env.PGUSER ?? 'mj_admin',
  password: process.env.PGPASSWORD ?? 'Verify99',
  database: process.env.PGDATABASE ?? 'Committees_OneShot',
});
const q = (sql, p) => pool.query(sql, p);

let pass = 0, fail = 0;
const ok = (n) => { pass++; console.log(`  ✓ ${n}`); };
const bad = (n, d) => { fail++; console.log(`  ✗ ${n} — ${d}`); };
const check = (n, cond, d) => (cond ? ok(n) : bad(n, d));
const created = []; // {schema, table, id} in reverse-dependency order for cleanup

async function createRow(schema, table, fn, args) {
  const keys = Object.keys(args);
  const id = (
    await q(
      `SELECT "ID" FROM ${schema}."${fn}"(${keys.map((k, i) => `${k} := $${i + 1}`).join(', ')})`,
      Object.values(args),
    )
  ).rows[0].ID;
  created.unshift({ schema, table, id });
  return id;
}

// needle match is case-insensitive: converter DDL keeps mixed-case constraint
// names ("CK_Committee_Status") while codegen-created objects may be lowercase
async function expectError(name, sql, params, needle) {
  try {
    await q(sql, params);
    bad(name, 'statement succeeded but should have violated a constraint');
  } catch (e) {
    check(name, e.message.toLowerCase().includes(needle.toLowerCase()), e.message.slice(0, 120));
  }
}

async function main() {
  console.log('\n[1] Seeded reference data (metadata/ via `mj sync push`)');
  for (const [t, want] of [['Type', 5], ['Role', 8], ['ArtifactType', 9]]) {
    const n = +(await q(`SELECT count(*) c FROM ${S}."${t}"`)).rows[0].c;
    check(`${t} seeded (=${want})`, n === want, `got ${n}`);
  }
  const credN = +(await q(`SELECT count(*) c FROM __mj."CredentialType" WHERE "Name"='Video Provider OAuth'`)).rows[0].c;
  check('core CredentialType "Video Provider OAuth" seeded (=1)', credN === 1, `got ${credN}`);

  console.log('\n[2] Create + FK-join base view reads (incl. cross-schema Person/Organization)');
  const person = await createRow(C, 'Person', 'spCreatePerson', { p_firstname: 'TEST', p_lastname: 'Chairholder' });
  const org = await createRow(C, 'Organization', 'spCreateOrganization', { p_name: 'TEST Governance Org' });
  const typeStanding = (await q(`SELECT "ID" FROM ${S}."Type" WHERE "Name"='Standing Committee'`)).rows[0].ID;
  const committee = await createRow(S, 'Committee', 'spCreateCommittee', { p_name: 'TEST Finance Committee', p_typeid: typeStanding, p_organizationid: org });
  const comRow = (await q(`SELECT "Type","Organization","Status","IsPublic" FROM ${S}."vwCommittees" WHERE "ID"=$1`, [committee])).rows[0];
  check('vwCommittees FK-joins (Type + cross-schema Organization)', comRow.Type === 'Standing Committee' && comRow.Organization === 'TEST Governance Org', JSON.stringify(comRow));
  check('Committee defaults (Status=Active, IsPublic=true)', comRow.Status === 'Active' && comRow.IsPublic === true, JSON.stringify(comRow));
  const term = await createRow(S, 'Term', 'spCreateTerm', { p_committeeid: committee, p_name: 'TEST Term 2026', p_startdate: '2026-01-01' });
  const termRow = (await q(`SELECT "Committee","Status" FROM ${S}."vwTerms" WHERE "ID"=$1`, [term])).rows[0];
  check('vwTerms Committee join + Status default', termRow.Committee === 'TEST Finance Committee' && termRow.Status === 'Active', JSON.stringify(termRow));
  const roleChair = (await q(`SELECT "ID" FROM ${S}."Role" WHERE "Name"='Chair'`)).rows[0].ID;
  const membership = await createRow(S, 'Membership', 'spCreateMembership', { p_personid: person, p_roleid: roleChair, p_termid: term, p_startdate: '2026-01-01' });
  const memRow = (await q(`SELECT "Person","Role","Term" FROM ${S}."vwMemberships" WHERE "ID"=$1`, [membership])).rows[0];
  check('vwMemberships joins (cross-schema Person DisplayName + Role + Term)',
    memRow.Person === 'TEST Chairholder' && memRow.Role === 'Chair' && memRow.Term === 'TEST Term 2026', JSON.stringify(memRow));

  console.log('\n[3] Recursive root-parent hierarchies (Committee / AgendaItem / Comment)');
  const childCommittee = await createRow(S, 'Committee', 'spCreateCommittee', { p_name: 'TEST Audit Subcommittee', p_typeid: typeStanding, p_parentcommitteeid: committee });
  const childComRow = (await q(`SELECT "ParentCommittee","RootParentCommitteeID" FROM ${S}."vwCommittees" WHERE "ID"=$1`, [childCommittee])).rows[0];
  check('Committee root-parent (child.RootParentCommitteeID = parent) + ParentCommittee join',
    childComRow.RootParentCommitteeID === committee && childComRow.ParentCommittee === 'TEST Finance Committee', JSON.stringify(childComRow));
  const meeting = await createRow(S, 'Meeting', 'spCreateMeeting', { p_committeeid: committee, p_name: 'TEST Q3 Meeting', p_startdatetime: '2026-08-01T15:00:00Z' });
  const agendaParent = await createRow(S, 'AgendaItem', 'spCreateAgendaItem', { p_meetingid: meeting, p_sequence: 1, p_name: 'TEST Agenda Parent' });
  const agendaChild = await createRow(S, 'AgendaItem', 'spCreateAgendaItem', { p_meetingid: meeting, p_sequence: 2, p_name: 'TEST Agenda Child', p_parentagendaitemid: agendaParent });
  const agRow = (await q(`SELECT "Meeting","ParentAgendaItem","RootParentAgendaItemID" FROM ${S}."vwAgendaItems" WHERE "ID"=$1`, [agendaChild])).rows[0];
  check('AgendaItem root-parent + Meeting/ParentAgendaItem joins',
    agRow.RootParentAgendaItemID === agendaParent && agRow.Meeting === 'TEST Q3 Meeting' && agRow.ParentAgendaItem === 'TEST Agenda Parent', JSON.stringify(agRow));
  const commentParent = await createRow(S, 'Comment', 'spCreateComment', { p_committeeid: committee, p_personid: person, p_commenttext: 'TEST root comment' });
  const commentChild = await createRow(S, 'Comment', 'spCreateComment', { p_committeeid: committee, p_personid: person, p_parentcommentid: commentParent, p_commenttext: 'TEST reply' });
  const cmRow = (await q(`SELECT "Person","RootParentCommentID" FROM ${S}."vwComments" WHERE "ID"=$1`, [commentChild])).rows[0];
  check('Comment root-parent + cross-schema Person join',
    cmRow.RootParentCommentID === commentParent && cmRow.Person === 'TEST Chairholder', JSON.stringify(cmRow));

  console.log('\n[4] Voting model + DB-level CHECK enforcement');
  await expectError(
    'CK_Committee_Status rejects unknown status',
    `UPDATE ${S}."Committee" SET "Status"='Bogus' WHERE "ID"=$1`, [childCommittee],
    'ck_committee_status',
  );
  await expectError(
    'CK_Membership_RenewalIntent rejects a value outside Yes/No/Undecided',
    `UPDATE ${S}."Membership" SET "RenewalIntent"='Maybe' WHERE "ID"=$1`, [membership],
    'ck_membership_renewalintent',
  );
  const motion = await createRow(S, 'Motion', 'spCreateMotion', { p_name: 'TEST Motion to adopt budget', p_sequence: 1 });
  const moRow = (await q(`SELECT "Result" FROM ${S}."vwMotions" WHERE "ID"=$1`, [motion])).rows[0];
  check('Motion default Result=Pending (meeting-less e-ballot motion)', moRow.Result === 'Pending', JSON.stringify(moRow));
  await expectError(
    'CK_Ballot_Window rejects ClosesAt <= OpensAt',
    `INSERT INTO ${S}."Ballot" ("CommitteeID","MotionID","OpensAt","ClosesAt") VALUES ($1,$2,now(),now())`, [committee, motion],
    'ck_ballot_window',
  );
  const ballot = await createRow(S, 'Ballot', 'spCreateBallot', { p_committeeid: committee, p_motionid: motion, p_opensat: '2026-08-01T00:00:00Z', p_closesat: '2026-08-08T00:00:00Z' });
  const baRow = (await q(`SELECT "Committee","Motion","Status","ThresholdType","IsSealed" FROM ${S}."vwBallots" WHERE "ID"=$1`, [ballot])).rows[0];
  check('vwBallots joins + defaults (Status=Open, ThresholdType=SimpleMajority, IsSealed=true)',
    baRow.Committee === 'TEST Finance Committee' && baRow.Motion === 'TEST Motion to adopt budget'
      && baRow.Status === 'Open' && baRow.ThresholdType === 'SimpleMajority' && baRow.IsSealed === true, JSON.stringify(baRow));
  const vote = await createRow(S, 'Vote', 'spCreateVote', { p_motionid: motion, p_membershipid: membership, p_votevalue: 'Yes' });
  const voRow = (await q(`SELECT "Motion","VoteValue" FROM ${S}."vwVotes" WHERE "ID"=$1`, [vote])).rows[0];
  check('spCreateVote + vwVotes Motion join', voRow.Motion === 'TEST Motion to adopt budget' && voRow.VoteValue === 'Yes', JSON.stringify(voRow));
  await expectError(
    'CK_Vote_Value rejects a value outside Yes/No/Abstain/Absent',
    `INSERT INTO ${S}."Vote" ("MotionID","MembershipID","VoteValue") VALUES ($1,$2,'Maybe')`, [motion, membership],
    'ck_vote_value',
  );
  await expectError(
    'UQ_Vote rejects a second vote by the same membership on the same motion',
    `INSERT INTO ${S}."Vote" ("MotionID","MembershipID","VoteValue") VALUES ($1,$2,'No')`, [motion, membership],
    'uq_vote',
  );

  console.log('\n[5] Cross-schema: bizapps-tasks Task joined into Artifact and Comment views');
  const taskType = (await q(`SELECT "ID" FROM ${T}."TaskType" WHERE "Name"='Action Item'`)).rows[0].ID;
  const task = await createRow(T, 'Task', 'spCreateTask', { p_name: 'TEST Committee Task', p_typeid: taskType });
  const artifactType = (await q(`SELECT "ID" FROM ${S}."ArtifactType" WHERE "Name"='Document'`)).rows[0].ID;
  const artifact = await createRow(S, 'Artifact', 'spCreateArtifact', {
    p_committeeid: committee, p_taskid: task, p_name: 'TEST Charter.pdf', p_artifacttypeid: artifactType,
    p_provider: 'URL', p_url: 'https://example.com/test-charter.pdf', p_uploadedbypersonid: person,
  });
  const arRow = (await q(`SELECT "Committee","Task","ArtifactType","UploadedByPerson" FROM ${S}."vwArtifacts" WHERE "ID"=$1`, [artifact])).rows[0];
  check('vwArtifacts joins (Committee + cross-schema Task + ArtifactType + UploadedByPerson)',
    arRow.Committee === 'TEST Finance Committee' && arRow.Task === 'TEST Committee Task'
      && arRow.ArtifactType === 'Document' && arRow.UploadedByPerson === 'TEST Chairholder', JSON.stringify(arRow));
  const taskComment = await createRow(S, 'Comment', 'spCreateComment', {
    p_committeeid: committee, p_personid: person, p_taskid: task, p_artifactid: artifact, p_commenttext: 'TEST comment on task',
  });
  const tcRow = (await q(`SELECT "Task","Artifact" FROM ${S}."vwComments" WHERE "ID"=$1`, [taskComment])).rows[0];
  check('vwComments cross-schema Task join + Artifact join',
    tcRow.Task === 'TEST Committee Task' && tcRow.Artifact === 'TEST Charter.pdf', JSON.stringify(tcRow));

  console.log('\n[6] spUpdate round-trip + row-touch trigger + spDelete cleanup');
  const before = (await q(`SELECT "__mj_UpdatedAt" FROM ${S}."Committee" WHERE "ID"=$1`, [committee])).rows[0].__mj_UpdatedAt;
  await new Promise((r) => setTimeout(r, 20));
  const upd = (await q(`SELECT "Name","Status" FROM ${S}."spUpdateCommittee"(p_id := $1, p_name := 'TEST Finance Committee v2', p_status := 'Inactive')`, [committee])).rows[0];
  check('spUpdateCommittee returns updated row from view', upd.Name === 'TEST Finance Committee v2' && upd.Status === 'Inactive', JSON.stringify(upd));
  const after = (await q(`SELECT "__mj_UpdatedAt" FROM ${S}."Committee" WHERE "ID"=$1`, [committee])).rows[0].__mj_UpdatedAt;
  check('__mj_UpdatedAt trigger bumped on update', new Date(after) > new Date(before), `${before} -> ${after}`);

  let cleaned = 0;
  for (const { schema, table, id } of created) {
    const r = await q(`SELECT "ID" FROM ${schema}."spDelete${table}"(p_id := $1)`, [id]);
    if (r.rows[0]?.ID === id) cleaned++;
  }
  check(`spDelete* removed all ${created.length} created rows (reverse-dependency order)`, cleaned === created.length, `cleaned ${cleaned}`);
  const leftovers = +(await q(`SELECT count(*) c FROM ${S}."Committee" WHERE "Name" LIKE 'TEST %'`)).rows[0].c;
  check('no TEST leftovers', leftovers === 0, `found ${leftovers}`);

  console.log(`\nRESULT: ${pass} passed, ${fail} failed`);
  await pool.end();
  process.exit(fail ? 1 : 0);
}

main().catch(async (e) => {
  console.error('FATAL:', e.message);
  // best-effort cleanup
  for (const { schema, table, id } of created) {
    try { await q(`SELECT * FROM ${schema}."spDelete${table}"(p_id := $1)`, [id]); } catch { /* already gone */ }
  }
  await pool.end();
  process.exit(1);
});
