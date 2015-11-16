--V3_List_Stock_Search_Count
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Stock_Search_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Stock_Search_Count]
GO

CREATE PROCEDURE [dbo].[V3_List_Stock_Search_Count]
@page int
,@size int
,@enable char(1)
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@store varchar(50)
,@type int
,@category int
AS
BEGIN
	SELECT COUNT(1) AS [Count] 
	FROM (SELECT 
      [vStockID]
      ,[vStockName]
      ,[bUnitID]
      ,[iEnable]
      ,[bCategoryID]
      ,[bPositionID]
      ,[iType]
  FROM [dbo].[WAMS_STOCK] (NOLOCK)
   UNION ALL 
   SELECT [vIDServiceItem]
		,[vServiceItemName]
		,[bUnitID]
		,[iEnable]
		,[bCategoryID]
		,[bPositionID]
		,8 
  FROM [dbo].[WAMS_ITEMS_SERVICE] (NOLOCK)) stock
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN stock.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
END
/*
exec dbo.V3_List_Stock_Search_Count 1, 10, 1, '','', 0, 0,0
*/
GO
--V3_List_Stock_Search
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Stock_Search]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Stock_Search]
GO
CREATE PROCEDURE [dbo].[V3_List_Stock_Search]
@page int
,@size int
,@enable char(1)
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@store varchar(50)
,@type int
,@category int
AS
BEGIN
IF (@size = 1000)
	BEGIN
		SELECT stock.Id
		,stock.vStockID AS Stock_Code
		,stock.vStockName AS Stock_Name
		,stock.vBrand AS Brand
		,stock.vAccountCode AS Account_Code
		,stype.TypeName AS [Type]
		,unit.vUnitName AS Unit
		,cate.vCategoryName AS Category
		,storeQuantity.*
		,stock.bWeight AS [Weight]
		,stock.RalNo
		,stock.ColorName AS Color
		,stock.PartNo
		,stock.vRemark AS Remark
		,stock.dCreated AS Created_Date
		,usc.NameUser AS Created_By
		,stock.dModified AS Modified_Date
		,usm.NameUser AS Modified_By
		FROM (SELECT [Id]
      ,[vStockID]
      ,[vStockName]
      ,[vRemark]
      ,[bUnitID]
      ,[bMeasurementID]
      ,[vBrand]
      ,[iEnable]
      ,[bCategoryID]
      ,[bPositionID]
      ,[bLabelID]
      ,[bWeight]
      ,[vAccountCode]
      ,[iType]
      ,[PartNo]
      ,[PartNoFor]
      ,[PartNoMiniQty]
      ,[RalNo]
      ,[ColorName]
      ,[Position]
      ,[SubCategory]
      ,[UserForPaint]
      ,[dCreated]
      ,[dModified]
      ,[iCreated]
      ,[iModified]
      ,[Timestamp]
  FROM [dbo].[WAMS_STOCK] (NOLOCK)
   UNION ALL 
   SELECT [Id]
      ,[vIDServiceItem]
      ,[vServiceItemName]
      ,[vDescription]
	  ,[bUnitID]
	  ,NULL
	  ,NULL
	  ,[iEnable]
      ,[bCategoryID]
      ,[bPositionID]
	  ,NULL
	  ,[bWeight]
      ,[vAccountCode]
	  ,8
      ,NULL
      ,NULL
	  ,NULL
	  ,NULL
	  ,NULL
	  ,NULL
	  ,NULL
	  ,NULL
      ,[dCreated]
      ,[dModified]
      ,[iCreated]
      ,[iModified]
      ,[Timestamp]
  FROM [dbo].[WAMS_ITEMS_SERVICE] (NOLOCK)) stock
		LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stock.iType = stype.Id
		LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON stock.bUnitID = unit.bUnitID
		LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) ON stock.bCategoryID = cate.bCategoryID
		LEFT JOIN (SELECT StockID,
			STUFF((SELECT ';' + CAST(Store AS varchar(10))
					FROM [dbo].[Store_Stock] t2 (NOLOCK) 
					WHERE t2.StockID = t1.StockID
					AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
					FOR XML PATH('')),1,1,'') as Stores,
			STUFF((SELECT ';' + CAST(Quantity as varchar(10))
				FROM [dbo].[Store_Stock] t2 (NOLOCK)
				WHERE t2.StockID = t1.StockID
				AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
				FOR XML PATH('')),1,1,'') as Quantity   
		FROM [dbo].[Store_Stock] t1 (NOLOCK)
		GROUP BY StockID) storeQuantity ON storeQuantity.StockID= stock.Id
		CROSS APPLY [dbo].[udf_GetUserName](stock.iCreated) AS usc
		CROSS APPLY [dbo].[udf_GetUserName](stock.iModified) AS usm
		WHERE
		1 = CASE WHEN @enable='' THEN 1 WHEN stock.iEnable = CAST(@enable AS INT) THEN 1 END
		AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
		AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
		AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
		AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	END
	ELSE
	BEGIN 
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT stock.Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,stock.vBrand AS Brand
	,stock.vAccountCode AS Account_Code
	,stype.TypeName AS [Type]
	,unit.vUnitName AS Unit
	,cate.vCategoryName AS Category
	,storeQuantity.*
	,stock.bWeight AS [Weight]
	,stock.RalNo
	,stock.ColorName AS Color
	,stock.PartNo
	,stock.vRemark AS Remark
	,stock.dCreated AS Created_Date
	,usc.NameUser AS Created_By
	,stock.dModified AS Modified_Date
	,usm.NameUser AS Modified_By
	FROM (SELECT [Id]
      ,[vStockID]
      ,[vStockName]
      ,[vRemark]
      ,[bUnitID]
      ,[bMeasurementID]
      ,[vBrand]
      ,[iEnable]
      ,[bCategoryID]
      ,[bPositionID]
      ,[bLabelID]
      ,[bWeight]
      ,[vAccountCode]
      ,[iType]
      ,[PartNo]
      ,[PartNoFor]
      ,[PartNoMiniQty]
      ,[RalNo]
      ,[ColorName]
      ,[Position]
      ,[SubCategory]
      ,[UserForPaint]
      ,[dCreated]
      ,[dModified]
      ,[iCreated]
      ,[iModified]
      ,[Timestamp]
  FROM [dbo].[WAMS_STOCK] (NOLOCK)
   UNION ALL 
   SELECT [Id]
      ,[vIDServiceItem]
      ,[vServiceItemName]
      ,[vDescription]
	  ,[bUnitID]
	  ,NULL
	  ,NULL
	  ,[iEnable]
      ,[bCategoryID]
      ,[bPositionID]
	  ,NULL
	  ,[bWeight]
      ,[vAccountCode]
	  ,8
      ,NULL
      ,NULL
	  ,NULL
	  ,NULL
	  ,NULL
	  ,NULL
	  ,NULL
	  ,NULL
      ,[dCreated]
      ,[dModified]
      ,[iCreated]
      ,[iModified]
      ,[Timestamp]
  FROM [dbo].[WAMS_ITEMS_SERVICE] (NOLOCK)) stock
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stock.iType = stype.Id
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON stock.bUnitID = unit.bUnitID
	LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) ON stock.bCategoryID = cate.bCategoryID
	LEFT JOIN (SELECT StockID,
	  STUFF((SELECT ';' + CAST(Store AS varchar(10))
			   FROM [dbo].[Store_Stock] t2 (NOLOCK) 
			   WHERE t2.StockID = t1.StockID
			   AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
			   FOR XML PATH('')),1,1,'') as Stores,
		STUFF((SELECT ';' + CAST(Quantity as varchar(10))
		   FROM [dbo].[Store_Stock] t2 (NOLOCK)
		   WHERE t2.StockID = t1.StockID
		   AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
		   FOR XML PATH('')),1,1,'') as Quantity   
	FROM [dbo].[Store_Stock] t1 (NOLOCK)
	GROUP BY StockID) storeQuantity ON storeQuantity.StockID= stock.Id
	CROSS APPLY [dbo].[udf_GetUserName](stock.iCreated) AS usc
	CROSS APPLY [dbo].[udf_GetUserName](stock.iModified) AS usm
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN stock.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	) tblTemp) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
		END
END
/*
exec dbo.V3_List_Stock_Search 1, 10, 1,'','', '', 8, 0
*/
GO

--V3_List_Stock_StockReturn
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Stock_StockReturn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Stock_StockReturn]
GO
CREATE PROCEDURE [dbo].[V3_List_Stock_StockReturn]
@page int
,@size int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@project int
,@type int
,@category int
AS
BEGIN
IF (@size = 1000)
	BEGIN
		SELECT stock.Id
		,stock.vStockID AS Stock_Code
		,stock.vStockName AS Stock_Name
		,stock.vBrand AS Brand
		,stock.vAccountCode AS Account_Code
		,stype.TypeName AS [Type]
		,unit.vUnitName AS Unit
		,cate.vCategoryName AS Category
		,storeStock.vStockID AS [StockID]
		,'' AS Stores
		,CAST(storeStock.bQuantity AS NVARCHAR(1000)) AS Quantity
		,stock.bWeight AS [Weight]
		,stock.RalNo
		,stock.ColorName AS Color
		,stock.PartNo
		,stock.vRemark AS Remark
		,stock.dCreated AS Created_Date
		,usc.NameUser AS Created_By
		,stock.dModified AS Modified_Date
		,usm.NameUser AS Modified_By
		FROM [dbo].[WAMS_STOCK] stock (NOLOCK)
		INNER JOIN dbo.WAMS_ASSIGNNING_STOCKS storeStock ON stock.Id = storeStock.vStockID
		LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stock.iType = stype.Id
		LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON stock.bUnitID = unit.bUnitID
		LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) ON stock.bCategoryID = cate.bCategoryID
		CROSS APPLY [dbo].[udf_GetUserName](stock.iCreated) AS usc
		CROSS APPLY [dbo].[udf_GetUserName](stock.iModified) AS usm
		WHERE stock.iEnable = 1 AND storeStock.bQuantity > 0
		AND 1 = CASE WHEN @project='' THEN 1 WHEN storeStock.vProjectID = @project THEN 1 END
		AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
		AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
		AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
		AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	END
	ELSE
	BEGIN 
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT stock.Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,stock.vBrand AS Brand
	,stock.vAccountCode AS Account_Code
	,stype.TypeName AS [Type]
	,unit.vUnitName AS Unit
	,cate.vCategoryName AS Category
	,storeStock.vStockID AS [StockID]
	,'' AS Stores
	,CAST(storeStock.bQuantity AS NVARCHAR(1000)) AS Quantity
	,stock.bWeight AS [Weight]
	,stock.RalNo
	,stock.ColorName AS Color
	,stock.PartNo
	,stock.vRemark AS Remark
	,stock.dCreated AS Created_Date
	,usc.NameUser AS Created_By
	,stock.dModified AS Modified_Date
	,usm.NameUser AS Modified_By
	FROM [dbo].[WAMS_STOCK] stock (NOLOCK)
	INNER JOIN dbo.WAMS_ASSIGNNING_STOCKS storeStock ON stock.Id = storeStock.vStockID
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stock.iType = stype.Id
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON stock.bUnitID = unit.bUnitID
	LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) ON stock.bCategoryID = cate.bCategoryID
	CROSS APPLY [dbo].[udf_GetUserName](stock.iCreated) AS usc
	CROSS APPLY [dbo].[udf_GetUserName](stock.iModified) AS usm
	WHERE stock.iEnable = 1 AND storeStock.bQuantity > 0
		AND 1 = CASE WHEN @project='' THEN 1 WHEN storeStock.vProjectID = @project THEN 1 END
		AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
		AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
		AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
		AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	) tblTemp) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
		END
END
/*
exec dbo.V3_List_Stock_StockOut 1, 10, '','',1, 0, 0
*/
GO

--V3_List_Stock_StockReturn_Count
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Stock_StockReturn_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Stock_StockReturn_Count]
GO

CREATE PROCEDURE [dbo].[V3_List_Stock_StockReturn_Count]
@page int
,@size int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@project int
,@type int
,@category int
AS
BEGIN
	SELECT COUNT(1) AS [Count] 
	FROM [dbo].[WAMS_STOCK] stock (NOLOCK)
	INNER JOIN dbo.WAMS_ASSIGNNING_STOCKS storeStock ON stock.Id = storeStock.vStockID
	WHERE stock.iEnable = 1 AND storeStock.bQuantity > 0
		AND 1 = CASE WHEN @project='' THEN 1 WHEN storeStock.vProjectID = @project THEN 1 END
		AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
		AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
		AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
		AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
END
/*
exec dbo.V3_List_Stock_StockReturn_Count 1, 10, 1, '1,2', 0, 0,''
*/
GO

--V3_List_Stock_StockOut
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Stock_StockOut]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Stock_StockOut]
GO
CREATE PROCEDURE [dbo].[V3_List_Stock_StockOut]
@page int
,@size int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@store int
,@type int
,@category int
AS
BEGIN
IF (@size = 1000)
	BEGIN
		SELECT stock.Id
		,stock.vStockID AS Stock_Code
		,stock.vStockName AS Stock_Name
		,stock.vBrand AS Brand
		,stock.vAccountCode AS Account_Code
		,stype.TypeName AS [Type]
		,unit.vUnitName AS Unit
		,cate.vCategoryName AS Category
		,storeStock.StockID
		,CAST(storeStock.Store AS NVARCHAR(10)) AS Stores
		,CAST(storeStock.Quantity AS NVARCHAR(1000)) AS Quantity
		,stock.bWeight AS [Weight]
		,stock.RalNo
		,stock.ColorName AS Color
		,stock.PartNo
		,stock.vRemark AS Remark
		,stock.dCreated AS Created_Date
		,usc.NameUser AS Created_By
		,stock.dModified AS Modified_Date
		,usm.NameUser AS Modified_By
		FROM [dbo].[WAMS_STOCK] stock (NOLOCK)
		INNER JOIN dbo.Store_Stock storeStock ON stock.Id = storeStock.StockID
		LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stock.iType = stype.Id
		LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON stock.bUnitID = unit.bUnitID
		LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) ON stock.bCategoryID = cate.bCategoryID
		CROSS APPLY [dbo].[udf_GetUserName](stock.iCreated) AS usc
		CROSS APPLY [dbo].[udf_GetUserName](stock.iModified) AS usm
		WHERE stock.iEnable = 1 AND storeStock.Quantity > 0
		AND 1 = CASE WHEN @store='' THEN 1 WHEN storeStock.Store = @store THEN 1 END
		AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
		AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
		AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
		AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	END
	ELSE
	BEGIN 
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT stock.Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,stock.vBrand AS Brand
	,stock.vAccountCode AS Account_Code
	,stype.TypeName AS [Type]
	,unit.vUnitName AS Unit
	,cate.vCategoryName AS Category
	,storeStock.StockID
	,CAST(storeStock.Store AS NVARCHAR(10)) AS Stores
	,CAST(storeStock.Quantity AS NVARCHAR(1000)) AS Quantity
	,stock.bWeight AS [Weight]
	,stock.RalNo
	,stock.ColorName AS Color
	,stock.PartNo
	,stock.vRemark AS Remark
	,stock.dCreated AS Created_Date
	,usc.NameUser AS Created_By
	,stock.dModified AS Modified_Date
	,usm.NameUser AS Modified_By
	FROM [dbo].[WAMS_STOCK] stock (NOLOCK)
	INNER JOIN dbo.Store_Stock storeStock ON stock.Id = storeStock.StockID
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stock.iType = stype.Id
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON stock.bUnitID = unit.bUnitID
	LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) ON stock.bCategoryID = cate.bCategoryID
	CROSS APPLY [dbo].[udf_GetUserName](stock.iCreated) AS usc
	CROSS APPLY [dbo].[udf_GetUserName](stock.iModified) AS usm
	WHERE stock.iEnable = 1 AND storeStock.Quantity > 0
	AND 1 = CASE WHEN @store='' THEN 1 WHEN storeStock.Store = @store THEN 1 END
	AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	) tblTemp) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
		END
END
/*
exec dbo.V3_List_Stock_StockOut 1, 10, '','',1, 0, 0
*/
GO

--V3_List_Stock_StockOut_Count
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Stock_StockOut_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Stock_StockOut_Count]
GO

CREATE PROCEDURE [dbo].[V3_List_Stock_StockOut_Count]
@page int
,@size int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@store int
,@type int
,@category int
AS
BEGIN
	SELECT COUNT(1) AS [Count] 
	FROM [dbo].[WAMS_STOCK] stock (NOLOCK)
	INNER JOIN dbo.Store_Stock storeStock ON stock.Id = storeStock.StockID
	WHERE stock.iEnable = 1 AND storeStock.Quantity > 0
	AND 1 = CASE WHEN @store='' THEN 1 WHEN storeStock.Store = @store THEN 1 END
	AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
END
/*
exec dbo.V3_List_Stock_StockOut_Count 1, 10, 1, '1,2', 0, 0,''
*/
GO

--V3_NewStockCode
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_NewStockCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_NewStockCode]
GO
CREATE PROCEDURE [dbo].[V3_NewStockCode]
@type INT
,@category INT
AS
BEGIN
IF @category = 0 
BEGIN
SELECT TOP 1 CASE 
	WHEN (stype.TypeCode +  dbo.CIntToChar((dbo.udf_GetNumeric(stock.vStockID) + 1), 8)) IS NULL THEN stype.TypeCode + '0000001'
	ELSE (stype.TypeCode +  dbo.CIntToChar((dbo.udf_GetNumeric(stock.vStockID) + 1), 8))
	END [NewCode], stock.vStockID
	FROM [dbo].[WAMS_STOCK] stock (NOLOCK)
	INNER JOIN dbo.WAMS_STOCK_TYPE stype (NOLOCK) ON stock.iType = stype.Id
	WHERE 
	stock.iType = @type
	ORDER BY stock.Id DESC        
END
ELSE
BEGIN 
SELECT TOP 1 CASE 
	WHEN (stype.TypeCode + category.CategoryCode  + dbo.CIntToChar((dbo.udf_GetNumeric(stock.vStockID) + 1), 8)) IS NULL THEN stype.TypeCode + category.CategoryCode + '0000001'
	ELSE (stype.TypeCode + category.CategoryCode + dbo.CIntToChar((dbo.udf_GetNumeric(stock.vStockID) + 1), 8))
	END [NewCode], stock.vStockID
	FROM [dbo].[WAMS_STOCK] stock (NOLOCK)
	INNER JOIN dbo.WAMS_STOCK_TYPE stype (NOLOCK) ON stock.iType = stype.Id
	INNER JOIN dbo.WAMS_CATEGORY category (NOLOCK) ON stock.bCategoryID = category.bCategoryID
	WHERE 
	stock.iType = @type
	AND stock.bCategoryID = @category
	ORDER BY stock.Id DESC        
END                                         
END
/*
exec dbo.V3_NewStockCode 6, 0
*/
GO
-- TransactionStockByProject
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionStockByProject]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TransactionStockByProject]
GO
CREATE PROCEDURE [dbo].[TransactionStockByProject]
@page int
,@size int
,@project int
,@type varchar(50) 
,@fd varchar(22) 
,@td varchar(22) 
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT 
	stockQty.dDate AS [Date]
	,stockQty.ID AS Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,stockQty.dQuantityCurrent AS Quantity_Current
	,stockQty.dQuantityChange AS Quantity_Change
	,stockQty.dQuantityAfterChange AS Quantity_After_Change
	,stockQty.vStatus AS [Status]
	,CASE 
		 WHEN stockQty.vStatus = 'ASSIGN' THEN stockQty.vStatusID
		 ELSE ''
	  END AS [SIV]
	,CASE 
		 WHEN stockQty.vStatus != 'ASSIGN' THEN stockQty.vStatusID
		 ELSE ''
	  END AS [SRV]
	,project.vProjectID AS Project_Code
	,project.vProjectName AS Project_Name
	,stockQty.FromStore
	,stockQty.ToStore
	,stock.RalNo
	,stock.ColorName AS Color
	,stock.PartNo
	,usr.vUsername AS [User]
	--,storeQuantity.*
	FROM [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY] stockQty (NOLOCK)
	INNER JOIN [dbo].[WAMS_PROJECT] project (NOLOCK) ON project.Id= stockQty.vProjectID
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = stockQty.vStockID
	LEFT JOIN [dbo].[WAMS_USER] usr (NOLOCK) ON usr.bUserId = stockQty.bUserId
	WHERE
	1 = CASE WHEN @project=0 THEN 1 WHEN project.Id = @project THEN 1 END
	AND 1 = CASE WHEN @type='' THEN 1 WHEN stockQty.vStatus = @type THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (stockQty.dDate >= convert(datetime,(@fd + ' 00:00:00')) OR stockQty.dDate = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (stockQty.dDate <= convert(datetime,(@td + ' 23:59:59')) OR stockQty.dDate = NULL) THEN 1 END
	) tblTemp) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
END
/*
exec dbo.TransactionStockByProject 1,10,0,'',''
*/
GO
--CountTransactionStockByProject
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CountTransactionStockByProject]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CountTransactionStockByProject]
GO
CREATE PROCEDURE [dbo].[CountTransactionStockByProject]
@page int
,@size int
,@project int
,@type varchar(50)
,@fd varchar(22) 
,@td varchar(22) 
AS
BEGIN
	SELECT COUNT(1) AS [Count]
	FROM [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY] (NOLOCK)
	WHERE
	1 = CASE WHEN @project=0 THEN 1 WHEN vProjectID = @project THEN 1 END
	AND 1 = CASE WHEN @type='' THEN 1 WHEN vStatus = @type THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (dDate >= convert(datetime,(@fd + ' 00:00:00')) OR dDate = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (dDate <= convert(datetime,(@td + ' 23:59:59')) OR dDate = NULL) THEN 1 END
END
/*
exec dbo.CountTransactionStockByProject 1,10,1,'',''
*/
GO
-- V3_StockCodeName
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_StockCodeName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_StockCodeName]
GO
CREATE PROCEDURE [dbo].[V3_StockCodeName]
@code nvarchar(200)
,@name nvarchar(200)
AS
BEGIN
	SELECT Id
	,vStockID AS Stock_Code
	,vStockName AS Stock_Name
	FROM [dbo].[WAMS_STOCK] (NOLOCK)
	WHERE 1 = CASE WHEN @code = '' THEN 1 WHEN vStockID = @code THEN 1 END
	AND 1 = CASE WHEN @name = '' THEN 1 WHEN vStockName = @name THEN 1 END
END
/*
exec dbo.V3_StockCodeName '',''
*/
GO
-- V3_List_StockReturn
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_StockReturn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_StockReturn]
GO
CREATE PROCEDURE [dbo].[V3_List_StockReturn]
@page int
,@size int
,@store int
,@project int
,@stocktype int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@srv nvarchar(20)
,@fd varchar(22) 
,@td varchar(22) 
,@enable char(1)
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1
	SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY SRV DESC) AS [No]
	,tblTable.* 
	FROM
	(SELECT DISTINCT 0 [Id]
	,sreturn.SRV
	,project.vProjectID [Project_Code]
	,project.vProjectName [Project_Name]
	,'Open' [Status]
	,project.vLocation [Location]
	,project.vMainContact [Main_Contact]
	,project.vCompanyName [Company]
	,'' [Client]
	,'' [Store]
	,'' [Country]
	,project.dCreated [Create_Date]
	,project.vRemark [Remark]
	FROM [dbo].WAMS_RETURN_LIST sreturn (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = sreturn.vStockID
	LEFT JOIN dbo.WAMS_PROJECT project (NOLOCK) ON sreturn.vProjectID = project.Id
	WHERE
	1 = CASE WHEN @store=0 THEN 1 WHEN sreturn.FromStore = @store THEN 1 END
	AND 1 = CASE WHEN @project = 0 THEN 1 WHEN sreturn.vProjectID = @project THEN 1 END
	AND 1 = CASE WHEN @stocktype = 0 THEN 1 WHEN stock.iType = @stocktype THEN 1 END
	AND 1 = CASE WHEN @stockCode = '' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1 = CASE WHEN @stockName = '' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	AND 1 = CASE WHEN @srv = '' THEN 1 WHEN sreturn.SRV = @srv THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (sreturn.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR sreturn.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (sreturn.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR sreturn.dCreated = NULL) THEN 1 END
	--AND 1 = CASE WHEN @enable='' THEN 1 WHEN assign.Ena = CAST(@enable AS INT) THEN 1 END
	) tblTable ) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
END
/*
exec dbo.V3_List_StockReturn 1, 20,0,0,0,'','','','','',1
*/
-- V3_List_StockReturn_Count
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_StockReturn_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_StockReturn_Count]
GO
CREATE PROCEDURE [dbo].[V3_List_StockReturn_Count]
@page int
,@size int
,@store int
,@project int
,@stocktype int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@srv nvarchar(20)
,@fd varchar(22) 
,@td varchar(22) 
,@enable char(1)
AS
BEGIN	
	SELECT COUNT(1) AS [Count]
	FROM [dbo].WAMS_RETURN_LIST sreturn (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = sreturn.vStockID
	LEFT JOIN dbo.WAMS_PROJECT project (NOLOCK) ON sreturn.vProjectID = project.Id
	WHERE
	1 = CASE WHEN @store=0 THEN 1 WHEN sreturn.FromStore = @store THEN 1 END
	AND 1 = CASE WHEN @project = 0 THEN 1 WHEN sreturn.vProjectID = @project THEN 1 END
	AND 1 = CASE WHEN @stocktype = 0 THEN 1 WHEN stock.iType = @stocktype THEN 1 END
	AND 1 = CASE WHEN @stockCode = '' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1 = CASE WHEN @stockName = '' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	AND 1 = CASE WHEN @srv = '' THEN 1 WHEN sreturn.SRV = @srv THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (sreturn.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR sreturn.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (sreturn.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR sreturn.dCreated = NULL) THEN 1 END
	--AND 1 = CASE WHEN @enable='' THEN 1 WHEN ful.iEnable = CAST(@enable AS INT) THEN 1 END
END
/*
exec dbo.V3_List_StockReturn_Count 1, 20,0,0,0,'','','','','',1
*/
GO
-- V3_StockReturnDetail
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_StockReturnDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_StockReturnDetail]
GO
CREATE PROCEDURE [dbo].[V3_StockReturnDetail]
	@id NVARCHAR(50)
	,@enable char(1)
AS
BEGIN
	SELECT assign.bReturnListID [Id]
	,assign.SRV
	,assign.vStockID [Stock_Id]
	,stock.vStockID AS [Stock_Code]
	,stock.vStockName AS [Stock_Name]
	,assign.bQuantity [Quantity]
	,assign.dCreated [ReturnDate]
	,assign.vCondition [Condition]
	,unit.vUnitName AS Unit
	,stype.TypeName AS [Type]
	,cate.vCategoryName AS Category
	,stock.RalNo
	,stock.ColorName AS [Color]
	,stock.PartNo
	FROM [dbo].WAMS_RETURN_LIST assign (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id= assign.vStockID
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stype.Id = stock.iType
	LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) ON stock.bCategoryID = cate.bCategoryID
	WHERE 1 = CASE WHEN @id = '' THEN 1 WHEN assign.SRV = @id THEN 1 END
END
--exec [dbo].[V3_StockReturnDetail] '15003331',''
GO

-- V3_List_StockOut
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_StockOut]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_StockOut]
GO
CREATE PROCEDURE [dbo].[V3_List_StockOut]
@page int
,@size int
,@store int
,@project int
,@stocktype int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@siv nvarchar(20)
,@fd varchar(22) 
,@td varchar(22) 
,@enable char(1)
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY SIV DESC) AS [No]
	,tblTable.* 
	FROM
	(SELECT DISTINCT assign.bAssignningStockID [Id]
	,assign.SIV
	,project.vProjectID [Project_Code]
	,project.vProjectName [Project_Name]
	,'Open' [Status]
	,project.vLocation [Location]
	,project.vMainContact [Main_Contact]
	,project.vCompanyName [Company]
	,'' [Client]
	,'' [Store]
	,'' [Country]
	,project.dCreated [Create_Date]
	,project.vRemark [Remark]
	FROM [dbo].WAMS_ASSIGNNING_STOCKS assign (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = assign.vStockID
	LEFT JOIN dbo.WAMS_PROJECT project (NOLOCK) ON assign.vProjectID = project.Id
	WHERE
	1 = CASE WHEN @store=0 THEN 1 WHEN assign.FromStore = @store THEN 1 END
	AND 1 = CASE WHEN @project = 0 THEN 1 WHEN assign.vProjectID = @project THEN 1 END
	AND 1 = CASE WHEN @stocktype = 0 THEN 1 WHEN stock.iType = @stocktype THEN 1 END
	AND 1 = CASE WHEN @stockCode = '' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1 = CASE WHEN @stockName = '' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	AND 1 = CASE WHEN @siv = '' THEN 1 WHEN assign.SIV = @siv THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (assign.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR assign.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (assign.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR assign.dCreated = NULL) THEN 1 END
	--AND 1 = CASE WHEN @enable='' THEN 1 WHEN assign.Ena = CAST(@enable AS INT) THEN 1 END
	) tblTable ) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
END
/*
exec dbo.V3_List_StockOut 1, 20,0,0,0,'','','','','',1
*/
-- V3_List_StockOut_Count
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_StockOut_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_StockOut_Count]
GO
CREATE PROCEDURE [dbo].[V3_List_StockOut_Count]
@page int
,@size int
,@store int
,@project int
,@stocktype int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@siv nvarchar(20)
,@fd varchar(22) 
,@td varchar(22) 
,@enable char(1)
AS
BEGIN	
	SELECT COUNT(1) AS [Count]
	FROM [dbo].WAMS_ASSIGNNING_STOCKS assign (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = assign.vStockID
	LEFT JOIN dbo.WAMS_PROJECT project (NOLOCK) ON assign.vProjectID = project.Id
	WHERE
	1 = CASE WHEN @store=0 THEN 1 WHEN assign.FromStore = @store THEN 1 END
	AND 1 = CASE WHEN @project = 0 THEN 1 WHEN assign.vProjectID = @project THEN 1 END
	AND 1 = CASE WHEN @stocktype = 0 THEN 1 WHEN stock.iType = @stocktype THEN 1 END
	AND 1 = CASE WHEN @stockCode = '' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1 = CASE WHEN @stockName = '' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	AND 1 = CASE WHEN @siv = '' THEN 1 WHEN assign.SIV = @siv THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (assign.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR assign.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (assign.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR assign.dCreated = NULL) THEN 1 END
	--AND 1 = CASE WHEN @enable='' THEN 1 WHEN ful.iEnable = CAST(@enable AS INT) THEN 1 END
END
/*
exec dbo.V3_List_StockOut_Count 1, 20,0,0,0,'','','','','',1
*/
GO
-- V3_StockOutDetail
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_StockOutDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_StockOutDetail]
GO
CREATE PROCEDURE [dbo].[V3_StockOutDetail]
	@id NVARCHAR(50)
	,@enable char(1)
AS
BEGIN
	SELECT assign.bAssignningStockID [Id]
	,assign.SIV
	,assign.vStockID [Stock_Id]
	,stock.vStockID AS [Stock_Code]
	,stock.vStockName AS [Stock_Name]
	,assign.bQuantity [Quantity]
	,assign.dCreated [AssignDate]
	,assign.vMRF [MRF]
	,unit.vUnitName AS Unit
	,stype.TypeName AS [Type]
	,cate.vCategoryName AS Category
	,stock.RalNo
	,stock.ColorName AS [Color]
	,stock.PartNo
	FROM [dbo].WAMS_ASSIGNNING_STOCKS assign (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id= assign.vStockID
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stype.Id = stock.iType
	LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) ON stock.bCategoryID = cate.bCategoryID
	WHERE 1 = CASE WHEN @id = '' THEN 1 WHEN assign.SIV = @id THEN 1 END
END
--exec [dbo].[V3_StockOutDetail] '15003331',''
GO

-- V3_List_Category
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Category]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Category]
GO

CREATE PROCEDURE [dbo].[V3_List_Category]
@page int
,@size int
,@code nvarchar(500)
,@name nvarchar(500)
,@type int
,@enable char(1)
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT 
	ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT st.bCategoryID [Id]
			,st.vCategoryName AS [Name]
			,st.CategoryCode AS Code
			,st.dCreated AS Created_Date
			,usc.NameUser AS Created_By
			,st.dModified AS Modified_Date
			,usm.NameUser AS Modified_By 
			FROM [dbo].WAMS_CATEGORY st (NOLOCK)
			CROSS APPLY [dbo].[udf_GetUserName](st.iCreated) AS usc
			CROSS APPLY [dbo].[udf_GetUserName](st.iModified) AS usm
	WHERE
	1 = CASE WHEN @code = '' THEN 1 WHEN st.CategoryCode = @code THEN 1 END
	AND 1 = CASE WHEN @name = '' THEN 1 WHEN st.vCategoryName like '%' + @name + '%' THEN 1 END
	AND 1 = CASE WHEN @type = 0 THEN 1 WHEN st.iType = @type THEN 1 END
	) tblTemp ) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
END
/*
exec dbo.V3_List_Category 1, 100,'','',''
*/
GO

-- V3_List_StockType_Count
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Category_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Category_Count]
GO

CREATE PROCEDURE [dbo].[V3_List_Category_Count]
@page int
,@size int
,@code nvarchar(500)
,@name nvarchar(500)
,@type int
,@enable char(1)
AS
BEGIN
	SELECT COUNT(1) AS [Count]
	FROM [dbo].WAMS_CATEGORY st (NOLOCK)
	WHERE
	1 = CASE WHEN @code = '' THEN 1 WHEN st.CategoryCode = @code THEN 1 END
	AND 1 = CASE WHEN @name = '' THEN 1 WHEN st.vCategoryName like '%' + @name + '%' THEN 1 END
	AND 1 = CASE WHEN @type = 0 THEN 1 WHEN st.iType = @type THEN 1 END
END
/*
exec dbo.V3_List_Category_Count 1, 100,'','',''
*/

-- V3_List_StockType
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_StockType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_StockType]
GO

CREATE PROCEDURE [dbo].[V3_List_StockType]
@page int
,@size int
,@enable char(1)
,@code nvarchar(500)
,@name nvarchar(500)
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT 
	ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT st.Id
			,st.TypeName AS [Name]
			,st.TypeCode AS Code
			,st.dCreated AS Created_Date
			,usc.NameUser AS Created_By
			,st.dModified AS Modified_Date
			,usm.NameUser AS Modified_By 
			FROM [dbo].WAMS_STOCK_TYPE st (NOLOCK)
			CROSS APPLY [dbo].[udf_GetUserName](st.iCreated) AS usc
			CROSS APPLY [dbo].[udf_GetUserName](st.iModified) AS usm
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN st.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1 = CASE WHEN @code = '' THEN 1 WHEN st.TypeCode = @code THEN 1 END
	AND 1 = CASE WHEN @name = '' THEN 1 WHEN st.TypeName like '%' + @name + '%' THEN 1 END
	) tblTemp ) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
END
/*
exec dbo.V3_List_StockType 1, 100,'','',''
*/
GO

-- V3_List_StockType_Count
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_StockType_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_StockType_Count]
GO

CREATE PROCEDURE [dbo].[V3_List_StockType_Count]
@page int
,@size int
,@enable char(1)
,@code nvarchar(500)
,@name nvarchar(500)
AS
BEGIN
	SELECT COUNT(1) AS [Count]
	FROM [dbo].WAMS_STOCK_TYPE st (NOLOCK)
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN st.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1 = CASE WHEN @code = '' THEN 1 WHEN st.TypeCode = @code THEN 1 END
	AND 1 = CASE WHEN @name = '' THEN 1 WHEN st.TypeName like '%' + @name + '%' THEN 1 END
END
/*
exec dbo.V3_List_StockType_Count 1, 100,'','',''
*/

-- V3_PE_PDF
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_PE_PDF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_PE_PDF]
GO
CREATE PROCEDURE [dbo].[V3_PE_PDF]
@id int
AS
BEGIN
	SELECT po.Id
	,po.vPOID AS PE
	,po.dPODate AS PE_Date
	,po.fPOTotal AS [Total]
	,po.vRemark AS [Remark]
	,po.vPOStatus AS [Status]
	,po.vLocation AS Location
	,po.dDeliverDate AS [Deliver_Date]
	      ,potype.vPOTypeName AS [Type] 
      ,project.vProjectID AS Project_Code
      ,project.vProjectName AS Project_Name
      ,supp.vSupplierName AS Supplier
      ,curr.vCurrencyName AS Currency
      ,store.Name Store
      ,pay.PaymentName AS Payment_Term
	  ,poDetail.TotalVAT AS TotalVAT
	  ,poDetail.TotalNotVAT AS TotalNotVAT
	FROM [dbo].[WAMS_PURCHASE_ORDER] po (NOLOCK) 
	INNER JOIN (
	select vPOID,SUM((fQuantity*fUnitPrice) - (fQuantity*fUnitPrice)*iDiscount/100) AS TotalNotVAT
, SUM(((fQuantity*fUnitPrice) - (fQuantity*fUnitPrice)*iDiscount/100)*fVAT/100) AS TotalVAT  
FROM WAMS_PO_DETAILS where vPOID=@id AND iEnable=1 GROUP BY vPOID
	) poDetail ON poDetail.vPOID = po.Id
	LEFT JOIN [dbo].[WAMS_PROJECT] project (NOLOCK) ON po.vProjectID = project.Id
	LEFT JOIN [dbo].[WAMS_PO_TYPE] potype (NOLOCK) ON potype.bPOTypeID = po.bPOTypeID
	LEFT JOIN [dbo].[PaymentTerm] pay (NOLOCK) ON pay.Id = po.iPayment
	LEFT JOIN [dbo].[WAMS_CURRENCY_TYPE] curr (NOLOCK) ON curr.bCurrencyTypeID = po.bCurrencyTypeID
	LEFT JOIN [dbo].[WAMS_SUPPLIER] supp (NOLOCK) ON supp.bSupplierID = po.bSupplierID
	LEFT JOIN [dbo].[Store] store (NOLOCK) ON store.Id = po.iStore
	WHERE po.Id = @id
END
/*
exec [dbo].[V3_PE_PDF] 32469
*/

--V3_Stock_List_Pe
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Stock_Pe]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Stock_Pe]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Stock_Pe]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Stock_Pe]
GO
GO
CREATE PROCEDURE [dbo].[V3_List_Stock_Pe]
@page int
,@size int
,@enable char(1)
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@store varchar(50)
,@type int
,@category int
,@supplier int
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT stock.Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,stock.vBrand AS Brand
	,stock.vAccountCode AS Account_Code
	,stype.TypeName AS [Type]
	,unit.vUnitName AS Unit
	,cate.vCategoryName AS Category
	,storeQuantity.*
	,stock.bWeight AS [Weight]
	,stock.RalNo
	,stock.ColorName AS Color
	,stock.PartNo
	,stock.vRemark AS Remark
	,stock.dCreated AS Created_Date
	,usc.NameUser AS Created_By
	,stock.dModified AS Modified_Date
	,usm.NameUser AS Modified_By
	FROM [dbo].[WAMS_PRODUCT] supplier (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = supplier.vProductID
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stock.iType = stype.Id
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON stock.bUnitID = unit.bUnitID
	LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) ON stock.bCategoryID = cate.bCategoryID
	LEFT JOIN (SELECT StockID,
	  STUFF((SELECT ';' + CAST(Store AS varchar(10))
			   FROM [dbo].[Store_Stock] t2 (NOLOCK) 
			   WHERE t2.StockID = t1.StockID
			   AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
			   FOR XML PATH('')),1,1,'') as Stores,
		STUFF((SELECT ';' + CAST(Quantity as varchar(10))
		   FROM [dbo].[Store_Stock] t2 (NOLOCK)
		   WHERE t2.StockID = t1.StockID
		   AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
		   FOR XML PATH('')),1,1,'') as Quantity   
	FROM [dbo].[Store_Stock] t1 (NOLOCK)
	GROUP BY StockID) storeQuantity ON storeQuantity.StockID= stock.Id
	CROSS APPLY [dbo].[udf_GetUserName](stock.iCreated) AS usc
	CROSS APPLY [dbo].[udf_GetUserName](stock.iModified) AS usm
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN stock.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	AND 1= CASE WHEN @supplier=0 THEN 1 WHEN supplier.bSupplierID = @supplier THEN 1 END
	) tblTemp) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
END
/*
exec dbo.V3_List_Stock_pe 1, 10, 1,'A010001','', '', 0, 0, 1
*/
GO

--V3_List_Stock_Pe_Count
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Stock_Pe_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Stock_Pe_Count]
GO

CREATE PROCEDURE [dbo].[V3_List_Stock_Pe_Count]
@page int
,@size int
,@enable char(1)
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@store varchar(50)
,@type int
,@category int
,@supplier int
AS
BEGIN
	SELECT COUNT(1) AS [Count] 
	FROM [dbo].[WAMS_PRODUCT] supplier (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = supplier.vProductID
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN stock.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	AND 1= CASE WHEN @supplier=0 THEN 1 WHEN supplier.bSupplierID = @supplier THEN 1 END
END
/*
exec dbo.V3_List_Stock_Pe_Count 1, 10, 1, '1,2', 0, 0,'', 1
*/
GO
--V3_List_Stock_StockIn
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Stock_StockIn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Stock_StockIn]
GO
CREATE PROCEDURE [dbo].[V3_List_Stock_StockIn]
@page int
,@size int
,@enable char(1)
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@store varchar(50)
,@type int
,@category int
,@pe int
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT stock.Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,stock.vBrand AS Brand
	,stock.vAccountCode AS Account_Code
	,stype.TypeName AS [Type]
	,unit.vUnitName AS Unit
	,cate.vCategoryName AS Category
	,storeQuantity.*
	,stock.bWeight AS [Weight]
	,stock.RalNo
	,stock.ColorName AS Color
	,stock.PartNo
	,stock.vRemark AS Remark
	,stock.dCreated AS Created_Date
	,usc.NameUser AS Created_By
	,stock.dModified AS Modified_Date
	,usm.NameUser AS Modified_By
	FROM [dbo].[WAMS_PO_DETAILS] pe (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = pe.vProductID
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stock.iType = stype.Id
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON stock.bUnitID = unit.bUnitID
	LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) ON stock.bCategoryID = cate.bCategoryID
	LEFT JOIN (SELECT StockID,
	  STUFF((SELECT ';' + CAST(Store AS varchar(10))
			   FROM [dbo].[Store_Stock] t2 (NOLOCK) 
			   WHERE t2.StockID = t1.StockID
			   AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
			   FOR XML PATH('')),1,1,'') as Stores,
		STUFF((SELECT ';' + CAST(Quantity as varchar(10))
		   FROM [dbo].[Store_Stock] t2 (NOLOCK)
		   WHERE t2.StockID = t1.StockID
		   AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
		   FOR XML PATH('')),1,1,'') as Quantity   
	FROM [dbo].[Store_Stock] t1 (NOLOCK)
	GROUP BY StockID) storeQuantity ON storeQuantity.StockID= stock.Id
	CROSS APPLY [dbo].[udf_GetUserName](stock.iCreated) AS usc
	CROSS APPLY [dbo].[udf_GetUserName](stock.iModified) AS usm
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN stock.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	AND 1= CASE WHEN @pe=0 THEN 1 WHEN pe.vPOID = @pe THEN 1 END
	AND pe.vPODetailStatus ='Open'
	) tblTemp) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
END
/*
exec dbo.V3_List_Stock_StockIn 1, 10, 1,'A010001','', '', 0, 0, 'APR/11/2014'
*/
GO

--V3_List_Stock_StockIn_Count
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Stock_StockIn_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Stock_StockIn_Count]
GO
CREATE PROCEDURE [dbo].[V3_List_Stock_StockIn_Count]
@page int
,@size int
,@enable char(1)
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@store varchar(50)
,@type int
,@category int
,@pe int
AS
BEGIN
	SELECT COUNT(1) AS [Count] 
	FROM [dbo].[WAMS_PO_DETAILS] pe (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = pe.vProductID
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN stock.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	AND 1= CASE WHEN @pe=0 THEN 1 WHEN pe.vPOID = @pe THEN 1 END
	AND pe.vPODetailStatus ='Open'
END
/*
exec dbo.V3_List_Stock_StockIn_Count 1, 10, 1, '1,2', 0, 0,'','APR/11/2015'
*/
GO

-- V3_Requisition_Master
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Requisition_Master]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Requisition_Master]
GO
CREATE PROCEDURE [dbo].[V3_Requisition_Master]
@id int
AS
BEGIN
	SELECT  req.*
	,proj.vProjectID [Project_Code]
	,proj.vProjectName [Project_Name]
			FROM [dbo].[WAMS_REQUISITION_MASTER] (NOLOCK) req
			LEFT JOIN [dbo].[WAMS_PROJECT] proj (NOLOCK) ON proj.Id=req.vProjectID
	WHERE 
	req.iEnable = 1
	AND 1 = CASE WHEN @id = 0 THEN 1 WHEN req.Id = @id THEN 1 END
END

/*
exec [dbo].[V3_Requisition_Master] 9948
*/
-- V3_List_StockIn
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_StockIn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_StockIn]
GO
CREATE PROCEDURE [dbo].[V3_List_StockIn]
@page int
,@size int
,@store int
,@poType int
,@status varchar(20)
,@po nvarchar(16)
,@supplier int
,@srv nvarchar(20)
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@fd varchar(22) 
,@td varchar(22) 
,@enable int
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY Year DESC, PE_Month DESC, PE_Code DESC) AS [No]
	,tblTable.* 
	FROM
	(SELECT DISTINCT po.Id AS [PE_Id]
		,po.vPOID AS [PE_Code]
		,potype.vPOTypeName AS [PE_Type] 
		,po.dPODate AS [PE_Date]
		,po.fPOTotal AS [PE_Total]
		,currency.vCurrencyName AS [Currency]
		,po.vLocation AS [PE_Location]
		,po.vPOStatus AS [PE_Status]
		,supp.vSupplierName AS [Supplier]
		,store.Name AS [Store]
		,SUBSTRING(po.vPOID, 5, 2) AS [Year] 
		,CASE substring(po.vPOID, 0, 4) 
		  WHEN 'JAN' THEN 1 
		  WHEN 'FEB' THEN 2 
		  WHEN 'MAR' THEN 3 
		  WHEN 'APR' THEN 4 
		  WHEN 'MAY' THEN 5 
		  WHEN 'JUN' THEN 6 
		  WHEN 'JUL' THEN 7 
		  WHEN 'AUG' THEN 8 
		  WHEN 'SEP' THEN 9 
		  WHEN 'OCT' THEN 10
		  WHEN 'NOV' THEN 11  
		  WHEN 'DEC' THEN 12 END AS PE_Month 
	FROM [dbo].[WAMS_FULFILLMENT_DETAIL] ful (NOLOCK)
	INNER JOIN [dbo].[WAMS_PURCHASE_ORDER] po (NOLOCK) ON ful.vPOID = po.Id
	INNER JOIN [dbo].[WAMS_PO_TYPE] potype (NOLOCK) ON potype.bPOTypeID = po.bPOTypeID
	INNER JOIN [dbo].[WAMS_SUPPLIER] supp (NOLOCK) ON supp.bSupplierID = po.bSupplierID
	INNER JOIN [dbo].[Store] store (NOLOCK) ON store.Id = po.iStore
	INNER JOIN [dbo].[WAMS_CURRENCY_TYPE] currency (NOLOCK) ON currency.bCurrencyTypeID = po.bCurrencyTypeID
	INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = ful.vStockID
	WHERE
	1 = CASE WHEN @store=0 THEN 1 WHEN ful.iStore = @store THEN 1 END
	AND 1 = CASE WHEN @poType = 0 THEN 1 WHEN po.bPOTypeID = @poType THEN 1 END
	AND 1 = CASE WHEN @status = '' THEN 1 WHEN po.vPOStatus = @status THEN 1 END
	AND 1 = CASE WHEN @po = '' THEN 1 WHEN po.vPOID = @po THEN 1 END
	AND 1 = CASE WHEN @supplier = 0 THEN 1 WHEN po.bSupplierID = @supplier THEN 1 END
	AND 1 = CASE WHEN @sRV = '' THEN 1 WHEN ful.SRV = @sRV THEN 1 END
	AND 1 = CASE WHEN @stockCode = '' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1 = CASE WHEN @stockName = '' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (ful.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR ful.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (ful.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR ful.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @enable='' THEN 1 WHEN ful.iEnable = CAST(@enable AS INT) THEN 1 END
	) tblTable ) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
END
/*
exec dbo.V3_List_StockIn 1, 20,0,0,'',0,'','','','','',1
*/
-- V3_List_StockIn_Count
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_StockIn_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_StockIn_Count]
GO
CREATE PROCEDURE [dbo].[V3_List_StockIn_Count]
@page int
,@size int
,@store int
,@poType int
,@status varchar(20)
,@po nvarchar(16)
,@supplier int
,@srv nvarchar(20)
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@fd varchar(22) 
,@td varchar(22) 
,@enable int
AS
BEGIN	
	SELECT COUNT(1) AS [Count]
	FROM [dbo].[WAMS_FULFILLMENT_DETAIL] ful (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON ful.vStockID = stock.Id
	INNER JOIN [dbo].[WAMS_PURCHASE_ORDER] po (NOLOCK) ON ful.vPOID = po.Id
	WHERE
	1 = CASE WHEN @store=0 THEN 1 WHEN ful.iStore = @store THEN 1 END
	AND 1 = CASE WHEN @poType = 0 THEN 1 WHEN po.bPOTypeID = @poType THEN 1 END
	AND 1 = CASE WHEN @status = '' THEN 1 WHEN po.vPOStatus = @status THEN 1 END
	AND 1 = CASE WHEN @po = '' THEN 1 WHEN po.vPOID = @po THEN 1 END
	AND 1 = CASE WHEN @supplier = 0 THEN 1 WHEN po.bSupplierID = @supplier THEN 1 END
	AND 1 = CASE WHEN @srv = '' THEN 1 WHEN ful.SRV = @srv THEN 1 END
	AND 1 = CASE WHEN @stockCode = '' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1 = CASE WHEN @stockName = '' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (ful.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR ful.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (ful.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR ful.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @enable='' THEN 1 WHEN ful.iEnable = CAST(@enable AS INT) THEN 1 END
END
/*
exec dbo.V3_List_StockIn_Count 1, 10,0,0,'',0,'','','','','',1
*/
GO
-- V3_StockInDetail
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_StockInDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_StockInDetail]
GO
CREATE PROCEDURE [dbo].[V3_StockInDetail]
	@id int
	,@enable char(1)
AS
BEGIN
	SELECT ful.ID AS [Id]
	,ful.vPOID AS [PE_Id]
	,po.vPOID AS [PE_Code]
	,ful.vStockID AS [Stock_Id]
	,stock.vStockID AS [Stock_Code]
	,stock.vStockName AS [Stock_Name]
	,ful.dQuantity AS [Qty_Total]
	,ful.dReceivedQuantity AS [Qty_Received]
	,ful.dPendingQuantity AS [Qty_Pending]
	,ful.vInvoiceNo AS [InvoiceNo]
	,ful.dInvoiceDate AS [InvoiceDate]
	,ful.tDescription AS [Description]
	,ful.vMRF AS [MRF]
	,ful.SRV AS [SRV]
	,unit.vUnitName AS Unit
	,stype.TypeName AS [Type]
	,cate.vCategoryName AS Category
	,stock.RalNo
	,stock.ColorName AS [Color]
	,stock.PartNo
	FROM [dbo].[WAMS_FULFILLMENT_DETAIL] ful (NOLOCK)
	INNER JOIN [dbo].[WAMS_PURCHASE_ORDER] po (NOLOCK) ON ful.vPOID = po.Id
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id= ful.vStockID
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stype.Id = stock.iType
	LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) ON stock.bCategoryID = cate.bCategoryID
	WHERE 1 = CASE WHEN @enable='' THEN 1 WHEN ful.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1 = CASE WHEN @id = 0 THEN 1 WHEN ful.vPOID = @id THEN 1 END
END
GO
--exec [dbo].[V3_StockInDetail] 22292,''
GO
-- V3_List_StockIn_Detail
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_StockIn_Detail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_StockIn_Detail]
GO
CREATE PROCEDURE [dbo].[V3_List_StockIn_Detail]
	@page int
	,@size int
	,@store int
	,@poType int
	,@status nvarchar(20)
	,@po nvarchar(16)
	,@supplier int
	,@srv nvarchar(20)
	,@stockCode nvarchar(200)
	,@stockName nvarchar(200)
	,@fd varchar(22) 
	,@td varchar(22) 
	,@enable int
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT ful.ID AS [Id]
	,ful.vPOID AS [PE_Id]
	,tbMaster.PE_Code AS [PE_Code]
	,ful.vStockID AS [Stock_Id]
	,stock.vStockID AS [Stock_Code]
	,stock.vStockName AS [Stock_Name]
	,ful.dQuantity AS [Qty_Total]
	,ful.dReceivedQuantity AS [Qty_Received]
	,ful.dPendingQuantity AS [Qty_Pending]
	,ful.dImportTax AS [ImportTax]
	,ful.vInvoiceNo AS [InvoiceNo]
	,ful.dInvoiceDate AS [InvoiceDate]
	,ful.tDescription AS [Description]
	,ful.vMRF AS [MRF]
	,ful.SRV AS [SRV]
	,unit.vUnitName AS Unit
	,stype.TypeName AS [Type]
	,cate.vCategoryName AS Category
	,stock.RalNo
	,stock.ColorName AS [Color]
	,stock.PartNo
	FROM [dbo].[WAMS_FULFILLMENT_DETAIL] ful (NOLOCK)
	INNER JOIN (
		SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY Year DESC, PE_Month DESC, PE_Code DESC) AS [No]
	,tblTable.* 
	FROM
	(SELECT DISTINCT po.Id, po.vPOID AS [PE_Code]
	,SUBSTRING(po.vPOID, 5, 2) AS [Year] 
		,CASE substring(po.vPOID, 0, 4) 
		  WHEN 'JAN' THEN 1 
		  WHEN 'FEB' THEN 2 
		  WHEN 'MAR' THEN 3 
		  WHEN 'APR' THEN 4 
		  WHEN 'MAY' THEN 5 
		  WHEN 'JUN' THEN 6 
		  WHEN 'JUL' THEN 7 
		  WHEN 'AUG' THEN 8 
		  WHEN 'SEP' THEN 9 
		  WHEN 'OCT' THEN 10
		  WHEN 'NOV' THEN 11  
		  WHEN 'DEC' THEN 12 END AS PE_Month 
	FROM [dbo].[WAMS_FULFILLMENT_DETAIL] ful (NOLOCK)
	INNER JOIN [dbo].[WAMS_PURCHASE_ORDER] po (NOLOCK) ON ful.vPOID = po.Id
	INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = ful.vStockID
	WHERE
	1 = CASE WHEN @store=0 THEN 1 WHEN ful.iStore = @store THEN 1 END
	AND 1 = CASE WHEN @poType = 0 THEN 1 WHEN po.bPOTypeID = @poType THEN 1 END
	AND 1 = CASE WHEN @status = '' THEN 1 WHEN po.vPOStatus = @status THEN 1 END
	AND 1 = CASE WHEN @po = '' THEN 1 WHEN po.vPOID = @po THEN 1 END
	AND 1 = CASE WHEN @supplier = 0 THEN 1 WHEN po.bSupplierID = @supplier THEN 1 END
	AND 1 = CASE WHEN @sRV = '' THEN 1 WHEN ful.SRV = @sRV THEN 1 END
	AND 1 = CASE WHEN @stockCode = '' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1 = CASE WHEN @stockName = '' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (ful.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR ful.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (ful.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR ful.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @enable='' THEN 1 WHEN ful.iEnable = CAST(@enable AS INT) THEN 1 END
	) tblTable ) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
	) tbMaster ON tbMaster.Id = ful.vPOID
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id= ful.vStockID
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stype.Id = stock.iType
	LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) ON cate.bCategoryID = stock.bCategoryID
	ORDER BY ful.vPOID DESC
END
GO
/*
exec dbo.V3_List_StockIn 1, 20,0,0,'',0,'','','','','',1
exec [dbo].[V3_List_StockIn_Detail] 1, 20,0,0,'',0,'','','','','',1
*/

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_ProjectById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_ProjectById]
GO
CREATE PROCEDURE [dbo].[V3_ProjectById]
@id INT
AS
BEGIN
	SELECT [Id]
      ,[vProjectID]
      ,[vProjectName]
      ,[vLocation]
      ,[vMainContact]
      ,[vCompanyName]
      ,[dBeginDate]
      ,[vRemark]
      ,[vDescription]
      ,[iEnable]
      ,[StatusId]
      ,[ClientId]
      ,[CountryId]
      ,[Suppervisor]
      ,[StoreId]
      ,[dCreated]
      ,[dModified]
      ,[iCreated]
      ,[iModified]
      ,[dEnd]
      ,[Timestamp] FROM [dbo].[WAMS_PROJECT] (NOLOCK) 
	WHERE id = @id
END
/*
exec [dbo].[V3_ProjectById] 1
*/
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Check_Login]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Check_Login]
GO
CREATE PROCEDURE [dbo].[V3_Check_Login]
@user nvarchar(64)
AS
BEGIN
	SELECT  UserName AS [User_Name]
			,[Password] AS [Password]
			FROM [dbo].XUser (NOLOCK) 
	WHERE 
	[Enable] = 1
	AND (UserName = @user OR Email = @user)
END
/*
exec [dbo].[V3_Check_Login] 'wams@yahoo.com'
*/
GO
-- V3_List_Service
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Service]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Service]
GO
CREATE PROCEDURE [dbo].[V3_List_Service]
@page int
,@size int
,@code nvarchar(2000)
,@name nvarchar(2000)
,@store int
,@category int
,@enable char(1)
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT sv.Id
	,sv.vIDServiceItem AS Service_Code
	,sv.vServiceItemName AS Service_Name
	,sv.vDescription AS [Description]
	,sv.vStockType AS [Type]
	,sv.bWeight AS [Weight]
	,sv.vAccountCode AS [Account_Code]
	,unit.vUnitName AS Unit
	,cate.vCategoryName AS Category
	,sv.dCreated AS Created_Date
	,usc.NameUser AS Created_By
	,sv.dModified AS Modified_Date
	,usm.NameUser AS Modified_By
	FROM [dbo].[WAMS_ITEMS_SERVICE] sv
	INNER JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON sv.bUnitID = unit.bUnitID
	INNER JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) ON sv.bCategoryID = cate.bCategoryID
	CROSS APPLY [dbo].[udf_GetUserName](sv.iCreated) AS usc
	CROSS APPLY [dbo].[udf_GetUserName](sv.iModified) AS usm
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN sv.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1= CASE WHEN @code='' THEN 1 WHEN sv.vIDServiceItem = @code THEN 1 END
	AND 1= CASE WHEN @name='' THEN 1 WHEN sv.vServiceItemName like '%' + @name + '%' THEN 1 END
	AND 1= CASE WHEN @store=0 THEN 1 WHEN sv.StoreId = @store THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN sv.bCategoryID = @category THEN 1 END
	) tblTemp) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
END
/*
exec dbo.V3_List_Service 1, 10, 1, 0, 0,''
*/
GO
-- V3_List_Service_Count
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Service_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Service_Count]
GO
CREATE PROCEDURE [dbo].[V3_List_Service_Count]
@page int
,@size int
,@code nvarchar(2000)
,@name nvarchar(2000)
,@store int
,@category int
,@enable char(1)
AS
BEGIN
	SELECT COUNT(1) AS [Count]
	FROM [dbo].[WAMS_ITEMS_SERVICE] sv
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN sv.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1= CASE WHEN @code='' THEN 1 WHEN sv.vIDServiceItem = @code THEN 1 END
	AND 1= CASE WHEN @name='' THEN 1 WHEN sv.vServiceItemName like '%' + @name + '%' THEN 1 END
	AND 1= CASE WHEN @store=0 THEN 1 WHEN sv.StoreId = @store THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN sv.bCategoryID = @category THEN 1 END
END
/*
exec dbo.V3_List_Service_Count 1, 10, 1, 0, 0,''
*/
GO

-- V3_Document
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Document]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Document]
GO
CREATE PROCEDURE [dbo].[V3_Document]
@key int
,@type int
AS
BEGIN
	SELECT * FROM [dbo].[Document] (NOLOCK)
	WHERE [KeyId] = @key AND [DocumentTypeId] = @type
	ORDER BY [ActionDate] DESC
END
/*
exec dbo.V3_Document 1 ,1
*/
GO
-- V3_DocumentById
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_DocumentById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_DocumentById]
GO
CREATE PROCEDURE [dbo].[V3_DocumentById]
@id int
AS
BEGIN
	SELECT * FROM [dbo].[Document] (NOLOCK)
	WHERE [Id] = @id
END
/*
exec dbo.V3_DocumentById 1
*/
GO
-- V3_GetPoId_Lastest
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetPoId_Lastest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetPoId_Lastest]
GO
CREATE PROCEDURE [dbo].[V3_GetPoId_Lastest]
@condition nvarchar(10)
AS
BEGIN
	SELECT top 1 vPOID, substring(vPOID,8,4) as Code, SUBSTRING(vPOID, 5, 2) AS yYear, 
		  CASE substring(vPOID, 0, 4) 
		  WHEN 'JAN' THEN 1 
		  WHEN 'FEB' THEN 2 
		  WHEN 'MAR' THEN 3 
		  WHEN 'APR' THEN 4 
		  WHEN 'MAY' THEN 5 
		  WHEN 'JUN' THEN 6 
		  WHEN 'JUL' THEN 7 
		  WHEN 'AUG' THEN 8 
		  WHEN 'SEP' THEN 9 
		  WHEN 'OCT' THEN 10
		  WHEN 'NOV' THEN 11  
		  WHEN 'DEC' THEN 12 END AS Month_Order
		FROM [dbo].[WAMS_PURCHASE_ORDER] (NOLOCK)
		WHERE vPOID like '%' + @condition +'%'
		ORDER BY yYear DESC, Month_Order DESC, vPOID DESC
END
/*
exec dbo.V3_GetPoId_Lastest 'AUG/14/'
*/
GO
-- V3_Stock_Search
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Stock_Search]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Stock_Search]
GO

CREATE PROCEDURE [dbo].[V3_Stock_Search]
@page int
,@size int
,@enable char(1)
,@fromStore varchar(50)
,@stype int
,@category int
,@stock nvarchar(2000)
,@itemCount int output
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT stock.Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,stock.vBrand AS Brand
	,stock.vAccountCode AS Account_Code
	,stype.TypeName AS [Type]
	,unit.vUnitName AS Unit
	,cate.vCategoryName AS Category
	,storeQuantity.*
	,stock.bWeight AS [Weight]
	,stock.RalNo
	,stock.ColorName AS Color
	,stock.PartNo
	,stock.vRemark AS Remark
	FROM [dbo].[WAMS_STOCK] stock
	INNER JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stock.iType = stype.Id
	INNER JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON stock.bUnitID = unit.bUnitID
	INNER JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) ON stock.bCategoryID = cate.bCategoryID
	LEFT JOIN (SELECT StockID,
	  STUFF((SELECT ';' + CAST(Store AS varchar(10))
			   FROM [dbo].[Store_Stock] t2
			   WHERE t2.StockID = t1.StockID
			   AND 1 = CASE WHEN @fromStore = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@fromStore)) THEN 1 END
			   FOR XML PATH('')),1,1,'') as Stores,
		STUFF((SELECT ';' + CAST(Quantity as varchar(10))
		   FROM [dbo].[Store_Stock] t2
		   WHERE t2.StockID = t1.StockID
		   AND 1 = CASE WHEN @fromStore = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@fromStore)) THEN 1 END
		   FOR XML PATH('')),1,1,'') as Quantity   
	FROM [dbo].[Store_Stock] t1
	GROUP BY StockID) storeQuantity ON storeQuantity.StockID= stock.Id
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN stock.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1= CASE WHEN @stype=0 THEN 1 WHEN stock.iType = @stype THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
	AND 1= CASE WHEN @stock='' THEN 1 WHEN (stock.vStockID = @stock OR stock.vStockName like '%' + @stock + '%') THEN 1 END
	) tblTemp) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
	
	SELECT @itemCount = COUNT(1) 
	FROM (SELECT 0 AS CountItem
	FROM [dbo].[WAMS_STOCK] stock
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN stock.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1= CASE WHEN @stype=0 THEN 1 WHEN stock.iType = @stype THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
	AND 1= CASE WHEN @stock='' THEN 1 WHEN (stock.vStockID = @stock OR stock.vStockName like '%' + @stock + '%') THEN 1 END
	) tempAll
	
	RETURN @itemCount
END
/*
declare @itemCount int
exec dbo.V3_Stock_Search 1, 10, 1, '1,2', 0, 0,'',@itemCount
print @itemCount
*/
GO

-- V3_GetStockInformation
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Information_Stock]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Information_Stock]
GO
CREATE PROCEDURE [dbo].[V3_Information_Stock]
@id int
,@store int
AS
BEGIN
	SELECT stock.Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,unit.vUnitName AS Unit
	,tpe.TypeName AS [Type]
	,cte.vCategoryName AS Category
	,stock.RalNo AS Ral_No
	,stock.ColorName AS Color
	,stock.PartNo AS Part_No
	,stock.iType AS TypeId
	,stock.bCategoryID AS CategoryId
	,stock.bUnitID AS UnitId
	,storeQuantity.*
	FROM [dbo].[WAMS_STOCK] stock (NOLOCK)
	INNER JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	INNER JOIN [dbo].[WAMS_STOCK_TYPE] tpe (NOLOCK) ON tpe.Id = stock.iType
	INNER JOIN [dbo].[WAMS_CATEGORY] cte (NOLOCK) ON cte.bCategoryID = stock.bCategoryID
	LEFT JOIN (SELECT StockID,
	  STUFF((SELECT ';' + CAST(Store AS varchar(10))
			   FROM [dbo].[Store_Stock] t2 (NOLOCK) 
			   WHERE t2.StockID = t1.StockID
			   AND 1 = CASE WHEN @store = 0 THEN 1 WHEN Store =@store THEN 1 END
			   FOR XML PATH('')),1,1,'') as Stores,
		STUFF((SELECT ';' + CAST(Quantity as varchar(10))
		   FROM [dbo].[Store_Stock] t2 (NOLOCK)
		   WHERE t2.StockID = t1.StockID
		   AND 1 = CASE WHEN @store = 0 THEN 1 WHEN Store = @store THEN 1 END
		   FOR XML PATH('')),1,1,'') as Quantity   
	FROM [dbo].[Store_Stock] t1 (NOLOCK)
	GROUP BY StockID) storeQuantity ON storeQuantity.StockID= stock.Id
	WHERE 1 = CASE WHEN @id = 0 THEN 1 WHEN stock.Id = @id THEN 1 END
END
/*
exec dbo.V3_Information_Stock 11398
*/
GO

-- V3_Information_Stock_Requisition
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Information_Stock_Requisition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Information_Stock_Requisition]
GO
CREATE PROCEDURE [dbo].[V3_Information_Stock_Requisition]
@code nvarchar(200)
,@store varchar(50)
AS
BEGIN
	SELECT stock.Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,unit.vUnitName AS Unit
	,tpe.TypeName AS [Type]
	,cte.vCategoryName AS Category
	,stock.RalNo AS Ral_No
	,stock.ColorName AS Color
	,stock.PartNo AS Part_No
	,stock.iType AS TypeId
	,stock.bCategoryID AS CategoryId
	,stock.bUnitID AS UnitId
	,storeQuantity.*
	FROM [dbo].[WAMS_STOCK] stock (NOLOCK)
	INNER JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	INNER JOIN [dbo].[WAMS_STOCK_TYPE] tpe (NOLOCK) ON tpe.Id = stock.iType
	INNER JOIN [dbo].[WAMS_CATEGORY] cte (NOLOCK) ON cte.bCategoryID = stock.bCategoryID
	LEFT JOIN (SELECT StockID,
	  STUFF((SELECT ';' + CAST(Store AS varchar(10))
			   FROM [dbo].[Store_Stock] t2 (NOLOCK) 
			   WHERE t2.StockID = t1.StockID
			   AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
			   FOR XML PATH('')),1,1,'') as Stores,
		STUFF((SELECT ';' + CAST(Quantity as varchar(10))
		   FROM [dbo].[Store_Stock] t2 (NOLOCK)
		   WHERE t2.StockID = t1.StockID
		   AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
		   FOR XML PATH('')),1,1,'') as Quantity   
	FROM [dbo].[Store_Stock] t1 (NOLOCK)
	GROUP BY StockID) storeQuantity ON storeQuantity.StockID= stock.Id
	WHERE 1 = CASE WHEN @code = '' THEN 1 WHEN stock.vStockID = @code THEN 1 END
END
/*
exec dbo.V3_Information_Stock_Requisition '',
*/
GO
-- V3_Information_Stock_Return
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Information_Stock_Return]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Information_Stock_Return]
GO
CREATE PROCEDURE [dbo].[V3_Information_Stock_Return]
@code nvarchar(200)
,@project varchar(50)
AS
BEGIN
	SELECT stock.Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,unit.vUnitName AS Unit
	,tpe.TypeName AS [Type]
	,cte.vCategoryName AS Category
	,stock.RalNo AS Ral_No
	,stock.ColorName AS Color
	,stock.PartNo AS Part_No
	,stock.iType AS TypeId
	,stock.bCategoryID AS CategoryId
	,stock.bUnitID AS UnitId
	,assigned.vStockID AS [StockID]
	,'' AS Stores
	,CAST(assigned.bQuantity AS NVARCHAR(1000)) AS Quantity
	FROM [dbo].[WAMS_STOCK] stock (NOLOCK)
	INNER JOIN dbo.WAMS_ASSIGNNING_STOCKS assigned (NOLOCK) ON stock.Id = assigned.vStockID
	INNER JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	INNER JOIN [dbo].[WAMS_STOCK_TYPE] tpe (NOLOCK) ON tpe.Id = stock.iType
	INNER JOIN [dbo].[WAMS_CATEGORY] cte (NOLOCK) ON cte.bCategoryID = stock.bCategoryID
	WHERE 1 = CASE WHEN @code = '' THEN 1 WHEN stock.vStockID = @code THEN 1 END
	AND 1 = CASE WHEN @project = '' THEN 1 WHEN assigned.vProjectID = @project THEN 1 END

END
/*
exec dbo.V3_Information_Stock_Return 'A060016',376
*/
GO
-- V3_Information_Stock_Pe
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Information_Stock_Pe]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Information_Stock_Pe]
GO
CREATE PROCEDURE [dbo].[V3_Information_Stock_Pe]
@code nvarchar(200)
,@store varchar(50)
,@supplier int
AS
BEGIN
	SELECT stock.Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,unit.vUnitName AS Unit
	,tpe.TypeName AS [Type]
	,cte.vCategoryName AS Category
	,stock.RalNo AS Ral_No
	,stock.ColorName AS Color
	,stock.PartNo AS Part_No
	,stock.iType AS TypeId
	,stock.bCategoryID AS CategoryId
	,stock.bUnitID AS UnitId
	,storeQuantity.*
	FROM [dbo].[WAMS_PRODUCT] supplier (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = supplier.vProductID
	INNER JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	INNER JOIN [dbo].[WAMS_STOCK_TYPE] tpe (NOLOCK) ON tpe.Id = stock.iType
	INNER JOIN [dbo].[WAMS_CATEGORY] cte (NOLOCK) ON cte.bCategoryID = stock.bCategoryID
	LEFT JOIN (SELECT StockID,
	  STUFF((SELECT ';' + CAST(Store AS varchar(10))
			   FROM [dbo].[Store_Stock] t2 (NOLOCK) 
			   WHERE t2.StockID = t1.StockID
			   AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
			   FOR XML PATH('')),1,1,'') as Stores,
		STUFF((SELECT ';' + CAST(Quantity as varchar(10))
		   FROM [dbo].[Store_Stock] t2 (NOLOCK)
		   WHERE t2.StockID = t1.StockID
		   AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
		   FOR XML PATH('')),1,1,'') as Quantity   
	FROM [dbo].[Store_Stock] t1 (NOLOCK)
	GROUP BY StockID) storeQuantity ON storeQuantity.StockID= stock.Id
	WHERE 1 = CASE WHEN @code = '' THEN 1 WHEN stock.vStockID = @code THEN 1 END
	AND 1 = CASE WHEN @supplier = 0 THEN 1 WHEN supplier.bSupplierID = @supplier THEN 1 END
END
/*
exec dbo.V3_Information_Stock_Pe 'A',1,1
*/
GO
-- V3_Information_Stock_StockIn
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Information_Stock_StockIn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Information_Stock_StockIn]
GO
CREATE PROCEDURE [dbo].[V3_Information_Stock_StockIn]
@code nvarchar(200)
,@store varchar(50)
,@pe int
AS
BEGIN
	SELECT stock.Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,unit.vUnitName AS Unit
	,tpe.TypeName AS [Type]
	,cte.vCategoryName AS Category
	,stock.RalNo AS Ral_No
	,stock.ColorName AS Color
	,stock.PartNo AS Part_No
	,stock.iType AS TypeId
	,stock.bCategoryID AS CategoryId
	,stock.bUnitID AS UnitId
	,storeQuantity.*
	,pe.fQuantity [PEQuantity]
	,'' [PendingQuantity]
	FROM [dbo].[WAMS_PO_DETAILS] pe (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = pe.vProductID
	INNER JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	INNER JOIN [dbo].[WAMS_STOCK_TYPE] tpe (NOLOCK) ON tpe.Id = stock.iType
	INNER JOIN [dbo].[WAMS_CATEGORY] cte (NOLOCK) ON cte.bCategoryID = stock.bCategoryID
	LEFT JOIN dbo.WAMS_FULFILLMENT_DETAIL stockIN (NOLOCK) ON stockIN.vStockID = pe.vProductID
	LEFT JOIN (SELECT StockID,
	  STUFF((SELECT ';' + CAST(Store AS varchar(10))
			   FROM [dbo].[Store_Stock] t2 (NOLOCK) 
			   WHERE t2.StockID = t1.StockID
			   AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
			   FOR XML PATH('')),1,1,'') as Stores,
		STUFF((SELECT ';' + CAST(Quantity as varchar(10))
		   FROM [dbo].[Store_Stock] t2 (NOLOCK)
		   WHERE t2.StockID = t1.StockID
		   AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
		   FOR XML PATH('')),1,1,'') as Quantity   
	FROM [dbo].[Store_Stock] t1 (NOLOCK)
	GROUP BY StockID) storeQuantity ON storeQuantity.StockID= stock.Id
	WHERE 1 = CASE WHEN @code = '' THEN 1 WHEN stock.vStockID = @code THEN 1 END
	AND 1 = CASE WHEN @pe = 0 THEN 1 WHEN pe.vPOID = @pe THEN 1 END
END
/*
exec dbo.V3_Information_Stock_StockIn 'A',1,''
*/
GO
-- V3_StockInQuantity
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_StockInQuantity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_StockInQuantity]
GO
CREATE PROCEDURE [dbo].[V3_StockInQuantity]
@code int
,@pe int
AS
BEGIN
	SELECT TOP 1 pe.vProductID [Id]
	,pe.vPOID [PeId]
	,pe.fQuantity [PeQuantity]
	,(pe.fQuantity - quantityTbl.ReceivedQuantity) [PendingQuantity]
	,quantityTbl.ReceivedQuantity [ReceivedQuantity]
	,pe.vMRF [Mrf]
	FROM WAMS_PO_DETAILS pe (NOLOCK)
	LEFT JOIN (
	SELECT vStockID AS Id
		,vPOID AS PeId
		,SUM(dReceivedQuantity) AS ReceivedQuantity
		FROM [dbo].WAMS_FULFILLMENT_DETAIL (NOLOCK)
		WHERE vStockID = @code
		AND vPOID = @pe
		GROUP BY vPOID, vStockID) quantityTbl ON pe.vPOID = quantityTbl.PeId
		WHERE pe.vPOID=@pe AND pe.vProductID = @code AND iEnable=1
END
/*
exec dbo.V3_StockInQuantity 11273,30303
*/
GO
-- V3_GetPrice
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetPrice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetPrice]
GO
CREATE PROCEDURE [dbo].[V3_GetPrice]
@stock int
,@tore int
,@curency int
AS
BEGIN
	SELECT Id,Price
	FROM [dbo].[Product_Price] (NOLOCK)
	WHERE iEnable = 1
	AND 1 = CASE WHEN @stock = 0 THEN 1 WHEN StockId =@stock THEN 1 END
	AND 1 = CASE WHEN @tore = 0 THEN 1 WHEN StoreId =@tore THEN 1 END
	AND 1 = CASE WHEN @curency = 0 THEN 1 WHEN CurrencyId =@curency THEN 1 END
	ORDER BY Price ASC
END
/*
exec dbo.V3_GetPrice 10493,1,1
*/
GO

-- V3_GetMRF
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetMRF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetMRF]
GO
CREATE PROCEDURE [dbo].[V3_GetMRF]
@stock int
,@tore int
AS
BEGIN
	SELECT mt.Id, mt.vMRF FROM [dbo].[WAMS_REQUISITION_MASTER] mt (NOLOCK)
	INNER JOIN [dbo].[WAMS_REQUISITION_DETAILS] detail (NOLOCK) ON detail.vMRF = mt.Id
	WHERE mt.iEnable = 1 AND detail.vStockID=@stock
	AND mt.iStore=@tore 
	ORDER BY mt.vMRF DESC
END
/*
exec dbo.V3_GetMRF 10493,1
*/
GO

-- V3_List_Supplier
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Supplier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Supplier]
GO
CREATE PROCEDURE [dbo].[V3_List_Supplier]
@page int
,@size int
,@supplierType int
,@supplierId int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@country int
,@market int
,@enable int
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY Name ASC) AS [No]
	,tblTable.* 
	FROM
	(SELECT sup.bSupplierID AS Id
			,sup.vSupplierName AS [Name]
			,sup.vAddress AS [Address]
			,sup.vCity AS City
			,sup.vPhone1 AS Phone
			,sup.vPhone2 AS Phone_2
			,sup.vMobile AS Mobile
			,sup.vFax AS Fax
			,sup.vEmail AS Email
			,sup.vContactPerson AS Contact
			,pay.PaymentName AS Payment_Term
			,suptype.vSupplierTypeName AS [Type]
			,store.Name AS Store
			,ct.NameNice AS Country
			,sup.dCreated AS Created_Date
			,usc.NameUser AS Created_By
			,sup.dModified AS Modified_Date
			,usm.NameUser AS Modified_By
			FROM [dbo].[WAMS_SUPPLIER] sup (NOLOCK)
			LEFT JOIN [dbo].[WAMS_SUPPLIER_TYPE] suptype (NOLOCK) ON suptype.bSupplierTypeID = sup.bSupplierTypeID
			LEFT JOIN [dbo].[Country] ct (NOLOCK) ON ct.Id = sup.CountryId
			LEFT JOIN [dbo].[Store] store (NOLOCK) ON store.Id = sup.iStore
			LEFT JOIN [dbo].[PaymentTerm] pay (NOLOCK) ON pay.Id= sup.iPayment
			CROSS APPLY [dbo].[udf_GetUserName](sup.iCreated) AS usc
			CROSS APPLY [dbo].[udf_GetUserName](sup.iModified) AS usm
	WHERE
	1 = CASE WHEN @supplierType=0 THEN 1 WHEN sup.bSupplierTypeID = @supplierType THEN 1 END
	AND 1 = CASE WHEN @supplierId = 0 THEN 1 WHEN sup.bSupplierID = @supplierId THEN 1 END
	AND 1 = CASE WHEN @stockCode = '' THEN 1 
	WHEN sup.bSupplierID IN (SELECT DISTINCT bSupplierID FROM [dbo].[WAMS_PRODUCT] red
					INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = red.vProductID
					WHERE stock.vStockID like '%' + @stockCode + '%') THEN 1 END
	AND 1 = CASE WHEN @stockName = '' THEN 1 
	WHEN sup.bSupplierID IN (SELECT DISTINCT bSupplierID FROM [dbo].[WAMS_PRODUCT] red
					INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = red.vProductID
					WHERE stock.vStockName like '%' + @stockName + '%') THEN 1 END
	AND 1 = CASE WHEN @country = 0 THEN 1 WHEN sup.CountryId = @country THEN 1 END
	AND 1 = CASE WHEN @market = 0 THEN 1 WHEN sup.iMarket = @market THEN 1 END
	AND 1 = CASE WHEN @enable='' THEN 1 WHEN sup.iEnable = CAST(@enable AS INT) THEN 1 END
	) tblTable ) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow

END
/*
exec dbo.V3_List_Supplier 1,10,0,0,'','',0,0,1
*/
GO
-- V3_List_Supplier_Count
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Supplier_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Supplier_Count]
GO
CREATE PROCEDURE [dbo].[V3_List_Supplier_Count]
@page int
,@size int
,@supplierType int
,@supplierId int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@country int
,@market int
,@enable int
AS
BEGIN
	SELECT COUNT(1) AS [Count]
	FROM [dbo].[WAMS_SUPPLIER] sup (NOLOCK)
	WHERE
	1 = CASE WHEN @supplierType=0 THEN 1 WHEN sup.bSupplierTypeID = @supplierType THEN 1 END
	AND 1 = CASE WHEN @supplierId = 0 THEN 1 WHEN sup.bSupplierID = @supplierId THEN 1 END
	AND 1 = CASE WHEN @stockCode = '' THEN 1 
	WHEN sup.bSupplierID IN (SELECT DISTINCT bSupplierID FROM [dbo].[WAMS_PRODUCT] red
					INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = red.vProductID
					WHERE stock.vStockID like '%' + @stockCode + '%') THEN 1 END
	AND 1 = CASE WHEN @stockName = '' THEN 1 
	WHEN sup.bSupplierID IN (SELECT DISTINCT bSupplierID FROM [dbo].[WAMS_PRODUCT] red
					INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = red.vProductID
					WHERE stock.vStockName like '%' + @stockName + '%') THEN 1 END
	AND 1 = CASE WHEN @country = 0 THEN 1 WHEN sup.CountryId = @country THEN 1 END
	AND 1 = CASE WHEN @market = 0 THEN 1 WHEN sup.iMarket = @market THEN 1 END
	AND 1 = CASE WHEN @enable='' THEN 1 WHEN sup.iEnable = CAST(@enable AS INT) THEN 1 END
END
GO
/*
exec dbo.V3_List_Supplier_Count 1,10,0,0,'','',0,0,1
*/
GO
-- V3_SupplierProduct
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_SupplierProduct]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_SupplierProduct]
GO
CREATE PROCEDURE [dbo].[V3_SupplierProduct]
	@id INT
	,@enable char(1)
AS
BEGIN
	SELECT 
		product.Id AS Id
		,product.vProductID AS Stock_Id
		,supplier.bSupplierID AS Supplier_Id
		,supplier.vSupplierName AS Supplier_Name
		,stock.vStockID AS Stock_Code
		,stock.vStockName AS Stock_Name
		,stock.PartNo AS Part_No
		,stock.RalNo AS Ral_No
		,stock.ColorName AS Color
		,stype.TypeName AS [Type]
		,unit.vUnitName AS Unit
		,cate.vCategoryName AS Category
		,product.vDescription AS [Remark]
		FROM [dbo].[WAMS_PRODUCT] product (NOLOCK)
		INNER JOIN dbo.WAMS_SUPPLIER supplier (NOLOCK) ON supplier.bSupplierID = product.bSupplierID
		INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id= product.vProductID
		LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) on stype.Id = stock.iType
		LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) on unit.bUnitID = stock.bUnitID
		LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) on cate.bCategoryID = stock.bCategoryID
		WHERE 1 = CASE WHEN @id = '' THEN 1 WHEN product.bSupplierID = @id THEN 1 END
		AND 1 = CASE WHEN @enable = '' THEN 1 WHEN product.iEnable = CAST(@enable AS INT) THEN 1 END
END
-- exec [dbo].[V3_SupplierProduct] 1, '1'
GO

-- V3_List_Supplier_Product
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Supplier_Product]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Supplier_Product]
GO

CREATE PROCEDURE [dbo].[V3_List_Supplier_Product]
@page int
,@size int
,@supplierType int
,@supplierId int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@country int
,@market int
,@enable int
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1
	SELECT product.Id AS Id
		,product.vProductID AS Stock_Id
		,masterTemp.bSupplierID AS Supplier_Id
		,masterTemp.vSupplierName AS Supplier_Name
		,stock.vStockID AS Stock_Code
		,stock.vStockName AS Stock_Name
		,stock.PartNo AS Part_No
		,stock.RalNo AS Ral_No
		,stock.ColorName AS Color
		,stype.TypeName AS [Type]
		,unit.vUnitName AS Unit
		,cate.vCategoryName AS Category
		,product.vDescription AS [Remark]
		FROM [dbo].[WAMS_PRODUCT] product (NOLOCK)
		INNER JOIN
	(SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY bSupplierID DESC) AS [No]
	,tblTable.* 
	FROM
	(SELECT bSupplierID, vSupplierName FROM WAMS_SUPPLIER sup (NOLOCK)
		WHERE
		1 = CASE WHEN @supplierType=0 THEN 1 WHEN sup.bSupplierTypeID = @supplierType THEN 1 END
		AND 1 = CASE WHEN @supplierId = 0 THEN 1 WHEN sup.bSupplierID = @supplierId THEN 1 END
		AND 1 = CASE WHEN @stockCode = '' THEN 1 
		WHEN sup.bSupplierID IN (SELECT DISTINCT bSupplierID FROM [dbo].[WAMS_PRODUCT] red
						INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = red.vProductID
						WHERE stock.vStockID like '%' + @stockCode + '%') THEN 1 END
		AND 1 = CASE WHEN @stockName = '' THEN 1 
		WHEN sup.bSupplierID IN (SELECT DISTINCT bSupplierID FROM [dbo].[WAMS_PRODUCT] red
						INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = red.vProductID
						WHERE stock.vStockName like '%' + @stockName + '%') THEN 1 END
		AND 1 = CASE WHEN @country = 0 THEN 1 WHEN sup.CountryId = @country THEN 1 END
		AND 1 = CASE WHEN @market = 0 THEN 1 WHEN sup.iMarket = @market THEN 1 END
		AND 1 = CASE WHEN @enable='' THEN 1 WHEN sup.iEnable = CAST(@enable AS INT) THEN 1 END
	) tblTable ) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow) masterTemp ON masterTemp.bSupplierID = product.bSupplierID
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id= product.vProductID
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) on stype.Id = stock.iType
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) on unit.bUnitID = stock.bUnitID
	LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) on cate.bCategoryID = stock.bCategoryID
	ORDER BY masterTemp.bSupplierID ASC, stock.vStockID desc
END
GO
/*
exec dbo.V3_List_Supplier_Product 1,10,0,0,'','',0,0,1
exec dbo.V3_List_Supplier 1,10,0,0,'','',0,0,1
*/
GO


-- V3_List_Price
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Price]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Price]
GO

CREATE PROCEDURE [dbo].[V3_List_Price]
@page int
,@size int
,@store int
,@supplier int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@status int
,@fd varchar(22) 
,@td varchar(22) 
,@enable char(1)
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY Created_Date DESC) AS [No]
	,tblTable.* 
	FROM
	(SELECT price.Id
			,stock.vStockID AS Stock_Code
			,stock.vStockName AS Stock_Name
			,price.Price
			,price.dStart AS [Start]
			,price.dEnd AS [End]
			,looku.LookUpValue [Status]
			,currency.vCurrencyName AS Currency
			,stock.PartNo AS Part_No
			,stock.RalNo AS Ral_No
			,stock.ColorName AS Color
			,supplier.vSupplierName AS Supplier
			,store.Name AS Store
			,stockType.TypeName AS Stock_Type
			,unit.vUnitName AS Unit
			,price.dCreated AS Created_Date
			,usc.NameUser AS Created_By
			,price.dModified AS Modified_Date
			,usm.NameUser AS Modified_By
			FROM [dbo].[Product_Price] price (NOLOCK)
			INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id= price.StockId
			INNER JOIN [dbo].[WAMS_CURRENCY_TYPE] currency (NOLOCK) ON currency.bCurrencyTypeID = price.CurrencyId
			INNER JOIN dbo.LookUp looku (NOLOCK) ON looku.LookUpKey = price.[Status]
			LEFT JOIN [dbo].[Store] store (NOLOCK) ON store.Id = price.StoreId 
			LEFT JOIN [dbo].[WAMS_SUPPLIER] supplier (NOLOCK) ON supplier.bSupplierID = price.SupplierId
			LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stockType (NOLOCK) ON stockType.Id = stock.iType
			LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
			CROSS APPLY [dbo].[udf_GetUserName](price.iCreated) AS usc
			CROSS APPLY [dbo].[udf_GetUserName](price.iModified) AS usm
	WHERE looku.LookUpType='pricestatus'
	AND 1 = CASE WHEN @store=0 THEN 1 WHEN price.StoreId = @store THEN 1 END
	AND 1 = CASE WHEN @supplier = 0 THEN 1 WHEN price.SupplierId = @supplier THEN 1 END
	AND 1 = CASE WHEN @stockCode = '' THEN 1 WHEN stock.vStockID=@stockCode THEN 1 END
	AND 1 = CASE WHEN @stockName = '' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	AND 1 = CASE WHEN @status = 0 THEN 1 WHEN price.[Status] = @status THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (price.dStart >= convert(datetime,(@fd + ' 00:00:00')) OR price.dStart IS NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (price.dStart <= convert(datetime,(@td + ' 23:59:59')) OR price.dStart IS NULL) THEN 1 END
	AND 1 = CASE WHEN @enable='' THEN 1 WHEN price.iEnable = CAST(@enable AS INT) THEN 1 END
	) tblTable ) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
	
END
/*
exec dbo.V3_List_Price 1, 50,0,0,'A010001','','','','1'
*/
GO

-- V3_List_Price_Count
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Price_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Price_Count]
GO

CREATE PROCEDURE [dbo].[V3_List_Price_Count]
@page int
,@size int
,@store int
,@supplier int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@status int
,@fd varchar(22) 
,@td varchar(22) 
,@enable char(1)
AS
BEGIN
	SELECT COUNT(1) AS [Count]
	FROM [dbo].[Product_Price] price (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id= price.StockId
	WHERE
	1 = CASE WHEN @store=0 THEN 1 WHEN price.StoreId = @store THEN 1 END
	AND 1 = CASE WHEN @supplier = 0 THEN 1 WHEN price.SupplierId = @supplier THEN 1 END
	AND 1 = CASE WHEN @stockCode = '' THEN 1 WHEN stock.vStockID=@stockCode THEN 1 END
	AND 1 = CASE WHEN @stockName = '' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	AND 1 = CASE WHEN @status = 0 THEN 1 WHEN price.[Status] = @status THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (price.dStart >= convert(datetime,(@fd + ' 00:00:00')) OR price.dStart IS NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (price.dStart <= convert(datetime,(@td + ' 23:59:59')) OR price.dStart IS NULL) THEN 1 END
	AND 1 = CASE WHEN @enable='' THEN 1 WHEN price.iEnable = CAST(@enable AS INT) THEN 1 END

END
/*
exec dbo.V3_List_Price_Count 1, 50,0,0,'','','',1
*/
GO
-- V3_Price_By_Id
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Price_By_Id]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Price_By_Id]
GO

CREATE PROCEDURE [dbo].[V3_Price_By_Id]
@id int
,@enable char(1)
AS
BEGIN
	SELECT price.Id
			,stock.Id AS Stock_Id
			,stock.vStockID AS Stock_Code
			,stock.vStockName AS Stock_Name
			,price.Price
			,price.dStart AS [Start]
			,price.dEnd AS [End]
			,(CASE WHEN GETDATE() BETWEEN price.dStart and price.dEnd THEN 'Exist'
						 WHEN price.dStart IS NULL and price.dEnd <= GETDATE() THEN 'Exist'
						 WHEN price.dEnd IS NULL and price.dStart >= GETDATE() THEN 'Exist'
						 WHEN price.dStart IS NULL and price.dEnd IS NULL THEN 'Exist'
						 ELSE 'Expired'
						 END) AS [Status]
			,currency.bCurrencyTypeID AS Currency_Id				
			,currency.vCurrencyName AS Currency
			,stock.PartNo AS Part_No
			,stock.RalNo AS Ral_No
			,stock.ColorName AS Color
			,supplier.bSupplierID AS Supplier_Id
			,supplier.vSupplierName AS Supplier
			,store.Id AS Store_Id
			,store.Name AS Store
			,stockType.TypeName AS Stock_Type
			,unit.vUnitName AS Unit
			,price.dCreated AS Created_Date
			,usc.NameUser AS Created_By
			,price.dModified AS Modified_Date
			,usm.NameUser AS Modified_By
			,price.Timestamp
			FROM [dbo].[Product_Price] price (NOLOCK)
			INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id= price.StockId
			INNER JOIN [dbo].[WAMS_CURRENCY_TYPE] currency (NOLOCK) ON currency.bCurrencyTypeID = price.CurrencyId
			LEFT JOIN [dbo].[Store] store (NOLOCK) ON store.Id = price.StoreId 
			LEFT JOIN [dbo].[WAMS_SUPPLIER] supplier (NOLOCK) ON supplier.bSupplierID = price.SupplierId
			LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stockType (NOLOCK) ON stockType.Id = stock.iType
			LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
			CROSS APPLY [dbo].[udf_GetUserName](price.iCreated) AS usc
			CROSS APPLY [dbo].[udf_GetUserName](price.iModified) AS usm
	WHERE
	1 = CASE WHEN @id=0 THEN 1 WHEN price.Id = @id THEN 1 END
	AND 1 = CASE WHEN @enable='' THEN 1 WHEN price.iEnable = CAST(@enable AS INT) THEN 1 END
END
/*
exec dbo.V3_Price_By_Id 1,'1'
*/
GO

-- V3_List_Requisition
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Requisition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Requisition]
GO

CREATE PROCEDURE [dbo].[V3_List_Requisition]
@page int
,@size int
,@enable char(1)
,@store int
,@mrf nvarchar(16)
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@status nvarchar(16)
,@fd varchar(22) 
,@td varchar(22) 
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY MRF DESC) AS [No]
	,tblTable.* 
	FROM
	(SELECT req.Id 
		,req.vMRF AS MRF
		,req.vFrom AS [From]
		,req.dDeliverDate AS Deliver_Date
		,req.vDeliverLocation AS Location
		,req.vStatus AS [Status]
		,project.vProjectID AS Project_Code
		,project.vProjectName AS Project_Name
		,store.Name AS [Store]
		,req.dCreated AS Created_Date
		,usc.NameUser AS Created_By
		,req.dModified AS Modified_Date
		,usm.NameUser AS Modified_By
		FROM [dbo].[WAMS_REQUISITION_MASTER] req (NOLOCK)
		LEFT JOIN [dbo].[WAMS_PROJECT] project (NOLOCK) ON project.Id = req.vProjectID
		INNER JOIN [dbo].[Store] store (NOLOCK) ON store.Id = req.iStore
		CROSS APPLY [dbo].[udf_GetUserName](req.iCreated) AS usc
		CROSS APPLY [dbo].[udf_GetUserName](req.iModified) AS usm
	WHERE
	1 = CASE WHEN @store=0 THEN 1 WHEN req.iStore = @store THEN 1 END
	AND 1 = CASE WHEN @mrf = '' THEN 1 WHEN req.vMRF = @mrf THEN 1 END
	AND 1 = CASE WHEN @stockCode = '' THEN 1 
	WHEN req.Id IN (SELECT DISTINCT vMRF FROM [dbo].[WAMS_REQUISITION_DETAILS] red
					INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = red.vStockID
					WHERE stock.vStockID like '%' + @stockCode + '%') THEN 1 END
	AND 1 = CASE WHEN @stockName = '' THEN 1 
	WHEN req.Id IN (SELECT DISTINCT vMRF FROM [dbo].[WAMS_REQUISITION_DETAILS] red
					INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = red.vStockID
					WHERE stock.vStockName like '%' + @stockName + '%') THEN 1 END
	AND 1 = CASE WHEN @status = '' THEN 1 WHEN req.vStatus = @status THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (req.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR req.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (req.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR req.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @enable='' THEN 1 WHEN req.iEnable = CAST(@enable AS INT) THEN 1 END
	) tblTable ) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
END
/*
exec dbo.V3_List_Requisition 1, 10,'1',0,'','','','Open','02/01/2015','02/04/2015'
*/
GO

-- V3_List_Requisition_Count
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Requisition_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Requisition_Count]
GO

CREATE PROCEDURE [dbo].[V3_List_Requisition_Count]
@page int
,@size int
,@enable char(1)
,@store int
,@mrf nvarchar(16)
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@status nvarchar(16)
,@fd varchar(22) 
,@td varchar(22) 
AS
BEGIN
	SELECT COUNT(1) AS [Count]
	FROM [dbo].[WAMS_REQUISITION_MASTER] (NOLOCK)
	WHERE
	1 = CASE WHEN @store=0 THEN 1 WHEN iStore = @store THEN 1 END
	AND 1 = CASE WHEN @mrf = '' THEN 1 WHEN vMRF = @mrf THEN 1 END
	AND 1 = CASE WHEN @stockCode = '' THEN 1 
	WHEN Id IN (SELECT DISTINCT vMRF FROM [dbo].[WAMS_REQUISITION_DETAILS] red
					INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = red.vStockID
					WHERE stock.vStockID like '%' + @stockCode + '%') THEN 1 END
	AND 1 = CASE WHEN @stockName = '' THEN 1 
	WHEN Id IN (SELECT DISTINCT vMRF FROM [dbo].[WAMS_REQUISITION_DETAILS] red
					INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = red.vStockID
					WHERE stock.vStockName like '%' + @stockName + '%') THEN 1 END
	AND 1 = CASE WHEN @status = '' THEN 1 WHEN vStatus = @status THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (dCreated <= convert(datetime,(@td + ' 23:59:59')) OR dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @enable='' THEN 1 WHEN iEnable = CAST(@enable AS INT) THEN 1 END
END
/*
exec dbo.V3_List_Requisition_Count 1, 10,'1',0,'','','','Open','02/01/2015','02/04/2015'
*/
GO

-- V3_List_Requisition_Detail
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Requisition_Detail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Requisition_Detail]
GO

CREATE PROCEDURE [dbo].[V3_List_Requisition_Detail]
@page int
,@size int
,@enable char(1)
,@store int
,@mrf nvarchar(16)
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@status nvarchar(16)
,@fd varchar(22) 
,@td varchar(22) 
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1
	SELECT reDetail.ID AS Id
		,requisitionMaster.MRF
		,stock.Id AS Stock_Id
		,stock.vStockID AS Stock_Code
		,stock.vStockName AS Stock_Name
		,reDetail.fQuantity AS [Quantity]
		,reDetail.fTobePurchased AS [Quantity_PE]
		,reDetail.iFollowUpRequired AS FollowUpRequired
		,reDetail.iPurchased AS Purchased
		,reDetail.iSent AS [Sent]
		,reDetail.vStatus AS [Status]
		,reDetail.Remark
		,stock.PartNo AS Part_No
		,stock.RalNo AS Ral_No
		,stock.ColorName AS Color
		,stype.TypeName AS [Type]
		,unit.vUnitName AS Unit
		,cate.vCategoryName AS Category
		,storeQuantity.Quantity AS Quantities, storeQuantity.Stores as StoreMult
		,reDetail.dCreated AS Created_Date
	    ,usc.NameUser AS Created_By
	    ,reDetail.dModified AS Modified_Date
	    ,usm.NameUser AS Modified_By
		FROM [dbo].[WAMS_REQUISITION_DETAILS] reDetail (NOLOCK)
		INNER JOIN
	(SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY MRF DESC) AS [No]
	,tblTable.* 
	FROM
	(SELECT Id,vMRF AS MRF FROM WAMS_REQUISITION_MASTER reMt
	WHERE
	1 = CASE WHEN @store=0 THEN 1 WHEN reMt.iStore = @store THEN 1 END
	AND 1 = CASE WHEN @mrf = '' THEN 1 WHEN reMt.vMRF = @mrf THEN 1 END
	AND 1 = CASE WHEN @stockCode = '' THEN 1 
	WHEN reMt.Id IN (SELECT DISTINCT vMRF FROM [dbo].[WAMS_REQUISITION_DETAILS] red
					INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = red.vStockID
					WHERE stock.vStockID like '%' + @stockCode + '%') THEN 1 END
	AND 1 = CASE WHEN @stockName = '' THEN 1 
	WHEN reMt.Id IN (SELECT DISTINCT vMRF FROM [dbo].[WAMS_REQUISITION_DETAILS] red
					INNER JOIN [dbo].[WAMS_STOCK] stock ON stock.Id = red.vStockID
					WHERE stock.vStockName like '%' + @stockName + '%') THEN 1 END
	AND 1 = CASE WHEN @status = '' THEN 1 WHEN reMt.vStatus = @status THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (reMt.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR reMt.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (reMt.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR reMt.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @enable='' THEN 1 WHEN reMt.iEnable = CAST(@enable AS INT) THEN 1 END
	) tblTable ) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow) requisitionMaster ON requisitionMaster.Id = reDetail.vMRF
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id= reDetail.vStockID
		LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) on stype.Id = stock.iType
		LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) on unit.bUnitID = stock.bUnitID
		LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) on cate.bCategoryID = stock.bCategoryID
		CROSS APPLY [dbo].[udf_GetUserName](reDetail.iCreated) AS usc
		CROSS APPLY [dbo].[udf_GetUserName](reDetail.iModified) AS usm
		LEFT JOIN (SELECT StockID,
		  STUFF((SELECT ';' + CAST(Store as varchar(10))
				   FROM [dbo].[Store_Stock] t2 (NOLOCK)
				   WHERE t2.StockID = t1.StockID
				   FOR XML PATH('')),1,1,'') as Stores,
			STUFF((SELECT ';' + CAST(Quantity as varchar(10))
			   FROM [dbo].[Store_Stock] t2 (NOLOCK)
			   where t2.StockID = t1.StockID
			   FOR XML PATH('')),1,1,'') as Quantity   
		FROM [dbo].[Store_Stock] t1 (NOLOCK)
		GROUP BY StockID) storeQuantity ON storeQuantity.StockID= stock.Id
		ORDER BY requisitionMaster.MRF ASC, stock.vStockID desc
END
/*
exec dbo.V3_List_Requisition_Detail 1, 10,'1',0,'','','','Open','01/01/2015','02/04/2015'
exec V3_List_Requisition 1, 10,'1',0,'','','','Open','01/01/2015','02/04/2015'
*/
GO
-- V3_RequisitionDetail
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_RequisitionDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_RequisitionDetail]
GO
CREATE PROCEDURE [dbo].[V3_RequisitionDetail]
	@id INT
	,@enable char(1)
AS
BEGIN
	SELECT 
		reDetail.ID AS Id
		,reMt.vMRF AS MRF
		,stock.Id AS Stock_Id
		,stock.vStockID AS Stock_Code
		,stock.vStockName AS Stock_Name
		,reDetail.fQuantity AS [Quantity]
		,reDetail.fTobePurchased AS [Quantity_PE]
		,reDetail.iFollowUpRequired AS FollowUpRequired
		,reDetail.iPurchased AS Purchased
		,reDetail.iSent AS [Sent]
		,reDetail.vStatus AS [Status]
		,reDetail.Remark AS [Remark]
		,stock.PartNo AS Part_No
		,stock.RalNo AS Ral_No
		,stock.ColorName AS Color
		,stype.TypeName AS [Type]
		,unit.vUnitName AS Unit
		,cate.vCategoryName AS Category
		,storeQuantity.Quantity AS Quantities, storeQuantity.Stores as StoreMult
		,reDetail.dCreated AS Created_Date
	    ,usc.NameUser AS Created_By
	    ,reDetail.dModified AS Modified_Date
	    ,usm.NameUser AS Modified_By
		FROM [dbo].[WAMS_REQUISITION_DETAILS] reDetail (NOLOCK)
		INNER JOIN [dbo].[WAMS_REQUISITION_MASTER] reMt (NOLOCK) ON reMt.Id = reDetail.vMRF
		INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id= reDetail.vStockID
		LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) on stype.Id = stock.iType
		LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) on unit.bUnitID = stock.bUnitID
		LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) on cate.bCategoryID = stock.bCategoryID
		CROSS APPLY [dbo].[udf_GetUserName](reDetail.iCreated) AS usc
		CROSS APPLY [dbo].[udf_GetUserName](reDetail.iModified) AS usm
		LEFT JOIN (SELECT StockID,
		  STUFF((SELECT ';' + CAST(Store as varchar(10))
				   FROM [dbo].[Store_Stock] t2 (NOLOCK)
				   WHERE t2.StockID = t1.StockID
				   FOR XML PATH('')),1,1,'') as Stores,
			STUFF((SELECT ';' + CAST(Quantity as varchar(10))
			   FROM [dbo].[Store_Stock] t2 (NOLOCK)
			   where t2.StockID = t1.StockID
			   FOR XML PATH('')),1,1,'') as Quantity   
		FROM [dbo].[Store_Stock] t1 (NOLOCK)
		GROUP BY StockID) storeQuantity ON storeQuantity.StockID= stock.Id
		WHERE 1 = CASE WHEN @id = '' THEN 1 WHEN reMt.Id = @id THEN 1 END
		AND 1 = CASE WHEN @enable = '' THEN 1 WHEN reDetail.iEnable = CAST(@enable AS INT) THEN 1 END
END
GO
-- exec [dbo].[V3_RequisitionDetail] 9854, '1'
GO





-- V3_List_Store
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Store]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Store]
GO

CREATE PROCEDURE [dbo].[V3_List_Store]
@page int
,@size int
,@enable char(1)
,@storeCode nvarchar(500)
,@storeName nvarchar(500)
,@country int
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT 
	ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT st.Id
			,st.Name AS [Name]
			,st.Code AS Code
			,st.Address AS [Address]
			,st.Tel
			,st.Phone AS Mobile
			,st.Description AS [Description] 
			,bc.NameNice AS Country
			,st.dCreated AS Created_Date
			,usc.NameUser AS Created_By
			,st.dModified AS Modified_Date
			,usm.NameUser AS Modified_By 
			FROM [dbo].[Store] st (NOLOCK)
			LEFT JOIN [dbo].[Country] bc (NOLOCK) ON st.CountryId = bc.ID
			CROSS APPLY [dbo].[udf_GetUserName](st.iCreated) AS usc
			CROSS APPLY [dbo].[udf_GetUserName](st.iModified) AS usm
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN st.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1 = CASE WHEN @storeCode = '' THEN 1 WHEN st.Code = @storeCode THEN 1 END
	AND 1 = CASE WHEN @storeName = '' THEN 1 WHEN st.Name like '%' + @storeName + '%' THEN 1 END
	AND 1= CASE WHEN @country = 0 THEN 1 WHEN st.CountryId = @country THEN 1 END
	) tblTemp ) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
END
/*
exec dbo.V3_List_Store 1, 100,'','','',0
*/
GO

-- V3_List_Store_Count
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Store_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Store_Count]
GO

CREATE PROCEDURE [dbo].[V3_List_Store_Count]
@page int
,@size int
,@enable char(1)
,@storeCode nvarchar(500)
,@storeName nvarchar(500)
,@country int
AS
BEGIN
	SELECT COUNT(1) AS [Count]
	FROM [dbo].[Store] st (NOLOCK)
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN st.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1 = CASE WHEN @storeCode = '' THEN 1 WHEN st.Code = @storeCode THEN 1 END
	AND 1 = CASE WHEN @storeName = '' THEN 1 WHEN st.Name like '%' + @storeName + '%' THEN 1 END
	AND 1= CASE WHEN @country = 0 THEN 1 WHEN st.CountryId = @country THEN 1 END
END
/*
exec dbo.V3_List_Store_Count 1, 100,'','','',0
*/
GO
--XUser_List
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[XUser_List]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[XUser_List]
GO

CREATE PROCEDURE [dbo].[XUser_List]
@page int
,@size int
,@enable char(1)
,@store int
,@department nvarchar(64)
,@user nvarchar(64)
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY [UserName] ASC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT * FROM [dbo].[XUser]
	WHERE 1 = CASE WHEN @enable='' THEN 1 WHEN [Enable] = CAST(@enable AS INT) THEN 1 END
	AND 1 = CASE WHEN @store = 0 THEN 1 WHEN StoreId = @store THEN 1 END
	AND 1= CASE WHEN @department = '' THEN 1 WHEN Department = @department THEN 1 END
	AND 1= CASE WHEN @user='' THEN 1 WHEN (Username like '%' + @user + '%' OR Email like '%' + @user + '%') THEN 1 END
	) tblTemp) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
END
/*
exec dbo.XUser_List 1, 100,'',0,'',''
*/
GO

-- XUser_List_Count
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[XUser_List_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[XUser_List_Count]
GO

CREATE PROCEDURE [dbo].[XUser_List_Count]
@page int
,@size int
,@enable char(1)
,@store int
,@department nvarchar(64)
,@user nvarchar(64)
AS
BEGIN
	SELECT COUNT(1) AS [Count]
	FROM [dbo].XUser (NOLOCK)
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN [Enable] = CAST(@enable AS INT) THEN 1 END
	AND 1 = CASE WHEN @store = 0 THEN 1 WHEN StoreId = @store THEN 1 END
	AND 1= CASE WHEN @department = '' THEN 1 WHEN Department = @department THEN 1 END
	AND 1= CASE WHEN @user='' THEN 1 WHEN (Username like '%' + @user + '%' OR Email like '%' + @user + '%') THEN 1 END
END
/*
exec dbo.XUser_List_Count 1, 100,'',0,'',''
*/
GO
--V3_Stock_List
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Stock]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Stock]
GO
CREATE PROCEDURE [dbo].[V3_List_Stock]
@page int
,@size int
,@enable char(1)
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@store varchar(50)
,@type int
,@category int
AS
BEGIN
IF (@size = 1000)
	BEGIN
		SELECT stock.Id
		,stock.vStockID AS Stock_Code
		,stock.vStockName AS Stock_Name
		,stock.vBrand AS Brand
		,stock.vAccountCode AS Account_Code
		,stype.TypeName AS [Type]
		,unit.vUnitName AS Unit
		,cate.vCategoryName AS Category
		,storeQuantity.*
		,stock.bWeight AS [Weight]
		,stock.RalNo
		,stock.ColorName AS Color
		,stock.PartNo
		,stock.vRemark AS Remark
		,stock.dCreated AS Created_Date
		,usc.NameUser AS Created_By
		,stock.dModified AS Modified_Date
		,usm.NameUser AS Modified_By
		FROM [dbo].[WAMS_STOCK] stock (NOLOCK)
		LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stock.iType = stype.Id
		LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON stock.bUnitID = unit.bUnitID
		LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) ON stock.bCategoryID = cate.bCategoryID
		LEFT JOIN (SELECT StockID,
			STUFF((SELECT ';' + CAST(Store AS varchar(10))
					FROM [dbo].[Store_Stock] t2 (NOLOCK) 
					WHERE t2.StockID = t1.StockID
					AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
					FOR XML PATH('')),1,1,'') as Stores,
			STUFF((SELECT ';' + CAST(Quantity as varchar(10))
				FROM [dbo].[Store_Stock] t2 (NOLOCK)
				WHERE t2.StockID = t1.StockID
				AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
				FOR XML PATH('')),1,1,'') as Quantity   
		FROM [dbo].[Store_Stock] t1 (NOLOCK)
		GROUP BY StockID) storeQuantity ON storeQuantity.StockID= stock.Id
		CROSS APPLY [dbo].[udf_GetUserName](stock.iCreated) AS usc
		CROSS APPLY [dbo].[udf_GetUserName](stock.iModified) AS usm
		WHERE
		1 = CASE WHEN @enable='' THEN 1 WHEN stock.iEnable = CAST(@enable AS INT) THEN 1 END
		AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
		AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
		AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
		AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	END
	ELSE
	BEGIN 
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT stock.Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,stock.vBrand AS Brand
	,stock.vAccountCode AS Account_Code
	,stype.TypeName AS [Type]
	,unit.vUnitName AS Unit
	,cate.vCategoryName AS Category
	,storeQuantity.*
	,stock.bWeight AS [Weight]
	,stock.RalNo
	,stock.ColorName AS Color
	,stock.PartNo
	,stock.vRemark AS Remark
	,stock.dCreated AS Created_Date
	,usc.NameUser AS Created_By
	,stock.dModified AS Modified_Date
	,usm.NameUser AS Modified_By
	FROM [dbo].[WAMS_STOCK] stock (NOLOCK)
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stock.iType = stype.Id
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON stock.bUnitID = unit.bUnitID
	LEFT JOIN [dbo].[WAMS_CATEGORY] cate (NOLOCK) ON stock.bCategoryID = cate.bCategoryID
	LEFT JOIN (SELECT StockID,
	  STUFF((SELECT ';' + CAST(Store AS varchar(10))
			   FROM [dbo].[Store_Stock] t2 (NOLOCK) 
			   WHERE t2.StockID = t1.StockID
			   AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
			   FOR XML PATH('')),1,1,'') as Stores,
		STUFF((SELECT ';' + CAST(Quantity as varchar(10))
		   FROM [dbo].[Store_Stock] t2 (NOLOCK)
		   WHERE t2.StockID = t1.StockID
		   AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
		   FOR XML PATH('')),1,1,'') as Quantity   
	FROM [dbo].[Store_Stock] t1 (NOLOCK)
	GROUP BY StockID) storeQuantity ON storeQuantity.StockID= stock.Id
	CROSS APPLY [dbo].[udf_GetUserName](stock.iCreated) AS usc
	CROSS APPLY [dbo].[udf_GetUserName](stock.iModified) AS usm
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN stock.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	) tblTemp) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
		END
END
/*
exec dbo.V3_List_Stock 1, 10, 1,'A010001','', '', 0, 0
*/
GO

--V3_List_Stock_Count
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Stock_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Stock_Count]
GO

CREATE PROCEDURE [dbo].[V3_List_Stock_Count]
@page int
,@size int
,@enable char(1)
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@store varchar(50)
,@type int
,@category int
AS
BEGIN
	SELECT COUNT(1) AS [Count] 
	FROM [dbo].[WAMS_STOCK] stock (NOLOCK)
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN stock.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
END
/*
exec dbo.V3_List_Stock_Count 1, 10, 1, '1,2', 0, 0,''
*/
GO

-- V3_Stock_Quantity_Management
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Stock_Quantity_Management]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Stock_Quantity_Management]
GO

CREATE PROCEDURE [dbo].[V3_Stock_Quantity_Management]
@page int
,@size int
,@enable char(1)
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@store varchar(50)
,@type int
,@category int
,@fd varchar(22) 
,@td varchar(22) 
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT 
	stockQty.dDate AS [Date]
	,stockQty.ID AS Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,stockQty.dQuantityCurrent AS Quantity_Current
	,stockQty.dQuantityChange AS Quantity_Change
	,stockQty.dQuantityAfterChange AS Quantity_After_Change
	,stockQty.vStatus AS [Status]
	,CASE 
		 WHEN stockQty.vStatus = 'ASSIGN' THEN stockQty.vStatusID
		 ELSE ''
	  END AS [SIV]
	,CASE 
		 WHEN stockQty.vStatus != 'ASSIGN' THEN stockQty.vStatusID
		 ELSE ''
	  END AS [SRV]
	,CAST(stockQty.vMRF AS NVARCHAR(128)) AS MRF
	,po.vPOID AS PO_Code
	,sup.vSupplierName AS Supplier
	,project.vProjectID AS Project_Code
	,project.vProjectName AS Project_Name
	,stockQty.FromStore
	,stockQty.ToStore
	,stock.RalNo
	,stock.ColorName AS Color
	,stock.PartNo
	,usr.vUsername AS [User]
	,storeQuantity.*
	FROM [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY] stockQty (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = stockQty.vStockID
	LEFT JOIN (SELECT StockID,
	  STUFF((SELECT ';' + CAST(Store AS varchar(10))
			   FROM [dbo].[Store_Stock] t2 (NOLOCK) 
			   WHERE t2.StockID = t1.StockID
			   AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
			   FOR XML PATH('')),1,1,'') as Stores,
		STUFF((SELECT ';' + CAST(Quantity as varchar(10))
		   FROM [dbo].[Store_Stock] t2 (NOLOCK)
		   WHERE t2.StockID = t1.StockID
		   AND 1 = CASE WHEN @store = '' THEN 1 WHEN Store IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
		   FOR XML PATH('')),1,1,'') as Quantity   
	FROM [dbo].[Store_Stock] t1 (NOLOCK)
	GROUP BY StockID) storeQuantity ON storeQuantity.StockID= stock.Id
	LEFT JOIN [dbo].[WAMS_PROJECT] project (NOLOCK) ON project.Id= stockQty.vProjectID
	--LEFT JOIN [dbo].[WAMS_REQUISITION_MASTER] re (NOLOCK) ON re.Id = stockQty.vMRF
	LEFT JOIN [dbo].[WAMS_PURCHASE_ORDER] po (NOLOCK) ON po.Id = stockQty.vPOID
	LEFT JOIN [dbo].[WAMS_SUPPLIER] sup (NOLOCK) ON sup.bSupplierID = stockQty.bSupplierID
	LEFT JOIN [dbo].[WAMS_USER] usr (NOLOCK) ON usr.bUserId = stockQty.bUserId
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN stock.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (stockQty.dDate >= convert(datetime,(@fd + ' 00:00:00')) OR stockQty.dDate = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (stockQty.dDate <= convert(datetime,(@td + ' 23:59:59')) OR stockQty.dDate = NULL) THEN 1 END
	) tblTemp) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
END
GO
/*
exec dbo.V3_Stock_Quantity_Management 1, 10, '1','A060016','', '0', 0, 0, '', ''
*/

-- V3_Stock_Quantity_Management_Count
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Stock_Quantity_Management_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Stock_Quantity_Management_Count]
GO

CREATE PROCEDURE [dbo].[V3_Stock_Quantity_Management_Count]
@page int
,@size int
,@enable char(1)
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@store varchar(50)
,@type int
,@category int
,@fd varchar(22) 
,@td varchar(22) 
AS
BEGIN
	SELECT COUNT(1) AS [Count]
	FROM [dbo].[WAMS_STOCK_MANAGEMENT_QUANTITY] stockQty (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = stockQty.vStockID
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN stock.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (stockQty.dDate >= convert(datetime,(@fd + ' 00:00:00')) OR stockQty.dDate = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (stockQty.dDate <= convert(datetime,(@td + ' 23:59:59')) OR stockQty.dDate = NULL) THEN 1 END
END
GO
/*
exec dbo.V3_Stock_Quantity_Management_Count 1, 10, '1','A060016','', '0', 0, 0, '', ''
*/
GO
-- V3_Project_Custom
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_Project_Custom]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_Project_Custom]
GO

CREATE PROCEDURE [dbo].[V3_Project_Custom]
@id int
AS
BEGIN
SELECT pro.Id
			,pro.vProjectID AS Project_Code
			,pro.vProjectName AS Project_Name
			,CASE pro.StatusId 
			WHEN 1 THEN 'Open' 
			WHEN 2 THEN 'Completed' 
			WHEN 3 THEN 'Cancel' 
			ELSE 'None' END AS [Status]
			,pro.vLocation AS Location
			,pro.vMainContact AS Main_Contact
			,pro.vCompanyName AS Company
			,client.Name AS Client
			,worker.vLastName + ' ' + worker.vFirstName AS Suppervisor
			,store.Name AS Store
			,bc.NameNice AS Country
			,pro.dBeginDate AS Begin_Date
			,pro.dEnd AS End_Date
			,pro.vRemark AS Remark
			,pro.dCreated AS Created_Date
			,usc.NameUser AS Created_By
			,pro.dModified AS Modified_Date
			,usm.NameUser AS Modified_By
			FROM [dbo].[WAMS_PROJECT] pro (NOLOCK)
			LEFT JOIN [dbo].[Project_Client] client (NOLOCK) ON pro.ClientId = client.Id
			LEFT JOIN [dbo].[WAMS_WORKER] worker (NOLOCK) ON pro.Suppervisor = worker.vWorkerID
			LEFT JOIN [dbo].[Country] bc (NOLOCK) ON bc.Id = pro.CountryId
			LEFT JOIN [dbo].[Store] store (NOLOCK) ON store.Id = pro.StoreId
			CROSS APPLY [dbo].[udf_GetUserName](pro.iCreated) AS usc
			CROSS APPLY [dbo].[udf_GetUserName](pro.iModified) AS usm
			WHERE pro.Id = @id
END
/*
exec dbo.V3_Project_Custom 1
*/
GO

--V3_Project_GetList
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Project]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Project]
GO

CREATE PROCEDURE [dbo].[V3_List_Project]
@page int
,@size int
,@projectCode nvarchar(64)
,@projectName nvarchar(64)
,@country int
,@status int
,@client int
,@fd varchar(22) 
,@td varchar(22)
,@enable bit
AS
BEGIN
	IF (@size = 1000)
		BEGIN
			SELECT pro.Id
			,pro.vProjectID AS Project_Code
			,pro.vProjectName AS Project_Name
			,CASE pro.StatusId 
			WHEN 1 THEN 'Open' 
			WHEN 2 THEN 'Completed' 
			WHEN 3 THEN 'Cancel' 
			ELSE 'None' END AS [Status]
			,pro.vLocation AS Location
			,pro.vMainContact AS Main_Contact
			,pro.vCompanyName AS Company
			,client.Name AS Client
			,worker.vLastName + ' ' + worker.vFirstName AS Suppervisor
			,store.Name AS Store
			,bc.NameNice AS Country
			,pro.dBeginDate AS Begin_Date
			,pro.dEnd AS End_Date
			,pro.vRemark AS Remark
			,pro.dCreated AS Created_Date
			,usc.NameUser AS Created_By
			,pro.dModified AS Modified_Date
			,usm.NameUser AS Modified_By
			FROM [dbo].[WAMS_PROJECT] pro (NOLOCK)
			LEFT JOIN [dbo].[Project_Client] client (NOLOCK) ON pro.ClientId = client.Id
			LEFT JOIN [dbo].[WAMS_WORKER] worker (NOLOCK) ON pro.Suppervisor = worker.vWorkerID
			LEFT JOIN [dbo].[Country] bc (NOLOCK) ON bc.Id = pro.CountryId
			LEFT JOIN [dbo].[Store] store (NOLOCK) ON store.Id = pro.StoreId
			CROSS APPLY [dbo].[udf_GetUserName](pro.iCreated) AS usc
			CROSS APPLY [dbo].[udf_GetUserName](pro.iModified) AS usm
			WHERE pro.iEnable = @enable
			AND 
			1 = CASE WHEN @projectCode = '' THEN 1 WHEN vProjectID like '%' + @projectCode + '%' THEN 1 END
			AND 1 = CASE WHEN @projectName = '' THEN 1 WHEN vProjectName like '%' + @projectName + '%' THEN 1 END
			AND 1 = CASE WHEN @country = 0 THEN 1 WHEN pro.CountryId = @country THEN 1 END
			AND 1= CASE WHEN @status=0 THEN 1 WHEN pro.StatusId = @status THEN 1 END
			AND 1= CASE WHEN @client=0 THEN 1 WHEN pro.ClientId=@client THEN 1 END
			AND 1 = CASE WHEN @fd='' THEN 1 WHEN (pro.dBeginDate >= convert(datetime,(@fd + ' 00:00:00')) OR pro.dBeginDate = NULL) THEN 1 END
			AND 1 = CASE WHEN @td='' THEN 1 WHEN (pro.dBeginDate <= convert(datetime,(@td + ' 23:59:59')) OR pro.dBeginDate = NULL) THEN 1 END
		END
	ELSE
		BEGIN
			DECLARE @fromRow int
			DECLARE @toRow int

			SET @fromRow = (@page - 1) * @size
			SET @toRow = (@page * @size) + 1

			SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Project_Code ASC) AS [No]
			,tblTemp.* 
			FROM
			(SELECT pro.Id
			,pro.vProjectID AS Project_Code
			,pro.vProjectName AS Project_Name
			,CASE pro.StatusId 
			WHEN 1 THEN 'Open' 
			WHEN 2 THEN 'Completed' 
			WHEN 3 THEN 'Cancel' 
			ELSE 'None' END AS [Status]
			,pro.vLocation AS Location
			,pro.vMainContact AS Main_Contact
			,pro.vCompanyName AS Company
			,client.Name AS Client
			,worker.vLastName + ' ' + worker.vFirstName AS Suppervisor
			,store.Name AS Store
			,bc.NameNice AS Country
			,pro.dBeginDate AS Begin_Date
			,pro.dEnd AS End_Date
			,pro.vRemark AS Remark
			,pro.dCreated AS Created_Date
			,usc.NameUser AS Created_By
			,pro.dModified AS Modified_Date
			,usm.NameUser AS Modified_By
			FROM [dbo].[WAMS_PROJECT] pro (NOLOCK)
			LEFT JOIN [dbo].[Project_Client] client (NOLOCK) ON pro.ClientId = client.Id
			LEFT JOIN [dbo].[WAMS_WORKER] worker (NOLOCK) ON pro.Suppervisor = worker.vWorkerID
			LEFT JOIN [dbo].[Country] bc (NOLOCK) ON bc.Id = pro.CountryId
			LEFT JOIN [dbo].[Store] store (NOLOCK) ON store.Id = pro.StoreId
			CROSS APPLY [dbo].[udf_GetUserName](pro.iCreated) AS usc
			CROSS APPLY [dbo].[udf_GetUserName](pro.iModified) AS usm
			WHERE pro.iEnable = @enable
			AND 
			1 = CASE WHEN @projectCode = '' THEN 1 WHEN vProjectID like '%' + @projectCode + '%' THEN 1 END
			AND 1 = CASE WHEN @projectName = '' THEN 1 WHEN vProjectName like '%' + @projectName + '%' THEN 1 END
			AND 1 = CASE WHEN @country = 0 THEN 1 WHEN pro.CountryId = @country THEN 1 END
			AND 1= CASE WHEN @status=0 THEN 1 WHEN pro.StatusId = @status THEN 1 END
			AND 1= CASE WHEN @client=0 THEN 1 WHEN pro.ClientId=@client THEN 1 END
			AND 1 = CASE WHEN @fd='' THEN 1 WHEN (pro.dBeginDate >= convert(datetime,(@fd + ' 00:00:00')) OR pro.dBeginDate = NULL) THEN 1 END
			AND 1 = CASE WHEN @td='' THEN 1 WHEN (pro.dBeginDate <= convert(datetime,(@td + ' 23:59:59')) OR pro.dBeginDate = NULL) THEN 1 END
			) tblTemp) tempTable
			WHERE [No] > @fromRow AND [No] < @toRow
		END
END
/*
exec dbo.V3_List_Project 1, 1000, '','', 0, '', 0,'',''
*/
GO
-- V3_List_Project_Count
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Project_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Project_Count]
GO

CREATE PROCEDURE [dbo].[V3_List_Project_Count]
@page int
,@size int
,@projectCode nvarchar(64)
,@projectName nvarchar(64)
,@country int
,@status int
,@client int
,@fd varchar(22) 
,@td varchar(22)
,@enable bit
AS
BEGIN
	SELECT COUNT(1) AS [Count] 
	FROM [dbo].[WAMS_PROJECT] (NOLOCK)
	WHERE iEnable = @enable
	AND 
	1 = CASE WHEN @projectCode = '' THEN 1 WHEN vProjectID like '%' + @projectCode + '%' THEN 1 END
	AND 1 = CASE WHEN @projectName = '' THEN 1 WHEN vProjectName like '%' + @projectName + '%' THEN 1 END
	AND 1 = CASE WHEN @country = 0 THEN 1 WHEN CountryId = @country THEN 1 END
	AND 1= CASE WHEN @status=0 THEN 1 WHEN StatusId = @status THEN 1 END
	AND 1= CASE WHEN @client=0 THEN 1 WHEN ClientId= @client THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (dBeginDate >= convert(datetime,(@fd + ' 00:00:00')) OR dBeginDate = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (dBeginDate <= convert(datetime,(@td + ' 23:59:59')) OR dBeginDate = NULL) THEN 1 END
END
/*
exec dbo.V3_List_Project_Count 1, 1000, '','', 0, '', 0,'',''
*/
GO
--V3_List_AssignStock
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_AssignStock]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_AssignStock]
GO

CREATE PROCEDURE [dbo].[V3_List_AssignStock]
@page int
,@size int
,@fromStore int
,@pro int
,@stype int
,@stock nvarchar(2000)
,@SIV nvarchar(20)
,@accCheck varchar(1)
,@fd varchar(22) 
,@td varchar(22)
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT assign.bAssignningStockID AS Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,assign.bQuantity AS Quantity
	,assign.SIV
	,assign.vMRF AS MRF
	,fstore.name AS From_Store
	,project.vProjectID AS Project_Code
	,project.vProjectName AS Project_Name
	,tstore.name AS To_Store
	,stock.RalNo
	,stock.ColorName AS Color
	,stockType.TypeName AS [Type_Name]
	,unit.vUnitName AS Unit
	,'' AS Worker
	,0.00 AS Return_Qty
	,assign.AccCheck AS Accounting
	,assign.AccdCreated AS Accounting_Date
	,usckc.NameUser AS Checked_By
	,assign.dCreated AS Created_Date
	,usc.NameUser AS Created_By
	,assign.dModified AS Modified_Date
	,usm.NameUser AS Modified_By
	FROM [dbo].[WAMS_ASSIGNNING_STOCKS] assign (NOLOCK)
	LEFT JOIN [dbo].[WAMS_PROJECT] project (NOLOCK) ON project.Id= assign.vProjectID
	LEFT JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = assign.vStockID
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stockType (NOLOCK) ON stockType.Id= stock.iType
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	CROSS APPLY [dbo].[udf_GetUserName](assign.iCreated) AS usc
	CROSS APPLY [dbo].[udf_GetUserName](assign.iModified) AS usm
	CROSS APPLY [dbo].[udf_GetUserName](assign.AcciCreated) AS usckc
	CROSS APPLY [dbo].[udf_GetStoreNameById](assign.FromStore) AS fstore
	CROSS APPLY [dbo].[udf_GetStoreNameById](assign.ToStore) AS tstore
	WHERE
	1 = CASE WHEN @fromStore = 0 THEN 1 WHEN assign.FromStore = @fromStore THEN 1 END
	AND 1 = CASE WHEN @pro = 0 THEN 1 WHEN assign.vProjectID = @pro THEN 1 END
	AND 1= CASE WHEN @stype=0 THEN 1 WHEN stock.iType = @stype THEN 1 END
	AND 1= CASE WHEN @stock='' THEN 1 WHEN (stock.vStockID = @stock OR stock.vStockName like '%' + @stock + '%') THEN 1 END
	AND 1= CASE WHEN @SIV='' THEN 1 WHEN assign.SIV = @SIV THEN 1 END
	AND 1= CASE WHEN @accCheck='' THEN 1 WHEN assign.AccCheck = CAST(@accCheck AS INT) THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (assign.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR assign.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (assign.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR assign.dCreated = NULL) THEN 1 END
	) tblTemp) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
END
/*
exec dbo.V3_List_AssignStock 1, 1000000, 0, 0, 0, '','','','',''
*/
GO
-- V3_List_AssignStock_Count
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_AssignStock_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_AssignStock_Count]
GO
CREATE PROCEDURE [dbo].[V3_List_AssignStock_Count]
@page int
,@size int
,@fromStore int
,@pro int
,@stype int
,@stock nvarchar(2000)
,@SIV nvarchar(20)
,@accCheck varchar(1)
,@fd varchar(22) 
,@td varchar(22)
AS
BEGIN
	SELECT COUNT(1) AS [Count]
	FROM [dbo].[WAMS_ASSIGNNING_STOCKS] assign (NOLOCK)
	LEFT JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = assign.vStockID
	WHERE
	1 = CASE WHEN @fromStore = 0 THEN 1 WHEN assign.FromStore = @fromStore THEN 1 END
	AND 1 = CASE WHEN @pro = 0 THEN 1 WHEN assign.vProjectID = @pro THEN 1 END
	AND 1= CASE WHEN @stype=0 THEN 1 WHEN stock.iType = @stype THEN 1 END
	AND 1= CASE WHEN @stock='' THEN 1 WHEN (stock.vStockID = @stock OR stock.vStockName like '%' + @stock + '%') THEN 1 END
	AND 1= CASE WHEN @SIV='' THEN 1 WHEN assign.SIV = @SIV THEN 1 END
	AND 1= CASE WHEN @accCheck='' THEN 1 WHEN assign.AccCheck = CAST(@accCheck AS INT) THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (assign.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR assign.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (assign.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR assign.dCreated = NULL) THEN 1 END
END
/*
exec dbo.V3_List_AssignStock_Count 1, 1000000, 0, 0, 0, '','','','',''
*/
GO
--V3_ReturnStock_GetList
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_ReturnStock_GetList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_ReturnStock_GetList]
GO

CREATE PROCEDURE [dbo].[V3_ReturnStock_GetList]
@page int
,@size int
,@fromStore int
,@pro int
,@stype int
,@stock nvarchar(2000) 
,@sRV nvarchar(20)
,@accCheck varchar(1)
,@fd varchar(22) 
,@td varchar(22) 
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT retur.bReturnListID AS Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,retur.bQuantity AS Quantity
	,retur.SRV
	,retur.vCondition AS Condition
	,project.vProjectID AS Project_Code
	,project.vProjectName AS Project_Name
	,fstore.name AS From_Store
	,tstore.name AS To_Store
	,stock.RalNo
	,stock.ColorName AS Color
	,stockType.TypeName AS [Type_Name]
	,unit.vUnitName AS Unit
	,'' AS Worker
	,retur.AccCheck AS Accounting
	,retur.AccdCreated AS Accounting_Date
	,usckc.NameUser AS Checked_By
	,retur.dCreated AS Created_Date
	,usc.NameUser AS Created_By
	,retur.dModified AS Modified_Date
	,usm.NameUser AS Modified_By
	FROM [dbo].[WAMS_RETURN_LIST] retur (NOLOCK)
	LEFT JOIN [dbo].[WAMS_PROJECT] project (NOLOCK) ON project.Id= retur.vProjectID
	LEFT JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = retur.vStockID
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stockType (NOLOCK) ON stockType.Id= stock.iType
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	CROSS APPLY [dbo].[udf_GetUserName](retur.iCreated) AS usc
	CROSS APPLY [dbo].[udf_GetUserName](retur.iModified) AS usm
	CROSS APPLY [dbo].[udf_GetUserName](retur.AcciCreated) AS usckc
	CROSS APPLY [dbo].[udf_GetStoreNameById](retur.FromStore) AS fstore
	CROSS APPLY [dbo].[udf_GetStoreNameById](retur.ToStore) AS tstore
	WHERE
	1 = CASE WHEN @fromStore = 0 THEN 1 WHEN retur.FromStore = @fromStore THEN 1 END
	AND 1 = CASE WHEN @pro = 0 THEN 1 WHEN retur.vProjectID = @pro THEN 1 END
	AND 1= CASE WHEN @stype=0 THEN 1 WHEN stock.iType = @stype THEN 1 END
	AND 1= CASE WHEN @stock='' THEN 1 WHEN (stock.vStockID = @stock OR stock.vStockName like '%' + @stock + '%') THEN 1 END
	AND 1= CASE WHEN @sRV='' THEN 1 WHEN retur.SRV = @sRV THEN 1 END
	AND 1= CASE WHEN @accCheck='' THEN 1 WHEN retur.AccCheck = CAST(@accCheck AS INT) THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (retur.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR retur.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (retur.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR retur.dCreated = NULL) THEN 1 END) tblTemp) tempReturn
	WHERE [No] > @fromRow AND [No] < @toRow
END
/*
exec dbo.V3_List_ReturnStock 1, 1000, 0, 0, 0, '','', '', '',''
*/
GO
-- V3_List_ReturnStock_Count
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_ReturnStock_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_ReturnStock_Count]
GO
CREATE PROCEDURE [dbo].[V3_List_ReturnStock_Count]
@page int
,@size int
,@fromStore int
,@pro int
,@stype int
,@stock nvarchar(2000) 
,@sRV nvarchar(20)
,@accCheck varchar(1)
,@fd varchar(22) 
,@td varchar(22) 
AS
BEGIN
	SELECT COUNT(1) AS [Count] 
	FROM [dbo].[WAMS_RETURN_LIST] retur (NOLOCK)
	LEFT JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = retur.vStockID
	WHERE
	1 = CASE WHEN @fromStore = 0 THEN 1 WHEN retur.FromStore = @fromStore THEN 1 END
	AND 1 = CASE WHEN @pro = 0 THEN 1 WHEN retur.vProjectID = @pro THEN 1 END
	AND 1= CASE WHEN @stype=0 THEN 1 WHEN stock.iType = @stype THEN 1 END
	AND 1= CASE WHEN @stock='' THEN 1 WHEN (stock.vStockID = @stock OR stock.vStockName like '%' + @stock + '%') THEN 1 END
	AND 1= CASE WHEN @sRV='' THEN 1 WHEN retur.SRV = @sRV THEN 1 END
	AND 1= CASE WHEN @accCheck='' THEN 1 WHEN retur.AccCheck = CAST(@accCheck AS INT) THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (retur.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR retur.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (retur.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR retur.dCreated = NULL) THEN 1 END
END
/*
exec dbo.V3_List_ReturnStock_Count 1, 1000, 0, 0, 0, '','', '', '',''
*/
GO
-- GET LIST ITEM STOCK ASSIGNED
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetAssignedStockBySIV]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetAssignedStockBySIV]
GO

CREATE PROCEDURE [dbo].[V3_GetAssignedStockBySIV]
	@SIV nvarchar(20)
AS
BEGIN
	SELECT assign.*
	,project.vProjectID AS Project_Code
	,project.vProjectName AS Project_Name
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,stock.RalNo
	,stock.ColorName AS Color
	,stock.iType
	,stockType.TypeName AS Type_Name
	,unit.vUnitName AS Unit
	,'' AS Worker
	,0.00 AS returnQty
	,usc.NameUser as Created_By
	,usm.NameUser as Modified_By
	FROM [dbo].[WAMS_ASSIGNNING_STOCKS] assign (NOLOCK)
	LEFT JOIN [dbo].[WAMS_PROJECT] project (NOLOCK) ON project.Id= assign.vProjectID
	LEFT JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = assign.vStockID
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stockType (NOLOCK) ON stockType.Id= stock.iType
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	CROSS APPLY [dbo].[udf_GetUserName](assign.iCreated) AS usc
	CROSS APPLY [dbo].[udf_GetUserName](assign.iModified) AS usm
	WHERE
	1 = CASE WHEN @SIV = '' THEN 1 WHEN assign.SIV = @SIV THEN 1 END
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_GetReturnedStockBySRV]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_GetReturnedStockBySRV]
GO

CREATE PROCEDURE [dbo].[V3_GetReturnedStockBySRV]
@sRV nvarchar(20)
AS
BEGIN
	SELECT retur.*
	,project.vProjectID AS projectCode
	,project.vProjectName
	,stock.vStockID AS stockCode
	,stock.vStockName
	,stock.RalNo
	,stock.ColorName
	,stock.iType
	,stockType.TypeName AS stockTypeName
	,unit.vUnitName AS stockUnitName
	,'' AS Worker
	,0.00 AS returnQty
	,usc.NameUser as Created_By
	,usm.NameUser as Modified_By
	FROM [dbo].[WAMS_RETURN_LIST] retur (NOLOCK)
	LEFT JOIN [dbo].[WAMS_PROJECT] project (NOLOCK) ON project.Id= retur.vProjectID
	LEFT JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = retur.vStockID
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stockType (NOLOCK) ON stockType.Id= stock.iType
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	CROSS APPLY [dbo].[udf_GetUserName](retur.iCreated) AS usc
	CROSS APPLY [dbo].[udf_GetUserName](retur.iModified) AS usm
	WHERE 1= CASE WHEN @sRV='' THEN 1 WHEN retur.SRV = @sRV THEN 1 END
END

-- V3_List_PO
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_PO]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_PO]
GO
CREATE PROCEDURE [dbo].[V3_List_PO]
@page int
,@size int
,@store int
,@poType int
,@po nvarchar(16)
,@status nvarchar(16)
,@mrf nvarchar(16)
,@supplier int
,@project int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@fd varchar(22) 
,@td varchar(22) 
,@enable char(1)
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY [Year] DESC, [Month] DESC, [PE] DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT po.Id
	,po.vPOID AS PE
	,po.dPODate AS PE_Date
	,po.fPOTotal AS [Total]
	,po.vRemark AS [Remark]
	,po.vPOStatus AS [Status]
	,po.vLocation AS Location
	,po.dDeliverDate AS [Deliver_Date]
	,SUBSTRING(po.vPOID, 5, 2) AS [Year]
    ,CASE substring(po.vPOID, 0, 4) 
      WHEN 'JAN' THEN 1 
      WHEN 'FEB' THEN 2 
      WHEN 'MAR' THEN 3 
      WHEN 'APR' THEN 4 
      WHEN 'MAY' THEN 5 
      WHEN 'JUN' THEN 6 
      WHEN 'JUL' THEN 7 
      WHEN 'AUG' THEN 8 
      WHEN 'SEP' THEN 9 
      WHEN 'OCT' THEN 10
      WHEN 'NOV' THEN 11  
      WHEN 'DEC' THEN 12 END AS [Month] 
      ,potype.vPOTypeName AS [Type] 
      ,project.vProjectID AS Project_Code
      ,project.vProjectName AS Project_Name
      ,supp.vSupplierName AS Supplier
      ,curr.vCurrencyName AS Currency
      ,store.Name Store
      ,pay.PaymentName AS Payment_Term
      ,po.dCreated AS Created_Date
	  ,usc.NameUser AS Created_By
	  ,po.dModified AS Modified_Date
	  ,usm.NameUser AS Modified_By
	FROM [dbo].[WAMS_PURCHASE_ORDER] po (NOLOCK) 
	LEFT JOIN [dbo].[WAMS_PROJECT] project (NOLOCK) ON po.vProjectID = project.Id
	LEFT JOIN [dbo].[WAMS_PO_TYPE] potype (NOLOCK) ON potype.bPOTypeID = po.bPOTypeID
	LEFT JOIN [dbo].[PaymentTerm] pay (NOLOCK) ON pay.Id = po.iPayment
	LEFT JOIN [dbo].[WAMS_CURRENCY_TYPE] curr (NOLOCK) ON curr.bCurrencyTypeID = po.bCurrencyTypeID
	LEFT JOIN [dbo].[WAMS_SUPPLIER] supp (NOLOCK) ON supp.bSupplierID = po.bSupplierID
	LEFT JOIN [dbo].[Store] store (NOLOCK) ON store.Id = po.iStore
	CROSS APPLY [dbo].[udf_GetUserName](po.iCreated) AS usc
	CROSS APPLY [dbo].[udf_GetUserName](po.iModified) AS usm
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN po.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1 = CASE WHEN @store = 0 THEN 1 WHEN po.iStore = @store THEN 1 END
	AND 1 = CASE WHEN @poType = 0 THEN 1 WHEN po.bPOTypeID = @poType THEN 1 END
	AND 1= CASE WHEN @po='' THEN 1 WHEN po.vPOID = @po THEN 1 END
	AND 1= CASE WHEN @status='All' THEN 1 WHEN po.vPOStatus = @status THEN 1 END
	AND 1= CASE WHEN @mrf='' THEN 1 
	WHEN po.Id IN (SELECT DISTINCT vPOID FROM dbo.WAMS_PO_DETAILS pod (NOLOCK)
					INNER JOIN dbo.WAMS_REQUISITION_MASTER requi (NOLOCK) ON requi.Id = pod.vMRF
					WHERE requi.vMRF like '%' + @mrf + '%') THEN 1 END
	AND 1= CASE WHEN @supplier=0 THEN 1 WHEN po.bSupplierID = @supplier THEN 1 END
	AND 1= CASE WHEN @project=0 THEN 1 WHEN po.vProjectID = @project THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 
	WHEN po.Id IN (SELECT DISTINCT vPOID FROM dbo.WAMS_PO_DETAILS pod (NOLOCK)
					INNER JOIN dbo.WAMS_STOCK stock (NOLOCK) ON stock.Id = pod.vProductID
					WHERE stock.vStockID like '%' + @stockCode + '%') THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 
	WHEN po.Id IN (SELECT DISTINCT vPOID FROM dbo.WAMS_PO_DETAILS pod (NOLOCK)
					INNER JOIN dbo.WAMS_STOCK stock (NOLOCK) ON stock.Id = pod.vProductID
					WHERE stock.vStockName like '%' + @stockName + '%') THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (po.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR po.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (po.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR po.dCreated = NULL) THEN 1 END) tblTemp) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow
END
/*
exec [dbo].[V3_List_PO] 1, 10, 0, 0,'','','1', 0,0,'','','','',''
*/
-- V3_List_PO_Count
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_PO_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_PO_Count]
GO
CREATE PROCEDURE [dbo].[V3_List_PO_Count]
@page int
,@size int
,@store int
,@poType int
,@po nvarchar(16)
,@status nvarchar(16)
,@mrf nvarchar(16)
,@supplier int
,@project int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@fd varchar(22) 
,@td varchar(22) 
,@enable char(1)
AS
BEGIN
	SELECT COUNT(1) AS [Count]
	FROM [dbo].[WAMS_PURCHASE_ORDER] (NOLOCK)
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1 = CASE WHEN @store = 0 THEN 1 WHEN iStore = @store THEN 1 END
	AND 1 = CASE WHEN @poType = 0 THEN 1 WHEN bPOTypeID = @poType THEN 1 END
	AND 1= CASE WHEN @po='' THEN 1 WHEN vPOID = @po THEN 1 END
	AND 1= CASE WHEN @status='All' THEN 1 WHEN vPOStatus = @status THEN 1 END
	AND 1= CASE WHEN @mrf='' THEN 1 
	WHEN Id IN (SELECT DISTINCT vPOID FROM dbo.WAMS_PO_DETAILS pod (NOLOCK)
					INNER JOIN dbo.WAMS_REQUISITION_MASTER requi (NOLOCK) ON requi.Id = pod.vMRF
					WHERE requi.vMRF like '%' + @mrf + '%') THEN 1 END
	AND 1= CASE WHEN @supplier=0 THEN 1 WHEN bSupplierID = @supplier THEN 1 END
	AND 1= CASE WHEN @project=0 THEN 1 WHEN vProjectID = @project THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 
	WHEN Id IN (SELECT DISTINCT vPOID FROM dbo.WAMS_PO_DETAILS pod (NOLOCK)
					INNER JOIN dbo.WAMS_STOCK stock (NOLOCK) ON stock.Id = pod.vProductID
					WHERE stock.vStockID like '%' + @stockCode + '%') THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 
	WHEN Id IN (SELECT DISTINCT vPOID FROM dbo.WAMS_PO_DETAILS pod (NOLOCK)
					INNER JOIN dbo.WAMS_STOCK stock (NOLOCK) ON stock.Id = pod.vProductID
					WHERE stock.vStockName like '%' + @stockName + '%') THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (dCreated <= convert(datetime,(@td + ' 23:59:59')) OR dCreated = NULL) THEN 1 END
END
GO
/*
exec [dbo].[V3_List_PO_Count] 1, 10, 0, 0,'','','', 0,0,'','','','',''
*/
-- V3_PE_Information
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_PE_Information]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_PE_Information]
GO
CREATE PROCEDURE [dbo].[V3_PE_Information]
@id int
AS
BEGIN
	SELECT Id
	,vPOID AS PE
	,dPODate AS PE_Date
	,fPOTotal AS [Total]
	,vRemark AS [Remark]
	,vPOStatus AS [Status]
	,vLocation AS Location
	,dDeliverDate AS [Deliver_Date]
	,vProjectID AS Project_Id
    ,bSupplierID AS Supplier_Id
	,bPOTypeID AS [Type_Id]
	,po.bCurrencyTypeID AS Currency_Id
	,currency.vCurrencyName AS Currency
	,vFromCC AS CC
	,vLocation AS Delivery_Place
	,iPayment AS Payment_Id
	,iStore AS Store_Id
	,iCreated AS Created_Id
	,dCreated AS Created_Date
	,[Timestamp]
    FROM [dbo].[WAMS_PURCHASE_ORDER] po (NOLOCK) 
    LEFT JOIN dbo.WAMS_CURRENCY_TYPE currency ON currency.bCurrencyTypeID = po.bCurrencyTypeID
	WHERE Id = @id
END
GO
-- exec [dbo].[V3_PE_Information] 10
GO
-- V3_PeDetail
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_PeDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_PeDetail]
GO

CREATE PROCEDURE [dbo].[V3_PeDetail]
	@id int
	,@enable char(1)
AS
BEGIN
	SELECT poDetail.ID AS Id
	,poDetail.iDiscount AS Discount
	,poDetail.fQuantity AS Quantity
	,poDetail.fVAT AS VAT
	,poDetail.fItemTotal AS Item_Total
	,poDetail.dDeliveryDate AS Delivery_Date
	,poDetail.vRemark AS Remark
	,poDetail.vPODetailStatus AS [Status]
	,po.vPOID AS PE
	,stock.Id AS Stock_Id
	,stock.vStockID AS Stock_Code
	,stock.vStockName AS Stock_Name
	,unit.vUnitName AS Unit
	,stype.TypeName AS [Type]
	,poDetail.vMRF AS MRF
	,poDetail.fUnitPrice [Price]
	,poDetail.dCreated AS Created_Date
  ,usc.NameUser AS Created_By
  ,poDetail.dModified AS Modified_Date
  ,usm.NameUser AS Modified_By
  ,poDetail.iCreated AS Created_Id
  ,poDetail.PriceId AS Price_Id
	FROM [dbo].[WAMS_PO_DETAILS] poDetail (NOLOCK)
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id= poDetail.vProductID
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stype.Id = stock.iType
	INNER JOIN [dbo].[WAMS_PURCHASE_ORDER] po (NOLOCK) ON po.Id = poDetail.vPOID
	--LEFT JOIN [dbo].[Product_Price] price (NOLOCK) ON price.Id = poDetail.PriceId
	CROSS APPLY [dbo].[udf_GetUserName](poDetail.iCreated) AS usc
	CROSS APPLY [dbo].[udf_GetUserName](poDetail.iModified) AS usm
	WHERE 1 = CASE WHEN @enable='' THEN 1 WHEN poDetail.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1 = CASE WHEN @id = 0 THEN 1 WHEN po.Id = @id THEN 1 END
END
GO
--exec [dbo].[V3_PeDetail] 22292,''

-- V3_List_Pe_Detail
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Pe_Detail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Pe_Detail]
GO

CREATE PROCEDURE [dbo].[V3_List_Pe_Detail]
	@page int
	,@size int
	,@store int
	,@poType int
	,@po nvarchar(16)
	,@status nvarchar(16)
	,@mrf nvarchar(16)
	,@supplier int
	,@project int
	,@stockCode nvarchar(200)
	,@stockName nvarchar(200)
	,@fd varchar(22) 
	,@td varchar(22) 
	,@enable char(1)
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1
	SELECT poDetail.ID AS Id
		,poDetail.iDiscount AS Discount
		,poDetail.fQuantity AS Quantity
		,poDetail.fVAT AS VAT
		,poDetail.fItemTotal AS Item_Total
		,poDetail.dDeliveryDate AS Delivery_Date
		,poDetail.vRemark AS Remark
		,poDetail.vPODetailStatus AS [Status]
		,purchaseOrder.PE
		,stock.Id AS Stock_Id
		,stock.vStockID AS Stock_Code
		,stock.vStockName AS Stock_Name
		,unit.vUnitName AS Unit
		,stype.TypeName AS [Type]
		,req.Id AS MRF_Id
		,req.vMRF AS MRF
		,poDetail.fUnitPrice [Price]
		,poDetail.dCreated AS Created_Date
	  ,usc.NameUser AS Created_By
	  ,poDetail.dModified AS Modified_Date
	  ,usm.NameUser AS Modified_By
	  ,poDetail.iCreated AS Created_Id
	  ,poDetail.PriceId AS Price_Id
	FROM [dbo].[WAMS_PO_DETAILS] poDetail (NOLOCK)
	INNER JOIN 
	(SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY [Year] DESC, [Month] DESC, [PE] DESC) AS [No]
	,tblTemp.* 
	FROM
	(SELECT po.Id, po.vPOID AS PE, SUBSTRING(po.vPOID, 5, 2) AS [Year]
    ,CASE substring(po.vPOID, 0, 4) 
      WHEN 'JAN' THEN 1 
      WHEN 'FEB' THEN 2 
      WHEN 'MAR' THEN 3 
      WHEN 'APR' THEN 4 
      WHEN 'MAY' THEN 5 
      WHEN 'JUN' THEN 6 
      WHEN 'JUL' THEN 7 
      WHEN 'AUG' THEN 8 
      WHEN 'SEP' THEN 9 
      WHEN 'OCT' THEN 10
      WHEN 'NOV' THEN 11  
      WHEN 'DEC' THEN 12 END AS [Month] FROM dbo.WAMS_PURCHASE_ORDER po
	WHERE
	1 = CASE WHEN @enable='' THEN 1 WHEN po.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1 = CASE WHEN @store = 0 THEN 1 WHEN po.iStore = @store THEN 1 END
	AND 1 = CASE WHEN @poType = 0 THEN 1 WHEN po.bPOTypeID = @poType THEN 1 END
	AND 1= CASE WHEN @po='' THEN 1 WHEN po.vPOID = @po THEN 1 END
	AND 1= CASE WHEN @status='' THEN 1 WHEN po.vPOStatus = @status THEN 1 END
	AND 1= CASE WHEN @mrf='' THEN 1 
	WHEN po.Id IN (SELECT DISTINCT vPOID FROM dbo.WAMS_PO_DETAILS pod (NOLOCK)
					INNER JOIN dbo.WAMS_REQUISITION_MASTER requi (NOLOCK) ON requi.Id = pod.vMRF
					WHERE requi.vMRF like '%' + @mrf + '%') THEN 1 END
	AND 1= CASE WHEN @supplier=0 THEN 1 WHEN po.bSupplierID = @supplier THEN 1 END
	AND 1= CASE WHEN @project=0 THEN 1 WHEN po.vProjectID = @project THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 
	WHEN po.Id IN (SELECT DISTINCT vPOID FROM dbo.WAMS_PO_DETAILS pod (NOLOCK)
					INNER JOIN dbo.WAMS_STOCK stock (NOLOCK) ON stock.Id = pod.vProductID
					WHERE stock.vStockID like '%' + @stockCode + '%') THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 
	WHEN po.Id IN (SELECT DISTINCT vPOID FROM dbo.WAMS_PO_DETAILS pod (NOLOCK)
					INNER JOIN dbo.WAMS_STOCK stock (NOLOCK) ON stock.Id = pod.vProductID
					WHERE stock.vStockName like '%' + @stockName + '%') THEN 1 END
	AND 1 = CASE WHEN @fd='' THEN 1 WHEN (po.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR po.dCreated = NULL) THEN 1 END
	AND 1 = CASE WHEN @td='' THEN 1 WHEN (po.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR po.dCreated = NULL) THEN 1 END) tblTemp) tempTable
	WHERE [No] > @fromRow AND [No] < @toRow) purchaseOrder ON purchaseOrder.Id = poDetail.vPOID
	INNER JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id= poDetail.vProductID
	LEFT JOIN [dbo].[WAMS_UNIT] unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	LEFT JOIN [dbo].[WAMS_STOCK_TYPE] stype (NOLOCK) ON stype.Id = stock.iType
	LEFT JOIN [dbo].[WAMS_REQUISITION_MASTER] req (NOLOCK) ON req.Id = poDetail.vMRF
	--LEFT JOIN [dbo].[Product_Price] price (NOLOCK) ON price.Id = poDetail.PriceId
	CROSS APPLY [dbo].[udf_GetUserName](poDetail.iCreated) AS usc
	CROSS APPLY [dbo].[udf_GetUserName](poDetail.iModified) AS usm
	ORDER BY purchaseOrder.Year ASC, purchaseOrder.Month ASC, purchaseOrder.PE ASC
END
GO
/*
exec [dbo].[V3_List_PO] 1, 10, 0, 0,'','','', 0,0,'','','','',''
exec [dbo].[V3_List_Pe_Detail] 1, 10, 0, 0,'','','', 0,0,'','','','',''
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Accounting]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Accounting]
GO

CREATE PROCEDURE [dbo].[V3_List_Accounting]
@page int
,@size int
,@status int
,@statusCheck int
,@sIRV nvarchar(20)
,@stock nvarchar(2000)
,@fromStore int
,@toStore int
,@project int
,@po nvarchar(16)
,@supplier int
,@fd varchar(22) 
,@td varchar(22) 
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	-- STOCK OUT
	IF (@status = 1)
	BEGIN
		SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
		,tblTemp.* 
		FROM
		(SELECT 
			so.bAssignningStockID AS Id
			,so.vStockID AS StockId
			,stock.vStockID AS stockCode
			,stock.vStockName
			,so.bQuantity AS Qty
			,0.00 AS QtyPending
			,0.00 AS QtyPO
			,'OUT' AS SIRVFag
			,dbo.ConvertAccCheck(so.AccCheck) AS AccStatus
			,so.SIV AS SIRV
			,so.FromStore AS StoreFromId
			,storef.name AS StoreFromName
			,so.ToStore AS StoreToId
			,storet.name AS StoreToName
			,so.vProjectID AS ProjectId
			,project.vProjectID AS projectCode
			,project.vProjectName AS vProjectName
			,'' AS POCode
			,0 AS SupplierId
			,'' AS SupplierName
			,so.dCreated
			,so.dModified
			,usc.NameUser AS Created_By
			,usm.NameUser AS Modified_By
			,so.AccCheck
			,so.AccDescription
			,so.AccdCreated
			,so.AccdModified
			,so.AcciCreated
			,usckc.NameUser AS CheckBy
		FROM [dbo].[WAMS_ASSIGNNING_STOCKS] so (NOLOCK)
		LEFT JOIN [dbo].[WAMS_PROJECT] project (NOLOCK) ON project.Id= so.vProjectID
		LEFT JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = so.vStockID
		CROSS APPLY [dbo].[udf_GetUserName](so.iCreated) AS usc
		CROSS APPLY [dbo].[udf_GetUserName](so.iModified) AS usm
		CROSS APPLY [dbo].[udf_GetUserName](so.AcciCreated) AS usckc
		CROSS APPLY [dbo].[udf_GetStoreNameById](so.FromStore) AS storef
		CROSS APPLY [dbo].[udf_GetStoreNameById](so.ToStore) AS storet
		WHERE
		1 = CASE WHEN @statusCheck = 0 THEN 1 WHEN so.AccCheck = @statusCheck THEN 1 END
		AND 1 = CASE WHEN @sIRV = '' THEN 1 WHEN so.SIV = @sIRV THEN 1 END
		AND 1= CASE WHEN @stock = '' THEN 1 WHEN (stock.vStockID = @stock OR stock.vStockName like '%' + @stock + '%') THEN 1 END
		AND 1= CASE WHEN @fromStore = 0 THEN 1 WHEN so.FromStore = @fromStore THEN 1 END
		AND 1= CASE WHEN @toStore = 0 THEN 1 WHEN so.ToStore = @toStore THEN 1 END
		AND 1= CASE WHEN @project = 0 THEN 1 WHEN so.vProjectID = @project THEN 1 END
		--AND 1 = CASE WHEN @po = '' THEN 1 WHEN so.vProjectID = @pro THEN 1 END
		--AND 1 = CASE WHEN @supplier = 0 THEN 1 WHEN so.vProjectID = @pro THEN 1 END
		AND 1 = CASE WHEN @fd = '' THEN 1 WHEN (so.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR so.dCreated = NULL) THEN 1 END
		AND 1 = CASE WHEN @td = '' THEN 1 WHEN (so.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR so.dCreated = NULL) THEN 1 END
		) tblTemp) tempTable
		WHERE [No] > @fromRow AND [No] < @toRow
	END
	-- STOCK RETURN
	ELSE IF (@status = 2)
	BEGIN
		SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
		,tblTemp.* 
		FROM
		(SELECT 
			sr.bReturnListID AS Id
			,sr.vStockID AS StockId
			,stock.vStockID AS stockCode
			,stock.vStockName
			,sr.bQuantity AS Qty
			,0.00 AS QtyPending
			,0.00 AS QtyPO
			,'RETURN' AS SIRVFag
			,dbo.ConvertAccCheck(sr.AccCheck) AS AccStatus
			,sr.SRV AS SIRV
			,sr.FromStore AS StoreFromId
			,storef.name AS StoreFromName
			,sr.ToStore AS StoreToId
			,storet.name AS StoreToName
			,sr.vProjectID AS ProjectId
			,project.vProjectID AS projectCode
			,project.vProjectName AS vProjectName
			,'' AS POCode
			,0 AS SupplierId
			,'' AS SupplierName
			,sr.dCreated
			,sr.dModified
			,usc.NameUser AS Created_By
			,usm.NameUser AS Modified_By
			,sr.AccCheck
			,sr.AccDescription
			,sr.AccdCreated
			,sr.AccdModified
			,sr.AcciCreated
			,usckc.NameUser AS CheckBy
		FROM [dbo].[WAMS_RETURN_LIST] sr (NOLOCK)
		LEFT JOIN [dbo].[WAMS_PROJECT] project (NOLOCK) ON project.Id= sr.vProjectID
		LEFT JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = sr.vStockID
		--LEFT JOIN [dbo].[WAMS_PURCHASE_ORDER] po (NOLOCK) ON po.Id = sr.vPOID
		CROSS APPLY [dbo].[udf_GetUserName](sr.iCreated) AS usc
		CROSS APPLY [dbo].[udf_GetUserName](sr.iModified) AS usm
		CROSS APPLY [dbo].[udf_GetUserName](sr.AcciCreated) AS usckc
		CROSS APPLY [dbo].[udf_GetStoreNameById](sr.FromStore) AS storef
		CROSS APPLY [dbo].[udf_GetStoreNameById](sr.ToStore) AS storet
		--CROSS APPLY [dbo].[udf_GetSupplierNameById](po.bSupplierID) AS sup
		WHERE
		1 = CASE WHEN @statusCheck = 0 THEN 1 WHEN sr.AccCheck = @statusCheck THEN 1 END
		AND 1 = CASE WHEN @sIRV = '' THEN 1 WHEN sr.SRV = @sIRV THEN 1 END
		AND 1= CASE WHEN @stock = '' THEN 1 WHEN (stock.vStockID = @stock OR stock.vStockName like '%' + @stock + '%') THEN 1 END
		AND 1= CASE WHEN @fromStore = 0 THEN 1 WHEN sr.FromStore = @fromStore THEN 1 END
		AND 1= CASE WHEN @toStore = 0 THEN 1 WHEN sr.ToStore = @toStore THEN 1 END
		AND 1= CASE WHEN @project = 0 THEN 1 WHEN sr.vProjectID = @project THEN 1 END
		--AND 1 = CASE WHEN @po = '' THEN 1 WHEN so.vProjectID = @pro THEN 1 END
		--AND 1 = CASE WHEN @supplier = 0 THEN 1 WHEN so.vProjectID = @pro THEN 1 END
		AND 1 = CASE WHEN @fd = '' THEN 1 WHEN (sr.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR sr.dCreated = NULL) THEN 1 END
		AND 1 = CASE WHEN @td = '' THEN 1 WHEN (sr.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR sr.dCreated = NULL) THEN 1 END
		) tblTemp) tempTable
		WHERE [No] > @fromRow AND [No] < @toRow
	END
	-- -- STOCK IN
	ELSE IF (@status = 3)
	BEGIN
		SELECT * FROM (SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Id DESC) AS [No]
		,tblTemp.* 
		FROM
		(SELECT 
			si.ID AS Id
			,si.vStockID AS StockId
			,stock.vStockID AS stockCode
			,stock.vStockName
			,si.dReceivedQuantity AS Qty
			,si.dPendingQuantity AS QtyPending
			--,0 AS QtyPending
			,si.dQuantity AS QtyPO
			--,0 AS QtyPO
			,'IN' AS SIRVFag
			,dbo.ConvertAccCheck(si.AccCheck) AS AccStatus
			,si.SRV AS SIRV
			,si.iStore AS StoreFromId
			,storef.name AS StoreFromName
			,0 AS StoreToId
			,'' AS StoreToName
			,0 AS ProjectId
			,'' AS projectCode
			,'' AS vProjectName
			,po.vPOID AS POCode
			,po.bSupplierID AS SupplierId
			,sup.SupplierName AS SupplierName
			,si.dCreated
			,si.dModified
			,usc.NameUser AS Created_By
			,usm.NameUser AS Modified_By
			,si.AccCheck
			,si.AccDescription
			,si.AccdCreated
			,si.AccdModified
			,si.AcciCreated
			,usckc.NameUser AS CheckBy
		FROM [dbo].[WAMS_FULFILLMENT_DETAIL] si (NOLOCK)
		--LEFT JOIN [dbo].[WAMS_PROJECT] project (NOLOCK) ON project.Id= assign.vProjectID
		LEFT JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = si.vStockID
		LEFT JOIN [dbo].[WAMS_PURCHASE_ORDER] po (NOLOCK) ON po.Id = si.vPOID
		CROSS APPLY [dbo].[udf_GetUserName](si.iCreated) AS usc
		CROSS APPLY [dbo].[udf_GetUserName](si.iModified) AS usm
		CROSS APPLY [dbo].[udf_GetUserName](si.AcciCreated) AS usckc
		CROSS APPLY [dbo].[udf_GetStoreNameById](si.iStore) AS storef
		--CROSS APPLY [dbo].[udf_GetStoreNameById](si.ToStore) AS storet
		CROSS APPLY [dbo].[udf_GetSupplierNameById](po.bSupplierID) AS sup
		WHERE
		1 = CASE WHEN @statusCheck = 0 THEN 1 WHEN si.AccCheck = @statusCheck THEN 1 END
		AND 1 = CASE WHEN @sIRV = '' THEN 1 WHEN si.SRV = @sIRV THEN 1 END
		AND 1= CASE WHEN @stock = '' THEN 1 WHEN (stock.vStockID = @stock OR stock.vStockName like '%' + @stock + '%') THEN 1 END
		AND 1= CASE WHEN @fromStore = 0 THEN 1 WHEN si.iStore = @fromStore THEN 1 END
		--AND 1= CASE WHEN @toStore = 0 THEN 1 WHEN so.ToStore = @toStore THEN 1 END
		--AND 1= CASE WHEN @project = 0 THEN 1 WHEN so.vProjectID = @project THEN 1 END
		AND 1 = CASE WHEN @po = '' THEN 1 WHEN po.vPOID = @po THEN 1 END
		AND 1 = CASE WHEN @supplier = 0 THEN 1 WHEN po.bSupplierID = @supplier THEN 1 END
		AND 1 = CASE WHEN @fd = '' THEN 1 WHEN (si.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR si.dCreated = NULL) THEN 1 END
		AND 1 = CASE WHEN @td = '' THEN 1 WHEN (si.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR si.dCreated = NULL) THEN 1 END
		) tblTemp) tempTable
		WHERE [No] > @fromRow AND [No] < @toRow
	END
END
/*
exec [dbo].[V3_Accounting_GetList] 1, 1000, 2, 1, '', '',0,0,0,'',0,'',''
*/
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V3_List_Accounting_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[V3_List_Accounting_Count]
GO
CREATE PROCEDURE [dbo].[V3_List_Accounting_Count]
@page int
,@size int
,@status int
,@statusCheck int
,@sIRV nvarchar(20)
,@stock nvarchar(2000)
,@fromStore int
,@toStore int
,@project int
,@po nvarchar(16)
,@supplier int
,@fd varchar(22) 
,@td varchar(22) 
AS
BEGIN
	DECLARE @fromRow int
	DECLARE @toRow int

	SET @fromRow = (@page - 1) * @size
	SET @toRow = (@page * @size) + 1

	-- STOCK OUT
	IF (@status = 1)
	BEGIN
		SELECT COUNT(1) AS [Count]
		FROM [dbo].[WAMS_ASSIGNNING_STOCKS] so (NOLOCK)
		LEFT JOIN [dbo].[WAMS_PROJECT] project (NOLOCK) ON project.Id= so.vProjectID
		LEFT JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = so.vStockID
		CROSS APPLY [dbo].[udf_GetUserName](so.iCreated) AS usc
		CROSS APPLY [dbo].[udf_GetUserName](so.iModified) AS usm
		CROSS APPLY [dbo].[udf_GetUserName](so.AcciCreated) AS usckc
		CROSS APPLY [dbo].[udf_GetStoreNameById](so.FromStore) AS storef
		CROSS APPLY [dbo].[udf_GetStoreNameById](so.ToStore) AS storet
		WHERE
		1 = CASE WHEN @statusCheck = 0 THEN 1 WHEN so.AccCheck = @statusCheck THEN 1 END
		AND 1 = CASE WHEN @sIRV = '' THEN 1 WHEN so.SIV = @sIRV THEN 1 END
		AND 1= CASE WHEN @stock = '' THEN 1 WHEN (stock.vStockID = @stock OR stock.vStockName like '%' + @stock + '%') THEN 1 END
		AND 1= CASE WHEN @fromStore = 0 THEN 1 WHEN so.FromStore = @fromStore THEN 1 END
		AND 1= CASE WHEN @toStore = 0 THEN 1 WHEN so.ToStore = @toStore THEN 1 END
		AND 1= CASE WHEN @project = 0 THEN 1 WHEN so.vProjectID = @project THEN 1 END
		--AND 1 = CASE WHEN @po = '' THEN 1 WHEN so.vProjectID = @pro THEN 1 END
		--AND 1 = CASE WHEN @supplier = 0 THEN 1 WHEN so.vProjectID = @pro THEN 1 END
		AND 1 = CASE WHEN @fd = '' THEN 1 WHEN (so.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR so.dCreated = NULL) THEN 1 END
		AND 1 = CASE WHEN @td = '' THEN 1 WHEN (so.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR so.dCreated = NULL) THEN 1 END
	END
	-- STOCK RETURN
	ELSE IF (@status = 2)
	BEGIN
		SELECT COUNT(1) AS [Count]
		FROM [dbo].[WAMS_RETURN_LIST] sr (NOLOCK)
		LEFT JOIN [dbo].[WAMS_PROJECT] project (NOLOCK) ON project.Id= sr.vProjectID
		LEFT JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = sr.vStockID
		--LEFT JOIN [dbo].[WAMS_PURCHASE_ORDER] po (NOLOCK) ON po.Id = sr.vPOID
		CROSS APPLY [dbo].[udf_GetUserName](sr.iCreated) AS usc
		CROSS APPLY [dbo].[udf_GetUserName](sr.iModified) AS usm
		CROSS APPLY [dbo].[udf_GetUserName](sr.AcciCreated) AS usckc
		CROSS APPLY [dbo].[udf_GetStoreNameById](sr.FromStore) AS storef
		CROSS APPLY [dbo].[udf_GetStoreNameById](sr.ToStore) AS storet
		--CROSS APPLY [dbo].[udf_GetSupplierNameById](po.bSupplierID) AS sup
		WHERE
		1 = CASE WHEN @statusCheck = 0 THEN 1 WHEN sr.AccCheck = @statusCheck THEN 1 END
		AND 1 = CASE WHEN @sIRV = '' THEN 1 WHEN sr.SRV = @sIRV THEN 1 END
		AND 1= CASE WHEN @stock = '' THEN 1 WHEN (stock.vStockID = @stock OR stock.vStockName like '%' + @stock + '%') THEN 1 END
		AND 1= CASE WHEN @fromStore = 0 THEN 1 WHEN sr.FromStore = @fromStore THEN 1 END
		AND 1= CASE WHEN @toStore = 0 THEN 1 WHEN sr.ToStore = @toStore THEN 1 END
		AND 1= CASE WHEN @project = 0 THEN 1 WHEN sr.vProjectID = @project THEN 1 END
		--AND 1 = CASE WHEN @po = '' THEN 1 WHEN so.vProjectID = @pro THEN 1 END
		--AND 1 = CASE WHEN @supplier = 0 THEN 1 WHEN so.vProjectID = @pro THEN 1 END
		AND 1 = CASE WHEN @fd = '' THEN 1 WHEN (sr.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR sr.dCreated = NULL) THEN 1 END
		AND 1 = CASE WHEN @td = '' THEN 1 WHEN (sr.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR sr.dCreated = NULL) THEN 1 END
	END
	-- -- STOCK IN
	ELSE IF (@status = 3)
	BEGIN
		SELECT COUNT(1) AS [Count]
		FROM [dbo].[WAMS_FULFILLMENT_DETAIL] si (NOLOCK)
		--LEFT JOIN [dbo].[WAMS_PROJECT] project (NOLOCK) ON project.Id= assign.vProjectID
		LEFT JOIN [dbo].[WAMS_STOCK] stock (NOLOCK) ON stock.Id = si.vStockID
		LEFT JOIN [dbo].[WAMS_PURCHASE_ORDER] po (NOLOCK) ON po.Id = si.vPOID
		CROSS APPLY [dbo].[udf_GetUserName](si.iCreated) AS usc
		CROSS APPLY [dbo].[udf_GetUserName](si.iModified) AS usm
		CROSS APPLY [dbo].[udf_GetUserName](si.AcciCreated) AS usckc
		CROSS APPLY [dbo].[udf_GetStoreNameById](si.iStore) AS storef
		--CROSS APPLY [dbo].[udf_GetStoreNameById](si.ToStore) AS storet
		CROSS APPLY [dbo].[udf_GetSupplierNameById](po.bSupplierID) AS sup
		WHERE
		1 = CASE WHEN @statusCheck = 0 THEN 1 WHEN si.AccCheck = @statusCheck THEN 1 END
		AND 1 = CASE WHEN @sIRV = '' THEN 1 WHEN si.SRV = @sIRV THEN 1 END
		AND 1= CASE WHEN @stock = '' THEN 1 WHEN (stock.vStockID = @stock OR stock.vStockName like '%' + @stock + '%') THEN 1 END
		AND 1= CASE WHEN @fromStore = 0 THEN 1 WHEN si.iStore = @fromStore THEN 1 END
		--AND 1= CASE WHEN @toStore = 0 THEN 1 WHEN so.ToStore = @toStore THEN 1 END
		--AND 1= CASE WHEN @project = 0 THEN 1 WHEN so.vProjectID = @project THEN 1 END
		AND 1 = CASE WHEN @po = '' THEN 1 WHEN po.vPOID = @po THEN 1 END
		AND 1 = CASE WHEN @supplier = 0 THEN 1 WHEN po.bSupplierID = @supplier THEN 1 END
		AND 1 = CASE WHEN @fd = '' THEN 1 WHEN (si.dCreated >= convert(datetime,(@fd + ' 00:00:00')) OR si.dCreated = NULL) THEN 1 END
		AND 1 = CASE WHEN @td = '' THEN 1 WHEN (si.dCreated <= convert(datetime,(@td + ' 23:59:59')) OR si.dCreated = NULL) THEN 1 END
	END
END

/*
exec [dbo].[V3_List_Accounting_Count] 1, 1000, 2, 1, '', '',0,0,0,'',0,'',''
*/