------------
--Return first 100 Users where UserID is sorted ascending
------------
SELECT TOP 100 * FROM [User] ORDER BY [UserID]

--OR

SELECT TOP 100 * FROM [User] ORDER BY [UserID] asc
	q.[Date]
FROM [User] u
------------
--Return first 100 Users where UserID is descending
------------
SELECT TOP 100 * FROM [User] ORDER BY [UserID] desc

------------
--Return first 100 Users that have an active bit of 1 and the FirstName is sorted descending
------------
SELECT TOP 100 * FROM [User] WHERE [ActiveBit] = 1 ORDER BY [FirstName] desc

------------
--Return first 100 Users where the FirstName, MiddleName and LastName are sorted descending
------------
SELECT TOP 100 * FROM [User] ORDER BY [FirstName], [MiddleName], [LastName] desc

------------
--Return first 100 User that have a weapon assigned to them
------------
SELECT TOP 100 * 
FROM [User] u
INNER JOIN [UserToWeapon] uw ON u.UserID = uw.UserID

------------
--Return first 100 User and Weapon information of all Users that have a weapon assigned to them
------------
SELECT TOP 100 * 
FROM [User] u
INNER JOIN [UserToWeapon] uw ON u.UserID = uw.UserID
INNER JOIN [Weapon] w ON uw.WeaponID = w.WeaponID

------------
--Return first 100 User and Weapon information of all Users whether or not the user has a weapon assigned to them
------------

SELECT TOP 100 * 
FROM [User] u
LEFT JOIN [UserToWeapon] uw ON u.UserID = uw.UserID
INNER JOIN [Weapon] w ON uw.WeaponID = w.WeaponID

------------
--Return first 100 User and Weapon information of all Users and Weapons whether or not a user has a weapon and 
--whether or not a weapon is assigned to a user
------------

SELECT TOP 100 * 
FROM [User] u
LEFT JOIN [UserToWeapon] uw ON u.UserID = uw.UserID
RIGHT JOIN [Weapon] w ON uw.WeaponID = w.WeaponID

------------
--Return first 100 UserIDs and ModelNumber of all active Users
------------

SELECT TOP 100 u.[UserID], w.[ModelNumber] 
FROM [User] u
INNER JOIN [UserToWeapon] uw ON u.UserID = uw.UserID
INNER JOIN [Weapon] w ON uw.WeaponID = w.WeaponID

------------
--Return first 100 FirstName, Qualification Score and Qualification Date of each user that passed
------------
SELECT TOP 100 
	u.[FirstName], 
	q.[Score],
INNER JOIN [UserToQual] uq ON u.UserID = uq.UserID
INNER JOIN [Qual] q ON uq.QualID = q.QualID
WHERE q.[Pass] = 1

------------
--Show in Data Set one column that shows a unique list of all User.FirstName, TypeWeather.Name and TypeQual.Name and call it DBName
------------
SELECT [FirstName] AS [DBName]
FROM [User]

UNION

SELECT [Name] AS [DBName]
FROM [TypeWeather]

UNION

SELECT [Name] AS [DBName]
FROM [TypeQual]