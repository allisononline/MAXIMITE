#DEFINE "MEM_EN", "3"
#DEFINE "CPU_RST", "5"
#DEFINE "CPU_A0", "7"
#DEFINE "CPU_A1", "8"
#DEFINE "CPU_A2", "10"
#DEFINE "CPU_A3", "11"
#DEFINE "CPU_A4", "12"
#DEFINE "CPU_A5", "13"
#DEFINE "CPU_A6", "15"
#DEFINE "CPU_A7", "16"
#DEFINE "CPU_A8", "18"
#DEFINE "CPU_A9", "19"
#DEFINE "CPU_AA", "21"
#DEFINE "CPU_AB", "22"
#DEFINE "CPU_AC", "23"
#DEFINE "CPU_AD", "24"
#DEFINE "CPU_AE", "26"
#DEFINE "CPU_AF", "27"
#DEFINE "CPU_D0", "28"
#DEFINE "CPU_D1", "29"
#DEFINE "CPU_D2", "31"
#DEFINE "CPU_D3", "32"
#DEFINE "CPU_D4", "33"
#DEFINE "CPU_D5", "35"
#DEFINE "CPU_D6", "36"
#DEFINE "CPU_D7", "37"
#DEFINE "CPU_CL2", "38"
#DEFINE "CPU_CLK", "40"
#DEFINE "PORT_A","CPU_A0, 2, CPU_A2, 4, CPU_A6, 2, CPU_A8, 2, CPU_AA, 4, CPU_AE, 2"
#DEFINE "PORT_D","CPU_D0,2,CPU_D2,3,CPU_D5,3"

Sub memInit
    SetPin CPU_RST, DOUT: Pin(CPU_RST) = 1
    SetPin CPU_CLK, DOUT: Pin(CPU_CLK) = 0
    SetPin CPU_CL2, INTH, memoSim
    SetPin MEM_EN, DIN
    SetPin CPU_A0,DIN
    SetPin CPU_A1,DIN
    SetPin CPU_A2,DIN
    SetPin CPU_A3,DIN
    SetPin CPU_A4,DIN
    SetPin CPU_A5,DIN
    SetPin CPU_A6,DIN
    SetPin CPU_A7,DIN
    SetPin CPU_A8,DIN
    SetPin CPU_A9,DIN
    SetPin CPU_AA,DIN
    SetPin CPU_AB,DIN
    SetPin CPU_AC,DIN
    SetPin CPU_AD,DIN
    SetPin CPU_AE,DIN
    SetPin CPU_AF,DIN
    SetPin CPU_D0,DOUT
    SetPin CPU_D1,DOUT
    SetPin CPU_D2,DOUT
    SetPin CPU_D3,DOUT
    SetPin CPU_D4,DOUT
    SetPin CPU_D5,DOUT
    SetPin CPU_D6,DOUT
    SetPin CPU_D7,DOUT
    Open "counter.asm" For Random As #3
End Sub

Sub memoSim
    If Pin(MEM_EN) = 0 Then
        addr = Port(PORT_A) And &H1FFF
        Seek #3, addr - 1
        Port(PORT_D) = Input$(1, #3)
    Else
        Port(PORT_D) = 0
    EndIf
End Sub

Sub cpuReset
    Pin(CPU_RST) = 0
    For i = 0 To 7
        cpuPulse
        Pause 2
    Next
End Sub

Sub cpuPulse
    Pin(CPU_CLK) = Not Pin(CPU_CLK)
End Sub

memInit
cpuReset
Do
    cpuPulse
    Pause 200
Loop
