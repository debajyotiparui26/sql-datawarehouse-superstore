create database SuperstoreDW;
drop database SuperstoreDW;

USE SuperstoreDW;
GO
 
PRINT '>> Now using SuperstoreDW';
GO

--create schemas(bronze,silver,gold)
IF NOT EXISTS (
    SELECT 1 FROM sys.schemas WHERE name = 'bronze'
)
BEGIN
    EXEC('CREATE SCHEMA bronze');
    PRINT '>> Schema bronze created';
END
ELSE
    PRINT '>> Schema bronze already exists - skipped';
GO
 
-- ── Silver schema ────────────────────────────────────────────
IF NOT EXISTS (
    SELECT 1 FROM sys.schemas WHERE name = 'silver'
)
BEGIN
    EXEC('CREATE SCHEMA silver');
    PRINT '>> Schema silver created';
END
ELSE
    PRINT '>> Schema silver already exists - skipped';
GO
 
-- ── Gold schema ──────────────────────────────────────────────
IF NOT EXISTS (
    SELECT 1 FROM sys.schemas WHERE name = 'gold'
)
BEGIN
    EXEC('CREATE SCHEMA gold');
    PRINT '>> Schema gold created';
END
ELSE
    PRINT '>> Schema gold already exists - skipped';
GO
 
PRINT '>> All schemas ready';
GO