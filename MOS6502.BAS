Accumulator = 0
RegisterX = 0
RegisterY = 0
ProgramCounter = 0
StackPointer = 0
StatusRegister = 0

NegativeFlag = 0
OverflowFlag = 0
BreakFlag = 0
DecimalFlag = 0
InterruptFlag = 0
ZeroFlag = 0
CarryFlag = 0

StackAddress = &H0100
NonMaskInterrupt = &HFFFA
PowerOnReset = &HFFFC
BreakRequest = &HFFFE

Instruction$ = "   "
AddressType$ = "   "

Sub Initialise
    Open "M6502MEM.BIN" For Random As #3
    StackPointer = &HFF
    ProgramCounter = PowerOnReset
    ProgramCounter = GetByte("a")
End Sub

Sub Cycle
    CodeNumber = ReadMemory(ProgramCounter)
    Decode(CodeNumber)
    Execute
End Sub

Sub Decode(OpCode)
    Group = OpCode AND &B11
    AddressType = (OpCode AND &B11100)/&B100
    Instruction = (OpCode AND &B11100000)/&B100000
    If Group = &B01 Then
        If Instruction = &B000 Then
            Instruction$ = "ORA"
        ElseIf Instruction = &B001 Then
               Instruction$ = "AND"
        ElseIf Instruction = &B010 Then
               Instruction$ = "EOR"
        ElseIf Instruction = &B011 Then
               Instruction$ = "ADC"
        ElseIf Instruction = &B100 Then
               Instruction$ = "STA"
        ElseIf Instruction = &B101 Then
               Instruction$ = "LDA"
        ElseIf Instruction = &B110 Then
               Instruction$ = "CMP"
        ElseIf Instruction = &B111 Then
               Instruction$ = "SBC"
        EndIf
        If AddressType = &B000 Then
            AddressType$ = "(zp,x)"
        ElseIf AddressType = &B001 Then
            AddressType$ = "zp"
        ElseIf AddressType = &B010 Then
            AddressType$ = "#"
        ElseIf AddressType = &B011 Then
            AddressType$ = "a"
        ElseIf AddressType = &B100 Then
            AddressType$ = "(zp),y"
        ElseIf AddressType = &B101 Then
            AddressType$ = "zp,x"
        ElseIf AddressType = &B110 Then
            AddressType$ = "a,y"
        ElseIf AddressType = &B001 Then
            AddressType$ = "a,x"
        EndIf
    ElseIf Group = &B10 Then
        If Instruction = &B000 Then
               Instruction$ = "ASL"
        ElseIf Instruction = &B001 Then
               Instruction$ = "ROL"
        ElseIf Instruction = &B010 Then
               Instruction$ = "LSR"
        ElseIf Instruction = &B011 Then
               Instruction$ = "ROR"
        ElseIf Instruction = &B100 Then
               Instruction$ = "STX"
        ElseIf Instruction = &B101 Then
               Instruction$ = "LDX"
        ElseIf Instruction = &B110 Then
               Instruction$ = "DEC"
        ElseIf Instruction = &B111 Then
               Instruction$ = "INC"
        EndIf
        If AddressType = &B000 Then
            AddressType$ = "#"
        ElseIf AddressType = &B001 Then
            AddressType$ = "zp"
        ElseIf AddressType = &B010 Then
            AddressType$ = "A"
        ElseIf AddressType = &B011 Then
            AddressType$ = "a"
        ElseIf AddressType = &B101 Then
            AddressType$ = "zp,x"
        ElseIf AddressType = &B111 Then
            AddressType$ = "a,x"
        EndIf
    ElseIf Group = &B00 Then
        If Instruction = &B001 Then
            Instruction$ = "BIT"
        ElseIf Instruction = &B010 THen
            Instruction$ = "JMP"
        ElseIf Instruction = &B011 THen
            Instruction$ = "JMP"
        ElseIf Instruction = &B100 THen
            Instruction$ = "STY"
        ElseIf Instruction = &B101 THen
            Instruction$ = "LDY"
        ElseIf Instruction = &B110 THen
            Instruction$ = "CPY"
        ElseIf Instruction = &B111 THen
            Instruction$ = "CPX"
        EndIf
        If AddressType = &B000 Then
            AddressType$ = "#"
        ElseIf AddressType = &B001 Then
            AddressType$ = "zp"
        ElseIf AddressType = &B011 Then
            AddressType$ = "a"
        ElseIf AddressType = &B101 Then
            AddressType$ = "zp,x"
        ElseIf AddressType = &B111 Then
            AddressType$ = "a,x"
        EndIf
    EndIf
End Sub

Sub Execute
    Byte = GetByte(AddressType$)
    If Instruction$ = "ADC" Then
        AddAccumulatorCarry
    ElseIf Instruction$ = "AND" Then
        AndLogical
    ElseIf Instruction$ = "ASL" Then
        Byte = ArithmShiftLeft
        If AddressType$ = "A" Then
            Accumulator = Byte
        Else
            WriteMemory(MemoryAddress,Byte)
        EndIf
    ElseIf Instruction$ = "BCC" Then
        BranchCarryClear
    ElseIf Instruction$ = "BCS" Then
        BranchCarrySet
    ElseIf Instruction$ = "BEQ" Then
        BranchEqual
    ElseIf Instruction$ = "BIT" Then
        BitTest
    ElseIf Instruction$ = "BMI" Then
        BranchMinus
    ElseIf Instruction$ = "BNE" Then
        BranchNotEqual
    ElseIf Instruction$ = "BPL" Then
        BranchPositive
    ElseIf Instruction$ = "BRK" Then
        BreakInterrupt
    ElseIf Instruction$ = "BVC" Then
        BranchOverClear
    ElseIf Instruction$ = "BVS" Then
        BranchOverSet
    ElseIf Instruction$ = "CLC" Then
        ClearCarry
    ElseIf Instruction$ = "CLD" Then
        ClearDecimal
    ElseIf Instruction$ = "CLI" Then
        ClearInterrupt
    ElseIf Instruction$ = "CLV" Then
        ClearOverflow
    ElseIf Instruction$ = "CMP" Then
        CompareAccum
    ElseIf Instruction$ = "CPX" Then
        CompareX
    ElseIf Instruction$ = "CPY" Then
        CompareY
    ElseIf Instruction$ = "DEC" Then
        DecrementMem(MemoryAddress)
    ElseIf Instruction$ = "DEX" Then
        DecrementX
    ElseIf Instruction$ = "DEY" Then
        DecrementY
    ElseIf Instruction$ = "EOR" Then
        ExclusiveOr
    ElseIf Instruction$ = "INC" Then
        IncrementMem(MemoryAddress)
    ElseIf Instruction$ = "INX" Then
        IncrementX
    ElseIf Instruction$ = "INY" Then
        IncrementY
    ElseIf Instruction$ = "JMP" Then
        Jump
    ElseIf Instruction$ = "JSR" Then
        JumpSubRoutine
    ElseIf Instruction$ = "LDA" Then
        LoadAccumulator
    ElseIf Instruction$ = "LDX" Then
        LoadXRegister
    ElseIf Instruction$ = "LDY" Then
        LoadYRegister
    ElseIf Instruction$ = "LSR" Then
        LogicalShiftRight
    ElseIf Instruction$ = "NOP" Then
        NoOperation
    ElseIf Instruction$ = "ORA" Then
        InclusiveOr
    ElseIf Instruction$ = "PHA" Then
        PushAccumulator
    ElseIf Instruction$ = "PHP" Then
        PushStatus
    ElseIf Instruction$ = "PLA" Then
        PullAccumulator
    ElseIf Instruction$ = "PLP" Then
        PullStatus
    ElseIf Instruction$ = "ROL" Then
        Byte = RotateLeft
        If AddressType$ = "A" Then
            Accumulator = Byte
        Else
            WriteMemory(MemoryAddress,Byte)
        EndIf
    ElseIf Instruction$ = "ROR" Then
        Byte = RotateRight
        If AddressType$ = "A" Then
            Accumulator = Byte
        Else
            WriteMemory(MemoryAddress,Byte)
        EndIf
    ElseIf Instruction$ = "RTI" Then
        ReturnFromInterrupt
    ElseIf Instruction$ = "RTS" Then
        ReturnFromSubroutine
    ElseIf Instruction$ = "SBC" Then
        SubtractCarry
    ElseIf Instruction$ = "SEC" Then
        SetCarry
    ElseIf Instruction$ = "SED" Then
        SetDecimal
    ElseIf Instruction$ = "SEI" Then
        SetInterrupt
    ElseIf Instruction$ = "STA" Then
        StoreAccumulator(MemoryAddress)
    ElseIf Instruction$ = "STX" Then
        StoreX(MemoryAddress)
    ElseIf Instruction$ = "STY" Then
        StoreY(MemoryAddress)
    ElseIf Instruction$ = "TAX" Then
        TransferAccumulatorX
    ElseIf Instruction$ = "TAY" Then
        TransferAccumulatorY
    ElseIf Instruction$ = "TSX" Then
        TransferStackX
    ElseIf Instruction$ = "TXA" Then
        TransferXAccumulator
    ElseIf Instruction$ = "TXS" Then
        TransferXStack
    ElseIf Instruction$ = "TYA" Then
        TransferYAccumulator
    EndIf
End Sub
        
Sub PushStack
    WriteMemory(StackAddress+StackPointer)
    StackPointer = StackPointer - 1
End Sub

Function PullStack
    PullStack = ReadMemory(StackAddress+StackPointer)
    StackPointer = StackPointer + 1
End Function

Function EightBit(Value)
    If Value < 0 Then
        Value = Value + 256
    EndIf
    EightBit = Value Mod(256)
End Function

Sub AddAccumulatorCarry
    Accumulator = Accumulator + Byte + ReadStatus("Carry")
    If Accumulator > 255 Then
        WriteStatus("Carry",1)
        WriteStatus("Overflow",1)
        Accumulator = EightBit(Accumulator)
    EndIf
    SetNumberFlags(Accumulator)
End Sub

Sub AndLogical
    Accumulator = Accumulator AND Byte
    SetNumberFlags(Accumulator)
End Sub

Function ArithmShiftLeft
    WriteStatus("Carry",(Byte AND &H80)/&H80)
    ArithmShiftLeft = (Byte*&B10) Mod(256)
End Function

Sub BranchCarryClear
    If ReadStatus("Carry") = 0 Then
        ProgramCounter = ProgramCounter + Byte
    EndIf
End Sub

Sub BranchCarrySet
    If ReadStatus("Carry") = 1 Then
        ProgramCounter = ProgramCounter + Byte
    EndIf
End Sub

Sub BranchEqual
    If ReadStatus("Zero") = 1 Then
        ProgramCounter = ProgramCounter + Byte
    EndIf
End Sub

Sub BitTest
    If Accumulator AND Byte = 0 Then
        WriteStatus("Zero",1)
    Else
        WriteStatus("Zero",0)
    EndIf
    WriteStatus("Overflow",Byte AND &B100000)
    WriteStatus("Negative",Byte AND &B1000000)
End Sub

Sub BranchMinus
    If ReadStatus("Negative") = 1 Then
        ProgramCounter = ProgramCounter + Byte
    EndIf
End Sub

Sub BranchNotEqual
    If ReadStatus("Zero") = 0 Then
        ProgramCounter = ProgramCounter + Byte
    EndIf
End Sub

Sub BranchPositive
    If ReadStatus("Negative") = 0 Then
        ProgramCounter = ProgramCounter + Byte
    EndIf
End Sub

Sub BreakInterrupt
    PushStack(ProgramCounter)
    PushStack(StatusRegister)
    HiByte = ReadMemory(&HFFFE)
    LoByte = ReadMemory(&HFFFF)
    ProgramCounter = (HiByte*&H100)+LoByte
    WriteStatus("Break",1)
End Sub

Sub BranchOverClear
    If ReadStatus("Overflow") = 0 Then
        ProgramCounter = ProgramCounter + Byte
    EndIf
End Sub

Sub BranchOverSet
    If ReadStatus("Overflow") = 1 Then
        ProgramCounter = ProgramCounter + Byte
    EndIf
End Sub

Sub ClearCarry
    WriteStatus("Carry",0)
End Sub

Sub ClearDecimal
    WriteStatus("Decimal",0)
End Sub

Sub ClearInterrupt
    WriteStatus("Interrupt",0)
End Sub

Sub ClearOverflow
    WriteStatus("Overflow",0)
End Sub

Sub CompareAccum
    If Accumulator >= Byte Then
        WriteStatus("Carry",1)
    EndIf
    If Accumulator = Byte Then
        WriteStatus("Zero")
    EndIf
    WriteStatus("Negative",(Byte AND &H80))
End Sub

Sub CompareX
    If RegisterX >= Byte Then
        WriteStatus("Carry",1)
    EndIf
    If RegisterX = Byte Then
        WriteStatus("Zero",1)
    EndIf
    WriteStatus("Negative",(Byte AND &H80))
End Sub

Sub CompareY
    If RegisterY >= Byte Then
        WriteStatus("Carry",1)
    EndIf
    If RegisterY = Byte Then
        WriteStatus("Zero",1)
    EndIf
    WriteStatus("Negative",(Byte AND &H80))
End Sub

Sub DecrementMem(Address)
    Byte = EightBit(ReadMemory(Address)-1)
    SetNumberFlags
    WriteMemory(Address,Byte)
End Sub

Sub DecrementX
    RegisterX = EightBit(RegisterX-1)
    SetNumberFlags(RegisterX)
End Sub

Sub DecrementY
    RegisterY = EightBit(RegisterY-1)
    SetNumberFlags(RegisterY)
End Sub

Sub ExclusiveOr
    Accumulator = Accumulator XOR Byte
    SetNumberFlags(Accumulator)
End Sub

Sub IncrementMem(Address)
    Byte = EightBit(ReadMemory(Address)+1)
    SetNumberFlags
    WriteMemory(Address,Byte)
End Sub

Sub IncrementX
    RegisterX = EightBit(RegisterX+1)
    SetNumberFlags(RegisterX)
End Sub

Sub IncrementY
    RegisterY = EightBit(RegisterY+1)
    SetNumberFlags(RegisterY)
End Sub

Sub Jump
    ProgramCounter = Byte
End Sub

Sub JumpSubRoutine
    PushStack(ProgramCounter+2)
    ProgramCounter = Byte
End Sub

Sub LoadAccumulator
    Accumulator = Byte
    SetNumberFlags(Accumulator)
End Sub

Sub LoadXRegister
    RegisterX = Byte
    SetNumberFlags(RegisterX)
End Sub

Sub LoadYRegister
    RegisterY = Byte
    SetNumberFlags(RegisterY)
End Sub

Function LogicalShiftRight
    WriteStatus("Carry",Byte AND 1)
    LogicalShiftRight = FIX(Byte/2)
    SetNumberFlags(LogicalShiftRight)
End Function

Sub NoOperation
    Do While 1 < 0
    Loop
End Sub

Sub InclusiveOr
    Accumulator = Accumulator OR Byte
    SetNumberFlags(Accumulator)
End Sub

Sub PushAccumulator
    PushStack(Accumulator)
End Sub

Sub PushStatus
    PushStack(StatusRegister)
End Sub

Sub PullAccumulator
    Accumulator = PullStack
End Sub

Sub PullStatus
    StatusRegister = PullStack
End Sub

Function RotateLeft
    OldBit = Byte AND &H80
    RotateLeft = EightBit(Byte*2) + ReadStatus("Carry")
    WriteStatus("Carry",OldBit)
    SetNumberFlags(RotateLeft)
End Function

Function RotateRight
    OldBit = Byte AND &H1
    RotateRight = EightBit(FIX(Byte/2)) + (ReadStatus("Carry")*&H80)
    WriteStatus("Carry",OldBit)
    SetNumberFlags(RotateRight)
End Function

Sub ReturnFromInterrupt
    StatusRegister = PullStack
    ProgramCounter = PullStack
End Sub

Sub ReturnFromSubroutine
    ProgramCounter = PullStack - 1
End Sub

Sub SubtractCarry
    Accumulator = Accumulator - Byte - (1-ReadStatus("Carry"))
    If Accumulator < 0 Then
        WriteStatus("Carry",1)
        WriteStatus("Overflow",1)
        Accumulator = EightBit(Accumulator)
    EndIf
    SetNumberFlags(Accumulator)
End Sub

Sub SetCarry
    WriteStatus("Carry",1)
End Sub

Sub SetDecimal
    WriteStatus("Decimal",1)
End Sub

Sub SetInterrupt
    WriteStatus("Interrupt",1)
End Sub

Sub StoreAccumulator(Address)
    WriteMemory(Address,Accumulator)
End Sub

Sub StoreX(Address)
    WriteMemory(Address,RegisterX)
End Sub

Sub StoreY(Address)
    WriteMemory(Address,RegisterY)
End Sub

Sub TransferAccumulatorX
    RegisterX = Accumulator
    SetNumberFlags(RegisterX)
End Sub

Sub TransferAccumulatorY
    RegisterY = Accumulator
    SetNumberFlags(RegisterY)
End Sub

Sub TransferStackX
    RegisterX = StackPointer
    SetNumberFlags(RegisterX)
End Sub

Sub TransferXAccumulator
    Accumulator = RegisterX
    SetNumberFlags(Accumulator)
End Sub

Sub TransferXStack
    StackPointer = RegisterX
End Sub

Sub TransferYAccumulator
    Accumulator = RegisterY
End Sub


Sub SetNumberFlags
    If Byte = 0 Then
        WriteStatus("Zero",1)
    EndIf
    WriteStatus("Negative",Byte AND &H80)
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
    If StatusRegister AND Mask <> 0 Then
        ReadStatus = 1
    Else
        ReadStatus = 0
    EndIf
End Function

Sub WriteStatus(Flag$,status)
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
    If status <> 0 Then
        StatusRegister = StatusRegister OR Mask
    Else
        StatusRegister = StatusRegister AND (NOT Mask)
    EndIf
End Sub

Function ReadMemory(Address)
    Seek #3, Address + 1
    ReadMemory = ASC(INPUT$(1,#3))
    ProgramCounter = ProgramCounter + 1
End Function

Sub WriteMemory(Address,Byte)
    Seek #3, Address + 1
    Print #3, CHR$;
End Sub

Function GetByte(AddressMode$)
    If AddressMode$ = "A" Then
        GetByte = Accumulator
    ElseIf AddressMode$ = "i" Then
        GetByte = 0
    ElseIf AddressMode$ = "#" Then
        GetByte = ReadMemory(ProgramCounter)
    ElseIf AddressMode$ = "a" Then
        LoByte = ReadMemory(ProgramCounter)
        HiByte = ReadMemory(ProgramCounter)
        MemoryAddress = (HiByte*&H100)+LoByte
        GetByte = ReadMemory(MemoryAddress)
    ElseIf AddressMode$ = "zp" Then
        MemoryAddress = ReadMemory(ProgramCounter)
        GetByte = ReadMemory(MemoryAddress)
    ElseIf AddressMode$ = "r" Then
        Offset = ReadMemory(ProgramCounter)
        MemoryAddress = ProgramCounter + Offset
        GetByte = ReadMemory(MemoryAddress)
    ElseIf AddressMode$ = "(a)" Then
        LoByte = ReadMemory(ProgramCounter)
        HiByte = ReadMemory(ProgramCounter)
        MemoryAddress = (HiByte*&H100)+LoByte
        GetByte = ReadMemory(MemoryAddress)
    ElseIf AddressMode$ = "a,x" Then
        LoByte = ReadMemory(ProgramCounter)
        HiByte = ReadMemory(ProgramCounter)
        MemoryAddress = (HiByte*&H100)+LoByte+RegisterX
        GetByte = ReadMemory(MemoryAddress)
    ElseIf AddressMode$ = "a,y" Then
        LoByte = ReadMemory(ProgramCounter)
        HiByte = ReadMemory(ProgramCounter)
        MemoryAddress = (HiByte*&H100)+LoByte+RegisterY
        GetByte = ReadMemory(MemoryAddress)
    ElseIf AddressMode$ = "zp,x" Then
        MemoryAddress = ReadMemory(ProgramCounter)+RegisterX
        GetByte = ReadMemory(MemoryAddress)
    ElseIf AddressMode$ = "zp,y" Then
        MemoryAddress = ReadMemory(ProgramCounter)+RegisterY
        GetByte = ReadMemory(MemoryAddress)
    ElseIf AddressMode$ = "(zp,x)"
        MemoryAddress = ReadMemory(ProgramCounter)+RegisterX
        LoByte = ReadMemory(MemoryAddress)
        HiByte = ReadMemory(MemoryAddress+1)
        MemoryAddress = (HiByte*&H100)+LoByte
        GetByte = ReadMemory(MemoryAddress)
    ElseIf AddressMode$ = "(zp),y"
        MemoryAddress = ReadMemory(ProgramCounter)
        LoByte = ReadMemory(MemoryAddress)
        HiByte = ReadMemory(MemoryAddress+1)
        MemoryAddress = (HiByte*&H100)+LoByte+RegisterY
        GetByte = ReadMemory(MemoryAddress)
    EndIf
End Function

Function PeekMemory(Address)
    Seek #3, Address + 1
    PeekMemory = ASC(INPUT$(1,#3))
End Function


Initialise
Do
    Cycle
    Print PeekMemory(&H8000)
    Pause 500
Loop