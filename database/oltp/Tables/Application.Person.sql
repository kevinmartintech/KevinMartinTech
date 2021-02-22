CREATE TABLE [Application].[Person]
(
[PersonId] [int] NOT NULL IDENTITY(1, 1),
[Title] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NickName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SearchName] AS (TRIM(concat(isnull(TRIM([NickName])+' ',''),isnull(TRIM([FirstName])+' ',''),isnull(TRIM([LastName])+' ',''),isnull(TRIM([Suffix])+'','')))) PERSISTED NOT NULL,
[IsOptOutFlag] [bit] NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_Person_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_Person_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[Person] ADD CONSTRAINT [Application_Person_PersonId] PRIMARY KEY CLUSTERED  ([PersonId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_Person_RowUpdatePersonId] ON [Application].[Person] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Person] ADD CONSTRAINT [Application_Person_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'First name of the person.', 'SCHEMA', N'Application', 'TABLE', N'Person', 'COLUMN', N'FirstName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Person does not wish to receive e-mail promotions, 1 = Person does wish to receive e-mail promotions.', 'SCHEMA', N'Application', 'TABLE', N'Person', 'COLUMN', N'IsOptOutFlag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last name of the person.', 'SCHEMA', N'Application', 'TABLE', N'Person', 'COLUMN', N'LastName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nickname of the person.', 'SCHEMA', N'Application', 'TABLE', N'Person', 'COLUMN', N'NickName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for person records.', 'SCHEMA', N'Application', 'TABLE', N'Person', 'COLUMN', N'PersonId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surname suffix. For example, Sr. or Jr.', 'SCHEMA', N'Application', 'TABLE', N'Person', 'COLUMN', N'Suffix'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A courtesy title. For example, Mr. or Ms.', 'SCHEMA', N'Application', 'TABLE', N'Person', 'COLUMN', N'Title'
GO
