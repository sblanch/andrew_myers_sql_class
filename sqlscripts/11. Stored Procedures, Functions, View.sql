----------------------------
--Creating s Stored Procedure
----------------------------
--Syntax
CREATE PROCEDURE ProcedureName
	InputParametersHere
AS
BEGIN
    QueryGoesHere
END

--Example
ALTER PROCEDURE [dbo].[CreateUser]
	-- Add the parameters for the stored procedure here
	@BadgeNum int,
	@FirstName varchar(50),
	@MiddleName varchar(50) = NULL, --I don't have to pass this in
	@LastName varchar(50),
	@BadgeNumber int,
	@PersonelNumber nvarchar(50)
AS
BEGIN
    -- Insert statements for procedure here
	insert into [User]
	(FirstName, MiddleName, LastName, BadgeNumber, ActiveBit, PersonelNumber)
	values
	(@FirstName, ISNULL(@MiddleName,''), @LastName, @BadgeNum, 1, @PersonelNumber)
END

--Query
EXEC CreateUser @BadgeNum = 10, @FirstName = 'Blah', @LastName = 'Leo', @BadgeNumber = 1, @PersonelNumber = 'OIPI234'

SELECT * FROM [USER] WHERE PersonelNumber = 'OIPI234'
----------------------------
--Creating a non-index view
----------------------------
--Syntax
CREATE VIEW ViewName
 WITH SCHEMABINDING AS
	AddQueryHere

--Example
CREATE VIEW [dbo].[Top10Users]
 WITH SCHEMABINDING AS
SELECT TOP 10 UserID, FirstName, MiddleName, LastName, BadgeNumber, PersonelNumber
FROM  dbo.[User]
WHERE (ActiveBit = 1)
ORDER BY UserID DESC

--Query a View
SELECT * FROM [Top10Users]

----------------------------
--Creating an indexed view
----------------------------
--Syntax
CREATE VIEW ViewName
 WITH SCHEMABINDING AS
	AddQueryHere

CREATE UNIQUE CLUSTERED INDEX IndexName ON ViewName (ColumnNameToIndex)

--Example
CREATE VIEW NonActiveUsers
 WITH SCHEMABINDING AS
SELECT UserID, FirstName, MiddleName, LastName, BadgeNumber, PersonelNumber
FROM         dbo.[User]
WHERE     (ActiveBit = 0)
GO
CREATE UNIQUE CLUSTERED INDEX VNonActiveUsersInd ON NonActiveUsers (UserID)

--Query a View
SELECT * FROM NonActiveUsers

----------------------------
--Creating a Function
----------------------------
--Syntax
CREATE FUNCTION FunctionName
(
	InputTypesHere 
)  
RETURNS  
	ReturnName/TypeHere  
AS  
BEGIN  
      QueryThatPopulatesReturnTypeHere
END 

--Example
CREATE FUNCTION [dbo].Split1
(
	@input AS Varchar(4000) 
)  
RETURNS  
	@Result TABLE(Value BIGINT)  
AS  
BEGIN  
      DECLARE @str VARCHAR(20)  
      DECLARE @ind Int  

      IF(@input is not null)  
      BEGIN  
            SET @ind = CharIndex(',',@input)  
            WHILE @ind > 0  
            BEGIN  
                  SET @str = SUBSTRING(@input,1,@ind-1)  
                  SET @input = SUBSTRING(@input,@ind+1,LEN(@input)-@ind)  
                  INSERT INTO @Result values (@str)  
                  SET @ind = CharIndex(',',@input)  
            END  
            SET @str = @input  
            INSERT INTO @Result values (@str)  
      END  
      RETURN  
END 

--Query the Function
DECLARE @str VARCHAR(4000) = 
'6,7,7,8,10,12,13,14,16,44,46,47,394,396,417,488,714,717,718,719,722,725,811,818,832,833,836,837,846,913,914,919,922,923,924,925,926,927,927,928,929,929,930,931,932,934,935,1029,1072,1187,1188,1192,1196,1197,1199,1199,1199,1199,1200,1201,1202,1203,1204,1205,1206,1207,1208,1209,1366,1367,1387,1388,1666,1759,1870,2042,2045,2163,2261,2374,2445,2550,2676,2879,2880,2881,2892,2893,2894'  

DECLARE @Result TABLE(Value BIGINT)

INSERT INTO @Result
SELECT * FROM dbo.Split1 ( @str ) 

SELECT * FROM @Result