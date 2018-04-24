USE C_HARTWIG_SO_DEVEL

DECLARE @languageDictId INT = 440001
-- polski,przekazywane jako parametr z aplikacji
DECLARE @vcharIDontKnowWhere VARCHAR(32) = '>idk where??<'

DECLARE @intImporterExporterDictTypeId INT = (SELECT [DictionaryItemVersionId]
FROM [schDictionaries].[tDictionaryItemVersions]
WHERE [DictionaryItemId] = 170012 AND IsActive = 1)

DECLARE @intPrincipalDictTypeId INT = (SELECT [DictionaryItemVersionId]
FROM [schDictionaries].[tDictionaryItemVersions]
WHERE [DictionaryItemId] = 170002 AND IsActive = 1)

DECLARE @intPayerDictTypeId INT = (SELECT [DictionaryItemVersionId]
FROM [schDictionaries].[tDictionaryItemVersions]
WHERE [DictionaryItemId] = 170003 AND IsActive = 1)



SELECT
	tSA.ShippingActionId
  ,tSOM.PrincipalSubjectId
,tPrincipal.Name AS Principal
-- ,tPrincipalTypesName.Name as PrincipalTypeName
,tPayer.Name AS Payer
-- ,tPayerTypesName.Name as PayerTypeName
,tImporterExporter.Name


FROM schSOA.tShippingActions tSA
	LEFT JOIN schSOA.tShippingActionMainData tSAMD
	ON tSA.ShippingActionMainDataId = tSAMD.ShippingActionMainDataId
	-- LEFT JOIN schSOA.tShippingActionsSubjects tSAC
	-- ON tSA.ShippingActionId = tSAC.ShippingActionId
	-- LEFT JOIN schSubjects.tSubjects tS
	-- ON tSAC.SubjectId = tS.SubjectId
	LEFT JOIN schSOA.tShippingOperationsActions tSOA
	ON tSA.ShippingActionMainDataId = tSOA.ShippingActionMainDataId
	JOIN schSO.tShippingOperations tSO
	ON tSOA.ShippingOperationId = tSO.ShippingOperationId
	-- LEFT JOIN schSO.tShippingOperationMainData tSOMD
	-- ON tSO.ShippingOperationMainDataId = tSOMD.ShippingOperationMainDataId
	-- -- LEFT JOIN schUsers.tUsers tU
	-- -- ON tSOMD.CreatedUserId = tU.UserId
	LEFT JOIN schSO.tShippingOperationMetrics tSOM
	ON tSO.ShippingOperationMetricId = tSOM.ShippingOperationMetricId

	LEFT JOIN
	(SELECT tS.SubjectId ,tS.Name
	FROM schSubjects.tSubjects tS
		JOIN schSubjects.tSubjectTypes tST
		ON tS.SubjectId=tST.SubjectId
	WHERE tST.TypeDictId=@intImporterExporterDictTypeId
)
AS tImporterExporter
	ON tSOM.PrincipalSubjectId=tImporterExporter.SubjectId


	LEFT JOIN(SELECT tS.SubjectId ,tS.Name
	FROM schSubjects.tSubjects tS
		JOIN schSubjects.tSubjectTypes tST
		ON tS.SubjectId=tST.SubjectId
	WHERE tST.TypeDictId=@intPrincipalDictTypeId
) AS tPrincipal
	ON tSOM.PrincipalSubjectId=tPrincipal.SubjectId

	LEFT JOIN (SELECT tS.SubjectId ,tS.Name
	FROM schSubjects.tSubjects tS
		JOIN schSubjects.tSubjectTypes tST
		ON tS.SubjectId=tST.SubjectId
	WHERE tST.TypeDictId=@intPayerDictTypeId
) AS tPayer
	ON tSOM.PayerSubjectId=tPayer.SubjectId

WHERE tSA.IsActive =1
	AND tSO.IsActive=1


	-- AND ActionNumber LIKE '%OC0105/2018%'
	AND ActionNumber LIKE '%OC0097/2018%'










/*
SELECT
	tSCC.ETDDate
,tSA.CreatedDate
,tSOMD.OperationNumber
,tSCC.ShippingTypeId

FROM [schSOA].[tShippingCustomsClearances] tSCC
	LEFT JOIN schSOA.tShippingActions tSA
	ON tSCC.ShippingCustomsClearanceId=tSA.ShppingCustomClearanceId
	LEFT JOIN schSOA.tShippingActionMainData tSAMD
	ON tSA.ShippingActionMainDataId=tSAMD.ShippingActionMainDataId
	LEFT JOIN schSOA.tShippingOperationsActions tSOA
	ON tSAMD.ShippingActionMainDataId = tSOA.ShippingActionMainDataId
	LEFT JOIN schSO.tShippingOperations tSO
	ON tSOA.ShippingOperationId = tSO.ShippingOperationId
	LEFT JOIN schSO.tShippingOperationMainData tSOMD
	ON tSO.ShippingOperationMainDataId = tSOMD.ShippingOperationMainDataId
WHERE tSAMD.ActionNumber LIKE '%OC0097/2018%'
	AND tSOMD.OperationNumber LIKE '%005134%'
	AND tSO.IsActive =1

*/









/*

SELECT tSO.ShippingOperationId
,tSRP.ShippingRoutePositionId
,tSRP.CarriesSubjectId
,tShipper.SubjectId
,tShipper.Name
FROM schSO.tShippingOperations tSO
	LEFT JOIN schSO.tShippingOperationsRoutePositions tSORP
	ON tSO.ShippingOperationId=tSORP.ShippingOperationId
	LEFT JOIN schSO.tShippingRoutePositions tSRP
	ON tSORP.ShippingRoutePositionId=tSRP.ShippingRoutePositionId
	LEFT JOIN schSubjects.tSubjects tShipper
	ON tShipper.SubjectId=tSRP.CarriesSubjectId
ORDER BY Name DESC
*/