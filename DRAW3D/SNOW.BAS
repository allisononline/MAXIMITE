Library Load "DRAW3D.LIB"
PARTICLES = 50

Sub INITIALISE
    CENTRE.X = MM.HRes/2
    CENTRE.Y = MM.VRes/2
    Dim SNOW(PARTICLES,3)
    For i = 0 To PARTICLES - 1
        GENERATE(i)
        SNOW(NUMBER,1) = SNOW(NUMBER,1)+MM.VRes
    Next
End Sub

Sub GENERATE(NUMBER)
    For k = 0 To 2
        SNOW(NUMBER,k) = (Rnd()*400) - 200
    Next
End Sub

Sub DRAW(NUMBER2,COLOUR)
    DOT.X = CENTRE.X+FOV(SNOW(NUMBER2,0),SNOW(NUMBER2,2))
    DOT.Y = CENTRE.Y-FOV(SNOW(NUMBER2,1),SNOW(NUMBER2,2))
    Pixel(DOT.X,DOT.Y) = COLOUR
End Sub

Sub MOVE(NUMBER3)
    SNOW(NUMBER3,1) = SNOW(NUMBER3,1) - 10
    If SNOW(NUMBER3,1) < -200 Then
        GENERATE(NUMBER3)
        SNOW(NUMBER3,1) = 200
    EndIf
End Sub

INITIALISE
Do
    For j = 0 To PARTICLES - 1
        DRAW(j,0)
        MOVE(j)
        DRAW(j,7)
    Next
Loop
