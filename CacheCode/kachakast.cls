Class gRPC.kachakast Extends %Persistent
{

Property Address As %Library.String;

Property BatteryStatus As %Library.String;

Property CommandStatus As %Library.String;

Storage Default
{
<Data name="kachakastDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>key</Value>
</Value>
<Value name="3">
<Value>BatteryStatus</Value>
</Value>
<Value name="4">
<Value>CommandStatus</Value>
</Value>
<Value name="5">
<Value>Adress</Value>
</Value>
<Value name="6">
<Value>Address</Value>
</Value>
</Data>
<DataLocation>^gRPC.kachakastD</DataLocation>
<DefaultData>kachakastDefaultData</DefaultData>
<IdLocation>^gRPC.kachakastD</IdLocation>
<IndexLocation>^gRPC.kachakastI</IndexLocation>
<StreamLocation>^gRPC.kachakastS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
