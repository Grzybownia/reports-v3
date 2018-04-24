USE [C_HARTWIG_SO_DEVEL]
GO

DECLARE
@languageDictId INT = 440001
,@operationTypeIds [schDictionaries].[IntTable] 
,@operationRelationTypeIds [schDictionaries].[IntTable] 
,@operationStatusIds [schDictionaries].[IntTable] 
,@openingDateFrom DATETIME = NULL
,@openingDateTo DATETIME = NULL
,@principalName VARCHAR(50) = NULL
,@shipperNamesIds [schDictionaries].[IntTable] 
,@etdFrom DATETIME = NULL
,@etdTo DATETIME = NULL
,@etaFrom DATETIME = NULL
,@etaTo DATETIME = NULL
,@loadingPortName VARCHAR(50) = NULL
,@unloadingPortName VARCHAR(50) = NULL
--
,@vcharApplicationAdress VARCHAR(100) = 'http://hartwig-so/ShippingOperation/Preview/'
,@vcharIDontKnowWhere VARCHAR(32) = '>idk where??<'


INSERT INTO @operationTypeIds
VALUES
	(581)
	,(580)
INSERT INTO @operationRelationTypeIds
VALUES
	(672)
-- (671) --matka
-- ,(672) --corka
-- ,(673) --sierota

INSERT INTO @operationStatusIds
VALUES
	(1033)
	,(585)
	,(1031)
	,(1032)

INSERT INTO @operationStatusIds
VALUES
	(12409)
	,(11662)
	,(12469)
	,(11602)
	,(1)
	,(5949)
	,(12462)
	,(12425)
	,(12408)
	,(11300)
	,(11501)
	,(12457)






EXEC	[schReports].[prGetOperationLCL]
	@languageDictId
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

GO
