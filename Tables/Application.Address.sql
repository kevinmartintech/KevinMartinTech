CREATE TABLE [Application].[Address]
(
[AddressId] [int] NOT NULL IDENTITY(1, 1),
[Line1] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Line2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CityTownId] [int] NULL,
[PostalCode] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_Address_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_Address_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[Address] ADD CONSTRAINT [Application_Address_AddressId] PRIMARY KEY CLUSTERED  ([AddressId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_Address_CityTownId] ON [Application].[Address] ([CityTownId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_Address_RowUpdatePersonId] ON [Application].[Address] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Address] ADD CONSTRAINT [Application_Address_Application_CityTown] FOREIGN KEY ([CityTownId]) REFERENCES [Application].[CityTown] ([CityTownId])
GO
ALTER TABLE [Application].[Address] ADD CONSTRAINT [Application_Address_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Street address information for customers, vendors, people, locations, ...', 'SCHEMA', N'Application', 'TABLE', N'Address', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for address records.', 'SCHEMA', N'Application', 'TABLE', N'Address', 'COLUMN', N'AddressId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key to city.', 'SCHEMA', N'Application', 'TABLE', N'Address', 'COLUMN', N'CityTownId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'First street address line.', 'SCHEMA', N'Application', 'TABLE', N'Address', 'COLUMN', N'Line1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Second street address line.', 'SCHEMA', N'Application', 'TABLE', N'Address', 'COLUMN', N'Line2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Postal code for the street address.', 'SCHEMA', N'Application', 'TABLE', N'Address', 'COLUMN', N'PostalCode'
GO
