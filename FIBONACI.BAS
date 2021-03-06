Function Linear(Value)
    Bit1 = ((Value And &H2)/&H2)
    Bit9 = ((Value And &H100)/&H100)
    Linear = Fix(Value/2) Or ((Bit1 Xor Bit9)*&H10000)
End Function

Function Padding$(InString$,Numbers)
    If Len(InString$) < Numbers Then
        Padding$ = String$(Numbers-Len(InString$),"0")+InString$
    Else
        Padding$ = InString$
    EndIf
End Function

Mode 3
Random = &H8988
Centre.X = MM.HRES/2
Centre.Y = MM.VRES/2

Sub DrawSpiral
    For i = 0 To (Centre.X) STEP 0.1
        Random = Linear(Random)
        Pixel(Centre.X+(Sin(i)*i),Centre.Y+(Cos(i)*i))=(Random AND 7)
    Next
End Sub

Sub DrawBlock
    For y = -128 To 127
        For x = -127 To 127
            Random = Linear(Random)
            Pixel(Centre.X+x,Centre.Y+y)=(Random AND 1)*7
        Next
    Next
End Sub

DrawBlock
            
