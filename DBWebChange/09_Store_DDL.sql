-- V3_PaymentTypeBySupplier
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_PaymentTypeBySupplier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_PaymentTypeBySupplier]
GO

CREATE PROCEDURE [dbo].[V3_PaymentTypeBySupplier]
@supplier int
AS
BEGIN
	SELECT vTermOfPayment FROM [dbo].WAMS_SUPPLIER (NOLOCK)
	WHERE bSupplierID = @supplier
END
GO
-- exec [dbo].[V3_PaymentTypeBySupplier] 1
GO

-- V3_Check_Client
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Check_Client]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Check_Client]
GO

CREATE PROCEDURE [dbo].[V3_Check_Client]
@condition nvarchar(500)
AS
BEGIN
	SELECT COUNT(1) FROM [dbo].[Project_Client] (NOLOCK) WHERE [Name] = @condition
END
GO
-- exec [dbo].[V3_Check_Client] 'asdads'

-- V3_GetSupplierFromPe
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetSupplierFromPe]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetSupplierFromPe]
GO

CREATE PROCEDURE [dbo].[V3_GetSupplierFromPe]
@pe int
AS
BEGIN
	SELECT DISTINCT pe.bSupplierID [Id], supplier.vSupplierName [Name] FROM [dbo].[WAMS_PURCHASE_ORDER] pe (NOLOCK)
	INNER JOIN dbo.WAMS_SUPPLIER supplier (NOLOCK) ON pe.bSupplierID = supplier.bSupplierID
	WHERE supplier.iEnable=1
	AND 1 = CASE WHEN @pe=0 THEN 1 WHEN Id = @pe THEN 1 END
END
GO
-- exec [dbo].[V3_GetSupplierFromPe] 1
GO
-- V3_GetPEDDL
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetPEDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetPEDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetPEDDL]
@supplier int,
@store int,
@status varchar(20)
AS
BEGIN
	SELECT [Id], vPOID AS [Code],CAST(SUBSTRING(vPOID, 5, 2) AS INT) AS [Year] 
		,CASE substring(vPOID, 0, 4) 
		  WHEN 'JAN' THEN 1 
		  WHEN 'FEB' THEN 2 
		  WHEN 'MAR' THEN 3 
		  WHEN 'APR' THEN 4 
		  WHEN 'MAY' THEN 5 
		  WHEN 'JUN' THEN 6 
		  WHEN 'JUL' THEN 7 
		  WHEN 'AUG' THEN 8 
		  WHEN 'SEP' THEN 9 
		  WHEN 'OCT' THEN 10
		  WHEN 'NOV' THEN 11  
		  WHEN 'DEC' THEN 12 END AS PE_Month FROM [dbo].[WAMS_PURCHASE_ORDER] (NOLOCK)
	WHERE iEnable=1
	AND 1 = CASE WHEN @store=0 THEN 1 WHEN iStore = @store THEN 1 END
	AND 1 = CASE WHEN @supplier=0 THEN 1 WHEN bSupplierID = @supplier THEN 1 END
	AND 1 = CASE WHEN @status='' THEN 1 WHEN vPOStatus = @status THEN 1 END
	ORDER BY [Year] DESC, PE_Month DESC, vPOID DESC
END
GO
-- exec [dbo].[V3_GetPEDDL] 0, 0 ,'Complete'
GO
-- V3_GetRequisitionDDL
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetRequisitionDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetRequisitionDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetRequisitionDDL]
@stock int,
@store int
AS
BEGIN
	SELECT TOP 10 mast.[Id], mast.vMRF AS [Code] FROM [dbo].[WAMS_REQUISITION_MASTER] mast (NOLOCK)
	INNER JOIN dbo.WAMS_REQUISITION_DETAILS detail (NOLOCK) ON mast.Id = detail.vMRF
	WHERE detail.vStockID = @stock AND mast.iStore = @store
	ORDER BY CAST(mast.vMRF AS INT) DESC
END
GO
-- exec [dbo].[V3_GetRequisitionDDL] 1, 1
GO
-- V3_GetPriceDDL
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetPriceDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetPriceDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetPriceDDL]
@stock int,
@store int,
@currency int
AS
BEGIN
	SELECT [Id],[Price] AS [Name] FROM [dbo].[Product_Price] (NOLOCK)
	WHERE StockId = @stock AND StoreId = @store AND CurrencyId = @currency 
	ORDER BY [Price] ASC
END

GO
-- exec [dbo].[V3_GetPriceDDL] 10060, 1, 18
-- 
GO
-- V3_GetPaymentDDL
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetPaymentDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetPaymentDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetPaymentDDL]
AS
BEGIN
	SELECT [Id], [PaymentName] AS [Name] FROM [dbo].[PaymentTerm] (NOLOCK)
	ORDER BY [PaymentName] ASC
END

GO
-- exec [dbo].[V3_GetPaymentDDL]

GO
-- V3_GetCurrencyDDL
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetCurrencyDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetCurrencyDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetCurrencyDDL]
AS
BEGIN
	SELECT [bCurrencyTypeID] AS [Id], [vCurrencyName] AS [Name] FROM [dbo].[WAMS_CURRENCY_TYPE] (NOLOCK)
	ORDER BY [vCurrencyName] ASC
END

GO
-- exec [dbo].[V3_GetCurrencyDDL]

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PoTypeList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PoTypeList]
GO

CREATE PROCEDURE [dbo].[PoTypeList]
AS
BEGIN
	SELECT bPOTypeID AS [Id],vPOTypeName AS [Name] FROM [dbo].WAMS_PO_TYPE (NOLOCK)
	ORDER BY vPOTypeName ASC
END

GO
-- exec [dbo].[PoTypeList]

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLookUp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetLookUp]
GO

CREATE PROCEDURE [dbo].[GetLookUp]
@lookUpType nvarchar(50)
AS
BEGIN
	SELECT [LookUpKey],[LookUpValue]
	FROM [dbo].[LookUp] (NOLOCK)
	WHERE LookUpType = @lookUpType
	ORDER BY LookUpKey
END
/*
	EXEC [dbo].[GetLookUp] 'department'
*/

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetSupplierTypeDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetSupplierTypeDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetSupplierTypeDDL]
AS
BEGIN
	SELECT bSupplierTypeID AS [Id], vSupplierTypeName AS [Name] FROM [dbo].[WAMS_SUPPLIER_TYPE] (NOLOCK)
	WHERE vSupplierTypeName != ''
	ORDER BY vSupplierTypeName ASC
END

GO
-- exec [dbo].[V3_GetSupplierTypeDDL]

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetSupplierDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetSupplierDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetSupplierDDL]
AS
BEGIN
	SELECT bSupplierID AS [Id], vSupplierName AS [Name] FROM [dbo].[WAMS_SUPPLIER] (NOLOCK)
	WHERE iEnable= 1 AND vSupplierName != ''
	ORDER BY vSupplierName ASC
END

GO
-- exec [dbo].[V3_GetSupplierDDL]

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetSIVLastest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetSIVLastest]
GO

CREATE PROCEDURE [dbo].[V3_GetSIVLastest]
AS
BEGIN
	SELECT TOP 1 
	SIV
	,substring(SIV,3,8) as NumSIV 
	FROM [dbo].[SIV] (NOLOCK)
	WHERE SUBSTRING(SIV,1,2) = RIGHT(YEAR(GETDATE()), 2)
	ORDER BY SIV DESC
END
GO
-- exec [dbo].[V3_GetSIVLastest]

--GET SRV LASTEST
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_GetSRV]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_GetSRV]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetSRVLastest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetSRVLastest]
GO

CREATE PROCEDURE [dbo].[V3_GetSRVLastest]
	@type nvarchar(2)
AS
BEGIN
	SET NOCOUNT ON;
	IF(@type='R')
	BEGIN
		SELECT TOP 1 SRV, SUBSTRING(SRV,4,9) AS NumSRV FROM [dbo].[SRV] (NOLOCK)
		WHERE SUBSTRING(SRV,2,2)= RIGHT(YEAR(GETDATE()), 2) AND SUBSTRING(SRV,1,1)='R' ORDER BY NumSRV DESC
	END
	ELSE
	BEGIN
		SELECT TOP 1 SRV, SUBSTRING(SRV,4,9) AS NumSRV FROM [dbo].[SRV] (NOLOCK)
		WHERE SUBSTRING(SRV,2,2)= RIGHT(YEAR(GETDATE()), 2) AND SUBSTRING(SRV,1,1)='F' ORDER BY NumSRV DESC
	END
END
GO
--exec dbo.V3_GetSRVLastest ''
--exec dbo.V3_GetSRVLastest 'R'

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetMRFLastest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetMRFLastest]
GO

CREATE PROCEDURE [dbo].[V3_GetMRFLastest]
AS
BEGIN
	SELECT TOP 1 vMRF
	FROM [dbo].[WAMS_REQUISITION_MASTER] (NOLOCK)
	ORDER BY CAST(vMRF AS INT) DESC
END
GO
-- exec [dbo].[V3_GetMRFLastest]


GO
-- V3_GetWorkerDDL
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetWorkerDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetWorkerDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetWorkerDDL]
AS
BEGIN
	SELECT vWorkerID AS [Id]
	,vLastName + ' ' + vFirstName  AS [Name] FROM [dbo].[WAMS_WORKER] (NOLOCK) ORDER BY [Name] ASC
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetProjectClientDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetProjectClientDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetProjectClientDDL]
AS
BEGIN
	SELECT * FROM [dbo].[Project_Client] (NOLOCK)
	ORDER BY Name ASC
END
GO
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetStoreDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetStoreDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetStoreDDL]
AS
BEGIN
	SELECT Id, Name AS [Name] FROM [dbo].[Store] (NOLOCK)
	WHERE iEnable= 1
	ORDER BY Name ASC
END

GO
-- exec [dbo].[V3_GetStoreDDL]

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetProjectDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetProjectDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetProjectDDL]
AS
BEGIN
	SELECT Id, vProjectID, vProjectName, dBeginDate, dEnd FROM [dbo].[WAMS_PROJECT] (NOLOCK)
	WHERE iEnable= 1 
	and dBeginDate <= GETDATE() 
	and (dEnd <= CAST(CONVERT(char(8), GETDATE(), 112) + ' 23:59:59.99' AS datetime) OR dEnd IS NULL)
	ORDER BY vProjectName ASC
END

GO
-- exec [dbo].[V3_GetProjectDDL]

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetAllProjectDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetAllProjectDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetAllProjectDDL]
AS
BEGIN
	SELECT Id, vProjectID, vProjectName FROM [dbo].[WAMS_PROJECT] (NOLOCK)
	WHERE iEnable= 1 
	ORDER BY vProjectName ASC
END

GO
-- exec [dbo].[V3_GetAllProjectDDL]

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetStockTypeDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetStockTypeDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetStockTypeDDL]
AS
BEGIN
	SELECT Id, TypeName AS [Name] FROM [dbo].[WAMS_STOCK_TYPE] (NOLOCK)
	WHERE iEnable= 1 
	ORDER BY TypeName ASC
END

GO
-- exec [dbo].[V3_GetStockTypeDDL]

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetStockCategoryDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetStockCategoryDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetStockCategoryDDL]
@type int
AS
BEGIN
	SELECT bCategoryID AS [Id], vCategoryName AS [Name] FROM [dbo].[WAMS_CATEGORY] (NOLOCK) 
	WHERE 1 = CASE WHEN @type = 0 THEN 1 WHEN iType = @type THEN 1 END
	ORDER BY vCategoryName ASC
END

GO
-- exec [dbo].[V3_GetStockCategoryDDL] 3

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetStockUnitDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetStockUnitDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetStockUnitDDL]
@type int
AS
BEGIN
	SELECT bUnitID AS [Id], vUnitName AS [Name] FROM [dbo].[WAMS_UNIT] (NOLOCK)
	WHERE 1 = CASE WHEN @type = 0 THEN 1 WHEN iType = @type THEN 1 END
	ORDER BY vUnitName ASC
END

GO
-- exec [dbo].[V3_GetStockUnitDDL] 3

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetStockPositionDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetStockPositionDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetStockPositionDDL]
AS
BEGIN
	SELECT bPositionID AS [Id], vPositionName AS [Name] FROM [dbo].[WAMS_POSITION] (NOLOCK)
	ORDER BY vPositionName ASC
END

GO
-- exec [dbo].[V3_GetStockPositionDDL]

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetStockLabelDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetStockLabelDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetStockLabelDDL]
@type int
AS
BEGIN
	SELECT bLabelID AS [Id], vLabelName AS [Name] FROM [dbo].[WAMS_LABELS] (NOLOCK) 
	WHERE 1 = CASE WHEN @type = 0 THEN 1 WHEN iType = @type THEN 1 END
	ORDER BY vLabelName ASC
END

GO
-- exec [dbo].[V3_GetStockLabelDDL] 3

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetCountryDDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetCountryDDL]
GO

CREATE PROCEDURE [dbo].[V3_GetCountryDDL]
AS
BEGIN
	SELECT Id, NameNice AS [Name] FROM [dbo].[Country] (NOLOCK) 
	WHERE iEnable = 1
	ORDER BY NameNice ASC
END

GO
-- exec [dbo].[V3_GetCountryDDL]
GO
