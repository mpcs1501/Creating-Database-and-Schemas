USE Chinook;
GO

-- =============================================
-- Author:		<Marcus,,Sousa>
-- Create date: <Oct, 28, 2019>
-- Description:	<Template for BI functions>
-- =============================================


CREATE or ALTER FUNCTION bia.udfMils2Secs(@milsIn int)
RETURNS int 
AS

-- returns milliseconds to seconds
BEGIN
	DECLARE @secsOut int;
	SELECT @secsOut = @milsIn / 1000
		IF(@secsOut is NULL)
			SET @secsOut = 0
	RETURN @secsOut
END;



SELECT t.AlbumId 
	  ,t.[Name] as 'Album NAme'
	  ,bia.udfMils2Secs(t.Milliseconds) as 'Seconds'
	  ,t.UnitPrice as 'Price'
FROM dbo.Track t;
GO



use Sakila;
go

select upper(left(c.first_name,1))
		+ lower(right(c.first_name, len(c.first_name)-1))
from dbo.customer c;



CREATE or ALTER FUNCTION udf.udfblah(@NameIn nvarchar(50))
RETURNS nvarchar(50)
AS


BEGIN
DECLARE @pName nvarchar(50);
		select 
			@pName = left(@NameIn,1) + lower(right(@NameIn, len(@NameIn)-1))
		IF(@pName is NULL)
			SET @pname = 0
	RETURN @pName
END;


select 

c.first_name
,udf.udfblah(c.first_name) as 'correct name'
from dbo.customer c
;
