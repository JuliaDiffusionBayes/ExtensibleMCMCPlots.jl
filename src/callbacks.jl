#===============================================================================
                            Plotting callback
===============================================================================#
mutable struct PlottingCallback{T,K} <: eMCMC.Callback
    segm_len::Int64
    num_segm::Int64
    plot_type::K
    size::Tuple{Int64,Int64}
    p1::T
    p2::T
    p::T

    function PlottingCallback(;segm_len, num_segm, size=(1400,1000), first_updt_only=true)
        p1, p2 = plot([1,2],[2,3]), plot()
        p = plot(p1, p2, layout=(1,2), size=size)
        plot_type = ( first_updt_only ? Val(:first) : Val(:all) )
        new{typeof(p1),typeof(plot_type)}(
            segm_len,
            num_segm,
            plot_type,
            size,
            p1,
            p2,
            p,
        )
    end
end

function eMCMC.check_if_execute(callback::PlottingCallback, iter)
    (
        (iter.mcmciter-1) % callback.segm_len == 0 &&
        (iter.pidx == 1) &&
        iter.mcmciter > 1
    )
end

function eMCMC.init!(callback::PlottingCallback, ws::eMCMC.GlobalWorkspace)
    callback.p1 = plot(ws, callback.plot_type; indices=nothing)
    callback.p2 = plot(ws, Val(:ar); indices=nothing)
    callback.p = plot(callback.p1, callback.p2, layout=(1,2), size=callback.size)
    display(callback.p)
end

function reinit!(callback::PlottingCallback, ws::eMCMC.GlobalWorkspace, iter)
    callback.p1 = plot(
        ws,
        callback.plot_type;
        indices = 1:(iter.mcmciter-1)
        #yguide = [
        #    (i == length(ws.state)+1 ? "log-likelihood" : "θ$i")
        #    for i in 1:length(ws.state)+1
        #]
    )
    callback.p2 = plot(
        ws,
        Val(:ar);
        indices = 1:(iter.mcmciter-1),
        #yguide = [
        #    "update $i" for i in 1:length(ws.state_history[1])
        #]
    )
    callback.p = plot(
        callback.p1,
        callback.p2,
        layout = (1,2),
        size = callback.size,
    )
    display(callback.p)
end

function update!(callback::PlottingCallback, ws::eMCMC.GlobalWorkspace, iter)
    plot!(
        callback.p1,
        ws,
        callback.plot_type;
        indices = (iter.mcmciter-callback.segm_len):(iter.mcmciter-1)
    )
    plot!(
        callback.p2,
        ws,
        Val(:ar);
        indices = (iter.mcmciter-callback.segm_len):(iter.mcmciter-1)
    )
    display(callback.p)
end


"""
    execute!(callback::Callback, ws::GlobalWorkspace, iter)

Execute the `callback`.
"""
function eMCMC.execute!(callback::PlottingCallback, lws::eMCMC.LocalWorkspace, ws::eMCMC.GlobalWorkspace, iter)
    (
        div(iter.mcmciter-1, callback.segm_len) %
        callback.num_segm == 0
    ) && return reinit!(callback, ws, iter)
    update!(callback, ws, iter)
end
