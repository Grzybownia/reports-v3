Public Function GetQuery(ByVal VBoperationTypeIds As Object(),ByVal VBoperationRelationTypeIds As Object(),ByVal VBoperationStatusIds  As Object(),ByVal VBshipperNamesIds  As Object()) As String

	Dim sb As New System.Text.StringBuilder() 
	
	sb.AppendLine("DECLARE @CODEoperationTypeIds schDictionaries.IntTable") 
	For i As Integer = 0 To VBoperationTypeIds.Length - 1 
		sb.AppendLine(String.Format("INSERT INTO @CODEoperationTypeIds VALUES ({0})", VBoperationTypeIds(i))) 
	Next

	sb.AppendLine("DECLARE @CODEoperationRelationTypeIds schDictionaries.IntTable") 
	For i As Integer = 0 To VBoperationRelationTypeIds.Length - 1 
 		sb.AppendLine(String.Format("INSERT INTO @CODEoperationRelationTypeIds VALUES ({0})", VBoperationRelationTypeIds(i))) 
	Next 

	sb.AppendLine("DECLARE @CODEoperationStatusIds schDictionaries.IntTable") 
	For i As Integer = 0 To VBoperationStatusIds.Length - 1 
 		sb.AppendLine(String.Format("INSERT INTO @CODEoperationStatusIds VALUES ({0})", VBoperationStatusIds(i))) 
	Next 

	sb.AppendLine("DECLARE @CODEshipperNamesIds schDictionaries.IntTable") 
	For i As Integer = 0 To VBshipperNamesIds.Length - 1 
 		sb.AppendLine(String.Format("INSERT INTO @CODEshipperNamesIds VALUES ({0})", VBshipperNamesIds(i))) 
	Next 
	
	sb.AppendLine("EXEC [schReports].[prGetOperationLCL] 
 @languageDictId ,@CODEoperationTypeIds ,@CODEoperationRelationTypeIds ,@CODEoperationStatusIds ,@openingDateFrom ,@openingDateTo ,@principalName  ,@CODEshipperNamesIds ,@etdFrom ,@etdTo ,@etaFrom ,@etaTo ,@loadingPortName ,@unloadingPortName ,@vcharApplicationAdress ,@vcharIDontKnowWhere,@intBookingActionTypeId") 

	Return sb.ToString() 
End Function


