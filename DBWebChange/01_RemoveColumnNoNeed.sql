GO
EXEC sp_rename 'WAMS_SRV', 'SRV'
GO
--ALTER TABLE WAMS_STOCK DROP COLUMN vPhotoPath
GO
ALTER TABLE WAMS_STOCK DROP COLUMN bSupplierID
GO
ALTER TABLE WAMS_SUPPLIER DROP COLUMN bArrovepeSupplier
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[deleteWAMS_STOCK]'))
DROP TRIGGER [dbo].[deleteWAMS_STOCK]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[insertWAMS_STOCK]'))
DROP TRIGGER [dbo].[insertWAMS_STOCK]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trigger_insertSTOCKIN]'))
DROP TRIGGER [dbo].[trigger_insertSTOCKIN]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trigger_insertWAMS_PRODUCT]'))
DROP TRIGGER [dbo].[trigger_insertWAMS_PRODUCT]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trigger_updateTotalmoneyPOforDelete]'))
DROP TRIGGER [dbo].[trigger_updateTotalmoneyPOforDelete]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trigger_updateTotalmoneyPOforInsert]'))
DROP TRIGGER [dbo].[trigger_updateTotalmoneyPOforInsert]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trigger_updateTotalmoneyPOforUpdate]'))
DROP TRIGGER [dbo].[trigger_updateTotalmoneyPOforUpdate]
GO
ALTER TABLE WAMS_REQUISITION_MASTER DROP COLUMN vRemark