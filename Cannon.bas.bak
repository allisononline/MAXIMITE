Sub GenerateSprite
    Open "CannonBall.spr" For Output As #4
    Print #4, "16, 1"
    For i = 0 To 15
        For j = 0 To 15
            Radius = Sqr(((i-8)^2)+((j-8)^2))
            Print #4, Str$(7*(Radius < 8));
        Next
        Print #4,""
    Next
    Close #4
End Sub

Option Y_Axis Up
Ground = 50
StartX = 50
StartY = 100 + (50*Cos(2*Pi/MM.Hres*50))
Gravity = 9.8
CannonForce = 500
CannonAngle = 50
CannonMass = 50
CannonX = StartX
CannonY = StartY
CannonXVelocity = 0
CannonYVelocity = 0
Incre = 0.004

Sub DrawGround
    For i = 50 To MM.Hres-50
        y = 100 + (50*Cos(2*Pi/MM.Hres*i))
        Line i,y,i,Ground,1,RGB(Green)
    Next
End Sub

Sub Explosion(x,y)
    For i = 1 To 32
        Circle x+8,y+8,i,,,RGB(Red),RGB(Orange)
        Pause 24
    Next
    For i = 1 To 32
        Circle x+8,y+8,i,,,RGB(Black),RGB(Black)
        Pause 24
    Next
End Sub

Sprite Load "CannonBall.spr"
Sprite Show #1,StartX,StartY,0
DrawGround
CannonXVelocity = (CannonForce/CannonMass)*Cos(Rad(CannonAngle))
CannonYVelocity = (CannonForce/CannonMass)*Sin(Rad(CannonAngle))
Pause 2000
Do
    CannonYVelocity = CannonYVelocity-((Gravity/CannonMass)*Incre)
    CannonX = CannonX+(CannonXVelocity*Incre)
    CannonY = CannonY+(CannonYVelocity*Incre)
    Sprite Show #1,CannonX,CannonY,0
Loop Until CannonY =< (100+(50*Cos(2*Pi/MM.Hres*CannonX)))
Sprite Hide #1
Explosion(CannonX,CannonY)
