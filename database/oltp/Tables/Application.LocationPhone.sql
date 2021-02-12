CREATE TABLE [Application].[LocationPhone]
(
[LocationPhoneId] [int] NOT NULL IDENTITY(1, 1),
[LocationId] [int] NOT NULL,
[PhoneTypeId] [int] NOT NULL CONSTRAINT [LocationPhone_PhoneTypeId_Unknown] DEFAULT ((-1)),
[PhoneNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL CONSTRAINT [LocationPhoneRowUpdatePersonId_Default] DEFAULT ((-1)),
[RowUpdateTime] [datetime2] NOT NULL CONSTRAINT [LocationPhone_RowUpdateTime_Default] DEFAULT (sysdatetime()),
[RowCreateTime] [datetime2] NOT NULL CONSTRAINT [LocationPhone_RowCreateTime_Default] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[LocationPhone] ADD CONSTRAINT [LocationPhone_LocationPhoneId] PRIMARY KEY CLUSTERED  ([LocationPhoneId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LocationPhone_LocationId] ON [Application].[LocationPhone] ([LocationId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[LocationPhone] ADD CONSTRAINT [LocationPhone_LocationId_PhoneTypeId_PhoneNumber] UNIQUE NONCLUSTERED  ([LocationId], [PhoneTypeId], [PhoneNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LocationPhone_PhoneTypeId] ON [Application].[LocationPhone] ([PhoneTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LocationPhone_RowUpdatePerson] ON [Application].[LocationPhone] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[LocationPhone] ADD CONSTRAINT [LocationPhone_Location] FOREIGN KEY ([LocationId]) REFERENCES [Application].[Location] ([LocationId])
GO
ALTER TABLE [Application].[LocationPhone] ADD CONSTRAINT [LocationPhone_PhoneType] FOREIGN KEY ([PhoneTypeId]) REFERENCES [Application].[PhoneType] ([PhoneTypeId])
GO
ALTER TABLE [Application].[LocationPhone] ADD CONSTRAINT [LocationPhone_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
