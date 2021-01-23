'-----------------------------------------------------------------
' HEXDUMP.BAS - a program to do a hexidecimal dump of a file.
' Doug Pankhurst and James Deakins 2012
Option Error Continue
Start:
Line Input "Enter file name to be displayed ? ",FileName$
Open FileName$ For Input As #1
If MM.Errno = 6 Then
  Print "File does not exist"
  GoTo Start
Else
  Option Error Abort  'back to normal
EndIf
ChrCnt = 0
Do While Not Eof(#1)
  For ScreenLines = 1 To 35
    Text$=""
    ChrCnt$ = Format$(ChrCnt,"%04.0f")
    Print ChrCnt$ + " ";
    For CharInLineCount = 1 To 16
      If Eof(#1) Then
        Text$ = Text$ + " "
        HexChar$ = "  "
        ScreenLines = 35
      Else
        InputChar$ = Input$(1,#1)
        If Asc(InputChar$) < 32 Then
          Text$ = Text$ + "."
        Else
          Text$ = Text$ + InputChar$
        EndIf
        InputChar = Asc(InputChar$)
        HexChar$ = Hex$(Asc(InputChar$))
        If Len(HexChar$) = 1 Then
          hexChar$ = "0" + HexChar$
        EndIf
      EndIf
      ChrCnt = ChrCnt + 1
      If CharInLineCount = 9 Then
        Print " ";
      EndIf
      Print HexChar$ + " ";
    Next CharInLineCount
  Print Text$
  Next ScreenLines
Line Input "Press any key to continue - ",Junk$
Loop
End

