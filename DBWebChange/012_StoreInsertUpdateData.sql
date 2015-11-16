--V3_Insert_Client
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Insert_Client]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Insert_Client]
GO
CREATE PROCEDURE [dbo].[V3_Insert_Client]
@Name nvarchar(500)
,@iCreated int
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO dbo.Project_Client(Name,iCreated,dCreated) VALUES (@Name, @iCreated, GETDATE())
	SELECT 1
END

GO
-- V3_InsertStockReturn
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_InsertStockReturn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_InsertStockReturn]
GO
CREATE PROCEDURE [dbo].[V3_InsertStockReturn]
@vStockID int
,@vProjectID int
,@bQuantity decimal(18,2)
,@vCondition nvarchar(18)
,@SRV nvarchar(20)
,@FromStore int
,@ToStore int
,@iCreated int
,@FlagFile bit
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 1
	DECLARE @now DATETIME
	SET @now = GETDATE()
	DECLARE @QtyCurrent DECIMAL(18,2)
	BEGIN TRAN				
		INSERT INTO [dbo].[WAMS_RETURN_LIST]
           ([vStockID],[vProjectID],[bQuantity],[vCondition],[SRV],[FromStore],[ToStore],[dCreated],[dModified],[iCreated],[iModified],[FlagFile])
     VALUES
           (@vStockID
           ,@vProjectID
           ,@bQuantity
           ,@vCondition
           ,@SRV
           ,@FromStore
           ,@ToStore
           ,@now
           ,@now
		   ,@iCreated
		   ,@iCreated
		   ,@FlagFile)

		--SET Idjustinsert = SCOPE_IDENTITY()

		-- Implement for WAMS_STOCK_MANAGEMENT_QUANTITY
		IF  EXISTS(SELECT StockID from Store_Stock where StockID = @vStockID and Store = @ToStore)
		BEGIN
			SET @QtyCurrent = (select Quantity from Store_Stock where Store=@ToStore and StockID=@vStockID)
		END
		ELSE
		BEGIN
			SET  @QtyCurrent = 0
		END
		
		INSERT INTO WAMS_STOCK_MANAGEMENT_QUANTITY(vStockID,dQuantityCurrent,dQuantityChange,dQuantityAfterChange,vStatus,
		vStatusID,bUserID,vProjectID,vMRF,vPOID,bSupplierID,dDate,FromStore) values(@vStockID,@QtyCurrent,@bQuantity,(@QtyCurrent+@bQuantity),'RETURN',
		@SRV,@iCreated,@vProjectID,NULL,NULL,NULL,GETDATE(),@ToStore)

		-- Implement for Store_Stock
		UPDATE Store_Stock set Quantity = (Quantity + @bQuantity) where StockID=@vStockID and Store=@ToStore
		
		IF(@isDebug = 1)
		BEGIN
			print 'Print insert stock return' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 0
		END 
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
GO
GO
-- V3_UpdateStockReturn
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_UpdateStockReturn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_UpdateStockReturn]
GO
CREATE PROCEDURE [dbo].[V3_UpdateStockReturn]
@bReturnListID INT
,@vStockID int
,@vProjectID int
,@bQuantity decimal(18,2)
,@vCondition nvarchar(18)
,@SRV nvarchar(20)
,@FromStore int
,@ToStore int
,@iCreated int
,@FlagFile bit
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 1
	DECLARE @now DATETIME
	SET @now = GETDATE()
	DECLARE @QtyStockReturnCurrent DECIMAL(18,2)
	DECLARE @QtyStockCurrent DECIMAL(18,2)
	BEGIN TRAN	
		SET @QtyStockReturnCurrent = (SELECT bQuantity FROM WAMS_RETURN_LIST WHERE bReturnListID=@bReturnListID) 
		SET @QtyStockCurrent = 	(SELECT Quantity FROM Store_Stock WHERE StockID=@vStockID and Store=@ToStore)	

		INSERT INTO [dbo].[WAMS_RETURN_LIST]
           ([vStockID],[vProjectID],[bQuantity],[vCondition],[SRV],[FromStore],[ToStore],[dCreated],[dModified],[iCreated],[iModified],[FlagFile])
     VALUES
           (@vStockID
           ,@vProjectID
           ,-@QtyStockReturnCurrent
           ,'DRAW'
           ,@bReturnListID
           ,@FromStore
           ,@ToStore
           ,@now
           ,@now
		   ,@iCreated
		   ,@iCreated
		   ,@FlagFile)

		INSERT INTO [dbo].[WAMS_RETURN_LIST]
           ([vStockID],[vProjectID],[bQuantity],[vCondition],[SRV],[FromStore],[ToStore],[dCreated],[dModified],[iCreated],[iModified],[FlagFile])
     VALUES
           (@vStockID
           ,@vProjectID
           ,@bQuantity
           ,@vCondition
           ,@SRV
           ,@FromStore
           ,@ToStore
           ,@now
           ,@now
		   ,@iCreated
		   ,@iCreated
		   ,@FlagFile)

		-- Implement for Store_Stock
		UPDATE Store_Stock set Quantity = ((Quantity - @QtyStockReturnCurrent) + @bQuantity) where StockID=@vStockID and Store=@ToStore

		-- Implement for WAMS_STOCK_MANAGEMENT_QUANTITY
		-- 1. Add 1 row change with status 'DRAW'
		-- 2. Add 1 row new value
		INSERT INTO WAMS_STOCK_MANAGEMENT_QUANTITY(vStockID,dQuantityCurrent,dQuantityChange,dQuantityAfterChange,vStatus,
		vStatusID,bUserID,vProjectID,vMRF,vPOID,bSupplierID,dDate,FromStore) values(@vStockID,@QtyStockCurrent,-@QtyStockReturnCurrent,(@QtyStockCurrent-@QtyStockReturnCurrent),'DRAW',
		@bReturnListID,@iCreated,@vProjectID,NULL,NULL,NULL,@now,@ToStore)

		INSERT INTO WAMS_STOCK_MANAGEMENT_QUANTITY(vStockID,dQuantityCurrent,dQuantityChange,dQuantityAfterChange,vStatus,
		vStatusID,bUserID,vProjectID,vMRF,vPOID,bSupplierID,dDate,FromStore) values(@vStockID,(@QtyStockCurrent-@QtyStockReturnCurrent),@bQuantity,(@QtyStockCurrent-@QtyStockReturnCurrent) + @bQuantity,'RETURN',
		@SRV,@iCreated,@vProjectID,NULL,NULL,NULL,@now,@ToStore)
					

		IF(@isDebug = 1)
		BEGIN
			print 'Print update stock out' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 0
		END 
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
GO

-- V3_InsertStockOut
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_InsertStockOut]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_InsertStockOut]
GO
CREATE PROCEDURE [dbo].[V3_InsertStockOut]
@vStockID int
,@vProjectID int
,@bQuantity decimal(18,2)
,@vWorkerID nvarchar(50)
,@SIV nvarchar(50)
,@vMRF nvarchar(50)
,@FromStore int
,@ToStore int
,@iCreated int
,@FlagFile bit
,@Description NVARCHAR(500)
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 1
	DECLARE @now DATETIME
	SET @now = GETDATE()
	DECLARE @QtyCurrent DECIMAL(18,2)
	DECLARE @SupplierId INT
	BEGIN TRAN				
		INSERT INTO [dbo].[WAMS_ASSIGNNING_STOCKS] ([vStockID],[vProjectID],[bQuantity],[vWorkerID],[SIV],[vMRF],[FromStore],
		[ToStore],[dCreated],[dModified],[iCreated],[iModified],[FlagFile],[Description])
     VALUES
           (@vStockID,@vProjectID,@bQuantity,@vWorkerID,@SIV,@vMRF,@FromStore,@ToStore,@now,@now,@iCreated,@iCreated,@FlagFile,@Description)
		  

		--SET Idjustinsert = SCOPE_IDENTITY()

		-- Implement for WAMS_STOCK_MANAGEMENT_QUANTITY
		IF  EXISTS(SELECT StockID from Store_Stock where StockID = @vStockID and Store = @FromStore)
		BEGIN
			SET @QtyCurrent = (select Quantity from Store_Stock where Store=@FromStore and StockID=@vStockID)
		END
		ELSE
		BEGIN
			SET  @QtyCurrent = 0
		END
		
		INSERT INTO WAMS_STOCK_MANAGEMENT_QUANTITY(vStockID,dQuantityCurrent,dQuantityChange,dQuantityAfterChange,vStatus,
		vStatusID,bUserID,vProjectID,vMRF,vPOID,bSupplierID,dDate,FromStore) values(@vStockID,@QtyCurrent,@bQuantity,(@QtyCurrent-@bQuantity),'ASSIGN',
		@SIV,@iCreated,null,@vMRF,NULL,NULL,GETDATE(),@FromStore)

		-- Implement for Store_Stock
		UPDATE Store_Stock set Quantity = (Quantity - @bQuantity) where StockID=@vStockID and Store=@FromStore
		
		IF(@isDebug = 1)
		BEGIN
			print 'Print insert stock out' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 0
		END 
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
GO
-- V3_UpdateStockOut
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_UpdateStockOut]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_UpdateStockOut]
GO
CREATE PROCEDURE [dbo].[V3_UpdateStockOut]
@bAssignningStockID INT
,@vStockID int
,@vProjectID int
,@bQuantity decimal(18,2)
,@vWorkerID nvarchar(50)
,@SIV nvarchar(50)
,@vMRF nvarchar(50)
,@FromStore int
,@ToStore int
,@iCreated int
,@FlagFile bit
,@Description NVARCHAR(500)
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 1
	DECLARE @now DATETIME
	SET @now = GETDATE()
	DECLARE @QtyStockOutCurrent DECIMAL(18,2)
	DECLARE @QtyStockCurrent DECIMAL(18,2)
	BEGIN TRAN	
		SET @QtyStockOutCurrent = (SELECT bQuantity FROM WAMS_ASSIGNNING_STOCKS WHERE bAssignningStockID=@bAssignningStockID) 
		SET @QtyStockCurrent = 	(SELECT Quantity FROM Store_Stock WHERE StockID=@vStockID and Store=@FromStore)	

		INSERT INTO [dbo].[WAMS_ASSIGNNING_STOCKS] ([vStockID],[vProjectID],[bQuantity],[vWorkerID],[SIV],[vMRF],[FromStore],
		[ToStore],[dCreated],[dModified],[iCreated],[iModified],[FlagFile],[Description])
		VALUES (@vStockID,@vProjectID,-@bQuantity,@vWorkerID,@bAssignningStockID,@vMRF,@FromStore,@ToStore,@now,@now,@iCreated,@iCreated,@FlagFile,'DRAW')

		INSERT INTO [dbo].[WAMS_ASSIGNNING_STOCKS] ([vStockID],[vProjectID],[bQuantity],[vWorkerID],[SIV],[vMRF],[FromStore],
		[ToStore],[dCreated],[dModified],[iCreated],[iModified],[FlagFile],[Description])
		VALUES (@vStockID,@vProjectID,@bQuantity,@vWorkerID,@SIV,@vMRF,@FromStore,@ToStore,@now,@now,@iCreated,@iCreated,@FlagFile,@Description)

		-- Implement for Store_Stock
		UPDATE Store_Stock set Quantity = ((Quantity + @QtyStockCurrent) - @bQuantity) where StockID=@vStockID and Store=@FromStore

		-- Implement for WAMS_STOCK_MANAGEMENT_QUANTITY
		-- 1. Add 1 row change with status 'DRAW'
		-- 2. Add 1 row new value
		INSERT INTO WAMS_STOCK_MANAGEMENT_QUANTITY(vStockID,dQuantityCurrent,dQuantityChange,dQuantityAfterChange,vStatus,
		vStatusID,bUserID,vProjectID,vMRF,vPOID,bSupplierID,dDate,FromStore) values(@vStockID,@QtyStockCurrent,-@QtyStockOutCurrent,(@QtyStockCurrent + @QtyStockOutCurrent),'DRAW',
		@bAssignningStockID,@iCreated,null,NULL,NULL,NULL,GETDATE(),@FromStore)

		INSERT INTO WAMS_STOCK_MANAGEMENT_QUANTITY(vStockID,dQuantityCurrent,dQuantityChange,dQuantityAfterChange,vStatus,
		vStatusID,bUserID,vProjectID,vMRF,vPOID,bSupplierID,dDate,FromStore) values(@vStockID,@QtyStockCurrent,@bQuantity,(@QtyStockCurrent +@QtyStockOutCurrent) - @bQuantity,'ASSIGN',
		@SIV,@iCreated,null,@vMRF,NULL,NULL,GETDATE(),@FromStore)
					

		IF(@isDebug = 1)
		BEGIN
			print 'Print update stock out' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 0
		END 
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
GO

-- V3_UpdateStockIn
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_UpdateStockIn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_UpdateStockIn]
GO
CREATE PROCEDURE [dbo].[V3_UpdateStockIn]
@ID INT
,@vPOID INT
,@vStockID INT
,@dQuantity DECIMAL(18,2)
,@dReceivedQuantity DECIMAL(18,2)
,@dPendingQuantity DECIMAL(18,2)
,@dDateDelivery DATETIME
,@iShipID NVARCHAR(16)
,@tDescription TEXT
,@vMRF NVARCHAR(16)
,@dCurrenQuantity DECIMAL(18,2)
,@dInvoiceDate DATETIME
,@vInvoiceNo NVARCHAR(16)
,@dImportTax DECIMAL(18,2)
,@SRV NVARCHAR(20)
,@iStore INT
,@iCreated INT
,@FlagFile BIT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 1
	DECLARE @now DATETIME
	SET @now = GETDATE()
	DECLARE @QtyStockInCurrent DECIMAL(18,2)
	DECLARE @QtyStockCurrent DECIMAL(18,2)
	DECLARE @LastestPending DECIMAL(18,2)
	DECLARE @SupplierId INT
	BEGIN TRAN	
		SET @QtyStockInCurrent = (SELECT dReceivedQuantity FROM WAMS_FULFILLMENT_DETAIL WHERE ID=@ID) 
		SET @QtyStockCurrent = 	(SELECT Quantity FROM Store_Stock WHERE StockID=@vStockID and Store=@iStore)	
		SET @LastestPending = (SELECT TOP 1 dPendingQuantity FROM WAMS_FULFILLMENT_DETAIL WHERE vPOID = @vPOID ORDER BY ID DESC)
		--UPDATE [dbo].[WAMS_FULFILLMENT_DETAIL] SET iEnable = 0 WHERE ID=@ID

		INSERT INTO [dbo].[WAMS_FULFILLMENT_DETAIL] ([vPOID],[vStockID],[dQuantity],[dReceivedQuantity],[dPendingQuantity],[dDateDelivery],[iShipID]
           ,[tDescription],[vMRF],[dCurrenQuantity],[dInvoiceDate],[vInvoiceNo],[dImportTax],[iEnable],[dDateAssign],[SRV],[iStore],[dCreated]
           ,[dModified],[iCreated],[iModified],[AccCheck],[AccDescription],[AccdCreated],[AccdModified],[AcciCreated],[AcciModidied],[FlagFile]) 
		   VALUES (@vPOID,@vStockID,@dQuantity,-@QtyStockInCurrent,(@LastestPending + @QtyStockInCurrent),@dDateDelivery,null,'DRAW',NULL,@QtyStockCurrent,
		   @now,NULL,NULL,1,@now,@ID,@iStore,@now,@now,@iCreated,@iCreated,null,null,null,null,null,null,@FlagFile)

		INSERT INTO [dbo].[WAMS_FULFILLMENT_DETAIL] ([vPOID],[vStockID],[dQuantity],[dReceivedQuantity],[dPendingQuantity],[dDateDelivery],[iShipID]
           ,[tDescription],[vMRF],[dCurrenQuantity],[dInvoiceDate],[vInvoiceNo],[dImportTax],[iEnable],[dDateAssign],[SRV],[iStore],[dCreated]
           ,[dModified],[iCreated],[iModified],[AccCheck],[AccDescription],[AccdCreated],[AccdModified],[AcciCreated],[AcciModidied],[FlagFile]) 
		   VALUES (@vPOID,@vStockID,@dQuantity,@dReceivedQuantity,@dPendingQuantity,@dDateDelivery,@iShipID,@tDescription,@vMRF,@dCurrenQuantity,
		   @dInvoiceDate,@vInvoiceNo,@dImportTax,1,@now,@SRV,@iStore,@now,@now,@iCreated,@iCreated,null,null,null,null,null,null,@FlagFile)
		
		-- Implement for Store_Stock
		UPDATE Store_Stock set Quantity = ((Quantity - @QtyStockInCurrent) + @dReceivedQuantity) where StockID=@vStockID and Store=@iStore

		SET @SupplierId = (SELECT bSupplierID from WAMS_PURCHASE_ORDER where Id=@vPOID)
		-- Implement for WAMS_STOCK_MANAGEMENT_QUANTITY
		-- 1. Add 1 row change with status 'DRAW'
		-- 2. Add 1 row new value
		INSERT INTO WAMS_STOCK_MANAGEMENT_QUANTITY(vStockID,dQuantityCurrent,dQuantityChange,dQuantityAfterChange,vStatus,
		vStatusID,bUserID,vProjectID,vMRF,vPOID,bSupplierID,dDate,FromStore) values(@vStockID,@QtyStockCurrent,@QtyStockInCurrent,(@QtyStockCurrent-@QtyStockInCurrent),'DRAW',
		@ID,@iCreated,null,NULL,@vPOID,@SupplierId,GETDATE(),@iStore)

		INSERT INTO WAMS_STOCK_MANAGEMENT_QUANTITY(vStockID,dQuantityCurrent,dQuantityChange,dQuantityAfterChange,vStatus,
		vStatusID,bUserID,vProjectID,vMRF,vPOID,bSupplierID,dDate,FromStore) values(@vStockID,@QtyStockCurrent-@QtyStockInCurrent,@dReceivedQuantity,((@QtyStockCurrent-@QtyStockInCurrent)+@dReceivedQuantity),'FULFILLMENT',
		@SRV,@iCreated,null,@vMRF,@vPOID,@SupplierId,GETDATE(),@iStore)
				
		
		-- Implement for Purchase Order
		IF @dPendingQuantity <= 0
		BEGIN
			UPDATE WAMS_PO_DETAILS set vPODetailStatus = 'Complete' where vProductID=@vStockID and vPOID=@vPOID and iEnable=1
			
			IF ((SELECT COUNT(vPODetailStatus) FROM WAMS_PO_DETAILS WHERE iEnable=1 and vPODetailStatus='Open' and vPOID=@vPOID) = 0)
			BEGIN
				UPDATE WAMS_PURCHASE_ORDER set vPOStatus = 'Complete' where Id=@vPOID and iEnable=1
			END
		END

		IF(@isDebug = 1)
		BEGIN
			print 'Print update stock in' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 0
		END 
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
GO

-- V3_InsertStockIn
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_InsertStockIn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_InsertStockIn]
GO
CREATE PROCEDURE [dbo].[V3_InsertStockIn]
@vPOID INT
,@vStockID INT
,@dQuantity DECIMAL(18,2)
,@dReceivedQuantity DECIMAL(18,2)
,@dPendingQuantity DECIMAL(18,2)
,@dDateDelivery DATETIME
,@iShipID NVARCHAR(16)
,@tDescription TEXT
,@vMRF NVARCHAR(16)
,@dCurrenQuantity DECIMAL(18,2)
,@dInvoiceDate DATETIME
,@vInvoiceNo NVARCHAR(16)
,@dImportTax DECIMAL(18,2)
,@SRV NVARCHAR(20)
,@iStore INT
,@iCreated INT
,@FlagFile BIT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 1
	DECLARE @now DATETIME
	SET @now = GETDATE()
	DECLARE @QtyCurrent DECIMAL(18,2)
	DECLARE @SupplierId INT
	BEGIN TRAN				
		INSERT INTO [dbo].[WAMS_FULFILLMENT_DETAIL] ([vPOID],[vStockID],[dQuantity],[dReceivedQuantity],[dPendingQuantity],[dDateDelivery],[iShipID]
           ,[tDescription],[vMRF],[dCurrenQuantity],[dInvoiceDate],[vInvoiceNo],[dImportTax],[iEnable],[dDateAssign],[SRV],[iStore],[dCreated]
           ,[dModified],[iCreated],[iModified],[AccCheck],[AccDescription],[AccdCreated],[AccdModified],[AcciCreated],[AcciModidied],[FlagFile]) 
		   VALUES (@vPOID,@vStockID,@dQuantity,@dReceivedQuantity,@dPendingQuantity,@dDateDelivery,@iShipID,@tDescription,@vMRF,@dCurrenQuantity,
		   @dInvoiceDate,@vInvoiceNo,@dImportTax,1,@now,@SRV,@iStore,@now,@now,@iCreated,@iCreated,null,null,null,null,null,null,@FlagFile)

		--SET Idjustinsert = SCOPE_IDENTITY()

		-- Implement for WAMS_STOCK_MANAGEMENT_QUANTITY
		IF  EXISTS(SELECT StockID from Store_Stock where StockID = @vStockID and Store = @iStore)
		BEGIN
			SET @QtyCurrent = (select Quantity from Store_Stock where Store=@iStore and StockID=@vStockID)
		END
		ELSE
		BEGIN
			SET  @QtyCurrent = 0
		END
		SET @SupplierId = (SELECT bSupplierID from WAMS_PURCHASE_ORDER where Id=@vPOID)
		INSERT INTO WAMS_STOCK_MANAGEMENT_QUANTITY(vStockID,dQuantityCurrent,dQuantityChange,dQuantityAfterChange,vStatus,
		vStatusID,bUserID,vProjectID,vMRF,vPOID,bSupplierID,dDate,FromStore) values(@vStockID,@QtyCurrent,@dReceivedQuantity,(@QtyCurrent+@dReceivedQuantity),'FULFILLMENT',
		@SRV,@iCreated,null,@vMRF,@vPOID,@SupplierId,GETDATE(),@iStore)

		-- Implement for Store_Stock
		IF  EXISTS(SELECT StockID from Store_Stock where StockID = @vStockID and Store = @iStore)
			BEGIN
				UPDATE Store_Stock set Quantity = (Quantity + @dReceivedQuantity) where StockID=@vStockID and Store=@iStore
			END
		ELSE 
			BEGIN
				INSERT INTO Store_Stock(Store,StockID,Quantity) values(@iStore,@vStockID,@dReceivedQuantity)
			END
		
		-- Implement for Purchase Order
		IF @dPendingQuantity <= 0
		BEGIN
			UPDATE WAMS_PO_DETAILS set vPODetailStatus = 'Complete' where vProductID=@vStockID and vPOID=@vPOID and iEnable=1
			
			IF ((SELECT COUNT(vPODetailStatus) FROM WAMS_PO_DETAILS WHERE iEnable=1 and vPODetailStatus='Open' and vPOID=@vPOID) = 0)
			BEGIN
				UPDATE WAMS_PURCHASE_ORDER set vPOStatus = 'Complete' where Id=@vPOID and iEnable=1
			END
		END

		IF(@isDebug = 1)
		BEGIN
			print 'Print insert stock in' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 0
		END 
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
GO

-- V3_CheckDelete_StockType
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_CheckDelete_StockType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_CheckDelete_StockType]
GO
CREATE PROCEDURE [dbo].[V3_CheckDelete_StockType]
@id INT
AS
BEGIN
	DECLARE @isDebug INT
	SET @isDebug = 0
	IF EXISTS (SELECT 1 FROM dbo.WAMS_STOCK (NOLOCK) WHERE iType=@id)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
	ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_CATEGORY (NOLOCK) WHERE iType=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
	ELSE
    BEGIN
		SELECT CAST(0 AS INT) 
    END
END
/*
exec dbo.V3_CheckDelete_StockType 9
*/

GO
-- V3_Delete_StockType
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_StockType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_StockType]
GO
CREATE PROCEDURE [dbo].[V3_Delete_StockType]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE dbo.WAMS_STOCK_TYPE WHERE Id = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete stock type' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END 
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_StockType 1
*/ 
GO
-- V3_CheckDelete_Category
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_CheckDelete_Category]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_CheckDelete_Category]
GO
CREATE PROCEDURE [dbo].[V3_CheckDelete_Category]
@id INT
AS
BEGIN
	DECLARE @isDebug INT
	SET @isDebug = 0
	IF EXISTS (SELECT 1 FROM dbo.WAMS_STOCK (NOLOCK) WHERE bCategoryID=@id)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
	ELSE
    BEGIN
		SELECT CAST(0 AS INT) 
    END
END
/*
exec dbo.V3_CheckDelete_Category 1
*/

GO
-- V3_Delete_Category
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_Category]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_Category]
GO
CREATE PROCEDURE [dbo].[V3_Delete_Category]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE dbo.WAMS_CATEGORY WHERE bCategoryID = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete category' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END 
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_Category 1
*/ 
GO
-- V3_Delete_StockOut_Detail
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_StockOut_Detail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_StockOut_Detail]
GO
CREATE PROCEDURE [dbo].[V3_Delete_StockOut_Detail]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE dbo.WAMS_ASSIGNNING_STOCKS WHERE bAssignningStockID = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete detail' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_StockOut_Detail 1
*/ 
GO
-- V3_Delete_StockReturn_Detail
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_StockReturn_Detail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_StockReturn_Detail]
GO
CREATE PROCEDURE [dbo].[V3_Delete_StockReturn_Detail]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE dbo.WAMS_RETURN_LIST WHERE bReturnListID = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete detail' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_StockReturn_Detail 1
*/ 
GO

-- V3_Delete_StockIn_Detail
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_StockIn_Detail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_StockIn_Detail]
GO
CREATE PROCEDURE [dbo].[V3_Delete_StockIn_Detail]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	DECLARE @store INT
	DECLARE @stock INT
	DECLARE @quantity DECIMAL(18,2)
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN	
		SELECT @store = iStore, @stock = vStockID, @quantity= dReceivedQuantity FROM WAMS_FULFILLMENT_DETAIL WHERE ID = @id	
		UPDATE Store_Stock SET Quantity = (Quantity - @quantity) WHERE StockID = @stock AND Store = @store		
		UPDATE dbo.WAMS_FULFILLMENT_DETAIL SET iEnable=0 WHERE ID = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete detail' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_StockIn_Detail 1
*/ 
GO
-- V3_PE_Update_Total
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_PE_Update_Total]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_PE_Update_Total]
GO
CREATE PROCEDURE [dbo].[V3_PE_Update_Total]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		UPDATE WAMS_PURCHASE_ORDER SET fPOTotal = (select SUM(fItemTotal) from WAMS_PO_DETAILS where vPOID=@id and iEnable=1) WHERE Id=@id
		IF(@isDebug = 1)
		BEGIN
			print 'update detail' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_PE_Update_Total 1
*/ 
GO
-- V3_PE_Update_Requisition
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_PE_Update_Requisition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_PE_Update_Requisition]
GO
CREATE PROCEDURE [dbo].[V3_PE_Update_Requisition]
	@mrf INT
	,@stock INT
	,@quantity DECIMAL(10,2)
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		UPDATE WAMS_REQUISITION_DETAILS set iPurchased = 1, fTobePurchased = (fTobePurchased + @quantity) where vStockID=@stock and vMRF=@mrf and iEnable=1
		IF(@isDebug = 1)
		BEGIN
			print 'update detail' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_PE_Update_Requisition 1,1,1
*/ 
GO

-- V3_Delete_PE_Detail
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_PE_Detail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_PE_Detail]
GO
CREATE PROCEDURE [dbo].[V3_Delete_PE_Detail]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE dbo.WAMS_PO_DETAILS WHERE ID = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete detail' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_PE_Detail 1
*/ 
GO

-- V3_CheckDelete_Service
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_CheckDelete_Service]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_CheckDelete_Service]
GO
CREATE PROCEDURE [dbo].[V3_CheckDelete_Service]
@id INT
AS
BEGIN
	DECLARE @isDebug INT
	SET @isDebug = 0
	IF EXISTS (SELECT 1 FROM dbo.WAMS_REQUISITION_DETAILS (NOLOCK) WHERE vStockID=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
	ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_PO_DETAILS (NOLOCK) WHERE vProductID=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
	ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_ASSIGNNING_STOCKS (NOLOCK) WHERE vStockID=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_RETURN_LIST (NOLOCK) WHERE vStockID=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_FULFILLMENT_DETAIL (NOLOCK) WHERE vStockID=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE
    BEGIN
		SELECT CAST(0 AS INT) 
    END
END
/*
exec dbo.V3_CheckDelete_Service 1
*/

GO
-- V3_Delete_Service
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_Service]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_Service]
GO
CREATE PROCEDURE [dbo].[V3_Delete_Service]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE dbo.WAMS_ITEMS_SERVICE WHERE Id = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete stock' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END 
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_Service 1
*/ 
GO

-- V3_Delete_Supplier
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_Supplier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_Supplier]
GO
CREATE PROCEDURE [dbo].[V3_Delete_Supplier]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE dbo.WAMS_PRODUCT WHERE bSupplierID = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete detail' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END
		DELETE dbo.WAMS_SUPPLIER WHERE bSupplierID = @id 
		IF(@isDebug = 1)
		BEGIN
			print 'Delete item' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_Supplier 1
*/ 
GO
-- V3_CheckDelete_Supplier
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_CheckDelete_Supplier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_CheckDelete_Supplier]
GO
CREATE PROCEDURE [dbo].[V3_CheckDelete_Supplier]
@id INT
AS
BEGIN
	DECLARE @isDebug INT
	SET @isDebug = 0
	IF EXISTS (SELECT 1 FROM dbo.WAMS_PURCHASE_ORDER (NOLOCK) WHERE bSupplierID=@id and iEnable=1)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
	ELSE IF EXISTS (SELECT 1 FROM dbo.Product_price (NOLOCK) WHERE SupplierId=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE
    BEGIN
		SELECT CAST(0 AS INT) 
    END
END
/*
exec dbo.V3_CheckDelete_Price 1
*/
GO
-- V3_Delete_Supplier_Detail
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_Supplier_Detail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_Supplier_Detail]
GO
CREATE PROCEDURE [dbo].[V3_Delete_Supplier_Detail]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE dbo.WAMS_PRODUCT WHERE Id = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete detail' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_Supplier_Detail 1
*/ 
GO

-- V3_CheckDelete_Price
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_CheckDelete_Price]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_CheckDelete_Price]
GO
CREATE PROCEDURE [dbo].[V3_CheckDelete_Price]
@id INT
AS
BEGIN
	DECLARE @isDebug INT
	SET @isDebug = 0
	IF EXISTS (SELECT 1 FROM dbo.WAMS_PO_DETAILS (NOLOCK) WHERE PriceId=@id and iEnable=1)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
    ELSE
    BEGIN
		SELECT CAST(0 AS INT) 
    END
END
/*
exec dbo.V3_CheckDelete_Price 1
*/

GO
-- V3_Delete_Price
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_Price]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_Price]
GO
CREATE PROCEDURE [dbo].[V3_Delete_Price]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE dbo.Product_Price WHERE Id = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete price' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_Price 1
*/ 
GO

-- V3_CheckDelete_PE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_CheckDelete_PE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_CheckDelete_PE]
GO
CREATE PROCEDURE [dbo].[V3_CheckDelete_PE]
@id INT
AS
BEGIN
	DECLARE @isDebug INT
	SET @isDebug = 0
	IF EXISTS (SELECT 1 FROM dbo.WAMS_FULFILLMENT_DETAIL (NOLOCK) WHERE vPOId=@id)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
    ELSE
    BEGIN
		SELECT CAST(0 AS INT) 
    END
END
/*
exec dbo.V3_CheckDelete_PE 1
*/

GO
-- V3_Delete_PE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_PE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_PE]
GO
CREATE PROCEDURE [dbo].[V3_Delete_PE]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE dbo.WAMS_PO_DETAILS WHERE vPOID = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete detail' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END
		DELETE dbo.WAMS_PURCHASE_ORDER WHERE Id = @id 
		IF(@isDebug = 1)
		BEGIN
			print 'Delete item' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_PE 1
*/ 
GO

-- V3_CheckDelete_Requisition
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_CheckDelete_Requisition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_CheckDelete_Requisition]
GO
CREATE PROCEDURE [dbo].[V3_CheckDelete_Requisition]
@id INT
AS
BEGIN
	DECLARE @isDebug INT
	SET @isDebug = 0
	IF EXISTS (SELECT 1 FROM dbo.WAMS_PO_DETAILS (NOLOCK) WHERE vMRF=@id)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
    ELSE
    BEGIN
		SELECT CAST(0 AS INT) 
    END
END
/*
exec dbo.V3_CheckDelete_Requisition 1
*/

GO
-- V3_Delete_Requisition
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_Requisition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_Requisition]
GO
CREATE PROCEDURE [dbo].[V3_Delete_Requisition]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE dbo.WAMS_REQUISITION_DETAILS WHERE vMRF = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete detail' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END
		DELETE dbo.WAMS_REQUISITION_MASTER WHERE Id = @id 
		IF(@isDebug = 1)
		BEGIN
			print 'Delete item' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_Requisition 1
*/ 
GO

-- V3_Delete_Requisition_Detail
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_Requisition_Detail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_Requisition_Detail]
GO
CREATE PROCEDURE [dbo].[V3_Delete_Requisition_Detail]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE dbo.WAMS_REQUISITION_DETAILS WHERE ID = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete detail' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_Requisition_Detail 1
*/ 
GO
-- V3_Insert_Document
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Insert_Document]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Insert_Document]
GO

CREATE PROCEDURE [dbo].[V3_Insert_Document]
	@documentURL nvarchar(200)
	,@documentDescription nvarchar(200)
	,@keyId int
    ,@documentTypeId int
    ,@documentName nvarchar(200)
    ,@documentTitle nvarchar(200)
    ,@folderLocation nvarchar(100)
    ,@documentFile varbinary(max)
    ,@loginId int
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		INSERT INTO [dbo].[Document]
           ([DocumentURL]
           ,[DocumentDescription]
           ,[KeyId]
           ,[ActionDate]
           ,[DocumentTypeId]
           ,[DocumentName]
           ,[DocumentTitle]
           ,[FolderLocation]
           ,[DocumentFile]
           ,[ById])
     VALUES
           (@documentUrl
           ,@documentDescription
           ,@keyId
           ,GETDATE()
           ,@documentTypeId
           ,@documentName
           ,@documentTitle
           ,@folderLocation
           ,@documentFile
           ,@loginId)
		IF(@isDebug = 1)
		BEGIN
			print 'Insert document' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END 
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
GO
-- V3_Delete_Document
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_Document]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_Document]
GO

CREATE PROCEDURE [dbo].[V3_Delete_Document]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE [dbo].[Document] WHERE Id=@id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete document' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END 
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
GO

-- V3_CheckDelete_Stock
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_CheckDelete_Stock]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_CheckDelete_Stock]
GO
CREATE PROCEDURE [dbo].[V3_CheckDelete_Stock]
@id INT
AS
BEGIN
	DECLARE @isDebug INT
	SET @isDebug = 0
	IF EXISTS (SELECT 1 FROM dbo.Store_Stock (NOLOCK) WHERE StockID=@id)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
	ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_REQUISITION_DETAILS (NOLOCK) WHERE vStockID=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
	ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_PO_DETAILS (NOLOCK) WHERE vProductID=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
	ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_ASSIGNNING_STOCKS (NOLOCK) WHERE vStockID=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_RETURN_LIST (NOLOCK) WHERE vStockID=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_FULFILLMENT_DETAIL (NOLOCK) WHERE vStockID=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE
    BEGIN
		SELECT CAST(0 AS INT) 
    END
END
/*
exec dbo.V3_CheckDelete_Stock 1
*/

GO
-- V3_Delete_Stock
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_Stock]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_Stock]
GO
CREATE PROCEDURE [dbo].[V3_Delete_Stock]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE dbo.WAMS_STOCK WHERE Id = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete stock' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END 
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_Stock 1
*/ 
GO
-- V3_CheckDelete_Store
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_CheckDelete_Store]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_CheckDelete_Store]
GO
CREATE PROCEDURE [dbo].[V3_CheckDelete_Store]
@id INT
AS
BEGIN
	DECLARE @isDebug INT
	SET @isDebug = 0
	IF EXISTS (SELECT 1 FROM dbo.Store_Stock (NOLOCK) WHERE Store=@id)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
	ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_ASSIGNNING_STOCKS (NOLOCK) WHERE FromStore=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_ASSIGNNING_STOCKS (NOLOCK) WHERE ToStore=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE
    BEGIN
		SELECT CAST(0 AS INT) 
    END
END
/*
exec dbo.V3_CheckDelete_Store 1
*/

GO
-- V3_Delete_Store
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_Store]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_Store]
GO
CREATE PROCEDURE [dbo].[V3_Delete_Store]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE dbo.Store WHERE Id = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete store' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END 
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_Store 1
*/ 
GO
-- V3_CheckDelete_Project
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_CheckDelete_Project]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_CheckDelete_Project]
GO
CREATE PROCEDURE [dbo].[V3_CheckDelete_Project]
@id INT
AS
BEGIN
	DECLARE @isDebug INT
	SET @isDebug = 0
	IF EXISTS (SELECT 1 FROM dbo.WAMS_RETURN_LIST (NOLOCK) WHERE vProjectID=@id)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_ASSIGNNING_STOCKS (NOLOCK) WHERE vProjectID=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE
    BEGIN
		SELECT CAST(0 AS INT) 
    END
END
/*
exec dbo.V3_CheckDelete_Project 91
*/

GO
-- V3_Delete_Project
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_Project]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_Project]
GO
CREATE PROCEDURE [dbo].[V3_Delete_Project]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE dbo.WAMS_PROJECT WHERE Id = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete project' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END 
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_Project 80
*/ 
GO
-- V3_CheckDelete_User
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_CheckDelete_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_CheckDelete_User]
GO
CREATE PROCEDURE [dbo].[V3_CheckDelete_User]
@id INT
AS
BEGIN
	DECLARE @isDebug INT
	SET @isDebug = 0
	IF EXISTS (SELECT 1 FROM dbo.WAMS_SUPPLIER (NOLOCK) WHERE iCreated=@id)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_SUPPLIER (NOLOCK) WHERE iModified=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_FULFILLMENT_DETAIL (NOLOCK) WHERE iCreated=@id)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_FULFILLMENT_DETAIL (NOLOCK) WHERE iModified=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_RETURN_LIST (NOLOCK) WHERE iCreated=@id)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_RETURN_LIST (NOLOCK) WHERE iModified=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_ASSIGNNING_STOCKS (NOLOCK) WHERE iCreated=@id)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_ASSIGNNING_STOCKS (NOLOCK) WHERE iModified=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_STOCK (NOLOCK) WHERE iCreated=@id)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_STOCK (NOLOCK) WHERE iModified=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_PROJECT (NOLOCK) WHERE iCreated=@id)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_PROJECT (NOLOCK) WHERE iModified=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE IF EXISTS (SELECT 1 FROM dbo.Store (NOLOCK) WHERE iCreated=@id)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
    ELSE IF EXISTS (SELECT 1 FROM dbo.Store (NOLOCK) WHERE iModified=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_USER (NOLOCK) WHERE iCreated=@id)
	BEGIN
		SELECT CAST(1 AS INT) 
	END
    ELSE IF EXISTS (SELECT 1 FROM dbo.WAMS_USER (NOLOCK) WHERE iModified=@id)
    BEGIN
		SELECT CAST(1 AS INT) 
    END
    ELSE
    BEGIN
		SELECT CAST(0 AS INT) 
    END
END
/*
exec dbo.V3_CheckDelete_User 91
*/
-- V3_Delete_User
GO
/****** Object:  StoredProcedure [dbo].[sproc_RemoveInvitee]    Script Date: 12/04/2014 14:58:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Delete_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Delete_User]
GO
CREATE PROCEDURE [dbo].[V3_Delete_User]
	@id INT
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 0
	BEGIN TRAN				
		DELETE dbo.XUser WHERE Id = @id
		IF(@isDebug = 1)
		BEGIN
			print 'Delete user' 
		END
		IF (@@ERROR <> 0)
		BEGIN
			PRINT 'Unexpected error occurred!'
			ROLLBACK TRAN
			SET @result = 1
		END 
	COMMIT TRAN
	
	SELECT CAST(@result AS INT)
END
/*
exec dbo.V3_Delete_User 80
*/
 
-- V3_ASSIGNSTOCK_Insert
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_ASSIGNNING_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_ASSIGNNING_Insert]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_ASSIGNSTOCK_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_ASSIGNSTOCK_Insert]
GO

CREATE PROCEDURE [dbo].[V3_ASSIGNSTOCK_Insert]
	@vStockID int
	,@vProjectID int
	,@bQuantity decimal(18,2)
	,@vWorkerID nvarchar(50)
	,@SIV nvarchar(20)
	,@vMRF nvarchar(50)
	,@FromStore int
	,@ToStore int
	,@dCreated datetime
	,@iCreated int
AS

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION ts_ASSIGNSTOCK_Insert
			-- SET NOCOUNT ON added to prevent extra result sets from
			SET NOCOUNT ON;
			-- INSERT INTO WAMS_ASSIGNNING_STOCKS
			INSERT INTO [dbo].[WAMS_ASSIGNNING_STOCKS] 
			(vStockID,vProjectID,bQuantity,vWorkerID,SIV,vMRF,FromStore,ToStore,dCreated,iCreated) 
			VALUES (@vStockID,@vProjectID,@bQuantity,@vWorkerID,@SIV,@vMRF,@FromStore,@ToStore,GETDATE(),@iCreated)
				
			-- UPDATE QUANTITY STOCK: RULE STOCK TYPE SERVICE NOT APPROVED FOS ASSIGN
			DECLARE @QuantityCurrent decimal(18,2)
			DECLARE @QuantityAfterChange decimal(18,2)
			SET @QuantityCurrent = (SELECT Quantity FROM [dbo].[Store_Stock] where Store = @FromStore and StockID=@vStockID)
			SET @QuantityAfterChange = @QuantityCurrent - @bQuantity
			UPDATE [dbo].[Store_Stock] set Quantity = @QuantityAfterChange where Store = @FromStore and StockID=@vStockID
			
			-- INSERT INTO WAMS_STOCK_MANAGEMENT_QUANTITY
			INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY] 
			(vStockID,dQuantityCurrent,dQuantityChange,dQuantityAfterChange,
			vStatus,vStatusID,bUserID,vProjectID,dDate,FromStore,ToStore) 
			VALUES (@vStockID,@QuantityCurrent,@bQuantity,@QuantityAfterChange,
			'ASSIGN',@SIV,@iCreated,@vProjectID, GETDATE(),@FromStore,@ToStore)

		COMMIT TRANSACTION ts_ASSIGNSTOCK_Insert
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION ts_ASSIGNSTOCK_Insert
	END CATCH
END

GO

-- V3_RETURNSTOCK_Insert
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_WAMS_RETURN_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_WAMS_RETURN_Insert]
GO
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_RETURNSTOCK_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_RETURNSTOCK_Insert]
GO

CREATE PROCEDURE [dbo].[V3_RETURNSTOCK_Insert] 
	@vStockID int
	,@vProjectID int
	,@bQuantity decimal(18,2)
	,@vCondition nvarchar(18)
	,@SRV nvarchar(20)
	,@FromStore int
	,@ToStore int
	,@dCreated datetime
	,@iCreated int
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION ts_RETURNSTOCK_Insert;
		SET NOCOUNT ON;
			-- WAMS_EQUIPMENT: DO LATER
			--if(@StockType='EQUIPMENT')
			--	begin
			--		UPDATE [dbo].[WAMS_EQUIPMENT] SET vCondition = @vCondition where vEquipmentID = @vStockID;
			--	end
			--WAMS_RETURN_LIST
			INSERT INTO [dbo].[WAMS_RETURN_LIST](vStockID,vProjectID,bQuantity,vCondition,SRV,FromStore,ToStore,dCreated,iCreated)
			VALUES (@vStockID,@vProjectID,@bQuantity,@vCondition,@SRV,@FromStore,@ToStore,@dCreated,@iCreated);
				
			--UPDATE QUANTITY STOCK: RULE STOCK TYPE SERVICE NOT APPROVED FOS ASSIGN
			DECLARE @QuantityCurrent decimal(18,2)
			DECLARE @QuantityAfterChange decimal(18,2)
			SET @QuantityCurrent = (SELECT Quantity FROM [dbo].[Store_Stock] where Store = @FromStore and StockID=@vStockID)
			SET @QuantityAfterChange = @QuantityCurrent + @bQuantity
			UPDATE [dbo].[Store_Stock] set Quantity = @QuantityAfterChange where Store = @FromStore and StockID=@vStockID
			
			-- INSERT INTO WAMS_STOCK_MANAGEMENT_QUANTITY
			INSERT INTO [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY] 
			(vStockID,dQuantityCurrent,dQuantityChange,dQuantityAfterChange,
			vStatus,vStatusID,bUserID,vProjectID,dDate,FromStore,ToStore) 
			VALUES (@vStockID,@QuantityCurrent,@bQuantity,@QuantityAfterChange,
			'RETURN',@SRV,@iCreated,@vProjectID, GETDATE(),@FromStore,@ToStore)
			
		COMMIT TRANSACTION ts_RETURNSTOCK_Insert;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION ts_RETURNSTOCK_Insert;
	END CATCH
END

GO
-- SRV
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_WAMS_SRV_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_WAMS_SRV_Insert]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_SRV_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_SRV_Insert]
GO

CREATE PROCEDURE [dbo].[V3_SRV_Insert]
	@SRV nvarchar(20),
	@Status nvarchar(20)
AS
BEGIN
	SET NOCOUNT ON;
	INSERT [dbo].[SRV] ([SRV],[Status],dDate) VALUES (@SRV,@Status, GETDATE())
END
GO

-- SIV
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_SIV_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_SIV_Insert]
GO

CREATE PROCEDURE [dbo].[V3_SIV_Insert]
	@SIV nvarchar(20),
	@Status nvarchar(20)
AS
BEGIN
	SET NOCOUNT ON;
	INSERT [dbo].[SIV] ([SIV],[vStatus],CreatedDate) VALUES (@SIV,@Status, GETDATE())
END

GO


