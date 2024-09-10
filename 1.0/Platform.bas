B4J=true
Group=API
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
Sub Class_Globals
	Private apiBaseUrl As String
	Private idSrvBaseUrl As String
	Public API_01, API_02, API_03, API_04, API_05, API_06 As API
	Type API (Verb As String, Name As String, Link As String)
End Sub

Public Sub Initialize
	#If Sandbox
	apiBaseUrl = Env.Sandbox.apiBaseUrl
	idSrvBaseUrl = Env.Sandbox.apiBaseUrl
	#End If
	#If Production
	apiBaseUrl = Env.Production.apiBaseUrl
	idSrvBaseUrl = Env.Production.apiBaseUrl
	#End If
	API_01 = CreateAPI("POST", "Login as Taxpayer System", $"https://${idSrvBaseUrl}/connect/token"$)
	API_02 = CreateAPI("POST", "Login as Intermediary System", $"https://${idSrvBaseUrl}/connect/token"$)
	API_03 = CreateAPI("GET", "Get All Document Types", $"https://${apiBaseUrl}/api/v1.0/documenttypes"$)
	API_04 = CreateAPI("GET", "Get Document Type", $"https://${apiBaseUrl}/api/v1.0/documenttypes/:id"$)
	API_05 = CreateAPI("GET", "Get Document Type Version", $"https://${apiBaseUrl}/api/v1.0/documenttypes/:id/versions/:vid"$)
	API_06 = CreateAPI("GET", "Get Notifications", $"https://${apiBaseUrl}/api/v1.0/notifications/taxpayer?dateFrom={dateFrom}&dateTo={dateTo}&type={type}&language={language}&status={status}&channel={channel}&pageNo={pageNo}&pageSize={pageSize}"$)
End Sub

Private Sub CreateAPI (Verb As String, Name As String, Link As String) As API
	Dim t1 As API
	t1.Initialize
	t1.Verb = Verb
	t1.Name = Name
	t1.Link = Link
	Return t1
End Sub