#DEFINE "SH_CLR","3"
#DEFINE "SH_LAT","5"
#DEFINE "SH_OEN","7"
#DEFINE "TR_DIR","27"
#DEFINE "TR_OEN","29"

Function lcdDigits(number)
    Select Case number
        Case &H0
            lcdDigits = &B0111111
        Case &H1
            lcdDigits = &B0000110
        Case &H2
            lcdDigits = &B1011011
        Case &H3
            lcdDigits = &B1001111
        Case &H4
            lcdDigits = &B1100110
        Case &H5
            lcdDigits = &B1101101
        Case &H6
            lcdDigits = &B1111101
        Case &H7
            lcdDigits = &B0000111
        Case &H8
            lcdDigits = &B1111111
        Case &H9
            lcdDigits = &B1101111
        Case &HA
            lcdDigits = &B1110111
        Case &HB
            lcdDigits = &B1111100
        Case &HC
            lcdDigits = &B0111001
        Case &HD
            lcdDigits = &B1011110
        Case &HE
            lcdDigits = &B1111001
        Case &HF
            lcdDigits = &B1110001
    End Select
End Function

Sub lcdInit
    SetPin SH_CLR,DOUT: Pin(SH_CLR) = 1
    SetPin SH_LAT,DOUT: Pin(SH_LAT) = 0
    SetPin SH_OEN,DOUT: Pin(SH_OEN) = 0
    SetPin TR_DIR,DOUT: Pin(TR_DIR) = 1
    SetPin TR_OEN,DOUT: Pin(TR_OEN) = 0
    SPI Open 195315,0,8
End Sub

Sub lcdDisp(number)
'    firstDigit = lcdDigits((number >> 4) And &HF)
    secondDigit = lcdDigits(number And &HF)
'    outputDigit = (firstDigit << 8) + secondDigit
    Pin(TR_OEN) = 1
    Pin(SH_LAT) = 0
    junk = SPI(secondDigit)
    Pulse SH_LAT,0.4
    Pause 0.4
    Pin(TR_OEN) = 0
End Sub

Sub lcdScrollOut(numberOut)
    firstOut = lcdDigits((numberOut >> 4) And &HF)
    secondOut = lcdDigits(numberOut And &HF)
    digitsOut = (firstOut << 8) + secondOut
    For i = 1 To 4
        _74hc595Clear(lcdShift())
        _74hc595Output(lcdShift(),digitsOut,16)
        Pause 48
        digitsMid = 0
        Inc digitsMid, ((digitsOut And &H0202) << 1)
        Inc digitsMid, ((digitsOut And &H2020) >> 1)
        Inc digitsMid, ((digitsOut And &H4040) >> 3)
        Inc digitsMid, ((digitsOut And &H0101) << 6)
        digitsOut = digitsMid
    Next
End Sub
    
lcdInit
For i = 0 To &HF
    lcdDisp(i)
    Pause 200
Next
