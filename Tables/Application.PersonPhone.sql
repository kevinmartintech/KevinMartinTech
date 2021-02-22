CREATE TABLE [Application].[PersonPhone]
(
[PersonPhoneId] [int] NOT NULL,
[PersonId] [int] NOT NULL,
[PhoneTypeId] [tinyint] NOT NULL,
[PhoneNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_PersonPhone_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_PersonPhone_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[PersonPhone] ADD CONSTRAINT [Application_PersonPhone_PersonPhoneId] PRIMARY KEY CLUSTERED  ([PersonPhoneId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_PersonPhone_PersonId] ON [Application].[PersonPhone] ([PersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[PersonPhone] ADD CONSTRAINT [Application_PersonPhone_PersonId_PhoneTypeId_PhoneNumber] UNIQUE NONCLUSTERED  ([PersonId], [PhoneTypeId], [PhoneNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_PersonPhone_PhoneTypeId] ON [Application].[PersonPhone] ([PhoneTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_PersonPhone_RowUpdatePersonId] ON [Application].[PersonPhone] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[PersonPhone] ADD CONSTRAINT [Application_PersonPhone_Application_Person] FOREIGN KEY ([PersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
ALTER TABLE [Application].[PersonPhone] ADD CONSTRAINT [Application_PersonPhone_Application_PhoneType] FOREIGN KEY ([PhoneTypeId]) REFERENCES [Application].[PhoneType] ([PhoneTypeId])
GO
ALTER TABLE [Application].[PersonPhone] ADD CONSTRAINT [Application_PersonPhone_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
