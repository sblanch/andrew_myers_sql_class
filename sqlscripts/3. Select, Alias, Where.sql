/*
SQL KEY WORDS

SELECT
FROM
WHERE
TOP
DISTINCT
LIKE
	% _ ^ []
BETWEEN
OPERATORS

	>
	=
	LIKE
	IS NULL
	IS NOT NULL
	<>
	!=
IN
*/

------------
-- Get all Users
------------
select * from [User]
------------
-- Why is is bad practice to select all rows in a table
------------
/*
Reason being the table could be very large, and it could
take a lot of processing power. To compound the issue, rendering
takes a lot of processing power, ~ 10X, so that makes
the computer processing effort even more laborious.
*/
------------
-- Get all users with an ID greater than 10
------------
select * from [User]
where UserId > 10
------------
-- Get all users with an ID greater than and equal to 10
------------
select * from [User]
where UserId >= 10
------------
-- Get all users with an ID not equal to 10
------------
select * from [user]
where UserId != 10
------------
-- What will the following select statement return and why
SELECT * FROM [User] WHERE [FirstName] LIKE 'Cindy'
SELECT * FROM [User] WHERE [FirstName] = 'Cindy'

SELECT * FROM [User] WHERE [FirstName] LIKE '%Cindy%'
SELECT * FROM [User] WHERE [FirstName] LIKE 'Cindy%'
SELECT * FROM [User] WHERE [FirstName] LIKE '%Cindy'
------------

------------
-- Get all users with a first name that starts with E
------------
select * from [User]
where [FirstName] like 'E%'
------------
-- Get all users with a first name that starts with W
-- and the third and fourch letters are 'll' (Note these are lower case L's)
------------
select * from [User]
where [FirstName] like 'W_ll%'

------------
-- Get all users with a first name that start with H, T or S
------------
select * from [User]
where [FirstName] like '[AMD]%'

select * from [User]
where
[FirstName] like 'A%' OR
[FirstName] like 'M%' OR
[FirstName] like 'D%'

------------
-- Get all users with a last name that ends with 'son'
------------
SELECT distinct [LASTNAME] FROM [USER]
WHERE [LASTNAME] LIKE '%son'
------------
-- Get all users that have a E in their middle name
------------
Select * From [User]
Where [MiddleName] like '%E%'
------------
-- Get the first 10 users
------------
select a.* from
(
	Select top 10 * From [User]
	order by userid desc
) as a
order by a.UserID asc
------------
-- Get all users with a badge number of 9970, 19840, 19760, 19640
------------
SELECT *
	FROM [User]
	WHERE	BadgeNumber =  9970 OR
			BadgeNumber = 19840 OR
			BadgeNumber = 19760 OR
			BadgeNumber = 19640;

------------
-- Give me all the Weapon Make Types that we have
------------
SELECT DISTINCT
	Make
	FROM [Weapon]
------------
-- Get all Weapons with an Weapon ID between 10 and 30, which includes 10 and 30
------------
SELECT
	*
	FROM [Weapon]
	WHERE WeaponID BETWEEN 10 AND 30
------------
-- Get all weapons with a Make of Remington and a Caliber of .222
------------
SELECT
	*
	FROM	[Weapon]
	WHERE	Make = 'Remington' AND
			Caliber = '.222'

------------
-- Get all weapons with a Make of Long Rifle or Magnum
------------
SELECT
	*
	FROM	[Weapon]
	WHERE	Make IN ('Long Rifle', 'Magnum')
-------------
-- Why wont the following query return any results
-- SELECT * FROM [Qual] WHERE TypeWeatherID = 5 AND TypeWeatherID = 3
-------------
/*
Because TypeWeatherID in this case has to both equal 5 and 3, which is impossible.
The person writing the query probably means TypeWeatherID = 5 OR TypeWeatherID = 3
*/
