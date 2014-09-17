IF OBJECT_ID('dbo.SOYEAR',N'FN') IS NOT NULL
  DROP FUNCTION dbo.SOYEAR
GO

CREATE FUNCTION SOYEAR
(
  @Date as DATETIME
)
RETURNS DATETIME
BEGIN

  RETURN dateadd(month, datediff(month, 0, ISNULL(@Date,getdate())),0)

END
GO

select dbo.SOYEAR(NULL) as 'NULL_ARG'
GO

select dbo.SOYEAR(getdate()) as 'GETDATE_ARG'
GO
