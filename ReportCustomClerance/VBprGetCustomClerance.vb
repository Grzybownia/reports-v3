Public Function GetQuery(ByVal VBcustomAgentIds As Object(),ByVal VBactionStatusIds As Object()) As String

Dim sb As New System.Text.StringBuilder()

sb.AppendLine("DECLARE @CODEcustomAgentIds schDictionaries.IntTable")
For i As Integer = 0 To VBcustomAgentIds.Length - 1
sb.AppendLine(String.Format("insert into @CODEcustomAgentIds values ({0})", VBcustomAgentIds(i)))
Next

sb.AppendLine("DECLARE @CODEactionStatusIds schDictionaries.IntTable")
For i As Integer = 0 To VBactionStatusIds.Length - 1
sb.AppendLine(String.Format("insert into @CODEactionStatusIds values ({0})", VBactionStatusIds(i)))
Next

sb.AppendLine("EXEC	[schReports].[prGetCustomClerance]	@languageDictId, @CODEcustomAgentIds, @CODEactionStatusIds, @importerExporterName, @orderDateFrom, @orderDateTo, @vcharIDontKnowWhere")
Return sb.ToString()

End Function
	

=Code.GetQuery(
Parameters!customAgentIds.Value,
Parameters!actionStatusIds.Value
)





11111111111
Public Function GetQuery(ByVal VBoperationTypeIds As Object(),ByVal VBtransportTypeIds As Object(),ByVal VBcontainerTypeIds As Object()) As String

Dim sb As New System.Text.StringBuilder()

sb.AppendLine("DECLARE @CODEoperationTypeIds schDictionaries.IntTable")
For i As Integer = 0 To VBoperationTypeIds.Length - 1
	sb.AppendLine(String.Format("insert into @CODEoperationTypeIds values ({0})", VBoperationTypeIds(i)))
Next

sb.AppendLine("DECLARE @CODEtransportTypeIds schDictionaries.IntTable")
For i As Integer = 0 To VBtransportTypeIds.Length - 1
	sb.AppendLine(String.Format("insert into @CODEtransportTypeIds values ({0})", VBtransportTypeIds(i)))
Next

sb.AppendLine("DECLARE @CODEcontainerTypeIds schDictionaries.IntTable")
For i As Integer = 0 To VBcontainerTypeIds.Length - 1
	sb.AppendLine(String.Format("insert into @CODEcontainerTypeIds values ({0})", VBcontainerTypeIds(i)))
Next

 sb.AppendLine("EXEC	[schReports].[prGetTransportOrder]	@languageDictId	,@CODEoperationTypeIds	,@CODEtransportTypeIds	,@openingDateFrom	,@openingDateTo	,@deployContainerDateFrom	,@deployContainerDateTo	,@principalCustomerName	,@loadingPlace	,@unloadingPlace	,@shipownerName	,@driverName	,@freighterName	,@CODEcontainerTypeIds	,@containerNumber	,@shippingNumber	,@bookingNumber	,@principalCHGNamesIds	,@executorCHGIds	,@vcharApplicationAdress	,@vcharIDontKnowWhere")
 Return sb.ToString()

End Function


