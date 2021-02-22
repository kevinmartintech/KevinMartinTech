CREATE TABLE [Sales].[Customer]
(
[CustomerId] [int] NOT NULL IDENTITY(1, 1),
[OrganizationId] [int] NOT NULL,
[CreditLimit] [decimal] (18, 2) NULL,
[PaymentDays] [int] NOT NULL,
[IsOnCreditHoldFlag] [bit] NOT NULL,
[AccountOpenedDate] [datetimeoffset] NOT NULL,
[StandardDiscountPercentage] [decimal] (18, 3) NOT NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Sales_Customer_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Sales_Customer_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Sales].[Customer] ADD CONSTRAINT [Sales_Customer_CreditLimit_Greater_Than_Zero] CHECK (([CreditLimit]>=(0)))
GO
ALTER TABLE [Sales].[Customer] ADD CONSTRAINT [Sales_Customer_PaymentDays_Greater_Than_Zero] CHECK (([PaymentDays]>=(0)))
GO
ALTER TABLE [Sales].[Customer] ADD CONSTRAINT [Sales_Customer_StandardDiscountPercentage_Greater_Than_Zero] CHECK (([StandardDiscountPercentage]>=(0)))
GO
ALTER TABLE [Sales].[Customer] ADD CONSTRAINT [Sales_Customer_CustomerId] PRIMARY KEY CLUSTERED  ([CustomerId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Sales_Customer_OrganizationId] ON [Sales].[Customer] ([OrganizationId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Sales_Customer_RowUpdatePersonId] ON [Sales].[Customer] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Sales].[Customer] ADD CONSTRAINT [Sales_Customer_Application_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [Application].[Organization] ([OrganizationId])
GO
ALTER TABLE [Sales].[Customer] ADD CONSTRAINT [Sales_Customer_Application_Person] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
