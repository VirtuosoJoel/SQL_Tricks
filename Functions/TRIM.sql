IF OBJECT_ID('dbo.TRIM', N'FN') IS NOT NULL
	DROP FUNCTION dbo.TRIM

GO

CREATE FUNCTION TRIM (@Text NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)

BEGIN
	RETURN LTRIM(RTRIM(@Text))

END

GO

SELECT dbo.TRIM(' KEVIN SPACEY  ')

GO
