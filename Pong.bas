Sub DrawLineScope(x1,y1,x2,y2)
    Division = 10
    For i = 0 To Division
        DAC 1, x1+((x2-x1)/Division)*i)
        DAC 2, y1+((y2-y1)/Division)*i)
    Next
End Sub

Do
    