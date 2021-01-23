'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Demonstration of Colour MMBasic
' Geoff Graham,  June 2012
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

If MM.Device$ <> "Colour Maximite" Then
  Print "This demonstration is intended to run on a Colour Maximite"
  End
EndIf

Mode 3
Cls
cx = MM.HRes/2 : cy = MM.VRes/2

' draw random circles with smaller circles near to the centre
Do
  x = Rnd * MM.HRes                            ' horiz center of the circle
  y = Rnd * MM.VRes                            ' vert center of the circle
  Do
    c = Int(Rnd * 6) + 1                       ' the colour
  Loop Until Pixel(x, y) <> c                  ' must be different
  d = Sqr(Abs(x-cx)^2 + Abs(y-cy)^2)           ' distance from the centre
  r = Rnd * d/8 + 2 + d/14                     ' radius
  Circle (x,y), r, c, f                        ' draw the sphere
  If r > Rnd*8 + 13 Then Circle (x,y), r+1, 0  ' draw the edge in black
  If Inkey$ <> "" Then End
Loop
