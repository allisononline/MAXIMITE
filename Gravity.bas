#Include "A:/DRAW3D/New3D.inc"
ParticleAmt = 200
ParticleMass = 0.1
ParticleArea = 0.1
TimeIncre = 0.4
Gravity = 9.8
AirDensity = 1.225
DragCoeff = 0.47
Bounds = 400

Sub Initialise
    Centre.X = Mm.Hres/2
    Centre.Y = Mm.Vres/2
    Dim Particle(ParticleAmt,4)
    Generate(Particle())
    For i = 0 To ParticleAmt-1
        Draw(Particle(),i,RGB(255,255,255))
    Next
End Sub

Sub Generate(ParticleArray())
    For i = 0 To ParticleAmt-1
        For k = 0 To 2
            ParticleArray(i,k) = (Rnd()*Bounds*2) - Bounds
        Next
        ParticleArray(i,3) = 0
    Next
End Sub

Sub Accelerate(ParticleArray(),Num)
    AirResistance = (1/2)*AirDensity*(ParticleArray(Num,3)^2)*DragCoeff*ParticleArea
    If ParticleArray(Num,1) => -Bounds Then
        ParticleArray(Num,3) = ParticleArray(Num,3)+(ParticleMass*(Gravity-AirResistance))
    Else
        ParticleArray(Num,3) = 0
    EndIf
End Sub

Sub Move(ParticleArray(),Num)
    ParticleArray(Num,1) = ParticleArray(Num,1)-((ParticleArray(Num,3))*TimeIncre)
    If ParticleArray(Num,1) < -Bounds Then
        ParticleArray(Num,1) = -Bounds
    EndIf
End Sub

Sub Draw(ParticleArray(),Num,Colour)
    Dot.X = Centre.X+Fov(ParticleArray(Num,0),ParticleArray(Num,2))
    Dot.Y = Centre.Y-Fov(ParticleArray(Num,1),ParticleArray(Num,2))
    Pixel Dot.X,Dot.Y,Colour
End Sub

Initialise
Cls
Do
    For i = 0 To ParticleAmt-1
        Accelerate(Particle(),i)
        If Particle(i,3) > 0 Then
            Draw(Particle(),i,RGB(0,0,0))
            Move(Particle(),i)
            Draw(Particle(),i,RGB(255,255,255))
        EndIf
    Next
Loop
       