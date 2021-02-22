CREATE TABLE [Application].[CityTown]
(
[CityTownId] [int] NOT NULL,
[StateProvinceId] [int] NOT NULL,
[CityTownName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_CityTown_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_CityTown_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[CityTown] ADD CONSTRAINT [Application_CityTown_CityTownId] PRIMARY KEY CLUSTERED  ([CityTownId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_CityTown_RowUpdatePersonId] ON [Application].[CityTown] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[CityTown] ADD CONSTRAINT [Application_CityTown_StateProvinceId_CityName] UNIQUE NONCLUSTERED  ([StateProvinceId], [CityTownName]) ON [PRIMARY]
GO
ALTER TABLE [Application].[CityTown] ADD CONSTRAINT [Application_CityTown_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
ALTER TABLE [Application].[CityTown] ADD CONSTRAINT [Application_CityTown_Application_StateProvince] FOREIGN KEY ([StateProvinceId]) REFERENCES [Application].[StateProvince] ([StateProvinceId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'City or town that are part of any address (including geographic location)', 'SCHEMA', N'Application', 'TABLE', N'CityTown', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for city or town records.', 'SCHEMA', N'Application', 'TABLE', N'CityTown', 'COLUMN', N'CityTownId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Formal name of the city or town', 'SCHEMA', N'Application', 'TABLE', N'CityTown', 'COLUMN', N'CityTownName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State or province for this city or town', 'SCHEMA', N'Application', 'TABLE', N'CityTown', 'COLUMN', N'StateProvinceId'
GO
