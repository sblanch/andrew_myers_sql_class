--DROP Database [WeaponsQualifications]
--go
Create Database [WeaponsQualifications]
go

USE [WeaponsQualifications]

--Lookup table
CREATE TABLE [TypeWeather]
(
	[TypeWeatherID] INT PRIMARY KEY IDENTITY (1, 1) NOT NULL,
	[Name] NVARCHAR(256) UNIQUE NOT NULL
)

--Lookup table
CREATE TABLE [TypeQual]
(
	[TypeQualID] INT PRIMARY KEY IDENTITY (1, 1) NOT NULL,
	[Name] NVARCHAR(256) UNIQUE NOT NULL
)

CREATE TABLE [User]
(
	[UserID] INT PRIMARY KEY IDENTITY (1, 1) NOT NULL,
	[FirstName] NVARCHAR(256) NOT NULL,
	[MiddleName] NVARCHAR(256) NOT NULL,
	[LastName] NVARCHAR(256) NOT NULL,
	[BadgeNumber] int NOT NULL,
	[ActiveBit] bit	DEFAULT (1),
	[PersonelNumber] NVARCHAR(256) NOT NULL
	--Ask John about the PersonelNumber Name and availability
)

CREATE TABLE [Weapon]
(
	[WeaponID] INT PRIMARY KEY IDENTITY (1, 1) NOT NULL,
	[ModelNumber] NVARCHAR(256) NOT NULL,
	[Make] NVARCHAR(256) NOT NULL,
	[Caliber] NVARCHAR(256) NOT NULL,
	[SerialNumber] NVARCHAR(256)UNIQUE NOT NULL
)

CREATE TABLE [UserToWeapon]
(
	[WeaponID] INT NOT NULL,
	[UserID] INT NOT NULL,
	[CreateDate] Datetime
)

ALTER TABLE [UserToWeapon]
ADD CONSTRAINT [UserForeignKey]
FOREIGN KEY (UserID) 
REFERENCES [User] (UserID) 
ON DELETE CASCADE 
ON UPDATE NO ACTION
GO

ALTER TABLE [UserToWeapon]
ADD CONSTRAINT [WeaponForeignKey]
FOREIGN KEY (WeaponID) 
REFERENCES [Weapon] (WeaponID) 
ON DELETE NO ACTION 
ON UPDATE NO ACTION
GO

CREATE TABLE [Qual]
(
	[QualID] INT PRIMARY KEY IDENTITY (1, 1) NOT NULL,
	[TypeQualID] int NOT NULL,
	[TypeWeatherID] int NULL,
	[Date] Datetime NOT NULL,
	[Outdoor] bit NOT NULL,
	[Temp] nvarchar NOT NULL,
	[Score] int NOT NULL,
	[Pass] bit NOT NULL
)

ALTER TABLE [Qual]
ADD CONSTRAINT [QualTypeForeignKey]
FOREIGN KEY (TypeQualID) 
REFERENCES [TypeQual] (TypeQualID) 
ON DELETE CASCADE 
ON UPDATE NO ACTION
GO

ALTER TABLE [Qual]
ADD CONSTRAINT [TypeWeatherForeignKey]
FOREIGN KEY (TypeWeatherID) 
REFERENCES [TypeWeather] (TypeWeatherID) 
ON DELETE NO ACTION 
ON UPDATE NO ACTION
GO

CREATE TABLE [UserToQual]
(
	[UserID] int NOT NULL,
	[QualID] int NOT NULL
)

ALTER TABLE [UserToQual]
ADD CONSTRAINT [UserQForeignKey]
FOREIGN KEY (UserID) 
REFERENCES [User] (UserID) 
ON DELETE CASCADE 
ON UPDATE NO ACTION
GO

ALTER TABLE [UserToQual]
ADD CONSTRAINT [QualForeignKey]
FOREIGN KEY (QualID) 
REFERENCES [Qual] (QualID) 
ON DELETE NO ACTION 
ON UPDATE NO ACTION
GO

--Insert data into the Look Up tables
if Not Exists(select [Name] from [TypeWeather] where [Name] = 'Clear')
begin
	insert into TypeWeather 
	(Name) values ('Clear') --1
end
if Not Exists(select [Name] from [TypeWeather] where [Name] = 'Cloudy')
begin
	insert into TypeWeather 
	(Name) values ('Cloudy') --2
end
if Not Exists(select [Name] from [TypeWeather] where [Name] = 'Foggy')
begin
	insert into TypeWeather 
	(Name) values ('Foggy') --3
end
if Not Exists(select [Name] from [TypeWeather] where [Name] = 'Raining')
begin
	insert into TypeWeather 
	(Name) values ('Raining') --4
end
if Not Exists(select [Name] from [TypeWeather] where [Name] = 'Snowing')
begin
	insert into TypeWeather 
	(Name) values ('Snowing') --5
end
if Not Exists(select [Name] from [TypeWeather] where [Name] = 'Windy')
begin
	insert into TypeWeather 
	(Name) values ('Windy') --6
end
if Not Exists(select [Name] from [TypeWeather] where [Name] = 'NA')
begin
	insert into TypeWeather 
	(Name) values ('NA') --7
end
-- ------------------
if Not Exists(select [Name] from [TypeQual] where [Name] = 'Day')
begin
	insert into TypeQual 
	(Name) values ('Day') --1
end

if Not Exists(select [Name] from [TypeQual] where [Name] = 'Low Light')
begin
	insert into TypeQual 
	(Name) values ('Low Light') --2
end

if Not Exists(select [Name] from [TypeQual] where [Name] = 'Off Duty')
begin
	insert into TypeQual 
	(Name) values ('Off Duty') --3
end

if Not Exists(select [Name] from [TypeQual] where [Name] = 'Shotgun')
begin
	insert into TypeQual 
	(Name) values ('Shotgun') --4
end

if Not Exists(select [Name] from [TypeQual] where [Name] = 'Rifle')
begin
	insert into TypeQual 
	(Name) values ('Rifle') --5
end

GO
CREATE PROCEDURE [dbo].[AddQualToUser]
	-- Add the parameters for the stored procedure here
	@PersonelNumber nvarchar(256),
	@WeatherType nvarchar(256),
	@QualType nvarchar(256),
	@Date Datetime,
	@Outdoor bit,
	@Temp nvarchar(20),
	@Score int,
	@Pass bit
AS
BEGIN
	Declare
		@UserID int,
		@QualTypeID int,
		@WeatherTypeID int,
		@QualID int
		
	Select @UserID = UserID from [User] where PersonelNumber = @PersonelNumber
	Select @WeatherTypeID = TypeWeatherID from [TypeWeather] where Name = @WeatherType
	Select @QualTypeID = TypeQualID from [TypeQual] where Name = @QualType
	
	Insert into Qual (TypeQualID, TypeWeatherID, [Date], Outdoor, Temp, Score, Pass)
	values (@QualTypeID, @WeatherTypeID, @Date, @Outdoor, @Temp, @Score, @Pass)
	
	set @QualID = @@IDENTITY
	
	Insert into UserToQual (UserID, QualID)
	values (@UserID, @QualID)
END

Go
Create PROCEDURE [dbo].[AddUserToWeapon]
	-- Add the parameters for the stored procedure here
	@BadgeNum varchar(50),
	@SerialNumber varchar(50)
AS
BEGIN

DECLARE
	@WeaponID int,
	@UserID int,
	@Date datetime
	
	Set @Date = GetUTCDate();
 
	Select @UserID = [UserID] 
	from [User] 
	where BadgeNumber = @BadgeNum

	Select @WeaponID = [WeaponID] 
	from [Weapon] 
	where SerialNumber = @SerialNumber
  
    -- Insert statements for procedure here
	insert into [UserToWeapon]
	(WeaponID, UserID, CreateDate)
	values
	(@WeaponID, @UserID, @Date)
END

Go
Create PROCEDURE [dbo].[CreateUser]
	-- Add the parameters for the stored procedure here
	@BadgeNum int,
	@FirstName varchar(50),
	@MiddleName varchar(50),
	@LastName varchar(50),
	@BadgeNumber int,
	@PersonelNumber nvarchar(50)
AS
BEGIN
    -- Insert statements for procedure here
	insert into [User]
	(FirstName, MiddleName, LastName, BadgeNumber, ActiveBit, PersonelNumber)
	values
	(@FirstName, @MiddleName, @LastName, @BadgeNum, 1, @PersonelNumber)
END

Go
Create PROCEDURE [dbo].[CreateWeapon]
	-- Add the parameters for the stored procedure here
	@Model varchar(50),
	@Make varchar(50),
	@Caliber varchar(50),
	@SerialNumber varchar(50)
AS
BEGIN
    -- Insert statements for procedure here
	insert into [Weapon]
	(ModelNumber, Make, Caliber, SerialNumber)
	values
	(@Model, @Make, @Caliber, @SerialNumber)
END