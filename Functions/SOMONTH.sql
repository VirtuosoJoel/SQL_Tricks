IF OBJECT_ID('dbo.SOMONTH',N'FN') IS NOT NULL
  DROP FUNCTION dbo.SOMONTH
GO

CREATE FUNCTION SOMONTH
(
  @Date as DATETIME
)
RETURNS DATETIME
BEGIN

  RETURN dateadd(year, datediff(year, 0, ISNULL(@Date,getdate())),0)

END
GO

select dbo.SOMONTH(NULL) as 'NULL_ARG'
GO

select dbo.SOMONTH(getdate()) as 'GETDATE_ARG'
GO
