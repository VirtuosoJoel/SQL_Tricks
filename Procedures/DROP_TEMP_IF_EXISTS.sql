-- Remove any existing proc
IF OBJECT_ID('DROP_TEMP_IF_EXISTS', 'P') IS NOT NULL
	DROP PROCEDURE DROP_TEMP_IF_EXISTS
GO

-- Create Proc to drop a table if it exists
CREATE PROCEDURE DROP_TEMP_IF_EXISTS (@table_name AS VARCHAR(128))
AS
BEGIN
	IF OBJECT_ID('TempDB..'+@table_name, 'U') IS NOT NULL
		EXEC ('DROP TABLE ' + @table_name)
END
GO

-- Create a Temp Table to test the Proc
CREATE TABLE #Test_Temp_table (test INT)
GO

-- Test the Proc
EXEC DROP_TEMP_IF_EXISTS '#Test_Temp_table'
GO

-- Should error if the Proc succeeded
DROP TABLE #Test_Temp_table
GO
