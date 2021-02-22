CREATE TABLE [Application].[Category]
(
[CategoryId] [int] NOT NULL IDENTITY(1, 1),
[ParentIdCategoryId] [int] NULL,
[CategoryName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CategorySlug] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_Category_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_Category_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[Category] ADD CONSTRAINT [Application_Category_CategoryId] PRIMARY KEY CLUSTERED  ([CategoryId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Category] ADD CONSTRAINT [Application_Category_CategorySlug] UNIQUE NONCLUSTERED  ([CategorySlug]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_Category_RowUpdatePersonId] ON [Application].[Category] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Category] ADD CONSTRAINT [Application_Category_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
ALTER TABLE [Application].[Category] ADD CONSTRAINT [Application_Category_ParentIdCategoryId] FOREIGN KEY ([ParentIdCategoryId]) REFERENCES [Application].[Category] ([CategoryId])
GO
