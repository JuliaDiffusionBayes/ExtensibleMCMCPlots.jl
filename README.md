# ExtensibleMCMCPlots.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaDiffusionBayes.github.io/ExtensibleMCMCPlots.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaDiffusionBayes.github.io/ExtensibleMCMCPlots.jl/dev)
[![Build Status](https://travis-ci.com/JuliaDiffusionBayes/ExtensibleMCMCPlots.jl.svg?branch=master)](https://travis-ci.com/JuliaDiffusionBayes/ExtensibleMCMCPlots.jl)

Adds `PlottingCallback` to [ExtensibleMCMC.jl](https://github.com/JuliaDiffusionBayes/ExtensibleMCMC.jl).

![anim](assets/online_plots.gif)

---
Note: the online plots may slow down your mcmc sampler, but if your problem is complicated enough and requires enough computations for each step, then using `PlottingCallback` should bear no effect on the overall performance.
