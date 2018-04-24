SELECT 
t.DictionaryItemVersionId
,t.Name
,tt.DictionaryItemId
,tt.IsActive

FROM [C_HARTWIG_SO_DEVEL].[schDictionaries].[tDictionaryItemNames] t
join [schDictionaries].[tDictionaryItemVersions] tt
on tt.DictionaryItemVersionId=t.DictionaryItemVersionId
--where t.DictionaryItemVersionId IN (
--521


--) 
--and tt.IsActive=1

where t.Name LIKE '%racht%'  and tt.IsActive=1
order by tt.DictionaryItemId


-- @intCustomClearanceActionTypeId --xxxxxx 522	Dyspozycja celna	60002 intCustomClearanceActionTypeId
-- @intFormingActionTypeId 523 --xxxxxx523	Formowanie 60003
-- @intUnformingActionTypeId     524 --xxxxxx524	Rozformowanie60004
--DECLARE @intSeaFreightActionTypeId INT = (SELECT [DictionaryItemVersionId] FROM [schDictionaries].[tDictionaryItemVersions] WHERE [DictionaryItemId] IN (180024,180025,180037) AND IsActive = 1)

--@intUnloadingActionTypeId tUnloading 525 --xxxxxx525	Roz³adunek60005
--@intLoadingActionTypeId 526 --xxxxxx526	Za³adunek60006

--@intTransportOrderActionTypeId     527	Zlecenietransportowe	60007






