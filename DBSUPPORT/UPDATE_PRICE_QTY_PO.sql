DECLARE @PO NVARCHAR(30)
DECLARE @Product NVARCHAR(30)
DECLARE @Price FLOAT
SET @PO = 'DEC/14/7670'
SET @Product = 'A060658'
SET @Price = 13208.9743
select * from WAMS_PURCHASE_ORDER where vPOID=@PO
select * from WAMS_PO_DETAILS where vPOID=@PO and vProductID=@Product
UPDATE WAMS_PO_DETAILS SET fUnitPrice=@Price WHERE vPOID=@PO and vProductID=@Product and iEnable=0
UPDATE WAMS_PO_DETAILS SET fItemTotal= ((fQuantity*fUnitPrice) + (fQuantity*fUnitPrice*fVAT/100)) WHERE vPOID=@PO and vProductID=@Product and iEnable=0
UPDATE WAMS_PURCHASE_ORDER SET fPOTotal = (select SUM(fItemTotal) from WAMS_PO_DETAILS where vPOID=@PO and iEnable=0)
where vPOID=@PO

---
GO
DECLARE @QtyChange INT
DECLARE @QtyAverage INT
DECLARE @POID NVARCHAR(30)
DECLARE @ProductId NVARCHAR(30)
SET @QtyChange = 60
SET @POID='DEC/14/7181'
SET @ProductId='A010002'
SET @QtyAverage = (SELECT fQuantity FROM WAMS_PO_DETAILS WHERE vPOID=@POID and vProductID=@ProductId and iEnable=0) - @QtyChange
UPDATE WAMS_PO_DETAILS SET fQuantity=@QtyChange WHERE vPOID=@POID and vProductID=@ProductId and iEnable=0
UPDATE WAMS_PO_DETAILS SET fItemTotal= ((fQuantity*fUnitPrice) + (fQuantity*fUnitPrice*fVAT/100)) WHERE vPOID=@POID and vProductID=@ProductId and iEnable=0
UPDATE WAMS_PURCHASE_ORDER SET fPOTotal = (select SUM(fItemTotal) from WAMS_PO_DETAILS where vPOID=@POID and iEnable=0) WHERE vPOID=@POID
UPDATE WAMS_FULFILLMENT_DETAIL set dQuantity=@QtyChange, dReceivedQuantity=@QtyChange where ID=29365
UPDATE WAMS_STOCK set bQuantity=(bQuantity-@QtyAverage) where vStockID=@ProductId
UPDATE WAMS_STOCK_MANAGEMENT_QUANTITY 
SET dQuantityChange= (dQuantityChange-@QtyAverage), 
dQuantityAfterChange = (dQuantityAfterChange-@QtyAverage) 
where ID=67159
UPDATE WAMS_STOCK_MANAGEMENT_QUANTITY 
SET dQuantityAfterChange = (dQuantityAfterChange-@QtyAverage),
dQuantityCurrent = (dQuantityCurrent-@QtyAverage)
WHERE vStockID=@ProductId and ID>67159
select * from WAMS_PURCHASE_ORDER where vPOID=@POID
select * from WAMS_PO_DETAILS where vPOID=@POID and vProductID=@ProductId
SELECT * FROM WAMS_FULFILLMENT_DETAIL WHERE vPOID=@POID and vStockID=@ProductId
SELECT * FROM WAMS_STOCK WHERE vStockID=@ProductId
SELECT * FROM WAMS_STOCK_MANAGEMENT_QUANTITY WHERE vStockID=@ProductId
