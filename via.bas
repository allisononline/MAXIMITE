#INCLUDE "ShiftOut.inc"

#DEFINE "SHR_CLR","8"
#DEFINE "SHR_CLK","10"
#DEFINE "SHR_LAT","16"
#DEFINE "SHR_OEN","18"
#DEFINE "SHR_SER","24"
#DEFINE "SHD_CLR","26"
#DEFINE "SHD_CLK","28"
#DEFINE "SHD_LAT","32"
#DEFINE "SHD_OEN","36"
#DEFINE "SHD_SER","38"
#DEFINE "VIA_CB1","3"
#DEFINE "VIA_CB2","5"
#DEFINE "VIA_IRQ","7"
#DEFINE "VIA__RW","11"
#DEFINE "VIA_CS2","13"
#DEFINE "VIA_CS1","15"
#DEFINE "VIA_CLK","29"
#DEFINE "VIA_RES","21"
#DEFINE "VIA_CA2","23"
#DEFINE "VIA_CA1","27"

#DEFINE "REG_ORB","0"
#DEFINE "REG_ORA","1"
#DEFINE "REG_DRB","2"
#DEFINE "REG_DRA","3"
#DEFINE "REG_T1CL","4"
#DEFINE "REG_T1CH","5"
#DEFINE "REG_T1LL","6"
#DEFINE "REG_T1LH","7"
#DEFINE "REG_T2CL","8"
#DEFINE "REG_T2CH","9"
#DEFINE "REG__SR","10"
#DEFINE "REG_ACR","11"
#DEFINE "REG_PCR","12"
#DEFINE "REG_IFR","13"
#DEFINE "REG_IER","14"
#DEFINE "REG_ORAN","15"

Sub viaInit
    SetPin VIA_CB1,DOUT: Pin(VIA_CB1) = 0
    SetPin VIA_CB2,DOUT: Pin(VIA_CB2) = 0
    SetPin VIA__RW,DOUT: Pin(VIA__RW) = 1
    SetPin VIA_CS2,DOUT: Pin(VIA_CS2) = 1   'active low
    SetPin VIA_CS1,DOUT: Pin(VIA_CS1) = 1   'active high
    SetPin VIA_CLK,DOUT: Pin(VIA_CLK) = 0
    SetPin VIA_RES,DOUT: Pin(VIA_RES) = 1
    SetPin VIA_CA2,DOUT: Pin(VIA_CA2) = 0
    SetPin VIA_CA1,DOUT: Pin(VIA_CA1) = 0
    SetPin VIA_IRQ,DIN
    PWM 1,2000000,0,0,50
    Dim shiftReg(5)
    Dim shiftData(5)
    ShiftInit(SHR_CLR,SHR_CLK,SHR_LAT,SHR_OEN,SHR_SER,shiftReg())
    ShiftInit(SHD_CLR,SHD_CLK,SHD_LAT,SHD_OEN,SHD_SER,shiftData())
    Pulse VIA_RES,10
    Pause 20
End Sub

Sub viaWrite(viaReg,viaData)
    ShiftOut(shiftReg(),viaReg)
    ShiftOut(shiftData(),viaData)
    Pin(VIA__RW) = 0    
    Pin(VIA_CS2) = 0
    Pause 2
    Pin(VIA__RW) = 1
    Pin(VIA_CS2) = 1
End Sub

Sub viaTest
    viaInit
    Do
        viaWrite(REG_DRB,&HFF)
        viaWrite(REG_DRA,&HFF)
        viaWrite(REG_ORB,&HAA)
        viaWrite(REG_ORA,&HAA)
        Pause 250
        viaWrite(REG_DRB,&HFF)
        viaWrite(REG_DRA,&HFF)
        viaWrite(REG_ORB,&H55)
        viaWrite(REG_ORA,&H55)
        Pause 250
    Loop
End Sub

viaTest        


