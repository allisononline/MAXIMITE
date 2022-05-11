#Include "A:/General.inc"
#Include "A:/DRAW3D/New3D.inc"

Open "A:/DRAW3D/GLOBE.obj" For Random As #3

Timer = 0
For j = 0 To 359 Step 45
    Seek #3,1
    Cls
    Do
        Line Input #3,Inline$
        If Word$(Inline$,1) = "v" Then
            x = ((Val(Word$(Inline$,2))*Cos(Rad(j)))-(Val(Word$(Inline$,4))*Sin(Rad(j))))*1.5
            y = Val(Word$(Inline$,3))*1.5
            z = ((Val(Word$(Inline$,2))*Sin(Rad(j)))+(Val(Word$(Inline$,4))*Cos(Rad(j))))*1.5
            If z < -30 Then
                Pixel (MM.Hres/2)-FOV(x,z),(MM.VRes/2)-FOV(y,z)
            EndIf
        EndIf
    Loop Until EOF(#3) = 1
    Save Image "A:/DRAW3D/Globe/Globe"+Str$(j/45,2,0,"0")+".bmp"
Next

Print "Time Elapsed: "+Str$(Fix(Timer/60000))+" Minutes "+Str$((Timer Mod 60000)/1000,0,0)+" Seconds"

RMBeep(1)
Pause 200
RMBeep(0)

Close #3