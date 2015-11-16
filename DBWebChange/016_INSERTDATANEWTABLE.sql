INSERT INTO [dbo].[XUser]
           ([UserName]
           ,[Password]
           ,[FirstName]
           ,[LastName]
		   ,[DepartmentId]
           ,[Department]
           ,[Telephone]
           ,[Mobile]
           ,[Email]
           ,[Enable]
		   ,[StoreId]
           ,[Store]
           ,[UserR]
           ,[ProjectR]
           ,[StoreR]
           ,[StockR]
           ,[RequisitionR]
           ,[StockOutR]
           ,[StockReturnR]
           ,[StockInR]
           ,[ReActiveStockR]
           ,[PER]
           ,[SupplierR]
           ,[PriceR]
           ,[StockServiceR]
           ,[AccountingR]
           ,[MaintenanceR]
           ,[WorkerR]
           ,[ShippmentR]
           ,[ReturnSupplierR]
           ,[StockTypeR]
           ,[CategoryR])
           (SELECT a.vUsername, a.vNewPassword,a.vFirstName, a.vLastName,NULL,a.vDepartment,
		   a.vPhone, a.vMobile, a.vEmail, a.iEnable,1,'Binh Chieu'
		   ,b.[User],b.Project,b.Store,b.Stock 
		   ,b.Requisition,b.StockOut,b.StockReturn,b.StockIn  
		   ,b.ReActiveStock,b.PE,b.Supplier,b.Price  
		   ,b.StockService,b.Accounting,b.Maintenance,b.Worker
		   ,b.Shippment,b.ReturnSupplier,b.StockType,b.Category  
		   FROM WAMS_USER a INNER JOIN WAMS_FUNCTION_MANAGEMENT b ON a.bUserId= b.bUserID)
GO


