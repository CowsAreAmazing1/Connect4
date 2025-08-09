# println("Starting...")
# println("Adding external files...")

include("Board.jl")
# println("Added Board.jl")

include("Game.jl")
# println("Added Game.jl")
# println("Done! Running main...")

testBoard = EmptyBoard()
game = GameNode(testBoard, :red)

# f = Figure(size = (800,800))
# ax = Axis(f[1,1], aspect = DataAspect()); hidedecorations!(ax); hidespines!(ax)

# _, boardplate = drawBoard(ax, testBoard);

allMoves!(game)