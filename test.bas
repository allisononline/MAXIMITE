Function Fov(Coord1,Coord2)
    Distance = 240
    Angle = Atn(Coord1 / (Distance + Coord2))
    Fov = (Tan(Angle) * Distance)
End Function

Print Fov(0,0)