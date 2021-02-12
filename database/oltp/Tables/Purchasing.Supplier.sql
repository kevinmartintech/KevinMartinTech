CREATE TABLE [Purchasing].[Supplier]
(
[SupplierId] [int] NOT NULL IDENTITY(1, 1),
[OrganizationId] [int] NOT NULL,
[PaymentDays] [int] NOT NULL,
[InternalComments] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowUpdatePersonId] [int] NOT NULL CONSTRAINT [Supplier_RowUpdatePersonId_Default] DEFAULT ((-1)),
[RowUpdateTime] [datetime2] NOT NULL CONSTRAINT [Customer_RowUpdateTime_Default] DEFAULT (sysdatetime()),
[RowCreateTime] [datetime2] NOT NULL CONSTRAINT [Customer_RowCreateTime_Default] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [Purchasing].[Supplier] ADD CONSTRAINT [Supplier_SupplierId] PRIMARY KEY CLUSTERED  ([SupplierId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Purchasing_OrganizationId] ON [Purchasing].[Supplier] ([OrganizationId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Supplier_RowUpdatePerson] ON [Purchasing].[Supplier] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Purchasing].[Supplier] ADD CONSTRAINT [Customer_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [Application].[Organization] ([OrganizationId])
GO
ALTER TABLE [Purchasing].[Supplier] ADD CONSTRAINT [Customer_Person] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
