Sub psockSetup(psockbuf%,bufptr%,bufsize)
    Poke Integer psockbuf%,bufptr%
    Poke Short psockbuf%+8,bufsize
End Sub

Function psockBufData(psockbuf%,len,dataptr%,datalen%)
    psockbuf.ptr% = Peek(Integer psockbuf%)
    psockbuf.left = Peek(Short psockbuf%+8)
    dataptrlocal% = Peek(Integer dataptr%)
    datalenlocal = Peek(Short datalen%)
    If datalenlocal < psockbuf.left Then
        memcpy(psockbuf.ptr%,dataptr%,datalenlocal)
        Poke Integer psockbuf%,psockbuf.ptr%+datalenlocal
        Poke Short psockbuf%+8,psockbuf.left-datalenlocal
        Poke Integer dataptr%,dataptrlocal%+datalenlocal
        Poke Short datalen%,0
        psockBufData = 0
        Exit Function
    ElseIf datalenlocal = psockbuf.left Then
        memcpy(psockbuf.ptr%,dataptr%,datalenlocal)
        Poke Integer psockbuf%,psockbuf.ptr%+datalenlocal
        Poke Short psockbuf%+8,0
        Poke Integer dataptr%,dataptrlocal%+datalenlocal
        Poke Short datalen%,0
        psockBufData = 1
        Exit Function
    Else
        memcpy(psockbuf.ptr%,dataptr%,psockbuf.left)
        Poke Integer psockbuf%,psockbuf.ptr%+psockbuf.left
        Poke Short datalen%,datalenlocal-psockbuf.left
        Poke Integer dataptr%,dataptrlocal%+psockbuf.left
        Poke Short psockbuf%+8,0
        psockBufData = 1
        Exit Function
    EndIf
End Function

Function psockBufTo(psockbuf%,endmarker,dataptr%,datalen%)
    c = 0
    Do While (Peek(Short psockbuf%+8) > 0) And (Peek(Short datalen%) > 0)
        Poke Integer psockbuf%,Peek(Integer dataptr%)
        c = Peek(Byte psockbuf%)
        Poke Integer dataptr%,Peek(Integer dataptr%)+1
        Poke Integer psockbuf%,Peek(Integer psockbuf%)+1
        Poke Short datalen%,Peek(Short datalen%)-1
        Poke Short psockbuf%+8,Peek(Short psockbuf%+8)-1

        If c = endmarker Then
            psockBufTo = 2
            Exit Function
        EndIf
    Loop
    if Peek(Short Datalen%) = 0 Then
        psockBufTo = 0
        Exit Function
    EndIf
    Do While Peek(Short datalen%) > 0
        c = Peek(Byte dataptr%)
        Poke Short datalen%,Peek(Short datalen%)-1
        Poke Integer dataptr%,Peek(Integer dataptr%)+1
        If c = endMarker Then
            psockBufTo = 1 Or 2
            Exit Function
        EndIf
    Loop
    psockBufTo = 1
End Function

Function 