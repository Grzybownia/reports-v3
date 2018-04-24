USE [C_HARTWIG_SO_DEVEL]
-- z procedury [schSO].[PrGetLclcShippingOperationsBySC]

DECLARE @languageDictId INT = 440001
-- polski,przekazywane jako parametr z aplikacji
DECLARE @vcharApplicationAdress VARCHAR(100) = 'http://hartwig-so/ShippingOperation/Preview/'
DECLARE @vcharIDontKnowWhere VARCHAR(32) = '>idk where??<'
--

SELECT
	--1 Numer czynności
	tSAMD.ActionNumber
--2 Typ operacji
	,tOperationTypeName.Name AS [OperationType]
--3 Numer operacji
	,tSOMD.OperationNumber
--4 Zleceniodawca CRM
	,tS.CRMNumber AS [PricipalCRMNumber]
--5 Zleceniodawca NAV
	,tS.NavisionNumber AS [PricipalNavisionNumber]
--6 Zleceniodawca Nazwa
	,tS.Name AS [PricipalName]
--7 Zleceniodawca NIP
	,tS.NIP AS [PricipalNIP]
--8 Zleceniodawca CHG
	,tPrincipalCHG.FullName AS [PrincipalCHG]
--9 Wykonawca CHG
	,tContractorCHG.FullName AS [ContractorCHG]
--10 Typ transportu
	,tTransportTypeName.Name AS [TransportType]
--11 Miejsce podjęcia pustego/pełnego kontenera
	,tSTO.FullContainerPickupPlace AS [EmptyFullContainerPickupPlace]
--12 Numer referencyjny kontenera
	,tSContainers.RefNumber AS [ContainerRefNumber]
--13 Data podjęcia kontenera
	,tSTO.FullContainerPickupDate AS [ContainerPickupDate]
--14 Miejsce załadunku
	,tSTO.LoadingPlace
--15 Rodzaj odprawy celnej
	,tCustomClearanceTypeName.Name AS[CustomClearanceType]
--16 Miejsce odprawy celnej
	,tCustomClearancePlaceName.Name AS [CustomClearancePlace]
--17 Agencja celna
	,tSTO.CustomsAgency
--18 Miejsce podjecia kontenera (!!! is it duplicated with 11? -KM)
	,tSTO.FullContainerPickupPlace AS [ContainerPickupPlace]
--19 Data podjecia kontenera (!!! is it duplicated with 13? -KM)
	,tSTO.FullContainerPickupDate AS [ContainerPickupDate2]
--20 Miejsce rozładunku sam/naczepy
	,tSTOUP.UnloadingPlace AS [UnloadingPlaceCarTrailer]
--21 Data rozładunku sam/naczepy
	,tSTOUP.UnloadingDate AS [UnloadingDateCarTrailer]
--22 Data załadunku kontenera 
	,tSTO.LoadingDate AS [ContainerLoadingDate]
--23 Miejsce ważeniw VGM
	,tVGMWeighingPlaceName.Name AS [VGMWeighingPlace]
--24 Data ważenia
	,tSTO.WeighingDate
--25 Miejsce złożenia kontenera
	,tSTO.FullContainerDeliveryPlace
--26 Numer referencyjny 
	,tSTO.PortSubmissionRefNumber AS [RefNumber]
--27 Termin najwcześniejszego złożenia
	,tSTO.PortSubmissionEarliestDate AS [EarliestOrderTime]
--28  Termin najpóźniejszego złożenia
	,tSTO.PortSubmissionLatestDate AS [LatestOrderTime]
--29 Numer bookingu
	,tSB.BookingNumber
--30 Armator
	,tShipownerName.Name AS [Shipowner]
--31 Numer kontenera
	,tSContainers.Number AS [ContainerName]
--32 --XXX--------------------------- Przewoźnik
	,tShipper.Name AS [Shipper]
--33 Kierowca
	,tSAD.DriverName
--34 Nr dowodu os kierowcy
	,tSAD.DriverIdNumber
--35 Email kierowcy
	,tSAD.DriverEmail
--36 Telefon kierowcy
	,tSAD.DriverPhoneNumber
--37 Stawka sprzedażowa
	,tSTO.SalesRate
--38 Stawka kosztowa
	,tSTO.CostRate
--39 Nr rejestracyjny ciągnika/samochodu
	,tSAD.CarRegistrationNumber
--40 Nr rejestracyjny naczepy/ przyczepy
	,tSAD.TrailerRegistrationNumber

FROM
	[schSOA].[tShippingTransportOrders] AS tSTO
	--1 Numer czynności
	LEFT JOIN [schSOA].[tShippingActions] tSA
	ON tSTO.ShippingTransportOrderId = tSA.ShippingTransportOrderId
	LEFT JOIN [schSOA].[tShippingActionMainData] tSAMD
	ON tSA.ShippingActionMainDataId= tSAMD.ShippingActionMainDataId
	--2 Typ operacji	
	LEFT JOIN [schSOA].[tShippingOperationsActions] tSOA
	ON tSAMD.ShippingActionMainDataId = tSOA.ShippingActionMainDataId
	LEFT JOIN [schSO].[tShippingOperations] tSO
	ON tSOA.ShippingOperationId = tSO.ShippingOperationId
	LEFT JOIN [schSO].[tShippingOperationMainData] tSOMD
	ON tSO.ShippingOperationMainDataId = tSOMD.ShippingOperationMainDataId
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] tOperationType
	ON tSOMD.OperationTypeId = tOperationType.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] tOperationTypeName
	ON tOperationType.[DictionaryItemVersionId] = tOperationTypeName.[DictionaryItemVersionId]
		AND tOperationTypeName.[LanguageDictId] = @languageDictId
	--3 Numer operacji straight from tSOMD
	--4 Zleceniodawca CRM
	LEFT JOIN [schSubjects].[tSubjects] tS
	ON tSTO.SubjectId = tS.SubjectId
	--5 Zleceniodawca NAV straight from tS straight from tS
	--6 Zleceniodawca Nazwa straight from tS
	--7 Zleceniodawca NIP straight from tS
	--8Zleceniodawca CHG	
	LEFT JOIN schUsers.tUsers tPrincipalCHG
	ON tSAMD.CreatedUserId=tPrincipalCHG.UserId
	--9 Wykonawca CHG
	LEFT JOIN schUsers.tUsers tContractorCHG
	ON tSA.CreatedUserId=tContractorCHG.UserId
	--10 Typ transportu
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] tTransportType
	ON tSTO.TransportTypeId = tTransportType.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] tTransportTypeName
	ON tTransportType.[DictionaryItemVersionId] = tTransportTypeName.[DictionaryItemVersionId]
		AND tTransportTypeName.[LanguageDictId] = @languageDictId
	--11 Miejsce podjęcia pustego/pełnego kontenera straight from tSTO
	--12 Numer referencyjny kontenera
	LEFT JOIN [schSO].[tShippingOperationsContainers] tSOC
	ON tSO.ShippingOperationId = tSOC.ShippingOperationId
	LEFT JOIN [schSO].[tShippingContainers] tSContainers
	ON tSOC.ShippingContainerId=tSContainers.ShippingContainerId
	--13 Data podjęcia kontenera straight from tSTO
	--14 Miejsce załadunku straight from tSTO
	--15 --XXX--------------------------- Rodzaj odprawy celnej
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] tCustomClearanceType
	ON tSTO.CustomsClearanceTypeId = tCustomClearanceType.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] tCustomClearanceTypeName
	ON tCustomClearanceType.[DictionaryItemVersionId] = tCustomClearanceTypeName.[DictionaryItemVersionId]
		AND tCustomClearanceTypeName.[LanguageDictId] = @languageDictId
	--XXX-----------------------------16 Miejsce odprawy celnej	
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] tCustomClearancePlace
	ON tSTO.CustomsClearancePlaceId = tCustomClearancePlace.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] tCustomClearancePlaceName
	ON tCustomClearancePlace.[DictionaryItemVersionId] = tCustomClearancePlaceName.[DictionaryItemVersionId]
		AND tCustomClearancePlaceName.[LanguageDictId] = @languageDictId
	--17 Agencja celna straight from tSTO
	--18 Miejsce podjecia kontenera (!!! is it duplicated with 11? -KM)
	--19 Data podjecia kontenera (!!! is it duplicated with 13? -KM)
	--20 Miejsce rozładunku sam/naczepy
	LEFT JOIN [schSOA].[tShippingTransportOrderUnloadingPlaces] tSTOUP
	ON tSTO.ShippingTransportOrderId=tSTOUP.ShippingTransportOrderId
	--21 -- Data rozładunku sam/naczepy stright form tSTOUP
	--22 --XXX--------------------------- Data załadunku kontenera
	--23 --XXX--------------------------- Miejsce ważeniw VGM
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] tVGMWeighingPlace
	ON tSTO.VGMWeighingPlaceId = tVGMWeighingPlace.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] tVGMWeighingPlaceName
	ON tVGMWeighingPlace.[DictionaryItemVersionId] = tVGMWeighingPlaceName.[DictionaryItemVersionId]
		AND tVGMWeighingPlaceName.[LanguageDictId] = @languageDictId
	--24 Data ważenia straight from tSTO
	--25 Miejsce złożenia kontenera straight from tSTO
	--26 Numer referencyjny straight FROM tSTO
	--27 Termin najwcześniejszego złożenia straight FROM tSTO
	--28 Termin najpóźniejszego złożenia straight FROM tSTO
	--29 Numer bookingu
	LEFT JOIN [schSOA].[tShippingBookings] tSB
	ON tSA.ShippingBookingId = tSB.ShippingBookingId
	--30 Armator
	LEFT JOIN [schDictionaries].[tDictionaryItemVersions] tShipowner
	ON tSA.ShipownerId = tShipowner.[DictionaryItemVersionId]
	LEFT JOIN [schDictionaries].[tDictionaryItemNames] tShipownerName
	ON tShipowner.[DictionaryItemVersionId] = tShipownerName.[DictionaryItemVersionId]
		AND tShipownerName.[LanguageDictId] = @languageDictId
	--31 Numer kontenera straight from tSContainers
	--32 --XXX--------------------------- Przewoźnik
	LEFT JOIN schSO.tShippingOperationsRoutePositions tSORP
	ON tSO.ShippingOperationId=tSORP.ShippingOperationId
	LEFT JOIN schSO.tShippingRoutePositions tSRP
	ON tSORP.ShippingRoutePositionId=tSRP.ShippingRoutePositionId
	LEFT JOIN schSubjects.tSubjects tShipper
	ON tShipper.SubjectId=tSRP.CarriesSubjectId
	--33 Kierowca
	LEFT JOIN [schSOA].[tShippingActionDrivers] AS tSAD
	ON tSA.ShippingActionId = tSAD.ShippingActionId
--34 Nr dowodu os kierowcy straight from tSAD
--35 Email kierowcy straight from tSAD
--36 Telefon kierowcy straight from tSAD
--37 Stawka sprzedażowa straight from tSTO
--38 Stawka kosztowa straight from tSTO
--39 Nr rejestracyjny ciągnika/samochodu straight from tSAD
--40 Nr rejestracyjny naczepy/ przyczepy straight from tSAD

WHERE tSO.IsActive = 1
	AND tSA.IsActive = 1
	AND tShipper.Name LIKE '%123%'

ORDER BY tShipper.Name DESC
, Shipowner DESC