include("../src/Ogs6InputFileHandler.jl")

file = "../dat/CTF1/CTF1.prj"
ogs6prj = read(Ogs6ModelDef, file)
filenew = "../dat/CTF1/CTF1_new.prj"
ogs6prj.name = filenew
write(ogs6prj)
ogs6prjn = read(Ogs6ModelDef, filenew)