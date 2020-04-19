#===============================================================================
                    Online visualization of Markov Chains
===============================================================================#

function _arrange_θs_to_plot(v::Val{:all}, θ_hist, indices, v1::Val{1})
    d = length(θ_hist[1][1])
    nu = length(θ_hist[1])
    idx_to_plot = 1:(nu*indices[end])
    [(idx_to_plot, _arrange_θs_to_plot(v, θ_hist, indices, i, v1)) for i in 1:d]
end

_arrange_θs_to_plot(v::Val{:all}, θ_hist, indices, i, v1::Val{1}) = map(
    θ->θ[i],
    collect(Iterators.flatten(θ_hist[indices]))
)

function _arrange_θs_to_plot(v::Val{:all}, θ_hist, indices, v1)
    d = length(θ_hist[1][1])
    nu = length(θ_hist[1])
    idx_to_plot = (nu*indices[1]-nu):(nu*indices[end])
    new_idx = (indices[1]-1):indices[end]
    [(idx_to_plot, _arrange_θs_to_plot(v, θ_hist, new_idx, i, v1)) for i in 1:d]
end

_arrange_θs_to_plot(v::Val{:all}, θ_hist, indices, i, v1) = map(
    θ->θ[i],
    collect(Iterators.flatten(θ_hist[indices]))[length(θ_hist[1]):end]
)


function _arrange_θs_to_plot(v::Val{:first}, θ_hist, indices, v1::Val{1})
    d = length(θ_hist[1][1])
    [(indices, map(θ->θ[1][i], θ_hist[indices])) for i in 1:d]
end


function _arrange_θs_to_plot(v::Val{:first}, θ_hist, indices, v1)
    d = length(θ_hist[1][1])
    new_idx = (indices[1]-1):indices[end]
    [(new_idx, map(θ->θ[1][i], θ_hist[new_idx])) for i in 1:d]
end

function _arrange_ar_to_plot(rolling_ar, indices, v1::Val{1})
    nu = length(rolling_ar[1])
    [(indices, map(ra->ra[i], rolling_ar[indices])) for i in 1:nu]
end

function _arrange_ar_to_plot(rolling_ar, indices, v1)
    num_updt = length(rolling_ar[1])
    new_idx = (indices[1]-1):indices[end]
    [(new_idx, map(ra->ra[i], rolling_ar[new_idx])) for i in 1:num_updt]
end

function _arrange_ll_to_plot(ll, indices, v1::Val{1})
    nu = length(ll[1])
    idx_to_plot = 1:(nu*indices[end])
    ( idx_to_plot, collect(Iterators.flatten(ll[indices])) )
end


function _arrange_ll_to_plot(ll, indices, v1)
    nu = length(ll[1])
    idx_to_plot = (nu*indices[1]-nu):(nu*indices[end])
    new_idx = (indices[1]-1):indices[end]
    ( idx_to_plot, collect(Iterators.flatten(ll[new_idx]))[nu:end] )
end

_const(ws::eMCMC.GlobalWorkspace) = (
    θ_len = length(ws.state),
    num_updts = length(ws.state_history[1]),
    N = length(ws.state_history)
)

@recipe function f(ws::eMCMC.GlobalWorkspace, v::K; indices=1:_const(ws).N) where {K<:Union{Val{:first}, Val{:all}}}
    layout --> (_const(ws).θ_len+1, 1)
    label --> ""
    #xguide --> (K <: Val{:first} ? "mcmc iteration" : "$(_const(ws).θ_len)*mcmc iteration")
    linecolor --> :steelblue
    (
        indices === nothing ?
        [([],[]) for _=1:_const(ws).θ_len+1] :
        vcat(
            _arrange_θs_to_plot(v, ws.state_history, indices, Val(indices[1])),
            _arrange_ll_to_plot(ws.ll_history, indices, Val(indices[1]))
        )
    )
end

@recipe function f(ws::eMCMC.GlobalWorkspace, v::Val{:ar}; indices=1:_const(ws).N)
    layout --> (_const(ws).num_updts, 1)
    label --> ""
    linecolor --> :steelblue
    xguide --> "mcmc iteration"
    (
        indices === nothing ?
        [([], []) for _=1:_const(ws).num_updts] :
        _arrange_ar_to_plot(ws.stats.rolling_ar, indices, Val(indices[1]))
    )
end
#=
using Plots
gr()
#pyplot()
plot_type = Val(:all)
num_refreshes = 1
num_segm = 99
segm_len = 100
updt_len = segm_len*num_segm
st = time()
begin
    for i in 1:num_refreshes
        p1 = plot(ws, plot_type; indices=1:((i-1)*updt_len+1))
        p2 = plot(ws, Val(:ar); indices=1:((i-1)*updt_len+1))
        p = plot(p1, p2, layout=(1,2), size=(1400,1000))
        d = display(p)
        println(typeof(p1))
        println("-------------")
        println(typeof(d))
        sleep(10)
        for k in ((i-1)*updt_len+1):segm_len:(i*updt_len)
            sleep(0.001)
            plot!(p1, ws, plot_type; indices=k:min((k+segm_len)))
            plot!(p2, ws, Val(:ar); indices=k:min((k+segm_len)))
            d = display(p)
        end
        i == num_refreshes || close(d)
    end
end
elapsed = time() - st
println("elapsed time: $elapsed.")

ws.ll_history

ws.acceptance_history

struct Foo
    data::Vector{Float64}
    t::Vector{Float64}
end

Base.length(foo::Foo) = length(foo.t)

@recipe function f(ws::Foo; idx_to_add=1:length(ws))
    ws.t[idx_to_add], ws.data[idx_to_add]
end

dt = 0.01
tt = collect(0.0:dt:1.0)
xx = zeros(Float64, length(tt))
xx[2:end]  = sqrt(dt) * randn(length(tt)-1)
cumsum!(xx, xx)
foo = Foo(xx, tt)

using Plots
pyplot()
begin
    p = plot(foo; idx_to_add=1:2, color=:steelblue)
    display(p)
    for i in 2:10
        sleep(1)
        plot!(p, foo; idx_to_add=i:(i+1), color=:steelblue)
        display(p)
    end
end




group = rand(map((i->begin
                    "group $(i)"
                end),1:4),100)
plot(rand(100),layout=@layout([a b;c]),group=group,linetype=[:bar :scatter :steppre])
=#
