CREATE TABLE [Application].[ProductVariant]
(
[ProductVariantId] [int] NOT NULL,
[ProductId] [int] NOT NULL,
[AttributeId] [int] NOT NULL,
[AttributeTermId] [int] NOT NULL,
[IsEnableFlag] [bit] NOT NULL,
[IsVirtualFlag] [bit] NOT NULL,
[RegularPrice] [decimal] (18, 2) NOT NULL,
[SalePrice] [decimal] (18, 2) NULL,
[SKU] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_ProductVariant_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_ProductVariant_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[ProductVariant] ADD CONSTRAINT [Application_ProductVariant_RegularPrice_Greater_Than_Zero] CHECK (([RegularPrice]>=(0)))
GO
ALTER TABLE [Application].[ProductVariant] ADD CONSTRAINT [Application_ProductVariant_SalePrice_Greater_Than_Zero] CHECK (([SalePrice]>=(0)))
GO
ALTER TABLE [Application].[ProductVariant] ADD CONSTRAINT [Application_ProductVariant_SalePrice_LessEqual_To_RegularPrice] CHECK (([SalePrice]<=[RegularPrice]))
GO
ALTER TABLE [Application].[ProductVariant] ADD CONSTRAINT [Application_ProductVariant_ProductVariantId] PRIMARY KEY CLUSTERED  ([ProductVariantId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_ProductVariant_AttributeId] ON [Application].[ProductVariant] ([AttributeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_ProductVariant_AttributeTermId] ON [Application].[ProductVariant] ([AttributeTermId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_ProductVariant_ProductId] ON [Application].[ProductVariant] ([ProductId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_ProductVariant_RowUpdatePersonId] ON [Application].[ProductVariant] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[ProductVariant] ADD CONSTRAINT [Application_ProductVariant_Application_Attribute] FOREIGN KEY ([AttributeId]) REFERENCES [Application].[Attribute] ([AttributeId])
GO
ALTER TABLE [Application].[ProductVariant] ADD CONSTRAINT [Application_ProductVariant_Application_AttributeTerm] FOREIGN KEY ([AttributeTermId]) REFERENCES [Application].[AttributeTerm] ([AttributeTermId])
GO
ALTER TABLE [Application].[ProductVariant] ADD CONSTRAINT [Application_ProductVariant_Application_Product] FOREIGN KEY ([ProductId]) REFERENCES [Application].[Product] ([ProductId])
GO
ALTER TABLE [Application].[ProductVariant] ADD CONSTRAINT [Application_ProductVariant_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
