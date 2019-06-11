#clearconsole()
#push!(LOAD_PATH,"../src")
using Pkg
Pkg.add("Documenter")
Pkg.add("DocumenterTools")
Pkg.add("Distributions")
Pkg.add("StatsBase")
Pkg.add("Statistics")

using Documenter, DocumenterTools, MCHammer, Distributions, Statistics, StatsBase

makedocs(sitename="MCHammer.jl", modules =[MCHammer, Documenter, DocumenterTools, Distributions, StatsBase, Statistics], doctest = true, repo = "github.com/etorkia/MCHammer.jl")

deploydocs(
    target="build",
    repo = "github.com/etorkia/MCHammer.jl.git",
    branch = "gh-pages",
    devbranch="master"
    #versions = ["stable" => "v^", "v#.#"]
)

#Literate.markdown("examples/NPV_testmodel.jl", "docs/src/tutorials"; documenter=true)
