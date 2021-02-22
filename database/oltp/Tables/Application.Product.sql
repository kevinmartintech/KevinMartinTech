CREATE TABLE [Application].[Product]
(
[ProductId] [int] NOT NULL,
[ProductName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProductSlug] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ImageJSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_Product_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_Product_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[Product] ADD CONSTRAINT [Application_Product_ProductId] PRIMARY KEY CLUSTERED  ([ProductId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Product] ADD CONSTRAINT [Application_Product_ProductName] UNIQUE NONCLUSTERED  ([ProductName]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Product] ADD CONSTRAINT [Application_Product_ProductSlug] UNIQUE NONCLUSTERED  ([ProductSlug]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_Product_RowUpdatePersonId] ON [Application].[Product] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Product] ADD CONSTRAINT [Application_Product_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
