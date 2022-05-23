--https://generatedata.com/generator

SET NOCOUNT ON;

/**********************************************************************************************************************
** Set Variables
**********************************************************************************************************************/
DECLARE
    @MinimumHouseNumber  int     = 1
   ,@MaximumHouseNumber  int     = 10000
   ,@TotalHouseNumbers   int     = 10000
   ,@PercentNullForLine2 tinyint = 90;

/**********************************************************************************************************************
** House Numbers
**********************************************************************************************************************/
DROP TABLE IF EXISTS #HouseNumber;
CREATE TABLE #HouseNumber (HouseNumberId int IDENTITY(1, 1), HouseNumber int NULL);

INSERT INTO #HouseNumber (HouseNumber)
SELECT
    R.RandomNumber
FROM (
    SELECT TOP (@TotalHouseNumbers)
        RandomNumber = FLOOR(CAST(CRYPT_GEN_RANDOM(4) AS bigint) / 4294967296 * ((@MaximumHouseNumber - @MinimumHouseNumber) + 1)) + @MinimumHouseNumber
    FROM
        sys.all_objects            AS AO1
        CROSS JOIN sys.all_objects AS AO2
) AS R
WHERE
    NOT EXISTS (
    SELECT
        AHN.HouseNumber
    FROM
        #HouseNumber AS AHN
    WHERE
        AHN.HouseNumber = R.RandomNumber
);

/**********************************************************************************************************************
** Cardinal and Ordinal Directions
**********************************************************************************************************************/
DROP TABLE IF EXISTS #Direction;
CREATE TABLE #Direction (DirectionId int IDENTITY(1, 1), Direction nvarchar(10) NULL);

INSERT INTO #Direction (Direction)
VALUES
    (N'North')
   ,(N'Northern')
   ,(N'East')
   ,(N'Eastern')
   ,(N'West')
   ,(N'Western')
   ,(N'South')
   ,(N'Southern');

DECLARE @i int;
SET @i = 1;

WHILE (@i <= 25)
    BEGIN
        INSERT INTO #Direction (Direction) VALUES (NULL);
        SET @i = @i + 1;
    END;

/**********************************************************************************************************************
** Street Names 1st Segment
**********************************************************************************************************************/
DROP TABLE IF EXISTS #StreetName1;
CREATE TABLE #StreetName1 (StreetName1Id int IDENTITY(1, 1), StreetName1 nvarchar(100) NULL);
INSERT INTO #StreetName1 (StreetName1)
VALUES
    (N'Green')
   ,(N'White')
   ,(N'Black')
   ,(N'Gray')
   ,(N'Blue')
   ,(N'Red')
   ,(N'Old')
   ,(N'New')
   ,(N'Rocky');

SET @i = 1;

WHILE (@i <= 25)
    BEGIN
        INSERT INTO #StreetName1 (StreetName1) VALUES (NULL);
        SET @i = @i + 1;
    END;

/**********************************************************************************************************************
** Street Names 2nd Segment
**********************************************************************************************************************/
DROP TABLE IF EXISTS #StreetName2;
CREATE TABLE #StreetName2 (StreetName2Id int IDENTITY(1, 1), StreetName2 nvarchar(100) NULL);
INSERT INTO #StreetName2 (StreetName2)
VALUES
    (N'Nobel')
   ,(N'Fabien')
   ,(N'Hague')
   ,(N'Oak')
   ,(N'Dogwood')
   ,(N'Pine')
   ,(N'Spruce')
   ,(N'Birch')
   ,(N'Willow')
   ,(N'Cedar')
   ,(N'Elm')
   ,(N'Hemlock')
   ,(N'Maple')
   ,(N'Cypress')
   ,(N'Redwood')
   ,(N'Aspen')
   ,(N'Walnut')
   ,(N'Hickory')
   ,(N'Sycamore')
   ,(N'Cowley')
   ,(N'Clarendon')
   ,(N'First')
   ,(N'1st')
   ,(N'Second')
   ,(N'2nd')
   ,(N'Third')
   ,(N'3rd')
   ,(N'Fourth')
   ,(N'4th')
   ,(N'Park')
   ,(N'Fifth')
   ,(N'5th')
   ,(N'Sixth')
   ,(N'6th')
   ,(N'Main')
   ,(N'Palo Verde')
   ,(N'Sunset')
   ,(N'Lake')
   ,(N'Ridge')
   ,(N'Hillside')
   ,(N'Washington')
   ,(N'Jefferson')
   ,(N'Madison')
   ,(N'Monroe')
   ,(N'Adams')
   ,(N'Jackson')
   ,(N'Van Buren')
   ,(N'Harrison')
   ,(N'Tyler')
   ,(N'Polk')
   ,(N'Taylor')
   ,(N'Fillmore')
   ,(N'Pierce')
   ,(N'Buchanan')
   ,(N'Lincoln')
   ,(N'Grant')
   ,(N'Hayes')
   ,(N'Garfield')
   ,(N'Arthur')
   ,(N'Cleveland')
   ,(N'McKinley')
   ,(N'Roosevelt')
   ,(N'Taft')
   ,(N'Wilson')
   ,(N'Harding')
   ,(N'Coolidge')
   ,(N'Hoover')
   ,(N'Truman')
   ,(N'Eisenhower')
   ,(N'Kennedy')
   ,(N'Johnson')
   ,(N'Nixon')
   ,(N'Ford')
   ,(N'Carter')
   ,(N'Reagan')
   ,(N'Milton')
   ,(N'Lee')
   ,(N'Magnolia');

/**********************************************************************************************************************
** Street Types
**********************************************************************************************************************/
DROP TABLE IF EXISTS #StreetType;
CREATE TABLE #StreetType (StreetTypeId int IDENTITY(1, 1), StreetType nvarchar(100) NULL);
INSERT INTO #StreetType (StreetType)
VALUES
    (N'Way')
   ,(N'Street')
   ,(N'St.')
   ,(N'Avenue')
   ,(N'Ave.')
   ,(N'Av.')
   ,(N'Road')
   ,(N'Rd.')
   ,(N'Parkway')
   ,(N'Freeway')
   ,(N'Drive')
   ,(N'Dr.')
   ,(N'Boulevard')
   ,(N'Blvd.')
   ,(N'Lane')
   ,(N'Ln.')
   ,(N'Bay')
   ,(N'Grove')
   ,(N'Heights')
   ,(N'Place')
   ,(N'Pond')
   ,(N'Circle')
   ,(N'Hill')
   ,(N'Trail')
   ,(N'Trl.');

/**********************************************************************************************************************
** Address Line 2
**********************************************************************************************************************/
DROP TABLE IF EXISTS #Line2;
CREATE TABLE #Line2 (Line2Id int IDENTITY(1, 1), Line2 nvarchar(100) NULL);
INSERT INTO #Line2 (Line2)
VALUES
    (N'1st Floor')
   ,(N'2nd Floor')
   ,(N'3rd Floor')
   ,(N'4th Floor')
   ,(N'5th Floor')
   ,(N'6th Floor')
   ,(N'7th Floor')
   ,(N'8th Floor')
   ,(N'9th Floor')
   ,(N'10th Floor')
   ,(N'11th Floor')
   ,(N'12th Floor')
   ,(N'13th Floor')
   ,(N'14th Floor')
   ,(N'15th Floor')
   ,(N'16th Floor')
   ,(N'17th Floor')
   ,(N'18th Floor')
   ,(N'19th Floor')
   ,(N'20th Floor')
   ,(N'21st Floor')
   ,(N'22nd Floor')
   ,(N'23rd Floor')
   ,(N'24th Floor')
   ,(N'25th Floor')
   ,(N'26th Floor')
   ,(N'27th Floor')
   ,(N'28th Floor')
   ,(N'29th Floor')
   ,(N'30th Floor')
   ,(N'31st Floor')
   ,(N'32nd Floor')
   ,(N'33rd Floor')
   ,(N'34th Floor')
   ,(N'35th Floor')
   ,(N'36th Floor')
   ,(N'37th Floor')
   ,(N'38th Floor')
   ,(N'39th Floor')
   ,(N'40th Floor')
   ,(N'41st Floor')
   ,(N'42nd Floor')
   ,(N'43rd Floor')
   ,(N'44th Floor')
   ,(N'45th Floor')
   ,(N'46th Floor')
   ,(N'47th Floor')
   ,(N'48th Floor')
   ,(N'49th Floor')
   ,(N'50th Floor')
   ,(N'51st Floor')
   ,(N'52nd Floor')
   ,(N'53rd Floor')
   ,(N'54th Floor')
   ,(N'55th Floor')
   ,(N'56th Floor')
   ,(N'57th Floor')
   ,(N'58th Floor')
   ,(N'59th Floor')
   ,(N'60th Floor')
   ,(N'61st Floor')
   ,(N'62nd Floor')
   ,(N'63rd Floor')
   ,(N'64th Floor')
   ,(N'65th Floor')
   ,(N'66th Floor')
   ,(N'67th Floor')
   ,(N'68th Floor')
   ,(N'69th Floor')
   ,(N'70th Floor')
   ,(N'71st Floor')
   ,(N'72nd Floor')
   ,(N'73rd Floor')
   ,(N'74th Floor')
   ,(N'75th Floor')
   ,(N'76th Floor')
   ,(N'77th Floor')
   ,(N'78th Floor')
   ,(N'79th Floor')
   ,(N'80th Floor')
   ,(N'81st Floor')
   ,(N'82nd Floor')
   ,(N'83rd Floor')
   ,(N'84th Floor')
   ,(N'85th Floor')
   ,(N'86th Floor')
   ,(N'87th Floor')
   ,(N'88th Floor')
   ,(N'89th Floor')
   ,(N'90th Floor')
   ,(N'91st Floor')
   ,(N'92nd Floor')
   ,(N'93rd Floor')
   ,(N'94th Floor')
   ,(N'95th Floor')
   ,(N'96th Floor')
   ,(N'97th Floor')
   ,(N'98th Floor')
   ,(N'99th Floor')
   ,(N'100th Floor')
   ,(N'101st Floor')
   ,(N'102nd Floor')
   ,(N'103rd Floor')
   ,(N'104th Floor')
   ,(N'105th Floor')
   ,(N'106th Floor')
   ,(N'107th Floor')
   ,(N'108th Floor')
   ,(N'109th Floor')
   ,(N'110th Floor')
   ,(N'111th Floor')
   ,(N'112th Floor')
   ,(N'113th Floor')
   ,(N'114th Floor')
   ,(N'115th Floor')
   ,(N'116th Floor')
   ,(N'117th Floor')
   ,(N'118th Floor')
   ,(N'119th Floor')
   ,(N'120th Floor')
   ,(N'121st Floor')
   ,(N'122nd Floor')
   ,(N'123rd Floor')
   ,(N'124th Floor')
   ,(N'125th Floor')
   ,(N'Sales Group')
   ,(N'Customer Group')
   ,(N'After Sales Group')
   ,(N'Pre Sales Group')
   ,(N'Post Sales Group')
   ,(N'Sales Department')
   ,(N'Customer Department')
   ,(N'After Sales Department')
   ,(N'Pre Sales Department')
   ,(N'Post Sales Department')
   ,(N'Sales')
   ,(N'Customer')
   ,(N'After Sales')
   ,(N'Pre Sales')
   ,(N'Lincoln Building')
   ,(N'Washington Building')
   ,(N'Jefferson Building')
   ,(N'Roosevelt Building')
   ,(N'Hamilton Building')
   ,(N'Franklin Building')
   ,(N'Marshall Building')
   ,(N'Edison Building')
   ,(N'Wilson Building')
   ,(N'Madison Building')
   ,(N'Roosevelt Building')
   ,(N'Truman Building')
   ,(N'Einstein Building')
   ,(N'Anthony Building')
   ,(N'Sanger Building')
   ,(N'Foster Building');

SET @i = 1;
DECLARE @ChooseNumber int = 1;

WHILE (@i <= 100)
    BEGIN

        SET @ChooseNumber = FLOOR(CAST(CRYPT_GEN_RANDOM(4) AS bigint) / 4294967296 * ((5 - 1) + 1)) + 1;

        INSERT INTO #Line2 (Line2)
        SELECT
            CASE @ChooseNumber
                WHEN 1
                    THEN N'APT'
                WHEN 2
                    THEN N'Apartment'
                WHEN 3
                    THEN N'Suite'
                WHEN 4
                    THEN N'STE'
                WHEN 5
                    THEN N'Unit'
                ELSE N'Suite'
            END + N' ' + /**/
            IIF(ABS(CHECKSUM(NEWID()) % 101) < 80, '', '#') + /**/
            CAST(FLOOR(CAST(CRYPT_GEN_RANDOM(4) AS bigint) / 4294967296 * ((1000 - 1) + 1)) + 1 AS nvarchar(10));

        SET @i = @i + 1;
    END;

/**********************************************************************************************************************
** City Names Prefix
**********************************************************************************************************************/
Saint
North
South
East
West
New
Old
Mount
Little
Lake
Fort
Camp

/**********************************************************************************************************************
** City Names Suffix
**********************************************************************************************************************/
DROP TABLE IF EXISTS #CitySuffix;
CREATE TABLE #CitySuffix (CitySuffixId int IDENTITY(1, 1), CitySuffix nvarchar(100) NULL);
INSERT INTO #CitySuffix (CitySuffix)
VALUES
(N'')

burg
sburg
bury
boro
creek
dale
sdale
ford
field
sfield
haven
hurst
hill
hills
more
port
ridge
son
sonville
town
ton
ridge
ston
ville
view
views
sville
worth
sworth
wood
woods
water
waters
way
wick

 Beach
 Brook
 Bluff
 Cape
 City
 Creek
 s Creek
 Creek Village
 Center
 Canyon 
 Canyon Lake
 Estates
 s Ferry
 Fork
 Falls
 Grove
 Harbour
 Heights
 Highlands
 Hill
 Hills
 Junction
 Knob
 s Landing
 Lakes
 Lodge
 Manor
 Meadows
 Mountain
 Mountain Lake 
 Mills
 Mill
 Oaks
 Park
 Pass
 Pines
 Point
 Prairie
 River
 River City
 Ridge
 Rock
 Rocks
 Springs
 Town
 Valley
 Valley Springs
 View
 Village
 Vista
 Wells
 Woods


fort
field
stead
lee
slee
mont
vista

/**********************************************************************************************************************
** Addresses
**********************************************************************************************************************/
SELECT
    Line1      = IIF(ABS(CHECKSUM(NEWID()) % 101) < 95
                    ,CAST(HN.HouseNumber AS nvarchar(100)) + N' ' + ISNULL(D.Direction + N' ', N'')
                     + IIF(SN2.StreetName2 NOT IN ((N'First'), (N'1st'), (N'Second'), (N'2nd'), (N'Third'), (N'3rd'), (N'Fourth'), (N'4th'), (N'Park'), (N'Fifth'), (N'5th'), (N'Sixth'), (N'6th')), ISNULL(SN1.StreetName1 + N' ', N''), N'') + /**/
                    SN2.StreetName2                     + N' ' + /**/
                    ST.StreetType
                    ,IIF(ABS(CHECKSUM(NEWID()) % 101) >= 5, 'PO BOX', 'P.O. BOX') + ' ' + /**/
                    IIF(ABS(CHECKSUM(NEWID()) % 101) < 80, '', '#') + CAST(FLOOR(CAST(CRYPT_GEN_RANDOM(4) AS bigint) / 4294967296 * ((1000 - 1) + 1)) + 1 AS nvarchar(100)))
   ,Line2      = IIF(ABS(CHECKSUM(NEWID()) % 101) < @PercentNullForLine2 OR @PercentNullForLine2 >= 100, NULL, L2.Line2)
   ,CityTownId = FLOOR(CAST(CRYPT_GEN_RANDOM(4) AS bigint) / 4294967296 * ((38186 - 1) + 1)) + 1
FROM
    #HouseNumber AS HN
    CROSS APPLY (
    SELECT TOP (1)
        D.Direction
    FROM
        #Direction AS D
    ORDER BY
        NEWID()
       ,CHECKSUM(HN.HouseNumberId, D.DirectionId)
)                AS D
    CROSS APPLY (
    SELECT TOP (1)
        SN1.StreetName1
    FROM
        #StreetName1 AS SN1
    ORDER BY
        NEWID()
       ,CHECKSUM(HN.HouseNumberId, SN1.StreetName1Id)
) AS SN1
    CROSS APPLY (
    SELECT TOP (1)
        SN2.StreetName2
    FROM
        #StreetName2 AS SN2
    ORDER BY
        NEWID()
       ,CHECKSUM(HN.HouseNumberId, SN2.StreetName2Id)
) AS SN2
    CROSS APPLY (
    SELECT TOP (1)
        ST.StreetType
    FROM
        #StreetType AS ST
    ORDER BY
        NEWID()
       ,CHECKSUM(HN.HouseNumberId, ST.StreetTypeId)
) AS ST
    CROSS APPLY (
    SELECT TOP (1)
        L2.Line2
    FROM
        #Line2 AS L2
    ORDER BY
        NEWID()
       ,CHECKSUM(HN.HouseNumberId, L2.Line2Id)
) AS L2;



/**********************************************************************************************************************
** Postal Codes
**********************************************************************************************************************/
DROP TABLE IF EXISTS #PostalCode;
CREATE TABLE #PostalCode (PostalCodeId int IDENTITY(1, 1), PostalCode nvarchar(15) NULL);
INSERT INTO #PostalCode (PostalCode) VALUES (N'55340'), (N'85704-3499');


/**********************************************************************************************************************
** Phone Numbers
**********************************************************************************************************************/
DROP TABLE IF EXISTS #PhoneNumber;
CREATE TABLE #PhoneNumber (#PhoneNumberId int IDENTITY(1, 1), PhoneNumber nvarchar(50) NULL);
INSERT INTO #PhoneNumber (PhoneNumber)
VALUES
    (N'123-456-5358')
   ,(N'(123) 456-2345')
   ,(N'(123) 456-2345 ext. 12345');

--Orginization
--https://www.mithrilandmages.com/utilities/BusinessNames.php
--https://www.mithrilandmages.com/utilities/ClothingStoreNames.php
