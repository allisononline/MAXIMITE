Function wordSort$(inWord$)
    wordSort$ = ""
    wordLen = Len(inWord$)
    Dim chars$(wordLen) Length 1
    For i = 0 To wordLen - 1
        chars$(i) = LCase$(Mid$(inWord$, i + 1, 1))
    Next
    Do
        moved = 0
        For i = 0 To wordLen - 2
            If chars$(i) > chars$(i + 1) Then
                b$ = chars$(i)
                chars$(i) = chars$(i + 1)
                chars$(i + 1) = b$
                moved = 1
            EndIf
        Next
    Loop Until moved = 0
    For i = 0 To wordLen - 1
        wordSort$ = wordSort$ + chars$(i)
    Next
    Erase chars$()
End Function

controlWord$ = wordSort$("EARTHWORM")
Open "9letters.txt" For Input As #3
Do While Not Eof(#3)
    testWord$ = Input$(9, #3)
    junk$ = Input$(1, #3)
    Print testWord$;
    If wordSort$(testWord$) = controlWord$ Then
        Print
    Else
        Print Chr$(&H1B) + "[G" +  Chr$(&H1B) + "[0K";
    EndIf
Loop
Close #3
End