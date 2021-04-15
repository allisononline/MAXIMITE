Input "Input: ", InFile$
Input "Output: ", OutFile$
Open InFile$ For Input As #4
Open OutFile$ For Output As #3
Indent = 0
DIM IncrCommand$(7)
DIM DecrCommand$(6)
IncrCommand$(0) = "IF"
IncrCommand$(1) = "DO"
IncrCommand$(2) = "FOR"
IncrCommand$(3) = "SUB"
IncrCommand$(4) = "FUNCTION"
IncrCommand$(5) = "ELSE"
IncrCommand$(6) = "ELSEIF"
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
    Do While Asc(Mid$(InStr$,i,1)) => &H30 AND Asc(Mid$(InStr$,i,1)) =< &H39
        i = i + 1
    Loop
    Do While Asc(Mid$(InStr$,i,1)) = &H20
    i = i + 1
    Loop
    Command$ = UCase$(Word$(Mid$(InStr$,i,Len(InStr$)-i+1)))
    For j = 0 To 5
        If Command$ = DecrCommand$(j) Then
            Indent = Indent - 1
        EndIf
    Next
    Print #3,Space$(Indent*4);
    For k = i To Len(InStr$)
        If Asc(Mid$(InStr$,k,1)) = &H22 Then
            QuoteFlag = NOT QuoteFlag
        EndIf
        If IsLetter(Mid$(InStr$,k,1)) OR IsNumber(Mid$(InStr$,k,1)) AND QuoteFlag = 0 Then
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
    For j = 0 To 6
        If Command$ = IncrCommand$(j) Then
            Indent = Indent + 1
        EndIf
    Next
Loop
Close #3
Close #4

Function IsLetter(Char$)
    If (Asc(Char$) => &H41 AND Asc(Char$) =< &H5A) Then
        IsLetter = 1
    ElseIf (Asc(Char$) => &H61 AND Asc(Char$) =< &H7A) Then
        IsLetter = 1
    EndIf
End Function

Function IsNumber(Char$)
    If (Asc(Char$) => &H30 AND Asc(Char$) =< &H39) Then
        IsNumber = 1
    EndIf
End Function

FUNCTION WORD$(INLINE3$)
    LOCAL k = 0
    WORD$ = ""
    START = 1
        START = START + k
        k = 0
        DO WHILE MID$(INLINE3$,START+k,1) = " "
            k = k + 1
        LOOP
        START = START + k
        k = 0
        DO WHILE MID$(INLINE3$,START+k,1) <> " " AND  START+k =< LEN(INLINE3$)
            k = k + 1
        LOOP
    IF k > 0 THEN
        WORD$ = MID$(INLINE3$,START,k)
    ENDIF
END FUNCTION