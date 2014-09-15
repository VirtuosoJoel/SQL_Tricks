/*

Table-valued function which gives a 4,4,5 52-week fiscal year with a 7 year cycle to 53 weeks.
I found the original code on an MSDN forum and then modified it.

First setup:
Set @Date to whatever date your fiscal year start would have been in 1900
Set @CycleYear to any "AD" year which was a 53 week fiscal year
This uses a 5,4,5 week first period every 7 years.
*/

-- Now we can run "create function" without worrying whether it already existed
IF OBJECT_ID('dbo.FISCAL_YEAR_FUNCTION', N'TF') IS NOT NULL
	DROP FUNCTION dbo.FISCAL_YEAR_FUNCTION
GO

-- @Year is the year of the start date
CREATE FUNCTION dbo.FISCAL_YEAR_FUNCTION (@Year AS INT)
RETURNS @fiscal_year_table TABLE (
	dtTemp DATETIME NOT NULL PRIMARY KEY CLUSTERED
	,FiscalDay INT NOT NULL 
	,FiscalWeek INT NOT NULL 
	,FiscalMonth INT NOT NULL 
	,FiscalQuarter INT NOT NULL 
	,CalenderDayOfYear INT NOT NULL 
	,CalenderWeekOfYear INT NOT NULL 
	,CalendarMonth INT NOT NULL 
	,CalenderQuarter INT NOT NULL 
	,CalenderYear INT NOT NULL 
	,FiscalYear INT NOT NULL
	)
AS
BEGIN

  -- What the financial year start date would have been in 1900
  -- Using this as a start date means we shouldn't need to go backwards
  -- Set this when creating the function
  DECLARE @Date DATETIME
  SET @Date = '19001025'

  -- Set this to a year which is 53 weeks, for the 7-year cycle
  DECLARE @CycleYear INT
  SET @CycleYear = 2014

  -- This is calculated from the given cycle year
  DECLARE @ModVal INT
  SET @ModVal = @CycleYear % 7

  -- Makes the first period 5,4,5 for a 53 week year every 7 years 
  DECLARE @Offset INT
  SET @Offset = CASE @Year % 7 WHEN @ModVal THEN 1 ELSE 0 END

  -- Take the 1900 date and advance it to the target year
  DECLARE @i INT
  SET @i = Year(@Date)
  WHILE @i < @Year
  BEGIN
    SET @Date = DateAdd(Day, (CASE @i % 7 WHEN @ModVal THEN 53 ELSE 52 END)*7, @Date)
    SET @i = @i + 1
  END

	DECLARE @dtFiscalYearStart DATETIME
		,@dtFiscalYearEnd DATETIME

	SET @dtFiscalYearStart = @date
	SET @dtFiscalYearEnd = dateadd(Day, ((52+@Offset)*7), @dtFiscalYearStart)

	DECLARE @Numbers TABLE (
		Num INT
		,dtTemp DATETIME
		)

	INSERT INTO @Numbers
	SELECT 0
		,@dtFiscalYEarStart

	SET @i = 0

	WHILE @i < 9
	BEGIN
		INSERT INTO @Numbers
		SELECT Num + power(2, @i)
			,Dateadd(d, power(2, @i), dtTemp)
		FROM @Numbers

		SET @i = @i + 1
	END

	DELETE
	FROM @Numbers
	WHERE dtTemp >= @dtFiscalYearEnd

	INSERT @fiscal_year_table
	SELECT dtTemp
		,Num + 1 AS FiscalDay
		,Dense_Rank() OVER (
			PARTITION BY Num % (7) ORDER BY dtTemp
			) AS FiscalWeek
		,CASE 
			WHEN Dense_Rank() OVER (
					PARTITION BY Num % (7) ORDER BY dtTemp
					) BETWEEN 1
					AND 4+@Offset
				THEN 1
			WHEN Dense_Rank() OVER (
					PARTITION BY Num % (7) ORDER BY dtTemp
					) BETWEEN 5+@Offset
					AND 8+@Offset
				THEN 2
			WHEN Dense_Rank() OVER (
					PARTITION BY Num % (7) ORDER BY dtTemp
					) BETWEEN 9+@Offset
					AND 13+@Offset
				THEN 3
			WHEN Dense_Rank() OVER (
					PARTITION BY Num % (7) ORDER BY dtTemp
					) BETWEEN 14+@Offset
					AND 17+@Offset
				THEN 4
			WHEN Dense_Rank() OVER (
					PARTITION BY Num % (7) ORDER BY dtTemp
					) BETWEEN 18+@Offset
					AND 21+@Offset
				THEN 5
			WHEN Dense_Rank() OVER (
					PARTITION BY Num % (7) ORDER BY dtTemp
					) BETWEEN 22+@Offset
					AND 26+@Offset
				THEN 6
			WHEN Dense_Rank() OVER (
					PARTITION BY Num % (7) ORDER BY dtTemp
					) BETWEEN 27+@Offset
					AND 30+@Offset
				THEN 7
			WHEN Dense_Rank() OVER (
					PARTITION BY Num % (7) ORDER BY dtTemp
					) BETWEEN 31+@Offset
					AND 34+@Offset
				THEN 8
			WHEN Dense_Rank() OVER (
					PARTITION BY Num % (7) ORDER BY dtTemp
					) BETWEEN 35+@Offset
					AND 39+@Offset
				THEN 9
			WHEN Dense_Rank() OVER (
					PARTITION BY Num % (7) ORDER BY dtTemp
					) BETWEEN 40+@Offset
					AND 43+@Offset
				THEN 10
			WHEN Dense_Rank() OVER (
					PARTITION BY Num % (7) ORDER BY dtTemp
					) BETWEEN 44+@Offset
					AND 47+@Offset
				THEN 11
			ELSE 12
			END AS [FiscalMonth]
		,CASE 
			WHEN datediff(d, @dtFiscalYEarStart, dtTEmp) < (91 * 1)
				THEN 1
			WHEN datediff(d, @dtFiscalYEarStart, dtTEmp) < (91 * 2)
				THEN 2
			WHEN datediff(d, @dtFiscalYEarStart, dtTEmp) < (91 * 3)
				THEN 3
			ELSE 4
			END AS FiscalQuarter
		,datepart(dy, dtTemp) AS CalendarDayOfYear
		,Datepart(wk, dtTemp) AS CalendarWeekOfYear
		,Datepart(m, dtTemp) AS CalendarMonth
		,Datepart(q, dtTemp) AS CalendarQuarter
		,Datepart(Year, dtTemp) AS CalendarYear
		,@Year AS FiscalYear
	FROM @Numbers
	ORDER BY Dateadd(d, Num, @dtFiscalYearStart)

	RETURN
END
GO

-- Test the function with 2 years
select * from dbo.FISCAL_YEAR_FUNCTION(2013)

SELECT * from dbo.FISCAL_YEAR_FUNCTION(2014)
