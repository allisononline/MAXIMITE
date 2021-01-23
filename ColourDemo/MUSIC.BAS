'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' Demonstration of the music playing ability of the Maximite
'
' Geoff Graham   July 2012
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


' First, check if the MOD files are on drive A: and if not. copy them
'
For i = 1 To 3
  Option error continue
  Open "A:T" + Chr$(48 + i) + ".Mod" For input As #1""
  If MM.Errno Then
    Option error abort
    If i = 1 Then
      Print "This program will copy three files to drive A:"
      Print "The screen will go blank for a while so please be patient"
      Input "Press ENTER to continue...", t$
    EndIf
    Copy "B:T" + Chr$(48 + i) + ".Mod" To "A:"
  Else
    Option error abort
    Close #1
  EndIf
Next i


' Play each file in a repeating sequence
i = 1
Do
  PlayMOD "A:T" + Chr$(48 + i) + ".Mod"
  Cls : Colour 6 : Print "Playing:  " "T" + Chr$(48 + i) + ".MOD"
  Print "Press any key to select the next file or CTRL-C to halt..."
  Print
  Print "While the music is playing MMBasic will calculate the table of prime numbers."
  Print "This ";
  Print "demonstrates that the music is being synthesised in the background."
  Print
  GoSub DoPrimes
'  Do : Loop While Inkey$ = ""
  i = i + 1
  If i > 3 Then i = 1
Loop


' Calculate the table of prime numbers
' Return to the caller if any key has been pressed
'
DoPrimes:
Colour 2
n = 1
Print "       2";
Do
skip:
  n = n + 2
  For d = 3 To Sqr(n)
    If Inkey$ <> "" Then Return
    If n Mod d = 0 Then GoTo skip
  Next d
  Print " " Format$(n, "%7g");
  If MM.VPos > MM.VRes - 36 Then
    BLIT 0, 84, 0, 72, MM.HRes, MM.VRes - 84
    Option usb off
    Locate MM.HPos, MM.VPos - 12
    Option usb on
  EndIf
Loop
