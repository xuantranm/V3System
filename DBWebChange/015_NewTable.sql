GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[XUser]') AND type in (N'U'))
DROP TABLE [dbo].[XUser]
GO
CREATE TABLE [dbo].[XUser](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](500) NOT NULL,
	[Password] [varchar](64) NOT NULL,
	[FirstName] [nvarchar](64) NULL,
	[LastName] [nvarchar](64) NULL,
	[DepartmentId] [int] NULL,
	[Department] [nvarchar](64) NULL,
	[Telephone] [nvarchar](32) NULL,
	[Mobile] [nvarchar](32) NULL,
	[Email] [nvarchar](64) NULL,
	[Enable] [bit] NULL,
	[StoreId] [int] NULL,
	[Store] [nvarchar] (200) NULL,
	[UserR] [int] NULL,
	[ProjectR] [int] NULL,
	[StoreR] [int] NULL,
	[StockR] [int] NULL,
	[RequisitionR] [int] NULL,
	[StockOutR] [int] NULL,
	[StockReturnR] [int] NULL,
	[StockInR] [int] NULL,
	[ReActiveStockR] [int] NULL,
	[PER] [int] NULL,
	[SupplierR] [int] NULL,
	[PriceR] [int] NULL,
	[StockServiceR] [int] NULL,
	[AccountingR] [int] NULL,
	[MaintenanceR] [int] NULL,
	[WorkerR] [int] NULL,
	[ShippmentR] [int] NULL,
	[ReturnSupplierR] [int] NULL,
	[StockTypeR] [int] NULL,
	[CategoryR] [int] NULL,
	[Created] [datetime] NULL,
	[Modified] [datetime] NULL,
	[CreatedBy] int NULL,
	[ModifiedBy] int NULL,
	[Timestamp] [timestamp] NOT NULL
 CONSTRAINT [PK_XUser] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


