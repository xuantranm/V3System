GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetNumeric]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_GetNumeric]
GO
CREATE FUNCTION [dbo].[udf_GetNumeric]
(@strAlphaNumeric VARCHAR(256))
RETURNS VARCHAR(256)
AS
BEGIN
DECLARE @intAlpha INT
SET @intAlpha = PATINDEX('%[^0-9]%', @strAlphaNumeric)
BEGIN
WHILE @intAlpha > 0
BEGIN
SET @strAlphaNumeric = STUFF(@strAlphaNumeric, @intAlpha, 1, '' )
SET @intAlpha = PATINDEX('%[^0-9]%', @strAlphaNumeric )
END
END
RETURN ISNULL(@strAlphaNumeric,0)
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConvertRight]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ConvertRight]
GO

CREATE FUNCTION [dbo].[ConvertRight](@input Int) RETURNS nvarchar(20)
AS
BEGIN
    RETURN CASE 
		WHEN @input = 0 THEN 'None'
        WHEN @input = 1 THEN 'Read'
        WHEN @input = 2 THEN 'Add'
        WHEN @input = 3 THEN 'Edit'
		WHEN @input = 4 THEN 'Delete'
    end 
END
-- select dbo.ConvertRight (3)

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnStringList2Table]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnStringList2Table]
GO

CREATE FUNCTION [dbo].[fnStringList2Table]
(
    @List varchar(MAX)
)
RETURNS 
@ParsedList table
(
    item int
)
AS
BEGIN
    DECLARE @item varchar(800), @Pos int

    SET @List = LTRIM(RTRIM(@List))+ ','
    SET @Pos = CHARINDEX(',', @List, 1)

    WHILE @Pos > 0
    BEGIN
        SET @item = LTRIM(RTRIM(LEFT(@List, @Pos - 1)))
        IF @item <> ''
        BEGIN
            INSERT INTO @ParsedList (item) 
            VALUES (CAST(@item AS int))
        END
        SET @List = RIGHT(@List, LEN(@List) - @Pos)
        SET @Pos = CHARINDEX(',', @List, 1)
    END

    RETURN
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConvertAccCheck]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ConvertAccCheck]
GO

CREATE FUNCTION [dbo].[ConvertAccCheck](@check Int) RETURNS nvarchar(20)
AS
BEGIN
    RETURN CASE 
        WHEN @check = 1 THEN 'Uncheck'
        WHEN @check = 2 THEN 'Process'
        WHEN @check = 3 THEN 'Checked'
    end 
END
--select dbo.ConvertAccCheck (3) as aass

GO

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetStoreNameById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_GetStoreNameById]
GO

CREATE FUNCTION [dbo].[udf_GetStoreNameById]
(	
	 @Id int
)
RETURNS @StoreSm TABLE(
	 name nvarchar(64) 
) 
AS
BEGIN
	IF(EXISTS (SELECT 1 FROM [dbo].[Store] WHERE Id = @Id))
	BEGIN
		INSERT INTO @StoreSm
		SELECT Name FROM [dbo].[Store] where Id = @Id
	END
	ELSE
	BEGIN
		INSERT INTO @StoreSm(name) VALUES (NULL)
	END
	RETURN
END
--select * from [dbo].[udf_GetStoreNameById] (3)
GO

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetSupplierNameById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_GetSupplierNameById]
GO

CREATE FUNCTION [dbo].[udf_GetSupplierNameById]
(	
	 @Id int
)
RETURNS @SupSm TABLE(
	 SupplierName nvarchar(64) 
) 
AS
BEGIN
	IF(EXISTS (SELECT 1 FROM [dbo].[WAMS_SUPPLIER] WHERE Id = @Id))
	BEGIN
		INSERT INTO @SupSm
		SELECT vSupplierName FROM [dbo].[WAMS_SUPPLIER] where Id = @Id
	END
	ELSE
	BEGIN
		INSERT INTO @SupSm(SupplierName) VALUES (NULL)
	END
	RETURN
END
--select * from [dbo].[udf_GetSupplierNameById] (3)
GO

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetMRFById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_GetMRFById]
GO

CREATE FUNCTION [dbo].[udf_GetMRFById]
(	
	 @Id int
)
RETURNS @MrfSm TABLE(
	 Mrf nvarchar(16) 
) 
AS
BEGIN
	IF(EXISTS (SELECT 1 FROM [dbo].[WAMS_REQUISITION_MASTER] WHERE Id = @Id))
	BEGIN
		INSERT INTO @MrfSm
		SELECT vMRF FROM [dbo].[WAMS_REQUISITION_MASTER] where Id = @Id
	END
	ELSE
	BEGIN
		INSERT INTO @MrfSm(Mrf) VALUES (NULL)
	END
	RETURN
END

GO

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetUserName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_GetUserName]
GO

CREATE FUNCTION [dbo].[udf_GetUserName]
(	
	 @Created int
)
RETURNS @UserCreated TABLE(
	 NameUser nvarchar(130) 
) 
AS
BEGIN
	IF(EXISTS (SELECT 1 FROM [dbo].[WAMS_USER] WHERE bUserId = @Created))
	BEGIN
		INSERT INTO @UserCreated
		SELECT (vLastName + ' ' + vFirstName) as NameUser FROM [dbo].[WAMS_USER] where bUserId=@Created
	END
	ELSE
	BEGIN
		INSERT INTO @UserCreated(NameUser) VALUES (NULL)
	END
	RETURN
END
GO
-- select * FROM dbo.udf_GetUserName (2)

-- Use for SIV, SRV
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CIntToChar]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[CIntToChar]
GO

CREATE FUNCTION [dbo].[CIntToChar](@intVal BIGINT, @intLen Int) RETURNS nvarchar(20)
AS
BEGIN
    -- BIGINT = 2^63-1 (9,223,372,036,854,775,807) Max size number

    -- @intlen contains the string size to return
    IF @intlen > 20
       SET @intlen = 20

    RETURN REPLICATE('0',@intLen-LEN(RTRIM(CONVERT(nvarchar(20),@intVal)))) 
        + CONVERT(nvarchar(20),@intVal)
END
--select dbo.CIntToChar (820, 6) as aass
GO

-- Create function GetUserNameById
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserNameById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetUserNameById]
GO

CREATE FUNCTION [dbo].[GetUserNameById](@Id int)
RETURNS varchar(max)
AS
BEGIN
	RETURN (select vLastName + ' ' + vFirstName as FullName from WAMS_USER where bUserId = @Id)
END

GO

-- Create function GetStoreNameById
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetStoreNameById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetStoreNameById]
GO

CREATE FUNCTION [dbo].[GetStoreNameById](@Id int)
RETURNS varchar(max)
AS
BEGIN
	RETURN (select Name from Store where Id = @Id)
END

-- GetCategoryNameById
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCategoryNameById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetCategoryNameById]
GO
CREATE FUNCTION [dbo].[GetCategoryNameById](@CategoryId int)
RETURNS varchar(max)
AS
BEGIN
	RETURN (select vCategoryName from WAMS_CATEGORY where Id = @CategoryId)
END
GO

-- GetSupplierNameById
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSupplierNameById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetSupplierNameById]
GO
CREATE FUNCTION [dbo].[GetSupplierNameById](@SupplierId int)
RETURNS varchar(max)
AS
BEGIN
	RETURN (select vSupplierName from WAMS_SUPPLIER where Id = @SupplierId)
END
GO

-- GetTypeNameById
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTypeNameById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetTypeNameById]
GO
CREATE FUNCTION [dbo].[GetTypeNameById](@TypeId int)
RETURNS varchar(max)
AS
BEGIN
	RETURN (select TypeName from WAMS_STOCK_TYPE where Id = @TypeId)
END
GO

-- GetUnitNameById
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUnitNameById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetUnitNameById]
GO
CREATE FUNCTION [dbo].[GetUnitNameById](@UnitId int)
RETURNS varchar(max)
AS
BEGIN
	RETURN (select vUnitName from WAMS_UNIT where Id = @UnitId)
END
GO

-- GetMRFById
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMRFById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetMRFById]
GO
CREATE FUNCTION [dbo].[GetMRFById](@MRFId int)
RETURNS varchar(max)
AS
BEGIN
	RETURN (select vMRF from WAMS_REQUISITION_MASTER where Id = @MRFId)
END
GO
-- select dbo.GetMRFById(1)

-- GetPOIdById
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPOIdById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetPOIdById]
GO
CREATE FUNCTION [dbo].[GetPOIdById](@POId int)
RETURNS varchar(max)
AS
BEGIN
	RETURN (select vPOID from WAMS_PURCHASE_ORDER where Id = @POId)
END
GO
-- select dbo.GetPOIdById(1)

-- GetCurrencyById
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCurrencyById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetCurrencyById]
GO
CREATE FUNCTION [dbo].[GetCurrencyById](@Id int)
RETURNS varchar(max)
AS
BEGIN
	RETURN (select vCurrencyName from WAMS_CURRENCY_TYPE where bCurrencyTypeID = @Id)
END
GO
-- select dbo.GetCurrencyById(1)

-- GetPOTypeById
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPOTypeById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetPOTypeById]
GO
CREATE FUNCTION [dbo].[GetPOTypeById](@Id int)
RETURNS varchar(max)
AS
BEGIN
	RETURN (select vPOTypeName from WAMS_PO_TYPE where bPOTypeID = @Id)
END
GO
-- select dbo.GetPOTypeById(1)

-- GetPaymentById
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPaymentById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetPaymentById]
GO
CREATE FUNCTION [dbo].[GetPaymentById](@Id int)
RETURNS varchar(max)
AS
BEGIN
	RETURN (select PaymentName from PaymentTerm where Id = @Id)
END
GO
-- select dbo.GetPaymentById(1)

--SELECT dbo.GetPendingQtyByPOandStock(9510,6996) AS MyResult
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPendingQtyByPOandStock]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetPendingQtyByPOandStock]
GO

CREATE FUNCTION [dbo].[GetPendingQtyByPOandStock](@PoId int, @StockId int)
RETURNS decimal(18,2)
AS
BEGIN
	RETURN (select top 1 dPendingQuantity from WAMS_FULFILLMENT_DETAIL where vPOID = @PoId and vStockID=@StockId and iEnable=1 order by ID desc)
END

GO