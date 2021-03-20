Open "OUTPUT.BAS" For Output As #3
Input Filename$
Open Filename$ For Input As #4
Do While Eof(#4) = 0
    Line Input #4, InStr$
    QuoteFlag = 0
    If Len(InStr$) = 0 Then
    Else
        For i = 1 To Len(InStr$)
            If Asc(Mid$(InStr$,i,1)) = &H22 Then
                QuoteFlag = Not QuoteFlag
                Print #3, Mid$(InStr$,i,1);
            ElseIf Asc(Mid$(InStr$,i,1)) = &H20 And QuoteFlag = 0 Then
            Else
                Print #3, Mid$(InStr$,i,1);
            EndIf
        Next
        Print #3, ""
    EndIf
Loop
Close #3
Close #4