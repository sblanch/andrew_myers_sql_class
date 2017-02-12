---------------
--SEARCHING EXAMPLE
---------------

/*
Searching will make more sense in a Stored Procedure however learning the basics now
will be benificial. 

Let's say that you wish to return results based on any set of search terms.
If a the search term is blank (null) then you don't want to use that search term.
To accomplish this we are going to use COALESCE.

Let's say that you wish to search on the User table where each column is a search term
if the search term is @SearchTerm then you will want to use a COALESCE to determine
whether you wish to use the @SearchTerm (if not null) or use the column name as a match.
Using the column name as the match will cause the query to simply ignore filtering based on that column, 
which is what we want.

In other words the syntax will look like this

SELECT
	*
FROM TableName
WHERE
[column field name] = COALESCE(@SearchTerm , [column field name]) or
[column field name] LIKE COALESCE('%' + @SearchTerm + '%', '%')

or you could use instead of COALESCE use ISNULL like so

[column field name] = ISNULL(@SEARCH_TERM, [column field name])
[column field name] LIKE ISNULL('%' + @SEARCH_TERM + '%', '%')

*/
USE WeaponsQualifications

DECLARE
	@FirstName NVARCHAR(256),
	@MiddleName NVARCHAR(256),
	@LastName NVARCHAR(256),
	@BadgeNumber INT,
	@ActiveBit BIT,
	@PersonelNumber NVARCHAR(256)

SELECT
	@FirstName = NULL,
	@MiddleName = NULL,
	@LastName = NULL,
	@BadgeNumber = NULL,
	@ActiveBit = NULL,
	@PersonelNumber = NULL

----------------------
--EXACT MATCH SEARCH
----------------------	
--SELECT TOP 1
--	@FirstName = FirstName, --'FN1000',
--	@MiddleName = MiddleName, --'MN1000',
--	@LastName = LastName, --'LN1000',
--	@BadgeNumber = BadgeNumber, --50000,
--	@ActiveBit = ActiveBit, --1,
--	@PersonelNumber = PersonelNumber --'PN:7771000'
--FROM [user] order by userid asc

--SELECT
--	*
--FROM [User] u
--WHERE
--	[FirstName] = COALESCE(@FirstName ,[FirstName])  AND
--	[MiddleName] = COALESCE(@MiddleName ,[MiddleName])  AND
--	[LastName] = COALESCE(@LastName ,[LastName])  AND
--	[BadgeNumber] = COALESCE(@BadgeNumber ,[BadgeNumber])  AND
--	[ActiveBit] = COALESCE(@ActiveBit ,[ActiveBit])  AND
--	[PersonelNumber] = COALESCE(@PersonelNumber ,[PersonelNumber])
 
-------------------
--CONTAINS VARCHAR SEARCH
--The only difference between this select statement and the one above
--is that we are going to be using LIKE instead of =
--so that we can search on values that contains the search criteria
-------------------
--SELECT
--	@FirstName = 'N10',
--	@MiddleName = 'MN1',
--	@LastName = '00',
--	@BadgeNumber = null,
--	@ActiveBit = null,
--	@PersonelNumber = null

--SELECT
--	*
--FROM [User] u
--WHERE
--	[FirstName] LIKE COALESCE('%' + @FirstName + '%' ,[FirstName])  AND
--	[MiddleName] LIKE COALESCE('%' + @MiddleName + '%' ,[MiddleName])  AND
--	[LastName] LIKE COALESCE('%' + @LastName + '%' ,[LastName])  AND
--	[BadgeNumber] =  COALESCE(@BadgeNumber,[BadgeNumber])  AND --Note can't use a LIKE on an INT. It must be a VARCHAR type
--	[ActiveBit] = COALESCE(@ActiveBit,[ActiveBit])  AND --Note can't use a LIKE on a BIT. It must be a VARCHAR type
--	[PersonelNumber] LIKE COALESCE('%' + @PersonelNumber + '%' ,[PersonelNumber])
 
-------------------
--CONTAINS VARCHAR AND INT SEARCH
--The only difference between this select statement and the one above
--is that we are going to be using LIKE instead of =
--so that we can search on values that contains the search criteria
-------------------
--DECLARE 
--	@BadgeNumberVar VARCHAR(256)
	
--SELECT
--	@FirstName = 'N10',
--	@MiddleName = 'MN1',
--	@LastName = '00',
--	@BadgeNumberVar = '500',
--	@ActiveBit = null,
--	@PersonelNumber = '777'
	
--DECLARE @Values TABLE(
--	[UserID] [int],
--	[FirstName] [nvarchar](256),
--	[MiddleName] [nvarchar](256),
--	[LastName] [nvarchar](256),
--	[BadgeNumber] [nvarchar](256), --It is important you make this a varchar instead of an INT
--	[ActiveBit] [bit],
--	[PersonelNumber] [nvarchar](256)
--	)

--INSERT INTO @Values
--SELECT
--	UserID,
--	FirstName,
--	MiddleName,
--	LastName,
--	BadgeNumber = CAST(BadgeNumber AS NVARCHAR(256)),
--	ActiveBit,
--	PersonelNumber
--FROM [User] u
--WHERE
--	[FirstName] LIKE COALESCE('%' + @FirstName + '%' ,[FirstName])  AND
--	[MiddleName] LIKE COALESCE('%' + @MiddleName + '%' ,[MiddleName])  AND
--	[LastName] LIKE COALESCE('%' + @LastName + '%' ,[LastName])  AND
--	[ActiveBit] = COALESCE(@ActiveBit,[ActiveBit])  AND --Note can't use a LIKE on a BIT. It must be a VARCHAR type
--	[PersonelNumber] LIKE COALESCE('%' + @PersonelNumber + '%' ,[PersonelNumber])

--SELECT 
--	*
--FROM @Values
--WHERE
--	[BadgeNumber] LIKE COALESCE('%' + @BadgeNumberVar + '%' ,[BadgeNumber])

-------------------
--CONTAINS VARCHAR AND INT SEARCH WITH ORDER BY
--The only difference between this select statement and the one above
--is that we are going to be using LIKE instead of =
--so that we can search on values that contains the search criteria
-------------------
--DECLARE
--	@OrderDirection BIT, --0 FOR DESC, 1 FOR ASC
--	@OrderBy VARCHAR(20) --Column Name
	
--SET @OrderDirection = 0
----SET @OrderDirection = 1

--SET @OrderBy = 'UserID'
----SET @OrderBy = 'FirstName'
----SET @OrderBy = 'Middlename'
----SET @OrderBy = 'LastName'
----SET @OrderBy = 'BadgeNumber'
----SET @OrderBy = 'ActiveBit'
----SET @OrderBy = 'PersonelNumber'

--SELECT
--	--@FirstName = 'FN10',
--	--@MiddleName = 'MN1000',
--	--@LastName = 'LN1000',
--	@BadgeNumber = 50,
--	@ActiveBit = 1--,
--	--@PersonelNumber = 'PN:7771000'

--DECLARE @Values TABLE(
--	[UserID] [int],
--	[FirstName] [nvarchar](256),
--	[MiddleName] [nvarchar](256),
--	[LastName] [nvarchar](256),
--	[BadgeNumber] [nvarchar](256), --It is important you make this a varchar instead of an INT
--	[ActiveBit] [bit],
--	[PersonelNumber] [nvarchar](256)
--	)

--INSERT INTO @Values
--SELECT
--	UserID,
--	FirstName,
--	MiddleName,
--	LastName,
--	BadgeNumber = CAST(BadgeNumber AS NVARCHAR(20)),
--	ActiveBit,
--	PersonelNumber
--FROM [User] u
--WHERE
--	[FirstName] LIKE COALESCE('%' + @FirstName + '%' ,[FirstName])  AND
--	[MiddleName] LIKE COALESCE('%' + @MiddleName + '%' ,[MiddleName])  AND
--	[LastName] LIKE COALESCE('%' + @LastName + '%' ,[LastName])  AND
--	[ActiveBit] = COALESCE(@ActiveBit,[ActiveBit])  AND --Note can't use a LIKE on a BIT. It must be a VARCHAR type
--	[PersonelNumber] LIKE COALESCE('%' + @PersonelNumber + '%' ,[PersonelNumber])

--SELECT 
--	*
--FROM @Values
--WHERE
--	[BadgeNumber] LIKE COALESCE('%' + CAST(@BadgeNumber AS NVARCHAR(20)) + '%' ,[BadgeNumber])
--ORDER BY
-- CASE @OrderDirection WHEN 1 THEN
--	CASE
--	WHEN @OrderBy = 'UserID' THEN RANK()OVER (ORDER BY UserID)
--	WHEN @OrderBy = 'FirstName' THEN RANK()OVER (ORDER BY FirstName)
--	WHEN @OrderBy = 'Middlename' THEN RANK()OVER (ORDER BY Middlename)
--	WHEN @OrderBy = 'LastName' THEN RANK()OVER (ORDER BY LastName) 
--	WHEN @OrderBy = 'BadgeNumber' THEN RANK()OVER (ORDER BY BadgeNumber)
--	WHEN @OrderBy = 'ActiveBit' THEN RANK()OVER (ORDER BY ActiveBit)
--	WHEN @OrderBy = 'PersonelNumber' THEN RANK()OVER (ORDER BY PersonelNumber)
--	END 
--END ASC,
-- CASE @OrderDirection WHEN 0 THEN
--	CASE 
--	WHEN @OrderBy = 'UserID' THEN RANK()OVER (ORDER BY UserID)
--	WHEN @OrderBy = 'FirstName' THEN RANK()OVER (ORDER BY FirstName)
--	WHEN @OrderBy = 'Middlename' THEN RANK()OVER (ORDER BY Middlename)
--	WHEN @OrderBy = 'LastName' THEN RANK()OVER (ORDER BY LastName) 
--	WHEN @OrderBy = 'BadgeNumber' THEN RANK()OVER (ORDER BY BadgeNumber)
--	WHEN @OrderBy = 'ActiveBit' THEN RANK()OVER (ORDER BY ActiveBit)
--	WHEN @OrderBy = 'PersonelNumber' THEN RANK()OVER (ORDER BY PersonelNumber)
--	END 
--END DESC

---------------
--PAGING EXAMPLE
---------------
-------------------
--CONTAINS VARCHAR AND INT SEARCH WITH ORDER BY
--The only difference between this select statement and the one above
--is we have added paging
-------------------

-----------------------
--Declare the variables
-----------------------

--DECLARE
--	@OrderDirection BIT,			--0 FOR DESC, 1 FOR ASC
--	@OrderBy		VARCHAR(20),	--Order by which Column Name
--	@PageSize		INT,			--This is the number of rows per page
--	@PageNumber		INT				--This is the page we want to return

----Temp Table is used to help do a LIKE statement on BadgeNumber
--DECLARE @Values TABLE(
--	[UserID]			INT,
--	[FirstName]			NVARCHAR(256),
--	[MiddleName]		NVARCHAR(256),
--	[LastName]			NVARCHAR(256),
--	[BadgeNumber]		NVARCHAR(256), --It is important you make this a varchar instead of an INT
--	[ActiveBit]			BIT,
--	[PersonelNumber]	NVARCHAR(256))

--DECLARE @PageValues TABLE(
--	[VID] 				INT IDENTITY(1,1),
--	[UserID]			INT,
--	[FirstName]			NVARCHAR(256),
--	[MiddleName]		NVARCHAR(256),
--	[LastName]			NVARCHAR(256),
--	[BadgeNumber]		NVARCHAR(256), --It is important you make this a varchar instead of an INT
--	[ActiveBit]			BIT,
--	[PersonelNumber]	NVARCHAR(256))

-------------------------
----Set the variables
----Uncomment and comment the values to change the search results
-------------------------

----These are the page values
--SET @PageSize	= 10	--This is the number of rows per page
--SET @PageNumber	= 11		--Start with page 1 - This is the page we want to return

----These is the sort order direction values
----SET @OrderDirection = 0
--SET @OrderDirection = 1

----This is what we want to order by
--SET @OrderBy = 'UserID'
----SET @OrderBy = 'FirstName'
----SET @OrderBy = 'Middlename'
----SET @OrderBy = 'LastName'
----SET @OrderBy = 'BadgeNumber'
----SET @OrderBy = 'ActiveBit'
----SET @OrderBy = 'PersonelNumber'

----These are the search term values
--SELECT
--	--@FirstName = 'FN10',
--	--@MiddleName = 'MN1000',
--	--@LastName = 'LN1000',
--	@BadgeNumber = 50,
--	@ActiveBit = 1--,
--	--@PersonelNumber = 'PN:7771000'

-----------------------
----Insert into the temp table the results.
----The reason for this table is because we need to cast the 
---- BadgeNumber from an INT into a VARCHAR
---- so that we can perform a contains (LIKE) on BadgeNumber later
-------------------------

--INSERT INTO @Values
--SELECT
--	UserID,
--	FirstName,
--	MiddleName,
--	LastName,
--	BadgeNumber = CAST(BadgeNumber AS NVARCHAR(20)),
--	ActiveBit,
--	PersonelNumber
--FROM [User] u
--WHERE
--	[FirstName] LIKE COALESCE('%' + @FirstName + '%' ,[FirstName])  AND
--	[MiddleName] LIKE COALESCE('%' + @MiddleName + '%' ,[MiddleName])  AND
--	[LastName] LIKE COALESCE('%' + @LastName + '%' ,[LastName])  AND
--	[ActiveBit] = COALESCE(@ActiveBit,[ActiveBit])  AND --Note can't use a LIKE on a BIT. It must be a VARCHAR type
--	[PersonelNumber] LIKE COALESCE('%' + @PersonelNumber + '%' ,[PersonelNumber])

-------------------------
----Insert into the temp table final filtered results.
----We can not do the paging at the same time because page 
----identifiers (VID) can be filtered out leaving us with 
----less results than @PageSize and/or invalid page results.
-------------------------

--INSERT INTO @PageValues
--SELECT 
--	UserID,
--	FirstName,
--	MiddleName,
--	LastName,
--	BadgeNumber,
--	ActiveBit,
--	PersonelNumber
--FROM @Values
--WHERE
--	[BadgeNumber] LIKE COALESCE('%' + CAST(@BadgeNumber AS NVARCHAR(20)) + '%' ,[BadgeNumber])
--ORDER BY
-- CASE @OrderDirection WHEN 1 THEN
--	CASE
--	WHEN @OrderBy = 'UserID' THEN RANK()OVER (ORDER BY UserID)
--	WHEN @OrderBy = 'FirstName' THEN RANK()OVER (ORDER BY FirstName)
--	WHEN @OrderBy = 'Middlename' THEN RANK()OVER (ORDER BY Middlename)
--	WHEN @OrderBy = 'LastName' THEN RANK()OVER (ORDER BY LastName) 
--	WHEN @OrderBy = 'BadgeNumber' THEN RANK()OVER (ORDER BY BadgeNumber)
--	WHEN @OrderBy = 'ActiveBit' THEN RANK()OVER (ORDER BY ActiveBit)
--	WHEN @OrderBy = 'PersonelNumber' THEN RANK()OVER (ORDER BY PersonelNumber)
--	END 
--END ASC,
-- CASE @OrderDirection WHEN 0 THEN
--	CASE 
--	WHEN @OrderBy = 'UserID' THEN RANK()OVER (ORDER BY UserID)
--	WHEN @OrderBy = 'FirstName' THEN RANK()OVER (ORDER BY FirstName)
--	WHEN @OrderBy = 'Middlename' THEN RANK()OVER (ORDER BY Middlename)
--	WHEN @OrderBy = 'LastName' THEN RANK()OVER (ORDER BY LastName) 
--	WHEN @OrderBy = 'BadgeNumber' THEN RANK()OVER (ORDER BY BadgeNumber)
--	WHEN @OrderBy = 'ActiveBit' THEN RANK()OVER (ORDER BY ActiveBit)
--	WHEN @OrderBy = 'PersonelNumber' THEN RANK()OVER (ORDER BY PersonelNumber)
--	END 
--END DESC


-------------------------
----Now page on the file results
-------------------------

--SELECT
--	*
--FROM @PageValues
--WHERE
--	VID >= (@PageSize * @PageNumber)+ 1 AND
--    VID < (@PageSize * @PageNumber) + (@PageSize + 1)
