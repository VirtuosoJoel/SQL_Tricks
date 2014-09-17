IF OBJECT_ID('dbo.EODAY',N'FN') IS NOT NULL
  DROP FUNCTION dbo.EODAY
GO

CREATE FUNCTION EODAY
(
  @date as DATETIME
)
RETURNS DATETIME
BEGIN

  RETURN DATEADD(millisecond,-2,DATEADD(day,DATEDIFF(day,0,isnull(@date,getdate()))+1,0))

END
GO

select dbo.EODAY(NULL) as 'NULL_ARG'
GO

select dbo.EODAY(getdate()) as 'GETDATE_ARG'
GO
