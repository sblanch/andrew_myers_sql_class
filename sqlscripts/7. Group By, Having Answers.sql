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
	COUNT(u.UserID) AS [Total # of Employeed Officers]
FROM [User] u
WHERE u.ActiveBit = 1

------------
--What is the total number of active police officers that has a weapon assigned to them
------------
SELECT
	COUNT(u.UserID) AS [Total # of Employeed Officers with a Weapon]
FROM [User] u
INNER JOIN [UserToWeapon] w ON w.UserID = u.UserID
WHERE u.ActiveBit = 1

------------
--What is the average score of all users
------------
SELECT
	AVG(q.Score)
FROM [User] u
INNER JOIN [UserToQual] uq ON uq.UserID = u.UserID
INNER JOIN [Qual] q ON uq.QualID = q.QualID

------------
--What is the average score of each individual user
------------
SELECT
	u.UserID,
	AVG(q.Score) AS 'Average Score per user'
FROM [User] u
INNER JOIN [UserToQual] uq ON uq.UserID = u.UserID
INNER JOIN [Qual] q ON uq.QualID = q.QualID
GROUP BY u.UserID

------------
--What is the average score of each individual user that has a Remington assigned to them
------------
SELECT
	u.UserID,
	AVG(q.Score) AS 'Average Score per user with a Remington'
FROM [User] u
INNER JOIN [UserToQual] uq ON uq.UserID = u.UserID
INNER JOIN [Qual] q ON uq.QualID = q.QualID
INNER JOIN [UserToWeapon] uw ON uw.UserID = u.UserID
INNER JOIN [Weapon] w ON w.WeaponID = uw.WeaponID
WHERE w.Make = 'Remington'
GROUP BY u.UserID

------------
--What is the total number of users with an average score greater than 70
------------
SELECT
	u.UserID,
	AVG(q.Score) AS 'Average Score greater than 70'
FROM [User] u
INNER JOIN [UserToQual] uq ON uq.UserID = u.UserID
INNER JOIN [Qual] q ON uq.QualID = q.QualID
GROUP BY u.UserID
HAVING AVG(q.Score) > 70

------------
--Show all users that have passed at least two qualification tests
------------
SELECT
U.UserID,
--Q.Score
COUNT(Q.QualID) AS [Test Count]
FROM [User] U
INNER JOIN UserToQual UQ ON UQ.UserID = U.UserID
INNER JOIN Qual Q ON UQ.QualID = Q.QualID
WHERE Q.Pass = 1
GROUP BY U.UserID
HAVING COUNT(Q.QualID) >= 2

------------
--Return a unique list of BadgeNumbers that have been used more than once.
--Also show how many times the number has been used.
------------
SELECT DISTINCT
	u.BadgeNumber,
	COUNT(u.BadgeNumber) AS 'Badge Number Count'
FROM [User] u
GROUP BY u.BadgeNumber
HAVING COUNT(u.BadgeNumber) > 2

------------
--Show all officers that have more than one weapon assigned to them and
--the officer has an average score greater than 80
------------
SELECT
	u.UserID,
	AVG(q.Score) AS 'Average Score',
	COUNT(w.Make) AS 'Num of Makes'
FROM [User] u
INNER JOIN [UserToQual] uq ON uq.UserID = u.UserID
INNER JOIN [Qual] q ON uq.QualID = q.QualID
INNER JOIN [UserToWeapon] uw ON uw.UserID = u.UserID
INNER JOIN [Weapon] w ON w.WeaponID = uw.WeaponID
GROUP BY u.UserID
HAVING AVG(q.Score) > 80 AND 
COUNT(w.Make) > 1

-------------------------------
--Show each user who has an average score greater than or equal to 70
--who has only taken one test and if the user's average score is 
--greater than or equal to 70 show rank as HIGH
--between 50 (include 50) and 70 show rank as MED
--else show rank as LOW
-------------------------------
SELECT
	U.UserID,
	AVG(Q.Score) AS [Score Average],
	CASE 
		WHEN AVG(Q.Score) > 70 THEN 'HIGH'
		WHEN AVG(Q.Score) >= 50 AND AVG(Q.Score) <= 70 THEN 'MED'
		WHEN AVG(Q.Score) > 50 THEN 'LOW'
	END AS [Score Result]
FROM [User] U
INNER JOIN UserToQual UQ ON UQ.UserID = U.UserID
INNER JOIN Qual Q ON UQ.QualID = Q.QualID
GROUP BY U.UserID
HAVING 
AVG(Q.Score) >= 70 AND
COUNT(U.UserID) = 1

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
	U.UserID,
	W.Make,
	[Weapon Count] = COUNT(UW.WeaponID),
	[Qual Count] = COUNT(UQ.QualID),
	[Passed Count] = SUM(CAST(Q.Pass AS INT)),
	[Avg Score] = AVG(Q.Score),
	[Percentage Of Passed] = 
		CAST((SUM(CAST(Q.Pass AS INT)) / COUNT(UQ.QualID) * 100) AS VARCHAR(3)) 
		+ '%',
	[Rank] =
		CASE
			WHEN SUM(CAST(Q.Pass AS INT)) = 2 THEN 'BEGINNER'
			WHEN SUM(CAST(Q.Pass AS INT)) = 3 THEN 'NOVICED'
			WHEN SUM(CAST(Q.Pass AS INT)) = 4 THEN 'AMATURE'
			WHEN SUM(CAST(Q.Pass AS INT)) >= 5 THEN 'EXPERT'
			ELSE ''
		END
FROM [User] U
INNER JOIN UserToWeapon UW ON U.UserID = UW.UserID
INNER JOIN Weapon W ON UW.WeaponID = W.WeaponID
INNER JOIN UserToQual UQ ON UQ.QualID = U.UserID
INNER JOIN Qual Q ON Q.QualID = UQ.QualID
WHERE 
	W.Make = 'Remington' OR
	W.Make = 'Magnum' OR
	W.Make = 'Long Rifle'
GROUP BY U.UserID, W.Make
HAVING SUM(CAST(Q.Pass AS INT)) > 1