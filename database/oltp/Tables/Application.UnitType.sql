CREATE TABLE [Application].[UnitType]
(
[UnitTypeId] [tinyint] NOT NULL,
[UnitTypeName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_UnitType_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_UnitType_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[UnitType] ADD CONSTRAINT [Application_UnitType_EmailTypeId] PRIMARY KEY CLUSTERED  ([UnitTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_UnitType_RowUpdatePersonId] ON [Application].[UnitType] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[UnitType] ADD CONSTRAINT [Application_UnitType_EmailTypeName_Unique] UNIQUE NONCLUSTERED  ([UnitTypeName]) ON [PRIMARY]
GO
ALTER TABLE [Application].[UnitType] ADD CONSTRAINT [Application_UnitType_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Types of units stored in the Unit table.', 'SCHEMA', N'Application', 'TABLE', N'UnitType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for unit type records.', 'SCHEMA', N'Application', 'TABLE', N'UnitType', 'COLUMN', N'UnitTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unit type description. For example, Each, Bag, Pallet.', 'SCHEMA', N'Application', 'TABLE', N'UnitType', 'COLUMN', N'UnitTypeName'
GO
