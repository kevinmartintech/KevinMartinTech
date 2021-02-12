CREATE TABLE [Application].[Location]
(
[LocationId] [int] NOT NULL IDENTITY(1, 1),
[OrganizationId] [int] NOT NULL,
[AddressId] [int] NOT NULL,
[AddressTypeId] [int] NOT NULL CONSTRAINT [Location_AddressTypeId_Unknown] DEFAULT ((-1)),
[LocationName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliverInstructions] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDeliverOnSunday] [bit] NOT NULL,
[IsDeliverOnSaturday] [bit] NOT NULL,
[PhoneNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowUpdatePersonId] [int] NOT NULL CONSTRAINT [Location_RowUpdatePersonId_Default] DEFAULT ((-1)),
[RowUpdateTime] [datetime2] NOT NULL CONSTRAINT [Location_RowUpdateTime_Default] DEFAULT (sysdatetime()),
[RowCreateTime] [datetime2] NOT NULL CONSTRAINT [Location_RowCreateTime_Default] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[Location] ADD CONSTRAINT [Location_LocationId] PRIMARY KEY CLUSTERED  ([LocationId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Location_AddressId] ON [Application].[Location] ([AddressId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Location_AddressTypeId] ON [Application].[Location] ([AddressTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Location_OrganizationId] ON [Application].[Location] ([OrganizationId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Location] ADD CONSTRAINT [Location_OrganizationId_AddressId_AddressTypeId] UNIQUE NONCLUSTERED  ([OrganizationId], [AddressId], [AddressTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Location_RowUpdatePerson] ON [Application].[Location] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Location] ADD CONSTRAINT [Location_Address] FOREIGN KEY ([AddressId]) REFERENCES [Application].[Address] ([AddressId])
GO
ALTER TABLE [Application].[Location] ADD CONSTRAINT [Location_AddressType] FOREIGN KEY ([AddressTypeId]) REFERENCES [Application].[AddressType] ([AddressTypeId])
GO
ALTER TABLE [Application].[Location] ADD CONSTRAINT [Location_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [Application].[Organization] ([OrganizationId])
GO
ALTER TABLE [Application].[Location] ADD CONSTRAINT [Location_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
