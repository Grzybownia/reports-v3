-- USE [C_HARTWIG_SO_DEBUG]
USE [C_HARTWIG_SO_DEVEL]
GO
/****** Object:  StoredProcedure [schReports].[prGetOperationLCL]    Script Date: 2018-03-09 12:01:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [schReports].[prGetOperationLCL]
	@languageDictId INT
--	Typ operacji	LCL	eksport/import		Rozwijalna lista wielokrotnego wyboru operacji w zależności od relacji
	,@operationTypeIds [schDictionaries].[IntTable] READONLY
--	Typ operacji	rodzaj	matka/córka/sierota		Rozwijalna lista wielokrotnego wyboru operacji w zależności od rodzaju
	,@operationRelationTypeIds [schDictionaries].[IntTable] READONLY
--	Status operacji				Rozwijalna lista wielokrotnego wyboru ze statusami
	,@operationStatusIds [schDictionaries].[IntTable] READONLY
--	Data otwarcia	od	do		Pole typu data z kalendarzem ułatwiającym wprowadzenie daty
	,@openingDateFrom DATETIME
	,@openingDateTo DATETIME
--	Zleceniodawca				Pole do wprowadzania nazwy Zleceniodawcy (klienta) - podpowiedź 3 znaki
	,@principalName VARCHAR(50)
--	Spedytor				Rozwijalna lista wielokrotnego wyboru spedytorów przypisanych do operacji
	,@shipperNamesIds [schDictionaries].[IntTable] READONLY
--	ETD	od	do		Pole typu data z kalendarzem ułatwiającym wprowadzenie daty
	,@etdFrom DATETIME
	,@etdTo DATETIME
--	ETA	od	do		Pole typu data z kalendarzem ułatwiającym wprowadzenie daty
	,@etaFrom DATETIME
	,@etaTo DATETIME	
--	Port załadunku				Pole do wprowadzania nazwy portu - podpowiedź 3 znaki
	,@loadingPortName VARCHAR(50)
--	Port wyładunku				Pole do wprowadzania nazwy portu - podpowiedź 3 znaki
	,@unloadingPortName VARCHAR(50)
--------------------------------------------------
	,@vcharApplicationAdress VARCHAR(100)
	,@vcharIDontKnowWhere VARCHAR(32)

AS
BEGIN
	DECLARE @sql NVARCHAR(MAX)
	DECLARE @paramsDef NVARCHAR(MAX)
	DECLARE @intBookingActionTypeId INT = (SELECT [DictionaryItemVersionId]
	FROM [schDictionaries].[tDictionaryItemVersions]
	WHERE [DictionaryItemId] = 60001 AND IsActive = 1)
	DECLARE @intSeaFreightActionTypeId INT = (SELECT [DictionaryItemVersionId]
	FROM [schDictionaries].[tDictionaryItemVersions]
	WHERE [DictionaryItemId] IN (180024) AND IsActive = 1)
	DECLARE @intSeaFreightALLINActionTypeId INT = (SELECT [DictionaryItemVersionId]
	FROM [schDictionaries].[tDictionaryItemVersions]
	WHERE [DictionaryItemId] IN (180025) AND IsActive = 1)
	DECLARE @intSeaFreightOtherAdditionActionTypeId INT = (SELECT [DictionaryItemVersionId]
	FROM [schDictionaries].[tDictionaryItemVersions]
	WHERE [DictionaryItemId] IN (180037) AND IsActive = 1)
	DECLARE @intCustomClearanceActionTypeId INT = (SELECT [DictionaryItemVersionId]
	FROM [schDictionaries].[tDictionaryItemVersions]
	WHERE [DictionaryItemId] IN (60002) AND IsActive = 1)
	DECLARE @intFormingActionTypeId INT = (SELECT [DictionaryItemVersionId]
	FROM [schDictionaries].[tDictionaryItemVersions]
	WHERE [DictionaryItemId] IN (60003) AND IsActive = 1)
	DECLARE @intUnformingActionTypeId INT = (SELECT [DictionaryItemVersionId]
	FROM [schDictionaries].[tDictionaryItemVersions]
	WHERE [DictionaryItemId] IN (60004) AND IsActive = 1)
	DECLARE @intUnloadingActionTypeId INT = (SELECT [DictionaryItemVersionId]
	FROM [schDictionaries].[tDictionaryItemVersions]
	WHERE [DictionaryItemId] IN (60005) AND IsActive = 1)
	DECLARE @intLoadingActionTypeId INT = (SELECT [DictionaryItemVersionId]
	FROM [schDictionaries].[tDictionaryItemVersions]
	WHERE [DictionaryItemId] IN (60006) AND IsActive = 1)
	DECLARE @intTransportOrderActionTypeId INT = (SELECT [DictionaryItemVersionId]
	FROM [schDictionaries].[tDictionaryItemVersions]
	WHERE [DictionaryItemId] IN (60007) AND IsActive = 1)
	DECLARE @intLoaderIntoContainerDictItemId INT = (SELECT [DictionaryItemVersionId]
	FROM [schDictionaries].[tDictionaryItemVersions]
	WHERE [DictionaryItemId] IN (170006) AND IsActive = 1)
	DECLARE @intSeaLoaderDictItemId INT = (SELECT [DictionaryItemVersionId]
	FROM [schDictionaries].[tDictionaryItemVersions]
	WHERE [DictionaryItemId] IN (170007) AND IsActive = 1)
	DECLARE @intRecipientDictItemId INT = (SELECT [DictionaryItemVersionId]
	FROM [schDictionaries].[tDictionaryItemVersions]
	WHERE [DictionaryItemId] IN (170004) AND IsActive = 1)

	SET @paramsDef = N'
	@languageDictId INT
	,@operationTypeIds [schDictionaries].[IntTable] READONLY
	,@operationRelationTypeIds [schDictionaries].[IntTable] READONLY
	,@operationStatusIds [schDictionaries].[IntTable] READONLY
	,@openingDateFrom DATETIME
	,@openingDateTo DATETIME
	,@principalName VARCHAR(50)
	,@shipperNamesIds [schDictionaries].[IntTable] READONLY 
	,@etdFrom DATETIME
	,@etdTo DATETIME
	,@etaFrom DATETIME
	,@etaTo DATETIME	
	,@loadingPortName VARCHAR(50)
	,@unloadingPortName VARCHAR(50)
--
	,@vcharApplicationAdress VARCHAR(100)
	,@vcharIDontKnowWhere VARCHAR(32)
	,@intBookingActionTypeId INT
	,@intSeaFreightActionTypeId INT
	,@intSeaFreightALLINActionTypeId INT
	,@intSeaFreightOtherAdditionActionTypeId INT
	,@intCustomClearanceActionTypeId INT
	,@intFormingActionTypeId INT
	,@intUnformingActionTypeId INT
	,@intUnloadingActionTypeId INT
	,@intLoadingActionTypeId INT
	,@intTransportOrderActionTypeId INT
	,@intLoaderIntoContainerDictItemId INT
	,@intSeaLoaderDictItemId INT
	,@intRecipientDictItemId INT
'


	SET @sql = N'
--#############################################################
--################ SELECT BEGIN ###############################
DECLARE @intLCLTypeDictId INT = (SELECT [DictionaryItemVersionId]
FROM [schDictionaries].[tDictionaryItemVersions]
WHERE [DictionaryItemId] = 10001 AND IsActive = 1)

SELECT
	--1	Numer operacji	
	tSOMD.OperationNumber AS [OperationNumber]
--2	Typ operacji	
	,tOperationTypeName.Name AS [OperationType]
--3	Zleceniodawca CRM	
	,tS.CRMNumber AS [PrincipalCRMNumber]
--4	Zleceniodawca NAV	
	,tS.NavisionNumber AS [PrincipalNavisionNumber]
--5	Zleceniodawca Nazwa	
	,tS.Name AS PrincipalName
--6	Zleceniodawca NIP	
	,tS.NIP AS PrincipalNIP
--7	Płatnik 	
	,tP.Name AS PayerName
--8 -------------------------------	Dysponent	
	,tShipper.FullName AS [Owner]
--9	Handlowiec	
	,tTrader.FullName AS [Trader]
--10	MPK	
	,tMPKName.Name AS [MPK]
--11	Numer referencyjny platnika, a jak NULL TO zleceniodawcy
	,tReferenceNumber.RefNum AS [ReferenceNumber]
--12	Typ numeru referencyjnego platnika, a jak NULL TO zleceniodawcy
	,tReferenceNumberTypeName.Name AS [ReferenceNumberType]
--13	Kwota ubezpieczenia	
	,tSOM.InsuranceAmount 
--14	Data gotowości towaru u załadowcy	
	,tSO.DateOfReadiness
--15	ETD	
	,tSO.ETDorATDDate AS [ETD]
--16	ETA	
	,tSO.ETAorATADate AS [ETA]
--17	Miejsce załadunku	
	,tSOM.LoadingPlace
--18	Port załadunku	
	,tLoadingPortName.Name AS [LoadingPort]
--19	Załadowca	Opcje
	,tLoader.Name AS [Loader]
--20	Port wyładunku	
	,tUnloadingPortName.Name AS [UnloadingPort]
--21	Odbiorca	Opcje
	,tRecipient.Name AS [Recipient]
--22	Miejsce dostawy	
	,tSOM.DeliveryPlace
--23	CFS Origin	
	,tCFSOriginName.Name AS [CFSOrigin]
--24	CFS Destination	
	,tCFSDestinationName.Name AS [CFSDestination]
--25	Sprzedaż PL (zł)	suma z pozycji kalkulacji - część sprzedażowa
	,tSCalculationsPositions.SellAmountPLN
--26	Koszty PL (zł)	suma z pozycji kalkulacji - część kosztowa
	,tSCalculationsPositions.PurchaseAmountPLN	
--27	Marża PL (zł)	wynik z pozycji kalkulacji (sprzedaż PL - koszty PL)
--,tSCalculationsPositions.MarginPLN
	,(tSCalculationsPositions.SellAmountPLN-tSCalculationsPositions.PurchaseAmountPLN) AS [MarginPLN]
--28	Rentowność PL (zł)	rentowność kalkulacji (Marża PL/ Sprzedaż PL) - wartość procentowa
	,tSCalculationsPositions.MarginAsPercentage
--29	Sprzedaż (faktury zł)	suma z przypiętych do operacji faktur sprzedażowych
	,tSCalculationsPositions.SalesInvoicesAmountPLN
--30	Koszty (faktury zł)	suma z przypiętych do operacji faktur kosztowych
	,tSCalculationsPositions.PurchaseInvoicesAmountPLN
--31	Marża (faktury zł)	wynik z przypiętych faktur (sprzedaż - koszty)
--,tSCalculations.TotalMarginPercent
	,(tSCalculationsPositions.SalesInvoicesAmountPLN-tSCalculationsPositions.PurchaseInvoicesAmountPLN) AS [MarginInvoicesPLN]
--32	Rentowność (faktury zł)	rentowność operacji (Marża / Sprzedaż) - wartość procentowa
	,(((tSCalculationsPositions.SalesInvoicesAmountPLN-tSCalculationsPositions.PurchaseInvoicesAmountPLN)/tSCalculationsPositions.SalesInvoicesAmountPLN)*100.0) AS [MarginInvoicesAsPercentage]
--33	Operator LCL	dla sierot
	,tLCLOperatorName.Name AS [LCLOperator]
--34	Typ kontenera	z matki dla córek; dla sierot z OS
	,tContainerTypeName.Name AS [ContainerType]
--35	Numer kontenera	z matki dla córek; dla sierot z OS
	,tSContainer.Number
--36	Armator	z matki dla córek; dla sierot z OS
	,tShipownerName.Name AS [Shipowner]
--37	Cargo EN	dla matek pole niewidoczne
	,tSContainer.CargoEn
--38	Ładunek PL	dla matek pole niewidoczne
	,tSContainer.CargoPl
--39	Masa brutto ładunku	suma z córek dla matki,dla córek i sierot z OS
	,tSContainer.GrossWeight
--40	Objętość ładunku	suma z córek dla matki,dla córek i sierot z OS
	,tSContainer.VolumeOfCargo
--41	HS Code	
	,tSContainer.HsCode
--42	Liczba opakowań	
	,tSContainer.NumberOfPackages 
--43	J.M.	
	,tMeasureUnitName.Name AS [MeasureUnit]	
--44	W/M	
	,(CAST(tSCargo.GrossWeight AS VARCHAR(10)) + tGrossWeightUnitName.Name + CAST(tSCargo.VolumeOfCargo AS VARCHAR(10)) + tVolumeOfCargoUnitName.Name) AS [W/M]
--45 Numer operacji córka	dla matek
	,tSOMDDaughters.OperationNumber AS [DaughterOperationNumber]
--46	Numer operacji matka	dla córek
	,tSOMDMother.OperationNumber AS [MotherOperationNumber]
--47 -------------------------------	Fracht morski kwota (sprzedaż/ kalkulacja/ zł)	
	,tSeaFreights.SeaFreightQuota
--48	Buking (numer czynności/ link)	
	,tBooking.ActionNumber AS [BookingLink]
	,tBooking.ShippingActionMainDataId AS [BookingId]
--49 -------------------------------	Dyspozycja celna (numer czynności/ link)	
	,tCustomClearance.ActionNumber AS [CustomClearanceLink]
	,tCustomClearance.ShippingActionMainDataId AS [CustomClearanceId]
--50 -------------------------------	Formowanie (numer czynności/link)	
	,tForming.ActionNumber AS [FormingLink]
	,tForming.ShippingActionMainDataId AS [FormingId]
--51 -------------------------------	Rozformowanie (numer czynności/link)	
	,tUnforming.ActionNumber AS [UnformingLink]
	,tUnforming.ShippingActionMainDataId AS [UnformingId]
--52 -------------------------------	Rozładunek (numer czynności/link)	
	,tUnloading.ActionNumber AS [UnloadingLink]
	,tUnloading.ShippingActionMainDataId AS [UnloadingId]
--53 -------------------------------	Załadunek (numer czynności/link)	
	,tLoading.ActionNumber AS [LoadingLink]
	,tLoading.ShippingActionMainDataId AS [LoadingLinkId]
--54 -------------------------------	Zlecenie transportowe (numer czynności/link)	
	,tTransportOrder.ActionNumber AS [TransportOrderLink]
	,tTransportOrder.ShippingActionMainDataId AS [TransportOrderId]
--55 -------------------------------	Data wykonania usługi	Pole do dodania   / ustalenia (faktury)


FROM
	--all I need
	schSO.tShippingOperationMainData AS tSOMD
	JOIN schSO.tShippingOperations tSO
	ON tSOMD.ShippingOperationMainDataId = tSO.ShippingOperationMainDataId

	--linking tables for many to many	
	LEFT JOIN schSO.tShippingOperationsCalculations tSOC
	ON tSO.ShippingOperationId = tSOC.ShippingOperationId
	LEFT JOIN schSO.tShippingOperationsContainers tSOContainer
	ON tSO.ShippingOperationId = tSOContainer.ShippingOperationId
	LEFT JOIN schSOA.tShippingOperationsActions tSOA --zmienilbym nazwe na tShippingOperationsActionsMainData bo potem laczym z ShippingActionMainDataId
	ON tSO.ShippingOperationId = tSOA.ShippingOperationId
	--------------------------------------------------------------------------------------
	--	1	Numer operacji straight from tSOMD
	--	2	Typ operacji	
	LEFT JOIN schDictionaries.tDictionaryItemVersions tOperationType
	ON tSOMD.DirectionId = tOperationType.DictionaryItemVersionId
	LEFT JOIN schDictionaries.tDictionaryItemNames tOperationTypeName
	ON tOperationType.DictionaryItemVersionId = tOperationTypeName.DictionaryItemVersionId
		AND tOperationTypeName.LanguageDictId = @LanguageDictId
	--	3	Zleceniodawca CRM	
	LEFT JOIN schSO.tShippingOperationMetrics tSOM
	ON tSO.ShippingOperationMetricId = tSOM.ShippingOperationMetricId
	LEFT JOIN schSubjects.tSubjects tS
	ON tSOM.PrincipalSubjectId = tS.SubjectId
	--	4	Zleceniodawca NAV straight from tS joined before
	--	5	Zleceniodawca Nazwa straight from tS joined before
	--	6	Zleceniodawca NIP traight from tS joined before
	--	7	Płatnik 	
	LEFT JOIN schSubjects.tSubjects tP
	ON tSOM.PayerSubjectId = tP.SubjectId
	--	Dysponent	
	LEFT JOIN [schUsers].[tUsers] [tShipper]
	ON [tSOM].[ShipperUserId]= [tShipper].[UserId]
	--	9	Handlowiec	
	LEFT JOIN schUsers.tUsers tTrader
	ON tSOM.TraderId = tTrader.UserId
	--	10	MPK	
	LEFT JOIN schDictionaries.tDictionaryItemVersions tMPK
	ON tSOM.MpkId = tMPK.DictionaryItemVersionId
	LEFT JOIN schDictionaries.tDictionaryItemNames tMPKName
	ON tMPK.DictionaryItemVersionId = tMPKName.DictionaryItemVersionId
		AND tMPKName.LanguageDictId = @LanguageDictId
	--	11	Numer referencyjny platnika, a jak null to zleceniodawcy
	LEFT JOIN (SELECT tSOM.ShippingOperationMetricId
		,ISNULL(tSOM.PayerReferenceNumber, tSOM.PrincipalReferenceNumber) AS RefNum
	FROM schSO.tShippingOperationMetrics tSOM) AS tReferenceNumber
	ON tSOM.ShippingOperationMetricId=tReferenceNumber.ShippingOperationMetricId
	--	12	Typ numeru referencyjnego platnika, a jak NULL TO zleceniodawcy
	LEFT JOIN (SELECT tSOM.ShippingOperationMetricId
	 ,ISNULL(tSOM.PayerReferenceNumberTypeId, tSOM.PrincipalReferenceNumberTypeId) AS RefNumType
	FROM schSO.tShippingOperationMetrics tSOM ) AS tReferenceNumberType
	ON tSOM.ShippingOperationMetricId=tReferenceNumberType.ShippingOperationMetricId
	LEFT JOIN schDictionaries.tDictionaryItemVersions tReferenceNumberTypeDict
	ON tReferenceNumberType.RefNumType = tReferenceNumberTypeDict.DictionaryItemVersionId
	LEFT JOIN schDictionaries.tDictionaryItemNames tReferenceNumberTypeName
	ON tReferenceNumberTypeDict.DictionaryItemVersionId = tReferenceNumberTypeName.DictionaryItemVersionId
		AND tReferenceNumberTypeName.LanguageDictId = @LanguageDictId
	--	13	Kwota ubezpieczenia straight from tSOM joined before
	--	14	Data gotowości towaru u załadowcy straight from tSO joined before
	--	15	ETD--15 straight from tSO joined before
	--	16	ETA--16 straight from tSO joined before
	--	17	Miejsce załadunku straight from tSOM joined before
	--	18	Port załadunku	
	LEFT JOIN schDictionaries.tDictionaryItemVersions tLoadingPort
	ON tSOM.LoadingPortId = tLoadingPort.DictionaryItemVersionId
	LEFT JOIN schDictionaries.tDictionaryItemNames tLoadingPortName
	ON tLoadingPort.DictionaryItemVersionId = tLoadingPortName.DictionaryItemVersionId
		AND tLoadingPortName.LanguageDictId = @LanguageDictId
	--	19 -Załadowca	Opcje
	LEFT JOIN (SELECT tSOS.ShippingOperationId
	 ,tS.Name
	FROM schSO.tShippingOperationsSubjects tSOS
		LEFT JOIN schSO.tShippingOperationsSubjectTypes tSOST
		ON tSOS.ShippingOperationSubjectId=tSOST.ShippingOperationSubjectId
		LEFT JOIN schSubjects.tSubjects tS
		ON tSOS.SubjectId=tS.SubjectId
	WHERE tSOST.SubjectTypeDictId= @intLoaderIntoContainerDictItemId OR tSOST.SubjectTypeDictId= @intSeaLoaderDictItemId) AS tLoader
	ON tSO.ShippingOperationId=tLoader.ShippingOperationId
	--	20	Port wyładunku	
	LEFT JOIN schDictionaries.tDictionaryItemVersions tUnloadingPort
	ON tSOM.UnloadingPortId = tUnloadingPort.DictionaryItemVersionId
	LEFT JOIN schDictionaries.tDictionaryItemNames tUnloadingPortName
	ON tUnloadingPort.DictionaryItemVersionId = tUnloadingPortName.DictionaryItemVersionId
		AND tUnloadingPortName.LanguageDictId = @LanguageDictId
	--	21 -Odbiorca	Opcje	
	LEFT JOIN (SELECT tSOS.ShippingOperationId
	 ,tS.Name
	FROM schSO.tShippingOperationsSubjects tSOS
		LEFT JOIN schSO.tShippingOperationsSubjectTypes tSOST
		ON tSOS.ShippingOperationSubjectId=tSOST.ShippingOperationSubjectId
		LEFT JOIN schSubjects.tSubjects tS
		ON tSOS.SubjectId=tS.SubjectId
	WHERE tSOST.SubjectTypeDictId= @intRecipientDictItemId) AS tRecipient
	ON tSO.ShippingOperationId=tLoader.ShippingOperationId
	--	22	Miejsce dostawy--22 straight from tSOM joined before
	--	23	CFS Origin	
	LEFT JOIN schDictionaries.tDictionaryItemVersions tCFSOrigin
	ON tSOM.CFSOriginId = tCFSOrigin.DictionaryItemVersionId
	LEFT JOIN schDictionaries.tDictionaryItemNames tCFSOriginName
	ON tCFSOrigin.DictionaryItemVersionId = tCFSOriginName.DictionaryItemVersionId
		AND tCFSOriginName.LanguageDictId = @LanguageDictId
	--	24	CFS Destination	
	LEFT JOIN schDictionaries.tDictionaryItemVersions tCFSDestination
	ON tSOM.CFSDestinationId = tCFSDestination.DictionaryItemVersionId
	LEFT JOIN schDictionaries.tDictionaryItemNames tCFSDestinationName
	ON tCFSDestination.DictionaryItemVersionId = tCFSDestinationName.DictionaryItemVersionId
		AND tCFSDestinationName.LanguageDictId = @LanguageDictId
	--	25	Sprzedaż PL (zł)	suma z pozycji kalkulacji - część sprzedażowa
	LEFT JOIN schSO.tShippingCalculations tSCalculations
	ON tSOC.ShippingCalculationId = tSCalculations.ShippingCalculationId
	LEFT JOIN schSO.tShippingCalculationPositions tSCalculationsPositions
	ON tSCalculations.ShippingCalculationId = tSCalculationsPositions.ShippingCalculationId
	--	26	Koszty PL (zł)	suma z pozycji kalkulacji - część kosztowa--26 straight from tSCalculationsPositions joined before
	--	27	Marża PL (zł)	wynik z pozycji kalkulacji (sprzedaż PL - koszty PL)--27 straight from tSCalculations joined before
	--	28	Rentowność PL (zł)	rentowność kalkulacji (Marża PL/ Sprzedaż PL) - wartość procentowa--28 straight from tSCalculations joined before
	--	29	Sprzedaż (faktury zł)	suma z przypiętych do operacji faktur sprzedażowych--29 straight from tSCalculations joined before
	--	30	Koszty (faktury zł)	suma z przypiętych do operacji faktur kosztowych--30 straight from tSCalculations joined before
	--	31	Marża (faktury zł)	wynik z przypiętych faktur (sprzedaż - koszty)--31 straight from tSCalculations joined before
	--	32	Rentowność (faktury zł)	rentowność operacji (Marża / Sprzedaż) - wartość procentowa - computed in before
	--	33	Operator LCL	dla sierot
	LEFT JOIN schSO.tShippingContainers tSContainer
	ON tSOContainer.ShippingContainerId = tSContainer.ShippingContainerId
	LEFT JOIN schDictionaries.tDictionaryItemVersions tLCLOperator
	ON tSContainer.LCLOperatorId = tLCLOperator.DictionaryItemVersionId
	LEFT JOIN schDictionaries.tDictionaryItemNames tLCLOperatorName
	ON tLCLOperator.DictionaryItemVersionId = tLCLOperatorName.DictionaryItemVersionId
		AND tLCLOperatorName.LanguageDictId = @LanguageDictId
	--	34	Typ kontenera	z matki dla córek; dla sierot z OS
	LEFT JOIN schDictionaries.tDictionaryItemVersions tContainerType
	ON tSContainer.CargoTypeId = tContainerType.DictionaryItemVersionId --zmienilbym nazwe CargoTypeId na tContainerTypeId bo chyba o typ kontenra chodzi
	LEFT JOIN schDictionaries.tDictionaryItemNames tContainerTypeName
	ON tContainerType.DictionaryItemVersionId = tContainerTypeName.DictionaryItemVersionId
		AND tContainerTypeName.LanguageDictId = @LanguageDictId
	--	35	Numer kontenera	z matki dla córek; dla sierot z OS straight from tSContainer joined before
	--	36	Armator	z matki dla córek; dla sierot z OS
	LEFT JOIN schDictionaries.tDictionaryItemVersions tShipowner
	ON tSContainer.ArmatorId = tShipowner.DictionaryItemVersionId
	LEFT JOIN schDictionaries.tDictionaryItemNames tShipownerName
	ON tShipowner.DictionaryItemVersionId = tShipownerName.DictionaryItemVersionId
		AND tShipownerName.LanguageDictId = @LanguageDictId
	--	37	Cargo EN	dla matek pole niewidoczne straight from tSContainer joined before
	--	38	Ładunek PL	dla matek pole niewidoczne straight from tSContainer joined before
	--	39	Masa brutto ładunku	suma z córek dla matki,dla córek i sierot z OS straight from tSContainer joined before
	--	40	Objętość ładunku	suma z córek dla matki,dla córek i sierot z OS straight from tSContainer joined before
	--	41	HS Code straight from tSContainer joined before
	--	42	Liczba opakowań straight from tSContainer joined before
	--	43	J.M.	
	LEFT JOIN schDictionaries.tDictionaryItemVersions tMeasureUnit
	ON tSContainer.UnitOfMeasureId = tMeasureUnit.DictionaryItemVersionId
	LEFT JOIN schDictionaries.tDictionaryItemNames tMeasureUnitName
	ON tMeasureUnit.DictionaryItemVersionId = tMeasureUnitName.DictionaryItemVersionId
		AND tMeasureUnitName.LanguageDictId = @LanguageDictId
	--	44	W/M	
	LEFT JOIN schSO.tShippingCargos tSCargo
	ON tSOContainer.ShippingContainerId = tSCargo.ShippingContainerId
	LEFT JOIN schDictionaries.tDictionaryItemVersions tGrossWeightUnit
	ON tSCargo.GrossWeightUnitDictId = tGrossWeightUnit.DictionaryItemVersionId
	LEFT JOIN schDictionaries.tDictionaryItemNames tGrossWeightUnitName
	ON tGrossWeightUnit.DictionaryItemVersionId = tGrossWeightUnitName.DictionaryItemVersionId
		AND tGrossWeightUnitName.LanguageDictId = @LanguageDictId
	LEFT JOIN schDictionaries.tDictionaryItemVersions tVolumeOfCargoUnit
	ON tSCargo.VolumeOfCargoUnitDictId = tVolumeOfCargoUnit.DictionaryItemVersionId
	LEFT JOIN schDictionaries.tDictionaryItemNames tVolumeOfCargoUnitName
	ON tVolumeOfCargoUnit.DictionaryItemVersionId = tVolumeOfCargoUnitName.DictionaryItemVersionId
		AND tVolumeOfCargoUnitName.LanguageDictId = @LanguageDictId
	--	45 Numer operacji córka	dla matek
	LEFT JOIN(SELECT
		tsomd.OperationNumber
		,tso.ParentOperationMainDataId
	FROM
		[schSO].[tShippingOperationMainData] tsomd
		LEFT JOIN [schSO].[tShippingOperations] tso
		ON tsomd.ShippingOperationMainDataId = tso.ShippingOperationMainDataId) AS tSOMDDaughters
	ON tSOMD.ShippingOperationMainDataId= tSOMDDaughters.ParentOperationMainDataId
	--	46	Numer operacji matka	dla córek
	LEFT JOIN schSO.tShippingOperationMainData tSOMDMother
	ON tSO.ParentOperationMainDataId = tSOMDMother.ShippingOperationMainDataId
	--	47 Fracht morski kwota (sprzedaż/ kalkulacja/ zł)	
	LEFT JOIN
	(SELECT
		tSC.TotalSalesAmount AS [SeaFreightQuota]
	,tSC.ShippingCalculationId
	FROM
		schSO.tShippingCalculations tSC
		LEFT JOIN schSO.tShippingCalculationPositions tSCP
		ON tSC.ShippingCalculationId=tSCP.ShippingCalculationId
	WHERE (
		tSCP.CalculationPositionTypeId = @intSeaFreightActionTypeId 
		OR tSCP.CalculationPositionTypeId = @intSeaFreightALLINActionTypeId 
		OR tSCP.CalculationPositionTypeId = @intSeaFreightOtherAdditionActionTypeId)	
	AND tSCP.IsActive=1)
AS [tSeaFreights]
	ON tSCalculations.ShippingCalculationId = tSeaFreights.ShippingCalculationId
	--	48	Buking (numer czynności/ link)	
	LEFT JOIN schSOA.tShippingActionMainData tBooking
	ON tSOA.ShippingActionMainDataId = tBooking.ShippingActionMainDataId
		AND tBooking.ActionTypeId = @intBookingActionTypeId
	--	49	Dyspozycja celna (numer czynności/ link)	
	LEFT JOIN schSOA.tShippingActionMainData tCustomClearance
	ON tSOA.ShippingActionMainDataId = tCustomClearance.ShippingActionMainDataId
		AND tCustomClearance.ActionTypeId = @intCustomClearanceActionTypeId
	--	50	Formowanie (numer czynności/link)	
	LEFT JOIN schSOA.tShippingActionMainData tForming
	ON tSOA.ShippingActionMainDataId = tForming.ShippingActionMainDataId
		AND tForming.ActionTypeId = @intFormingActionTypeId
	--	51	Rozformowanie (numer czynności/link)
	LEFT JOIN schSOA.tShippingActionMainData tUnforming
	ON tSOA.ShippingActionMainDataId = tUnforming.ShippingActionMainDataId
		AND tUnforming.ActionTypeId = @intUnformingActionTypeId
	--	52	Rozładunek (numer czynności/link)	
	LEFT JOIN schSOA.tShippingActionMainData tUnloading
	ON tSOA.ShippingActionMainDataId = tUnloading.ShippingActionMainDataId
		AND tUnloading.ActionTypeId = @intUnloadingActionTypeId
	--	53	Załadunek (numer czynności/link)	
	LEFT JOIN schSOA.tShippingActionMainData tLoading
	ON tSOA.ShippingActionMainDataId = tLoading.ShippingActionMainDataId
		AND tLoading.ActionTypeId = @intLoadingActionTypeId
	--	54	Zlecenie transportowe (numer czynności/link)	
	LEFT JOIN schSOA.tShippingActionMainData tTransportOrder
	ON tSOA.ShippingActionMainDataId = tTransportOrder.ShippingActionMainDataId
		AND tTransportOrder.ActionTypeId = @intTransportOrderActionTypeId
--	55 -------------------------------	Data wykonania usługi	Pole do dodania   / ustalenia (faktury)

WHERE tSOMD.OperationTypeId = @intLCLTypeDictId AND tSO.IsActive = 1
'
	--################ SELECT END ###############################
	--###########################################################


	--############################################################
	--###################  BEGIN Filters   #########################
	--	Typ operacji	LCL	eksport/import		Rozwijalna lista wielokrotnego wyboru operacji w zależności od relacji
	IF(EXISTS(SELECT Id
	FROM @operationTypeIds))	
	SET @sql = @sql + N'
	AND [tSOMD].[DirectionId] IN (SELECT Id FROM @operationTypeIds)'

	--	Typ operacji	rodzaj	matka/córka/sierota		Rozwijalna lista wielokrotnego wyboru operacji w zależności od rodzaju
	IF(EXISTS(SELECT Id
	FROM @operationRelationTypeIds))
	SET @sql = @sql + N'
	AND [tSOMD].[RelationTypeId] IN (SELECT Id FROM @operationRelationTypeIds)'

	--	Status operacji				Rozwijalna lista wielokrotnego wyboru ze statusami
	IF(EXISTS(SELECT Id
	FROM @operationStatusIds))
	SET @sql = @sql + N'
	AND [tSOM].[OperationStatusId] IN (SELECT Id FROM @operationStatusIds)'

	--	Data otwarcia	od	do		Pole typu data z kalendarzem ułatwiającym wprowadzenie daty
	-- no data to filter

	--	Zleceniodawca				Pole do wprowadzania nazwy Zleceniodawcy (klienta) - podpowiedź 3 znaki
	IF((@principalName IS NOT NULL) AND (@principalName <> ''))
	SET @sql = @sql + N'
	AND tS.Name LIKE ''%'' + @principalName + ''%'' '

	--	Spedytor				Rozwijalna lista wielokrotnego wyboru spedytorów przypisanych do operacji
	IF(EXISTS(SELECT Id
	FROM @shipperNamesIds))
	SET @sql = @sql + N'
	AND [tSOM].[ShipperUserId] IN (SELECT Id FROM @shipperNamesIds)'

	--ETA and ETD all nulls, comment this filter
	--	ETD	od	do		Pole typu data z kalendarzem ułatwiającym wprowadzenie daty
	IF((@etdFrom IS NOT NULL) AND (@etdFrom <> ''))
	SET @sql = @sql + N'
	AND tSO.ETDorATDDate >=@etdFrom'

	IF((@etdTo IS NOT NULL) AND (@etdTo <> ''))
	SET @sql = @sql + N'
	AND tSO.ETDorATDDate <=@etdTo'

	--	ETA	od	do		Pole typu data z kalendarzem ułatwiającym wprowadzenie daty
	IF((@etaFrom IS NOT NULL) AND (@etaFrom <> ''))
	SET @sql = @sql + N'
	AND tSO.ETAorATADate >=@etaFrom'

	IF((@etaTo IS NOT NULL) AND (@etaTo <> ''))
	SET @sql = @sql + N'
	AND tSO.ETAorATADate <=@etaTo'

	--	Port załadunku				Pole do wprowadzania nazwy portu - podpowiedź 3 znaki
	IF((@loadingPortName IS NOT NULL) AND (@loadingPortName <> ''))
	SET @sql = @sql + N'
	AND [tLoadingPortName].[Name] LIKE ''%'' + @loadingPortName + ''%'' '

	--	Port wyładunku				Pole do wprowadzania nazwy portu - podpowiedź 3 znaki
	IF((@unloadingPortName IS NOT NULL) AND (@unloadingPortName <> ''))
	SET @sql = @sql + N'
	AND [tUnloadingPortName].[Name] LIKE ''%'' + @unloadingPortName + ''%'' '

	--###################  END Filters   #########################
	--############################################################

	EXEC sp_executesql 
	@sql
	,@paramsDef
	,@languageDictId
	,@operationTypeIds
	,@operationRelationTypeIds
	,@operationStatusIds
	,@openingDateFrom
	,@openingDateTo
	,@principalName 
	,@shipperNamesIds
	,@etdFrom
	,@etdTo
	,@etaFrom
	,@etaTo
	,@loadingPortName
	,@unloadingPortName
--
	,@vcharApplicationAdress
	,@vcharIDontKnowWhere
	,@intBookingActionTypeId
	,@intSeaFreightActionTypeId
	,@intSeaFreightALLINActionTypeId
	,@intSeaFreightOtherAdditionActionTypeId
	,@intCustomClearanceActionTypeId
	,@intFormingActionTypeId
	,@intUnformingActionTypeId
	,@intUnloadingActionTypeId
	,@intLoadingActionTypeId
	,@intTransportOrderActionTypeId
	,@intLoaderIntoContainerDictItemId
	,@intSeaLoaderDictItemId
	,@intRecipientDictItemId
END
