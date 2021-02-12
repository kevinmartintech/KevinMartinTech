CREATE TABLE [Application].[CountryRegion]
(
[CountryRegionId] [int] NOT NULL,
[CountryName] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FormalName] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsoAlpha3Code] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsoNumericCode] [int] NULL,
[CountryType] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Continent] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Region] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Subregion] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL CONSTRAINT [CountryRegion_RowUpdatePersonId_Default] DEFAULT ((-1)),
[RowUpdateTime] [datetime2] NOT NULL CONSTRAINT [CountryRegion_RowUpdateTime_Default] DEFAULT (sysdatetime()),
[RowCreateTime] [datetime2] NOT NULL CONSTRAINT [CountryRegion_RowCreateTime_Default] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[CountryRegion] ADD CONSTRAINT [CountryRegion_CountryRegionId] PRIMARY KEY CLUSTERED  ([CountryRegionId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[CountryRegion] ADD CONSTRAINT [CountryRegion_CountryName] UNIQUE NONCLUSTERED  ([CountryName]) ON [PRIMARY]
GO
ALTER TABLE [Application].[CountryRegion] ADD CONSTRAINT [CountryRegion_FormalName] UNIQUE NONCLUSTERED  ([FormalName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CountryRegion_RowUpdatePerson] ON [Application].[CountryRegion] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[CountryRegion] ADD CONSTRAINT [CountryRegion_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'CountryRegion that contain the states or provinces (including geographic boundaries)', 'SCHEMA', N'Application', 'TABLE', N'CountryRegion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the continent', 'SCHEMA', N'Application', 'TABLE', N'CountryRegion', 'COLUMN', N'Continent'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the country', 'SCHEMA', N'Application', 'TABLE', N'CountryRegion', 'COLUMN', N'CountryName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for country or region records.', 'SCHEMA', N'Application', 'TABLE', N'CountryRegion', 'COLUMN', N'CountryRegionId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of country or administrative region', 'SCHEMA', N'Application', 'TABLE', N'CountryRegion', 'COLUMN', N'CountryType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Full formal name of the country as agreed by United Nations', 'SCHEMA', N'Application', 'TABLE', N'CountryRegion', 'COLUMN', N'FormalName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'3 letter alphabetic code assigned to the country by ISO', 'SCHEMA', N'Application', 'TABLE', N'CountryRegion', 'COLUMN', N'IsoAlpha3Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numeric code assigned to the country by ISO', 'SCHEMA', N'Application', 'TABLE', N'CountryRegion', 'COLUMN', N'IsoNumericCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the region', 'SCHEMA', N'Application', 'TABLE', N'CountryRegion', 'COLUMN', N'Region'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the subregion', 'SCHEMA', N'Application', 'TABLE', N'CountryRegion', 'COLUMN', N'Subregion'
GO
