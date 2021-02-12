CREATE TABLE [Application].[PersonPhone]
(
[PersonPhoneId] [int] NOT NULL,
[PersonId] [int] NOT NULL,
[PhoneTypeId] [int] NOT NULL CONSTRAINT [PersonPhone_PhoneTypeId_Unknown] DEFAULT ((-1)),
[PhoneNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowUpdatePersonId] [int] NOT NULL CONSTRAINT [PersonPhone_RowUpdatePersonId_Default] DEFAULT ((-1)),
[RowUpdateTime] [datetime2] NOT NULL CONSTRAINT [PersonPhone_RowUpdateTime_Default] DEFAULT (sysdatetime()),
[RowCreateTime] [datetime2] NOT NULL CONSTRAINT [PersonPhone_RowCreateTime_Default] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[PersonPhone] ADD CONSTRAINT [PersonPhone_PersonPhoneId] PRIMARY KEY CLUSTERED  ([PersonPhoneId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PersonPhone_PersonId] ON [Application].[PersonPhone] ([PersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[PersonPhone] ADD CONSTRAINT [PersonPhone_PersonId_PhoneTypeId_PhoneNumber] UNIQUE NONCLUSTERED  ([PersonId], [PhoneTypeId], [PhoneNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PersonPhone_PhoneTypeId] ON [Application].[PersonPhone] ([PhoneTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PersonPhone_RowUpdatePerson] ON [Application].[PersonPhone] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[PersonPhone] ADD CONSTRAINT [PersonPhone_Person] FOREIGN KEY ([PersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
ALTER TABLE [Application].[PersonPhone] ADD CONSTRAINT [PersonPhone_PhoneType] FOREIGN KEY ([PhoneTypeId]) REFERENCES [Application].[PhoneType] ([PhoneTypeId])
GO
ALTER TABLE [Application].[PersonPhone] ADD CONSTRAINT [PersonPhone_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
