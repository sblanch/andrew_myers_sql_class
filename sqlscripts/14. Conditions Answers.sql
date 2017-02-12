/*
WHAT YOU'LL NEED TO KNOW
------------------------

IF - ELSE IF - ELSE
EXISTS
*/

------------
--REVIEW
------------
--Divisable By %
--CHARINDEX('LOOKFOR', VALUE)
--SUBSTRING(VALUE,INDEX,COUNT)
--LEN(VALUE)

----------------------------------------------
-- Determine the number of user with and without a weapon
-- If with_count > without_count display "Quota Met"
-- Else display "Quota Not Met"
----------------------------------------------
DECLARE
	@UserWithWeaponCount INT,
	@UserWithOutWeaponCount INT

SET @UserWithWeaponCount = 
(	
	SELECT
		COUNT(U.UserID) AS UserWithWeaponCount
	FROM [User] U
	INNER JOIN UserToWeapon UW on UW.UserID = U.UserID
)

SET @UserWithOutWeaponCount =
(
	SELECT
		COUNT(U.UserID) AS UserWithOutWeaponCount
	FROM [User] U
	LEFT JOIN UserToWeapon UW on UW.UserID = U.UserID
	WHERE UW.WeaponID IS NULL
)

IF @UserWithWeaponCount > @UserWithOutWeaponCount
BEGIN
	print('Quota Met')
END
ELSE
BEGIN
	print('Quota Not Met')
END

----------------------------------------------
-- If a user with ID of 10 does not have a weapon then assign them a weapon not in use
-- If all weapons are in use then display "No Weapons Available"
----------------------------------------------
if exists(
	select U.UserID, UW.WeaponID
	from [User] U
	left join UserToWeapon UW on U.UserId = UW.UserID
	where U.UserID = 10 and UW.WeaponID is null
)
begin
	DECLARE @WeaponID INT
	SET @WeaponID = 
		(
			select top 1 W.WeaponID
			from Weapon W
			left join UserToWeapon UW on W.WeaponID = UW.WeaponID
			where UW.UserID is null --and 1 = 2
		)
	if @WeaponID is null
	begin
		print('No Weapons Available')
	end
	else
	begin	
		INSERT INTO [WeaponsQualifications].[dbo].[UserToWeapon]
			   ([WeaponID]
			   ,[UserID]
			   ,[CreateDate])
		 VALUES
			   (@WeaponID
			   ,10
			   ,Null)
	end
end

--delete FROM UserToWeapon WHERE UserID = 10
--select * from UserToWeapon WHERE UserID = 10

-------------------------------
-- For one of the users that have the greatest average score, assign them a weapon that is not in use.
-- If all weapons are in use then create a weapon in the weapon table and assign that weapon 
-- to the user.
-------------------------------
DECLARE 
	@UserID INT, @WeaponID INT

--Get the User with the Highest Avg Score
SELECT TOP 1
	@UserID = AQ.UserID
FROM
(
	--Get all Average Scores
	SELECT
		UQ.UserID,
		AVG(Score) as AvgScore
	FROM 
		UserToQual UQ
	INNER JOIN [Qual] Q on UQ.QualID = Q.QualID
	GROUP BY UQ.UserID
) AS AQ
ORDER BY AQ.AvgScore DESC

--Get at least one Weapon ID that is not in Use
SELECT TOP 1
	@WeaponID = W.WeaponID
FROM UserToWeapon UW
RIGHT JOIN Weapon W ON UW.WeaponID = W.WeaponID
WHERE UW.WeaponID IS NULL

--If no weapon ID is in use create a Weapon and get it's ID
IF (@WeaponID IS NULL) 
BEGIN
	INSERT INTO [WeaponsQualifications].[dbo].[Weapon]
           ([ModelNumber]
           ,[Make]
           ,[Caliber]
           ,[SerialNumber])
     VALUES
           ('ModelNumber-(256)'
           ,'Make-(256)'
           ,'Caliber-(256)'
           ,'SerialNumber-(256)')
     
     SET @WeaponID = (SELECT TOP 1 WeaponID FROM Weapon ORDER BY WeaponID DESC)  
END

--Assign the Weapon to the User with the highest average score
DECLARE @Date DateTime
SET @Date = GetUtcDate()

INSERT INTO [WeaponsQualifications].[dbo].[UserToWeapon]
           ([WeaponID]
           ,[UserID]
           ,[CreateDate])
        VALUES
           (@WeaponID
           ,@UserID
           ,@Date)