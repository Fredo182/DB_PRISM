SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PROJECT](
	[ProjectId] [int] IDENTITY(1,1) NOT NULL,
	[Project] [varchar](50) NOT NULL,
	[Description] [varchar](255) NULL,
	[USR_Status] [char](1) NOT NULL,
	[USR_LastUpdateUser] [varchar](50) NOT NULL,
	[DBS_LastUpdateDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_CreationDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_LastUpdateUser] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[PROJECT] ADD  CONSTRAINT [PK__PROJECT__8AFACE1A3118447E] PRIMARY KEY CLUSTERED 
(
	[ProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
ALTER TABLE [dbo].[PROJECT] ADD  CONSTRAINT [UQ_PROJECT] UNIQUE NONCLUSTERED 
(
	[Project] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PROJECT] ADD  CONSTRAINT [DF__PROJECT__USR_Status__33F4B129]  DEFAULT ('A') FOR [USR_Status]
GO
ALTER TABLE [dbo].[PROJECT] ADD  CONSTRAINT [DF__PROJECT__USR_LastUp__34E8D562]  DEFAULT (suser_sname()) FOR [USR_LastUpdateUser]
GO
ALTER TABLE [dbo].[PROJECT] ADD  CONSTRAINT [DF__PROJECT__DBS_LastUp__35DCF99B]  DEFAULT (sysdatetimeoffset()) FOR [DBS_LastUpdateDateTime]
GO
ALTER TABLE [dbo].[PROJECT] ADD  CONSTRAINT [DF__PROJECT__DBS_Creati__36D11DD4]  DEFAULT (sysdatetimeoffset()) FOR [DBS_CreationDateTime]
GO
ALTER TABLE [dbo].[PROJECT] ADD  CONSTRAINT [DF__PROJECT__DBS_LastUp__37C5420D]  DEFAULT (suser_sname()) FOR [DBS_LastUpdateUser]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRIG__PROJECT__]
    ON [dbo].[PROJECT] FOR INSERT, UPDATE AS

   SET NOCOUNT ON

   /*=================================================================
   **  (1)  UPDATE THE LAST USERID AND DATETIME FIELDS AUTOMATICALLY. 
   **================================================================*/
   IF(UPDATE(DBS_CreationDateTime) AND EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ProjectId = d.ProjectId WHERE i.DBS_CreationDateTime <> d.DBS_CreationDateTime))
   BEGIN 
       RAISERROR ('DBS_CreationDateTime cannot change.', 16, 1);
       ROLLBACK TRAN
   END
   
   UPDATE dbo.[PROJECT] 
      SET DBS_LastUpdateUser     = SYSTEM_USER,
          DBS_LastUpdateDateTime = SYSDATETIMEOFFSET()
     FROM dbo.[PROJECT] D,
          INSERTED I
    WHERE D.ProjectId = I.ProjectId



GO
ALTER TABLE [dbo].[PROJECT] ENABLE TRIGGER [TRIG__PROJECT__]
GO
