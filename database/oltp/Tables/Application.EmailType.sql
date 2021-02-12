CREATE TABLE [Application].[EmailType]
(
[EmailTypeId] [int] NOT NULL,
[EmailTypeName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL CONSTRAINT [EmailType_RowUpdatePersonId_Default] DEFAULT ((-1)),
[RowUpdateTime] [datetime2] NOT NULL CONSTRAINT [EmailType_RowUpdateTime_Default] DEFAULT (sysdatetime()),
[RowCreateTime] [datetime2] NOT NULL CONSTRAINT [EmailType_RowCreateTime_Default] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[EmailType] ADD CONSTRAINT [EmailType_EmailTypeId] PRIMARY KEY CLUSTERED  ([EmailTypeId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[EmailType] ADD CONSTRAINT [EmailType_EmailTypeName_Unique] UNIQUE NONCLUSTERED  ([EmailTypeName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmailType_RowUpdatePerson] ON [Application].[EmailType] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[EmailType] ADD CONSTRAINT [EmailType_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Types of emails stored in the Email table.', 'SCHEMA', N'Application', 'TABLE', N'EmailType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for email type records.', 'SCHEMA', N'Application', 'TABLE', N'EmailType', 'COLUMN', N'EmailTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Email type description. For example, Work, Home.', 'SCHEMA', N'Application', 'TABLE', N'EmailType', 'COLUMN', N'EmailTypeName'
GO
