Class gRPC.status Extends %Persistent
{

Property Status As %Library.Integer;

Property Command As %Library.String;

Property Error As %Library.List;

Storage Default
{
<Data name="statusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
<Value name="3">
<Value>Msg</Value>
</Value>
<Value name="4">
<Value>Success</Value>
</Value>
<Value name="5">
<Value>Command</Value>
</Value>
<Value name="6">
<Value>Error</Value>
</Value>
</Data>
<DataLocation>^gRPC.statusD</DataLocation>
<DefaultData>statusDefaultData</DefaultData>
<IdLocation>^gRPC.statusD</IdLocation>
<IndexLocation>^gRPC.statusI</IndexLocation>
<StreamLocation>^gRPC.statusS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
