CREATE TABLE [Purchasing].[Supplier]
(
[SupplierId] [int] NOT NULL IDENTITY(1, 1),
[OrganizationId] [int] NOT NULL,
[PaymentDays] [int] NOT NULL,
[InternalComments] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Purchasing_Supplier_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Purchasing_Supplier_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Purchasing].[Supplier] ADD CONSTRAINT [Purchasing_Supplier_PaymentDays_Greater_Than_Zero] CHECK (([PaymentDays]>=(0)))
GO
ALTER TABLE [Purchasing].[Supplier] ADD CONSTRAINT [Purchasing_Supplier_SupplierId] PRIMARY KEY CLUSTERED  ([SupplierId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Purchasing_Supplier_OrganizationId] ON [Purchasing].[Supplier] ([OrganizationId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Purchasing_Supplier_RowUpdatePersonId] ON [Purchasing].[Supplier] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Purchasing].[Supplier] ADD CONSTRAINT [Purchasing_Supplier_Application_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [Application].[Organization] ([OrganizationId])
GO
ALTER TABLE [Purchasing].[Supplier] ADD CONSTRAINT [Purchasing_Supplier_Application_Person] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
