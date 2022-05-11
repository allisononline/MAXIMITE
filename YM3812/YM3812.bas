#DEFINE "YM_A0", "3"
#DEFINE "YM_WR", "5"
#DEFINE "YM_RD", "7"
#DEFINE "YM_DAT","21, 4, 26, 4"
#DEFINE "YM_D0", "21"
#DEFINE "YM_D1", "22"
#DEFINE "YM_D2", "23"
#DEFINE "YM_D3", "24"
#DEFINE "YM_D4", "26"
#DEFINE "YM_D5", "27"
#DEFINE "YM_D6", "28"
#DEFINE "YM_D7", "29"

#DEFINE "SMPLRATE","44100"
#DEFINE "TIMING","1000/560"


Sub ymInit
    SetPin YM_A0, DOUT: Pin(YM_A0) = 0
    SetPin YM_WR, DOUT: Pin(YM_WR) = 1
    SetPin YM_RD, DOUT: Pin(YM_RD) = 1
    SetPin YM_D0, DOUT
    SetPin YM_D1, DOUT
    SetPin YM_D2, DOUT
    SetPin YM_D3, DOUT
    SetPin YM_D4, DOUT
    SetPin YM_D5, DOUT
    SetPin YM_D6, DOUT
    SetPin YM_D7, DOUT
End Sub

Sub ymWriteData(addr,value1)
    Pin(YM_A0) = addr
    Port(YM_DAT) = value1
    Pulse YM_WR, 2
End Sub

Sub TestFile(filename$)
    ymInit
    Open filename$ For Input As #2
    Do
        ymAddr = Asc(Input$(1,#2))
        ymData = Asc(Input$(1,#2))
        ymDelay = Asc(Input$(1,#2)) + (Asc(Input$(1,#2)) << 8)
        ymWriteData(0,ymAddr)
        ymWriteData(1,ymData)
        Pause (TIMING) * ymDelay        
    Loop Until EOF(#2)
End Sub

TestFile("kickpant.imf")

