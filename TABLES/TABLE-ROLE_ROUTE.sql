SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLE_ROUTE](
	[RoleRouteId] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[RouteId] [int] NOT NULL,
	[Admin] [bit] NOT NULL,
	[Create] [bit] NOT NULL,
	[Read] [bit] NOT NULL,
	[Update] [bit] NOT NULL,
	[Delete] [bit] NOT NULL,
	[ACRUD]  AS (((([Admin]*(16)+[Create]*(8))+[Read]*(4))+[Update]*(2))+[Delete]*(1)),
	[IsACRUD]  AS (((([Admin]|[Create])|[Read])|[Update])|[Delete]),
	[META_Lock] [bit] NOT NULL,
	[USR_Status] [char](1) NOT NULL,
	[USR_LastUpdateUser] [varchar](50) NOT NULL,
	[DBS_LastUpdateDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_CreationDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_LastUpdateUser] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ROLE_ROUTE] ADD  CONSTRAINT [UQ_ROLE_ROUTE] UNIQUE CLUSTERED 
(
	[RoleId] ASC,
	[RouteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROLE_ROUTE] ADD  CONSTRAINT [PK__ROLE_ROUTE__1A9ADE7C6497E884] PRIMARY KEY NONCLUSTERED 
(
	[RoleRouteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROLE_ROUTE] ADD  DEFAULT ((0)) FOR [Admin]
GO
ALTER TABLE [dbo].[ROLE_ROUTE] ADD  DEFAULT ((0)) FOR [Create]
GO
ALTER TABLE [dbo].[ROLE_ROUTE] ADD  DEFAULT ((0)) FOR [Read]
GO
ALTER TABLE [dbo].[ROLE_ROUTE] ADD  DEFAULT ((0)) FOR [Update]
GO
ALTER TABLE [dbo].[ROLE_ROUTE] ADD  DEFAULT ((0)) FOR [Delete]
GO
ALTER TABLE [dbo].[ROLE_ROUTE] ADD  DEFAULT (0) FOR [META_Lock]
GO
ALTER TABLE [dbo].[ROLE_ROUTE] ADD  DEFAULT ('A') FOR [USR_Status]
GO
ALTER TABLE [dbo].[ROLE_ROUTE] ADD  DEFAULT (suser_sname()) FOR [USR_LastUpdateUser]
GO
ALTER TABLE [dbo].[ROLE_ROUTE] ADD  DEFAULT (sysdatetimeoffset()) FOR [DBS_LastUpdateDateTime]
GO
ALTER TABLE [dbo].[ROLE_ROUTE] ADD  DEFAULT (sysdatetimeoffset()) FOR [DBS_CreationDateTime]
GO
ALTER TABLE [dbo].[ROLE_ROUTE] ADD  DEFAULT (suser_sname()) FOR [DBS_LastUpdateUser]
GO
ALTER TABLE [dbo].[ROLE_ROUTE]  WITH CHECK ADD  CONSTRAINT [FK__ROLE_ROUTE__Role__68687968] FOREIGN KEY([RoleId])
REFERENCES [dbo].[ROLE] ([RoleId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ROLE_ROUTE] CHECK CONSTRAINT [FK__ROLE_ROUTE__Role__68687968]
GO
ALTER TABLE [dbo].[ROLE_ROUTE]  WITH CHECK ADD  CONSTRAINT [FK__ROLE_ROUTE__Route__68687968] FOREIGN KEY([RouteId])
REFERENCES [dbo].[ROUTE] ([RouteId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ROLE_ROUTE] CHECK CONSTRAINT [FK__ROLE_ROUTE__Route__68687968]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRIG__ROLE_ROUTE__]
    ON [dbo].[ROLE_ROUTE] FOR INSERT, UPDATE AS

   SET NOCOUNT ON

   /*=================================================================
   **  (1)  UPDATE THE LAST USERID AND DATETIME FIELDS AUTOMATICALLY. 
   **================================================================*/
   IF(UPDATE(DBS_CreationDateTime) AND EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.RoleRouteId = d.RoleRouteId WHERE i.DBS_CreationDateTime <> d.DBS_CreationDateTime))
   BEGIN 
       RAISERROR ('DBS_CreationDateTime cannot change.', 16, 1);
       ROLLBACK TRAN
   END
   
   UPDATE dbo.ROLE_ROUTE 
      SET DBS_LastUpdateUser     = SYSTEM_USER,
          DBS_LastUpdateDateTime = SYSDATETIMEOFFSET()
     FROM dbo.ROLE_ROUTE D,
          INSERTED I
    WHERE D.RoleRouteId = I.RoleRouteId


GO
ALTER TABLE [dbo].[ROLE_ROUTE] ENABLE TRIGGER [TRIG__ROLE_ROUTE__]
GO
