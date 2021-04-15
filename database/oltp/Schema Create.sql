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
USE KevinMartinTech;
/**********************************************************************************************************************
** Drop tables
**********************************************************************************************************************/
DROP TABLE IF EXISTS Application.OrganizationPerson;
DROP TABLE IF EXISTS Application.OrganizationPhone;
DROP TABLE IF EXISTS Application.OrganizationEmail;
DROP TABLE IF EXISTS Application.OrganizationPhone;
DROP TABLE IF EXISTS Application.Time;
DROP TABLE IF EXISTS Application.Date;
DROP TABLE IF EXISTS Application.Number;
DROP TABLE IF EXISTS Purchasing.PurchaseOrderLine;
DROP TABLE IF EXISTS Purchasing.PurchaseOrder;
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
DROP TABLE IF EXISTS Application.RoleClaim;
DROP TABLE IF EXISTS Application.Role;
DROP TABLE IF EXISTS Application.Phone;
DROP TABLE IF EXISTS Application.Location;
DROP TABLE IF EXISTS Application.Residence;
DROP TABLE IF EXISTS Application.Address;
DROP TABLE IF EXISTS Application.AddressType;
DROP TABLE IF EXISTS Application.EmailType;
DROP TABLE IF EXISTS Application.DeliveryType;
DROP TABLE IF EXISTS Application.PhoneType;
DROP TABLE IF EXISTS Application.UnitType;
DROP TABLE IF EXISTS Application.CityTown;
DROP TABLE IF EXISTS Application.StateProvince;
DROP TABLE IF EXISTS Application.CountryRegion;
DROP TABLE IF EXISTS Sales.Customer;
DROP TABLE IF EXISTS Purchasing.Supplier;

DROP TABLE IF EXISTS Application.Organization;
DROP TABLE IF EXISTS Application.Person;

DROP SCHEMA IF EXISTS Application;
DROP SCHEMA IF EXISTS Sales;
DROP SCHEMA IF EXISTS Purchasing;
DROP SCHEMA IF EXISTS Warehouse;
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
CREATE SCHEMA Warehouse AUTHORIZATION dbo;
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
    PersonId                    int               NOT NULL IDENTITY(1, 1)
   ,UserName                    nvarchar(256)     NULL
   ,NormalizedUserName          AS (UPPER(ISNULL(UserName, ''))) PERSISTED NOT NULL
   ,EmailAddress                nvarchar(256)     NULL
   ,NormalizedEmailAddress      AS (UPPER(ISNULL(EmailAddress, ''))) PERSISTED NOT NULL
   ,IsEmailAddressConfirmedFlag bit               NOT NULL CONSTRAINT Application_Person_IsEmailAddressConfirmedFlag_Default DEFAULT ((0))
   ,PasswordHash                nvarchar(MAX)     NULL
   ,SecurityStamp               nvarchar(MAX)     NULL
   ,ConcurrencyStamp            nvarchar(MAX)     NULL
   ,PhoneNumber                 nvarchar(MAX)     NULL
   ,IsPhoneNumberConfirmedFlag  bit               NOT NULL CONSTRAINT Application_Person_IsPhoneNumberConfirmedFlag_Default DEFAULT ((0))
   ,IsTwoFactorEnabledFlag      bit               NOT NULL CONSTRAINT Application_Person_IsTwoFactorEnabledFlag_Default DEFAULT ((0))
   ,LockoutEnd                  datetimeoffset(7) NULL
   ,IsLockoutEnabledFlag        bit               NOT NULL CONSTRAINT Application_Person_IsLockoutEnabledFlag_Default DEFAULT ((0))
   ,AccessFailedCount           int               NOT NULL CONSTRAINT Application_Person_AccessFailedCount_Default DEFAULT ((0))
   ,Title                       nvarchar(10)      NULL
   ,FirstName                   nvarchar(100)     NULL
   ,LastName                    nvarchar(100)     NULL
   ,Suffix                      nvarchar(10)      NULL
   ,NickName                    nvarchar(100)     NULL
   ,SearchName                  AS (TRIM(CONCAT(ISNULL(TRIM(NickName) + ' ', ''), ISNULL(TRIM(FirstName) + ' ', ''), ISNULL(TRIM(LastName) + ' ', ''), ISNULL(TRIM(Suffix) + '', '')))) PERSISTED NOT NULL
   ,IsOptOutFlag                bit               NULL
   ,RowUpdatePersonId           int               NOT NULL CONSTRAINT Application_Person_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime               datetimeoffset(7) NOT NULL CONSTRAINT Application_Person_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime               datetimeoffset(7) NOT NULL CONSTRAINT Application_Person_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp             rowversion        NOT NULL
   ,CONSTRAINT Application_Person_PersonId PRIMARY KEY CLUSTERED (PersonId ASC)
);
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
   ,@level2name = N'IsOptOutFlag';
GO


/**********************************************************************************************************************
** Create PersonToken (https://kevinmartin.tech/go/customize-identity-model)
**********************************************************************************************************************/

CREATE TABLE Application.PersonToken (
    PersonId         int           NOT NULL CONSTRAINT Application_PersonToken_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,LoginProvider    nvarchar(128) NOT NULL
   ,PersonTokenName  nvarchar(128) NOT NULL /* ASP.NET Core Identity: Identity model customization in ASP.NET Core: https://kevinmartin.tech/go/customize-identity-model */
   ,PersonTokenValue nvarchar(MAX) NULL
   ,CONSTRAINT Application_PersonToken_PersonId_LoginProvider_PersonTokenName PRIMARY KEY CLUSTERED (
        PersonId ASC
       ,LoginProvider ASC
       ,PersonTokenName ASC
    )
);
GO

/**********************************************************************************************************************
** Create Roles (https://kevinmartin.tech/go/customize-identity-model)
**********************************************************************************************************************/

CREATE TABLE Application.Role (
    RoleId             int           NOT NULL
   ,RoleName           nvarchar(256) NULL
   ,RoleNormalizedName nvarchar(256) NULL
   ,ConcurrencyStamp   nvarchar(MAX) NULL
   ,CONSTRAINT Application_Role_RoleId PRIMARY KEY CLUSTERED (RoleId ASC)
);
GO

/**********************************************************************************************************************
** Create PersonRole (https://kevinmartin.tech/go/customize-identity-model)
**********************************************************************************************************************/

CREATE TABLE Application.PersonRole (
    PersonId int NOT NULL CONSTRAINT Application_PersonRole_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RoleId   int NOT NULL CONSTRAINT Application_PersonRole_Application_Role FOREIGN KEY REFERENCES Application.Role (RoleId)
   ,CONSTRAINT Application_PersonRole_PersonRoleId_RoleId PRIMARY KEY CLUSTERED (
        PersonId ASC
       ,RoleId ASC
    )
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
   ,CONSTRAINT PK_AspNetUserLogins PRIMARY KEY CLUSTERED (
        LoginProvider ASC
       ,ProviderKey ASC
    )
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
);
GO

/**********************************************************************************************************************
** Create RoleClaim (https://kevinmartin.tech/go/customize-identity-model)
**********************************************************************************************************************/

CREATE TABLE Application.RoleClaim (
    RoleClaimId int           IDENTITY(1, 1) NOT NULL
   ,RoleId      int           NOT NULL CONSTRAINT Application_RoleClaim_Application_Role FOREIGN KEY REFERENCES Application.Role (RoleId)
   ,ClaimType   nvarchar(MAX) NULL
   ,ClaimValue  nvarchar(MAX) NULL
   ,CONSTRAINT Application_RoleClaim_RoleClaimId PRIMARY KEY CLUSTERED (RoleClaimId ASC)
);
GO

/**********************************************************************************************************************
** Create CountryRegion
**********************************************************************************************************************/

CREATE TABLE Application.CountryRegion (
    CountryRegionId   int               NOT NULL
   ,CountryName       nvarchar(60)      NOT NULL
   ,FormalName        nvarchar(60)      NOT NULL
   ,IsoAlpha3Code     nvarchar(3)       NULL
   ,IsoNumericCode    int               NULL
   ,CountryType       nvarchar(20)      NULL
   ,Continent         nvarchar(30)      NOT NULL
   ,Region            nvarchar(30)      NOT NULL
   ,Subregion         nvarchar(30)      NOT NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_CountryRegion_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_CountryRegion_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_CountryRegion_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_CountryRegion_CountryRegionId PRIMARY KEY CLUSTERED (CountryRegionId ASC)
   ,CONSTRAINT Application_CountryRegion_CountryName UNIQUE NONCLUSTERED (CountryName ASC)
   ,CONSTRAINT Application_CountryRegion_FormalName UNIQUE NONCLUSTERED (FormalName ASC)
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
    StateProvinceId   int               NOT NULL
   ,CountryRegionId   int               NOT NULL CONSTRAINT Application_StateProvince_Application_CountryRegion FOREIGN KEY REFERENCES Application.CountryRegion (CountryRegionId)
   ,StateProvinceCode nvarchar(5)       NULL
   ,StateProvinceName nvarchar(50)      NOT NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_StateProvince_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_StateProvince_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_StateProvince_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_StateProvince_StateProvinceId PRIMARY KEY CLUSTERED (StateProvinceId ASC)
   ,CONSTRAINT Application_StateProvince_CountryRegionId_StateProvinceCode_StateProvinceName UNIQUE NONCLUSTERED (
        CountryRegionId ASC
       ,StateProvinceCode ASC
       ,StateProvinceName ASC
    )
   ,CONSTRAINT Application_StateProvince_StateProvinceName UNIQUE NONCLUSTERED (StateProvinceName ASC)
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
    CityTownId        int               NOT NULL IDENTITY(1, 1)
   ,StateProvinceId   int               NOT NULL CONSTRAINT Application_CityTown_Application_StateProvince FOREIGN KEY REFERENCES Application.StateProvince (StateProvinceId)
   ,CityTownName      nvarchar(50)      NOT NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_CityTown_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_CityTown_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_CityTown_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_CityTown_CityTownId PRIMARY KEY CLUSTERED (CityTownId ASC)
   ,CONSTRAINT Application_CityTown_StateProvinceId_CityName UNIQUE NONCLUSTERED (
        StateProvinceId ASC
       ,CityTownName ASC
    )
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
    AddressTypeId     tinyint           NOT NULL IDENTITY(1, 1)
   ,AddressTypeName   nvarchar(50)      NOT NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_AddressType_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_AddressType_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_AddressType_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_AddressType_AddressTypeId PRIMARY KEY CLUSTERED (AddressTypeId ASC)
   ,CONSTRAINT Application_AddressType_AddressTypeName_Unique UNIQUE (AddressTypeName)
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
    EmailTypeId       tinyint           NOT NULL IDENTITY(1, 1)
   ,EmailTypeName     nvarchar(50)      NOT NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_EmailType_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_EmailType_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_EmailType_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_EmailType_EmailTypeId PRIMARY KEY CLUSTERED (EmailTypeId ASC)
   ,CONSTRAINT Application_EmailType_EmailTypeName_Unique UNIQUE (EmailTypeName)
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
    AddressId         int               NOT NULL IDENTITY(1, 1)
   ,Line1             nvarchar(100)     NULL
   ,Line2             nvarchar(100)     NULL
   ,CityTownId        int               NULL CONSTRAINT Application_Address_Application_CityTown FOREIGN KEY REFERENCES Application.CityTown (CityTownId)
   ,PostalCode        nvarchar(12)      NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_Address_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Address_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Address_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_Address_AddressId PRIMARY KEY CLUSTERED (AddressId ASC)
   ,INDEX Application_Address_CityTownId NONCLUSTERED (CityTownId ASC)
);
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
    PersonEmailId     int               NOT NULL IDENTITY(1, 1)
   ,PersonId          int               NOT NULL CONSTRAINT Application_PersonEmail_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,EmailTypeId       tinyint           NOT NULL CONSTRAINT Application_PersonEmail_Application_EmailType FOREIGN KEY REFERENCES Application.EmailType (EmailTypeId)
   ,EmailAddress      nvarchar(254)     NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_PersonEmail_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_PersonEmail_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_PersonEmail_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_PersonEmail_PersonEmailId PRIMARY KEY CLUSTERED (PersonEmailId ASC)
   ,CONSTRAINT Application_PersonEmail_PersonId_EmailId_EmailTypeId UNIQUE NONCLUSTERED (
        PersonId ASC
       ,EmailTypeId ASC
       ,EmailAddress ASC
    )
   ,INDEX Application_PersonEmail_EmailTypeId NONCLUSTERED (EmailTypeId ASC)
   ,INDEX Application_PersonEmail_PersonId NONCLUSTERED (PersonId ASC)
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
** Create Residence
**********************************************************************************************************************/

CREATE TABLE Application.Residence (
    ResidenceId       int               NOT NULL IDENTITY(1, 1)
   ,PersonId          int               NOT NULL CONSTRAINT Application_Residence_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,AddressId         int               NOT NULL CONSTRAINT Application_Residence_Application_Address FOREIGN KEY REFERENCES Application.Address (AddressId)
   ,AddressTypeId     tinyint           NOT NULL CONSTRAINT Application_Residence_Application_AddressType FOREIGN KEY REFERENCES Application.AddressType (AddressTypeId)
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_Residence_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Residence_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Residence_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_Residence_ResidenceId PRIMARY KEY CLUSTERED (ResidenceId ASC)
   ,CONSTRAINT Application_Residence_PersonId_AddressId_AddressTypeId UNIQUE NONCLUSTERED (
        PersonId ASC
       ,AddressId ASC
       ,AddressTypeId ASC
    )
   ,INDEX Application_Residence_PersonId NONCLUSTERED (PersonId ASC)
   ,INDEX Application_Residence_AddressId NONCLUSTERED (AddressId ASC)
   ,INDEX Application_Residence_AddressTypeId NONCLUSTERED (AddressTypeId ASC)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Primary key for residence records.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Residence'
   ,@level2type = N'COLUMN'
   ,@level2name = N'ResidenceId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Foreign key to Person.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Residence'
   ,@level2type = N'COLUMN'
   ,@level2name = N'PersonId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Foreign key to Address.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Residence'
   ,@level2type = N'COLUMN'
   ,@level2name = N'AddressId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Foreign key to AddressType.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Residence'
   ,@level2type = N'COLUMN'
   ,@level2name = N'AddressTypeId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'An address of a person.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Residence';
GO

/**********************************************************************************************************************
** Create Organization 
**********************************************************************************************************************/

CREATE TABLE Application.Organization (
    OrganizationId    int               NOT NULL IDENTITY(1, 1)
   ,OrganizationName  nvarchar(200)     NOT NULL
   ,WebsiteURL        nvarchar(2083)    NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_Organization_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Organization_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Organization_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_Organization_OrganizationId PRIMARY KEY CLUSTERED (OrganizationId ASC)
);
GO


/**********************************************************************************************************************
** Create Customer
**********************************************************************************************************************/

CREATE TABLE Sales.Customer (
    OrganizationId             int               NOT NULL CONSTRAINT Sales_Customer_Application_Organization FOREIGN KEY REFERENCES Application.Organization (OrganizationId)
   ,CreditLimit                decimal(18, 2)    NULL
   ,PaymentDays                int               NOT NULL
   ,IsOnCreditHoldFlag         bit               NOT NULL
   ,AccountOpenedDate          datetimeoffset(7) NOT NULL
   ,StandardDiscountPercentage decimal(18, 3)    NOT NULL
   ,RowUpdatePersonId          int               NOT NULL CONSTRAINT Sales_Customer_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime              datetimeoffset(7) NOT NULL CONSTRAINT Sales_Customer_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime              datetimeoffset(7) NOT NULL CONSTRAINT Sales_Customer_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp            rowversion        NOT NULL
   /*These are for testing*/
   --,BigInt           bigint            NULL
   --,Binary           binary(50)        NULL
   --,Bit              bit               NULL
   ,Char                       char(10)          NULL
   ,Date                       date              NULL
   ,DateTime                   datetime          NULL
   ,DateTime2                  datetime2(7)      NULL
   --   ,DateTimeOffset   datetimeoffset(7) NULL
   --   ,Decimal          decimal(18, 4)    NULL
   ,Float                      float             NULL
   --   ,Geography        geography         NULL
   --   ,Geometry         geometry          NULL
   --   ,HierarchyId      hierarchyid       NULL
   --   ,Image            image             NULL
   --   ,Int              int               NULL
   ,Money                      money             NULL
   ,NChar                      nchar(10)         NULL
   ,NText                      ntext             NULL
   ,Numeric                    numeric(16, 6)    NULL
   --   ,NVarchar         nvarchar(50)      NULL
   --   ,NVarcharMax      nvarchar(MAX)     NULL
   ,Real                       real              NULL
   ,SmallDateTime              smalldatetime     NULL
   ,SmallInt                   smallint          NULL
   ,SmallMoney                 smallmoney        NULL
   --   ,SQLVariant       sql_variant       NULL
   ,Text                       text              NULL
   ,Time                       time(7)           NULL
   --   ,TimeStamp        timestamp         NULL
   ,TinyInt                    tinyint           NULL
   ,UniqueIdentifier           uniqueidentifier  NULL
   --   ,VarBinary        varbinary(500)    NULL
   --   ,VarBinaryMax     varbinary(MAX)    NULL
   ,VarChar                    varchar(3346)     NULL
   ,VarCharMax                 varchar(MAX)      NULL
   ,XML                        xml               NULL
   ,CONSTRAINT Sales_Customer_OrganizationId PRIMARY KEY CLUSTERED (OrganizationId ASC)
   ,CONSTRAINT Sales_Customer_CreditLimit_Greater_Than_Zero CHECK (CreditLimit >= 0)
   ,CONSTRAINT Sales_Customer_PaymentDays_Greater_Than_Zero CHECK (PaymentDays >= 0)
   ,CONSTRAINT Sales_Customer_StandardDiscountPercentage_Greater_Zero_To_One_Hundred CHECK (StandardDiscountPercentage >= 0
                                                                                     AND StandardDiscountPercentage <= 100
    )
);
GO

/**********************************************************************************************************************
** Create Supplier
**********************************************************************************************************************/

CREATE TABLE Purchasing.Supplier (
    OrganizationId    int               NOT NULL CONSTRAINT Purchasing_Supplier_Application_Organization FOREIGN KEY REFERENCES Application.Organization (OrganizationId)
   ,PaymentDays       int               NOT NULL
   ,InternalComment   nvarchar(MAX)     NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Purchasing_Supplier_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Purchasing_Supplier_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Purchasing_Supplier_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Purchasing_Supplier_OrganizationId PRIMARY KEY CLUSTERED (OrganizationId ASC)
   ,CONSTRAINT Purchasing_Supplier_PaymentDays_Greater_Than_Zero CHECK (PaymentDays >= 0)
);
GO

/**********************************************************************************************************************
** Create Location
**********************************************************************************************************************/

CREATE TABLE Application.Location (
    LocationId          int               NOT NULL IDENTITY(1, 1)
   ,OrganizationId      int               NOT NULL CONSTRAINT Application_Location_Application_Organization FOREIGN KEY REFERENCES Application.Organization (OrganizationId)
   ,AddressId           int               NOT NULL CONSTRAINT Application_Location_Application_Address FOREIGN KEY REFERENCES Application.Address (AddressId)
   ,AddressTypeId       tinyint           NOT NULL CONSTRAINT Application_Location_Application_AddressType FOREIGN KEY REFERENCES Application.AddressType (AddressTypeId)
   ,LocationName        nvarchar(100)     NULL
   ,DeliverInstructions nvarchar(MAX)     NULL
   ,IsDeliverOnSunday   bit               NOT NULL
   ,IsDeliverOnSaturday bit               NOT NULL
   ,RowUpdatePersonId   int               NOT NULL CONSTRAINT Application_Location_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime       datetimeoffset(7) NOT NULL CONSTRAINT Application_Location_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime       datetimeoffset(7) NOT NULL CONSTRAINT Application_Location_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp     rowversion        NOT NULL
   ,CONSTRAINT Application_Location_LocationId PRIMARY KEY CLUSTERED (LocationId ASC)
   ,CONSTRAINT Application_Location_OrganizationId_AddressId_AddressTypeId UNIQUE NONCLUSTERED (
        OrganizationId ASC
       ,AddressId ASC
       ,AddressTypeId ASC
    )
   ,INDEX Application_Location_OrganizationId NONCLUSTERED (OrganizationId ASC)
   ,INDEX Application_Location_AddressId NONCLUSTERED (AddressId ASC)
   ,INDEX Application_Location_AddressTypeId NONCLUSTERED (AddressTypeId ASC)
);
GO

/**********************************************************************************************************************
** Create PhoneType
**********************************************************************************************************************/

CREATE TABLE Application.PhoneType (
    PhoneTypeId       tinyint           NOT NULL IDENTITY(1, 1)
   ,PhoneTypeName     nvarchar(20)      NOT NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_PhoneType_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_PhoneType_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_PhoneType_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_PhoneType_PhoneTypeId PRIMARY KEY CLUSTERED (PhoneTypeId ASC)
   ,CONSTRAINT Application_PhoneType_PhoneTypeName_Unique UNIQUE (PhoneTypeName)
);
GO

/**********************************************************************************************************************
** Create OrganizationPhone
**********************************************************************************************************************/

CREATE TABLE Application.OrganizationPhone (
    OrganizationPhoneId int               NOT NULL
   ,OrganizationId      int               NOT NULL CONSTRAINT Application_OrganizationPhone_Application_Organization FOREIGN KEY REFERENCES Application.Organization (OrganizationId)
   ,PhoneTypeId         tinyint           NOT NULL CONSTRAINT Application_OrganizationPhone_Application_PhoneType FOREIGN KEY REFERENCES Application.PhoneType (PhoneTypeId)
   ,PhoneNumber         nvarchar(50)      NULL
   ,RowUpdatePersonId   int               NOT NULL CONSTRAINT Application_OrganizationPhone_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime       datetimeoffset(7) NOT NULL CONSTRAINT Application_OrganizationPhone_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime       datetimeoffset(7) NOT NULL CONSTRAINT Application_OrganizationPhone_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp     rowversion        NOT NULL
   ,CONSTRAINT Application_OrganizationPhone_OrganizationPhoneId PRIMARY KEY CLUSTERED (OrganizationPhoneId ASC)
   ,CONSTRAINT Application_OrganizationPhone_OrganizationPhoneId_PhoneTypeId_PhoneNumber UNIQUE (
        OrganizationPhoneId ASC
       ,PhoneTypeId ASC
       ,PhoneNumber ASC
    )
   ,INDEX Application_OrganizationPhone_PersonId NONCLUSTERED (OrganizationPhoneId ASC)
   ,INDEX Application_OrganizationPhone_PhoneTypeId NONCLUSTERED (PhoneTypeId ASC)
);
GO

/**********************************************************************************************************************
** Create OrganizationPerson
**********************************************************************************************************************/

CREATE TABLE Application.OrganizationPerson (
    OrganizationPersonId int               NOT NULL IDENTITY(1, 1)
   ,OrganizationId       int               NOT NULL CONSTRAINT Application_OrganizationPerson_Application_Organization FOREIGN KEY REFERENCES Application.Organization (OrganizationId)
   ,PersonId             int               NOT NULL CONSTRAINT Application_OrganizationPerson_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdatePersonId    int               NOT NULL CONSTRAINT Application_OrganizationPerson_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime        datetimeoffset(7) NOT NULL CONSTRAINT Application_OrganizationPerson_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime        datetimeoffset(7) NOT NULL CONSTRAINT Application_OrganizationPerson_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp      rowversion        NOT NULL
   ,CONSTRAINT Application_OrganizationPerson_OrganizationPersonId PRIMARY KEY CLUSTERED (OrganizationPersonId ASC)
   ,CONSTRAINT Application_OrganizationPerson_OrganizationId_PersonId UNIQUE NONCLUSTERED (
        OrganizationId ASC
       ,PersonId ASC
    )
   ,INDEX Application_OrganizationPerson_PersonId NONCLUSTERED (PersonId ASC)
   ,INDEX Application_OrganizationPerson_OrganizationId NONCLUSTERED (OrganizationId ASC)
);
GO

/**********************************************************************************************************************
** Create OrganizationEmail
**********************************************************************************************************************/

CREATE TABLE Application.OrganizationEmail (
    OrganizationEmailId int               NOT NULL IDENTITY(1, 1)
   ,OrganizationId      int               NOT NULL CONSTRAINT Application_OrganizationEmail_Application_Person FOREIGN KEY REFERENCES Application.Organization (OrganizationId)
   ,EmailTypeId         tinyint           NOT NULL CONSTRAINT Application_OrganizationEmail_Application_EmailType FOREIGN KEY REFERENCES Application.EmailType (EmailTypeId)
   ,EmailAddress        nvarchar(254)     NULL
   ,RowUpdatePersonId   int               NOT NULL CONSTRAINT Application_OrganizationEmail_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime       datetimeoffset(7) NOT NULL CONSTRAINT Application_OrganizationEmail_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime       datetimeoffset(7) NOT NULL CONSTRAINT Application_OrganizationEmail_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp     rowversion        NOT NULL
   ,CONSTRAINT Application_OrganizationEmail_OrganizationEmailId PRIMARY KEY CLUSTERED (OrganizationEmailId ASC)
   ,CONSTRAINT Application_OrganizationEmail_OrganizationId_EmailId_EmailTypeId UNIQUE NONCLUSTERED (
        OrganizationId ASC
       ,EmailTypeId ASC
       ,EmailAddress ASC
    )
   ,INDEX Application_OrganizationEmail_EmailTypeId NONCLUSTERED (EmailTypeId ASC)
   ,INDEX Application_OrganizationEmail_OrganizationId NONCLUSTERED (OrganizationId ASC)
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
    PersonPhoneId     int               NOT NULL
   ,PersonId          int               NOT NULL CONSTRAINT Application_PersonPhone_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,PhoneTypeId       tinyint           NOT NULL CONSTRAINT Application_PersonPhone_Application_PhoneType FOREIGN KEY REFERENCES Application.PhoneType (PhoneTypeId)
   ,PhoneNumber       nvarchar(50)      NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_PersonPhone_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_PersonPhone_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_PersonPhone_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_PersonPhone_PersonPhoneId PRIMARY KEY CLUSTERED (PersonPhoneId ASC)
   ,CONSTRAINT Application_PersonPhone_PersonId_PhoneTypeId_PhoneNumber UNIQUE (
        PersonId ASC
       ,PhoneTypeId ASC
       ,PhoneNumber ASC
    )
   ,INDEX Application_PersonPhone_PersonId NONCLUSTERED (PersonId ASC)
   ,INDEX Application_PersonPhone_PhoneTypeId NONCLUSTERED (PhoneTypeId ASC)
);
GO

/**********************************************************************************************************************
** Create LocationPhone
**********************************************************************************************************************/

CREATE TABLE Application.LocationPhone (
    LocationPhoneId   int               NOT NULL IDENTITY(1, 1)
   ,LocationId        int               NOT NULL CONSTRAINT Application_LocationPhone_Application_Location FOREIGN KEY REFERENCES Application.Location (LocationId)
   ,PhoneTypeId       tinyint           NOT NULL CONSTRAINT Application_LocationPhone_Application_PhoneType FOREIGN KEY REFERENCES Application.PhoneType (PhoneTypeId)
   ,PhoneNumber       nvarchar(50)      NOT NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_LocationPhone_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_LocationPhone_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_LocationPhone_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_LocationPhone_LocationPhoneId PRIMARY KEY CLUSTERED (LocationPhoneId ASC)
   ,CONSTRAINT Application_LocationPhone_LocationId_PhoneTypeId_PhoneNumber UNIQUE (
        LocationId ASC
       ,PhoneTypeId ASC
       ,PhoneNumber ASC
    )
   ,INDEX Application_LocationPhone_LocationId NONCLUSTERED (LocationId ASC)
   ,INDEX Application_LocationPhone_PhoneTypeId NONCLUSTERED (PhoneTypeId ASC)
);
GO

/**********************************************************************************************************************
** Create DeliveryType
**********************************************************************************************************************/

CREATE TABLE Application.DeliveryType (
    DeliveryTypeId    tinyint           NOT NULL IDENTITY(1, 1)
   ,DeliveryTypeName  nvarchar(50)      NOT NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_DeliveryType_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_DeliveryType_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_DeliveryType_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_DeliveryType_DeliveryTypeId PRIMARY KEY CLUSTERED (DeliveryTypeId ASC)
   ,CONSTRAINT Application_DeliveryType_DeliveryTypeName_Unique UNIQUE (DeliveryTypeName)
);
GO

/**********************************************************************************************************************
** Create Category
**********************************************************************************************************************/

CREATE TABLE Application.Category (
    CategoryId         int               NOT NULL IDENTITY(1, 1)
   ,ParentIdCategoryId int               NULL CONSTRAINT Application_Category_ParentIdCategoryId FOREIGN KEY REFERENCES Application.Category (CategoryId)
   ,CategoryName       nvarchar(200)     NOT NULL
   ,CategorySlug       nvarchar(400)     NOT NULL
   ,RowUpdatePersonId  int               NOT NULL CONSTRAINT Application_Category_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime      datetimeoffset(7) NOT NULL CONSTRAINT Application_Category_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime      datetimeoffset(7) NOT NULL CONSTRAINT Application_Category_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp    rowversion        NOT NULL
   ,CONSTRAINT Application_Category_CategoryId PRIMARY KEY CLUSTERED (CategoryId ASC)
   ,CONSTRAINT Application_Category_CategorySlug UNIQUE NONCLUSTERED (CategorySlug ASC)
);
GO

/**********************************************************************************************************************
** Create Product
**********************************************************************************************************************/

CREATE TABLE Application.Product (
    ProductId          int               NOT NULL IDENTITY(1, 1)
   ,ProductName        nvarchar(200)     NOT NULL
   ,ProductSlug        nvarchar(400)     NOT NULL
   ,ImageJSON          nvarchar(MAX)     NULL
   ,ProductDescription nvarchar(MAX)     NULL
   ,RowUpdatePersonId  int               NOT NULL CONSTRAINT Application_Product_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime      datetimeoffset(7) NOT NULL CONSTRAINT Application_Product_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime      datetimeoffset(7) NOT NULL CONSTRAINT Application_Product_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp    rowversion        NOT NULL
   ,CONSTRAINT Application_Product_ProductId PRIMARY KEY CLUSTERED (ProductId ASC)
   ,CONSTRAINT Application_Product_ProductName UNIQUE NONCLUSTERED (ProductName ASC)
   ,CONSTRAINT Application_Product_ProductSlug UNIQUE NONCLUSTERED (ProductSlug ASC)
);
GO

/**********************************************************************************************************************
** Create ProductCategory
**********************************************************************************************************************/

CREATE TABLE Application.ProductCategory (
    ProductCategoryId int               NOT NULL IDENTITY(1, 1)
   ,ProductId         int               NOT NULL CONSTRAINT Application_ProductCategory_Application_Product FOREIGN KEY REFERENCES Application.Product (ProductId)
   ,CategoryId        int               NOT NULL CONSTRAINT Application_ProductCategory_Application_Category FOREIGN KEY REFERENCES Application.Category (CategoryId)
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_ProductCategory_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_ProductCategory_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_ProductCategory_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_ProductCategory_ProductCategoryId PRIMARY KEY CLUSTERED (ProductCategoryId ASC)
);
GO

/**********************************************************************************************************************
** Create Attribute
**********************************************************************************************************************/

CREATE TABLE Application.Attribute (
    AttributeId       int               NOT NULL IDENTITY(1, 1)
   ,AttributeName     nvarchar(100)     NOT NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_Attribute_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Attribute_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_Attribute_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_Attribute_AttributeId PRIMARY KEY CLUSTERED (AttributeId ASC)
);
GO

/**********************************************************************************************************************
** Create AttributeTerm
**********************************************************************************************************************/

CREATE TABLE Application.AttributeTerm (
    AttributeTermId   int               NOT NULL IDENTITY(1, 1)
   ,AttributeId       int               NOT NULL CONSTRAINT Application_AttributeTerm_Application_Attribute FOREIGN KEY REFERENCES Application.Attribute (AttributeId)
   ,TermName          nvarchar(100)     NOT NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_AttributeTerm_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_AttributeTerm_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_AttributeTerm_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_AttributeTerm_AttributeTermId PRIMARY KEY CLUSTERED (AttributeTermId ASC)
   ,INDEX Application_AttributeTerm_AttributeId NONCLUSTERED (AttributeId ASC)
   ,INDEX Application_AttributeTerm_TermName NONCLUSTERED (TermName ASC)
);
GO

/**********************************************************************************************************************
** Create ProductItem
**********************************************************************************************************************/
CREATE TABLE Application.ProductItem (
    ProductItemId     int               NOT NULL IDENTITY(1, 1)
   ,ProductId         int               NOT NULL CONSTRAINT Application_ProductItem_Application_Product FOREIGN KEY REFERENCES Application.Product (ProductId)
   ,UPC               varchar(12)       NULL
   ,IsEnableFlag      bit               NOT NULL
   ,IsVirtualFlag     bit               NOT NULL
   ,RegularPrice      decimal(18, 2)    NOT NULL
   ,SalePrice         decimal(18, 2)    NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_ProductItem_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_ProductItem_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_ProductItem_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_ProductItem_ProductItemId PRIMARY KEY CLUSTERED (ProductItemId ASC)
   ,INDEX Application_ProductItem_ProductId NONCLUSTERED (ProductId ASC)
   ,CONSTRAINT Application_ProductItem_RegularPrice_Greater_Than_Zero CHECK (RegularPrice >= 0)
   ,CONSTRAINT Application_ProductItem_SalePrice_Greater_Than_Zero CHECK (SalePrice >= 0)
   ,CONSTRAINT Application_ProductItem_SalePrice_LessEqual_To_RegularPrice CHECK (SalePrice <= RegularPrice)
);
GO


/**********************************************************************************************************************
** Create ProductVariant
**********************************************************************************************************************/

CREATE TABLE Application.ProductVariant (
    ProductVariantId  int               NOT NULL IDENTITY(1, 1)
   ,ProductItemId     int               NOT NULL CONSTRAINT Application_ProductVariant_Application_ProductItem FOREIGN KEY REFERENCES Application.ProductItem (ProductItemId)
   ,AttributeTermId   int               NOT NULL CONSTRAINT Application_ProductVariant_Application_AttributeTerm FOREIGN KEY REFERENCES Application.AttributeTerm (AttributeTermId)
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_ProductVariant_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_ProductVariant_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_ProductVariant_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_ProductVariant_ProductVariantId PRIMARY KEY CLUSTERED (ProductVariantId ASC)
   ,INDEX Application_ProductVariant_ProductItemId NONCLUSTERED (ProductItemId ASC)
   ,INDEX Application_ProductVariant_AttributeTermId NONCLUSTERED (AttributeTermId ASC)
);
GO

/**********************************************************************************************************************
** Create PurchaseOrder
**********************************************************************************************************************/

CREATE TABLE Purchasing.PurchaseOrder (
    PurchaseOrderId      int               NOT NULL IDENTITY(1000, 1)
   --,SupplierId           int               NOT NULL CONSTRAINT Purchasing_PurchaseOrder_Application_Supplier FOREIGN KEY REFERENCES Purchasing.Supplier (SupplierId)
   ,OrganizationId       int               NOT NULL CONSTRAINT Purchasing_PurchaseOrder_Application_OrganizationId FOREIGN KEY REFERENCES Purchasing.Supplier (OrganizationId)
   ,OrderDate            datetimeoffset(7) NOT NULL
   ,ExpectedDeliveryDate datetimeoffset(7) NULL
   ,DeliveryTypeId       tinyint           NOT NULL CONSTRAINT Purchasing_PurchaseOrder_Application_DeliveryType FOREIGN KEY REFERENCES Application.DeliveryType (DeliveryTypeId)
   ,ContactPersonId      int               NOT NULL CONSTRAINT Purchasing_PurchaseOrder_Application_ContactPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,SupplierReference    nvarchar(20)      NULL
   ,IsOrderFinalizedFlag bit               NOT NULL
   ,Comment              nvarchar(MAX)     NULL
   ,RowUpdatePersonId    int               NOT NULL CONSTRAINT Purchasing_PurchaseOrder_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime        datetimeoffset(7) NOT NULL CONSTRAINT Purchasing_PurchaseOrder_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime        datetimeoffset(7) NOT NULL CONSTRAINT Purchasing_PurchaseOrder_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp      rowversion        NOT NULL
   ,CONSTRAINT Purchasing_PurchaseOrder_PurchaseOrderId PRIMARY KEY CLUSTERED (PurchaseOrderId ASC)
   --,INDEX Purchasing_PurchaseOrder_SupplierId NONCLUSTERED (SupplierId ASC)
   ,INDEX Purchasing_PurchaseOrder_OrganizationId NONCLUSTERED (OrganizationId ASC)
   ,INDEX Purchasing_PurchaseOrder_DeliveryTypeId NONCLUSTERED (DeliveryTypeId ASC)
   ,INDEX Purchasing_PurchaseOrder_ContactPersonId NONCLUSTERED (ContactPersonId ASC)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Numeric Id used for reference to a purchase order within the database'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrder'
   ,@level2type = N'COLUMN'
   ,@level2name = N'PurchaseOrderId';
GO

--EXEC sys.sp_addextendedproperty
--    @name = N'Description'
--   ,@value = N'Supplier for this purchase order'
--   ,@level0type = N'SCHEMA'
--   ,@level0name = N'Purchasing'
--   ,@level1type = N'TABLE'
--   ,@level1name = N'PurchaseOrder'
--   ,@level2type = N'COLUMN'
--   ,@level2name = N'SupplierId';
--GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Date that this purchase order was raised'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrder'
   ,@level2type = N'COLUMN'
   ,@level2name = N'OrderDate';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'How this purchase order should be delivered'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrder'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DeliveryTypeId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'The person who is the primary contact for this purchase order'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrder'
   ,@level2type = N'COLUMN'
   ,@level2name = N'ContactPersonId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Expected delivery date for this purchase order'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrder'
   ,@level2type = N'COLUMN'
   ,@level2name = N'ExpectedDeliveryDate';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Supplier reference for our organization (might be our account number at the supplier)'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrder'
   ,@level2type = N'COLUMN'
   ,@level2name = N'SupplierReference';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Is this purchase order now considered finalized?'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrder'
   ,@level2type = N'COLUMN'
   ,@level2name = N'IsOrderFinalizedFlag';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Any comments related this purchase order (comments sent to the supplier)'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrder'
   ,@level2type = N'COLUMN'
   ,@level2name = N'Comment';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Details of supplier purchase orders'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrder';
GO

/**********************************************************************************************************************
** Create UnitType
**********************************************************************************************************************/

CREATE TABLE Application.UnitType (
    UnitTypeId        tinyint           NOT NULL IDENTITY(1, 1)
   ,UnitTypeName      nvarchar(50)      NOT NULL
   ,RowUpdatePersonId int               NOT NULL CONSTRAINT Application_UnitType_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_UnitType_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     datetimeoffset(7) NOT NULL CONSTRAINT Application_UnitType_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp   rowversion        NOT NULL
   ,CONSTRAINT Application_UnitType_EmailTypeId PRIMARY KEY CLUSTERED (UnitTypeId ASC)
   ,CONSTRAINT Application_UnitType_EmailTypeName_Unique UNIQUE (UnitTypeName)
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

CREATE TABLE Purchasing.PurchaseOrderLine (
    PurchaseOrderLineId      int               NOT NULL IDENTITY(1, 1)
   ,PurchaseOrderId          int               NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_Purchasing_PurchaseOrder FOREIGN KEY REFERENCES Purchasing.PurchaseOrder (PurchaseOrderId)
   ,ProductItemId            int               NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_Application_ProductItem FOREIGN KEY REFERENCES Application.ProductItem (ProductItemId)
   ,UnitTypeId               tinyint           NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_Application_UnitType FOREIGN KEY REFERENCES Application.UnitType (UnitTypeId)
   ,QuantityOrdered          int               NOT NULL
   ,QuantityReceived         int               NOT NULL
   ,UnitPrice                decimal(18, 2)    NOT NULL
   ,DiscountPercentage       decimal(18, 3)    NULL
   ,NetAmount                decimal(18, 2)    NOT NULL
   ,IsOrderLineFinalizedFlag bit               NOT NULL
   ,RowUpdatePersonId        int               NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime            datetimeoffset(7) NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime            datetimeoffset(7) NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowVersionStamp          rowversion        NOT NULL
   ,CONSTRAINT Purchasing_PurchaseOrderLine_PurchaseOrderLineId PRIMARY KEY CLUSTERED (PurchaseOrderLineId ASC)
   ,CONSTRAINT Purchasing_PurchaseOrderLine_QuantityOrdered_Greater_Than_Zero CHECK (QuantityOrdered >= 0)
   ,CONSTRAINT Purchasing_PurchaseOrderLine_QuantityReceived_Greater_Than_Zero CHECK (QuantityReceived >= 0)
   ,CONSTRAINT Purchasing_PurchaseOrderLine_UnitPrice_Greater_Than_Zero CHECK (UnitPrice >= 0)
   ,CONSTRAINT Purchasing_PurchaseOrderLine_DiscountPercentage_Zero_To_One_Hundred CHECK (DiscountPercentage >= 0
                                                                                   AND DiscountPercentage <= 100
    )
   ,CONSTRAINT Purchasing_PurchaseOrderLine_NetAmount_Greater_Than_Zero CHECK (NetAmount >= 0)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Numeric ID used for reference to a line on a purchase order within the database'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrderLine'
   ,@level2type = N'COLUMN'
   ,@level2name = N'PurchaseOrderLineId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Purchase order that this line is associated with'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrderLine'
   ,@level2type = N'COLUMN'
   ,@level2name = N'PurchaseOrderId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Stock item for this purchase order line'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrderLine'
   ,@level2type = N'COLUMN'
   ,@level2name = N'ProductItemId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Quantity of the stock item that is ordered'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrderLine'
   ,@level2type = N'COLUMN'
   ,@level2name = N'QuantityOrdered';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Total quantity of the stock item that has been received so far'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrderLine'
   ,@level2type = N'COLUMN'
   ,@level2name = N'QuantityReceived';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Type of package received'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrderLine'
   ,@level2type = N'COLUMN'
   ,@level2name = N'UnitTypeId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'The unit price that we expect to be charged'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrderLine'
   ,@level2type = N'COLUMN'
   ,@level2name = N'UnitPrice';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'The discount percent that we expect to receive'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrderLine'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DiscountPercentage';
GO


EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'The net amount that we expect to be charged'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrderLine'
   ,@level2type = N'COLUMN'
   ,@level2name = N'NetAmount';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Is this purchase order line now considered finalized? (Receipted quantities and weights are often not precise)'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrderLine'
   ,@level2type = N'COLUMN'
   ,@level2name = N'IsOrderLineFinalizedFlag';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Detail lines from supplier purchase order'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrderLine';
GO

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
   ,CONSTRAINT Application_Time_Time_Key PRIMARY KEY CLUSTERED (TimeId ASC)
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
   ,@value = N'Standard US Date Format of MM/DD/YYYY'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DateNameUS';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Standard European Union Date Format of DD/MM/YYYY'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Date'
   ,@level2type = N'COLUMN'
   ,@level2name = N'DateNameEU';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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
    @name = N'Description'
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

--TODO: Add FK for *_RowUpdatePerson back
--TODO: Add PurchaseOrderLines and other tables in Purchasing schema from WideWorldImporters
--TODO: HR tables from AdventureWorks2019
--         Person to Employee to PermanentEmployee and ContractEmployee? some kind of 3 level inheritance 
--                 Could this be done with a pay table?
--TODO: Document table that links has a URI to the document on the file system, HR can link to resumes
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
--TODO: Accounting??
--TODO: Data Warehouse
--TODO: Power BI
--TODO: SSRS reports
--TODO: RMA
--TODO: separate images into table vs json


/*
SELECT [Table] = 'Application.Address',			  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.Address UNION
SELECT [Table] = 'Application.AddressType',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.AddressType UNION
SELECT [Table] = 'Application.Attribute',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.Attribute UNION
SELECT [Table] = 'Application.AttributeTerm',	  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.AttributeTerm UNION
SELECT [Table] = 'Application.Category',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.Category UNION
SELECT [Table] = 'Application.CityTown',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.CityTown UNION
SELECT [Table] = 'Application.CountryRegion',	  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.CountryRegion UNION
SELECT [Table] = 'Application.DeliveryType',	  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.DeliveryType UNION
SELECT [Table] = 'Application.EmailType',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.EmailType UNION
SELECT [Table] = 'Application.Location',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.Location UNION
SELECT [Table] = 'Application.LocationPhone',	  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.LocationPhone UNION
SELECT [Table] = 'Application.Number',			  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.Number UNION
SELECT [Table] = 'Application.Organization',	  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.Organization UNION
SELECT [Table] = 'Application.OrganizationEmail', [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.OrganizationEmail UNION
SELECT [Table] = 'Application.OrganizationPhone', [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.OrganizationPhone UNION
SELECT [Table] = 'Application.Person',			  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.Person UNION
SELECT [Table] = 'Application.PersonClaim',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.PersonClaim UNION
SELECT [Table] = 'Application.PersonEmail',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.PersonEmail UNION
SELECT [Table] = 'Application.PersonLogin',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.PersonLogin UNION
SELECT [Table] = 'Application.PersonPhone',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.PersonPhone UNION
SELECT [Table] = 'Application.PersonRole',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.PersonRole UNION
SELECT [Table] = 'Application.PersonToken',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.PersonToken UNION
SELECT [Table] = 'Application.PhoneType',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.PhoneType UNION
SELECT [Table] = 'Application.Product',			  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.Product UNION
SELECT [Table] = 'Application.ProductCategory',	  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.ProductCategory UNION
SELECT [Table] = 'Application.ProductItem',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.ProductItem UNION
SELECT [Table] = 'Application.ProductVariant',	  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.ProductVariant UNION
SELECT [Table] = 'Application.Residence',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.Residence UNION
SELECT [Table] = 'Application.Role',			  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.Role UNION
SELECT [Table] = 'Application.RoleClaim',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.RoleClaim UNION
SELECT [Table] = 'Application.StateProvince',	  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.StateProvince UNION
SELECT [Table] = 'Application.Time',			  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.Time UNION
SELECT [Table] = 'Application.UnitType',		  [Count] = FORMAT(COUNT(*), '#,##0') FROM Application.UnitType UNION
SELECT [Table] = 'Purchasing.PurchaseOrder',	  [Count] = FORMAT(COUNT(*), '#,##0') FROM Purchasing.PurchaseOrder UNION
SELECT [Table] = 'Purchasing.PurchaseOrderLine',  [Count] = FORMAT(COUNT(*), '#,##0') FROM Purchasing.PurchaseOrderLine UNION
SELECT [Table] = 'Purchasing.Supplier',			  [Count] = FORMAT(COUNT(*), '#,##0') FROM Purchasing.Supplier UNION
SELECT [Table] = 'Sales.Customer',				  [Count] = FORMAT(COUNT(*), '#,##0') FROM Sales.Customer
ORDER BY [Table];
*/

