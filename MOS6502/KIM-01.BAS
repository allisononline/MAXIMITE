#Include "Soft6502.inc"

Sub LoadKIM
    Initialise
    M6530Init
    SevenSegInit
    WriteMemory(PowerResetRequest,&H22)
    WriteMemory(PowerResetRequest+1,&H1C)
    WriteMemory(NonMaskRequest,&H00)
    WriteMemory(NonMaskRequest+1,&H1C)
    WriteMemory(BreakRequest,&H00)
    WriteMemory(BreakRequest+1,&H1C)
    PowerReset
    Do
        'WriteMemory(PeripheralAAddr,1)
        Cycle
        TeleType
        StatusDisplay
        FileOutput
        SevenSegOutput
        'Delay
    Loop
End Sub

Sub M6530Init
    M65302Addr = &H1C00
    M65303Addr = &H1800
    PeripheralAAddr = &H1740
    PeripheralBAddr = &H1742
    PeripheralA = 0
    PeripheralB = 0
    LoadProgram("KIMROM2.BIN",M65302Addr)
    LoadProgram("KIMROM3.BIN",M65303Addr)
End Sub

Sub M6530Store
    If Instruction$ = "STA" Or Instruction$ = "STX" Or Instruction$ = "STY" Then
        If CPUMemoryAddress = PeripheralAAddr Then
            PeripheralA = ReadMemory(PeripheralAAddr)
        ElseIf CPUMemoryAddress = PeripheralBAddr Then
            PeripheralB = ReadMemory(PeripheralBAddr)
        EndIf
    EndIf
End Sub

Sub M6530Load
    If Instruction$ = "LDA" Or Instruction$ = "LDX" Or Instruction$ = "LDY" Then
        If CPUMemoryAddress = PeripheralAAddr Then
            WriteMemory(PeripheralAAddr,PeripheralA)
        ElseIf CPUMemoryAddress = PeripheralBAddr Then
            WriteMemory(PeripheralBAddr,PeripheralB)
        EndIf
    EndIf
End Sub

Sub SevenSegInit
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
    Dim SegOutput(6)
End Sub

Sub SevenSegOutput
    SegDisplay = Fix((ReadMemory(PeripheralBAddr) AND &H1E)/2)
    If SegDisplay => 4 AND SegDisplay =< 9 Then
        SegCode = ReadMemory(PeripheralAAddr) AND &H7F
        For i = 0 To &HF
            If SegCode = CharCode(i) Then
                SegOutput(SegDisplay-4) = i
            EndIf
        Next
        For i = 0 To 5
            Print Hex$(SegOutput(i));
        Next
        Print ""
    EndIf
End Sub

Sub TeleType
    If InstructionRegister = &H1C52 Then
        WriteMemory(PeripheralA,&H01)
    EndIf
    If InstructionRegister = &H1EA0 Then
        Print Chr$(ReadMemory(&HFE));
    EndIf
End Sub

Sub KeyPress
    If (PeripheralB AND &H1E)/2 = 1 Then
        PeripheralA = PeripheralA OR 1
    EndIf
End Sub