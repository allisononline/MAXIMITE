#INCLUDE "A:/esp8266.inc"
#MMDEBUG ON

Sub generateIndexPage
    Timer = 0
    Open "index.htm" For Output As #4
    Print #4, "<!DOCTYPE html>"
    Print #4, "<html>"
    Print #4, "<body>"
    Print #4, "<p>Date and Time: "+DateTime$(Now)+"</p>"
    Print #4, "<p>Core Temperature: "+Format$(Pin("TEMP"))+Chr$(176)+"C</p>"
    Print #4, "<p>This page was generated in "+Format$(Timer/1000)+" seconds.</p>
'    Print #4, "<img src="+q$+"IMG1.61937e+09.bmp"+q$+" alt="+q$+"Moooo"+q$+">"
    Print #4, "</body>"
    Print #4, "</html>"
    Close #4
End Sub

Sub startWebServer
    espInit
    espOpenServer(80)
End Sub

Sub processWebData
    Local fileStart = 0
    Local fileEnd = 0
    Local fileReq$ = ""
    If LLen(espReceiveData%()) Then
        fileStart = LInStr(espReceiveData%(),"GET")+4
        fileEnd = LInstr(espReceiveData%(),"HTTP",fileStart)-2
        fileReq$ = LGetStr$(espReceiveData%(),fileStart,fileEnd-fileStart+1)
        MMDebug fileReq$
        If fileReq$ = "/" Then
            generateIndexPage
            espConnSendFile("A:/WebServer/index.htm",espConnCurrent)
        Else
            If Dir$("A:/WebServer"+fileReq$) = "" Then
                espConnSendFile("A:/WebServer/fourohfour.htm",espConnCurrent)
            Else
                espConnSendFile("A:/WebServer"+fileReq$,espConnCurrent)
            EndIf
        EndIf
        Do While Not espFindStr("SEND OK")
            espReceive
        Loop
        espConnClose(espConnCurrent)
    EndIf
End Sub

startWebServer
Do
    espConnReceiveData
    processWebData
    espReceive
Loop

