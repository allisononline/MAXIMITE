Sprite Load "A:/DRAW3D/Snow.spr"
Sprite Copy #1,#2,63
For i = 1 To 64
    Sprite Show #i,(MM.Hres/2)+(Sin(i)*(i*4)),(MM.Vres/2)+(Cos(i)*(i*4)),0
Next
Do
For j = 0 To (2*Pi) Step (2*Pi/64)
    For i = 1 To 64
        RotateX= Sin((i*2)+j)*(i*4)
        RotateY= Cos((i*2)+j)*(i*4)
        Sprite Next i,(MM.Hres/2)+RotateX,(MM.Vres/2)+RotateY
    Next
    Sprite Move
    Pause 1000/24
Next
Loop
