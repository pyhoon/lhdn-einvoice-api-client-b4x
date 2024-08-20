B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

'Ctrl + click to export as zip: ide://run?File=%B4X%\Zipper.jar&Args=%PROJECT_NAME%.zip

Sub Class_Globals
	Private xui As XUI
	Private Root As B4XView
	Private B4XComboBox1 As B4XComboBox
	Private LblEndPoint As B4XView
	Private BtnSubmit As B4XView
	'Private LblMessage As B4XView
	Private TxtResponse As B4XFloatTextField
	'Private https As String = "https://"
	Private apiBaseUrl As String 'ignore
	Private idSrvBaseUrl As String 'ignore
	Private clientId As String
	Private clientSecret As String
	Private generatedAccessToken As String
	Private headers As List
	Private API As API
	Private E As EInvoice 'ignore
	Private P As Platform
End Sub

Public Sub Initialize
	'B4XPages.GetManager.LogEvents = True
	Dim config As Map = File.ReadMap(File.DirAssets, "config.properties")
	#If Sandbox
	Env.Sandbox.apiBaseUrl = config.Get("Env.Sandbox.apiBaseUrl")
	Env.Sandbox.idSrvBaseUrl = config.Get("Env.Sandbox.idSrvBaseUrl")
	Env.Sandbox.clientId = config.Get("Env.Sandbox.clientId")
	Env.Sandbox.clientSecret = config.Get("Env.Sandbox.clientSecret")
	apiBaseUrl = Env.Sandbox.apiBaseUrl
	idSrvBaseUrl = Env.Sandbox.idSrvBaseUrl
	clientId = Env.Sandbox.clientId
	clientSecret = Env.Sandbox.clientSecret
	#End If
	#If Production
	Env.Production.apiBaseUrl = config.Get("Env.Production.apiBaseUrl")
	Env.Production.idSrvBaseUrl = config.Get("Env.Production.idSrvBaseUrl")
	Env.Production.clientId = config.Get("Env.Production.clientId")
	Env.Production.clientSecret = config.Get("Env.Production.clientSecret")
	apiBaseUrl = Env.Production.apiBaseUrl
	idSrvBaseUrl = Env.Production.idSrvBaseUrl
	clientId = Env.Production.clientId
	clientSecret = Env.Production.clientSecret
	#End If
	P.Initialize
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("1")
	B4XPages.SetTitle(Me, "LHDN e-Invoice API Client")
	PopulateApiList
End Sub

Private Sub BtnSubmit_Click
	Select B4XComboBox1.SelectedIndex
		Case 1
			Dim data As Map = CreateMap( _
			"client_id": clientId, _
			"client_secret": clientSecret, _
			"grant_type": "client_credentials", _
			"scope": "InvoicingAPI")
			MakePlatformApiCall(data)
		Case 2
			Dim data As Map = CreateMap( _
			"client_id": clientId, _
			"client_secret": clientSecret, _
			"grant_type": "client_credentials", _
			"scope": "InvoicingAPI")
			headers.Initialize
			headers.Add(CreateMap("onbehalfof": "100015840"))
			MakePlatformApiCall(data)
		Case 3
			MakePlatformApiCall2
		Case 4
			' test :id = 1
			P.API_04.Link = P.API_04.Link.Replace(":id", 1)
			MakePlatformApiCall2
		Case 5
			' test :id = 1, :vid = 1
			P.API_05.Link = P.API_05.Link.Replace(":id", 1).Replace(":vid", 1)
			MakePlatformApiCall2
		Case 6
			ShowError("Not yet implemented")
			Return
		'Case 7
		'	Dim data As Map
		'	MakeEInvoicingApiCall(data)
		Case Else
			'TxtResponse.Text = ""
			Return
	End Select
End Sub

Private Sub PopulateApiList
	Dim apis As List
	apis.Initialize
	apis.Add("Select an API")
	apis.Add(P.API_01.Name)
	apis.Add(P.API_02.Name)
	apis.Add(P.API_03.Name)
	apis.Add(P.API_04.Name)
	apis.Add(P.API_05.Name)
	apis.Add(P.API_06.Name)
	B4XComboBox1.SetItems(apis)
End Sub

Private Sub Map2Body (data As Map) As String
	Dim sb As StringBuilder
	sb.Initialize
	For Each Key As String In data.Keys
		Dim value As String = data.Get(Key)
		If sb.Length > 0 Then sb.Append("&")
		sb.Append(Key).Append("=").Append(value)
	Next
	Return sb.ToString
End Sub

Private Sub MakePlatformApiCall (payload As Map)
	Dim job As HttpJob
	job.Initialize("", Me)
	Dim body As String = Map2Body(payload)
	Select API.Verb
		Case "POST"
			job.PostString(API.Link, body)
			If headers.IsInitialized And headers.Size > 0 Then
				Dim header As Map = headers.Get(0)
				For Each Key As String In header.Keys
					job.GetRequest.SetHeader(Key, header.Get(Key))
				Next				
			End If
			job.GetRequest.SetContentType("application/x-www-form-urlencoded")
		Case Else
			ShowError("Bad Request")
			Return
	End Select
	Wait For (job) JobDone (job As HttpJob)
	If job.Success Then
		Dim response As Map = job.GetString.As(JSON).ToMap
		generatedAccessToken = response.Get("access_token")
		Dim expires_in As String = response.Get("expires_in")
		Dim token_type As String = response.Get("token_type")
		Dim scope As String = response.Get("scope")
		Log($"access_token: ${generatedAccessToken}"$)
		Log($"expires_in: ${expires_in}"$)
		Log($"token_type: ${token_type}"$)
		Log($"scope: ${scope}"$)
		#If Production
		Env.Production.clientSecret = generatedAccessToken
		#Else
		Env.Sandbox.clientSecret = generatedAccessToken
		#End If		
		ShowMessage(response.As(JSON).ToString)
	Else
		Dim error As Map = job.ErrorMessage.As(JSON).ToMap
		ShowError(error.As(JSON).ToString)
	End If
	job.Release
End Sub

Private Sub MakePlatformApiCall2
	Dim job As HttpJob
	job.Initialize("", Me)
	Select API.Verb
		Case "GET"
			job.Download(API.Link)
		Case Else
			ShowError("Bad Request")
			Return
	End Select	
	job.GetRequest.SetHeader("Authorization", $"Bearer ${generatedAccessToken}"$)
	Wait For (job) JobDone (job As HttpJob)
	If job.Success Then
		Dim message As Map = job.GetString.As(JSON).ToMap
		ShowMessage(message.As(JSON).ToString)
	Else
		Dim error As Map = job.ErrorMessage.As(JSON).ToMap
		ShowError(error.As(JSON).ToString)
	End If
	job.Release
End Sub

Private Sub MakeEInvoicingApiCall (payload As Map) 'ignore
	Dim job As HttpJob
	job.Initialize("", Me)
	Dim body As String = payload.As(JSON).ToString
	Select API.Verb
		Case "GET"
			job.Download(API.Link)
		Case "POST"
			job.PostString(API.Link, body)
			job.GetRequest.SetContentType("application/json")
		Case Else
			ShowError("Bad Request")
			Return
	End Select	
	job.GetRequest.SetHeader("Authorization", $"Bearer ${generatedAccessToken}"$)
	Wait For (job) JobDone (job As HttpJob)
	If job.Success Then
		Dim message As Map = job.GetString.As(JSON).ToMap
		ShowMessage(message.As(JSON).ToString)
	Else
		Dim error As Map = job.ErrorMessage.As(JSON).ToMap
		ShowError(error.As(JSON).ToString)
	End If
	job.Release
End Sub

Private Sub B4XComboBox1_SelectedIndexChanged (Index As Int)
	Select Index
		Case 1
			API = P.API_01
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
			LblEndPoint.Visible = True
		Case 2
			API = P.API_02
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
			LblEndPoint.Visible = True
		Case 3
			API = P.API_03
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
			LblEndPoint.Visible = True
		Case 4
			API = P.API_04
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
			LblEndPoint.Visible = True
		Case 5
			API = P.API_05
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
			LblEndPoint.Visible = True
		Case 6
			API = P.API_06
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
			LblEndPoint.Visible = True
		Case Else
			LblEndPoint.Visible = False
			TxtResponse.Text = ""
	End Select
End Sub

Public Sub ShowMessage (Message As String)
	'LblMessage.Text = Message
	'LblMessage.Color = xui.Color_RGB(127, 255, 212)
	'LblMessage.TextColor = xui.Color_RGB(0, 100, 0)
	'LblMessage.Visible = True
	TxtResponse.Text = Message
	TxtResponse.TextField.TextColor = xui.Color_RGB(0, 100, 0)
End Sub

Public Sub ShowError (Error As String)
	'LblMessage.Text = Error
	'LblMessage.Color = xui.Color_RGB(255, 182, 193)
	'LblMessage.TextColor = xui.Color_RGB(178, 34, 34)
	'LblMessage.Visible = True
	TxtResponse.Text = Error
	TxtResponse.TextField.TextColor = xui.Color_RGB(178, 34, 34)
End Sub