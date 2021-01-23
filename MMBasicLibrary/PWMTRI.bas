' Author: Graeme Anderson
' Date:   29-Oct-2012
'
' Variable pulse width for front panel LED
' LED amplitude is a 'triangle' wave


  iSeconds = 1 ' length of the whole cycle

  Do
    iState = 1

    For y = 1 To 2
      For x = 1 To 50 * iSeconds Step iSeconds
        Pin(0) = iState ' first part of duty cycle
        Pause x / 5

        Pin(0) = Abs(iState - 1) ' reverse pin state
        Pause iSeconds * 10 - x / 5 ' hold for remainder of duty cycle
      Next

      ' revsere the logic for the second time through
      iState = Abs(iState -1)
    Next
  Loop
