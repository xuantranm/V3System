-- RETURN STOCK
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = 'BC 0005'
SET @date = '2015-01-30'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020184',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F020184'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020184',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020184' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date


GO
UPDATE dbo.WAMS_STOCK_MANAGEMENT_QUANTITY SET dQuantityAfterChange = (dQuantityCurrent + dQuantityChange)
WHERE vStatus='RETURN' AND bUserID=1 AND dQuantityAfterChange=0 AND ID>89990 
GO
SELECT DISTINCT vStatusID, vProjectID FROM dbo.WAMS_STOCK_MANAGEMENT_QUANTITY (NOLOCK)
WHERE bUserID=1 AND vStatus='RETURN' AND ID>9999
