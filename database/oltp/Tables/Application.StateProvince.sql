CREATE TABLE [Application].[StateProvince]
(
[StateProvinceId] [int] NOT NULL,
[CountryRegionId] [int] NOT NULL,
[StateProvinceCode] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateProvinceName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_StateProvince_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_StateProvince_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[StateProvince] ADD CONSTRAINT [Application_StateProvince_StateProvinceId] PRIMARY KEY CLUSTERED  ([StateProvinceId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[StateProvince] ADD CONSTRAINT [Application_StateProvince_CountryRegionId_StateProvinceCode_StateProvinceName] UNIQUE NONCLUSTERED  ([CountryRegionId], [StateProvinceCode], [StateProvinceName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_StateProvince_RowUpdatePersonId] ON [Application].[StateProvince] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[StateProvince] ADD CONSTRAINT [Application_StateProvince_StateProvinceName] UNIQUE NONCLUSTERED  ([StateProvinceName]) ON [PRIMARY]
GO
ALTER TABLE [Application].[StateProvince] ADD CONSTRAINT [Application_StateProvince_Application_CountryRegion] FOREIGN KEY ([CountryRegionId]) REFERENCES [Application].[CountryRegion] ([CountryRegionId])
GO
ALTER TABLE [Application].[StateProvince] ADD CONSTRAINT [Application_StateProvince_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'States or provinces that contain City (including geographic location)', 'SCHEMA', N'Application', 'TABLE', N'StateProvince', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Country for this StateProvince', 'SCHEMA', N'Application', 'TABLE', N'StateProvince', 'COLUMN', N'CountryRegionId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Common code for this state or province (such as WA - Washington for the USA)', 'SCHEMA', N'Application', 'TABLE', N'StateProvince', 'COLUMN', N'StateProvinceCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for state or province records.', 'SCHEMA', N'Application', 'TABLE', N'StateProvince', 'COLUMN', N'StateProvinceId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Formal name of the state or province', 'SCHEMA', N'Application', 'TABLE', N'StateProvince', 'COLUMN', N'StateProvinceName'
GO
