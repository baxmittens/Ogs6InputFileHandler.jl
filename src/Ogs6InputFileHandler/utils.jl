
function rename!(ogsmodel::Ogs6ModelDef,name::String)
	ogsmodel.name = name
	return nothing
end

if !isdefined(Main,:ogspathspecifier) #top level hack
const ogspathspecifier = Dict{String,String}(
	"parameter"=>"name",
	"property"=>"name",
	"phase"=>"type",
	"independent_variable"=>"variable_name"
	)
end

import XMLParser: checkTagName
function getAllPathesbyTag!(ret::Vector{String},xmlroot::XMLElement,tagname::String,path="./")
	for con in xmlroot.content
		if typeof(con)==XMLElement
			_path = joinpath(path,con.tag.name)
			if haskey(ogspathspecifier,con.tag.name)
				pathspec = ogspathspecifier[con.tag.name]
				els = getChildrenbyTagName(con,pathspec)
				if !isempty(els)
					@assert length(els) == 1 && length(els[1].content) == 1 "$els"
					_path = joinpath(_path,"?$(els[1].content[1])")
				end
			end
			for attribute in con.tag.attributes
				_path = joinpath(_path,"@$(attribute.key)=$(attribute.val)")
			end
			if checkTagName(con,tagname) && typeof(con.content[1]) == String
				push!(ret,_path)
			else
				getAllPathesbyTag!(ret,con,tagname,_path)
			end
		end
	end
	return nothing
end


function getAllPathesbyTag(xmlroot::XMLElement,tagname::String,path="./")
	ret = Vector{String}()
	getAllPathesbyTag!(ret,xmlroot,tagname,path)
	return ret
end
getAllPathesbyTag(ogsmodel::Ogs6ModelDef,tagname::String,path="./") = getAllPathesbyTag(ogsmodel.xmlroot,tagname,path)


function getElementbyPath(xmlroot::XMLElement, path::String)
	tagstrings = filter(x->x != ".",splitpath(path))
	tag = popfirst!(tagstrings)
	els = getChildrenbyTagName(xmlroot,tag)
	@assert !isempty(els)
	if isempty(tagstrings)
		@assert length(els)==1	"empty tagstring"
		return els[1]
	elseif tagstrings[1][1] != '@' && tagstrings[1][1] != '?'
		@assert length(els)==1 "$tagstrings"
		return getElementbyPath(els[1], joinpath(tagstrings...))
	elseif haskey(ogspathspecifier,tag) && tagstrings[1][1] == '?'
		specstring = replace(popfirst!(tagstrings),"?"=>"")
		for el in els
			children = getChildrenbyTagName(el,ogspathspecifier[tag])
			@assert length(children) == 1 "$children"
			if children[1].content[1] == specstring
				if isempty(tagstrings)
					return el
				else
					return getElementbyPath(el, joinpath(tagstrings...))
				end
			end	
		end
		error("No element found")
	elseif tagstrings[1][1] == '@'
		key,val = split(replace(popfirst!(tagstrings),"@"=>""),"=")
		for el in els
			if getAttribute(el,String(key)) == val
				return getElementbyPath(el, joinpath(tagstrings...))
			end
		end
		error("No element found")
	else
		println(tag)
		println(tagstrings)
		error()
	end
end
getElementbyPath(ogsmodel::Ogs6ModelDef, path::String) = getElementbyPath(ogsmodel.xmlroot, path)

function Base.string(md::Ogs6ModelDef)
	str = "Ogs6ModelDef: \n"
	str *= "projectfile: "*md.name*"\n"
	str *= "XML: \n"
	str *= string(md.xmlroot)
	return str
end

#function Base.display(cpt::CollocationPoint)
#	print(cpt)
#end
#
#function Base.print(io::IO, cpt::CollocationPoint)
#	return print(io,Base.string(cpt))
#end
#
#function Base.show(io::IO, cpt::CollocationPoint)
#	return Base.print(io,cpt)
#end
