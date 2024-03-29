module Ogs6InputFileHandler

using XMLParser

mutable struct Ogs6ModelDef
	name::String
	xmlfile::XMLFile
	xmlroot::XMLElement
end

include(joinpath(".","Ogs6InputFileHandler","io.jl"))
include(joinpath(".","Ogs6InputFileHandler","utils.jl"))

end # module