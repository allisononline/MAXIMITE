#DEFINE "GRPHSZ","400"
SetPin 7,AIN
Page Write 1
px = (MM.Hres/2)-(GRPHSZ/2)
py = (MM.VRes/2)+(GRPHSZ/2)


Do
    Cls
    For i = 1 To GRPHSZ
        Pixel px+i,py-(Pin(7)*100)
    Next
    Page Copy 1 To 0
Loop
