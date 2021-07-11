Sub ShiftInit(pinClear,pinLatch,pinClock,pinOutput,pinSerial)
    SetPin pinClear, DOUT: Pin(pinClear) = 1
    SetPin pinLatch, DOUT: Pin(pinLatch) = 0
    SetPin pinClock, DOUT: Pin(pinClock) = 0
    SetPin pinEnable, DOUT: Pin(pinEnable) = 1
    SetPin pinSerial, DOUT: Pin(pinSerial) = 0
End Sub

Sub ShiftOut(pinLatch,pinClock,pinOutput,pinSerial,number)
    Pin(pinClock) = 0
    Pin(pinLatch) = 0
    Pin(pinEnable) = 1
    For i = 0 To 7
        Pin(pinSerial) = (number >> i) And 1
        Pulse pinLatch, 0.2
        Pause 0.2
        Pulse pinClock, 0.2
        Pause 0.2
    Next
    Pin(pinEnable) = 0
End Sub

Sub ShiftClear(pinClear,pinClock)
    Pin(pinClear) = 0
    Pulse pinClock, 0.2
    Pin(pinClear) = 1
End Sub
