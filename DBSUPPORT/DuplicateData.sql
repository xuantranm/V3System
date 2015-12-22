SELECT * FROM WAMS_STOCK where vStockName in (
SELECT vStockName FROM WAMS_STOCK 
group by vStockName having count(vStockName) > 1)