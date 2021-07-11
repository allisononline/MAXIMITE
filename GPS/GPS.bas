LCD Init 1, 2, 3, 4, 5, 6
Open "COM2:9600" As #3
gpsInput$ = ""
junk$ = ""
latDisplay$ = ""
longDisplay$ = ""

LCD Clear

Sub fetchData
    Do
        Input #3,gpsCode$,gpsTime,gpsRecv$,gpsLat,gpsLatDir$,gpsLong,gpsLongDir$
    Loop Until gpsCode$ = "$GPRMC"
End Sub

Sub processData
    latDegrees = Int(gpsLat/100)
    latMinutes = gpsLat - (latDegrees*100)
    longDegrees = Int(gpsLong/100)
    longMinutes = gpsLong - (longDegrees*100)
    latDisplay$ = Format$(latDegrees)+Chr$(&HB0)+" "+Format$(latMinutes)+"'"
    LongDisplay$ = Format$(latDegrees)+Chr$(&HB0)+" "+Format$(longMinutes)+"'"
End Sub

Sub displayData
    If gpsRecv$ = "A" Then
        LCD 1,C16,latDisplay$
        LCD 2,C16,longDisplay$
    Else
        LCD 1,C16,""
        LCD 2,C16,"Searching..."
    EndIf
End Sub

Do
    fetchData
    processData
    displayData
Loop