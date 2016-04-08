--XGetDynamicReport
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[XGetDynamicReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[XGetDynamicReport]
GO

CREATE PROCEDURE [dbo].[XGetDynamicReport]
@page int
,@size int
,@poType int
,@po nvarchar(200)
,@stockType int
,@category int
,@stockCode nvarchar(200)
,@stockName nvarchar(200)
,@out INT OUTPUT
AS
BEGIN
	-- get record count
	WITH AllRecords AS ( 
		SELECT * FROM XDynamicReport
	WHERE 1= CASE WHEN @user='' THEN 1 WHEN a.Email like '%' + @user +'%' OR a.UserName like '%' + @user +'%'  THEN 1 END
	AND 1= CASE WHEN @projectId = 0 THEN 1 WHEN project.Id = @projectId THEN 1 END
	AND 1 = CASE WHEN @project = '' THEN 1 WHEN project.UnsignName like '%' + @project + '%' THEN 1 END
	) SELECT @out = Count(*) From AllRecords;

  -- now get the records
  WITH AllRecords AS ( 
   SELECT ROW_NUMBER() OVER (ORDER BY p.Id DESC) 
   AS Row, p.*
	FROM XDynamicReport p
	INNER JOIN AspNetUsers a ON a.Id = p.UserId
	INNER JOIN ProjectView2 project ON project.Id = p.ProjectId
	WHERE p.[Type] = @type
	AND 1= CASE WHEN @user='' THEN 1 WHEN a.Email like '%' + @user +'%' OR a.UserName like '%' + @user +'%'  THEN 1 END
	AND 1= CASE WHEN @projectId = 0 THEN 1 WHEN project.Id = @projectId THEN 1 END
	AND 1 = CASE WHEN @project = '' THEN 1 WHEN project.UnsignName like '%' + @project + '%' THEN 1 END
  ) SELECT * FROM AllRecords 
  WHERE [Row] > (@page - 1) * @size and  [Row] < (@page * @size) + 1;
END
/*
exec dbo.V3_List_Stock_Search_Count 1, 10, 1, '','', 0, 0,0
*/
GO