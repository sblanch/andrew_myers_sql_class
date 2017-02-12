------------
-- Get all Users
------------
-- You can either use the * to denote to return all columns or specify each
-- individual column
-- Here is both examples:

-- Example 1
SELECT * FROM [USER]

-- Example 2
-- You can quickly create this example by right clicking on the table and choosing
-- Select top 1000 rows
-- and then removing the (top 1000)
SELECT [UserID]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[BadgeNumber]
      ,[ActiveBit]
      ,[PersonelNumber]
  FROM [WeaponsQualifications].[dbo].[User]

------------
-- Why is is bad practice to select all rows in a table
------------
-- The larger the table the more time it takes to return.
-- Queries could take between a fraction of a second to hours depending on the
-- query and the size
-- of the table.
-- The longer a query runs the more resources is being used on the database server.
-- Return the least amount of rows you need is always the best practice.

------------
-- Get all users with an ID greater than 10
------------
SELECT * FROM [User] WHERE [UserID] > 10

------------
-- Get all users with an ID greater than and equal to 10
------------
SELECT * FROM [User] WHERE [UserID] >= 10

------------
-- Get all users with an ID not equal to 10
------------
SELECT * FROM [User] WHERE [UserID] <> 10

------------
-- What will the following select statement return and why
--SELECT * FROM [User] WHERE [FirstName] LIKE 'Cindy'
------------
-- It returns any name that exactly matches FN9 because the LIKE statement is missing
-- any wild cards
-- The select statement is the same as
-- SELECT * FROM [User] WHERE [FirsName] = 'FN9'

------------
-- Get all users with a first name that starts with E
------------
SELECT * FROM [User] WHERE [FirstName] LIKE 'E%'

------------
-- Get all users with a first name that starts with W
-- and the third and fourch letters are 'll'
------------
SELECT * FROM [User] WHERE [FirstName] LIKE 'W_ll%'

------------
-- Get all users with that a first name that start with H, T or S
------------
SELECT * FROM [User] WHERE [FirstName] LIKE '[HTS]%'

--Or you could do this

SELECT * FROM [User]
WHERE
	[FirstName] LIKE 'H%' OR
	[FirstName] LIKE 'T%' OR
	[FirstName] LIKE 'S%'

------------
-- Get all users with a last name that ends with 'son'
------------
SELECT * FROM [User] WHERE [FirstName] LIKE '%son'

------------
-- Get all users that have a E in their middle name
------------
SELECT * FROM [User] WHERE [FirstName] LIKE '%E%'

------------
-- Get the first 10 users
------------
SELECT TOP 10
	  [UserID]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[BadgeNumber]
      ,[ActiveBit]
      ,[PersonelNumber]
  FROM [WeaponsQualifications].[dbo].[User]

------------
-- Get all users with a badge number of 9970, 19840, 19760, 19640
------------
SELECT * FROM [User] WHERE BadgeNumber IN (9970, 19840, 19760, 19640)

--OR

SELECT * FROM [User]
WHERE
	BadgeNumber = 9970 OR
	BadgeNumber = 19840 OR
	BadgeNumber = 19760 OR
	BadgeNumber = 19640

------------
-- Get me a list of all unique Weapon types (hint Make column)
------------
SELECT DISTINCT
	Make
FROM [Weapon]

------------
-- Get all Weapons with an WeaponID between 10 and 30, which includes 10 and 30
------------
SELECT * FROM [Weapon] WHERE WeaponID BETWEEN 10 AND 30

--OR

SELECT * FROM [Weapon]
WHERE WeaponID >= 10 AND WeaponID <= 30

------------
-- Get all weapons with a Make of Remington and a Caliber of .222
------------
SELECT * FROM [Weapon] WHERE Make = 'Remington' AND Caliber = '.222'

------------
-- Get all weapons with a Make of Long Rifle or Magnum
------------
SELECT * FROM [Weapon] WHERE Make IN ('Long Rifle', 'Magnum')

--OR

SELECT * FROM [Weapon] WHERE Make = 'Long Rifle' OR Make = 'Magnum'

-------------
-- Why wont the following query return any results
-- SELECT * FROM [Qual] WHERE TypeWeatherID = 5 AND TypeWeatherID = 3
-------------

-- The select statement's filter is using an AND meaning that an exact match must be found.
-- There will never be a row that has a TypeWeatherID of 5 and 3 because the column
-- can only have one value not two.