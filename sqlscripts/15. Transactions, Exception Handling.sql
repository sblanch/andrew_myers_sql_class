--Try Catch syntax
BEGIN TRY
     { sql_statement | statement_block }
END TRY
BEGIN CATCH
     [ { sql_statement | statement_block } ]
END CATCH


--Transaction syntax
BEGIN TRY
     BEGIN TRANSACTION TransactionName --Begin recording the transaction
     
	 select * from [user]
     --================================================
     -- Add Your Code Here
     --================================================
     
     COMMIT TRANSACTION TransactionName --Commits all changes within the transaction
 END TRY
 BEGIN CATCH
	ROLLBACK TRANSACTION TransactionName --Rolls back all changes within the transaction
  
	SELECT 
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() as ErrorState,
		ERROR_PROCEDURE() as ErrorProcedure,
		ERROR_LINE() as ErrorLine,
		ERROR_MESSAGE() as ErrorMessage;   
 END CATCH

-----------------------------------------------
-- EXAMPLE
-----------------------------------------------
BEGIN TRY
     BEGIN TRANSACTION --Begin recording the transaction
     --Add a user
     INSERT INTO [WeaponsQualifications].[dbo].[User]
           ([FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[BadgeNumber]
           ,[ActiveBit]
           ,[PersonelNumber])
     VALUES
           ('People'
           ,'Like'
           ,'People'
           ,123456
           ,1
           ,'ThatsNotFair')
	 
	 SELECT @@IDENTITY
	 SELECT * FROM [USER] WHERE [PersonelNumber] = 'ThatsNotFair'
	 
	 --Add a Type Weather
     INSERT INTO [WeaponsQualifications].[dbo].[TypeWeather]
           ([Name])
     VALUES
           ('Clear')
     
     COMMIT --Commits all changes within the transaction
 END TRY
 BEGIN CATCH
	ROLLBACK --Rolls back all changes within the transaction
	
	SELECT 
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() as ErrorState,
		ERROR_PROCEDURE() as ErrorProcedure,
		ERROR_LINE() as ErrorLine,
		ERROR_MESSAGE() as ErrorMessage;   
 END CATCH

SELECT * FROM [USER] WHERE [PersonelNumber] = 'ThatsNotFair'