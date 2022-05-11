Sub pickup
    digit = 0
    number = 0
    clickLast = Timer
    SetPin phoneYel, 7, click
End Sub

Sub click
    Pause 48
    digit = digit + 1
    clickLast = Timer
    Do While Pin(phoneYel) = 0
        If (Timer - clickLast) > 400 Then
            digit = 0
            number = 0
            SetPin phoneYel, 6, pickup
            Exit Sub
        EndIf
    Loop
End Sub

Sub usbIdle
    Pin(usbDPlus) = 0
    Pin(usbDMinus) = 1
End Sub

Sub usbK
    Pin(usbDPlus) = 1
    Pin(usbDMinus) = 0
End Sub

Sub usbSEO
    Pin(usbDPlus) = 0
    Pin(usbDMinus) = 0
End Sub

Sub usbZero
    Pin(usbDPlus) = Not Pin(usbDPlus)
    Pin(usbDMinus) = Not Pin(usbDMinus)
End Sub

Sub usbOne
    Rem "Nothing happens"
    Pin(usbDPlus) = Pin(usbDPlus)
    Pin(usbDMinus) = Pin(usbDMinus)
End Sub

Sub usbTransmit(_data, bits)
    If bits = 0 Then
        bits = 8
    EndIf
    oneBits = 0
    For i = (bits - 1) To 0 Step -1
        If ((packet / (2 ^ bits)) And 1) = 1 Then
            usbOne
            oneBits = oneBits + 1
            If oneBits = 6 Then
                usbZero
                oneBits = 0
            EndIf
        Else
            usbZero
            oneBits = 0
        EndIf
    Next
End Sub

Sub usbEOP
    usbSEO
    usbSEO
    usbIdle
End Sub

Sub setup
    usbDPlus = 11
    usbDMinus = 12
    phoneYel = 13
    SetPin usbDPlus, 8
    SetPin usbDMinus, 8
    SetPin phoneYel, 6, pickup
End Sub

Sub usbTest
    usbIdle
    Do
        usbTransmit(&H0101, 16)
        usbEOP
    Loop
End Sub

Sub phoneTest
    Do
        If ((Timer - clickLast) > 200) Then
            If (digit > 0) Then
                number = (number * 10) + (digit Mod 10)
                digit = 0
            EndIf
        EndIf
        If (number > 0) And (digit = 0) And ((Timer - clickLast) > 2000) Then
            Print number
            number = 0
            digit = 0
        EndIf        
    Loop
End Sub