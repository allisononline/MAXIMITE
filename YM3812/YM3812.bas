#INCLUDE "A:/ShiftOut.inc"
#DEFINE "YM_IRQ","3"
#DEFINE "YM_IC","5"
#DEFINE "YM_A0","7"
#DEFINE "YM_WR","11"
#DEFINE "YM_RD","13"
#DEFINE "YM_CS","15"
#DEFINE "YM_SH","19"
#DEFINE "YM_MO","21"
#DEFINE "YM_SY","23"
#DEFINE "YM_CLK","31"
#DEFINE "YM_DAT","8,1,10,1,16,1,18,1,24,1,26,1,28,1,32,1"
#DEFINE "YM_D0","8"
#DEFINE "YM_D1","10"
#DEFINE "YM_D2","16"
#DEFINE "YM_D3","18"
#DEFINE "YM_D4","24"
#DEFINE "YM_D5","26"
#DEFINE "YM_D6","28"
#DEFINE "YM_D7","32"
#DEFINE "YS_CLR","27"
#DEFINE "YS_CLK","29"
#DEFINE "YS_LAT","31"
#DEFINE "YS_OEN","33"
#DEFINE "YS_SER","35"

#DEFINE "SMPLRATE","44100"
#DEFINE "TIMING","1000/560"

Sub ymInit
    SetPin YM_IRQ, DOUT: Pin(YM_IRQ) = 0
    SetPin YM_IC, DOUT: Pin(YM_IC) = 1
    SetPin YM_A0, DOUT: Pin(YM_A0) = 0
    SetPin YM_WR, DOUT: Pin(YM_WR) = 1
    SetPin YM_RD, DOUT: Pin(YM_RD) = 1
    SetPin YM_CS, DOUT: Pin(YM_CS) = 1
    SetPin YM_MO, DIN
    Dim ymShift(5)
    ShiftInit(YS_CLR,YS_CLK,YS_LAT,YS_OEN,YS_SER,ymShift())
End Sub

Sub ymReset
    Pin(YM_CS) = 1
    Pulse YM_IC,25
    Pause 25
End Sub

Function bitFlip(byte)
    bitFlip = ((byte And &H0F) << 4) Or ((byte And &HF0) >> 4)
    bitFlip = ((bitFlip And &H33) << 2) Or ((bitFlip And &HCC) >> 2)
    bitFlip = ((bitFlip And &H55) << 1) Or ((bitFlip And &HAA) >> 1)
End Function

Sub ymWriteData(addr,value1)
    Pin(YM_A0) = addr
    ShiftOut(ymShift(),value1)
    Pin(YM_CS) = 0
    Pin(YM_WR) = 0
    Pause 1
    Pin(YM_CS) = 1
    Pin(YM_WR) = 1
End Sub

Sub ymSerialStart
    ymSerialOut = 0
    SetPin YM_SH, INTL, ymSerialStop,PullUp
    SetPin YM_SY, INTH, ymSerialBit,PullDown
End Sub

Sub ymSerialBit
    ymSerialOut = (ymSerialOut << 1) + Pin(YM_MO)
End Sub

Sub ymSerialStop
    SetPin YM_SH, OFF
    SetPin YM_SY, OFF
    Print ymSerialOut
    Pause SMPLRATE/1000/8
End Sub

Sub TestFile(filename$)
    ymInit
    Open filename$ For Input As #2
    Do Until EOF(#2)
        ymAddr = Asc(Input$(1,#2))
        ymData = Asc(Input$(1,#2))
        ymDelay = (Asc(Input$(1,#2)) << 8) + Asc(Input$(1,#2))
        ymWriteData(0,ymAddr)
        ymWriteData(1,ymData)
        SetPin YM_SH, INTL, ymSerialStart,PullUp
    Loop
End Sub

TestFile("kickpant.imf")
