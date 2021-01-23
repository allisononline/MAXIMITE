 'Space Invaders for the Maximite
Option base 1
Clear
 'Initialise variables
Dim FireCoord(2)
Dim OldFireCoord(2)
NbCols = 11
NbInvFire = 5
SprWide = 16
MinX = 0 : MaxX = 120
Dim Invaders(5,NbCols)
Dim InvCols(NbCols)
Dim InvFireCoord(20,2)
Dim InvFireOld(20,2)
Dim InvLine(5)
Dim InvErase(5)
Dim InvLine$(5)
Dim InvChar$(5,2)
Dim InvScore(5)
InvScore(1) = 30
InvScore(2) = 30
InvScore(3) = 20
InvScore(4) = 20
InvScore(5) = 10
InvMiScore = 100
Mistery = 117
Canon = 118
CanonExp1 = 119
CanonExp2 = 120
Dx = -2
InvInterval = 200
InvMiInterval = 200
InvMiSpeed = 20
InvFireTimer = 25
InvFireSpeed = 25
FireSpeed = 5
MisteryOn = 0
Score = 0
Lives = 3
Level = 0
NextLevel = 1
InvaderX = 16
InvaderY = 40
OriginMaxY = 70
InvMaxY = OriginMaxY
MisteryX = 280
OldMisteryX = MisteryX
OldInvaderX = InvaderX
OldInvaderY = InvaderY
CanonX = 100
CanonY = 180
OldCanonX = CanonX
OldCanonY = CanonY
Fire = 0
InvHitB = 0
Cycle = 0
 'Get the Invaders font (16 x 13 pixels)
Font Load "invader.fnt" As #6
 'Get the start Screen font (8 x 8 pixels)
Font Load "invmenu.fnt" As #7
 'Setting the joystick pins
 'PIN 13 = LEFT
SetPin 13,2
 'PIN 14 = RIGHT
SetPin 14,2
 'PIN 15 = Fire Button 1
SetPin 15,2
 'We start here
Cls
GoSub StartScreen
Randomize Timer
Pause 500
Cls
Timer = 0
Counter1 = 0
Counter2 = 0
Counter3 = 0
Counter4 = 0
Counter5 = 0
Counter6 = 0
RedrawInvaders = 1
 'General game loop
Do While 1
 'check if we draw a new level
 If NextLevel = 1 Then GoSub DrawNextLevel
 'check if we have to move the Invaders
 If Counter1 >= InvInterval Then
  Sound 300,50
  Timer = 0
  GoSub MoveInvaders
  RedrawInvaders = 1
  If Cycle = 0 Then Cycle = 1 Else Cycle = 0
 EndIf
 'check if we redraw the Invaders fire
 'at new positions
 If Counter2 >= InvFireSpeed Then
  Counter2 = 0
  GoSub InvFireShow
 EndIf
 'Check if one of the invader can fire
 If Counter3 >= InvFireTimer Then
  Counter3 = 0
  GoSub InvNewFire
 EndIf
 'Check if we activate the Mistery Ship
 If (Counter4 >= InvMiInterval) And (MisteryOn = 0) Then
  MisteryOn = 1
 EndIf
 'Check if we show the Mistery Ship
 If (MisteryOn = 1) And (Counter6 >= InvMiSpeed) Then
  Counter6 = 0
  GoSub MoveMistery
 EndIf
 char = Asc(Inkey$)
 'check if we move the Canon to Left
 If (char = 130) Then
  OldCanonX = CanonX
  CanonX = CanonX - 2
  If CanonX < 0 Then CanonX = 0
 EndIf
 'check if we move the Canon to Right
 If (char = 131) Then
  OldCanonX = CanonX
  CanonX = CanonX + 2
  If CanonX > 285 Then CanonX = 285
 EndIf
 'check if we Fire
 If (char = 32) And (Fire = 0) Then
  GoSub CanonFire
 EndIf
 'check if we kill a Invaders
 If (Fire = 1) And (Counter5 >= FireSpeed) Then
  Counter5 = 0
  OldFireCoord(1) = FireCoord(1)
  OldFireCoord(2) = FireCoord(2)
  FireCoord(2) = FireCoord(2) - 5
  If (FireCoord(2) <= ActMaxY) Then GoSub CheckKill
  GoSub CanonHitBunker
  If FireCoord(2) < 0 Then
   Line (OldFireCoord(1) , OldFireCoord(2)) - (OldFireCoord(1) , OldFireCoord(2) - 3),0
   Fire = 0
  EndIf
 EndIf
 'Actualize all Counters
 Counter1 = Timer
 Counter2 = Counter2 + 1
 Counter3 = Counter3 + 1
 Counter4 = Counter4 + 1
 Counter5 = Counter5 + 1
 Counter6 = Counter6 + 1
 GoSub Redraw
Loop
 'Draw a new level and set the variables
DrawNextLevel:
Level = Level + 1
If Level = 10 Then GoTo YouWin
InvInterval = 200 - ((Level - 1) * 10)
If InvInterval < 40 Then InvInterval = 40
InvFireTimer = 20 - ((Level - 1) * 2)
If InvFireTimer < 10 Then InvFireTimer = 10
InvaderX = 16
InvaderY = 21
CanonX = 100
CanonY = 180
Fire = 0
 'Set the Invaders
For a = 1 To 5
 For b = 1 To NbCols
  Invaders(a , b) = 1
 Next b
Next a
For a = 1 To NbInvFire
 InvFireCoord(a,1) = -1
 InvFireCoord(a,2) = -1
Next a
For a = 1 To 5
 InvLine(a) = NbCols
 InvErase(a) = 1
 InvChar$(a , 1) = "c"
 InvChar$(a , 1) = "a"
 InvChar$(a , 1) = "b"
 InvChar$(a , 1) = "e"
 InvChar$(a , 1) = "f"
 InvChar$(a , 2) = "d"
 InvChar$(a , 2) = "b"
 InvChar$(a , 2) = "a"
 InvChar$(a , 2) = "f"
 InvChar$(a , 2) = "e"
Next a
InvMaxY = OriginMaxY
MinX = 0 : MaxX = 120
NbInvFire = 5 + (Level - 1)
InvFireTimer = 25 - ((Level - 1) * 2)
InvFireSpeed = 25 - (Level - 1)
 'Draw the Level
Cls
GoSub ShowBunker
GoSub Redraw
NextLevel = 0
Return
MoveInvaders:
OldInvaderX = InvaderX
OldInvaderY = InvaderY
InvaderX = InvaderX + Dx
If InvaderX < MinX Then
 InvaderX = MinX
 OldInvaderY = InvaderY
 InvaderY = InvaderY + 5
 InvInterval = InvInterval - 10
 If InvInterval < 40 Then InvInterval = 40
 Dx = Abs(Dx)
EndIf
If InvaderX > MaxX Then
 InvaderX = MaxX
 OldInvaderY = InvaderY
 InvaderY = InvaderY + 5
 InvInterval = InvInterval - 10
 If InvInterval < 40 Then InvInterval = 40
 Dx = -Dx
EndIf
If InvaderY >= InvMaxY Then
 GoTo GameOver
EndIf
Return
MoveMistery:
OldMisteryX = MisteryX
MisteryX = MisteryX - 3
If MisteryX < 0 Then
 Line (OldMisteryX , 0) - (OldMisteryX + 16, 20) , 0,BF
 MisteryOn = 0
 Counter4 = 0
 MisteryX = 280
EndIf
Return
Redraw:
 'Draw the Invaders
Font #6
If RedrawInvaders = 1 Then
 For a = 1 To 5
  InvLine$(a) = ""
 Next a
 If Cycle = 0 Then
  For a = 1 To 5
   For b = 1 To NbCols
    If Invaders(a , b) <> 121 Then
     InvLine$(a) = InvLine$(a) + InvChar$(a , 1)
    Else
     InvLine$(a) = InvLine$(a) + Chr$(121)
    EndIf
   Next b
  Next a
 Else
  For a = 1 To 5
   For b = 1 To NbCols
    If Invaders(a , b) <> 121 Then
     InvLine$(a) = InvLine$(a) + InvChar$(a , 2)
    Else
     InvLine$(a) = InvLine$(a) + Chr$(121)
    EndIf
   Next b
  Next a
 EndIf
 For a = 1 To 5
  If InvLine(a) <> 0 Then
   oy1 = OldInvaderY + ((a - 1) * 20)
   oy2 = OldInvaderY + ((a - 1) * 20) + 13
   oy3 = InvaderY + ((a - 1) * 20)
   Line (OldInvaderX , oy1) - (OldInvaderX + (16 * NbCols) , oy2),0,BF
   Print @(InvaderX , oy3) InvLine$(a)
   ActMaxY = oy2
  EndIf
 Next a
 RedrawInvaders = 0
EndIf
 'Draw the Canon
Line (OldCanonX , OldCanonY) - (OldCanonX + 16, OldCanonY + 13) , 0,BF
Print @(CanonX , CanonY) Chr$(Canon)
 'Draw the Mistery Ship
If MisteryOn = 1 Then
 Line (OldMisteryX , 0) - (OldMisteryX + 16, 20) , 0,BF
 Print @(MisteryX , 0) Chr$(Mistery)
EndIf
 'Draw the Canon Fire
If Fire = 1 Then
  Line (OldFireCoord(1) , OldFireCoord(2)) - (OldFireCoord(1) , OldFireCoord(2) - 3),0
  Line (FireCoord(1) , FireCoord(2)) - (FireCoord(1) , FireCoord(2) - 3),1
EndIf
 'Draw Lives , Score and Level
Font #1
Print @(1,200) "Lives = "; Lives
Print @(100,200) "Score = "; Score
Print @(200,200) "Level = "; Level
Return
InvNewFire:
a = 1
ValidFire = 0
Do While a <= NbInvFire
 If InvFireCoord(a,1) = -1 And InvFireCoord(a,2) = -1 Then
  x = Int(Rnd * 10) + 1
  y = Int(Rnd * 4) + 1
  If Invaders(y , x) <> 121 Then ValidFire = 1
  If ValidFire = 1 Then
   InvFireCoord(a,1) = InvaderX + ((x - 1) * 16) + 8
   InvFireCoord(a,2) = InvaderY + (y * 20)
   InvFireOld(a,1) = InvFireCoord(a,1)
   InvFireOld(a,2) = InvFireCoord(a,2)
   a = NbInvFire + 1
  EndIf
 EndIf
 a = a + 1
Loop
Return
InvFireShow:
a = 1
Do While a <= NbInvFire
 Dead = 0
 InvHitB = 0
 If InvFireCoord(a,1) <> -1 And InvFireCoord(a,2) <> -1 Then
  InvFireOld(a,1) = InvFireCoord(a,1)
  InvFireOld(a,2) = InvFireCoord(a,2)
  InvFireCoord(a,2) = InvFireCoord(a,2) + 5
  x = InvFireCoord(a,1) : y = InvFireCoord(a,2)
  Line (InvFireOld(a,1) , InvFireOld(a,2)) - (InvFireOld(a,1) , InvFireOld(a,2) + 3),0
  Line (InvFireCoord(a,1) , InvFireCoord(a,2)) - (InvFireCoord(a,1) , InvFireCoord(a,2) + 3),1
  GoSub CheckDead
  If Dead = 1 Then
   Line (InvFireCoord(a,1) , InvFireCoord(a,2)) - (InvFireCoord(a,1) , InvFireCoord(a,2) + 3),0
   InvFireCoord(a,1) = -1
   InvFireCoord(a,2) = -1
   Dead = 0
  EndIf
  GoSub InvHitBunker
  If y > (CanonY + 3) Then
   Line (InvFireCoord(a,1) , InvFireCoord(a,2)) - (InvFireCoord(a,1) , InvFireCoord(a,2) + 3),0
   InvFireCoord(a,1) = -1
   InvFireCoord(a,2) = -1
  EndIf
 EndIf
 a = a + 1
Loop
Return
CanonFire:
Fire = 1
FireCoord(1) = CanonX + 8
FireCoord(2) = CanonY
OldFireCoord(1) = FireCoord(1)
OldFireCoord(2) = FireCoord(2)
GoSub beepFire
Return
CheckKill:
If (FireCoord(1) >= InvaderX) And (FireCoord(1) <= (InvaderX + 175)) Then
 FireColumn = Int((FireCoord(1) - InvaderX) / 16) + 1
 If ((FireCoord(2) - 3) >= InvaderY) And ((FireCoord(2) - 3) <= (InvaderY + 93)) Then
  FireLine = Int((FireCoord(2) - 3 - InvaderY) / 20) + 1
  If Invaders(FireLine , FireColumn) <> 121 Then
   Invaders(FireLine , FireColumn) = 121
   Score = Score + InvScore(FireLine)
   Line (OldFireCoord(1) , OldFireCoord(2)) - (OldFireCoord(1) , OldFireCoord(2) - 3),0
   Fire = 0
   GoSub beepKillInv
   GoSub CheckLevel
  EndIf
 EndIf
EndIf
If MisteryOn = 1 Then
 x1 = MisteryX
 x2 = MisteryX + 16
 y1 = 0
 y2 = 13
 If FireCoord(1) >= x1 And FireCoord(1) <= x2 And FireCoord(2) >= y1 And FireCoord(2) <= y2 Then
  Score = Score + InvMiScore + Int(Rnd * 100) + 100
  Line (OldFireCoord(1) , OldFireCoord(2)) - (OldFireCoord(1) , OldFireCoord(2) - 3),0
  Line (OldMisteryX , 0) - (OldMisteryX + 16, 20) , 0,BF
  Fire = 0
  MisteryOn = 0
  Counter4 = 0
  MisteryX = 280
  GoSub beepKillMis
 EndIf
EndIf
Return
CheckDead:
If (x >= CanonX) And (x <= (CanonX + 16)) And (y >= CanonY) And (y <= (CanonY + 13)) Then
 Font #6
 'We loose one Canon
 Locate CanonX , CanonY : Print Chr$(119)
 Sound 800,200
 Pause 300
 Sound 600,200
 Pause 300
 Locate CanonX , CanonY : Print Chr$(120)
 Sound 300,200
 Pause 500
 Lives = Lives - 1
 Sound 500,200
 Pause 200
 Locate CanonX , CanonY : Print Chr$(121)
 Dead = 1
 'Check if we loose the game
 If Lives = 0 Then GoTo GameOver
Else
 Dead = 0
EndIf
Return
CanonHitBunker:
If (FireCoord(2) >= 160) And (FireCoord(2) <= 179) Then
 ax = FireCoord(1) : ay = FireCoord(2)
 If Pixel(ax , ay + 1) <> 0 Then
  Sound 1200,50
  For b = 1 To 10
   x = FireCoord(1) + ( Int(Rnd * 10) - 5)
   y = FireCoord(2) + ( Int(Rnd * 10) - 5)
   Pixel(x , y) = 0
  Next b
  Line (ax - 2 , ay - 2) - (ax + 2 , ay + 2) , 0 , BF
  Line (OldFireCoord(1) , OldFireCoord(2)) - (OldFireCoord(1) , OldFireCoord(2) - 3),0
  Fire = 0
 EndIf
EndIf
Return
InvHitBunker:
 'Check if Invaders hit the bunkers
If (y >= 160) And (y <= 179) Then
 If Pixel(x , y - 1) <> 0 Then
  'Invaders hit the bunkers
   Sound 1200,50
   For b = 1 To 10
    x1 = x + ( Int(Rnd * 10) - 5)
    y1 = y + ( Int(Rnd * 10) - 5)
    Pixel(x1 , y1) = 0
   Next b
   Line (x - 2 , y - 2) - (x + 2 , y + 2) , 0 , BF
   Line (InvFireCoord(a,1) , InvFireCoord(a,2)) - (InvFireCoord(a,1) , InvFireCoord(a,2) + 3),0
   InvFireCoord(a,1) = -1
   InvFireCoord(a,2) = -1
 EndIf
EndIf
Return
ShowBunker:
 'Show the 4 bunkers
For a = 1 To 4
 Line (a * 60 , 160) - (a * 60 + 30 , 179) , 1 , BF
 Line (a * 60 + 10, 175) - (a * 60 + 20 , 180) , 0 , BF
Next a
Return
beepKillInv:
Sound 1200,50
Return
beepKillMis:
Sound 1100,50
Pause 50
Sound 1300,50
Pause 50
Sound 1200,50
Pause 50
Sound 1400,50
Return
beepFire:
Sound 1000,50
Return
CheckLevel:
 'Here we look if we killed all Invaders
For l = 1 To 5
 InvLine(l) = 0
Next l
For l = 1 To NbCols
 InvCols(l) = 0
Next l
For l = 1 To 5
 For m = 1 To NbCols
  If Invaders (l , m) <> 121 Then
   InvLine(l) = InvLine(l) + 1
   InvCols(m) = InvCols(m) + 1
  EndIf
 Next m
Next l
If InvLine(1) = 0 And InvLine(2) = 0 And InvLine(3) = 0 And InvLine(4) = 0 And InvLine(5) = 0 Then
 'We finish the Level
 NextLevel = 1
EndIf
For l = 1 To 5
 If (InvLine(l) = 0) And (InvErase(l) <> 0) Then
  InvErase(l) = 0
  Line (OldInvaderX , OldInvaderY + (( l - 1) * 20)) - (OldInvaderX + (16 * NbCols) , OldInvaderY + (( l - 1) * 20) + 13),0,BF
 EndIf
Next l
If InvLine(5) = 0 Then InvMaxY = OriginMaxY + 20
If (InvLine(4) = 0) And (InvLine(5) = 0) Then InvMaxY = OriginMaxY + 40
If (InvLine(3) = 0) And (InvLine(4) = 0) Then InvMaxY = OriginMaxY + 60
If (InvLine(2) = 0) And (InvLine(3) = 0) Then InvMaxY = OriginMaxY + 80
For l = 1 To NbCols
 If InvCols(l) = 0 Then
  MinX = 0 - (SprWide * l)
 Else
  l = NbCols + 1
 EndIf
Next l
For l = NbCols To 1 Step - 1
 If InvCols(l) = 0 Then
  MaxX = 120 + (SprWide * (NbCols - l))
 Else
  l = 0
 EndIf
Next l
Return
 'You loose the game
GameOver:
Font #1
Cls
Print @(120,100) "G A M E - O V E R"
Pause 5000
Run
 'You win the game at Level 10
YouWin:
Font #1
Cls
Print @(120,100) "Y O U - W I N"
Pause 5000
Run
 'Start Screen
StartScreen:
Cls
Font #1
Print @(140,50) "PLA"
Font #7
Print @(159,50) "Y"
Font #1
Print @(120,70) "SPACE  INVADERS"
Print @(100,90) "*SCORE ADVANCE TABLE*"
Font #6
Print @(115,105) Chr$(117)
Font #1
Print @(132,108) "=?  MYSTERY"
Font #6
Print @(115,125) "c"
Font #1
Print @(132,128) "=30  POINTS"
Font #6
Print @(115,145) "a"
Font #1
Print @(132,148) "=20  POINTS"
Font #6
Print @(115,165) "e"
Font #1
Print @(132,168) "=10  POINTS"
Print @(110,200) "PRESS FIRE TO START"
Cnt = 0
Animate = 0
AnimX = 290
OldAnimX = AnimX
Spr = 90
Do While (Inkey$ = "")
 Cnt = Cnt + 1
 If (Cnt > 3000) And (Animate = 0) Then
  Animate = 1
  Font #7
 EndIf
 If Animate = 1 Then
  'Go to the reversed 'Y'
  If Spr = 90 Then Spr = 91 Else Spr = 90
  px1 = OldAnimX - 1 : px2 = OldAnimX + 12
  Line (px1 , 50) - (px2 , 61) , 0 , BF
  Pause 5
  Print @(AnimX , 50) Chr$(Spr);
  Pause 5
  OldAnimX = AnimX
  AnimX = AnimX - 1
  If AnimX <= 167 Then
   Animate = 2
   OldAnimX = OldAnimX - 8
   AnimX = AnimX - 8
  EndIf
 EndIf
 If Animate = 2 Then
  'Take the reversed 'Y' away
  If Spr = 90 Then Spr = 91 Else Spr = 90
  Font #7
  px1 = OldAnimX - 1 : px2 = OldAnimX + 22
  Line (px1 , 50) - (px2 , 61) , 0 , BF
  Pause 5
  Locate AnimX , 50 : Print "Y"; Chr$(Spr);
  Pause 5
  OldAnimX = AnimX
  AnimX = AnimX + 1
  If AnimX >= 282 Then Animate = 3
 EndIf
 If Animate = 3 Then
  'Put the good 'Y' in place
  If Spr = 90 Then Spr = 91 Else Spr = 90
  px1 = OldAnimX - 1 : px2 = OldAnimX + 22
  Line (px1 , 50) - (px2 , 61) , 0 , BF
  Pause 5
  Font #1
  Print @(AnimX , 50) "Y";
  Font #7
  Print @(AnimX + 8 , 50) Chr$(Spr);
  Pause 5
  OldAnimX = AnimX
  AnimX = AnimX - 1
  If AnimX <= 158 Then
   Animate = 4
   OldAnimX = OldAnimX + 8
   AnimX = AnimX + 8
  EndIf
 EndIf
 If Animate = 4 Then
  'Invader go away alone
  If Spr = 90 Then Spr = 91 Else Spr = 90
  px1 = OldAnimX - 1 : px2 = OldAnimX + 12
  Line (px1 , 50) - (px2 , 61) , 0 , BF
  Pause 5
  Print @(AnimX , 50) Chr$(Spr);
  Pause 5
  OldAnimX = AnimX
  AnimX = AnimX + 1
  If AnimX >= 290 Then
   Animate = 5
   Line (AnimX - 1 , 50) - (AnimX + 12, 61) , 0 , BF
  EndIf
 EndIf
 If Cnt > 4000 Then Cnt = 0
Loop
Return
