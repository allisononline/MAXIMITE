' Potentiometer test
' -----------------------
' Author: Graeme Anderson
' Date:   Oct-2012
' -----------------------

' GND and pin 10 are the 10k resistance  ---/\/\/\/\/\---
' pin 8 is the wiper                        ----^

  SetPin 8,1 ' analog input
  SetPin 10,8 ' digital output (used as v+)
  ' I use pin 10 as v+ as the wiring of my project is neater
  ' and I can deactivate the pot by settiing pin 10 low.

  ' Read value from pin 8 to check for any change as pin 10 is set from low to
  ' high. If a change is detected the the potentiometer is connected.
  ' Set the wiper to about midway to ensure that the program detects the pot
  Pin(10)=0 ' initial low
  For i = 1 To 10
    vValue = Pin(8) ' initial voltage value
  Next
  Pin(10)=1 ' set high (3.3v)

  If Abs(Pin(8) - vValue)>1 Then ' pot is connected (this is not foolproof!)
    ' calbration
    ' the value read can represent anything; my project treats it as milliseconds
    Print "Rotate the potentiometer to one extreme and ";
    Input "enter the minimum delay (ms)";dMin
    vMin =Pin(8)
    Print "Rotate the potentiometer to the other extreme and ";
    Input "enter the maximum delay (ms)";dMax
    vMax=Pin(8)

    Cls
    Print @(50, 80) "Delay = ";

    Do
      vValue =Pin(8)
      dValue=Cint(dMin+Abs((dmax-dmin)/(vmax-vmin))*vValue)

      If dvalue <> dPrev Then
        Print @(90, 80) dvalue;" ms  "
        Print String$(Cint(dValue*70/dMax),"#");Space$(70)
      EndIf
      dPrev = dValue
    Loop
  Else
    Print "Potentiometer was not detected"
  EndIf

