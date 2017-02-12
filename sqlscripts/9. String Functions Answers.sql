/*
COVER

DECLARE @VAR
SET
CONCATINATION

CONVERT(TYPE, VALUE)
CAST(VALUE AS TYPE)

SUBSTRING(VALUE,INDEX,COUNT)
LEN(VALUE)
REPLACE (VALUE, 'LOOK_FOR' , 'REPLACE_WITH')
CHARINDEX('LOOK_FOR', VALUE, (OPTIONAL) START_INDEX_LOCATION )  
*/

--------------------------
--Create a variable and populate the variable with the name of the first user using the following format
-- Format: { LastName, FirstName MiddleName }
--Then display the result of the variable with a column name as User Name
--------------------------

DECLARE 
	@Name VARCHAR(255)

SET @Name = (SELECT TOP 1 LastName + ', ' + FirstName + ' ' MiddleName FROM [User])

SELECT @Name AS [User Name]

--------------------------
--Return the LastName, FirstName and UserName
--Where UserName is in the following format
-- Format: { FirstInitial_LastName }
--------------------------

SELECT
	FirstName,
	LastName,
	UserName = SUBSTRING(FirstName, 1, 1) + '_' + LastName
FROM [USER]

--------------------------
--Return the LastName, FirstName and UserName
--Where UserName in the following format
-- Format: { FirstInitial_LastName_UserID }
--------------------------
SELECT
	FirstName,
	LastName,
	UserName = SUBSTRING(FirstName, 1, 1) + '_' + LastName + '_' + CAST(UserID AS VARCHAR(30))
FROM [USER]

--OR

SELECT
	FirstName,
	LastName,
	UserName = SUBSTRING(FirstName, 1, 1) + '_' + LastName + '_' + CONVERT(VARCHAR(100), UserID)
FROM [USER]

--------------------------
-- Extract the number within the following string 'UID_1000:DPT_AA'
-- Then divide the number by 50 and display the result
-- Name the result RESULT
--------------------------
DECLARE 
	@UserIDStr VARCHAR(255)

SET @UserIDStr = 'UID_1000:DPT_AA'

SELECT CAST(SUBSTRING(@UserIDStr, 5, 4) AS INT) / 50 AS RESULT

--OR

DECLARE 
	@UserIDStr VARCHAR(255)

SET @UserIDStr = 'UID_1000:DPT_AA'

SELECT CONVERT(INT, SUBSTRING(@UserIDStr, 5, 4)) / 50 AS RESULT

--------------------------
--Put each user name in a comma separated list with a format of FistName LastName,.....
--------------------------

DECLARE
	@NAMES VARCHAR(MAX)

SET @NAMES = ''

SELECT TOP 10
	@NAMES = @NAMES + (FirstName + ' ' + LastName + ', ')
FROM [USER]

SELECT @NAMES

--------------------------
--Put the last 10 UserIDs in a comma separated list and then 
--display that List with no trailing comma
--------------------------
DECLARE
	@List VARCHAR(100)

SET @List = ''

SELECT TOP 10
	@List = @List + CAST(UserID AS VARCHAR(20)) + ','
FROM [User] 
ORDER BY UserID DESC

SELECT SUBSTRING(@List, 1, LEN(@List) - 1) AS CommaList

--------------------------
--Put first 10 UserIDs in a comma separated list where the User has the third highest score 
--Also display the List with no trailing comma
--------------------------
DECLARE @ALLUSERSCORES TABLE
(
	USERID INT, 
	SCORE INT
)

INSERT INTO @ALLUSERSCORES
SELECT DISTINCT
	U.USERID,
	Q.SCORE
FROM [USER] U
INNER JOIN USERTOQUAL UQ ON U.USERID = UQ.USERID
INNER JOIN QUAL Q ON UQ.QUALID = Q.QUALID
ORDER BY Q.SCORE DESC

--
DECLARE @USERSCORES TABLE
(
	SCORE INT
)

INSERT INTO @USERSCORES
SELECT DISTINCT TOP 3
	Q.SCORE
FROM [USER] U
INNER JOIN USERTOQUAL UQ ON U.USERID = UQ.USERID
INNER JOIN QUAL Q ON UQ.QUALID = Q.QUALID
ORDER BY Q.SCORE DESC	

DECLARE @Score INT, @List VARCHAR(1000)
SET @List = ''

SET @Score = 
(SELECT TOP 1 * FROM @USERSCORES Q
ORDER BY Q.SCORE ASC)

SELECT TOP 10
	@List = @List + CAST(UserID AS VARCHAR(20)) + ','
FROM @ALLUSERSCORES
WHERE SCORE = @Score 
ORDER BY UserID DESC

SELECT SUBSTRING(@List, 1, LEN(@List) - 1) AS CommaList

--------------------------
-- Create a query that can extract three comma separated numbers and add the time numbers together and name the result ResultSum
-- For example '77,899,444' or '1,2,7890898'
--------------------------
DECLARE 
	@NumList VARCHAR(100),
	@Index INT,
	@Sum INT

SET @NumList = '77,899,444'

SET @Index = CHARINDEX(',', @NumList)
SET @Sum = SUBSTRING(@NumList, 1, @Index - 1)
SET @NumList = SUBSTRING(@NumList, @Index + 1, LEN(@NumList))

--SELECT @Sum
--SELECT @NumList

SET @Index = CHARINDEX(',', @NumList)
SET @Sum = @Sum + SUBSTRING(@NumList, 1, @Index - 1)
SET @NumList = SUBSTRING(@NumList, @Index + 1, LEN(@NumList))

--SELECT @Sum
--SELECT @NumList

SET @Sum = @Sum + @NumList

SELECT @Sum
--SELECT @NumList

--------------------------------
--Insert a ( and ) around all numbers in the following string
--'This is the 3rd time 55 people spoke 7 words to me in the last 10 days'
--In the end it should look like
--'This is the (3)rd time (55) people spoke (7) words to me in the last (10) days'
--------------------------------

DECLARE 
	@Str VARCHAR(100),
	@Index3 INT,
	@Index55 INT,
	@Index7 INT,
	@Index10 INT
	
SET @Str = 'This is the 3rd time 55 people spoke 7 words to me in the last 10 days'

SET @Index3 = CHARINDEX('3', @Str)
SET @Index55 = CHARINDEX('55', @Str)
SET @Index7 = CHARINDEX('7', @Str)
SET @Index10 = CHARINDEX('10', @Str)

SET @Str = REPLACE (@Str, '3' , '(3)')
SET @Str = REPLACE (@Str, '55' , '(55)')
SET @Str = REPLACE (@Str, '7' , '(7)')
SET @Str = REPLACE (@Str, '10' , '(10)')

SELECT @Str

--------------------------------
--Get all users that 
--	are not sharing a weapon 
--  that are assigned at least two weapons
--  that have qualified at least twice on a raining or snowing day. Note: to have qualified their score must be higher than the fifth highest average score
--  and that their over all average score is greater than 70
--  and display only their first, middle and last initial into one column
---------------------------------
--QUALIFIED SCORE - GET THE FIFTH HIGHEST SCORE
DECLARE	@FifthHighestScore INT

SELECT TOP 1
	@FifthHighestScore = S.Score
FROM
(
	SELECT DISTINCT TOP 5
		Score
	FROM Qual
	ORDER BY Qual.Score DESC
) AS S
ORDER BY S.Score ASC

--ALL WEAPONS NOT BEING SHARED
DECLARE @WeaponsNotShared TABLE 
( 
	WeaponID INT, 
	WeaponCnt INT 
)

INSERT INTO @WeaponsNotShared
SELECT 	
	uw.WeaponID,
	COUNT(uw.WeaponID) AS WCount
FROM UserToWeapon uw
GROUP BY uw.WeaponID
HAVING COUNT(uw.WeaponID) = 1

--USERS THAT HAVE MORE THAN ONE WEAPON ASSIGNED TO THEM
--AND THEIR WEAPONS ARE NOT SHARED
DECLARE @UserWeaponCnt TABLE 
( 
	UserId INT, 
	WeaponCnt INT 
)

INSERT INTO @UserWeaponCnt
SELECT 	
	uw.UserId,
	COUNT(uw.UserId)
FROM UserToWeapon uw
INNER JOIN @WeaponsNotShared ws ON ws.WeaponID = uw.WeaponID
GROUP BY uw.UserId
HAVING COUNT(uw.UserId) > 1

--That have qualified at least twice with two different weapons on a raining or cloudy day
DECLARE @UserQualified TABLE ( UserID INT, AvgScore INT )

INSERT INTO @UserQualified
SELECT DISTINCT
	UW.UserID,
	AVG(Q.Score) AS AvgScore
FROM @UserWeaponCnt UW
INNER JOIN UserToQual UQ ON UW.UserID = UQ.UserID
INNER JOIN QUAL Q ON Q.QualID = UQ.QualID
INNER JOIN TypeWeather TW ON TW.TypeWeatherID = Q.TypeWeatherID
WHERE 
	(Q.TypeWeatherID = 5 /*CLOUDY*/ OR Q.TypeWeatherID = 4 /*RAINING*/) AND
	Q.Score >= @FifthHighestScore
GROUP BY UW.UserID

SELECT 
	SUBSTRING(FirstName,1,1) +
	SUBSTRING(MiddleName,1,1) +
	SUBSTRING(LastName,1,1)
FROM @UserQualified UQ
INNER JOIN [User] U ON U.UserID = UQ.UserId
WHERE AvgScore > 70