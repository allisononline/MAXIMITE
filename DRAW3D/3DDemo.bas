#Include "New3D.inc"
#Include "A:/General.inc"

Sub Keys
    Keypress$ = Inkey$
    If Keypress$ <> "" Then
        If Keypress$ = "q" Then
            Rotate(PointArray(),"ZMINUS")
            Cls
            DrawObject(PointArray(),LineArray(),0,0,-150)
        Elseif Keypress$ = "e" Then
            Rotate(PointArray(),"ZPLUS")
            Cls
            DrawObject(PointArray(),LineArray(),0,0,-150)
        Elseif Keypress$ = "w" Then
            Rotate(PointArray(),"XMINUS")
            Cls
            DrawObject(PointArray(),LineArray(),0,0,-150)
        Elseif Keypress$ = "s" Then
            Rotate(PointArray(),"XPLUS")
            Cls
            DrawObject(PointArray(),LineArray(),0,0,-150)
        Elseif Keypress$ = "a" Then
            Rotate(PointArray(),"YMINUS")
            Cls
            DrawObject(PointArray(),LineArray(),0,0,-150)
        Elseif Keypress$ = "d" Then
            Rotate(PointArray(),"YPLUS")
            Cls
            DrawObject(PointArray(),LineArray(),0,0,-150)
        Endif
    Endif
End Sub

Sub Demo
    Do
        Keys
    Loop
End Sub

Readfile("gaystation.obj")
DrawObject(PointArray(),LineArray(),0,0,0)
Demo
