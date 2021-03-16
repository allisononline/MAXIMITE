Sub DebugMsg(Msg$)
    Debug = 0
    If Debug = 1 Then
        Print Msg$
    EndIf
End Sub

Sub Initialise
    Accumulator = 0
    RegisterX = 0
    RegisterY = 0
    ProgramCounter = 0
    StackPointer = 0
    StatusRegister = 0
    InstructionRegister = 0
    MemoryAddress = 0
    Magic = 0

    StackAddress = &H0100
    NonMaskRequest = &HFFFA
    PowerResetRequest = &HFFFC
    BreakRequest = &HFFFE

    OneMinus = 1 XOR &HFF

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
    ProgramCounter = ReadAddress(PowerResetRequest)
    StackPointer = &HFF
End Sub

Sub NonMaskInterrupt
    LoByte = ProgramCounter AND &HFF
    HiByte = Fix(ProgramCounter/&H100)
    PushStack(HiByte)
    PushStack(LoByte)
    PushStack(StatusRegister)
    WriteStatus("Interrupt",1)
    ProgramCounter = ReadAddress(NonMaskRequest)
End Sub

Sub IRQInterrupt
    LoByte = ProgramCounter AND &HFF
    HiByte = Fix(ProgramCounter/&H100)
    PushStack(HiByte)
    PushStack(LoByte)
    PushStack(StatusRegister)
    WriteStatus("Interrupt",1)
End Sub

Sub Test
    Initialise
    LoadC64
    PowerReset
    StatusDisplay
    FileOutput
    Do
        Cycle
        FileOutput
        PrintData
    Loop
    Print "TILT!"
End Sub

Sub PrintData
    If Magic => 32 AND Magic =< 126 Then
        Print CHR$(Magic);
    EndIf
End Sub

Sub LoadC64
    BASICAddress = &HA000
    CharacterAddress = &HD000
    KernelAddress = &HE000
    LoadProgram("BASIC.BIN",BASICAddress)
    LoadProgram("CHARS.BIN",CharacterAddress)
    LoadProgram("KERNAL.BIN",KernelAddress)
End Sub

Sub LoadProgram(Filename$,offset)
    Open Filename$ For Random As #4
    Seek #3,offset+1
    Seek #4,1
    Do While Eof(#4) = 0
        Print #3,Input$(1,#4);
    Loop
    Close #4
End Sub

Sub Cycle
    WriteStatus("Constant",1)
    Fetch
    Decode
    GetAddress
    GetNumber
    Execute
End Sub

Sub Fetch
    InstructionRegister = ReadMemory(ProgramCounter)
    ProgramCounter = ProgramCounter + 1
End Sub

Sub Decode
    Group = InstructionRegister And &B11
    AddressType = (InstructionRegister And &B11100)/&B100
    InstructionType= (InstructionRegister And &B11100000)/&B100000
    HiNibble = Fix(InstructionRegister/&H10)
    LoNibble = InstructionRegister AND &HF
    If Group = &B00 Then
        If InstructionType = &B001 Then
            Instruction$ = "BIT"
        ElseIf InstructionType = &B010 Then
            Instruction$ = "JMP"
        ElseIf InstructionType = &B011 Then
            Instruction$ = "JMP"
        ElseIf InstructionType = &B100 Then
            Instruction$ = "STY"
        ElseIf InstructionType = &B101 Then
            Instruction$ = "LDY"
        ElseIf InstructionType = &B110 Then
            Instruction$ = "CPY"
        ElseIf InstructionType = &B111 Then
            Instruction$ = "CPX"
        EndIf
        If AddressType = &B000 Then
            Address$ = "#"
        ElseIf AddressType = &B001 Then
            Address$ = "zp"
        ElseIf AddressType = &B011 Then
            If InstructionType = &B011 Then
                Address$ = "(a)"
            Else
                Address$ = "a"
            EndIf
        ElseIf AddressType = &B101 Then
            Address$ = "zp,x"
        ElseIf AddressType = &B111 Then
            Address$ = "a,x"
        EndIf
    ElseIf Group = &B01 Then
        If InstructionType= &B000 Then
            Instruction$ = "ORA"
        ElseIf InstructionType= &B001 Then
            Instruction$ = "AND"
        ElseIf InstructionType= &B010 Then
            Instruction$ = "EOR"
        ElseIf InstructionType= &B011 Then
            Instruction$ = "ADC"
        ElseIf InstructionType= &B100 Then
            Instruction$ = "STA"
        ElseIf InstructionType= &B101 Then
            Instruction$ = "LDA"
        ElseIf InstructionType= &B110 Then
            Instruction$ = "CMP"
        ElseIf InstructionType= &B111 Then
            Instruction$ = "SBC"
        EndIf
        If AddressType = &B000 Then
            Address$ = "(zp,x)"
        ElseIf AddressType = &B001 Then
            Address$ = "zp"
        ElseIf AddressType = &B010 Then
            Address$ = "#"
        ElseIf AddressType = &B011 Then
            Address$ = "a"
        ElseIf AddressType = &B100 Then
            Address$ = "(zp),y"
        ElseIf AddressType = &B101 Then
            Address$ = "zp,x"
        ElseIf AddressType = &B110 Then
            Address$ = "a,y"
        ElseIf AddressType = &B001 Then
            Address$ = "a,x"
        EndIf
    ElseIf Group = &B10 Then
        If InstructionType = &B000 Then
               Instruction$ = "ASL"
        ElseIf InstructionType = &B001 Then
               Instruction$ = "ROL"
        ElseIf InstructionType = &B010 Then
               Instruction$ = "LSR"
        ElseIf InstructionType = &B011 Then
               Instruction$ = "ROR"
        ElseIf InstructionType = &B100 Then
               Instruction$ = "STX"
        ElseIf InstructionType = &B101 Then
               Instruction$ = "LDX"
        ElseIf InstructionType = &B110 Then
               Instruction$ = "DEC"
        ElseIf InstructionType = &B111 Then
               Instruction$ = "INC"
        EndIf
        If AddressType = &B000 Then
            Address$ = "#"
        ElseIf AddressType = &B001 Then
            Address$ = "zp"
        ElseIf AddressType = &B010 Then
            Address$ = "A"
        ElseIf AddressType = &B011 Then
            Address$ = "a"
        ElseIf AddressType = &B101 Then
            Address$ = "zp,x"
        ElseIf AddressType = &B111 Then
            Address$ = "a,x"
        EndIf
    EndIf
    If LoNibble = &H0 Then
        Address$ = "r"
        If HiNibble = &H0 Then
            Instruction$ = "BRK"
            Address$ = "i"
        ElseIf HiNibble = &H1 Then
            Instruction$ = "BPL"
        ElseIf HiNibble = &H2 Then
            Instruction$ = "JSR"
            Address$ = "a"
        ElseIf HiNibble = &H3 Then
            Instruction$ = "BMI"
        ElseIf HiNibble = &H4 Then
            Instruction$ = "RTI"
            Address$ = "i"
        ElseIf HiNibble = &H5 Then
            Instruction$ = "BVC"
        ElseIf HiNibble = &H6 Then
            Instruction$ = "RTS"
            Address$ = "i"
        ElseIf HiNibble = &H7 Then
            Instruction$ = "BVS"
        ElseIf HiNibble = &H9 Then
            Instruction$ = "BCC"
        ElseIf HiNibble = &HB Then
            Instruction$ = "BCS"
        ElseIf HiNibble = &HD Then
            Instruction$ = "BNE"
        ElseIf HiNibble = &HF Then
            Instruction$ = "BEQ"
        EndIf
    ElseIf LoNibble = &H8 Then
        Address$ = "i"
        If HiNibble = &H0 Then
            Instruction$ = "PHP"
        ElseIf HiNibble = &H1 Then
            Instruction$ = "CLC"
        ElseIf HiNibble = &H2 Then
            Instruction$ = "PLP"
        ElseIf HiNibble = &H3 Then
            Instruction$ = "SEC"
        ElseIf HiNibble = &H4 Then
            Instruction$ = "PHA"
        ElseIf HiNibble = &H5 Then
            Instruction$ = "CLI"
        ElseIf HiNibble = &H6 Then
            Instruction$ = "PLA"
        ElseIf HiNibble = &H7 Then
            Instruction$ = "SEI"
        ElseIf HiNibble = &H8 Then
            Instruction$ = "DEY"
        ElseIf HiNibble = &H9 Then
            Instruction$ = "TYA"
        ElseIf HiNibble = &HA Then
            Instruction$ = "TAY"
        ElseIf HiNibble = &HB Then
            Instruction$ = "CLV"
        ElseIf HiNibble = &HC Then
            Instruction$ = "INY"
        ElseIf HiNibble = &HD Then
            Instruction$ = "CLD"
        ElseIf HiNibble = &HE Then
            Instruction$ = "INX"
        ElseIf HiNibble = &HF Then
            Instruction$ = "SED"
        EndIf
    ElseIf LoNibble = &HA AND HiNibble > &H7 Then
        Address$ = "i"
        If HiNibble = &H8 Then
            Instruction$ = "TXA"
        ElseIf HiNibble = &H9 Then
            Instruction$ = "TXS"
        ElseIf HiNibble = &HA Then
            Instruction$ = "TAX"
        ElseIf HiNibble = &HB Then
            Instruction$ = "TSX"
        ElseIf HiNibble = &HC Then
            Instruction$ = "DEX"
        ElseIf HiNibble = &HE Then
            Instruction$ = "NOP"
        EndIf
    EndIf
End Sub

Sub GetAddress
    If Address$ = "#" Then
        MemoryAddress = ProgramCounter
        ProgramCounter = ProgramCounter + 1
    ElseIf Address$ = "a" Then
        MemoryAddress = ReadAddress(ProgramCounter)
        ProgramCounter = ProgramCounter + 2
    ElseIf Address$ = "zp" Then
        MemoryAddress = ReadMemory(ProgramCounter)
        ProgramCounter = ProgramCounter + 1
    ElseIf Address$ = "r" Then
        MemoryAddress = ReadMemory(ProgramCounter)
        ProgramCounter = ProgramCounter + 1
        If MemoryAddress AND &H80 > 0 Then
            MemoryAddress = MemoryAddress + &HFF00
        EndIf
    ElseIf Address$ = "(a)" Then
        MemoryAddress = ReadAddress(ProgramCounter)
        MemoryAddress = ReadAddress(MemoryAddress)
    ElseIf Address$ = "a,x" Then
        MemoryAddress = ReadAddress(ProgramCounter)+RegisterX
        ProgramCounter = ProgramCounter + 2
    ElseIf Address$ = "a,y" Then
        MemoryAddress = ReadAddress(ProgramCounter)+RegisterY
        ProgramCounter = ProgramCounter + 2
    ElseIf Address$ = "zp,x" Then
        MemoryAddress = NoCarry(ReadMemory(ProgramCounter)+RegisterX)
        ProgramCounter = ProgramCOunter + 1
    ElseIf Address$ = "zp,y" Then
        MemoryAddress = NoCarry(ReadMemory(ProgramCounter)+RegisterY)
        ProgramCounter = ProgramCounter + 1
    ElseIf Address$ = "(zp,x)" Then
        MemoryAddress = NoCarry(ReadMemory(ProgramCounter)+RegisterX)
        ProgramCounter = ProgramCounter + 1
        MemoryAddress = ReadAddress(MemoryAddress)
    ElseIf Address$ = "(zp),y" Then
        MemoryAddress = PageWrapAdd(ReadMemory(ProgramCounter),1)
        ProgramCounter = ProgramCounter + 1
        MemoryAddress = ReadAddress(MemoryAddress)+RegisterY
        MemoryAddress = PageWrapAdd(MemoryAddress,RegisterY)
    EndIf
End Sub

Sub GetNumber
    If Address$ = "A" Then
        Magic = Accumulator
    Else
        Magic = ReadMemory(MemoryAddress)
    EndIf
End Sub

Sub Execute
    Result = Magic
    If Instruction$ = "ADC" Then
        Result = Accumulator + Magic + ReadStatus("Carry")
        TestCarry(Result)
        TestZero(Result)
        TestNegative(Result)
        TestOverflow(Accumulator,Magic)
        Accumulator = NoCarry(Result)
    ElseIf Instruction$ = "AND" Then
        Result = Accumulator AND Magic
        TestZero(Result)
        TestNegative(Result)
        Accumulator = NoCarry(Result)
    ElseIf Instruction$ = "ASL" Then
        Result = Magic * &B10
        TestCarry(Result)
        TestZero(Result)
        TestNegative(Result)
        SaveNumber(Result)
    ElseIf Instruction$ = "BCC" Then
        If ReadStatus("Carry") = 0 Then
            ProgramCounter = ProgramCounter + MemoryAddress
        EndIf
    ElseIf Instruction$ = "BCS" Then
        If ReadStatus("Carry") = 1 Then
            ProgramCounter = ProgramCounter + MemoryAddress
        EndIf
    ElseIf Instruction$ = "BEQ" Then
        If ReadStatus("Zero") = 1 Then
            ProgramCounter = ProgramCounter + MemoryAddress
        EndIf
    ElseIf Instruction$ = "BIT" Then
        Result = Magic AND Accumulator
        TestZero(Result)
        WriteStatus("Overflow",Result And &B100000)
        WriteStatus("Negative",Result And &B1000000)
    ElseIf Instruction$ = "BMI" Then
        If ReadStatus("Negative") = 1 Then
            ProgramCounter = ProgramCounter + MemoryAddress
        EndIf
    ElseIf Instruction$ = "BNE" Then
        If ReadStatus("Zero") = 0 Then
            ProgramCounter = ProgramCounter + MemoryAddress
        EndIf
    ElseIf Instruction$ = "BPL" Then
        If ReadStatus("Negative") = 0 Then
            ProgramCounter = ProgramCounter + MemoryAddress
        EndIf
    ElseIf Instruction$ = "BRK" Then
        HiByte = Fix(ProgramCounter/&H100)
        LoByte = ProgramCounter AND &HFF
        PushStack(HiByte)
        PushStack(LoByte)
        PushStack(StatusRegister)
        ProgramCounter = ReadAddress(BreakRequest)
        WriteStatus("Break",1)
    ElseIf Instruction$ = "BVC" Then
        If ReadStatus("Overflow") = 0 Then
            ProgramCounter = ProgramCounter + MemoryAddress
        EndIf
    ElseIf Instruction$ = "BVS" Then
        If ReadStatus("Overflow") = 1 Then
            ProgramCounter = ProgramCounter + MemoryAddress
        EndIf
    ElseIf Instruction$ = "CLC" Then
        WriteStatus("Carry",0)
    ElseIf Instruction$ = "CLD" Then
        WriteStatus("Decimal",0)
    ElseIf Instruction$ = "CLI" Then
        WriteStatus("Interrupt",0)
    ElseIf Instruction$ = "CLV" Then
        WriteStatus("Overflow",0)
    ElseIf Instruction$ = "CMP" Then
        Result = NoCarry(Accumulator+(Magic XOR &HFF))
        If Accumulator >= Magic Then
            WriteStatus("Carry",1)
        Else
            WriteStatus("Carry",0)
        EndIf
        If Accumulator = Magic Then
            WriteStatus("Zero",1)
        Else
            WriteStatus("Zero",0)
        EndIf
        TestNegative(Result)
    ElseIf Instruction$ = "CPX" Then
        Result = NoCarry(RegisterX-Magic)
        If RegisterX >= Magic Then
            WriteStatus("Carry",1)
        Else
            WriteStatus("Carry",0)
        EndIf
        If RegisterX = Magic Then
            WriteStatus("Zero",1)
        Else
            WriteStatus("Zero",0)
        EndIf
        TestNegative(Result)
    ElseIf Instruction$ = "CPY" Then
        Result = NoCarry(RegisterY-Magic)
        If RegisterY >= Magic Then
            WriteStatus("Carry",1)
        Else
            WriteStatus("Carry",0)
        EndIf
        If RegisterY = Magic Then
            WriteStatus("Zero",1)
        Else
            WriteStatus("Zero",0)
        EndIf
        TestNegative(Result)
    ElseIf Instruction$ = "DEC" Then
        Result = NoCarry(Magic + OneMinus)
        TestZero(Result)
        TestNegative(Result)
        SaveNumber(result)
    ElseIf Instruction$ = "DEX" Then
        Magic = RegisterX
        Result = NoCarry(Magic + OneMinus)
        TestZero(Result)
        TestNegative(Result)
        RegisterX = Result
    ElseIf Instruction$ = "DEY" Then
        Magic = RegisterY
        Result = NoCarry(Magic + OneMinus)
        TestZero(Result)
        TestNegative(Result)
        RegisterX = Result
    ElseIf Instruction$ = "EOR" Then
        Result = Accumulator XOR Magic
        TestZero(Result)
        TestNegative(Result)
        Accumulator = Result
    ElseIf Instruction$ = "INC" Then
        Result = NoCarry(Magic + 1)
        TestZero(Result)
        TestNegative(Result)
        SaveNumber(Result)
    ElseIf Instruction$ = "INX" Then
        Magic = RegisterX
        Result = NoCarry(Magic + 1)
        TestZero(Result)
        TestNegative(Result)
        RegisterX = Result
    ElseIf Instruction$ = "INY" Then
        Magic = RegisterY
        Result = NoCarry(Magic + 1)
        TestZero(Result)
        TestNegative(Result)
        RegisterX = Result
    ElseIf Instruction$ = "JMP" Then
        ProgramCounter = MemoryAddress
    ElseIf Instruction$ = "JSR" Then
        HiByte = Fix((ProgramCounter-1)/&H100)
        LoByte = (ProgramCounter-1) AND &HFF
        PushStack(HiByte)
        PushStack(LoByte)
        ProgramCounter = MemoryAddress
    ElseIf Instruction$ = "LDA" Then
        TestZero(Magic)
        TestNegative(Magic)
        Accumulator = Magic
    ElseIf Instruction$ = "LDX" Then
        TestZero(Magic)
        TestNegative(Magic)
        RegisterX = Magic
    ElseIf Instruction$ = "LDY" Then
        TestZero(Magic)
        TestNegative(Magic)
        RegisterY = Magic
    ElseIf Instruction$ = "LSR" Then
        Result = Fix(Magic/2)
        If Magic AND 1 = 1 Then
            WriteStatus("Carry",1)
        Else
            WriteStatus("Carry",0)
        EndIf
        TestZero(Result)
        TestNegative(Result)
        SaveNumber(Result)
    ElseIf Instruction$ = "NOP" Then
        Do While 1 < 0
        Loop
    ElseIf Instruction$ = "ORA" Then
        Result = Accumulator OR Magic
        TestZero(Result)
        TestNegative(Result)
        Accumulator = Result
    ElseIf Instruction$ = "PHA" Then
        PushStack(Accumulator)
    ElseIf Instruction$ = "PHP" Then
        WriteStatus("Break",1)
        PushStack(StatusRegister)
    ElseIf Instruction$ = "PLA" Then
        Accumulator = PullStack()
        TestZero(Accumulator)
        TestNegative(Accumulator)
    ElseIf Instruction$ = "PLP" Then
        StatusRegister = PullStack()
        WriteStatus("Constant",1)
    ElseIf Instruction$ = "ROL" Then
        Result = (Magic*2) + ReadStatus("Carry")
        TestCarry(Result)
        TestNegative(Result)
        TestSign(result)
        SaveNumber(Result)
    ElseIf Instruction$ = "ROR" Then
        Result = Fix(Magic/2) + ReadStatus("Carry")
        TestCarry(Result)
        TestNegative(Result)
        TestSign(result)
        SaveNumber(Result)
    ElseIf Instruction$ = "RTI" Then
        StatusRegister = PullStack()
        LoByte = PullStack()
        HiByte = PullStack()
        ProgramCounter = (HiByte*&H100)+LoByte
    ElseIf Instruction$ = "RTS" Then
        LoByte = PullStack()
        HiByte = PullStack()
        ProgramCounter = (HiByte*&H100)+LoByte+1
    ElseIf Instruction$ = "SBC" Then
        Result = (Magic XOR &HFF)+Accumulator+ReadStatus("Carry")
        TestCarry(Result)
        TestNegative(Result)
        TestNegative(Result)
        TestOverflow(Magic,Accumulator)
        Accumulator = NoCarry(Result)
    ElseIf Instruction$ = "SEC" Then
        WriteStatus("Carry",1)
    ElseIf Instruction$ = "SED" Then
        WriteStatus("Decimal",1)
    ElseIf Instruction$ = "SEI" Then
        WriteStatus("Interrupt",1)
    ElseIf Instruction$ = "STA" Then
        SaveNumber(Accumulator)
    ElseIf Instruction$ = "STX" Then
        SaveNumber(RegisterX)
    ElseIf Instruction$ = "STY" Then
        SaveNumber(RegisterY)
    ElseIf Instruction$ = "TAX" Then
        RegisterX = Accumulator
        TestZero(RegisterX)
        TestNegative(RegisterX)
    ElseIf Instruction$ = "TAY" Then
        RegisterY = Accumulator
        TestZero(RegisterY)
        TestNegative(RegisterY)
    ElseIf Instruction$ = "TSX" Then
        RegisterX = StackPointer
        TestZero(RegisterX)
        TestNegative(RegisterY)
    ElseIf Instruction$ = "TXA" Then
        Accumulator = RegisterX
        TestZero(Accumulator)
        TestNegative(Accumulator)
    ElseIf Instruction$ = "TXS" Then
        StackPointer = RegisterX
    ElseIf Instruction$ = "TYA" Then
        Accumulator = RegisterY
        TestZero(Accumulator)
        TestNegative(Accumulator)
    EndIf
End Sub

Sub SaveNumber(Value)
    If Address$ = "A" Then
        Accumulator = NoCarry(Value)
    Else
        WriteMemory(MemoryAddress,NoCarry(Value))
    EndIf
End Sub

Sub TestZero(Value)
    If NoCarry(Value) = 0 Then
        WriteStatus("Zero",1)
    Else
        WriteStatus("Zero",0)
    EndIf
End Sub

Sub TestNegative(Value)
    If Value AND &H80 > 0 Then
        WriteStatus("Negative",1)
    Else
        WriteStatus("Negative",0)
    EndIf
End Sub

Sub TestCarry(Value)
    If Value AND &HFF00 > 0 Then
        WriteStatus("Carry",1)
    Else
        WriteStatus("Carry",0)
    EndIf
End Sub

Sub TestOverflow(Value1,Value2)
    WriteStatus("Overflow",0)
    Bit = (Value1 AND &H80) AND (Value2 AND &H80)/&H80
    If Bit = 1 Then
        If Bit <> (ReadStatus("Carry") Then
            WriteStatus("Overflow",1)
        EndIf
    EndIf
End Sub

Sub PushStack(Value)
    WriteMemory(StackAddress+StackPointer,Value)
    StackPointer = NoCarry(StackPointer+OneMinus)
End Sub

Function PullStack()
    PullStack = ReadMemory(StackAddress+StackPointer)
    StackPointer = StackPointer + 1
End Function

Function NoCarry(Value3)
    NoCarry = Value3 And &HFF
End Function

Function ReadAddress(Address)
    LoByte = ReadMemory(Address)
    HiByte = ReadMemory(PageWrapAdd(Address,1))
    ReadAddress = (HiByte*&H100)+LoByte
    DebugMsg(Hex$(ReadAddress))
End Function

Function PageWrapAdd(Value,incr)
    LoByte2 = NoCarry(Value+incr)
    HiByte2 = (Value AND &HFF00)
    PageWrapAdd = LoByte2 + HiByte2
End Function

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

Sub WriteStatus(Flag$,status)
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
    If status = 0 Then
        StatusRegister = StatusRegister AND (255-Mask)
    Else
        StatusRegister = StatusRegister OR Mask
    EndIf
End Sub

Function ReadMemory(Address)
    Seek #3, Address + 1
    ReadMemory = Asc(Input$(1,#3))
End Function

Sub WriteMemory(Address,Value)
    Seek #3, Address + 1
    Print #3, Chr$(NoCarry(Value));
End Sub

Sub StatusDisplay
    Print Chr$(&H1B)+"[1;1H";
    Print "Negative: ";
    Print ReadStatus("Negative");
    Print " Overflow: ";
    Print ReadStatus("Overflow");
    Print " Break: ";
    Print ReadStatus("Break");
    Print " Decimal: ";
    Print ReadStatus("Decimal");
    Print " Interrupt: ";
    Print ReadStatus("Interrupt");
    Print " Zero: ";
    Print ReadStatus("Zero");
    Print " Carry: ";
    Print ReadStatus("Carry")
    Print "Instruction: "+Instruction$+" "+Address$+Space$(8)
    Print "Memory Address: "+Padding$(Hex$(MemoryAddress),4)+Space$(8)
    Print "Data: "+Padding$(Hex$(NoCarry(Result)),4)+Space$(8)
    Print "Program Counter: "+Padding$(Hex$(ProgramCounter),4)+Space$(8)
    Print "Stack Pointer: "+Padding$(Hex$(StackPointer),2)+Space$(8)
    Print "Accumulator: "+Padding$(Hex$(Accumulator),2)+Space$(8)
    Print "Register X: "+Padding$(Hex$(RegisterX),2)+Space$(8)
    Print "Register Y: "+Padding$(Hex$(RegisterY),2)+Space$(8)
End Sub

Sub FileOutput
    Open "6502OUT.TXT" For Append As #5
    Print #5, "Negative: ";
    Print #5, ReadStatus("Negative");
    Print #5, " Overflow: ";
    Print #5, ReadStatus("Overflow");
    Print #5, " Break: ";
    Print #5, ReadStatus("Break");
    Print #5, " Decimal: ";
    Print #5, ReadStatus("Decimal");
    Print #5, " Interrupt: ";
    Print #5, ReadStatus("Interrupt");
    Print #5, " Zero: ";
    Print #5, ReadStatus("Zero");
    Print #5, " Carry: ";
    Print #5, ReadStatus("Carry")
    Print #5, "Instruction: "+Instruction$+" "+Address$
    Print #5, "Memory Address: "+Padding$(Hex$(MemoryAddress),4)
    Print #5, "Data: "+Padding$(Hex$(NoCarry(Result)),2)
    Print #5, "Program Counter: "+Padding$(Hex$(ProgramCounter),4)
    Print #5, "Stack Pointer: "+Padding$(Hex$(StackPointer),2)
    Print #5, "Accumulator: "+Padding$(Hex$(Accumulator),2)
    Print #5, "Register X: "+Padding$(Hex$(RegisterX),2)
    Print #5, "Register Y: "+Padding$(Hex$(RegisterY),2)
    Print #5, ""
    Close #5
End Sub

Function Padding$(InString$,Numbers)
    If Len(InString$) < Numbers Then
        Padding$ = String$(Numbers-Len(InString$),"0")+InString$
    Else
        Padding$ = InString$
    EndIf
End Function

Test