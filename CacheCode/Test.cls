Class gRPC.Test Extends (%RegisteredObject, %Persistent, %CSP.REST)
{

XData UrlMap
{
<Routes>
        <Route Url="/battery/([^/]*)" Method="GET" Call="setToBattery" />
        <Route Url="/command/([^/]*)" Method="GET" Call="setToCommand" />
        <Route Url="/reset/([^/]*)" Method="GET" Call="setToReset" />
    </Routes>
}

ClassMethod MoveKachaka(value1, value2) [ SqlName = Move, SqlProc ]
{
    Tstart
    Set $NAMESPACE="grpc"

    Set status = ##class(gRPC.Test).setOrder(value1, value2)
    Tcommit
    Quit status
}

ClassMethod setOrder(value1, value2)
{
    Set $NAMESPACE="grpc"

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
    } ElseIf value1 = 2{
        Set status = httpRequest.Get("http://192.168.43.147/return/192.168.43.5")
    } ElseIf value1 = 3{
        Set status = httpRequest.Get("http://192.168.43.147/cancel/192.168.43.5")
    } ElseIf value1 = 4{
        Set status = httpRequest.Get("http://192.168.43.147/reset/192.168.43.5")
    }

    If $$$ISERR(status) {
        Write "Error: ", status, !
        Quit
    }

    Set response = httpRequest.HttpResponse.Data.Read()
    Set utfres = $ZCONVERT(response, "I", "UTF8")
    Quit utfres
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

Storage Default
{
<Data name="TestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^gRPC.TestD</DataLocation>
<DefaultData>TestDefaultData</DefaultData>
<IdLocation>^gRPC.TestD</IdLocation>
<IndexLocation>^gRPC.TestI</IndexLocation>
<StreamLocation>^gRPC.TestS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
