USE [C_HARTWIG_SO_DEVEL]
GO

DECLARE @languageDictId INT = 440001
	,@operationTypeIds [schDictionaries].[IntTable]
	,@transportTypeIds [schDictionaries].[IntTable]
	,@openingDateFrom DATETIME = NULL
	,@openingDateTo DATETIME = NULL
	,@deployContainerDateFrom DATETIME = NULL
	,@deployContainerDateTo DATETIME = NULL
	,@principalCustomerName VARCHAR(50) = NULL
	,@loadingPlace VARCHAR(50) = NULL
	,@unloadingPlace VARCHAR(50) = NULL
	,@shipownerName VARCHAR(50) = NULL
	,@driverName VARCHAR(50) = NULL
	,@freighterName VARCHAR(50) = NULL
	,@containerTypeIds [schDictionaries].[IntTable]
	,@ContainerNumber VARCHAR(50) = NULL
	,@shippingNumber VARCHAR(50) = NULL
	,@bookingNumber VARCHAR(50) = NULL
	,@principalCHGNamesIds INT
	,@executorCHGIds INT
	,@vcharApplicationAdress VARCHAR(100) = 'http://hartwig-so/ShippingOperation/Preview/'
	,@vcharIDontKnowWhere VARCHAR(32) = '>idk where??<'

INSERT INTO @operationTypeIds
VALUES
	(513)
	,(514)
INSERT INTO  @transportTypeIds
VALUES
	(680)
	,(681)
	,(682)
INSERT INTO  @containerTypeIds
VALUES
	(528)
	,(542)
	,(537)
	,(536)
	,(533)
	,(529)
	,(543)
	,(530)
	,(541)
	,(540)
	,(535)
	,(539)
	,(538)
	,(534)
	,(531)
	,(532)

--INSERT INTO @principalCustomerName VALUES  (1) 

EXEC [schReports].[prGetTransportOrder] 
	@languageDictId
	,@OperationTypeIds
	,@transportTypeIds
	,@openingDateFrom
	,@openingDateTo
	,@deployContainerDateFrom
	,@deployContainerDateTo
	,@principalCustomerName
	,@loadingPlace
	,@unloadingPlace
	,@shipownerName
	,@driverName
	,@freighterName
	,@containerTypeIds
	,@ContainerNumber
	,@shippingNumber
	,@bookingNumber
	,@principalCHGNamesIds
	,@executorCHGIds
	-------------------------------------------------
	,@vcharApplicationAdress
	,@vcharIDontKnowWhere
GO