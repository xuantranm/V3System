ALTER TABLE WAMS_PO_DETAILS ALTER COLUMN vMRF NVARCHAR(256)
GO
UPDATE WAMS_STOCK SET dCreated = getdate(), dModified = getdate()
GO
UPDATE t1
  SET t1.Unit = t2.vUnitName
  FROM dbo.WAMS_STOCK AS t1
  INNER JOIN dbo.WAMS_UNIT AS t2
  ON t1.bUnitID = t2.bUnitID
GO
UPDATE t1
  SET t1.Category = t2.vCategoryName
  FROM dbo.WAMS_STOCK AS t1
  INNER JOIN dbo.WAMS_CATEGORY AS t2
  ON t1.bCategoryID = t2.bCategoryID
GO
UPDATE t1
  SET t1.Position = t2.vPositionName
  FROM dbo.WAMS_STOCK AS t1
  INNER JOIN dbo.WAMS_POSITION AS t2
  ON t1.bPositionID = t2.bPositionID
GO
UPDATE t1
  SET t1.Label = t2.vLabelName
  FROM dbo.WAMS_STOCK AS t1
  INNER JOIN dbo.WAMS_LABELS AS t2
  ON t1.bLabelID = t2.bLabelID
  GO