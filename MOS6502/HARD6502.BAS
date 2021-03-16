Sub Initialise
    Accumulator = 0
    RegisterX = 0
    RegisterY = 0
    ProgramCounterLow = 0
    ProgramCounterHigh = 0
    StackPointer = 0
    StatusRegister = 0
    AddressBusLow = 0
    AddressBusHigh = 0
    AdderHoldRegister = 0
    DataBus = 0
    InstructionRegister = 0
    Clock = 0
    ResetPin = 0
    ReadWritePin = 0
    ReadyPin = 0
    IRQPin = 0
    NMIPin = 0
    SyncPin  = 0

    StackAddress = &H0100
    NonMaskInterrupt = &HFFFA
    PowerOnReset = &HFFFC
    BreakRequest = &HFFFE

    Instruction$ = "   "
    Address$ = "   "

    Cls
    Open "M6502MEM.BIN" For Random As #3
    Seek #3,1
    For i = 0 To &HFFFF
        Print #3,Chr$(00);
    Next
End Sub

Sub PowerReset
    Accumulator = 0
    RegisterX = 0
    RegisterY = 0
    StackPointer = &HFD
    WriteStatus("Constant",1)
End Sub

Sub PhaseOne
End Sub

Sub PhaseTwo
End Sub

Function ReadStatus(Flag$)
    If Flag$ = "Negative" Then
        Bit = 7
    ElseIf Flag$ = "Overflow" Then
        Bit = 6
    ElseIf Flag$ = "Break" Then
        Bit = 4
    ElseIf Flag$ = "Decimal" Then
        Bit = 3
    ElseIf Flag$ = "Interrupt" Then
        Bit = 2
    ElseIf Flag$ = "Zero" Then
        Bit = 1
    ElseIf Flag$ = "Carry" Then
        Bit = 0
    EndIf
    Mask = 2^Bit
    If (StatusRegister And Mask) = 0 Then
        ReadStatus = 0
    Else
        ReadStatus = 1
    EndIf
End Function

Sub WriteStatus(Flag$,Status)
    If Flag$ = "Negative" Then
        Bit = 7
    ElseIf Flag$ = "Overflow" Then
        Bit = 6
    ElseIf Flag$ = "Constant" Then
        Bit = 5
    ElseIf Flag$ = "Break" Then
        Bit = 4
    ElseIf Flag$ = "Decimal" Then
        Bit = 3
    ElseIf Flag$ = "Interrupt" Then
        Bit = 2
    ElseIf Flag$ = "Zero" Then
        Bit = 1
    ElseIf Flag$ = "Carry" Then
        Bit = 0
    EndIf
    Mask = 2^Bit
    If Status = 0 Then
        StatusRegister = StatusRegister AND (255-Mask)
    Else
        StatusRegister = StatusRegister OR Mask
    EndIf
End Sub

Function AddressBus()
    AddressBus = (AddressBusHigh*&H100)+AddressBusLow
End Function

Function ProgramCounter
    ProgramCounter = (ProgramCounterHigh*&H100)+ProgramCounterLow
End Function

Function ReadMemory(Address)
    Seek #3, Address + 1
    ReadMemory = Asc(Input$(1,#3))
End Function

Sub WriteMemory(Address,Byte)
    Seek #3, Address + 1
    Print #3, Chr$(Byte);
End Sub

Sub PushStack(Value)
    StackPointer = StackPointer - 1
    WriteMemory(StackAddress+StackPointer,Value)
End Sub

Function PullStack()
    StackPointer = StackPointer + 1
    PullStack = ReadMemory(StackAddress+StackPointer)
End Function