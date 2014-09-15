SELECT
   SUM(st.row_count) AS Total_Rows
FROM
   sys.dm_db_partition_stats st
WHERE
    object_name(object_id) = 'MyTable' AND (index_id < 2)
