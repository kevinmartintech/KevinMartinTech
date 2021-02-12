CREATE TABLE [Application].[Organization]
(
[OrganizationId] [int] NOT NULL IDENTITY(1, 1),
[OrganizationName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WebsiteURL] [nvarchar] (2083) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowUpdatePersonId] [int] NOT NULL CONSTRAINT [Organization_RowUpdatePersonId_Default] DEFAULT ((-1)),
[RowUpdateTime] [datetime2] NOT NULL CONSTRAINT [Organization_RowUpdateTime_Default] DEFAULT (sysdatetime()),
[RowCreateTime] [datetime2] NOT NULL CONSTRAINT [Organization_RowCreateTime_Default] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[Organization] ADD CONSTRAINT [Organization_OrganizationId] PRIMARY KEY CLUSTERED  ([OrganizationId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Organization_RowUpdatePerson] ON [Application].[Organization] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Organization] ADD CONSTRAINT [Organization_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
