-- RETURN STOCK 1
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '214 01 0090'
SET @date = '2016-03-29'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'S000007',@project,122,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 122) WHERE vStockID='S000007'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'S000008',@project,122,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 122) WHERE vStockID='S000008'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'S000007',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='S000007' AND iEnable=0),122,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'S000008',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='S000008' AND iEnable=0),122,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 2
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '214 01 0070'
SET @date = '2016-03-28'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'S000086',@project,100,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 100) WHERE vStockID='S000086'	INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'S000086',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='S000086' AND iEnable=0),100,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 3
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '214 01 0236'
SET @date = '2016-03-29'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'HTE03003',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='HTE03003'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'HTE00025',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='HTE00025'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'HTE00028',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='HTE00028'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'HTE03003',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='HTE03003' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'HTE00025',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='HTE00025' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'HTE00028',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='HTE00028' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 4
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '215 01 0306'
SET @date = '2016-03-29'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'S000062',@project,10,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 10) WHERE vStockID='S000062'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'S000078',@project,10,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 10) WHERE vStockID='S000078'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'C0100186',@project,5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 5) WHERE vStockID='C0100186'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'C0100187',@project,5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 5) WHERE vStockID='C0100187'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'C0100182',@project,0.5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 0.5) WHERE vStockID='C0100182'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'C0100179',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='C0100179'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'E031044',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='E031044'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070049',@project,5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 5) WHERE vStockID='F070049'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'S000062',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='S000062' AND iEnable=0),10,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'S000078',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='S000078' AND iEnable=0),10,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'C0100186',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='C0100186' AND iEnable=0),5,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'C0100187',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='C0100187' AND iEnable=0),5,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'C0100182',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='C0100182' AND iEnable=0),0.5,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'C0100179',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='C0100179' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'E031044',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='E031044' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070049',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070049' AND iEnable=0),5,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 5
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '214 01 0091'
SET @date = '2016-03-29'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060160',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='A060160'	INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060160',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060160' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 6
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '214 01 0091'
SET @date = '2016-03-29'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'S000088',@project,10,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 10) WHERE vStockID='S000088'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'S000064',@project,7,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 7) WHERE vStockID='S000064'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'S000061',@project,11,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 11) WHERE vStockID='S000061'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'S000062',@project,9,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 9) WHERE vStockID='S000062'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070002',@project,4,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 4) WHERE vStockID='F070002'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'S000088',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='S000088' AND iEnable=0),10,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'S000064',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='S000064' AND iEnable=0),7,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'S000061',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='S000061' AND iEnable=0),11,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'S000062',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='S000062' AND iEnable=0),9,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070002',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070002' AND iEnable=0),4,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 7
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '214 01 0090'
SET @date = '2016-03-29'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070154',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F070154'	INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070154',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070154' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 8
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '214 01 0236'
SET @date = '2016-03-30'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'B033001',@project,20,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 20) WHERE vStockID='B033001'	INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'B033001',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='B033001' AND iEnable=0),20,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 9
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '215 01 0306'
SET @date = '2016-03-29'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQI0033',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQI0033'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQI0034',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQI0034'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'HTE00119',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='HTE00119'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F05',@project,4,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 4) WHERE vStockID='F05'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070009',@project,4,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 4) WHERE vStockID='F070009'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070004',@project,10,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 10) WHERE vStockID='F070004'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F0700176',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F0700176'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070053',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F070053'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070025',@project,3,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 3) WHERE vStockID='F070025'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070168',@project,9,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 9) WHERE vStockID='F070168'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070002',@project,5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 5) WHERE vStockID='F070002'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070022',@project,5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 5) WHERE vStockID='F070022'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQI0033',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQI0033' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQI0034',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQI0034' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'HTE00119',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='HTE00119' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F05',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F05' AND iEnable=0),4,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070009',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070009' AND iEnable=0),4,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070004',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070004' AND iEnable=0),10,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F0700176',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F0700176' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070053',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070053' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070025',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070025' AND iEnable=0),3,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070168',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070168' AND iEnable=0),9,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070002',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070002' AND iEnable=0),5,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070022',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070022' AND iEnable=0),5,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 10
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '29 01 0095'
SET @date = '2016-03-29'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070009',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F070009'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070053',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F070053'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070002',@project,5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 5) WHERE vStockID='F070002'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070022',@project,5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 5) WHERE vStockID='F070022'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070009',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070009' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070053',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070053' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070002',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070002' AND iEnable=0),5,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070022',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070022' AND iEnable=0),5,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 11
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '29 01 0095'
SET @date = '2016-03-29'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQI0030',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQI0030'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'HTE00038',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='HTE00038'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'HTE00117',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='HTE00117'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'HTE00118',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='HTE00118'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'HTE00023',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='HTE00023'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQI0030',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQI0030' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'HTE00038',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='HTE00038' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'HTE00117',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='HTE00117' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'HTE00118',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='HTE00118' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'HTE00023',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='HTE00023' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date

GO
UPDATE dbo.WAMS_STOCK_MANAGEMENT_QUANTITY SET dQuantityAfterChange = (dQuantityCurrent + dQuantityChange)
WHERE vStatus='RETURN' AND bUserID=1 AND dQuantityAfterChange=0 AND ID>89990 
GO
SELECT DISTINCT vStatusID, vProjectID FROM dbo.WAMS_STOCK_MANAGEMENT_QUANTITY (NOLOCK)
WHERE bUserID=1 AND vStatus='RETURN' AND ID>9999
