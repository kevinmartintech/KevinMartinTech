CREATE TABLE [Application].[City]
(
[CityId] [int] NOT NULL,
[StateProvinceId] [int] NOT NULL,
[CityName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL CONSTRAINT [City_RowUpdatePersonId_Default] DEFAULT ((-1)),
[RowUpdateTime] [datetime2] NOT NULL CONSTRAINT [City_RowUpdateTime_Default] DEFAULT (sysdatetime()),
[RowCreateTime] [datetime2] NOT NULL CONSTRAINT [City_RowCreateTime_Default] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[City] ADD CONSTRAINT [City_CityId] PRIMARY KEY CLUSTERED  ([CityId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [City_RowUpdatePerson] ON [Application].[City] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[City] ADD CONSTRAINT [City_StateProvinceId_CityName] UNIQUE NONCLUSTERED  ([StateProvinceId], [CityName]) ON [PRIMARY]
GO
ALTER TABLE [Application].[City] ADD CONSTRAINT [City_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
ALTER TABLE [Application].[City] ADD CONSTRAINT [City_StateProvince] FOREIGN KEY ([StateProvinceId]) REFERENCES [Application].[StateProvince] ([StateProvinceId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'City that are part of any address (including geographic location)', 'SCHEMA', N'Application', 'TABLE', N'City', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for city records.', 'SCHEMA', N'Application', 'TABLE', N'City', 'COLUMN', N'CityId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Formal name of the city', 'SCHEMA', N'Application', 'TABLE', N'City', 'COLUMN', N'CityName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State or province for this city', 'SCHEMA', N'Application', 'TABLE', N'City', 'COLUMN', N'StateProvinceId'
GO
