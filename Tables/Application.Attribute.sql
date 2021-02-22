CREATE TABLE [Application].[Attribute]
(
[AttributeId] [int] NOT NULL,
[AttributeName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_Attribute_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_Attribute_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[Attribute] ADD CONSTRAINT [Application_Attribute_AttributeId] PRIMARY KEY CLUSTERED  ([AttributeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_Attribute_RowUpdatePersonId] ON [Application].[Attribute] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Attribute] ADD CONSTRAINT [Application_Attribute_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
