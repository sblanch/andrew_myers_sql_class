/*
Introduction to Variables
Table Variable
Temp Table
Inline Scripting - Subquery - Nested Query
*/

------------
-- What is the average score of each individual user 
-- that has a Remington and Long Rifle assigned to them 
-- who taken one test in the Fog or two tests in Rain 
-- or three tests in Snow and their average score was 
-- greater than 70
------------
--************* TABLE VARIABLE APPROACH ***************
--GET ALL THE USERS THAT HAVE EITHER A REMINGTON OR LONG RIFLE
--THAT HAVE TAKEN ONE TEST IN FOG, RAIN OR SNOW
DECLARE @UWeapons TABLE 
( UserID INT, Name VARCHAR(256), WeatherCount INT )

INSERT INTO @UWeapons
SELECT 
	U.UserID,
	T.Name,
	COUNT(T.Name) AS WeatherCount
FROM [User] U
INNER JOIN [UserToQual] UQ ON U.UserID = UQ.UserID
INNER JOIN [Qual] Q ON UQ.QualID = Q.QualID
INNER JOIN [TypeWeather] T ON Q.TypeWeatherID = T.TypeWeatherID
INNER JOIN [UserToWeapon] UW ON	UW.UserID = U.UserID
INNER JOIN [Weapon] W ON W.WeaponID = UW.WeaponID
WHERE 
	W.Make IN ('Remington', 'Long Rifle') AND 
	T.Name IN ('Foggy', 'Raining', 'Snowing')
GROUP BY 
	U.UserID, T.Name

--GET ALL THE USERS THAT HAVE TAKEN 
--ONE TEST IN THE FOG OR 
--TWO TESTS IN RAIN OR 
--THREE IN SNOW
DECLARE @UTests TABLE 
( UserID INT, Name VARCHAR(256), WeatherCount INT )

INSERT INTO @UTests
SELECT * 
FROM
	@UWeapons AS U
WHERE 
	(
		CASE 
			WHEN U.Name = 'Foggy' AND U.WeatherCount >= 1 THEN 1 
			WHEN U.Name = 'Raining' AND U.WeatherCount >= 2 THEN 1 
			WHEN U.Name = 'Snowing' AND U.WeatherCount >= 3 THEN 1 
		ELSE 0
		END
	) = 1
	
--GET ALL USERS WITH AN AVERAGE SCORE OF 70
SELECT 
	UU.UserID,
	AVG(Q.Score) AS AvgScore
FROM @UTests AS UU
INNER JOIN [UserToQual] UQ ON UU.UserID = UQ.UserID
INNER JOIN [Qual] Q ON UQ.QualID = Q.QualID
GROUP BY UU.UserId
HAVING AVG(Q.Score) > 70
ORDER BY UU.UserId

--************* TEMP TABLE APPROACH USING SELECT INTO ***************
--GET ALL THE USERS THAT HAVE EITHER A REMINGTON OR LONG RIFLE
--THAT HAVE TAKEN ONE TEST IN FOG, RAIN OR SNOW
SELECT 
	U.UserID,
	T.Name,
	COUNT(T.Name) AS WeatherCount
INTO #UWeapons
FROM [User] U
INNER JOIN [UserToQual] UQ ON U.UserID = UQ.UserID
INNER JOIN [Qual] Q ON UQ.QualID = Q.QualID
INNER JOIN [TypeWeather] T ON Q.TypeWeatherID = T.TypeWeatherID
INNER JOIN [UserToWeapon] UW ON	UW.UserID = U.UserID
INNER JOIN [Weapon] W ON W.WeaponID = UW.WeaponID
WHERE 
	W.Make IN ('Remington', 'Long Rifle') AND 
	T.Name IN ('Foggy', 'Raining', 'Snowing')
GROUP BY 
	U.UserID, T.Name

--GET ALL THE USERS THAT HAVE TAKEN 
--ONE TEST IN THE FOG OR 
--TWO TESTS IN RAIN OR 
--THREE IN SNOW
SELECT * 
INTO #UTests
FROM
	#UWeapons AS U
WHERE 
	(
		CASE 
			WHEN U.Name = 'Foggy' AND U.WeatherCount >= 1 THEN 1 
			WHEN U.Name = 'Raining' AND U.WeatherCount >= 2 THEN 1 
			WHEN U.Name = 'Snowing' AND U.WeatherCount >= 3 THEN 1 
		ELSE 0
		END
	) = 1
	
--GET ALL USERS WITH AN AVERAGE SCORE OF 70
SELECT 
	UU.UserID,
	AVG(Q.Score) AS AvgScore
FROM #UTests AS UU
INNER JOIN [UserToQual] UQ ON UU.UserID = UQ.UserID
INNER JOIN [Qual] Q ON UQ.QualID = Q.QualID
GROUP BY UU.UserId
HAVING AVG(Q.Score) > 70
ORDER BY UU.UserId

DROP TABLE #UWeapons
DROP TABLE #UTests

--************* INLINE SCRIPTING APPROACH ***************
--GET ALL USERS WITH AN AVERAGE SCORE OF 70
SELECT 
	UU.UserID,
	AVG(Q.Score) AS AvgScore
FROM
(
	--GET ALL THE USERS THAT HAVE TAKEN 
	--ONE TEST IN THE FOG OR 
	--TWO TESTS IN RAIN OR 
	--THREE IN SNOW
	SELECT * FROM
	(
		--GET ALL THE USERS THAT HAVE EITHER A REMINGTON OR LONG RIFLE
		--THAT HAVE TAKEN ONE TEST IN FOG, RAIN OR SNOW
		SELECT 
			U.UserID,
			T.Name,
			COUNT(T.Name) AS WeatherCount
		FROM [User] U
		INNER JOIN [UserToQual] UQ ON U.UserID = UQ.UserID
		INNER JOIN [Qual] Q ON UQ.QualID = Q.QualID
		INNER JOIN [TypeWeather] T ON Q.TypeWeatherID = T.TypeWeatherID
		INNER JOIN [UserToWeapon] UW ON	UW.UserID = U.UserID
		INNER JOIN [Weapon] W ON W.WeaponID = UW.WeaponID
		WHERE 
			W.Make IN ('Remington', 'Long Rifle') AND 
			T.Name IN ('Foggy', 'Raining', 'Snowing')
		GROUP BY 
			U.UserID, T.Name
	) AS U
	WHERE 
		(
			CASE 
				WHEN U.Name = 'Foggy' AND U.WeatherCount >= 1 THEN 1 
				WHEN U.Name = 'Raining' AND U.WeatherCount >= 2 THEN 1 
				WHEN U.Name = 'Snowing' AND U.WeatherCount >= 3 THEN 1 
			ELSE 0
			END
		) = 1
) AS UU
INNER JOIN [UserToQual] UQ ON UU.UserID = UQ.UserID
INNER JOIN [Qual] Q ON UQ.QualID = Q.QualID
GROUP BY UU.UserId
HAVING AVG(Q.Score) > 70
ORDER BY UU.UserId

------------
-- Return all user(s) with the third and fifth highest 
-- average qualification score
-----------

--***************
-- GET ALL AVERAGE SCORES AND RANK THEM
--***************
DECLARE @AvgScore TABLE
(
ID INT IDENTITY(1,1),
AvgScore INT
)

INSERT INTO @AvgScore
SELECT DISTINCT
	AVG(Q.Score) AS AverageScore
FROM [User] U
INNER JOIN [UserToQual] UQ ON U.UserID = UQ.UserID
INNER JOIN [Qual] Q ON Q.QualID = UQ.QualID
GROUP BY U.UserID
ORDER BY AverageScore DESC

--***************
-- GET ALL USERS WITH AN AVERAGE SCORES OF RANK 3 AND 5
--***************
SELECT
	A.UserID,
	A.AverageScore
FROM
(
	--***************
	-- GET ALL USERS AVERAGE SCORES
	-- Note: the following you could put in a temp table and join on it
	--***************
	SELECT DISTINCT
	U.UserID,
	AVG(Q.Score) AS AverageScore
	FROM [User] U
	INNER JOIN [UserToQual] UQ ON U.UserID = UQ.UserID
	INNER JOIN [Qual] Q ON Q.QualID = UQ.QualID
	GROUP BY U.UserID
) AS A
INNER JOIN @AvgScore SA ON A.AverageScore = SA.AvgScore
WHERE SA.ID = 3 OR SA.ID = 5
ORDER BY A.AverageScore DESC

------------
-- Return all active users in the User table that 
-- have a weapon and have not attempted to qualify
-- or who has attempted to qualify but has not 
-- passed any tests
------------

--********
--GET USERS THAT HAVE NOT ATTEMPTED TO QUALIFY
--********
SELECT 
	U.UserID 
FROM @Users U
LEFT JOIN UserToQual UQ ON U.UserID = UQ.UserID
WHERE UQ.QualID IS NULL

UNION

--********
--GET USERS THAT HAS NOT PASSED ANY TESTS
--********
SELECT 
	U.UserID
	--SUM(CAST(Q.Pass AS INT)) AS PassedTest
FROM @Users U
INNER JOIN UserToQual UQ ON U.UserID = UQ.UserID
INNER JOIN Qual Q ON UQ.QualID = Q.QualID
GROUP BY U.UserID
HAVING SUM(CAST(Q.Pass AS INT)) > 0

------------
-- Show all users that have passed at least two qualification 
-- tests but are not assigned a weapon
------------

--**********
--GET ALL USERS THAT ARE NOT ASSIGNED A WEAPON
--**********
SELECT
	UT.UserID,
	UT.PassCount
FROM
(
	--**********
	--GET ALL USERS THAT HAVE PASSED AT LEAST TWO QUALIFIATION TESTS
	--**********
	SELECT
		U.UserID,
		COUNT(Q.Pass) AS PassCount
	FROM [User] U
	INNER JOIN UserToQual UQ ON U.UserID = UQ.UserID
	INNER JOIN Qual Q ON Q.QualID = UQ.QualID
	GROUP BY U.UserID
	HAVING COUNT(Q.Pass) >= 2
) AS UT
LEFT JOIN UserToWeapon UW ON UT.UserID = UW.UserID
WHERE UW.UserID IS NULL

---- SAME THING BUT FLIPPED FLOPPED ON WHAT WE GATHERED FIRST

--**********
--GET ALL USERS THAT HAVE PASSED AT LEAST TWO QUALIFIATION TESTS
--**********
SELECT
	U.UserID,
	COUNT(Q.Pass) AS PassCount
FROM 
(
	--**********
	--GET ALL USERS THAT ARE NOT ASSIGNED A WEAPON
	--**********
	SELECT
		UT.UserID
	FROM [User] AS UT
	LEFT JOIN UserToWeapon UW ON UT.UserID = UW.UserID
	WHERE UW.UserID IS NULL
) AS U
INNER JOIN UserToQual UQ ON U.UserID = UQ.UserID
INNER JOIN Qual Q ON Q.QualID = UQ.QualID
GROUP BY U.UserID
HAVING COUNT(Q.Pass) >= 2


------------
-- Return all weapons that have been assigned to at 
-- least one active and one inactive user
------------

--**********
--GET ALL WEAPONS ASSIGNED TO MORE THAN ONE USER
--**********
DECLARE @MoreThanOne TABLE ( WeaponID INT )
INSERT INTO @MoreThanOne
SELECT 
	UW.WeaponID
	--,Count(U.UserID) AS UserCount
FROM [User] U
INNER JOIN UserToWeapon UW ON U.UserID = UW.UserID
GROUP BY UW.WeaponID
HAVING Count(U.UserID) > 1

--**********
--Get all Weapon IDs also with an active user
--**********
SELECT DISTINCT
	UTW.WeaponID
FROM 
[User] UU
INNER JOIN UserToWeapon UTW ON UU.UserID = UTW.UserID
INNER JOIN 
(
	--**********
	--Get all weapon IDs with an inactive user
	--UPDATE [USER] SET ACTIVEBIT = 0 WHERE USERID = 998
	--**********
	SELECT
		UTW.WeaponID
	FROM [User] U
	INNER JOIN UserToWeapon UTW ON U.UserID = UTW.UserID
	INNER JOIN @MoreThanOne AS W ON W.WeaponID = UTW.WeaponID
	WHERE U.ActiveBit = 0
) WW ON UTW.WeaponID = WW.WeaponID
WHERE UU.Activebit = 1

------------
-- Return all Users that have a Qualification information
-- Group their scores into the following category
-- Scores greater than 70 rank as HIGH
-- Scores between 50 and 70 rank as MED
-- Scores lower than 50 as LOW
-- Within each group sort the Users by their first name, 
-- middle name and last name ascending respectfully
-- Also show only rows 100 through 200
------------

--******************* USING TEMP TABLE **********************
DECLARE @UserScores TABLE
(
	ID INT IDENTITY(1,1),
	ScoreRank VARCHAR(4)
)

INSERT INTO @UserScores
SELECT
	CASE 
		WHEN Q.Score >= 70 THEN 'HIGH'
		WHEN Q.Score >= 50 AND Q.Score <= 70  THEN 'MED'
		WHEN Q.Score < 50 THEN 'LOW'
	END AS Score
FROM [User] U
INNER JOIN UserToQual UQ ON U.UserID = UQ.UserID
INNER JOIN Qual Q ON Q.QualID = UQ.QualID
ORDER BY U.FirstName ASC, U.MiddleName ASC, U.LastName ASC

SELECT * FROM @UserScores U
WHERE U.ID >= 100 AND U.ID <= 200

--******************* USING ROW_NUMBER WITH INLINE **********************

SELECT
*
FROM
(
	SELECT
		ROW_NUMBER() OVER (
		Order by 
			U.FirstName ASC, 
			U.MiddleName ASC, 
			U.LastName ASC) AS RowNumber,
		CASE 
			WHEN Q.Score >= 70 THEN 'HIGH'
			WHEN Q.Score >= 50 AND Q.Score <= 70  THEN 'MED'
			WHEN Q.Score < 50 THEN 'LOW'
		END AS Score
	FROM [User] U
	INNER JOIN UserToQual UQ ON U.UserID = UQ.UserID
	INNER JOIN Qual Q ON Q.QualID = UQ.QualID
) R
WHERE R.RowNumber >= 100 AND R.RowNumber <= 200