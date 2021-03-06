/*
Aggregated Functions - 
AVG
COUNT
FIRST
LAST
MAX
MIN
SUM
GROUP BY
HAVING
CAST
Concatination
*/

------------
--What is the total number of active police officers and output the column as "Total # of Employeed Officers"
------------
SELECT
	[Total # of Employeed Officers] = Count(u.UserID)
FROM [User] u
Where u.ActiveBit = 1
------------
--What is the total number of active police officers that has a weapon assigned to them
------------
SELECT
	[Total number of active police officers that has a weapon assigned to them] =
	Count(u.UserID)
From [User] u
INNER JOIN [UserToWeapon] uw ON uw.UserID = u.UserID


------------
--What is the average score of all users
------------
SELECT
	[Average Score of All Users] = AVG(q.Score)
FROM [User] u
INNER JOIN [UserToQual] uq ON u.UserID = uq.UserID
INNER JOIN [Qual] q on uq.QualID = q.QualID

------------
--What is the average score of each individual user
------------
SELECT
	u.UserID,
	[Average Score of All Users] = AVG(q.Score)
FROM [User] u
INNER JOIN [UserToQual] uq ON u.UserID = uq.UserID
INNER JOIN [Qual] q on uq.QualID = q.QualID
GROUP BY u.UserID

------------
--What is the average score of each individual user that has a Remington assigned to them
------------

SELECT 
	[Average Score of Each Individual User That Has a Remington] = AVG(q.Score)
FROM [User] u
INNER JOIN [UserToQual] uq ON u.UserID = uq.UserID
INNER JOIN [Qual] q ON uq.QualID = q.QualID
INNER JOIN [UserToWeapon] uw ON u.UserID =  uw.UserID
INNER JOIN [Weapon] w ON uw.WeaponID = w.WeaponID
WHERE w.Make = 'Remington'
GROUP BY u.UserID


------------
--What is the total number of users with an average score greater than 70
------------

SELECT
	u.UserID,
	[Average Score of All Users] = AVG(q.Score)
FROM [User] u
INNER JOIN [UserToQual] uq ON u.UserID = uq.UserID
INNER JOIN [Qual] q on uq.QualID = q.QualID
GROUP BY u.UserID
HAVING AVG(q.Score) > 70


------------
--Show all users that have passed at least two qualification tests
------------
SELECT
	u.*,
	[Count of Qualification Tests] = 
FROM [User] u
INNER JOIN [UserToQual] uq ON u.UserID = uq.UserID
INNER JOIN [Qual] q on uq.QualID = q.QualID
GROUP BY u.UserID
HAVING AVG(q.Score) > 70

------------
--Return a unique list of BadgeNumbers that have been used more than once.
--Also show how many times the number has been used.
------------
SELECT 
	u.BadgeNumber,
	[Number of Times Number Has Been Used] = COUNT(u.BadgeNumber)
FROM [User] u
GROUP BY u.BadgeNumber
HAVING COUNT(u.BadgeNumber) > 1

------------
--Show all officers that have more than one weapon assigned to them and
--the officer has an average score greater than 80
------------
SELECT
	u.*
FROM [User] u
INNER JOIN [UserToWeapon] uw ON u.UserID = uw.UserID
INNER JOIN [UserToQual] uq ON u.UserID = uq.UserID
INNER JOIN [Qual] q ON uq.QualID = q.QualID
GROUP BY u.UserID
HAVING COUNT(uw.UserID) > 1
		AND AVG(q.Score) > 80
-------------------------------
--Show each user who has an average score greater than or equal to 70
--who has only taken one test and if the user's average score is 
--greater than or equal to 70 show rank as HIGH
--between 50 (include 50) and 70 show rank as MED
--else show rank as LOW
-------------------------------
SELECT
	u.UserID,
	[Rank] = 
	CASE
		WHEN q.Score >= 70 THEN 'HIGH'
		WHEN q.Score BETWEEN 50 AND 70 THEN 'MED'
		WHEN q.Score < 50 THEN 'LOW'
	END 
FROM [User] U
INNER JOIN [UserToQual] uq ON u.UserID = uq.UserID
INNER JOIN [Qual] q ON uq.QualID = q.QualID
GROUP BY u.UserID, q.Score
HAVING COUNT(q.Score) = 1

-------------------------------
-- Return all users that have a Remington, Magnum or Long Rifle weapon assigned to them and that have passed at least two qualification tests.
-- Also show the following:
	-- The number of weapons assigned to the user
	-- The number of qualifcation tests (pass and failed) the user performed
	-- The number of passed qualifications
	-- The average qualification score (pass and failed tests)
	-- The percentage of qualifications the user passed
		--Note: the format must be X%, meaning include the % at the end of the number
		--Equation: (Total # of Passed Tests / Total # of Tests) * 100 + '%'
-- Also state the following for each rank
	-- Number of times the user passed Show in column called "Rank"
	-- 1-2 BEGINNER
	-- 3 NOVICED
	-- 4 AMATURE
	-- >= 5 EXPERT
-------------------------------

SELECT 
	[Weapon Count] = COUNT(uw.WeaponID),
	[Qual Count] = COUNT(uq.QualID),
	[Passed Count] = SUM(CAST(q.Pass AS INT)),
	[Avg Score] = AVG(q.Score),
	[Percentage Of Passed] = 
		CAST((SUM(CAST(q.Pass AS INT)) / COUNT(uq.QualID) * 100) AS VARCHAR(3)) 
		+ '%',
	[Rank] =
		CASE
			WHEN SUM(CAST(q.Pass AS INT)) = 2 THEN 'BEGINNER'
			WHEN SUM(CAST(q.Pass AS INT)) = 3 THEN 'NOVICED'
			WHEN SUM(CAST(q.Pass AS INT)) = 4 THEN 'AMATURE'
			WHEN SUM(CAST(q.Pass AS INT)) >= 5 THEN 'EXPERT'
			ELSE ''
		END
FROM [User] u
INNER JOIN [UserToWeapon] uw ON u.UserID = uw.UserID
INNER JOIN [Weapon] w ON uw.WeaponID = w.WeaponID
INNER JOIN [UserToQual] uq on u.UserID = uq.UserID
INNER JOIN [Qual] q on uq.QualID = q.QualID

WHERE q.Pass > 1
GROUP BY u.UserID, w.Make







