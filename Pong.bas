Sub DrawLineScope(Paddle,value)
    Division = 100
    For i = 0 To Division
        DAC 2, Value-0.5+((1/Division)*i)
        DAC 1, (Paddle-1)*3
        Next
    DAC 1,0
    DAC 2,0
End Sub

Dim Paddle1 = 1.5
Dim Paddle2 = 1.5

Do
    If Inkey$ = "w" And (Paddle2 > 0.5) Then
        Paddle2 = Paddle2 + 0.1
        Print Paddle2
    EndIf
    If InKey$ = "s" And (Paddle2 < 2.5) Then
        Paddle1 = Paddle1 - 0.1
    EndIf
    DrawLineScope(1,Paddle1)
    DrawLineScope(2,Paddle2)
Loop
