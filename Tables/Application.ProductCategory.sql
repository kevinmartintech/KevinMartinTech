CREATE TABLE [Application].[ProductCategory]
(
[ProductCategoryId] [int] NOT NULL IDENTITY(1, 1),
[ProductId] [int] NOT NULL,
[CategoryId] [int] NOT NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_ProductCategory_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_ProductCategory_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[ProductCategory] ADD CONSTRAINT [Application_ProductCategory_CategoryId] PRIMARY KEY CLUSTERED  ([CategoryId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_ProductCategory_RowUpdatePersonId] ON [Application].[ProductCategory] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[ProductCategory] ADD CONSTRAINT [Application_ProductCategory_Application_Category] FOREIGN KEY ([CategoryId]) REFERENCES [Application].[Category] ([CategoryId])
GO
ALTER TABLE [Application].[ProductCategory] ADD CONSTRAINT [Application_ProductCategory_Application_Product] FOREIGN KEY ([ProductId]) REFERENCES [Application].[Product] ([ProductId])
GO
ALTER TABLE [Application].[ProductCategory] ADD CONSTRAINT [Application_ProductCategory_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
