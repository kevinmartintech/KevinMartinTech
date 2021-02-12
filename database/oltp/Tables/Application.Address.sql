CREATE TABLE [Application].[Address]
(
[AddressId] [int] NOT NULL IDENTITY(1, 1),
[Line1] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Line2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CityId] [int] NULL,
[PostalCode] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowUpdatePersonId] [int] NOT NULL CONSTRAINT [Address_RowUpdatePersonId_Default] DEFAULT ((-1)),
[RowUpdateTime] [datetime2] NOT NULL CONSTRAINT [Address_RowUpdateTime_Default] DEFAULT (sysdatetime()),
[RowCreateTime] [datetime2] NOT NULL CONSTRAINT [Address_RowCreateTime_Default] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[Address] ADD CONSTRAINT [Address_AddressId] PRIMARY KEY CLUSTERED  ([AddressId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Address_CityId] ON [Application].[Address] ([CityId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Address_RowUpdatePerson] ON [Application].[Address] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Address] ADD CONSTRAINT [Address_City] FOREIGN KEY ([CityId]) REFERENCES [Application].[City] ([CityId])
GO
ALTER TABLE [Application].[Address] ADD CONSTRAINT [Address_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Street address information for customers, vendors, people, locations, ...', 'SCHEMA', N'Application', 'TABLE', N'Address', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for address records.', 'SCHEMA', N'Application', 'TABLE', N'Address', 'COLUMN', N'AddressId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key to city.', 'SCHEMA', N'Application', 'TABLE', N'Address', 'COLUMN', N'CityId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'First street address line.', 'SCHEMA', N'Application', 'TABLE', N'Address', 'COLUMN', N'Line1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Second street address line.', 'SCHEMA', N'Application', 'TABLE', N'Address', 'COLUMN', N'Line2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Postal code for the street address.', 'SCHEMA', N'Application', 'TABLE', N'Address', 'COLUMN', N'PostalCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Application', 'TABLE', N'Address', 'CONSTRAINT', N'Address_AddressId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing city.', 'SCHEMA', N'Application', 'TABLE', N'Address', 'CONSTRAINT', N'Address_City'
GO
