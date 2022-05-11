Input "Input: ", InFile$
Input "Output: ", OutFile$
Open InFile$ For Input As #4
Open OutFile$ For Output As #3
Indent = 0
IncrNum = 8
DecrNum = 6
Dim IncrCommand$(IncrNum)
Dim DecrCommand$(DecrNum)
IncrCommand$(0) = "IF"
IncrCommand$(1) = "DO"
IncrCommand$(2) = "FOR"
IncrCommand$(3) = "SUB"
IncrCommand$(4) = "FUNCTION"
IncrCommand$(5) = "ELSE"
IncrCommand$(6) = "ELSEIF"
IncrCommand$(7) = "SELECT"
DecrCommand$(0) = "ELSE"
DecrCommand$(1) = "ELSEIF"
DecrCommand$(2) = "ENDIF"
DecrCommand$(3) = "LOOP"
DecrCommand$(4) = "NEXT"
DecrCommand$(5) = "END"

Do While Eof(#4) = 0
    Line Input #4, InStr$
    InWord = 0
    QuoteFlag = 0
    i = 1
    Do While Asc(Mid$(InStr$,i,1)) => &H30 And Asc(Mid$(InStr$,i,1)) =< &H39
        i = i + 1
    Loop
    Do While Asc(Mid$(InStr$,i,1)) = &H20
    i = i + 1
    Loop
    Command$ = UCase$(Word$(Mid$(InStr$,i,Len(InStr$)-i+1)))
    For j = 0 To decrNum
        If Command$ = DecrCommand$(j) Then
            Indent = Indent - 1
        EndIf
    Next
    If Indent > 0 Then
        Print #3, Space$(4 * Indent);
    EndIf
    For k = i To Len(InStr$)
        If Asc(Mid$(InStr$,k,1)) = &H22 Then
            QuoteFlag = Not QuoteFlag
        EndIf
        If IsLetter(Mid$(InStr$,k,1)) Or IsNumber(Mid$(InStr$,k,1)) And QuoteFlag = 0 Then
            If InWord = 0 Then
                InWord = 1
                Print #3, UCase$(Mid$(InStr$,k,1));
            ElseIf InWord = 1 Then
                Print #3, LCase$(Mid$(InStr$,k,1));
            EndIf
        Else
            InWord = 0
            Print #3, Mid$(InStr$,k,1);
        EndIf
    Next
    Print #3,""
    For j = 0 To incrNum
        If Command$ = IncrCommand$(j) Then
            Indent = Indent + 1
        EndIf
    Next
Loop
Close #3
Close #4

Function IsLetter(Char$)
    If (Asc(Char$) => &H41 And Asc(Char$) =< &H5A) Then
        IsLetter = 1
    ElseIf (Asc(Char$) => &H61 And Asc(Char$) =< &H7A) Then
        IsLetter = 1
    EndIf
End Function

Function IsNumber(Char$)
    If (Asc(Char$) => &H30 And Asc(Char$) =< &H39) Then
        IsNumber = 1
    EndIf
End Function

Function WORD$(INLINE3$)
    Local k = 0
    WORD$ = ""
    START = 1
        START = START + k
        k = 0
        Do While Mid$(INLINE3$,START+k,1) = " "
            k = k + 1
        Loop
        START = START + k
        k = 0
        Do While Mid$(INLINE3$,START+k,1) <> " " And  START+k =< Len(INLINE3$)
            k = k + 1
        Loop
    If k > 0 Then
        WORD$ = Mid$(INLINE3$,START,k)
    EndIf
End Function