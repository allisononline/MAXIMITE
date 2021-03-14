Debug = 1
Sub Debug(Msg$)
    If Debug = 1 Then
        Print Msg$
    EndIf
End Sub

Accumulator = 0
RegisterX = 0
RegisterY = 0
ProgramCounter = 0
StackPointer = 0
StatusRegister = 0
MemoryAddress = 0
Byte = 0

StackAddress = &H0100
NonMaskInterrupt = &HFFFA
PowerOnReset = &HFFFC
BreakRequest = &HFFFE

Instruction$ = "   "
AddressType$ = "   "

Sub Initialise
    Open "M6502MEM.BIN" For Random As #3
    StackPointer = &HFF
    ProgramCounter = 0
End Sub

Sub Cycle
    Decode(Fetch())
    GetAddress
    GetData
    Execute
    Debug(Instruction$)
End Sub

Function Fetch()
    Fetch = ReadMemory(ProgramCounter)
    ProgramCounter = ProgramCounter + 1
End Function

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

Sub GetAddress
    If AddressType$ = "a" Then
        LoByte = Fetch()
        HiByte = Fetch()
        MemoryAddress = (HiByte*&H100)+LoByte
    ElseIf AddressType$ = "zp" Then
        MemoryAddress = Fetch()
    ElseIf AddressType$ = "r" Then
        Offset = Fetch()
        MemoryAddress = ProgramCounter + Offset
    ElseIf AddressType$ = "(a)" Then
        LoByte = Fetch()
        HiByte = Fetch()
        MemoryAddress = (HiByte*&H100)+LoByte
    ElseIf AddressType$ = "a,x" Then
        LoByte = Fetch()
        HiByte = Fetch()
        MemoryAddress = (HiByte*&H100)+LoByte+RegisterX
    ElseIf AddressType$ = "a,y" Then
        LoByte = Fetch()
        HiByte = Fetch()
        MemoryAddress = (HiByte*&H100)+LoByte+RegisterY
    ElseIf AddressType$ = "zp,x" Then
        MemoryAddress = Fetch()+RegisterX
    ElseIf AddressType$ = "zp,y" Then
        MemoryAddress = Fetch()+RegisterY
    ElseIf AddressType$ = "(zp,x)" Then
        MemoryAddress = Fetch()+RegisterX
        LoByte = ReadMemory(MemoryAddress)
        HiByte = ReadMemory(MemoryAddress+1)
        MemoryAddress = (HiByte*&H100)+LoByte
    ElseIf AddressType$ = "(zp),y" Then
        MemoryAddress = Fetch()
        LoByte = ReadMemory(MemoryAddress)
        HiByte = ReadMemory(MemoryAddress+1)
        MemoryAddress = (HiByte*&H100)+LoByte+RegisterY
    EndIf
End Sub

Sub GetData
    If AddressType$ = "A" Then
        Byte = Accumulator
    ElseIf AddressType$ = "#" Then
        Byte = Fetch()
    Else
        Byte = ReadMemory(MemoryAddress)
    EndIf
End Sub

Sub Execute
    If Instruction$ = "ADC" Then
        Accumulator = Accumulator + Byte + ReadStatus("Carry")
            If Accumulator > 255 Then
            WriteStatus("Carry",1)
            WriteStatus("Overflow",1)
            Accumulator = EightBit(Accumulator)
        EndIf
        SetNumberFlags(Accumulator)
    ElseIf Instruction$ = "AND" Then
        Accumulator = Accumulator AND Byte
        SetNumberFlags(Accumulator)
    ElseIf Instruction$ = "ASL" Then
        WriteStatus("Carry",(Byte AND &H80)/&H80)
        Byte = (Byte*&B10) Mod(256)
        If AddressType$ = "A" Then
            Accumulator = Byte
        Else
            WriteMemory(MemoryAddress,Byte)
        EndIf
    ElseIf Instruction$ = "BCC" Then
        If ReadStatus("Carry") = 0 Then
            ProgramCounter = ProgramCounter + Byte
        EndIf
    ElseIf Instruction$ = "BCS" Then
        If ReadStatus("Carry") = 1 Then
            ProgramCounter = ProgramCounter + Byte
        EndIf
    ElseIf Instruction$ = "BEQ" Then
        If ReadStatus("Zero") = 1 Then
            ProgramCounter = ProgramCounter + Byte
        EndIf
    ElseIf Instruction$ = "BIT" Then
        If Accumulator AND Byte = 0 Then
            WriteStatus("Zero",1)
        Else
            WriteStatus("Zero",0)
        EndIf
        WriteStatus("Overflow",Byte AND &B100000)
        WriteStatus("Negative",Byte AND &B1000000)
    ElseIf Instruction$ = "BMI" Then
        If ReadStatus("Negative") = 1 Then
            ProgramCounter = ProgramCounter + Byte
        EndIf
    ElseIf Instruction$ = "BNE" Then
        If ReadStatus("Zero") = 0 Then
            ProgramCounter = ProgramCounter + Byte
        EndIf
    ElseIf Instruction$ = "BPL" Then
        If ReadStatus("Negative") = 0 Then
            ProgramCounter = ProgramCounter + Byte
        EndIf
    ElseIf Instruction$ = "BRK" Then
        PushStack(ProgramCounter)
        PushStack(StatusRegister)
        ProgramCounter = BreakRequest
        ProgramCounter = GetByte("a")
        WriteStatus("Break",1)
    ElseIf Instruction$ = "BVC" Then
        If ReadStatus("Overflow") = 0 Then
            ProgramCounter = ProgramCounter + Byte
        EndIf
    ElseIf Instruction$ = "BVS" Then
        If ReadStatus("Overflow") = 1 Then
            ProgramCounter = ProgramCounter + Byte
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
        If Accumulator >= Byte Then
            WriteStatus("Carry",1)
        EndIf
        If Accumulator = Byte Then
            WriteStatus("Zero")
        EndIf
        WriteStatus("Negative",(Byte AND &H80))
    ElseIf Instruction$ = "CPX" Then
        If RegisterX >= Byte Then
            WriteStatus("Carry",1)
        EndIf
        If RegisterX = Byte Then
            WriteStatus("Zero",1)
        EndIf
        WriteStatus("Negative",(Byte AND &H80))
    ElseIf Instruction$ = "CPY" Then
        If RegisterY >= Byte Then
            WriteStatus("Carry",1)
        EndIf
        If RegisterY = Byte Then
            WriteStatus("Zero",1)
        EndIf
        WriteStatus("Negative",(Byte AND &H80))
    ElseIf Instruction$ = "DEC" Then
        Byte = EightBit(Byte-1)
        SetNumberFlags(Byte)
        WriteMemory(MemoryAddress,Byte)
    ElseIf Instruction$ = "DEX" Then
        RegisterX = EightBit(RegisterX-1)
        SetNumberFlags(RegisterX)
    ElseIf Instruction$ = "DEY" Then
        RegisterY = EightBit(RegisterY-1)
        SetNumberFlags(RegisterY)
    ElseIf Instruction$ = "EOR" Then
        Accumulator = Accumulator XOR Byte
        SetNumberFlags(Accumulator)
    ElseIf Instruction$ = "INC" Then
        Byte = EightBit(Byte+1)
        SetNumberFlags(Byte)
        WriteMemory(MemoryAddress,Byte)
    ElseIf Instruction$ = "INX" Then
        RegisterX = EightBit(RegisterX+1)
        SetNumberFlags(RegisterX)
    ElseIf Instruction$ = "INY" Then
        RegisterY = EightBit(RegisterY+1)
        SetNumberFlags(RegisterY)
    ElseIf Instruction$ = "JMP" Then
        ProgramCounter = Byte
    ElseIf Instruction$ = "JSR" Then
        PushStack(ProgramCounter+2)
        ProgramCounter = Byte
    ElseIf Instruction$ = "LDA" Then
        Accumulator = Byte
        SetNumberFlags(Accumulator)
    ElseIf Instruction$ = "LDX" Then
        RegisterX = Byte
        SetNumberFlags(RegisterX)
    ElseIf Instruction$ = "LDY" Then
        RegisterY = Byte
        SetNumberFlags(RegisterY)
    ElseIf Instruction$ = "LSR" Then
        WriteStatus("Carry",Byte AND 1)
        LogicalShiftRight = FIX(Byte/2)
        SetNumberFlags(LogicalShiftRight)
    ElseIf Instruction$ = "NOP" Then
        Do While 1 < 0
        Loop
    ElseIf Instruction$ = "ORA" Then
        Accumulator = Accumulator OR Byte
        SetNumberFlags(Accumulator)
    ElseIf Instruction$ = "PHA" Then
        PushStack(Accumulator)
    ElseIf Instruction$ = "PHP" Then
        PushStack(StatusRegister)
    ElseIf Instruction$ = "PLA" Then
        Accumulator = PullStack
    ElseIf Instruction$ = "PLP" Then
        StatusRegister = PullStack
    ElseIf Instruction$ = "ROL" Then
        OldBit = Byte AND &H80
        Byte = EightBit(Byte*2) + ReadStatus("Carry")
        WriteStatus("Carry",OldBit)
        SetNumberFlags(Byte)
        If AddressType$ = "A" Then
            Accumulator = Byte
        Else
            WriteMemory(MemoryAddress,Byte)
        EndIf
    ElseIf Instruction$ = "ROR" Then
        OldBit = Byte AND &H1
        Byte = EightBit(FIX(Byte/2)) + (ReadStatus("Carry")*&H80)
        WriteStatus("Carry",OldBit)
        SetNumberFlags(Byte)
        If AddressType$ = "A" Then
            Accumulator = Byte
        Else
            WriteMemory(MemoryAddress,Byte)
        EndIf
    ElseIf Instruction$ = "RTI" Then
        StatusRegister = PullStack
        ProgramCounter = PullStack
    ElseIf Instruction$ = "RTS" Then
        ProgramCounter = PullStack - 1
    ElseIf Instruction$ = "SBC" Then
        Accumulator = Accumulator - Byte - (1-ReadStatus("Carry"))
        If Accumulator < 0 Then
            WriteStatus("Carry",1)
            WriteStatus("Overflow",1)
            Accumulator = EightBit(Accumulator)
        EndIf
        SetNumberFlags(Accumulator)
    ElseIf Instruction$ = "SEC" Then
        WriteStatus("Carry",1)
    ElseIf Instruction$ = "SED" Then
        WriteStatus("Decimal",1)
    ElseIf Instruction$ = "SEI" Then
        WriteStatus("Interrupt",1)
    ElseIf Instruction$ = "STA" Then
        WriteMemory(MemoryAddress,Accumulator)
    ElseIf Instruction$ = "STX" Then
       WriteMemory(MemoryAddress,RegisterX)
    ElseIf Instruction$ = "STY" Then
        WriteMemory(MemoryAddress,RegisterY)
    ElseIf Instruction$ = "TAX" Then
        RegisterX = Accumulator
        SetNumberFlags(RegisterX)
    ElseIf Instruction$ = "TAY" Then
        RegisterY = Accumulator
        SetNumberFlags(RegisterY)
    ElseIf Instruction$ = "TSX" Then
        RegisterX = StackPointer
        SetNumberFlags(RegisterX)
    ElseIf Instruction$ = "TXA" Then
        Accumulator = RegisterX
        SetNumberFlags(Accumulator)
    ElseIf Instruction$ = "TXS" Then
        StackPointer = RegisterX
    ElseIf Instruction$ = "TYA" Then
        Accumulator = RegisterY
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

Sub SetNumberFlags(Number)
    If Number = 0 Then
        WriteStatus("Zero",1)
    EndIf
    WriteStatus("Negative",Number AND &H80)
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
End Function

Sub WriteMemory(Address,Byte)
    Seek #3, Address + 1
    Print #3, CHR$(Byte);
End Sub

Sub StatusDisplay
    Print @(0,0)"Negative: ";
    Print ReadStatus("Negative");
    Print " Overflow: ";
    Print ReadStatus("Overflow");
    Print " Break: ";
    Print ReadStatus("Break");
    Print " Decimal: ";
    Print ReadStatus("Decimal");
    Print " Zero: ";
    Print ReadStatus("Zero");
    Print " Carry: ";
    Print ReadStatus("Carry")
    Print "Memory Address: "+Padding$(Hex$(MemoryAddress),4)+Space$(8)
    Print "Data: "+Padding$(Hex$(Byte),2)+Space$(8)
    Print "Program Counter: "+Padding$(Hex$(ProgramCounter),4)+Space$(8)
    Print "Stack Pointer: "+Padding$(Hex$(StackPointer),2)+Space$(8)
    Print "Accumulator: "+Padding$(Hex$(Accumulator),2)+Space$(8)
    Print "Register X: "+Padding$(Hex$(RegisterX),2)+Space$(8)
    Print "Register Y: "+Padding$(Hex$(RegisterY),2)+Space$(8)
End Sub

Function Padding$(InString$,Number)
    Padding$ = String$(Number-Len(InString$),"0")+InString$
End Function

Initialise
Do
    Cycle
    StatusDisplay
    Print "Address &H8000: ";
    Print ReadMemory(&H8000)
    Pause 500
Loop