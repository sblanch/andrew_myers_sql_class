/*
Introduction to Variables
Table Variable
Temp Table
Inline Scripting - Subquery - Nested Query
*/

------------
-- What is the average score of each individual user 
-- that has a Remington or Long Rifle assigned to them 
-- who took at least one test in the Fog, two tests in Rain 
-- and three tests in Snow and their average score was 
-- greater than 70
------------

/* Attempt in class */
SELECT 
  CASE
    WHEN Fog.[Weather] = 'Foggy' AND Fog.[Weather Count] >= 1
    Then 1
    WHEN Fog.[Weather] = 'Raining'
  END
FROM(
  SELECT 
    U.UserID,
    AVG(Q.Score) AS 'Average Score',
    TW.Name As 'Weather',
    COUNT(TW.Name) AS 'Weather Count'
  FROM 
  [User] U
  INNER JOIN [UserToWeapon] UW on U.UserID = UW.UserId
  INNER JOIN [Weapon] W on W.WeaponID = UW.WeaponID
  INNER JOIN [UserToQual]UQ ON U.UserID = UQ.UserID
  INNER JOIN [Qual] Q ON Q.QualID = UQ.QualID
  INNER JOIN [TypeWeather] TW ON Q.TypeWeatherID = TW.TypeWeatherID
  Where W.Make in ('Remington', 'Long Rifle') AND
      TW.Name in ('Foggy', 'Raining', 'Snowing')
  Group By U.UserId, TW.Name
) AS Fog 
WHERE ((Fog.[Weather Count] >= 1 AND Fog.[Weather] = 'Foggy') OR
(Fog.[Weather Count] >= 2 AND Fog.[Weather] = 'Raining') OR
(Fog.[Weather Count] >= 3 AND Fog.[Weather] = 'Snowing')) 
--AND
--Fog.[Average Score] > 70   


-- Homework attempt


CREATE TABLE #AllJoined 
(
  [Quality Score] INT,
  [Weapon Name] VARCHAR(50),
  UserID INT,
  [User Full Name] VARCHAR(200),
  [Weather] VARCHAR(50)
)

CREATE TABLE #FulfillsFogCount
(
  UserID INT,
  [Weather] VARCHAR(50),
  [Weather Count] INT
)

CREATE TABLE #FulfillsRainCount
(
  UserID INT,
  [Weather] VARCHAR(50),
  [Weather Count] INT
)

CREATE TABLE #FulfillsSnowCount
(
  UserID INT,
  [Weather] VARCHAR(50),
  [Weather Count] INT
)

INSERT INTO #AllJoined
SELECT
  Q.Score AS [Quality Score],
  W.Make As [Weapon Make],
  U.UserID As [UserID],
  (U.FirstName + ' ' + U.MiddleName + ' ' + U.LastName) AS [User Full Name],
  TW.Name AS [Weather]
FROM 
[User] U
INNER JOIN [UserToWeapon] UW on U.UserID = UW.UserId
INNER JOIN [Weapon] W on W.WeaponID = UW.WeaponID
INNER JOIN [UserToQual]UQ ON U.UserID = UQ.UserID
INNER JOIN [Qual] Q ON Q.QualID = UQ.QualID
INNER JOIN [TypeWeather] TW ON Q.TypeWeatherID = TW.TypeWeatherID
Where W.Make in ('Remington', 'Long Rifle') AND
    TW.Name in ('Foggy', 'Raining', 'Snowing')

INSERT INTO #FulfillsFogCount
SELECT 
  UserID,
  Weather,
  COUNT(Weather) AS [Weather Count]
FROM #AllJoined
WHERE [Weather] = 'Foggy'
GROUP BY UserID, Weather
HAVING COUNT(Weather) >= 1

INSERT INTO #FulfillsRainCount
SELECT 
  UserID,
  Weather,
  COUNT(Weather) AS [Weather Count]
FROM #AllJoined
WHERE [Weather] = 'Raining'
GROUP BY UserID, Weather
HAVING COUNT(Weather) >= 2

INSERT INTO #FulfillsSnowCount
SELECT 
  UserID,
  Weather,
  COUNT(Weather) AS [Weather Count]
FROM #AllJoined
WHERE [Weather] = 'Snowing'
GROUP BY UserID, Weather
HAVING COUNT(Weather) >= 3

SELECT 
  AJ.UserID,
  AJ.[User Full Name],
  AVG(AJ.[Quality Score]) AS [Average Score]
FROM
#FulfillsFogCount [Fog] 
INNER JOIN #FulfillsRainCount [Rain] ON Fog.UserID = Rain.UserID
INNER JOIN #FulfillsSnowCount [Snow] ON Fog.UserID = Snow.UserID
INNER JOIN #AllJoined [AJ] ON Fog.UserID = AJ.UserID
GROUP BY AJ.UserID, AJ.[User Full Name], AJ.[Quality Score]

DROP TABLE #AllJoined
DROP TABLE #FulfillsFogCount
DROP TABLE #FulfillsRainCount
DROP TABLE #FulfillsSnowCount

------------
-- Return all user(s) with the third and fifth highest 
-- average qualification score
-----------

CREATE TABLE #AvgScores
(
  ID INT IDENTITY(1,1),
  [Average Score] INT
)

CREATE TABLE #NeededAvgScores
(
  [Average Score] INT
)

CREATE TABLE #UserAvgScores
(
  UserID INT,
  [Average Score] INT
)

INSERT INTO #AvgScores
SELECT 
  AVG(Q.Score) AS [Average Score]
FROM [Qual] Q
Group by Q.Score
ORDER BY Q.Score DESC


INSERT INTO #NeededAvgScores
SELECT
  AVGS.[Average Score] AS [Average Score]
FROM #AvgScores AVGS
WHERE
AVGS.ID = 3 or AVGS.ID = 5

INSERT INTO #UserAvgScores
SELECT 
  U.UserID,
  AVG(Q.Score) AS [Average Score]
FROM [User] U 
INNER JOIN [UserToQual] UQ ON UQ.UserID = U.UserID
INNER JOIN [Qual] Q ON Q.QualID = UQ.QualID
GROUP BY U.UserID, Q.Score


SELECT
  UAS.UserID,
  UAS.[Average Score]
FROM #NeededAvgScores NAS 
INNER JOIN #UserAvgScores UAS ON NAS.[Average Score] = UAS.[Average Score]
Order by NAS.[Average Score]

DROP TABLE #AvgScores
DROP TABLE #NeededAvgScores
DROP TABLE #UserAvgScores



------------
-- Return all active users in the User table that 
-- have a weapon and have not attempted to qualify
-- or who has attempted to qualify but has not 
-- passed any tests
------------

SELECT 
  *
FROM [User] U
INNER JOIN [UserToWeapon] UW uw.UserID = u.UserID
LEFT JOIN [UserToQual] UQ uq.UserID = u.UserID
LEFT JOIN [Qual] Q q.QualID = uq.QualID
WHERE U.ActivBit = 1 AND
  (Q.Pass IS NULL OR Q.PASS = 0)

------------
-- Show all users that have passed two qualification 
-- tests but are not assigned a weapon
------------

------------
-- Return all weapons that have been assigned to at 
-- least one active and one inactive user
------------

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