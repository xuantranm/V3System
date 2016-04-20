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

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[XDynamicReport]') AND type in (N'U'))
DROP TABLE [dbo].[XDynamicReport]
GO
CREATE TABLE [dbo].[XDynamicReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Action] [nvarchar](20) NULL,
	[POId] [int] NULL,
	[PODate] [datetime] NULL,
	[POCode] [nvarchar](16) NOT NULL,
	[POTypeId] [int] NULL,
	[POType] [varchar](50) NULL,
	[ProjectId] [int] NULL,
	[ProjectCode] [nvarchar](20) NULL,
	[ProjectName] [nvarchar](64) NULL,
	[StockId] [int] NULL,
	[StockCode] [nvarchar](16) NULL,
	[StockName] [nvarchar](2000) NULL,
	[StockTypeId] [int] NULL,
	[StockType] [nvarchar](250) NULL,
	[MRF] [nvarchar](200) NULL,
	[CategoryId] [int] NULL,
	[Category] [nvarchar](64) NULL,
	[SupplierId] [int] NULL,
	[Supplier] [nvarchar](64) NULL,
	[UnitId] [int] NULL,
	[Unit] [nvarchar](64) NULL,
	[Quantity] [decimal](18, 2) NULL,
	[QuantityReceived] [decimal](18, 2) NULL,
	[QuantityPending] [decimal](18, 2) NULL,
	[RalNo] [nvarchar](50) NULL,
	[Color] [nvarchar](64) NULL,
    [Weight] [nvarchar](20) NULL,
    [Note] [nvarchar](max) NULL,
	[Created] [datetime] NULL,
	[Modified] [datetime] NULL,
	[CreatedBy] [nvarchar](500) NULL,
	[ModifiedBy] [nvarchar](500) NULL
 CONSTRAINT [PK_XDynamicReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT INTO [dbo].[XDynamicReport]
SELECT po.vPODetailStatus, poMaster.Id, poMaster.dPODate, poMaster.vPOID, poType.bPOTypeID, poType.vPOTypeName,
project.Id, project.vProjectID, project.vProjectName, stock.Id, stock.vStockID, stock.vStockName
,stockType.Id, stockType.TypeName, po.vMRF, category.bCategoryID, category.vCategoryName
,supplier.bSupplierID, supplier.vSupplierName 
,unit.bUnitID ,unit.vUnitName
,po.fQuantity, fulfill.dReceivedQuantity, fulfill.dPendingQuantity
,NULL,NULL,stock.bWeight,NULL,NULL,NULL,NULL,NULL
FROM WAMS_PO_DETAILS po
INNER JOIN WAMS_STOCK stock ON po.vProductID = stock.Id
INNER JOIN WAMS_STOCK_TYPE stockType ON stockType.Id = stock.iType
INNER JOIN WAMS_UNIT unit ON unit.bUnitID = stock.bUnitID
INNER JOIN WAMS_CATEGORY category On category.bCategoryID = stock.bCategoryID
INNER JOIN WAMS_PURCHASE_ORDER poMaster ON poMaster.Id = po.vPOID
INNER JOIN WAMS_PO_TYPE poType ON poType.bPOTypeID = poMaster.bPOTypeID
INNER JOIN WAMS_SUPPLIER supplier ON supplier.bSupplierID = poMaster.bSupplierID
INNER JOIN WAMS_PROJECT project ON poMaster.vProjectID = project.Id
INNER JOIN WAMS_FULFILLMENT_DETAIL fulfill ON fulfill.vPOID = poMaster.Id
ORDER BY poMaster.dPODate ASC



