Function FACTORIAL(NUMBER)
    FACTORIAL = Abs(Fix(NUMBER))
    If NUMBER <> 0 Then
        For i = NUMBER-1 To 1 Step -1
            FACTORIAL = FACTORIAL*i
        Next
    Else
        FACTORIAL = 1
    EndIf
End Function

OUTPUT = 0
FOR j = 1 TO 20
    OUTPUT = OUTPUT+(((j*2)^j)*(FACTORIAL(j)^2))/FACTORIAL(2*j)
NEXT
PRINT OUTPUT-3