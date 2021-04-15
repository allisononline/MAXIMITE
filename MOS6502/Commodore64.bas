#Include "Soft6502.inc"

Sub LoadC64
    BASICAddress = &HA000
    CharacterAddress = &HD000
    KernelAddress = &HE000
    LoadProgram("COMBASIC.BIN",BASICAddress)
    LoadProgram("CHARS.BIN",CharacterAddress)
    LoadProgram("KERNAL.BIN",KernelAddress)
End Sub