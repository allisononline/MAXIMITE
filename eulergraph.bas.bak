#DEFINE "GRAPHSIZE","400"
#DEFINE "MAXVAL","2"

Cls
Line (MM.Hres/2)-(GRAPHSIZE/2),(MM.Vres/2)+(GRAPHSIZE/2),(MM.Hres/2)+(GRAPHSIZE/2),(MM.VRES/2)+(GRAPHSIZE/2)
Line (MM.Hres/2)-(GRAPHSIZE/2),(MM.Vres/2)+(GRAPHSIZE/2),(MM.Hres/2)-(GRAPHSIZE/2),(MM.VRES/2)-(GRAPHSIZE/2)

graphArea = 0
For x = 1 To GRAPHSIZE
    y = GRAPHSIZE/x
    xpixel = (MM.Hres/2)-(GRAPHSIZE/2)+x
    ypixel = (MM.Vres/2)+(GRAPHSIZE/2)-y
    If y < GRAPHSIZE Then
        Pixel xpixel,ypixel,RGB(Blue)
    EndIf
    If (MAXVAL/GRAPHSIZE*x) => 1 And graphArea < 1 Then
        Inc graphArea,y/GRAPHSIZE*MAXVAL
        Line xpixel,ypixel-y,xpixel,ypixel
        EndIf
    EndIf
Next

