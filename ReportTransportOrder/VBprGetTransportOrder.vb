Public Function GetQuery(ByVal VBoperationTypeIds As Object(),ByVal VBtransportTypeIds As Object(),ByVal VBcontainerTypeIds As Object(),ByVal VBprincipalCHGNamesIds As Object() ,ByVal VBexecutorCHGIds As Object()) As String

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

sb.AppendLine("DECLARE @CODEprincipalCHGNamesIds schDictionaries.IntTable")
For i As Integer = 0 To VBprincipalCHGNamesIds.Length - 1
sb.AppendLine(String.Format("insert into @CODEprincipalCHGNamesIds values ({0})", VBprincipalCHGNamesIds(i)))
Next

sb.AppendLine("DECLARE @CODEexecutorCHGIds schDictionaries.IntTable")
For i As Integer = 0 To VBexecutorCHGIds.Length - 1
sb.AppendLine(String.Format("insert into @CODEexecutorCHGIds values ({0})", VBexecutorCHGIds(i)))
Next

sb.AppendLine("EXEC	[schReports].[prGetTransportOrder]	@languageDictId	,@CODEoperationTypeIds	,@CODEtransportTypeIds	,@openingDateFrom	,@openingDateTo	,@deployContainerDateFrom	,@deployContainerDateTo	,@principalCustomerName	,@loadingPlace	,@unloadingPlace	,@shipownerName	,@driverName	,@freighterName	,@CODEcontainerTypeIds	,@containerNumber	,@shippingNumber	,@bookingNumber	,@CODEprincipalCHGNamesIds	,@CODEexecutorCHGIds	,@vcharApplicationAdress	,@vcharIDontKnowWhere")
Return sb.ToString()

End Function
	







=Code.GetQuery(
Parameters!operationTypeIds.Value,
Parameters!transportTypeIds.Value,
Parameters!containerTypeIds.Value,
Parameters!principalIds.Value,
Parameters!executorCHGIds.Value
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


