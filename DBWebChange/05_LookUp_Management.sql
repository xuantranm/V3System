GO
/****** Object:  Table [dbo].[LookUp]    Script Date: 09/10/2014 10:32:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LookUp]') AND type in (N'U'))
DROP TABLE [dbo].[LookUp]
GO

CREATE TABLE [dbo].[LookUp](
	[LookUpId] [int] IDENTITY(1,1) NOT NULL,
	[LookUpType] [nvarchar](50) NULL,
	[LookUpKey] [nvarchar](100) NULL,
	[LookUpValue] [nvarchar](200) NULL,
	[Enable] [bit] NULL,
 CONSTRAINT [PK_LookUp] PRIMARY KEY CLUSTERED 
(
	[LookUpId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
DELETE [dbo].[LookUp]
GO
DBCC CHECKIDENT('LookUp', RESEED, 1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('department','1','Accounting',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('department','2','PE',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('department','3','Store',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('department','4','Administrator',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('department','5','Developement',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('projectstatus','1','Open',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('projectstatus','2','Completed',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('projectstatus','3','Cancel',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('pricestatus','1','Exist',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('pricestatus','2','No use',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('requisitionstatus','1','Open',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('requisitionstatus','2','Complete',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('requisitionstatus','2','Cancel',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('right','0','None',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('right','1','Read',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('right','2','Add',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('right','3','Edit',1)
GO
INSERT INTO [dbo].[LookUp]([LookUpType],[LookUpKey],[LookUpValue],[Enable])
     VALUES ('right','4','Delete',1)
GO
SELECT * FROM dbo.[LookUp]