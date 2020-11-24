cls
Mode 1
linelen = 200
anglex = 1
angley = 1
anglez = 1
pointx = (mm.hres/2)
pointy = (mm.vres/2) - linelen
Line (pointx, pointy) - ((MM.HRes/2), (MM.VRes / 2)), 3
Do
If KeyDown = 101 Then
anglez = anglez + 1
If anglex > 359 Then
anglex = 0
EndIf
cls
pointx = (MM.HRes/2) + (linelen * Sin(anglez*Pi/180))
pointx = cint(pointx)
pointy = (MM.VRes/2) - (linelen * Cos(anglez*Pi/180))
pointy = cint(pointy)
Line (pointx, pointy) - ((MM.HRes/2), (MM.VRes / 2)), 3
EndIf
If KeyDown = 113 Then
anglez = anglez - 1
If anglez < 0 Then
anglez = 359
EndIf
cls
pointx = (MM.HRes/2) + (linelen * Sin(anglez*Pi/180))
pointx = cint(pointx)
pointy = (MM.VRes/2) - (linelen * Cos(anglez*Pi/180))
pointy = cint(pointy)
Line (pointx, pointy) - ((MM.HRes/2), (MM.VRes / 2)), 3
EndIf
if keydown = 100 then
angley = angley + 1
If angley > 359 then
angley = 0
endif
cls
lenghx = pointx - (mm.hres/2) + 1
pointx = (MM.Hres/2) + (lenghx * sin(angley*Pi/180))
Line (pointx, pointy) - ((MM.HRes/2), (MM.VRes / 2)), 3
endif
If KeyDown = 27 Then
Cls
End
EndIf
Loop