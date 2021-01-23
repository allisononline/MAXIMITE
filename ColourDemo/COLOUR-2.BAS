''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Demonstration of the colour modes in Colour MMBasic
' Geoff Graham  May 2012
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Data "Black ", " Blue ", "Green ", " Cyan "
Data " Red  ", "Purple", "Yellow", "White "
Data Red, Yellow, Green, Red, Blue, Purple,    Red, Cyan, White
Data Green, Cyan, Blue,  Green, Purple, White, Yellow, Blue, White
Dim c$(8)
Dim p(9, 2)
For i = 0 To 7: Read c$(i) : Next
For i = 1 To 6: For j = 0 To 2 : Read p(i, j)  : Next i, j

Option usb off
Cls
mspc = 31
Mode 3
Colour 7
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Print "Monochrome Mode";
Line (0, MM.VPos+10)-(MM.HPos-2, MM.VPos+10), 7
Locate 0, MM.VPos + 5
Print "Any one colour can be selected for all output:"
Locate 0, MM.VPos + 5
For i = Blue To White
  Colour i
  Print " MODE 1," Str$(i) "  ";
Next
Print
For i = Blue To White
  Colour i
  Print "  " c$(i) "   ";
Next

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Print @(0, MM.VPos + mspc) "Four colour mode";
Line (0, MM.VPos+10)-(MM.HPos-2, MM.VPos+10), 7
Locate 0, MM.VPos + 5
Print "Six colour palettes to chose from."
Print "Each palette consists of three colours plus black:" ;
For i = 1 To 6
  Print @(20, MM.VPos + 17) "Palette" i "  MODE 2," Str$(i) "   ";
  For j = 0 To 2
    Colour Black, p(i, j)
    Print "      ";
    Colour White, Black
    Print " ";
  Next
  Print "   (";
  For j = 0 To 2
    Colour p(i, j)
    Print " " c$(p(i, j)) " ";
  Next
  Colour White
  Print ")";
Next

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Print @(0, MM.VPos + mspc) "Eight colour mode";
Line (0, MM.VPos+10)-(MM.HPos-2, MM.VPos+10), 7
Locate 0, MM.VPos + 5
Print "MODE 3    All colours can be used simultaneously"
line3 = MM.VPos
height3 = 40
For i = 0 To MM.HRes
  If (i \ (MM.HRes\8)) + 1 > 7 Then Exit For
  Line (i, line3)-(i + height3, line3 + height3), (i \ (MM.HRes\8)) + 1
Next


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Print @(0, MM.VPos + mspc) "240x216 eight colour mode";
Line (0, MM.VPos+10)-(MM.HPos-2, MM.VPos+10), 7
Locate 0, MM.VPos + 5
Print "MODE 4                                          (press any key to exit):"
Font 1, 2
p$ = "  All Eight Colours  240x216 Pixels"
p$ = p$ + Chr$(13) + Chr$(10) + "  High Speed    Maximum Free Memory"
line4 = MM.VPos
Do
  Locate 0, line4
  For i = 1 To Len(p$)
    Colour (Rnd * 6) + 1
    Print Mid$(p$, i, 1);
    If i Mod 12 = 0 Then
      BLIT 0, line3, 1, line3, MM.HRes-2, height3 + 1
      BLIT MM.HRes - 2, line3, 0, line3, 1, height3 + 1
    EndIf
  Next i
Loop Until Inkey$ <> ""
Colour White
Option usb on
Print
' SaveBMP "t.bmp"

