USE [C_HARTWIG_SO_DEBUG]
USE [C_HARTWIG_SO_DEVEL]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [schUsers].[prGetAllContractorsNamesFromtShippingActions]

AS
BEGIN
	DECLARE @sql NVARCHAR(MAX)

	SET @sql = N'
SELECT DISTINCT
	tSA.[ContractorId]
	 ,[tContractor].[LastName]
     ,[tContractor].[FullName]
FROM schSOA.tShippingActions tSA
	JOIN [schUsers].[tUsers] [tContractor]
	ON tSA.[ContractorId] = [tContractor].UserId
ORDER BY [tContractor].[LastName]
  '
	EXEC sp_executesql @sql
END

