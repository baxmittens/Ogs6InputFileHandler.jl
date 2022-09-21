include("../src/Ogs6InputFileHandler.jl")

file = "../dat/CTF1/CTF1.prj"
ogs6prj = read(Ogs6ModelDef, file)
ogs6prj.name = "../dat/CTF1/CTF1_new.prj"
write(ogs6prj)