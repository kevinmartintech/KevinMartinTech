CREATE TABLE [Application].[AddressType]
(
[AddressTypeId] [tinyint] NOT NULL,
[AddressTypeName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_AddressType_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_AddressType_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[AddressType] ADD CONSTRAINT [Application_AddressType_AddressTypeId] PRIMARY KEY CLUSTERED  ([AddressTypeId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[AddressType] ADD CONSTRAINT [Application_AddressType_AddressTypeName_Unique] UNIQUE NONCLUSTERED  ([AddressTypeName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_AddressType_RowUpdatePersonId] ON [Application].[AddressType] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[AddressType] ADD CONSTRAINT [Application_AddressType_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Types of addresses stored in the Address table. ', 'SCHEMA', N'Application', 'TABLE', N'AddressType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for address type records.', 'SCHEMA', N'Application', 'TABLE', N'AddressType', 'COLUMN', N'AddressTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address type description. For example, Billing, Home, or Shipping.', 'SCHEMA', N'Application', 'TABLE', N'AddressType', 'COLUMN', N'AddressTypeName'
GO
