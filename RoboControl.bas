Sub controlInit
    Open "COM1:19200" As #3
    SetPin 11,DIN
    SetPin 12,DIN
    SetPin 13,DIN
    SetPin 15,DIN
    SetPin 16,DIN
    controlByte = 0
End Sub

Sub getControlByte
    controlByte = Port(11,3,15,2)
    If controlByte Then
        Print #3,Chr$(controlByte)
    EndIf
End Sub

controlInit
Do
    getControlByte
Loop
