Sub espLog espMsg$
    espLogEnable = 0
    If espLogEnable = 1 Then
        Print espMsg$
    EndIf
End Sub

Function espSendReceive$(Command$)
    Print #1, Command$
    Pause 400
    espSendReceive$ = espReceive$()
End Function

Sub espSend(Command$)
    Print #1, Command$
End Sub

Function espReceive$()
    If Loc(#1) <> 0 Then
        Prevchrs = 0
        Chrs = 0
        Do
            Pause 400
            Prevchrs = Chrs
            Chrs = Loc(#1)
        Loop While Chrs <> Prevchrs Or Chrs = 0
        If Chrs > 255 Then
            Chrs = 255
        EndIf
        espReceive$ = Input$(Chrs,#1)
    EndIf
End Function

Sub espWaitOK
    Do
        Result$ = espReceive$()
        If Result$ <> "" Then    
            espLog Result$
        EndIf
    Loop Until InStr(Result$,"OK")
End Sub    

Sub espReset
    espSend("AT+RST")
    Pause 400
    espWaitOK
End Sub

Sub espInit
    Dim espBuffer%(1024/8)
    Open "COM1:115200,1024" As #1
    espReset
    espSend("ATE0")
    espWaitOK
    espSend("AT+CWMODE=1")
    espWaitOK
End Sub

Function espIPAddr$()
    espIPAddr$ = espSendReceive$("AT+CIFSR")
End Function

Function espSvrStatus$()
    espSvrStatus$ = espSendReceive$("AT+CIPSTATUS")
End Function

Sub espJoin(ssid$,pass$)
    espSend("AT+CWJAP="+Chr$(34)+ssid$+Chr$(34)+","+Chr$(34)+pass$+Chr$(34))
    espWaitOK
End Sub

Sub espLeave
    espLog espSendReceive$("AT+CWQAP")
End Sub

Sub espOpenServer(portNum)
    espLog espSendReceive$("AT+CIPMUX=1")
    espLog espSendReceive$("AT+CIPSERVER=1,"+Format$(portNum))
End Sub

Sub espClose
    Close #1
End Sub

espInit
espOpenServer(80)

Do
    Print espReceive$();
Loop