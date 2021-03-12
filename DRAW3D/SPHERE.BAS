Function FOV(COORD1,COORD2)
    DISTANCE = 240
    ANGLE = Atn(COORD1/(DISTANCE+COORD2))
    FOV = (Tan(ANGLE)*DISTANCE)
End Function

CENTRE.X = MM.HRes/2
CENTRE.Y = MM.VRes/2
STEPS = 8-1
For i = 0 To STEPS
    ANGLE.Y = Pi*(i/STEPS)
    For j = 0 To STEPS
        ANGLE.X = Pi*(j/STEPS)
        For k = 0 To STEPS
            ANGLE.Z = Pi*(k/STEPS)
            X = (100*Sin(ANGLE.X))-50
            Y = (100*Sin(ANGLE.Y))-50
            Z = (100*Sin(ANGLE.Z))-50
            Pixel(CENTRE.X+FOV(X,Z),CENTRE.Y-FOV(Y,Z)) = White
        Next
    Next
Next
