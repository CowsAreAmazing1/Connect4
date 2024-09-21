
include("Board.jl")
include("Game.jl")


testb::Observable{Board} = Observable(fill(:empty, 6, 7))
testb[] = map(x -> rand([:red, :yellow, :green, :blue, :empty]), testb[])


f = Figure(size = (800,800))
ax = Axis(f[1,1], aspect = DataAspect()); hidedecorations!(ax); hidespines!(ax)

qwe = drawBoard(ax, testb)

testb[][1, :]
testb[][:, 1]

