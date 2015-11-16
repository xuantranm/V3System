-- RETURN STOCK 31 Jan
-- RPT 1
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '214 01 0160'
SET @date = '2015-01-30'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F0500150',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F0500150'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F0500150',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F0500150' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date

GO

-- RPT 2
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '29 01 0095'
SET @date = '2015-01-30'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070002',@project,7,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 7) WHERE vStockID='F070002'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070049',@project,6,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 6) WHERE vStockID='F070049'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'HTE00023',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='HTE00023'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'HTE00024',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='HTE00024'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070002',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070002' AND iEnable=0),7,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070049',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070049' AND iEnable=0),6,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'HTE00023',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='HTE00023' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'HTE00024',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='HTE00024' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date

GO

-- RPT 3
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '213 01 0047'
SET @date = '2015-01-30'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'HTE03001',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='HTE03001'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'HTE03001',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='HTE03001' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date

GO

UPDATE dbo.WAMS_STOCK_MANAGEMENT_QUANTITY SET dQuantityAfterChange = (dQuantityCurrent + dQuantityChange)
WHERE vStatus='RETURN' AND bUserID=1 AND dQuantityAfterChange=0
GO
-- R15000066
SELECT DISTINCT vStatusID, vProjectID FROM dbo.WAMS_STOCK_MANAGEMENT_QUANTITY (NOLOCK)
WHERE bUserID=1 AND vStatus='RETURN'