'ColourMM Sprites test
Option Base 1
Dim SprNum(5)
Dim XCoord(5)
Dim YCoord(5)
Dim SprDir(5)
Dim PixCol(5)
Dim PixLR(5)
Dim LemRun(5)
ScreenY = 0
ScreenDir = 1
ModNum = 1
SprOffs = 16
NumSprites = 5
MaxSpr = 5
Mode 4
Cls
Drive "b:"
LoadBMP "level001.bmp",0,ScreenY + 2
Sprite Load "lemmings.spr"
Randomize Timer
For a = 1 To MaxSpr
 SprNum(a) = 1 + (SprOffs * (a-1))
 SprDir(a) = 1
 XCoord(a) = 52
 YCoord(a) = 35
 PixCol(a) = 0
 PixLR(a) = 0
 LemRun(a) = 0
Next a
MaxSpr = 1
Timer = 0
Drive "a:"
PlayMOD "track_01.mod"
Do While 1
 If (ModNum = 1) And (Timer >= 53000) Then
  PlayMOD stop
  ModNum = 2
  Timer = 0
  PlayMOD "track_03.mod"
 EndIf
 If (ModNum = 2) And (Timer >= 53000) Then
  PlayMOD stop
  ModNum = 3
  Timer = 0
  PlayMOD "track_09.mod"
 EndIf
 If (ModNum = 3) And (Timer >= 60900) Then
  PlayMOD stop
  ModNum = 1
  Timer = 0
  PlayMOD "track_01.mod"
 EndIf
 If MaxSpr < NumSprites Then
  If Timer > 1500 And MaxSpr = 1 Then MaxSpr = 2
  If Timer > 3000 And MaxSpr = 2 Then MaxSpr = 3
  If Timer > 4500 And MaxSpr = 3 Then MaxSpr = 4
  If Timer > 6000 And MaxSpr = 4 Then MaxSpr = 5
 EndIf
 For a = 1 To MaxSpr
  PixCol(a) = Pixel(XCoord(a) + 8,YCoord(a) + 17 + ScreenY)
  If SprDir(a) = 1 Then
   PixLR(a) = Pixel(XCoord(a) + 12,YCoord(a) + 5 + ScreenY)
   If (PixLR(a) <> 0) Or (XCoord(a) > (MM.HRes - 10)) Then
    SprDir(a) = -1
    SprNum(a) = 9 + (SprOffs * (a-1))
   EndIf
  Else
   PixLR(a) = Pixel(XCoord(a) + 4,YCoord(a) + 5 + ScreenY)
   If (PixLR(a) <> 0) Or (XCoord(a) < -5) Then
    SprDir(a) = 1
    SprNum(a) = 1 + (SprOffs * (a-1))
   EndIf
  EndIf
 Next a
 For a = 1 To MaxSpr
  Sprite on SprNum(a), XCoord(a) , YCoord(a) + ScreenY
 Next a
 ScreenY = ScreenY + Screendir
 If ScreenY > 50 Then ScreenDir = -1
 If ScreenY < 2 Then ScreenDir = 1
 Do While (Timer Mod 90) < 80
 Loop
 For a = MaxSpr To 1 Step -1
  Sprite off SprNum(a)
 Next a
 BLIT 0,ScreenY ,0,ScreenY + ScreenDir,MM.HRes,154
 For a = 1 To MaxSpr
  If LemRun(a) = 1 Then
   SprNum(a) = SprNum(a) + 1
  EndIf
  If SprDir(a) = 1 Then
   If SprNum(a) > (8 + (SprOffs * (a-1))) Then SprNum(a) = 1 + (SprOffs * (a-1))
  Else
   If SprNum(a) > (16 +(SprOffs * (a-1))) Then SprNum(a) = 9 + (SprOffs * (a-1))
  EndIf
 Next a
 For a = 1 To MaxSpr
  If LemRun(a) = 1 Then
   XCoord(a) = XCoord(a) + SprDir(a)
   If PixCol(a) <> 0 Then
    'Lemming have to go up
       YCoord(a) = YCoord(a) - 1
   Else
    'Lemming have to go down
       YCoord(a) = YCoord(a) + 1
   EndIf
  Else
   If PixCol(a) <> 0 Then
    LemRun(a) = 1
   Else
    YCoord(a) = YCoord(a) + 2
   EndIf
  EndIf
 Next a
Loop

