MODE 3
CLEAR
CHDIR ".."
LIBRARY LOAD "CONTROLR.LIB"
CHDIR "TETRIS"
SPRITE LOAD "TETRIS.SPR"
Dim FIELD(11,21)
Dim PREVIEW(3,3)
Dim PIECE(3,3)
Dim SPAWN(1)
SPAWN(0) = 4
SPAWN(1) = 1
PIECE.X = 0
PIECE.Y = 0
PIECE.TYPE = 0
PREVIEW.TYPE = 0
GFX.FIELD.X = (MM.HRES/2)-(6*16)
GFX.FIELD.Y = (MM.VRES/2)-(11*16)
SCORE = 0
LEVEL = 0
LINES = 0
STARTLEVEL = 0
COUNT = 16.7*48
GFX = 1
SOFTDROP = 0

FUNCTION GFX.FORMINPUT$(x,y,n)
    OUTPUT$ = SPACE$(n)
    FORMKEY$ = ""
    POSIT = 1
    FORMKEY$ = UCASE$(INKEY$)
    FONT #2,,1
    PRINT @(x,y) CHR$(PEEK(VAR OUTPUT$,1))
    DO 
        FORMKEY$ = UCASE$(INKEY$)
        IF FORMKEY$ => "A" AND FORMKEY$ =< "Z" THEN
            POKE VAR OUTPUT$,POSIT, PEEK(VAR FORMKEY$,1)
            FONT #2,,0
            PRINT @(x+((POSIT-1)*13),y) CHR$(PEEK(VAR FORMKEY$,1))
            IF POSIT < n THEN
                POSIT = POSIT + 1
            ENDIF
            FONT #2,,1
            PRINT @(x+((POSIT-1)*13),y) CHR$(PEEK(VAR OUTPUT$,POSIT))
            FONT #2,,0
        ELSEIF FORMKEY$ = CHR$(8) THEN
            POKE VAR OUTPUT$,POSIT,32
            FONT #2,,0
            PRINT @(x,y) OUTPUT$
            IF POSIT > 1 THEN
                POSIT = POSIT - 1
            ENDIF
            FONT #2,,1
            PRINT @(x+((POSIT-1)*13),y) CHR$(PEEK(VAR OUTPUT$,POSIT))
            FONT #2,,0
        ELSEIF FORMKEY$ = CHR$(130) THEN
            FONT #2,,0
            PRINT @(x,y) OUTPUT$
            IF POSIT > 1 THEN
                POSIT = POSIT - 1
            ENDIF
            FONT #2,,1
            PRINT @(x+((POSIT-1)*13),y) CHR$(PEEK(VAR OUTPUT$,POSIT))
            FONT #2,,0
        ELSEIF FORMKEY$ = CHR$(131) THEN
            FONT #2,,0
            PRINT @(x,y) OUTPUT$
            IF POSIT < n THEN
                POSIT = POSIT + 1
            ENDIF
            FONT #2,,1
            PRINT @(x+((POSIT-1)*13),y) CHR$(PEEK(VAR OUTPUT$,POSIT))
            FONT #2,,0
        ENDIF
    LOOP UNTIL FORMKEY$ = CHR$(13)
    GFX.FORMINPUT$ = OUTPUT$
    FONT #2,,0
END FUNCTION
    
CLS
IF GFX = 1 THEN
    FONT #2
ENDIF

Sub GAME.INIT
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
End Sub

SUB DRAW.SCORE
    PRINT @(0,312) SCORE
    PRINT @(0,324) LEVEL
    PRINT @(0,336) LINES
END SUB

SUB GFX.DRAW.BORDER
    LOADBMP "TEMPLATE.BMP"
    PRINT @(364,156) "SCORE"
    PRINT @(364,220) "LEVEL"
    PRINT @(364,284) "LINES"
    FOR i = 0 TO 11
        SPRITE PASTE 4,GFX.FIELD.X+(i*16),GFX.FIELD.Y+(16*0)
        SPRITE PASTE 4,GFX.FIELD.X+(i*16),GFX.FIELD.Y+(16*21)
    NEXT
    FOR j = 1 to 20
        SPRITE PASTE 4,GFX.FIELD.X+(0*16),GFX.FIELD.Y+(16*j)
        SPRITE PASTE 4,GFX.FIELD.X+(11*16),GFX.FIELD.Y+(16*j)
    NEXT
END SUB

SUB GFX.CLEAR.FIELD
    LINE(GFX.FIELD.X+16,GFX.FIELD.Y+16)-(GFX.FIELD.X+(16*11)-1,GFX.FIELD.Y+(16*21)-1),0,BF
END SUB

SUB GFX.DRAW.SCORE
    PRINT @(364,172) SCORE
    PRINT @(364,236) LEVEL
    PRINT @(364,300) LINES
END SUB

SUB GFX.DRAW.PREVIEW
    LINE(GFX.FIELD.X+((15)*16),GFX.FIELD.Y+((1)*16))-(GFX.FIELD.X+((19)*16),GFX.FIELD.Y+((5)*16)),0,BF
    FOR j = 0 TO 3
        FOR i = 0 TO 3
            IF PREVIEW(i,j) = 2 THEN
                IF PREVIEW.TYPE = 0 OR PREVIEW.TYPE = 1 OR PREVIEW.TYPE = 5 THEN
                    SPRITE PASTE 3,GFX.FIELD.X+((15+i)*16),GFX.FIELD.Y+((1+j)*16)
                ELSEIF PREVIEW.TYPE = 2 OR PREVIEW.TYPE = 4 THEN
                    SPRITE PASTE 1,GFX.FIELD.X+((15+i)*16),GFX.FIELD.Y+((1+j)*16)
                ELSEIF PREVIEW.TYPE = 3 OR PREVIEW.TYPE = 6 THEN
                    SPRITE PASTE 2,GFX.FIELD.X+((15+i)*16),GFX.FIELD.Y+((1+j)*16)
                ENDIF
            ENDIF
        NEXT
    NEXT
END SUB        
                
SUB GFX.PIECE.NEW
    LOCAL k = 0
    FOR i = 0 TO 3
        IF PIECE.TYPE = 0 OR PIECE.TYPE = 1 OR PIECE.TYPE = 5 THEN
            SPRITE COPY 3 TO 5+i
        ELSEIF PIECE.TYPE = 2 OR PIECE.TYPE = 4 THEN
            SPRITE COPY 1 TO 5+i
        ELSEIF PIECE.TYPE = 3 OR PIECE.TYPE = 6 THEN
            SPRITE COPY 2 TO 5+i
        ENDIF
    NEXT
    DO WHILE k < 3
        FOR j = 0 TO 3
            FOR i = 0 TO 3
                IF PIECE(i,j) = 2 THEN
                    SPRITE ON 5+k,GFX.FIELD.X+(PIECE.X+i)*16,GFX.FIELD.Y+(PIECE.Y+j)*16
                    k = k + 1
                ENDIF
            NEXT
        NEXT
    LOOP
END SUB

SUB GFX.PIECE.MOVE
    k = 8
    DO WHILE k > 5
        FOR i = 0 TO 3
            FOR j = 0 TO 3
                IF PIECE(i,j) = 2 THEN
                    SPRITE MOVE k,GFX.FIELD.X+(PIECE.X+i)*16,GFX.FIELD.Y+(PIECE.Y+j)*16
                    IF COLLISION(k, SPRITE) > 0 THEN
                        FOR l = 5 TO 8
                            IF COLLISION(l, SPRITE) > 0 AND l <> k THEN
                                SPRITE OFF k
                                SPRITE OFF l
                    SPRITE ON k,GFX.FIELD.X+(PIECE.X+i)*16,GFX.FIELD.Y+(PIECE.Y+j)*16
                    SPRITE ON l,GFX.FIELD.X+(PIECE.X+i)*16,GFX.FIELD.Y+(PIECE.Y+j)*16
                            ENDIF
                        NEXT
                    ENDIF
                    k = k - 1
                ENDIF
            NEXT
        NEXT
    LOOP
END SUB

SUB GFX.PIECE.PASTE
    SPRITE OFF ALL
    FOR j = 0 TO 3
        FOR i = 0 TO 3
            IF PIECE(i,j) = 2 THEN
                SPRITE PASTE 5,GFX.FIELD.X+(PIECE.X+i)*16,GFX.FIELD.Y+(PIECE.Y+j)*16
            ENDIF
        NEXT
    NEXT
END SUB

SUB GFX.LINE.DOWN(linenbr)
    LINE (GFX.FIELD.X+16,GFX.FIELD.Y+(16*linenbr))-(GFX.FIELD.X+(16*11)-1,GFX.FIELD.Y+(16*(linenbr+1))-1),0,BF
    PAUSE COUNT/2
    BLIT GFX.FIELD.X+16,GFX.FIELD.Y+16,GFX.FIELD.X+16,GFX.FIELD.Y+32,160,((linenbr-1)*16)
    PAUSE COUNT/2
END SUB

SUB DRAW.LINE.DOWN(linenbr)
    DRAW.FIELD 1,1,10,linenbr
    PAUSE 500
END SUB

FUNCTION GFX.LEVELSELECT()
    LOCAL KEY$ = ""
    LOCAL LEVEL(10)
    FOR i = 0 TO 9
        LEVEL(i) = i
    NEXT
    GFX.LEVELSELECT = 0
    PRINT @(208,198) "LEVEL"
    PRINT @(200,214) "SELECT"
    FOR i = 0 TO 4
        IF i = GFX.LEVELSELECT THEN
            FONT #2,,1
        ELSE
            FONT #2,,0
        ENDIF
        PRINT @(200+(i*16),242) FORMAT$(i)
        FONT #2,,0
    NEXT
    FOR i = 5 TO 9
        IF i = GFX.LEVELSELECT THEN
            FONT #2,,1
        ELSE
            FONT #2,,0
        ENDIF
        PRINT @(200+((i-5)*16),260) FORMAT$(i)
        FONT #2,,0
    NEXT
    DO WHILE KEY$ <> CHR$(13)
        KEY$ = INKEY$
        IF KEY$ = CHR$(130) or KEY$ = CHR$(131) THEN
            IF KEY$ = CHR$(130) THEN
                GFX.LEVELSELECT = (GFX.LEVELSELECT-1)
                IF GFX.LEVELSELECT < 0 THEN
                    GFX.LEVELSELECT = 9
                ENDIF
            ELSEIF KEY$ = CHR$(131) THEN
                GFX.LEVELSELECT = (GFX.LEVELSELECT+1)
                IF GFX.LEVELSELECT > 9 THEN
                    GFX.LEVELSELECT = 0
                ENDIF
            ENDIF
            FOR i = 0 TO 4
                IF i = GFX.LEVELSELECT THEN
                    FONT #2,,1
                ELSE
                    FONT #2,,0
                ENDIF
                PRINT @(200+(i*16),242) FORMAT$(i)
            NEXT
            FOR i = 5 TO 9
                IF i = GFX.LEVELSELECT THEN
                    FONT #2,,1
                ELSE
                    FONT #2,,0
                ENDIF
                PRINT @(200+((i-5)*16),260) FORMAT$(i)
            NEXT
        ENDIF
    LOOP
    FONT #2,,0
END FUNCTION

FUNCTION GFX.NEWGAME()
    GFX.CLEAR.FIELD
    LOCAL KEY$ = ""
    GFX.NEWGAME = 1
    FONT #2,,1
    PRINT @(188,224) "NEW GAME"
    FONT #2,,0
    PRINT @(188,242) "  EXIT  "
    DO WHILE KEY$ <> CHR$(13)
        KEY$ = INKEY$
        IF KEY$ = CHR$(128) or KEY$ = CHR$(129) THEN
            GFX.NEWGAME = (GFX.NEWGAME+1) MOD(2)
            IF GFX.NEWGAME = 1 THEN    
                FONT #2,,1
                PRINT @(188,224) "NEW GAME"
                FONT #2,,0
                PRINT @(188,242) "  EXIT  "
            ELSE
                FONT #2,,0
                PRINT @(188,224) "NEW GAME"
                FONT #2,,1
                PRINT @(188,242) "  EXIT  "
                FONT #2,,0
            ENDIF
        ENDIF
    LOOP
END FUNCTION
    
    
Sub NEWPREVIEW(BIT)
    PREVIEW.TYPE = BIT
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
    PIECE.TYPE = PREVIEW.TYPE
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
    j = 0
    i = 0
    BUMP = 0
    For j = 0 To 3
        For i = 0 To 3
            If PIECE(i,j) = 2 Then
                If DIR$ = "DOWN" Then
                    If FIELD(i+PIECE.X,j+PIECE.Y+1) = 1 Then
                        BUMP = 1
                    EndIf
                ElseIf DIR$ = "LEFT" Then
                    If FIELD(i+PIECE.X-1,j+PIECE.Y) = 1 Then
                        BUMP = 1
                    EndIf
                ElseIf DIR$ = "RIGHT" Then
                    If FIELD(i+PIECE.X+1,j+PIECE.Y) = 1 Then
                        BUMP = 1
                    EndIf
                ELSEIF DIR$ = "RLEFT" THEN
IF PIECE.X+3-j < 1 OR PIECE.X+3-j > 10 OR PIECE.Y+i < 1 OR PIECE.Y+i > 20 THEN
                        BUMP = 1
                    ELSE
                        IF FIELD(PIECE.X+3-j,PIECE.Y+i) = 1 THEN
                            BUMP = 1
                        ENDIF
                    ENDIF
                ELSEIF DIR$ = "RRIGHT" THEN
IF PIECE.X+j < 1 OR PIECE.X+j > 10 OR PIECE.Y+3-i < 1 OR PIECE.Y+3-i > 20 THEN
                        BUMP = 1
                    ELSE
                        IF FIELD(PIECE.X+j,PIECE.Y+3-i) = 1 THEN
                            BUMP = 1 
                        ENDIF
                    ENDIF
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
                    ElseIf DIR$ = "RIGHT" Then
                        ROTATE(i,j) = PIECE(j,3-i)
                        If FIELD(PIECE.X+i,PIECE.Y+j) = 2 Then
                            FIELD(PIECE.X+i,PIECE.Y+j) = 0
                        EndIf
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
    LOCAL m = 0
    For j = 20 To 1 Step -1
        k = 0
        For i = 1 To 10
            If FIELD(i,j) > 0 Then
                k = k + 1
            EndIf
        Next
        If k = 10 Then
            LINES = LINES + 1
            For i = 1 To 10
                FIELD(i,j) = 0
            Next
            IF GFX = 0 THEN
                DRAW.LINE.DOWN(j)
            ENDIF
            For l = j To 2 Step -1
                For i = 1 To 10
                    FIELD(i,l) = FIELD(i,l-1)
                Next
            Next
            IF GFX = 1 THEN
                GFX.LINE.DOWN(j)
            ELSE
                DRAW.LINE.DOWN(j)
            ENDIF
            j = j + 1
            m = m + 1
        EndIf
    Next
    IF m = 1 THEN
        SCORE = SCORE+(40*(LEVEL+1))
    ELSEIF m = 2 THEN
        SCORE = SCORE+(100*(LEVEL+1))
    ELSEIF m = 3 THEN
        SCORE = SCORE+(300*(LEVEL+1))
    ELSEIF m = 4 THEN
        SCORE = SCORE+(1200*(LEVEL+1))
    ENDIF
        LEVEL = STARTLEVEL + FIX(LINES/10)
End Sub

SUB FRAMES
    IF LEVEL < 9 THEN
        COUNT = 16.7*(48-(5*LEVEL))
    ELSEIF LEVEL = 9 THEN
        COUNT = 16.7*6
    ELSEIF LEVEL => 10 AND =< 12 THEN
        COUNT = 16.7*5
    ELSEIF LEVEL => 13 AND =< 15 THEN
        COUNT = 16.7*4
    ELSEIF LEVEL => 16 AND =< 18 THEN
        COUNT = 16.7*3
    ELSEIF LEVEL => 19 AND =< 28 THEN
        COUNT = 16.7*2
    ELSEIF LEVEL => 29 THEN
        COUNT = 16.7*2
    ENDIF
END SUB

Sub KEYPRESS
        Local KEY$
        KEY$ = Inkey$
        If Key$ = "s" And BUMP("DOWN") = 0 Then
            MOVE "DOWN"
            IF GFX = 1 THEN
                GFX.PIECE.MOVE
            ELSE
                DRAW.FIELD PIECE.X,PIECE.Y-1,PIECE.X+3,PIECE.Y+3
            ENDIF
            SOFTDROP = SOFTDROP+1
        ElseIf Key$ = "a" And BUMP("LEFT") = 0 Then
            MOVE "LEFT"
            IF GFX = 1 THEN
                GFX.PIECE.MOVE
            ELSE
                DRAW.FIELD PIECE.X+1,PIECE.Y,PIECE.X+3,PIECE.Y+3
            ENDIF
        ElseIf Key$ = "d" And BUMP("RIGHT") = 0 Then
            MOVE "RIGHT"
            IF GFX = 1 THEN
                GFX.PIECE.MOVE
            ELSE
                DRAW.FIELD PIECE.X-1,PIECE.Y,PIECE.X+3,PIECE.Y+3
            ENDIF
        ElseIf Key$ = "q" AND BUMP("RRIGHT") = 0 Then
            ROTATE "LEFT"
            IF GFX = 1 THEN
                GFX.PIECE.MOVE
            ELSE
                DRAW.FIELD PIECE.X-1,PIECE.Y,PIECE.X+3,PIECE.Y+3
                DRAW.PIECE
            ENDIF
        ElseIf Key$ = "e" AND BUMP("RLEFT") = 0 Then
            ROTATE "RIGHT"
            IF GFX = 1 THEN
                GFX.PIECE.MOVE
            ELSE
                DRAW.FIELD PIECE.X-1,PIECE.Y,PIECE.X+3,PIECE.Y+3
                DRAW.PIECE
            ENDIF
        ELSEIF KEY$ = CHR$(156) THEN
            SAVEBMP "TETRIS.BMP"
        ELSEIF KEY$ = CHR$(27) THEN
            PAUSEGAME
        EndIf
End Sub

Sub CONTROLLER
    LOCAL BUTTONS$
    BUTTONS$ = CONTROL.READ$()
    IF BUTTONS$ <> "00000" THEN
        IF MID$(BUTTONS$,5,1) = "1" AND BUMP("DOWN") = 0 THEN
            MOVE "DOWN"
            IF GFX = 1 THEN
                GFX.PIECE.MOVE
            ELSE
                DRAW.FIELD PIECE.X,PIECE.Y-1,PIECE.X+3,PIECE.Y+3
            ENDIF
            SOFTDROP = SOFTDROP+1
        ENDIF
        IF MID$(BUTTONS$,4,1) = "1" AND BUMP("LEFT") = 0 THEN
            MOVE "LEFT"
            IF GFX = 1 THEN
                GFX.PIECE.MOVE
            ELSE
                DRAW.FIELD PIECE.X+1,PIECE.Y,PIECE.X+3,PIECE.Y+3
            ENDIF
        ENDIF
        IF MID$(BUTTONS$,3,1) = "1" AND BUMP("RIGHT") = 0 THEN
            MOVE "RIGHT"
            IF GFX = 1 THEN
                GFX.PIECE.MOVE
            ELSE
                DRAW.FIELD PIECE.X-1,PIECE.Y,PIECE.X+3,PIECE.Y+3
            ENDIF
        ENDIF
        IF MID$(BUTTONS$,2,1) = "1" AND BUMP("RRIGHT") = 0 THEN
            ROTATE "LEFT"
            IF GFX = 1 THEN
                GFX.PIECE.MOVE
            ELSE
                DRAW.FIELD PIECE.X-1,PIECE.Y,PIECE.X+3,PIECE.Y+3
                DRAW.PIECE
            ENDIF
          ENDIF
    ENDIF
END SUB

SUB GAMEOVER
    IF GFX = 1 THEN
        FOR j = 20 TO 1 STEP -1
            LINE(GFX.FIELD.X+(16*1),GFX.FIELD.Y+(16*j))-(GFX.FIELD.X+(16*11)-1,GFX.FIELD.Y+(16*(j+1))-1),0,BF
            PAUSE 16.7
        NEXT
        PRINT @(188,144) "********"
        PRINT @(188,160) "* GAME *"
        PRINT @(188,176) "* OVER *"
        PRINT @(188,192) "********"
        PAUSE 1000
    ELSE
        PRINT @(48,60) "********"
        Print @(48,72) "* TILT *"
        PRINT @(48,84) "********"
    ENDIF
    HISCORE
END SUB

SUB HISCORE
    LOCAL HISCORE
    LOCAL HILINES
    LOCAL TOPSCORE(9)
    LOCAL TOPLINES(9)
    LOCAL TOPNAME$(9) LENGTH 8
    PRINT @(168,242) "ENTER NAME:"
    PLAYER$ = GFX.FORMINPUT$(168,260,8)
    ENDIF
    OPEN "HISCORE.DAT" FOR APPEND AS #4
    PRINT #4, FORMAT$(SCORE);","FORMAT$(LINES);",";PLAYER$;","
    CLOSE #4
    FOR i = 0 TO 5
        OPEN "HISCORE.DAT" FOR INPUT AS #4
        DO WHILE EOF(#4) = 0
            INPUT #4,HISCORE,HILINES,PLAYER$
            IF i > 0 THEN
                IF HISCORE > TOPSCORE(i) AND HISCORE < TOPSCORE(i-1) THEN
                    TOPSCORE(i) = HISCORE
                    TOPLINES(i) = HILINES
                    TOPNAME$(i) = PLAYER$
                ENDIF
            ELSE
                IF HISCORE > TOPSCORE(i) THEN
                    TOPSCORE(i) = HISCORE
                    TOPLINES(i) = HILINES
                    TOPNAME$(i) = PLAYER$
                ENDIF
            ENDIF
        LOOP
        CLOSE #4
    NEXT
    GFX.CLEAR.FIELD
    FOR i = 0 TO 5
        PRINT @(GFX.FIELD.X+15,GFX.FIELD.Y+16+(48*i)) "#";FORMAT$(i+1);" "TOPNAME$(i)
        PRINT @(GFX.FIELD.X+15,GFX.FIELD.Y+32+(48*i)) " SCORE";TOPSCORE(i)
        PRINT @(GFX.FIELD.X+15,GFX.FIELD.Y+48+(48*i)) " LINES";TOPLINES(i)
    NEXT
    DO
        KEY$ = INKEY$
    LOOP UNTIL KEY$ <> ""                
END SUB

SUB PAUSEGAME
    DO
    KEY$ = INKEY$
    LOOP UNTIL KEY$ = CHR$(27)
END SUB
        
Sub GAME
    IF GFX = 1 THEN
        GFX.DRAW.BORDER
        GFX.CLEAR.FIELD
    ENDIF
    IF GFX = 1 THEN
        STARTLEVEL = GFX.LEVELSELECT()
        GFX.CLEAR.FIELD
    ENDIF
    Timer = 0
    SCORE = 0
    LEVEL = STARTLEVEL
    LINES = 0
    GAME.INIT
    NEWPREVIEW(Cint(Rnd()*100) Mod (6))
    IF GFX = 1 THEN
        GFX.DRAW.PREVIEW
        GFX.DRAW.SCORE
    ELSE
        DRAW.FIELD 0,0,11,21
        DRAW.PREVIEW
        DRAW.SCORE
    ENDIF
    Do While OVERLAP() = 0
        FRAMES
        TIMER = 0
        GETPIECE
        PLACEPIECE
        NEWPREVIEW(Cint(Rnd()*100) Mod (6))
        IF GFX = 1 THEN
            GFX.PIECE.NEW
            GFX.DRAW.PREVIEW
        ELSE
            DRAW.PIECE
            DRAW.PREVIEW
            DRAW.FIELD PIECE.X,PIECE.Y,PIECE.X+3,PIECE.Y+3
        ENDIF
        SOFTDROP = 0
        DO WHILE BUMP("DOWN") = 0
            MOVE "DOWN"
            IF GFX = 1 THEN
                GFX.PIECE.MOVE
            ELSE
                DRAW.FIELD PIECE.X,PIECE.Y-1,PIECE.X+3,PIECE.Y+3
            ENDIF
            Do While TIMER < COUNT
                KEYPRESS
                CONTROLLER
            LOOP
            TIMER = 0
        LOOP
        SCORE = SCORE+SOFTDROP
        PETRIFY
        IF GFX = 1 THEN
            GFX.PIECE.PASTE
        ELSE
            DRAW.FIELD PIECE.X,PIECE.Y,PIECE.X+3,PIECE.Y+3
        ENDIF
        LINEDOWN
        IF GFX = 1 THEN
            GFX.DRAW.SCORE
        ELSE
            DRAW.SCORE
        ENDIF
    Loop
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

DO
    GAME
    GAMEOVER
    IF GFX = 1 THEN
        LOOP UNTIL GFX.NEWGAME() = 0
    ENDIF
SPRITE UNLOAD
CLEAR
CLS
END       
 