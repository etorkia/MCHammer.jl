clearconsole()
#push!(LOAD_PATH,"../src")
using Documenter, MCHammer
makedocs(sitename="MC Hammer Documentation", modules =[MCHammer], doctest = true, root = "Z:\\Program Dev\\Risk & Simulation\\Solution Dev\\Julia\\mc_hammer\\docs", repo = "https://github.com/etorkia/MCHammer.jl")

#Literate.markdown("examples/NPV_testmodel.jl", "docs/src/tutorials"; documenter=true)
