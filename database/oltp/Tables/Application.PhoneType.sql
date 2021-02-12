CREATE TABLE [Application].[PhoneType]
(
[PhoneTypeId] [int] NOT NULL,
[PhoneTypeName] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL CONSTRAINT [PhoneType_RowUpdatePersonId_Default] DEFAULT ((-1)),
[RowUpdateTime] [datetime2] NOT NULL CONSTRAINT [PhoneType_RowUpdateTime_Default] DEFAULT (sysdatetime()),
[RowCreateTime] [datetime2] NOT NULL CONSTRAINT [PhoneType_RowCreateTime_Default] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[PhoneType] ADD CONSTRAINT [PhoneType_PhoneTypeId] PRIMARY KEY CLUSTERED  ([PhoneTypeId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[PhoneType] ADD CONSTRAINT [PhoneType_PhoneTypeName_Unique] UNIQUE NONCLUSTERED  ([PhoneTypeName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PhoneType_RowUpdatePerson] ON [Application].[PhoneType] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[PhoneType] ADD CONSTRAINT [PhoneType_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
