CREATE TABLE [Application].[Organization]
(
[OrganizationId] [int] NOT NULL IDENTITY(1, 1),
[OrganizationName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WebsiteURL] [nvarchar] (2083) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_Organization_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_Organization_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[Organization] ADD CONSTRAINT [Application_Organization_OrganizationId] PRIMARY KEY CLUSTERED  ([OrganizationId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_Organization_RowUpdatePersonId] ON [Application].[Organization] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Organization] ADD CONSTRAINT [Application_Organization_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
