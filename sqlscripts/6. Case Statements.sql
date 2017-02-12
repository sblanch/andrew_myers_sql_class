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

SELECT 
	CASE
		WHEN W.Make = 'Long Rifle' THEN 'Rifle'
		WHEN W.Make = 'M2' THEN 'Mag'
		WHEN W.Make = 'Magnum' THEN 'Mag 1'
		WHEN W.Make = 'Remington' THEN 'Shot Gun'
	END AS [Make]
FROM [Weapons] W



-------------------------------
-- Return all Users that have a Qualification information
-- Group their scores into the following category
-- Scores greater than 70 rank as HIGH
-- Scores between 50 and 70 rank as MED
-- Scores lower than 50 as LOW
-- Sort the results by user's last name descending, first name ascending
-------------------------------

SELECT
	CASE
		WHEN q.Score > 70 THEN 'HIGH'
		WHEN q.Score BETWEEN 50 and 70 THEN 'MED'
		WHEN q.Score < 50 THEN 'LOW'
	END AS [Scores]
FROM [USER] u
INNER JOIN [UserToQual] uq ON u.UserID = uq.UserID
INNER JOIN [Qual] q ON uq.QualID = q.QualID


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
	q.Score,
	CASE 
		WHEN w.Make = 'Mag 2' OR w.Make = 'Magnum'
			THEN
				CASE
					WHEN q.Score > 70 THEN 'HIGH'
					WHEN q.Score BETWEEN 50 AND 70 THEN 'MED'
					WHEN q.Score < 50 THEN 'LOW'
				END
		WHEN w.Make = 'Long Rifle' OR w.Make = 'Remington'
			THEN
				CASE
					WHEN q.Score > 90 THEN 'HIGH'
					WHEN q.Score BETWEEN 70 AND 90 THEN 'MED'
					WHEN q.Score < 70 THEN 'LOW'
				END
		ELSE
			THEN
				CASE
					WHEN q.Score > 80 THEN 'HIGH'
					WHEN q.Score BETWEEN 70 AND 80 THEN 'MED'
					WHEN q.Score < 70 THEN 'LOW'
				END						
	END AS [Rank]
FROM [User] u
INNER JOIN [UserToQual] uq on u.UserID = uq.UserID
INNER JOIN [Qual] q on q.QualID = uq.QualID
INNER JOIN [UserToWeapon] uw on uw.UserID = u.UserID
INNER JOIN [Weapon] w on uw.WeaponID = w.WeaponID

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
