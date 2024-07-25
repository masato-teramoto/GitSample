Class gRPC.order Extends %Persistent
{

Property Request As %Library.Integer;

Property Status As %Library.Integer;

Property TimeStamp As %Library.TimeStamp;

Property Success As %Library.Boolean;

Property Response As %Library.String;

Property ErrorCode As %Library.Integer;

Property SerialNo As %Library.Integer;

Property ShelfNo As %DynamicObject;

Storage Default
{
<Data name="orderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Request</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
<Value name="4">
<Value>TimeStamp</Value>
</Value>
<Value name="5">
<Value>Success</Value>
</Value>
<Value name="6">
<Value>Response</Value>
</Value>
<Value name="7">
<Value>ErrorCode</Value>
</Value>
<Value name="8">
<Value>SerialNo</Value>
</Value>
<Value name="9">
<Value>ShelfNo</Value>
</Value>
</Data>
<DataLocation>^gRPC.orderD</DataLocation>
<DefaultData>orderDefaultData</DefaultData>
<IdLocation>^gRPC.orderD</IdLocation>
<IndexLocation>^gRPC.orderI</IndexLocation>
<StreamLocation>^gRPC.orderS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
