Sub BufferCpy(dstBuffer%,srcBuffer%,size)
    For i = 0 To size-1
        Poke Byte dstBuffer%+i,Peek(Byte srcBuffer%+i)
    Next
End Sub

Sub ipLog(logMsg$)
    If ipLogging = 1 Then
        Print logMsg$
    EndIf
End Sub

Function htons(int16)
    htons = ((int16 >> 8) Or (int16 << 8)) And &HFFFF
End Function

Function ipAddress%(byte1,byte2,byte3,byte4)
    ipAddress% = (byte1 << 8) + byte2
    ipAddress% = (ipAddress% << 8) + byte3
    ipAddress% = (ipAddress% << 8) + byte4
End Function

Function netAddress%(addrWord%)
    netAddress% = ((addrWord% And &HFF) << 24) Or ((addrWord% And &HFF000000 >> 24)
    NetAddress% = netAddr% Or ((addrWord% And &HFF00) << 8) Or ((addrWord% And &HFF0000) >> 8)
End Function

Function incWord%(inWord%,value)
    Local tmpArray(4) = ((inWord% And &HFF),(inWord% >> 8) And &HFF,(inWord% >> 16) And &HFF,(inWord% >> 24) And &HFF)
    Inc tmpArray(3), value And &HFF
    Inc tmpArray(2), value >> 8
    Local carry = 0
    For l = 3 To 0 Step -1
        Inc tmpArray(l),carry
        carry = (tmpArray(l) > 255)
        tmpArray(l) = tmpArray(l) And &HFF
    Next
    incWord% = (tmpArray(0) << 24)+(tmpArray(1)<<16)+(tmpArray(2)<<8)+tmpArray(3)
End Function