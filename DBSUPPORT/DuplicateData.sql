SELECT * FROM WAMS_STOCK where vStockName in (
SELECT vStockName FROM WAMS_STOCK 
group by vStockName having count(vStockName) > 1)

SELECT TOP 1 CASE 
	--WHEN (stype.TypeCode + category.CategoryCode  + dbo.CIntToChar((dbo.udf_GetNumeric(stock.vStockID) + 1), 8)) IS NULL THEN stype.TypeCode + category.CategoryCode + '0000001'
	--ELSE (stype.TypeCode + category.CategoryCode + dbo.CIntToChar((dbo.udf_GetNumeric(stock.vStockID) + 1), 8))
	--END [NewCode], stock.vStockID
	--FROM [dbo].[WAMS_STOCK] stock (NOLOCK)
	--INNER JOIN dbo.WAMS_STOCK_TYPE stype (NOLOCK) ON stock.iType = stype.Id
	--INNER JOIN dbo.WAMS_CATEGORY category (NOLOCK) ON stock.bCategoryID = category.bCategoryID
	--WHERE 
	--stock.iType = @type
	--AND stock.bCategoryID = @category
	--ORDER BY stock.Id DESC    
	WHEN (category.CategoryCode  + dbo.CIntToChar((dbo.udf_GetNumeric(stock.vStockID) + 1), 5)) IS NULL THEN category.CategoryCode + '00001'
	ELSE (category.CategoryCode + dbo.CIntToChar((dbo.udf_GetNumeric(stock.vStockID) + 1), 5))
	END [NewCode], stock.vStockID
	FROM [dbo].[WAMS_STOCK] stock (NOLOCK)
	INNER JOIN dbo.WAMS_CATEGORY category (NOLOCK) ON stock.bCategoryID = category.bCategoryID
	WHERE stock.bCategoryID = 33
	ORDER BY stock.Id DESC

select dbo.CIntToChar((dbo.udf_GetNumeric('A020010') + 1), 5)
