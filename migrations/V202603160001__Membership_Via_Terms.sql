-- Migration: Make Membership work through Terms, not directly through Committees
-- TermID becomes required; CommitteeID is dropped (inherited from Term.CommitteeID).
--
-- For any existing Membership rows that have a NULL TermID, we create a
-- catch-all "Legacy" term on the relevant committee so no data is lost.
-- Idempotent: safe to re-run if partially or fully applied.

---------------------------------------------------------------------------
-- 1. Create a catch-all Term for any Membership rows missing a TermID
--    (only runs if CommitteeID column still exists on Membership)
---------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('__mj_Committees.Membership') AND name = 'CommitteeID')
BEGIN
    INSERT INTO __mj_Committees.Term (CommitteeID, Name, StartDate, Status)
    SELECT DISTINCT
        m.CommitteeID,
        'Legacy',
        m.StartDate,
        'Active'
    FROM __mj_Committees.Membership m
    WHERE m.TermID IS NULL
      AND NOT EXISTS (
          SELECT 1 FROM __mj_Committees.Term t
          WHERE t.CommitteeID = m.CommitteeID AND t.Name = 'Legacy'
      );
END
GO

---------------------------------------------------------------------------
-- 2. Back-fill TermID on Membership rows that are still NULL
--    (only runs if CommitteeID column still exists on Membership)
---------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('__mj_Committees.Membership') AND name = 'CommitteeID')
BEGIN
    UPDATE m
    SET m.TermID = t.ID
    FROM __mj_Committees.Membership m
    INNER JOIN __mj_Committees.Term t
        ON t.CommitteeID = m.CommitteeID AND t.Name = 'Legacy'
    WHERE m.TermID IS NULL;
END
GO

---------------------------------------------------------------------------
-- 3. Make TermID required
--    Must drop FK and index first, then re-add after ALTER COLUMN
---------------------------------------------------------------------------
ALTER TABLE __mj_Committees.Membership DROP CONSTRAINT IF EXISTS FK_Membership_Term;
GO

DROP INDEX IF EXISTS IDX_AUTO_MJ_FKEY_Membership_TermID ON __mj_Committees.Membership;
GO

ALTER TABLE __mj_Committees.Membership ALTER COLUMN TermID UNIQUEIDENTIFIER NOT NULL;
GO

ALTER TABLE __mj_Committees.Membership ADD
    CONSTRAINT FK_Membership_Term FOREIGN KEY (TermID) REFERENCES __mj_Committees.Term(ID);
GO

---------------------------------------------------------------------------
-- 4. Drop CommitteeID FK, index, and column (if still present)
---------------------------------------------------------------------------
ALTER TABLE __mj_Committees.Membership DROP CONSTRAINT IF EXISTS FK_Membership_Committee;
GO

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('__mj_Committees.Membership') AND name = 'CommitteeID')
BEGIN
    -- Drop any index on CommitteeID (CodeGen may have created one)
    DECLARE @idxName NVARCHAR(256);
    SELECT @idxName = i.name
    FROM sys.indexes i
    INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
    INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
    WHERE i.object_id = OBJECT_ID('__mj_Committees.Membership')
      AND c.name = 'CommitteeID'
      AND i.is_primary_key = 0;

    IF @idxName IS NOT NULL
        EXEC('DROP INDEX ' + @idxName + ' ON __mj_Committees.Membership');

    ALTER TABLE __mj_Committees.Membership DROP COLUMN CommitteeID;
END
GO
