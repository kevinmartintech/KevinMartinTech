CREATE TABLE [Application].[AttributeTerm]
(
[AttributeTermId] [int] NOT NULL,
[AttributeId] [int] NOT NULL,
[TermName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_AttributeTerm_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_AttributeTerm_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[AttributeTerm] ADD CONSTRAINT [Application_AttributeTerm_AttributeTermId] PRIMARY KEY CLUSTERED  ([AttributeTermId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_AttributeTerm_AttributeId] ON [Application].[AttributeTerm] ([AttributeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_AttributeTerm_RowUpdatePersonId] ON [Application].[AttributeTerm] ([RowUpdatePersonId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_AttributeTerm_TermName] ON [Application].[AttributeTerm] ([TermName]) ON [PRIMARY]
GO
ALTER TABLE [Application].[AttributeTerm] ADD CONSTRAINT [Application_AttributeTerm_Application_Attribute] FOREIGN KEY ([AttributeId]) REFERENCES [Application].[Attribute] ([AttributeId])
GO
ALTER TABLE [Application].[AttributeTerm] ADD CONSTRAINT [Application_AttributeTerm_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
