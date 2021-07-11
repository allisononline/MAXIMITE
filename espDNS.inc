#INCLUDE "esp8266.inc"

Sub genDNSQuery(domainName$)
    ID = &H1337
    flags = &H0100
    options = &H0100
    qdCount = &H0001
    anCount = &H0000
    nsCount = &H0000
    arCount = &H0000
    qType = &H0001
    qClass = &H0001
    Longstring Clear espSendData%()
    espWrite16Bit(options)
    espWrite16Bit(qdCount)
    espWrite16Bit(anCount)
    espWrite16Bit(nsCount)
    espWrite16Bit(arCount)
    For i = 1 To Len(domainName$)
        c$ = Mid$(domainName$,i,1)
        If c$ = "." Then
            Longstring Append espSendData%(),Chr$(i-lastDot-1)
            lastDot = i
        Else
            Longstring Append espSendData%(),c$
        EndIf
    Next
    espWrite16Bit(qType)
    espWrite16Bit(qClass)
End Sub

Sub espWrite16Bit(value)
    Longstring Append espSendData%(),Chr$((value >> 8) And &HFF)
    Longstring Append espSendData%(),Chr$(value And &HFF)
End Sub

espInit
junk = espConnStart(0,"UDP","8.8.8.8",53)
genDNSQuery("www.google.com")
espConnSendData(0)
espSendReceive()
Do
espReceive
Loop
