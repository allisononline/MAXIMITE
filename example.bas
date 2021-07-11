port = 80

Sub sendAndReceive(cmd$, result$)
' send command to esp8266 and wait for the result
Print cmd$
Print #1, cmd$
prevChrs = 0
chrs = 0
Do
Pause 400
Print ".";
prevChrs = chrs
chrs = Loc(#1)
Loop While chrs<>prevChrs Or chrs=0
Print
result$=Input$(chrs,#1)
Print result$
End Sub

Sub receive(result$)
' get data (if any) from the esp8266
If Loc(#1) <> 0 Then
prevChrs = 0
chrs = 0
Do
Pause 400
prevChrs = chrs
chrs = Loc(#1)
Loop While chrs<>prevChrs Or chrs=0

result$=Input$(chrs,#1)
Print result$
EndIf
End Sub


ssid$="WiFi-P69T-(nice)"
pw$="7112beyapt"
q$=Chr$(34)

Open "com1:115200" As #1
sendAndReceive("ATE0", answer$)
sendAndReceive("AT", answer$)

join$="AT+CWJAP="+q$+ssid$+q$+","+q$+pw$+q$
'sendAndReceive(join$, answer$)

sendAndReceive("AT+CIFSR", answer$)
sendAndReceive("AT+CIPMUX=1", answer$)
sendAndReceive("AT+CIPSERVER=1,80")
sendAndReceive("AT+CIPSTO=120", answer$)
sendAndReceive("AT+CIFSR", answer$)

' main loop. look for messages from wifi, parse and display
do
answer$ = ""
receive(answer$)
sizePos = instr(1, answer$, "+IPD,0,")
If sizePos <> 0 Then
answer$=Mid$(answer$, sizePos+7)
If answer$ <> "" Then
colonPos = instr(1, answer$, ":")
msgLen=Val(Mid$(answer$,1,colonPos-1))
msg$=Mid$(answer$,colonPos+1,msgLen)
print msg$
EndIf
EndIf
loop while msg$<>"0000"

print "Closing"
close #1
