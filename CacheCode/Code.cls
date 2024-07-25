Class gRPC.Code Extends (%RegisteredObject, %CSP.REST)
{

XData UrlMap
{
<Routes>
    <Route Url="/success" Method="GET" Call="MoveSuccess" />
    <Route Url="/status/([^/]*)" Method="GET" Call="setToStatus" />
    <Route Url="/status2" Method="POST" Call="setToStatus2" />
</Routes>
}

ClassMethod MoveKachaka(value1, value2) [ SqlName = MoveKachaka, SqlProc ]
{
    Tstart
    Set $NAMESPACE="grpc"

    Set statement=##class(%SQL.Statement).%New()
    Set order=##class(gRPC.order).%New()
    Set data = ##class(%DynamicObject).%New()
    Set httpRequest = ##class(%Net.HttpRequest).%New()
    Set st=##class(gRPC.kachakast).%OpenId(19)


    #; Set sql1="SELECT COUNT(Status) AS ""Count"" FROM gRPC.order WHERE Status = 2"
    #; Set tStatus=statement.%Prepare(sql1)
    #; If $$$ISERR(tStatus){
    #;     Set status = ##class(gRPC.Code).setOrder(value1, value2)
    #;     Tcommit
    #;     Quit status
    #; }
    #; Set rSet=statement.%Execute()
    #; If rSet.%Next() {
    #;     If rSet.Count = 2 {
    #;         Tcommit
    #;         Quit "操作可能なKachakaはありません"
    #;     } Else {
    #; Set sql1="INSERT INTO gRPC.kachakast (CommandStatus) VALUES ('running')"
    #; Set tStatus=statement.%Prepare(sql1)
    #; If $$$ISERR(tStatus){
    #;     Quit
    #; }
    #; Set rSet=statement.%Execute()
    #; If rSet.%Next() {

    #; } Else {
    #; }
    Set status = ##class(gRPC.Code).setOrder(value1, value2)
    Tcommit
    Quit status
    #;     }
    #; }
}

ClassMethod setOrder(value1, value2)
{
    Set $NAMESPACE="grpc"

    Set statement=##class(%SQL.Statement).%New()
    Set order=##class(gRPC.order).%New()
    Set st=##class(gRPC.kachakast).%OpenId(23)
    Set data = ##class(%DynamicObject).%New()
    Set httpRequest = ##class(%Net.HttpRequest).%New()
    Set order.Status=1
    Set order.Request=value1
    Set order.SerialNo=value2
    Set order.TimeStamp=$ZDATETIME($HOROLOG, 3, 9)_"."_$EXTRACT($PIECE($ZTIMESTAMP,".",2),1,3)
    Set status=order.%Save()

    Set httpRequest.Https = 0
    Set httpRequest.SSLConfiguration = "default"
    Set httpRequest.Timeout = 30

    If st.CommandStatus="pending"{
        Set st.CommandStatus = "running"
        Do st.%Save()
    }

    If value1 = 1{
        Set status = httpRequest.Get("http://192.168.43.147/move/192.168.43.5/4.09,-0.62,-1.64")
        #; Set status = httpRequest.Get("http://localhost:80/move")
    } ElseIf value1 = 2{
        Set status = httpRequest.Get("http://192.168.43.147/return/192.168.43.5")
    }

    If $$$ISERR(status) {
        Write "Error: ", status, !
        Quit
    }

    Set response = httpRequest.HttpResponse.Data.Read()
    Set utfres = $ZCONVERT(response, "I", "UTF8")
    Quit utfres
}

ClassMethod MoveCancel() [ SqlName = MoveCancel, SqlProc ]
{
    Set statement=##class(%SQL.Statement).%New()
    Set order=##class(gRPC.order).%New()
    Set httpRequest = ##class(%Net.HttpRequest).%New()

    Set httpRequest.Https = 0
    Set httpRequest.SSLConfiguration = "default"
    Set httpRequest.Timeout = 30
    Set status = httpRequest.Get("http://192.168.43.147/cancel/192.168.43.5")

    If $$$ISERR(status) {
        Write "Error: ", status, !
        Quit
    }
    
    Set response = httpRequest.HttpResponse.Data.Read()
    Set utfres = $ZCONVERT(response, "I", "UTF8")
    Quit utfres
}

ClassMethod MoveReset() [ SqlName = MoveReset, SqlProc ]
{
    Set statement=##class(%SQL.Statement).%New()
    Set order=##class(gRPC.order).%New()
    Set httpRequest = ##class(%Net.HttpRequest).%New()

    Set httpRequest.Https = 0
    Set httpRequest.SSLConfiguration = "default"
    Set httpRequest.Timeout = 30
    Set status = httpRequest.Get("http://192.168.43.147/reset/192.168.43.5")

    If $$$ISERR(status) {
        Write "Error: ", status, !
        Quit
    }
    
    Set response = httpRequest.HttpResponse.Data.Read()
    Set utfres = $ZCONVERT(response, "I", "UTF8")
    Quit utfres
}

ClassMethod SpeakKachaka(value As %Library.String) [ SqlName = MoveSpeak, SqlProc ]
{
    Set httpRequest = ##class(%Net.HttpRequest).%New()

    Set httpRequest.Https = 0
    Set httpRequest.SSLConfiguration = "default"
    Set httpRequest.Timeout = 30
    Set msg = "http://192.168.43.147/speak/192.168.43.5/" _ value
    Set status = httpRequest.Get(msg)

    If $$$ISERR(status) {
        Write "Error: ", status, !
        Quit
    }
    
    Set response = httpRequest.HttpResponse.Data.Read()
    Quit response
}

ClassMethod MoveSuccess() [ SqlName = MoveSuccess, SqlProc ]
{
    Set statement=##class(%SQL.Statement).%New()
    Set order=##class(gRPC.order).%New()
    Set httpRequest = ##class(%Net.HttpRequest).%New()
    
    Set sql1="UPDATE gRPC.order SET Status = 3 WHERE ID = (SELECT TOP 1 ID FROM gRPC.order WHERE Status = 2 FOR UPDATE)"
    Set tStatus=statement.%Prepare(sql1)
    If $$$ISERR(tStatus){
        Quit "process don't move"
    }
    Set rSet=statement.%Execute()

    Set httpRequest.Https = 0
    Set httpRequest.SSLConfiguration = "default"
    Set httpRequest.Timeout = 30

    Set status = httpRequest.Get("http://localhost:80/success")


    If $$$ISERR(status) {
        Write "Error: ", status, !
        Quit
    }
    
    Set response = httpRequest.HttpResponse.Data.Read()
    Quit response
}

ClassMethod setToStatus(jsonObject As %DynamicObject) As %Library.Integer
{
    Set status=$$$OK
    Try{
        Set $NAMESPACE="grpc"
        Set obj=##class(%DynamicObject).%FromJSON(jsonObject)
        Set st=##class(gRPC.status).%New()
        #; Set myList = $LISTBUILD("Red", "Blue", "Green")
        #; Set st.Error = myList
        Set st.Status=obj.status
        Set st.Command=obj.command
        Set st.Error=obj.error
        Set status=st.%Save()
    }
    Catch ex{
        Set status=ex.AsStatus()
    }
    Quit status
}

ClassMethod setToStatus2() As %Status
{
    Set status=$$$OK
    Try{
        Set req=%request.Content.Read()
        Set reqObj={}.%FromJSON(req)
        Write reqObj.%Get("msg")
        Set $NAMESPACE="grpc"
        Set st=##class(gRPC.status).%New()
        Set st.Status=reqObj.%Get("status")
        Set st.Msg=reqObj.%Get("msg")
        Set st.Success=reqObj.%Get("bool")
        Set status=st.%Save()
    }
    Catch ex{
        Set status=ex.AsStatus()
    }
    Quit status
}

}
