' --- Byte-Oriented Bit Manipulation Functions
' Library: BIN8.BAS
' Author:  crackerjack
' Date:   March 2012
' Requires: MMBasic 3.2, or later
' Version: 1.0
' Function: Implements a number of Byte-Wide Bit
'           Manipulation Functions and Subs
' ------------------------------------------------------------------------

Function GetBit(byte_in, bit)
  ' Return the value (0/1) of a specified bit in a given byte
  CheckByte(byte_in)
  If bit < 0 Or bit > 7 Then Error "Invalid bit value"
  GetBit = (byte_in And (2 ^ bit)) > 0
End Function

Function Invert(byte_in)
  'Inverts bits in the byte
  CheckByte(byte_in)
  Invert = byte_in Xor &hFF
End Function

Function ShiftL(byte_in, shift)
  ' Logically shifts bits left by given quantity
  CheckByte(byte_in)
  If shift < 1 Or shift > 7 Then Error "Invalid shift value"
  ShiftL = ((byte_in * 2 ^ shift) And &hFF)
End Function

Function ShiftR(byte_in, shift)
  ' Logically shifts bits right by given quantity
  CheckByte(byte_in)
  If shift < 1 Or shift > 7 Then Error "Invalid shift value"
  ShiftR = (byte_in \ 2 ^ shift)
End Function

Function RotL(byte_in, rot)
  ' Rotates (circular shift) bits left by given quantity
  CheckByte(byte_in)
  If rot < 1 Or rot > 7 Then Error "Invalid rotate value"
  RotL = ((byte_in * 2 ^ rot) + ((byte_in * 2 ^ rot)\&h100)) And &hFF
End Function

Function RotR(byte_in, rot)
  ' Rotates (circular shift) bits right by given quantity
  CheckByte(byte_in)
  RotR = RotL(byte_in, (8 - rot))
End Function

' --- Byte-Oriented Bit Manipulation Subs

Sub SetBit(byte_in, bit)
  ' Sets the given bit of a given byte
  ' Note: **PassByRef** - The passed in variable's value is changed
  CheckByte(byte_in)
  If bit < 0 Or bit > 7 Then Error "Invalid bit value"
  byte_in = byte_in Or (2 ^ bit)
End Sub

' --- Utility Functions

Function Bin8$(byte_in)
 Bin8$ = Right$(String$(8,"0")+Bin$(byte_in),8)
End Function

' --- Utility Subroutines

Sub CheckByte(byte_in)
  If byte_in < 0 Or byte_in > 255 Then Error "Value not in range"
End Sub
