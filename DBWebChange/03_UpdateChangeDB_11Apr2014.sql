GO
INSERT INTO dbo.Functions(Id,Name) VALUES (1,'User')
INSERT INTO dbo.Functions(Id,Name) VALUES (2,'Store')
INSERT INTO dbo.Functions(Id,Name) VALUES (3,'Project')
INSERT INTO dbo.Functions(Id,Name) VALUES (4,'Stock')
INSERT INTO dbo.Functions(Id,Name) VALUES (5,'Supplier')
INSERT INTO dbo.Functions(Id,Name) VALUES (6,'Requisition')
INSERT INTO dbo.Functions(Id,Name) VALUES (7,'PE')
INSERT INTO dbo.Functions(Id,Name) VALUES (8,'Fulfillment')
INSERT INTO dbo.Functions(Id,Name) VALUES (9,'Return to Supplier')
INSERT INTO dbo.Functions(Id,Name) VALUES (10,'Stock Type')
INSERT INTO dbo.Functions(Id,Name) VALUES (11,'Category')
GO
UPDATE dbo.WAMS_USER SET iEnable=2 WHERE iEnable=0
GO
UPDATE dbo.WAMS_USER SET iEnable= 3 WHERE iEnable=1
GO
UPDATE dbo.WAMS_USER SET iEnable = 0 WHERE iEnable=3
GO
UPDATE dbo.WAMS_USER SET iEnable = 1 WHERE iEnable=2
GO
-- password@123
UPDATE dbo.WAMS_USER SET vNewPassword='4617ECF11B542A14F3D0AE5591BF181FE139C563';
GO
UPDATE dbo.WAMS_USER SET storeId=1
GO
UPDATE dbo.WAMS_FUNCTION_MANAGEMENT SET
[User] = 0, 
Project = 0, 
Store = 0,
Stock = 0,
Requisition = 0,
StockOut = 0,
StockReturn = 0,
StockIn = 0,
ReActiveStock = 0,
PE = 0, 
Supplier = 0, 
Price = 0,
StockService = 0,
Accounting = 0,
Maintenance = 0,
Worker = 0, 
Shippment = 0,
ReturnSupplier = 0,
StockType = 0,
Category = 0
GO
INSERT INTO dbo.Country (Iso, NameBasic, NameNice, Iso3, NumCode, PhoneCode, iEnable) VALUES
('VN', 'VIET NAM', 'Viet Nam', 'VNM', 704, 84, 1);
INSERT INTO dbo.Country (Iso, NameBasic, NameNice, Iso3, NumCode, PhoneCode, iEnable) VALUES
('ML', 'MALAYSIA', 'Malaysia', 'ML', 704, 84, 1);
GO
INSERT INTO dbo.Store (Name,Code,CountryId, iEnable) VALUES ('Malaysia','Malaysia',1,1)
GO
UPDATE dbo.WAMS_PROJECT SET iEnable=2 WHERE iEnable=0
GO
UPDATE dbo.WAMS_PROJECT SET iEnable= 3 WHERE iEnable=1
GO
UPDATE dbo.WAMS_PROJECT SET iEnable = 0 WHERE iEnable=3
GO
UPDATE dbo.WAMS_PROJECT SET iEnable = 1 WHERE iEnable=2
GO
UPDATE dbo.WAMS_PROJECT SET StatusId=1, EnableRequisition =1, EnablePO =1
GO
--UPDATE dbo.WAMS_PROJECT SET CountryId = (select Id FROM Country WHERE NameNice like '%Viet%')
UPDATE dbo.WAMS_PROJECT SET CountryId = (select Id FROM Country WHERE NameNice like '%Ma%')
GO
DELETE Project_Client
INSERT INTO dbo.Project_Client(Name)
SELECT DISTINCT vClient FROM dbo.WAMS_PROJECT WHERE vClient !='';
GO
UPDATE WP 
SET WP.ClientId = P.Id
FROM dbo.WAMS_PROJECT AS WP
INNER JOIN dbo.Project_Client AS P
       ON WP.vClient = P.Name  
GO
UPDATE WP 
SET WP.Suppervisor = S.bSupervisorID
FROM dbo.WAMS_PROJECT AS WP
INNER JOIN dbo.WAMS_PROJECT_SUPERVISOR AS S
       ON WP.vProjectID = S.vProjectID
GO
UPDATE dbo.WAMS_PROJECT SET vProjectName = vProjectID WHERE vProjectName = ''
GO
INSERT INTO dbo.WAMS_STOCK_TYPE (TypeName, TypeCode, iEnable) VALUES ('Consumable', 'CS', 1);
INSERT INTO dbo.WAMS_STOCK_TYPE (TypeName, TypeCode, iEnable)  VALUES ('Equipment', 'EQ', 1);
INSERT INTO dbo.WAMS_STOCK_TYPE (TypeName, TypeCode, iEnable) VALUES ('Material','MT', 1);
INSERT INTO dbo.WAMS_STOCK_TYPE (TypeName, TypeCode, iEnable) VALUES ('Paint','PA', 1);
INSERT INTO dbo.WAMS_STOCK_TYPE (TypeName, TypeCode, iEnable) VALUES ('Scaffolding','SC', 1);
INSERT INTO dbo.WAMS_STOCK_TYPE (TypeName, TypeCode, iEnable) VALUES ('Sparepart','SP', 1);
INSERT INTO dbo.WAMS_STOCK_TYPE (TypeName, TypeCode, iEnable) VALUES ('Tool','TO', 1);
INSERT INTO dbo.WAMS_STOCK_TYPE (TypeName, TypeCode, iEnable) VALUES ('Service','SE', 1);
GO
-- SERVICE MANAGEMENT INTO STOCK
INSERT INTO dbo.WAMS_STOCK (vStockID, vStockName, vRemark, bCategoryID, bUnitID, bPositionID, iEnable,iType)
SELECT vIDServiceItem, vServiceItemName, vDescription, bCategoryID, bUnitID, bPositionID, iEnable,8 FROM dbo.WAMS_ITEMS_SERVICE
GO

UPDATE dbo.WAMS_STOCK SET iType=1, [Type]='Consumable' WHERE vStockType='Consumable';
UPDATE dbo.WAMS_STOCK SET iType=2, [Type]='Equipment' WHERE vStockType='Equipment';
UPDATE dbo.WAMS_STOCK SET iType=3, [Type]='Material' WHERE vStockType='Material';
UPDATE dbo.WAMS_STOCK SET iType=4, [Type]='Paint' WHERE vStockType='Paint';
UPDATE dbo.WAMS_STOCK SET iType=5, [Type]='Scaffolding' WHERE vStockType='Scaffolding';
UPDATE dbo.WAMS_STOCK SET iType=6, [Type]='Sparepart' WHERE vStockType='Sparepart';
UPDATE dbo.WAMS_STOCK SET iType=7, [Type]='Tool' WHERE vStockType='Tool';
UPDATE dbo.WAMS_STOCK SET iType=8, [Type]='Service' WHERE vStockType='Service';
GO

UPDATE dbo.WAMS_STOCK SET iEnable=2 WHERE iEnable=0
GO
UPDATE dbo.WAMS_STOCK SET iEnable= 3 WHERE iEnable=1
GO
UPDATE dbo.WAMS_STOCK SET iEnable = 0 WHERE iEnable=3
GO
UPDATE dbo.WAMS_STOCK SET iEnable = 1 WHERE iEnable=2
GO
-- Insert data FROM PAINT, SPAREPART
UPDATE WAS 
SET WAS.PartNo = S.vPartNo,
WAS.PartNoFor = S.vFor,
WAS.PartNoMiniQty = S.bMinimumQuantity
FROM dbo.WAMS_STOCK AS WAS
INNER JOIN dbo.WAMS_SPAREPART AS S
       ON WAS.vStockID = S.vSparepartID
GO
UPDATE WAS 
SET WAS.RalNo = S.vRalNo,
WAS.ColorName = S.vColorName,
WAS.Position = S.vPosition,
WAS.SubCategory = S.bSubcategoryID,
WAS.UserForPaint = S.bUseForID
FROM dbo.WAMS_STOCK AS WAS
INNER JOIN dbo.WAMS_PAINT AS S
       ON WAS.vStockID = S.vPaintID
GO
UPDATE dbo.WAMS_CATEGORY SET iType=1 WHERE vCategoryType='Consumable';
UPDATE dbo.WAMS_CATEGORY SET iType=2 WHERE vCategoryType='Equipment';
UPDATE dbo.WAMS_CATEGORY SET iType=3 WHERE vCategoryType='Material';
UPDATE dbo.WAMS_CATEGORY SET iType=4 WHERE vCategoryType='Paint';
UPDATE dbo.WAMS_CATEGORY SET iType=5 WHERE vCategoryType='Scaffolding';
UPDATE dbo.WAMS_CATEGORY SET iType=6 WHERE vCategoryType='Sparepart';
UPDATE dbo.WAMS_CATEGORY SET iType=7 WHERE vCategoryType='Tool';
UPDATE dbo.WAMS_CATEGORY SET iType=8 WHERE vCategoryType='Service';
GO
UPDATE dbo.WAMS_UNIT SET iType=1 WHERE vUnitType='Consumable';
UPDATE dbo.WAMS_UNIT SET iType=2 WHERE vUnitType='Equipment';
UPDATE dbo.WAMS_UNIT SET iType=3 WHERE vUnitType='Material';
UPDATE dbo.WAMS_UNIT SET iType=4 WHERE vUnitType='Paint';
UPDATE dbo.WAMS_UNIT SET iType=5 WHERE vUnitType='Scaffolding';
UPDATE dbo.WAMS_UNIT SET iType=6 WHERE vUnitType='Sparepart';
UPDATE dbo.WAMS_UNIT SET iType=7 WHERE vUnitType='Tool';
UPDATE dbo.WAMS_UNIT SET iType=8 WHERE vUnitType='Service';
GO
UPDATE dbo.WAMS_LABELS SET iType=1 WHERE vStockType='Consumable';
UPDATE dbo.WAMS_LABELS SET iType=2 WHERE vStockType='Equipment';
UPDATE dbo.WAMS_LABELS SET iType=3 WHERE vStockType='Material';
UPDATE dbo.WAMS_LABELS SET iType=4 WHERE vStockType='Paint';
UPDATE dbo.WAMS_LABELS SET iType=5 WHERE vStockType='Scaffolding';
UPDATE dbo.WAMS_LABELS SET iType=6 WHERE vStockType='Sparepart';
UPDATE dbo.WAMS_LABELS SET iType=7 WHERE vStockType='Tool';
UPDATE dbo.WAMS_LABELS SET iType=8 WHERE vStockType='Service';
GO

/* MIGRATE WAMS_STOCK, WAMS_PROJECT LOST DATA => DELETE SOLUTION */
DELETE WAMS_STOCK_MANAGEMENT_QUANTITY WHERE ID IN (select a.ID from WAMS_STOCK_MANAGEMENT_QUANTITY a
LEFT JOIN WAMS_STOCK b ON a.vStockID = b.vStockID
WHERE b.vStockID IS NULL)
GO
DELETE WAMS_STOCK_MANAGEMENT_QUANTITY WHERE ID IN (select a.ID from WAMS_STOCK_MANAGEMENT_QUANTITY a
LEFT JOIN WAMS_PROJECT b ON a.vProjectID = b.vProjectID
WHERE b.vProjectID IS NULL and a.vProjectID IS NOT NULL)
GO
DELETE WAMS_ASSIGNNING_STOCKS WHERE bAssignningStockID IN (select a.bAssignningStockID from WAMS_ASSIGNNING_STOCKS a
LEFT JOIN WAMS_STOCK b ON a.vStockID = b.vStockID
WHERE b.vStockID IS NULL)
GO
DELETE WAMS_ASSIGNNING_STOCKS WHERE bAssignningStockID IN (select a.bAssignningStockID from WAMS_ASSIGNNING_STOCKS a
LEFT JOIN WAMS_PROJECT b ON a.vProjectID = b.vProjectID
WHERE b.vProjectID IS NULL and a.vProjectID IS NOT NULL)
GO 
DELETE WAMS_RETURN_LIST WHERE bReturnListID IN (select a.bReturnListID from WAMS_RETURN_LIST a
LEFT JOIN WAMS_STOCK b ON a.vStockID = b.vStockID
WHERE b.vStockID IS NULL)
GO   
DELETE WAMS_RETURN_LIST WHERE bReturnListID IN (select a.bReturnListID from WAMS_RETURN_LIST a
LEFT JOIN WAMS_PROJECT b ON a.vProjectID = b.vProjectID
WHERE b.vProjectID IS NULL and a.vProjectID IS NOT NULL)
GO
DELETE WAMS_PRODUCT WHERE ID IN (select a.ID from WAMS_PRODUCT a
LEFT JOIN WAMS_STOCK b ON a.vProductID = b.vStockID
WHERE b.vStockID IS NULL)
GO
DELETE WAMS_REQUISITION_DETAILS WHERE Id IN (select a.Id from WAMS_REQUISITION_DETAILS a
LEFT JOIN WAMS_STOCK b ON a.vStockID = b.vStockID
WHERE b.vStockID IS NULL)
GO
DELETE WAMS_REQUISITION_MASTER WHERE Id IN (select a.Id from WAMS_REQUISITION_MASTER a
LEFT JOIN WAMS_PROJECT b ON a.vProjectID = b.vProjectID
WHERE b.vProjectID IS NULL and a.vProjectID IS NOT NULL)
GO
DELETE WAMS_PO_DETAILS WHERE Id IN (select a.Id from WAMS_PO_DETAILS a
LEFT JOIN WAMS_STOCK b ON a.vProductID = b.vStockID
WHERE b.vStockID IS NULL)
GO
DELETE WAMS_PURCHASE_ORDER WHERE Id IN (select a.Id from WAMS_PURCHASE_ORDER a
LEFT JOIN WAMS_PROJECT b ON a.vProjectID = b.vProjectID
WHERE b.vProjectID IS NULL and a.vProjectID IS NOT NULL)
GO
DELETE WAMS_PO_DETAILS WHERE Id IN (select a.Id from WAMS_PO_DETAILS a
LEFT JOIN WAMS_PURCHASE_ORDER b ON a.vPOID = b.vPOID
WHERE b.vPOID IS NULL)
GO 
DELETE WAMS_FULFILLMENT_DETAIL WHERE Id IN (select a.Id from WAMS_FULFILLMENT_DETAIL a
LEFT JOIN WAMS_STOCK b ON a.vStockID = b.vStockID
WHERE b.vStockID IS NULL)
GO

/* END MIGRATE WAMS_STOCK, WAMS_PROJECT LOST DATA => DELETE SOLUTION */

UPDATE WAS 
SET WAS.vStockID = S.Id
FROM dbo.WAMS_STOCK_MANAGEMENT_QUANTITY AS WAS
INNER JOIN dbo.WAMS_STOCK AS S
       ON WAS.vStockID = S.vStockID
GO   
UPDATE WAS 
SET WAS.vProjectID = P.Id
FROM dbo.WAMS_STOCK_MANAGEMENT_QUANTITY AS WAS
INNER JOIN dbo.WAMS_PROJECT AS P
       ON WAS.vProjectID = P.vProjectID
GO 
UPDATE WAS 
SET WAS.vStockID = S.Id
FROM dbo.WAMS_ASSIGNNING_STOCKS AS WAS
INNER JOIN dbo.WAMS_STOCK AS S
       ON WAS.vStockID = S.vStockID
GO  
UPDATE WAS 
SET WAS.vProjectID = P.Id
FROM dbo.WAMS_ASSIGNNING_STOCKS AS WAS
INNER JOIN dbo.WAMS_PROJECT AS P
       ON WAS.vProjectID = P.vProjectID
GO   
UPDATE WAS 
SET WAS.vStockID = S.Id
FROM dbo.WAMS_RETURN_LIST AS WAS
INNER JOIN WAMS_STOCK AS S
       ON WAS.vStockID = S.vStockID
GO 
UPDATE WAS 
SET WAS.vProjectID = P.Id
FROM dbo.WAMS_RETURN_LIST AS WAS
INNER JOIN dbo.WAMS_PROJECT AS P
       ON WAS.vProjectID = P.vProjectID
GO      
UPDATE dbo.WAMS_SUPPLIER SET iEnable=2 WHERE iEnable=0
UPDATE dbo.WAMS_SUPPLIER SET iEnable= 3 WHERE iEnable=1
UPDATE dbo.WAMS_SUPPLIER SET iEnable = 0 WHERE iEnable=3
UPDATE dbo.WAMS_SUPPLIER SET iEnable = 1 WHERE iEnable=2
UPDATE dbo.WAMS_SUPPLIER SET iMarket = 1 WHERE vMarket='Checked'
UPDATE dbo.WAMS_SUPPLIER SET iMarket = 0 WHERE vMarket!='Checked'
UPDATE dbo.WAMS_SUPPLIER SET vCountry='Viet Nam' WHERE vCountry=''
UPDATE dbo.WAMS_SUPPLIER SET vCountry='Viet Nam' WHERE vCountry='Add new item'
UPDATE dbo.WAMS_SUPPLIER SET vCountry='Brazil' WHERE vCountry='Brasil'
UPDATE dbo.WAMS_SUPPLIER SET vCountry='United Kingdom' WHERE vCountry='England'
UPDATE dbo.WAMS_SUPPLIER SET vCountry='Hong Kong' WHERE vCountry='Hongkong'
UPDATE dbo.WAMS_SUPPLIER SET vCountry='South Korea' WHERE vCountry='Korea'
UPDATE dbo.WAMS_SUPPLIER SET vCountry='Ukraine' WHERE vCountry='Ucraine'
UPDATE dbo.WAMS_SUPPLIER SET vCountry='United Kingdom' WHERE vCountry='UK'
UPDATE dbo.WAMS_SUPPLIER SET vCountry='United States' WHERE vCountry='US'
GO
UPDATE WP 
SET WP.CountryId = P.Id
FROM dbo.WAMS_SUPPLIER AS WP
INNER JOIN dbo.Country AS P
       ON WP.vCountry = P.NameNice
GO
UPDATE WAS 
SET WAS.vProductID = S.Id
FROM dbo.WAMS_PRODUCT AS WAS
INNER JOIN WAMS_STOCK AS S
       ON WAS.vProductID = S.vStockID
GO
UPDATE dbo.WAMS_PRODUCT SET iEnable=2 WHERE iEnable=0
UPDATE dbo.WAMS_PRODUCT SET iEnable= 3 WHERE iEnable=1
UPDATE dbo.WAMS_PRODUCT SET iEnable = 0 WHERE iEnable=3
UPDATE dbo.WAMS_PRODUCT SET iEnable = 1 WHERE iEnable=2
GO
UPDATE WAS 
SET WAS.vProjectID = P.Id
FROM dbo.WAMS_REQUISITION_MASTER AS WAS
INNER JOIN dbo.WAMS_PROJECT AS P
       ON WAS.vProjectID = P.vProjectID
GO   
UPDATE dbo.WAMS_REQUISITION_MASTER SET iStore = 1     
UPDATE dbo.WAMS_REQUISITION_MASTER SET iEnable=2 WHERE iEnable=0
UPDATE dbo.WAMS_REQUISITION_MASTER SET iEnable= 3 WHERE iEnable=1
UPDATE dbo.WAMS_REQUISITION_MASTER SET iEnable = 0 WHERE iEnable=3
UPDATE dbo.WAMS_REQUISITION_MASTER SET iEnable = 1 WHERE iEnable=2
UPDATE dbo.WAMS_REQUISITION_DETAILS SET iEnable=2 WHERE iEnable=0
UPDATE dbo.WAMS_REQUISITION_DETAILS SET iEnable= 3 WHERE iEnable=1
UPDATE dbo.WAMS_REQUISITION_DETAILS SET iEnable = 0 WHERE iEnable=3
UPDATE dbo.WAMS_REQUISITION_DETAILS SET iEnable = 1 WHERE iEnable=2
GO
UPDATE WAS 
SET WAS.vStockID = S.Id
FROM dbo.WAMS_REQUISITION_DETAILS AS WAS
INNER JOIN dbo.WAMS_STOCK AS S
       ON WAS.vStockID = S.vStockID
GO
UPDATE WAS 
SET WAS.vMRF = S.Id
FROM dbo.WAMS_REQUISITION_DETAILS AS WAS
INNER JOIN dbo.WAMS_REQUISITION_MASTER AS S
       ON WAS.vMRF = S.vMRF
GO   
UPDATE dbo.WAMS_PO_DETAILS
SET vMRF = 0
WHERE vMRF not in (select vMRF FROM dbo.WAMS_REQUISITION_MASTER)
GO
UPDATE WAS 
SET WAS.vMRF = S.Id
FROM dbo.WAMS_PO_DETAILS AS WAS
INNER JOIN dbo.WAMS_REQUISITION_MASTER AS S
       ON WAS.vMRF = S.vMRF
GO
UPDATE WAS 
SET WAS.vMRF = S.Id
FROM dbo.WAMS_STOCK_MANAGEMENT_QUANTITY AS WAS
INNER JOIN dbo.WAMS_REQUISITION_MASTER AS S
       ON WAS.vMRF = S.vMRF
GO
UPDATE dbo.WAMS_PURCHASE_ORDER SET iStore = 1
UPDATE dbo.WAMS_PURCHASE_ORDER SET iEnable=2 WHERE iEnable=0
UPDATE dbo.WAMS_PURCHASE_ORDER SET iEnable= 3 WHERE iEnable=1
UPDATE dbo.WAMS_PURCHASE_ORDER SET iEnable = 0 WHERE iEnable=3
UPDATE dbo.WAMS_PURCHASE_ORDER SET iEnable = 1 WHERE iEnable=2
UPDATE dbo.WAMS_PURCHASE_ORDER SET dCreated = dPODate, iCreated = 1
GO  
UPDATE WAS 
SET WAS.vProjectID = P.Id
FROM dbo.WAMS_PURCHASE_ORDER AS WAS
INNER JOIN dbo.WAMS_PROJECT AS P
       ON WAS.vProjectID = P.vProjectID
GO      
UPDATE dbo.WAMS_PO_DETAILS SET iEnable=2 WHERE iEnable=0
UPDATE dbo.WAMS_PO_DETAILS SET iEnable= 3 WHERE iEnable=1
UPDATE dbo.WAMS_PO_DETAILS SET iEnable = 0 WHERE iEnable=3
UPDATE dbo.WAMS_PO_DETAILS SET iEnable = 1 WHERE iEnable=2
GO
UPDATE WAS 
SET WAS.vProductID = S.Id
FROM dbo.WAMS_PO_DETAILS AS WAS
INNER JOIN dbo.WAMS_STOCK AS S
       ON WAS.vProductID = S.vStockID
GO
UPDATE WAS 
SET WAS.vPOID = P.Id
FROM dbo.WAMS_PO_DETAILS AS WAS
INNER JOIN dbo.WAMS_PURCHASE_ORDER AS P
       ON WAS.vPOID = P.vPOID

GO 
  
UPDATE WAS 
SET WAS.vPOID = P.Id
FROM dbo.WAMS_STOCK_MANAGEMENT_QUANTITY AS WAS
INNER JOIN dbo.WAMS_PURCHASE_ORDER AS P
       ON WAS.vPOID = P.vPOID
GO 

UPDATE WAS 
SET WAS.vPOID = P.Id
FROM dbo.WAMS_FULFILLMENT_DETAIL AS WAS
INNER JOIN dbo.WAMS_PURCHASE_ORDER AS P
       ON WAS.vPOID = P.vPOID
GO 
UPDATE dbo.WAMS_FULFILLMENT_DETAIL SET iEnable=2 WHERE iEnable=0
GO
UPDATE dbo.WAMS_FULFILLMENT_DETAIL SET iEnable= 3 WHERE iEnable=1
GO
UPDATE dbo.WAMS_FULFILLMENT_DETAIL SET iEnable = 0 WHERE iEnable=3
GO
UPDATE dbo.WAMS_FULFILLMENT_DETAIL SET iEnable = 1 WHERE iEnable=2
GO
UPDATE WAS 
SET WAS.vStockID = S.Id
FROM dbo.WAMS_FULFILLMENT_DETAIL AS WAS
INNER JOIN dbo.WAMS_STOCK AS S
       ON WAS.vStockID = S.vStockID 
GO   
INSERT INTO dbo.PaymentTerm(PaymentName)
SELECT DISTINCT vTermOfPayment FROM dbo.WAMS_SUPPLIER WHERE vTermOfPayment !='';
GO
UPDATE dbo.PaymentTerm SET iEnable= 1
GO
UPDATE WP 
SET WP.iPayment = P.Id
FROM dbo.WAMS_SUPPLIER AS WP
INNER JOIN dbo.PaymentTerm AS P
       ON WP.vTermOfPayment = P.PaymentName
GO
UPDATE WP 
SET WP.iPayment = P.Id
FROM dbo.WAMS_PURCHASE_ORDER AS WP
INNER JOIN dbo.PaymentTerm AS P
       ON WP.vTermOfPayment = P.PaymentName
GO
-- UPDATE Price
INSERT INTO dbo.Product_Price (StockId, Price, StoreId, SupplierId ,CurrencyId, iEnable)
SELECT vProductID, bBestPrice, 1, bSupplierID, bCurrencyTypeID, 1
FROM dbo.WAMS_PRODUCT
GO
UPDATE dbo.Product_Price SET dCreated = GETDATE(), iCreated = 1, dStart = GETDATE()
GO
-- UPDATE Store_Stock
INSERT INTO dbo.Store_Stock (Store, StockID, Quantity)
SELECT 1, Id, bQuantity
FROM dbo.WAMS_STOCK
GO
UPDATE dbo.WAMS_PRODUCT SET dCreated=dDateAssign
GO
UPDATE dbo.WAMS_REQUISITION_MASTER SET dCreated=dDeliverDate
GO
DELETE [dbo].[SIV] 
GO
DBCC CHECKIDENT(SIV, RESEED, 0)
GO
INSERT INTO SIV (SIV, vStatus, CreatedDate)
SELECT DISTINCT SIV, 'OUT', dDateAssign FROM dbo.WAMS_ASSIGNNING_STOCKS WHERE SIV is not null ORDER BY dDateAssign asc
GO
UPDATE dbo.WAMS_ASSIGNNING_STOCKS SET dCreated=dDateAssign
GO
UPDATE dbo.WAMS_RETURN_LIST SET dCreated=dDateReturn
GO
UPDATE dbo.WAMS_ASSIGNNING_STOCKS SET FROMStore=1
GO
UPDATE dbo.WAMS_ASSIGNNING_STOCKS SET iCreated=1
GO
UPDATE dbo.WAMS_USER SET vFirstName='Xuan', vLastName='Tran' WHERE bUserId=1
GO
UPDATE dbo.WAMS_RETURN_LIST SET FROMStore=1
GO
UPDATE dbo.WAMS_PROJECT SET vStatus='Open' WHERE vStatus NOT IN ('Open','Completed','Cancel')
GO
UPDATE dbo.WAMS_PROJECT
SET vProjectID = replace(vProjectID, ' ', '')
GO
-- AccCheck : 1: Uncheck 2: Process 3:Checked
UPDATE dbo.WAMS_ASSIGNNING_STOCKS SET AccCheck=1
GO
UPDATE dbo.WAMS_RETURN_LIST SET AccCheck=1
GO
UPDATE dbo.WAMS_FULFILLMENT_DETAIL SET AccCheck=1
GO
UPDATE dbo.WAMS_ASSIGNNING_STOCKS SET FlagFile=0
GO
UPDATE dbo.WAMS_RETURN_LIST SET FlagFile=0
GO
UPDATE dbo.WAMS_FULFILLMENT_DETAIL SET FlagFile=0
GO
UPDATE dbo.SRV SET [Status]='IN' WHERE [Status] ='FULFILLMENT'
GO
UPDATE dbo.WAMS_FULFILLMENT_DETAIL SET dCreated=dDateAssign, iCreated=1, iStore=1
GO
-- update stock above. No need do service
--UPDATE dbo.WAMS_STOCK SET iEnable=2 WHERE iEnable=0
--GO
--UPDATE dbo.WAMS_ITEMS_SERVICE SET iEnable= 3 WHERE iEnable=1
--GO
--UPDATE dbo.WAMS_ITEMS_SERVICE SET iEnable = 0 WHERE iEnable=3
--GO
--UPDATE dbo.WAMS_ITEMS_SERVICE SET iEnable = 1 WHERE iEnable=2
--GO