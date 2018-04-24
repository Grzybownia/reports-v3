USE [C_HARTWIG_SO_DEBUG]
USE [C_HARTWIG_SO_DEVEL]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [schUsers].[prGetAllPrincipalsCHGNamesFromtShippingActionsMainData]

AS
BEGIN
	DECLARE @sql NVARCHAR(MAX)

	SET @sql = N'
SELECT DISTINCT
	tSAMD.CreatedUserId
	 ,[tPincipalCHG].[LastName]
     ,[tPincipalCHG].[FullName]
FROM schSOA.tShippingActionMainData tSAMD
	JOIN [schUsers].[tUsers] [tPincipalCHG]
	ON tSAMD.CreatedUserId = [tPincipalCHG].UserId
ORDER BY [tPincipalCHG].[LastName]
  '
	EXEC sp_executesql @sql
END


