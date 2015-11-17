GO
ALTER TABLE dbo.WAMS_USER DROP CONSTRAINT [DF_WAMS_USER_iEnable];
GO
ALTER TABLE dbo.WAMS_USER ALTER COLUMN iEnable bit
GO
ALTER TABLE dbo.WAMS_FUNCTION_MANAGEMENT DROP CONSTRAINT [DF_WAMS_FUNCTION_MANAGEMENT_iEnable];
GO
ALTER TABLE dbo.WAMS_FUNCTION_MANAGEMENT ALTER COLUMN iEnable bit
GO
ALTER TABLE dbo.WAMS_PROJECT DROP CONSTRAINT [DF_WAMS_PROJECT_iEnable];
GO
ALTER TABLE dbo.WAMS_PROJECT ALTER COLUMN iEnable bit
GO
ALTER TABLE dbo.WAMS_PROJECT DROP COLUMN vClient
GO
ALTER TABLE dbo.WAMS_PROJECT DROP COLUMN vStatus
GO
ALTER TABLE dbo.WAMS_STOCK DROP CONSTRAINT [DF_WAMS_STOCK_iEnable];
GO
ALTER TABLE dbo.WAMS_STOCK ALTER COLUMN iEnable bit
GO
ALTER TABLE dbo.WAMS_STOCK DROP COLUMN vStockType
GO
ALTER TABLE dbo.WAMS_STOCK_MANAGEMENT_QUANTITY ALTER COLUMN vStockID int not null
GO
ALTER TABLE dbo.WAMS_STOCK_MANAGEMENT_QUANTITY ALTER COLUMN vProjectID int null 
GO
ALTER TABLE dbo.WAMS_ASSIGNNING_STOCKS ALTER COLUMN vStockID int not null
GO   
ALTER TABLE dbo.WAMS_ASSIGNNING_STOCKS ALTER COLUMN vProjectID int null 
GO
ALTER TABLE dbo.WAMS_ASSIGNNING_STOCKS DROP CONSTRAINT [DF_WAMS_ASSIGNNING_STOCKS_bQuantity];
GO
ALTER TABLE dbo.WAMS_ASSIGNNING_STOCKS ALTER COLUMN bQuantity decimal(18,2) 
GO
ALTER TABLE dbo.WAMS_RETURN_LIST ALTER COLUMN vStockID int not null
GO
ALTER TABLE dbo.WAMS_SUPPLIER DROP CONSTRAINT [DF_WAMS_SUPPLIER_iEnable];
GO
ALTER TABLE dbo.WAMS_SUPPLIER ALTER COLUMN iEnable bit
GO
ALTER TABLE dbo.WAMS_SUPPLIER ALTER COLUMN bTotalPO decimal(18,2)
GO
ALTER TABLE dbo.WAMS_SUPPLIER ALTER COLUMN fTotalMoney decimal(18,2)
GO
ALTER TABLE dbo.WAMS_SUPPLIER DROP COLUMN vCountry
GO
ALTER TABLE dbo.WAMS_SUPPLIER DROP COLUMN vMarket
GO
ALTER TABLE dbo.WAMS_SUPPLIER DROP COLUMN vSupplierType
GO
ALTER TABLE dbo.WAMS_SUPPLIER DROP COLUMN bTotalPO
GO
ALTER TABLE dbo.WAMS_SUPPLIER DROP COLUMN bVAT
GO
ALTER TABLE dbo.WAMS_PRODUCT DROP CONSTRAINT [PK_WAMS_PRODUCT]
GO
ALTER TABLE dbo.WAMS_PRODUCT ALTER COLUMN vProductID int null
GO
ALTER TABLE dbo.WAMS_PRODUCT DROP CONSTRAINT [DF_WAMS_PRODUCT_iEnable];
GO
ALTER TABLE dbo.WAMS_PRODUCT ALTER COLUMN iEnable bit
GO
ALTER TABLE dbo.WAMS_REQUISITION_MASTER ALTER COLUMN vProjectID int
GO
ALTER TABLE dbo.WAMS_REQUISITION_MASTER DROP CONSTRAINT [DF_WAMS_REQUISITION_MASTER_iEnable];
GO
ALTER TABLE dbo.WAMS_REQUISITION_MASTER ALTER COLUMN iEnable bit
GO
ALTER TABLE dbo.WAMS_REQUISITION_DETAILS DROP CONSTRAINT [DF_WAMS_REQUISITION_DETAILS_iEnable];
GO
ALTER TABLE dbo.WAMS_REQUISITION_DETAILS ALTER COLUMN iEnable bit
GO
ALTER TABLE dbo.WAMS_REQUISITION_DETAILS ALTER COLUMN fTobePurchased decimal(18,2)
GO
ALTER TABLE dbo.WAMS_REQUISITION_DETAILS ALTER COLUMN vStockID int null
GO
ALTER TABLE dbo.WAMS_REQUISITION_DETAILS ALTER COLUMN vMRF int null 
GO
ALTER TABLE dbo.WAMS_PO_DETAILS ALTER COLUMN vMRF int null
GO
ALTER TABLE dbo.WAMS_PO_DETAILS ALTER COLUMN fQuantity decimal(18,2)
GO
ALTER TABLE dbo.WAMS_PO_DETAILS ALTER COLUMN fVAT int
GO
ALTER TABLE dbo.WAMS_PO_DETAILS ALTER COLUMN fImportTax decimal(18,2)
GO
ALTER TABLE dbo.WAMS_STOCK_MANAGEMENT_QUANTITY ALTER COLUMN vMRF int null
GO
ALTER TABLE dbo.WAMS_PURCHASE_ORDER DROP CONSTRAINT [DF_WAMS_PURCHASE_ORDER_iEnable];
GO
ALTER TABLE dbo.WAMS_PURCHASE_ORDER ALTER COLUMN iEnable bit
GO
ALTER TABLE dbo.WAMS_PURCHASE_ORDER ALTER COLUMN vProjectID int
GO
ALTER TABLE dbo.WAMS_PURCHASE_ORDER ALTER COLUMN fPOTotal decimal(18,2)
GO
ALTER TABLE dbo.WAMS_PURCHASE_ORDER ALTER COLUMN vFROMContact nvarchar(256) null
GO
ALTER TABLE dbo.WAMS_PURCHASE_ORDER ALTER COLUMN vFROMTel nvarchar(64) null
GO
ALTER TABLE dbo.WAMS_PURCHASE_ORDER ALTER COLUMN vFROMFax nvarchar(64) null
GO
ALTER TABLE dbo.WAMS_PURCHASE_ORDER ALTER COLUMN vRemark nvarchar(1024) null
GO
ALTER TABLE dbo.WAMS_PO_DETAILS DROP CONSTRAINT [DF_WAMS_PO_DETAILS_iEnable];
GO
ALTER TABLE dbo.WAMS_PO_DETAILS ALTER COLUMN iEnable bit
GO
ALTER TABLE dbo.WAMS_PO_DETAILS DROP CONSTRAINT [PK_WAMS_PO_DETAILS_1];
GO
ALTER TABLE dbo.WAMS_PO_DETAILS ALTER COLUMN vProductID int null
GO
ALTER TABLE dbo.WAMS_PO_DETAILS ALTER COLUMN fItemTotal decimal(18,2)
GO
ALTER TABLE dbo.WAMS_PO_DETAILS ALTER COLUMN fUnitPrice decimal(18,2) null
GO
ALTER TABLE dbo.WAMS_SUPPLIER_SERVICE ALTER COLUMN bSupplierID int
GO
ALTER TABLE dbo.WAMS_PO_DETAILS ALTER COLUMN vPOID int
GO
ALTER TABLE dbo.WAMS_PO_DETAILS
ADD CONSTRAINT PK_WAMS_PO_DETAILS PRIMARY KEY (ID)
GO
ALTER TABLE dbo.WAMS_STOCK_MANAGEMENT_QUANTITY ALTER COLUMN vPOID int
GO
ALTER TABLE dbo.WAMS_FULFILLMENT_DETAIL ALTER COLUMN vPOID int
GO
ALTER TABLE dbo.WAMS_FULFILLMENT_DETAIL DROP CONSTRAINT [DF_WAMS_FULFILLMENT_DETAIL_iEnable];
GO
ALTER TABLE dbo.WAMS_FULFILLMENT_DETAIL ALTER COLUMN iEnable bit
GO
ALTER TABLE dbo.WAMS_FULFILLMENT_DETAIL ALTER COLUMN vStockID int null
GO
ALTER TABLE dbo.WAMS_SUPPLIER ALTER COLUMN vTermOfPayment NVARCHAR(500)
GO
ALTER TABLE dbo.WAMS_STOCK DROP CONSTRAINT [DF_WAMS_STOCK_bQuantity]
GO
ALTER TABLE dbo.WAMS_STOCK DROP COLUMN bQuantity
GO
ALTER TABLE dbo.WAMS_PRODUCT ALTER COLUMN vProductID int not null
GO
ALTER TABLE dbo.WAMS_PRODUCT DROP COLUMN bCurrentPrice
GO
ALTER TABLE dbo.WAMS_PRODUCT DROP COLUMN bBestPrice
GO
ALTER TABLE dbo.WAMS_PRODUCT DROP COLUMN bCurrencyTypeID
GO
ALTER TABLE dbo.WAMS_PRODUCT DROP CONSTRAINT DF_WAMS_PRODUCT_dDateAssign
GO
ALTER TABLE dbo.WAMS_PRODUCT DROP COLUMN dDateAssign
GO
ALTER TABLE dbo.WAMS_PRODUCT DROP CONSTRAINT FK_WAMS_PRODUCT_WAMS_SUPPLIER
GO
ALTER TABLE dbo.WAMS_PRODUCT
ADD CONSTRAINT PK_WAMS_PRODUCT PRIMARY KEY (ID)
GO
ALTER TABLE dbo.WAMS_ASSIGNNING_STOCKS DROP CONSTRAINT DF_WAMS_ASSIGNNING_STOCKS_dDateAssign
GO
ALTER TABLE dbo.WAMS_ASSIGNNING_STOCKS DROP COLUMN dDateAssign
GO
ALTER TABLE dbo.WAMS_RETURN_LIST DROP CONSTRAINT DF_WAMS_RETURN_LIST_dDateReturn
GO
ALTER TABLE dbo.WAMS_RETURN_LIST DROP COLUMN dDateReturn
GO
ALTER TABLE dbo.WAMS_RETURN_LIST DROP CONSTRAINT DF_WAMS_RETURN_LIST_ServiceFlag
GO
ALTER TABLE dbo.WAMS_RETURN_LIST DROP COLUMN ServiceFlag
GO
ALTER TABLE dbo.WAMS_RETURN_LIST ALTER COLUMN vProjectID int null
GO
ALTER TABLE dbo.WAMS_STOCK_MANAGEMENT_QUANTITY ADD FROMStore int null
GO
ALTER TABLE dbo.WAMS_STOCK_MANAGEMENT_QUANTITY ADD ToStore int null
GO
ALTER TABLE dbo.WAMS_STOCK_MANAGEMENT_QUANTITY DROP COLUMN Store
GO
ALTER TABLE dbo.WAMS_STOCK_MANAGEMENT_QUANTITY DROP COLUMN Country
GO
ALTER TABLE dbo.WAMS_ITEMS_SERVICE ALTER COLUMN iEnable bit
GO
ALTER TABLE dbo.WAMS_ITEMS_SERVICE DROP COLUMN bQuantity
GO
ALTER TABLE dbo.WAMS_ITEMS_SERVICE DROP COLUMN bProductType
GO
ALTER TABLE dbo.WAMS_ITEMS_SERVICE DROP COLUMN vPhotoPath
GO
ALTER TABLE dbo.WAMS_ITEMS_SERVICE ALTER COLUMN vDescription nvarchar(4000) null
GO