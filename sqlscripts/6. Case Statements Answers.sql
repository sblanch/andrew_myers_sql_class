/*
CASE 
WHEN THEN 
ELSE 
END
*/

-------------------------------
-- Return all Weapons Makes however change the values to match the following
-- 'Long Rifle' to 'Rifle'
-- 'M2' to 'Mag'
-- 'Magnum' to 'Mag 1'
-- 'Remington' to 'Shot Gun'
-------------------------------
SELECT DISTINCT
W.Make,
CASE 
	WHEN W.Make = 'Long Rifle' THEN 'Riffle'
	WHEN W.Make = 'M2' THEN 'Mag'
	WHEN W.Make = 'Magnum' THEN 'Mag 1'
	WHEN W.Make = 'Remington' THEN 'Shot Gun'
END AS Make
FROM Weapon W

-------------------------------
-- Return all Users that have a Qualification information
-- Group their scores into the following category
-- Scores greater than 70 rank as HIGH
-- Scores between 50 and 70 rank as MED
-- Scores lower than 50 as LOW
-- Sort the results by user's last name descending, first name ascending
-------------------------------
SELECT
--Q.Score,
CASE 
	WHEN Q.Score >= 70 THEN 'HIGH'
	WHEN Q.Score >= 50 AND Q.Score <= 70  THEN 'MED'
	WHEN Q.Score < 50 THEN 'LOW'
END AS Score
FROM [User] U
INNER JOIN UserToQual UQ ON U.UserID = UQ.UserID
INNER JOIN Qual Q ON Q.QualID = UQ.QualID
ORDER BY U.LastName DESC, U.FirstName ASC

-------------------------------
-- Return all users that have a weapon assigned to them and that have 
-- taken at least one qualification test.
-- Also show the following (assume that each police officer is only assigned one weapon):
-- If the user is assigned a Mag 2 or Magnum then show rank according to the following:
-- Scores greater than 70 show rank as HIGH
-- Scores between 50 and 70 show rank as MED
-- Scores lower than 50 show rank as LOW
-- If the user is assigned a Long Rifle or Remington then show rank according to the following:
-- Scores greater than 90 show rank as HIGH
-- Scores between 70 and 90 show rank as MED
-- Scores lower than 70 show rank as LOW
-- Else show rank as
-- Scores greater than 80 show rank as HIGH
-- Scores between 70 and 80 show rank as MED
-- Scores lower than 70 show rank as LOW
-------------------------------
SELECT
--W.Make, 
--Q.Score,
CASE 
	WHEN W.Make = 'Mag 2' OR W.Make = 'Magnum' 
	THEN
		CASE 
			WHEN Q.Score >= 70 THEN 'HIGH'
			WHEN Q.Score >= 50 AND Q.Score <= 70  THEN 'MED'
			WHEN Q.Score < 50 THEN 'LOW'
		END
	WHEN W.Make = 'Rifle' OR W.Make = 'Remington' 
	THEN
		CASE 
			WHEN Q.Score >= 90 THEN 'HIGH'
			WHEN Q.Score >= 70 AND Q.Score <= 90  THEN 'MED'
			WHEN Q.Score < 70 THEN 'LOW'
		END
	ELSE
	CASE 
		WHEN Q.Score >= 80 THEN 'HIGH'
		WHEN Q.Score >= 70 AND Q.Score <= 80  THEN 'MED'
		WHEN Q.Score < 70 THEN 'LOW'
	END
END AS Score
FROM [User] U
INNER JOIN UserToQual UQ ON U.UserID = UQ.UserID
INNER JOIN Qual Q ON Q.QualID = UQ.QualID
INNER JOIN UserToWeapon UW ON UW.UserID = U.UserID
INNER JOIN Weapon W ON W.WeaponID = UW.WeaponID

-------------------------------
-- If there are any users that are not active and assigned a weapon then show 
-- "Inactive users with assigned weapons detected"
-- Else if there are any users that are active, assigned a weapon but have not taken 
-- a qualification test
-- "Active users with assigned weapons who have not taken a test detected."
-- Else if there are any users that are active and not assigned a weapon
-- "Active users with no assigned weapons detected"
-- Else if there are any users that are active, assigned a weapon but have not passed 
-- any qualification tests, but have taken at least one test.
-- "Active users that have not passed qualification tests detected"
-- Else show
-- "SUCESS"
-------------------------------
SELECT --DISTINCT
--U.UserID,
--U.ActiveBit,
--UW.WeaponID,
--Q.QualID,
--Q.Pass,
CASE
	WHEN U.ActiveBit = 0 AND UW.WeaponID IS NOT NULL 
	THEN 'Inactive users with assigned weapons detected'
	WHEN U.ActiveBit = 1 AND UW.WeaponID IS NOT NULL AND UQ.QualID IS NULL 
	THEN 'Active users with assigned weapons who have not taken a test detected.'
	WHEN U.ActiveBit = 1 AND UW.WeaponID IS NULL 
	THEN 'Active users with no assigned weapons detected.'
	WHEN U.ActiveBit = 1 AND UW.WeaponID IS NOT NULL AND Q.Pass = 0 
	THEN 'Active users that have not passed qualification tests detected.'
ELSE 'SUCCESS'
END AS Name
FROM [User] U
FULL JOIN UserToQual UQ ON U.UserID = UQ.UserID
FULL JOIN Qual Q ON Q.QualID = UQ.QualID
FULL JOIN UserToWeapon UW ON UW.UserID = U.UserID
