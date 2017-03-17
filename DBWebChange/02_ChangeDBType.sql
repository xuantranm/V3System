-- WAMS_ASSIGNNING_STOCKS
ALTER TABLE WAMS_ASSIGNNING_STOCKS
DROP CONSTRAINT PK_WAMS_ASSIGNNING_STOCKS
GO
ALTER TABLE WAMS_ASSIGNNING_STOCKS ALTER COLUMN bAssignningStockID int
GO
ALTER TABLE WAMS_ASSIGNNING_STOCKS
ADD CONSTRAINT PK_WAMS_ASSIGNNING_STOCKS PRIMARY KEY (bAssignningStockID)
GO
-- WAMS_CURRENCY_TYPE
ALTER TABLE WAMS_PURCHASE_ORDER
DROP CONSTRAINT FK_WAMS_PURCHASE_ORDER_WAMS_CURRENCY_TYPE
GO
ALTER TABLE WAMS_CURRENCY_TYPE
DROP CONSTRAINT PK_WAMS_CURRENCY_TYPE
GO
ALTER TABLE WAMS_CURRENCY_TYPE ALTER COLUMN bCurrencyTypeID int
GO
ALTER TABLE WAMS_CURRENCY_TYPE
ADD CONSTRAINT PK_WAMS_CURRENCY_TYPE PRIMARY KEY (bCurrencyTypeID)
GO
ALTER TABLE WAMS_PURCHASE_ORDER ALTER COLUMN bCurrencyTypeID int
GO
ALTER TABLE WAMS_PURCHASE_ORDER  WITH CHECK ADD  CONSTRAINT FK_WAMS_PURCHASE_ORDER_WAMS_CURRENCY_TYPE FOREIGN KEY(bCurrencyTypeID)
REFERENCES WAMS_CURRENCY_TYPE (bCurrencyTypeID)
GO
-- WAMS_USER
ALTER TABLE WAMS_USER
DROP CONSTRAINT PK_WAMS_USER
GO
ALTER TABLE WAMS_USER ALTER COLUMN bUserId int
GO
ALTER TABLE WAMS_USER
ADD CONSTRAINT PK_WAMS_USER PRIMARY KEY (bUserId)
GO
--WAMS_FUNCTION_MANAGEMENT
ALTER TABLE WAMS_FUNCTION_MANAGEMENT
DROP CONSTRAINT PK_WAMS_FUNCTION_MANAGEMENT
GO
ALTER TABLE WAMS_FUNCTION_MANAGEMENT ALTER COLUMN bFunctionID int
GO
ALTER TABLE WAMS_FUNCTION_MANAGEMENT ALTER COLUMN bUserID int
GO
ALTER TABLE WAMS_FUNCTION_MANAGEMENT
ADD CONSTRAINT PK_WAMS_FUNCTION_MANAGEMENT PRIMARY KEY (bFunctionID)
GO
-- WAMS_RETURN_LIST
ALTER TABLE WAMS_RETURN_LIST
DROP CONSTRAINT PK_WAMS_RETURN_LIST
GO
ALTER TABLE WAMS_RETURN_LIST ALTER COLUMN bReturnListID int
GO
ALTER TABLE WAMS_RETURN_LIST
ADD CONSTRAINT PK_WAMS_RETURN_LIST PRIMARY KEY (bReturnListID)
GO
-- WAMS_SUPPLIER_TYPE
ALTER TABLE WAMS_SUPPLIER
DROP CONSTRAINT FK_WAMS_SUPPLIER_WAMS_SUPPLIER_TYPE
GO
ALTER TABLE WAMS_SUPPLIER_TYPE
DROP CONSTRAINT PK_WAMS_SUPPLIER_TYPE
GO
ALTER TABLE WAMS_SUPPLIER_TYPE ALTER COLUMN bSupplierTypeID int
GO
ALTER TABLE WAMS_SUPPLIER_TYPE
ADD CONSTRAINT PK_WAMS_SUPPLIER_TYPE PRIMARY KEY (bSupplierTypeID)
GO
ALTER TABLE WAMS_SUPPLIER ALTER COLUMN bSupplierTypeID int
GO
ALTER TABLE WAMS_SUPPLIER  WITH CHECK ADD  CONSTRAINT FK_WAMS_SUPPLIER_WAMS_SUPPLIER_TYPE FOREIGN KEY(bSupplierTypeID)
REFERENCES WAMS_SUPPLIER_TYPE (bSupplierTypeID)
GO
--WAMS_PO_TYPE
ALTER TABLE WAMS_PURCHASE_ORDER
DROP CONSTRAINT FK_WAMS_PURCHASE_ORDER_WAMS_PO_TYPE
GO
ALTER TABLE WAMS_PO_TYPE
DROP CONSTRAINT PK_WAMS_PO_TYPE
GO
ALTER TABLE WAMS_PO_TYPE ALTER COLUMN bPOTypeID int
GO
ALTER TABLE WAMS_PO_TYPE
ADD CONSTRAINT PK_WAMS_PO_TYPE PRIMARY KEY (bPOTypeID)
GO
ALTER TABLE WAMS_PURCHASE_ORDER ALTER COLUMN bPOTypeID int
GO
ALTER TABLE WAMS_PURCHASE_ORDER  WITH CHECK ADD  CONSTRAINT FK_WAMS_PURCHASE_ORDER_WAMS_PO_TYPE FOREIGN KEY(bPOTypeID)
REFERENCES WAMS_PO_TYPE (bPOTypeID)
GO
ALTER TABLE dbo.WAMS_RETURN_LIST ALTER COLUMN SRV nvarchar(20)
GO
ALTER TABLE dbo.SRV ALTER COLUMN SRV nvarchar(20)
GO
ALTER TABLE dbo.SRV ALTER COLUMN [Status] nvarchar(20)
GO
ALTER TABLE WAMS_FULFILLMENT_DETAIL ALTER COLUMN SRV nvarchar(20)
GO

-- Document
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Document]') AND type in (N'U'))
DROP TABLE [dbo].[Document]
GO

CREATE TABLE [dbo].[Document](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DocumentURL] [nvarchar](200) NULL,
	[DocumentDescription] [nvarchar](200) NULL,
	[KeyId] [int] NOT NULL,
	[ActionDate] [datetime] NOT NULL,
	[DocumentTypeId] [int] NULL,
	[DocumentName] [nvarchar](200) NULL,
	[DocumentTitle] [nvarchar](200) NULL,
	[FolderLocation] [nvarchar](100) NULL,
	[DocumentFile] [varbinary](max) NULL,
	[ById] [int] NULL,
 CONSTRAINT [PK_Document] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Functions
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Functions]') AND type in (N'U'))
DROP TABLE [dbo].[Functions]
GO
CREATE TABLE [dbo].[Functions](
	[Id] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Functions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- WAMS_USER
ALTER TABLE [dbo].[WAMS_USER] ALTER COLUMN [vPassword] varchar(64) null
GO
ALTER TABLE dbo.WAMS_USER 
ADD	[vNewPassword] nvarchar(500),
	[storeId] int NULL,
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL;
GO

-- WAMS_FUNCTION_MANAGEMENT
ALTER TABLE dbo.WAMS_FUNCTION_MANAGEMENT 
ADD [User] [int] NULL,
	[Project] [int] NULL,
	[Store] [int] NULL,
	[Stock] [int] NULL,
	[Requisition] [int] NULL,
	[StockOut] [int] NULL,
	[StockReturn] [int] NULL,
	[StockIn] [int] NULL,
	[ReActiveStock] [int] NULL,	
	[PE] [int] NULL,
	[Supplier] [int] NULL,
	[Price] [int] NULL,
	[StockService] [int] NULL,	
	[Accounting] [int] NULL,
	[Maintenance] [int] NULL,
	[Worker] [int] NULL,
	[Shippment] [int] NULL,
	[ReturnSupplier] [int] NULL,
	[StockType] [int] NULL,
	[Category] [int] NULL
GO
-- Country
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Country]') AND type in (N'U'))
DROP TABLE [dbo].[Country]
GO
CREATE TABLE [dbo].[Country](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Iso] [char](2) NULL,
	[NameBasic] [nvarchar](80) NOT NULL,
	[NameNice] [nvarchar](80) NULL,
	[Iso3] [char](3) NULL,
	[NumCode] [int] NULL,
	[PhoneCode] [int] NULL,
	[iEnable] [bit] NULL,
	[Timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

-- Store
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Store]') AND type in (N'U'))
DROP TABLE [dbo].[Store]
GO
CREATE TABLE [dbo].[Store](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[CountryId] [int] NULL,
	[Address] [nvarchar](500) NULL,
	[Tel] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[Description] [ntext] NULL,
	
	[PDFHeader] [nvarchar](256) NULL,
	[CoRegNo] [nvarchar](50) NULL,
	[GSTRegNo] [nvarchar](50) NULL,
	[Email] [nvarchar](256) NULL,
	[Website] [nvarchar](256) NULL,
	[PDFFooter] [nvarchar](256) NULL,
	
	[iEnable] [bit],
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL
 CONSTRAINT [PK_Store] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
-- dbo.WAMS_PROJECT 
ALTER TABLE dbo.WAMS_PROJECT 
ADD 
	[StatusId] [int] NULL,
	[ClientId] [int] NULL,
	[CountryId] [int] NULL,
	[Suppervisor] [nvarchar](16) NULL,
	[StoreId] [int] NULL, 
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL,
	[dEnd] [datetime] NULL,
	[EnableRequisition] [bit],
	[EnablePO] [bit]
GO
-- Project_Client
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Project_Client]') AND type in (N'U'))
DROP TABLE [dbo].[Project_Client]
GO
CREATE TABLE [dbo].[Project_Client](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NULL,
	[dCreated] [datetime] NULL,
	[iCreated] [int] NULL,
 CONSTRAINT [PK_Project_Client] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
-- WAMS_STOCK_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WAMS_STOCK_TYPE]') AND type in (N'U'))
DROP TABLE [dbo].[WAMS_STOCK_TYPE]
GO
CREATE TABLE [dbo].[WAMS_STOCK_TYPE](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [varchar](250) NOT NULL,
	[TypeCode] [varchar](50) NULL,
	[iEnable] [bit],
	[Timestamp] [timestamp] NOT NULL,
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL,
 CONSTRAINT [PK_WAMS_STOCK_TYPE] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
-- WAMS_STOCK
ALTER TABLE dbo.WAMS_STOCK 
ADD 
	[Unit] [nvarchar](16) NULL,
	[Category] [nvarchar](64) NULL,
	[Position] [nvarchar](64) NULL,
	[Label] [nvarchar](64) NULL,
	[iType] int,
	[Type] [nvarchar](64) NULL,
	[PartNo] [nvarchar](50) NULL,
	[PartNoFor] [nvarchar](64) NULL,
	[PartNoMiniQty] [int] NULL,
	[RalNo] [nvarchar](50) NULL,
	[ColorName] [nvarchar](64) NULL,
	[SubCategory] [int] NULL,
	[UserForPaint] int NULL,
	[Files] [nvarchar](512) NULL, 
	[OrginalFile] [nvarchar](512) NULL, 
	[FilePath] [nvarchar](512) NULL, 
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL;
GO
ALTER TABLE dbo.WAMS_STOCK ALTER COLUMN bUnitID int
GO
ALTER TABLE dbo.WAMS_STOCK ALTER COLUMN bCategoryID int
GO
ALTER TABLE dbo.WAMS_STOCK ALTER COLUMN bPositionID int
GO
ALTER TABLE dbo.WAMS_STOCK ALTER COLUMN bLabelID int
GO
ALTER TABLE dbo.WAMS_STOCK ALTER COLUMN bWeight float null
GO
ALTER TABLE dbo.WAMS_STOCK ALTER COLUMN vStockType nvarchar(64) null
GO
-- Store_Stock
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Store_Stock]') AND type in (N'U'))
DROP TABLE [dbo].[Store_Stock]
GO
CREATE TABLE dbo.Store_Stock(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Store] [int] NOT NULL,
	[StockID] [int] NOT NULL,
	[Quantity] [decimal](18, 0) NOT NULL,
 CONSTRAINT [PK_Store_Stock] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE dbo.WAMS_UNIT ADD iType int;
GO
ALTER TABLE dbo.WAMS_LABELS ADD iType int;
GO
ALTER TABLE dbo.WAMS_STOCK_MANAGEMENT_QUANTITY 
ADD Country int NULL,
	Store int NULL;
GO
ALTER TABLE dbo.WAMS_STOCK_MANAGEMENT_QUANTITY ALTER COLUMN bUserID int
GO
-- ALTER TABLE WAMS_ASSIGNNING_STOCKS
ALTER TABLE dbo.WAMS_ASSIGNNING_STOCKS 
ADD 
	[FromStore] [int] NULL,
	[ToStore] [int] NULL,
	[DateStockOut] [datetime] NOT NULL,
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL,
	[AccCheck] [int] NULL,
	[AccDescription] nvarchar(200) NULL,
	[AccdCreated] [datetime] NULL,
	[AccdModified] [datetime] NULL,
	[AcciCreated] int NULL,
	[AcciModidied] int NULL,
	[FlagFile] bit NULL
GO
ALTER TABLE [dbo].[WAMS_ASSIGNNING_STOCKS] ADD  CONSTRAINT [DF_WAMS_ASSIGNNING_STOCKS_DateStockOut]  DEFAULT (getdate()) FOR [DateStockOut]
GO

-- WAMS_RETURN_LIST
ALTER TABLE dbo.WAMS_RETURN_LIST 
ADD 
	[FromStore] [int] NULL,
	[ToStore] [int] NULL,
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL,
	[AccCheck] [int] NULL,
	[AccDescription] nvarchar(200) NULL,
	[AccdCreated] [datetime] NULL,
	[AccdModified] [datetime] NULL,
	[AcciCreated] int NULL,
	[AcciModidied] int NULL,
	[FlagFile] bit NULL
GO
ALTER TABLE dbo.WAMS_RETURN_LIST DROP CONSTRAINT [DF_WAMS_RETURN_LIST_bQuantity];
GO
ALTER TABLE dbo.WAMS_RETURN_LIST ALTER COLUMN bQuantity decimal(18,2) 
GO
-- WAMS_SUPPLIER
ALTER TABLE dbo.WAMS_SUPPLIER 
ADD	[CountryId] [int] NULL,
	[iMarket] [bit] NULL,
	[iStore] [int] NULL,
	[iPayment] [int] NULL,
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL;
GO
ALTER TABLE dbo.WAMS_STOCK_MANAGEMENT_QUANTITY ALTER COLUMN bSupplierID int null
GO
ALTER TABLE dbo.WAMS_SUPPLIER ALTER COLUMN vAddress nvarchar(256) null
GO
ALTER TABLE dbo.WAMS_SUPPLIER ALTER COLUMN vContactPerson nvarchar(256) null
GO
ALTER TABLE dbo.WAMS_SUPPLIER ALTER COLUMN vCity nvarchar(64) null
GO
-- WAMS_PRODUCT
ALTER TABLE dbo.WAMS_PRODUCT 
ADD	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL;
GO
-- ALTER TABLE WAMS_REQUISITION_MASTER
ALTER TABLE dbo.WAMS_REQUISITION_MASTER 
ADD [iStore] [int] NULL,
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL;
GO
-- ALTER TABLE WAMS_REQUISITION_DETAILS
ALTER TABLE dbo.WAMS_REQUISITION_DETAILS 
ADD	[iStore] [int] NULL,
	[Remark] NVARCHAR(MAX),
	[dCreated] [datetime] NULL, 
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL;
GO
-- ALTER TABLE WAMS_PURCHASE_ORDER
ALTER TABLE dbo.WAMS_PURCHASE_ORDER 
ADD [Address] NVARCHAR(MAX),
[TaxCode] NVARCHAR(128),
[PeStaff] NVARCHAR(128),
[CoRegNo] NVARCHAR(128),
[GSTRegNo] NVARCHAR(128),
[PengerangSite] NVARCHAR(512),
[GSTAddress] NVARCHAR(512),

	[iStore] [int] NULL,
	[iPayment] [int] NULL,
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL;
GO
-- ALTER TABLE WAMS_PO_DETAILS
ALTER TABLE dbo.WAMS_PO_DETAILS 
ADD [PriceId] int NULL,
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL;
GO
-- Manage Price of PO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Product_Price]') AND type in (N'U'))
DROP TABLE [dbo].[Product_Price]
GO
CREATE TABLE [dbo].[Product_Price](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StockId] [int] NULL,
	[Price] [decimal](18, 2) NULL,
	[StoreId] [int] NULL,
	[SupplierId] [int] NULL,
	[CurrencyId] [int] NULL,
	[dStart] [datetime] NULL,
	[dEnd] [datetime] NULL,
	[Status] [int] NULL,
	[iEnable] [bit] NULL,
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL,
	[Timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_Product_Price] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- WAMS_FULFILLMENT_DETAIL
ALTER TABLE dbo.WAMS_FULFILLMENT_DETAIL 
ADD 
	[iStore] [int] NULL,
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL,
	[AccCheck] [int] NULL,
	[AccDescription] nvarchar(200) NULL,
	[AccdCreated] [datetime] NULL,
	[AccdModified] [datetime] NULL,
	[AcciCreated] int NULL,
	[AcciModidied] int NULL,
	[FlagFile] bit NULL
GO
-- Manage change Code
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Change_Code]') AND type in (N'U'))
DROP TABLE [dbo].[Change_Code]
GO
CREATE TABLE [dbo].[Change_Code](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FunctionId] [int] NOT NULL,
	[OldCode] [varchar](500) NOT NULL,
	[NewCode] [varbinary](500) NOT NULL,
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL,
	[iEnable] [bit] NULL,
	[Timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_Change_Code] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
-- Create PaymentTerm
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentTerm]') AND type in (N'U'))
DROP TABLE [dbo].[PaymentTerm]
GO
CREATE TABLE [dbo].[PaymentTerm](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PaymentName] [nvarchar](500) NULL,
	[iEnable] [bit] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL,
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_PaymentTerm] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SIV]') AND type in (N'U'))
DROP TABLE [dbo].[SIV]
GO
CREATE TABLE [dbo].[SIV](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SIV] [nvarchar](20) NOT NULL,
	[vStatus] [nvarchar](20) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_SIV] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE dbo.WAMS_CATEGORY 
ADD	
	[iType] int NULL,
	[CategoryCode] nvarchar(50) NULL,
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL;
GO
-- WAMS_ITEMS_SERVICE
GO
ALTER TABLE dbo.WAMS_ITEMS_SERVICE 
ADD [StoreId] int NULL,
	[dCreated] [datetime] NULL,
	[dModified] [datetime] NULL,
	[iCreated] [int] NULL,
	[iModified] [int] NULL;
GO
ALTER TABLE dbo.WAMS_ITEMS_SERVICE ALTER COLUMN bUnitID int
GO
ALTER TABLE dbo.WAMS_ITEMS_SERVICE ALTER COLUMN bCategoryID int
GO
ALTER TABLE dbo.WAMS_ITEMS_SERVICE ALTER COLUMN bPositionID int
GO
ALTER TABLE dbo.WAMS_PROJECT ALTER COLUMN vClient NVARCHAR(128) NULL
GO
ALTER TABLE dbo.WAMS_CATEGORY ALTER COLUMN vCategoryType NVARCHAR(64) NULL
GO
ALTER TABLE dbo.WAMS_CATEGORY 
ADD [iEnable] [bit] NULL
GO
ALTER TABLE WAMS_PO_DETAILS ALTER COLUMN vMRF nvarchar(128)
GO
--EXEC sp_RENAME 'WAMS_FULFILLMENT_DETAIL.StockId', 'vStockID', 'COLUMN'
GO
ALTER TABLE WAMS_STOCK_MANAGEMENT_QUANTITY ALTER COLUMN vStatusID nvarchar(30)
GO
ALTER TABLE WAMS_ASSIGNNING_STOCKS ADD [Description] nvarchar(500) NULL
GO
ALTER TABLE WAMS_RETURN_LIST ALTER COLUMN vCondition nvarchar(500) NULL
GO
ALTER TABLE WAMS_STOCK_MANAGEMENT_QUANTITY ALTER COLUMN vMRF nvarchar(500) NULL
GO
ALTER TABLE WAMS_FULFILLMENT_DETAIL ALTER COLUMN vMRF nvarchar(500) NULL
GO
ALTER TABLE WAMS_PO_DETAILS ALTER COLUMN vMRF nvarchar(500) NULL
GO
ALTER TABLE WAMS_PO_DETAILS ALTER COLUMN fImportTax decimal(18,4) NULL
GO
ALTER TABLE WAMS_PO_DETAILS ALTER COLUMN fQuantity decimal(18,4) NULL
GO
ALTER TABLE WAMS_PO_DETAILS ALTER COLUMN fUnitPrice decimal(18,4) NULL
GO
ALTER TABLE WAMS_PO_DETAILS ALTER COLUMN fItemTotal decimal(18,4) NULL
GO
ALTER TABLE WAMS_PURCHASE_ORDER ALTER COLUMN fPOTotal decimal(18,4) NULL
GO
ALTER TABLE WAMS_STOCK_MANAGEMENT_QUANTITY 
ADD
	[ProjectCode] [nvarchar](20) NULL,
	[ProjectName] [nvarchar](64) NULL,
	[StockCode] [nvarchar](16) NULL,
	[StockName] [nvarchar](2000) NULL,
	[StockTypeId] [int] NULL,
	[StockType] [nvarchar](250) NULL,
	[CategoryId] [int] NULL,
	[Category] [nvarchar](64) NULL,
	[UnitId] [int] NULL,
	[Unit] [nvarchar](64) NULL,
	[Supplier] [nvarchar](64) NULL,
	[PODate] [datetime] NULL,
	[POCode] [nvarchar](16) NULL,
    [Weight] [nvarchar](20) NULL,
    [Note] [nvarchar](max) NULL,
	[Created] [datetime] NULL,
	[Modified] [datetime] NULL,
	[CreatedBy] [nvarchar](500) NULL,
	[ModifiedBy] [nvarchar](500) NULL,
	[FagFrom] [nvarchar](10) NULL,
	[FagId] INT NULL,
	[MRFCode] [nvarchar](64) NULL
