CREATE TABLE [Purchasing].[PurchaseOrderLine]
(
[PurchaseOrderLineId] [int] NOT NULL,
[PurchaseOrderId] [int] NOT NULL,
[ProductVariantId] [int] NOT NULL,
[UnitTypeId] [tinyint] NOT NULL,
[QuantityOrdered] [int] NOT NULL,
[QuantityReceived] [int] NOT NULL,
[UnitPrice] [decimal] (18, 2) NOT NULL,
[DiscountPercentage] [decimal] (18, 3) NULL,
[NetAmount] [decimal] (18, 2) NOT NULL,
[IsOrderLineFinalizedFlag] [bit] NOT NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Purchasing_PurchaseOrderLine_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Purchasing_PurchaseOrderLine_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Purchasing].[PurchaseOrderLine] ADD CONSTRAINT [Purchasing_PurchaseOrderLine_DiscountPercentage_Greater_Than_Zero] CHECK (([DiscountPercentage]>=(0)))
GO
ALTER TABLE [Purchasing].[PurchaseOrderLine] ADD CONSTRAINT [Purchasing_PurchaseOrderLine_NetAmount_Greater_Than_Zero] CHECK (([NetAmount]>=(0)))
GO
ALTER TABLE [Purchasing].[PurchaseOrderLine] ADD CONSTRAINT [Purchasing_PurchaseOrderLine_QuantityOrdered_Greater_Than_Zero] CHECK (([QuantityOrdered]>=(0)))
GO
ALTER TABLE [Purchasing].[PurchaseOrderLine] ADD CONSTRAINT [Purchasing_PurchaseOrderLine_QuantityReceived_Greater_Than_Zero] CHECK (([QuantityReceived]>=(0)))
GO
ALTER TABLE [Purchasing].[PurchaseOrderLine] ADD CONSTRAINT [Purchasing_PurchaseOrderLine_UnitPrice_Greater_Than_Zero] CHECK (([UnitPrice]>=(0)))
GO
ALTER TABLE [Purchasing].[PurchaseOrderLine] ADD CONSTRAINT [Purchasing_PurchaseOrderLine_PurchaseOrderLineId] PRIMARY KEY CLUSTERED  ([PurchaseOrderLineId]) ON [PRIMARY]
GO
ALTER TABLE [Purchasing].[PurchaseOrderLine] ADD CONSTRAINT [Purchasing_PurchaseOrderLine_Application_ProductVariant] FOREIGN KEY ([ProductVariantId]) REFERENCES [Application].[ProductVariant] ([ProductVariantId])
GO
ALTER TABLE [Purchasing].[PurchaseOrderLine] ADD CONSTRAINT [Purchasing_PurchaseOrderLine_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
ALTER TABLE [Purchasing].[PurchaseOrderLine] ADD CONSTRAINT [Purchasing_PurchaseOrderLine_Application_UnitType] FOREIGN KEY ([UnitTypeId]) REFERENCES [Application].[UnitType] ([UnitTypeId])
GO
ALTER TABLE [Purchasing].[PurchaseOrderLine] ADD CONSTRAINT [Purchasing_PurchaseOrderLine_Purchasing_PurchaseOrder] FOREIGN KEY ([PurchaseOrderId]) REFERENCES [Purchasing].[PurchaseOrder] ([PurchaseOrderId])
GO
EXEC sp_addextendedproperty N'Description', N'Detail lines from supplier purchase order', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderLine', NULL, NULL
GO
EXEC sp_addextendedproperty N'Description', N'The discount percent that we expect to receive', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderLine', 'COLUMN', N'DiscountPercentage'
GO
EXEC sp_addextendedproperty N'Description', N'Is this purchase order line now considered finalized? (Receipted quantities and weights are often not precise)', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderLine', 'COLUMN', N'IsOrderLineFinalizedFlag'
GO
EXEC sp_addextendedproperty N'Description', N'The net amount that we expect to be charged', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderLine', 'COLUMN', N'NetAmount'
GO
EXEC sp_addextendedproperty N'Description', N'Stock item for this purchase order line', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderLine', 'COLUMN', N'ProductVariantId'
GO
EXEC sp_addextendedproperty N'Description', N'Purchase order that this line is associated with', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderLine', 'COLUMN', N'PurchaseOrderId'
GO
EXEC sp_addextendedproperty N'Description', N'Numeric ID used for reference to a line on a purchase order within the database', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderLine', 'COLUMN', N'PurchaseOrderLineId'
GO
EXEC sp_addextendedproperty N'Description', N'Quantity of the stock item that is ordered', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderLine', 'COLUMN', N'QuantityOrdered'
GO
EXEC sp_addextendedproperty N'Description', N'Total quantity of the stock item that has been received so far', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderLine', 'COLUMN', N'QuantityReceived'
GO
EXEC sp_addextendedproperty N'Description', N'The unit price that we expect to be charged', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderLine', 'COLUMN', N'UnitPrice'
GO
EXEC sp_addextendedproperty N'Description', N'Type of package received', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderLine', 'COLUMN', N'UnitTypeId'
GO
