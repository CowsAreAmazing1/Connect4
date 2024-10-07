# println("Starting...")
# println("Adding external files...")

include("Board.jl")
# println("Added Board.jl")

include("Game.jl")
# println("Added Game.jl")
# println("Done! Running main...")

testb::Observable{Board} = Observable(fill(:empty, 6, 7))
testb[] = map(x -> rand([:red, :yellow, :empty]), testb[])

f = Figure(size = (800,800))
ax = Axis(f[1,1], aspect = DataAspect()); hidedecorations!(ax); hidespines!(ax)

_, boardplate = drawBoard(ax, testb);


shifts = [ findall(x -> x == :empty, testb[][:, i]) for i in 1:7 ]
movers = []
for x in 1:7
    for y in 1:6
        y in shifts[x] && continue
        ct = count(z -> z < y, shifts[x])
        ct == 0 && continue

        st = CartesianIndex(y, x)
        en = CartesianIndex(y - ct, x)
        push!(movers, PieceMover(st, en, 1))
    end
end
movers


begin
    startcs = map(x -> testb[][x.startIndex], movers)
    foreach(x -> testb[][x.startIndex] = :empty, movers)
    
    nexts = map(iterate, movers)
    animposes = map(x -> Observable(x[1]), nexts)
    circs = map((x, c) -> poly!(ax, @lift(Circle($x, 50.0)), color = colorer(c)), animposes, startcs)
    
    notify(testb)

    boardplate = drawBoardPlate(ax, boardplate)

    while !all(isnothing, nexts)
        foreach((x,y) ->  if !(isnothing(y) || isnothing(x)); x[] = y[1]; end, animposes, nexts)
        states = map(y -> isnothing(y) ? y : y[2], nexts)
        nexts = map((x,y) -> if !(isnothing(y) || isnothing(x)); iterate(x, y); end, movers, states)
        sleep(1/60)
    end
    foreach((p,col,c) -> begin
        testb[][p.endIndex] = col
        delete!(ax, c)
    end, movers, startcs, circs)
    notify(testb)
end
