Option Base 1
Dim VA$(30),CA$(10),D$(4),CA(10)
Dim RD$(10),RE(10,4)
Dim OA$(75),OD$(75),OM(75),OL(75),OV(75),OT(75)
Dim LI(10)
IC = 0: TT = 0: ET = 1000
Restore
G = 0

'   ----Main Program----
GoSub 700
R = 1
GoSub 500
215 Print
GoSub 300
Print
If B > 0 Then
    Goto 245
EndIf
GoSub 900
Goto 215
245 GoSub 400
If V = 0 Or N = 0 Then
    Goto 215
EndIf
GoSub 2000
Goto 215

'   ----Input Routine----
300 R$ = ""
Inc TT, 3
If TT > ET Then
    Print "Sorry... You ran out of time."
    End
EndIf
Input "Now what? ",R$
Print
For B = 1 To Len(R$)
    If Mid$(R$,B,1) = " " Then
        Return
    EndIf
Next
B = 0
Return

'   ----Parsing----
400 V$ = Left$(R$,B - 1)
For V = 1 To NV
    If V$ = VA$(V) Then
        Goto 435
    EndIf
Next
Print "I don't know how to "+V$+"."
V = 0
Return
435 L = Len(R$)
N$ = Mid$(R$,B+1,L)
For N = 1 To NN
    If N$ = OA$(N) And (OM(N) = R Or OM(N) = 100) Then
        Return
    EndIf
Next
Print "It won't help."
N = 0
Return

'   ----New Room----
500 Cls
Print RD$(R)
Return

'   ----Move Routine----
600 For J = 1 To 4
    If D$(J) = N$ Then
        Goto 625
    EndIf
Next
Goto 645
If RE(R,J) = 0 Then
    Goto 645
EndIf
R = RE(R,J)
GoSub 500
Return
Print "I can't go that direction."
Return

'   ----Read Data----
720 Read NV,NR,NC,NN
For i = 1 To NR
    Read RD$(i)
    For j = 1 To 4
        Read RE(i,j)
    Next
Next
For i = 1 To 10
    Read H$(i)
Next
For i = 1 To NC
    Read CA$(i)
Next
For i = 1 To NV
    Read VA$(i)
Next
For i = 1 To NN
    Read OA$(i),OD$(i),OM(i),OL(i),OV(i),OT(i)
Next
D$(1) = "North"
D$(2) = "East"
D$(3) = "South"
D$(4) = "West"
Return
Select Case C
    Case C 1
        Goto 930
    Case C 2
        Goto 934
    Case C 3
        Goto 940
    Case C 4
        Goto 1000
    Case C 5
        Goto 1030
    Case C 6
        Goto 1060
    Case C 7
        Goto 1100
End Select
Print "Invalid command code "+Format$(C)
Return

'   ----Command - Help----
930 Print H$(R)
Return

'   ----Command - Quit----
934 Input "Are you sure you want to quit? ",R$
If R$ = "No" Then
    Return
EndIf
GoSub 1030
GoSub 1060
End

'   ----Command - Inventory----
940 If IC = 0 Then
    Print "You aren't carrying anything."
    Return
EndIf
Print "You have"
For i = 1 To IC
    Print OA$(CA(i))
Next
Return

'   ----Command - Look----
1000 Print RD$(R)
Return

'   ----Command - Time----
1030 Print "Elapsed time is "+Format$(TT)+" minutes."
Return

'   ----Command - Score----
1060 If IC = 0 Then
    Print "You aren't carrying anything."
    Return
EndIf
S = 0
For i = 1 To IC
    Inc S,OV(CA(i))
Next
Print "You have "+Format$(S)+" points for evidence"
Return

'   ----Command - Restart----
1100 Input "Are you sure you want to restart? ",R$
If R$ = "Yes" Then
    Goto 150
EndIf
Print "Since you don't want to restart,"
Return

'   ----Verb Routines----
2000 If OT(N) <> 2 Then
    Goto 2010
EndIf
Print "You can't "+V$+" "+N$" yet."
Return
Select Case CA
    Case 1
        Goto 2100
    Case 2
        Goto 2200
    Case 3
        Goto 2200
    Case 4
        Goto 2300
    Case 5
        Goto 2300
    Case 6
        Goto 2300
    Case 7
        Goto 2400
    Case 8
        Goto 2500
    Case 9
        Goto 2600
    Case 10
        Goto 2700
    Case 11
        Goto 2800
    Case 12
        Goto 2900
    Case 13
        Goto 3100
    Case 14
        Goto 3200
    Case 15
        Goto 3300
    Case 16
        Goto 3400
    Case 17
        Goto 3500
    Case 18
        Goto 3500
    Case 19
        Goto 3600
    Case 20
        Goto 3700
    Case 21
        Goto 3800
    Case 22
        Goto 3900
    Case 23
        Goto 4000
    Case 24
        Goto 4100
End Select
Print "Invalid verb number: "+Format$(V)
Return

'   ----Verb - Look----
2100 Print OD$(N)
If OL(N) = 0 Then
    Return
EndIf
N = OL(N)
If OM(N) = R Then
    Return
EndIf
If OM(N) = R Then
    Goto 2100
EndIf
Goto 2110

'   ----Verbs - Take, Get----
2200 K = OT(N)
Select Case k
    Case 1
        Goto 2210
    Case 2
        Goto 2270
    Case 3
        Goto 2240
    Case 4
        Goto 2260
    Case 5
        Goto 2270
End Select
Print "Invalid take code for object "+OA$(N)+": "+OT(N)
Return
If IC < 6 Then
    Goto 2220
EndIf
Print "You can't carry anything else."
Return
If OM(N) = 100 Then
    Print "You already have it."
    Return
EndIf
Print "Taken."
OM(N) = 100
Inc IC
CA(IC) = N
Return
Print "Silly, that's too heavy to carry."
Return
Print "That's ridiculous!"
Return
Print "You can't take "+N$+" yet."
Return

'   ----Verb - Go----
2300 GoSub 600
Return

'   ----Verb - Open----
If N = 12 Then
    Goto 2420
EndIf
If N = 18 Then
    Goto 2430
EndIf
If N = 44 Then
    Goto 2440
EndIf
If N = 49 Then
    Goto 2450
EndIf
If N = 17 Then
    Print "You stab yourself with the tip, which is a poisoned dart."
    Print "You are rushed to the hospital."
    Print "End of game."
    End
EndIf
If N = 21 Then
    Print "Opened."
    OL(21) = 57
    OT(57) = 1
    Return
EndIf
If N = 37 Then
    OL(37) = 38
    OT(38) = 1
    RD$(8) = Left$(RD$(8),169)+" open."
    Return
EndIf
Print "A "+N$+" can't be opened."
Return
2420 If OT(12) = 4 And OT(13) = 4 Then
    Print "Opened."
    RE(2,1) = 3
    Return
EndIf
If OT(12) = 5 Then
    Print "The door is locked."
    Return
EndIf
If OT(13) = 5 Then
    Print "You didn't disconnect the alarm."
    Print "It goes off and the police come and arrest you."
    Print "End of game."
    End
EndIf
Print "You can't get through the door yet"
Return
Input "Combination :",C$
If C$ = "2-4-8" Then
    Print "Opened."
    Cat OD$(18), " Parts of an RR-13 rifle are inside the padded case."
    Return
EndIf
Print "Sorry - you don't have the right combination."
Return
Input "Combination: ",C$
If C$ = 20-15-9 Then
    Print "Opened."
    OL(44) = 45
    OT(45) = 1
    Cat OD$(44), " Inside is: "
    Return
EndIf
Print "Sorry - Combination isn't right."
Return
Print "Opened."
OT(51) = 1
OL(49) = 51
RD$(10) = Left$(RD$(10),184)+" open"
Return

'   ----Verb - Read----
If R = 3 And N = 16 Then
    Print "The telephone bill is made out to:"
    Print "    322-9678 -V.Grim"
    Print "    P.O. X"
    Print "    Grand Central Station NYC"
    Print "The amount is $247.36 for long distance charges to Washington D.C."
    Return
EndIf
If N = 20 Then
    Print "You can just make out this message:"
    Print "    HEL-ZXT.93.ZARF.1"
    Return
EndIf
If N = 23 Then
    Print "The bill is made out to:"
    Print "    322-8721"
    Print "    Ambassador Vladimir Griminski"
    Print "    14 Parkside Avenue - NYC"
    Print "The bill is for $68.34 for mostly local calls."
    Return
EndIf
If N = 25 Then
    Print "322-8721"
    Return
EndIf
If N = 30 Then
    Print "322-9678"
    Return
EndIf
If N = 42 Then
    Print "20-15-9"
    Return
EndIf
Print "Nothing to read."
Return

