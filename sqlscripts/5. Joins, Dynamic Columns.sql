------------
/*
Notes:
	Each dataset of each join will be used with the next join statement
*/
------------

------------
--Return all Users, whether or not they have a weapon.
--Also show all assigned weapon information for all users that do have a weapon(s)
------------

-- WRONG!
SELECT U.*, W.*
FROM
[User] U LEFT JOIN [UserToWeapon] UW ON [User].UserID = [UserToWeapon].UserID
INNER JOIN [Weapon] W ON [UserToWeapon].WeaponID = [Weapon].WeaponID

-- In correct
-- This is because the inner join with weapon removes those temp table where
-- there isn't a weaponID

-- in order to not delete the users use a left join
SELECT u.*, w.*
FROM [User] as u
LEFT JOIN [UsertoWeapon] as uw on u.UserID = uw.UserID
LEFT JOIN [Weapon] as w on uw.WeaponID=w.WeaponID

-- if you want to do an inner join you can do
SELECT u.*, w.*
FROM [Weapon] as w
INNER JOIN [UserToWeapon] as uw on w.weaponId = uw.weaponId
RIGHT JOIN [User] as u on u.UserId = uw.UserId


------------
--Return all Users, whether or not they have a weapon.
-- Also show all assigned weapon information for all users that do have a weapon(s)
-- Also show all qualification scores of all users whether or not they have taken a qualifaction test
------------

-- Correct!
SELECT u.*, w.*, q*
FROM
[User] u
LEFT JOIN [UserToWeapon] uw ON u.UserID = uw.UserID
LEFT JOIN [UserToQual] uq ON u.UserID = uq.UserID
LEFT JOIN [Qual] q ON uq.QualID = q.QualID;

------------
--Return all Users, whether or not they have a weapon and have attempted at least one qualification.
-- Also show all assigned weapon information for all users that do have a weapon(s)
-- Also show all qualification scores of all users
------------

-- my question What if we only wanted to return highest qualification score

--Correct!
SELECT u.*, w.*, q.Score
FROM [User] u
LEFT JOIN [UserToWeapon] uw ON u.UserID = uw.UserID
LEFT JOIN [Weapon] w ON uw.WeaponID = w.WeaponID
INNER JOIN [UserToQual] uq ON u.UserID = uq.UserID
INNER JOIN [Qual] q ON uq.QualID = q.QualID
------------
--Get all users and their weapons information if the weapon make is Long Rifle or Remington
------------

-- Correct, I think. He uses inner joing but the where removes any
-- where make is null, thus being an inner join
SELECT u.*, w.*
FROM [User] u
INNER JOIN [UserToWeapon] uw on u.UserID = uw.UserID
INNER JOIN [Weapon] w on uw.WeaponID = w.WeaponID
WHERE w.Make IN ('Long Rifle', 'Remington')
------------
--Return all Users that have a weapon (do not show weapon information) assigned to them
--and return all user's scores
------------

-- *****
--  CONFLICT
-- *****

-- Wrong according to key, but I think I am right.
-- Problem says all scores, doesn't specify scores that exist or not.
-- If a user doesn't have a score it still should be included.

SELECT u.*, q.Score
FROM [User] u
INNER JOIN [UserToWeapon] uw on u.UserID = uw.UserID
LEFT JOIN [UserToQual] uq on u.UserID = uq.UserID
LEFT JOIN [Qual] q  on uq.QualID = q.QualID


------------
--Return all user names and their qualification information of
--each user with a Remington weapon and a score greater than 50
------------

-- Correct

SELECT (u.FirstName + ','+u.LastName) as 'name', q.Score
FROM [User] u
LEFT JOIN [UserToQual] uw on u.UserID = uw.UserID
LEFT JOIN [Qual] q on uq.QualID = q.QualID
INNER JOIN [UserToWeapon] uw on u.UserID = uw.UserID
INNER JOIN [Weapon] w on uw.WeaponID = w.WeaponID
WHERE w.make = 'Remington'
  AND q.Score > 50

------------
--Return all user names and their qualification information
--However do not show TypeQualID or TypeWeatherID
--but instead show TypeQual.Name as QualName and TypeWeather.Name as WeatherName
------------
select u.firstname, u.middlename, u.lastname, q.*, tq.name as [qualname], tw.name as [weathername]
from [user] u
left join usertoqual uq on u.userid = uq.UserId
left join qual q on uq.qualid = q.qualid
left join typeweather tw on q.typeweatherid = tw.typeweatherid
left join typequal tq on q.typequalid = tq.TypeQualID

------------
--Return all user names, their weapon information and their qualification information of every user that has passed
--However do not show TypeQualID or TypeWeatherID
--but instead show Type.Qual.Name as QualName and TypeWeather.Name as WeatherName
--and also sort the user names ascending
------------
select u.firstname, u.middlename, u.lastname, q.*, tq.name as [qualname], tw.name as [weathername]
from [user] u
left join usertoqual uq on u.userid = uq.UserId
left join qual q on uq.qualid = q.qualid
left join typeweather tw on q.typeweatherid = tw.typeweatherid
left join typequal tq on q.typequalid = tq.TypeQualID
WHERE q.Pass IS NOT NULL
  AND q.Pass > 0
ORDER BY u.LastName, u.FirstName, u.MiddleName



------------
-- Return all Users that have a Qualification information
-- Group their scores into the following category
-- Scores greater than 70 rank as HIGH
-- Scores between 50 and 70 rank as MED
-- Scores lower than 50 as LOW
-- Within each group sort the Users by their first name, middle name and last name ascending respectfully
------------

select u.*, [Rank] = 'High'
from [user] u
inner join [usertoqual] uq on u.userid = uq.userid
inner join [qual] q on uq.qualid = q.qualid
where q.score > 70
ORDER BY u.firstname, u.middlename, u.lastname asc

union all

select u.*, [Rank] = 'Medium'
from [user] u
inner join [usertoqual] uq on u.userid = uq.userid
inner join [qual] q on uq.qualid = q.qualid
where q.score BETWEEN 50 AND 70
ORDER BY u.firstname, u.middlename, u.lastname asc

union all

select u.*, [Rank] = 'LOW'
from [user] u
inner join [usertoqual] uq on u.userid = uq.userid
inner join [qual] q on uq.qualid = q.qualid
where q.score < 50
ORDER BY u.firstname, u.middlename, u.lastname asc

------------
--Return all Users that have a weapon (do not show weapon information) assigned to them
--and return all user's scores
--Also show a new column called Action and populate the action as follows
--	When the score is less than 50 have the action state "Turn in your badge"
--	Between 50 and 60 state "On probation"
--	Between 60 and 90 state "Need improvement"
--	Greater than 90 state "Pass"
------------

