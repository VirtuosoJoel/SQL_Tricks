SELECT col.table_catalog AS [Database]
  ,col.table_schema AS [Schema]
  ,col.table_name AS [Table]
	,col.ordinal_position AS [Col #]
	,col.column_name AS [Col Name]
	,data_type AS DataType
	,ISNULL(character_maximum_length,numeric_precision) AS [Length]
	,is_nullable AS [Nulls?]
	,col.column_name + ' (' + CASE 
		WHEN keys.column_name IS NOT NULL
			THEN 'PK, '
		ELSE ''
		END + data_type + CASE 
		WHEN data_type IN (
				'numeric'
				,'decimal'
				)
			THEN '(' + cast(numeric_precision AS VARCHAR(12)) + ',' + cast(numeric_scale AS VARCHAR(12)) + ')'
		WHEN isnull(character_maximum_length, '') = ''
			THEN ''
		ELSE '(' + CASE 
				WHEN character_maximum_length = - 1
					THEN 'MAX'
				ELSE cast(character_maximum_length AS VARCHAR(12))
				END + ')'
		END + CASE is_nullable
		WHEN 'YES'
			THEN ', null)'
		ELSE ', not null)'
		END AS [Column Detail]
    --,*

FROM information_schema.columns col

INNER JOIN information_schema.tables tab
	ON (
			col.table_catalog = tab.table_catalog
			AND col.table_schema = tab.table_schema
			AND col.table_name = tab.table_name
			)

LEFT JOIN information_schema.table_constraints cons
	ON (
			col.table_catalog = cons.table_catalog
			AND col.table_schema = cons.table_schema
			AND col.table_name = cons.table_name
			AND constraint_type = 'PRIMARY KEY'
			)

LEFT JOIN information_schema.constraint_column_usage keys
	ON (
			cons.table_catalog = keys.table_catalog
			AND cons.table_schema = keys.table_schema
			AND cons.table_name = keys.table_name
			AND cons.constraint_name = keys.constraint_name
			AND col.column_name = keys.column_name
			)

WHERE table_type = 'BASE TABLE'

ORDER BY 1,2,3,4
