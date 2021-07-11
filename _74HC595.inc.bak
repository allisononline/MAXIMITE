Sub _74hc595Init(pinClear,pinClock,pinLatch,pinEnable,pinSerial,shiftArray())
    shiftArray(0) = pinClear
    shiftArray(1) = pinClock
    shiftArray(2) = pinLatch
    shiftArray(3) = pinEnable
    shiftArray(4) = pinSerial
    SetPin shiftArray(0),DOUT: Pin(shiftArray(0)) = 1
    SetPin shiftArray(1),DOUT: Pin(shiftArray(1)) = 0
    SetPin shiftArray(2),DOUT: Pin(shiftArray(2)) = 0
    SetPin shiftArray(3),DOUT: Pin(shiftArray(3)) = 1
    SetPin shiftArray(4),DOUT: Pin(shiftArray(4)) = 0
End Sub

Sub _74hc595Enable(shiftArray2())
    Pin(shiftArray2(3)) = 0
End Sub

Sub _74hc595Disable(shiftArray3())
    Pin(shiftArray3(3)) = 1
End Sub

Sub _74hc595Output(shiftArray4(),number,bytes)
    Pin(shiftArray4(1)) = 1
    Pin(shiftArray4(2)) = 0
    _74hc595Disable(shiftArray4())
    If bytes = 0 Then
        bytes = 8
    EndIf
    For _74Count = 0 To bytes-1
        Pin(shiftArray4(4)) = (number >> _74Count) And 1
        Pulse shiftArray4(1),0.2
        Pulse shiftArray4(2),0.2
        Pause 0.4
    Next
    _74hc595Enable(shiftArray4())
End Sub

Sub _74hc595Clear(shiftArray5())
    Pulse shiftArray5(0),0.2
    Pulse shiftArray5(1),0.2
    Pause 0.4
End Sub
