#DEFINE "APPTOKEN","323932399-Mye5MfOYaOPBhXHCl28SfNUzR6L1J9ocevXGr4qJ"
#DEFINE "TOKENLEN","50"
#DEFINE "HOSTADDR","142.250.66.244"
#DEFINE "HOSTDOMAIN","arduino-tweet.appspot.com"
#INCLUDE "esp8266.inc"

Sub GenerateHeader
    Open "SendTweet.txt" For Output As #7
    sendMsg$ = "The time is "+Format$(Epoch(Now))
    Print #7,"POST http://arduino-tweet.appspot.com/update HTTP/1.0"
    Print #7,"Content-Length: "+Format$(Len(sendMsg$)+50+14)
    Print #7
    Print #7,"token=323932399-Mye5MfOYaOPBhXHCl28SfNUzR6L1J9ocevXGr4qJ&status="+sendMsg$
    Close #7
End Sub

Sub SendTweet
    espInit
    espOpenServer(80)
    If espConnStart(0,"TCP","192.168.1.2",80) Then
        espConnSendFile("SendTweet.txt",0)
        Do Until espFindStr("CLOSED")
            espReceive
        Loop
        espConnClose(0)
        espCloseServer(80)
    EndIf
    espClose
End Sub

GenerateHeader
SendTweet
