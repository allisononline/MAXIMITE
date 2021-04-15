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