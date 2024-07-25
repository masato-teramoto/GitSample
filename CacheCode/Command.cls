Class gRPC.Command Extends (%Persistent, %CSP.REST)
{

XData UrlMap
{
<Routes>
    <Route Url="/status/([^/]*)" Method="GET" Call="setToStatus" />
    <Route Url="/status2/([^/]*)" Method="POST" Call="setToStatus2" />
    <Route Url="/battery/([^/]*)" Method="GET" Call="setToBattery" />
    <Route Url="/command/([^/]*)" Method="GET" Call="setToCommand" />
    <Route Url="/reset/([^/]*)" Method="GET" Call="setToReset" />
</Routes>
}

ClassMethod setToBattery(data As %DynamicObject) As %Library.Integer
{
    Set status=$$$OK
    Try{
        Set $NAMESPACE="grpc"
        Set statement=##class(%SQL.Statement).%New()
        Set obj=##class(%DynamicObject).%FromJSON(data)
        Set sql1="UPDATE gRPC.kachakast SET BatteryStatus = ? WHERE Address = ?"
        Set tStatus=statement.%Prepare(sql1)
        If $$$ISERR(tStatus){
            Quit
        }
        Set rSet=statement.%Execute(obj.data.status, obj.data.address)
        If rSet.%Next() {
        } Else {
        }
    }
    Catch ex{
        Set status=ex.AsStatus()
    }
    Quit status
}

ClassMethod setToCommand(data As %DynamicObject) As %Library.Integer
{
    Set status=$$$OK
    Try{
        Set $NAMESPACE="grpc"
        Set statement=##class(%SQL.Statement).%New()
        Set obj=##class(%DynamicObject).%FromJSON(data)
        Set sql1="UPDATE gRPC.kachakast SET CommandStatus = ? WHERE Address = ?"
        Set tStatus=statement.%Prepare(sql1)
        If $$$ISERR(tStatus){
            Quit
        }
        Set rSet=statement.%Execute(obj.status, obj.address)
        If rSet.%Next() {
        } Else {
        }
    }
    Catch ex{
        Set status=ex.AsStatus()
    }
    Quit status
}

ClassMethod setToReset(data As %DynamicObject) As %Library.Integer
{
    Set status=$$$OK
    Try{
        Set $NAMESPACE="grpc"
        Set statement=##class(%SQL.Statement).%New()
        Set obj=##class(%DynamicObject).%FromJSON(data)
        Set sql1="UPDATE gRPC.kachakast SET BatteryStatus = ?, CommandStatus = ? WHERE Address = ?"
        Set tStatus=statement.%Prepare(sql1)
        If $$$ISERR(tStatus){
            Quit
        }
        Set rSet=statement.%Execute(obj.status.battery, obj.status.command, obj.address)
        If rSet.%Next() {
        } Else {
        }
    }
    Catch ex{
        Set status=ex.AsStatus()
    }
    Quit status
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

/// Description
ClassMethod setToDB(value1, value2)
{
    Set $NAMESPACE="grpc"
    Set order=##class(gRPC.order).%New()
    Set order.Status=1
    Set order.Request=value1
    Set order.SerialNo=value2
    Set order.TimeStamp=$ZDATETIME($HOROLOG, 3, 9)_"."_$EXTRACT($PIECE($ZTIMESTAMP,".",2),1,3)
    Set status=order.%Save()

    #; Set sem = ##class(%SYSTEM.Semaphore).%New()
    #; Set semName = "DBSemaphore" _ value2
    #; Do sem.Open(semName)
    #; Do sem.Increment(1)
}

ClassMethod getFromDB(value) As %DynamicObject
{
    Set $NAMESPACE="grpc"
    Set statement=##class(%SQL.Statement).%New()
    Set data = ##class(%DynamicObject).%New()
    Set sql1="SELECT TOP 1 ID, Request FROM gRPC.order WHERE Status = 1"
    Set tStatus=statement.%Prepare(sql1)
    If $$$ISERR(tStatus){
        Quit
    }
    Set rSet=statement.%Execute()
    If rSet.%Next() {
        Set data.id = rSet.ID
        Set data.request = rSet.Request
    } Else {
        Quit
    }
    Quit data.%ToJSON()
}

ClassMethod sample(j As %DynamicObject)
{
    Write j, !
}

ClassMethod updateToDB(value1, value2, value3)
{
    Set $NAMESPACE="grpc"
    Set update=##class(gRPC.order).%OpenId(value1)
    If value2{
        Set update.Status=3
        Set update.Success=value2
        Set update.Response=value3
    } Else{
        Set update.Status=0
        Set update.Success=value2
        Set update.ErrorCode=2
    }

    Do update.%Save()
}

ClassMethod statusTo2(value)
{
    Set $NAMESPACE="grpc"
    Set order=##class(gRPC.order).%OpenId(value)
    Set order.Status=2
    Set status=order.%Save()
    Quit
}

ClassMethod statusTo3(value)
{
    Set $NAMESPACE="grpc"
    Set order=##class(gRPC.order).%OpenId(value)
    Set order.Status=3
    Set status=order.%Save()
    Quit
}

ClassMethod checkDB()
{
    Set $NAMESPACE="grpc"
    Set statement=##class(%SQL.Statement).%New()
    Set sql1="SELECT COUNT(Status) AS ""Count"" FROM gRPC.order WHERE Status = 2 FOR UPDATE"
    Set tStatus=statement.%Prepare(sql1)
    If $$$ISERR(tStatus){
        Write "what"
        Quit
    }
    Set rSet=statement.%Execute()
    If rSet.%Next() {
        Write rSet.Count
        If rSet.Count = 2 {
            Write "ok"
        }
    } Else {
        Write "fuck"
        Quit
    }
    Quit
}

ClassMethod setErrorMessage(value1, value2)
{
    Set $NAMESPACE="grpc"
    Set errortable=##class(gRPC.order).%OpenId(value1)
    Set errortable.Status=0
    Set errortable.ErrorCode=value2
    Set status=errortable.%Save()
    Quit
}

ClassMethod createSemaphore(value)
{
    Set sem = ##class(%SYSTEM.Semaphore).%New()
    Set semName = "DBSemaphore" _ value
    Do sem.Create(semName, 2)
    Quit
}

ClassMethod getFromSemaphore(value) As %Library.Boolean
{
    Set sem = ##class(%SYSTEM.Semaphore).%New()
    Set semName = "DBSemaphore" _ value
    Do sem.Open(semName)

    #; Write "semName is " _ semName, !
    #; Write sem.GetValue(), !
    Write "wait 10 seconds", !

    Set status = sem.Decrement(1, 10)
    #; Write "success " _ status, !
    #; Write !
    Quit status
}

// テスト用

ClassMethod semUp(value)
{
    Set s = ##class(%SYSTEM.Semaphore).%New()
    Set semName = "DBSemaphore" _ value
    Do s.Open(semName)


    Do s.Increment(1)
    Quit
}

ClassMethod updateDB()
{
    Set $NAMESPACE="grpc"
    Set order=##class(gRPC.order).%New()
    Set order.Response = "something"
    Set status=order.%Save()
    Quit
}

ClassMethod throwHTTP(value) As %Library.String
{
    // HTTPリクエストオブジェクトを作成
    Set httpRequest = ##class(%Net.HttpRequest).%New()

    // URLを設定
    #; Set httpRequest.Server = "http://localhost:56773/api/atelier/"
    Set httpRequest.Https = 0
    Set httpRequest.SSLConfiguration = "default"
    Set httpRequest.Timeout = 30

    If value=1{
        #; Set status = httpRequest.Get("http://192.168.43.147:8080/?action=MoveToPose")
        Set status = httpRequest.Get("http://127.0.0.1:80/crud/status/%7B%22status%22%3A%202%2C%20%22command%22%3A%20%22success%22%2C%20%22error%22%3A%20%22something%22%7D")
    } ElseIf value=2{
        #; Set status = httpRequest.Get("http://192.168.43.147:8080/?action=ReturnHome")
        Do httpRequest.InsertFormData("msg", "hello")
        Set status = httpRequest.Post("http://localhost:80/crud/status2")
    } ElseIf value=3{
        Set status = httpRequest.Get("http://localhost:8000/cancel")
    }
    // ステータスを確認
    If $$$ISERR(status) {
        Write "Error: ", status, !
        Quit
    }

    // レスポンスを取得
    Set response = httpRequest.HttpResponse.Data.Read()
    Write response

    #; Write response
    Quit response
}

ClassMethod StartProcesses()
{
        Set ^StopFlag = 0
        Job ##class(gRPC.Command).PrintOK()::10
        Job ##class(gRPC.Command).PrintNO()::10
        Job ##class(gRPC.Command).StopProcesses()::10
        Quit
}

ClassMethod PrintOK()
{
        While '^StopFlag {
            Hang 1
            Do ##class(gRPC.Command).setToDB(1,1)
        }
}

ClassMethod PrintNO()
{
        While '^StopFlag {
            Hang 5
            Do ##class(gRPC.Command).setToDB(5,1)
        }
}

ClassMethod StopProcesses()
{
        Hang 10
        Set ^StopFlag = 1
}

Storage Default
{
<Data name="CommandDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^gRPC.CommandD</DataLocation>
<DefaultData>CommandDefaultData</DefaultData>
<IdLocation>^gRPC.CommandD</IdLocation>
<IndexLocation>^gRPC.CommandI</IndexLocation>
<StreamLocation>^gRPC.CommandS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
