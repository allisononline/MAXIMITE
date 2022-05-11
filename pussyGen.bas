Const LETT = 6

Open "6letters.txt" For Random As #3
Seek #3, Fix(Rnd * Fix(Lof(#3) / (LETT + 1))) * (LETT + 1) + 1
word$ = Input$(LETT, #3)
Close #3
count = 1
Do
    If Not Vowel(Mid$(word$, count, 1)) Then
        Exit Do
    EndIf
    count = count + 1
Loop
Do
    If Vowel(Mid$(word$, count, 1)) Then
        Exit Do
    EndIf
    count = count + 1
Loop
prefix$ = Mid$(word$, 1, count - 1)
Print "She got that "+word$+" pussy ("+prefix$+"ussy)"

Function Vowel(char$)
    Select Case LCase$(char$)
        Case "a"
            Vowel = 1
        Case "e"
            Vowel = 1
        Case "i"
            Vowel = 1
        Case "o"
            Vowel = 1
        Case "u"
            Vowel = 1
        Case Else
            Vowel = 0
    End Select
End Function
