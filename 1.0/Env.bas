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

' Currently not used
Public Sub Reset
	#If Sandbox
	Sandbox.Initialize
	Sandbox.apiBaseUrl = ""
	Sandbox.idSrvBaseUrl = ""
	Sandbox.clientId = ""
	Sandbox.clientSecret = ""
	#End If
	#If Production
	Production.Initialize
	Production.apiBaseUrl = ""
	Production.idSrvBaseUrl = ""
	Production.clientId = ""
	Production.clientSecret = ""
	#End If
End Sub