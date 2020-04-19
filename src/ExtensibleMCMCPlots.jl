module ExtensibleMCMCPlots

    using ExtensibleMCMC
    const eMCMC = ExtensibleMCMC
    using RecipesBase, Plots
    include("online_chains.jl")
    include("callbacks.jl")
    export PlottingCallback

end # module
