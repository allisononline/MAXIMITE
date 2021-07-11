ModeBits = (MM.Info(Mode)-Fix(MM.Info))*100
If ModeBits = 80 Then
    ModeBits = ModeBits/10
EndIf
LineBytes = MM.Hres*ModeBits/8
Page1Addr% = MM.Info(Page Address 1)

For i = MM.Vres-2 To 0 Step -1
    For j = 0 To MM.Hres-1
        Poke Byte Page1Addr%+((i+1)*LineBytes)+j,Peek(Byte Page1Addr%+(i*lineBytes)+j)
    Next
    Page Copy 1 To 0, B
Next

