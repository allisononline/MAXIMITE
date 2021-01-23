'''''''''''''''''''''''''''''''''''''''''''
' DAY OF THE WEEK FOR ANY DATE            '
' developed January 2012 for MMBasic 3.1  '
' theo.reimer@bigpond.com                 '
' program base date: Sunday 01/01/2012    '
' Now, 365 / 7 = 52 weeks and one day .   '
' Thus, day of week for a particular date '
' drifts by one or two days per year.     '
'''''''''''''''''''''''''''''''''''''''''''
Cls
Print "--------------------------------"
Print "* Day of the week for any date *"
Print "--------------------------------"
Print
Print "The Gregorian calendar came into use in 1582, so day of the week"
Print "for a particular date is not relevant for dates prior to the year"
Print "1582, although this program will generate a day of the week from"
Print "the year zero to the year 9999."
Print
Print "Press <Ctrl><C> to EXIT!"
Print
Print "Enter date as  DD*MM*YYYY  where * is any separator character,"
Print "followed by the <Enter> key, e.g., 31/12/2011 or 01-02-2012 ."
''''''''''''''''''''''''''''''''''''''''''
Do ' MAIN LOOP
''''''''''''''''''''''''''''''''''''''''''
GETDATE:
Print
Input "Date"; MYDATE$
D$ = Left$(MYDATE$,2)  : MYDAY   = Val(D$)
M$ = Mid$(MYDATE$,4,2) : MYMONTH = Val(M$)
Y$ = Right$(MYDATE$,4) : MYYEAR  = Val(Y$)
EM$ = "DATE or SYNTAX INVALID - TRY AGAIN!"
LEAPYEAR MYYEAR
If Len(MYDATE$) <> 10 Then
  Print EM$ : GoTo GETDATE
ElseIf (MYDAY <  1) Or (MYDAY > 31) Then
  Print EM$ : GoTo GETDATE
ElseIf (MYMONTH <  1) Or (MYMONTH > 12) Then
  Print EM$ : GoTo GETDATE
ElseIf (MYMONTH =  2) And (MYDAY > (28 + LY)) Then
  Print EM$ : GoTo GETDATE
ElseIf (MYMONTH =  4) And (MYDAY > 30) Then
  Print EM$ : GoTo GETDATE
ElseIf (MYMONTH =  6) And (MYDAY > 30) Then
  Print EM$ : GoTo GETDATE
ElseIf (MYMONTH =  9) And (MYDAY > 30) Then
  Print EM$ : GoTo GETDATE
ElseIf (MYMONTH = 11) And (MYDAY > 30) Then
  Print EM$ : GoTo GETDATE
EndIf
''''''''''''''''''''''''''''''''''''''''''
If MYYEAR >= 2012 Then
  DAYS_FROM_START_OF_YEAR
  DD = SC Mod 7
  If MYYEAR > 2012 Then
    For X = 2012 To (MYYEAR - 1)
      LEAPYEAR X
      DD = DD + 1 + LY
    Next
    DD = DD Mod 7
  EndIf
  If DD = 0 Then
    DOW$ = "Sunday"
  ElseIf DD = 1 Then
    DOW$ = "Monday"
  ElseIf DD = 2 Then
    DOW$ = "Tuesday"
  ElseIf DD = 3 Then
    DOW$ = "Wednesday"
  ElseIf DD = 4 Then
    DOW$ = "Thursday"
  ElseIf DD = 5 Then
    DOW$ = "Friday"
  ElseIf DD = 6 Then
    DOW$ = "Saturday"
  EndIf
''''''''''''''''''''''''''''''''''''''''''
Else
''''''''''''''''''''''''''''''''''''''''''
  DAYS_TO_END_OF_YEAR
  DD = SC Mod 7
  If MYEAR < 2011 Then
    For X = (MYYEAR + 1) To 2011
      LEAPYEAR X
      DD = DD + 1 + LY
    Next
    DD = DD Mod 7
  EndIf
  If DD = 0 Then
    DOW$ = "Sunday"
  ElseIf DD = 1 Then
    DOW$ = "Saturday"
  ElseIf DD = 2 Then
    DOW$ = "Friday"
  ElseIf DD = 3 Then
    DOW$ = "Thursday"
  ElseIf DD = 4 Then
    DOW$ = "Wednesday"
  ElseIf DD = 5 Then
    DOW$ = "Tuesday"
  ElseIf DD = 6 Then
    DOW$ = "Monday"
  EndIf
EndIf
''''''''''''''''''''''''''''''''''''''''''
If MYMONTH =  1 Then
  MOY$ = "January"
ElseIf MYMONTH =  2 Then
  MOY$ = "February"
ElseIf MYMONTH =  3 Then
  MOY$ = "March"
ElseIf MYMONTH =  4 Then
  MOY$ = "April"
ElseIf MYMONTH =  5 Then
  MOY$ = "May"
ElseIf MYMONTH =  6 Then
  MOY$ = "June"
ElseIf MYMONTH =  7 Then
  MOY$ = "July"
ElseIf MYMONTH =  8 Then
  MOY$ = "August"
ElseIf MYMONTH =  9 Then
  MOY$ = "September"
ElseIf MYMONTH = 10 Then
  MOY$ = "October"
ElseIf MYMONTH = 11 Then
  MOY$ = "November"
ElseIf MYMONTH = 12 Then
  MOY$ = "December"
EndIf
''''''''''''''''''''''''''''''''''''''''''
If MYDAY < 10 Then
  D$ = " " + Right$(D$,1)
EndIf
If Left$(Y$,3) = "000" Then
  Y$ = " " + Right$(Y$,1)
ElseIf Left$(Y$,2) = "00" Then
  Y$ = " " + Right$(Y$,2)
ElseIf Left$(Y$,1) = "0" Then
  Y$ = " " + Right$(Y$,3)
EndIf
''''''''''''''''''''''''''''''''''''''''''''''
' OUTPUT RESULT
Print DOW$ + " " + D$ + " " + MOY$ + " " + Y$
''''''''''''''''''''''''''''''''''''''''''''''
Loop
''''''''''''''''''''''''''''''''''''''''''
Sub LEAPYEAR ( YEAR )
  LY = 0
  If YEAR Mod 4 = 0 Then
    LY = 1
    If YEAR Mod 100 = 0 Then
      LY = 0
      If YEAR Mod 400 = 0 Then
        LY = 1
      EndIf
    EndIf
  EndIf
End Sub
''''''''''''''''''''''''''''''''''''''''''
Sub DAYS_FROM_START_OF_YEAR
  If MYMONTH =  1 Then
    SC =  MYDAY - 1
  ElseIf MYMONTH =  2 Then
    SC =  MYDAY + 30
  ElseIf MYMONTH =  3 Then
    SC =  MYDAY + 58 + LY
  ElseIf MYMONTH =  4 Then
    SC =  MYDAY + 89 + LY
  ElseIf MYMONTH =  5 Then
    SC =  MYDAY + 119 + LY
  ElseIf MYMONTH =  6 Then
    SC =  MYDAY + 150 + LY
  ElseIf MYMONTH =  7 Then
    SC =  MYDAY + 180 + LY
  ElseIf MYMONTH =  8 Then
    SC =  MYDAY + 211 + LY
  ElseIf MYMONTH =  9 Then
    SC =  MYDAY + 242 + LY
  ElseIf MYMONTH = 10 Then
    SC =  MYDAY + 272 + LY
  ElseIf MYMONTH = 11 Then
    SC =  MYDAY + 303 + LY
  ElseIf MYMONTH = 12 Then
    SC =  MYDAY + 333 + LY
  EndIf
End Sub
''''''''''''''''''''''''''''''''''''''''''
Sub DAYS_TO_END_OF_YEAR
  If MYMONTH = 12 Then
    SC =  32 - MYDAY
  ElseIf MYMONTH = 11 Then
    SC =  62 - MYDAY
  ElseIf MYMONTH = 10 Then
    SC =  93 - MYDAY
  ElseIf MYMONTH =  9 Then
    SC = 123 - MYDAY
  ElseIf MYMONTH =  8 Then
    SC = 154 - MYDAY
  ElseIf MYMONTH =  7 Then
    SC = 185 - MYDAY
  ElseIf MYMONTH =  6 Then
    SC = 215 - MYDAY
  ElseIf MYMONTH =  5 Then
    SC = 246 - MYDAY
  ElseIf MYMONTH =  4 Then
    SC = 276 - MYDAY
  ElseIf MYMONTH =  3 Then
    SC = 307 - MYDAY
  ElseIf MYMONTH =  2 Then
    SC = 335 - MYDAY + LY
  ElseIf MYMONTH =  1 Then
    SC = 366 - MYDAY + LY
  EndIf
End Sub
''''''''''''''''''''''''''''''''''''''''''

