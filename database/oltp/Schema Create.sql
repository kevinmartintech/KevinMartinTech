SET ANSI_NULLS, QUOTED_IDENTIFIER ON;
GO
/**********************************************************************************************************************
** Create Database
**********************************************************************************************************************/
/*
sp_who2
kill  170

DROP DATABASE IF EXISTS KevinMartinTech;
GO

CREATE DATABASE KevinMartinTech;
GO
*/

--USE KevinMartinTech;

/**********************************************************************************************************************
** Drop stored procedures except sp_CRUDGen
**********************************************************************************************************************/
DECLARE @SQLStatement nvarchar(MAX) = N'';
DECLARE @NewLineString nvarchar(MAX) = CAST(CHAR(13) + CHAR(10) AS nvarchar(MAX));

SELECT
    @SQLStatement = @SQLStatement + COALESCE(N'DROP PROCEDURE ' + S.name + N'.' + P.name + N';', N'') + @NewLineString
FROM
    sys.procedures     AS P
INNER JOIN sys.schemas AS S ON P.schema_id = S.schema_id
WHERE
    P.name NOT IN ('sp_CRUDGen', 'sp_Develop');

EXECUTE sys.sp_executesql @SQLStatement;
--PRINT @SQLStatement;
SET @SQLStatement = N'';

/**********************************************************************************************************************
** Drop Functions
**********************************************************************************************************************/
DROP FUNCTION IF EXISTS dbo.RemoveCharactersFromString;

/**********************************************************************************************************************
** Drop Tables
**********************************************************************************************************************/
DROP TABLE IF EXISTS Application.OrganizationPerson;
DROP TABLE IF EXISTS Application.OrganizationPhone;
DROP TABLE IF EXISTS Application.OrganizationEmail;
DROP TABLE IF EXISTS Application.OrganizationPhone;
DROP TABLE IF EXISTS Application.Time;
DROP TABLE IF EXISTS Application.Date;
DROP TABLE IF EXISTS Application.Number;

DROP TABLE IF EXISTS Sales.SalesOrderLine;
DROP TABLE IF EXISTS Sales.SalesOrder;
DROP TABLE IF EXISTS Sales.CreditCard;

DROP TABLE IF EXISTS Purchasing.PurchaseOrderLine;
DROP TABLE IF EXISTS Purchasing.PurchaseOrder;
DROP TABLE IF EXISTS Application.ProductImage;
DROP TABLE IF EXISTS Application.Image;
DROP TABLE IF EXISTS Application.ProductCategory;
DROP TABLE IF EXISTS Application.ProductVariant;
DROP TABLE IF EXISTS Application.ProductItem;
DROP TABLE IF EXISTS Application.Product;
DROP TABLE IF EXISTS Application.Category;
DROP TABLE IF EXISTS Application.AttributeTerm;
DROP TABLE IF EXISTS Application.Attribute;
DROP TABLE IF EXISTS Application.LocationPhone;
DROP TABLE IF EXISTS Application.PersonPhone;
DROP TABLE IF EXISTS Application.PersonEmail;
DROP TABLE IF EXISTS Application.PersonToken;
DROP TABLE IF EXISTS Application.PersonRole;
DROP TABLE IF EXISTS Application.PersonLogin;
DROP TABLE IF EXISTS Application.PersonClaim;
DROP TABLE IF EXISTS Application.SecurityRoleClaim;
DROP TABLE IF EXISTS Application.SecurityRole;
DROP TABLE IF EXISTS Application.Phone;
DROP TABLE IF EXISTS Application.Location;
DROP TABLE IF EXISTS Application.Residence;

IF OBJECTPROPERTY(OBJECT_ID('Application.Address'), 'TableTemporalType') = 2
    BEGIN
        ALTER TABLE Application.Address SET (SYSTEM_VERSIONING = OFF);
    END;
DROP TABLE IF EXISTS Application.Address;
DROP TABLE IF EXISTS History.Address;

DROP TABLE IF EXISTS Application.AddressType;
DROP TABLE IF EXISTS Application.EmailType;
DROP TABLE IF EXISTS Application.DeliveryType;
DROP TABLE IF EXISTS Application.PhoneType;
DROP TABLE IF EXISTS Application.UnitType;
DROP TABLE IF EXISTS Application.CityTown;
DROP TABLE IF EXISTS Application.LanguageCode;
DROP TABLE IF EXISTS Application.StateProvince;
DROP TABLE IF EXISTS Application.CountryRegion;
DROP TABLE IF EXISTS Sales.Customer;
DROP TABLE IF EXISTS Purchasing.Supplier;

IF OBJECTPROPERTY(OBJECT_ID('Application.Organization'), 'TableTemporalType') = 2
    BEGIN
        ALTER TABLE Application.Organization SET (SYSTEM_VERSIONING = OFF);
    END;

DROP TABLE IF EXISTS Application.Organization;
DROP TABLE IF EXISTS History.Organization;


IF OBJECTPROPERTY(OBJECT_ID('Application.Person'), 'TableTemporalType') = 2
    BEGIN
        ALTER TABLE Application.Person SET (SYSTEM_VERSIONING = OFF);
    END;

DROP TABLE IF EXISTS Application.Person;
DROP TABLE IF EXISTS History.Person;


DROP SCHEMA IF EXISTS Application;
DROP SCHEMA IF EXISTS Sales;
DROP SCHEMA IF EXISTS Purchasing;
DROP SCHEMA IF EXISTS History;
GO

/**********************************************************************************************************************
** Create Schema
**********************************************************************************************************************/

CREATE SCHEMA Application AUTHORIZATION dbo;
GO
CREATE SCHEMA Sales AUTHORIZATION dbo;
GO
CREATE SCHEMA Purchasing AUTHORIZATION dbo;
GO
CREATE SCHEMA History AUTHORIZATION dbo;
GO

/**********************************************************************************************************************
** Create Person
**
** This table contains ASP.NET Core Identity columns
**  Overview of ASP.NET Core Security: https://kevinmartin.tech/go/aspnet-core-security
**  Identity model customization in ASP.NET Core: https://kevinmartin.tech/go/customize-identity-model
**
** Table-per-Type vs Table-per-Hierarchy in ORM
**  Proper database design/modeling will use TPT 
**********************************************************************************************************************/

CREATE TABLE Application.Person (
    PersonId                int               NOT NULL IDENTITY(1, 1)
   ,AzureAdUserId           uniqueidentifier  NULL /* Could associate an Azure Active Directory user id for authentication to a person row. */
   ,UserName                nvarchar(256)     NULL
   ,EmailAddress            nvarchar(254)     NULL
   ,IsEmailAddressConfirmed bit               NOT NULL CONSTRAINT Application_Person_IsEmailAddressConfirmed_Default DEFAULT ((0))
   ,PasswordHash            nvarchar(500)     NULL
   ,PhoneNumber             nvarchar(100)     NULL
   ,IsPhoneNumberConfirmed  bit               NOT NULL CONSTRAINT Application_Person_IsPhoneNumberConfirmed_Default DEFAULT ((0))
   ,IsTwoFactorEnabled      bit               NOT NULL CONSTRAINT Application_Person_IsTwoFactorEnabled_Default DEFAULT ((0))
   ,LockoutEndTime          datetimeoffset(7) NULL
   ,IsLockoutEnabled        bit               NOT NULL CONSTRAINT Application_Person_IsLockoutEnabled_Default DEFAULT ((0))
   ,AccessFailedCount       int               NOT NULL CONSTRAINT Application_Person_AccessFailedCount_Default DEFAULT ((0))
   ,Title                   nvarchar(10)      NULL
   ,FirstName               nvarchar(100)     NULL
   ,LastName                nvarchar(100)     NULL
   ,Suffix                  nvarchar(10)      NULL
   ,NickName                nvarchar(100)     NULL
   ,SearchName              AS (TRIM(CONCAT(ISNULL(TRIM(NickName) + ' ', ''), ISNULL(TRIM(FirstName) + ' ', ''), ISNULL(TRIM(LastName) + ' ', ''), ISNULL(TRIM(Suffix) + '', '')))) PERSISTED NOT NULL
   ,IsOptOut                bit               NOT NULL CONSTRAINT Application_Person_IsOptOut_Default DEFAULT ((0))
   ,ModifyPersonId          int               NOT NULL CONSTRAINT Application_Person_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId          int               NOT NULL CONSTRAINT Application_Person_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime              datetimeoffset(7) NOT NULL CONSTRAINT Application_Person_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime              datetimeoffset(7) NOT NULL CONSTRAINT Application_Person_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp            rowversion        NOT NULL
   ,ValidFromTime           datetime2(7)      GENERATED ALWAYS AS ROW START NOT NULL CONSTRAINT Person_ValidFromTime_Default DEFAULT (SYSUTCDATETIME())
   ,ValidToTime             datetime2(7)      GENERATED ALWAYS AS ROW END NOT NULL CONSTRAINT Person_ValidToTime_Default DEFAULT ('9999-12-31 23:59:59.9999999')
   ,CONSTRAINT Application_Person_PersonId PRIMARY KEY CLUSTERED (PersonId ASC)
   ,INDEX Application_Person_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_Person_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
   ,INDEX Application_Person_SearchName NONCLUSTERED (SearchName ASC)
   ,INDEX Application_Person_LastName NONCLUSTERED (LastName ASC)
   ,PERIOD FOR SYSTEM_TIME(ValidFromTime, ValidToTime)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = History.Person));
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Primary key for person records.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Person'
   ,@level2type = N'COLUMN'
   ,@level2name = N'PersonId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'A courtesy title. For example, Mr. or Ms.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Person'
   ,@level2type = N'COLUMN'
   ,@level2name = N'Title';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'First name of the person.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Person'
   ,@level2type = N'COLUMN'
   ,@level2name = N'FirstName';
GO


EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Last name of the person.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Person'
   ,@level2type = N'COLUMN'
   ,@level2name = N'LastName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Surname suffix. For example, Sr. or Jr.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Person'
   ,@level2type = N'COLUMN'
   ,@level2name = N'Suffix';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Nickname of the person.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Person'
   ,@level2type = N'COLUMN'
   ,@level2name = N'NickName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'0 = Person does not wish to receive e-mail promotions, 1 = Person does wish to receive e-mail promotions.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Person'
   ,@level2type = N'COLUMN'
   ,@level2name = N'IsOptOut';
GO


/**********************************************************************************************************************
** Create PersonToken (https://kevinmartin.tech/go/customize-identity-model)
**********************************************************************************************************************/

CREATE TABLE Application.PersonToken (
    PersonId         int           NOT NULL CONSTRAINT Application_PersonToken_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,LoginProvider    nvarchar(128) NOT NULL
   ,PersonTokenName  nvarchar(128) NOT NULL /* ASP.NET Core Identity: Identity model customization in ASP.NET Core: https://kevinmartin.tech/go/customize-identity-model */
   ,PersonTokenValue nvarchar(MAX) NULL
   ,CONSTRAINT Application_PersonToken_PersonId_LoginProvider_PersonTokenName PRIMARY KEY CLUSTERED (PersonId ASC, LoginProvider ASC, PersonTokenName ASC)
   ,INDEX Application_PersonToken_PersonId NONCLUSTERED (PersonId ASC)
);
GO

/**********************************************************************************************************************
** Create Roles (https://kevinmartin.tech/go/customize-identity-model)
**********************************************************************************************************************/

CREATE TABLE Application.SecurityRole (
    SecurityRoleId             int           NOT NULL
   ,SecurityRoleName           nvarchar(256) NULL
   ,SecurityRoleNormalizedName nvarchar(256) NULL
   ,ConcurrencyStamp           nvarchar(MAX) NULL
   ,CONSTRAINT Application_SecurityRole_SecurityRoleId PRIMARY KEY CLUSTERED (SecurityRoleId ASC)
);
GO

/**********************************************************************************************************************
** Create PersonRole (https://kevinmartin.tech/go/customize-identity-model)
**********************************************************************************************************************/

CREATE TABLE Application.PersonRole (
    PersonId       int NOT NULL CONSTRAINT Application_PersonRole_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,SecurityRoleId int NOT NULL CONSTRAINT Application_PersonRole_Application_SecurityRole FOREIGN KEY REFERENCES Application.SecurityRole (SecurityRoleId)
   ,CONSTRAINT Application_PersonRole_PersonId_SecurityRoleId PRIMARY KEY CLUSTERED (PersonId ASC, SecurityRoleId ASC)
   ,INDEX Application_PersonRole_PersonId NONCLUSTERED (PersonId ASC)
   ,INDEX Application_PersonRole_SecurityRoleId NONCLUSTERED (SecurityRoleId ASC)
);
GO

/**********************************************************************************************************************
** Create PersonLogin (https://kevinmartin.tech/go/customize-identity-model)
**********************************************************************************************************************/

CREATE TABLE Application.PersonLogin (
    LoginProvider       nvarchar(128) NOT NULL
   ,ProviderKey         nvarchar(128) NOT NULL
   ,ProviderDisplayName nvarchar(MAX) NULL
   ,PersonId            int           NOT NULL CONSTRAINT Application_PersonLogin_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CONSTRAINT Application_PersonLogin_LoginProvider_ProviderKey PRIMARY KEY CLUSTERED (LoginProvider ASC, ProviderKey ASC)
   ,INDEX Application_PersonLogin_PersonId NONCLUSTERED (PersonId ASC)
);
GO

/**********************************************************************************************************************
** Create PersonClaim (https://kevinmartin.tech/go/customize-identity-model)
**********************************************************************************************************************/

CREATE TABLE Application.PersonClaim (
    PersonClaimId int           IDENTITY(1, 1) NOT NULL
   ,PersonId      int           NOT NULL CONSTRAINT Application_PersonClaim_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ClaimType     nvarchar(MAX) NULL
   ,ClaimValue    nvarchar(MAX) NULL
   ,CONSTRAINT Application_PersonClaim_PersonClaimId PRIMARY KEY CLUSTERED (PersonClaimId ASC)
   ,INDEX Application_PersonClaim_PersonId NONCLUSTERED (PersonId ASC)
);
GO

/**********************************************************************************************************************
** Create RoleClaim (https://kevinmartin.tech/go/customize-identity-model)
**********************************************************************************************************************/

CREATE TABLE Application.SecurityRoleClaim (
    SecurityRoleClaimId int           IDENTITY(1, 1) NOT NULL
   ,SecurityRoleId      int           NOT NULL CONSTRAINT Application_SecurityRoleClaim_Application_SecurityRole FOREIGN KEY REFERENCES Application.SecurityRole (SecurityRoleId)
   ,ClaimType           nvarchar(MAX) NULL
   ,ClaimValue          nvarchar(MAX) NULL
   ,CONSTRAINT Application_SecurityRoleClaim_SecurityRoleClaimId PRIMARY KEY CLUSTERED (SecurityRoleClaimId ASC)
   ,INDEX Application_SecurityRoleClaim_SecurityRoleId NONCLUSTERED (SecurityRoleId ASC)
);
GO


/**********************************************************************************************************************
** Create LanguageCode
**********************************************************************************************************************/
CREATE TABLE Application.LanguageCode (
    LanguageCodeId int               IDENTITY(1, 1) NOT NULL
   ,LanguageName   nvarchar(100)     NOT NULL
   ,IsoAlpha2Code  varchar(2)        NOT NULL
   ,IsoAlpha3Code  varchar(3)        NOT NULL
   ,ModifyPersonId int               NOT NULL CONSTRAINT Application_LanguageCode_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId int               NOT NULL CONSTRAINT Application_LanguageCode_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_LanguageCode_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_LanguageCode_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_LanguageCode_LanguageCodeId PRIMARY KEY CLUSTERED (LanguageCodeId ASC)
   ,INDEX Application_LanguageCode_LanguageName UNIQUE NONCLUSTERED (LanguageName ASC)
   ,INDEX Application_LanguageCode_IsoAlpha2Code UNIQUE NONCLUSTERED (IsoAlpha2Code ASC)
   ,INDEX Application_LanguageCode_IsoAlpha3Code UNIQUE NONCLUSTERED (IsoAlpha3Code ASC)
   ,INDEX Application_LanguageCode_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_LanguageCode_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);

/**********************************************************************************************************************
** Create CountryRegion
**********************************************************************************************************************/

CREATE TABLE Application.CountryRegion (
    CountryRegionId int               NOT NULL IDENTITY(1, 1)
   ,CountryName     nvarchar(60)      NOT NULL
   ,FormalName      nvarchar(60)      NOT NULL
   ,IsoAlpha3Code   nvarchar(3)       NULL
   ,IsoNumericCode  int               NULL
   ,CountryType     nvarchar(20)      NULL
   ,Continent       nvarchar(30)      NOT NULL
   ,Region          nvarchar(30)      NOT NULL
   ,Subregion       nvarchar(30)      NOT NULL
   ,ModifyPersonId  int               NOT NULL CONSTRAINT Application_CountryRegion_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId  int               NOT NULL CONSTRAINT Application_CountryRegion_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime      datetimeoffset(7) NOT NULL CONSTRAINT Application_CountryRegion_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime      datetimeoffset(7) NOT NULL CONSTRAINT Application_CountryRegion_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp    rowversion        NOT NULL
   ,CONSTRAINT Application_CountryRegion_CountryRegionId PRIMARY KEY CLUSTERED (CountryRegionId ASC)
   ,INDEX Application_CountryRegion_CountryName UNIQUE NONCLUSTERED (CountryName ASC)
   ,INDEX Application_CountryRegion_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_CountryRegion_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Primary key for country or region records.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'CountryRegion'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CountryRegionId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Name of the country'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'CountryRegion'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CountryName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Full formal name of the country as agreed by United Nations'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'CountryRegion'
   ,@level2type = N'COLUMN'
   ,@level2name = N'FormalName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'3 letter alphabetic code assigned to the country by ISO'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'CountryRegion'
   ,@level2type = N'COLUMN'
   ,@level2name = N'IsoAlpha3Code';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Numeric code assigned to the country by ISO'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'CountryRegion'
   ,@level2type = N'COLUMN'
   ,@level2name = N'IsoNumericCode';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Type of country or administrative region'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'CountryRegion'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CountryType';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Name of the continent'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'CountryRegion'
   ,@level2type = N'COLUMN'
   ,@level2name = N'Continent';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Name of the region'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'CountryRegion'
   ,@level2type = N'COLUMN'
   ,@level2name = N'Region';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Name of the subregion'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'CountryRegion'
   ,@level2type = N'COLUMN'
   ,@level2name = N'Subregion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Country or Region that contain the states or provinces (including geographic boundaries)'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'CountryRegion';
GO

/**********************************************************************************************************************
** Create StateProvince
**********************************************************************************************************************/

CREATE TABLE Application.StateProvince (
    StateProvinceId   int               NOT NULL IDENTITY(1, 1)
   ,CountryRegionId   int               NOT NULL CONSTRAINT Application_StateProvince_Application_CountryRegion FOREIGN KEY REFERENCES Application.CountryRegion (CountryRegionId)
   ,StateProvinceCode nvarchar(5)       NULL
   ,StateProvinceName nvarchar(50)      NOT NULL
   ,ModifyPersonId    int               NOT NULL CONSTRAINT Application_StateProvince_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId    int               NOT NULL CONSTRAINT Application_StateProvince_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime        datetimeoffset(7) NOT NULL CONSTRAINT Application_StateProvince_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime        datetimeoffset(7) NOT NULL CONSTRAINT Application_StateProvince_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp      rowversion        NOT NULL
   ,CONSTRAINT Application_StateProvince_StateProvinceId PRIMARY KEY CLUSTERED (StateProvinceId ASC)
   ,INDEX Application_StateProvince_CountryRegionId_StateProvinceCode_StateProvinceName UNIQUE NONCLUSTERED (CountryRegionId ASC, StateProvinceCode ASC, StateProvinceName ASC)
   ,INDEX Application_StateProvince_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_StateProvince_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Primary key for state or province records.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'StateProvince'
   ,@level2type = N'COLUMN'
   ,@level2name = N'StateProvinceId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Country for this StateProvince'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'StateProvince'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CountryRegionId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Common code for this state or province (such as WA - Washington for the USA)'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'StateProvince'
   ,@level2type = N'COLUMN'
   ,@level2name = N'StateProvinceCode';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Formal name of the state or province'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'StateProvince'
   ,@level2type = N'COLUMN'
   ,@level2name = N'StateProvinceName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'States or provinces that contain City (including geographic location)'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'StateProvince';
GO

/**********************************************************************************************************************
** Create City
**********************************************************************************************************************/

CREATE TABLE Application.CityTown (
    CityTownId      int               NOT NULL IDENTITY(1, 1)
   ,StateProvinceId int               NOT NULL CONSTRAINT Application_CityTown_Application_StateProvince FOREIGN KEY REFERENCES Application.StateProvince (StateProvinceId)
   ,CityTownName    nvarchar(85)      NOT NULL
   ,ModifyPersonId  int               NOT NULL CONSTRAINT Application_CityTown_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId  int               NOT NULL CONSTRAINT Application_CityTown_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime      datetimeoffset(7) NOT NULL CONSTRAINT Application_CityTown_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime      datetimeoffset(7) NOT NULL CONSTRAINT Application_CityTown_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp    rowversion        NOT NULL
   ,CONSTRAINT Application_CityTown_CityTownId PRIMARY KEY CLUSTERED (CityTownId ASC)
   ,INDEX Application_CityTown_StateProvinceId_CityTownName UNIQUE NONCLUSTERED (StateProvinceId ASC, CityTownName ASC)
   ,INDEX Application_CityTown_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_CityTown_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Primary key for city or town records.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'CityTown'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CityTownId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'State or province for this city or town'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'CityTown'
   ,@level2type = N'COLUMN'
   ,@level2name = N'StateProvinceId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Formal name of the city or town'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'CityTown'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CityTownName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'City or town that are part of any address (including geographic location)'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'CityTown';
GO


/**********************************************************************************************************************
** Create AddressType
**********************************************************************************************************************/

CREATE TABLE Application.AddressType (
    AddressTypeId          int               NOT NULL IDENTITY(1, 1)
   --TODO: Should this be AddressTypeCode
   ,AddressTypeShortName   nvarchar(10)      NOT NULL
   ,AddressTypeName        nvarchar(50)      NOT NULL
   ,AddressTypeDescription nvarchar(300)     NULL
   ,SortOrderNumber        int               NULL
   ,IsDefault              bit               NOT NULL CONSTRAINT Application_AddressType_IsDefault_Default DEFAULT (0)
   ,IsLocked               bit               NOT NULL CONSTRAINT Application_AddressType_IsLocked_Default DEFAULT (0)
   ,IsActive               bit               NOT NULL CONSTRAINT Application_AddressType_IsActive_Default DEFAULT (1)
   ,ModifyPersonId         int               NOT NULL CONSTRAINT Application_AddressType_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId         int               NOT NULL CONSTRAINT Application_AddressType_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime             datetimeoffset(7) NOT NULL CONSTRAINT Application_AddressType_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime             datetimeoffset(7) NOT NULL CONSTRAINT Application_AddressType_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp           rowversion        NOT NULL
   ,CONSTRAINT Application_AddressType_AddressTypeId PRIMARY KEY CLUSTERED (AddressTypeId ASC)
   ,INDEX Application_AddressType_AddressTypeName_AddressTypeShortName UNIQUE NONCLUSTERED (AddressTypeName ASC, AddressTypeShortName ASC)
   ,INDEX Application_AddressType_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_AddressType_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Primary key for address type records.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'AddressType'
   ,@level2type = N'COLUMN'
   ,@level2name = N'AddressTypeId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Address type description. For example, Billing, Home, or Shipping.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'AddressType'
   ,@level2type = N'COLUMN'
   ,@level2name = N'AddressTypeName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Types of addresses stored in the Address table. '
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'AddressType';
GO

/**********************************************************************************************************************
** Create EmailType
**********************************************************************************************************************/

CREATE TABLE Application.EmailType (
    EmailTypeId          tinyint           NOT NULL IDENTITY(1, 1)
   ,EmailTypeName        nvarchar(50)      NOT NULL
   ,EmailTypeShortName   nvarchar(10)      NOT NULL
   ,EmailTypeDescription nvarchar(300)     NULL
   ,SortOrderNumber      int               NULL
   ,IsDefault            bit               NOT NULL CONSTRAINT Application_EmailType_IsDefault_Default DEFAULT (0)
   ,IsLocked             bit               NOT NULL CONSTRAINT Application_EmailType_IsLocked_Default DEFAULT (0)
   ,IsActive             bit               NOT NULL CONSTRAINT Application_EmailType_IsActive_Default DEFAULT (1)
   ,ModifyPersonId       int               NOT NULL CONSTRAINT Application_EmailType_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId       int               NOT NULL CONSTRAINT Application_EmailType_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime           datetimeoffset(7) NOT NULL CONSTRAINT Application_EmailType_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime           datetimeoffset(7) NOT NULL CONSTRAINT Application_EmailType_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp         rowversion        NOT NULL
   ,CONSTRAINT Application_EmailType_EmailTypeId PRIMARY KEY CLUSTERED (EmailTypeId ASC)
   ,INDEX Application_EmailType_EmailTypeName_EmailTypeShortName UNIQUE NONCLUSTERED (EmailTypeName ASC, EmailTypeShortName ASC)
   ,INDEX Application_EmailType_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_EmailType_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Primary key for email type records.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'EmailType'
   ,@level2type = N'COLUMN'
   ,@level2name = N'EmailTypeId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Email type description. For example, Work, Home.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'EmailType'
   ,@level2type = N'COLUMN'
   ,@level2name = N'EmailTypeName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Types of emails stored in the Email table.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'EmailType';
GO

/**********************************************************************************************************************
** Create Address
**********************************************************************************************************************/

CREATE TABLE Application.Address (
    AddressId      int               NOT NULL IDENTITY(1, 1)
   ,Line1          nvarchar(100)     NULL
   ,Line2          nvarchar(100)     NULL
   ,CityTownId     int               NULL CONSTRAINT Application_Address_Application_CityTown FOREIGN KEY REFERENCES Application.CityTown (CityTownId)
   ,PostalCode     nvarchar(12)      NULL
   ,ModifyPersonId int               NOT NULL CONSTRAINT Application_Address_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId int               NOT NULL CONSTRAINT Application_Address_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Address_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Address_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp   rowversion        NOT NULL
   ,ValidFromTime  datetime2(7)      GENERATED ALWAYS AS ROW START NOT NULL CONSTRAINT Address_ValidFromTime_Default DEFAULT (SYSUTCDATETIME())
   ,ValidToTime    datetime2(7)      GENERATED ALWAYS AS ROW END NOT NULL CONSTRAINT Vendor_ValidToTime_Default DEFAULT ('9999-12-31 23:59:59.9999999')
   ,CONSTRAINT Application_Address_AddressId PRIMARY KEY CLUSTERED (AddressId ASC)
   ,INDEX Application_Address_CityTownId NONCLUSTERED (CityTownId ASC)
   ,INDEX Application_Address_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_Address_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
   ,PERIOD FOR SYSTEM_TIME(ValidFromTime, ValidToTime)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = History.Address));
GO

--TODO: ??? Add https://docs.microsoft.com/en-us/sql/t-sql/spatial-geography/spatial-types-geography?redirectedfrom=MSDN&view=sql-server-ver15

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Foreign key to city.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Address'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CityTownId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Street address information for customers, vendors, people, locations, ...'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Address';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Primary key for address records.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Address'
   ,@level2type = N'COLUMN'
   ,@level2name = N'AddressId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'First street address line.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Address'
   ,@level2type = N'COLUMN'
   ,@level2name = N'Line1';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Second street address line.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Address'
   ,@level2type = N'COLUMN'
   ,@level2name = N'Line2';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Postal code for the street address.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Address'
   ,@level2type = N'COLUMN'
   ,@level2name = N'PostalCode';
GO

/**********************************************************************************************************************
** Create PersonEmail
**********************************************************************************************************************/

CREATE TABLE Application.PersonEmail (
    PersonEmailId  int               NOT NULL IDENTITY(1, 1)
   ,PersonId       int               NOT NULL CONSTRAINT Application_PersonEmail_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,EmailTypeId    tinyint           NOT NULL CONSTRAINT Application_PersonEmail_Application_EmailType FOREIGN KEY REFERENCES Application.EmailType (EmailTypeId)
   ,EmailAddress   nvarchar(254)     NOT NULL
   ,ModifyPersonId int               NOT NULL CONSTRAINT Application_PersonEmail_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId int               NOT NULL CONSTRAINT Application_PersonEmail_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_PersonEmail_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_PersonEmail_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_PersonEmail_PersonEmailId PRIMARY KEY CLUSTERED (PersonEmailId ASC)
   ,INDEX Application_PersonEmail_PersonId_EmailId_EmailTypeId UNIQUE NONCLUSTERED (PersonId ASC, EmailTypeId ASC, EmailAddress ASC)
   /* ,INDEX Application_PersonEmail_PersonId NONCLUSTERED (PersonId ASC) Do not need this index as it is the first key in the unique index */
   ,INDEX Application_PersonEmail_EmailTypeId NONCLUSTERED (EmailTypeId ASC)
   ,INDEX Application_PersonEmail_EmailAddress NONCLUSTERED (EmailAddress ASC)
   ,INDEX Application_PersonEmail_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_PersonEmail_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Primary key for person email records.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'PersonEmail'
   ,@level2type = N'COLUMN'
   ,@level2name = N'PersonEmailId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Foreign key to Person.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'PersonEmail'
   ,@level2type = N'COLUMN'
   ,@level2name = N'PersonId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Foreign key to EmailType.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'PersonEmail'
   ,@level2type = N'COLUMN'
   ,@level2name = N'EmailTypeId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Persons Email Address'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'PersonEmail'
   ,@level2type = N'COLUMN'
   ,@level2name = N'EmailAddress';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Email address of a person.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'PersonEmail';
GO

/**********************************************************************************************************************
** Create Residence - 

--TODO: This is an example of when to create a table as a strong entity/table.
        Instead of having a linking table, just create an ResidenceAddress table.
        You might encounter a requirement for security that utilizing a linking table makes it impossible to have a 
        discriminator to prevent read or modifications to a row.
**********************************************************************************************************************/

CREATE TABLE Application.Residence (
    ResidenceId    int               NOT NULL IDENTITY(1, 1)
   ,PersonId       int               NOT NULL CONSTRAINT Application_Residence_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,AddressTypeId  int               NOT NULL CONSTRAINT Application_Residence_Application_AddressType FOREIGN KEY REFERENCES Application.AddressType (AddressTypeId)
   ,Line1          nvarchar(100)     NULL
   ,Line2          nvarchar(100)     NULL
   ,CityTownId     int               NULL CONSTRAINT Application_Residence_Application_CityTown FOREIGN KEY REFERENCES Application.CityTown (CityTownId)
   ,PostalCode     nvarchar(12)      NULL
   ,ModifyPersonId int               NOT NULL CONSTRAINT Application_Residence_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId int               NOT NULL CONSTRAINT Application_Residence_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Residence_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Residence_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_Residence_ResidenceId PRIMARY KEY CLUSTERED (ResidenceId ASC)
   ,INDEX Application_Residence_PersonId NONCLUSTERED (PersonId ASC)
   ,INDEX Application_Residence_AddressTypeId NONCLUSTERED (AddressTypeId ASC)
   ,INDEX Application_Residence_CityTownId NONCLUSTERED (CityTownId ASC)
   ,INDEX Application_Residence_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_Residence_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Foreign key to city.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Residence'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CityTownId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Street address information for customers, vendors, people, locations, ...'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Residence';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Primary key for address records.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Residence'
   ,@level2type = N'COLUMN'
   ,@level2name = N'ResidenceId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'First street address line.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Residence'
   ,@level2type = N'COLUMN'
   ,@level2name = N'Line1';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Second street address line.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Residence'
   ,@level2type = N'COLUMN'
   ,@level2name = N'Line2';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Postal code for the street address.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Residence'
   ,@level2type = N'COLUMN'
   ,@level2name = N'PostalCode';
GO


--CREATE TABLE Application.Residence (
--    ResidenceId       int               NOT NULL IDENTITY(1, 1)
--   ,PersonId          int               NOT NULL CONSTRAINT Application_Residence_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
--   ,AddressId         int               NOT NULL CONSTRAINT Application_Residence_Application_Address FOREIGN KEY REFERENCES Application.Address (AddressId)
--   ,AddressTypeId     int               NOT NULL CONSTRAINT Application_Residence_Application_AddressType FOREIGN KEY REFERENCES Application.AddressType (AddressTypeId)
--   ,ModifyPersonId int               NOT NULL CONSTRAINT Application_Residence_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
--   ,CreatePersonId int               NOT NULL CONSTRAINT Application_Residence_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
--   ,ModifyTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Residence_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
--   ,CreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Residence_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
--   ,VersionStamp   rowversion        NOT NULL
--   ,CONSTRAINT Application_Residence_ResidenceId PRIMARY KEY CLUSTERED (ResidenceId ASC)
--   ,INDEX Application_Residence_PersonId_AddressId_AddressTypeId UNIQUE NONCLUSTERED (PersonId ASC, AddressId ASC, AddressTypeId ASC)
--   /* ,INDEX Application_Residence_PersonId NONCLUSTERED (PersonId ASC) Do not need this index as it is the first key in the unique index */
--   ,INDEX Application_Residence_AddressId NONCLUSTERED (AddressId ASC)
--   ,INDEX Application_Residence_AddressTypeId NONCLUSTERED (AddressTypeId ASC)
--   ,INDEX Application_Residence_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
--   ,INDEX Application_Residence_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
--);
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Primary key for residence records.'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Application'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'Residence'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'ResidenceId';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Foreign key to Person.'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Application'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'Residence'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'PersonId';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Foreign key to Address.'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Application'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'Residence'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'AddressId';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Foreign key to AddressType.'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Application'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'Residence'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'AddressTypeId';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'An address of a person.'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Application'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'Residence';
--GO

/**********************************************************************************************************************
** Create Organization 
**********************************************************************************************************************/

CREATE TABLE Application.Organization (
    OrganizationId   int               NOT NULL IDENTITY(1, 1)
   ,OrganizationName nvarchar(200)     NOT NULL
   ,WebsiteURL       nvarchar(2083)    NULL
   ,ModifyPersonId   int               NOT NULL CONSTRAINT Application_Organization_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId   int               NOT NULL CONSTRAINT Application_Organization_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime       datetimeoffset(7) NOT NULL CONSTRAINT Application_Organization_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime       datetimeoffset(7) NOT NULL CONSTRAINT Application_Organization_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp     rowversion        NOT NULL
   ,ValidFromTime    datetime2(7)      GENERATED ALWAYS AS ROW START NOT NULL CONSTRAINT Organization_ValidFromTime_Default DEFAULT (SYSUTCDATETIME())
   ,ValidToTime      datetime2(7)      GENERATED ALWAYS AS ROW END NOT NULL CONSTRAINT Organization_ValidToTime_Default DEFAULT ('9999-12-31 23:59:59.9999999')
   ,CONSTRAINT Application_Organization_OrganizationId PRIMARY KEY CLUSTERED (OrganizationId ASC)
   ,INDEX Application_Organization_OrganizationName NONCLUSTERED (OrganizationName ASC)
   ,INDEX Application_Organization_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_Organization_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
   ,PERIOD FOR SYSTEM_TIME(ValidFromTime, ValidToTime)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = History.Organization));
GO


/**********************************************************************************************************************
** Create Customer
**********************************************************************************************************************/

CREATE TABLE Sales.Customer (
    OrganizationId             int               NOT NULL CONSTRAINT Sales_Customer_Application_Organization FOREIGN KEY REFERENCES Application.Organization (OrganizationId)
   ,CreditLimit                decimal(18, 2)    NULL
   ,PaymentDays                int               NOT NULL
   ,IsOnCreditHold             bit               NOT NULL
   ,AccountOpenedDate          datetimeoffset(7) NOT NULL
   ,StandardDiscountPercentage decimal(18, 3)    NOT NULL
   ,ModifyPersonId             int               NOT NULL CONSTRAINT Sales_Customer_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId             int               NOT NULL CONSTRAINT Sales_Customer_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime                 datetimeoffset(7) NOT NULL CONSTRAINT Sales_Customer_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime                 datetimeoffset(7) NOT NULL CONSTRAINT Sales_Customer_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp               rowversion        NOT NULL
   ,CONSTRAINT Sales_Customer_OrganizationId PRIMARY KEY CLUSTERED (OrganizationId ASC)
   ,CONSTRAINT Sales_Customer_CreditLimit_Zero_Or_Greater CHECK (CreditLimit >= 0)
   ,CONSTRAINT Sales_Customer_PaymentDays_Zero_Or_Greater CHECK (PaymentDays >= 0)
   ,CONSTRAINT Sales_Customer_StandardDiscountPercentage_Zero_Or_Greater_To_One_Hundred CHECK (StandardDiscountPercentage >= 0 AND StandardDiscountPercentage <= 100)
   ,INDEX Sales_Customer_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Sales_Customer_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create Supplier
**********************************************************************************************************************/

CREATE TABLE Purchasing.Supplier (
    OrganizationId  int               NOT NULL CONSTRAINT Purchasing_Supplier_Application_Organization FOREIGN KEY REFERENCES Application.Organization (OrganizationId)
   ,PaymentDays     int               NOT NULL
   ,InternalComment nvarchar(MAX)     NULL
   ,ModifyPersonId  int               NOT NULL CONSTRAINT Purchasing_Supplier_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId  int               NOT NULL CONSTRAINT Purchasing_Supplier_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime      datetimeoffset(7) NOT NULL CONSTRAINT Purchasing_Supplier_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime      datetimeoffset(7) NOT NULL CONSTRAINT Purchasing_Supplier_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp    rowversion        NOT NULL
   ,CONSTRAINT Purchasing_Supplier_OrganizationId PRIMARY KEY CLUSTERED (OrganizationId ASC)
   ,CONSTRAINT Purchasing_Supplier_PaymentDays_Zero_Or_Greater CHECK (PaymentDays >= 0)
   ,INDEX Purchasing_Supplier_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Purchasing_Supplier_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create Location
**********************************************************************************************************************/

CREATE TABLE Application.Location (
    LocationId          int               NOT NULL IDENTITY(1, 1)
   ,OrganizationId      int               NOT NULL CONSTRAINT Application_Location_Application_Organization FOREIGN KEY REFERENCES Application.Organization (OrganizationId)
   ,AddressId           int               NOT NULL CONSTRAINT Application_Location_Application_Address FOREIGN KEY REFERENCES Application.Address (AddressId)
   ,AddressTypeId       int               NOT NULL CONSTRAINT Application_Location_Application_AddressType FOREIGN KEY REFERENCES Application.AddressType (AddressTypeId)
   ,LocationName        nvarchar(100)     NULL
   ,DeliverInstructions nvarchar(MAX)     NULL
   ,IsDeliverOnSunday   bit               NOT NULL
   ,IsDeliverOnSaturday bit               NOT NULL
   ,ModifyPersonId      int               NOT NULL CONSTRAINT Application_Location_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId      int               NOT NULL CONSTRAINT Application_Location_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime          datetimeoffset(7) NOT NULL CONSTRAINT Application_Location_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime          datetimeoffset(7) NOT NULL CONSTRAINT Application_Location_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp        rowversion        NOT NULL
   ,CONSTRAINT Application_Location_LocationId PRIMARY KEY CLUSTERED (LocationId ASC)
   ,INDEX Application_Location_OrganizationId_AddressId_AddressTypeId UNIQUE NONCLUSTERED (OrganizationId ASC, AddressId ASC, AddressTypeId ASC)
   /* ,INDEX Application_Location_OrganizationId NONCLUSTERED (OrganizationId ASC) Do not need this index as it is the first key on the unique index */
   ,INDEX Application_Location_AddressId NONCLUSTERED (AddressId ASC)
   ,INDEX Application_Location_AddressTypeId NONCLUSTERED (AddressTypeId ASC)
   ,INDEX Application_Location_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_Location_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create PhoneType
**********************************************************************************************************************/

CREATE TABLE Application.PhoneType (
    PhoneTypeId          tinyint           NOT NULL IDENTITY(1, 1)
   ,PhoneTypeName        nvarchar(20)      NOT NULL
   ,PhoneTypeShortName   nvarchar(10)      NOT NULL
   ,PhoneTypeDescription nvarchar(300)     NULL
   ,SortOrderNumber      int               NULL
   ,IsDefault            bit               NOT NULL CONSTRAINT Application_PhoneType_IsDefault_Default DEFAULT (0)
   ,IsLocked             bit               NOT NULL CONSTRAINT Application_PhoneType_IsLocked_Default DEFAULT (0)
   ,IsActive             bit               NOT NULL CONSTRAINT Application_PhoneType_IsActive_Default DEFAULT (1)
   ,ModifyPersonId       int               NOT NULL CONSTRAINT Application_PhoneType_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId       int               NOT NULL CONSTRAINT Application_PhoneType_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime           datetimeoffset(7) NOT NULL CONSTRAINT Application_PhoneType_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime           datetimeoffset(7) NOT NULL CONSTRAINT Application_PhoneType_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp         rowversion        NOT NULL
   ,CONSTRAINT Application_PhoneType_PhoneTypeId PRIMARY KEY CLUSTERED (PhoneTypeId ASC)
   ,INDEX Application_PhoneType_PhoneTypeName_PhoneTypeShortName UNIQUE NONCLUSTERED (PhoneTypeName ASC, PhoneTypeShortName ASC)
   ,INDEX Application_PhoneType_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_PhoneType_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create OrganizationPhone
**********************************************************************************************************************/

CREATE TABLE Application.OrganizationPhone (
    OrganizationPhoneId int               NOT NULL
   ,OrganizationId      int               NOT NULL CONSTRAINT Application_OrganizationPhone_Application_Organization FOREIGN KEY REFERENCES Application.Organization (OrganizationId)
   ,PhoneTypeId         tinyint           NOT NULL CONSTRAINT Application_OrganizationPhone_Application_PhoneType FOREIGN KEY REFERENCES Application.PhoneType (PhoneTypeId)
   ,PhoneNumber         nvarchar(50)      NOT NULL
   ,ModifyPersonId      int               NOT NULL CONSTRAINT Application_OrganizationPhone_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId      int               NOT NULL CONSTRAINT Application_OrganizationPhone_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime          datetimeoffset(7) NOT NULL CONSTRAINT Application_OrganizationPhone_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime          datetimeoffset(7) NOT NULL CONSTRAINT Application_OrganizationPhone_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp        rowversion        NOT NULL
   ,CONSTRAINT Application_OrganizationPhone_OrganizationPhoneId PRIMARY KEY CLUSTERED (OrganizationPhoneId ASC)
   ,INDEX Application_OrganizationPhone_OrganizationId_PhoneTypeId_PhoneNumber UNIQUE NONCLUSTERED (OrganizationId ASC, PhoneTypeId ASC, PhoneNumber ASC)
   /* ,INDEX Application_OrganizationPhone_PersonId NONCLUSTERED (OrganizationPhoneId ASC) Do not need as the this is the first key in the unique index */
   ,INDEX Application_OrganizationPhone_PhoneTypeId NONCLUSTERED (PhoneTypeId ASC)
   ,INDEX Application_OrganizationPhone_PhoneNumber NONCLUSTERED (PhoneNumber ASC)
   ,INDEX Application_OrganizationPhone_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_OrganizationPhone_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create OrganizationPerson
**********************************************************************************************************************/

CREATE TABLE Application.OrganizationPerson (
    OrganizationPersonId int               NOT NULL IDENTITY(1, 1)
   ,OrganizationId       int               NOT NULL CONSTRAINT Application_OrganizationPerson_Application_Organization FOREIGN KEY REFERENCES Application.Organization (OrganizationId)
   ,PersonId             int               NOT NULL CONSTRAINT Application_OrganizationPerson_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyPersonId       int               NOT NULL CONSTRAINT Application_OrganizationPerson_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId       int               NOT NULL CONSTRAINT Application_OrganizationPerson_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime           datetimeoffset(7) NOT NULL CONSTRAINT Application_OrganizationPerson_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime           datetimeoffset(7) NOT NULL CONSTRAINT Application_OrganizationPerson_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp         rowversion        NOT NULL
   ,CONSTRAINT Application_OrganizationPerson_OrganizationPersonId PRIMARY KEY CLUSTERED (OrganizationPersonId ASC)
   ,INDEX Application_OrganizationPerson_OrganizationId_PersonId UNIQUE NONCLUSTERED (OrganizationId ASC, PersonId ASC)
   /* ,INDEX Application_OrganizationPerson_OrganizationId NONCLUSTERED (OrganizationId ASC) Do not need as it is the first key in the unique index */
   ,INDEX Application_OrganizationPerson_PersonId NONCLUSTERED (PersonId ASC)
   ,INDEX Application_OrganizationPerson_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_OrganizationPerson_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create OrganizationEmail
**********************************************************************************************************************/

CREATE TABLE Application.OrganizationEmail (
    OrganizationEmailId int               NOT NULL IDENTITY(1, 1)
   ,OrganizationId      int               NOT NULL CONSTRAINT Application_OrganizationEmail_Application_Organization FOREIGN KEY REFERENCES Application.Organization (OrganizationId)
   ,EmailTypeId         tinyint           NOT NULL CONSTRAINT Application_OrganizationEmail_Application_EmailType FOREIGN KEY REFERENCES Application.EmailType (EmailTypeId)
   ,EmailAddress        nvarchar(254)     NOT NULL
   ,ModifyPersonId      int               NOT NULL CONSTRAINT Application_OrganizationEmail_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId      int               NOT NULL CONSTRAINT Application_OrganizationEmail_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime          datetimeoffset(7) NOT NULL CONSTRAINT Application_OrganizationEmail_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime          datetimeoffset(7) NOT NULL CONSTRAINT Application_OrganizationEmail_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp        rowversion        NOT NULL
   ,CONSTRAINT Application_OrganizationEmail_OrganizationEmailId PRIMARY KEY CLUSTERED (OrganizationEmailId ASC)
   ,INDEX Application_OrganizationEmail_OrganizationId_EmailId_EmailTypeId UNIQUE NONCLUSTERED (OrganizationId ASC, EmailTypeId ASC, EmailAddress ASC)
   /* ,INDEX Application_OrganizationEmail_OrganizationId NONCLUSTERED (OrganizationId ASC) Do not need as it is the first key in the unique index */
   ,INDEX Application_OrganizationEmail_EmailTypeId NONCLUSTERED (EmailTypeId ASC)
   ,INDEX Application_OrganizationEmail_EmailAddress NONCLUSTERED (EmailAddress ASC)
   ,INDEX Application_OrganizationEmail_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_OrganizationEmail_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Primary key for organization email records.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'OrganizationEmail'
   ,@level2type = N'COLUMN'
   ,@level2name = N'OrganizationEmailId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Foreign key to Organization.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'OrganizationEmail'
   ,@level2type = N'COLUMN'
   ,@level2name = N'OrganizationId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Foreign key to EmailType.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'OrganizationEmail'
   ,@level2type = N'COLUMN'
   ,@level2name = N'EmailTypeId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Organizations Email Address'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'OrganizationEmail'
   ,@level2type = N'COLUMN'
   ,@level2name = N'EmailAddress';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Email address of a organization.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'OrganizationEmail';
GO


/**********************************************************************************************************************
** Create PersonPhone
**********************************************************************************************************************/

CREATE TABLE Application.PersonPhone (
    PersonPhoneId  int               NOT NULL
   ,PersonId       int               NOT NULL CONSTRAINT Application_PersonPhone_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,PhoneTypeId    tinyint           NOT NULL CONSTRAINT Application_PersonPhone_Application_PhoneType FOREIGN KEY REFERENCES Application.PhoneType (PhoneTypeId)
   ,PhoneNumber    nvarchar(50)      NOT NULL
   ,ModifyPersonId int               NOT NULL CONSTRAINT Application_PersonPhone_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId int               NOT NULL CONSTRAINT Application_PersonPhone_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_PersonPhone_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_PersonPhone_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_PersonPhone_PersonPhoneId PRIMARY KEY CLUSTERED (PersonPhoneId ASC)
   ,INDEX Application_PersonPhone_PersonId_PhoneTypeId_PhoneNumber UNIQUE NONCLUSTERED (PersonId ASC, PhoneTypeId ASC, PhoneNumber ASC)
   /* ,INDEX Application_PersonPhone_PersonId NONCLUSTERED (PersonId ASC) Do not need as it is the first key in the unique index */
   ,INDEX Application_PersonPhone_PhoneTypeId NONCLUSTERED (PhoneTypeId ASC)
   ,INDEX Application_PersonPhone_PhoneNumber NONCLUSTERED (PhoneNumber ASC)
   ,INDEX Application_PersonPhone_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_PersonPhone_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create LocationPhone
**********************************************************************************************************************/

CREATE TABLE Application.LocationPhone (
    LocationPhoneId int               NOT NULL IDENTITY(1, 1)
   ,LocationId      int               NOT NULL CONSTRAINT Application_LocationPhone_Application_Location FOREIGN KEY REFERENCES Application.Location (LocationId)
   ,PhoneTypeId     tinyint           NOT NULL CONSTRAINT Application_LocationPhone_Application_PhoneType FOREIGN KEY REFERENCES Application.PhoneType (PhoneTypeId)
   ,PhoneNumber     nvarchar(50)      NOT NULL
   ,ModifyPersonId  int               NOT NULL CONSTRAINT Application_LocationPhone_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId  int               NOT NULL CONSTRAINT Application_LocationPhone_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime      datetimeoffset(7) NOT NULL CONSTRAINT Application_LocationPhone_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime      datetimeoffset(7) NOT NULL CONSTRAINT Application_LocationPhone_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp    rowversion        NOT NULL
   ,CONSTRAINT Application_LocationPhone_LocationPhoneId PRIMARY KEY CLUSTERED (LocationPhoneId ASC)
   ,INDEX Application_LocationPhone_LocationId_PhoneTypeId_PhoneNumber UNIQUE NONCLUSTERED (LocationId ASC, PhoneTypeId ASC, PhoneNumber ASC)
   /* ,INDEX Application_LocationPhone_LocationId NONCLUSTERED (LocationId ASC) Do not need as it is the first key in the unique index */
   ,INDEX Application_LocationPhone_PhoneTypeId NONCLUSTERED (PhoneTypeId ASC)
   ,INDEX Application_LocationPhone_PhoneNumber NONCLUSTERED (PhoneNumber ASC)
   ,INDEX Application_LocationPhone_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_LocationPhone_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create DeliveryType
**********************************************************************************************************************/

CREATE TABLE Application.DeliveryType (
    DeliveryTypeId          tinyint           NOT NULL IDENTITY(1, 1)
   ,DeliveryTypeName        nvarchar(50)      NOT NULL
   ,DeliveryTypeShortName   nvarchar(10)      NOT NULL
   ,DeliveryTypeDescription nvarchar(300)     NULL
   ,SortOrderNumber         int               NULL
   ,IsDefault               bit               NOT NULL CONSTRAINT Application_DeliveryType_IsDefault_Default DEFAULT (0)
   ,IsLocked                bit               NOT NULL CONSTRAINT Application_DeliveryType_IsLocked_Default DEFAULT (0)
   ,IsActive                bit               NOT NULL CONSTRAINT Application_DeliveryType_IsActive_Default DEFAULT (1)
   ,ModifyPersonId          int               NOT NULL CONSTRAINT Application_DeliveryType_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId          int               NOT NULL CONSTRAINT Application_DeliveryType_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime              datetimeoffset(7) NOT NULL CONSTRAINT Application_DeliveryType_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime              datetimeoffset(7) NOT NULL CONSTRAINT Application_DeliveryType_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp            rowversion        NOT NULL
   ,CONSTRAINT Application_DeliveryType_DeliveryTypeId PRIMARY KEY CLUSTERED (DeliveryTypeId ASC)
   ,INDEX Application_DeliveryType_DeliveryTypeName_DeliveryTypeShortName UNIQUE NONCLUSTERED (DeliveryTypeName ASC, DeliveryTypeShortName ASC)
   ,INDEX Application_DeliveryType_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_DeliveryType_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create Category
**********************************************************************************************************************/

--TODO: Should this be ProductCategory??? What to do with the linking table ProductCategory???

CREATE TABLE Application.Category (
    CategoryId         int               NOT NULL IDENTITY(1, 1)
   ,ParentIdCategoryId int               NULL CONSTRAINT Application_Category_Application_ParentIdCategoryId FOREIGN KEY REFERENCES Application.Category (CategoryId)
   ,CategoryName       nvarchar(200)     NOT NULL
   ,CategorySlug       nvarchar(400)     NOT NULL
   ,ModifyPersonId     int               NOT NULL CONSTRAINT Application_Category_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId     int               NOT NULL CONSTRAINT Application_Category_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime         datetimeoffset(7) NOT NULL CONSTRAINT Application_Category_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime         datetimeoffset(7) NOT NULL CONSTRAINT Application_Category_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp       rowversion        NOT NULL
   ,CONSTRAINT Application_Category_CategoryId PRIMARY KEY CLUSTERED (CategoryId ASC)
   ,INDEX Application_Category_ParentIdCategoryId NONCLUSTERED (ParentIdCategoryId ASC)
   ,INDEX Application_Category_CategorySlug UNIQUE NONCLUSTERED (CategorySlug ASC)
   ,INDEX Application_Category_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_Category_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO


/**********************************************************************************************************************
** Create Product
**********************************************************************************************************************/

CREATE TABLE Application.Product (
    ProductId          int               NOT NULL IDENTITY(1, 1)
   ,ProductName        nvarchar(200)     NOT NULL
   ,ProductSlug        nvarchar(400)     NOT NULL
   ,ProductDescription nvarchar(MAX)     NULL
   ,ModifyPersonId     int               NOT NULL CONSTRAINT Application_Product_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId     int               NOT NULL CONSTRAINT Application_Product_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime         datetimeoffset(7) NOT NULL CONSTRAINT Application_Product_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime         datetimeoffset(7) NOT NULL CONSTRAINT Application_Product_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp       rowversion        NOT NULL
   ,CONSTRAINT Application_Product_ProductId PRIMARY KEY CLUSTERED (ProductId ASC)
   ,INDEX Application_Product_ProductName UNIQUE NONCLUSTERED (ProductName ASC)
   ,INDEX Application_Product_ProductSlug UNIQUE NONCLUSTERED (ProductSlug ASC)
   ,INDEX Application_Product_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_Product_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create Image
**********************************************************************************************************************/

CREATE TABLE Application.Image (
    ImageId        int               NOT NULL IDENTITY(1, 1)
   ,ImageURL       nvarchar(2083)    NOT NULL
   ,ModifyPersonId int               NOT NULL CONSTRAINT Application_Image_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId int               NOT NULL CONSTRAINT Application_Image_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Image_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Image_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_Image_ImageId PRIMARY KEY CLUSTERED (ImageId ASC)
   ,INDEX Application_Image_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_Image_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO


/**********************************************************************************************************************
** Create ProductImage
**********************************************************************************************************************/

CREATE TABLE Application.ProductImage (
    ProductImageId  int               IDENTITY(1, 1) NOT NULL
   ,ProductId       int               NOT NULL CONSTRAINT Application_ProductImage_Application_Product FOREIGN KEY REFERENCES Application.Product (ProductId)
   ,ImageId         int               NOT NULL CONSTRAINT Application_ProductImage_Application_Image FOREIGN KEY REFERENCES Application.Image (ImageId)
   ,IsThumbnail     bit               NOT NULL CONSTRAINT Application_ProductImage_IsThumbnail_Default DEFAULT (0)
   ,SortOrderNumber int               NULL
   ,ModifyPersonId  int               NOT NULL CONSTRAINT Application_ProductImage_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId  int               NOT NULL CONSTRAINT Application_ProductImage_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime      datetimeoffset(7) NOT NULL CONSTRAINT Application_ProductImage_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime      datetimeoffset(7) NOT NULL CONSTRAINT Application_ProductImage_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp    rowversion        NOT NULL
   ,CONSTRAINT Application_ProductImage_ProductImageId PRIMARY KEY CLUSTERED (ProductImageId ASC)
   ,INDEX Application_ProductImage_ProductId_ImageId UNIQUE NONCLUSTERED (ProductId ASC, ImageId ASC)
   ,INDEX Application_ProductImage_ImageId NONCLUSTERED (ImageId ASC)
   ,INDEX Application_ProductImage_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_ProductImage_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO


/**********************************************************************************************************************
** Create ProductCategory
**********************************************************************************************************************/

CREATE TABLE Application.ProductCategory (
    ProductCategoryId int               NOT NULL IDENTITY(1, 1)
   ,ProductId         int               NOT NULL CONSTRAINT Application_ProductCategory_Application_Product FOREIGN KEY REFERENCES Application.Product (ProductId)
   ,CategoryId        int               NOT NULL CONSTRAINT Application_ProductCategory_Application_Category FOREIGN KEY REFERENCES Application.Category (CategoryId)
   ,ModifyPersonId    int               NOT NULL CONSTRAINT Application_ProductCategory_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId    int               NOT NULL CONSTRAINT Application_ProductCategory_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime        datetimeoffset(7) NOT NULL CONSTRAINT Application_ProductCategory_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime        datetimeoffset(7) NOT NULL CONSTRAINT Application_ProductCategory_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp      rowversion        NOT NULL
   ,CONSTRAINT Application_ProductCategory_ProductCategoryId PRIMARY KEY CLUSTERED (ProductCategoryId ASC)
   ,INDEX Application_ProductCategory_ UNIQUE NONCLUSTERED (ProductId ASC, CategoryId ASC)
   /* ,INDEX Application_ProductCategory_ProductId NONCLUSTERED (ProductId ASC) Do not need as it is the first key */
   ,INDEX Application_ProductCategory_CategoryId NONCLUSTERED (CategoryId ASC)
   ,INDEX Application_ProductCategory_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_ProductCategory_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create Attribute
**********************************************************************************************************************/

CREATE TABLE Application.Attribute (
    AttributeId    int               NOT NULL IDENTITY(1, 1)
   ,AttributeName  nvarchar(100)     NOT NULL
   ,ModifyPersonId int               NOT NULL CONSTRAINT Application_Attribute_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId int               NOT NULL CONSTRAINT Application_Attribute_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Attribute_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Attribute_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_Attribute_AttributeId PRIMARY KEY CLUSTERED (AttributeId ASC)
   ,INDEX Application_Attribute_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_Attribute_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create AttributeTerm
**********************************************************************************************************************/

CREATE TABLE Application.AttributeTerm (
    AttributeTermId int               NOT NULL IDENTITY(1, 1)
   ,AttributeId     int               NOT NULL CONSTRAINT Application_AttributeTerm_Application_Attribute FOREIGN KEY REFERENCES Application.Attribute (AttributeId)
   ,TermName        nvarchar(100)     NOT NULL
   ,ModifyPersonId  int               NOT NULL CONSTRAINT Application_AttributeTerm_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId  int               NOT NULL CONSTRAINT Application_AttributeTerm_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime      datetimeoffset(7) NOT NULL CONSTRAINT Application_AttributeTerm_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime      datetimeoffset(7) NOT NULL CONSTRAINT Application_AttributeTerm_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp    rowversion        NOT NULL
   ,CONSTRAINT Application_AttributeTerm_AttributeTermId PRIMARY KEY CLUSTERED (AttributeTermId ASC)
   ,INDEX Application_AttributeTerm_AttributeId NONCLUSTERED (AttributeId ASC)
   ,INDEX Application_AttributeTerm_TermName NONCLUSTERED (TermName ASC)
   ,INDEX Application_AttributeTerm_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_AttributeTerm_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create ProductItem
**********************************************************************************************************************/
CREATE TABLE Application.ProductItem (
    ProductItemId     int               NOT NULL IDENTITY(1, 1)
   ,ProductId         int               NOT NULL CONSTRAINT Application_ProductItem_Application_Product FOREIGN KEY REFERENCES Application.Product (ProductId)
   ,UPC               varchar(12)       NULL
   ,IsEnable          bit               NOT NULL
   ,IsVirtual         bit               NOT NULL
   ,RegularPrice      decimal(18, 2)    NOT NULL
   ,SalePrice         decimal(18, 2)    NULL
   ,ManufactureCost   decimal(18, 2)    NULL
   ,DaysToManufacture int               NULL
   ,ModifyPersonId    int               NOT NULL CONSTRAINT Application_ProductItem_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId    int               NOT NULL CONSTRAINT Application_ProductItem_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime        datetimeoffset(7) NOT NULL CONSTRAINT Application_ProductItem_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime        datetimeoffset(7) NOT NULL CONSTRAINT Application_ProductItem_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp      rowversion        NOT NULL
   ,CONSTRAINT Application_ProductItem_ProductItemId PRIMARY KEY CLUSTERED (ProductItemId ASC)
   ,CONSTRAINT Application_ProductItem_RegularPrice_Zero_Or_Greater CHECK (RegularPrice >= 0)
   ,CONSTRAINT Application_ProductItem_SalePrice_Zero_Or_Greater CHECK (SalePrice >= 0)
   ,CONSTRAINT Application_ProductItem_SalePrice_Less_Than_Or_Equal_To_RegularPrice CHECK (SalePrice <= RegularPrice)
   ,INDEX Application_ProductItem_ProductId NONCLUSTERED (ProductId ASC)
   ,INDEX Application_ProductItem_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_ProductItem_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO


/**********************************************************************************************************************
** Create ProductVariant
**********************************************************************************************************************/

CREATE TABLE Application.ProductVariant (
    ProductVariantId int               NOT NULL IDENTITY(1, 1)
   ,ProductItemId    int               NOT NULL CONSTRAINT Application_ProductVariant_Application_ProductItem FOREIGN KEY REFERENCES Application.ProductItem (ProductItemId)
   ,AttributeTermId  int               NOT NULL CONSTRAINT Application_ProductVariant_Application_AttributeTerm FOREIGN KEY REFERENCES Application.AttributeTerm (AttributeTermId)
   ,ModifyPersonId   int               NOT NULL CONSTRAINT Application_ProductVariant_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId   int               NOT NULL CONSTRAINT Application_ProductVariant_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime       datetimeoffset(7) NOT NULL CONSTRAINT Application_ProductVariant_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime       datetimeoffset(7) NOT NULL CONSTRAINT Application_ProductVariant_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp     rowversion        NOT NULL
   ,CONSTRAINT Application_ProductVariant_ProductVariantId PRIMARY KEY CLUSTERED (ProductVariantId ASC)
   ,INDEX Application_ProductVariant_ProductItemId NONCLUSTERED (ProductItemId ASC)
   ,INDEX Application_ProductVariant_AttributeTermId NONCLUSTERED (AttributeTermId ASC)
   ,INDEX Application_ProductVariant_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_ProductVariant_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create PurchaseOrder
**********************************************************************************************************************/
CREATE TABLE Purchasing.PurchaseOrder (
    PurchaseOrderId      int               NOT NULL IDENTITY(1000, 1)
   ,RevisionNumber       tinyint           NOT NULL CONSTRAINT Purchasing_PurchaseOrder_RevisionNumber_Default DEFAULT (0)
   ,OrganizationId       int               NOT NULL CONSTRAINT Purchasing_PurchaseOrder_Application_OrganizationId FOREIGN KEY REFERENCES Purchasing.Supplier (OrganizationId)
   ,OrderDate            datetimeoffset(7) NOT NULL CONSTRAINT Purchasing_PurchaseOrder_OrderDate_Default DEFAULT (SYSDATETIMEOFFSET())
   ,ShipDate             datetimeoffset(7) NULL
   ,ExpectedDeliveryDate datetimeoffset(7) NULL
   ,SupplierReference    nvarchar(20)      NULL
   ,IsOrderFinalized     bit               NOT NULL CONSTRAINT Purchasing_PurchaseOrder_IsOrderFinalized_Default DEFAULT (0)
   ,DeliveryTypeId       tinyint           NOT NULL CONSTRAINT Purchasing_PurchaseOrder_Application_DeliveryType FOREIGN KEY REFERENCES Application.DeliveryType (DeliveryTypeId)
   ,ContactPersonId      int               NOT NULL CONSTRAINT Purchasing_PurchaseOrder_Application_ContactPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,SubTotal             decimal(18, 2)    NOT NULL CONSTRAINT Purchasing_PurchaseOrder_SubTotal_Default DEFAULT (0.00)
   ,TaxAmount            decimal(18, 2)    NOT NULL CONSTRAINT Purchasing_PurchaseOrder_TaxAmount_Default DEFAULT (0.00)
   ,FreightAmount        decimal(18, 2)    NOT NULL CONSTRAINT Purchasing_PurchaseOrder_FreightAmount_Default DEFAULT (0.00)
   ,TotalDue             AS (ISNULL((SubTotal + TaxAmount) + FreightAmount, (0)))
   ,OrderComment         nvarchar(MAX)     NULL
   ,ModifyPersonId       int               NOT NULL CONSTRAINT Purchasing_PurchaseOrder_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId       int               NOT NULL CONSTRAINT Purchasing_PurchaseOrder_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime           datetimeoffset(7) NOT NULL CONSTRAINT Purchasing_PurchaseOrder_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime           datetimeoffset(7) NOT NULL CONSTRAINT Purchasing_PurchaseOrder_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp         rowversion        NOT NULL
   ,CONSTRAINT Purchasing_PurchaseOrder_PurchaseOrderId PRIMARY KEY CLUSTERED (PurchaseOrderId ASC)
   ,CONSTRAINT Purchasing_PurchaseOrder_ShipDate_After_OrderDate_Or_NULL CHECK (ShipDate >= OrderDate OR ShipDate IS NULL)
   ,CONSTRAINT Purchasing_PurchaseOrder_ExpectedDeliveryDate_After_ShipDate CHECK (ExpectedDeliveryDate >= ShipDate OR ExpectedDeliveryDate IS NULL)
   ,INDEX Purchasing_PurchaseOrder_OrganizationId NONCLUSTERED (OrganizationId ASC)
   ,INDEX Purchasing_PurchaseOrder_DeliveryTypeId NONCLUSTERED (DeliveryTypeId ASC)
   ,INDEX Purchasing_PurchaseOrder_ContactPersonId NONCLUSTERED (ContactPersonId ASC)
   ,INDEX Purchasing_PurchaseOrder_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Purchasing_PurchaseOrder_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Numeric Id used for reference to a purchase order within the database'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrder'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'PurchaseOrderId';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Supplier for this purchase order'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrder'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'SupplierId';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Date that this purchase order was raised'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrder'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'OrderDate';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'How this purchase order should be delivered'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrder'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'DeliveryTypeId';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'The person who is the primary contact for this purchase order'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrder'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'ContactPersonId';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Expected delivery date for this purchase order'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrder'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'ExpectedDeliveryDate';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Supplier reference for our organization (might be our account number at the supplier)'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrder'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'SupplierReference';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Is this purchase order now considered finalized?'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrder'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'IsOrderFinalized';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Any comments related this purchase order (comments sent to the supplier)'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrder'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'Comment';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Details of supplier purchase orders'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrder';
--GO

/**********************************************************************************************************************
** Create UnitType
**********************************************************************************************************************/

CREATE TABLE Application.UnitType (
    UnitTypeId          tinyint           NOT NULL IDENTITY(1, 1)
   ,UnitTypeName        nvarchar(50)      NOT NULL
   ,UnitTypeShortName   nvarchar(10)      NOT NULL
   ,UnitTypeDescription nvarchar(300)     NULL
   ,SortOrderNumber     int               NULL
   ,IsDefault           bit               NOT NULL CONSTRAINT Application_UnitType_IsDefault_Default DEFAULT (0)
   ,IsLocked            bit               NOT NULL CONSTRAINT Application_UnitType_IsLocked_Default DEFAULT (0)
   ,IsActive            bit               NOT NULL CONSTRAINT Application_UnitType_IsActive_Default DEFAULT (1)
   ,ModifyPersonId      int               NOT NULL CONSTRAINT Application_UnitType_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId      int               NOT NULL CONSTRAINT Application_UnitType_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime          datetimeoffset(7) NOT NULL CONSTRAINT Application_UnitType_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime          datetimeoffset(7) NOT NULL CONSTRAINT Application_UnitType_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp        rowversion        NOT NULL
   ,CONSTRAINT Application_UnitType_UnitTypeId PRIMARY KEY CLUSTERED (UnitTypeId ASC)
   ,INDEX Application_UnitType_UnitTypeName_UnitTypeShortName UNIQUE NONCLUSTERED (UnitTypeName ASC, UnitTypeShortName ASC)
   ,INDEX Application_UnitType_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Application_UnitType_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Primary key for unit type records.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'UnitType'
   ,@level2type = N'COLUMN'
   ,@level2name = N'UnitTypeId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Unit type description. For example, Each, Bag, Pallet.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'UnitType'
   ,@level2type = N'COLUMN'
   ,@level2name = N'UnitTypeName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Types of units stored in the Unit table.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'UnitType';
GO

/**********************************************************************************************************************
** Create PurchaseOrderLines
**********************************************************************************************************************/
--yyyyyy
CREATE TABLE Purchasing.PurchaseOrderLine (
    PurchaseOrderLineId  int               NOT NULL IDENTITY(1, 1)
   ,PurchaseOrderId      int               NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_Purchasing_PurchaseOrder FOREIGN KEY REFERENCES Purchasing.PurchaseOrder (PurchaseOrderId)
   ,ProductItemId        int               NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_Application_ProductItem FOREIGN KEY REFERENCES Application.ProductItem (ProductItemId)
   ,UnitTypeId           tinyint           NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_Application_UnitType FOREIGN KEY REFERENCES Application.UnitType (UnitTypeId)
   ,QuantityOrdered      int               NOT NULL /* Assess if fractional quantities are required */
   ,QuantityReceived     int               NOT NULL /* Assess if fractional quantities are required */
   ,UnitPrice            decimal(18, 2)    NOT NULL
   ,DiscountPercentage   decimal(18, 3)    NULL
   ,NetAmount            decimal(18, 2)    NOT NULL
   ,IsOrderLineFinalized bit               NOT NULL
   ,ModifyPersonId       int               NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId       int               NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime           datetimeoffset(7) NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime           datetimeoffset(7) NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp         rowversion        NOT NULL
   ,CONSTRAINT Purchasing_PurchaseOrderLine_PurchaseOrderLineId PRIMARY KEY CLUSTERED (PurchaseOrderLineId ASC)
   ,CONSTRAINT Purchasing_PurchaseOrderLine_QuantityOrdered_Zero_Or_Greater CHECK (QuantityOrdered >= 0)
   ,CONSTRAINT Purchasing_PurchaseOrderLine_QuantityReceived_Zero_Or_Greater CHECK (QuantityReceived >= 0)
   ,CONSTRAINT Purchasing_PurchaseOrderLine_UnitPrice_Zero_Or_Greater CHECK (UnitPrice >= 0)
   ,CONSTRAINT Purchasing_PurchaseOrderLine_DiscountPercentage_Zero_Or_Greater_To_One_Hundred CHECK (DiscountPercentage >= 0 AND DiscountPercentage <= 100)
   ,CONSTRAINT Purchasing_PurchaseOrderLine_NetAmount_Zero_Or_Greater CHECK (NetAmount >= 0)
   ,INDEX Purchasing_PurchaseOrderLine_PurchaseOrderId NONCLUSTERED (PurchaseOrderId ASC)
   ,INDEX Purchasing_PurchaseOrderLine_ProductItemId NONCLUSTERED (ProductItemId ASC)
   ,INDEX Purchasing_PurchaseOrderLine_UnitTypeId NONCLUSTERED (UnitTypeId ASC)
   ,INDEX Purchasing_PurchaseOrderLine_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Purchasing_PurchaseOrderLine_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Numeric ID used for reference to a line on a purchase order within the database'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrderLine'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'PurchaseOrderLineId';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Purchase order that this line is associated with'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrderLine'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'PurchaseOrderId';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Stock item for this purchase order line'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrderLine'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'ProductItemId';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Quantity of the stock item that is ordered'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrderLine'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'QuantityOrdered';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Total quantity of the stock item that has been received so far'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrderLine'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'QuantityReceived';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Type of package received'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrderLine'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'UnitTypeId';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'The unit price that we expect to be charged'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrderLine'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'UnitPrice';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'The discount percent that we expect to receive'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrderLine'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'DiscountPercentage';
--GO


--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'The net amount that we expect to be charged'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrderLine'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'NetAmount';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Is this purchase order line now considered finalized? (Receipted quantities and weights are often not precise)'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrderLine'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'IsOrderLineFinalized';
--GO

--EXEC sys.sp_addextendedproperty
--    @name = N'MS_Description'
--   ,@value = N'Detail lines from supplier purchase order'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrderLine';
--GO

/**********************************************************************************************************************
** Credit Card
**********************************************************************************************************************/

CREATE TABLE Sales.CreditCard (
    CreditCardId          int               IDENTITY(1, 1) NOT NULL
   ,CardType              nvarchar(50)      NOT NULL
   ,CardNumber            nvarchar(25)      NOT NULL
   ,CardVerificationValue smallint          NOT NULL CONSTRAINT Sales_CreditCard_CardVerificationValue_Zero_To_Four_Digits CHECK (CardVerificationValue >= 0 OR CardVerificationValue <= 9999)
   ,ExpirationMonth       tinyint           NOT NULL CONSTRAINT Sales_CreditCard_ExpirationMonth_Valid_Month_Number CHECK (ExpirationMonth >= 1 OR ExpirationMonth <= 12)
   ,ExpirationYear        smallint          NOT NULL CONSTRAINT Sales_CreditCard_ExpirationYear_Valid_Year_Or_Greater CHECK (ExpirationYear >= YEAR(SYSDATETIMEOFFSET()))
   ,ModifyPersonId        int               NOT NULL CONSTRAINT Sales_CreditCard_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId        int               NOT NULL CONSTRAINT Sales_CreditCard_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime            datetimeoffset(7) NOT NULL CONSTRAINT Sales_CreditCard_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime            datetimeoffset(7) NOT NULL CONSTRAINT Sales_CreditCard_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp          rowversion        NOT NULL
   ,CONSTRAINT Sales_CreditCard_CreditCardId PRIMARY KEY CLUSTERED (CreditCardId ASC)
   ,INDEX Sales_CreditCard_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Sales_CreditCard_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);


--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key for CreditCard records.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'CreditCard', @level2type=N'COLUMN',@level2name=N'CreditCardId'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Credit card name.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'CreditCard', @level2type=N'COLUMN',@level2name=N'CardType'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Credit card number.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'CreditCard', @level2type=N'COLUMN',@level2name=N'CardNumber'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Credit card expiration month.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'CreditCard', @level2type=N'COLUMN',@level2name=N'ExpMonth'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Credit card expiration year.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'CreditCard', @level2type=N'COLUMN',@level2name=N'ExpYear'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date and time the record was last updated.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'CreditCard', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of GETDATE()' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'CreditCard', @level2type=N'CONSTRAINT',@level2name=N'DF_CreditCard_ModifiedDate'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key (clustered) constraint' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'CreditCard', @level2type=N'CONSTRAINT',@level2name=N'PK_CreditCard_CreditCardID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer credit card information.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'CreditCard'
--GO




/**********************************************************************************************************************
** Sales Order
**********************************************************************************************************************/

CREATE TABLE Sales.SalesOrder (
    SalesOrderId           int               NOT NULL IDENTITY(1000, 1)
   ,SalesOrderNumber       AS (ISNULL(N'SO' + CONVERT(nvarchar(23), SalesOrderId), N'*** ERROR ***'))
   ,RevisionNumber         tinyint           NOT NULL CONSTRAINT Sales_SalesOrder_RevisionNumber_Default DEFAULT (0)
   ,OrganizationId         int               NOT NULL CONSTRAINT Sales_SalesOrder_Application_OrganizationId FOREIGN KEY REFERENCES Sales.Customer (OrganizationId)
   ,OrderDate              datetimeoffset(7) NOT NULL CONSTRAINT Sales_SalesOrder_OrderDate_Default DEFAULT (SYSDATETIMEOFFSET())
   ,DueDate                datetimeoffset(7) NOT NULL
   ,ShipDate               datetimeoffset(7) NULL --
   ,PurchaseOrderNumber    nvarchar(50)      NULL
   ,IsOrderFinalized       bit               NOT NULL CONSTRAINT Sales_SalesOrder_IsOrderFinalized_Default DEFAULT (0)
   ,IsOnlineOrder          bit               NOT NULL CONSTRAINT Sales_SalesOrder_IsOnlineOrder_Default DEFAULT (1)
   ,DeliveryTypeId         tinyint           NOT NULL CONSTRAINT Sales_SalesOrder_Application_DeliveryType FOREIGN KEY REFERENCES Application.DeliveryType (DeliveryTypeId)
   ,SalesPersonId          int               NOT NULL CONSTRAINT Sales_SalesOrder_Application_SalesPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,BillToLocationId       int               NOT NULL CONSTRAINT Sales_SalesOrder_Application_BillToLocation FOREIGN KEY REFERENCES Application.Location (LocationId)
   ,ShipToLocationId       int               NOT NULL CONSTRAINT Sales_SalesOrder_Application_ShipToLocation FOREIGN KEY REFERENCES Application.Location (LocationId)
   ,CreditCardId           int               NULL CONSTRAINT Sales_SalesOrder_Application_CreditCardId FOREIGN KEY REFERENCES Sales.CreditCard (CreditCardId)
   ,CreditCardApprovalCode varchar(15)       NULL
   ,SubTotal               decimal(18, 2)    NOT NULL CONSTRAINT Sales_SalesOrder_SubTotal_Default DEFAULT (0.00)
   ,TaxAmount              decimal(18, 2)    NOT NULL CONSTRAINT Sales_SalesOrder_TaxAmount_Default DEFAULT (0.00)
   ,FreightAmount          decimal(18, 2)    NOT NULL CONSTRAINT Sales_SalesOrder_FreightAmount_Default DEFAULT (0.00)
   ,TotalDue               AS (ISNULL((SubTotal + TaxAmount) + FreightAmount, (0)))
   ,OrderComment           nvarchar(MAX)     NULL
   ,ModifyPersonId         int               NOT NULL CONSTRAINT Sales_SalesOrder_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId         int               NOT NULL CONSTRAINT Sales_SalesOrder_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime             datetimeoffset(7) NOT NULL CONSTRAINT Sales_SalesOrder_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime             datetimeoffset(7) NOT NULL CONSTRAINT Sales_SalesOrder_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp           rowversion        NOT NULL
   ,CONSTRAINT Sales_SalesOrder_SalesOrderId PRIMARY KEY CLUSTERED (SalesOrderId ASC)
   ,CONSTRAINT Sales_SalesOrder_DueDate_After_OrderDate CHECK (DueDate >= OrderDate)
   ,CONSTRAINT Sales_SalesOrderHeader_ShipDate_After_OrderDate_Or_NULL CHECK (ShipDate >= OrderDate OR ShipDate IS NULL)
   ,INDEX Sales_SalesOrder_OrganizationId NONCLUSTERED (OrganizationId ASC)
   ,INDEX Sales_SalesOrder_PurchaseOrderNumber NONCLUSTERED (PurchaseOrderNumber ASC)
   ,INDEX Sales_SalesOrder_DeliveryTypeId NONCLUSTERED (DeliveryTypeId ASC)
   ,INDEX Sales_SalesOrder_SalesPersonId NONCLUSTERED (SalesPersonId ASC)
   ,INDEX Sales_SalesOrder_BillToLocationId NONCLUSTERED (BillToLocationId ASC)
   ,INDEX Sales_SalesOrder_ShipToLocationId NONCLUSTERED (ShipToLocationId ASC)
   ,INDEX Sales_SalesOrder_CreditCardId NONCLUSTERED (CreditCardId ASC)
   ,INDEX Sales_SalesOrder_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Sales_SalesOrder_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'SalesOrderId'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Incremental number to track changes to the sales order over time.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'RevisionNumber'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of 0' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'DF_SalesOrderHeader_RevisionNumber'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dates the sales order was created.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'OrderDate'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of GETDATE()' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'DF_SalesOrderHeader_OrderDate'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the order is due to the customer.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'DueDate'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the order was shipped to the customer.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'ShipDate'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Order current status. 1 = In process; 2 = Approved; 3 = Backordered; 4 = Rejected; 5 = Shipped; 6 = Cancelled' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'Status'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of 1' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'DF_SalesOrderHeader_Status'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = Order placed by sales person. 1 = Order placed online by customer.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'OnlineOrder'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of 1 (TRUE)' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'DF_SalesOrderHeader_OnlineOrder'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique sales order identification number.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'SalesOrderNumber'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer purchase order number reference. ' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'PurchaseOrderNumber'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Financial accounting number reference.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'AccountNumber'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer identification number. Foreign key to Customer.BusinessEntityID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'CustomerID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sales person who created the sales order. Foreign key to SalesPerson.BusinessEntityID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'SalesPersonID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Territory in which the sale was made. Foreign key to SalesTerritory.SalesTerritoryID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'TerritoryID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer billing address. Foreign key to Address.AddressID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'BillToAddressID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer shipping address. Foreign key to Address.AddressID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'ShipToAddressID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipping method. Foreign key to ShipMethod.ShipMethodID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'ShipMethodID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Credit card identification number. Foreign key to CreditCard.CreditCardId.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'CreditCardId'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Approval code provided by the credit card company.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'CreditCardApprovalCode'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Currency exchange rate used. Foreign key to CurrencyRate.CurrencyRateID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'CurrencyRateID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sales subtotal. Computed as SUM(SalesOrderDetail.LineTotal)for the appropriate SalesOrderId.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'SubTotal'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of 0.0' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'DF_SalesOrderHeader_SubTotal'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tax amount.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'TaxAmt'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of 0.0' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'DF_SalesOrderHeader_TaxAmt'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipping cost.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'Freight'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of 0.0' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'DF_SalesOrderHeader_Freight'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total due from customer. Computed as Subtotal + TaxAmt + Freight.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'TotalDue'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sales representative comments.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'Comment'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'rowguid'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of NEWID()' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'DF_SalesOrderHeader_rowguid'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date and time the record was last updated.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of GETDATE()' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'DF_SalesOrderHeader_ModifiedDate'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key (clustered) constraint' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'PK_SalesOrderHeader_SalesOrderId'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'General sales order information.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key constraint referencing Address.AddressID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'FK_SalesOrderHeader_Address_BillToAddressID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key constraint referencing Address.AddressID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'FK_SalesOrderHeader_Address_ShipToAddressID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key constraint referencing CreditCard.CreditCardId.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'FK_SalesOrderHeader_CreditCard_CreditCardId'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key constraint referencing CurrencyRate.CurrencyRateID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'FK_SalesOrderHeader_CurrencyRate_CurrencyRateID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key constraint referencing Customer.CustomerID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'FK_SalesOrderHeader_Customer_CustomerID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key constraint referencing SalesPerson.SalesPersonID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'FK_SalesOrderHeader_SalesPerson_SalesPersonID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key constraint referencing SalesTerritory.TerritoryID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'FK_SalesOrderHeader_SalesTerritory_TerritoryID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key constraint referencing ShipMethod.ShipMethodID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'FK_SalesOrderHeader_ShipMethod_ShipMethodID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Check constraint [DueDate] >= [OrderDate]' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'CK_SalesOrderHeader_DueDate'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Check constraint [Freight] >= (0.00)' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'CK_SalesOrderHeader_Freight'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Check constraint [ShipDate] >= [OrderDate] OR [ShipDate] IS NULL' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'CK_SalesOrderHeader_ShipDate'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Check constraint [Status] BETWEEN (0) AND (8)' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'CK_SalesOrderHeader_Status'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Check constraint [SubTotal] >= (0.00)' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'CK_SalesOrderHeader_SubTotal'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Check constraint [TaxAmt] >= (0.00)' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderHeader', @level2type=N'CONSTRAINT',@level2name=N'CK_SalesOrderHeader_TaxAmt'
--GO


/**********************************************************************************************************************
** Create SalesOrderLine
**********************************************************************************************************************/
--xxxxxx
CREATE TABLE Sales.SalesOrderLine (
    SalesOrderLineId     int               IDENTITY(1, 1) NOT NULL
   ,SalesOrderId         int               NOT NULL CONSTRAINT Sales_SalesOrderLine_Purchasing_PurchaseOrder FOREIGN KEY REFERENCES Sales.SalesOrder (SalesOrderId)
   ,QuantityOrdered      int               NOT NULL CONSTRAINT Sales_SalesOrderDetail_Zero_Or_Greater CHECK (QuantityOrdered > 0)/* Assess if fractional quantities are required */
   ,ProductItemId        int               NOT NULL CONSTRAINT Sales_SalesOrderLine_Application_ProductItem FOREIGN KEY REFERENCES Application.ProductItem (ProductItemId)
   ,UnitPrice            decimal(18, 2)    NOT NULL CONSTRAINT Sales_SalesOrderLine_UnitPrice_Zero_Or_Greater CHECK (UnitPrice >= 0.00)
   ,UnitPriceDiscount    decimal(18, 2)    NOT NULL CONSTRAINT Sales_SalesOrderDetail_UnitPriceDiscount_Default DEFAULT (0.00)
        CONSTRAINT Sales_SalesOrderDetail_UnitPriceDiscount_Zero_Or_Greater CHECK (UnitPriceDiscount >= 0.00)
   ,LineTotal            AS (ISNULL((UnitPrice * ((1.00) - UnitPriceDiscount)) * QuantityOrdered, (0.00)))
   ,IsOrderLineFinalized bit               NOT NULL
   ,ModifyPersonId       int               NOT NULL CONSTRAINT Sales_SalesOrderLine_Application_ModifyPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,CreatePersonId       int               NOT NULL CONSTRAINT Sales_SalesOrderLine_Application_CreatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ModifyTime           datetimeoffset(7) NOT NULL CONSTRAINT Sales_SalesOrderLine_ModifyTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CreateTime           datetimeoffset(7) NOT NULL CONSTRAINT Sales_SalesOrderLine_CreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,VersionStamp         rowversion        NOT NULL
   ,CONSTRAINT Sales_SalesOrderLine_PurchaseOrderLineId PRIMARY KEY CLUSTERED (SalesOrderLineId ASC)
   ,INDEX Sales_SalesOrderLine_SalesOrderId_IsOrderLineFinalized NONCLUSTERED (SalesOrderId ASC, IsOrderLineFinalized ASC)
   ,INDEX Sales_SalesOrderLine_ProductItemId NONCLUSTERED (ProductItemId ASC)
   ,INDEX Sales_SalesOrderLine_ModifyPersonId NONCLUSTERED (ModifyPersonId ASC)
   ,INDEX Sales_SalesOrderLine_CreatePersonId NONCLUSTERED (CreatePersonId ASC)
);
GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key. Foreign key to SalesOrderHeader.SalesOrderID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'COLUMN',@level2name=N'SalesOrderID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key. One incremental unique number per product sold.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'COLUMN',@level2name=N'SalesOrderDetailID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipment tracking number supplied by the shipper.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'COLUMN',@level2name=N'CarrierTrackingNumber'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quantity ordered per product.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'COLUMN',@level2name=N'OrderQty'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Product sold to customer. Foreign key to Product.ProductID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'COLUMN',@level2name=N'ProductID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Promotional code. Foreign key to SpecialOffer.SpecialOfferID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'COLUMN',@level2name=N'SpecialOfferID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Selling price of a single product.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'COLUMN',@level2name=N'UnitPrice'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Discount amount.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'COLUMN',@level2name=N'UnitPriceDiscount'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of 0.0' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'CONSTRAINT',@level2name=N'DF_SalesOrderDetail_UnitPriceDiscount'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Per product subtotal. Computed as UnitPrice * (1 - UnitPriceDiscount) * OrderQty.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'COLUMN',@level2name=N'LineTotal'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'COLUMN',@level2name=N'rowguid'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of NEWID()' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'CONSTRAINT',@level2name=N'DF_SalesOrderDetail_rowguid'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date and time the record was last updated.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of GETDATE()' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'CONSTRAINT',@level2name=N'DF_SalesOrderDetail_ModifiedDate'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key (clustered) constraint' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'CONSTRAINT',@level2name=N'PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Individual products associated with a specific sales order. See SalesOrderHeader.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key constraint referencing SalesOrderHeader.PurchaseOrderID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'CONSTRAINT',@level2name=N'FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key constraint referencing SpecialOfferProduct.SpecialOfferIDProductID.' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'CONSTRAINT',@level2name=N'FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Check constraint [OrderQty] > (0)' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'CONSTRAINT',@level2name=N'CK_SalesOrderDetail_OrderQty'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Check constraint [UnitPrice] >= (0.00)' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'CONSTRAINT',@level2name=N'CK_SalesOrderDetail_UnitPrice'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Check constraint [UnitPriceDiscount] >= (0.00)' , @level0type=N'SCHEMA',@level0name=N'Sales', @level1type=N'TABLE',@level1name=N'SalesOrderDetail', @level2type=N'CONSTRAINT',@level2name=N'CK_SalesOrderDetail_UnitPriceDiscount'
--GO




/**********************************************************************************************************************
** Create Number
**********************************************************************************************************************/

CREATE TABLE Application.Number (
    NumberId            bigint       NOT NULL
   ,NumberWord          varchar(500) NULL
   ,BinaryNumber        varchar(16)  NULL
   ,HexNumber           varchar(16)  NULL
   ,EvenOdd             varchar(4)   NULL
   ,RomanNumeral        varchar(9)   NULL
   ,Ones                tinyint      NULL
   ,Tens                tinyint      NULL
   ,Hundreds            tinyint      NULL
   ,Thousands           tinyint      NULL
   ,TenThousands        tinyint      NULL
   ,HundredThousands    tinyint      NULL
   ,Millions            tinyint      NULL
   ,TenMillions         tinyint      NULL
   ,HundredMillions     tinyint      NULL
   ,Billions            tinyint      NULL
   ,TenBillions         tinyint      NULL
   ,HundredBillions     tinyint      NULL
   ,Trillions           tinyint      NULL
   ,TenTrillions        tinyint      NULL
   ,HundredTrillions    tinyint      NULL
   ,Quadrillions        tinyint      NULL
   ,TenQuadrillions     tinyint      NULL
   ,HundredQuadrillions tinyint      NULL
   ,Quintillions        tinyint      NULL
   ,CONSTRAINT Application_Number_NumberId PRIMARY KEY CLUSTERED (NumberId ASC)
);
GO

/**********************************************************************************************************************
** Create Time
**********************************************************************************************************************/

CREATE TABLE Application.Time (
    TimeId             int         NOT NULL
   ,Hour24             int         NOT NULL
   ,Hour24Short        char(2)     NOT NULL
   ,Hour24Medium       char(5)     NOT NULL
   ,Hour24Full         char(8)     NOT NULL
   ,Hour12             int         NOT NULL
   ,Hour12Short        char(5)     NOT NULL
   ,Hour12ShortTrim    varchar(5)  NOT NULL
   ,Hour12Medium       char(8)     NOT NULL
   ,Hour12MediumTrim   varchar(8)  NOT NULL
   ,Hour12Full         char(11)    NOT NULL
   ,Hour12FullTrim     varchar(11) NOT NULL
   ,AMPMCode           bit         NOT NULL
   ,AMPM               char(2)     NOT NULL
   ,Minute             int         NOT NULL
   ,MinuteOfDay        int         NOT NULL
   ,MinuteCode         int         NOT NULL
   ,MinuteShort        char(2)     NOT NULL
   ,Minute24Full       char(8)     NOT NULL
   ,Minute12Full       char(11)    NOT NULL
   ,Minute12FullTrim   varchar(14) NOT NULL
   ,HalfHourCode       int         NOT NULL
   ,HalfHour           bit         NOT NULL
   ,HalfHourShort      char(2)     NOT NULL
   ,HalfHour24Full     char(8)     NOT NULL
   ,HalfHour12Full     char(11)    NOT NULL
   ,HalfHour12FullTrim varchar(14) NOT NULL
   ,Second             int         NOT NULL
   ,SecondOfDay        int         NOT NULL
   ,SecondShort        char(2)     NOT NULL
   ,FullTime24         char(8)     NOT NULL
   ,FullTime12         char(11)    NOT NULL
   ,FullTime12Trim     varchar(14) NOT NULL
   ,FullTime           time(7)     NOT NULL
   ,CONSTRAINT Application_Time_TimeId PRIMARY KEY CLUSTERED (TimeId ASC)
);

/**********************************************************************************************************************
** Create Number
**********************************************************************************************************************/

CREATE TABLE Application.Date (
    DateId              int          NOT NULL
   ,FullDateTime        datetime2(7) NOT NULL
   ,DateName            varchar(10)  NOT NULL
   ,DateNameUS          varchar(10)  NOT NULL
   ,DateNameEU          varchar(10)  NOT NULL
   ,DayOfWeek           tinyint      NOT NULL
   ,DayNameOfWeek       varchar(9)   NOT NULL
   ,DayOfMonth          tinyint      NOT NULL
   ,DayOfYear           smallint     NOT NULL
   ,WeekdayWeekend      char(7)      NOT NULL
   ,WeekOfYear          tinyint      NOT NULL
   ,MonthName           varchar(9)   NOT NULL
   ,MonthNameShort      char(3)      NOT NULL
   ,MonthYear           char(8)      NOT NULL
   ,MonthOfYear         tinyint      NOT NULL
   ,LastDayOfMonth      varchar(3)   NOT NULL
   ,WorkDay             varchar(3)   NOT NULL
   ,CalendarQuarter     tinyint      NOT NULL
   ,CalendarYear        smallint     NOT NULL
   ,CalendarYearMonth   char(7)      NOT NULL
   ,CalendarYearQuarter char(6)      NOT NULL
   ,FiscalMonthOfYear   tinyint      NOT NULL
   ,FiscalQuarter       tinyint      NOT NULL
   ,FiscalQuarterName   char(3)      NOT NULL
   ,FiscalYear          int          NOT NULL
   ,FiscalYearNameShort char(4)      NOT NULL
   ,FiscalYearNameLong  char(6)      NOT NULL
   ,FiscalYearMonth     char(7)      NOT NULL
   ,FiscalYearQuarter   char(6)      NOT NULL
   ,CONSTRAINT Application_Date_DateId PRIMARY KEY CLUSTERED (DateId ASC)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'Comments'
   ,@value = N'In the form: yyyymmdd'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DateId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Surrogate primary key'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DateId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'20041123'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DateId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Full date as a SQL datetime2 (time=00:00:00.0000000)'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'FullDateTime';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'11/23/2004 2004-12-31 23:59:59.9999999'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'FullDateTime';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Standard Date Format of YYYY/MM/DD'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DateName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'23-Nov-2004'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DateName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Standard US Date Format of MM/DD/YYYY'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DateNameUS';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Standard European Union Date Format of DD/MM/YYYY'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DateNameEU';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Number of the day of week; Sunday = 1'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DayOfWeek';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'1..7'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DayOfWeek';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'DayNameOfWeek'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DayNameOfWeek';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'Sunday'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DayNameOfWeek';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Number of the day in the month'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DayOfMonth';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'1..31'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DayOfMonth';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Number of the day in the year'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DayOfYear';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'1..365'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DayOfYear';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Is today a weekday or a weekend'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'WeekdayWeekend';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'Weekday, Weekend'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'WeekdayWeekend';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'WeekOfYear'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'WeekOfYear';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'1..52 or 53'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'WeekOfYear';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'MonthName'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'MonthName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'November'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'MonthName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'MonthOfYear'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'MonthOfYear';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'1, 2, …, 12'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'MonthOfYear';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Is this the last day of the calendar month?'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'LastDayOfMonth';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'Yes, No'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'LastDayOfMonth';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Is this a work day?'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'WorkDay';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'Yes, No'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'WorkDay';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'CalendarQuarter'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CalendarQuarter';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'1, 2, 3, 4'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CalendarQuarter';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'CalendarYear'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CalendarYear';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'2004'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CalendarYear';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Calendar year and month'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CalendarYearMonth';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'2004-01'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CalendarYearMonth';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Calendar year and quarter'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CalendarYearQuarter';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'2004Q1'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CalendarYearQuarter';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Fiscal month of year (1..12). FY starts in [MONTH-NAME]'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'FiscalMonthOfYear';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'1, 2, …, 12'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'FiscalMonthOfYear';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'FiscalQuarter'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'FiscalQuarter';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'1, 2, 3, 4'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'FiscalQuarter';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Fiscal year. Fiscal year begins in [MONTH-NAME].'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'FiscalYear';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'2004'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'FiscalYear';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Fiscal year and month'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'FiscalYearMonth';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'FY2004-01'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'FiscalYearMonth';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Fiscal year and quarter'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'FiscalYearQuarter';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Example Values'
   ,@value = N'FY2004Q1'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'FiscalYearQuarter';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Date dimension contains one row for every day, beginning at 1/1/2000. There may also be rows for "hasn''t happened yet."'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Table Type'
   ,@value = N'Application'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date';
GO

EXEC sys.sp_addextendedproperty
    @name = N'View Name'
   ,@value = N'Date'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date';
GO

/**********************************************************************************************************************
** CREATE FUNCTION #dbo.RemoveCharactersFromString
**********************************************************************************************************************/
CREATE FUNCTION dbo.RemoveCharactersFromString (@String nvarchar(4000), @MatchExpression varchar(255))
RETURNS table
AS
    RETURN

    /* How to use

    ## Alphabetic Only ##
    SELECT * FROM dbo.RemoveCharactersFromString(N'T1!e2@x3#t4$ Only Accents Characters ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ Chinese Characters 凯文', 'a-zA-Z⺀-⿕')
    SELECT * FROM dbo.RemoveCharactersFromString(N'T1!e2@x3#t4$ Only Accents Characters ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ Chinese Characters 凯文', 'a-zA-Z')

    ## No Alphabetics ##
    SELECT * FROM dbo.RemoveCharactersFromString(N'T1!e2@x3#t4$ Only Accents Characters ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ Chinese Characters 凯文', '^a-zA-Z')

    ## Numeric Only ##
    SELECT * FROM dbo.RemoveCharactersFromString(N'T1!e2@x3#t4$ Only Accents Characters ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ Chinese Characters 凯文', '0-9')

    ## No Numerics ##
    SELECT * FROM dbo.RemoveCharactersFromString(N'T1!e2@x3#t4$ Only Accents Characters ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ Chinese Characters 凯文', '^0-9')

    ## Alphanumeric Only ##
    SELECT * FROM dbo.RemoveCharactersFromString(N'T1!e2@x3#t4$ Only Accents Characters ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ Chinese Characters 凯文', 'a-zA-Z0-9')

    ## No Alphanumerics ##
    SELECT * FROM dbo.RemoveCharactersFromString(N'T1!e2@x3#t4$ Only Accents Characters ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ Chinese Characters 凯文', '^a-zA-Z0-9')

    ## Non-alphanumeric with Spaces ##
    SELECT * FROM dbo.RemoveCharactersFromString(N'T1!e2@x3#t4$ Only Accents Characters ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ Chinese Characters 凯文', ' a-zA-Z0-9')

    ## Can also remove carriage returns, line feeds and tabs ##
    SELECT * FROM dbo.RemoveCharactersFromString(N'Some text, other text.  ''.,!?/<>"[]{}|`~@#$%^&*()-+=/\:;市汇

    After a CR/LF!' + + CHAR(13) + CHAR(10) + CHAR(9) + N'After CR/LF & tab character.', 'a-zA-Z0-9')

    */

    WITH Numbers
      AS (
          SELECT TOP (ISNULL(DATALENGTH(@String), 0))
              n = ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
          FROM (VALUES (0), (0), (0), (0)) AS d (n)
             ,(VALUES (0), (0), (0), (0), (0), (0), (0), (0), (0), (0)) AS E (n)
             ,(VALUES (0), (0), (0), (0), (0), (0), (0), (0), (0), (0)) AS F (n)
             ,(VALUES (0), (0), (0), (0), (0), (0), (0), (0), (0), (0)) AS g (n)
      )
    SELECT
        String = N'' + (
                           SELECT
                               N.StringCharacter
                           FROM
                               Numbers
                           CROSS APPLY (SELECT SUBSTRING(@String, n, 1)) AS N(StringCharacter)
                           WHERE
                               N.StringCharacter LIKE '%[' + @MatchExpression + ']%'
                           ORDER BY
                               Numbers.n
                           FOR XML PATH(''), TYPE
                       ).value('.', 'nvarchar(4000)');
GO

/**********************************************************************************************************************
** Create stored procedures using sp_CRUDGen
**********************************************************************************************************************/
--EXEC dbo.sp_CRUDGen
--    @GenerateStoredProcedures = 1
--   ,@GenerateCreate = 1
--   ,@GenerateCreateMultiple = 0
--   ,@GenerateRead = 1
--   ,@GenerateReadEager = 0
--   ,@GenerateUpdate = 1
--   ,@GenerateUpdateMultiple = 0
--   ,@GenerateUpsert = 0
--   ,@GenerateIndate = 0
--   ,@GenerateDelete = 1
--   ,@GenerateDeleteMultiple = 0
--   ,@GenerateSearch = 0




--Future TODO: Only add what is required for coursework now and add other table models for more samples.
--TODO: Add temporal table to person table
--TODO: Linking tables for Supplier
--TODO: Linking tables for Store
--TODO: Address, where should they link, org, customer, vendor, store???
--TODO: Store, staff to also sell products (retail schema)
--TODO: Add Production schema tables from AdventureWorks2019
--TODO: Add Warehouse tables from WideWorldImporters
--TODO: Add receive inventory table
--TODO: Inventory
--TODO: Add Sales tables from WideWorldImporters
--TODO: Sales Pipeline, leads, ...
--TODO: Add a large amount of sales for gold productid 79 so we can parameter sniff query
--TODO: Redgate SQL Data Generation is not loading the FullTime column (sent help ticket)
--TODO: product reviews from shopping cart??
--TODO: forum
--TODO: Manufacturing
--TODO: RMA
--TODO: Accounting??
--TODO: Data Warehouse
--TODO: Power BI
--TODO: SSRS reports



/**********************************************************************************************************************
 ** Testing paramater sniffing with skewed data distrobution
 **********************************************************************************************************************/
--SET QUOTED_IDENTIFIER, ANSI_NULLS ON;
--GO
--CREATE OR ALTER PROCEDURE Application.PersonLastNameSearch (@LastName nvarchar(100))
--AS
--    BEGIN
--        SET NOCOUNT, XACT_ABORT ON;

--        SELECT PersonId, LastName FROM Application.Person WHERE LastName = @LastName;

--    END;
--GO

--DBCC FREEPROCCACHE
--EXEC Application.PersonLastNameSearch @LastName = N'Baxter';
--EXEC Application.PersonLastNameSearch @LastName = N'Martin';
