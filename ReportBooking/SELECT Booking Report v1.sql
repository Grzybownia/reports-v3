USE [C_HARTWIG_SO_DEVEL]

DECLARE @intLCLTypeDictId INT = (SELECT [DictionaryItemVersionId]
FROM [schDictionaries].[tDictionaryItemVersions]
WHERE [DictionaryItemId] = 10001 AND IsActive = 1)
DECLARE @LanguageDictId INT = 440001
-- polski,przekazywane jako parametr z aplikacji
DECLARE @vcharApplicationAdress VARCHAR(100) = 'http://hartwig-so/ShippingOperation/Preview/'
DECLARE @vcharIDontKnowWhere VARCHAR(32) = '>idk where??<'

DECLARE @intBookingDictItemId INT = (SELECT [DictionaryItemVersionId]
FROM [schDictionaries].[tDictionaryItemVersions]
WHERE [DictionaryItemId] IN (60001) AND IsActive = 1)
DECLARE @intBookingConfirmationDictItemId INT = (SELECT [DictionaryItemVersionId]
FROM [schDictionaries].[tDictionaryItemVersions]
WHERE [DictionaryItemId] IN (60008) AND IsActive = 1)

SELECT
	--1 Numer czynności
	[tSAMD].[ActionNumber]
--2 Typ operacji
	,[tOperationTypeName].[Name] AS [OperationType]
--3 Numer operacji
	,[tSOMD].[OperationNumber]
--4 Data zlecenia
	,[tSAMD].CreatedDate AS [OrderDate]
--5 Data przyjęcia do realizacji
	,[tSA].[AcceptanceDate]
--6 Data realizacji
	,[tSA].[RealizationDate]
--7 Data zakończenia
	,[tSA].[EndDate]
--8 Zleceniodawca CRM
	,[tS].[CRMNumber] AS [PrincipalCRMNumber]
--9 Zleceniodawca NAV
	,[tS].[NavisionNumber] AS [PrincipalNavisionNumber]
--10 Zleceniodawca Nazwa
	,[tS].[Name] AS [PrincipalName]
--11 Zleceniodawca NIP
	,[tS].[NIP] AS [PrincipalNIP]
--12 Odbiorca
	,[tReceiverName].[Name] AS [Receiver]
--13 Dostawca
	,[tContractor].[FullName] AS [Contractor]
--14 MPK
	,[tMPKName].[Name] AS [MPK]
--15 Spedytor
	,[tShipper].[FullName] AS [Shipper]
--16 Miejsce załadunku
	,[tSB].[LoadingPlace]
--17 Port załadunku
	,[tLoadingPortName].[Name] AS [LoadingPort]
--18 Port wyładunku
	,[tUnloadingPortName].[Name] AS [UnloadingPort]
--19 Miejsce dostawy
	,[tSB].[DeliveryPlace]
--20 Liczba kontenerów
	,[tSA].[NumberOfContainers]
--21 Armator
	,tShipowner.Name AS [Shipowner]
--22 Stawka/numer referencyjny
	,tSB.ReferenceNumber AS [RateRefNumber]
--23 Agent
	,[tAgent].[Name] AS [Agent]
--24 Cargo EN
	,[tSContainer].[CargoEn]
--25 Ładunek PL
	,[tSContainer].[CargoPl]
--26 HS Code
	,[tSContainer].[HsCode]
--27 L].[ opakowań
	,[tSContainer].[NumberOfPackages]
--28 J].[M].[
	,[tMeasureUnitName].[Name] AS [MeasureUnit]
--29 Masa brutto ładunku
	,[tSContainer].[GrossWeight]
--30 Objętość ładunku
	,[tSContainer].[VolumeOfCargo]
--31 Typ kontenera
	,[tContainerTypeName].[Name] AS [ContainerType]
--32 Numer kontenera
	,[tSContainer].[Number] AS [ContainerNumber]
--33 Potwierdzenie bookingu (link)
	--,@vcharApplicationAdress + CAST ([tSA].[ShippingBookingConfirmationId] AS VARCHAR (10)) AS [BookingConfirmationLink]
	-- ,tSBConfirmation.ActionNumber AS [BookingConfirmationLink]
	-- ,tSBConfirmation.ShippingActionMainDataId AS [BookingConfirmationId]
	,tSBConfirmation.BookingMainId AS [BookingConfirmationId]
	,tSBConfirmationMD.ActionNumber AS [BookingConfirmationLink]
--34 CUT OFF CARGO CY
	,[tSB].CutOff  AS [CutoffCargoCY]
--35 CUT OFF VGM
	,[tSB].[CutOffVGM]
--36 CUT OFF DOKUMENTY
	,[tSB].[CutOffDocumentation]
--37 ETD
	,[tSB].[Etd]
--38 ETA
	,[tSB].[Eta]
--39Statek
	,tSRP.FreightShip AS [Ship]
--40 Nr bukingu
	,[tSRP].[FreightBookingNumber]
--41 Nr kontraktu/kwotowania
	,[tSRP].[FreightContractNumber] AS [ContractNumber/QuotationNumber]
--42----------------------------------------FCL cut off
	,tSRP.FreightFclCutoff AS [FCLcutOFF]
--43 VGM cut off
	,tSRP.FreightVgmCutoff AS [VGMCutOff]
--44----------------------------------------SI cut off
	,tSRP.FreightSiCutoff AS [SICutOff]

FROM
	--all I need
	[schSOA].[tShippingBookings] AS [tSB]
	--1 Numer czynności
	-- RIGHT JOIN [schSOA].[tS]hippingActionMainData] [tSAMD]
	LEFT JOIN [schSOA].[tShippingActionMainData] [tSAMD]
	ON [tSB].[BookingMainId] = [tSAMD].[ShippingActionMainDataId]
		AND [tSAMD].[ActionTypeId] = @intBookingDictItemId
	--2 Typ operacji
	JOIN [schSOA].[tShippingOperationsActions] [tSOA]
	ON [tSAMD].[ShippingActionMainDataId] = [tSOA].[ShippingActionMainDataId]
	JOIN [schSO].[tShippingOperations] [tSO]
	ON [tSOA].[ShippingOperationId] = [tSO].[ShippingOperationId]
	JOIN [schSO].[tShippingOperationMainData] [tSOMD]
	ON [tSO].[ShippingOperationMainDataId] = [tSOMD].[ShippingOperationMainDataId]
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] [tOperationType]
	ON [tSOMD].[OperationTypeId] = [tOperationType].[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] [tOperationTypeName]
	ON [tOperationType].[DictionaryItemVersionId] = [tOperationTypeName].[DictionaryItemVersionId]
		AND [tOperationTypeName].[LanguageDictId] = @LanguageDictId
	--3 Numer operacji straight from [tSOMD]
	--4 Data zlecenia straight from [tSAMD]
	--5 Data przyjęcia do realizacji
	JOIN [schSOA].[tShippingActions] [tSA]
	ON [tSAMD].[ShippingActionMainDataId] = [tSA].[ShippingActionMainDataId]
	--6 Data realizacji straight from [tSA]
	--7 Data zakończenia straight from [tSA]
	--8 Zleceniodawca CRM
	JOIN [schSO].[tShippingOperationMetrics] [tSOM]
	ON [tSO].[ShippingOperationMetricId] = [tSOM].[ShippingOperationMetricId]
	LEFT JOIN [schSubjects].[tSubjects] [tS]
	ON [tSOM].[PrincipalSubjectId] = [tS].[SubjectId]
	--9 Zleceniodawca NAV straight from [tS]
	--10 Zleceniodawca Nazwa straight from [tS]
	--11 Zleceniodawca NIP straight from [tS]
	--12 Odbiorca
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] [tReceiver]
	ON [tSB].[BookingReceiverDictId] = [tReceiver].[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] [tReceiverName]
	ON [tReceiver].[DictionaryItemVersionId] = [tReceiverName].[DictionaryItemVersionId]
		AND [tReceiverName].[LanguageDictId] = @LanguageDictId
	--13 Dostawca
	LEFT JOIN [schUsers].[tUsers] [tContractor]
	ON [tSA].[ContractorId] = [tContractor].[UserId]
	--14 MPK
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] [tMPK]
	ON [tSOM].[MpkId] = [tMPK].[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] [tMPKName]
	ON [tMPK].[DictionaryItemVersionId] = [tMPKName].[DictionaryItemVersionId]
		AND [tMPKName].[LanguageDictId] = @LanguageDictId
	--15 Spedytor
	LEFT JOIN [schUsers].[tUsers] [tShipper]
	ON [tSOM].[ShipperUserId]= [tShipper].[UserId]
	--16 Miejsce załadunku straight from [tSB]
	--17 Port załadunku
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] [tLoadingPort]
	ON [tSB].[LoadingPortDictId] = [tLoadingPort].[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] [tLoadingPortName]
	ON [tLoadingPort].[DictionaryItemVersionId] = [tLoadingPortName].[DictionaryItemVersionId]
		AND [tLoadingPortName].[LanguageDictId] = @LanguageDictId
	--18 Port wyładunku
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] [tUnloadingPort]
	ON [tSB].[UnloadingPortDictId] = [tUnloadingPort].[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] [tUnloadingPortName]
	ON [tUnloadingPort].[DictionaryItemVersionId] = [tUnloadingPortName].[DictionaryItemVersionId]
		AND [tUnloadingPortName].[LanguageDictId] = @LanguageDictId
	--19 Miejsce dostawy straight from [tSB]
	--20 Liczba kontenerów straight from [tSA]
	--21 Armator
	LEFT JOIN schSubjects.tSubjects tShipowner
	ON tSB.ShipownerId = tShipowner.SubjectId
	--22 Stawka/numer referencyjny straight from [tSB]
	--23 Agent
	LEFT JOIN [schSubjects].[tSubjects] [tAgent]
	ON [tSB].[AgentDictId] = [tAgent].[SubjectId]
	--24 Cargo EN
	LEFT JOIN [schSO].[tShippingOperationsContainers] [tSOC]
	ON [tSO].[ShippingOperationId] = [tSOC].[ShippingOperationId]
	LEFT JOIN [schSO].[tShippingContainers] [tSContainer]
	ON [tSOC].[ShippingContainerId] = [tSContainer].[ShippingContainerId]
	--25 Ładunek PL straight from [tSContainer
	--26 HS Code straight from [tSContainer
	--27 L].[ opakowań straight from [tSContainer
	--28 J.M
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] [tMeasureUnit]
	ON [tSContainer].[UnitOfMeasureId] = [tMeasureUnit].[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] [tMeasureUnitName]
	ON [tMeasureUnit].[DictionaryItemVersionId] = [tMeasureUnitName].[DictionaryItemVersionId]
		AND [tMeasureUnitName].[LanguageDictId] = @LanguageDictId
	--29 Masa brutto ładunku straight from [tSContainer
	--30 Objętość ładunku straight from [tSContainer
	--31 Typ kontenera
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] [tContainerType]
	ON [tSContainer].[CargoTypeId] = [tContainerType].[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] [tContainerTypeName]
	ON [tContainerType].[DictionaryItemVersionId] = [tContainerTypeName].[DictionaryItemVersionId]
		AND [tContainerTypeName].[LanguageDictId] = @LanguageDictId
	--32 Numer kontenera straight from [tSContainer
	--33 Potwierdzenie bookingu (link)
	-- LEFT JOIN schSOA.tShippingActionMainData tSBConfirmation
	-- 	ON tSA.BookingNumber = tSBConfirmation.ShippingActionMainDataId
	-- 		AND tSBConfirmation.ActionTypeId = @intBookingConfirmationDictItemId
	LEFT JOIN schSOA.tShippingBookings tSBConfirmation
	ON tSA.ShippingBookingConfirmationId = tSBConfirmation.ShippingBookingId
	LEFT JOIN schSOA.tShippingActionMainData tSBConfirmationMD
	ON tSBConfirmation.BookingMainId = tSBConfirmationMD.ShippingActionMainDataId
	--34 CUT OFF CARGO CY straight from [tSA]
	--35 CUT OFF VGM straight from [tSB]
	--36 CUT OFF DOKUMENTY straight from [tSB]
	--37 ETD straight from [tSB]
	--38 ETA straight from [tSB]
	--39----------------------------------------Statek
	LEFT JOIN schSO.tShippingOperationsRoutePositions tSORP
	ON tSO.ShippingOperationId=tSORP.ShippingOperationId
	LEFT JOIN [schSO].[tShippingRoutePositions] tSRP
	ON tSORP.ShippingRoutePositionId=tSRP.ShippingRoutePositionId
--40 Nr bukingu straight from [tSB]
--41 Nr kontraktu/kwotowania straight FROM tSRP
--42 FCL cut off straight FROM tSRP
--43 VGM cut off straight from [tSB]
--44 SI cut off straight FROM tSRP

WHERE tSA.IsActive =1
	--AND tSO.IsActive = 1
	--AND tSA.ShippingActionId=7512
	AND tSAMD.ActionNumber LIKE '%BK0263/2018%'
--and tSBCMD.ActionNumber LIKE '%BC0106/2018%'
--and [FreightBookingNumber] like '%BK49834uhf%'

ORDER BY tSBConfirmationMD.ActionNumber DESC
	-- OrderDate2 desc,
	--  OrderDate3 desc,
	--  OrderDate4 desc,
	--  OrderDate5 desc


