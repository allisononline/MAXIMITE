#DEFINE "slipEnd","&HC0"
#DEFINE "slipEsc","&HDB"
#DEFINE "slipEscEnd","&HDC"
#DEFINE "slipEscEsc","&HDD"

Sub slipInit
    Dim slipBuffer%(ipBufSize/8)
    Dim SlipBuffAddr% = Peek(VarAddr,slipBuffer%())
    Dim sliplen = 0
    Open "Com1:115200" As #1
End Sub

Sub slipClose
    Close #1
End Sub

Sub slipCharPut(char)
    Print #1,Chr$(char);
End Sub

Function slipCharPoll()
    If Loc(#1) > 0 Then
        slipCharPoll = Asc(Input$(1,#1))
    EndIf
End Function

Sub slipSend
    slipCharPut(slipEnd)
    Local ptr = 0
    For i = 0 To ipLen-1
        c Peek(Byte ipBuffAddr%+ptr)
        inc ptr
        Select Case c
            Case slipEnd
                slipCharPut(slipEsc)
                slipCharPut(slipEscEnd)
            Case slipEsc
                slipCharPut(slipEsc)
                slipCharPut(slipEscEsc)
            Case Else
                slipCharPut(c)
        End Select
    Next
    slipCharPut(slipEnd)
End Sub

Function slipPoll()
    Local c = 0
    Do While Loc(#1) > 0
        c = slipCharPoll()
        Select Case c
            Case slipEsc
                c = slipCharPoll()
                Select Case c
                    Case slipEscEnd
                        c = slipEnd
                    Case slipEscEsc
                        c = slipEsc
                End Select
            Case slipEnd
                if sliplen > 0 Then
                    BufferCpy(ipBuffAddr%,slipBuffAddr%,sliplen)
                    slipPoll = sliplen
                    sliplen = 0
                    Exit Function
                EndIf
            Case Else
        End Select
        Poke Byte slipBuffAddr%+sliplen, c
        inc sliplen
        If sliplen > ipBufSize Then
            sliplen = 0
        EndIf
    Loop
End Function