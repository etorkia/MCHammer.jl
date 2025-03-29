
using Logging, LoggingExtras, Documenter

# Create a file logger that writes to "doc_errors.log"
file_logger = LoggingExtras.FileLogger("doc_errors.log")
global_logger(file_logger)

# Now call your documentation build code, e.g.:
include("LocalDocBuild.jl")



#activate "E:\\Technology Partnerz\\Program Dev\\Risk & Simulation\\Solution Dev\\Julia\\mc_hammer\\"
#dev "E:\\Technology Partnerz\\Program Dev\\Risk & Simulation\\Solution Dev\\Julia\\mc_hammer\\"