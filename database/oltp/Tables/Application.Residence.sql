CREATE TABLE [Application].[Residence]
(
[ResidenceId] [int] NOT NULL IDENTITY(1, 1),
[PersonId] [int] NOT NULL,
[AddressId] [int] NOT NULL,
[AddressTypeId] [int] NOT NULL CONSTRAINT [Residence_AddressTypeId_Unknown] DEFAULT ((-1)),
[RowUpdatePersonId] [int] NOT NULL CONSTRAINT [Residence_RowUpdatePersonId_Default] DEFAULT ((-1)),
[RowUpdateTime] [datetime2] NOT NULL CONSTRAINT [Residence_RowUpdateTime_Default] DEFAULT (sysdatetime()),
[RowCreateTime] [datetime2] NOT NULL CONSTRAINT [Residence_RowCreateTime_Default] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[Residence] ADD CONSTRAINT [Residence_ResidenceId] PRIMARY KEY CLUSTERED  ([ResidenceId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Residence_AddressId] ON [Application].[Residence] ([AddressId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Residence_AddressTypeId] ON [Application].[Residence] ([AddressTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Residence_PersonId] ON [Application].[Residence] ([PersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Residence] ADD CONSTRAINT [Residence_PersonId_AddressId_AddressTypeId] UNIQUE NONCLUSTERED  ([PersonId], [AddressId], [AddressTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Residence_RowUpdatePerson] ON [Application].[Residence] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[Residence] ADD CONSTRAINT [Residence_Address] FOREIGN KEY ([AddressId]) REFERENCES [Application].[Address] ([AddressId])
GO
ALTER TABLE [Application].[Residence] ADD CONSTRAINT [Residence_AddressType] FOREIGN KEY ([AddressTypeId]) REFERENCES [Application].[AddressType] ([AddressTypeId])
GO
ALTER TABLE [Application].[Residence] ADD CONSTRAINT [Residence_Person] FOREIGN KEY ([PersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
ALTER TABLE [Application].[Residence] ADD CONSTRAINT [Residence_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'An address of a person.', 'SCHEMA', N'Application', 'TABLE', N'Residence', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key to Address.', 'SCHEMA', N'Application', 'TABLE', N'Residence', 'COLUMN', N'AddressId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key to AddressType.', 'SCHEMA', N'Application', 'TABLE', N'Residence', 'COLUMN', N'AddressTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key to Person.', 'SCHEMA', N'Application', 'TABLE', N'Residence', 'COLUMN', N'PersonId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for residence records.', 'SCHEMA', N'Application', 'TABLE', N'Residence', 'COLUMN', N'ResidenceId'
GO
