Open "COM2:19200, 8" As #5
For j = 1 To 7
SetPin j, 8
Next
Pin(1) = 1
Pin(2) = 1
Do
dat$ = Input$(1, #5)
contr$ = Bin$(Asc(dat$))
'If Mid$(contr$,2,5) = "00000" then
'For i = 3 To 7
'Pin(i) = 0
'Next
'EndIf
'Print contr$
If Mid$(contr$,6,1) = "0" And Mid$(contr$,5,1) = "0" Then
If Mid$(contr$,4,1) = "1" Then
Pin(3) = 1
Pin(6) = 1
ElseIf Mid$(contr$,3,1) = "1" Then
Pin(4) = 1
Pin(5) = 1
Else
Pin(3) = 0
Pin(4) = 0
Pin(5) = 0
Pin(6) = 0
EndIf
EndIf
If Mid$(contr$,6,1) = "1" Then
If Mid$(contr$,4,1) = "1" Then
Pin(3) = 1
Pin(5) = 0
ElseIf Mid$(contr$,3,1) = "1" Then
Pin(3) = 0
Pin(5) = 1
Else
Pin(3) = 1
Pin(5) = 1
EndIf
EndIf
If Mid$(contr$,5,1) = "1" Then
If Mid$(contr$,4,1) = "1" Then
Pin(4) = 1
Pin(6) = 0
ElseIf Mid$(contr$,3,1) = "1" Then
Pin(4) = 0
Pin(6) = 1
Else
Pin(4) = 1
Pin(6) = 1
EndIf
EndIf
If Mid$(contr$,2,1) = "1" Then
Pin(7) = 1
Else
Pin(7) = 0
EndIf
'contr$ = "100000"
Loop                                                                    