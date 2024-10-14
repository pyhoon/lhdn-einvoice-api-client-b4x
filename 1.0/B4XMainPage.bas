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
#Region GitHub Desktop
'Ctrl + click to open: ide://run?file=%WINDIR%\System32\cmd.exe&Args=/c&Args=github&Args=.
#End Region
#Region Zip B4XPages Project
'Ctrl + click to export: ide://run?File=%B4X%\Zipper.jar&Args=%PROJECT_NAME%.zip
#End Region

Sub Class_Globals
	Private xui As XUI
	Private API As API
	Private E As EInvoice
	Private P As Platform
	Private Root As B4XView
	Private Label1 As Label
	Private Label2 As Label
	Private Label3 As Label
	Private B4XComboBox1 As B4XComboBox
	Private LblEndPoint As B4XView
	Private BtnSubmit As B4XView
	Private TxtResponse As B4XFloatTextField
	Private clientId As String
	Private clientSecret As String
	Private generatedAccessToken As String
	Private headers As List
	Private format As String = "XML" ' "JSON"
	Private docversion As String = "1.1"
	Private token_expiry As Long
	Private token_dir As String
	Private token_file As String
End Sub

Public Sub Initialize
	'B4XPages.GetManager.LogEvents = True
	Dim config As Map = File.ReadMap(File.DirAssets, "config.properties")
	#If Sandbox
	Env.Sandbox.apiBaseUrl = config.Get("Env.Sandbox.apiBaseUrl")
	Env.Sandbox.idSrvBaseUrl = config.Get("Env.Sandbox.idSrvBaseUrl")
	Env.Sandbox.clientId = config.Get("Env.Sandbox.clientId")
	Env.Sandbox.clientSecret = config.Get("Env.Sandbox.clientSecret")
	clientId = Env.Sandbox.clientId
	clientSecret = Env.Sandbox.clientSecret
	#End If
	#If Production
	Env.Production.apiBaseUrl = config.Get("Env.Production.apiBaseUrl")
	Env.Production.idSrvBaseUrl = config.Get("Env.Production.idSrvBaseUrl")
	Env.Production.clientId = config.Get("Env.Production.clientId")
	Env.Production.clientSecret = config.Get("Env.Production.clientSecret")
	clientId = Env.Production.clientId
	clientSecret = Env.Production.clientSecret
	#End If
	E.Initialize
	P.Initialize
	If format = "" Then format = "XML"
	If docversion <> "1.1" Then docversion = "1.0"
	#If B4J
	token_dir = File.DirApp ' Objects
	#Else If B4A
	token_dir = File.DirInternal
	#Else If B4i
	token_dir = File.DirDocuments	
	#End If
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("1")
	B4XPages.SetTitle(Me, "LHDN e-Invoice API Client")
	PopulateApiList
	Label1.Text = "Document Type: v" & docversion
	Label2.Text = "Document Format: " & format.ToUpperCase
	Label3.Text = "Token expiry: -"
	token_file = "Taxpayer.Token" ' Read Taxpayer token if exist
	If File.Exists(token_dir, token_file) Then
		Dim token As String =  File.ReadString(token_dir, token_file)
		Dim token_expiry As Long = token.As(JSON).ToMap.Get("token_expiry")
		Label3.Text = "Token expiry: " & FormatDateTime(token_expiry)
	End If
End Sub

Private Sub B4XComboBox1_SelectedIndexChanged (Index As Int)
	Select Index
		Case 1
			API = P.API_01
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
			token_file = "Taxpayer.Token"
			Dim token As String =  File.ReadString(token_dir, token_file)
			Dim token_expiry As Long = token.As(JSON).ToMap.Get("token_expiry")
			Label3.Text = "Token expiry: " & FormatDateTime(token_expiry)
		Case 2
			API = P.API_02
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
			token_file = "Intermediary.Token"
			Dim token As String =  File.ReadString(token_dir, token_file)
			Dim token_expiry As Long = token.As(JSON).ToMap.Get("token_expiry")
			Label3.Text = "Token expiry: " & FormatDateTime(token_expiry)
		Case 3
			API = P.API_03
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
		Case 4
			P.API_04.Link = P.API_04.Link.Replace(":id", 1)
			API = P.API_04
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
		Case 5
			P.API_05.Link = P.API_05.Link.Replace(":id", 1)
			P.API_05.Link = P.API_05.Link.Replace(":vid", 1)
			API = P.API_05
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
		Case 6
			'P.API_06.Link = P.API_06.Link.Replace("{dateFrom}", "2024-09-01T12:30:40Z")
			'P.API_06.Link = P.API_06.Link.Replace("{dateTo}", "2024-09-30T12:30:40Z")
			'P.API_06.Link = P.API_06.Link.Replace("{type}", "2")
			'P.API_06.Link = P.API_06.Link.Replace("{language}", "en")
			'P.API_06.Link = P.API_06.Link.Replace("{status}", "delivered")
			'P.API_06.Link = P.API_06.Link.Replace("{channel}", "email")
			'P.API_06.Link = P.API_06.Link.Replace("{pageNo}", "3")
			'P.API_06.Link = P.API_06.Link.Replace("{pageSize}", "20")
			P.API_06.Link = P.API_06.Link.Replace("?dateFrom={dateFrom}&dateTo={dateTo}&type={type}&language={language}&status={status}&channel={channel}&pageNo={pageNo}&pageSize={pageSize}", "")
			API = P.API_06
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
		Case 7
			E.API_01.Link = E.API_01.Link.Replace("{tin}", "C25845632020")
			E.API_01.Link = E.API_01.Link.Replace("{idType}", "NRIC") ' NRIC / PASSPORT / BRN / ARMY
			E.API_01.Link = E.API_01.Link.Replace("{idValue}", "770625015324") ' 770625015324 / A12345678 / 201901234567 / 551587706543
			API = E.API_01
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
		Case 8
			API = E.API_02
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
		Case 9
			E.API_03.Link = E.API_03.Link.Replace("{UUID}", "F9D425P6DS7D8IU")
			API = E.API_03
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
		Case 10
			E.API_04.Link = E.API_04.Link.Replace("{UUID}", "F9D425P6DS7D8IU")
			API = E.API_04
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
		Case 11
			'E.API_05.Link = E.API_05.Link.Replace("{pageNo}", "3")
			'E.API_05.Link = E.API_05.Link.Replace("{pageSize}", "20")
			'E.API_05.Link = E.API_05.Link.Replace("{submissionDateFrom}", "2024-09-01T00:00:00Z")
			'E.API_05.Link = E.API_05.Link.Replace("{submissionDateTo}", "2024-09-30T00:00:00Z")
			'E.API_05.Link = E.API_05.Link.Replace("{issueDateFrom}", "2024-09-01T00:00:00Z")
			'E.API_05.Link = E.API_05.Link.Replace("{IssueDateTo}", "2024-09-10T00:00:00Z")
			'E.API_05.Link = E.API_05.Link.Replace("{direction}", "Sent")
			'E.API_05.Link = E.API_05.Link.Replace("{status}", "Valid")
			'E.API_05.Link = E.API_05.Link.Replace("{documentType}", "01")
			'E.API_05.Link = E.API_05.Link.Replace("{issuerId}", "770625015324")
			'E.API_05.Link = E.API_05.Link.Replace("{issuerIdType}", "NRIC")
			'E.API_05.Link = E.API_05.Link.Replace("{issuerTin}", "C2584563200")
			'E.API_05.Link = E.API_05.Link.Replace("{receiverId}", "770625015324")
			'E.API_05.Link = E.API_05.Link.Replace("{receiverIdType}", "NRIC")
			'E.API_05.Link = E.API_05.Link.Replace("{receiverTin}", "C2584563200")
			E.API_05.Link = E.API_05.Link.Replace($"?pageNo={pageNo}&pageSize={pageSize}&submissionDateFrom={submissionDateFrom}&submissionDateTo={submissionDateTo}&issueDateFrom={issueDateFrom}&issueDateTo={IssueDateTo}&direction={direction}&status={status}&documentType={documentType}&receiverIdType={receiverIdType}&receiverId={receiverId}&receiverTin={receiverTin}&issuerTin={issuerTin}&issuerIdType={issuerIdType}&issuerId={issuerId}"$, "")
			API = E.API_05
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
		Case 12
			E.API_06.Link = E.API_06.Link.Replace("{submissionUid}", "HJSD135P2S7D8IU")
			E.API_06.Link = E.API_06.Link.Replace("{pageNo}", "3")
			E.API_06.Link = E.API_06.Link.Replace("{pageSize}", "20")
			API = E.API_06
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
		Case 13
			E.API_07.Link = E.API_07.Link.Replace("{uuid}", "F9D425P6DS7D8IU")
			API = E.API_07
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
		Case 14
			E.API_08.Link = E.API_08.Link.Replace("{uuid}", "F9D425P6DS7D8IU")
			API = E.API_08
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
		Case 15
			'E.API_09.Link = E.API_09.Link.Replace("{uuid}", "F9D425P6DS7D8IU")
			'E.API_09.Link = E.API_09.Link.Replace("{submissionDateFrom}", "2024-09-01T00:00:00Z")
			'E.API_09.Link = E.API_09.Link.Replace("{submissionDateTo}", "2024-09-30T00:00:00Z")
			'E.API_09.Link = E.API_09.Link.Replace("{continuationToken}", "")
			'E.API_09.Link = E.API_09.Link.Replace("{pageSize}", "20")
			'E.API_09.Link = E.API_09.Link.Replace("{issueDateFrom}", "2024-09-01T00:00:00Z")
			'E.API_09.Link = E.API_09.Link.Replace("{issueDateTo}", "2024-09-30T00:00:00Z")
			'E.API_09.Link = E.API_09.Link.Replace("{direction}", "Sent")
			'E.API_09.Link = E.API_09.Link.Replace("{status}", "Valid")
			'E.API_09.Link = E.API_09.Link.Replace("{documentType}", "01")
			'E.API_09.Link = E.API_09.Link.Replace("{issuerTin}", "C2584563200")
			'E.API_09.Link = E.API_09.Link.Replace("{receiverId}", "770625015324")
			'E.API_09.Link = E.API_09.Link.Replace("{receiverIdType}", "NRIC")
			'E.API_09.Link = E.API_09.Link.Replace("{receiverTin}", "C2584563200")
			E.API_09.Link = E.API_09.Link.Replace($"?uuid={uuid}&submissionDateFrom={submissionDateFrom}&submissionDateTo={submissionDateTo}&continuationToken={continuationToken}&pageSize={pageSize}&issueDateFrom={issueDateFrom}&issueDateTo={issueDateTo}&direction={direction}&status={status}&documentType={documentType}&receiverId={receiverId}&receiverIdType={receiverIdType}&issuerTin={issuerTin}&receiverTin={receiverTin}"$, "")
			API = E.API_09
			LblEndPoint.Text = $"${API.Name} (${API.Verb})${CRLF}${API.Link}"$
		Case Else
			LblEndPoint.Text = "Please select an API"
			TxtResponse.Text = ""
	End Select
End Sub

Private Sub BtnSubmit_Click
	Select B4XComboBox1.SelectedIndex
		Case 1, 2
			If HasCredentials = False Then
				xui.MsgboxAsync("Credentials required", "Error")
				Return
			End If
			Dim data As Map = CreateMap( _
			"client_id": clientId, _
			"client_secret": clientSecret, _
			"grant_type": "client_credentials", _
			"scope": "InvoicingAPI")
			If B4XComboBox1.SelectedIndex = 2 Then
				headers.Initialize
				headers.Add(CreateMap("onbehalfof": "100015840"))
			End If
			
			If TokenExpired Then
				Log("Token has expired")
				MakePlatformApiCall(data)
			Else
				Log("Token is not expired")
				'Dim token As String =  File.ReadString(token_dir, token_file)
				'ShowMessage(token)
				ShowMessage("Already login")
			End If
		Case 3, 4, 5, 6
			MakePlatformApiCall2
		Case 7
			MakeEInvoicingApiCall(Null)
		Case 8
			Dim codeNumber As String = format & "-INV20240925-120326" ' Replace with your own internal invoice number
			Dim ext As String = format.ToLowerCase
			Dim content As String = File.ReadString(File.DirAssets, docversion & $" signed-${codeNumber}.${ext}"$)
			Dim document As Map = CreateMap("format": format.ToUpperCase, _
			"documentHash": SHA256(content), _
			"codeNumber": codeNumber, _
			"document": Base64Encode(content))
			Dim documents As List
			documents.Initialize
			documents.Add(document)
			Dim data As Map = CreateMap("documents": documents)
			MakeEInvoicingApiCall(data)
		Case 9
			Dim data As Map = CreateMap("status": "cancelled", _
			"reason": "some reason for cancelled document")
			MakeEInvoicingApiCall(data)
		Case 10
			Dim data As Map = CreateMap("status": "rejected", _
			"reason": "some reason for rejected document")
			MakeEInvoicingApiCall(data)
		Case 11, 12, 13, 14, 15
			MakeEInvoicingApiCall(Null)
		Case Else
			TxtResponse.Text = ""
	End Select
End Sub

Sub PopulateApiList
	Dim apis As List
	apis.Initialize
	apis.Add("Select an API")
	apis.Add(P.API_01.Name)
	apis.Add(P.API_02.Name)
	apis.Add(P.API_03.Name)
	apis.Add(P.API_04.Name)
	apis.Add(P.API_05.Name)
	apis.Add(P.API_06.Name)
	apis.Add(E.API_01.Name)
	apis.Add(E.API_02.Name)
	apis.Add(E.API_03.Name)
	apis.Add(E.API_04.Name)
	apis.Add(E.API_05.Name)
	apis.Add(E.API_06.Name)
	apis.Add(E.API_07.Name)
	apis.Add(E.API_08.Name)
	apis.Add(E.API_09.Name)
	B4XComboBox1.SetItems(apis)
End Sub

Sub Map2Body (data As Map) As String
	Dim sb As StringBuilder
	sb.Initialize
	For Each Key As String In data.Keys
		Dim value As String = data.Get(Key)
		If sb.Length > 0 Then sb.Append("&")
		sb.Append(Key).Append("=").Append(value)
	Next
	Return sb.ToString
End Sub

Sub MakePlatformApiCall (payload As Map)
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
		token_expiry = expires_in
		token_expiry = (token_expiry * 1000) + UTC(0)
		response.Put("token_expiry", token_expiry)
		File.WriteString(token_dir, token_file, response.As(JSON).ToString)
		Label3.Text = "Token expiry: " & FormatDateTime(token_expiry)
		ShowMessage(response.As(JSON).ToString)
	Else
		Dim error As Map = job.ErrorMessage.As(JSON).ToMap
		ShowError(error.As(JSON).ToString)
	End If
	job.Release
End Sub

Sub MakePlatformApiCall2
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

Sub MakeEInvoicingApiCall (payload As Map)
	Try
		Dim job As HttpJob
		job.Initialize("", Me)
		If payload.IsInitialized Then
			Dim body As String = payload.As(JSON).ToString
		End If
		Select API.Verb
			Case "GET"
				job.Download(API.Link)
			Case "POST"
				job.PostString(API.Link, body)
				job.GetRequest.SetContentType("application/json")
			Case "PUT"
				job.PutString(API.Link, body)
				job.GetRequest.SetContentType("application/json")
			Case Else
				ShowError("Bad Request")
				Return
		End Select
		job.GetRequest.SetHeader("Authorization", $"Bearer ${generatedAccessToken}"$)
		Wait For (job) JobDone (job As HttpJob)
		If job.Success Then
			Log("Success: " & job.Response.StatusCode)
			Log(job.GetString)
			If job.GetString.Length > 0 Then
				Dim message As Map = job.GetString.As(JSON).ToMap
				ShowMessage(message.As(JSON).ToString)
			Else
				ShowMessage("Success " & job.Response.StatusCode)
			End If
		Else
			Log("Error: " & job.Response.StatusCode)
			Log(job.ErrorMessage)
			If job.ErrorMessage.Length > 0 Then
				Dim error As Map = job.ErrorMessage.As(JSON).ToMap
				ShowError(error.As(JSON).ToString)
			Else
				ShowError("Error " & job.Response.StatusCode)
			End If
		End If
	Catch
		Log(LastException)
	End Try
	job.Release
End Sub

Sub ShowMessage (Message As String)
	TxtResponse.Text = Message
	TxtResponse.TextField.TextColor = xui.Color_RGB(0, 100, 0)
End Sub

Sub ShowError (Error As String)
	TxtResponse.Text = Error
	TxtResponse.TextField.TextColor = xui.Color_RGB(178, 34, 34)
End Sub

Sub SHA256 (str As String) As String
	Dim data() As Byte
	Dim MD As MessageDigest
	Dim BC As ByteConverter
	data = BC.StringToBytes(str, "UTF8")
	data = MD.GetMessageDigest(data, "SHA-256")
	Return BC.HexFromBytes(data).ToLowerCase
End Sub

Sub Base64Encode (str As String) As String
	Dim SU As StringUtils
	Dim encoded As String = SU.EncodeBase64(str.GetBytes("UTF8"))
	Return encoded
End Sub

Sub UTC (OffsetHours As Int) As Long
	DateTime.SetTimeZone(OffsetHours)
	Return DateTime.Now
End Sub

Sub FormatDateTime (Ticks As Long) As String
	Dim DF As String = DateTime.DateFormat
	DateTime.DateFormat = "yyyy-MM-dd hh:mm:ss aa"
	'Dim CD As String = DateTime.Date(Ticks)
	'Log(CD)
	DateTime.SetTimeZone(8) ' Malaysian Time
	Dim CD As String = DateTime.Date(Ticks)
	'Log(CD)
	DateTime.DateFormat = DF
	Return CD
End Sub

Sub TokenExpired As Boolean
	If File.Exists(token_dir, token_file) = False Then Return True
	Dim token As String = File.ReadString(token_dir, token_file)
	Dim expiry As Long = token.As(JSON).ToMap.Get("token_expiry")
	generatedAccessToken = token.As(JSON).ToMap.Get("access_token")
	Return expiry < DateTime.Now - 60000 ' If expire in less than 60 seconds
End Sub

Sub HasCredentials As Boolean
	Return Not(clientId = "" Or clientSecret = "") 
End Sub