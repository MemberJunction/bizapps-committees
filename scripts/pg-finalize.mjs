#!/usr/bin/env node
/**
 * pg-finalize.mjs — post-conversion patch layer for the BizApps Committees PostgreSQL migrations.
 *
 * WHY THIS EXISTS
 * ---------------
 * `mj migrate convert` (the @memberjunction/sql-converter rule pipeline) translates the
 * canonical SQL Server migrations under `migrations/` into PostgreSQL under `migrations-pg/`.
 * The converter is rule/string based; a small, well-understood set of T-SQL constructs it does
 * not fully translate are corrected here as a deterministic, idempotent post-pass — the
 * "things we fix after the converter" layer (converter → this finalize pass → pg-only supplements).
 *
 * It is intentionally SURGICAL and idempotent: re-running it on already-finalized files is a no-op,
 * and `mj migrate convert` itself never regenerates a `.pg.sql` that already exists, so these fixes
 * are preserved across normal conversion runs. If a migration is ever force-regenerated, re-run this.
 *
 * NO MemberJunction-core changes are involved — this lives entirely in the BizApps Committees repo.
 * Adapted from the bizapps-common / bizapps-tasks pg-finalize pipeline; the patches are generic,
 * only the app schema name (`__mj_BizAppsCommittees`), the bizapps boolean-column list, and two
 * committees-specific patches (extended-property translation, dependency-schema unquoting) differ.
 *
 * PATCHES (each documented with the converter gap it compensates for):
 *
 *  1. FK-join alias quoting. CodeGen base views define their FK-join aliases quoted
 *     (`... AS "mjBizAppsCommitteesType_TypeID"`) but the converter leaves the *references*
 *     unquoted, so PostgreSQL case-folds them to lowercase and raises "missing FROM-clause entry".
 *     We quote every `mj<Entity>_<FK>.` reference so it matches its quoted definition.
 *
 *  2. Skipped-trigger / unrecognized-batch neutralization. The converter cannot translate T-SQL
 *     `AFTER UPDATE` triggers, so it emits a `-- SKIPPED: trigger ...` marker — but only comments the
 *     `CREATE TRIGGER` line, leaving the (often truncated) body live, which is invalid PostgreSQL.
 *     These are the `__mj_UpdatedAt` maintenance triggers that `mj codegen` regenerates natively on
 *     PostgreSQL, so the migration must simply not contain them. Same treatment for `-- NOTE:
 *     unrecognized batch type (UNKNOWN)` passthroughs (none in the current committees set, kept for
 *     future regenerations). We comment out every live line of each block up to its terminator.
 *
 *  2b. Inline root-ID TVF translation. CodeGen emits one `fn<Table><Field>_GetRootID` function per
 *     self-referencing-ParentID entity (Committee, AgendaItem, Comment). The converter passes the
 *     T-SQL inline TVF through almost verbatim, producing invalid PostgreSQL (`RETURNS TABLE` with
 *     no column list, `AS RETURN (...)` body, non-RECURSIVE self-referencing CTE). We rewrite each
 *     block into the canonical `WITH RECURSIVE ... LANGUAGE sql STABLE` form, preserving the
 *     TABLE("RootID" <pk-type>) return contract.
 *
 *  2c. Extended-property translation. The T-SQL `IF NOT EXISTS (... sys.extended_properties ...)
 *     EXEC sp_addextendedproperty @name = 'MS_Description', ...` guards come through as live DO
 *     blocks referencing `sys.extended_properties` and a quoted `"EXEC"` — invalid PostgreSQL.
 *     The PostgreSQL equivalent of an MS_Description extended property is a comment, so each block
 *     is rewritten to `COMMENT ON TABLE/COLUMN ... IS '...'` (matching bizapps-common's shipped
 *     PG baseline, which carries COMMENT ON statements for its table/column descriptions).
 *
 *  3. Cast core boolean INSERTs. The converter emits native TRUE/FALSE for bizapps tables it sized
 *     from their CREATE TABLE, but cannot see the core `__mj` table types, so it leaves bare 0/1 —
 *     which PostgreSQL refuses to implicitly cast to boolean. Positionally cast 0/1 -> FALSE/TRUE for
 *     core `__mj` boolean columns (map in `pg-core-boolean-columns.json`).
 *
 *  4. Cast boolean comparisons. `"boolCol" = 0|1` / `<> 0|1` -> FALSE/TRUE in WHERE/UPDATE clauses
 *     (PostgreSQL has no implicit boolean=integer operator). Scoped to known boolean column names
 *     (MJ-core map ∪ the bizapps table booleans) so integer columns that legitimately equal 0/1 are
 *     never touched.
 *
 *  5. Quote core object refs. Unquoted mixed-case `__mj.vwGeneratedCodeCategories` folds to a
 *     non-existent lowercased relation; we quote mixed-case `__mj` object references.
 *
 *  6. Drop-before-create views. `CREATE OR REPLACE VIEW` cannot rename/reorder columns (42P16); a
 *     regeneration migration reshapes a view when an upstream table gains a column. We inject a
 *     `DROP VIEW IF EXISTS ... CASCADE` before each app-schema view block so the create is fresh.
 *     These base views are regenerated authoritatively by `mj codegen` on PostgreSQL.
 *
 *  7. Cast `_Clear` flag args. The CodeGen "tolerant" CRUD sprocs take boolean `<field>_Clear`
 *     flags; the converter passes integer `:= 1` / `:= 0`, which PostgreSQL cannot match to the
 *     boolean parameter. The `_Clear` suffix is the CodeGen convention, so it is a safe key.
 *
 *  8. Defer bizapps sproc seed blocks. On PostgreSQL the install is three-stage — `mj migrate`
 *     (DDL) -> `mj codegen` (creates the PG CRUD functions/views/triggers) -> `mj sync push` (seeds
 *     reference data). The CodeGen-emitted Metadata_Sync migration seeds the Type table by
 *     calling `__mj_BizAppsCommittees."spCreate*"`, but those functions do not exist yet at migrate
 *     time on PostgreSQL. The same seed data ships in `metadata/` and is loaded by `mj sync push`,
 *     so these `DO $mj$ … END $mj$;` blocks are commented out for PostgreSQL. Blocks that only call
 *     CORE `__mj."sp*"` functions (which already exist) are left intact.
 *
 *  9. Normalize schemas unquoted. The app schema identifier is normalized to UNQUOTED so
 *     PostgreSQL folds it to lowercase consistently — matching how `mj codegen` and the MJServer
 *     runtime emit schema references on PostgreSQL. The same applies to the DEPENDENCY schema
 *     reference `"${mjSchema}_BizAppsTasks"`: the runner resolves the placeholder to
 *     `__mj_BizAppsTasks`, but inside a QUOTED identifier the mixed-case result would not fold to
 *     bizapps-tasks' lowercase physical schema — so the quotes are stripped. Single-quoted string
 *     literals (the SchemaName metadata value, `format('%I', ...)` constants) are untouched.
 */
import { readFileSync, writeFileSync, readdirSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const HERE = dirname(fileURLToPath(import.meta.url));
const PG_DIR = join(HERE, '..', 'migrations-pg');

const APP_SCHEMA = '__mj_BizAppsCommittees';

/**
 * Boolean-column map for the MJ-core `__mj` schema. Used by Patch 3 to positionally cast integer
 * 0/1 literals to FALSE/TRUE in INSERTs into core tables. Copied from bizapps-common (identical to
 * bizapps-tasks' copy). Regenerate if the targeted MJ core version changes (this repo targets
 * MJ >=5.44):
 *   psql ... -c "SELECT json_object_agg(table_name, cols) FROM (SELECT table_name,
 *     json_agg(column_name ORDER BY column_name) cols FROM information_schema.columns
 *     WHERE table_schema='__mj' AND data_type='boolean' GROUP BY table_name) t" > pg-core-boolean-columns.json
 */
const CORE_BOOL_COLS = JSON.parse(readFileSync(join(HERE, 'pg-core-boolean-columns.json'), 'utf8'));

/** Split on top-level commas, respecting single-quoted strings ('' escapes) and parenthesis depth. */
function splitTopLevel(s) {
  const parts = [];
  let buf = '', depth = 0, inStr = false;
  for (let i = 0; i < s.length; i++) {
    const c = s[i];
    if (inStr) {
      buf += c;
      if (c === "'") {
        if (s[i + 1] === "'") { buf += s[++i]; } // escaped quote
        else inStr = false;
      }
      continue;
    }
    if (c === "'") { inStr = true; buf += c; continue; }
    if (c === '(') { depth++; buf += c; continue; }
    if (c === ')') { depth--; buf += c; continue; }
    if (c === ',' && depth === 0) { parts.push(buf); buf = ''; continue; }
    buf += c;
  }
  parts.push(buf);
  return parts;
}

/** Find index of the paren matching the `(` at openIdx, respecting quotes. */
function matchParen(s, openIdx) {
  let depth = 0, inStr = false;
  for (let i = openIdx; i < s.length; i++) {
    const c = s[i];
    if (inStr) { if (c === "'") { if (s[i + 1] === "'") i++; else inStr = false; } continue; }
    if (c === "'") inStr = true;
    else if (c === '(') depth++;
    else if (c === ')') { depth--; if (depth === 0) return i; }
  }
  return -1;
}

const unquoteIdent = (t) => t.trim().replace(/^"|"$/g, '');

/** Find the index of the first TOP-LEVEL `FROM` keyword at/after startIdx (quote/paren aware). */
function findTopLevelFrom(s, startIdx) {
  let depth = 0, inStr = false;
  for (let i = startIdx; i < s.length; i++) {
    const c = s[i];
    if (inStr) { if (c === "'") { if (s[i + 1] === "'") i++; else inStr = false; } continue; }
    if (c === "'") { inStr = true; continue; }
    if (c === '(') { depth++; continue; }
    if (c === ')') { if (depth === 0) return -1; depth--; continue; }
    if (c === ';' && depth === 0) return -1;
    if (depth === 0 && (c === 'F' || c === 'f') && /^FROM\b/i.test(s.slice(i, i + 5)) && /[\s)]/.test(s[i - 1] ?? ' ')) return i;
  }
  return -1;
}

/** Patch 1: quote unquoted `mj<Pascal>_<Field>.` view-join alias references. */
function quoteFkJoinAliasReferences(sql) {
  // Only lowercase-`mj`-prefixed PascalCase aliases (the converter's generated FK-join aliases).
  // Negative lookbehind on `"` avoids re-quoting; lookahead on `.` targets references, not the
  // already-quoted `AS "..."` definitions (which are followed by a newline, not a dot).
  return sql.replace(/(?<!")\b(mj[A-Z][A-Za-z0-9]*_[A-Za-z0-9]+)(?=\.)/g, '"$1"');
}

/**
 * Patch 2: fully comment out the live body left behind by the converter's incomplete skips.
 *  - `-- SKIPPED: trigger ...` — only the CREATE TRIGGER line is commented; the (often truncated)
 *    body stays live. These `__mj_UpdatedAt` triggers are regenerated by `mj codegen` on PostgreSQL.
 *    Trigger bodies have no `BEGIN…END;` structure to track, so a blank line (the batch boundary)
 *    terminates the block.
 *  - `-- NOTE: unrecognized batch type (UNKNOWN) — passed through as-is` — the converter could not
 *    translate the following batch and emitted the raw T-SQL verbatim. A procedure body legitimately
 *    CONTAINS blank lines, so the blank-line terminator used for triggers would stop early; instead
 *    we track `BEGIN`/`END` depth and comment through the matching `END;`. If the batch is not a
 *    procedure (no BEGIN seen), we fall back to the first blank line. (No such batches exist in the
 *    current committees set; kept for future regenerations.)
 */
function neutralizeSkippedTriggers(sql) {
  const lines = sql.split('\n');
  const out = [];
  const commentOut = (line) => (line.trim() === '' || line.startsWith('--')) ? line : `-- ${line}`;
  const isComment = (line) => line.trim().startsWith('--');
  const isBlank = (line) => line.trim() === '';

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];

    // (a) SKIPPED trigger: converter commented only the CREATE TRIGGER line; comment the rest of the
    //     (BEGIN/END-less, blank-terminated) trigger body. These are __mj_UpdatedAt triggers that
    //     `mj codegen` regenerates natively on PostgreSQL.
    if (/^--\s*SKIPPED:\s*trigger/i.test(line)) {
      out.push(line);
      while (i + 1 < lines.length && !isBlank(lines[i + 1])) out.push(commentOut(lines[++i]));
      continue;
    }

    // (b) UNKNOWN batch passthrough: the converter emitted raw T-SQL it couldn't translate. Comment
    //     the batch's live SQL out. The batch begins after a comment preamble (banner + section
    //     comments, which may contain blank lines), so we first advance past the preamble to the
    //     first real SQL line, then comment through the batch's matching END; (BEGIN/END
    //     depth-tracked). Idempotent: if that first real line is already commented, the batch was
    //     neutralized on a prior run and we leave it untouched.
    if (/^--\s*NOTE:\s*unrecognized batch type.*passed through as-is/i.test(line)) {
      out.push(line);
      let alreadyNeutralized = false;
      while (i + 1 < lines.length && (isComment(lines[i + 1]) || isBlank(lines[i + 1]))) {
        if (/^--\s*(CREATE|ALTER|DECLARE|DO|BEGIN)\b/i.test(lines[i + 1].trim())) alreadyNeutralized = true;
        out.push(lines[++i]);
      }
      if (alreadyNeutralized) continue; // batch already deferred on a prior run — leave the rest alone

      let beginDepth = 0, sawBegin = false;
      while (i + 1 < lines.length) {
        const body = lines[i + 1];
        // Strip BEGIN TRAN/TRANSACTION (paired with COMMIT/ROLLBACK, not END) before counting.
        const cf = body.replace(/\bBEGIN\s+TRAN(SACTION)?\b/gi, '');
        const begins = (cf.match(/\bBEGIN\b/gi) || []).length;
        const ends = (cf.match(/\bEND\b/gi) || []).length;
        if (begins > 0) sawBegin = true;
        beginDepth += begins - ends;
        out.push(commentOut(lines[++i]));
        if (sawBegin && beginDepth <= 0) break;          // batch's outermost END; reached
        if (!sawBegin && isBlank(body)) break;           // non-procedure batch: first blank line ends it
      }
      continue;
    }

    out.push(line);
  }
  return out.join('\n');
}

/**
 * Patch 2b: translate the converter's invalid inline table-valued functions (TVFs).
 *
 * CodeGen emits one `fn<Table><Field>_GetRootID` function per self-referencing-ParentID entity
 * (Committee, AgendaItem, Comment). The SS->PG converter passes the T-SQL inline TVF through
 * almost verbatim, producing INVALID PostgreSQL:
 *   - `RETURNS TABLE` with no column list (PG requires `RETURNS TABLE("col" type)`),
 *   - T-SQL `AS RETURN ( <query> )` body instead of `AS $fn$ <query> $fn$ LANGUAGE sql`,
 *   - a non-RECURSIVE `WITH` around a self-referencing CTE (PG requires `WITH RECURSIVE`),
 *   - an unquoted `AS RootID` alias that won't match the returned column.
 *
 * MJ Core's PostgreSQLCodeGenProvider.generateRootIDFunction defines the canonical PG body
 * (a `WITH RECURSIVE cte_root_parent` walk, `LANGUAGE sql STABLE`). We rewrite each baseline
 * block into that valid form, preserving the baseline's TABLE("RootID" <pk-type>) return
 * contract (Core deliberately keeps the table-returning baseline name distinct from the scalar
 * snake_case `fn_<table>_<field>_get_root_id` it generates for view joins, to avoid a
 * return-type clash — so we must NOT change the name or collapse it to a scalar).
 *
 * Idempotent: a block already rewritten contains `LANGUAGE sql STABLE` and no longer matches.
 */
function translateInlineRootIdTVFs(sql) {
  const re = /CREATE FUNCTION\s+(?<schema>[A-Za-z0-9_]+)\."(?<fn>[A-Za-z0-9_]+_GetRootID)"\s*\(\s*p_RecordID\s+(?<pktype>[A-Za-z0-9_]+),\s*p_ParentID\s+[A-Za-z0-9_]+\s*\)\s*RETURNS TABLE\s*AS\s*RETURN\s*\(\s*WITH\s+CTE_RootParent[\s\S]*?FROM\s+\1\."(?<table>[A-Za-z0-9_]+)"\s+c\s+INNER JOIN\s+CTE_RootParent\s+p\s+ON\s+c\."(?<pk>[A-Za-z0-9_]+)"\s*=\s*p\."(?<parent>[A-Za-z0-9_]+)"[\s\S]*?LIMIT\s+1\);/g;

  return sql.replace(re, (match, ...args) => {
    const g = args[args.length - 1]; // named-group object
    const { schema, fn, pktype, table, pk, parent } = g;
    return [
      `CREATE OR REPLACE FUNCTION ${schema}."${fn}"(`,
      `    p_RecordID ${pktype},`,
      `    p_ParentID ${pktype}`,
      `) RETURNS TABLE("RootID" ${pktype}) AS $fn$`,
      `    WITH RECURSIVE cte_root_parent AS (`,
      `        SELECT`,
      `            "${pk}",`,
      `            "${parent}",`,
      `            "${pk}" AS root_parent_id,`,
      `            0 AS depth`,
      `        FROM ${schema}."${table}"`,
      `        WHERE "${pk}" = COALESCE(p_ParentID, p_RecordID)`,
      ``,
      `        UNION ALL`,
      ``,
      `        SELECT`,
      `            c."${pk}",`,
      `            c."${parent}",`,
      `            c."${pk}" AS root_parent_id,`,
      `            p.depth + 1 AS depth`,
      `        FROM ${schema}."${table}" c`,
      `        INNER JOIN cte_root_parent p ON c."${pk}" = p."${parent}"`,
      `        WHERE p.depth < 100`,
      `    )`,
      `    SELECT root_parent_id AS "RootID"`,
      `    FROM cte_root_parent`,
      `    WHERE "${parent}" IS NULL`,
      `    ORDER BY root_parent_id`,
      `    LIMIT 1;`,
      `$fn$ LANGUAGE sql STABLE;`,
    ].join('\n');
  });
}

/**
 * Patch 2c: translate extended-property guard blocks into COMMENT ON statements.
 *
 * The SS migrations document tables/columns via
 *   IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ...) EXEC sp_addextendedproperty
 *     @name = N'MS_Description', @value = N'...', @level1type = N'TABLE', @level1name = N'X'
 *     [, @level2type = N'COLUMN', @level2name = N'Y'];
 * The converter wraps these in DO blocks but leaves `sys.extended_properties` and a quoted
 * `"EXEC"` — invalid PostgreSQL that fails at migrate time. The PG-native equivalent is
 * COMMENT ON, which is idempotent by definition (it overwrites), so the guard is dropped.
 */
function translateExtendedProperties(sql) {
  // The guard's SELECT must follow the `IF NOT EXISTS (` IMMEDIATELY — anchoring it prevents the
  // match from starting at an earlier, unrelated `DO $$ ... IF NOT EXISTS (` block (e.g. a CREATE
  // TABLE guard) and swallowing everything up to the first extended-property block.
  const blockRe = /DO \$\$\s*BEGIN\s*IF NOT EXISTS \(\s*SELECT 1 FROM sys\.extended_properties[\s\S]*?\) THEN\s*"EXEC" sp_addextendedproperty ([^\n]+);\s*END IF;\s*END \$\$;/g;
  const arg = (args, name) => {
    const m = new RegExp(`@${name}\\s*=\\s*'((?:[^']|'')*)'`).exec(args);
    return m ? m[1] : null;
  };
  return sql.replace(blockRe, (full, args) => {
    const value = arg(args, 'value');
    const table = arg(args, 'level1name');
    const column = arg(args, 'level2name');
    if (value === null || table === null) return full; // not the MS_Description shape — leave as-is
    return column !== null
      ? `COMMENT ON COLUMN ${APP_SCHEMA}."${table}"."${column}" IS '${value}';`
      : `COMMENT ON TABLE ${APP_SCHEMA}."${table}" IS '${value}';`;
  });
}

/**
 * Patch 3: positionally cast integer 0/1 -> FALSE/TRUE in INSERTs into MJ-core `__mj` boolean
 * columns. The converter emits native TRUE/FALSE for bizapps tables it sized from their CREATE
 * TABLE, but cannot see the core `__mj` table types, so it leaves bare 0/1 — which PostgreSQL
 * refuses to implicitly cast to boolean (and the catalog-level implicit cast is unavailable on
 * managed PG/Aurora).
 */
function castCoreBooleanInserts(sql) {
  // Core schema is referenced either literally (`__mj`) or via the `${mjSchema}` placeholder
  // (resolved by the migration runner) — match both, quoted or not.
  const re = /INSERT\s+INTO\s+(?:"?__mj"?|"?\$\{mjSchema\}"?)\."?([A-Za-z0-9_]+)"?\s*\(/gi;
  let out = '', last = 0, m;
  while ((m = re.exec(sql)) !== null) {
    const table = m[1];
    const boolCols = CORE_BOOL_COLS[table];
    const colOpen = re.lastIndex - 1; // index of the '(' after the column list
    const colClose = matchParen(sql, colOpen);
    if (colClose < 0) continue;
    const afterCols = sql.slice(colClose + 1);
    const vm = /^\s*VALUES\s*\(/i.exec(afterCols);
    if (!vm) {
      // SELECT-form INSERT (e.g. the ApplicationRole role-grant block): map the select-list
      // positionally against the column list and cast bare 0/1 items — including inside
      // CASE ... THEN/ELSE arms — for boolean-mapped columns.
      const sm = /^\s*SELECT\b/i.exec(afterCols);
      if (sm && boolCols && boolCols.length) {
        const selStart = colClose + 1 + sm[0].length;
        const fromIdx = findTopLevelFrom(sql, selStart);
        if (fromIdx > selStart) {
          const cols = splitTopLevel(sql.slice(colOpen + 1, colClose)).map(unquoteIdent);
          const items = splitTopLevel(sql.slice(selStart, fromIdx));
          if (cols.length === items.length) {
            const boolSet = new Set(boolCols);
            let touched = false;
            const newItems = items.map((v, i) => {
              if (!boolSet.has(cols[i])) return v;
              const t = v.trim();
              if (t === '1') { touched = true; return v.replace('1', 'TRUE'); }
              if (t === '0') { touched = true; return v.replace('0', 'FALSE'); }
              const cast = v
                .replace(/\b(THEN|ELSE)(\s+)1\b/gi, '$1$2TRUE')
                .replace(/\b(THEN|ELSE)(\s+)0\b/gi, '$1$2FALSE');
              if (cast !== v) touched = true;
              return cast;
            });
            if (touched) {
              out += sql.slice(last, selStart) + newItems.join(',');
              last = fromIdx;
              re.lastIndex = fromIdx;
              continue;
            }
          }
        }
      }
      continue;
    }
    const valOpen = colClose + 1 + vm[0].length - 1;
    const valClose = matchParen(sql, valOpen);
    if (valClose < 0) continue;

    if (boolCols && boolCols.length) {
      const cols = splitTopLevel(sql.slice(colOpen + 1, colClose)).map(unquoteIdent);
      const vals = splitTopLevel(sql.slice(valOpen + 1, valClose));
      if (cols.length === vals.length) {
        const boolSet = new Set(boolCols);
        let touched = false;
        const newVals = vals.map((v, i) => {
          if (!boolSet.has(cols[i])) return v;
          const t = v.trim();
          if (t === '1') { touched = true; return v.replace('1', 'TRUE'); }
          if (t === '0') { touched = true; return v.replace('0', 'FALSE'); }
          return v;
        });
        if (touched) {
          out += sql.slice(last, valOpen + 1) + newVals.join(',') + sql.slice(valClose, valClose + 1);
          last = valClose + 1;
          re.lastIndex = valClose + 1;
          continue;
        }
      }
    }
    re.lastIndex = valClose + 1;
  }
  out += sql.slice(last);
  return out;
}

/**
 * Patch 3b: cast integer DEFAULTs on BOOLEAN columns in DDL. The converter maps BIT -> BOOLEAN in
 * CREATE TABLE / ALTER TABLE but carries the T-SQL numeric default through (`BOOLEAN NOT NULL
 * DEFAULT 1`), and PostgreSQL rejects an integer default expression on a boolean column at DDL
 * time ("column ... is of type boolean but default expression is of type integer").
 * First confirmed live: `IsStandards` failed committees' baseline at CREATE TABLE.
 */
function castBooleanColumnDefaults(sql) {
  return sql.replace(/(\bBOOLEAN\b[^,\n]*\bDEFAULT\s+)\(*([01])\)*(?=\s*[,\n)])/g,
    (full, lhs, val) => `${lhs}${val === '1' ? 'TRUE' : 'FALSE'}`);
}

/**
 * Patch 3c: unquote quoted built-in type names in column definitions. The converter emits the
 * T-SQL `date` type as a QUOTED `"DATE"` (`"StartDate" "DATE" NOT NULL`); PostgreSQL treats a
 * quoted type name as a case-sensitive custom-type lookup and fails with 'type "DATE" does not
 * exist'. Only DATE is affected in this repo's set (verified by scanning all column definitions);
 * extend the alternation if a future conversion emits more.
 * First confirmed live: committees' baseline failed at CREATE TABLE Committee.
 */
function unquoteBuiltinTypeNames(sql) {
  return sql.replace(/("([A-Za-z0-9_]+)"\s+)"(DATE)"/g, (full, lhs, col, type) => `${lhs}${type}`);
}

/**
 * Patch 4: cast `"boolCol" = 0|1` / `<> 0|1` predicate comparisons to FALSE/TRUE. The converter
 * casts boolean INSERT values but not boolean comparisons in WHERE/UPDATE clauses (PostgreSQL has
 * no implicit boolean=integer operator). Scoped to known boolean column names (MJ-core map ∪ the
 * bizapps table booleans) so integer columns that legitimately equal 0/1 are never touched.
 */
const BIZAPPS_BOOL_COLS = ['IsActive', 'IsDefault', 'IsOfficer', 'IsPublic', 'IsResolved', 'IsSealed', 'IsStandards', 'IsVotingRole'];
const BOOL_NAMES = new Set([...Object.values(CORE_BOOL_COLS).flat(), ...BIZAPPS_BOOL_COLS]);
function castBooleanComparisons(sql) {
  return sql.replace(/"([A-Za-z0-9_]+)"(\s*(?:=|<>)\s*)([01])\b/g, (full, name, op, val) =>
    BOOL_NAMES.has(name) ? `"${name}"${op}${val === '1' ? 'TRUE' : 'FALSE'}` : full
  );
}

/**
 * Patch 5: quote unquoted schema-qualified references to mixed-case `__mj` core objects
 * (e.g. `__mj.vwGeneratedCodeCategories` -> `__mj."vwGeneratedCodeCategories"`). PostgreSQL folds
 * unquoted identifiers to lowercase, so an unquoted mixed-case core view/table reference resolves to
 * a non-existent lowercased relation. Only objects containing an uppercase letter are quoted;
 * already-quoted refs (`__mj."X"`) never match.
 */
function quoteCoreObjectRefs(sql) {
  return sql.replace(/\b__mj\.([A-Za-z_][A-Za-z0-9_]*)\b/g, (full, name) =>
    /[A-Z]/.test(name) ? `__mj."${name}"` : full
  );
}

/**
 * Patch 6: make view (re)creation idempotent across migrations. The converter wraps each view in a
 * `CREATE OR REPLACE VIEW` inside a self-healing DO-block, but `CREATE OR REPLACE` cannot rename or
 * reorder columns (PostgreSQL 42P16) — which a regeneration migration does when an upstream table
 * gains a column. We inject a `DROP VIEW IF EXISTS ... CASCADE` before each view block so the create
 * is always fresh. These base views are regenerated authoritatively by `mj codegen` on PostgreSQL,
 * and the bizapps base views have no inter-view dependencies, so the CASCADE is safe. Idempotent: a
 * DROP is injected at most once per block.
 */
function dropBeforeCreateViews(sql) {
  return sql.replace(
    // Match an optional already-injected DROP line immediately preceding the DO-block, so the guard
    // sees prior injections (they sit OUTSIDE the DO-block, on the line above it). Without capturing
    // that prefix the patch is non-idempotent — it prepends a fresh DROP on every run.
    new RegExp(`((?:DROP VIEW IF EXISTS ${APP_SCHEMA}\\."[^"]+" CASCADE;\\n)*)(DO \\$do\\$[\\s\\S]*?CREATE OR REPLACE VIEW\\s+(${APP_SCHEMA})\\."([^"]+)")`, 'g'),
    (full, existingDrops, block, schema, view) => {
      const drop = `DROP VIEW IF EXISTS ${schema}."${view}" CASCADE;\n`;
      // Already dropped (in the captured prefix or inside the block) — leave untouched.
      return existingDrops.includes(drop) || block.includes(drop.trimEnd())
        ? full
        : `${drop}${block}`;
    }
  );
}

/**
 * Patch 7: cast boolean literals in named function-call arguments. The CodeGen "tolerant" CRUD
 * sprocs take boolean `<field>_Clear` flags; the converter passes them as integer `:= 1` / `:= 0`,
 * which PostgreSQL cannot match to the boolean parameter (yielding "function ... does not exist").
 * The `_Clear` suffix is the CodeGen convention for these boolean clear-flags, so it is a safe key.
 */
function castClearFlagArgs(sql) {
  return sql.replace(/(_Clear\s*:=\s*)([01])\b/g, (full, lhs, val) => `${lhs}${val === '1' ? 'TRUE' : 'FALSE'}`);
}

/**
 * Patch 8: defer seed blocks that call bizapps CRUD sprocs. On PostgreSQL the MJ install is
 * three-stage — `mj migrate` (DDL) -> `mj codegen` (creates the PG CRUD functions/views/triggers) ->
 * `mj sync push` (seeds reference data). The CodeGen-emitted Metadata_Sync migration seeds the
 * Type table by calling `__mj_BizAppsCommittees."spCreate*"`, but those functions do not exist
 * yet at migrate time on PostgreSQL (they are produced later by codegen). The same seed data ships
 * in `metadata/` and is loaded by `mj sync push`, so these `DO $mj$ … END $mj$;` blocks are commented
 * out for PostgreSQL. Blocks that only call CORE `__mj."sp*"` functions (which already exist) are
 * left intact.
 */
function deferBizappsSprocSeedBlocks(sql) {
  // Capture an optional comment prefix on the opening line. The converter often already defers these
  // blocks itself (emitting `-- DO $mj$ … -- END $mj$;`); without capturing that `-- ` the regex would
  // still match the live-looking `DO $mj$` inside it and re-comment every line — non-idempotent,
  // producing `-- -- DO`. If the opening line is already commented, the whole block is left untouched.
  return sql.replace(/(^|\n)(--\s*)?(DO \$mj\$[\s\S]*?END \$mj\$;)/g, (full, lead, alreadyCommented, block) => {
    const callsBizappsSproc = new RegExp(`PERFORM\\s+"?${APP_SCHEMA}"?\\."sp(Create|Update|Delete)`, 'i').test(block);
    if (!callsBizappsSproc) return full;
    if (alreadyCommented) return full; // converter (or a prior run) already deferred this block
    const commented = block
      .split('\n')
      .map((l) => (l.startsWith('--') ? l : `-- ${l}`))
      .join('\n');
    return `${lead}${commented}`;
  });
}

/**
 * Patch 9: normalize schema identifiers to UNQUOTED, so PostgreSQL folds them to lowercase
 * consistently. This matches how `mj codegen` (and the MJServer runtime) generate schema references
 * on PostgreSQL — they emit the schema UNQUOTED (e.g. `__mj_BizAppsCommittees."Committee"`), which
 * folds to `__mj_bizappscommittees`. If the migration created a mixed-case quoted schema, codegen's
 * regenerated views/sprocs would look for the lowercased schema and fail with "relation does not
 * exist". The same treatment is applied to the quoted dependency reference
 * `"${mjSchema}_BizAppsTasks"` (bizapps-tasks' schema via the runner-resolved core placeholder):
 * after resolution a QUOTED `"__mj_BizAppsTasks"` would not fold to tasks' lowercase physical
 * schema. (`__mj_BizAppsCommon` references already come through unquoted; `"${mjSchema}"` alone is
 * harmless since `__mj` is already lowercase.) Table/column identifiers stay quoted (mixed case);
 * only SCHEMA identifiers are unquoted. Single-quoted string literals (`'__mj_BizAppsCommittees'`,
 * e.g. the SchemaName value and PL/pgSQL `format('%I', ...)` constants) are untouched — those carry
 * the canonical name in metadata and are quoted correctly at runtime by `%I`.
 */
function normalizeSchemasUnquoted(sql) {
  return sql
    .replaceAll(`"${APP_SCHEMA}"`, () => APP_SCHEMA)
    .replaceAll('"${mjSchema}_BizAppsTasks"', () => '${mjSchema}_BizAppsTasks')
    .replaceAll('"__mj_BizAppsTasks"', () => '__mj_BizAppsTasks')
    .replaceAll('"__mj_BizAppsCommon"', () => '__mj_BizAppsCommon');
}

/**
 * Patch 10: lowercase the app schema in metadata STRING LITERALS. On PostgreSQL,
 * `__mj."Entity"."SchemaName"` (and every other metadata value naming the schema) must hold the
 * PHYSICAL lowercase schema — matching what codegen's catalog scan sees — or codegen re-registers
 * every table as a duplicate `<Entity>____mj_bizappscommittees` entity (confirmed live: first PG
 * codegen run created 16 duplicates). bizapps-tasks' shipped PG baseline stores the lowercase
 * physical name the same way. Canonical casing lives ONLY in `SchemaInfo.CanonicalSchemaName`,
 * which the CodeGen_Metadata_Backfill `.pgonly.sql` sets — and pg-finalize never touches
 * `.pgonly.sql` files, so that value keeps its casing.
 */
function lowercaseAppSchemaStringLiterals(sql) {
  return sql.replaceAll(`'${APP_SCHEMA}'`, () => `'${APP_SCHEMA.toLowerCase()}'`);
}

const PATCHES = [
  ['quote FK-join alias references', quoteFkJoinAliasReferences],
  ['neutralize skipped triggers', neutralizeSkippedTriggers],
  ['translate inline root-id TVFs', translateInlineRootIdTVFs],
  ['translate extended properties to COMMENT ON', translateExtendedProperties],
  ['cast core boolean INSERTs', castCoreBooleanInserts],
  ['cast boolean column DEFAULTs', castBooleanColumnDefaults],
  ['unquote built-in type names', unquoteBuiltinTypeNames],
  ['cast boolean comparisons', castBooleanComparisons],
  ['quote core object refs', quoteCoreObjectRefs],
  ['drop-before-create views', dropBeforeCreateViews],
  ['cast _Clear flag args', castClearFlagArgs],
  ['defer bizapps sproc seed blocks', deferBizappsSprocSeedBlocks],
  ['normalize schemas unquoted', normalizeSchemasUnquoted],
  ['lowercase app schema string literals', lowercaseAppSchemaStringLiterals],
];

// Marker that a .pg.sql already carries CodeGen's native PG plpgsql (baked). These patches
// were written for the LEGACY rule-converter's output and MUST NOT run over native CodeGen
// objects — e.g. the FK-join-alias quoting patch quotes references that native views leave
// unquoted, producing "missing FROM-clause entry" at migrate time. Baked files are the final,
// hand-maintained artifact (re-bake when the schema changes; see migrations-pg/docs/), so
// pg-finalize skips them.
const BAKED_MARKER = 'CodeGen native PostgreSQL objects (baked from';

function main() {
  const files = readdirSync(PG_DIR).filter((f) => f.endsWith('.pg.sql'));
  let changed = 0, skipped = 0;
  for (const f of files) {
    const p = join(PG_DIR, f);
    const before = readFileSync(p, 'utf8');
    if (before.includes(BAKED_MARKER)) {
      skipped++;
      console.log(`  skipped (baked) ${f}`);
      continue;
    }
    let after = before;
    for (const [, fn] of PATCHES) after = fn(after);
    if (after !== before) {
      writeFileSync(p, after);
      changed++;
      console.log(`  finalized ${f}`);
    }
  }
  console.log(`pg-finalize: ${changed}/${files.length} file(s) patched, ${skipped} baked file(s) skipped (idempotent).`);
}

main();
