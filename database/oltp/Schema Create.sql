/**********************************************************************************************************************
** Create Database
**********************************************************************************************************************/
/*
DROP DATABASE IF EXISTS KevinMartinTech;
GO

CREATE DATABASE KevinMartinTech;
GO
*/
USE KevinMartinTech;
/**********************************************************************************************************************
** Drop tables
**********************************************************************************************************************/

DROP TABLE IF EXISTS Purchasing.PurchaseOrderLine;
DROP TABLE IF EXISTS Purchasing.PurchaseOrder;
DROP TABLE IF EXISTS Application.ProductVariant;
DROP TABLE IF EXISTS Application.Product;
DROP TABLE IF EXISTS Application.ProductCategory;

DROP TABLE IF EXISTS Application.AttributeTerm;
DROP TABLE IF EXISTS Application.Attribute;
DROP TABLE IF EXISTS Application.LocationPhone;
DROP TABLE IF EXISTS Application.PersonPhone;
DROP TABLE IF EXISTS Application.PersonEmail;
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

CREATE SCHEMA Application;
GO
CREATE SCHEMA Sales;
GO
CREATE SCHEMA Purchasing;
GO
CREATE SCHEMA Warehouse;
GO

/**********************************************************************************************************************
** Create Person
**********************************************************************************************************************/

CREATE TABLE Application.Person (
    PersonId          INT               IDENTITY(1, 1) NOT NULL
   ,Title             NVARCHAR(10)      NULL
   ,FirstName         NVARCHAR(100)     NULL
   ,LastName          NVARCHAR(100)     NULL
   ,Suffix            NVARCHAR(10)      NULL
   ,NickName          NVARCHAR(100)     NULL
   ,SearchName        AS (TRIM(CONCAT(ISNULL(TRIM(NickName) + ' ', ''), ISNULL(TRIM(FirstName) + ' ', ''), ISNULL(TRIM(LastName) + ' ', ''), ISNULL(TRIM(Suffix) + '', '')))) PERSISTED NOT NULL
   ,IsOptOutFlag      BIT               NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_Person_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_Person_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_Person_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_Person_PersonId PRIMARY KEY CLUSTERED (PersonId ASC)
   ,INDEX Application_Person_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
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
** Create CountryRegion
**********************************************************************************************************************/

CREATE TABLE Application.CountryRegion (
    CountryRegionId   INT               NOT NULL
   ,CountryName       NVARCHAR(60)      NOT NULL
   ,FormalName        NVARCHAR(60)      NOT NULL
   ,IsoAlpha3Code     NVARCHAR(3)       NULL
   ,IsoNumericCode    INT               NULL
   ,CountryType       NVARCHAR(20)      NULL
   ,Continent         NVARCHAR(30)      NOT NULL
   ,Region            NVARCHAR(30)      NOT NULL
   ,Subregion         NVARCHAR(30)      NOT NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_CountryRegion_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_CountryRegion_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_CountryRegion_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_CountryRegion_CountryRegionId PRIMARY KEY CLUSTERED (CountryRegionId ASC)
   ,CONSTRAINT Application_CountryRegion_CountryName UNIQUE NONCLUSTERED (CountryName ASC)
   ,CONSTRAINT Application_CountryRegion_FormalName UNIQUE NONCLUSTERED (FormalName ASC)
   ,INDEX Application_CountryRegion_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
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
    StateProvinceId   INT               NOT NULL
   ,CountryRegionId   INT               NOT NULL CONSTRAINT Application_StateProvince_Application_CountryRegion FOREIGN KEY REFERENCES Application.CountryRegion (CountryRegionId)
   ,StateProvinceCode NVARCHAR(5)       NULL
   ,StateProvinceName NVARCHAR(50)      NOT NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_StateProvince_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_StateProvince_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_StateProvince_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_StateProvince_StateProvinceId PRIMARY KEY CLUSTERED (StateProvinceId ASC)
   ,CONSTRAINT Application_StateProvince_CountryRegionId_StateProvinceCode_StateProvinceName UNIQUE NONCLUSTERED (CountryRegionId ASC, StateProvinceCode ASC, StateProvinceName ASC)
   ,CONSTRAINT Application_StateProvince_StateProvinceName UNIQUE NONCLUSTERED (StateProvinceName ASC)
   ,INDEX Application_StateProvince_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
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
    CityTownId        INT               NOT NULL
   ,StateProvinceId   INT               NOT NULL CONSTRAINT Application_CityTown_Application_StateProvince FOREIGN KEY REFERENCES Application.StateProvince (StateProvinceId)
   ,CityTownName      NVARCHAR(50)      NOT NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_CityTown_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_CityTown_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_CityTown_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_CityTown_CityTownId PRIMARY KEY CLUSTERED (CityTownId ASC)
   ,CONSTRAINT Application_CityTown_StateProvinceId_CityName UNIQUE NONCLUSTERED (StateProvinceId ASC, CityTownName ASC)
   ,INDEX Application_CityTown_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
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
    AddressTypeId     TINYINT           NOT NULL
   ,AddressTypeName   NVARCHAR(50)      NOT NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_AddressType_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_AddressType_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_AddressType_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_AddressType_AddressTypeId PRIMARY KEY CLUSTERED (AddressTypeId ASC)
   ,CONSTRAINT Application_AddressType_AddressTypeName_Unique UNIQUE (AddressTypeName)
   ,INDEX Application_AddressType_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
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
    EmailTypeId       TINYINT           NOT NULL
   ,EmailTypeName     NVARCHAR(50)      NOT NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_EmailType_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_EmailType_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_EmailType_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_EmailType_EmailTypeId PRIMARY KEY CLUSTERED (EmailTypeId ASC)
   ,CONSTRAINT Application_EmailType_EmailTypeName_Unique UNIQUE (EmailTypeName)
   ,INDEX Application_EmailType_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
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
    AddressId         INT               IDENTITY(1, 1) NOT NULL
   ,Line1             NVARCHAR(100)     NULL
   ,Line2             NVARCHAR(100)     NULL
   ,CityTownId        INT               NULL CONSTRAINT Application_Address_Application_CityTown FOREIGN KEY REFERENCES Application.CityTown (CityTownId)
   ,PostalCode        NVARCHAR(12)      NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_Address_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_Address_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_Address_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_Address_AddressId PRIMARY KEY CLUSTERED (AddressId ASC)
   ,INDEX Application_Address_CityTownId NONCLUSTERED (CityTownId ASC)
   ,INDEX Application_Address_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
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
    PersonEmailId     INT               IDENTITY(1, 1) NOT NULL
   ,PersonId          INT               NOT NULL CONSTRAINT Application_PersonEmail_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,EmailTypeId       TINYINT           NOT NULL CONSTRAINT Application_PersonEmail_Application_EmailType FOREIGN KEY REFERENCES Application.EmailType (EmailTypeId)
   ,EmailAddress      NVARCHAR(254)     NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_PersonEmail_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_PersonEmail_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_PersonEmail_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_PersonEmail_PersonEmailId PRIMARY KEY CLUSTERED (PersonEmailId ASC)
   ,CONSTRAINT Application_PersonEmail_PersonId_EmailId_EmailTypeId UNIQUE NONCLUSTERED (PersonId ASC, EmailTypeId ASC, EmailAddress ASC)
   ,INDEX Application_PersonEmail_EmailTypeId NONCLUSTERED (EmailTypeId ASC)
   ,INDEX Application_PersonEmail_PersonId NONCLUSTERED (PersonId ASC)
   ,INDEX Application_PersonEmail_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
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
    ResidenceId       INT               IDENTITY(1, 1) NOT NULL
   ,PersonId          INT               NOT NULL CONSTRAINT Application_Residence_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,AddressId         INT               NOT NULL CONSTRAINT Application_Residence_Application_Address FOREIGN KEY REFERENCES Application.Address (AddressId)
   ,AddressTypeId     TINYINT           NOT NULL CONSTRAINT Application_Residence_Application_AddressType FOREIGN KEY REFERENCES Application.AddressType (AddressTypeId)
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_Residence_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_Residence_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_Residence_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_Residence_ResidenceId PRIMARY KEY CLUSTERED (ResidenceId ASC)
   ,CONSTRAINT Application_Residence_PersonId_AddressId_AddressTypeId UNIQUE NONCLUSTERED (PersonId ASC, AddressId ASC, AddressTypeId ASC)
   ,INDEX Application_Residence_PersonId NONCLUSTERED (PersonId ASC)
   ,INDEX Application_Residence_AddressId NONCLUSTERED (AddressId ASC)
   ,INDEX Application_Residence_AddressTypeId NONCLUSTERED (AddressTypeId ASC)
   ,INDEX Application_Residence_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
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
    OrganizationId    INT               IDENTITY(1, 1) NOT NULL
   ,OrganizationName  NVARCHAR(200)     NOT NULL
   ,WebsiteURL        NVARCHAR(2083)    NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_Organization_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_Organization_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_Organization_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_Organization_OrganizationId PRIMARY KEY CLUSTERED (OrganizationId ASC)
   ,INDEX Application_Organization_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create Customer
**********************************************************************************************************************/

CREATE TABLE Sales.Customer (
    CustomerId                 INT               IDENTITY(1, 1) NOT NULL
   ,OrganizationId             INT               NOT NULL CONSTRAINT Sales_Customer_Application_Organization FOREIGN KEY REFERENCES Application.Organization (OrganizationId)
   ,CreditLimit                DECIMAL(18, 2)    NULL
   ,PaymentDays                INT               NOT NULL
   ,IsOnCreditHoldFlag         BIT               NOT NULL
   ,AccountOpenedDate          DATETIMEOFFSET(7) NOT NULL
   ,StandardDiscountPercentage DECIMAL(18, 3)    NOT NULL
   ,RowUpdatePersonId          INT               NOT NULL CONSTRAINT Sales_Customer_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime              DATETIMEOFFSET(7) NOT NULL CONSTRAINT Sales_Customer_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime              DATETIMEOFFSET(7) NOT NULL CONSTRAINT Sales_Customer_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Sales_Customer_CustomerId PRIMARY KEY CLUSTERED (CustomerId ASC)
   ,INDEX Sales_Customer_OrganizationId NONCLUSTERED (OrganizationId ASC)
   ,INDEX Sales_Customer_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
   ,CONSTRAINT Sales_Customer_CreditLimit_Greater_Than_Zero CHECK (CreditLimit >= 0)
   ,CONSTRAINT Sales_Customer_PaymentDays_Greater_Than_Zero CHECK (PaymentDays >= 0)
   ,CONSTRAINT Sales_Customer_StandardDiscountPercentage_Greater_Than_Zero CHECK (StandardDiscountPercentage >= 0)
);
GO

/**********************************************************************************************************************
** Create Supplier
**********************************************************************************************************************/

CREATE TABLE Purchasing.Supplier (
    SupplierId        INT               IDENTITY(1, 1) NOT NULL
   ,OrganizationId    INT               NOT NULL CONSTRAINT Purchasing_Supplier_Application_Organization FOREIGN KEY REFERENCES Application.Organization (OrganizationId)
   ,PaymentDays       INT               NOT NULL
   ,InternalComments  NVARCHAR(MAX)     NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Purchasing_Supplier_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Purchasing_Supplier_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Purchasing_Supplier_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Purchasing_Supplier_SupplierId PRIMARY KEY CLUSTERED (SupplierId ASC)
   ,INDEX Purchasing_Supplier_OrganizationId NONCLUSTERED (OrganizationId ASC)
   ,INDEX Purchasing_Supplier_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
   ,CONSTRAINT Purchasing_Supplier_PaymentDays_Greater_Than_Zero CHECK (PaymentDays >= 0)
);
GO

/**********************************************************************************************************************
** Create Location
**********************************************************************************************************************/

CREATE TABLE Application.Location (
    LocationId          INT               IDENTITY(1, 1) NOT NULL
   ,OrganizationId      INT               NOT NULL CONSTRAINT Application_Location_Application_Organization FOREIGN KEY REFERENCES Application.Organization (OrganizationId)
   ,AddressId           INT               NOT NULL CONSTRAINT Application_Location_Application_Address FOREIGN KEY REFERENCES Application.Address (AddressId)
   ,AddressTypeId       TINYINT           NOT NULL CONSTRAINT Application_Location_Application_AddressType FOREIGN KEY REFERENCES Application.AddressType (AddressTypeId)
   ,LocationName        NVARCHAR(100)     NULL
   ,DeliverInstructions NVARCHAR(MAX)     NULL
   ,IsDeliverOnSunday   BIT               NOT NULL
   ,IsDeliverOnSaturday BIT               NOT NULL
   ,RowUpdatePersonId   INT               NOT NULL CONSTRAINT Application_Location_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime       DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_Location_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime       DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_Location_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_Location_LocationId PRIMARY KEY CLUSTERED (LocationId ASC)
   ,CONSTRAINT Application_Location_OrganizationId_AddressId_AddressTypeId UNIQUE NONCLUSTERED (OrganizationId ASC, AddressId ASC, AddressTypeId ASC)
   ,INDEX Application_Location_OrganizationId NONCLUSTERED (OrganizationId ASC)
   ,INDEX Application_Location_AddressId NONCLUSTERED (AddressId ASC)
   ,INDEX Application_Location_AddressTypeId NONCLUSTERED (AddressTypeId ASC)
   ,INDEX Application_Location_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create PhoneType
**********************************************************************************************************************/

CREATE TABLE Application.PhoneType (
    PhoneTypeId       TINYINT           NOT NULL
   ,PhoneTypeName     NVARCHAR(20)      NOT NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_PhoneType_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_PhoneType_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_PhoneType_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_PhoneType_PhoneTypeId PRIMARY KEY CLUSTERED (PhoneTypeId ASC)
   ,CONSTRAINT Application_PhoneType_PhoneTypeName_Unique UNIQUE (PhoneTypeName)
   ,INDEX Application_PhoneType_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create PersonPhone
**********************************************************************************************************************/

CREATE TABLE Application.PersonPhone (
    PersonPhoneId     INT               NOT NULL
   ,PersonId          INT               NOT NULL CONSTRAINT Application_PersonPhone_Application_Person FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,PhoneTypeId       TINYINT           NOT NULL CONSTRAINT Application_PersonPhone_Application_PhoneType FOREIGN KEY REFERENCES Application.PhoneType (PhoneTypeId)
   ,PhoneNumber       NVARCHAR(50)      NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_PersonPhone_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_PersonPhone_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_PersonPhone_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_PersonPhone_PersonPhoneId PRIMARY KEY CLUSTERED (PersonPhoneId ASC)
   ,CONSTRAINT Application_PersonPhone_PersonId_PhoneTypeId_PhoneNumber UNIQUE (PersonId ASC, PhoneTypeId ASC, PhoneNumber ASC)
   ,INDEX Application_PersonPhone_PersonId NONCLUSTERED (PersonId ASC)
   ,INDEX Application_PersonPhone_PhoneTypeId NONCLUSTERED (PhoneTypeId ASC)
   ,INDEX Application_PersonPhone_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create LocationPhone
**********************************************************************************************************************/

CREATE TABLE Application.LocationPhone (
    LocationPhoneId   INT               IDENTITY(1, 1) NOT NULL
   ,LocationId        INT               NOT NULL CONSTRAINT Application_LocationPhone_Application_Location FOREIGN KEY REFERENCES Application.Location (LocationId)
   ,PhoneTypeId       TINYINT           NOT NULL CONSTRAINT Application_LocationPhone_Application_PhoneType FOREIGN KEY REFERENCES Application.PhoneType (PhoneTypeId)
   ,PhoneNumber       NVARCHAR(50)      NOT NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_LocationPhone_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_LocationPhone_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_LocationPhone_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_LocationPhone_LocationPhoneId PRIMARY KEY CLUSTERED (LocationPhoneId ASC)
   ,CONSTRAINT Application_LocationPhone_LocationId_PhoneTypeId_PhoneNumber UNIQUE (LocationId ASC, PhoneTypeId ASC, PhoneNumber ASC)
   ,INDEX Application_LocationPhone_LocationId NONCLUSTERED (LocationId ASC)
   ,INDEX Application_LocationPhone_PhoneTypeId NONCLUSTERED (PhoneTypeId ASC)
   ,INDEX Application_LocationPhone_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create DeliveryType
**********************************************************************************************************************/

CREATE TABLE Application.DeliveryType (
    DeliveryTypeId    TINYINT           NOT NULL
   ,DeliveryTypeName  NVARCHAR(50)      NOT NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_DeliveryType_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_DeliveryType_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_DeliveryType_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_DeliveryType_DeliveryTypeId PRIMARY KEY CLUSTERED (DeliveryTypeId ASC)
   ,CONSTRAINT Application_DeliveryType_DeliveryTypeName_Unique UNIQUE (DeliveryTypeName)
   ,INDEX Application_DeliveryType_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create ProductCategory
**********************************************************************************************************************/

CREATE TABLE Application.ProductCategory (
    ProductCategoryId         INT               NOT NULL
   ,ParentIdProductCategoryId INT               NULL CONSTRAINT Application_ProductCategory_ParentIdProductCategoryId FOREIGN KEY REFERENCES Application.ProductCategory (ProductCategoryId)
   ,ProductCategoryName       NVARCHAR(200)     NOT NULL
   ,ProductCategorySlug       NVARCHAR(400)     NOT NULL
   ,RowUpdatePersonId         INT               NOT NULL CONSTRAINT Application_ProductCategory_Application_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId)
   ,RowUpdateTime             DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_ProductCategory_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime             DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_ProductCategory_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_ProductCategory_ProductCategoryId PRIMARY KEY CLUSTERED (ProductCategoryId ASC)
   ,CONSTRAINT Application_ProductCategory_ProductCategorySlug UNIQUE NONCLUSTERED (ProductCategorySlug ASC)
   ,INDEX Application_ProductCategory_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create Product
**********************************************************************************************************************/

CREATE TABLE Application.Product (
    ProductId          INT               NOT NULL
   ,ProductName        NVARCHAR(200)     NOT NULL
   ,ProductSlug        NVARCHAR(400)     NOT NULL
   ,ImageLocation      NVARCHAR(2000)    NULL
   ,ProductDescription NVARCHAR(MAX)     NULL
   ,RowUpdatePersonId  INT               NOT NULL CONSTRAINT Application_Product_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime      DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_Product_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime      DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_Product_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_Product_ProductId PRIMARY KEY CLUSTERED (ProductId ASC)
   ,CONSTRAINT Application_Product_ProductName UNIQUE NONCLUSTERED (ProductName ASC)
   ,CONSTRAINT Application_Product_ProductSlug UNIQUE NONCLUSTERED (ProductSlug ASC)
   ,INDEX Application_Product_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create Attribute
**********************************************************************************************************************/

CREATE TABLE Application.Attribute (
    AttributeId       INT               NOT NULL
   ,AttributeName     NVARCHAR(100)     NOT NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_Attribute_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_Attribute_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_Attribute_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_Attribute_AttributeId PRIMARY KEY CLUSTERED (AttributeId ASC)
   ,INDEX Application_Attribute_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create AttributeTerm
**********************************************************************************************************************/

CREATE TABLE Application.AttributeTerm (
    AttributeTermId   INT               NOT NULL
   ,AttributeId       INT               NOT NULL CONSTRAINT Application_AttributeTerm_Application_Attribute FOREIGN KEY REFERENCES Application.Attribute (AttributeId)
   ,TermName          NVARCHAR(100)     NOT NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_AttributeTerm_Application_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_AttributeTerm_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_AttributeTerm_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_AttributeTerm_AttributeTermId PRIMARY KEY CLUSTERED (AttributeTermId ASC)
   ,INDEX Application_AttributeTerm_AttributeId NONCLUSTERED (AttributeId ASC)
   ,INDEX Application_AttributeTerm_TermName NONCLUSTERED (TermName ASC)
   ,INDEX Application_AttributeTerm_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

/**********************************************************************************************************************
** Create ProductVariant
**********************************************************************************************************************/

CREATE TABLE Application.ProductVariant (
    ProductVariantId  INT               NOT NULL
   ,ProductId         INT               NOT NULL CONSTRAINT Application_ProductVariant_Application_Product FOREIGN KEY REFERENCES Application.Product (ProductId)
   ,AttributeId       INT               NOT NULL CONSTRAINT Application_ProductVariant_Application_Attribute FOREIGN KEY REFERENCES Application.Attribute (AttributeId)
   ,AttributeTermId   INT               NOT NULL CONSTRAINT Application_ProductVariant_Application_AttributeTerm FOREIGN KEY REFERENCES Application.AttributeTerm (AttributeTermId)
   ,IsEnableFlag      BIT               NOT NULL
   ,IsVirtualFlag     BIT               NOT NULL
   ,RegularPrice      DECIMAL(18, 2)    NOT NULL
   ,SalePrice         DECIMAL(18, 2)    NULL
   ,SKU               NVARCHAR(50)      NULL
   ,ImageLocation     NVARCHAR(2000)    NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_ProductVariant_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_ProductVariant_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_ProductVariant_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_ProductVariant_ProductVariantId PRIMARY KEY CLUSTERED (ProductVariantId ASC)
   ,INDEX Application_ProductVariant_ProductId NONCLUSTERED (ProductId ASC)
   ,INDEX Application_ProductVariant_AttributeId NONCLUSTERED (AttributeId ASC)
   ,INDEX Application_ProductVariant_AttributeTermId NONCLUSTERED (AttributeTermId ASC)
   ,INDEX Application_ProductVariant_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
   ,CONSTRAINT Application_ProductVariant_RegularPrice_Greater_Than_Zero CHECK (RegularPrice >= 0)
   ,CONSTRAINT Application_ProductVariant_SalePrice_Greater_Than_Zero CHECK (SalePrice >= 0)
   ,CONSTRAINT Application_ProductVariant_SalePrice_LessEqual_To_RegularPrice CHECK (SalePrice <= RegularPrice)
);
GO

/**********************************************************************************************************************
** Create PurchaseOrder
**********************************************************************************************************************/

CREATE TABLE Purchasing.PurchaseOrder (
    PurchaseOrderId      INT               IDENTITY(1, 1) NOT NULL
   ,SupplierId           INT               NOT NULL CONSTRAINT Purchasing_PurchaseOrder_Application_Supplier FOREIGN KEY REFERENCES Purchasing.Supplier (SupplierId)
   ,OrderDate            DATETIMEOFFSET(7) NOT NULL
   ,DeliveryTypeId       TINYINT           NOT NULL CONSTRAINT Purchasing_PurchaseOrder_Application_DeliveryType FOREIGN KEY REFERENCES Application.DeliveryType (DeliveryTypeId)
   ,ContactPersonId      INT               NOT NULL CONSTRAINT Purchasing_PurchaseOrder_Application_ContactPerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,ExpectedDeliveryDate DATETIMEOFFSET(7) NULL
   ,SupplierReference    NVARCHAR(20)      NULL
   ,IsOrderFinalizedFlag BIT               NOT NULL
   ,Comments             NVARCHAR(MAX)     NULL
   ,InternalComments     NVARCHAR(MAX)     NULL
   ,RowUpdatePersonId    INT               NOT NULL CONSTRAINT Purchasing_PurchaseOrder_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime        DATETIMEOFFSET(7) NOT NULL CONSTRAINT Purchasing_PurchaseOrder_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime        DATETIMEOFFSET(7) NOT NULL CONSTRAINT Purchasing_PurchaseOrder_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Purchasing_PurchaseOrder_PurchaseOrderId PRIMARY KEY CLUSTERED (PurchaseOrderId ASC)
   ,INDEX Purchasing_PurchaseOrder_SupplierId NONCLUSTERED (SupplierId ASC)
   ,INDEX Purchasing_PurchaseOrder_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
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

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Supplier for this purchase order'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrder'
   ,@level2type = N'COLUMN'
   ,@level2name = N'SupplierId';
GO

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
   ,@level2name = N'Comments';
GO

EXEC sys.sp_addextendedproperty
    @name = N'Description'
   ,@value = N'Any internal comments related this purchase order (comments for internal reference only and not sent to the supplier)'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Purchasing'
   ,@level1type = N'TABLE'
   ,@level1name = N'PurchaseOrder'
   ,@level2type = N'COLUMN'
   ,@level2name = N'InternalComments';
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
    UnitTypeId        TINYINT           NOT NULL
   ,UnitTypeName      NVARCHAR(50)      NOT NULL
   ,RowUpdatePersonId INT               NOT NULL CONSTRAINT Application_UnitType_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_UnitType_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime     DATETIMEOFFSET(7) NOT NULL CONSTRAINT Application_UnitType_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Application_UnitType_EmailTypeId PRIMARY KEY CLUSTERED (UnitTypeId ASC)
   ,CONSTRAINT Application_UnitType_EmailTypeName_Unique UNIQUE (UnitTypeName)
   ,INDEX Application_UnitType_RowUpdatePersonId NONCLUSTERED (RowUpdatePersonId ASC)
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
    PurchaseOrderLineId      INT               NOT NULL
   ,PurchaseOrderId          INT               NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_Purchasing_PurchaseOrder FOREIGN KEY REFERENCES Purchasing.PurchaseOrder (PurchaseOrderId)
   ,ProductVariantId         INT               NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_Application_ProductVariant FOREIGN KEY REFERENCES Application.ProductVariant (ProductVariantId)
   ,UnitTypeId               TINYINT           NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_Application_UnitType FOREIGN KEY REFERENCES Application.UnitType (UnitTypeId)
   ,QuantityOrdered          INT               NOT NULL
   ,QuantityReceived         INT               NOT NULL
   ,UnitPrice                DECIMAL(18, 2)    NOT NULL
   ,DiscountPercentage       DECIMAL(18, 3)    NULL
   ,NetAmount                DECIMAL(18, 2)    NOT NULL
   ,IsOrderLineFinalizedFlag BIT               NOT NULL
   ,RowUpdatePersonId        INT               NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_Application_RowUpdatePerson FOREIGN KEY REFERENCES Application.Person (PersonId)
   ,RowUpdateTime            DATETIMEOFFSET(7) NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_RowUpdateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,RowCreateTime            DATETIMEOFFSET(7) NOT NULL CONSTRAINT Purchasing_PurchaseOrderLine_RowCreateTime_Default DEFAULT (SYSDATETIMEOFFSET())
   ,CONSTRAINT Purchasing_PurchaseOrderLine_PurchaseOrderLineId PRIMARY KEY CLUSTERED (PurchaseOrderLineId ASC)
   ,CONSTRAINT Purchasing_PurchaseOrderLine_QuantityOrdered_Greater_Than_Zero CHECK (QuantityOrdered >= 0)
   ,CONSTRAINT Purchasing_PurchaseOrderLine_QuantityReceived_Greater_Than_Zero CHECK (QuantityReceived >= 0)
   ,CONSTRAINT Purchasing_PurchaseOrderLine_UnitPrice_Greater_Than_Zero CHECK (UnitPrice >= 0)
   ,CONSTRAINT Purchasing_PurchaseOrderLine_DiscountPercentage_Greater_Than_Zero CHECK (DiscountPercentage >= 0)
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
   ,@level2name = N'ProductVariantId';
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




--TODO: App.Cateogry
--TODO: App.ProductCateogry


--TODO: Add PurchaseOrderLines and other tables in Purchasing schema from WideWorldImporters
--TODO: HR tables from AdventureWorks2019
--TODO: Document table that links has a URI to the document on the file system, HR can link to resumes
--TODO: Linking table for Customer, Supplier
--TODO: Add Production schema tables from AdventureWorks2019
--TODO: Add Warehouse tables from WideWorldImporters
--TODO: Add Sales tables from WideWorldImporters
--TODO: Sales Pipeline, leads, ...
--TODO: Auth, roles, membership
--TODO: Date, Time, Number tables
--TODO: Store, staff to also sell products (retail schema)