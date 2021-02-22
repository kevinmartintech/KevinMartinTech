CREATE TABLE [Purchasing].[PurchaseOrder]
(
[PurchaseOrderId] [int] NOT NULL IDENTITY(1, 1),
[SupplierId] [int] NOT NULL,
[OrderDate] [datetimeoffset] NOT NULL,
[DeliveryTypeId] [tinyint] NOT NULL,
[ContactPersonId] [int] NOT NULL,
[ExpectedDeliveryDate] [datetimeoffset] NULL,
[SupplierReference] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsOrderFinalizedFlag] [bit] NOT NULL,
[Comments] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InternalComments] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Purchasing_PurchaseOrder_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Purchasing_PurchaseOrder_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Purchasing].[PurchaseOrder] ADD CONSTRAINT [Purchasing_PurchaseOrder_PurchaseOrderId] PRIMARY KEY CLUSTERED  ([PurchaseOrderId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Purchasing_PurchaseOrder_ContactPersonId] ON [Purchasing].[PurchaseOrder] ([ContactPersonId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Purchasing_PurchaseOrder_DeliveryTypeId] ON [Purchasing].[PurchaseOrder] ([DeliveryTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Purchasing_PurchaseOrder_RowUpdatePersonId] ON [Purchasing].[PurchaseOrder] ([RowUpdatePersonId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Purchasing_PurchaseOrder_SupplierId] ON [Purchasing].[PurchaseOrder] ([SupplierId]) ON [PRIMARY]
GO
ALTER TABLE [Purchasing].[PurchaseOrder] ADD CONSTRAINT [Purchasing_PurchaseOrder_Application_ContactPerson] FOREIGN KEY ([ContactPersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
ALTER TABLE [Purchasing].[PurchaseOrder] ADD CONSTRAINT [Purchasing_PurchaseOrder_Application_DeliveryType] FOREIGN KEY ([DeliveryTypeId]) REFERENCES [Application].[DeliveryType] ([DeliveryTypeId])
GO
ALTER TABLE [Purchasing].[PurchaseOrder] ADD CONSTRAINT [Purchasing_PurchaseOrder_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
ALTER TABLE [Purchasing].[PurchaseOrder] ADD CONSTRAINT [Purchasing_PurchaseOrder_Application_Supplier] FOREIGN KEY ([SupplierId]) REFERENCES [Purchasing].[Supplier] ([SupplierId])
GO
EXEC sp_addextendedproperty N'Description', N'Details of supplier purchase orders', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrder', NULL, NULL
GO
EXEC sp_addextendedproperty N'Description', N'Any comments related this purchase order (comments sent to the supplier)', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrder', 'COLUMN', N'Comments'
GO
EXEC sp_addextendedproperty N'Description', N'The person who is the primary contact for this purchase order', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrder', 'COLUMN', N'ContactPersonId'
GO
EXEC sp_addextendedproperty N'Description', N'How this purchase order should be delivered', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrder', 'COLUMN', N'DeliveryTypeId'
GO
EXEC sp_addextendedproperty N'Description', N'Expected delivery date for this purchase order', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrder', 'COLUMN', N'ExpectedDeliveryDate'
GO
EXEC sp_addextendedproperty N'Description', N'Any internal comments related this purchase order (comments for internal reference only and not sent to the supplier)', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrder', 'COLUMN', N'InternalComments'
GO
EXEC sp_addextendedproperty N'Description', N'Is this purchase order now considered finalized?', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrder', 'COLUMN', N'IsOrderFinalizedFlag'
GO
EXEC sp_addextendedproperty N'Description', N'Date that this purchase order was raised', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrder', 'COLUMN', N'OrderDate'
GO
EXEC sp_addextendedproperty N'Description', N'Numeric Id used for reference to a purchase order within the database', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrder', 'COLUMN', N'PurchaseOrderId'
GO
EXEC sp_addextendedproperty N'Description', N'Supplier for this purchase order', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrder', 'COLUMN', N'SupplierId'
GO
EXEC sp_addextendedproperty N'Description', N'Supplier reference for our organization (might be our account number at the supplier)', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrder', 'COLUMN', N'SupplierReference'
GO
