using GLMakie

poses = [ Point2(100x - 50.0, 100y - 50.0) for x in 1:7, y in 1:6 ]


c4red = RGBf(0.976470588235,0.121568627451,0.21568627451);
c4yellow = RGBf(0.980392156863,0.890196078431,0.207843137255);


f = Figure(size = (800,800))
ax = Axis(f[1,1], aspect = DataAspect())

poly!(ax, Point2.([(0,0),(700,0),(700,600),(0,600)]), color = RGBf(0.1098,0.380392156863,0.9411))
poly!.(ax, Circle.(poses, 40.0), color = :white)

while true
    poly!(ax, Circle(rand(poses), 40.0), color = rand([c4red, c4yellow]))
    sleep(1/100)
end

# arc!.(ax, vec(poses), 50, -pi, pi)
