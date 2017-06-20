
GO
DROP PROCEDURE [dbo].[XGetListStock]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[XGetListStock]
@page int
,@size int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@store varchar(50)
,@type int
,@category int
,@enable char(1)
,@out INT OUTPUT
AS
BEGIN
	WITH AllRecords AS ( 
		SELECT COUNT(1) [Rows] FROM [dbo].[WAMS_STOCK] (NOLOCK)
	WHERE iType != 8
	AND 1 = CASE WHEN @enable='' THEN 1 WHEN iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1 = CASE WHEN @store='' THEN 1 WHEN StoreId IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
	AND 1= CASE WHEN @type=0 THEN 1 WHEN iType = @type THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN bCategoryID = @category THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 WHEN vStockID = @stockCode THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 WHEN vStockName like '%' + @stockName + '%' THEN 1 END
	) SELECT @out = [Rows] From AllRecords;
	
  -- now get the records
  WITH AllRecords AS ( 
   SELECT ROW_NUMBER() OVER (ORDER BY stock.Id DESC) 
   AS Row, stock.*, store.Name [Store] ,usc.NameUser AS Created_By
		,usm.NameUser AS Modified_By FROM dbo.[WAMS_STOCK] stock (NOLOCK)
		INNER JOIN dbo.Store store (NOLOCK) ON store.Id = stock.StoreId
		CROSS APPLY [dbo].[udf_GetUserName](stock.iCreated) AS usc
		CROSS APPLY [dbo].[udf_GetUserName](stock.iModified) AS usm
   WHERE iType != 8
	AND 1 = CASE WHEN @enable='' THEN 1 WHEN stock.iEnable = CAST(@enable AS INT) THEN 1 END
	AND 1 = CASE WHEN @store='' THEN 1 WHEN StoreId IN (SELECT * from dbo.fnStringList2Table(@store)) THEN 1 END
	AND 1= CASE WHEN @type=0 THEN 1 WHEN stock.iType = @type THEN 1 END
	AND 1= CASE WHEN @category=0 THEN 1 WHEN stock.bCategoryID = @category THEN 1 END
	AND 1= CASE WHEN @stockCode='' THEN 1 WHEN stock.vStockID = @stockCode THEN 1 END
	AND 1= CASE WHEN @stockName='' THEN 1 WHEN stock.vStockName like '%' + @stockName + '%' THEN 1 END
  )
  SELECT * FROM AllRecords 
  WHERE [Row] > (@page - 1) * @size and [Row] < (@page * @size) + 1;
END
/*
exec dbo.XGetListStock 1, 10, '','','',0,0,1,0
*/
GO


