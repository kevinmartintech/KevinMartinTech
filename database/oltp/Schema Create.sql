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
DROP TABLE IF EXISTS Purchasing.PurchaseOrder;
DROP TABLE IF EXISTS Application.LocationPhone;
DROP TABLE IF EXISTS Application.PersonPhone;
DROP TABLE IF EXISTS Application.PersonEmail;
DROP TABLE IF EXISTS Application.Phone;
DROP TABLE IF EXISTS Application.Location;
DROP TABLE IF EXISTS Application.EmailType;
DROP TABLE IF EXISTS Application.DeliveryType;
DROP TABLE IF EXISTS Application.PhoneType;
DROP TABLE IF EXISTS Application.Residence;
DROP TABLE IF EXISTS Application.Address;
DROP TABLE IF EXISTS Application.AddressType;
DROP TABLE IF EXISTS Application.City;
DROP TABLE IF EXISTS Application.StateProvince;
DROP TABLE IF EXISTS Application.CountryRegion;
DROP TABLE IF EXISTS Sales.Customer;
DROP TABLE IF EXISTS Purchasing.Supplier;

DROP TABLE IF EXISTS Application.Organization;
DROP TABLE IF EXISTS Application.Person;

DROP SCHEMA IF EXISTS Application;
DROP SCHEMA IF EXISTS Sales;
DROP SCHEMA IF EXISTS Purchasing;
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

/**********************************************************************************************************************
** Create Person
**********************************************************************************************************************/

CREATE TABLE Application.Person (
    PersonId          INT           IDENTITY(1, 1) NOT NULL
   ,Title             NVARCHAR(10)  NULL
   ,FirstName         NVARCHAR(100) NULL
   ,MiddleName        NVARCHAR(100) NULL
   ,LastName          NVARCHAR(100) NULL
   ,Suffix            NVARCHAR(10)  NULL
   ,NickName          NVARCHAR(100) NULL
   ,SearchName        AS (TRIM(CONCAT(ISNULL(TRIM(NickName) + ' ', ''), ISNULL(TRIM(FirstName) + ' ', ''), ISNULL(TRIM(MiddleName) + ' ', ''), ISNULL(TRIM(LastName), '')))) PERSISTED NOT NULL
   ,IsOptOutFlag      BIT           NULL
   ,RowUpdatePersonId INT           NOT NULL
   ,RowUpdateTime     DATETIME2(7)  NOT NULL
   ,RowCreateTime     DATETIME2(7)  NOT NULL
   ,CONSTRAINT Person_PersonId PRIMARY KEY CLUSTERED (PersonId ASC)
   ,INDEX Person_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

ALTER TABLE Application.Person WITH CHECK
ADD
    CONSTRAINT Person_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Application.Person WITH CHECK
--ADD
--    CONSTRAINT Person_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Application.Person WITH CHECK
ADD
    CONSTRAINT Person_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Application.Person WITH CHECK
ADD
    CONSTRAINT Person_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
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
   ,@value = N'Middle name or middle initial of the person.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Person'
   ,@level2type = N'COLUMN'
   ,@level2name = N'MiddleName';
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

SET IDENTITY_INSERT Application.Person ON;
INSERT INTO Application.Person (PersonId, FirstName, MiddleName, LastName, RowUpdatePersonId)
VALUES
     (1, N'Data', N'Conversion', N'Only', 1);
SET IDENTITY_INSERT Application.Person OFF;

/**********************************************************************************************************************
** Create CountryRegion
**********************************************************************************************************************/

CREATE TABLE Application.CountryRegion (
    CountryRegionId   INT          NOT NULL
   ,CountryName       NVARCHAR(60) NOT NULL
   ,FormalName        NVARCHAR(60) NOT NULL
   ,IsoAlpha3Code     NVARCHAR(3)  NULL
   ,IsoNumericCode    INT          NULL
   ,CountryType       NVARCHAR(20) NULL
   ,Continent         NVARCHAR(30) NOT NULL
   ,Region            NVARCHAR(30) NOT NULL
   ,Subregion         NVARCHAR(30) NOT NULL
   ,RowUpdatePersonId INT          NOT NULL
   ,RowUpdateTime     DATETIME2(7) NOT NULL
   ,RowCreateTime     DATETIME2(7) NOT NULL
   ,CONSTRAINT CountryRegion_CountryRegionId PRIMARY KEY CLUSTERED (CountryRegionId ASC)
   ,CONSTRAINT CountryRegion_CountryName UNIQUE NONCLUSTERED (CountryName ASC)
   ,CONSTRAINT CountryRegion_FormalName UNIQUE NONCLUSTERED (FormalName ASC)
   ,INDEX CountryRegion_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

ALTER TABLE Application.CountryRegion WITH CHECK
ADD
    CONSTRAINT CountryRegion_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Application.CountryRegion WITH CHECK
--ADD
--    CONSTRAINT CountryRegion_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Application.CountryRegion WITH CHECK
ADD
    CONSTRAINT CountryRegion_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Application.CountryRegion WITH CHECK
ADD
    CONSTRAINT CountryRegion_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
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
   ,@value = N'CountryRegion that contain the states or provinces (including geographic boundaries)'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'CountryRegion';
GO

/**********************************************************************************************************************
** Create StateProvince
**********************************************************************************************************************/

CREATE TABLE Application.StateProvince (
    StateProvinceId   INT          NOT NULL
   ,CountryRegionId   INT          NOT NULL
   ,StateProvinceCode NVARCHAR(5)  NULL
   ,StateProvinceName NVARCHAR(50) NOT NULL
   ,RowUpdatePersonId INT          NOT NULL
   ,RowUpdateTime     DATETIME2(7) NOT NULL
   ,RowCreateTime     DATETIME2(7) NOT NULL
   ,CONSTRAINT StateProvince_StateProvinceId PRIMARY KEY CLUSTERED (StateProvinceId ASC)
   ,CONSTRAINT StateProvince_CountryRegionId_StateProvinceCode_StateProvinceName UNIQUE NONCLUSTERED (CountryRegionId ASC, StateProvinceCode ASC, StateProvinceName ASC)
   ,CONSTRAINT StateProvince_StateProvinceName UNIQUE NONCLUSTERED (StateProvinceName ASC)
   ,INDEX StateProvince_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

ALTER TABLE Application.StateProvince WITH CHECK
ADD
    CONSTRAINT StateProvince_CountryRegion FOREIGN KEY (CountryRegionId) REFERENCES Application.CountryRegion (CountryRegionId);
GO

ALTER TABLE Application.StateProvince WITH CHECK
ADD
    CONSTRAINT StateProvince_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Application.StateProvince WITH CHECK
--ADD
--    CONSTRAINT StateProvince_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Application.StateProvince WITH CHECK
ADD
    CONSTRAINT StateProvince_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Application.StateProvince WITH CHECK
ADD
    CONSTRAINT StateProvince_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
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

CREATE TABLE Application.City (
    CityId            INT          NOT NULL
   ,StateProvinceId   INT          NOT NULL
   ,CityName          NVARCHAR(50) NOT NULL
   ,RowUpdatePersonId INT          NOT NULL
   ,RowUpdateTime     DATETIME2(7) NOT NULL
   ,RowCreateTime     DATETIME2(7) NOT NULL
   ,CONSTRAINT City_CityId PRIMARY KEY CLUSTERED (CityId ASC)
   ,CONSTRAINT City_StateProvinceId_CityName UNIQUE NONCLUSTERED (StateProvinceId ASC, CityName ASC)
   ,INDEX City_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

ALTER TABLE Application.City WITH CHECK
ADD
    CONSTRAINT City_StateProvince FOREIGN KEY (StateProvinceId) REFERENCES Application.StateProvince (StateProvinceId);
GO

ALTER TABLE Application.City WITH CHECK
ADD
    CONSTRAINT City_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Application.City WITH CHECK
--ADD
--    CONSTRAINT City_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Application.City WITH CHECK
ADD
    CONSTRAINT City_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Application.City WITH CHECK
ADD
    CONSTRAINT City_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Primary key for city records.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'City'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CityId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'State or province for this city'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'City'
   ,@level2type = N'COLUMN'
   ,@level2name = N'StateProvinceId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Formal name of the city'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'City'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CityName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'City that are part of any address (including geographic location)'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'City';
GO


/**********************************************************************************************************************
** Create AddressType
**********************************************************************************************************************/

CREATE TABLE Application.AddressType (
    AddressTypeId     INT          NOT NULL
   ,AddressTypeName   NVARCHAR(50) NOT NULL
   ,RowUpdatePersonId INT          NOT NULL
   ,RowUpdateTime     DATETIME2(7) NOT NULL
   ,RowCreateTime     DATETIME2(7) NOT NULL
   ,CONSTRAINT AddressType_AddressTypeId PRIMARY KEY CLUSTERED (AddressTypeId ASC)
   ,CONSTRAINT AddressType_AddressTypeName_Unique UNIQUE (AddressTypeName)
   ,INDEX AddressType_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

ALTER TABLE Application.AddressType WITH CHECK
ADD
    CONSTRAINT AddressType_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Application.AddressType WITH CHECK
--ADD
--    CONSTRAINT AddressType_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Application.AddressType WITH CHECK
ADD
    CONSTRAINT AddressType_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Application.AddressType WITH CHECK
ADD
    CONSTRAINT AddressType_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
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
   ,@value = N'Primary key (clustered) constraint'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'AddressType'
   ,@level2type = N'CONSTRAINT'
   ,@level2name = N'AddressType_AddressTypeId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Types of addresses stored in the Address table. '
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'AddressType';
GO

INSERT INTO Application.AddressType (AddressTypeId, AddressTypeName, RowUpdatePersonId)
VALUES
     (1, N'Main', 1)
    ,(2, N'Billing', 1)
    ,(3, N'Remit', 1)
    ,(4, N'Home', 1)
    ,(5, N'Shipping', 1)
    ,(6, N'Archive', 1);

/**********************************************************************************************************************
** Create EmailType
**********************************************************************************************************************/

CREATE TABLE Application.EmailType (
    EmailTypeId       INT          NOT NULL
   ,EmailTypeName     NVARCHAR(50) NOT NULL
   ,RowUpdatePersonId INT          NOT NULL
   ,RowUpdateTime     DATETIME2(7) NOT NULL
   ,RowCreateTime     DATETIME2(7) NOT NULL
   ,CONSTRAINT EmailType_EmailTypeId PRIMARY KEY CLUSTERED (EmailTypeId ASC)
   ,CONSTRAINT EmailType_EmailTypeName_Unique UNIQUE (EmailTypeName)
   ,INDEX EmailType_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

ALTER TABLE Application.EmailType WITH CHECK
ADD
    CONSTRAINT EmailType_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Application.EmailType WITH CHECK
--ADD
--    CONSTRAINT EmailType_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Application.EmailType WITH CHECK
ADD
    CONSTRAINT EmailType_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Application.EmailType WITH CHECK
ADD
    CONSTRAINT EmailType_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
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

INSERT INTO Application.EmailType (EmailTypeId, EmailTypeName, RowUpdatePersonId)
VALUES
     (1, N'Home', 1)
    ,(2, N'Work', 1);

/**********************************************************************************************************************
** Create Address
**********************************************************************************************************************/

CREATE TABLE Application.Address (
    AddressId         INT           IDENTITY(1, 1) NOT NULL
   ,Line1             NVARCHAR(100) NULL
   ,Line2             NVARCHAR(100) NULL
   ,CityId            INT           NULL
   ,PostalCode        NVARCHAR(12)  NULL
   ,RowUpdatePersonId INT           NOT NULL
   ,RowUpdateTime     DATETIME2(7)  NOT NULL
   ,RowCreateTime     DATETIME2(7)  NOT NULL
   ,CONSTRAINT Address_AddressId PRIMARY KEY CLUSTERED (AddressId ASC)
   ,INDEX Address_CityId NONCLUSTERED (CityId ASC)
   ,INDEX Address_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

--TODO: ??? Add https://docs.microsoft.com/en-us/sql/t-sql/spatial-geography/spatial-types-geography?redirectedfrom=MSDN&view=sql-server-ver15


ALTER TABLE Application.Address WITH CHECK
ADD
    CONSTRAINT Address_City FOREIGN KEY (CityId) REFERENCES Application.City (CityId);
GO

ALTER TABLE Application.Address WITH CHECK
ADD
    CONSTRAINT Address_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Application.Address WITH CHECK
--ADD
--    CONSTRAINT Address_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Application.Address WITH CHECK
ADD
    CONSTRAINT Address_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Application.Address WITH CHECK
ADD
    CONSTRAINT Address_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Foreign key constraint referencing city.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Address'
   ,@level2type = N'CONSTRAINT'
   ,@level2name = N'Address_City';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description'
   ,@value = N'Foreign key to city.'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Address'
   ,@level2type = N'COLUMN'
   ,@level2name = N'CityId';
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
   ,@value = N'Primary key (clustered) constraint'
   ,@level0type = N'SCHEMA'
   ,@level0name = N'Application'
   ,@level1type = N'TABLE'
   ,@level1name = N'Address'
   ,@level2type = N'CONSTRAINT'
   ,@level2name = N'Address_AddressId';
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
    PersonEmailId     INT           IDENTITY(1, 1) NOT NULL
   ,PersonId          INT           NOT NULL
   ,EmailTypeId       INT           NOT NULL
   ,EmailAddress      NVARCHAR(254) NULL
   ,RowUpdatePersonId INT           NOT NULL
   ,RowUpdateTime     DATETIME2(7)  NOT NULL
   ,RowCreateTime     DATETIME2(7)  NOT NULL
   ,CONSTRAINT PersonEmail_PersonEmailId PRIMARY KEY CLUSTERED (PersonEmailId ASC)
   ,CONSTRAINT PersonEmail_PersonId_EmailId_EmailTypeId UNIQUE NONCLUSTERED (PersonId ASC, EmailTypeId ASC, EmailAddress ASC)
   ,INDEX PersonEmail_EmailTypeId NONCLUSTERED (EmailTypeId ASC)
   ,INDEX PersonEmail_PersonId NONCLUSTERED (PersonId ASC)
   ,INDEX PersonEmail_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

ALTER TABLE Application.PersonEmail WITH CHECK
ADD
    CONSTRAINT PersonEmail_Person FOREIGN KEY (PersonId) REFERENCES Application.Person (PersonId);
GO

ALTER TABLE Application.PersonEmail WITH CHECK
ADD
    CONSTRAINT PersonEmail_EmailType FOREIGN KEY (EmailTypeId) REFERENCES Application.EmailType (EmailTypeId);
GO

--ALTER TABLE Application.PersonEmail
--ADD
--    CONSTRAINT PersonEmail_EmailTypeId_Unknown DEFAULT ((-1)) FOR EmailTypeId;
--GO

ALTER TABLE Application.PersonEmail WITH CHECK
ADD
    CONSTRAINT PersonEmail_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Application.PersonEmail WITH CHECK
--ADD
--    CONSTRAINT PersonEmail_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Application.PersonEmail WITH CHECK
ADD
    CONSTRAINT PersonEmail_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Application.PersonEmail WITH CHECK
ADD
    CONSTRAINT PersonEmail_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
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
    ResidenceId       INT          IDENTITY(1, 1) NOT NULL
   ,PersonId          INT          NOT NULL
   ,AddressId         INT          NOT NULL
   ,AddressTypeId     INT          NOT NULL
   ,RowUpdatePersonId INT          NOT NULL
   ,RowUpdateTime     DATETIME2(7) NOT NULL
   ,RowCreateTime     DATETIME2(7) NOT NULL
   ,CONSTRAINT Residence_ResidenceId PRIMARY KEY CLUSTERED (ResidenceId ASC)
   ,CONSTRAINT Residence_PersonId_AddressId_AddressTypeId UNIQUE NONCLUSTERED (PersonId ASC, AddressId ASC, AddressTypeId ASC)
   ,INDEX Residence_PersonId NONCLUSTERED (PersonId ASC)
   ,INDEX Residence_AddressId NONCLUSTERED (AddressId ASC)
   ,INDEX Residence_AddressTypeId NONCLUSTERED (AddressTypeId ASC)
   ,INDEX Residence_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

ALTER TABLE Application.Residence WITH CHECK
ADD
    CONSTRAINT Residence_Person FOREIGN KEY (PersonId) REFERENCES Application.Person (PersonId);
GO

ALTER TABLE Application.Residence WITH CHECK
ADD
    CONSTRAINT Residence_Address FOREIGN KEY (AddressId) REFERENCES Application.Address (AddressId);
GO

ALTER TABLE Application.Residence WITH CHECK
ADD
    CONSTRAINT Residence_AddressType FOREIGN KEY (AddressTypeId) REFERENCES Application.AddressType (AddressTypeId);
GO

--ALTER TABLE Application.Residence
--ADD
--    CONSTRAINT Residence_AddressTypeId_Unknown DEFAULT ((-1)) FOR AddressTypeId;
--GO

ALTER TABLE Application.Residence WITH CHECK
ADD
    CONSTRAINT Residence_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Application.Residence WITH CHECK
--ADD
--    CONSTRAINT Residence_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Application.Residence WITH CHECK
ADD
    CONSTRAINT Residence_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Application.Residence WITH CHECK
ADD
    CONSTRAINT Residence_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
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
    OrganizationId    INT            IDENTITY(1, 1) NOT NULL
   ,OrganizationName  NVARCHAR(100)  NULL
   ,WebsiteURL        NVARCHAR(2083) NULL
   ,RowUpdatePersonId INT            NOT NULL
   ,RowUpdateTime     DATETIME2(7)   NOT NULL
   ,RowCreateTime     DATETIME2(7)   NOT NULL
   ,CONSTRAINT Organization_OrganizationId PRIMARY KEY CLUSTERED (OrganizationId ASC)
   ,INDEX Organization_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

ALTER TABLE Application.Organization WITH CHECK
ADD
    CONSTRAINT Organization_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Application.Organization WITH CHECK
--ADD
--    CONSTRAINT Organization_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Application.Organization WITH CHECK
ADD
    CONSTRAINT Organization_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Application.Organization WITH CHECK
ADD
    CONSTRAINT Organization_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
GO

/**********************************************************************************************************************
** Create Customer
**********************************************************************************************************************/
CREATE TABLE Sales.Customer (
    CustomerId                 INT            IDENTITY(1, 1) NOT NULL
   ,OrganizationId             INT            NOT NULL
   ,CreditLimit                DECIMAL(18, 2) NULL
   ,PaymentDays                INT            NOT NULL
   ,IsOnCreditHoldFlag         BIT            NOT NULL
   ,AccountOpenedDate          DATE           NOT NULL
   ,StandardDiscountPercentage DECIMAL(18, 3) NOT NULL
   ,RowUpdatePersonId          INT            NOT NULL
   ,RowUpdateTime              DATETIME2(7)   NOT NULL
   ,RowCreateTime              DATETIME2(7)   NOT NULL
   ,CONSTRAINT Customer_CustomerId PRIMARY KEY CLUSTERED (CustomerId ASC)
   ,INDEX Customer_OrganizationId NONCLUSTERED (OrganizationId ASC)
   ,INDEX Customer_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

--TODO: Add CONSTRAINT for PaymentDays
--TODO: Add CONSTRAINT for CreditLimit
--TODO: Add CONSTRAINT for StandardDiscountPercentage

ALTER TABLE Sales.Customer WITH CHECK
ADD
    CONSTRAINT Customer_Organization FOREIGN KEY (OrganizationId) REFERENCES Application.Organization (OrganizationId);
GO

ALTER TABLE Sales.Customer WITH CHECK
ADD
    CONSTRAINT Customer_Person FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Sales.Customer WITH CHECK
--ADD
--    CONSTRAINT Customer_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Sales.Customer WITH CHECK
ADD
    CONSTRAINT Customer_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Sales.Customer WITH CHECK
ADD
    CONSTRAINT Customer_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
GO

/**********************************************************************************************************************
** Create Supplier
**********************************************************************************************************************/

CREATE TABLE Purchasing.Supplier (
    SupplierId        INT           IDENTITY(1, 1) NOT NULL
   ,OrganizationId    INT           NOT NULL
   ,PaymentDays       INT           NOT NULL
   ,InternalComments  NVARCHAR(MAX) NULL
   ,RowUpdatePersonId INT           NOT NULL
   ,RowUpdateTime     DATETIME2(7)  NOT NULL
   ,RowCreateTime     DATETIME2(7)  NOT NULL
   ,CONSTRAINT Supplier_SupplierId PRIMARY KEY CLUSTERED (SupplierId ASC)
   ,INDEX Purchasing_OrganizationId NONCLUSTERED (OrganizationId ASC)
   ,INDEX Supplier_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

--TODO: Add CONSTRAINT for PaymentDays

ALTER TABLE Purchasing.Supplier WITH CHECK
ADD
    CONSTRAINT Customer_Organization FOREIGN KEY (OrganizationId) REFERENCES Application.Organization (OrganizationId);
GO

ALTER TABLE Purchasing.Supplier WITH CHECK
ADD
    CONSTRAINT Customer_Person FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Purchasing.Supplier WITH CHECK
--ADD
--    CONSTRAINT Supplier_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Purchasing.Supplier WITH CHECK
ADD
    CONSTRAINT Customer_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Purchasing.Supplier WITH CHECK
ADD
    CONSTRAINT Customer_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
GO

/**********************************************************************************************************************
** Create Location
**********************************************************************************************************************/

CREATE TABLE Application.Location (
    LocationId          INT           IDENTITY(1, 1) NOT NULL
   ,OrganizationId      INT           NOT NULL
   ,AddressId           INT           NOT NULL
   ,AddressTypeId       INT           NOT NULL
   ,LocationName        NVARCHAR(100) NULL
   ,DeliverInstructions NVARCHAR(MAX) NULL
   ,IsDeliverOnSunday   BIT           NOT NULL
   ,IsDeliverOnSaturday BIT           NOT NULL
   ,PhoneNumber         NVARCHAR(50)  NULL
   ,RowUpdatePersonId   INT           NOT NULL
   ,RowUpdateTime       DATETIME2(7)  NOT NULL
   ,RowCreateTime       DATETIME2(7)  NOT NULL
   ,CONSTRAINT Location_LocationId PRIMARY KEY CLUSTERED (LocationId ASC)
   ,CONSTRAINT Location_OrganizationId_AddressId_AddressTypeId UNIQUE NONCLUSTERED (OrganizationId ASC, AddressId ASC, AddressTypeId ASC)
   ,INDEX Location_OrganizationId NONCLUSTERED (OrganizationId ASC)
   ,INDEX Location_AddressId NONCLUSTERED (AddressId ASC)
   ,INDEX Location_AddressTypeId NONCLUSTERED (AddressTypeId ASC)
   ,INDEX Location_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

ALTER TABLE Application.Location WITH CHECK
ADD
    CONSTRAINT Location_Organization FOREIGN KEY (OrganizationId) REFERENCES Application.Organization (OrganizationId);
GO

ALTER TABLE Application.Location WITH CHECK
ADD
    CONSTRAINT Location_Address FOREIGN KEY (AddressId) REFERENCES Application.Address (AddressId);
GO

ALTER TABLE Application.Location WITH CHECK
ADD
    CONSTRAINT Location_AddressType FOREIGN KEY (AddressTypeId) REFERENCES Application.AddressType (AddressTypeId);
GO

--ALTER TABLE Application.Location
--ADD
--    CONSTRAINT Location_AddressTypeId_Unknown DEFAULT ((-1)) FOR AddressTypeId;
--GO

ALTER TABLE Application.Location WITH CHECK
ADD
    CONSTRAINT Location_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Application.Location WITH CHECK
--ADD
--    CONSTRAINT Location_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Application.Location WITH CHECK
ADD
    CONSTRAINT Location_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Application.Location WITH CHECK
ADD
    CONSTRAINT Location_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
GO

/**********************************************************************************************************************
** Create PhoneType
**********************************************************************************************************************/

CREATE TABLE Application.PhoneType (
    PhoneTypeId       INT          NOT NULL
   ,PhoneTypeName     NVARCHAR(20) NOT NULL
   ,RowUpdatePersonId INT          NOT NULL
   ,RowUpdateTime     DATETIME2(7) NOT NULL
   ,RowCreateTime     DATETIME2(7) NOT NULL
   ,CONSTRAINT PhoneType_PhoneTypeId PRIMARY KEY CLUSTERED (PhoneTypeId ASC)
   ,CONSTRAINT PhoneType_PhoneTypeName_Unique UNIQUE (PhoneTypeName)
   ,INDEX PhoneType_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

ALTER TABLE Application.PhoneType WITH CHECK
ADD
    CONSTRAINT PhoneType_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Application.PhoneType WITH CHECK
--ADD
--    CONSTRAINT PhoneType_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Application.PhoneType WITH CHECK
ADD
    CONSTRAINT PhoneType_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Application.PhoneType WITH CHECK
ADD
    CONSTRAINT PhoneType_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
GO

INSERT INTO Application.PhoneType (PhoneTypeId, PhoneTypeName, RowUpdatePersonId)
VALUES
     (1, N'Mobile', 1)
    ,(2, N'Home', 1)
    ,(3, N'Work', 1);

/**********************************************************************************************************************
** Create PersonPhone
**********************************************************************************************************************/

CREATE TABLE Application.PersonPhone (
    PersonPhoneId     INT          NOT NULL
   ,PersonId          INT          NOT NULL
   ,PhoneTypeId       INT          NOT NULL
   ,PhoneNumber       NVARCHAR(50) NULL
   ,RowUpdatePersonId INT          NOT NULL
   ,RowUpdateTime     DATETIME2(7) NOT NULL
   ,RowCreateTime     DATETIME2(7) NOT NULL
   ,CONSTRAINT PersonPhone_PersonPhoneId PRIMARY KEY CLUSTERED (PersonPhoneId ASC)
   ,CONSTRAINT PersonPhone_PersonId_PhoneTypeId_PhoneNumber UNIQUE (PersonId ASC, PhoneTypeId ASC, PhoneNumber ASC)
   ,INDEX PersonPhone_PersonId NONCLUSTERED (PersonId ASC)
   ,INDEX PersonPhone_PhoneTypeId NONCLUSTERED (PhoneTypeId ASC)
   ,INDEX PersonPhone_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

ALTER TABLE Application.PersonPhone WITH CHECK
ADD
    CONSTRAINT PersonPhone_Person FOREIGN KEY (PersonId) REFERENCES Application.Person (PersonId);
GO

ALTER TABLE Application.PersonPhone WITH CHECK
ADD
    CONSTRAINT PersonPhone_PhoneType FOREIGN KEY (PhoneTypeId) REFERENCES Application.PhoneType (PhoneTypeId);
GO

--ALTER TABLE Application.PersonPhone
--ADD
--    CONSTRAINT PersonPhone_PhoneTypeId_Unknown DEFAULT ((-1)) FOR PhoneTypeId;
--GO

ALTER TABLE Application.PersonPhone WITH CHECK
ADD
    CONSTRAINT PersonPhone_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Application.PersonPhone WITH CHECK
--ADD
--    CONSTRAINT PersonPhone_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Application.PersonPhone WITH CHECK
ADD
    CONSTRAINT PersonPhone_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Application.PersonPhone WITH CHECK
ADD
    CONSTRAINT PersonPhone_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
GO

/**********************************************************************************************************************
** Create LocationPhone
**********************************************************************************************************************/

CREATE TABLE Application.LocationPhone (
    LocationPhoneId   INT          IDENTITY(1, 1) NOT NULL
   ,LocationId        INT          NOT NULL
   ,PhoneTypeId       INT          NOT NULL
   ,PhoneNumber       NVARCHAR(50) NOT NULL
   ,RowUpdatePersonId INT          NOT NULL
   ,RowUpdateTime     DATETIME2(7) NOT NULL
   ,RowCreateTime     DATETIME2(7) NOT NULL
   ,CONSTRAINT LocationPhone_LocationPhoneId PRIMARY KEY CLUSTERED (LocationPhoneId ASC)
   ,CONSTRAINT LocationPhone_LocationId_PhoneTypeId_PhoneNumber UNIQUE (LocationId ASC, PhoneTypeId ASC, PhoneNumber ASC)
   ,INDEX LocationPhone_LocationId NONCLUSTERED (LocationId ASC)
   ,INDEX LocationPhone_PhoneTypeId NONCLUSTERED (PhoneTypeId ASC)
   ,INDEX LocationPhone_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

ALTER TABLE Application.LocationPhone WITH CHECK
ADD
    CONSTRAINT LocationPhone_Location FOREIGN KEY (LocationId) REFERENCES Application.Location (LocationId);
GO

ALTER TABLE Application.LocationPhone WITH CHECK
ADD
    CONSTRAINT LocationPhone_PhoneType FOREIGN KEY (PhoneTypeId) REFERENCES Application.PhoneType (PhoneTypeId);
GO

--ALTER TABLE Application.LocationPhone
--ADD
--    CONSTRAINT LocationPhone_PhoneTypeId_Unknown DEFAULT ((-1)) FOR PhoneTypeId;
--GO

ALTER TABLE Application.LocationPhone WITH CHECK
ADD
    CONSTRAINT LocationPhone_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Application.LocationPhone WITH CHECK
--ADD
--    CONSTRAINT LocationPhoneRowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Application.LocationPhone WITH CHECK
ADD
    CONSTRAINT LocationPhone_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Application.LocationPhone WITH CHECK
ADD
    CONSTRAINT LocationPhone_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
GO

/**********************************************************************************************************************
** Create DeliveryType
**********************************************************************************************************************/

CREATE TABLE Application.DeliveryType (
    DeliveryTypeId    INT          NOT NULL
   ,DeliveryTypeName  NVARCHAR(50) NOT NULL
   ,RowUpdatePersonId INT          NOT NULL
   ,RowUpdateTime     DATETIME2(7) NOT NULL
   ,RowCreateTime     DATETIME2(7) NOT NULL
   ,CONSTRAINT DeliveryType_DeliveryTypeId PRIMARY KEY CLUSTERED (DeliveryTypeId ASC)
   ,CONSTRAINT DeliveryType_DeliveryTypeName_Unique UNIQUE (DeliveryTypeName)
   ,INDEX DeliveryType_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
);
GO

ALTER TABLE Application.DeliveryType WITH CHECK
ADD
    CONSTRAINT DeliveryType_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Application.DeliveryType WITH CHECK
--ADD
--    CONSTRAINT DeliveryType_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Application.DeliveryType WITH CHECK
ADD
    CONSTRAINT DeliveryType_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Application.DeliveryType WITH CHECK
ADD
    CONSTRAINT DeliveryType_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
GO

INSERT INTO Application.DeliveryType (DeliveryTypeId, DeliveryTypeName, RowUpdatePersonId)
VALUES
     (1, N'Post', 1)
    ,(2, N'Courier', 1)
    ,(3, N'Delivery Van', 1)
    ,(4, N'Customer Collect', 1)
    ,(5, N'Chilled Van', 1)
    ,(6, N'Customer Courier to Collect', 1)
    ,(7, N'Road Freight', 1)
    ,(8, N'Air Freight', 1);

/**********************************************************************************************************************
** Create PurchaseOrder
**********************************************************************************************************************/

CREATE TABLE Purchasing.PurchaseOrder (
    PurchaseOrderId      INT           IDENTITY(1, 1) NOT NULL
   ,SupplierId           INT           NOT NULL
   ,OrderDate            DATE          NOT NULL
   ,DeliveryTypeId       INT           NOT NULL
   ,ContactPersonId      INT           NOT NULL
   ,ExpectedDeliveryDate DATE          NULL
   ,SupplierReference    NVARCHAR(20)  NULL
   ,IsOrderFinalizedFlag BIT           NOT NULL
   ,Comments             NVARCHAR(MAX) NULL
   ,InternalComments     NVARCHAR(MAX) NULL
   ,RowUpdatePersonId    INT           NOT NULL
   ,RowUpdateTime        DATETIME2(7)  NOT NULL
   ,RowCreateTime        DATETIME2(7)  NOT NULL
   ,CONSTRAINT PurchaseOrder_PurchaseOrderId PRIMARY KEY CLUSTERED (PurchaseOrderId ASC)
   ,INDEX PurchaseOrder_SupplierId NONCLUSTERED (SupplierId ASC)
   ,INDEX PurchaseOrder_RowUpdatePerson NONCLUSTERED (RowUpdatePersonId ASC)
   ,INDEX PurchaseOrder_DeliveryTypeId NONCLUSTERED (DeliveryTypeId ASC)
   ,INDEX PurchaseOrder_ContactPersonId NONCLUSTERED (ContactPersonId ASC)
);
GO

--ALTER TABLE Purchasing.PurchaseOrder WITH CHECK
--ADD
--    CONSTRAINT PurchaseOrder_ContactPersonId_Default DEFAULT ((-1)) FOR ContactPersonId;
--GO

--ALTER TABLE Purchasing.PurchaseOrder WITH CHECK
--ADD
--    CONSTRAINT PurchaseOrder_DeliveryTypeId_Default DEFAULT ((-1)) FOR DeliveryTypeId;
--GO

ALTER TABLE Purchasing.PurchaseOrder WITH CHECK
ADD
    CONSTRAINT PurchaseOrder_IsOrderFinalizedFlag_Default DEFAULT ((0)) FOR IsOrderFinalizedFlag;
GO

ALTER TABLE Purchasing.PurchaseOrder WITH CHECK
ADD
    CONSTRAINT PurchaseOrder_RowUpdatePerson FOREIGN KEY (RowUpdatePersonId) REFERENCES Application.Person (PersonId);
GO

--ALTER TABLE Purchasing.PurchaseOrder WITH CHECK
--ADD
--    CONSTRAINT PurchaseOrder_RowUpdatePersonId_Default DEFAULT ((-1)) FOR RowUpdatePersonId;
--GO

ALTER TABLE Purchasing.PurchaseOrder WITH CHECK
ADD
    CONSTRAINT PurchaseOrder_RowUpdateTime_Default DEFAULT (SYSDATETIME()) FOR RowUpdateTime;
GO

ALTER TABLE Purchasing.PurchaseOrder WITH CHECK
ADD
    CONSTRAINT PurchaseOrder_RowCreateTime_Default DEFAULT (SYSDATETIME()) FOR RowCreateTime;
GO

ALTER TABLE Purchasing.PurchaseOrder WITH CHECK
ADD
    CONSTRAINT PurchaseOrder_ContactPerson FOREIGN KEY (ContactPersonId) REFERENCES Application.Person (PersonId);
GO

ALTER TABLE Purchasing.PurchaseOrder WITH CHECK
ADD
    CONSTRAINT PurchaseOrder_DeliveryType FOREIGN KEY (DeliveryTypeId) REFERENCES Application.DeliveryType (DeliveryTypeId);
GO

ALTER TABLE Purchasing.PurchaseOrder WITH CHECK
ADD
    CONSTRAINT PurchaseOrder_Supplier FOREIGN KEY (SupplierId) REFERENCES Purchasing.Supplier (SupplierId);
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

--TODO: Add PurchaseOrderLines and other tables in Purchasing schema from WideWorldImporters
--TODO: HR tables from AdventureWorks2019
--TODO: Document table that links has a URI to the document on the file system, HR can link to resumes
--TODO: Linking table for Customer, Supplier
--TODO: Add Production schema tables from AdventureWorks2019
--TODO: Add Warehouse tables from WideWorldImporters
--TODO: Add Sales tables from WideWorldImporters
--TODO: Sales Pipeline, leads, ...
--TODO: Auth, roles, membership
