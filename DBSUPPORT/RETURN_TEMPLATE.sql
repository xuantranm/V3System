-- RETURN STOCK 1
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '29 01 0095'
SET @date = '2015-12-17'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T0007',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='T0007'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T0006',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='T0006'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T0007',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T0007' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T0006',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T0006' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 2
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '212 01 0001'
SET @date = '2015-12-17'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A040042',@project,5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 5) WHERE vStockID='A040042'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010155',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F010155'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060031',@project,22,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 22) WHERE vStockID='A060031'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A061134',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='A061134'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020454',@project,11,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 11) WHERE vStockID='F020454'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010295',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F010295'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F050373',@project,3,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 3) WHERE vStockID='F050373'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A040042',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A040042' AND iEnable=0),5,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010155',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010155' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060031',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060031' AND iEnable=0),22,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A061134',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A061134' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020454',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020454' AND iEnable=0),11,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010295',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010295' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F050373',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F050373' AND iEnable=0),3,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 3
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '213 01 0039'
SET @date = '2015-12-17'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQM0334',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQM0334'	INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQM0334',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQM0334' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 4
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '213 01 0029'
SET @date = '2015-12-17'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F050123',@project,6,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 6) WHERE vStockID='F050123'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060059',@project,14,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 14) WHERE vStockID='A060059'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A020021',@project,104,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 104) WHERE vStockID='A020021'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060790',@project,4,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 4) WHERE vStockID='A060790'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A050082',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='A050082'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060625',@project,3,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 3) WHERE vStockID='A060625'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060248',@project,252,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 252) WHERE vStockID='A060248'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060047',@project,12,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 12) WHERE vStockID='A060047'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A050073',@project,4.5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 4.5) WHERE vStockID='A050073'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020008',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F020008'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010335',@project,4,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 4) WHERE vStockID='F010335'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A062011',@project,4,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 4) WHERE vStockID='A062011'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010007',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F010007'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010142',@project,5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 5) WHERE vStockID='F010142'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010048',@project,3,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 3) WHERE vStockID='F010048'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010047',@project,3,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 3) WHERE vStockID='F010047'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010114',@project,6,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 6) WHERE vStockID='F010114'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F050372',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F050372'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010103',@project,3,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 3) WHERE vStockID='F010103'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020419',@project,13,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 13) WHERE vStockID='F020419'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020420',@project,20,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 20) WHERE vStockID='F020420'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020394',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F020394'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020405',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F020405'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020393',@project,3,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 3) WHERE vStockID='F020393'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F0200006',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F0200006'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020404',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F020404'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F0200496',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F0200496'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F1200129',@project,8,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 8) WHERE vStockID='F1200129'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020454',@project,4,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 4) WHERE vStockID='F020454'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020090',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F020090'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010295',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F010295'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A020040',@project,89,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 89) WHERE vStockID='A020040'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070129',@project,3,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 3) WHERE vStockID='F070129'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070058',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F070058'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F0700130',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F0700130'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070048',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F070048'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'AAP00628',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='AAP00628'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'AAP00640',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='AAP00640'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'AAP00641',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='AAP00641'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQM0373',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQM0373'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQM0366',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQM0366'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T0000022',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='T0000022'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T0000023',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='T0000023'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T0000019',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='T0000019'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T0000020',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='T0000020'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T0000024',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='T0000024'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F0500150',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F0500150'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQM0424',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQM0424'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQM0583',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQM0583'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F050123',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F050123' AND iEnable=0),6,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060059',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060059' AND iEnable=0),14,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A020021',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A020021' AND iEnable=0),104,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060790',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060790' AND iEnable=0),4,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A050082',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A050082' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060625',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060625' AND iEnable=0),3,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060248',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060248' AND iEnable=0),252,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060047',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060047' AND iEnable=0),12,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A050073',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A050073' AND iEnable=0),4.5,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020008',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020008' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010335',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010335' AND iEnable=0),4,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A062011',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A062011' AND iEnable=0),4,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010007',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010007' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010142',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010142' AND iEnable=0),5,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010048',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010048' AND iEnable=0),3,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010047',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010047' AND iEnable=0),3,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010114',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010114' AND iEnable=0),6,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F050372',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F050372' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010103',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010103' AND iEnable=0),3,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020419',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020419' AND iEnable=0),13,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020420',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020420' AND iEnable=0),20,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020394',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020394' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020405',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020405' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020393',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020393' AND iEnable=0),3,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F0200006',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F0200006' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020404',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020404' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F0200496',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F0200496' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F1200129',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F1200129' AND iEnable=0),8,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020454',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020454' AND iEnable=0),4,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020090',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020090' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010295',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010295' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A020040',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A020040' AND iEnable=0),89,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070129',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070129' AND iEnable=0),3,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070058',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070058' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F0700130',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F0700130' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070048',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070048' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'AAP00628',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='AAP00628' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'AAP00640',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='AAP00640' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'AAP00641',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='AAP00641' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQM0373',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQM0373' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQM0366',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQM0366' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T0000022',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T0000022' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T0000023',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T0000023' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T0000019',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T0000019' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T0000020',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T0000020' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T0000024',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T0000024' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F0500150',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F0500150' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQM0424',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQM0424' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQM0583',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQM0583' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 5
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '213 01 0192'
SET @date = '2015-12-17'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A040026',@project,5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 5) WHERE vStockID='A040026'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A0200012',@project,230,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 230) WHERE vStockID='A0200012'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A0200013',@project,230,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 230) WHERE vStockID='A0200013'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A0200014',@project,322,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 322) WHERE vStockID='A0200014'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F060044',@project,11,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 11) WHERE vStockID='F060044'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010003',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F010003'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010004',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F010004'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010007',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F010007'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060053',@project,8,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 8) WHERE vStockID='A060053'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010140',@project,9,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 9) WHERE vStockID='F010140'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F050372',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F050372'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070024',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F070024'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070102',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F070102'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQM00138',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQM00138'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQM00132',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQM00132'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'HTE00087',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='HTE00087'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T0000052',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='T0000052'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T0000053',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='T0000053'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T0000054',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='T0000054'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQA0022',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQA0022'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A040026',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A040026' AND iEnable=0),5,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A0200012',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A0200012' AND iEnable=0),230,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A0200013',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A0200013' AND iEnable=0),230,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A0200014',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A0200014' AND iEnable=0),322,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F060044',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F060044' AND iEnable=0),11,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010003',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010003' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010004',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010004' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010007',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010007' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060053',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060053' AND iEnable=0),8,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010140',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010140' AND iEnable=0),9,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F050372',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F050372' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070024',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070024' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070102',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070102' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQM00138',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQM00138' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQM00132',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQM00132' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'HTE00087',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='HTE00087' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T0000052',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T0000052' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T0000053',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T0000053' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T0000054',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T0000054' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQA0022',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQA0022' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 6
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '214 01 0236'
SET @date = '2015-12-17'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'C0100015',@project,2760,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2760) WHERE vStockID='C0100015'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'C010030',@project,100,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 100) WHERE vStockID='C010030'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'C020091',@project,420,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 420) WHERE vStockID='C020091'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A061091',@project,7,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 7) WHERE vStockID='A061091'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A061065',@project,16,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 16) WHERE vStockID='A061065'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'C010040',@project,207,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 207) WHERE vStockID='C010040'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T26',@project,6,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 6) WHERE vStockID='T26'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070233',@project,13,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 13) WHERE vStockID='F070233'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'S000079',@project,20,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 20) WHERE vStockID='S000079'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060021',@project,5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 5) WHERE vStockID='A060021'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A040042',@project,10,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 10) WHERE vStockID='A040042'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060019',@project,3,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 3) WHERE vStockID='A060019'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060105',@project,3,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 3) WHERE vStockID='A060105'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A040068',@project,12,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 12) WHERE vStockID='A040068'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A030041',@project,0.5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 0.5) WHERE vStockID='A030041'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A0600142',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='A0600142'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010080',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F010080'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010152',@project,100,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 100) WHERE vStockID='F010152'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060602',@project,3,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 3) WHERE vStockID='A060602'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010014',@project,3,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 3) WHERE vStockID='F010014'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010445',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F010445'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010076',@project,24,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 24) WHERE vStockID='F010076'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'S000072',@project,25,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 25) WHERE vStockID='S000072'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'S000063',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='S000063'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060249',@project,431,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 431) WHERE vStockID='A060249'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060248',@project,20,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 20) WHERE vStockID='A060248'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060242',@project,106,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 106) WHERE vStockID='A060242'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A050175',@project,1000,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1000) WHERE vStockID='A050175'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A050073',@project,28.5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 28.5) WHERE vStockID='A050073'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'C0600001',@project,43,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 43) WHERE vStockID='C0600001'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'E033002',@project,6,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 6) WHERE vStockID='E033002'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020073',@project,3,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 3) WHERE vStockID='F020073'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010030',@project,13,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 13) WHERE vStockID='F010030'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010008',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F010008'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020002',@project,4,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 4) WHERE vStockID='F020002'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010007',@project,5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 5) WHERE vStockID='F010007'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A0600766',@project,5050,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 5050) WHERE vStockID='A0600766'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A0600764',@project,760,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 760) WHERE vStockID='A0600764'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070059',@project,3,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 3) WHERE vStockID='F070059'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060063',@project,6,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 6) WHERE vStockID='A060063'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060097',@project,16,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 16) WHERE vStockID='A060097'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020664',@project,10,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 10) WHERE vStockID='F020664'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020044',@project,8,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 8) WHERE vStockID='F020044'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020050',@project,6,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 6) WHERE vStockID='F020050'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010009',@project,20,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 20) WHERE vStockID='F010009'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060286',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='A060286'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010057',@project,5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 5) WHERE vStockID='F010057'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A0100001',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='A0100001'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A050044',@project,20,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 20) WHERE vStockID='A050044'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A040024',@project,25,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 25) WHERE vStockID='A040024'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A040023',@project,34,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 34) WHERE vStockID='A040023'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A0600362',@project,19,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 19) WHERE vStockID='A0600362'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A030050',@project,26,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 26) WHERE vStockID='A030050'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070393',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F070393'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070394',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F070394'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070004',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F070004'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F0700156',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F0700156'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F0700154',@project,4,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 4) WHERE vStockID='F0700154'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070294',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F070294'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070015',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F070015'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F0700200',@project,4,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 4) WHERE vStockID='F0700200'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070220',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F070220'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A040037',@project,4,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 4) WHERE vStockID='A040037'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A040033',@project,7,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 7) WHERE vStockID='A040033'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F0700039',@project,10,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 10) WHERE vStockID='F0700039'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070012',@project,8,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 8) WHERE vStockID='F070012'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'E044013',@project,82,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 82) WHERE vStockID='E044013'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'S000061',@project,5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 5) WHERE vStockID='S000061'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070048',@project,10,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 10) WHERE vStockID='F070048'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'AAP00623',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='AAP00623'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'AAP00642',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='AAP00642'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQM00103',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQM00103'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQM00137',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQM00137'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQM0475',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQM0475'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQM0474',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQM0474'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQM00042',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQM00042'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQM0526',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQM0526'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T0000060',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='T0000060'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T0000061',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='T0000061'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T0000026',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='T0000026'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T0221',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='T0221'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T0371',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='T0371'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T0401',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='T0401'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQA00131',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQA00131'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQM0486',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQM0486'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'C0100015',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='C0100015' AND iEnable=0),2760,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'C010030',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='C010030' AND iEnable=0),100,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'C020091',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='C020091' AND iEnable=0),420,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A061091',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A061091' AND iEnable=0),7,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A061065',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A061065' AND iEnable=0),16,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'C010040',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='C010040' AND iEnable=0),207,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T26',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T26' AND iEnable=0),6,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070233',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070233' AND iEnable=0),13,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'S000079',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='S000079' AND iEnable=0),20,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060021',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060021' AND iEnable=0),5,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A040042',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A040042' AND iEnable=0),10,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060019',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060019' AND iEnable=0),3,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060105',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060105' AND iEnable=0),3,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A040068',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A040068' AND iEnable=0),12,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A030041',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A030041' AND iEnable=0),0.5,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A0600142',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A0600142' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010080',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010080' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010152',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010152' AND iEnable=0),100,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060602',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060602' AND iEnable=0),3,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010014',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010014' AND iEnable=0),3,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010445',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010445' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010076',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010076' AND iEnable=0),24,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'S000072',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='S000072' AND iEnable=0),25,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'S000063',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='S000063' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060249',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060249' AND iEnable=0),431,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060248',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060248' AND iEnable=0),20,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060242',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060242' AND iEnable=0),106,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A050175',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A050175' AND iEnable=0),1000,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A050073',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A050073' AND iEnable=0),28.5,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'C0600001',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='C0600001' AND iEnable=0),43,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'E033002',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='E033002' AND iEnable=0),6,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020073',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020073' AND iEnable=0),3,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010030',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010030' AND iEnable=0),13,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010008',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010008' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020002',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020002' AND iEnable=0),4,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010007',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010007' AND iEnable=0),5,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A0600766',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A0600766' AND iEnable=0),5050,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A0600764',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A0600764' AND iEnable=0),760,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070059',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070059' AND iEnable=0),3,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060063',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060063' AND iEnable=0),6,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060097',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060097' AND iEnable=0),16,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020664',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020664' AND iEnable=0),10,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020044',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020044' AND iEnable=0),8,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020050',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020050' AND iEnable=0),6,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010009',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010009' AND iEnable=0),20,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060286',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060286' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010057',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010057' AND iEnable=0),5,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A0100001',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A0100001' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A050044',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A050044' AND iEnable=0),20,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A040024',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A040024' AND iEnable=0),25,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A040023',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A040023' AND iEnable=0),34,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A0600362',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A0600362' AND iEnable=0),19,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A030050',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A030050' AND iEnable=0),26,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070393',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070393' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070394',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070394' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070004',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070004' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F0700156',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F0700156' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F0700154',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F0700154' AND iEnable=0),4,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070294',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070294' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070015',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070015' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F0700200',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F0700200' AND iEnable=0),4,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070220',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070220' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A040037',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A040037' AND iEnable=0),4,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A040033',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A040033' AND iEnable=0),7,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F0700039',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F0700039' AND iEnable=0),10,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070012',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070012' AND iEnable=0),8,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'E044013',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='E044013' AND iEnable=0),82,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'S000061',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='S000061' AND iEnable=0),5,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070048',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070048' AND iEnable=0),10,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'AAP00623',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='AAP00623' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'AAP00642',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='AAP00642' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQM00103',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQM00103' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQM00137',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQM00137' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQM0475',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQM0475' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQM0474',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQM0474' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQM00042',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQM00042' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQM0526',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQM0526' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T0000060',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T0000060' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T0000061',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T0000061' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T0000026',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T0000026' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T0221',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T0221' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T0371',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T0371' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T0401',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T0401' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQA00131',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQA00131' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQM0486',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQM0486' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date

GO
-- RETURN STOCK 7
DECLARE @project NVARCHAR(16)
DECLARE @date DATETIME
DECLARE @newSIV NVARCHAR(50)
DECLARE @maxSIV NVARCHAR(50)
SET @maxSIV = (SELECT TOP 1 SRV FROM dbo.WAMS_SRV (NOLOCK) WHERE [Status]='RETURN' ORDER BY SRV DESC)
SET @newSIV = 'R' + CAST((CAST(substring(@maxSIV,2,12) AS INT) + 1) AS VARCHAR(12))
SET @project = '211 01 0001'
SET @date = '2015-12-17'
INSERT INTO dbo.WAMS_SRV ([SRV],[Status],[dDate]) SELECT @newSIV,'RETURN',@date
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A050080',@project,5,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 5) WHERE vStockID='A050080'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060099',@project,17,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 17) WHERE vStockID='A060099'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A060098',@project,13,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 13) WHERE vStockID='A060098'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'A0600156',@project,49,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 49) WHERE vStockID='A0600156'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F010093',@project,10,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 10) WHERE vStockID='F010093'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F030318',@project,4,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 4) WHERE vStockID='F030318'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020460',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F020460'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020451',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F020451'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020450',@project,7,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 7) WHERE vStockID='F020450'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020453',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F020453'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020452',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F020452'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F020074',@project,3,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 3) WHERE vStockID='F020074'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070094',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='F070094'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070163',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F070163'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070445',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F070445'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070444',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F070444'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070446',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='F070446'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'EQM0445',@project,1,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 1) WHERE vStockID='EQM0445'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'T02',@project,2,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 2) WHERE vStockID='T02'
INSERT INTO [dbo].[WAMS_RETURN_LIST]([vStockID],[vProjectID],[bQuantity],[dDateReturn],[SRV]) 
 SELECT 'F070154',@project,3,@date,@newSIV
UPDATE dbo.WAMS_STOCK SET bQuantity = (bQuantity + 3) WHERE vStockID='F070154'
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A050080',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A050080' AND iEnable=0),5,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060099',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060099' AND iEnable=0),17,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A060098',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A060098' AND iEnable=0),13,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'A0600156',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='A0600156' AND iEnable=0),49,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F010093',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F010093' AND iEnable=0),10,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F030318',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F030318' AND iEnable=0),4,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020460',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020460' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020451',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020451' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020450',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020450' AND iEnable=0),7,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020453',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020453' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020452',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020452' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F020074',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F020074' AND iEnable=0),3,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070094',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070094' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070163',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070163' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070445',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070445' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070444',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070444' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070446',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070446' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'EQM0445',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='EQM0445' AND iEnable=0),1,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'T02',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='T02' AND iEnable=0),2,0,'RETURN',@newSIV,1,@project,@date
INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY]([vStockID],[dQuantityCurrent],[dQuantityChange],[dQuantityAfterChange],[vStatus],[vStatusID],[bUserID],[vProjectID],[dDate])
     SELECT 'F070154',(SELECT bQuantity FROM dbo.WAMS_STOCK WHERE vStockID='F070154' AND iEnable=0),3,0,'RETURN',@newSIV,1,@project,@date

GO
UPDATE dbo.WAMS_STOCK_MANAGEMENT_QUANTITY SET dQuantityAfterChange = (dQuantityCurrent + dQuantityChange)
WHERE vStatus='RETURN' AND bUserID=1 AND dQuantityAfterChange=0 AND ID>89990 
GO
SELECT DISTINCT vStatusID, vProjectID FROM dbo.WAMS_STOCK_MANAGEMENT_QUANTITY (NOLOCK)
WHERE bUserID=1 AND vStatus='RETURN' AND ID>9999
