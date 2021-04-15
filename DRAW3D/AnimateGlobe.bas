Function Fov(Coord1,Coord2)
    Distance = 240
    Angle = Atn(Coord1 / (Distance + Coord2))
    Fov = (Tan(Angle) * Distance)
End Function

Open "A:/DRAW3D/Globe.obj" For Random As #3

For x = 0 To 360 Step 15
    Seek #3,1
    Cls
    Do
        Line Input #4,Inline$
        If Word$(Inline$,1) = "v" Then
            x = ((Val(Word$(Inline$,2))*Cos(Rad(x)))-(Val(Word$(Inline$,4))*Sin(Rad(x))))*1.5
            z = ((Val(Word$(Inline$,2))*Sin(Rad(x)))+(Val(Word$(Inline$,4))*Cos(Rad(x))))*1.5
            y = Val(Word$(Inline$,3))*1.5
            Pixel (MM.Hres/2)+FOV(x,z),(MM.VRes/2)-FOV(y,z)
        EndIf
    Loop Until EOF(#4) = 1
    Save Image "Globe"+Str$(x/15,2,0,"0")+".bmp"
Next

Close #3