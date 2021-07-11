Sub Initialise
    Dim H%(8)
    Dim K%(64)
    Dim W%(64)
    MaxVal% = &HFFFFFFFF
    H%(0)=&H6a09e667:H%(1)=&Hbb67ae85:H%(2)=&H3c6ef372:H%(3)=&Ha54ff53a
    H%(4)=&H510e527f:H%(5)=&H9b05688c:H%(6)=&H1f83d9ab:H%(7)=&H5be0cd19
    K%(0)=&H428a2f98:K%(1)=&H71374491:K%(2)=&Hb5c0fbcf:K%(3)=&He9b5dba5
    K%(4)=&H3956c25b:K%(5)=&H59f111f1:K%(6)=&H923f82a4:K%(7)=&Hab1c5ed5
    K%(8)=&Hd807aa98:K%(9)=&H12835b01:K%(10)=&H243185be:K%(11)=&H550c7dc3
    K%(12)=&H72be5d74:K%(13)=&H80deb1fe:K%(14)=&H9bdc06a7:K%(15)=&Hc19bf174
    K%(16)=&He49b69c1:K%(17)=&Hefbe4786:K%(18)=&H0fc19dc6:K%(19)=&H240ca1cc
    K%(20)=&H2de92c6f:K%(21)=&H4a7484aa:K%(22)=&H5cb0a9dc:K%(23)=&H76f988da
    K%(24)=&H983e5152:K%(25)=&Ha831c66d:K%(26)=&Hb00327c8:K%(27)=&Hbf597fc7
    K%(28)=&Hc6e00bf3:K%(29)=&Hd5a79147:K%(30)=&H06ca6351:K%(31)=&H14292967
    K%(32)=&H27b70a85:K%(33)=&H2e1b2138:K%(34)=&H4d2c6dfc:K%(35)=&H53380d13
    K%(36)=&H650a7354:K%(37)=&H766a0abb:K%(38)=&H81c2c92e:K%(39)=&H92722c85
    K%(40)=&Ha2bfe8a1:K%(41)=&Ha81a664b:K%(42)=&Hc24b8b70:K%(43)=&Hc76c51a3
    K%(44)=&Hd192e819:K%(45)=&Hd6990624:K%(46)=&Hf40e3585:K%(47)=&H106aa070
    K%(48)=&H19a4c116:K%(49)=&H1e376c08:K%(50)=&H2748774c:K%(51)=&H34b0bcb5
    K%(52)=&H391c0cb3:K%(53)=&H4ed8aa4a:K%(54)=&H5b9cca4f:K%(55)=&H682e6ff3
    K%(56)=&H748f82ee:K%(57)=&H78a5636f:K%(58)=&H84c87814:K%(59)=&H8cc70208
    K%(60)=&H90befffa:K%(61)=&Ha4506ceb:K%(62)=&Hbef9a3f7:K%(63)=&Hc67178f2
End Sub

Sub LoadWords(MsgInput$,L%,NoCRLF)
    If L% = 0 Then
        L% = Len(MsgInput$)
    EndIf
    Local Byte% = 0
    Local Word% = 0
    For i = 0 To 15
        Word% = 0
        For j = 0 to 3
            Byte% = Asc(Mid$(MsgInput$,(i*4)+j+1),1)
            Word% = Word% << 8
            If NoCRLF = 0 Then
                Word% = Word% + Byte%
            Else
                If (Byte% = &H0D) OR (Byte% = &H0A) Then
                    L% = L% - 1
                Else
                    Word% = Word% + Byte%
                EndIf
            EndIf
        Next
        W%(i) = Word%
    Next
    If (56-L%) > 0 Then
        W%(Fix(L%/4)) = W%(Fix(L%/4)) OR (&H80 << (8*(3-L% Mod(4))))
        W%(15) = L%*8
    EndIf
End Sub

Sub ExtendWords
    Local s0% = 0
    Local s1% = 0
    For i = 16 To 63
        s0% = RightRotate%(W%(i-15),7) XOR RightRotate%(W%(i-15),18) XOR (W%(i-15) >> 3)
        S1% = RightRotate%(W%(i-2),17) XOR RightRotate%(W%(i-2),19) XOR (W%(i-2) >> 10)
        W%(i) = NoCarry32%(W%(i-16) + s0% + W%(i-7) + s1%)
    Next
End Sub

Sub Compress
    Local a%(8)
    For i = 0 To 7
        a%(i) = h%(i)
    Next
    Local S1% = 0
    Local ch% = 0
    Local temp1% = 0
    Local S0% = 0
    Local maj% = 0
    Local temp2% = 0
    For i = 0 To 63
        S1% = RightRotate%(a%(4),6) XOR RightRotate%(a%(4),11) XOR RightRotate%(a%(4),25)
        ch% = (a%(4) AND a%(5)) XOR ((MaxVal%-a%(4)) AND a%(6))
        temp1% = NoCarry32%(a%(7)+S1%+ch%+K%(i)+W%(i))
        S0% = RightRotate%(a%(0),2) XOR RightRotate%(a%(0),13) XOR RightRotate%(a%(0),22)
        maj% = (a%(0) AND a%(1)) XOR (a%(0) AND a%(2)) XOR (a%(1) AND a%(2))
        temp2% = NoCarry32%(S0%+maj%)
        For j = 7 To 1 Step -1
            a%(j) = a%(j-1)
        Next
        a%(4) = NoCarry32%(a%(4)+temp1%)
        a%(0) = NoCarry32%(temp1%+temp2%)
    Next
    For i = 0 To 7
        h%(i) = NoCarry32%(h%(i)+a%(i))
    Next
End Sub

Function CreateDigest$()
    CreateDigest$ = ""
    For i = 0 To 7
        CreateDigest$ = CreateDigest$ + LCase$(Hex$(H%(i)))
    Next
End Function

Function RightRotate%(Value%,Bits)
    Local Carry% = Value% AND ((2^Bits)-1)
    RightRotate% = (Value% >> Bits) + (Carry% << (32-Bits))
End Function

Function NoCarry32%(Value%)
    NoCarry32% = Value% AND MaxVal%
End Function

Sub ProcessFile(Filename$)
    Initialise
    Open Filename$ For Input As #3
    Do 
        FileIn$ = Input$(64,#3)
        LoadWords(FileIn$,LOF(#3),1)
        ExtendWords
        Compress
    Loop Until EOF(#3)
    Close #3
    Print CreateDigest$()
End Sub

Sub Epoch
    CurrentDate$ = Date$
    CurrentTime$ = Time$
    TimeZone = 8
    Seconds = Val(Mid$(CurrentTime$,7,2))+(Val(Mid$(CurrentTime$,4,2))*60)
    Seconds = Seconds+(Val(Mid$(CurrentTime$,1,2))*3600)
    Days = Val(Mid$(CurrentDate$,1,2))
    Month = Val(Mid$(CurrentDate$,4,2))
    Year = Val(Mid$(CurrentDate$,7,4))
    If Year Mod(4) = 0 Then
        LeapYear = 1
    Else
        LeapYear = 0
    EndIf
    Days = Days+((Month-1)*30)+Fix(Month/2)-((2-LeapYear)*(Month>2))+(Month>7)
    Days = Days+(365*(Year-1970))+Fix((Year-1970)/4)
    Print Seconds+(86400*Days)-(3600*TimeZone)
End Sub

ProcessFile("HELLWRLD.TXT")