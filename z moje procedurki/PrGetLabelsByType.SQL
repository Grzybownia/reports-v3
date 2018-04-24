USE [C_HARTWIG_SO_DEBUG]
-- USE [C_HARTWIG_SO_DEVEL]
GO
/****** Object:  StoredProcedure [schDictionaries].[PrGetLabelsByType]    Script Date: 2018-04-10 18:27:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [schDictionaries].[PrGetLabelsByType]
	@intIdOfType INT
AS
BEGIN

	DECLARE @sql NVARCHAR(MAX)
	DECLARE @paramsDef NVARCHAR(MAX)

	SET @paramsDef = N'@intIdOfType INT'

	SET @sql = N'
SELECT tDIN.DictionaryItemVersionId
  ,tDIN.Name
FROM schDictionaries.tDictionaryItems tDI
	JOIN schDictionaries.tDictionaryItemVersions tDIV
	ON tDIV.DictionaryItemId=tDI.DictionaryItemId
	JOIN schDictionaries.tDictionaryItemNames tDIN
	ON tDIV.DictionaryItemVersionId=tDIN.DictionaryItemVersionId
WHERE tDI.DictionaryId = (SELECT tDI.DictionaryId
	FROM schDictionaries.tDictionaryItems tDI
	WHERE tDI.DictionaryItemId=@intIdOfType) AND tDIV.IsActive=1
ORDER BY tDIN.Name ASC
  '

	EXEC sp_executesql @sql, @paramsDef, @intIdOfType

END

