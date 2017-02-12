------------
--Creating a Dynamic Query to execute
------------
DECLARE @QUERY NVARCHAR(2000)

SET @QUERY = 
'UPDATE [WeaponsQualifications].[dbo].[User]
   SET [ActiveBit] = 0
 WHERE UserID IN ('

SELECT 
	@QUERY = @QUERY + CAST(u.UserID AS VARCHAR(5)) + ','
FROM [User] u
WHERE ActiveBit = 1

--Remove the last comma and add ')'
SET @QUERY = SUBSTRING(@QUERY,0,LEN(@QUERY) - 1) + ')'
--SELECT @QUERY

EXECUTE sp_executesql @QUERY --OR EXEC sp_executesql @QUERY