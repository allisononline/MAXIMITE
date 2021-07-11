#DEFINE "ROM_RDY", "3"
#DEFINE "ROM_CE", "5"
#DEFINE "ROM_A0", "7"
#DEFINE "ROM_A1", "8"
#DEFINE "ROM_A2", "10"
#DEFINE "ROM_A3", "11"
#DEFINE "ROM_A4", "12"
#DEFINE "ROM_A5", "13"
#DEFINE "ROM_A6", "15"
#DEFINE "ROM_A7", "16"
#DEFINE "ROM_A8", "18"
#DEFINE "ROM_A9", "19"
#DEFINE "ROM_AA", "21"
#DEFINE "ROM_AB", "22"
#DEFINE "ROM_AC", "23"
#DEFINE "ROM_AD", "24"
#DEFINE "ROM_AE", "26"
#DEFINE "ROM_AF", "27"
#DEFINE "ROM_D0", "28"
#DEFINE "ROM_D1", "29"
#DEFINE "ROM_D2", "31"
#DEFINE "ROM_D3", "32"
#DEFINE "ROM_D4", "33"
#DEFINE "ROM_D5", "35"
#DEFINE "ROM_D6", "36"
#DEFINE "ROM_D7", "37"
#DEFINE "ROM_OE", "38"
#DEFINE "ROM_WE", "40"
#DEFINE "PORT_A", "ROM_A0, 2, ROM_A2, 4, ROM_A6, 2, ROM_A8, 2, ROM_AA, 4, ROM_AE, 2"
#DEFINE "PORT_D", "ROM_D0, 2, ROM_D2, 3, ROM_D5, 3"

Sub EEPInit
    SetPin ROM_RDY, DIN
    SetPin ROM_CE, DOUT: Pin(ROM_CE) = 0
    SetPin ROM_OE, DOUT: Pin(ROM_OE) = 1
    SetPin ROM_WE, DOUT: Pin(ROM_WE) = 1
    SetPin ROM_A0, DOUT: Pin(ROM_A0) = 0
    SetPin ROM_A1, DOUT: Pin(ROM_A1) = 0
    SetPin ROM_A2, DOUT: Pin(ROM_A2) = 0
    SetPin ROM_A3, DOUT: Pin(ROM_A3) = 0
    SetPin ROM_A4, DOUT: Pin(ROM_A4) = 0
    SetPin ROM_A5, DOUT: Pin(ROM_A5) = 0
    SetPin ROM_A6, DOUT: Pin(ROM_A6) = 0
    SetPin ROM_A7, DOUT: Pin(ROM_A7) = 0
    SetPin ROM_A8, DOUT: Pin(ROM_A8) = 0
    SetPin ROM_A9, DOUT: Pin(ROM_A9) = 0
    SetPin ROM_AA, DOUT: Pin(ROM_AA) = 0
    SetPin ROM_AB, DOUT: Pin(ROM_AB) = 0
    SetPin ROM_AC, DOUT: Pin(ROM_AC) = 0
    SetPin ROM_AD, DOUT: Pin(ROM_AD) = 0
    SetPin ROM_AE, DOUT: Pin(ROM_AE) = 0
    SetPin ROM_AF, DOUT: Pin(ROM_AF) = 0
    setDataRead
End Sub

Sub setDataRead
    SetPin ROM_D0,DIN
    SetPin ROM_D1,DIN
    SetPin ROM_D2,DIN
    SetPin ROM_D3,DIN
    SetPin ROM_D4,DIN
    SetPin ROM_D5,DIN
    SetPin ROM_D6,DIN
    SetPin ROM_D7,DIN
End Sub

Sub setDataWrite
    SetPin ROM_D0,DOUT: Pin(ROM_D0) = 0
    SetPin ROM_D1,DOUT: Pin(ROM_D1) = 0
    SetPin ROM_D2,DOUT: Pin(ROM_D2) = 0
    SetPin ROM_D3,DOUT: Pin(ROM_D3) = 0
    SetPin ROM_D4,DOUT: Pin(ROM_D4) = 0
    SetPin ROM_D5,DOUT: Pin(ROM_D5) = 0
    SetPin ROM_D6,DOUT: Pin(ROM_D6) = 0
    SetPin ROM_D7,DOUT: Pin(ROM_D7) = 0
End Sub

Function EEPRead(addr)
    setDataRead
    Port(PORT_A) = addr
    Pin(ROM_CE) = 0
    Pin(ROM_OE) = 0
    Pin(ROM_WE) = 1
    Pause 2
    EEPRead = Port(PORT_D)
    Pin(ROM_OE) = 1
End Function

Sub EEPWrite(addr,byte)
    setDataWrite
    Pin(ROM_CE) = 0
    Pin(ROM_OE) = 1
    Pin(ROM_WE) = 1
    Port(PORT_A) = addr
    Port(PORT_D) = byte
    Pulse ROM_WE,0.2
    CheckReady
    Port(PORT_D) = 0
End Sub

Sub CheckReady
    Do While Pin(ROM_RDY)
    Loop 
    Do While Not Pin(ROM_RDY)
    Loop
End Sub

Sub ROMDump
    For j = 0 To (2^13)-1
        Print Hex$(EEPRead(j),2)+" ";
        If j Mod 16 = 15 Then
            Print Hex$(j,4)
        EndIf
    Next
End Sub

Sub ROMWrite
    value = Fix(Rnd() * 256)
    For j = 0 To (2^13)-1
        Do 
            EEPWrite(j, value)
        Loop Until EEPRead(j) = value
    Next
End Sub

Sub EEPTest
    ROMWrite
    ROMDump
End Sub

EEPInit
EEPTest

