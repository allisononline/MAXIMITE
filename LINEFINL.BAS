CENTRE.X = (MM.HRes/2)
CENTRE.Y = (MM.VRes/2)
DRAW.X.1 = 0
DRAW.Y.1 = 0
DRAW.X.2 = 0
DRAW.Y.2 = 0
UNIT = 75
INCRE = 15

i = 0
x = 0
y = 0
z = 0

Sub LOADSQUARE()
    POINTS = 8
    VERTICES = 12
    Dim POINT(POINTS, 3)
    Dim VERTEX(VERTICES, 2)
    For i = 0 To 7
        If i Mod (2) > 0 Then
            POINT(i, 2) = UNIT
        Else
            POINT(i, 2) = (0 - UNIT)
        EndIf
        If i Mod (4) > 1 Then
            POINT(i, 1) = UNIT
        Else
            POINT(i, 1) = (0 - UNIT)
        EndIf
        If i > 3 Then
            POINT(i, 0) = UNIT
        Else
            POINT(i, 0) = (0 - UNIT)
        EndIf
        POINT(i, 3) = 1
    Next
    VERTEX(0, 0) = 0 : VERTEX(0, 1) = 1
    VERTEX(1, 0) = 4 : VERTEX(1, 1) = 5
    VERTEX(2, 0) = 0 : VERTEX(2, 1) = 4
    VERTEX(3, 0) = 1 : VERTEX(3, 1) = 5
    VERTEX(4, 0) = 2 : VERTEX(4, 1) = 3
    VERTEX(5, 0) = 6 : VERTEX(5, 1) = 7
    VERTEX(6, 0) = 2 : VERTEX(6, 1) = 6
    VERTEX(7, 0) = 3 : VERTEX(7, 1) = 7
    VERTEX(8, 0) = 0 : VERTEX(8, 1) = 2
    VERTEX(9, 0) = 1 : VERTEX(9, 1) = 3
    VERTEX(10, 0) = 4 : VERTEX(10, 1) = 6
    VERTEX(11, 0) = 5 : VERTEX(11, 1) = 7
End Sub

Sub ROTATE(DIR$)
    For i = 0 To POINTS - 1
        If DIR$ = "ZMINUS" Then
            x = (POINT(i, 0) * Cos(Rad(INCRE))) - (POINT(i, 1) * Sin(Rad(INCRE)))
            y = (POINT(i, 0) * Sin(Rad(INCRE))) + (POINT(i, 1) * Cos(Rad(INCRE)))
            POINT(i, 0) = x
            POINT(i, 1) = y
        ElseIf DIR$ = "ZPLUS" Then
            x = (POINT(i, 0) * Cos(Rad(-INCRE))) - (POINT(i, 1) * Sin(Rad(-INCRE)))
            y = (POINT(i, 0) * Sin(Rad(-INCRE))) + (POINT(i, 1) * Cos(Rad(-INCRE)))
            POINT(i, 0) = x
            POINT(i, 1) = y
        ElseIf DIR$ = "XMINUS" Then
            y = (POINT(i, 1) * Cos(Rad(INCRE))) - (POINT(i, 2) * Sin(Rad(INCRE)))
            z = (POINT(i, 1) * Sin(Rad(INCRE))) + (POINT(i, 2) * Cos(Rad(INCRE)))
            POINT(i, 1) = y
            POINT(i, 2) = z
        ElseIf DIR$ = "XPLUS" Then
            y = (POINT(i, 1) * Cos(Rad(-INCRE))) - (POINT(i, 2) * Sin(Rad(-INCRE)))
            z = (POINT(i, 1) * Sin(Rad(-INCRE))) + (POINT(i, 2) * Cos(Rad(-INCRE)))
            POINT(i, 1) = y
            POINT(i, 2) = z
        ElseIf DIR$ = "YMINUS" Then
            x = (POINT(i, 0) * Cos(Rad(INCRE))) - (POINT(i, 2) * Sin(Rad(INCRE)))
            z = (POINT(i, 0) * Sin(Rad(INCRE))) + (POINT(i, 2) * Cos(Rad(INCRE)))
            POINT(i, 0) = x
            POINT(i, 2) = z
        ElseIf DIR$ = "YPLUS" Then
            x = (POINT(i, 0) * Cos(Rad(-INCRE))) - (POINT(i, 2) * Sin(Rad(-INCRE)))
            z = (POINT(i, 0) * Sin(Rad(-INCRE))) + (POINT(i, 2) * Cos(Rad(-INCRE)))
            POINT(i, 0) = x
            POINT(i, 2) = z
        EndIf
    Next
End Sub

Sub KEYPRESS()
    KEYPRESS$ = InKey$
    If KEYPRESS$ <> "" Then
        If KEYPRESS$ = "q" Then
            ROTATE("ZMINUS")
            DRAW()
        ElseIf KEYPRESS$ = "e" Then
            ROTATE("ZPLUS")
            DRAW()
        ElseIf KEYPRESS$ = "w" Then
            ROTATE("XMINUS")
            DRAW()
        ElseIf KEYPRESS$ = "s" Then
            ROTATE("XPLUS")
            DRAW()
        ElseIf KEYPRESS$ = "a" Then
            ROTATE("YMINUS")
            DRAW()
        ElseIf KEYPRESS$ = "d" Then
            ROTATE("YPLUS")
            DRAW()
        EndIf
    EndIf
End Sub

Function FOV(POIMT, COORD)
    ANGLE = DEG(ATN(POINT(POIMT, COORD) / (240 + POINT(POIMT, 2))))
    FOV = (Tan(Rad(ANGLE)) * 240)
End Function

Sub DRAW()
    CLS
    For i = 0 To POINTS - 1
        DRAW.X.1 = FOV(i, 0)
        DRAW.Y.1 = FOV(i, 1)
        PIXEL(CENTRE.X+DRAW.X.1, CENTRE.Y+DRAW.Y.1) = 2
    Next
    FOR i = 0 TO VERTICES - 1
        DRAW.X.1 = FOV(VERTEX(i,0),0)
        DRAW.Y.1 = FOV(VERTEX(i,0),1)
        DRAW.X.2 = FOV(VERTEX(i,1),0)
        DRAW.Y.2 = FOV(VERTEX(i,1),1)
        LINE(CENTRE.X+DRAW.X.1,CENTRE.Y+DRAW.Y.1)-(CENTRE.X+DRAW.X.2,CENTRE.Y+DRAW.Y.2),2
    NEXT
End Sub

LOADSQUARE
DRAW()
DO
KEYPRESS()
LOOP