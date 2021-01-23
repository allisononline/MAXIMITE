' --- Byte-Oriented Bit Manipulation Functions Test Harness
' Program: BIN8Test.BAS
' Author:  crackerjack
' Date:   March 2012
' Requires: MMBasic 3.2, or later
' Version: 1.0
' Function: Tests BIN8.BAS - Bit Manipulation Library
' ------------------------------------------------------------------------

Clear : Cls

? "Test harness for BIN8.BAS Function library" Chr$(10)
? "Test #1: Invert function...";
' Assume Pass
Pass=1
' Test Invert Function
For b=0 to 255
  Pass=Pass And (b+Invert(b)=255)
Next b
CheckResults (255)

? "Test #2: ShiftL function...";
' Assume Pass
Pass=1
' Test ShiftL Function
For b=0 to 255
  For s=1 to 7
    Pass=Pass And Val("&b" + Bin8$(ShiftL(b,s)))=((b * 2 ^ s) And &hFF)
  Next s
Next b
CheckResults (255*7)

? "Test #3: ShiftR function...";
' Assume Pass
Pass=1
' Test ShiftR Function
For b=0 to 255
  For s=1 to 7
    Pass=Pass And Val("&b" + Bin8$(ShiftR(b,s)))=(b \ 2 ^ s)
  Next s
Next b
CheckResults (255*7)

? "Test #4: RotL -> RotR functions...";
' Assume Pass
Pass=1
' Test RotL & RotR Function's (Inverse functions)
For b=0 To 255
  For s=1 To 7
    Pass=Pass And RotL(RotR(b,s),s)=b
  Next s
Next b
CheckResults (255*7)

? "Test #5: RotR -> RotL functions...";
' Assume Pass
Pass=1
' Test RotR & RotL Function's (Inverse functions)
For b=0 To 255
  For s=1 To 7
    Pass=Pass And RotR(RotL(b,s),s)=b
  Next s
Next b
CheckResults (255*7)

? "Test #6: GetBit function...";
' Assume Pass
Pass=1
' Test GetBit Function
Pass=Pass And GetBit(&b10001000,0)=0
Pass=Pass And GetBit(&b10001000,3)=1
Pass=Pass And GetBit(&b10001000,5)=0
Pass=Pass And GetBit(&b10001000,7)=1
CheckResults (4)

? "Test #7: SetBit sub...";
' Assume Pass
Pass=1
' Test SetBit Sub
testByte=0
SetBit (testByte,0)=1
Pass=Pass And testByte=&h1
testByte=0
SetBit (testByte,3)
Pass=Pass And testByte=&h8
SetBit (testByte,5)
Pass=Pass And testByte=&h28
SetBit (testByte,7)
Pass=Pass And testByte=&hA8
CheckResults (4)

If Pass=1 Then
  ? Chr$(10) "All tests passed."
EndIf

If MM.VRes=0 Then
  Quit ' Windows/DOS Version Only, Return to O/S
EndIf

End

' --- Utility Sub's

Sub CheckResults(noOfTests)
 If Pass=1 Then
  ? noOfTests " Tests Passed"
 Else
  ? " 1 of " noOfTests " Tests Failed" : Quit
 EndIf
End Sub

' *--- Use Ctrl-F to merge BIN8.BAS here --->
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