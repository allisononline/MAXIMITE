#DEFINE "SHORTFREQ","1000/0.352"
#DEFINE "SHORTDUR","0.352"
#DEFINE "MEDFREQ","1000/0.512"
#DEFINE "MEDDUR","0.512"
#DEFINE "LONGFREQ","1000/.672"
#DEFINE "LONGDUR","0.672"

Sub sendByte(value)
    parity = 1
    sendMarker
    For i = 0 To 7
        sendBit((value >> i) And 1)
    Next
End Sub

Sub shortTone
    Play Tone SHORTFREQ,SHORTFREQ,SHORTDUR
'    Pause SHORTDUR
End Sub

Sub medTone
    Play Tone MEDFREQ,MEDFREQ,MEDDUR
'    Pause MEDDUR
End Sub

Sub longTone
    Play Tone LONGFREQ,LONGFREQ,LONGDUR
'    Pause LONGDUR
End Sub

Sub sendMarker
    longTone
    medTone
End Sub

Sub sendEndData
    longTone
    shortTone
End Sub

Sub sendBit(bit)
    If bit Then
        medTone
        shortTone
    Else
        shortTone
        medTone
    EndIf
End Sub

Sub countDown
    For k = &H89 To &H81
        sendByte(i)
    Next
End Sub

Play Volume 50,50
Open "general.inc" For Input As #3
Play Tone SHORTFREQ,SHORTFREQ
Pause 4000
countDown
Do Until EOF(#3)
    sendByte(Asc(Input$(1,#3)))
Loop
sendEndData
Close #3
