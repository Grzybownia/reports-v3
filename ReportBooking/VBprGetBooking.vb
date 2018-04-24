Public Function GetQuery(	ByVal VBshipperIds As Object()	,ByVal VBactionStatusIds As Object()	,ByVal VBoperationTypeIds As Object()) As String 

Dim sb As New System.Text.StringBuilder()  

sb.AppendLine("DECLARE @CODEshipperIds schDictionaries.IntTable") 
    For i As Integer = 0 To VBshipperIds.Length - 1 
      sb.AppendLine(String.Format("insert into @CODEshipperIds values ({0})", VBshipperIds(i))) 
Next    

sb.AppendLine("DECLARE @CODEactionStatusIds schDictionaries.IntTable") 
    For i As Integer = 0 To VBactionStatusIds.Length - 1 
      sb.AppendLine(String.Format("insert into @CODEactionStatusIds values ({0})", VBactionStatusIds(i))) 
Next    

sb.AppendLine("DECLARE @CODEoperationTypeIds schDictionaries.IntTable") 
    For i As Integer = 0 To VBoperationTypeIds.Length - 1 
      sb.AppendLine(String.Format("insert into @CODEoperationTypeIds values ({0})", VBoperationTypeIds(i))) 
Next    

' sb.AppendLine(String.Format("DECLARE @CODEshipownerName VARCHAR(50)={0}",VBshipownerName))

    sb.AppendLine("EXEC	[schReports].[prGetBooking] 		@languageDictId,		@CODEshipperIds,		@openingDateFrom,		@openingDateTo,		@CODEactionStatusIds,		@CODEoperationTypeIds,		@etdFrom,		@etdTo,		@etaFrom,		@etaTo,		@shipownerName,		@agentName,		@loadingPortName,		@unloadingPortName,		@vcharApplicationAdress,@vcharIDontKnowWhere") 
    Return sb.ToString() 
End Function
