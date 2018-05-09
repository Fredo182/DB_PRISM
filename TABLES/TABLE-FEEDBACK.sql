SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FEEDBACK](
	[FeedbackId] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[Feature] [varchar](255) NULL,
	[Priority] [int] NULL,
	[CreateTime] [datetimeoffset](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[FeedbackTypeId] [int] NOT NULL,
	[FeedbackStatusId] [int] NOT NULL,
	[META_Lock] [bit] NOT NULL,
	[USR_Status] [char](1) NOT NULL,
	[USR_LastUpdateUser] [varchar](50) NOT NULL,
	[DBS_LastUpdateDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_CreationDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_LastUpdateUser] [varchar](50) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[FEEDBACK] ADD  CONSTRAINT [PK__FEEDBACK__8AFACE1A3118447E] PRIMARY KEY CLUSTERED 
(
	[FeedbackId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
ALTER TABLE [dbo].[FEEDBACK] ADD  CONSTRAINT [UQ_FEEDBACK] UNIQUE NONCLUSTERED 
(
	[FeedbackId] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FEEDBACK] ADD  CONSTRAINT [DF__FEEDBACK__META_Lock__33F4B129]  DEFAULT ((0)) FOR [META_Lock]
GO
ALTER TABLE [dbo].[FEEDBACK] ADD  CONSTRAINT [DF__FEEDBACK__USR_Status__33F4B129]  DEFAULT ('A') FOR [USR_Status]
GO
ALTER TABLE [dbo].[FEEDBACK] ADD  CONSTRAINT [DF__FEEDBACK__USR_LastUp__34E8D562]  DEFAULT (suser_sname()) FOR [USR_LastUpdateUser]
GO
ALTER TABLE [dbo].[FEEDBACK] ADD  CONSTRAINT [DF__FEEDBACK__DBS_LastUp__35DCF99B]  DEFAULT (sysdatetimeoffset()) FOR [DBS_LastUpdateDateTime]
GO
ALTER TABLE [dbo].[FEEDBACK] ADD  CONSTRAINT [DF__FEEDBACK__DBS_Creati__36D11DD4]  DEFAULT (sysdatetimeoffset()) FOR [DBS_CreationDateTime]
GO
ALTER TABLE [dbo].[FEEDBACK] ADD  CONSTRAINT [DF__FEEDBACK__DBS_LastUp__37C5420D]  DEFAULT (suser_sname()) FOR [DBS_LastUpdateUser]
GO
ALTER TABLE [dbo].[FEEDBACK]  WITH CHECK ADD  CONSTRAINT [FK__FEEDBACK__Person__68687968] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[PERSON] ([PersonId])
GO
ALTER TABLE [dbo].[FEEDBACK] CHECK CONSTRAINT [FK__FEEDBACK__Person__68687968]
GO
ALTER TABLE [dbo].[FEEDBACK]  WITH CHECK ADD  CONSTRAINT [FK__FEEDBACK__Status__68687968] FOREIGN KEY([FeedbackStatusId])
REFERENCES [dbo].[FEEDBACK_STATUS] ([FeedbackStatusId])
GO
ALTER TABLE [dbo].[FEEDBACK] CHECK CONSTRAINT [FK__FEEDBACK__Status__68687968]
GO
ALTER TABLE [dbo].[FEEDBACK]  WITH CHECK ADD  CONSTRAINT [FK__FEEDBACK__Type__68687968] FOREIGN KEY([FeedbackTypeId])
REFERENCES [dbo].[FEEDBACK_TYPE] ([FeedbackTypeId])
GO
ALTER TABLE [dbo].[FEEDBACK] CHECK CONSTRAINT [FK__FEEDBACK__Type__68687968]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRIG__FEEDBACK__]
    ON [dbo].[FEEDBACK] FOR INSERT, UPDATE AS

   SET NOCOUNT ON

   /*=================================================================
   **  (1)  UPDATE THE LAST USERID AND DATETIME FIELDS AUTOMATICALLY. 
   **================================================================*/
   IF(UPDATE(DBS_CreationDateTime) AND EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.FeedbackId = d.FeedbackId WHERE i.DBS_CreationDateTime <> d.DBS_CreationDateTime))
   BEGIN 
       RAISERROR ('DBS_CreationDateTime cannot change.', 16, 1);
       ROLLBACK TRAN
   END
   
   UPDATE dbo.[FEEDBACK] 
      SET DBS_LastUpdateUser     = SYSTEM_USER,
          DBS_LastUpdateDateTime = SYSDATETIMEOFFSET()
     FROM dbo.[FEEDBACK] D,
          INSERTED I
    WHERE D.FeedbackId = I.FeedbackId





GO
ALTER TABLE [dbo].[FEEDBACK] ENABLE TRIGGER [TRIG__FEEDBACK__]
GO
