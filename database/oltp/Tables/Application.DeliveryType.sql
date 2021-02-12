CREATE TABLE [Application].[DeliveryType]
(
[DeliveryTypeId] [int] NOT NULL,
[DeliveryTypeName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL CONSTRAINT [DeliveryType_RowUpdatePersonId_Default] DEFAULT ((-1)),
[RowUpdateTime] [datetime2] NOT NULL CONSTRAINT [DeliveryType_RowUpdateTime_Default] DEFAULT (sysdatetime()),
[RowCreateTime] [datetime2] NOT NULL CONSTRAINT [DeliveryType_RowCreateTime_Default] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[DeliveryType] ADD CONSTRAINT [DeliveryType_DeliveryTypeId] PRIMARY KEY CLUSTERED  ([DeliveryTypeId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[DeliveryType] ADD CONSTRAINT [DeliveryType_DeliveryTypeName_Unique] UNIQUE NONCLUSTERED  ([DeliveryTypeName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DeliveryType_RowUpdatePerson] ON [Application].[DeliveryType] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[DeliveryType] ADD CONSTRAINT [DeliveryType_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
