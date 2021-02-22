CREATE TABLE [Application].[PhoneType]
(
[PhoneTypeId] [tinyint] NOT NULL,
[PhoneTypeName] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_PhoneType_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_PhoneType_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[PhoneType] ADD CONSTRAINT [Application_PhoneType_PhoneTypeId] PRIMARY KEY CLUSTERED  ([PhoneTypeId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[PhoneType] ADD CONSTRAINT [Application_PhoneType_PhoneTypeName_Unique] UNIQUE NONCLUSTERED  ([PhoneTypeName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_PhoneType_RowUpdatePersonId] ON [Application].[PhoneType] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[PhoneType] ADD CONSTRAINT [Application_PhoneType_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
