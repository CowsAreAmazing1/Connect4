using GLMakie

const Board = Matrix{Symbol}
c4red = RGBf(0.976470588235,0.121568627451,0.21568627451);
c4yellow = RGBf(0.980392156863,0.890196078431,0.207843137255);
c4blue = RGBf(0.1098,0.380392156863,0.9411);
empty = 0; red = 1; yellow = 2










function drawBoard(ax:: Axis, board::Union{Board, Observable{Board}})
    poses = [ Point2(100x - 50.0, 100y - 50.0) for x in 1:7, y in 1:6 ] # Centers for the 7x6 grid of circles
    ob = @lift( reshape(map(x -> lift(y -> y[x] == :red ? c4red : y[x] == :yellow ? c4yellow : :white, board), eachindex($board)), 6, 7)) # Turns the observable board of chips into an observable board of observable colours which listens to the original board


    poly!(ax, Point2.([(0,0),(700,0),(700,600),(0,600)]), color = c4blue)
    foreach((p,c) -> begin
        poly!(ax, Circle(p, 40.0), color = c)
    end, poses, ob[])

    return ob
end