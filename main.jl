println("Starting...")
println("Adding external files...")

include("Board.jl")
println("Added Board.jl")

include("Game.jl")
println("Added Game.jl")
println("Done! Running main...")

testb::Observable{Board} = Observable(fill(:empty, 6, 7))
testb[] = map(x -> rand([:red, :yellow, :empty]), testb[])

f = Figure(size = (800,800))
ax = Axis(f[1,1], aspect = DataAspect()); hidedecorations!(ax); hidespines!(ax)

q = drawBoard(ax, testb)


shifts = [ findall(x -> x == :empty, testb[][:, i]) for i in 1:7 ]

movers = []
for x in 1:7
    for y in 1:6
        y in shifts[x] && continue
        ct = count(z -> z < y, shifts[x])
        ct == 0 && continue

        st = CartesianIndex(y, x)
        en = CartesianIndex(y - ct, x)
        push!(movers, PieceMover(st, en, 0.3))
    end
end

display(f)

println("gonna threads soon")
sleep(5)

Threads.@threads :static for i in movers
    sleep(5rand())
    animatePiece(testb, i)
end


#=
foreach(x -> begin
    c = testb[][x.startIndex]
    testb[][x.startIndex] = :empty

    next = iterate(x)
    pos = Observable(next[1])
    poly!(ax, @lift(Circle($pos, 40.0)), color = colorer(c))

    Threads.@spawn while next !== nothing
        pos[], state = next
        next = iterate(x, state)
        sleep(1/60)
    end


end, movers); notify(testb)


foreach(x -> begin
    c = testb[][x.startIndex]
    testb[][x.startIndex] = :empty
    testb[][x.endIndex]   = c
end, movers)
notify(testb)


movers


testb = @lift([ filter(y -> y != :empty, $testb[:, i]) for i in 1:7 ])
foreach(x -> while length(a[][x]) != 6; push!(a[][x], :empty); end, eachindex(a[]))
a = @lift( reshape(reduce(vcat, $a), 6, 7) )


playpos = Observable(Point2f((0,0)))
sectionboxfunc = on(events(ax).mouseposition) do event
    playpos[] = Point2f(mouseposition(ax)...)
end

poly!(ax, @lift( Circle($playpos, 40.0)), color = :red)

drawBoard(ax, a)




pos1 = CartesianIndex(1,1)
pos2 = CartesianIndex(3,2)
pm = PieceMover(pos1, pos2, 1)

pos = Observable(poses[pos1])
next = iterate(pm)

f, ax = scatter(poses[pos2])
scatter!(ax, poses[pos1]); scatter!(ax, pos)
ax.limits = (0, 700, 0, 600)

while next !== nothing
    pos[], state = next
    next = iterate(pm, state)
    sleep(1/60)
end

=#