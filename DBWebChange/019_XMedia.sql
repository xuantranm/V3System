IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[XStockInParent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[XStockInParent]
GO
CREATE PROCEDURE XStockInParent
	@siv varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT DISTINCT store1.Name [From], '' [To], '' [ProjectCode], '' [ProjectName], sout.SRV [Srv], sout.dCreated [Date] 
	FROM dbo.WAMS_FULFILLMENT_DETAIL sout (NOLOCK)
	--INNER JOIN dbo.WAMS_PROJECT project (NOLOCK) ON project.Id = sout.vProjectID
	LEFT JOIN dbo.Store store1 (NOLOCK) ON store1.Id = sout.iStore
	--LEFT JOIN dbo.Store store2 (NOLOCK) ON store2.Id = sout.ToStore
	WHERE sout.SRV = @siv 
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[XStockIn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[XStockIn]
GO
CREATE PROCEDURE XStockIn
	@siv varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT sout.ID [Id] 
	,stock.vStockID [StockCode]
	,stock.vStockName [StockName]
	,unit.vUnitName [Unit]
	,sout.dQuantity [Quantity]
	,stock.RalNo [RalNo]
	,stock.ColorName [Color]
	,sout.tDescription [Note]
	FROM dbo.WAMS_FULFILLMENT_DETAIL sout (NOLOCK)
	INNER JOIN dbo.WAMS_STOCK stock (NOLOCK) ON stock.Id = sout.vStockID
	LEFT JOIN dbo.WAMS_UNIT unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	WHERE sout.SRV = @siv 
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[XStockOutParent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[XStockOutParent]
GO
CREATE PROCEDURE XStockOutParent
	@siv varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT sout.vMRF [Mrf], project.vProjectID [ProjectCode], sout.SIV, sout.dCreated [Date] FROM dbo.WAMS_ASSIGNNING_STOCKS sout (NOLOCK)
	INNER JOIN dbo.WAMS_PROJECT project (NOLOCK) ON project.Id = sout.vProjectID
	WHERE sout.SIV = @siv 
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[XStockOut]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[XStockOut]
GO
CREATE PROCEDURE XStockOut
	@siv varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT sout.bAssignningStockID [Id] 
	,stock.vStockID [StockCode]
	,stock.vStockName [StockName]
	,unit.vUnitName [Unit]
	,sout.bQuantity [Quantity]
	,stock.RalNo [RalNo]
	,stock.ColorName [Color]
	,sout.[Description] [Note]
	FROM dbo.WAMS_ASSIGNNING_STOCKS sout (NOLOCK)
	INNER JOIN dbo.WAMS_STOCK stock (NOLOCK) ON stock.Id = sout.vStockID
	LEFT JOIN dbo.WAMS_UNIT unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	WHERE sout.SIV = @siv 
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[XStockReturnParent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[XStockReturnParent]
GO
CREATE PROCEDURE XStockReturnParent
	@siv varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT DISTINCT store1.Name [From], store2.Name [To], project.vProjectID [ProjectCode], project.vProjectName [ProjectName], sout.SRV [Srv], sout.dCreated [Date] FROM dbo.WAMS_RETURN_LIST sout (NOLOCK)
	INNER JOIN dbo.WAMS_PROJECT project (NOLOCK) ON project.Id = sout.vProjectID
	LEFT JOIN dbo.Store store1 (NOLOCK) ON store1.Id = sout.FromStore
	LEFT JOIN dbo.Store store2 (NOLOCK) ON store2.Id = sout.ToStore
	WHERE sout.SRV = @siv 
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[XStockReturn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[XStockReturn]
GO
CREATE PROCEDURE XStockReturn
	@siv varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT sout.bReturnListID [Id] 
	,stock.vStockID [StockCode]
	,stock.vStockName [StockName]
	,unit.vUnitName [Unit]
	,sout.bQuantity [Quantity]
	,stock.RalNo [RalNo]
	,stock.ColorName [Color]
	,sout.vCondition [Note]
	FROM dbo.WAMS_RETURN_LIST sout (NOLOCK)
	INNER JOIN dbo.WAMS_STOCK stock (NOLOCK) ON stock.Id = sout.vStockID
	LEFT JOIN dbo.WAMS_UNIT unit (NOLOCK) ON unit.bUnitID = stock.bUnitID
	WHERE sout.SRV = @siv 
END
GO
