#clearconsole()
#push!(LOAD_PATH,"../src")
using Documenter, MCHammer
makedocs(sitename="MCHammer.jl", modules =[MCHammer], doctest = true, root = "Z:\\Program Dev\\Risk & Simulation\\Solution Dev\\Julia\\mc_hammer\\docs", repo = "github.com/etorkia/MCHammer.jl")

deploydocs(
    #target="build",
    repo = "github.com/etorkia/MCHammer.jl.git",
    #branch = "gh-pages",
    #devbranch="master",
    #versions = ["stable" => "v^", "v#.#"]
)

#Literate.markdown("examples/NPV_testmodel.jl", "docs/src/tutorials"; documenter=true)
