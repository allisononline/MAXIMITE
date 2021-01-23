'Arcade game test for Colour Maximite v4.0
'Fabrice Muller 2012
'All music modules have to be copied to a:
'The sprites are read from b:
'Joystick connections are :
'Pin 2  = 10Kohm Potentiometer
'
'                Pin 2
'                  |
'                  |
'                /   \
' +3v3 ----------| o |---------- GND
'                \___/
'
'         10Kohm Potentiometer
'
'
'Pin 15 = Button connected to GND , 10Kohm pullup resistor to pin 15
'
'                                    __|__
'
'               10 Kohm              |   |
' +3v3 ---------/\/\/\/\-----|-------|   |-------- GND
'                            |
'                            |       Button
'                          Pin 15
'
'All arrays start at index 1
Option Base 1
'Erase all variables values from memory
Clear
'Load the Sprites
Drive "b:"
Sprite Load "arcade01.spr"
Drive "a:"
'Arrays declaration
Dim ShootSpr(5)
Dim ShowShoot(5)
Dim ShootPos(5,2)
Dim EnnemySpr(10)
Dim EnnemyPos(10,2)
Dim EnnemyShow(10)
Dim EnnemyDir(10)
Dim EnnemySpeed(10)
Dim EnnemyKilled(10)
Dim EnnemyShootSpr(10)
Dim EnnemyShootPos(10,2)
Dim EnnemyShowShoot(10)
Dim Sprite_to_Show(26)
Dim Cx(26)
Dim Cy(26)
'Main ship sprite number is 1
ShipSpr = 1
'Global Variables declaration
Max_Shoot = 5
Max_Ennemy = 10
Max_Ennemy_Shoot = 10
Max_Sprite = 26
Shoot_Speed = -5
Ennemy_Shoot_Speed = 5
SpriteFlip = 0
OutsideX = 0
OutsideY = 0
ShipX = 0
ShipY = 0
Audio_is_playing = 0
Fire = 0
Lives = 0
Score = 0
'Joystick declaration
'Pin 2 as ADC input for a 10Kohm potentiometer
SetPin 2,1
'PIN 15 = Fire Button 1
SetPin 15,2
'Initialise the sprites and screen
Initialise
'General game loop
Do While 1
 'Here we check if we fire every 300mS
 If (Timer Mod 200) >= 100 Then
  fire = Check_Fire(15)
  'Put a new fire if possible
  If fire = 0 Then Put_New_Fire
 EndIf
 'Here we move the Ship
 ShipX = Pot_Read(2)
 'Here we move all Ennemys
 Move_Ennemy
 'Here we move the Shoots we have fired
 Move_Shoot
 'Here we move the Ennemys Shoots they have fired
 Move_Ennemy_Shoot
 'Here we check if we have kill a Ennemy
 Check_Ennemy_Dead
 'Here we Check if the Ennemys kill us
 Check_Player_Dead
 'We Random the Ennemy Shoots
 If Int(Rnd * 100) > 80 Then Put_New_Enenmy_Fire
 'Here we redraw all Sprites every 100mS
 Show_All_Sprites
 Print @(60,0) "Lives : ";Lives;" "
 Print @(150,0) "Score : ";Score;" "
Loop

Sub Initialise
 Local a
 'Set all the Sprite first
 For a = 1 To Max_Shoot
  'Shoot Sprites start at 2
  ShootSpr(a) = a + 1
  ShowShoot(a) = 0
 Next a
 For a = 1 To Max_Ennemy
  'Ennemy Sprites start at 7
  EnnemySpr(a) = a + 6
  'Don't show the ennemys now
  EnnemyShow(a) = 1
  'Reset Ennemys Directions
  EnnemyDir(a) = 0
  'Reset the Ennemys Speed
  EnnemySpeed(a) = 2
  'Put all Ennemy as not Killed
  EnnemyKilled(a) = 0
 Next a
 For a = 1 To Max_Ennemy_Shoot
  'Ennemy Shoot Sprites start at 17
  EnnemyShootSpr(a) = a + 16
  EnnemyShowShoot(a) = 0
 Next a
 SpriteFlip = 0
 'Set Lives ans Score
 Lives = 3
 Score = 0
 ' Set the graphics mode
 Mode 4
 'Erase the screen
 Cls
 'Wait for a key to start
 Print @(80 , 100) "Press a key to start"
 Do While Inkey$ = "" : Loop
 Cls
 'Initialise the random number generator
 Randomize Timer
 'Place the ship
 ShipX = Pot_Read(2)
 ShipY = 198
 'Set the Ennemys Positions and directions
 For a = 1 To Max_Ennemy
  EnnemyPos(a,1) = Set_Ennemy_Pos_X(1)
  EnnemyPos(a,2) = Set_Ennemy_Pos_Y(1)
  EnnemyDir(a)   = Set_Ennemy_Dir(1)
  EnnemySpeed(a) = Set_Ennemy_Speed(1)
 Next a
 OutsideX = -20
 OutsideY = -20
 Start_All_Sprite
 'Reset the timer for the game loop
 Timer = 0
End Sub

Sub Start_All_Sprite
 'We start all sprite here outside the screen
 'for not have to look at on/off status
 'This improve the performance.
 'Sprite order:
 'Sprite 1
 Sprite On ShipSpr,OutsideX,OutsideY
 'Sprite 2 to 6
 For a = 1 To Max_Shoot
  Sprite On ShootSpr(a),OutsideX,OutsideY
 Next a
 'Sprite 7 to 16
 For a = 1 To Max_Ennemy
  Sprite On EnnemySpr(a),OutsideX,OutsideY
 Next a
 'Sprite 17 to 26
 For a = 1 To Max_Ennemy_Shoot
  Sprite On EnnemyShootSpr(a),OutsideX,OutsideY
 Next a
End Sub

Sub Show_All_Sprites
 'Here we show all sprite in respecting the
 'Order needed for the Sprite function
 'We record the Ship info
 Sprite_to_Show(ShipSpr) = ShipSpr
 Cx(ShipSpr) = ShipX
 Cy(ShipSpr) = ShipY
 'Check if Sprites have to be Moved or
 'pushed out of the screen
 For a = 1 To Max_Shoot
  If ShowShoot(a) = 1 Then
   Sprite_to_Show(ShootSpr(a)) = 1
   Cx(ShootSpr(a))=ShootPos(a,1)
   Cy(ShootSpr(a))=ShootPos(a,2)
  Else
   Sprite_to_Show(ShootSpr(a)) = 0
   Cx(ShootSpr(a))=OutsideX
   Cy(ShootSpr(a))=OutsideY
  EndIf
 Next a
 For a = 1 To Max_Ennemy
  If EnnemyShow(a) = 1 Then
   Sprite_to_Show(EnnemySpr(a)) = 1
   Cx(EnnemySpr(a))=EnnemyPos(a,1)
   Cy(EnnemySpr(a))=EnnemyPos(a,2)
  Else
   Sprite_to_Show(EnnemySpr(a)) = 0
   Cx(EnnemySpr(a))=OutsideX
   Cy(EnnemySpr(a))=OutsideY
  EndIf
 Next a
 For a = 1 To Max_Ennemy_Shoot
  If EnnemyShowShoot(a) = 1 Then
   Sprite_to_Show(EnnemyShootSpr(a)) = 1
   Cx(EnnemyShootSpr(a))=EnnemyShootPos(a,1)
   Cy(EnnemyShootSpr(a))=EnnemyShootPos(a,2)
  Else
   Sprite_to_Show(EnnemyShootSpr(a)) = 0
   Cx(EnnemyShootSpr(a))=OutsideX
   Cy(EnnemyShootSpr(a))=OutsideY
  EndIf
 Next a

 If SpriteFlip = 0 Then
  'Sprites was drawn 1st to last , we erase or move
  'then Last to 1st
  'Drawing Order was :
  'Ship
  'Shoot
  'Ennemy
  'Ennemy_Shoot
  '
  'Here we move the Sprite or put them out of the screen
  For a = Max_Sprite To 1 Step - 1
   Sprite Off a
  Next a
  For a = Max_Sprite To 1 Step - 1
   If Sprite_to_Show(a) = 0 Then
    Sprite On a,OutsideX,OutsideY
   Else
    Sprite On a,Cx(a),Cy(a)
   EndIf
  Next a
  SpriteFlip = 1
 Else
  'Sprites was drawn last to 1st , we erase or move
  'then 1st to last
  'Drawing Order was :
  'Ennemy_Shoot
  'Ennemy
  'Shoot
  'Ship
  '
  'Here we move the Sprite or put them out of the screen
  For a = 1 To Max_Sprite
    Sprite Off a
  Next a
  For a = 1 To Max_Sprite
   If Sprite_to_Show(a) = 0 Then
    Sprite On a,OutsideX,OutsideY
   Else
    Sprite On a,Cx(a),Cy(a)
   EndIf
  Next a
  SpriteFlip = 0
 EndIf
End Sub

Sub Move_Ennemy
 'Move all ennemy Ship
 Local a
 For a = 1 To Max_Ennemy
  If EnnemyShow(a) = 1 Then
   EnnemyPos(a,1) = EnnemyPos(a,1) + EnnemyDir(a)
   'We look if the Ennemy bump at a screen border
   'If so , we reverse his direction
   If EnnemyPos(a,1) < 1 Then EnnemyDir(a) = 1
   If EnnemyPos(a,1) > MM.HRes - 18 Then EnnemyDir(a) = -1
   'We made the Ennemy go down
   EnnemyPos(a,2) = EnnemyPos(a,2) + EnnemySpeed(a)
   'If the ennemy go outside the screen or if we kill
   'then we put it at new place
   If (EnnemyPos(a,2) >= (MM.VRes - 40)) Or (EnnemyKilled(a) = 1) Then
    EnnemyPos(a,1) = Set_Ennemy_Pos_X(1)
    EnnemyPos(a,2) = Set_Ennemy_Pos_Y(1)
    EnnemyDir(a)   = Set_Ennemy_Dir(1)
   EndIf
   'Update the score if we kill a Ennemy
   If EnnemyKilled(a) = 1 Then
    EnnemyKilled(a) = 0
       Score = Score + 10
   EndIf
  EndIf
 Next a
End Sub

Sub Move_Shoot
 'Move the player shoots
 Local a
 For a = 1 To Max_Shoot
  If ShowShoot(a) = 1 Then
   ShootPos(a,2) = ShootPos(a,2) + Shoot_Speed
   'If the Shoot go outside the screen we put it
   'as not showed
   If ShootPos(a,2) < 18 Then ShowShoot(a) = 0
  EndIf
 Next a
End Sub

Sub Move_Ennemy_Shoot
 'Move the ennemys shoots
 Local a
 For a = 1 To Max_Ennemy_Shoot
  If EnnemyShowShoot(a) = 1 Then
   EnnemyShootPos(a,2) = EnnemyShootPos(a,2) + Ennemy_Shoot_Speed
   'If the Shoot go outside the screen we put it
   'as not showed
   If EnnemyShootPos(a,2) >= MM.VRes Then EnnemyShowShoot(a) = 0
  EndIf
 Next a
End Sub

Sub Check_Ennemy_Dead
 'Check if we have kill one of the Ennemy
 Local a,b
 Local px,py
 For a = 1 To Max_Ennemy
  px = EnnemyPos(a,1) + 15
  py = EnnemyPos(a,2) + 15
  For b = 1 To Max_Shoot
   If ShowShoot(b) = 1 Then
    If (ShootPos(b,1) >= EnnemyPos(a,1)) And (ShootPos(b,1) <= px) Then
        If (ShootPos(b,2) >= EnnemyPos(a,2)) And (ShootPos(b,2) <= py) Then
         'We have killed this ennemy
         EnnemyKilled(a) = 1
         Score = Score + 10
         ShowShoot(b) = 0
               If Audio_is_playing = 1 Then
                PlayMOD stop
                PlayMOD "Explode.mod" , 6000
               Else
                PlayMOD "Explode.mod" , 6000
               EndIf
         Exit For
        EndIf
       EndIf
   EndIf
  Next b
 Next a
End Sub

Sub Check_Player_Dead
 'Check if the Ennemys kill us
 Local a,px,py
 px = ShipX + 15
 py = ShipY + 15
 For a = 1 To Max_Ennemy_Shoot
  If EnnemyShowShoot(a) = 1 Then
   If (EnnemyShootPos(a,1) >= ShipX) And (EnnemyShootPos(a,1) <= px) Then
    If (EnnemyShootPos(a,2) >= ShipY) And (EnnemyShootPos(a,2) <= py) Then
     'The Ennemy Kill us !
     '............... to continue ............
     Lives = Lives - 1
     If Lives = 0 Then
         Drive "b:"
         Print @(100,80) "Game Over"
         Print @(80,120) "press a key to restart"
         Do While Inkey$ = "" : Loop
      End
     Else
      Exit Sub
     EndIf
    EndIf
   EndIf
  EndIf
 Next a
End Sub

Sub Put_New_Fire
 'Here we check if we can add a new fire
 Local a
  For a = 1 To Max_Shoot
   If ShowShoot(a) = 0 Then
    'we can add a shoot
    'Record the the Actual Show Shoot status
    ShootPos(a,1) = ShipX + 6
    ShootPos(a,2) = ShipY - 8
    ShowShoot(a) = 1
       If Audio_is_playing = 1 Then
        PlayMOD stop
        PlayMOD "Shoot.mod" , 6000
       Else
        PlayMOD "Shoot.mod" , 6000
       EndIf
    Exit For
   EndIf
  Next a
End Sub

Sub Put_New_Enenmy_Fire
 'Here we check if the Ennemy can add a new fire
 Local a
 For a = 1 To Max_Ennemy_Shoot
   If EnnemyShowShoot(a) = 0 Then
    'Ennemy can add a shoot
    EnnemyShootPos(a,1) = EnnemyPos(a,1) + 6
    EnnemyShootPos(a,2) = EnnemyPos(a,2) + 16
    EnnemyShowShoot(a) = 1
    Exit For
   EndIf
 Next a
End Sub

Function Pot_Read(ADC_Pin)
 'Read the potentiometer value for place
 'the X coordinate from the Ship
 'ADC_Pin is the pin number we have define for ADC input
 Local CalcPot , tmppos
 CalcPot = 3 / MM.HRes
 tmppos = Int((Pin(ADC_Pin) -0.1) / CalcPot)
 If tmppos > (MM.HRes - 17) Then tmppos = MM.HRes - 17
 Pot_Read = tmppos
End Function

Function Check_Fire(Fire_Button)
 'Return the value from the Fire Button
 'Fire_Button is the pin number we have define as fire button
 Check_Fire = Pin(Fire_Button)
End Function

Function Set_Ennemy_Dir(dummy)
 'Return -1 or 1 for the Ennemy direction
 Local a
 a = 0
  Do While a = 0
   If (Int(Rnd * 100) + 1 ) > 50 Then
    a = 1
   Else
    a = -1
   EndIf
  Loop
  Set_Ennemy_Dir = a
End Function

Function Set_Ennemy_Pos_X(dummy)
 'Set Ennemy Pos X
  Set_Ennemy_Pos_X = Int(Rnd * (MM.HRes - 30)) + 15
End Function

Function Set_Ennemy_Pos_Y(dummy)
 'Set Ennemy Pos X
  Set_Ennemy_Pos_Y = Int(Rnd * 30) + 15
End Function

Function Set_Ennemy_Speed(dummy)
 'Set the Ennemy Speed in Y
 Set_Ennemy_Speed = Int(Rnd * 5) + 1
End Function

