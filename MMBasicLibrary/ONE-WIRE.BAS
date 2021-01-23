GetTemp 18, Temp
Print "The temperature is:" Temp


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Subroutine to get the temperature from a Dallas DS18B20.
' The temperature is returned to the varable used for the
' second argument in the calling program
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub GetTemp (PinNbr, Value)
  Local T1, T2, b, t
  OWReset PinNbr                        ' reset
  OWWrite PinNbr, 1, 2, &hcc, &h44      ' start conversion
  Pause 100
  t = Timer
  Do
    If Timer - t > 1000 Then Error "Sensor not responding"
    OWRead PinNbr, 4 , 1 , b            ' conversion done?
  Loop Until b = 1
  OWWrite PinNbr, 1, 2, &hcc, &hbe      ' command read data
  OWRead PinNbr, 2, 2, T1, T2           ' get the data
  Value = ((T2 And &b111) * 256 + T1) / 16
  If T2 And &b1000 Then Value = -Value  ' adjust if negative
End Sub

