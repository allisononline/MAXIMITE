Library Load "SOFT6502.LIB"

Sub M6530Init
    M65302Addr = &H1C00
    M65303Addr = &H1800
    LoadProgram("KIMROM2.BIN",M65302Addr)
    LoadProgram("KIMROM3.BIN",M65303Addr)
End Sub

Sub SevenSegInit
    DisplayAAddr = &H1740
    DisplayBAddr = &H1742
    Dim CharCode(16)
    CharCode(&H0) = &H3F
    CharCode(&H1) = &H06
    CharCode(&H2) = &H5B
    CharCode(&H3) = &H4F
    CharCode(&H4) = &H66
    CharCode(&H5) = &H6D
    CharCode(&H6) = &H7D
    CharCode(&H7) = &H07
    CharCode(&H8) = &H7F
    CharCode(&H9) = &H6F
    CharCode(&HA) = &H77
    CharCode(&HB) = &H7C
    CharCode(&HC) = &H39
    CharCode(&HD) = &H5E
    CharCode(&HE) = &H79
    CharCode(&HF) = &H71
End Sub

Sub SevenSegOutput
    If ReadMemory(DisplayAAddr) OR ReadMemory(DisplayBAddr) > 0 Then
        DisplayData = ReadMemory(DisplayAAddr) AND &H7F
        DisplaySelect = ((ReadMemory(DisplayAAddr) AND &H1E)/2)-4
        For i = 0 TO 15
            If DisplayData = CharCode(i) Then
                Print Space$(DisplaySelect)+Hex$(i)
            EndIf
        Next
    EndIf
End Sub

Initlialise
M6530Init
SevenSegInit
PowerReset
Do
    Cycle
    SevenSegOutput
Loop
