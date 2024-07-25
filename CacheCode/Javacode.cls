Class gRPC.Javacode Extends %Persistent
{

Property Msg As %String;

Projection cacheJava As %Projection.Java;

Projection JavaClient As %Projection.Java(ROOTDIR = "C:\cache_python\");

Storage Default
{
<Data name="JavacodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Msg</Value>
</Value>
</Data>
<DataLocation>^gRPC.JavacodeD</DataLocation>
<DefaultData>JavacodeDefaultData</DefaultData>
<IdLocation>^gRPC.JavacodeD</IdLocation>
<IndexLocation>^gRPC.JavacodeI</IndexLocation>
<StreamLocation>^gRPC.JavacodeS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
