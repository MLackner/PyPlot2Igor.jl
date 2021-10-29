using PyPlot2Igor
using Documenter

DocMeta.setdocmeta!(PyPlot2Igor, :DocTestSetup, :(using PyPlot2Igor); recursive=true)

makedocs(;
    modules=[PyPlot2Igor],
    authors="MLackner <lacknersmichael@gmail.com> and contributors",
    repo="https://github.com/MLackner/PyPlot2Igor.jl/blob/{commit}{path}#{line}",
    sitename="PyPlot2Igor.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://MLackner.github.io/PyPlot2Igor.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/MLackner/PyPlot2Igor.jl",
    devbranch="main",
)
