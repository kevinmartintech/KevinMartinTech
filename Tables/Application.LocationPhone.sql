CREATE TABLE [Application].[LocationPhone]
(
[LocationPhoneId] [int] NOT NULL IDENTITY(1, 1),
[LocationId] [int] NOT NULL,
[PhoneTypeId] [tinyint] NOT NULL,
[PhoneNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowUpdatePersonId] [int] NOT NULL,
[RowUpdateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_LocationPhone_RowUpdateTime_Default] DEFAULT (sysdatetimeoffset()),
[RowCreateTime] [datetimeoffset] NOT NULL CONSTRAINT [Application_LocationPhone_RowCreateTime_Default] DEFAULT (sysdatetimeoffset())
) ON [PRIMARY]
GO
ALTER TABLE [Application].[LocationPhone] ADD CONSTRAINT [Application_LocationPhone_LocationPhoneId] PRIMARY KEY CLUSTERED  ([LocationPhoneId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_LocationPhone_LocationId] ON [Application].[LocationPhone] ([LocationId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[LocationPhone] ADD CONSTRAINT [Application_LocationPhone_LocationId_PhoneTypeId_PhoneNumber] UNIQUE NONCLUSTERED  ([LocationId], [PhoneTypeId], [PhoneNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_LocationPhone_PhoneTypeId] ON [Application].[LocationPhone] ([PhoneTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Application_LocationPhone_RowUpdatePersonId] ON [Application].[LocationPhone] ([RowUpdatePersonId]) ON [PRIMARY]
GO
ALTER TABLE [Application].[LocationPhone] ADD CONSTRAINT [Application_LocationPhone_Application_Location] FOREIGN KEY ([LocationId]) REFERENCES [Application].[Location] ([LocationId])
GO
ALTER TABLE [Application].[LocationPhone] ADD CONSTRAINT [Application_LocationPhone_Application_PhoneType] FOREIGN KEY ([PhoneTypeId]) REFERENCES [Application].[PhoneType] ([PhoneTypeId])
GO
ALTER TABLE [Application].[LocationPhone] ADD CONSTRAINT [Application_LocationPhone_Application_RowUpdatePerson] FOREIGN KEY ([RowUpdatePersonId]) REFERENCES [Application].[Person] ([PersonId])
GO
