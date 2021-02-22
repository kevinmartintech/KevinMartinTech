CREATE TABLE [Application].[Location]
(
[LocationId] [int] NOT NULL IDENTITY(1, 1),
[OrganizationId] [int] NOT NULL,
[AddressId] [int] NOT NULL,
[AddressTypeId] [tinyint] NOT NULL,
[LocationName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliverInstructions] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDeliverOnSunday] [bit] NOT NULL,
[IsDeliverOnSaturday] [bit] NOT NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_Location_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_Location_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[Location] ADD CONSTRAINT [Application_Location_LocationId] PRIMARY KEY CLUSTERED  ([LocationId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_Location_AddressId] ON [Application].[Location] ([AddressId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_Location_AddressTypeId] ON [Application].[Location] ([AddressTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_Location_OrganizationId] ON [Application].[Location] ([OrganizationId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Location] ADD CONSTRAINT [Application_Location_OrganizationId_AddressId_AddressTypeId] UNIQUE NONCLUSTERED  ([OrganizationId], [AddressId], [AddressTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_Location_RowUpdatePersonId] ON [Application].[Location] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Location] ADD CONSTRAINT [Application_Location_Application_Address] FOREIGN KEY ([AddressId]) REFERENCES [Application].[Address] ([AddressId])
GO
ALTER TABLE [Application].[Location] ADD CONSTRAINT [Application_Location_Application_AddressType] FOREIGN KEY ([AddressTypeId]) REFERENCES [Application].[AddressType] ([AddressTypeId])
GO
ALTER TABLE [Application].[Location] ADD CONSTRAINT [Application_Location_Application_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [Application].[Organization] ([OrganizationId])
GO
ALTER TABLE [Application].[Location] ADD CONSTRAINT [Application_Location_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
