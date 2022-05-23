DECLARE @ProductsToLoad int = 100;
DECLARE @OrganizationsToLoad int = 100;
DECLARE @CityTownsToLoad int = 100;
DECLARE @DatesToLoad int = 100;
DECLARE @TimesToLoad int = 100;
DECLARE @NumbersToLoad int = 100;

SET IDENTITY_INSERT Application.Person ON;
INSERT INTO Application.Person (PersonId, FirstName, LastName, RowModifyPersonId, RowCreatePersonId)
VALUES
     (-1, N'Data Conversion', N'Only', -1, -1);
SET IDENTITY_INSERT Application.Person OFF;


SET IDENTITY_INSERT Application.AddressType ON;
INSERT INTO Application.AddressType (
    AddressTypeId
   ,AddressTypeName
   ,AddressTypeShortName
   ,AddressTypeDescription
   ,SortOrderNumber
   ,IsDefaultFlag
   ,IsLockedFlag
   ,IsActiveFlag
   ,RowModifyPersonId
   ,RowCreatePersonId
)
SELECT
    AddressTypeId
   ,AddressTypeName
   ,AddressTypeShortName
   ,AddressTypeDescription
   ,SortOrderNumber
   ,IsDefaultFlag
   ,IsLockedFlag
   ,IsActiveFlag
   ,-1
   ,-1
FROM
    KevinMartinTechData.dbo.AddressType;
SET IDENTITY_INSERT Application.AddressType OFF;



SET IDENTITY_INSERT Application.Attribute ON;
INSERT INTO Application.Attribute (AttributeId, AttributeName, RowModifyPersonId, RowCreatePersonId)
SELECT AttributeId, AttributeName, -1, -1 FROM KevinMartinTechData.dbo.Attribute;
SET IDENTITY_INSERT Application.Attribute OFF;



SET IDENTITY_INSERT Application.AttributeTerm ON;
INSERT INTO Application.AttributeTerm (AttributeTermId, AttributeId, TermName, RowModifyPersonId, RowCreatePersonId)
SELECT
    AttributeTermId
   ,AttributeId
   ,TermName
   ,-1
   ,-1
FROM
    KevinMartinTechData.dbo.AttributeTerm;
SET IDENTITY_INSERT Application.AttributeTerm OFF;



SET IDENTITY_INSERT Application.CountryRegion ON;
INSERT INTO Application.CountryRegion (
    CountryRegionId
   ,CountryName
   ,FormalName
   ,IsoAlpha3Code
   ,IsoNumericCode
   ,CountryType
   ,Continent
   ,Region
   ,Subregion
   ,RowModifyPersonId
   ,RowCreatePersonId
)
SELECT
    CountryRegionId
   ,CountryName
   ,FormalName
   ,IsoAlpha3Code
   ,IsoNumericCode
   ,CountryType
   ,Continent
   ,Region
   ,Subregion
   ,-1
   ,-1
FROM
    KevinMartinTechData.dbo.CountryRegion;
SET IDENTITY_INSERT Application.CountryRegion OFF;



SET IDENTITY_INSERT Application.StateProvince ON;
INSERT INTO Application.StateProvince (
    StateProvinceId
   ,CountryRegionId
   ,StateProvinceCode
   ,StateProvinceName
   ,RowModifyPersonId
   ,RowCreatePersonId
)
SELECT
    StateProvinceId
   ,CountryRegionId
   ,StateProvinceCode
   ,StateProvinceName
   ,-1
   ,-1
FROM
    KevinMartinTechData.dbo.StateProvince;
SET IDENTITY_INSERT Application.StateProvince OFF;



SET IDENTITY_INSERT Application.CityTown ON;
INSERT INTO Application.CityTown (CityTownId, StateProvinceId, CityTownName, RowModifyPersonId, RowCreatePersonId)
SELECT TOP (@CityTownsToLoad)
    CityTownId
   ,StateProvinceId
   ,CityTownName
   ,-1
   ,-1
FROM
    KevinMartinTechData.dbo.CityTown;
SET IDENTITY_INSERT Application.CityTown OFF;


INSERT INTO Application.Date (
    DateId
   ,FullDateTime
   ,DateName
   ,DateNameUS
   ,DateNameEU
   ,DayOfWeek
   ,DayNameOfWeek
   ,DayOfMonth
   ,DayOfYear
   ,WeekdayWeekend
   ,WeekOfYear
   ,MonthName
   ,MonthNameShort
   ,MonthYear
   ,MonthOfYear
   ,LastDayOfMonth
   ,WorkDay
   ,CalendarQuarter
   ,CalendarYear
   ,CalendarYearMonth
   ,CalendarYearQuarter
   ,FiscalMonthOfYear
   ,FiscalQuarter
   ,FiscalQuarterName
   ,FiscalYear
   ,FiscalYearNameShort
   ,FiscalYearNameLong
   ,FiscalYearMonth
   ,FiscalYearQuarter
)
SELECT TOP (@DatesToLoad)
    DateId
   ,FullDateTime
   ,DateName
   ,DateNameUS
   ,DateNameEU
   ,DayOfWeek
   ,DayNameOfWeek
   ,DayOfMonth
   ,DayOfYear
   ,WeekdayWeekend
   ,WeekOfYear
   ,MonthName
   ,MonthNameShort
   ,MonthYear
   ,MonthOfYear
   ,LastDayOfMonth
   ,WorkDay
   ,CalendarQuarter
   ,CalendarYear
   ,CalendarYearMonth
   ,CalendarYearQuarter
   ,FiscalMonthOfYear
   ,FiscalQuarter
   ,FiscalQuarterName
   ,FiscalYear
   ,FiscalYearNameShort
   ,FiscalYearNameLong
   ,FiscalYearMonth
   ,FiscalYearQuarter
FROM
    KevinMartinTechData.Application.Date;


INSERT INTO Application.Time (
    TimeId
   ,Hour24
   ,Hour24Short
   ,Hour24Medium
   ,Hour24Full
   ,Hour12
   ,Hour12Short
   ,Hour12ShortTrim
   ,Hour12Medium
   ,Hour12MediumTrim
   ,Hour12Full
   ,Hour12FullTrim
   ,AMPMCode
   ,AMPM
   ,Minute
   ,MinuteOfDay
   ,MinuteCode
   ,MinuteShort
   ,Minute24Full
   ,Minute12Full
   ,Minute12FullTrim
   ,HalfHourCode
   ,HalfHour
   ,HalfHourShort
   ,HalfHour24Full
   ,HalfHour12Full
   ,HalfHour12FullTrim
   ,Second
   ,SecondOfDay
   ,SecondShort
   ,FullTime24
   ,FullTime12
   ,FullTime12Trim
   ,FullTime
)
SELECT TOP (@TimesToLoad)
    TimeId
   ,Hour24
   ,Hour24Short
   ,Hour24Medium
   ,Hour24Full
   ,Hour12
   ,Hour12Short
   ,Hour12ShortTrim
   ,Hour12Medium
   ,Hour12MediumTrim
   ,Hour12Full
   ,Hour12FullTrim
   ,AMPMCode
   ,AMPM
   ,Minute
   ,MinuteOfDay
   ,MinuteCode
   ,MinuteShort
   ,Minute24Full
   ,Minute12Full
   ,Minute12FullTrim
   ,HalfHourCode
   ,HalfHour
   ,HalfHourShort
   ,HalfHour24Full
   ,HalfHour12Full
   ,HalfHour12FullTrim
   ,Second
   ,SecondOfDay
   ,SecondShort
   ,FullTime24
   ,FullTime12
   ,FullTime12Trim
   ,FullTime
FROM
    KevinMartinTechData.Application.Time;



SET IDENTITY_INSERT Application.DeliveryType ON;
INSERT INTO Application.DeliveryType (
    DeliveryTypeId
   ,DeliveryTypeName
   ,DeliveryTypeShortName
   ,DeliveryTypeDescription
   ,SortOrderNumber
   ,IsDefaultFlag
   ,IsLockedFlag
   ,IsActiveFlag
   ,RowModifyPersonId
   ,RowCreatePersonId
)
SELECT
    DeliveryTypeId
   ,DeliveryTypeName
   ,DeliveryTypeShortName
   ,DeliveryTypeDescription
   ,SortOrderNumber
   ,IsDefaultFlag
   ,IsLockedFlag
   ,IsActiveFlag
   ,-1
   ,-1
FROM
    KevinMartinTechData.dbo.DeliveryType;
SET IDENTITY_INSERT Application.DeliveryType OFF;


SET IDENTITY_INSERT Application.EmailType ON;
INSERT INTO Application.EmailType (
    EmailTypeId
   ,EmailTypeName
   ,EmailTypeShortName
   ,EmailTypeDescription
   ,SortOrderNumber
   ,IsDefaultFlag
   ,IsLockedFlag
   ,IsActiveFlag
   ,RowModifyPersonId
   ,RowCreatePersonId
)
SELECT
    EmailTypeId
   ,EmailTypeName
   ,EmailTypeShortName
   ,EmailTypeDescription
   ,SortOrderNumber
   ,IsDefaultFlag
   ,IsLockedFlag
   ,IsActiveFlag
   ,-1
   ,-1
FROM
    KevinMartinTechData.dbo.EmailType;
SET IDENTITY_INSERT Application.EmailType OFF;


SET IDENTITY_INSERT Application.LanguageCode ON;
INSERT INTO Application.LanguageCode (
    LanguageCodeId
   ,LanguageName
   ,IsoAlpha2Code
   ,IsoAlpha3Code
   ,RowModifyPersonId
   ,RowCreatePersonId
)
SELECT
    LanguageCodeId
   ,LanguageName
   ,IsoAlpha2Code
   ,IsoAlpha3Code
   ,-1
   ,-1
FROM
    KevinMartinTechData.Application.LanguageCode;
SET IDENTITY_INSERT Application.LanguageCode OFF;


INSERT INTO Application.Number (
    NumberId
   ,NumberWord
   ,BinaryNumber
   ,HexNumber
   ,EvenOdd
   ,RomanNumeral
   ,Ones
   ,Tens
   ,Hundreds
   ,Thousands
   ,TenThousands
   ,HundredThousands
   ,Millions
   ,TenMillions
   ,HundredMillions
   ,Billions
   ,TenBillions
   ,HundredBillions
   ,Trillions
   ,TenTrillions
   ,HundredTrillions
   ,Quadrillions
   ,TenQuadrillions
   ,HundredQuadrillions
   ,Quintillions
)
SELECT TOP (@NumbersToLoad)
    NumberId
   ,NumberWord
   ,BinaryNumber
   ,HexNumber
   ,EvenOdd
   ,RomanNumeral
   ,Ones
   ,Tens
   ,Hundreds
   ,Thousands
   ,TenThousands
   ,HundredThousands
   ,Millions
   ,TenMillions
   ,HundredMillions
   ,Billions
   ,TenBillions
   ,HundredBillions
   ,Trillions
   ,TenTrillions
   ,HundredTrillions
   ,Quadrillions
   ,TenQuadrillions
   ,HundredQuadrillions
   ,Quintillions
FROM
    KevinMartinTechData.Application.Number;


SET IDENTITY_INSERT Application.Organization ON;
INSERT INTO Application.Organization (
    OrganizationId
   ,OrganizationName
   ,WebsiteURL
   ,RowModifyPersonId
   ,RowCreatePersonId
)
SELECT TOP (@OrganizationsToLoad)
    OrganizationId
   ,OrganizationName
   ,WebsiteURL
   ,-1
   ,-1
FROM
    KevinMartinTechData.dbo.Organization
ORDER BY
    OrganizationId;
SET IDENTITY_INSERT Application.Organization OFF;



SET IDENTITY_INSERT Application.PhoneType ON;
INSERT INTO Application.PhoneType (
    PhoneTypeId
   ,PhoneTypeName
   ,PhoneTypeShortName
   ,PhoneTypeDescription
   ,SortOrderNumber
   ,IsDefaultFlag
   ,IsLockedFlag
   ,IsActiveFlag
   ,RowModifyPersonId
   ,RowCreatePersonId
)
SELECT
    PhoneTypeId
   ,PhoneTypeName
   ,PhoneTypeShortName
   ,PhoneTypeDescription
   ,SortOrderNumber
   ,IsDefaultFlag
   ,IsLockedFlag
   ,IsActiveFlag
   ,-1
   ,-1
FROM
    KevinMartinTechData.dbo.PhoneType;
SET IDENTITY_INSERT Application.PhoneType OFF;



SET IDENTITY_INSERT Application.Category ON;
INSERT INTO Application.Category (
    CategoryId
   ,ParentIdCategoryId
   ,CategoryName
   ,CategorySlug
   ,RowModifyPersonId
   ,RowCreatePersonId
)
SELECT
    CategoryId
   ,ParentIdCategoryId
   ,CategoryName
   ,CategorySlug
   ,-14
   ,-1
FROM
    KevinMartinTechData.dbo.Category
SET IDENTITY_INSERT Application.Category OFF;



SET IDENTITY_INSERT Application.Product ON;
INSERT INTO Application.Product (
    ProductId
   ,ProductName
   ,ProductSlug
   ,ProductDescription
   ,RowModifyPersonId
   ,RowCreatePersonId
)
SELECT TOP (@ProductsToLoad)
    ProductId
   ,ProductName
   ,ProductSlug
   ,ProductDescription
   ,-1
   ,-1
FROM
    KevinMartinTechData.dbo.Product
ORDER BY
    ProductId;
SET IDENTITY_INSERT Application.Product OFF;



SET IDENTITY_INSERT Application.ProductItem ON;
INSERT INTO Application.ProductItem (
    ProductItemId
   ,ProductId
   ,UPC
   ,IsEnableFlag
   ,IsVirtualFlag
   ,RegularPrice
   ,SalePrice
   ,ManufactureCost
   ,DaysToManufacture
   ,RowModifyPersonId
   ,RowCreatePersonId
)
SELECT TOP (@ProductsToLoad)
    ProductItemId
   ,ProductId
   ,UPC
   ,IsEnableFlag      = IIF(ABS(CHECKSUM(NEWID()) % 101) >= 5, 1, 0)
   ,IsVirtualFlag     = IIF(ABS(CHECKSUM(NEWID()) % 101) >= 98, 1, 0)
   ,RegularPrice
   ,SalePrice
   ,ManufactureCost
   ,DaysToManufacture = IIF(ABS(CHECKSUM(NEWID()) % 101) >= 90, NULL, ABS(CHECKSUM(NEWID()) % 5))
   ,-1
   ,-1
FROM
    KevinMartinTechData.dbo.ProductItem
ORDER BY
    ProductId;
SET IDENTITY_INSERT Application.ProductItem OFF;


SET IDENTITY_INSERT Application.ProductCategory ON;
INSERT INTO Application.ProductCategory (ProductCategoryId, ProductId, CategoryId, RowModifyPersonId, RowCreatePersonId)
SELECT TOP (@ProductsToLoad)
    ProductCategoryId
   ,ProductId
   ,CategoryId
   ,-1
   ,-1
FROM
    KevinMartinTechData.dbo.ProductCategory
ORDER BY
    ProductId;
SET IDENTITY_INSERT Application.ProductCategory OFF;



SET IDENTITY_INSERT Application.ProductVariant ON;
INSERT INTO Application.ProductVariant (
    ProductVariantId
   ,ProductItemId
   ,AttributeTermId
   ,RowModifyPersonId
   ,RowCreatePersonId
)
SELECT TOP (@ProductsToLoad)
    PV.ProductVariantId
   ,PV.ProductItemId
   ,PV.AttributeTermId
   ,-1
   ,-1
FROM
    KevinMartinTechData.dbo.ProductVariant AS PV
    INNER JOIN Application.ProductItem     AS PI
        ON PV.ProductItemId = PI.ProductItemId
ORDER BY
    PI.ProductId ASC;
SET IDENTITY_INSERT Application.ProductVariant OFF;


SET IDENTITY_INSERT Application.UnitType ON;
INSERT INTO Application.UnitType (
    UnitTypeId
   ,UnitTypeName
   ,UnitTypeShortName
   ,UnitTypeDescription
   ,SortOrderNumber
   ,IsDefaultFlag
   ,IsLockedFlag
   ,IsActiveFlag
   ,RowModifyPersonId
   ,RowCreatePersonId
)
SELECT
    UnitTypeId
   ,UnitTypeName
   ,UnitTypeShortName
   ,UnitTypeDescription
   ,SortOrderNumber
   ,IsDefaultFlag
   ,IsLockedFlag
   ,IsActiveFlag
   ,-1
   ,-1
FROM
    KevinMartinTechData.dbo.UnitType;
SET IDENTITY_INSERT Application.UnitType OFF;

SET IDENTITY_INSERT Application.Image ON;
INSERT INTO Application.Image (ImageId, ImageURL, RowModifyPersonId, RowCreatePersonId)
SELECT DISTINCT
    I.ImageId
   ,I.ImageURL
   ,-1
   ,-1
FROM
    KevinMartinTechData.dbo.Image                   AS I
    INNER JOIN KevinMartinTechData.dbo.ProductImage AS PI
        ON I.ImageId = PI.ImageId
WHERE
    PI.ProductId IN (
        SELECT TOP (@ProductsToLoad)
            ProductId
        FROM
            KevinMartinTechData.dbo.Product
        ORDER BY
            ProductId
    );
SET IDENTITY_INSERT Application.Image OFF;

SET IDENTITY_INSERT Application.ProductImage ON;
INSERT INTO Application.ProductImage (ProductImageId, ProductId, ImageId, RowModifyPersonId, RowCreatePersonId)
SELECT TOP (@ProductsToLoad)
    ProductImageId
   ,ProductId
   ,ImageId
   ,-1
   ,-1
FROM
    KevinMartinTechData.dbo.ProductImage
ORDER BY
    ProductId ASC;
SET IDENTITY_INSERT Application.ProductImage OFF;
