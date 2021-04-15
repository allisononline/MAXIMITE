#Include "New3D.inc"

Sub Keys
    Keypress$ = Inkey$
    If Keypress$ <> "" Then
        If Keypress$ = "q" Then
            Rotate(PointArray(),"ZMINUS")
            Cls
            DrawObject(PointArray(),LineArray())
        Elseif Keypress$ = "e" Then
            Rotate(PointArray(),"ZPLUS")
            Cls
            DrawObject(PointArray(),LineArray())
        Elseif Keypress$ = "w" Then
            Rotate(PointArray(),"XMINUS")
            Cls
            DrawObject(PointArray(),LineArray())
        Elseif Keypress$ = "s" Then
            Rotate(PointArray(),"XPLUS")
            Cls
            DrawObject(PointArray(),LineArray())
        Elseif Keypress$ = "a" Then
            Rotate(PointArray(),"YMINUS")
            Cls
            DrawObject(PointArray(),LineArray())
        Elseif Keypress$ = "d" Then
            Rotate(PointArray(),"YPLUS")
            Cls
            DrawObject(PointArray(),LineArray())
        Endif
    Endif
End Sub

Sub Demo
    Do
        Keys
    Loop
End Sub

Readfile("COW.OBJ")
DrawObject(PointArray(),LineArray())
Demo