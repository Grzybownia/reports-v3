USE [C_HARTWIG_SO_DEVEL]
GO

DECLARE
	@languageDictId INT = 440001
	,@shipperIds [schDictionaries].[IntTable]
	,@openingDateFrom DATETIME = NULL
	,@openingDateTo DATETIME = NULL
	,@actionStatusIds [schDictionaries].[IntTable]
	,@operationTypeIds [schDictionaries].[IntTable]
	,@etdFrom DATETIME = NULL
	,@etdTo DATETIME = NULL
	,@etaFrom DATETIME = NULL
	,@etaTo DATETIME = NULL
 	,@shipownerName VARCHAR(50)= NULL
	,@agentName VARCHAR(50)= NULL
	,@loadingPortName VARCHAR(50) = NULL
	,@unloadingPortName VARCHAR(50) = NULL
	--
	,@vcharApplicationAdress VARCHAR(100) = 'http://hartwig-so/ShippingOperation/Preview/'
	,@vcharIDontKnowWhere VARCHAR(32) = '>idk where??<'

INSERT INTO @shipperIds
VALUES
	(12409)

INSERT INTO @actionStatusIds
VALUES
	(683)
-- (684),
-- (685),
-- (686),
-- (687)

INSERT INTO @operationTypeIds
VALUES
	-- (513)
	(514)


EXEC	[schReports].[prGetBooking]
	@languageDictId
	,@shipperIds
	,@openingDateFrom
	,@openingDateTo
	,@actionStatusIds
	,@operationTypeIds
	,@etdFrom
	,@etdTo
	,@etaFrom 
	,@etaTo
	,@shipownerName
	,@agentName 
	,@loadingPortName 
	,@unloadingPortName
	--
	,@vcharApplicationAdress 
	,@vcharIDontKnowWhere
GO
