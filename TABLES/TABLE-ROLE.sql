SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLE](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[Role] [varchar](50) NOT NULL,
	[Description] [varchar](255) NULL,
    [META_Lock] [bit] NOT NULL,
	[USR_Status] [char](1) NOT NULL,
	[USR_LastUpdateUser] [varchar](50) NOT NULL,
	[DBS_LastUpdateDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_CreationDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_LastUpdateUser] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ROLE] ADD  CONSTRAINT [PK__ROLE__8AFACE1A3118447E] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
ALTER TABLE [dbo].[ROLE] ADD  CONSTRAINT [UQ_ROLE] UNIQUE NONCLUSTERED 
(
	[Role] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROLE] ADD  CONSTRAINT [DF__ROLE__META_Lock__33F4B129]  DEFAULT (0) FOR [META_Lock]
GO
ALTER TABLE [dbo].[ROLE] ADD  CONSTRAINT [DF__ROLE__USR_Status__33F4B129]  DEFAULT ('A') FOR [USR_Status]
GO
ALTER TABLE [dbo].[ROLE] ADD  CONSTRAINT [DF__ROLE__USR_LastUp__34E8D562]  DEFAULT (suser_sname()) FOR [USR_LastUpdateUser]
GO
ALTER TABLE [dbo].[ROLE] ADD  CONSTRAINT [DF__ROLE__DBS_LastUp__35DCF99B]  DEFAULT (sysdatetimeoffset()) FOR [DBS_LastUpdateDateTime]
GO
ALTER TABLE [dbo].[ROLE] ADD  CONSTRAINT [DF__ROLE__DBS_Creati__36D11DD4]  DEFAULT (sysdatetimeoffset()) FOR [DBS_CreationDateTime]
GO
ALTER TABLE [dbo].[ROLE] ADD  CONSTRAINT [DF__ROLE__DBS_LastUp__37C5420D]  DEFAULT (suser_sname()) FOR [DBS_LastUpdateUser]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRIG__ROLE__]
    ON [dbo].[ROLE] FOR INSERT, UPDATE AS

   SET NOCOUNT ON

   /*=================================================================
   **  (1)  UPDATE THE LAST USERID AND DATETIME FIELDS AUTOMATICALLY. 
   **================================================================*/
   IF(UPDATE(DBS_CreationDateTime) AND EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.RoleId = d.RoleId WHERE i.DBS_CreationDateTime <> d.DBS_CreationDateTime))
   BEGIN 
       RAISERROR ('DBS_CreationDateTime cannot change.', 16, 1);
       ROLLBACK TRAN
   END
   
   UPDATE dbo.[ROLE] 
      SET DBS_LastUpdateUser     = SYSTEM_USER,
          DBS_LastUpdateDateTime = SYSDATETIMEOFFSET()
     FROM dbo.[ROLE] D,
          INSERTED I
    WHERE D.RoleId = I.RoleId


GO
ALTER TABLE [dbo].[ROLE] ENABLE TRIGGER [TRIG__ROLE__]
GO
