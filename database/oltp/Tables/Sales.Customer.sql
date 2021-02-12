CREATE TABLE [Sales].[Customer]
(
[CustomerId] [int] NOT NULL IDENTITY(1, 1),
[OrganizationId] [int] NOT NULL,
[CreditLimit] [decimal] (18, 2) NULL,
[IsOnCreditHoldFlag] [bit] NOT NULL,
[AccountOpenedDate] [date] NOT NULL,
[StandardDiscountPercentage] [decimal] (18, 3) NOT NULL,
[RowUpdatePersonId] [int] NOT NULL CONSTRAINT [Customer_RowUpdatePersonId_Default] DEFAULT ((-1)),
[RowUpdateTime] [datetime2] NOT NULL CONSTRAINT [Customer_RowUpdateTime_Default] DEFAULT (sysdatetime()),
[RowCreateTime] [datetime2] NOT NULL CONSTRAINT [Customer_RowCreateTime_Default] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [Sales].[Customer] ADD CONSTRAINT [Customer_CustomerId] PRIMARY KEY CLUSTERED  ([CustomerId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Customer_OrganizationId] ON [Sales].[Customer] ([OrganizationId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Customer_RowUpdatePerson] ON [Sales].[Customer] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Sales].[Customer] ADD CONSTRAINT [Customer_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [Application].[Organization] ([OrganizationId])
GO
ALTER TABLE [Sales].[Customer] ADD CONSTRAINT [Customer_Person] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
