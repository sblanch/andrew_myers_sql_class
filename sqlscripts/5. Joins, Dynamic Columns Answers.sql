------------
--Return all Users, whether or not they have a weapon. 
--Also show all assigned weapon information for all users that do have a weapon(s)
------------
-- We came up with the following equation. 
SELECT u.*, w.*
FROM [User] as u
LEFT JOIN [UsertoWeapon] as uw on u.UserID = uw.UserID
LEFT JOIN [Weapon] as w on uw.WeaponID=w.WeaponID

-- However the following will also work. I was going to bring this up next week but decided to throw this out now
-- to give you time to ponder why this equation will also satisfy the requirement.
-- Notice that the equation above uses two Left Joins but the one below uses an Inner followed by a Right join
SELECT u.*, w.*
FROM [Weapon] as w
INNER JOIN [UserToWeapon] as uw on w.weaponId = uw.weaponId
RIGHT JOIN [User] as u on u.UserId = uw.UserId

-- You might be tempted to think that this equation would satisfy the requirement. But if you run it will see that it 
-- does not return all users, whether or not they have a weapon. Instead it just returns those users that have a weapon.
SELECT u.*, w.*
FROM [User] as u
LEFT JOIN [UsertoWeapon] as uw on u.UserID = uw.UserID
INNER JOIN [Weapon] as w on uw.WeaponID=w.WeaponID

------------
--Return all Users, whether or not they have a weapon. 
-- Also show all assigned weapon information for all users that do have a weapon(s)
-- Also show all qualification scores of all users whether or not they have taken a qualifaction test 
------------
SELECT u.*, w.*, q.Score
FROM [User] as u
LEFT JOIN [UsertoWeapon] as uw on u.UserID = uw.UserID
LEFT JOIN [Weapon] as w on uw.WeaponID=w.WeaponID
LEFT JOIN [UserToQual] as uq on u.UserID = uq.UserID
LEFT JOIN [Qual] q on uq.QualId = q.QualId
--WHERE w.WEAPONID IS NULL

------------
--Return all Users, whether or not they have a weapon and have attempted at least one qualification. 
-- Also show all assigned weapon information for all users that do have a weapon(s)
-- Also show all qualification scores of all users 
------------
SELECT u.*, w.*, q.Score
FROM [User] as u
LEFT JOIN [UsertoWeapon] as uw on u.UserID = uw.UserID
LEFT JOIN [Weapon] as w on uw.WeaponID=w.WeaponID
INNER JOIN [UserToQual] as uq on u.UserID = uq.UserID
INNER JOIN [Qual] q on uq.QualId = q.QualId 

------------
--Get all users and their weapons information if the weapon make is Long Rifle or Remington
------------
SELECT u.*, w.*
FROM [User] as u
LEFT JOIN [UsertoWeapon] as uw on u.UserID = uw.UserID
LEFT JOIN [Weapon] as w on uw.WeaponID=w.WeaponID
WHERE w.Make in('Long Rifle','Remington')
--ORDER BY u.[UserID] asc

------------
--Return all Users that have a weapon (do not show weapon information) assigned to them 
--and return all user's scores
------------
--To make sure that your query is correct first get all users and their weapons
SELECT DISTINCT u.*,w.*
FROM [User] as u
INNER JOIN [UserToWeapon] as w on u.UserID=w.UserID
--ORDER BY u.[UserID] asc

--Next get all Users and their Qualifications
SELECT DISTINCT u.*, q.*
FROM [User] as u
INNER JOIN [UserToQual] as uq on u.UserID = uq.UserID
INNER JOIN [Qual] as q on uq.QualID=q.QualID
--ORDER BY u.[UserID] asc

--Next combine the queries together
SELECT DISTINCT u.*,w.*,q.*
FROM [User] as u
INNER JOIN [UsertoWeapon] as w on u.UserID=w.UserID
INNER JOIN [UsertoQual] as uq on u.UserID = uq.UserID
INNER JOIN [Qual] as q on uq.QualID=q.QualID
--ORDER BY u.[UserID] asc

--Remove the Weapon information from the query and only show the score 
SELECT DISTINCT u.*,q.Score
FROM [User] as u
INNER JOIN [UsertoWeapon] as w on u.UserID=w.UserID
INNER JOIN [UsertoQual] as uq on u.UserID = uq.UserID
INNER JOIN [Qual] as q on uq.QualID=q.QualID
--ORDER BY u.[UserID] asc

------------
--Return all user names and their qualification information of 
--each user with a Remington weapon and a score greater than 50
------------
--With your first query I would include the Make to make sure that the data returned is correct
SELECT DISTINCT u.FirstName, u.MiddleName, u.LastName, q.*, wp.Make
FROM [User] as u
INNER JOIN [UsertoWeapon] as w on u.UserID=w.UserID
INNER JOIN [Weapon] as wp on w.WeaponID = wp.WeaponID
INNER JOIN [UsertoQual] as uq on u.UserID = uq.UserID
INNER JOIN [Qual] as q on uq.QualID=q.QualID
WHERE 
	wp.Make = 'Remington' AND
	q.Score > 50
--ORDER BY u.[UserID] asc

--Next I would take out the make since it is not required
SELECT DISTINCT u.FirstName, u.MiddleName, u.LastName, q.*
FROM [User] as u
INNER JOIN [UsertoWeapon] as w on u.UserID=w.UserID
INNER JOIN [Weapon] as wp on w.WeaponID = wp.WeaponID
INNER JOIN [UsertoQual] as uq on u.UserID = uq.UserID
INNER JOIN [Qual] as q on uq.QualID=q.QualID
WHERE 
	wp.Make = 'Remington' AND
	q.Score > 50
--ORDER BY u.[UserID] asc

------------
--Return all user names and their qualification information 
--However do not show TypeQualID or TypeWeatherID
--but instead show Type.Qual.Name as QualName and TypeWeather.Name as WeatherName
------------
SELECT DISTINCT 
	u.FirstName, 
	u.MiddleName, 
	u.LastName, 
	q.QualID,
	q.[Date],
	q.Outdoor,
	q.Temp,
	q.Score,
	q.Pass,
	tq.Name as QualName,
	tw.Name as WeatherName
FROM [User] as u
INNER JOIN [UsertoQual] as uq on u.UserID = uq.UserID
INNER JOIN [Qual] as q on uq.QualID=q.QualID
INNER JOIN [TypeQual] as tq on q.TypeQualID = tq.TypeQualID
INNER JOIN [TypeWeather] as tw on q.TypeWeatherID = q.TypeWeatherID
--ORDER BY u.[UserID] asc

------------
--Return all user names, their weapon information and their qualification information of every user that has passed
--However do not show TypeQualID or TypeWeatherID
--but instead show TypeQual.Name as QualName and TypeWeather.Name as WeatherName
--and also sort the user names ascending
------------

SELECT DISTINCT TOP 1000
	--u.UserID,
	u.FirstName, 
	u.MiddleName, 
	u.LastName, 
	q.QualID,
	q.[Date],
	q.Outdoor,
	q.Temp,
	q.Score,
	q.Pass,
	tq.Name as QualName,
	tw.Name as WeatherName,
	w.WeaponID
FROM [User] as u
INNER JOIN [UserToWeapon] as uw on u.UserID = uw.UserID
INNER JOIN [Weapon] as w on uw.WeaponID = w.WeaponID
INNER JOIN [UserToQual] as uq on u.UserID = uq.UserID
INNER JOIN [Qual] as q on uq.QualID = q.QualID
INNER JOIN [TypeQual] as tq on q.TypeQualID = tq.TypeQualID
INNER JOIN [TypeWeather] as tw on q.TypeWeatherID = tw.TypeWeatherID
ORDER BY u.LastName, u.FirstName, u.MiddleName 
	
------------
-- Return all Users that have a Qualification information
-- Group their scores into the following category
-- Scores greater than 70 rank as HIGH
-- Scores between 50 and 70 rank as MED
-- Scores lower than 50 as LOW
------------
SELECT DISTINCT 
	[Rank] = 'HIGH',
	u.FirstName, 
	u.MiddleName, 
	u.LastName, 
	q.QualID,
	q.[Date],
	q.Outdoor,
	q.Temp,
	q.Score,
	q.Pass,
	tq.Name as QualName,
	tw.Name as WeatherName
FROM [User] as u
INNER JOIN [UsertoQual] as uq on u.UserID = uq.UserID
INNER JOIN [Qual] as q on uq.QualID=q.QualID
INNER JOIN [TypeQual] as tq on q.TypeQualID = tq.TypeQualID
INNER JOIN [TypeWeather] as tw on q.TypeWeatherID = q.TypeWeatherID
WHERE q.Score > 70

UNION ALL

SELECT DISTINCT 
	[Rank] = 'MED',
	u.FirstName, 
	u.MiddleName, 
	u.LastName, 
	q.QualID,
	q.[Date],
	q.Outdoor,
	q.Temp,
	q.Score,
	q.Pass,
	tq.Name as QualName,
	tw.Name as WeatherName
FROM [User] as u
INNER JOIN [UsertoQual] as uq on u.UserID = uq.UserID
INNER JOIN [Qual] as q on uq.QualID=q.QualID
INNER JOIN [TypeQual] as tq on q.TypeQualID = tq.TypeQualID
INNER JOIN [TypeWeather] as tw on q.TypeWeatherID = q.TypeWeatherID
WHERE q.Score > 50 AND q.Score <= 70

UNION ALL

SELECT DISTINCT 
	[Rank] = 'LOW',
	u.FirstName, 
	u.MiddleName, 
	u.LastName, 
	q.QualID,
	q.[Date],
	q.Outdoor,
	q.Temp,
	q.Score,
	q.Pass,
	tq.Name as QualName,
	tw.Name as WeatherName
FROM [User] as u
INNER JOIN [UsertoQual] as uq on u.UserID = uq.UserID
INNER JOIN [Qual] as q on uq.QualID=q.QualID
INNER JOIN [TypeQual] as tq on q.TypeQualID = tq.TypeQualID
INNER JOIN [TypeWeather] as tw on q.TypeWeatherID = q.TypeWeatherID
WHERE q.Score < 50

------------
--Return all Users that have a weapon (do not show weapon information) assigned to them 
--and return all user's scores
--Also show a new column called Action and populate the action as follows
--	When the score is less than 50 have the action state "Turn in your badge"
--	Between 50 and 60 state "On probation"
--	Between 60 and 90 state "Need improvement"
--	Greater than 90 state "Pass"
------------

Select Distinct 
	u.UserID,
	q.Score, 
	[Action]='Turn in your badge'
from [User] as u
Inner join [UsertoQual] as uq on u.UserID = uq.UserID
Inner join [Qual] as q on uq.QualID=q.QualID
Inner join [UsertoWeapon] as w on u.UserID=w.UserID
Where q.Score < 50

Union All

Select Distinct 
	u.UserID,
	q.Score, 
	[Action]='On Probation'
from [User] as u
Inner join [UsertoQual] as uq on u.UserID = uq.UserID
Inner join [Qual] as q on uq.QualID=q.QualID
Inner join [UsertoWeapon] as w on u.UserID=w.UserID
Where q.Score>= 50 and q.Score<= 70

