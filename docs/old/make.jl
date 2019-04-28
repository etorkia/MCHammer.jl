push!(LOAD_PATH,"../src/")
using Documenter, mc_hammer
makedocs(sitename="MC Hammer Documentation", modules =[mc_hammer], doctest = false)
