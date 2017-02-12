/*
COVER

DECLARE @VAR
SET
CONCATINATION

CONVERT(TYPE, VALUE)
CAST(VALUE AS TYPE)

SUBSTRING(VALUE,INDEX,COUNT)
LEN(VALUE)
REPLACE (VALUE, 'LOOK_FOR' , 'REPLACE_WITH')
CHARINDEX('LOOK_FOR', VALUE, (OPTIONAL) START_INDEX_LOCATION )  
*/

--------------------------
--Create a variable and populate the variable with the name of the first user using the following format
-- Format: { LastName, FirstName MiddleName }
--Then display the result of the variable with a column name as User Name
--------------------------


declare @phrase varchar(200);
declare @firstName varchar(200);
declare @lastName varchar(200);
declare @middleName varchar(200);

SELECT 
TOP 1 
 @firstName = u.FirstName,
 @lastName = u.LastName,
 @middleName = u.MiddleName
from [User] U



set @phrase ='Format: { LastName, FirstName MiddleName }'
set @phrase = REPLACE(@phrase, 'LastName', @lastName)
set @phrase = REPLACE(@phrase, 'FirstName', @firstName)
set @phrase = REPLACE(@phrase, 'MiddleName', @middleName)


select @phrase


--------------------------
--Return the LastName, FirstName and UserName
--Where UserName is in the following format
-- Format: { FirstInitial_LastName }
--------------------------
SELECT
Substring(U.FirstName, 1, 1) + '_'+ U.LastName AS [Username], 
from [User] U

--------------------------
--Return the LastName, FirstName and UserName
--Where UserName in the following format
-- Format: { FirstInitial_LastName_UserID }
--------------------------

SELECT
Substring(U.FirstName, 1, 1) +  '_' + U.LastName  + '_'+ CAST(U.UserID AS varchar(5)) AS [Username]
from [User] U

--------------------------
-- Extract the number within the following string 'UID_1000:DPT_AA'
-- Then divide the number by 50 and display the result
-- Name the result RESULT
--------------------------


declare @phrase varchar(200)
declare @lookFor varchar (200)
declare @number int
declare @result int

set @phrase = 'UID_1000:DPT_AA'
set @lookFor = '1000'

set @number = CAST( SUBSTRING(@phrase, CHARINDEX('1000', @phrase), LEN(@lookFor)) as int)
set @result = @number/50

select @result as [Result]

--------------------------
--Put each user name in a comma separated list with a format of FistName LastName,.....
--------------------------
declare @phrase as VARCHAR(MAX)

set @phrase = ''

select 
TOP 10
 @phrase = @phrase + ',' + U.FirstName + ' ' + U.LastName
from [User] U

set @phrase = Substring(@phrase, 2, Len(@phrase))

select @phrase
-- print(@phrase)

--------------------------
--Put the last 10 UserIDs in a comma separated list and then 
--display that List with no trailing comma
--------------------------
declare @phrase varchar(200)

set @phrase = ''
select TOP 10
@phrase = @phrase + ',' + CAST(U.UserID as varchar(10))
from [User] U
Order by U.UserID DESC

set @phrase = substring(@phrase, 2, len(@phrase))

print (@phrase)

--------------------------
--Put first 10 UserIDs in a comma separated list where the User has the third highest score 
--Also display the List with no trailing comma
--------------------------


--------------------------
-- Create a query that can extract three comma separated numbers and add the time numbers together and name the result ResultSum
-- For example '77,899,444' or '1,2,7890898'
--------------------------


--------------------------------
--Insert a ( and ) around all numbers in the following string
--'This is the 3rd time 55 people spoke 7 words to me in the last 10 days'
--In the end it should look like
--'This is the (3)rd time (55) people spoke (7) words to me in the last (10) days'
--------------------------------


--------------------------------
--Get all users that 
--	are not sharing a weapon 
--  that are assigned at least two weapons
--  that have qualified at least twice on a raining or snowing day. Note: to have qualified their score must be higher than the fifth highest average score
--  and that their over all average score is greater than 70
--  and display only their first, middle and last initial into one column
---------------------------------

