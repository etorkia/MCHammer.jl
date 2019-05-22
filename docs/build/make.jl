clearconsole()
#push!(LOAD_PATH,"../src")
using Documenter, MCHammer
makedocs(sitename="MC Hammer Documentation", modules =[MCHammer], doctest = false, root = "Z:\\Program Dev\\Risk & Simulation\\Solution Dev\\Julia\\mc_hammer\\docs", repo = "https://github.com/etorkia/MCHammer.jl")
