--XGetDynamicReport
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[XGetDynamicReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[XGetDynamicReport]
GO

CREATE PROCEDURE [dbo].[XGetDynamicReport]
@page int
,@size int
,@poType int
,@po nvarchar(200)
,@stockType int
,@category int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@fd varchar(22) 
,@td varchar(22) 
,@out INT OUTPUT
AS
BEGIN
	-- get record count
	WITH AllRecords AS ( 
		SELECT * FROM XDynamicReport
	WHERE 1 = CASE WHEN @poType=0 THEN 1 WHEN POTypeId = @poType THEN 1 END
   AND 1= CASE WHEN @po= '' THEN 1 WHEN POId = @po THEN 1 END
   AND 1= CASE WHEN @stockType= 0 THEN 1 WHEN StockTypeId = @stockType THEN 1 END
   AND 1= CASE WHEN @category= 0 THEN 1 WHEN CategoryId = @category THEN 1 END
   AND 1= CASE WHEN @stockCode= '' THEN 1 WHEN StockCode = @stockCode THEN 1 END
   AND 1= CASE WHEN @stockName= '' THEN 1 WHEN StockName like '%'+ @stockName+'%' THEN 1 END
   AND 1 = CASE WHEN @fd='' THEN 1 WHEN (PODate >= convert(datetime,(@fd + ' 00:00:00')) OR PODate = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (PODate <= convert(datetime,(@td + ' 23:59:59')) OR PODate = NULL) THEN 1 END
	) SELECT @out = Count(*) From AllRecords;

  -- now get the records
  WITH AllRecords AS ( 
   SELECT ROW_NUMBER() OVER (ORDER BY Id DESC) 
   AS Row, * FROM XDynamicReport
   WHERE 1 = CASE WHEN @poType=0 THEN 1 WHEN POTypeId = @poType THEN 1 END
   AND 1= CASE WHEN @po= '' THEN 1 WHEN POId = @po THEN 1 END
   AND 1= CASE WHEN @stockType= 0 THEN 1 WHEN StockTypeId = @stockType THEN 1 END
   AND 1= CASE WHEN @category= 0 THEN 1 WHEN CategoryId = @category THEN 1 END
   AND 1= CASE WHEN @stockCode= '' THEN 1 WHEN StockCode = @stockCode THEN 1 END
   AND 1= CASE WHEN @stockName= '' THEN 1 WHEN StockName like '%'+ @stockName+'%' THEN 1 END
   AND 1 = CASE WHEN @fd='' THEN 1 WHEN (PODate >= convert(datetime,(@fd + ' 00:00:00')) OR PODate = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (PODate <= convert(datetime,(@td + ' 23:59:59')) OR PODate = NULL) THEN 1 END
  ) SELECT * FROM AllRecords 
  WHERE [Row] > (@page - 1) * @size and [Row] < (@page * @size) + 1;
END
/*
exec dbo.XGetDynamicReport 1, 10, 1, '','', 0, 0,0
*/
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[XInsertUpdatePe]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[XInsertUpdatePe]
GO

CREATE PROCEDURE [dbo].[XInsertUpdatePe]
@Id INT
,@vPOID int
,@vUnit nvarchar(32)
,@vInvoiceNo nvarchar(64)
,@dInvoiceDate DATETIME
,@vMRF nvarchar(256)
,@iDiscount int
,@vProductID int
,@fQuantity decimal
,@fVAT int
,@fImportTax decimal 
,@fUnitPrice decimal
,@fItemTotal decimal
,@dDeliveryDate DATETIME
,@vRemark nvarchar(MAX)
,@PriceId INT
,@iCreated INT
-- XDynamicReport
,@Action nvarchar(20)
,@PODate DATETIME
,@POCode nvarchar(16)
,@POTypeId INT
,@POType NVARCHAR(50)
,@ProjectId INT
,@ProjectCode NVARCHAR(20)
,@ProjectName NVARCHAR(64)
,@StockCode NVARCHAR(16)
,@StockName NVARCHAR(2000)
,@StockTypeId INT
,@StockType NVARCHAR(250)
,@CategoryId INT
,@Category NVARCHAR(64)
,@SupplierId INT
,@Supplier NVARCHAR(64)
,@UnitId INT
,@Unit NVARCHAR(64)
,@QuantityReceived DECIMAL
,@QuantityPending DECIMAL
,@RalNo NVARCHAR(50)
,@Color NVARCHAR(64)
,@Weight DECIMAL
,@lstDeleteDetailItem NVARCHAR(MAX)
AS
BEGIN
	DECLARE @isDebug INT
	DECLARE @result INT
	SET @isDebug = 0
	SET @result = 1
	DECLARE @now DATETIME
	SET @now = GETDATE()
	DECLARE @idjustinsert INT
	DECLARE @individualMRF varchar(20) = null
	BEGIN TRAN		
		INSERT INTO [dbo].[WAMS_PO_DETAILS]
				   ([vPOID]
				   ,[vUnit]
				   ,[vInvoiceNo]
				   ,[dInvoiceDate]
				   ,[vMRF]
				   ,[iDiscount]
				   ,[vProductID]
				   ,[fQuantity]
				   ,[fVAT]
				   ,[fImportTax]
				   ,[fUnitPrice]
				   ,[fItemTotal]
				   ,[dDeliveryDate]
				   ,[iEnable]
				   ,[vRemark]
				   ,[vPODetailStatus]
				   ,[dDateAssign]
				   ,[PriceId]
				   ,[dCreated]
				   ,[dModified]
				   ,[iCreated]
				   ,[iModified])
			 VALUES
				   (@vPOID
				   ,@vUnit
				   ,@vInvoiceNo
				   ,@dInvoiceDate
				   ,@vMRF
				   ,@iDiscount
				   ,@vProductID
				   ,@fQuantity
				   ,@fVAT
				   ,@fImportTax
				   ,@fUnitPrice
				   ,@fItemTotal
				   ,@dDeliveryDate
				   ,1
				   ,@vRemark
				   ,'Open'
				   ,@now
				   ,@PriceId
				   ,@now
				   ,@now
				   ,@iCreated
				   ,@iCreated)
		
		SET @idjustinsert = SCOPE_IDENTITY()

		INSERT INTO [dbo].[XDynamicReport]
				([Action]
				,[POId]
				,[PODate]
				,[POCode]
				,[POTypeId]
				,[POType]
				,[ProjectId]
				,[ProjectCode]
				,[ProjectName]
				,[StockId]
				,[StockCode]
				,[StockName]
				,[StockTypeId]
				,[StockType]
				,[MRF]
				,[CategoryId]
				,[Category]
				,[SupplierId]
				,[Supplier]
				,[UnitId]
				,[Unit]
				,[Quantity]
				,[QuantityReceived]
				,[QuantityPending]
				,[RalNo]
				,[Color]
				,[Weight]
				,[Note]
				,[Created]
				,[Modified]
				,[CreatedBy]
				,[ModifiedBy]
				,[FagFrom]
				,[FagId])
			VALUES
				('Open'
				,@vPOID
				,@now
				,@POCode
				,@POType
				,@POType
				,@ProjectId
				,@ProjectCode
				,@ProjectName
				,@vProductID
				,@StockCode
				,@StockName
				,@StockTypeId
				,@StockType
				,@vMRF
				,@CategoryId
				,@Category
				,@SupplierId
				,@Supplier
				,@UnitId
				,@Unit
				,@fQuantity
				,@QuantityReceived
				,@QuantityPending
				,@RalNo
				,@Color
				,@Weight
				,@vRemark
				,@now
				,@now
				,@iCreated
				,@iCreated
				,'PE'
				,@idjustinsert)

		WHILE LEN(@vMRF) > 0
		BEGIN
			IF PATINDEX('%;%',@vMRF) > 0
			BEGIN
				SET @individualMRF = SUBSTRING(@vMRF, 0, PATINDEX('%;%',@vMRF))
				--SELECT @individualMRF
				UPDATE WAMS_REQUISITION_DETAILS set iPurchased = 1, fTobePurchased = (fTobePurchased + @fQuantity) where vStockID=@vProductID and vMRF=@individualMRF and iEnable=1

				SET @vMRF = SUBSTRING(@vMRF, LEN(@individualMRF + ';') + 1,
															 LEN(@vMRF))
			END
			ELSE
			BEGIN
				SET @individualMRF = @vMRF
				SET @vMRF = NULL
				--SELECT @individualMRF
				UPDATE WAMS_REQUISITION_DETAILS set iPurchased = 1, fTobePurchased = (fTobePurchased + @fQuantity) where vStockID=@vProductID and vMRF=@individualMRF and iEnable=1
			END
		END


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