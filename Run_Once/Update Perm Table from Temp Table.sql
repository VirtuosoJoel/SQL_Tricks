UPDATE t1

SET t1.change_column = t2.change_column

FROM Permanent_Table t1

INNER JOIN #Temp_Table t2
	ON t1.match_column = t2.match_column
		AND (
			t1.change_column <> t2.change_column
			OR t1.change_column IS NULL
			)

