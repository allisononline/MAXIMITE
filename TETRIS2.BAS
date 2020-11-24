LIBRARY LOAD "CONTROLR.LIB"
SPRITE LOAD TETRIS.SPR
Dim FIELD(11,21)
Dim PREVIEW(3,3)
Dim PIECE(3,3)
Dim SPAWN(1)
SPAWN(0) = 4
SPAWN(1) = 1
PIECE.X = 0
PIECE.Y = 0

Sub INIT
    For j = 0 To 21
        FIELD(0,j) = 1
        FIELD(11,j) = 1
    Next
    For i = 0 To 11
        FIELD(i,0) = 1
        FIELD(i,21) = 1
    Next
    For j = 1 To 20
        For i = 1 To 10
            FIELD(i,j) = 0
        Next
    Next
    CONTROL.INIT
    cls
End Sub

Sub DRAW.FIELD draw.x.1,draw.y.1,draw.x.2,draw.y.2
    For l = draw.y.1 To draw.y.2
        For k = draw.x.1 To draw.x.2
            If FIELD(k,l) > 0 Then
                Print @(k*12,l*12) FIELD(k,l)
            Else
                Print @(k*12,l*12) "  "
            EndIf
        Next
    Next
END SUB

SUB DRAW.PREVIEW
    For l = 0 To 3
        For k = 0 To 3
           If PREVIEW(k,l) > 0 Then
               Print @(k*12,264+(l*12)) PREVIEW(k,l)
           Else
               Print @(k*12,264+(l*12))"  "
           EndIf
        Next
    NEXT
END SUB

SUB DRAW.PIECE
    FOR l = 0 TO 3
        For k = 0 To 3
           If PIECE(k,l) > 0 Then
               Print @(48+(k*12),264+(l*12)) PIECE(k,l)
           Else
               Print @(48+(k*12),264+(l*12)) "  "
           EndIf
        Next
        Print ""
    Next
'    Print PIECE.X;
'    Print PIECE.Y
End Sub

SUB DRAW.SPRITE

Sub NEWPIECE(BIT)
    For j = 0 To 3
          For i = 0 To 3
            PREVIEW(i,j) = 0
        Next
    Next
        If BIT = 0 Then
            PREVIEW(0,1) = 2
            PREVIEW(1,1) = 2
            PREVIEW(2,1) = 2
            PREVIEW(3,1) = 2
        ElseIf BIT = 1 Then
            PREVIEW(1,1) = 2
            PREVIEW(1,2) = 2
            PREVIEW(2,1) = 2
            PREVIEW(2,2) = 2
        ElseIf BIT = 2 Then
            PREVIEW(1,1) = 2
            PREVIEW(2,1) = 2
            PREVIEW(3,1) = 2
            PREVIEW(3,2) = 2
        ElseIf BIT = 3 Then
            PREVIEW(1,2) = 2
            PREVIEW(1,1) = 2
            PREVIEW(2,1) = 2
            PREVIEW(3,1) = 2
        ElseIf BIT = 4 Then
            PREVIEW(1,2) = 2
            PREVIEW(2,1) = 2
            PREVIEW(2,2) = 2
            PREVIEW(3,1) = 2
        ElseIf BIT = 5 Then
            PREVIEW(1,1) = 2
            PREVIEW(2,1) = 2
            PREVIEW(2,2) = 2
            PREVIEW(3,1) = 2
        ElseIf BIT = 6 Then
            PREVIEW(1,1) = 2
            PREVIEW(2,1) = 2
            PREVIEW(2,2) = 2
            PREVIEW(3,2) = 2
        EndIf
End Sub

Sub GETPIECE
    For j = 0 To 3
        For i = 0 To 3
            PIECE(i,j) = PREVIEW(i,j)
        Next
    Next
End Sub

Sub PLACEPIECE
    PIECE.X = SPAWN(0)
    PIECE.Y = SPAWN(1)
    For j = 0 To 3
        For i = 0 To 3
    FIELD(i+SPAWN(0),j+SPAWN(1))=FIELD(i+SPAWN(0),j+SPAWN(1))+PIECE(i,j)
        Next
    Next
End Sub

Sub FINDPIECE
    PIECE.X = 10
    PIECE.Y = 20
    For j = 1 To 20
        For i = 1 To 10
            If FIELD(i,j) = 2 Then
                If i < PIECE.X Then
                    PIECE.X = i
                EndIf
                If j < PIECE.Y Then
                    PIECE.Y = j
                EndIf
            EndIf
        Next
    Next
End Sub

Function OVERLAP()
    For j = 0 To 3
        For i = 0 To 3
            If PREVIEW(i,j) = 2 Then
                If FIELD(i+SPAWN(0),j+SPAWN(1)) > 2 Then
                    OVERLAP = 1
                EndIf
            EndIf
        Next
    Next
End Function

Function BUMP(DIR$)
    For j = 1 To 20
        For i = 1 To 10
            If FIELD(i,j) = 2 Then
                If DIR$ = "DOWN" Then
                    If FIELD(i,j+1) = 1 Then
                        BUMP = 1
                    EndIf
                ElseIf DIR$ = "LEFT" Then
                    If FIELD(i-1,j) = 1 Then
                        BUMP = 1
                    EndIf
                ElseIf DIR$ = "RIGHT" Then
                    If FIELD(i+1,j) = 1 Then
                        BUMP = 1
                    EndIf
                EndIf
            EndIf
        Next
    Next
End Function

Sub MOVE(DIR$)
    If DIR$ = "DOWN" Then
        For j = 3 To 0 Step -1
            For i = 0 To 3
                If PIECE(i,j) = 2 Then
                    FIELD(i+(PIECE.X),j+(PIECE.Y)+1) = 2
                    FIELD(i+(PIECE.X),j+(PIECE.Y)) = 0
                EndIf
            Next
        Next
        PIECE.Y = PIECE.Y + 1
    ElseIf DIR$ = "LEFT" Then
        For j = 3 To 0 Step -1
            For i = 0 To 3
                If PIECE(i,j) = 2 Then
                    FIELD(i+(PIECE.X)-1,j+(PIECE.Y)) = 2
                    FIELD(i+(PIECE.X),j+(PIECE.Y)) = 0
                EndIf
            Next
        Next
        PIECE.X = PIECE.X -1
    ElseIf DIR$ = "RIGHT" Then
        For j = 3 To 0 Step -1
            For i = 0 To 3
                If PIECE(i,j) = 2 Then
                    FIELD(i+(PIECE.X)+1,j+(PIECE.Y)) = 2
                    FIELD(i+(PIECE.X),j+(PIECE.Y)) = 0
                EndIf
            Next
        Next
        PIECE.X = PIECE.X + 1
    EndIf
End Sub

Sub ROTATE(DIR$)
    Local ROTATE(3,3)
    For k = 0 To 1
        For j = 0 To 3
            For i = 0 To 3
                If k = 0 Then
                    If DIR$ = "LEFT" Then
                        ROTATE(i,j) = PIECE(3-j,i)
                        If FIELD(PIECE.X+i,PIECE.Y+j) = 2 Then
                            FIELD(PIECE.X+i,PIECE.Y+j) = 0
                        EndIf
                        FIELD(PIECE.X+i,PIECE.Y+j) = 0
                    ElseIf DIR$ = "RIGHT" Then
                        ROTATE(i,j) = PIECE(j,3-i)
                        If FIELD(PIECE.X+i,PIECE.Y+j) = 2 Then
                            FIELD(PIECE.X+i,PIECE.Y+j) = 0
                        EndIf
                        FIELD(PIECE.X+i,PIECE.Y+j) = 0
                    EndIf
                Else
                    PIECE(i,j) = ROTATE(i,j)
                    If PIECE(i,j) = 2 Then
                        FIELD(PIECE.X+i,PIECE.Y+j) = 2
                    EndIf
                EndIf
            Next
        Next
    Next
End Sub

Sub PETRIFY
    For j = 1 To 20
        For i = 1 To 10
            If FIELD(i,j) = 2 Then
                FIELD(i,j) = 1
            EndIf
        Next
    Next
End Sub

Sub LINEDOWN
    Local k = 0
    Local l = 0
    For j = 20 To 1 Step -1
        k = 0
        For i = 1 To 10
            If FIELD(i,j) > 0 Then
                k = k + 1
            EndIf
        Next
        If k = 10 Then
            For i = 1 To 10
                FIELD(i,j) = 0
            Next
            DRAW.FIELD 1,1,10,j
            PAUSE 500
            For l = j To 2 Step -1
                For i = 1 To 10
                    FIELD(i,l) = FIELD(i,l-1)
                Next
            Next
            DRAW.FIELD 1,1,10,j
             PAUSE 500
            j = j + 1
        EndIf
'        Print k;
    Next
End Sub

Sub KEYPRESS
        Local KEY$
        KEY$ = Inkey$
        If Key$ = "s" And BUMP("DOWN") = 0 Then
            MOVE "DOWN"
            DRAW.FIELD PIECE.X,PIECE.Y-1,PIECE.X+3,PIECE.Y+3
        ElseIf Key$ = "a" And BUMP("LEFT") = 0 Then
            MOVE "LEFT"
            DRAW.FIELD PIECE.X,PIECE.Y,PIECE.X+4,PIECE.Y+3
        ElseIf Key$ = "d" And BUMP("RIGHT") = 0 Then
            MOVE "RIGHT"
            DRAW.FIELD PIECE.X-1,PIECE.Y,PIECE.X+3,PIECE.Y+3
        ElseIf Key$ = "q" Then
            ROTATE "LEFT"
            DRAW.FIELD PIECE.X,PIECE.Y,PIECE.X+3,PIECE.Y+3
            DRAW.PIECE
        ElseIf Key$ = "e" Then
            ROTATE "RIGHT"
            DRAW.FIELD PIECE.X,PIECE.Y,PIECE.X+3,PIECE.Y+3
            DRAW.PIECE
        EndIf
End Sub

Sub CONTROLLER
    LOCAL BUTTONS$
    BUTTONS$ = CONTROL.READ$()
    IF BUTTONS$ <> "00000" THEN
        IF PEEK(VAR BUTTONS$,5) = 49 AND BUMP("DOWN") = 0 THEN
            MOVE "DOWN"
            DRAW.FIELD PIECE.X,PIECE.Y-1,PIECE.X+3,PIECE.Y+3
            DRAW.PIECE
        ENDIF
        IF PEEK(VAR BUTTONS$,4) = 49 AND BUMP("LEFT") = 0 THEN
            MOVE "LEFT"
            DRAW.FIELD PIECE.X,PIECE.Y,PIECE.X+4,PIECE.Y+3
            DRAW.PIECE
        ENDIF
        IF PEEK(VAR BUTTONS$,3) = 49 AND BUMP("RIGHT") = 0 THEN
            MOVE "RIGHT"
            DRAW.FIELD PIECE.X-1,PIECE.Y,PIECE.X+3,PIECE.Y+3
            DRAW.PIECE
        ENDIF
    ENDIF
END SUB
        
Sub GAME
    Timer = 0
    INIT
    NEWPIECE(Cint(Rnd()*100) Mod (6))
    DRAW.FIELD 0,0,11,21
    DRAW.PREVIEW
    Do While OVERLAP() = 0
        GETPIECE
        PLACEPIECE
        NEWPIECE(Cint(Rnd()*100) Mod (6))
        DRAW.PIECE
        DRAW.PREVIEW
        DRAW.FIELD PIECE.X,PIECE.Y,PIECE.X+3,PIECE.Y+3
        Do While BUMP("DOWN") = 0
            KEYPRESS
            CONTROLLER
            If Timer > 500 AND BUMP("DOWN") = 0 Then
                MOVE("DOWN")
                DRAW.FIELD PIECE.X,PIECE.Y-1,PIECE.X+3,PIECE.Y+3
                Timer = 0
            EndIf
        Loop
        PETRIFY
        DRAW.FIELD PIECE.X,PIECE.Y,PIECE.X+3,PIECE.Y+3
        LINEDOWN
    Loop
    PRINT @(48,60) "********"
    Print @(48,72) "* TILT *"
    PRINT @(48,84) "********"
End Sub

Sub TEST
    For k = 0 To 6
        PREVIEW(k)
        For j = 0 To 3
            For i = 0 To 3
                Print PREVIEW(i,j);
            Next
            Print ""
        Next
        Print ""
    Next
End Sub

GAME                     