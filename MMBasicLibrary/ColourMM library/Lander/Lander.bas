'Lunar Lander for Colour Maximite v4.0
'
Option Base 1
Clear
'Array declaration
Dim Tevel(MM.HRes)
Dim BoosterSpr(2)
Dim ExplodeSpr(5)
Dim PlatformLSpr(5)
Dim PlatformRSpr(5)
Dim FootPix(2)
'Set 240 x 216 8 colours resolution
Mode 4
'We get the Sprites from file
Drive "b:"
Sprite Load "Lunar.spr"
'Sprite declaration
LanderSpr = 1
BoosterSpr(1) = 2 : BoosterSpr(2) = 3
For a = 1 To 5
 ExplodeSpr(a) = a + 3
 PlatformLSpr(a) = a + 8
 PlatformRSpr(a) = a + 13
Next a
FootPix(1) = 0 : FootPix(2) = 0
'1st animated Sprite per type
PlatFormSprNum = 1
ExplodeSprNum = 1
BoosterSprNum = 1
'Set the Joystick pin's
'PIN 11 = UP (Booster)
SetPin 11,2
'PIN 13 = LEFT
SetPin 13,2
'PIN 14 = RIGHT
SetPin 14,2
'Set some variables
Booster = 0
LemSpeed = 0.1
SpeedX = 0.0
Fuel = 25.0
Gravity = 1.63
GoRight = 0 : GoUp = 0 : GoLeft = 0
Score = 0
PixLeft = 0
PixRight = 0
GMx = MM.HRes - 1
GMy = MM.VRes - 1
Print @(70,100) "Press a key to Start"
Do While (Inkey$ = "") And (Pin(11) = 1) And (Pin(13) = 1) And (Pin(14) = 1)
Loop
Cls
Randomize Timer
'Landing platform position
Platformx = Int(Rnd * (GMx -60)) + 20
Platformy = Int(Rnd * 80) + (GMy - 80)
'Here we draw the terrain and the Landing platform
Sprite On PlatformLSpr(PlatFormSprNum) , Platformx , Platformy
Sprite On PlatformRSpr(PlatFormSprNum) , Platformx + 16, Platformy
'Terrain at Left from the platform
py = Platformy + (Rnd * 7) - 3
For a = Platformx - 1 To 0 Step - 1
 py = py + (Rnd * 7) - 3
 Line (a,GMy) - (a,py),3
 Tevel(a) = py
Next a
'Terrain at Right from the platform
py = Platformy + (Rnd * 7) - 3
For a = Platformx + 33 To GMx
 py = py + (Rnd * 7) - 3
 Line (a,GMy) - (a,py),3
 Tevel(a) = py
Next a
'Terrain under the platform
For a = Platformx To Platformx + 32
 Line (a,GMy) - (a,Platformy + 6),3
Next a
'LEM position at start
LemX = Rnd * (GMx - 60) + 20
LemY = Rnd * 50 + 25
'Show the LEM
Sprite On LanderSpr , LemX , LemY
BoosterWas1 = 0
'Initialise the platform sprite counter
PlatformCount = 0
'Next load's will be from drive "a:"
Drive "a:"
Mod_is_playing = 0
Timer = 0
'Main program loop
Do While 1
 'Read the buttons
 keypressed$ = Inkey$
 If (Pin(11) = 0) Or (Asc(keypressed$) = 128) Then GoUP = 1
 If (Pin(14) = 0) Or (Asc(keypressed$) = 131) Then GoRight = 1
 If (Pin(13) = 0) Or (Asc(keypressed$) = 130) Then GoLeft = 1
 '
 'Test if we are over the platform
 If LemY > (Platformy - 17) Then
   'Test if we have landed or Collided
  If (LemX >= Platformx) And (Lemx < (Platformx + 16)) Then
   'Landing test
   If LemSpeed <= 2.0 Then
    If Mod_is_playing = 1 Then
     PlayMOD Stop
    EndIf
    PlayMOD "landed.mod" , 4000
    Print @(75,50) "Successfully Landed"
    Pause 2000
    Run
   Else
    If BoosterWas1 = 1 Then
     Sprite Off BoosterSpr(BoosterSprNum)
    EndIf
    If Mod_is_playing = 1 Then
     PlayMOD Stop
    EndIf
    PlayMOD "explode.mod" , 4000
    Sprite Off LanderSpr
    For a = 1 To 5
     Sprite on ExplodeSpr(a) , LemX , LemY
     Pause 100
     Sprite off ExplodeSpr(a)
    Next a
    Print @(80,50) "You Crashed !!!"
    Pause 2000
     Run
   EndIf
  EndIf
 EndIf
 'We check collision with the Terrain
 FootPix(1) = Pixel(LemX,LemY + 16)
 FootPix(2) = Pixel(LemX + 15,LemY + 16)
 If (FootPix(1) <> 0) Or (FootPix(2) <> 0) Then
  If BoosterWas1 = 1 Then
   Sprite Off BoosterSpr(BoosterSprNum)
  EndIf
  Sprite Off LanderSpr
  If Mod_is_playing = 1 Then
   PlayMOD Stop
  EndIf
  PlayMOD "explode.mod" , 4000
  For a = 1 To 5
   Sprite on ExplodeSpr(a) , LemX , LemY
   Pause 100
   Sprite off ExplodeSpr(a)
  Next a
  Print @(80,50) "You Crashed !!!"
  Pause 2000
  Run
 EndIf
 If Timer >= 100 Then
  'Timer routine every 100mS
  PlatformCount = PlatformCount + 1
  Recompute
  Redraw
  Timer = 0
 EndIf
Loop

Sub Recompute
'This part is executed every 100mS
 LEMSpeed = LEMSpeed + (Gravity * 0.1)
 If (GoUP = 1) And (Fuel > 0) Then
  LemSpeed = LemSpeed - (Gravity * 0.2)
  Fuel = Fuel - 0.3
  GoUp = 0
  Booster = 1
 Else
  Booster = 0
 EndIf
 If (GoRight = 1) And (Fuel > 0) Then
  Vx = Vx + 0.1
  Fuel = Fuel - 0.1
  GoRight = 0
 EndIf
 If (GoLeft = 1) And (Fuel > 0) Then
  Vx = Vx - 0.1
  Fuel = Fuel - 0.1
  GoLeft = 0
 EndIf
 'Record the LEM position
 OldLemX = Int(LemX) : OldLemY = Int(LemY)
 LemY = Int(LemY + LemSpeed)
 LemX = Int(LemX + Vx)
 'Clip the LEM in the screen
 If LemX > (GMx - 17) Then LemX = GMx - 17
 If LemX < 5 Then LemX = 5
 If LemY > (GMy - 17) Then LemY = GMy - 17
 If LemY < 50 Then LemY = 50
End Sub

Sub Redraw
 'This part is executed every 100mS
 Print @(0,0) "Speed " @(35,0) Str$(Int(LemSpeed)) + " "
 Print @(100,0) "Fuel "@(135,0) Str$(Int(Fuel)) + " "
 'Check if we have to erase the booster
 If BoosterWas1 = 1 Then
  Sprite Off BoosterSpr(BoosterSprNum)
  BoosterWas1 = 0
 Else
  If Mod_is_playing = 1 Then
   PlayMOD Stop
   Mod_is_playing = 0
  EndIf
 EndIf
 'We redraw the LEM
 Sprite Move LanderSpr , LemX , LemY
 ' Draw the Booster if needed
 If Booster = 1 Then
  If Mod_is_playing = 0 Then
   PlayMOD "turbine.mod"
   Mod_is_playing = 1
  EndIf
  BoosterSprNum = BoosterSprNum + 1
  If BoosterSprNum > 2 Then BoosterSprNum = 1
  Sprite On BoosterSpr(BoosterSprNum) , LemX + 5 , LemY + 12
  Booster = 0
  BoosterWas1 = 1
 EndIf
 'Cycle the platform Sprites evey 300mS
 If PlatformCount = 3 Then
  Sprite Off PlatformRSpr(PlatFormSprNum)
  Sprite Off PlatformLSpr(PlatFormSprNum)
  PlatFormSprNum = PlatFormSprNum + 1
  If PlatFormSprNum > 5 Then PlatFormSprNum = 1
  Sprite On PlatformLSpr(PlatFormSprNum) , Platformx , Platformy
  Sprite On PlatformRSpr(PlatFormSprNum) , Platformx + 16, Platformy
  PlatformCount = 0
 EndIf
End Sub
