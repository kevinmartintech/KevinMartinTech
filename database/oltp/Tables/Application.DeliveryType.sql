CREATE TABLE [Application].[DeliveryType]
(
[DeliveryTypeId] [tinyint] NOT NULL,
[DeliveryTypeName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_DeliveryType_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_DeliveryType_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[DeliveryType] ADD CONSTRAINT [Application_DeliveryType_DeliveryTypeId] PRIMARY KEY CLUSTERED  ([DeliveryTypeId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[DeliveryType] ADD CONSTRAINT [Application_DeliveryType_DeliveryTypeName_Unique] UNIQUE NONCLUSTERED  ([DeliveryTypeName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_DeliveryType_RowUpdatePersonId] ON [Application].[DeliveryType] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[DeliveryType] ADD CONSTRAINT [Application_DeliveryType_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
