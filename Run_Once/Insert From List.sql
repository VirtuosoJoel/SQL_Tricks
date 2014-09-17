INSERT INTO TargetTable (field1, field2)
SELECT 'Value1','Value2' UNION ALL
SELECT 'Value3','Value4'

/*

I usually copy and paste the columns with headers from Excel into Notepad++
Then I run a Notead++ find & replace macro which does this:

(Search Mode "Regular expression")
Find: \t
Replace: ','

Find: [\r\n]+\z
Replace: 

Find: ^|$
Replace: '

Find: \r\n
Replace: \r\nSELECT 

Find: (SELECT .+)$\r\n
Replace: \1 UNION ALL\r\n

(Tick ". matches newline")
Find: ^(.+?)(\r\n.+)
Replace: INSERT INTO Table_Name \(\1\)\2

In document, Select the first line (Ctrl+Home, Shift+End)

(Search Mode: Normal)
(Tick "In Selection")
Find: ('
Replace: ([

Find: ,'
Replace: ,[

Find: ',
Replace: ],

Find: ')
Replace: ]) 

Then I just enter the table name and put it into a SQL Query

From this input (paste from Excel):

Field1	Field2	Field3
Value1	Value2	Value3
Value4	Value5	Value6
Value7	Value8	Value9

I just run the macro, and get this output:

INSERT INTO Table_Name ('Field1','Field2','Field3')
SELECT 'Value1','Value2','Value3' UNION ALL
SELECT 'Value4','Value5','Value6' UNION ALL
SELECT 'Value7','Value8','Value9'

*/
