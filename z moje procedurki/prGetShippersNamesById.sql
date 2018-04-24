USE [C_HARTWIG_SO_DEVEL]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [schUsers].[prGetAllShippersNamesFromShippingOperationMetrics]

AS
BEGIN
	DECLARE @sql NVARCHAR(MAX)

	SET @sql = N'
SELECT DISTINCT
	[ShipperUserId]
	, [tShipper].[LastName]
    , [tShipper].[FullName]
FROM [schSO].[tShippingOperationMetrics]
	LEFT JOIN [schUsers].[tUsers] [tShipper]
	ON [schSO].[tShippingOperationMetrics].[ShipperUserId]= [tShipper].[UserId]
ORDER BY [tShipper].[LastName]
  '
	EXEC sp_executesql @sql
END

