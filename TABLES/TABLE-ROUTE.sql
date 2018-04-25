SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROUTE](
	[RouteId] [int] IDENTITY(1,1) NOT NULL,
	[Route] [varchar](255) NOT NULL,
	[Name] [varchar](255) NULL,
	[Description] [varchar](255) NULL,
	[USR_Status] [char](1) NOT NULL,
	[USR_LastUpdateUser] [varchar](50) NOT NULL,
	[DBS_LastUpdateDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_CreationDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_LastUpdateUser] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ROUTE] ADD  CONSTRAINT [PK__ELEMENT__A429721A4F9CCB9E] PRIMARY KEY CLUSTERED 
(
	[RouteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
ALTER TABLE [dbo].[ROUTE] ADD  CONSTRAINT [UQ_ELEMENT] UNIQUE NONCLUSTERED 
(
	[Route] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROUTE] ADD  CONSTRAINT [DF__ROUTE__USR_Sta__52793849]  DEFAULT ('A') FOR [USR_Status]
GO
ALTER TABLE [dbo].[ROUTE] ADD  CONSTRAINT [DF__ROUTE__USR_Las__536D5C82]  DEFAULT (suser_sname()) FOR [USR_LastUpdateUser]
GO
ALTER TABLE [dbo].[ROUTE] ADD  CONSTRAINT [DF__ROUTE__DBS_Las__546180BB]  DEFAULT (sysdatetimeoffset()) FOR [DBS_LastUpdateDateTime]
GO
ALTER TABLE [dbo].[ROUTE] ADD  CONSTRAINT [DF__ROUTE__DBS_Cre__5555A4F4]  DEFAULT (sysdatetimeoffset()) FOR [DBS_CreationDateTime]
GO
ALTER TABLE [dbo].[ROUTE] ADD  CONSTRAINT [DF__ROUTE__DBS_Las__5649C92D]  DEFAULT (suser_sname()) FOR [DBS_LastUpdateUser]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[TRIG__ROUTE__]
    ON [dbo].[ROUTE] FOR INSERT, UPDATE AS

   SET NOCOUNT ON


   /*=================================================================
   **  (1)  UPDATE THE LAST USERID AND DATETIME FIELDS AUTOMATICALLY. 
   **================================================================*/
   IF(UPDATE(DBS_CreationDateTime) AND EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.RouteId = d.RouteId WHERE i.DBS_CreationDateTime <> d.DBS_CreationDateTime))
   BEGIN 
       RAISERROR ('DBS_CreationDateTime cannot change.', 16, 1);
       ROLLBACK TRAN
   END
   
   UPDATE dbo.ROUTE 
      SET DBS_LastUpdateUser     = SYSTEM_USER,
          DBS_LastUpdateDateTime = SYSDATETIMEOFFSET()
     FROM dbo.ROUTE D,
          INSERTED I
    WHERE D.RouteId = I.RouteId

GO
ALTER TABLE [dbo].[ROUTE] ENABLE TRIGGER [TRIG__ROUTE__]
GO
