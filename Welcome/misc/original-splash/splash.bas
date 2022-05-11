
' Colour Maximite 2 Animation Splash Screen
' written by vegipete
' August 2020
'
' Demonstrates some mathematical number crunching,
' image generation using multiple pages, page copying and blitting,
' page flipping to prevent image flicker
' and colour pallet cycling.
'
' Title painting uses path data generated by CNC software.
'
' While the program is somewhat commented and structured, it is NOT
' an example of particularly good coding practices because it is
' filled with magic numbers. However, perhaps there are nuggets within
' that are interesting and of some value.

#Include "../../common/welcome.inc"

' factors to fit original CNC letter path to screen
offsetx = 1650
offsety = 700
SCALE = 95

SPRAYSIZE = 5   ' radius of pen
STROKESPEED = 4

OURCOLOUR = &hBBBBBB    ' random colour for cycling
GNDCOLOUR = &h804000    ' medium brown for the ground
SHADOWCOL = &h301500    ' darker brown for the shadow on the ground

c_red   = 255   ' starting colour - white
c_green = 255
c_blue  = 255
col_step = 0    ' colour cycle state flag
CSTEP = 8       ' colour cycle step value - bigger is faster change

flip_page = 1   ' active drawing page

mode 1,8        ' 800 x 600 x 8 bit colour

we.clear_keyboard_buffer()

' determine the colour index for the colour to be cycled
page write 1
cls
pixel 0,0,OURCOLOUR
our_col_num = peek(byte MM.INFO(PAGE ADDRESS 1))
map(our_col_num) = &hFFFFFF
map set

' clear some pages
page write 3  ' holds shadow coloured text
cls
page write 4  ' holds text in sky and the ground
cls

' Stars! Everyone likes stars
page write 5  ' holds the star field
cls
for i = 1 to 300    ' So how many star d'ya want?
  pixel rnd * 800, rnd * 600, rgb(rnd * 255, rnd * 255, rnd * 255)
next i

' make stars visible
page copy 5,0

' paint text onto display, plus work copies on pages 3 and 4
page write 0
' Text 400, 570, " Press any key to skip ", "C", 2
Text 400, 570, " Press Q to Quit ", "C", 2
PaintTitle(offsetx,offsety,SCALE,OURCOLOUR)
If we.is_quit_pressed%() Then we.end_program()

' draw ground on source image page
page write 4
box 0,306,MM.HRES,300,0,GNDCOLOUR,GNDCOLOUR
DrawGrid

' scroll ground up into view
page write 0
Text 400, 285, "Welcome Tape " + WE.VERSION$, "C", 2

for i = 599 to 306 step -1
  blit 0,306,0,i,MM.HRES,306,4
'  Text 400, 570, " Press any key to skip ", "C", 2
  Text 400, 570, " Press Q to Quit ", "C", 2
  pause 10
  If we.is_quit_pressed%() Then we.end_program()
next i

angle = 4   ' starting sun angle in the sky
do
  ' prepare page
  page write flip_page

  ' show the stars
  page copy 5, flip_page

  ' draw sun
  x = 400 - cos(rad(angle)) * 500
  y = 300 - sin(rad(angle)) * 250
  circle x,y,20,2,1,&hA0A000,&hFFFF40 ' draw sun - bright yellow fill, darker yellow edge

  ' draw text in sky and ground
  blit 0,100,0,100,MM.HRES,MM.VRES-100,4,4  ' copy image without erasing sun

  ' create shadow of text
  for j = 1 to 300
    blit 0,306-j*sin(rad(angle)),(400-x)*j/150,306+j,MM.HRES,1,3,4
  next j

  ' draw grid on ground
  DrawGrid

  Text 400, 285, "Welcome Tape " + WE.VERSION$, "C", 2
'  Text 400, 570, " Press any key to skip ", "C", 2
  Text 400, 570, " Press Q to Quit ", "C", 2

  ' copy image to display page
  page copy flip_page,0,D

  ' colour cycle the text in the sky
  ColourWheel

  ' advance the sun
  angle = angle + 0.33
  if angle <= 179 then
    ' flip to other page
    flip_page = 1 + (flip_page = 1)
  else
    angle = 0
  endif

loop until we.is_quit_pressed%()

we.wait_for_quit()
we.end_program()

' draw grid lines on the ground
sub DrawGrid
  for i = 0 to 15
    delta = sin(i/10) * 90
    x = cos(rad(90 - delta)) * 800
    y = sin(rad(90 - delta)) * 600
    line 400,305,400 - x,305 + y,1,0
    line 400,305,400 + x,305 + y,1,0
  next i
  for i = 1 to 20
    line 0,308+i*i,MM.HRES,308+i*i,1,0
  next i
end sub

' cycle the colour of colour index given in "our_col_num"
sub ColourWheel
  select case col_step
    case 0    ' fade to red
      c_green = max(c_green - CSTEP, 0)
      c_blue = max(c_blue - CSTEP, 0)
      c_red   = min(c_red + CSTEP, 255)
      if c_blue = 0 then col_step = 1
    case 1    ' red to yellow
      c_green = min(c_green + CSTEP, 255)
      if c_green = 255 then col_step = 2
    case 2    ' yellow to green
      c_red   = max(c_red - CSTEP,   0)
      if c_red = 0 then col_step = 3
    case 3    ' green to cyan
      c_blue = min(c_blue + CSTEP, 255)
      if c_blue = 255 then col_step = 4
    case 4    ' cyan to blue
      c_green  = max(c_green - CSTEP,   0)
      if c_green = 0 then col_step = 5
    case 5    ' blue to magenta
      c_red = min(c_red + CSTEP, 255)
      if c_red = 255 then col_step = 6
    case 6    ' magenta to red
      c_blue   = max(c_blue - CSTEP,   0)
      if c_blue = 0 then col_step = 1
  end select
  map(our_col_num) = (c_red * 256 + c_green) * 256 + c_blue
  map set
end sub

'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
' Read the title data and paint it on the screen
' Attempt to mimic spray painting
sub PaintTitle(x,y,scale,colr)
  restore CMM2string  ' move read pointer to data
  do
    read x1,y1
    do
      read x2,y2
      if x2 > 0 then
        col_step = 0
        read x2,y2
      endif
      if x2 = 0 then exit do  ' stroke done
      PaintLine(x+x1*scale,y-y1*scale,x+x2*scale,y-y2*scale,colr)
      x1 = x2
      y1 = y2
    loop
    if y2 = 0 then exit do  ' all done
    pause y2
    if we.is_quit_pressed%() Then Exit Do
  loop
end sub

' Paint a line from x0,y0 to x1,y1
' Use Bresenham's algorithm and draw small circles
' for each position along the line
' Desired speed is slow, as if spray painting.
sub PaintLine(x0,y0,x1,y1,c)

  local integer dx, dy, stepx, stepy, frac

  x0 = int(x0) : y0 = int(y0)
  x1 = int(x1) : y1 = int(y1)
  dy = y1 - y0 : dx = x1 - x0

  stepy = 1
  if dy < 0 then dy = -dy : stepy = -1

  stepx = 1
  if dx < 0 then dx = -dx : stepx = -1

  dy = dy * 2
  dx = dx * 2

  ' draw starting point
  page write 0
  circle x0, y0, SPRAYSIZE, SPRAYSIZE, 1, c
  ' extra draw for working copy on page 3
  page write 3
  circle x0, y0, SPRAYSIZE, SPRAYSIZE, 1, SHADOWCOL
  ' extra draw for working copy on page 4
  page write 4
  circle x0, y0, SPRAYSIZE, SPRAYSIZE, 1, c

  if(dx > dy) then ' shallow line = iterate over x
    frac = dy - dx / 2
    do while x0 <> x1
      if frac >= 0 then y0 = y0 + stepy : frac = frac - dx
      x0 = x0 + stepx
      frac = frac + dy
      page write 0
      circle x0, y0, SPRAYSIZE, SPRAYSIZE, 1, c
      ' extra draw for working copy on page 3
      page write 3
      circle x0, y0, SPRAYSIZE, SPRAYSIZE, 1, SHADOWCOL
      ' extra draw for working copy on page 4
      page write 4
      circle x0, y0, SPRAYSIZE, SPRAYSIZE, 1, c
      pause STROKESPEED
    loop
  else  ' steep line = iterate over y
    frac = dx - dy / 2
    do while y0 <> y1
      if frac >= 0 then x0 = x0 + stepx : frac = frac - dy
      y0 = y0 + stepy
      frac = frac + dx
      page write 0
      circle x0, y0, SPRAYSIZE, SPRAYSIZE, 1, c
      ' extra draw for working copy on page 3
      page write 3
      circle x0, y0, SPRAYSIZE, SPRAYSIZE, 1, SHADOWCOL
      ' extra draw for working copy on page 4
      page write 4
      circle x0, y0, SPRAYSIZE, SPRAYSIZE, 1, c
      pause STROKESPEED
    loop
  endif

end sub

' Stroke encoded lettering.
' Form characters by drawing lines point to point.
' End of stroke indicated by (0,n)
'   where n is delay (ms) before starting next stroke
' End of image indicated by (0,0)

CMM2string:
' C
DATA -16.5386, 5.7056
DATA -16.6120, 5.8249
DATA -16.7135, 5.9005
DATA -16.8145, 5.9172
DATA -16.9065, 5.8753
DATA -16.9869, 5.7724
DATA -17.0430, 5.6238
DATA -17.0832, 5.4365
DATA -17.1000, 5.2571
DATA -17.1000, 5.0587
DATA -17.0876, 4.9094
DATA -17.0414, 4.7360
DATA -16.9701, 4.5998
DATA -16.9059, 4.5174
DATA -16.8264, 4.4685
DATA -16.7433, 4.4637
DATA -16.6605, 4.4998
DATA -16.5905, 4.5682
DATA -16.5347, 4.6545
DATA 0,50

' o
DATA -16.0707, 5.3594
DATA -16.1162, 5.4465
DATA -16.1513, 5.4974
DATA -16.2038, 5.5263
DATA -16.2420, 5.5263
DATA -16.2872, 5.5083
DATA -16.3492, 5.4252
DATA -16.4123, 5.2697
DATA -16.4337, 5.1199
DATA -16.4364, 4.8908
DATA -16.4277, 4.7794
DATA -16.3920, 4.6514
DATA -16.3349, 4.5522
DATA -16.2658, 4.4963
DATA -16.2040, 4.4887
DATA -16.1428, 4.5075
DATA -16.0806, 4.5783
DATA -16.0394, 4.6820
DATA -16.0143, 4.8221
DATA -16.0052, 4.9754
DATA -16.0169, 5.1281
DATA -16.0578, 5.3346
DATA 0,50

' l
DATA -15.8353, 5.9035
DATA -15.8353, 4.5061
DATA 0,50

' o
DATA -15.2948, 5.3594
DATA -15.3402, 5.4465
DATA -15.3754, 5.4974
DATA -15.4279, 5.5263
DATA -15.4661, 5.5263
DATA -15.5113, 5.5083
DATA -15.5733, 5.4252
DATA -15.6364, 5.2697
DATA -15.6578, 5.1199
DATA -15.6605, 4.8908
DATA -15.6518, 4.7794
DATA -15.6161, 4.6514
DATA -15.5590, 4.5522
DATA -15.4899, 4.4963
DATA -15.4281, 4.4887
DATA -15.3669, 4.5075
DATA -15.3047, 4.5783
DATA -15.2635, 4.6820
DATA -15.2384, 4.8221
DATA -15.2293, 4.9754
DATA -15.2410, 5.1281
DATA -15.2819, 5.3346
DATA 0,50

' u
DATA -15.0595, 5.4632
DATA -15.0595, 4.8815
DATA -15.0515, 4.7819
DATA -15.0301, 4.6634
DATA -15.0000, 4.5672
DATA -14.9716, 4.5219
DATA -14.9391, 4.4989
DATA -14.9047, 4.4926
DATA -14.8725, 4.4944
DATA -14.8321, 4.5110
DATA -14.7978, 4.5419
DATA -14.7733, 4.5825
DATA -14.7548, 4.6265
DATA -14.7252, 4.7285
DATA -14.7082, 4.8294
DATA -14.7032, 4.9112
DATA -14.7032, 5.4830
DATA 0,50

' r
DATA -14.5009, 5.4706
DATA -14.5009, 4.5185
DATA 0,50
DATA -14.4934, 5.2728
DATA -14.4219, 5.4242
DATA -14.3821, 5.4867
DATA -14.3314, 5.5187
DATA -14.2953, 5.5223
DATA -14.2593, 5.5114
DATA -14.2229, 5.4759
DATA -14.1912, 5.4212
DATA 1,1
DATA 0,150

' M - first stroke
DATA -13.7378, 5.8837
DATA -13.7391, 4.4566
DATA 0,50

' M - the rest
DATA -13.7378, 5.8837
DATA -13.5003, 4.7880
DATA -13.2629, 5.8688
DATA -13.2590, 4.4789
DATA 0,50

' a
DATA -12.7207, 5.3952
DATA -12.7629, 5.4610
DATA -12.8214, 5.5167
DATA -12.8714, 5.5329
DATA -12.9357, 5.5353
DATA -12.9867, 5.5094
DATA -13.0326, 5.4502
DATA -13.0690, 5.3610
DATA -13.0945, 5.2598
DATA -13.1108, 5.1289
DATA -13.1125, 5.0129
DATA -13.1108, 4.9171
DATA -13.0949, 4.7864
DATA -13.0659, 4.6515
DATA -13.0324, 4.5733
DATA -12.9840, 4.5191
DATA -12.9366, 4.5022
DATA -12.8885, 4.5036
DATA -12.8324, 4.5382
DATA -12.7833, 4.6052
DATA -12.7499, 4.6978
DATA -12.7382, 4.7823
DATA -12.7093, 5.4335
DATA -12.7081, 4.5383
DATA 0,50

' x - first stroke
DATA -12.5382, 5.5028
DATA -12.1626, 4.5234
DATA 0,40

' x - second stroke
DATA -12.1742, 5.5176
DATA -12.5563, 4.5259
DATA 0,50

' i - body
DATA -12.0142, 5.5077
DATA -12.0142, 4.5395
DATA 0,50

' m
DATA -11.8043, 5.5176
DATA -11.8038, 4.5185
DATA 0,50
DATA -11.7656, 5.2968
DATA -11.7549, 5.3687
DATA -11.7245, 5.4456
DATA -11.6836, 5.4941
DATA -11.6451, 5.5222
DATA -11.6089, 5.5301
DATA -11.5714, 5.5260
DATA -11.5324, 5.4989
DATA -11.4994, 5.4476
DATA -11.4774, 5.3801
DATA -11.4618, 5.2968
DATA -11.4555, 5.2183
DATA -11.4579, 4.5234
DATA 0,50
DATA -11.4205, 5.2499
DATA -11.4092, 5.3210
DATA -11.3881, 5.3899
DATA -11.3593, 5.4467
DATA -11.3239, 5.4881
DATA -11.2932, 5.5062
DATA -11.2530, 5.5196
DATA -11.2259, 5.5193
DATA -11.1899, 5.5019
DATA -11.1540, 5.4542
DATA -11.1263, 5.3826
DATA -11.1135, 5.3140
DATA -11.1094, 5.2613
DATA -11.1094, 4.5209
DATA 0,50

' i - body
DATA -10.8993, 5.5077
DATA -10.8993, 4.5318
DATA 0,50

' t - body
DATA -10.6662, 5.9331
DATA -10.6662, 4.7034
DATA -10.6605, 4.6508
DATA -10.6471, 4.5977
DATA -10.6316, 4.5630
DATA -10.6120, 4.5354
DATA -10.5860, 4.5203
DATA -10.5009, 4.5185
DATA 0,250

' i - dot
DATA -12.0187, 5.9232
DATA -12.0187, 5.8589
DATA 0,200

' i - dot
DATA -10.9038, 5.9232
DATA -10.9038, 5.8589
DATA 0,200

' t - cross
DATA -10.7694, 5.4978
DATA -10.4880, 5.4978
DATA 0,100

' e
DATA -10.3884, 5.0329
DATA -9.9832, 5.0329
DATA -9.9852, 5.2045
DATA -10.0007, 5.3020
DATA -10.0203, 5.3697
DATA -10.0453, 5.4303
DATA -10.0847, 5.4867
DATA -10.1242, 5.5165
DATA -10.1578, 5.5275
DATA -10.2096, 5.5275
DATA -10.2593, 5.5091
DATA -10.3008, 5.4660
DATA -10.3317, 5.4208
DATA -10.3582, 5.3562
DATA -10.3738, 5.2879
DATA -10.3851, 5.1982
DATA -10.3910, 5.1143
DATA -10.3926, 5.0148
DATA -10.3919, 4.9155
DATA -10.3815, 4.8075
DATA -10.3592, 4.6916
DATA -10.3312, 4.6131
DATA -10.2907, 4.5548
DATA -10.2463, 4.5267
DATA -10.2038, 4.5110
DATA -10.1604, 4.5076
DATA -10.1168, 4.5166
DATA -10.0758, 4.5394
DATA -10.0397, 4.5738
DATA -9.9870, 4.6446
DATA 0,50

' 2
DATA -9.6940, 5.8575
DATA -9.6424, 5.9141
DATA -9.5670, 5.9858
DATA -9.4707, 6.0511
DATA -9.3981, 6.0600
DATA -9.3360, 6.0405
DATA -9.2730, 5.9992
DATA -9.2249, 5.9283
DATA -9.1907, 5.8304
DATA -9.1710, 5.7135
DATA -9.1664, 5.6064
DATA -9.1745, 5.4999
DATA -9.1952, 5.4005
DATA -9.2254, 5.3188
DATA -9.8231, 4.2341
DATA -9.1000, 4.3990
DATA 0,0