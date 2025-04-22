B4J=true
Group=Modules
ModulesStructureVersion=1
Type=StaticCode
Version=10
@EndOfDesignText@
'Static code module
Sub Process_Globals
	#If Sandbox
	Public Sandbox As Sandbox
	Type Sandbox (apiBaseUrl As String, idSrvBaseUrl As String, clientId As String, clientSecret As String)
	#End If
	#If Production
	Public Production As Production
	Type Production (apiBaseUrl As String, idSrvBaseUrl As String, clientId As String, clientSecret As String)
	#End If
End Sub