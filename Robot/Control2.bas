Sub controlInit
    Open "COM2:19200" As #5
    controlByte = 0
    prevByte = 0
    For j = 1 To 7
        SetPin j, 8
    Next
    Pin(1) = 1      'left-forward = 3   right-forward = 5
    Pin(2) = 1      'left-backward = 4  right-backward = 6
End Sub

Sub getControlByte
    If Loc(#5) Then
        controlByte = Asc(Input$(#5))
    Else
        controlByte = 0
    EndIf
End Sub

Sub motorControl
    If Not (controlByte And &HF) Then
        Pin(3) = 0: Pin(5) = 0
        Pin(4) = 0: Pin(6) = 0
    Else
        If controlByte <> prevByte Then
            If controlByte And &B0001 Then
                If controlByte And &B0010 Then
                    Pin(5) = 1
                ElseIf controlByte And &B0100
                    Pin(3) = 1
                Else
                    Pin(3) = 1
                    Pin(5) = 1
                EndIf
            ElseIf controlByte And &B1000 Then
                If controlByte And &B0010 Then
                    Pin(6) = 1
                ElseIf controlByte And &B0100
                    Pin(4) = 1
                Else
                    Pin(4) = 1
                    Pin(6) = 1
                EndIf
            ElseIf (controlByte And &B0010) And Not(controlByte And &B1001) Then
                Pin(4) = 1
                Pin(5) = 1
            ElseIf (controlByte And &B0100) And Not(controlByte And &B1001) Then
                Pin(3) = 1
                Pin(6) = 1
            EndIf
        EndIf
    EndIf
End Sub

controlInit
Do
    getControlByte
    motorControl
    prevByte = controlByte
Loop