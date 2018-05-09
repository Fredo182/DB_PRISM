SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PERSON](
	[PersonId] [int] IDENTITY(1,1) NOT NULL,
	[DisplayName] [varchar](50) NOT NULL,
	[IsEmployee] [bit] NOT NULL,
	[NTID] [varchar](50) NOT NULL,
	[EmployeeID] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[PrimaryPhone] [varchar](50) NULL,
	[Domain] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[EWPPersonId] [varchar](50) NULL,
	[JobTitle] [varchar](50) NULL,
	[Company] [varchar](50) NULL,
	[META_Lock] [bit] NOT NULL,
	[USR_Status] [char](1) NOT NULL,
	[USR_LastUpdateUser] [varchar](50) NOT NULL,
	[DBS_LastUpdateDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_CreationDateTime] [datetimeoffset](7) NOT NULL,
	[DBS_LastUpdateUser] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[PERSON] ADD PRIMARY KEY CLUSTERED 
(
	[PersonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
ALTER TABLE [dbo].[PERSON] ADD  CONSTRAINT [UQ_PERSON] UNIQUE NONCLUSTERED 
(
	[NTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PERSON] ADD  CONSTRAINT [DF_PERSON_IsEmployee]  DEFAULT ((0)) FOR [IsEmployee]
GO
ALTER TABLE [dbo].[PERSON] ADD  CONSTRAINT [DF__PERSON__META_Lock__5EBF139D]  DEFAULT (0) FOR [META_Lock]
GO
ALTER TABLE [dbo].[PERSON] ADD  CONSTRAINT [DF__PERSON__USR_Stat__5EBF139D]  DEFAULT ('A') FOR [USR_Status]
GO
ALTER TABLE [dbo].[PERSON] ADD  CONSTRAINT [DF__PERSON__USR_Last__5FB337D6]  DEFAULT (suser_sname()) FOR [USR_LastUpdateUser]
GO
ALTER TABLE [dbo].[PERSON] ADD  CONSTRAINT [DF__PERSON__DBS_Last__60A75C0F]  DEFAULT (sysdatetimeoffset()) FOR [DBS_LastUpdateDateTime]
GO
ALTER TABLE [dbo].[PERSON] ADD  CONSTRAINT [DF__PERSON__DBS_Crea__619B8048]  DEFAULT (sysdatetimeoffset()) FOR [DBS_CreationDateTime]
GO
ALTER TABLE [dbo].[PERSON] ADD  CONSTRAINT [DF__PERSON__DBS_Last__628FA481]  DEFAULT (suser_sname()) FOR [DBS_LastUpdateUser]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRIG__PERSON__]
    ON [dbo].[PERSON] FOR INSERT, UPDATE AS

   SET NOCOUNT ON


   /*=================================================================
   **  (1)  UPDATE THE LAST USERID AND DATETIME FIELDS AUTOMATICALLY. 
   **================================================================*/
   IF(UPDATE(DBS_CreationDateTime) AND EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.PersonId = d.PersonId WHERE i.DBS_CreationDateTime <> d.DBS_CreationDateTime))
   BEGIN 
       RAISERROR ('DBS_CreationDateTime cannot change.', 16, 1);
       ROLLBACK TRAN
   END
   
   UPDATE dbo.PERSON 
      SET DBS_LastUpdateUser      = SYSTEM_USER,
          DBS_LastUpdateDateTime = SYSDATETIMEOFFSET()
     FROM dbo.PERSON D,
          INSERTED I
    WHERE D.PersonId = I.PersonId



GO
ALTER TABLE [dbo].[PERSON] ENABLE TRIGGER [TRIG__PERSON__]
GO
