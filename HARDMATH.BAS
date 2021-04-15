Byte1 = &HFF
Byte2 = &HAA
Result1 = 0

Function GetBit(Byte,Position)
    Mask = 2^Position
    GetBit = (Byte And Mask)/2^Position
End Function

Function WriteBit(Byte,Position,Value)
    Mask = 2^Position
    If Value <> 0 Then
        WriteBit = Byte Or Mask
    Else
        WriteBit = Byte And (255-Mask)
    EndIf
End Sub


Sub Addition
