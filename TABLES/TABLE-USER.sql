SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USER](
	[UserId] [int] NOT NULL,
	[SysAdmin] [bit] NOT NULL,
    [META_Lock] [bit] NOT NULL,
	[USR_Status] [char](1) NOT NULL,
	[USR_LastUpdateUser] [varchar](50) NOT NULL,
	[DBS_LastUpdateDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_CreationDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_LastUpdateUser] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[USER] ADD  CONSTRAINT [PK__USER__1788CC4C117F9D94] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[USER] ADD  CONSTRAINT [UQ_USER] UNIQUE NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[USER] ADD  CONSTRAINT [DF__USER__IsSysAdmin__4F089A18]  DEFAULT ((0)) FOR [SysAdmin]
GO
ALTER TABLE [dbo].[USER] ADD  CONSTRAINT [DF__USER__META_Lock__1367E606]  DEFAULT (0) FOR [META_Lock]
GO
ALTER TABLE [dbo].[USER] ADD  CONSTRAINT [DF__USER__USR_Status__1367E606]  DEFAULT ('A') FOR [USR_Status]
GO
ALTER TABLE [dbo].[USER] ADD  CONSTRAINT [DF__USER__USR_LastUp__145C0A3F]  DEFAULT (suser_sname()) FOR [USR_LastUpdateUser]
GO
ALTER TABLE [dbo].[USER] ADD  CONSTRAINT [DF__USER__DBS_LastUp__15502E78]  DEFAULT (sysdatetimeoffset()) FOR [DBS_LastUpdateDateTime]
GO
ALTER TABLE [dbo].[USER] ADD  CONSTRAINT [DF__USER__DBS_Creati__164452B1]  DEFAULT (sysdatetimeoffset()) FOR [DBS_CreationDateTime]
GO
ALTER TABLE [dbo].[USER] ADD  CONSTRAINT [DF__USER__DBS_LastUp__173876EA]  DEFAULT (suser_sname()) FOR [DBS_LastUpdateUser]
GO
ALTER TABLE [dbo].[USER]  WITH CHECK ADD  CONSTRAINT [FK_USER_PERSON] FOREIGN KEY([UserId])
REFERENCES [dbo].[PERSON] ([PersonId])
GO
ALTER TABLE [dbo].[USER] CHECK CONSTRAINT [FK_USER_PERSON]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRIG__USER__]
    ON [dbo].[USER] FOR INSERT, UPDATE AS

   SET NOCOUNT ON

   /*=================================================================
   **  (1)  UPDATE THE LAST USERID AND DATETIME FIELDS AUTOMATICALLY. 
   **================================================================*/
   IF(UPDATE(DBS_CreationDateTime) AND EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.UserId = d.UserId WHERE i.DBS_CreationDateTime <> d.DBS_CreationDateTime))
   BEGIN 
       RAISERROR ('DBS_CreationDateTime cannot change.', 16, 1);
       ROLLBACK TRAN
   END
   
   UPDATE dbo.[USER] 
      SET DBS_LastUpdateUser     = SYSTEM_USER,
          DBS_LastUpdateDateTime = SYSDATETIMEOFFSET()
     FROM dbo.[USER] D,
          INSERTED I
    WHERE D.UserId = I.UserId


GO
ALTER TABLE [dbo].[USER] ENABLE TRIGGER [TRIG__USER__]
GO
