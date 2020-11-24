10  Input "PLEASE ENTER A FILE NAME: ", FILE$

20  Open FILE$ For INPUT As #2

30  While Eof(2) = 0
40    Input #2, X$,Y
50    B = Peek(VAR X$,1)
60    If B = 48 Then
70        C = 0
80      GoTo 360
90    ElseIf B < 48 Or B > 56 Then
100      Print "SCALE OUT OF RANGE"
110     Exit
120   EndIf
130   C = Peek(VAR X$,2)
140   If C <41 Or C > 71 Then
150     Print "NOT A NOTE"
160     Exit
170   ElseIf C = 65 Then
180     C = 1
190   ElseIf C = 66 Then
200     C = 3
210   ElseIf C = 67 Then
220     C = 4
230   ElseIf C = 68 Then
240     C = 6
250   ElseIf C = 69 Then
260     C = 8
270   ElseIf C = 70 Then
280     C = 9
290   ElseIf C = 71 Then
300     C = 11
310   EndIf
320   If Peek(VAR X$,3) = 35 Then
330   '
340   EndIf
350   TONE ((110*2^(B-50))*2^(C/12))
360   Print ((110*2^(B-50))*2^(C/12)) ;
370   Pause 250 * Y
380   TONE STOP
390   Wend



