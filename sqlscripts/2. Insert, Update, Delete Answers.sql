--------------------------------------------------
--Create a new User where that user is not active
--------------------------------------------------
-- You can do the following to accomplish this task
-- 1. Look at the problem. Notice that it asks that you insert a User
-- Users are stored in the User table
-- 2. Go to Object Explorer -> Databases -> WeaponsQualifications -> Tables -> User -> Columns
-- Look at the column called ActiveBit
-- The name alone suggests that it determines if a user is active or not
-- However if in doubt either ask the person that created the table or any documentation about it
-- Also notice the type of ActiveBit, which is a bit. Which can be either 1 or 0
-- Note: In the programming world 0 means NO/OFF and 1 means YES/ON
-- 3. Look at the other fields and notice that they are all set to "not null", meaning require a value
-- 4. Insert values into all required fields and make sure that ActiveBit is 0
-- You can quickly do this by right clicking on the User table and selecting 
-- Script Table as -> Insert to -> New Query Editor Window
-- This will produce
/*
INSERT INTO [WeaponsQualifications].[dbo].[User]
           ([FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[BadgeNumber]
           ,[ActiveBit]
           ,[PersonelNumber])
     VALUES
           (<FirstName, nvarchar(256),>
           ,<MiddleName, nvarchar(256),>
           ,<LastName, nvarchar(256),>
           ,<BadgeNumber, int,>
           ,<ActiveBit, bit,>
           ,<PersonelNumber, nvarchar(256),>)
GO
*/
-- 5. Now replace each Value with any string values you want and make sure that the ActiveBit is 0 like so

INSERT INTO [WeaponsQualifications].[dbo].[User]
           ([FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[BadgeNumber]
           ,[ActiveBit]
           ,[PersonelNumber])
     VALUES
           ('Andrew'
           ,'Thomas'
           ,'Myers'
           ,12345
           ,0
           ,'PN90582ER')

--------------------------------------------------
--Create a new User where ActiveBit is null
--------------------------------------------------
-- Same as above except make sure that ActiveBit is set to null
-- Meaning that no memory will be allocated for this column
INSERT INTO [WeaponsQualifications].[dbo].[User]
           ([FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[BadgeNumber]
           ,[ActiveBit]
           ,[PersonelNumber])
     VALUES
           ('Andrew'
           ,'Thomas'
           ,'Myers'
           ,54321
           ,null
           ,'PN90582ER')

--------------------------------------------------
--Create a new UserToWeapon entry where the BadgeNumber is 42000 and the SerialNumber is 9993
--------------------------------------------------
-- There are several ways to accomplish this, either way requires SELECT statements to determine the correct data entries
-- Lets look at two approaches

-----------------
-- First Approach
-----------------
-- 1. Look at the table that needs an entry, in this case we want to add an entry to UserToWeapon
-- To accomplish this drill down in Object Explorer -> WeaponsQualifications -> dbo.UserToWeapon -> Columns
-- Notice that there are three columns; WeaponID, UserID and CreateDate. 
-- The first two are required and the last is not. Simply because the first two are "not null" and the last "null".
-- Meaning that the first two (WeaponID and UserID) have a column constraint that does not accept null values
-- While CreateDate does accept nulls.
-- So you could skip adding a value in the CreateDate field
-- However you must provide the UserID and the WeaponID
-- 2. Retrieving the UserID
-- Reading the assignment you notice that it mentions "where the BadgeNumber is 42000".
-- Looking through the tables you will notice that the UserID and BadgeNumber values are stored in the User table
-- To retrieve the UserID from the User table you can use a simple query like so

SELECT TOP 1 [UserID] FROM [User] WHERE [BadgeNumber] = 42000

--In my database the UserID is 161.
--For your database write down the return value to be used later in the Insert statement.
--3. Retriving the WeaponID
--Reading the assignment you notice that it mentions "SerialNumber is 9993"
--The Weapon table holds the WeaponID and SerialNumber values
--Using another select Statement we can get the WeaponID by

SELECT TOP 1 [WeaponID] FROM [Weapon] WHERE [SerialNumber] = 9993 

--In my database the WeaponID was 998.
--For your database write down the return value to be used later in the Insert statement.
--4. Inserting the values
-- Now that you have the UserID and WeaponID you can create the UserToWeapon insert statement like so

INSERT INTO [WeaponsQualifications].[dbo].[UserToWeapon]
           ([WeaponID]
           ,[UserID])
     VALUES
           (998
           ,161);

-----------------
-- Second Approach
-----------------
--This approach uses variables to store the values and then using those variables to insert the values into the table
--We have not covered this type of approach in class.
--I am simpily introducing this type of method to you now so that you can see the type of 
--queries that you will be learning in the future.

--Declare the variables
DECLARE
	@UserID int,
	@WeaponID int,
	@Date datetime;

--Get the User ID from User table where BadgeNumber is 42000
SELECT TOP 1
	@UserID = [UserID]
FROM [User]
WHERE BadgeNumber = 42000;

--Get the WeaponID from the Weapon table where SerialNumber is 9993
SELECT TOP 1
	@WeaponID = [WeaponID]
FROM [Weapon]
WHERE [SerialNumber] = 9993;

--Get the current UTC Date 
SET @Date = GetUTCDate();

--Insert the variable values into the database, which for me was UserID = 161 and WeaponID 998
INSERT INTO [WeaponsQualifications].[dbo].[UserToWeapon]
           ([WeaponID]
           ,[UserID]
           ,[CreateDate])
     VALUES
           (@WeaponID
           ,@UserID
           ,@Date);

--------------------------------------------------
--Create a new TypeWeather where the name is 'Cloudy'
--------------------------------------------------
-- The script will look like this

INSERT INTO [WeaponsQualifications].[dbo].[TypeWeather]
           ([Name])
     VALUES
           ('Cloudy')

-- However when you run this script you will get the following error
-- Cannot insert duplicate key in object 'dbo.TypeWeather'
-- The reason is there is a UNIGUE constraint on the table.
-- Look at how the table was created
/*
CREATE TABLE [TypeWeather]
(
	[TypeWeatherID] INT PRIMARY KEY IDENTITY (1, 1) NOT NULL,
	[Name] NVARCHAR(256) UNIQUE NOT NULL
)
*/
-- Notice the UNIQUE keyword next to the column name
-- If you run the following query

SELECT * FROM [TypeWeather] WHERE [Name] = 'Cloudy'

-- You will see that there is already an entry called Cloudy

--------------------------------------------------
--Create a new User where the FirstName is null
--------------------------------------------------
-- The Query will look like

INSERT INTO [WeaponsQualifications].[dbo].[User]
           ([FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[BadgeNumber]
           ,[ActiveBit]
           ,[PersonelNumber])
     VALUES
           (null
           ,'Thomas'
           ,'Myers'
           ,54321
           ,1
           ,'PN90582ER')
 
-- Where the FirstName value is null
-- However when you run the query you will get
-- Cannot insert the value NULL into column 'FirstName'
-- This is because the FirstName column is set to 'not null' meaning that a value is required. 
-- So there is no way of adding a user with a FirstName of null
         
--------------------------------------------------
--In the User table Set Firstname equal to 'Henry' where the User ID is 10
--------------------------------------------------
-- To create an update script for the User table
-- Right click on the User table and choose
-- Script Table as -> Update to -> New Query Editor Window
-- You will get something like this
/*
UPDATE [WeaponsQualifications].[dbo].[User]
   SET [FirstName] = <FirstName, nvarchar(256),>
      ,[MiddleName] = <MiddleName, nvarchar(256),>
      ,[LastName] = <LastName, nvarchar(256),>
      ,[BadgeNumber] = <BadgeNumber, int,>
      ,[ActiveBit] = <ActiveBit, bit,>
      ,[PersonelNumber] = <PersonelNumber, nvarchar(256),>
 WHERE <Search Conditions,,>
*/
-- Notice that it includes a Where clause.
-- Without the Where clause you will end up updating all values in the table, which could be a large issue trying to revert it
-- Since we only want to update the FirstName remove all other columns except FirstName like so
/*
UPDATE [WeaponsQualifications].[dbo].[User]
   SET [FirstName] = <FirstName, nvarchar(256),>
 WHERE <Search Conditions,,>
*/
-- Set the FirstName value, which is 'Henry'
-- And in the WHERE clause we are looking for a UserID of 10
-- In the end the query should be

UPDATE [WeaponsQualifications].[dbo].[User]
   SET [FirstName] = 'Henry'
 WHERE UserID = 10
 
 --------------------------------------------------
--In the Qual table if the TypeQualID is 6 and Pass is 0 make Pass 1
--------------------------------------------------
-- The query for this will end up being

UPDATE [WeaponsQualifications].[dbo].[Qual]
   SET 
      [Pass] = 1
 WHERE TypeQualID = 6 AND Pass = 0

--------------------------------------------------
--In Qual table set all Scores equal 0 where the Scores are 60 or less
--------------------------------------------------
-- The query for this will be

UPDATE [WeaponsQualifications].[dbo].[Qual]
   SET 
      [Score] = 0
 WHERE [Score] <= 60

--------------------------------------------------
--In Weapon table set Make equal to Mag 2 where Make is equal to M2
--------------------------------------------------
-- The query for this will be

UPDATE [WeaponsQualifications].[dbo].[Weapon]
   SET 
	   [Make] = 'Mag 2'
 WHERE [Make] = 'M2'
 
--------------------------------------------------
--Remove all users that are not active
--------------------------------------------------
-- The query for this will be

DELETE FROM [User]
 WHERE ActiveBit = 0
 
--------------------------------------------------
--Remove all UserToWeapons entries
--------------------------------------------------
-- The query for this will be

DELETE FROM UserToWeapons