' demonstration program
' send 2 lines to the LCD
InitLCD
PrintLCD 1, "  Hello  World"
PrintLCD 2, "  Maximite LCD"



'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' LCD driver for MMBasic 3.1 or later (uses defined subroutines)
' Geoff Graham, Jan 2012
'
' Will drive a standard 16 x 2 LCDs
' For example:  futurlec.com       LCD16X2
'               altronics.com.au   Z7001
'               jaycar.com.au      QP5512
'
' To use:
'  - Setup the LCD with the command:    InitLCD
'  - Display a line using the command:  PrintLCD LineNbr, Text$
'
' See documentation (LCD.PDF) for the schematic
' Maximite pin 11 is RS, pin 12 is EN
' pins 13 to 16 are D4 to D7
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Initialise the LCD
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub InitLCD
  For i = 11 To 16 : SetPin i, 9 : Next i  ' all open collector
  LCD_Nibble &B0011, 0, 5                  ' reset
  LCD_Nibble &B0011, 0, 5                  ' reset
  LCD_Nibble &B0011, 0, 5                  ' reset
  LCD_Nibble &B0010, 0, 2                  ' 4 bit mode
  LCD_Nibble &B0010 : LCD_Nibble &B1100    ' 4 bits, 2 lines
  LCD_Nibble &B0000 : LCD_Nibble &B1100    ' display on, no cursor
  LCD_Nibble &B0000 : LCD_Nibble &B0110    ' increment on write
  LCD_Nibble &B0000 : LCD_Nibble &B0001    ' clear the display
  Pause 2
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Display a line on the LCD
' argument #1 is the line to be used (1 or 2)
' argument #2 is the line to display (can be any length)
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub PrintLCD ( LineNumber, Line$ )
  Local i, c

  ' first send the cursor position (in two nibbles)
  LCD_Nibble &B1000 + (LineNumber - 1) * 4 : LCD_Nibble 0

  ' then send the text character by character (two nibbles per character)
  For i = 1 To 16
    c = Asc(Mid$(Line$ + Space$(16), i, 1))
    LCD_Nibble Int(c/16), 1 : LCD_Nibble c, 1
  Next i
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Send the lower 4 bits (called a nibble) to the LCD
' argument #1 is the nibble to send
' argument #2 is true if data, false if command (default is command)
' argument #3 is delay after the data has been sent (default is zero)
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub LCD_Nibble ( Data, Flag, Wait_mSec )
  Pin(11) = Flag
  Pin(13) = Data And &B00000001
  Pin(14) = Data And &B00000010
  Pin(15) = Data And &B00000100
  Pin(16) = Data And &B00001000
  Pin(12) = 1 : Pin(12) = 0
  Pause Wait_mSec
End Sub

