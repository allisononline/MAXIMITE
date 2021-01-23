'Graphic test for ColourMM V4.0 Final Release.
'Muller Fabrice
'2012
'This program just show all graphics functions.
'That is :
'Pixels
'Lines
'Box
'Filled Box
'Circles
'Filled Circle
'and the new Blitter !!

'declare some arrays
Dim px1(10)
Dim px2(10)
Dim py1(10)
Dim py2(10)
Dim ox1(10)
Dim ox2(10)
Dim oy1(10)
Dim oy2(10)
Dim dx1(10)
Dim dx2(10)
Dim dy1(10)
Dim dy2(10)
'Game Graphic Mode 240 x 216 in 8 colors
Mode 4
'clear the screen
Cls
'Generic pixels graphics
For a = 1 To 2000
 x = Int(Rnd * MM.HRes)
 y = Int(Rnd * MM.VRes)
 Pixel(x,y) = Int(Rnd * 8)
Next a
Print @(0,0) "2000 Pixels"
Do While Inkey$ = "" : Loop
Randomize Timer
'clear the screen
'Cls
box_erase
'Lines
For a = 1 To 2000
 x1 = Int(Rnd * MM.HRes)
 y1 = Int(Rnd * MM.VRes)
 x2 = Int(Rnd * MM.HRes)
 y2 = Int(Rnd * MM.VRes)
 Line (x1,y1)-(x2,y2),Int(Rnd * 8)
Next a
Print @(0,0) "2000 Lines"
Do While Inkey$ = "" : Loop
'clear the screen
'Cls
box_erase
'Box's
For a = 1 To 2000
 x1 = Int(Rnd * MM.HRes)
 y1 = Int(Rnd * MM.VRes)
 x2 = Int(Rnd * MM.HRes)
 y2 = Int(Rnd * MM.VRes)
 Line (x1,y1)-(x2,y2),Int(Rnd * 8),b
Next a
Print @(0,0) "2000 Box"
Do While Inkey$ = "" : Loop
'clear the screen
'Cls
box_erase
'Filled Box's
For a = 1 To 200
 x1 = Int(Rnd * MM.HRes)
 y1 = Int(Rnd * MM.VRes)
 x2 = Int(Rnd * MM.HRes)
 y2 = Int(Rnd * MM.VRes)
 Line (x1,y1)-(x2,y2),Int(Rnd * 8),bf
Next a
Print @(0,0) "200 Filled Box"
Do While Inkey$ = "" : Loop
'clear the screen
'Cls
box_erase
'Circles
For a = 1 To 2000
 x1 = Int(Rnd * MM.HRes)
 y1 = Int(Rnd * MM.VRes)
 r = Int(Rnd * (MM.HRes/4))
 Circle (x1,y1),r,Int(Rnd * 8)
Next a
Print @(0,0) "2000 Circles"
Do While Inkey$ = "" : Loop
'clear the screen
'Cls
box_erase
'Filled Circles
For a = 1 To 200
 x1 = Int(Rnd * MM.HRes)
 y1 = Int(Rnd * MM.VRes)
 r = Int(Rnd * (MM.HRes/4))
 Circle (x1,y1),r,Int(Rnd * 8),f
Next a
Print @(0,0) "200 Filled Circles"
Do While Inkey$ = "" : Loop
'clear the screen
'Cls
box_erase
'Line Saver
For a = 1 To 7
 ox1(a) = 0
 oy1(a) = 0
 ox2(a) = 0
 oy2(a) = 0
 px1(a) = Int(Rnd * MM.HRes)
 py1(a) = Int(Rnd * MM.VRes)
 px2(a) = Int(Rnd * MM.HRes)
 py2(a) = Int(Rnd * MM.VRes)
 dx1(a) = (Rnd * 5) + 3
 dy1(a) = (Rnd * 5) + 3
 dx2(a) = (Rnd * 5) + 3
 dy2(a) = (Rnd * 5) + 3
Next a
Do While Inkey$ = ""
 For a = 1 To 7
  px1(a) = px1(a) + dx1(a)
  py1(a) = py1(a) + dy1(a)
  px2(a) = px2(a) + dx2(a)
  py2(a) = py2(a) + dy2(a)
  If px1(a) > MM.HRes - dx1(a) Then dx1(a) = -((Rnd * 5) + 3)
  If py1(a) > MM.VRes - dy1(a) Then dy1(a) = -((Rnd * 5) + 3)
  If px1(a) < Abs(dx1(a)) Then dx1(a) = (Rnd * 5) + 3
  If py1(a) < Abs(dy1(a)) Then dy1(a) = (Rnd * 5) + 3
  If px2(a) > MM.HRes - dx2(a) Then dx2(a) = -((Rnd * 5) + 3)
  If py2(a) > MM.VRes - dy2(a) Then dy2(a) = -((Rnd * 5) + 3)
  If px2(a) < Abs(dx2(a)) Then dx2(a) = (Rnd * 5) + 3
  If py2(a) < Abs(dy2(a)) Then dy2(a) = (Rnd * 5) + 3
  Line (ox1(a),oy1(a))-(ox2(a),oy2(a)),0
  Line (px1(a),py1(a))-(px2(a),py2(a)),a
  ox1(a) = px1(a)
  oy1(a) = py1(a)
  ox2(a) = px2(a)
  oy2(a) = py2(a)
 Next a
Loop
'clear the screen
'Cls
box_erase
'Blitter
For a = 0 To MM.HRes - 16 Step 16
 For b = 0 To MM.VRes - 16 Step 16
  Line(a,b)-(a+15,b+15),Int(Rnd * 7) + 1,bf
  Line(a,b)-(a+15,b+15),0,b
 Next b
Next a
For a = 0 To MM.VRes - 16 Step 32
 For b = 0 To MM.HRes + 16
  BLIT 0,a,1,a,MM.HRes,16
  BLIT 0,a + 16,-1,a + 16,MM.HRes,16
 Next b
Next a
For a = 0 To MM.HRes - 16 Step 16
 For b = 0 To MM.VRes - 16 Step 16
  Line(a,b)-(a+15,b+15),Int(Rnd * 7) + 1,bf
  Line(a,b)-(a+15,b+15),0,b
 Next b
Next a
For a = 0 To MM.HRes - 16 Step 32
 For b = 0 To MM.VRes + 16
  BLIT a,0,a,1,16,MM.VRes
  BLIT a + 16,0,a + 16,-1,16,MM.VRes
 Next b
Next a
For a = 0 To MM.HRes - 16 Step 16
 For b = 0 To MM.VRes - 16 Step 16
  Line(a,b)-(a+15,b+15),Int(Rnd * 7) + 1,bf
  Line(a,b)-(a+15,b+15),0,b
 Next b
Next a
For a = 0 To MM.HRes + 16
 BLIT 0,0,1,0,MM.HRes,16
 BLIT 0,16,-1,16,MM.HRes,16
 BLIT 0,32,1,32,MM.HRes,16
 BLIT 0,48,-1,48,MM.HRes,16
 BLIT 0,64,1,64,MM.HRes,16
 BLIT 0,80,-1,80,MM.HRes,16
 BLIT 0,96,1,96,MM.HRes,16
8 BLIT 0,112,-1,112,MM.HRes,16
 BLIT 0,128,1,128,MM.HRes,16
 BLIT 0,144,-1,144,MM.HRes,16
 BLIT 0,160,1,160,MM.HRes,16
 BLIT 0,176,-1,176,MM.HRes,16
 BLIT 0,192,1,192,MM.HRes,16
 BLIT 0,208,-1,208,MM.HRes,16
 BLIT 0,224,1,224,MM.HRes,16
Next a
For a = 0 To MM.HRes - 16 Step 16
 For b = 0 To MM.VRes - 16 Step 16
  Line(a,b)-(a+15,b+15),Int(Rnd * 7) + 1,bf
  Line(a,b)-(a+15,b+15),0,b
 Next b
Next a
For a = 0 To MM.VRes + 16
 BLIT 0,0,0,1,16,MM.VRes
 BLIT 16,0,16,-1,16,MM.VRes
 BLIT 32,0,32,1,16,MM.VRes
 BLIT 48,0,48,-1,16,MM.VRes
 BLIT 64,0,64,1,16,MM.VRes
 BLIT 80,0,80,-1,16,MM.VRes
 BLIT 96,0,96,1,16,MM.VRes
 BLIT 112,0,112,-1,16,MM.VRes
 BLIT 128,0,128,1,16,MM.VRes
 BLIT 144,0,144,-1,16,MM.VRes
 BLIT 160,0,160,1,16,MM.VRes
 BLIT 176,0,176,-1,16,MM.VRes
 BLIT 192,0,192,1,16,MM.VRes
 BLIT 208,0,208,-1,16,MM.VRes
 BLIT 224,0,224,1,16,MM.VRes
 BLIT 240,0,240,-1,16,MM.VRes
Next a
Print @(50,90) "End of Graphics test ..."
Do While Inkey$ = "" : Loop
box_erase
End

Sub box_erase
 'erase the screen with black box's
 Local j
 For j = 0 To Int(MM.HRes / 2) + 2 Step 2
  Line(j,j)-(MM.HRes - j,MM.VRes - j),0,b
  Pause 15
 Next j
 For j = Int(MM.HRes / 2) + 2 To 0 Step -1
  Line(j,j)-(MM.HRes - j,MM.VRes - j),0,b
  Pause 10
 Next j
End Sub
