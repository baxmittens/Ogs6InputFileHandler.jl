import XMLParser.IOState
function Base.read(::Type{Ogs6ModelDef}, file)
	state = IOState(file)
	element = readXMLElement(state)
	close(state.f)
	return Ogs6ModelDef(file,element)
end

function Base.write(ogsmodel::Ogs6ModelDef)
	f = open(ogsmodel.name,"w")
	writeXMLElement(f,ogsmodel.xmlroot)
	close(f)
end