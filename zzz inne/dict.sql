SELECT
	tDIV.[DictionaryItemId]
	--,tDIV.[DictionaryItemVersionId]
      --, tDIV.[IsActive]
	  --, tDI.DictionaryId
	  , tDIN.Name

FROM [C_HARTWIG_SO_DEVEL].[schDictionaries].[tDictionaryItemVersions] tDIV

	JOIN schDictionaries.tDictionaryItems tDI
	ON tDIV.DictionaryItemId = tDI.DictionaryItemId

	JOIN [schDictionaries].[tDictionaryItemNames] tDIN
	ON tDIV.DictionaryItemVersionId = tDIN .DictionaryItemVersionId

where tDI.DictionaryId=6 AND tDIV.[IsActive]=1 
