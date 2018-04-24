USE C_HARTWIG_SO_DEVEL

DECLARE @listIntIdsOfType TABLE (id INT)
INSERT INTO @listIntIdsOfType
VALUES
	(556)
	,(549)
	,(548)
	,(5822)
	,(516)
	,(585)
	,(587)
	,(581)
	,(671)
	,(542)
	,(5229)
	,(683)
	,(527)
	,(1031)
	,(812)

SELECT tDIV.DictionaryItemVersionId
,tDIV.DictionaryItemId
,tDIN.Name
,tDI.DictionaryId
,IsActive
-- FROM schDictionaries.tDictionaryItemNames tDIN
FROM schDictionaries.tDictionaryItemVersions tDIV
	JOIN schDictionaries.tDictionaryItemNames tDIN
	ON tDIV.DictionaryItemVersionId=tDIN.DictionaryItemVersionId
	JOIN schDictionaries.tDictionaryItems tDI
	ON tDIV.DictionaryItemId=tDI.DictionaryItemId
WHERE tDIV.DictionaryItemVersionId IN (
	SELECT Id
	FROM @listIntIdsOfType
) AND tDIV.IsActive=1
ORDER BY tDIV.DictionaryItemVersionId





