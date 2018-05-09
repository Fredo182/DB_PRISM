SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ATTACHMENT](
	[AttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [varchar](255) NOT NULL,
	[FileType] [varchar](50) NOT NULL,
	[File] [varbinary](max) NOT NULL,
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
SET ANSI_PADDING ON

GO
ALTER TABLE [dbo].[ATTACHMENT] ADD  CONSTRAINT [PK__ATTACHMENT__8AFACE1A3118447E] PRIMARY KEY CLUSTERED 
(
	[AttachmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ATTACHMENT] ADD  CONSTRAINT [UQ_ATTACHMENT] UNIQUE NONCLUSTERED 
(
	[AttachmentId] ASC,
    [FileName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ATTACHMENT] ADD  CONSTRAINT [DF__ATTACHMENT__META_Lock__33F4B129]  DEFAULT ((0)) FOR [META_Lock]
GO
ALTER TABLE [dbo].[ATTACHMENT] ADD  CONSTRAINT [DF__ATTACHMENT__USR_Status__33F4B129]  DEFAULT ('A') FOR [USR_Status]
GO
ALTER TABLE [dbo].[ATTACHMENT] ADD  CONSTRAINT [DF__ATTACHMENT__USR_LastUp__34E8D562]  DEFAULT (suser_sname()) FOR [USR_LastUpdateUser]
GO
ALTER TABLE [dbo].[ATTACHMENT] ADD  CONSTRAINT [DF__ATTACHMENT__DBS_LastUp__35DCF99B]  DEFAULT (sysdatetimeoffset()) FOR [DBS_LastUpdateDateTime]
GO
ALTER TABLE [dbo].[ATTACHMENT] ADD  CONSTRAINT [DF__ATTACHMENT__DBS_Creati__36D11DD4]  DEFAULT (sysdatetimeoffset()) FOR [DBS_CreationDateTime]
GO
ALTER TABLE [dbo].[ATTACHMENT] ADD  CONSTRAINT [DF__ATTACHMENT__DBS_LastUp__37C5420D]  DEFAULT (suser_sname()) FOR [DBS_LastUpdateUser]
GO
ALTER TABLE [dbo].[ATTACHMENT]  WITH CHECK ADD  CONSTRAINT [FK__ATTACHMENT__Person__68687968] FOREIGN KEY([PersonId])
REFERENCES [dbo].[PERSON] ([PersonId])
GO
ALTER TABLE [dbo].[ATTACHMENT] CHECK CONSTRAINT [FK__ATTACHMENT__Person__68687968]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRIG__ATTACHMENT__]
    ON [dbo].[ATTACHMENT] FOR INSERT, UPDATE AS

   SET NOCOUNT ON

   /*=================================================================
   **  (1)  UPDATE THE LAST USERID AND DATETIME FIELDS AUTOMATICALLY. 
   **================================================================*/
   IF(UPDATE(DBS_CreationDateTime) AND EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.AttachmentId = d.AttachmentId WHERE i.DBS_CreationDateTime <> d.DBS_CreationDateTime))
   BEGIN 
       RAISERROR ('DBS_CreationDateTime cannot change.', 16, 1);
       ROLLBACK TRAN
   END
   
   UPDATE dbo.[ATTACHMENT] 
      SET DBS_LastUpdateUser     = SYSTEM_USER,
          DBS_LastUpdateDateTime = SYSDATETIMEOFFSET()
     FROM dbo.[ATTACHMENT] D,
          INSERTED I
    WHERE D.AttachmentId = I.AttachmentId





GO
ALTER TABLE [dbo].[ATTACHMENT] ENABLE TRIGGER [TRIG__ATTACHMENT__]
GO
