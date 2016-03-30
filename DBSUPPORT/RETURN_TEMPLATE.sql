-- RETURN STOCK 1
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '213 01 0029'
SET @date = '2015-12-31'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQA0036',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQA0036'	INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQA0036',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQA0036' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 2
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '212 01 0001'
SET @date = '2015-04-25'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQM0246',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQM0246'	INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQM0246',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQM0246' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 3
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '214 01 0070'
SET @date = '2016-03-15'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'S000066',@project,127,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 127) WHERE vStockID='S000066'	INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'S000066',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='S000066' AND iEnable=0),127,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 4
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '29 01 0095'
SET @date = '2016-03-23'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQP0044',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQP0044'	INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQP0044',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQP0044' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 5
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '29 01 0095'
SET @date = '2016-03-02'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'HTLWS002',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='HTLWS002'	INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'HTLWS002',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='HTLWS002' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 6
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = 'BC 0006'
SET @date = '2016-03-25'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A050059',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='A050059'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060053',@project,4,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 4) WHERE vStockID='A060053'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A050059',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A050059' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060053',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060053' AND iEnable=0),4,0,'RETURN',@newSIV,1,@project,@date

GO
UPDATE dbo.WAMS_STOCK_MANAGEMENT_QUANTITY SET dQuantityAfterChange = (dQuantityCurrent + dQuantityChange)
WHERE vStatus='RETURN' AND bUserID=1 AND dQuantityAfterChange=0 AND ID>89990 
GO
SELECT DISTINCT vStatusID, vProjectID FROM dbo.WAMS_STOCK_MANAGEMENT_QUANTITY (NOLOCK)
WHERE bUserID=1 AND vStatus='RETURN' AND ID>9999
