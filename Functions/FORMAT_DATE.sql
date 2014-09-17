IF OBJECT_ID('dbo.FORMAT_DATE', N'FN') IS NOT NULL
	DROP FUNCTION dbo.FORMAT_DATE
GO
CREATE FUNCTION FORMAT_DATE (
	@DateTime AS DATETIME
	,@Format AS VARCHAR(100)
	)
RETURNS VARCHAR(100)

BEGIN

  RETURN Replace(
    Replace(
      Replace(
        Replace(
          Replace(
            Replace(
              Replace(
                Replace(
                  Replace(
                    Replace(
                      Replace(
                        @Format, 'dddd', DateName( weekday, @DateTime )
                      ), 'ddd', Left( DateName( weekday, @DateTime), 3)
                    ), 'dd', RIGHT( '0' + CONVERT( NVARCHAR( 2), DATEPART( DAY, @DateTime)), 2)
                  ), 'mmmm', DateName( month, @DateTime)
                ), 'mmm', Left( DateName( month, @DateTime), 3)
              ), 'mm', RIGHT( '0' + CONVERT( NVARCHAR( 2), DATEPART( MONTH, @DateTime)), 2)
            ),'yyyy',CONVERT(NVARCHAR(4),DatePart(year,@DateTime))
          ), 'yy', Right( CONVERT( NVARCHAR( 4), DatePart( year, @DateTime)), 2)
        ), 'hh', RIGHT( '0' + CONVERT( NVARCHAR( 2), DATEPART(hour, @DateTime)), 2)
      ), 'mi', RIGHT('0' + CONVERT(NVARCHAR(2), DATEPART(minute, @DateTime)), 2)
    ), 'ss', RIGHT('0' + CONVERT( NVARCHAR(2), DATEPART(second, @DateTime)), 2)
  )

END
GO

SELECT dbo.FORMAT_DATE(getdate(), 'dddd (ddd) mmmm (mmm) dd/mm/yyyy (yy) hh:mi:ss') AS FORMAT_DATE
GO
