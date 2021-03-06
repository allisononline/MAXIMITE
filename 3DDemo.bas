#Include "General.inc"
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
            Rotate(Pointarray(),"XPLUS")
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
'        Rotate(PointArray(),"YPLUS")
'        ScopeLineSweep(PointArray(),LineArray())
    Loop
End Sub

Sub LoadScopeArrays(ObjectPoints())
    For i = 0 To Bound(ObjectPoints())-1
        XArray%(i) = (ObjectPoints(i,0)+1)*2048
        YArray%(i) = (ObjectPoints(i,1)+1)*2048
    Next
    DAC Start 100000,XArray%(),YArray%()
End Sub

Sub ScopeLineSweep(ObjectPoints(),ObjectLines())
    Division = 16
    For i = 0 To Bound(ObjectLines())-1
        x1 = ObjectPoints(ObjectLines(i,0)-1,0)+1
        y1 = ObjectPoints(ObjectLines(i,0)-1,1)+1
        x2 = ObjectPoints(ObjectLines(i,1)-1,0)+1
        y2 = ObjectPoints(ObjectLines(i,1)-1,1)+1
        For j = 0 To Division
            DAC 1, x1+((x2-x1)/Division*j)
            DAC 2, y1+((y2-y1)/Division*j)
        Next
        If ObjectLines(i,2) > 0 Then
            x1 = ObjectPoints(ObjectLines(i,1)-1,0)+1
            y1 = ObjectPoints(ObjectLines(i,1)-1,1)+1
            x2 = ObjectPoints(ObjectLines(i,2)-1,0)+1
            y2 = ObjectPoints(ObjectLines(i,2)-1,1)+1
            For j = 0 To Division
                DAC 1, (x1+((x2-x1)/Division*j))
                DAC 2, (y1+((y2-y1)/Division*j))
            Next
        EndIf
    Next
End Sub

DrawPointsNoMem("DRAW3D/Globe.OBJ")


