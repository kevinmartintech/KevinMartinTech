CREATE TABLE [Application].[PersonEmail]
(
[PersonEmailId] [int] NOT NULL IDENTITY(1, 1),
[PersonId] [int] NOT NULL,
[EmailTypeId] [int] NOT NULL CONSTRAINT [PersonEmail_EmailTypeId_Unknown] DEFAULT ((-1)),
[EmailAddress] [nvarchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowUpdatePersonId] [int] NOT NULL CONSTRAINT [PersonEmail_RowUpdatePersonId_Default] DEFAULT ((-1)),
[RowUpdateTime] [datetime2] NOT NULL CONSTRAINT [PersonEmail_RowUpdateTime_Default] DEFAULT (sysdatetime()),
[RowCreateTime] [datetime2] NOT NULL CONSTRAINT [PersonEmail_RowCreateTime_Default] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[PersonEmail] ADD CONSTRAINT [PersonEmail_PersonEmailId] PRIMARY KEY CLUSTERED  ([PersonEmailId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PersonEmail_EmailTypeId] ON [Application].[PersonEmail] ([EmailTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PersonEmail_PersonId] ON [Application].[PersonEmail] ([PersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[PersonEmail] ADD CONSTRAINT [PersonEmail_PersonId_EmailId_EmailTypeId] UNIQUE NONCLUSTERED  ([PersonId], [EmailTypeId], [EmailAddress]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PersonEmail_RowUpdatePerson] ON [Application].[PersonEmail] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[PersonEmail] ADD CONSTRAINT [PersonEmail_EmailType] FOREIGN KEY ([EmailTypeId]) REFERENCES [Application].[EmailType] ([EmailTypeId])
GO
ALTER TABLE [Application].[PersonEmail] ADD CONSTRAINT [PersonEmail_Person] FOREIGN KEY ([PersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
ALTER TABLE [Application].[PersonEmail] ADD CONSTRAINT [PersonEmail_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Email address of a person.', 'SCHEMA', N'Application', 'TABLE', N'PersonEmail', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Persons Email Address', 'SCHEMA', N'Application', 'TABLE', N'PersonEmail', 'COLUMN', N'EmailAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key to EmailType.', 'SCHEMA', N'Application', 'TABLE', N'PersonEmail', 'COLUMN', N'EmailTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for person email records.', 'SCHEMA', N'Application', 'TABLE', N'PersonEmail', 'COLUMN', N'PersonEmailId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key to Person.', 'SCHEMA', N'Application', 'TABLE', N'PersonEmail', 'COLUMN', N'PersonId'
GO
