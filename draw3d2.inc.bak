Sub Readfile
    Memmax = 1024
    Input "ENTER .OBJ FILE: ",Filename$
    Inline$ = ""
    Countpointslines(Filename$)
    Initpoints(Points)
    Initlines(Lines)
    Open Filename$ For Random As #3
    Seek #3,1
    Pointcnt = 0
    Linecnt = 0
    Print ""
    Print "LOADING POINTS & LINES"
    Do While Eof(#3) = 0
        Line Input #3,Inline$
        If Word$(Inline$,1) = "v" Then
            For V = 0 To 2
                Points(Pointcnt,V) = Val(Word$(Inline$,V+2))
            Next
            Pointcnt = Pointcnt + 1
        Elseif Word$(Inline$,1) = "f" Or Word$(Inline$,1) = "l" Then
            For F = 0 To 2
                Lines(Linecnt,F) = Val(Word$(Inline$,F+2))
            Next           
            Linecnt = Linecnt + 1
        Endif
        Progress(Lof(#3),Loc(#3))
    Loop 
    Close #3
    Normalise
End Sub

Sub Lowmem
    Clear
    Pointstart = 0
    Linestart = 0
    Placehold = 0
    Dim Points(3,3)
    Input "ENTER .OBJ FILE: ",Filename2$
    Countpointslines(Filename2$)
    Open Filename2$ For Random As #4
    Seek #4,1
    Do
        Line Input #4,Inline2$
    Loop Until Word$(Inline2$,1) = "v"
    Pointstart = Loc(#4) - Len(Inline2$)
    Seek #4,1
    Do
        Line Input #4,Inline2$
    Loop Until Word$(Inline2$,1) = "f" Or Word$(Inline2$,1) = "l"
    Linestart = Loc(#4) - Len(Inline2$)
    Seek #4,Linestart
    X = 0
    Cls
    Do Until X => Lines Or Eof(#4) <> 0
        Line Input #4,Inline2$
        If Word$(Inline2$,1) = "f" Or Word$(Inline2$,1) = "l" Then
            Placehold = Loc(#4)
            For Y = 0 To 2
                Gotoline = Val(Word$(Inline2$,Y+2))
                Seek #4,Pointstart
                For Z = 1 To Gotoline
                    Do
                        Line Input #4,Inline3$
                    Loop Until Word$(Inline3$,1) = "v"
                Next
                For W = 0 To 2
                    Points(Y,W) = Val(Word$(Inline3$,W+2))
                Next
            Next
            Normalise
            Lowmemlines
            Seek #4,Placehold
            X = X + 1
        Endif
    Loop
    Close #4
End Sub

Sub Lowmemlines
    Magx = 150
    Centre.X = Mm.Hres/2
    Centre.Y = Mm.Vres/2
    X1 = Centre.X+Fov((Points(0,0)*Magx)+Xoffset,-(Points(0,2)*Magx)+Zoffset)
    Y1 = Centre.Y-Fov((Points(0,1)*Magx)+Yoffset,-(Points(0,2)*Magx)+Zoffset)
    X2 = Centre.X+Fov((Points(1,0)*Magx)+Xoffset,-(Points(1,2)*Magx)+Zoffset)
    Y2 = Centre.Y-Fov((Points(1,1)*Magx)+Yoffset,-(Points(1,2)*Magx)+Zoffset)
    Line(X1,Y1)-(X2,Y2)
    If Points(2,0) <> 0 Then
        X1 = Centre.X+Fov((Points(1,0)*Magx)+Xoffset,-(Points(1,2)*Magx)+Zoffset)
        Y1 = Centre.Y-Fov((Points(1,1)*Magx)+Yoffset,-(Points(1,2)*Magx)+Zoffset)
        X2 = Centre.X+Fov((Points(2,0)*Magx)+Xoffset,-(Points(2,2)*Magx)+Zoffset)
        Y2 = Centre.Y-Fov((Points(2,1)*Magx)+Yoffset,-(Points(2,2)*Magx)+Zoffset)
        Line(X1,Y1)-(X2,Y2)
    Endif
End Sub

Sub Progress(Total,Position)
    Percent = Fix((Position/Total)*100)
    Bargrph$ = Space$(22)
    Poke Var Bargrph$,1,91
    Poke Var Bargrph$,22,93
    For L = 2 To Fix(Percent/5)+1
        Poke Var Bargrph$,L,35
    Next
    Print @(0,Mm.Vpos) Bargrph$+" "+Format$(Percent)+"%";
End Sub

Sub Countpointslines(Filename2$)
    Points = 0
    Lines = 0
    Open Filename2$ For Input As #3
    Print "COUNTING POINTS & LINES"
    Do While Eof(#3) = 0
        Line Input #3,Inline$
        If Word$(Inline$,1) = "v" Then
            Points = Points + 1
        Elseif Word$(Inline$,1) = "f" Or Word$(Inline$,1) = "l" Then
            Lines = Lines + 1
        Endif
        Progress(Lof(#3),Loc(#3))
    Loop
    Close #3
End Sub

Sub Initpoints(Numpoints)
    If Numpoints > Memmax Then
        Numpoints = Memmax
    Endif
    Dim Points(Numpoints,3)
End Sub

Sub Initlines(Numlines)
    If Numlines > Memmax Then
        Numlines = Memmax
    Endif
    Dim Lines(Numlines,3)
End Sub

Function Word$(Inline3$,Wordnum)
    If Wordnum < 1 Then
        Wordnum = 1
    Endif
    Local K = 0
    Word$ = ""
    Start = 1
    For I = 1 To Wordnum
        Start = Start + K
        K = 0
        Do While Mid$(Inline3$,Start+K,1) = " "
            K = K + 1
        Loop
        Start = Start + K
        K = 0
        Do While Mid$(Inline3$,Start+K,1) <> " " And  Start+K =< Len(Inline3$)
            K = K + 1
        Loop
    Next
    If K > 0 Then
        Word$ = Mid$(Inline3$,Start,K)
    Endif
End Function

Sub Rotate(Dir$,Incre)
    If Incre = 0 Then
        Incre = 15
    Endif
    For I = 0 To Points - 1
        If Dir$ = "ZMINUS" Then
            X = (Points(I, 0) * Cos(Rad(Incre))) - (Points(I, 1) * Sin(Rad(Incre)))
            Y = (Points(I, 0) * Sin(Rad(Incre))) + (Points(I, 1) * Cos(Rad(Incre)))
            Points(I, 0) = X
            Points(I, 1) = Y
        Elseif Dir$ = "ZPLUS" Then
            X = (Points(I, 0) * Cos(Rad(-Incre))) - (Points(I, 1) * Sin(Rad(-Incre)))
            Y = (Points(I, 0) * Sin(Rad(-Incre))) + (Points(I, 1) * Cos(Rad(-Incre)))
            Points(I, 0) = X
            Points(I, 1) = Y
        Elseif Dir$ = "XMINUS" Then
            Y = (Points(I, 1) * Cos(Rad(Incre))) - (Points(I, 2) * Sin(Rad(Incre)))
            Z = (Points(I, 1) * Sin(Rad(Incre))) + (Points(I, 2) * Cos(Rad(Incre)))
            Points(I, 1) = Y
            Points(I, 2) = Z
        Elseif Dir$ = "XPLUS" Then
            Y = (Points(I, 1) * Cos(Rad(-Incre))) - (Points(I, 2) * Sin(Rad(-Incre)))
            Z = (Points(I, 1) * Sin(Rad(-Incre))) + (Points(I, 2) * Cos(Rad(-Incre)))
            Points(I, 1) = Y
            Points(I, 2) = Z
        Elseif Dir$ = "YMINUS" Then
            X = (Points(I, 0) * Cos(Rad(Incre))) - (Points(I, 2) * Sin(Rad(Incre)))
            Z = (Points(I, 0) * Sin(Rad(Incre))) + (Points(I, 2) * Cos(Rad(Incre)))
            Points(I, 0) = X
            Points(I, 2) = Z
        Elseif Dir$ = "YPLUS" Then
            X = (Points(I, 0) * Cos(Rad(-Incre))) - (Points(I, 2) * Sin(Rad(-Incre)))
            Z = (Points(I, 0) * Sin(Rad(-Incre))) + (Points(I, 2) * Cos(Rad(-Incre)))
            Points(I, 0) = X
            Points(I, 2) = Z
        Endif
    Next
End Sub

Sub Normalise
    Highest = 0
    For I = 0 To Points - 1
        For J = 0 To 2
            If Abs(Points(I,J)) > Highest Then
                Highest = Points(I,J)
            Endif
        Next
    Next
    For I = 0 To Points - 1
        For J = 0 To 2
            Points(I,J) = Points(I,J) / Highest
        Next
    Next
End Sub

Sub Centreize
    Highest = 0
    Lowest = 0
    Range = 0
    For J = 0 To 2
        For I = 0 To Points - 1
            If Points(I,J) > Highest Then
                Highest = Points(I,J)
            Endif
            If Points(I,J) < Lowest Then
                Lowest = Points(I,J)
            Endif
        Next
        Range = Highest - Lowest
        For I = 0 To Points - 1
            Points(I,J) = Points(I,J) - (Range/2)
        Next
    Next
End Sub

Function Fov(Coord1,Coord2)
    Distance = 240
    Angle = Atn(Coord1 / (Distance + Coord2))
    Fov = (Tan(Angle) * Distance)
End Function

Sub Drawline(Magx,Xoffset,Yoffset,Zoffset)
    Local Current(6)
    Centre.X = Mm.Hres/2
    Centre.Y = Mm.Vres/2
    If Magx = 0 Then
        Magx = 150
    Endif
    For I = 0 To Lines - 1
        For J = 0 To 2
            Current(J) = Points(Lines(I,0)-1,J) * Magx
            Current(J+3) = Points(Lines(I,1)-1,J) * Magx
        Next
        X1 = Centre.X+Fov(Current(0)+Xoffset,-Current(2)+Zoffset)
        Y1 = Centre.Y-Fov(Current(1)+Yoffset,-Current(2)+Zoffset)
        X2 = Centre.X+Fov(Current(3)+Xoffset,-Current(5)+Zoffset)
        Y2 = Centre.Y-Fov(Current(4)+Yoffset,-Current(5)+Zoffset)
        Line(X1,Y1)-(X2,Y2)
        If Lines(I,2) > 0 Then
            For J = 0 To 2
                Current(J) = Points(Lines(I,1)-1,J) * Magx
                Current(J+3) = Points(Lines(I,2)-1,J) * Magx
            Next
            X1 = Centre.X+Fov(Current(0)+Xoffset,-Current(2)+Zoffset)
            Y1 = Centre.Y-Fov(Current(1)+Yoffset,-Current(2)+Zoffset)
            X2 = Centre.X+Fov(Current(3)+Xoffset,-Current(5)+Zoffset)
            Y2 = Centre.Y-Fov(Current(4)+Yoffset,-Current(5)+Zoffset)
            Line(X1,Y1)-(X2,Y2)
        Endif
    Next
End Sub

Sub Keypress
    Keypress$ = Inkey$
    If Keypress$ <> "" Then
        If Keypress$ = "q" Then
            Rotate("ZMINUS")
            Cls
            Drawline()
        Elseif Keypress$ = "e" Then
            Rotate("ZPLUS")
            Cls
            Drawline()
        Elseif Keypress$ = "w" Then
            Rotate("XMINUS")
            Cls
            Drawline()
        Elseif Keypress$ = "s" Then
            Rotate("XPLUS")
            Cls
            Drawline()
        Elseif Keypress$ = "a" Then
            Rotate("YMINUS")
            Cls
            Drawline()
        Elseif Keypress$ = "d" Then
            Rotate("YPLUS")
            Cls
            Drawline()
        Endif
    Endif
End Sub

Sub Spherify
    For I = 0 To Points - 1
        L = Sqr(Abs(Points(I,0))+Abs(Points(I,1))+Abs(Points(I,2)))
        For J = 0 To 2
            Points(I,J) = Points(I,J) * (1/L)
        Next
    Next
End Sub

Sub Round
    Do
        Cls
        Drawline
        Spherify
    Loop
End Sub

Sub Demo
    Do
        Keypress
    Loop
End Sub


