UPDATE WAMS_PURCHASE_ORDER SET vRemark='' WHERE vPOID=''
-- Use excel faster
SELECT vRemark, vPOID FROM WAMS_PURCHASE_ORDER WHERE dPODate>='2015-05-01' and bPOTypeID=3 and vRemark like '%<%'
