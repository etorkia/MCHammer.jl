#clearconsole()
#push!(LOAD_PATH,"../src")
using Pkg
Pkg.add("Documenter")
using Documenter, MCHammer

makedocs(sitename="MCHammer.jl", modules =[MCHammer, Documenter, DocumenterTools], doctest = true, repo = "github.com/etorkia/MCHammer.jl")

deploydocs(
    #target="build",
    repo = "github.com/etorkia/MCHammer.jl.git",
    #branch = "gh-pages",
    #devbranch="master",
    #versions = ["stable" => "v^", "v#.#"]
)

#Literate.markdown("examples/NPV_testmodel.jl", "docs/src/tutorials"; documenter=true)
