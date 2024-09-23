
include("Board.jl")
include("Game.jl")


testb::Observable{Board} = Observable(fill(:empty, 6, 7))
testb[] = map(x -> rand([:red, :yellow, :empty]), testb[])

f = Figure(size = (800,800))
ax = Axis(f[1,1], aspect = DataAspect()); hidedecorations!(ax); hidespines!(ax)

qwe = drawBoard(ax, testb)

a = @lift([ filter(y -> y != :empty, $testb[:, i]) for i in 1:7 ])
foreach(x -> while length(a[][x]) != 6; push!(a[][x], :empty); end, eachindex(a[]))
a = @lift( reshape(reduce(vcat, $a), 6, 7) )


playpos = Observable(Point2f(0,0))
sectionboxfunc = on(events(ax).mouseposition) do event
    playpos[] = Point2f(mouseposition(ax)...)
end

poly!(ax, @lift( Circle($playpos, 40.0)), color = :red)



drawBoard(ax, a)





