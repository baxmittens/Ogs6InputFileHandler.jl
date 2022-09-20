#include(joinpath(".","XMLParser.jl"))
using XMLParser

mutable struct Ogs6ModelDef
	name::String
	xmlroot::XMLElement
end

include(joinpath(".","Ogs6InputFileHandler","io.jl"))
include(joinpath(".","Ogs6InputFileHandler","utils.jl"))