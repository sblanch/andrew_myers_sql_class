/*
SQL KEY WORDS

	INSERT INTO
	UPDATE
	DELETE
	WHERE
*/

----------------------
--NOTE Two of the following questions will fail. Explain why
----------------------

--Create a new User where that user is not active
INSERT INTO [WeaponsQualifications].[dbo].[User]
           ([FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[BadgeNumber]
           ,[ActiveBit]
           ,[PersonelNumber])
     VALUES
           ('Leke'
           ,'Edward'
           ,'MateMate'
           ,2290
           ,0
           ,'9022')

--Create a new User where ActiveBit is null
INSERT INTO [WeaponsQualifications].[dbo].[User]
           ([FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[BadgeNumber]
           ,[ActiveBit]
           ,[PersonelNumber])
     VALUES
           ('Leke'
           ,'Edward'
           ,'MateMate'
           ,2290
           ,null
           ,'9022')

--Create a new TypeWeather where the name is 'Cloudy'
INSERT INTO [WeaponsQualifications].[dbo].[TypeWeather]
           ([Name])
     VALUES
           ('cloudy')
           
Msg 2627, Level 14, State 1, Line 1
Violation of UNIQUE KEY constraint 'UQ__TypeWeat__737584F6023D5A04'. Cannot insert duplicate key in object 'dbo.TypeWeather'.
The statement has been terminated.

--Create a new User where the FirstName is null
INSERT INTO [WeaponsQualifications].[dbo].[User]
           ([FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[BadgeNumber]
           ,[ActiveBit]
           ,[PersonelNumber])
     VALUES
           (null
           ,'Edward'
           ,'MateMate'
           ,2290
           ,1
           ,'9022')

Msg 515, Level 16, State 2, Line 1
Cannot insert the value NULL into column 'FirstName', table 'WeaponsQualifications.dbo.User'; column does not allow nulls. INSERT fails.
The statement has been terminated.

--In the User table Set Firstname equal to 'Henry' where the User ID is 10
UPDATE [WeaponsQualifications].[dbo].[User]
   SET [FirstName] ='Henry'    
 WHERE userid=10

--In the Qual table if the TypeQualID is 6 and Pass is 0 make Pass 1
UPDATE [WeaponsQualifications].[dbo].[Qual]
   SET [Pass] = 1
 WHERE [TypeQualID] = 6 AND Pass = 0
 
--In Qual table set all Scores equal 0 where the Scores are 60 or less
UPDATE [WeaponsQualifications].[dbo].[Qual]
   SET [Score] = 0
 WHERE [Score] <= 60

--In Weapon table set Make equal to Mag 2 where Make is equal to M2
UPDATE [WeaponsQualifications].[dbo].[Weapon]
   SET [Make] = 'Mag 2'      
 WHERE [Make] = 'M2'
 
 --In the Qual table if the TypeQualID is 6 and Pass is 0 make Pass 1
UPDATE [WeaponsQualifications].[dbo].[Qual]
   SET [Pass] = 1
 WHERE [TypeQualID] = 6 AND Pass = 0
 
 --Update pass, make it 1 for the row that has TypeQualID as 10 and score is greater than 50
 UPDATE [WeaponsQualifications].[dbo].[Qual]
   SET [Pass] = 1
 WHERE [TypeQualID] = 10 AND Score > 50
 
 --For every qualification in the Qual table change the value of Score to 50 
 --if the Score is less than 50 and the TypeWeatherID is 5
UPDATE [WeaponsQualifications].[dbo].[Qual]
   SET [Score] = 50
 WHERE [Score] < 50 AND TypeWeatherID = 5
 
--For each qaulification add 10 points to every score if the score is less than 60 and the qualification was done out doors
UPDATE [WeaponsQualifications].[dbo].[Qual]
   SET [Score] = [Score] + 10
 WHERE [Score] < 60 AND Outdoor = 1
 
 --Where ever the score is greater than 90 and the qualification was performed outside and the test was performed before today
 --Set the score to 100 and the Pass to 1
 UPDATE [WeaponsQualifications].[dbo].[Qual]
   SET [Score] = 100, Pass = 1
 WHERE [Score] > 90 AND Outdoor = 1 AND [Date] < '2016-02-8 11:59:59.999'
 
--Remove all users that are not active
DELETE FROM [WeaponsQualifications].[dbo].[User]
      WHERE ActiveBit = 0

--Remove all UserToWeapons entries
DELETE FROM [WeaponsQualifications].[dbo].[UserToWeapon] 
