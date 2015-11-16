-- insertWAMS_FULFILLMENT_DETAIL
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[insertWAMS_FULFILLMENT_DETAIL]'))
DROP TRIGGER [dbo].[insertWAMS_FULFILLMENT_DETAIL]
GO

--CREATE TRIGGER insertWAMS_FULFILLMENT_DETAIL
--ON WAMS_FULFILLMENT_DETAIL 
--FOR INSERT 
--AS
--BEGIN 
--	DECLARE @FromStore int, @StockId nvarchar(16), @ReceivedQty decimal(18,2),
--	@PoId int,@PendingQty decimal(18,2), @MRF nvarchar(16), @QtyCurrent decimal(18,2),
--	@SRV nvarchar(50), @UserId int, @SupplierId int
			
--	SELECT @FromStore=S.iStore, @StockId=S.vStockID, @ReceivedQty=S.dReceivedQuantity, @PoId=S.vPOID,
--	@PendingQty=S.dPendingQuantity, @MRF=S.vMRF, @SRV = S.SRV,@UserId = S.iCreated
--	from WAMS_FULFILLMENT_DETAIL S,INSERTED I
--	where S.ID=I.ID
	
--	-- Implement for WAMS_STOCK_MANAGEMENT_QUANTITY
--	IF  EXISTS(SELECT StockID from Store_Stock where StockID = @StockId and Store = @FromStore)
--	BEGIN
--		SET @QtyCurrent = (select Quantity from Store_Stock where Store=@FromStore and StockID=@StockId)
--	END
--	ELSE
--	BEGIN
--		SET  @QtyCurrent = 0
--	END
--	SET @SupplierId = (select bSupplierID from WAMS_PURCHASE_ORDER where Id=@PoId)
--	INSERT INTO WAMS_STOCK_MANAGEMENT_QUANTITY(vStockID,dQuantityCurrent,dQuantityChange,dQuantityAfterChange,vStatus,
--	vStatusID,bUserID,vProjectID,vMRF,vPOID,bSupplierID,dDate,FromStore) values(@StockId,@QtyCurrent,@ReceivedQty,(@QtyCurrent+@ReceivedQty),'FULFILLMENT',
--	@SRV,@UserId,null,@MRF,@PoId,@SupplierId,GETDATE(),@FromStore)

--	-- Implement for Store_Stock
--	IF  EXISTS(SELECT StockID from Store_Stock where StockID = @StockId and Store = @FromStore)
--		BEGIN
--			UPDATE Store_Stock set Quantity = (Quantity + @ReceivedQty) where StockID=@StockId and Store=@FromStore
--		END
--	ELSE 
--		BEGIN
--			INSERT INTO Store_Stock(Store,StockID,Quantity) values(@FromStore,@StockId,@ReceivedQty)
--		END
		
--	-- Implement for Purchase Order
--	IF @PendingQty <= 0
--		BEGIN
--			UPDATE WAMS_PO_DETAILS set vPODetailStatus = 'Complete' where vProductID=@StockId and vPOID=@PoId and iEnable=1
			
--			IF ((SELECT COUNT(vPODetailStatus) FROM WAMS_PO_DETAILS WHERE iEnable=1 and vPODetailStatus='Open' and vPOID=@PoId) = 0)
--			BEGIN
--				UPDATE WAMS_PURCHASE_ORDER set vPOStatus = 'Complete' where Id=@PoId and iEnable=1
--			END
--		END
--END
--GO

---- TRIGGER on PO update MRF
--GO
--IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[insertWAMS_PO_DETAILS]'))
--DROP TRIGGER [dbo].[insertWAMS_PO_DETAILS]
--GO

--CREATE TRIGGER insertWAMS_PO_DETAILS
--ON WAMS_PO_DETAILS
--FOR INSERT 
--AS
--BEGIN 
--	DECLARE @MRF int, @ProductID nvarchar(16), @Quantity decimal(18,2)
			
--	SELECT @MRF=S.vMRF, @ProductID=S.vProductID, @Quantity=S.fQuantity
--	from WAMS_PO_DETAILS S,INSERTED I
--	where S.ID=I.ID
	
--		-- Implement for Purchase Order
--	IF @MRF != 0
--		BEGIN
--			UPDATE WAMS_REQUISITION_DETAILS set iPurchased = 1, fTobePurchased = (fTobePurchased +@Quantity) where vStockID=@ProductID and vMRF=@MRF and iEnable=1
--		END

--		-- Implete update Total PO

--END
--GO






