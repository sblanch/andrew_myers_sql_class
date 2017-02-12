--------------------------
--Create a list of 100 random first and last names
--------------------------
declare
	@Names table ( Name varchar(50) )
declare
	@FirstNameCnter int,
	@FirstNameIndex int,
	@LastNameCnter int,
	@LastNameIndex int,
	@FirstNameList varchar(1000),
	@FirstName varchar(20),
	@LastNameList varchar(1000),
	@LastNamePreserve varchar(1000),
	@LastName varchar(20)
	
set @FirstNameList = 'Andrew,Jared,Mike,Eddie,John,Sally,Suzzy,Misty,Mary,Hiedi'
set @LastNameList = 'Myers,Lam,McConkie,Smith,Johnson,Anderson,McBride,Lee,Grim,Quakenthebush'
set @LastNamePreserve = @LastNameList
set @FirstNameCnter = 10
set @FirstNameIndex = 0
set @LastNameIndex = 0

--Create 100 unique names
while (@FirstNameCnter > 0)
begin
	--Get the next first name
	set @FirstNameIndex = CHARINDEX(',', @FirstNameList);
	if(@FirstNameIndex = 0)
	begin
		set @FirstName = @FirstNameList
		set @FirstNameList = ''
	end
	else
	begin		
		set @FirstName = SUBSTRING(@FirstNameList,0,@FirstNameIndex)
		set @FirstNameList = SUBSTRING(@FirstNameList, @FirstNameIndex + 1, 1000);
	end

	--Set each first name with a last name
	set @LastNameList = @LastNamePreserve
	set @LastNameCnter = 10
	
	while (@LastNameCnter > 0)
	begin
		--Get the next last name
		set @LastNameIndex = CHARINDEX(',', @LastNameList);
		if(@LastNameIndex = 0)
		begin
			set @LastName = @LastNameList
			set @LastNameList = ''
		end
		else
		begin		
			set @LastName = SUBSTRING(@LastNameList,0,@LastNameIndex)
			set @LastNameList = SUBSTRING(@LastNameList, @LastNameIndex + 1, 1000);
		end
		
		insert into @Names
		select @LastName + ',' + @FirstName
		
		--Decrement the counter
		set @LastNameCnter = @LastNameCnter - 1
	end
	
	--Decrement the counter
	set @FirstNameCnter = @FirstNameCnter - 1
end

select * from @Names

------------------------------
--SELECT 
--	w.*
--FROM [User] u
--inner join UserToWeapon uw on u.UserID = uw.UserID
--inner join Weapon w on uw.WeaponID = w.WeaponID

declare @ResultSet table
(
	[WeaponID] [int],
	[ModelNumber] [nvarchar](256),
	[Make] [nvarchar](256),
	[Caliber] [nvarchar](256),
	[SerialNumber] [nvarchar](256)
)
	
declare 
	@UserCnt int,
	@UserID int,
	@UWCnt int, @UWCntSave int,
	@WeaponID int,
	@UWUserID int,
	@UWWeaponID int,
	@WCnt int, @WCntSave int
	
declare
	@TUserToWeapon Table (
	UWIndex int Identity (1,1), 
	UserID int, 
	WeaponID int)	
Insert into @TUserToWeapon
select UserId, WeaponId from UserToWeapon
order by UserID asc

set @UserCnt = (select count(UserID) from [User] where userID < 10)
set @UWCntSave = (select count(UserID) from [UserToWeapon])
set @WCntSave = (select count(WeaponId) from [Weapon])

while (@UserCnt > 0)
	begin
		--Get the u.UserID
		set @UserID = (select UserID from [User] where UserID = @UserCnt)
		if @UserID is not null
			begin
				set @UWCnt = @UWCntSave
				while (@UWCnt > 0)
					begin
						--Get the uw.UserID that matches the u.UserID
						set @UWUserID = (select UserID from @TUserToWeapon where UWIndex = @UWCnt)
						if(@UWUserID = @UserID)
						begin
							--Get the uw.WeaponID that is at uw.UWIndex that matches @UWCnt
							set @UWWeaponID = (select WeaponId from @TUserToWeapon where UWIndex = @UWCnt)
							set @WCnt = @WCntSave
							while(@WCnt > 0)
							begin
								--Get each w.WeaponID
								set @WeaponID = (Select WeaponId from Weapon where WeaponId = @WCnt)
								
								---Determine if w.WeaponId is equal to @UWWeaponID and if so add results to dataset table
								if(@WeaponID = @UWWeaponID)
								begin
									insert into @ResultSet
									select * from Weapon where WeaponID = @WeaponID
								end
								
								set @WCnt = @WCnt - 1
							end							
						end
						set @UWCnt = @UWCnt - 1
					end
			end
		set @UserCnt = @UserCnt-1
	end

select * from @ResultSet