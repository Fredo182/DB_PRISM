SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PROJECT_ROLE](
	[ProjectRoleId] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
	[USR_Status] [char](1) NOT NULL,
	[USR_LastUpdateUser] [varchar](50) NOT NULL,
	[DBS_LastUpdateDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_CreationDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_LastUpdateUser] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[PROJECT_ROLE] ADD  CONSTRAINT [UQ_PROJECT_ROLE] UNIQUE CLUSTERED 
(
	[ProjectId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PROJECT_ROLE] ADD  CONSTRAINT [PK__PROJECT_ROLE__1A9ADE7C6497E884] PRIMARY KEY NONCLUSTERED 
(
	[ProjectRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PROJECT_ROLE] ADD  DEFAULT ('A') FOR [USR_Status]
GO
ALTER TABLE [dbo].[PROJECT_ROLE] ADD  DEFAULT (suser_sname()) FOR [USR_LastUpdateUser]
GO
ALTER TABLE [dbo].[PROJECT_ROLE] ADD  DEFAULT (sysdatetimeoffset()) FOR [DBS_LastUpdateDateTime]
GO
ALTER TABLE [dbo].[PROJECT_ROLE] ADD  DEFAULT (sysdatetimeoffset()) FOR [DBS_CreationDateTime]
GO
ALTER TABLE [dbo].[PROJECT_ROLE] ADD  DEFAULT (suser_sname()) FOR [DBS_LastUpdateUser]
GO
ALTER TABLE [dbo].[PROJECT_ROLE]  WITH CHECK ADD  CONSTRAINT [FK__PROJECT_ROLE__Project__68687968] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[PROJECT] ([ProjectId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PROJECT_ROLE] CHECK CONSTRAINT [FK__PROJECT_ROLE__Project__68687968]
GO
ALTER TABLE [dbo].[PROJECT_ROLE]  WITH CHECK ADD  CONSTRAINT [FK__PROJECT_ROLE__Role__68687968] FOREIGN KEY([RoleId])
REFERENCES [dbo].[ROLE] ([RoleId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PROJECT_ROLE] CHECK CONSTRAINT [FK__PROJECT_ROLE__Role__68687968]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRIG__PROJECT_ROLE__]
    ON [dbo].[PROJECT_ROLE] FOR INSERT, UPDATE AS

   SET NOCOUNT ON

   /*=================================================================
   **  (1)  UPDATE THE LAST USERID AND DATETIME FIELDS AUTOMATICALLY. 
   **================================================================*/
   IF(UPDATE(DBS_CreationDateTime) AND EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ProjectRoleId = d.ProjectRoleId WHERE i.DBS_CreationDateTime <> d.DBS_CreationDateTime))
   BEGIN 
       RAISERROR ('DBS_CreationDateTime cannot change.', 16, 1);
       ROLLBACK TRAN
   END
   
   UPDATE dbo.PROJECT_ROLE 
      SET DBS_LastUpdateUser     = SYSTEM_USER,
          DBS_LastUpdateDateTime = SYSDATETIMEOFFSET()
     FROM dbo.PROJECT_ROLE D,
          INSERTED I
    WHERE D.ProjectRoleId = I.ProjectRoleId



GO
ALTER TABLE [dbo].[PROJECT_ROLE] ENABLE TRIGGER [TRIG__PROJECT_ROLE__]
GO
