#clearconsole()
#push!(LOAD_PATH,"../src")
using Pkg
Pkg.add("Documenter")
Pkg.add("DocumenterTools")
Pkg.add("Distributions")
Pkg.add("StatsBase")
Pkg.add("Statistics")
Pkg.add("Dates")
Pkg.add("MCHammer")
Pkg.add("DataFrames")

using Dates
using DataFrames
using Documenter, DocumenterTools
using Distributions, Statistics, StatsBase
using MCHammer


makedocs(
sitename="MCHammer.jl",
modules =[MCHammer, Documenter, DocumenterTools, Distributions, StatsBase, Statistics, Dates, DataFrames, Gadfly],

format = Documenter.HTML(
    # Use clean URLs, unless built as a "local" build
    prettyurls = !("local" in ARGS),
    canonical = "https://etorkia.github.io/MCHammer.jl/dev/",
    assets = ["assets/favicon.ico"],
    analytics = "UA-3913053-5",
),

authors = "Eric Torkia, Technology Partnerz and contributors",
doctest = true,
repo = "github.com/etorkia/MCHammer.jl")

deploydocs(
    target="build",
    repo = "github.com/etorkia/MCHammer.jl.git",
    branch = "gh-pages",
    devbranch="master",
    versions = ["stable" => "v^", "v#.#"]
)

#Literate.markdown("examples/NPV_testmodel.jl", "docs/src/tutorials"; documenter=true)
