println("Importing GLMakie..")
using GLMakie
println("Importing GeometryBasics..")
using GeometryBasics
println("Done adding packages")

# Main Board struct
struct Board
    board::Observable{Matrix{Symbol}}
    poses::Matrix{Point{2, Float64}}
    
    
    function Board()
        board = EmptyBoard()
        for x in 1:7
            y_max = rand(1:6)
            for y in 1:y_max
                board.board[][y,x] = rand([:red, :yellow])
            end
        end
        board
    end

    

    function Board(board::Matrix{Symbol})
        poses = [ Point2((100x - 50.0, 100y - 50.0)) for y in 1:6, x in 1:7 ]
        new(Observable(board), poses)
    end

    function Base.show(io::IO, b::Board)
        out = ""
        for y in 1:6
            for x in 1:7
                out *= b.board[][7-y, x] == :empty  ? "  " :
                       b.board[][7-y, x] == :red    ? "🔴" :
                       b.board[][7-y, x] == :yellow ? "🟡" :
                       "?"
            end
            out *= "\n"
        end
        println(io, out)
    end
end

function EmptyBoard()
    Board(fill(:empty, 6, 7))
end



import Base.copy
copy(board::Board) = Board(copy(board.board[]))

abstract type Result end
struct Win <: Result winner::Symbol end
struct Draw <: Result end
struct Ongoing <: Result end

result(board::Board) = Ongoing()


# Displaying

c4red = RGBAf(0.976470588235,0.121568627451,0.21568627451);
c4yellow = RGBAf(0.980392156863,0.890196078431,0.207843137255);
c4blue = RGBAf(0.1098,0.380392156863,0.9411);
empty = 0; red = 1; yellow = 2

colorer(symbol::Symbol) = symbol == :red ? c4red : symbol == :yellow ? c4yellow : symbol != :empty ? symbol : RGBAf(1, 1, 1, 0.0)


function drawBoardPlate(ax::Axis, board::Board)
    p = Polygon(
        Point2d[(0,0),(700,0),(700,600),(0,600)],
        vec(map(x -> collect(coordinates(Circle(x, 40))), board.poses))
    );
    return poly!(ax, p, color = (c4blue, 0.3))
end

function drawBoardPlate(ax::Axis, board::Board, bp)
    delete!(ax, bp)
    p = Polygon(
        Point2d[(0,0),(700,0),(700,600),(0,600)],
        vec(map(x -> collect(coordinates(Circle(x, 40))), board.poses))
    );
    return poly!(ax, p, color = (c4blue, 0.3))
end



function drawBoard(ax::Axis, board::Board)

    ob = map(x -> begin
            lift(y -> colorer(y[x]), board.board)
        end, eachindex(board.board[]))
    # Turns the observable board of chips into a board of observable colours which listens to the original board
     
    foreach((p,c) -> begin
        poly!(ax, Circle(p, 50.0), color = c)
    end, board.poses, ob)
    
    boardplate = drawBoardPlate(ax, board)
    
    return ob, boardplate
end

function playerMove!(board::Board, player::Symbol, colIndex::Int)
    # Find the first empty row in the column
    for y in 1:6
        if board.board[][y, colIndex] == :empty
            board.board[][y, colIndex] = player
            notify(board.board)
            return
        end
    end
    error("Column $colIndex is full!")
end


# Animation for pieces falling

# struct PieceMover
#     startIndex::CartesianIndex
#     endIndex::CartesianIndex
#     distance::Int
#     time::Real

#     function PieceMover(startIndex::CartesianIndex, endIndex::CartesianIndex, time::Real)
#         new(startIndex, endIndex, startIndex[1] - endIndex[1], time)
#     end
# end

# function Base.iterate(pm::PieceMover, state = 0)
#     smoothstep(x) = x * x * x
#     # 60fps
#     ts(x) = smoothstep(x * (1/60) / pm.time / d)

#     end_time = 60 * pm.time * d

#     if state > ent_time
#         return nothing
#     else
#         interp = ts(state)
#         return (
#             (1-interp) * pm.poses[pm.startIndex] + interp * pm.poses[pm.endIndex],
#             state + 1,
#         )
#     end
# end

# Base.iterate(n::Nothing, state = 0) = nothing



# shifts = [ findall(x -> x == :empty, testb[][:, i]) for i in 1:7 ]
# movers = []
# for x in 1:7
#     for y in 1:6
#         y in shifts[x] && continue
#         ct = count(z -> z < y, shifts[x])
#         ct == 0 && continue

#         st = CartesianIndex(y, x)
#         en = CartesianIndex(y - ct, x)
#         push!(movers, PieceMover(st, en, 1))
#     end
# end
# movers


# begin
#     startcs = map(x -> testb[][x.startIndex], movers)
#     foreach(x -> testb[][x.startIndex] = :empty, movers)
    
#     nexts = map(iterate, movers)
#     animposes = map(x -> Observable(x[1]), nexts)
#     circs = map((x, c) -> poly!(ax, @lift(Circle($x, 50.0)), color = colorer(c)), animposes, startcs)
    
#     notify(testb)

#     boardplate = drawBoardPlate(ax, boardplate)

#     while !all(isnothing, nexts)
#         foreach((x,y) ->  if !(isnothing(y) || isnothing(x)); x[] = y[1]; end, animposes, nexts)
#         states = map(y -> isnothing(y) ? y : y[2], nexts)
#         nexts = map((x,y) -> if !(isnothing(y) || isnothing(x)); iterate(x, y); end, movers, states)
#         sleep(1/60)
#     end
#     foreach((p,col,c) -> begin
#         testb[][p.endIndex] = col
#         delete!(ax, c)
#     end, movers, startcs, circs)
#     notify(testb)
# end