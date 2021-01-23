' setup the SPI ports for this chip
MCPSetup 1, 2, 3, 4

' demonstration of ramping from one end of the pot to the other
For i = 0 To 100
  MCPSet 0, i
  Pause 100
Next i


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' driver for the Microchip MCP4xxx series of digital potentiometers
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

' initialise the SPI interface
Sub MCPSetup(mosi, miso, clk, ce)
  _mosi = mosi
  _miso = miso
  _clk = clk
  _ce = ce
  SetPin _mosi, 8                 ' set MOSI pin as an output
  SetPin _miso, 2                 ' set MISO pin as a digital input
  Pin(_clk) = 1 : SetPin _clk, 8  ' set CLK pin high then set it as an output
  Pin(_ce) = 1 : SetPin _ce, 8    ' set CE pin high then set it as an output
End Sub


' set the potentiometer to a percentage of full scale
' pot = 0   set potentiometer 0
' pot = 1   set potentiometer 1 (not on all chips)
' pot = 2   the default power up setting for potentiometer 0
' pot = 3   the default power up setting for potentiometer 1
Sub MCPSet(pot, percent)
  Local junk, r, v
  r = pot * (2 ^ 14)              ' the bits to select the correct register
  v = (256 * percent) \ 100       ' the bits to set the pot
  If percent = 100 Then v = &H100 ' full scale
  Pin(_ce) = 0                    ' select the slave
  junk = SPI(_miso, _mosi, _clk, r + v, m, 3, 16)
  If pot > 1 Then                 ' if we are setting the eeprom
    Pin(_ce) = 1                  ' deselect
    Pause 15                      ' wait for the write
    Pin(_ce) = 0                  ' reselect
  EndIf
  If (SPI(_miso, _mosi, _clk, r + &HC00, m, 3, 16) And &H1FF) <> v Then
    Error "Device not responding"
  EndIf
  Pin(_ce) = 1                    ' deselect the slave
End Sub
