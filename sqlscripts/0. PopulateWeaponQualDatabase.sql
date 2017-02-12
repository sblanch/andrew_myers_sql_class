USE WeaponsQualifications

DECLARE
	@NumOf int
SET @NumOf = 1000;

-----------------------
---- CREATE WEAPONS
-----------------------
DECLARE
	@Count int,
	@ModelNumber nvarchar(256),
	@SerialNumber nvarchar(256),
	@Make nvarchar(256);

SET @Count = @NumOf;

WHILE(@Count > 0)
BEGIN
	SET @ModelNumber = '245' + CAST(@Count AS varchar(100));
	SET @SerialNumber = '999' + CAST(@Count AS varchar(100));
	
	IF((@Count % 5) = 0)
	BEGIN
		SET @Make = ('Long Rifle ');
		EXEC CreateWeapon
		@Model = @ModelNumber,
		@Make = @Make,
		@Caliber = '.22',
		@SerialNumber = @SerialNumber;
	END
	
	ELSE IF((@Count % 3) = 0)
	BEGIN
		SET @Make = ('M2 ');
		EXEC CreateWeapon
		@Model = @ModelNumber,
		@Make = @Make,
		@Caliber = '.30',
		@SerialNumber = @SerialNumber;
	END
	ELSE IF((@Count % 2) = 0)
	BEGIN
		SET @Make = ('Magnum ');
		EXEC CreateWeapon
		@Model = @ModelNumber,
		@Make = @Make,
		@Caliber = '.44',
		@SerialNumber = @SerialNumber;
	END
	ELSE
	BEGIN
		SET @Make = ('Remington ');
		EXEC CreateWeapon
		@Model = @ModelNumber,
		@Make = @Make,
		@Caliber = '.222',
		@SerialNumber = @SerialNumber;
	END
	SET @Count = @Count -1;
END

---------------------
-- CREATE USERS
---------------------
DECLARE
	@FirstName nvarchar(50),
	@MiddleName nvarchar(50),
	@LastName nvarchar(50),
	@BadgeNumber int,
	@PersonelNumber varchar(50);

DECLARE @FirstNames TABLE (ID INT IDENTITY(1,1), Name VARCHAR(30) )
DECLARE @FNCount INT
DECLARE @MiddleNames TABLE (ID INT IDENTITY(1,1), Name VARCHAR(30) )
DECLARE @MNCount INT
DECLARE @LastNames TABLE (ID INT IDENTITY(1,1), Name VARCHAR(30) )
DECLARE @LNCount INT

INSERT INTO @FirstNames VALUES
('Aaron'),('Andrew'), ('Anna'), ('Amy'), ('Alex'), ('Audrey'), ('Betty'), ('Breney'), ('Brett'), ('Brian'), ('Brock'), ('Bruce'), ('Broody'), ('Brittney'), ('Becky'), ('Cathey'), ('Carry'), ('Cindy'), ('Darren'), ('Dick'), ('Edward'), ('Erin'), ('Elias'), ('Elijah'), ('Frances'), ('Fred'), ('George'), ('Grace'), ('Hiedi'), ('Helda'), ('Heinrich'), ('Henry'), ('Issac'), ('Irean'), ('Jordan'), ('Jared'), ('James'), ('Jessica'), ('Jessy'), ('Josh'), ('Katlyn'), ('Kathy'), ('Kasy'), ('Leo'), ('Larry'), ('Lucy'), ('Leke'), ('Mathew'), ('Mark'), ('Megan'), ('Morgan'), ('Micheal'), ('Mike'), ('Molly'), ('Maria'), ('Melisa'), ('Marleah'), ('Nacey'), ('Nick'), ('Oscar'), ('Owen'), ('Peter'), ('Patty'), ('Patricia'), ('Patrich'), ('Quin'), ('Rick'), ('Renna'), ('Ron'), ('Rodney'), ('Rachel'), ('Stacey'), ('Steve'), ('Sally'), ('Stephany'), ('Stacey'), ('Tracey'), ('Teriance'), ('Todd'), ('Timothy'), ('Tim'), ('Uber'), ('Victor'), ('Victoria'), ('William'), ('Wesley'), ('Willma'), ('Xzar'), ('Yem'), ('Zack')
SELECT @FNCount = COUNT(Name) FROM @FirstNames

INSERT INTO @MiddleNames VALUES
('A'),('B'), ('C'), ('D'), ('E'), ('F'), ('G'), ('H'), ('I'),('J'),('K'), ('L'), ('M'), ('N'), ('O'), ('P'), ('R'), ('S'),('T'),('V'), ('W'), ('Z')
SELECT @MNCount = COUNT(Name) FROM @MiddleNames

INSERT INTO @LastNames VALUES
('Anderson'),('Matemate'), ('Davis'), ('Davidson'), ('Myers'), ('Stevenson'), ('McDonalds'),('Brides'), ('Muhn'), ('Jones'), ('Perisons'), ('Henrys'), ('Madison'), ('Arthurs'), ('Blakes'), ('Hills'), ('Bakers')
SELECT @LNCount = COUNT(Name) FROM @LastNames

SET @Count = @FNCount * @MNCount * @LNCount;

DECLARE @i1 INT, @i2 INT, @i3 INT
SET @i1 = 1
SET @i2 = 1
SET @i3 = 1

WHILE(@Count > 0)
BEGIN
	
	IF(@i1 = @FNCount - 1)
	BEGIN
		SET @i1 = 1
		SET @i2 = @i2 + 1
		IF(@i2 = @LNCount - 1)
		BEGIN
			SET @i2 = 1
			SET @i3 = @i3 + 1
			IF(@i3 = @MNCount - 1)
			BEGIN
				SET @i3 = 1
			END
		END
	END
	
	SELECT @FirstName = NAME FROM @FirstNames WHERE ID = @i1;
	SELECT @MiddleName = NAME FROM @MiddleNames WHERE ID = @i3;
	SELECT @LastName = NAME FROM @LastNames WHERE ID = @i2; 
	
	SET @i1 = @i1 + 1
	SET @PersonelNumber = 'PN:777' + CAST(@Count AS varchar(100));
	
	IF((@Count % 5) = 0)
	BEGIN	 
		SET @BadgeNumber = @Count * 50;
		EXEC CreateUser
		@BadgeNum = @BadgeNumber,
		@FirstName = @FirstName,
		@MiddleName = @MiddleName,
		@LastName = @LastName,
		@BadgeNumber = @BadgeNumber,
		@PersonelNumber = @PersonelNumber;
	END
	
	ELSE IF((@Count % 3) = 0)
	BEGIN
		SET @BadgeNumber = @Count * 30;
		EXEC CreateUser
		@BadgeNum = @BadgeNumber,
		@FirstName = @FirstName,
		@MiddleName = @MiddleName,
		@LastName = @LastName,
		@BadgeNumber = @BadgeNumber,
		@PersonelNumber = @PersonelNumber;
	END
	ELSE IF((@Count % 2) = 0)
	BEGIN
		SET @BadgeNumber = @Count * 20;
		EXEC CreateUser
		@BadgeNum = @BadgeNumber,
		@FirstName = @FirstName,
		@MiddleName = @MiddleName,
		@LastName = @LastName,
		@BadgeNumber = @BadgeNumber,
		@PersonelNumber = @PersonelNumber;
	END
	ELSE
	BEGIN
		SET @BadgeNumber = @Count * 10;
		EXEC CreateUser
		@BadgeNum = @BadgeNumber,
		@FirstName = @FirstName,
		@MiddleName = @MiddleName,
		@LastName = @LastName,
		@BadgeNumber = @BadgeNumber,
		@PersonelNumber = @PersonelNumber;
	END
	SET @Count = @Count -1;
END

--------------------
-- ADD USERS TO WEAPONS
--------------------
SET @Count = @NumOf;

WHILE(@Count > 0)
BEGIN
	SET @BadgeNumber = (SELECT BadgeNumber FROM [USER] WHERE [UserID] = @Count);
	SET @SerialNumber = (SELECT SerialNumber FROM [WEAPON] WHERE [WeaponID] = @Count);
	
	IF((@Count % 5) <> 0)
	BEGIN	 
		EXEC AddUserToWeapon
			@BadgeNum = @BadgeNumber,
			@SerialNumber = @SerialNumber;
	END
	
	SET @Count = @Count -1;
END

----------------------
-- ADD USERS TO QUALIFICATION
/*
TypeWeatherID	Name
1	Clear
2	Cloudy
3	Foggy
4	Raining
5	Snowing
6	Windy
7	NA

TypeQualID	Name
1	Day
2	Low Light
3	Off Duty
4	Shotgun
5	Rifle
*/
----------------------
DECLARE 
	@Date DATETIME;

SET @Count = @NumOf;
SET @Date = GetUTCDate();

WHILE(@Count > 0)
BEGIN
	SET @PersonelNumber = (SELECT PersonelNumber FROM [USER] WHERE [UserID] = @Count);

	IF((@Count % 7) = 0)
	BEGIN	 
		EXEC AddQualToUser
			@PersonelNumber = @PersonelNumber,
			@WeatherType = 'NA',
			@QualType = 'Day',
			@Date = @Date,
			@Outdoor = 1,
			@Temp = '8',
			@Score = 90,
			@Pass = 1;
	END
	
	ELSE IF((@Count % 6) = 0)
	BEGIN	 
		EXEC AddQualToUser
			@PersonelNumber = @PersonelNumber,
			@WeatherType = 'Windy',
			@QualType = 'Day',
			@Date = @Date,
			@Outdoor = 1,
			@Temp = '7',
			@Score = 67,
			@Pass = 0
	END
	
	ELSE IF((@Count % 5) = 0)
	BEGIN	 
		EXEC AddQualToUser
			@PersonelNumber = @PersonelNumber,
			@WeatherType = 'Snowing',
			@QualType = 'Rifle',
			@Date = @Date,
			@Outdoor = 1,
			@Temp = '3',
			@Score = 82,
			@Pass = 1
	END
	
	ELSE IF((@Count % 4) = 0)
	BEGIN	 
		EXEC AddQualToUser
			@PersonelNumber = @PersonelNumber,
			@WeatherType = 'Raining',
			@QualType = 'Shotgun',
			@Date = @Date,
			@Outdoor = 1,
			@Temp = '6',
			@Score = 70,
			@Pass = 0
	END
	
	ELSE IF((@Count % 3) = 0)
	BEGIN	 
		EXEC AddQualToUser
			@PersonelNumber = @PersonelNumber,
			@WeatherType = 'Foggy',
			@QualType = 'Off Duty',
			@Date = @Date,
			@Outdoor = 1,
			@Temp = '6',
			@Score = 53,
			@Pass = 0
	END
	
	ELSE IF((@Count % 2) = 0)
	BEGIN	 
		EXEC AddQualToUser
			@PersonelNumber = @PersonelNumber,
			@WeatherType = 'Cloudy',
			@QualType = 'Low Light',
			@Date = @Date,
			@Outdoor = 1,
			@Temp = '8',
			@Score = 86,
			@Pass = 1
	END
	
	ELSE IF((@Count % 1) = 0)
	BEGIN	 
		EXEC AddQualToUser
			@PersonelNumber = 'PN:7771000', --@PersonelNumber,
			@WeatherType = 'Clear',
			@QualType = 'Day',
			@Date = @Date,
			@Outdoor = 1,
			@Temp = '9',
			@Score = 97,
			@Pass = 1
	END
	
	SET @Count = @Count -1;
END