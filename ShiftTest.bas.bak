#INCLUDE "ShiftInOut.inc"

SetPin 3,DOUT: Pin(3) = 1       'Shift Out Clear
SetPin 5,DOUT: Pin(5) = 0       'Shift Out Latch
SetPin 7,DOUT: Pin(7) = 1       'Shift Out Output
SetPin 11,DOUT: Pin(11) = 1     'Shift In Shift/Load
SetPin 13,DOUT: Pin(13) = 0     'Shift In Inhibit
SetPin 27,DOUT: Pin(27) = 1     'Port Direction
SetPin 29,DOUT: Pin(29) = 0     'Port Enable

For i = 0 To 255
    Pin(5) = 0
    Pin(7) = 1
    ShiftOut(1,i)
    Pulse 5,0.4
    Pause 0.4
    Pin(7) = 0
    Pulse 11,0.4
    Pause 0.4
    Pin(29) = 1
    Print Bin$(ShiftIn(2),8)
    Pin(29) = 0
    Pause 24
Next
