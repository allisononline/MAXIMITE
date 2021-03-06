CENTRE.X = (MM.HRes/2)
CENTRE.Y = (MM.VRes/2)
DRAW.X.1 = 0
DRAW.Y.1 = 0
DRAW.X.2 = 0
DRAW.Y.2 = 0
UNIT = 50
INCRE = 15
DISTANCE = 240

Sub LOADTESSERACT()
    POINTS = 16
    VERTICES = 12
    Dim POINT(POINTS, 4)
    Dim VERTEX(VERTICES, 2)
    For i = 0 to POINTS-1
        For j = 0 to 3
            If i AND 2^j <> 0 THEN
                POINT(i,j) = UNIT
            Else
                POINT(i,j) = -UNIT
            EndIf
        Next
    Next
End Sub

Sub LOADTESSERACTOLD()
    POINTS = 16
    VERTICES = 32
    Dim POINT(POINTS, 4)
    Dim VERTEX(VERTICES, 2)
    POINT(0,0) = -UNIT:POINT(0,1) = -UNIT:POINT(0,2) = -UNIT:POINT(0,3) = -UNIT
    POINT(1,0) = -UNIT:POINT(1,1) = -UNIT:POINT(1,2) = -UNIT:POINT(1,3) = UNIT
    POINT(2,0) = -UNIT:POINT(2,1) = -UNIT:POINT(2,2) = UNIT:POINT(2,3) = -UNIT
    POINT(3,0) = -UNIT:POINT(3,1) = -UNIT:POINT(3,2) = UNIT:POINT(3,3) = UNIT
    POINT(4,0) = -UNIT:POINT(4,1) = UNIT:POINT(4,2) = -UNIT:POINT(4,3) = -UNIT
    POINT(5,0) = -UNIT:POINT(5,1) = UNIT:POINT(5,2) = -UNIT:POINT(5,3) = UNIT
    POINT(6,0) = -UNIT:POINT(6,1) = UNIT:POINT(6,2) = UNIT:POINT(6,3) = -UNIT
    POINT(7,0) = -UNIT:POINT(7,1) = UNIT:POINT(7,2) = UNIT:POINT(7,3) = UNIT
    POINT(8,0) = UNIT:POINT(8,1) = -UNIT:POINT(8,2) = -UNIT:POINT(8,3) = -UNIT
    POINT(9,0) = UNIT:POINT(9,1) = -UNIT:POINT(9,2) = -UNIT:POINT(9,3) = UNIT
    POINT(10,0) = UNIT:POINT(10,1) = -UNIT:POINT(10,2) = UNIT:POINT(10,3) = -UNIT
    POINT(11,0) = UNIT:POINT(11,1) = -UNIT:POINT(11,2) = UNIT:POINT(11,3) = UNIT
    POINT(12,0) = UNIT:POINT(12,1) = UNIT:POINT(12,2) = -UNIT:POINT(12,3) = -UNIT
    POINT(13,0) = UNIT:POINT(13,1) = UNIT:POINT(13,2) = -UNIT:POINT(13,3) = UNIT
    POINT(14,0) = UNIT:POINT(14,1) = UNIT:POINT(14,2) = UNIT:POINT(14,3) = -UNIT
    POINT(15,0) = UNIT:POINT(15,1) = UNIT:POINT(15,2) = UNIT:POINT(15,3) = UNIT
    VERTEX(0,0) = 0:VERTEX(0,1) = 1
    VERTEX(1,0) = 4:VERTEX(1,1) = 5
    VERTEX(2,0) = 0:VERTEX(2,1) = 4
    VERTEX(3,0) = 1:VERTEX(3,1) = 5
    VERTEX(4,0) = 2:VERTEX(4,1) = 3
    VERTEX(5,0) = 6:VERTEX(5,1) = 7
    VERTEX(6,0) = 2:VERTEX(6,1) = 6
    VERTEX(7,0) = 3:VERTEX(7,1) = 7
    VERTEX(8,0) = 0:VERTEX(8,1) = 2
    VERTEX(9,0) = 1:VERTEX(9,1) = 3
    VERTEX(10,0) = 4:VERTEX(10,1) = 6
    VERTEX(11,0) = 5:VERTEX(11,1) = 7
    VERTEX(12,0) = 8:VERTEX(12,1) = 9
    VERTEX(13,0) = 12:VERTEX(13,1) = 13
    VERTEX(14,0) = 8:VERTEX(14,1) = 12
    VERTEX(15,0) = 9:VERTEX(15,1) = 13
    VERTEX(16,0) = 10:VERTEX(16,1) = 11
    VERTEX(17,0) = 14:VERTEX(17,1) = 15
    VERTEX(18,0) = 10:VERTEX(18,1) = 14
    VERTEX(19,0) = 11:VERTEX(19,1) = 15
    VERTEX(20,0) = 8:VERTEX(20,1) = 10
    VERTEX(21,0) = 9:VERTEX(21,1) = 11
    VERTEX(22,0) = 12:VERTEX(22,1) = 14
    VERTEX(23,0) = 13:VERTEX(23,1) = 15
    VERTEX(24,0) = 0:VERTEX(24,1) = 8
    VERTEX(25,0) = 1:VERTEX(25,1) = 9
    VERTEX(26,0) = 2:VERTEX(26,1) = 10
    VERTEX(27,0) = 3:VERTEX(27,1) = 11
    VERTEX(28,0) = 4:VERTEX(28,1) = 12
    VERTEX(29,0) = 5:VERTEX(29,1) = 13
    VERTEX(30,0) = 6:VERTEX(30,1) = 14
    VERTEX(31,0) = 7:VERTEX(31,1) = 15
End Sub

Sub ROTATE(DIR$)
    x = 0
    y = 0
    z = 0
    w = 0
    For i = 0 To POINTS - 1
        If DIR$ = "XY" Then
            x = (POINT(i,0)*Cos(Rad(-INCRE)))-(POINT(i,1)*Sin(Rad(-INCRE)))
            y = (POINT(i,0)*Sin(Rad(-INCRE)))+(POINT(i,1)*Cos(Rad(-INCRE)))
            POINT(i,0) = x
            POINT(i,1) = y
        ElseIf DIR$ = "XZ" Then
            x = (POINT(i,0)*Cos(Rad(-INCRE)))-(POINT(i,2)*Sin(Rad(-INCRE)))
            z = (POINT(i,0)*Sin(Rad(-INCRE)))+(POINT(i,2)*Cos(Rad(-INCRE)))
            POINT(i,0) = x
            POINT(i,2) = z
        ElseIf DIR$ = "YZ" Then
            y = (POINT(i,1)*Cos(Rad(-INCRE)))-(POINT(i,2)*Sin(Rad(-INCRE)))
            z = (POINT(i,1)*Sin(Rad(-INCRE)))+(POINT(i,2)*Cos(Rad(-INCRE)))
            POINT(i,1) = y
            POINT(i,2) = z
        ElseIf DIR$ = "WX" Then
            w = (POINT(i,3)*Cos(Rad(-INCRE)))-(POINT(i,0)*Sin(Rad(-INCRE)))
            x = (POINT(i,3)*Sin(Rad(-INCRE)))+(POINT(i,0)*Cos(Rad(-INCRE)))
            POINT(i,3) = w
            POINT(i,0) = x
        ElseIf DIR$ = "WY" Then
            w = (POINT(i,3)*Cos(Rad(-INCRE)))-(POINT(i,1)*Sin(Rad(-INCRE)))
            y = (POINT(i,3)*Sin(Rad(-INCRE)))+(POINT(i,1)*Cos(Rad(-INCRE)))
            POINT(i,3) = w
            POINT(i,1) = y
        ElseIf DIR$ = "WZ" Then
            w = (POINT(i,3)*Cos(Rad(-INCRE)))-(POINT(i,2)*Sin(Rad(-INCRE)))
            z = (POINT(i,3)*Sin(Rad(-INCRE)))+(POINT(i,2)*Cos(Rad(-INCRE)))
            POINT(i,3) = w
            POINT(i,2) = z
        EndIf
    Next
End Sub

Sub KEYPRESS()
    KEYPRESS$ = Inkey$
    If KEYPRESS$ <> "" Then
        If KEYPRESS$ = "q" Then
            ROTATE("XY")
            DRAW()
        ElseIf KEYPRESS$ = "e" Then
            ROTATE("XZ")
            DRAW()
        ElseIf KEYPRESS$ = "w" Then
            ROTATE("YZ")
            DRAW()
        ElseIf KEYPRESS$ = "s" Then
            ROTATE("WX")
            DRAW()
        ElseIf KEYPRESS$ = "a" Then
            ROTATE("WY")
            DRAW()
        ElseIf KEYPRESS$ = "d" Then
            ROTATE("WY")
            DRAW()
        EndIf
    EndIf
End Sub

Function FOV(COORD1,COORD2)
    ANGLE = Deg(Atn(COORD1 / (DISTANCE + COORD2)))
    FOV = (Tan(Rad(ANGLE)) * DISTANCE)
End Function

Sub DRAW()
    Cls
    FOR i = 0 TO VERTICES - 1
        DRAW.X.1 = FOV(POINT(VERTEX(i,0),1),POINT(VERTEX(i,0),3))
        DRAW.Y.1 = FOV(POINT(VERTEX(i,0),2),POINT(VERTEX(i,0),3))
        DRAW.X.2 = FOV(POINT(VERTEX(i,1),1),POINT(VERTEX(i,1),3))
        DRAW.Y.2 = FOV(POINT(VERTEX(i,1),2),POINT(VERTEX(i,1),3))
        DRAW.X.1 = FOV(DRAW.X.1,POINT(VERTEX(i,0),0))
        DRAW.Y.1 = FOV(DRAW.Y.1,POINT(VERTEX(i,0),0))
        DRAW.X.2 = FOV(DRAW.X.2,POINT(VERTEX(i,1),0))
        DRAW.Y.2 = FOV(DRAW.Y.2,POINT(VERTEX(i,1),0))
        LINE(CENTRE.X+DRAW.X.1,CENTRE.Y+DRAW.Y.1)-(CENTRE.X+DRAW.X.2,CENTRE.Y+DRAW.Y.2),2
    NEXT
End Sub

LOADTESSERACTOLD()
DRAW()
Do
KEYPRESS()
Loop
