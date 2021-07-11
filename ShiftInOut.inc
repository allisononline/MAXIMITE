Sub ShiftOut(portNum,number,bits)
    If bits = 0 Then
        bits = 8
    EndIf
    If portNum = 1 Then
        SPI Open 195315,2,bits
        junk = SPI(number)
        SPI Close
    ElseIf portNum = 2 Then
        SPI2 Open 195315,2,bits
        junk = SPI2(number)
        SPI2 Close
    EndIf
End Sub

Function ShiftIn(portNum,bits)
    If bits = 0 Then
        bits = 8
    EndIf
    If portNum = 1 Then
        SPI Open 195315,0,bits
        shiftIn = SPI(0)
        SPI Close
    ElseIf portNum = 2 Then
        SPI2 Open 195315,0,bits
        shiftIn = SPI2(0)
        SPI2 Close
    EndIf
End Function
