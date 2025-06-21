println("Importing GLMakie..")
using GLMakie
println("Importing GeometryBasics..")
using GeometryBasics
println("Done adding packages")

const BoardM = Matrix{Symbol}

struct Board
    
end



c4red = RGBAf(0.976470588235,0.121568627451,0.21568627451);
c4yellow = RGBAf(0.980392156863,0.890196078431,0.207843137255);
c4blue = RGBAf(0.1098,0.380392156863,0.9411);
empty = 0; red = 1; yellow = 2

colorer(x) = x == :red ? c4red : x == :yellow ? c4yellow : x != :empty ? x : RGBAf(1, 1, 1, 0.0)


poses = [ Point2((100x - 50.0, 100y - 50.0)) for y in 1:6, x in 1:7 ] # Centers for the 7x6 grid of circles

function drawBoardPlate(ax)
    p = Polygon(
        Point2d[(0,0),(700,0),(700,600),(0,600)],
        vec(map(x -> collect(coordinates(Circle(x, 40))), poses))
    );
    return poly!(ax, p, color = (c4blue, 0.3))
end

function drawBoardPlate(ax, bp)
    delete!(ax, bp)
    p = Polygon(
        Point2d[(0,0),(700,0),(700,600),(0,600)],
        vec(map(x -> collect(coordinates(Circle(x, 40))), poses))
    );
    return poly!(ax, p, color = (c4blue, 0.3))
end



function drawBoard(ax:: Axis, board::Observable{Board})

    ob = map(x -> begin
            lift(y -> colorer(y[x]), board)
        end, eachindex(board[]))
    # Turns the observable board of chips into a board of observable colours which listens to the original board
     
     
    foreach((p,c) -> begin
        poly!(ax, Circle(p, 50.0), color = c)
    end, poses, ob)
    
    boardplate = drawBoardPlate(ax)
    
    return ob, boardplate
end


struct PieceMover
    startIndex::CartesianIndex
    endIndex::CartesianIndex
    time::Real

    PieceMover(s::CartesianIndex, e::CartesianIndex, t::Real) = begin
        new(s, e, t)
    end
end

Base.iterate(pm::PieceMover, state = 0) = begin
    d = pm.startIndex[1] - pm.endIndex[1]

    smoothstep(x) = x * x * x * x
    ts(x) = smoothstep(x / 60 / pm.time / d)

    state > 60pm.time*d ? nothing : (
        (1-ts(state)) * poses[pm.startIndex] + 
        ts(state)     * poses[pm.endIndex], state + 1
    )
end

Base.iterate(n::Nothing, state = 0) = nothing