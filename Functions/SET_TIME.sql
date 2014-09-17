IF OBJECT_ID('dbo.SET_TIME',N'FN') IS NOT NULL
  DROP FUNCTION dbo.SET_TIME
GO

CREATE FUNCTION SET_TIME
(
  @Date DATETIME
  ,@Time CHAR(20)
)
RETURNS DATETIME
BEGIN

  RETURN Dateadd( day, Datediff(day, 0, @Date ), @Time )

END
GO

select dbo.SET_TIME(getdate(), '00:00:00.010')
GO
