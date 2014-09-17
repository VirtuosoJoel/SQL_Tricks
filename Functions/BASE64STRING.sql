IF OBJECT_ID('dbo.BASE64STRING', N'FN') IS NOT NULL
	DROP FUNCTION dbo.BASE64STRING

GO

CREATE FUNCTION BASE64STRING (@image IMAGE)
RETURNS VARCHAR(MAX)

BEGIN
	DECLARE @conversion VARBINARY(MAX)

	SET @conversion = CAST(@image AS VARBINARY(MAX))

	RETURN CAST(N'' AS XML).value('xs:base64Binary(xs:hexBinary(sql:variable("@conversion")))', 'VARCHAR(MAX)')

END

/*

This is designed to take a gif which was saved as an image in the database and turn it into a "src" arribute in html
"The_Base_64_String" section of the below javascript can be overwritten with the base64 string, thus displaying an image.


javascript:window.open('data:text/html;charset=utf-8,' +encodeURIComponent('<html><body><div><img src="data:image/gif;base64,The_Base_64_String" /></div></body></html>'));

*/
