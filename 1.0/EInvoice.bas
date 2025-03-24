B4J=true
Group=API
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
Sub Class_Globals
	Private apiBaseUrl As String
	Public API_01, API_02, API_03, API_04, API_05, API_06, API_07, API_08, API_09, API_10 As API
End Sub

Public Sub Initialize
	#If Sandbox
	apiBaseUrl = Env.Sandbox.apiBaseUrl
	#End If
	#If Production
	apiBaseUrl = Env.Production.apiBaseUrl
	#End If
	API_01 = CreateAPI("GET", "Validate Taxpayer's TIN", $"https://${apiBaseUrl}/api/v1.0/taxpayer/validate/{tin}?idType={idType}&idValue={idValue}"$)
	API_02 = CreateAPI("POST", "Submit Documents", $"https://${apiBaseUrl}/api/v1.0/documentsubmissions"$)
	API_03 = CreateAPI("PUT", "Cancel Document", $"https://${apiBaseUrl}/api/v1.0/documents/state/{UUID}/state"$)
	API_04 = CreateAPI("PUT", "Reject Document", $"https://${apiBaseUrl}/api/v1.0/documents/state/{UUID}/state"$)
	API_05 = CreateAPI("GET", "Get Recent Documents", $"https://${apiBaseUrl}/api/v1.0/documents/recent?pageNo={pageNo}&pageSize={pageSize}&submissionDateFrom={submissionDateFrom}&submissionDateTo={submissionDateTo}&issueDateFrom={issueDateFrom}&issueDateTo={IssueDateTo}&direction={direction}&status={status}&documentType={documentType}&receiverIdType={receiverIdType}&receiverId={receiverId}&receiverTin={receiverTin}&issuerTin={issuerTin}&issuerIdType={issuerIdType}&issuerId={issuerId}"$)
	API_06 = CreateAPI("GET", "Get Submission", $"https://${apiBaseUrl}/api/v1.0/documentsubmissions/{submissionUid}?pageNo={pageNo}&pageSize={pageSize}"$)
	API_07 = CreateAPI("GET", "Get Document", $"https://${apiBaseUrl}/api/v1.0/documents/{uuid}/raw"$)
	API_08 = CreateAPI("GET", "Get Document Details", $"https://${apiBaseUrl}/api/v1.0/documents/{uuid}/details"$)
	API_09 = CreateAPI("GET", "Search Documents", $"https://${apiBaseUrl}/api/v1.0/documents/search?uuid={uuid}&submissionDateFrom={submissionDateFrom}&submissionDateTo={submissionDateTo}&continuationToken={continuationToken}&pageSize={pageSize}&issueDateFrom={issueDateFrom}&issueDateTo={issueDateTo}&direction={direction}&status={status}&documentType={documentType}&receiverId={receiverId}&receiverIdType={receiverIdType}&issuerTin={issuerTin}&receiverTin={receiverTin}"$)
	API_10 = CreateAPI("GET", "Search Taxpayer's TIN", $"https://${apiBaseUrl}/api/v1.0/taxpayer/search/tin?idType={idType}&idValue={idValue}&taxpayerName={taxpayerName}"$)
End Sub

Private Sub CreateAPI (Verb As String, Name As String, Link As String) As API
	Dim t1 As API
	t1.Initialize
	t1.Verb = Verb
	t1.Name = Name
	t1.Link = Link
	Return t1
End Sub