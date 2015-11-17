-- V3_CategoryGetListCode
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_CategoryGetListCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_CategoryGetListCode]
GO
CREATE PROCEDURE [dbo].[V3_CategoryGetListCode]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 CategoryCode [Code]
		FROM [dbo].WAMS_CATEGORY (NOLOCK)
		WHERE CategoryCode like '%' + @condition +'%'
		ORDER BY CategoryCode ASC
END
/*
exec dbo.V3_CategoryGetListCode 'B'
*/
GO

-- V3_CategoryGetListName
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_CategoryGetListName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_CategoryGetListName]
GO
CREATE PROCEDURE [dbo].[V3_CategoryGetListName]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 vCategoryName [Name]
		FROM [dbo].WAMS_CATEGORY (NOLOCK)
		WHERE vCategoryName like '%' + @condition +'%'
		ORDER BY vCategoryName ASC
END
/*
exec dbo.V3_CategoryGetListName 'B'
*/
GO

-- V3_StockTypeGetListCode
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_StockTypeGetListCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_StockTypeGetListCode]
GO
CREATE PROCEDURE [dbo].[V3_StockTypeGetListCode]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 TypeCode [Code]
		FROM [dbo].WAMS_STOCK_TYPE (NOLOCK)
		WHERE TypeCode like '%' + @condition +'%'
		ORDER BY TypeCode ASC
END
/*
exec dbo.V3_StockTypeGetListCode 'B'
*/
GO

-- V3_StockTypeGetListName
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_StockTypeGetListName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_StockTypeGetListName]
GO
CREATE PROCEDURE [dbo].[V3_StockTypeGetListName]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 TypeName [Name]
		FROM [dbo].WAMS_STOCK_TYPE (NOLOCK)
		WHERE TypeName like '%' + @condition +'%'
		ORDER BY TypeName ASC
END
/*
exec dbo.V3_StockTypeGetListName 'B'
*/
GO

-- V3_StockServiceGetListName
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_StockServiceGetListName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_StockServiceGetListName]
GO
CREATE PROCEDURE [dbo].[V3_StockServiceGetListName]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 vServiceItemName
		FROM dbo.WAMS_ITEMS_SERVICE (NOLOCK)
		WHERE vServiceItemName like '%' + @condition +'%'
		ORDER BY vServiceItemName ASC
END
/*
exec dbo.V3_StockServiceGetListName 'A'
*/
GO

-- V3_StockServiceGetListCode
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_StockServiceGetListCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_StockServiceGetListCode]
GO
CREATE PROCEDURE [dbo].[V3_StockServiceGetListCode]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 vIDServiceItem
		FROM dbo.WAMS_ITEMS_SERVICE (NOLOCK)
		WHERE vIDServiceItem like '%' + @condition +'%'
		ORDER BY vIDServiceItem ASC
END
/*
exec dbo.V3_StockServiceGetListCode 'A'
*/
GO
-- V3_SupplierGetListName
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_SupplierGetListName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_SupplierGetListName]
GO
CREATE PROCEDURE [dbo].[V3_SupplierGetListName]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 vSupplierName
		FROM [dbo].[WAMS_SUPPLIER] (NOLOCK)
		WHERE vSupplierName like '%' + @condition +'%'
		ORDER BY vSupplierName DESC
END
/*
exec dbo.V3_SupplierGetListName 'xuan'
*/

GO
-- V3_PeGetListCode
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_PeGetListCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_PeGetListCode]
GO
CREATE PROCEDURE [dbo].[V3_PeGetListCode]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 vPOID
		FROM [dbo].[WAMS_PURCHASE_ORDER] (NOLOCK)
		WHERE vPOID like '%' + @condition +'%'
		ORDER BY substring(vPOID,5,2) DESC
		,(CASE substring(vPOID,0,4) 
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
		else 12 end) DESC
		,vPOID DESC
END
/*
exec dbo.V3_PeGetListCode '15'
*/

GO
-- V3_RequisitionGetListCode
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_RequisitionGetListCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_RequisitionGetListCode]
GO
CREATE PROCEDURE [dbo].[V3_RequisitionGetListCode]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 vMRF
		FROM [dbo].[WAMS_REQUISITION_MASTER] (NOLOCK)
		WHERE vMRF like '%' + @condition +'%'
		ORDER BY vMRF ASC
END
/*
exec dbo.V3_RequisitionGetListCode '0'
*/

GO
-- V3_StoreGetListName
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_StoreGetListCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_StoreGetListCode]
GO
CREATE PROCEDURE [dbo].[V3_StoreGetListCode]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 Code
		FROM [dbo].[Store] (NOLOCK)
		WHERE Code like '%' + @condition +'%'
		ORDER BY Code ASC
END
/*
exec dbo.V3_StoreGetListCode 'B'
*/
GO

-- V3_StoreGetListName
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_StoreGetListName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_StoreGetListName]
GO
CREATE PROCEDURE [dbo].[V3_StoreGetListName]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 Name
		FROM [dbo].[Store] (NOLOCK)
		WHERE Name like '%' + @condition +'%'
		ORDER BY Name ASC
END
/*
exec dbo.V3_StoreGetListName 'B'
*/
GO
-- V3_ProjectGetListName
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_ProjectGetListName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_ProjectGetListName]
GO
CREATE PROCEDURE [dbo].[V3_ProjectGetListName]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 vProjectName
		FROM [dbo].[WAMS_PROJECT] (NOLOCK)
		WHERE vProjectName like '%' + @condition +'%'
		ORDER BY vProjectName ASC
END
/*
exec dbo.V3_ProjectGetListName 'A'
*/
GO
-- V3_ProjectGetListNameClient
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_ProjectGetListNameClient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_ProjectGetListNameClient]
GO
CREATE PROCEDURE [dbo].[V3_ProjectGetListNameClient]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 [Name]
		FROM dbo.Project_Client (NOLOCK)
		WHERE [Name] like '%' + @condition +'%'
		ORDER BY [Name] ASC
END
/*
exec dbo.V3_ProjectGetListNameClient 'A'
*/
GO
-- V3_ProjectGetListCode
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_ProjectGetListCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_ProjectGetListCode]
GO
CREATE PROCEDURE [dbo].[V3_ProjectGetListCode]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 vProjectId
		FROM [dbo].[WAMS_PROJECT] (NOLOCK)
		WHERE vProjectId like '%' + @condition +'%'
		ORDER BY vProjectId ASC
END
/*
exec dbo.V3_ProjectGetListCode '210010005'
*/
GO
-- V3_ServiceGetListCode
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_ServiceGetListCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_ServiceGetListCode]
GO
CREATE PROCEDURE [dbo].[V3_ServiceGetListCode]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 vIDServiceItem
		FROM [dbo].[WAMS_ITEMS_SERVICE] (NOLOCK)
		WHERE vIDServiceItem like '%' + @condition +'%'
		ORDER BY vIDServiceItem ASC
END
/*
exec dbo.V3_ServiceGetListCode '001'
*/
GO
-- V3_ServiceGetListName
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_ServiceGetListName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_ServiceGetListName]
GO
CREATE PROCEDURE [dbo].[V3_ServiceGetListName]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 vServiceItemName
		FROM [dbo].[WAMS_ITEMS_SERVICE] (NOLOCK)
		WHERE vServiceItemName like '%' + @condition +'%'
		ORDER BY vServiceItemName ASC
END
/*
exec dbo.V3_ServiceGetListName 'A'
*/
GO
-- V3_UserGetListName
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_UserGetListName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_UserGetListName]
GO
CREATE PROCEDURE [dbo].[V3_UserGetListName]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 Username
		FROM [dbo].XUser (NOLOCK)
		WHERE Username like '%' + @condition +'%'
		ORDER BY Username ASC
END
/*
exec dbo.V3_UserGetListName 'A'
*/
GO
-- V3_UserGetEmail
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_UserGetEmail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_UserGetEmail]
GO
CREATE PROCEDURE [dbo].[V3_UserGetEmail]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 Email
		FROM [dbo].XUser (NOLOCK)
		WHERE Email like '%' + @condition +'%'
		ORDER BY Email ASC
END
/*
exec dbo.V3_UserGetEmail 'xuan'
*/
GO
-- V3_StockGetListName
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_StockGetListName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_StockGetListName]
GO
CREATE PROCEDURE [dbo].[V3_StockGetListName]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 vStockName
		FROM [dbo].[WAMS_STOCK] (NOLOCK)
		WHERE vStockName like '%' + @condition +'%'
		ORDER BY vStockName ASC
END
/*
exec dbo.V3_StockGetListName 'A'
*/
GO

-- V3_StockGetListCode
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_StockGetListCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_StockGetListCode]
GO
CREATE PROCEDURE [dbo].[V3_StockGetListCode]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 vStockID
		FROM [dbo].[WAMS_STOCK] (NOLOCK)
		WHERE vStockID like '%' + @condition +'%'
		ORDER BY vStockID ASC
END
/*
exec dbo.V3_StockGetListCode 'A'
*/
GO

-- V3_ListPayment
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_ListPayment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_ListPayment]
GO
CREATE PROCEDURE [dbo].[V3_ListPayment]
@condition nvarchar(100)
AS
BEGIN
	SELECT TOP 10 PaymentName
		FROM [dbo].PaymentTerm (NOLOCK)
		WHERE PaymentName like '%' + @condition +'%' and iEnable=1
		ORDER BY PaymentName ASC
END
/*
exec dbo.V3_ListPayment 'A'
*/
GO

-- V3_Payment
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Payment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Payment]
GO
CREATE PROCEDURE [dbo].[V3_Payment]
@supplier int
AS
BEGIN
	SELECT TOP 10 PaymentName
		FROM [dbo].PaymentTerm (NOLOCK)
		WHERE PaymentName like '%' + @condition +'%' and iEnable=1
		ORDER BY PaymentName ASC
END
/*
exec dbo.V3_ListPayment 'A'
*/
GO
