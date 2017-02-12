/*
SQL KEY WORDS

AS
ORDER BY
	DESC
	ASC
FULL JOIN
INNER JOIN
LEFT JOIN
RIGHT JOIN
	ON
UNION
UNION ALL
*/

------------
--Return first 100 Users where UserID is sorted ascending
------------
SELECT
  *
FROM
  [User]
ORDER BY [UserID] ASC;
------------
--Return first 100 Users where UserID is descending
------------
SELECT
  TOP 10
  *
FROM [User]
ORDER BY [UserID] DESC;



------------
--Return first 100 Users that have an active bit of 1 and the FirstName is
--sorted descending
------------

SELECT
  TOP 100
  *
FROM
  [USER]
WHERE
  [ActiveBit] = 1
ORDER BY FirstName DESC;

------------
--Return first 100 Users where the FirstName, MiddleName and LastName are
--sorted descending
------------
SELECT
  TOP 100
  *
FROM
  [USER]
WHERE
  [ActiveBit] = 1
ORDER BY FirstName DESC, MiddleName DESC, LastName DESC;


------------
--Return first 100 Users that have a weapon assigned to them
------------
SELECT
  TOP 100
  *
FROM
  [User] U  INNER JOIN

  (
    SELECT
      DISTINCT
      [UserId]
    FROM
      [UserToWeapon]
  ) UW
  ON U.UserID = UW.UserID


------------
--Return first 100 Users and Weapon information of all Users that have a weapon assigned
--to them
------------
SELECT
  TOP 100
  *
FROM
  [User] U INNER JOIN
  [UserToWeapon] UW
  ON U.UserID = UW.UserID INNER JOIN
  [Weapon] W
  ON UW.WeaponID = W.WeaponID



------------
--Return first 100 Users and Weapon information of all Users whether or not the user
--has a weapon assigned to them
------------

SELECT
  TOP 100
  *
FROM
  [UserToWeapon] UW INNER JOIN
  [Weapon] W
  ON Uw.WeaponID = W.WeaponID LEFT JOIN
  [User] U
  ON U.UserID = UW.UserID


------------
--Return first 100 Users and Weapon information of all Users and Weapons whether
--or not a user has a weapon and whether or not a weapon is assigned to a user
------------
/*
-- first try --
SELECT TOP 100 *
FROM [User] U
INNER JOIN [UserToWeapon] UW
on U.UserID = UW.UserID
FULL JOIN [Weapon] W
ON Uw.WeaponID = W.WeaponID
--
--This is wrong.

Think of these two separate queries

SELECT TOP 100 * INTO #a
FROM [User] U
LEFT JOIN [UserToWeapon] UW
on U.UserID = UW.UserID


SELECT TOP 100 *
FROM [UserToWeapon] UW
RIGHT JOIN [Weapon] W
on UW.WeaponID = W.WeaponID

Then just combine them. UserWeapon is the middle table.

Says you can do a full join between user and UserWeapon and then a full join with Weapons. I think this is wrong,
in that it doesn't work the same in every case.

*/

SELECT TOP 100 *
FROM [User] U
LEFT JOIN [UserToWeapon] UW
ON U.UserID = UW.UserID
RIGHT JOIN [Weapon] W
ON UW.WeaponID = W.WeaponID

------------
--Return first 100 UserIDs and their Weapon ModelNumber of all active Users
------------
SELECT TOP 100 U.UserID, W.ModelNumber
FROM [User] U
INNER JOIN [UserToWeapon] UW
ON U.UserID = UW.UserID
INNER JOIN [Weapon] W
ON UW.WeaponID = W.WeaponID
WHERE U.ActiveBit = 1



------------
--Return first 100 FirstName, Qualification Score and Qualification Date of each
--user that passed
------------
SELECT TOP 100 U.Firstname, Q.Score, Q.Date
FROM [User] U
INNER JOIN [UserToQual] UQ
ON U.UserId = UQ.UserID
INNER JOIN [Qual] Q
ON UQ.QualID = Q.QualID
WHERE Q.Pass = 1


------------
--Show in Data Set one column that shows a unique list of all User.FirstName,
--TypeWeather.Name and TypeQual.Name and call it DBName
------------

SELECT Distinct
  U.FirstName AS DbName
FROM [User] U

UNION

SELECT Distinct
  TW.Name AS DbName
FROM [TypeWeather] TW

UNION

Select Distinct
  TQ.Name As DbName
From [TypeQual] TQ

