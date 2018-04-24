-- USE [C_HARTWIG_SO_DEBUG]
USE [C_HARTWIG_SO_DEVEL]
GO
/****** Object:  StoredProcedure [schReports].[prGetTransportOrder]    Script Date: 2018-03-08 13:33:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [schReports].[prGetCustomsClearance]
	@languageDictId INT
--Agent celny	rozwijalna lista wielokrotnego wyboru z użytkownikami systemu,
	,@customAgentIds [schDictionaries].[IntTable] READONLY
--Status czynności	rozwijalna lista wielokrotnego wyboru ze statusami,
	,@actionStatusIds [schDictionaries].[IntTable] READONLY
--Importer/eksporter	wyszukiwarka kontrahentów,
	,@importerExporterName VARCHAR(50)
--Data zlecenia od do	pole typu data z kalendarzem ułatwiającym wprowadzenia daty.
	,@orderDateFrom DATETIME
	,@orderDateTo DATETIME
--XXX----------------------------------------------
	,@vcharIDontKnowWhere VARCHAR(32)

AS
BEGIN
	DECLARE @sql NVARCHAR(MAX)
	DECLARE @paramsDef NVARCHAR(MAX)

	DECLARE @intImporterExporterDictTypeId INT = (SELECT [DictionaryItemVersionId]
	FROM [schDictionaries].[tDictionaryItemVersions]
	WHERE [DictionaryItemId] = 170012 AND IsActive = 1)

	DECLARE @intPrincipalDictTypeId INT = (SELECT [DictionaryItemVersionId]
	FROM [schDictionaries].[tDictionaryItemVersions]
	WHERE [DictionaryItemId] = 170002 AND IsActive = 1)

	DECLARE @intPayerDictTypeId INT = (SELECT [DictionaryItemVersionId]
	FROM [schDictionaries].[tDictionaryItemVersions]
	WHERE [DictionaryItemId] = 170003 AND IsActive = 1)

	SET @paramsDef = N'
	@languageDictId INT
	,@customAgentIds [schDictionaries].[IntTable] READONLY
	,@actionStatusIds [schDictionaries].[IntTable] READONLY
	,@importerExporterName VARCHAR(50)
	,@orderDateFrom DATETIME
	,@orderDateTo DATETIME
--XXX----------------------------------------------
	,@vcharIDontKnowWhere VARCHAR(32)
	,@intImporterExporterDictTypeId INT
	,@intPrincipalDictTypeId INT
	,@intPayerDictTypeId INT
'

	--####################################
	--######### SELECT BEGIN #############
	SET @sql = N'
	SELECT
-- 	1	Czynność - (link do podglądu dyspozycji celnej),
	tSAMD.ShippingActionMainDataId AS [ActionNumberId]
	,tSAMD.ActionNumber AS [ActionNumberLink]
-- 	2	Operacja spedycyjna - (link do podglądu operacji spedycyjnej),
	,tSOMD.ShippingOperationMainDataId AS [ShippingOperationId]
	,tSOMD.OperationNumber AS [ShippingOperationNumberLink]
-- 	3	Status czynności
	,tActionStatusName.Name AS [ActionStatus]
-- 	4	Data zlecenia
	,tSA.CreatedDate AS [OrderDate]
-- 	5	Data przyjęcia do realizacji
	,tSA.AcceptanceDate AS [RealizationAcceptanceDate]
-- 	6	Data realizacji
	,tSA.RealizationDate 
-- 	7	Data zakończenia
	,tSA.EndDate
-- 	8	Zleceniodawca CHG
	,tPrincipalCHG.FullName AS [PrincipalCHG]
-- 	9	Biuro wykonawcy
	,tOffice.OfficeName AS [ContractorOffice]
-- 	10	Kierownik biura wykonawcy
	,tContractorOfficeManager.FullName AS [ContractorOfficeManager]
-- 	11	Tryb odprawy
	,tExpeditionTypeName.Name AS [ExpeditionType]
-- 	12	Incoterms
	,tIncotermsName.Name AS [Incoterms]
-- 	13	Rodzaj odprawy
	,tShippingTypeName.Name AS [ShippingType]
-- 	14	Procedura celna
	,tCustomsProcedureName.Name AS [CustomsProcedure]
-- 	15	Typ zgłoszenia
	,tApplicationTypeName.Name AS [ApplicationType]
-- 	16	Data deadline 
	,tSCC.DeadlineDate 
-- 	17	Data E.T.D.
	,tSCC.ETDDate
-- 	18	Rodzaj zabezpieczeń
	,tSecurityTypeName.Name AS [SecurityType]
-- 	19	Płatnik
	,tPayerTypeName.Name AS [PayerType]
-- 	20	Miejsce załadunku
	,tSCC.LoadingPlace
-- 	21	Importer/Eksporter
	,tImporterExporter.Name AS [ImporterExporter]
-- 	22	Zleceniodawca
	,tPrincipal.Name AS [Principal]
-- 	23	Płatnik 
	,tPayer.Name AS [PayerType2]
-- 	24	Numer referencyjny WinSAD
	,tSCC.WinSADNumber
-- 	25	Numer OGL/MRN
	,tSCC.OGLOrMRNNumber
-- 	26	Data odprawy
	,tSCC.ShippingDate
-- 	27	Data odbioru SAD-u/POD
	,tSCC.SADOrPODReceivingDate
-- 	28	Liczba pozycji
	,tSCC.NumberOfPositions
-- 	29	Suma należności celnych - (suma z pól "Kwota" - w tabeli z należnościami celnymi).
	,tSumOfCustomsClearancesPayments.Amount AS [SumOfCustomsClearancesPayments]


FROM
	[schSOA].[tShippingCustomsClearances] tSCC
-- 	1	Czynność - (link do podglądu dyspozycji celnej),
	LEFT JOIN schSOA.tShippingActions tSA
	ON tSCC.ShippingCustomsClearanceId=tSA.ShppingCustomClearanceId
	LEFT JOIN schSOA.tShippingActionMainData tSAMD
	ON tSA.ShippingActionMainDataId=tSAMD.ShippingActionMainDataId
-- 	2	Operacja spedycyjna - (link do podglądu operacji spedycyjnej),
	LEFT JOIN schSOA.tShippingOperationsActions tSOA
	ON tSAMD.ShippingActionMainDataId = tSOA.ShippingActionMainDataId
	LEFT JOIN schSO.tShippingOperations tSO
	ON tSOA.ShippingOperationId = tSO.ShippingOperationId
	LEFT JOIN schSO.tShippingOperationMainData tSOMD
	ON tSO.ShippingOperationMainDataId = tSOMD.ShippingOperationMainDataId
-- 	3	Status czynności
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] [tActionStatus]
	ON tSA.ActionStatusId = tActionStatus.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] [tActionStatusName]
	ON [tActionStatus].[DictionaryItemVersionId] = [tActionStatusName].[DictionaryItemVersionId]
		AND [tActionStatusName].[LanguageDictId] = @LanguageDictId
-- 	4	Data zlecenia straight form tSA
-- 	5	Data przyjęcia do realizacji straight form tSA
-- 	6	Data realizacji straight form tSA
-- 	7	Data zakończenia straight form tSA
-- 	8	Zleceniodawca CHG
	LEFT JOIN schUsers.tUsers tPrincipalCHG
	ON tSA.CreatedUserId = tPrincipalCHG.UserId
-- 	9	Biuro wykonawcy
	LEFT JOIN schSOF.tOffice tOffice
	ON tSA.ContractorOfficeId = tOffice.OfficeId
-- 	10	Kierownik biura wykonawcy
	LEFT JOIN schUsers.tUsers tContractorOfficeManager
	ON tSA.ContractorOfficeManagerId = tContractorOfficeManager.UserId
-- 	11	Tryb odprawy
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] tExpeditionType
	ON tSCC.[ExpeditionTypeId] = tExpeditionType.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] tExpeditionTypeName
	ON tExpeditionType.DictionaryItemVersionId = tExpeditionTypeName.[DictionaryItemVersionId]
		AND tExpeditionTypeName.LanguageDictId = @LanguageDictId
-- 	12	Incoterms
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] tIncoterms
	ON tSCC.[IncotermsId] = tIncoterms.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] tIncotermsName
	ON tIncoterms.DictionaryItemVersionId = tIncotermsName.[DictionaryItemVersionId]
		AND tIncotermsName.LanguageDictId = @LanguageDictId
-- 	13	Rodzaj odprawy
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] tShippingType
	ON tSCC.[ShippingTypeId] = tShippingType.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] tShippingTypeName
	ON tShippingType.DictionaryItemVersionId = tShippingTypeName.[DictionaryItemVersionId]
		AND tShippingTypeName.LanguageDictId = @LanguageDictId
-- 	14	Procedura celna
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] tCustomsProcedure
	ON tSCC.[CustomsProcedureId] = tCustomsProcedure.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] tCustomsProcedureName
	ON tCustomsProcedure.DictionaryItemVersionId = tCustomsProcedureName.[DictionaryItemVersionId]
		AND tCustomsProcedureName.LanguageDictId = @LanguageDictId
-- 	15	Typ zgłoszenia
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] tApplicationType
	ON tSCC.[ApplicationTypeId] = tApplicationType.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] tApplicationTypeName
	ON tApplicationType.DictionaryItemVersionId = tApplicationTypeName.[DictionaryItemVersionId]
		AND tApplicationTypeName.LanguageDictId = @LanguageDictId
-- 	16	Data deadline straight from tSCC
-- 	17	Data E.T.D. straight FROM tSCC
-- 	18	Rodzaj zabezpieczeń
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] tSecurityType
	ON tSCC.[SecurityTypeId] = tSecurityType.[DictionaryItemVersionId]
	LEFT JOIN[schDictionaries].[tDictionaryItemNames] tSecurityTypeName
	ON tSecurityType.DictionaryItemVersionId = tSecurityTypeName.[DictionaryItemVersionId]
		AND tSecurityTypeName.LanguageDictId = @LanguageDictId
-- 	19	Płatnik
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] tPayerType
	ON tSCC.[PayerTypeId] = tPayerType.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] tPayerTypeName
	ON tPayerType.DictionaryItemVersionId = tPayerTypeName.[DictionaryItemVersionId]
		AND tPayerTypeName.LanguageDictId = @LanguageDictId
-- 	20	Miejsce załadunku straight FROM tSCC
-- 	21	Importer/Eksporter
	LEFT JOIN schSO.tShippingOperationMetrics tSOM
	ON tSO.ShippingOperationMetricId = tSOM.ShippingOperationMetricId
	LEFT JOIN (SELECT tS.SubjectId ,tS.Name
	FROM schSubjects.tSubjects tS
	JOIN schSubjects.tSubjectTypes tST
	ON tS.SubjectId=tST.SubjectId
	WHERE tST.TypeDictId=@intImporterExporterDictTypeId) AS tImporterExporter
	ON tSOM.PrincipalSubjectId=tImporterExporter.SubjectId
-- 	22	Zleceniodawca 
	LEFT JOIN (SELECT tS.SubjectId ,tS.Name
	FROM schSubjects.tSubjects tS
	JOIN schSubjects.tSubjectTypes tST
	ON tS.SubjectId=tST.SubjectId
	WHERE tST.TypeDictId=@intPrincipalDictTypeId) AS tPrincipal
	ON tSOM.PrincipalSubjectId=tPrincipal.SubjectId
-- 	23	Płatnik
	LEFT JOIN (SELECT tS.SubjectId ,tS.Name
	FROM schSubjects.tSubjects tS
	JOIN schSubjects.tSubjectTypes tST
	ON tS.SubjectId=tST.SubjectId
	WHERE tST.TypeDictId=@intPayerDictTypeId) AS tPayer
	ON tSOM.PayerSubjectId=tPayer.SubjectId
-- 	24	Numer referencyjny WinSAD straight FROM tSCC
-- 	25	Numer OGL/MRN straight FROM tSCC
-- 	26	Data odprawy straight form tSA
-- 	27	Data odbioru SAD-u/POD straight FROM tSCC
-- 	28	Liczba pozycji straight FROM tSCC
-- 	29	Suma należności celnych - (suma z pól "Kwota" - w tabeli z należnościami celnymi).
	LEFT JOIN (
		SELECT SUM(tSCCP.Amount) AS [Amount] ,tSCCP.ShippingCustomsClearanceId
	FROM schSOA.tShippingCustomsClearancesPayments tSCCP
	GROUP BY tSCCP.ShippingCustomsClearanceId) AS tSumOfCustomsClearancesPayments
	ON tSCC.ShippingCustomsClearanceId=tSumOfCustomsClearancesPayments.ShippingCustomsClearanceId

WHERE tSA.IsActive =1
AND tSO.IsActive =1
'
	--###################  END SELECT   #########################
	--############################################################
	--Agent celny	rozwijalna lista wielokrotnego wyboru z użytkownikami systemu,
	IF(EXISTS(SELECT Id
	FROM @customAgentIds))
	SET @sql = @sql + N'
	AND tSA.ContractorId IN (SELECT Id FROM @customAgentIds)'

	--Status czynności	rozwijalna lista wielokrotnego wyboru ze statusami,
	IF(EXISTS(SELECT Id
	FROM @actionStatusIds))
	SET @sql = @sql + N'
	AND tSA.ActionStatusId IN (SELECT Id FROM @actionStatusIds)'

	-- Importer/eksporter	wyszukiwarka kontrahentów,
	IF((@importerExporterName IS NOT NULL) AND (@importerExporterName <> ''))
SET @sql = @sql + N'
AND tImporterExporter.Name LIKE ''%'' + @importerExporterName + ''%'' '

	--Data zlecenia od do	pole typu data z kalendarzem ułatwiającym wprowadzenia daty.
	IF((@orderDateFrom IS NOT NULL) AND (@orderDateFrom <> ''))
	SET @sql = @sql + N'
	AND tSA.CreatedDate >=@orderDateFrom'

	IF((@orderDateTo IS NOT NULL) AND (@orderDateTo <> ''))
	SET @sql = @sql + N'
	AND tSA.CreatedDate <=@orderDateTo'

	EXEC sp_executesql 
	@sql
	,@paramsDef
	,@languageDictId
	,@customAgentIds
	,@actionStatusIds
	,@importerExporterName
	,@orderDateFrom
	,@orderDateTo
--XXX----------------------------------------------
	,@vcharIDontKnowWhere
	,@intImporterExporterDictTypeId
	,@intPrincipalDictTypeId
	,@intPayerDictTypeId

END
