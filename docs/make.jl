using Documenter, ExtensibleMCMCPlots

makedocs(;
    modules=[ExtensibleMCMCPlots],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/JuliaDiffusionBayes/ExtensibleMCMCPlots.jl/blob/{commit}{path}#L{line}",
    sitename="ExtensibleMCMCPlots.jl",
    authors="Sebastiano Grazzi, Frank van der Meulen, Marcin Mider, Moritz Schauer",
    assets=String[],
)

deploydocs(;
    repo="github.com/JuliaDiffusionBayes/ExtensibleMCMCPlots.jl",
)
