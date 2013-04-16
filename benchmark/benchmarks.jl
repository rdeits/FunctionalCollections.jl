using Benchmark
using PersistentDataStructures

function appending(::Type{PersistentVector})
    function ()
        v = PersistentVector{Int}()
        for i=1:50000
            v = append(v, i)
        end
    end
end
function appending(::Type{TransientVector})
    function ()
        v = TransientVector{Int}()
        for i=1:50000
            v = push!(v, i)
        end
    end
end
function appending(::Type{Array})
    function ()
        a = Int[]
        for i=1:50000
            a = push!(a, i)
        end
    end
end

println("Appending")
println(compare([appending(PersistentVector), appending(TransientVector), appending(Array)], 20))

function vec(r::Range1)
    v = TransientVector{Int}()
    for i=r
        push!(v, i)
    end
    persist!(v)
end

const pv = vec(1:1000000)
const arr = Array(Int, 1000000)

function iterating(::Type{PersistentVector})
    function ()
        for el in pv
            nothing
        end
    end
end
function iterating(::Type{Array})
    function ()
        for el in arr
            nothing
        end
    end
end

println("Iterating")
println(compare([iterating(PersistentVector), iterating(Array)], 20))

function indexing{T}(v::PersistentVector{T})
    function ()
        for _ in 500000
            v[rand(1:length(v))]
        end
    end
end
function indexing{T}(a::Array{T})
    function ()
        for _ in 500000
            a[rand(1:length(a))]
        end
    end
end

println("Indexing")
println(compare([indexing(vec(1:1000000)), indexing(Array(Int, 1000000))], 20))

function popping(::Type{PersistentVector})
    v = vec(1:100000)
    function ()
        v2 = v
        for _ in 1:length(v2)
            v2 = pop(v2)
        end
    end
end
function popping(::Type{Array})
    function ()
        a = Array(Int, 100000)
        for _ in 1:length(a)
            pop!(a)
        end
    end
end

println("Popping")
println(compare([popping(PersistentVector), popping(Array)], 20))

function updating(v::PersistentVector)
    function ()
        for _ in 500000
            update(v, rand(1:length(v)), 1)
        end
    end
end
function updating(a::Array)
    function ()
        for _ in 500000
            a[rand(1:length(a))] = 1
        end
    end
end

println("Updating")
println(compare([updating(vec(1:100000)), updating(Array(Int, 100000))], 20))