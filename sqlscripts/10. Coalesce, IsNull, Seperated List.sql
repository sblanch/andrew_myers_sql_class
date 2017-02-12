/*
WHAT YOU'LL NEED TO KNOW
------------------------
WHILE
COALESCE
ISNULL
*/

-------------------------
--Create a comma seperated list with all UserIDs with no ending coma using a COALESCE
-------------------------

-------------------------
--Create a comma seperated list with all UserIDs with no ending coma using an ISNULL
-------------------------

-------------------------
--Create a comma seperated list with all UserIDs with no ending coma without using a COALESCE or ISNULL
-------------------------

--------------------------
--Create a CSV file where each user name in a comma separated list with a format of (FistName LastName,)
--Also have 10 items for each row
-- Note: CHAR(13) + CHAR(10) is carriage return line feed
--------------------------

--------------------------
--Create a random list of 100 random first and last names
--The following functions may come in handy
--	CHARINDEX('LOOKFOR', VALUE)
--	SUBSTRING(VALUE,INDEX,COUNT)
--	LEN(VALUE)
--------------------------