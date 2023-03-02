#import XMLParser.IOState
function Base.read(::Type{Ogs6ModelDef}, file)
	#state = IOState(file)
	#element = readXMLElement(state)
	#close(state.f)
	xmlfile = read(XMLFile, file)
	return Ogs6ModelDef(file,xmlfile,xmlfile.element)
end

function Base.write(ogsmodel::Ogs6ModelDef)
	#f = open(ogsmodel.name,"w")
	#writeXMLElement(f,ogsmodel.xmlroot)
	#close(f)
	write(ogsmodel.name, ogsmodel.xmlfile)
end