SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COMMENT](
	[CommentId] [int] IDENTITY(1,1) NOT NULL,
	[Comment] [varchar](max) NOT NULL,
	[PersonId] [int] NOT NULL,
	[CreateTime] [datetimeoffset](7) NOT NULL,
	[META_Lock] [bit] NOT NULL,
	[USR_Status] [char](1) NOT NULL,
	[USR_LastUpdateUser] [varchar](50) NOT NULL,
	[DBS_LastUpdateDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_CreationDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_LastUpdateUser] [varchar](50) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[COMMENT] ADD  CONSTRAINT [PK__COMMENT__8AFACE1A3118447E] PRIMARY KEY CLUSTERED 
(
	[CommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[COMMENT] ADD  CONSTRAINT [UQ_COMMENT] UNIQUE NONCLUSTERED 
(
	[CommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[COMMENT] ADD  CONSTRAINT [DF__COMMENT__META_Lock__33F4B129]  DEFAULT ((0)) FOR [META_Lock]
GO
ALTER TABLE [dbo].[COMMENT] ADD  CONSTRAINT [DF__COMMENT__USR_Status__33F4B129]  DEFAULT ('A') FOR [USR_Status]
GO
ALTER TABLE [dbo].[COMMENT] ADD  CONSTRAINT [DF__COMMENT__USR_LastUp__34E8D562]  DEFAULT (suser_sname()) FOR [USR_LastUpdateUser]
GO
ALTER TABLE [dbo].[COMMENT] ADD  CONSTRAINT [DF__COMMENT__DBS_LastUp__35DCF99B]  DEFAULT (sysdatetimeoffset()) FOR [DBS_LastUpdateDateTime]
GO
ALTER TABLE [dbo].[COMMENT] ADD  CONSTRAINT [DF__COMMENT__DBS_Creati__36D11DD4]  DEFAULT (sysdatetimeoffset()) FOR [DBS_CreationDateTime]
GO
ALTER TABLE [dbo].[COMMENT] ADD  CONSTRAINT [DF__COMMENT__DBS_LastUp__37C5420D]  DEFAULT (suser_sname()) FOR [DBS_LastUpdateUser]
GO
ALTER TABLE [dbo].[COMMENT]  WITH CHECK ADD  CONSTRAINT [FK__COMMENT__Person__68687968] FOREIGN KEY([PersonId])
REFERENCES [dbo].[PERSON] ([PersonId])
GO
ALTER TABLE [dbo].[COMMENT] CHECK CONSTRAINT [FK__COMMENT__Person__68687968]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRIG__COMMENT__]
    ON [dbo].[COMMENT] FOR INSERT, UPDATE AS

   SET NOCOUNT ON

   /*=================================================================
   **  (1)  UPDATE THE LAST USERID AND DATETIME FIELDS AUTOMATICALLY. 
   **================================================================*/
   IF(UPDATE(DBS_CreationDateTime) AND EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.CommentId = d.CommentId WHERE i.DBS_CreationDateTime <> d.DBS_CreationDateTime))
   BEGIN 
       RAISERROR ('DBS_CreationDateTime cannot change.', 16, 1);
       ROLLBACK TRAN
   END
   
   UPDATE dbo.[COMMENT] 
      SET DBS_LastUpdateUser     = SYSTEM_USER,
          DBS_LastUpdateDateTime = SYSDATETIMEOFFSET()
     FROM dbo.[COMMENT] D,
          INSERTED I
    WHERE D.CommentId = I.CommentId




GO
ALTER TABLE [dbo].[COMMENT] ENABLE TRIGGER [TRIG__COMMENT__]
GO
