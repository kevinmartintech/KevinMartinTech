CREATE TABLE [Application].[EmailType]
(
[EmailTypeId] [tinyint] NOT NULL,
[EmailTypeName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_EmailType_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_EmailType_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[EmailType] ADD CONSTRAINT [Application_EmailType_EmailTypeId] PRIMARY KEY CLUSTERED  ([EmailTypeId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[EmailType] ADD CONSTRAINT [Application_EmailType_EmailTypeName_Unique] UNIQUE NONCLUSTERED  ([EmailTypeName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_EmailType_RowUpdatePersonId] ON [Application].[EmailType] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[EmailType] ADD CONSTRAINT [Application_EmailType_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Types of emails stored in the Email table.', 'SCHEMA', N'Application', 'TABLE', N'EmailType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for email type records.', 'SCHEMA', N'Application', 'TABLE', N'EmailType', 'COLUMN', N'EmailTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Email type description. For example, Work, Home.', 'SCHEMA', N'Application', 'TABLE', N'EmailType', 'COLUMN', N'EmailTypeName'
GO
