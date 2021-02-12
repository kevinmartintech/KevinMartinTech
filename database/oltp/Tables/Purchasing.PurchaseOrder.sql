CREATE TABLE [Purchasing].[PurchaseOrder]
(
[PurchaseOrderId] [int] NOT NULL IDENTITY(1, 1),
[SupplierId] [int] NOT NULL,
[OrderDate] [date] NOT NULL,
[DeliveryTypeId] [int] NOT NULL CONSTRAINT [PurchaseOrder_DeliveryTypeId_Default] DEFAULT ((-1)),
[ContactPersonId] [int] NOT NULL CONSTRAINT [PurchaseOrder_ContactPersonId_Default] DEFAULT ((-1)),
[ExpectedDeliveryDate] [date] NULL,
[SupplierReference] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsOrderFinalizedFlag] [bit] NOT NULL CONSTRAINT [PurchaseOrder_IsOrderFinalizedFlag_Default] DEFAULT ((0)),
[Comments] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InternalComments] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowUpdatePersonId] [int] NOT NULL CONSTRAINT [PurchaseOrder_RowUpdatePersonId_Default] DEFAULT ((-1)),
[RowUpdateTime] [datetime2] NOT NULL CONSTRAINT [PurchaseOrder_RowUpdateTime_Default] DEFAULT (sysdatetime()),
[RowCreateTime] [datetime2] NOT NULL CONSTRAINT [PurchaseOrder_RowCreateTime_Default] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [Purchasing].[PurchaseOrder] ADD CONSTRAINT [PurchaseOrder_PurchaseOrderId] PRIMARY KEY CLUSTERED  ([PurchaseOrderId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PurchaseOrder_ContactPersonId] ON [Purchasing].[PurchaseOrder] ([ContactPersonId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PurchaseOrder_DeliveryTypeId] ON [Purchasing].[PurchaseOrder] ([DeliveryTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PurchaseOrder_RowUpdatePerson] ON [Purchasing].[PurchaseOrder] ([RowUpdatePersonId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PurchaseOrder_SupplierId] ON [Purchasing].[PurchaseOrder] ([SupplierId]) ON [PRIMARY]
GO
ALTER TABLE [Purchasing].[PurchaseOrder] ADD CONSTRAINT [PurchaseOrder_ContactPerson] FOREIGN KEY ([ContactPersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
ALTER TABLE [Purchasing].[PurchaseOrder] ADD CONSTRAINT [PurchaseOrder_DeliveryType] FOREIGN KEY ([DeliveryTypeId]) REFERENCES [Application].[DeliveryType] ([DeliveryTypeId])
GO
ALTER TABLE [Purchasing].[PurchaseOrder] ADD CONSTRAINT [PurchaseOrder_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
ALTER TABLE [Purchasing].[PurchaseOrder] ADD CONSTRAINT [PurchaseOrder_Supplier] FOREIGN KEY ([SupplierId]) REFERENCES [Purchasing].[Supplier] ([SupplierId])
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
