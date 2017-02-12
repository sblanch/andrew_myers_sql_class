-------------------------
--Create a comma seperated list with all UserIDs with no starting coma using a COALESCE
-------------------------
USE WeaponsQualifications

DECLARE
	@List VARCHAR(1000)

SET @List = null

SELECT 
	@List = COALESCE(@List + ',', '') + CAST(u.UserID AS VARCHAR(20))
FROM [User] u

-------------------------
--Create a comma seperated list with all UserIDs with no starting coma using an ISNULL
-------------------------
USE WeaponsQualifications

DECLARE
	@List2 VARCHAR(1000)

SET @List2 = null

SELECT 
	@List2 = ISNULL(@List2 + ',', '') + CAST(u.UserID AS VARCHAR)
FROM [User] u

-------------------------
--Create a comma seperated list with all UserIDs with no starting coma without using a COALESCE or ISNULL
-------------------------
USE WeaponsQualifications

DECLARE
	@List3 VARCHAR(1000)

SET @List3 = ''

SELECT 
	@List3 = @List3 + CAST(u.UserID AS VARCHAR(20)) + ','
FROM [User] u

--------------------------
--Create a CSV file where each user name in a comma separated list with a format of (FistName LastName,)
--Also have 10 items for each row
-- Note: CHAR(13) + CHAR(10) is carriage return line feed
--------------------------
DECLARE @List VARCHAR(MAX)

SET @List = ''
SELECT
	@List = @List + FirstName + ' ' + LastName + ',' + CHAR(13) + CHAR(10)
FROM [User]

SELECT @List