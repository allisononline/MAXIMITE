SUB READFILE
    MEMMAX = 1024
    Input "ENTER .OBJ FILE: ",FILENAME$
    INLINE$ = ""
    COUNTPOINTSLINES(FILENAME$)
    INITPOINTS(POINTS)
    INITLINES(LINES)
    Open FILENAME$ For RANDOM As #3
    SEEK #3,1
    POINTCNT = 0
    LINECNT = 0
    PRINT ""
    PRINT "LOADING POINTS & LINES"
    DO WHILE EOF(#3) = 0
        LINE INPUT #3,INLINE$
        IF WORD$(INLINE$,1) = "v" THEN
            FOR v = 0 TO 2
                POINTS(POINTCNT,v) = VAL(WORD$(INLINE$,v+2))
            NEXT
            POINTCNT = POINTCNT + 1
        ELSEIF WORD$(INLINE$,1) = "f" OR WORD$(INLINE$,1) = "l" THEN
            FOR f = 0 TO 2
                LINES(LINECNT,f) = VAL(WORD$(INLINE$,f+2))
            NEXT           
            LINECNT = LINECNT + 1
        ENDIF
        PROGRESS(LOF(#3),LOC(#3))
    LOOP 
    CLOSE #3
    NORMALISE
END SUB

SUB LOWMEM
    CLEAR
    POINTSTART = 0
    LINESTART = 0
    PLACEHOLD = 0
    DIM POINTS(3,3)
    Input "ENTER .OBJ FILE: ",FILENAME2$
    COUNTPOINTSLINES(FILENAME2$)
    OPEN FILENAME2$ FOR RANDOM AS #4
    SEEK #4,1
    DO
        LINE INPUT #4,INLINE2$
    LOOP UNTIL WORD$(INLINE2$,1) = "v"
    POINTSTART = LOC(#4) - LEN(INLINE2$)
    SEEK #4,1
    DO
        LINE INPUT #4,INLINE2$
    LOOP UNTIL WORD$(INLINE2$,1) = "f" OR WORD$(INLINE2$,1) = "l"
    LINESTART = LOC(#4) - LEN(INLINE2$)
    SEEK #4,LINESTART
    x = 0
    CLS
    DO UNTIL x => LINES OR EOF(#4) <> 0
        LINE INPUT #4,INLINE2$
        IF WORD$(INLINE2$,1) = "f" OR WORD$(INLINE2$,1) = "l" THEN
            PLACEHOLD = LOC(#4)
            FOR y = 0 TO 2
                GOTOLINE = VAL(WORD$(INLINE2$,y+2))
                SEEK #4,POINTSTART
                FOR z = 1 TO GOTOLINE
                    DO
                        LINE INPUT #4,INLINE3$
                    Loop UNTIL WORD$(INLINE3$,1) = "v"
                NEXT
                FOR w = 0 TO 2
                    POINTS(y,w) = VAL(WORD$(INLINE3$,w+2))
                NEXT
            NEXT
            NORMALISE
            LOWMEMLINES
            SEEK #4,PLACEHOLD
            x = x + 1
        ENDIF
    LOOP
    CLOSE #4
END SUB

SUB LOWMEMLINES
    MAGX = 150
    CENTRE.X = MM.HRES/2
    CENTRE.Y = MM.VRES/2
    x1 = CENTRE.X+FOV((POINTS(0,0)*MAGX)+XOFFSET,-(POINTS(0,2)*MAGX)+ZOFFSET)
    y1 = CENTRE.Y-FOV((POINTS(0,1)*MAGX)+YOFFSET,-(POINTS(0,2)*MAGX)+ZOFFSET)
    x2 = CENTRE.X+FOV((POINTS(1,0)*MAGX)+XOFFSET,-(POINTS(1,2)*MAGX)+ZOFFSET)
    y2 = CENTRE.Y-FOV((POINTS(1,1)*MAGX)+YOFFSET,-(POINTS(1,2)*MAGX)+ZOFFSET)
    LINE(x1,y1)-(x2,y2)
    IF POINTS(2,0) <> 0 THEN
        x1 = CENTRE.X+FOV((POINTS(1,0)*MAGX)+XOFFSET,-(POINTS(1,2)*MAGX)+ZOFFSET)
        y1 = CENTRE.Y-FOV((POINTS(1,1)*MAGX)+YOFFSET,-(POINTS(1,2)*MAGX)+ZOFFSET)
        x2 = CENTRE.X+FOV((POINTS(2,0)*MAGX)+XOFFSET,-(POINTS(2,2)*MAGX)+ZOFFSET)
        y2 = CENTRE.Y-FOV((POINTS(2,1)*MAGX)+YOFFSET,-(POINTS(2,2)*MAGX)+ZOFFSET)
        LINE(x1,y1)-(x2,y2)
    ENDIF
END SUB

SUB PROGRESS(TOTAL,POSITION)
    PERCENT = FIX((POSITION/TOTAL)*100)
    BARGRPH$ = SPACE$(22)
    POKE VAR BARGRPH$,1,91
    POKE VAR BARGRPH$,22,93
    FOR l = 2 TO FIX(PERCENT/5)+1
        POKE VAR BARGRPH$,l,35
    NEXT
    PRINT @(0,MM.VPOS) BARGRPH$+" "+FORMAT$(PERCENT)+"%";
END SUB

SUB COUNTPOINTSLINES(FILENAME2$)
    POINTS = 0
    LINES = 0
    Open FILENAME2$ For INPUT As #3
    PRINT "COUNTING POINTS & LINES"
    DO WHILE EOF(#3) = 0
        Line Input #3,INLINE$
        IF WORD$(INLINE$,1) = "v" THEN
            POINTS = POINTS + 1
        ELSEIF WORD$(INLINE$,1) = "f" OR WORD$(INLINE$,1) = "l" THEN
            LINES = LINES + 1
        ENDIF
        PROGRESS(LOF(#3),LOC(#3))
    LOOP
    CLOSE #3
END SUB

SUB INITPOINTS(NUMPOINTS)
    IF NUMPOINTS > MEMMAX THEN
        NUMPOINTS = MEMMAX
    ENDIF
    DIM POINTS(NUMPOINTS,3)
END SUB

SUB INITLINES(NUMLINES)
    IF NUMLINES > MEMMAX THEN
        NUMLINES = MEMMAX
    ENDIF
    DIM LINES(NUMLINES,3)
END SUB

FUNCTION WORD$(INLINE3$,WORDNUM)
    IF WORDNUM < 1 THEN
        WORDNUM = 1
    ENDIF
    LOCAL k = 0
    WORD$ = ""
    START = 1
    FOR i = 1 TO WORDNUM
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
    NEXT
    IF k > 0 THEN
        WORD$ = MID$(INLINE3$,START,k)
    ENDIF
END FUNCTION

Sub ROTATE(DIR$,INCRE)
    IF INCRE = 0 THEN
        INCRE = 15
    ENDIF
    For i = 0 To POINTS - 1
        If DIR$ = "ZMINUS" Then
            x = (POINTS(i, 0) * Cos(Rad(INCRE))) - (POINTS(i, 1) * Sin(Rad(INCRE)))
            y = (POINTS(i, 0) * Sin(Rad(INCRE))) + (POINTS(i, 1) * Cos(Rad(INCRE)))
            POINTS(i, 0) = x
            POINTS(i, 1) = y
        ElseIf DIR$ = "ZPLUS" Then
            x = (POINTS(i, 0) * Cos(Rad(-INCRE))) - (POINTS(i, 1) * Sin(Rad(-INCRE)))
            y = (POINTS(i, 0) * Sin(Rad(-INCRE))) + (POINTS(i, 1) * Cos(Rad(-INCRE)))
            POINTS(i, 0) = x
            POINTS(i, 1) = y
        ElseIf DIR$ = "XMINUS" Then
            y = (POINTS(i, 1) * Cos(Rad(INCRE))) - (POINTS(i, 2) * Sin(Rad(INCRE)))
            z = (POINTS(i, 1) * Sin(Rad(INCRE))) + (POINTS(i, 2) * Cos(Rad(INCRE)))
            POINTS(i, 1) = y
            POINTS(i, 2) = z
        ElseIf DIR$ = "XPLUS" Then
            y = (POINTS(i, 1) * Cos(Rad(-INCRE))) - (POINTS(i, 2) * Sin(Rad(-INCRE)))
            z = (POINTS(i, 1) * Sin(Rad(-INCRE))) + (POINTS(i, 2) * Cos(Rad(-INCRE)))
            POINTS(i, 1) = y
            POINTS(i, 2) = z
        ElseIf DIR$ = "YMINUS" Then
            x = (POINTS(i, 0) * Cos(Rad(INCRE))) - (POINTS(i, 2) * Sin(Rad(INCRE)))
            z = (POINTS(i, 0) * Sin(Rad(INCRE))) + (POINTS(i, 2) * Cos(Rad(INCRE)))
            POINTS(i, 0) = x
            POINTS(i, 2) = z
        ElseIf DIR$ = "YPLUS" Then
            x = (POINTS(i, 0) * Cos(Rad(-INCRE))) - (POINTS(i, 2) * Sin(Rad(-INCRE)))
            z = (POINTS(i, 0) * Sin(Rad(-INCRE))) + (POINTS(i, 2) * Cos(Rad(-INCRE)))
            POINTS(i, 0) = x
            POINTS(i, 2) = z
        EndIf
    Next
End Sub

SUB NORMALISE
    HIGHEST = 0
    FOR i = 0 TO POINTS - 1
        FOR j = 0 TO 2
            IF ABS(POINTS(i,j)) > HIGHEST THEN
                HIGHEST = POINTS(i,j)
            ENDIF
        NEXT
    NEXT
    FOR i = 0 TO POINTS - 1
        FOR j = 0 TO 2
            POINTS(i,j) = POINTS(i,j) / HIGHEST
        NEXT
    NEXT
END SUB

SUB CENTREIZE
    HIGHEST = 0
    LOWEST = 0
    RANGE = 0
    FOR j = 0 TO 2
        FOR i = 0 TO POINTS - 1
            IF POINTS(i,j) > HIGHEST THEN
                HIGHEST = POINTS(i,j)
            ENDIF
            IF POINTS(i,j) < LOWEST THEN
                LOWEST = POINTS(i,j)
            ENDIF
        NEXT
        RANGE = HIGHEST - LOWEST
        FOR i = 0 TO POINTS - 1
            POINTS(i,j) = POINTS(i,j) - (RANGE/2)
        NEXT
    NEXT
END SUB

Function FOV(COORD1,COORD2)
    DISTANCE = 240
    ANGLE = Atn(COORD1 / (DISTANCE + COORD2))
    FOV = (Tan(ANGLE) * DISTANCE)
End Function

SUB DRAWLINE(MAGX,XOFFSET,YOFFSET,ZOFFSET)
    LOCAL CURRENT(6)
    CENTRE.X = MM.HRES/2
    CENTRE.Y = MM.VRES/2
    IF MAGX = 0 THEN
        MAGX = 150
    ENDIF
    FOR i = 0 TO LINES - 1
        FOR j = 0 TO 2
            CURRENT(j) = POINTS(LINES(i,0)-1,j) * MAGX
            CURRENT(j+3) = POINTS(LINES(i,1)-1,j) * MAGX
        NEXT
        x1 = CENTRE.X+FOV(CURRENT(0)+XOFFSET,-CURRENT(2)+ZOFFSET)
        y1 = CENTRE.Y-FOV(CURRENT(1)+YOFFSET,-CURRENT(2)+ZOFFSET)
        x2 = CENTRE.X+FOV(CURRENT(3)+XOFFSET,-CURRENT(5)+ZOFFSET)
        y2 = CENTRE.Y-FOV(CURRENT(4)+YOFFSET,-CURRENT(5)+ZOFFSET)
        LINE(x1,y1)-(x2,y2)
        IF LINES(i,2) > 0 THEN
            FOR j = 0 TO 2
                CURRENT(j) = POINTS(LINES(i,1)-1,j) * MAGX
                CURRENT(j+3) = POINTS(LINES(i,2)-1,j) * MAGX
            NEXT
            x1 = CENTRE.X+FOV(CURRENT(0)+XOFFSET,-CURRENT(2)+ZOFFSET)
            y1 = CENTRE.Y-FOV(CURRENT(1)+YOFFSET,-CURRENT(2)+ZOFFSET)
            x2 = CENTRE.X+FOV(CURRENT(3)+XOFFSET,-CURRENT(5)+ZOFFSET)
            y2 = CENTRE.Y-FOV(CURRENT(4)+YOFFSET,-CURRENT(5)+ZOFFSET)
            LINE(x1,y1)-(x2,y2)
        ENDIF
    NEXT
END SUB

Sub KEYPRESS
    KEYPRESS$ = InKey$
    If KEYPRESS$ <> "" Then
        If KEYPRESS$ = "q" Then
            ROTATE("ZMINUS")
            CLS
            DRAWLINE()
        ElseIf KEYPRESS$ = "e" Then
            ROTATE("ZPLUS")
            CLS
            DRAWLINE()
        ElseIf KEYPRESS$ = "w" Then
            ROTATE("XMINUS")
            CLS
            DRAWLINE()
        ElseIf KEYPRESS$ = "s" Then
            ROTATE("XPLUS")
            CLS
            DRAWLINE()
        ElseIf KEYPRESS$ = "a" Then
            ROTATE("YMINUS")
            CLS
            DRAWLINE()
        ElseIf KEYPRESS$ = "d" Then
            ROTATE("YPLUS")
            CLS
            DRAWLINE()
        EndIf
    EndIf
End Sub

SUB SPHERIFY
    FOR i = 0 TO POINTS - 1
        L = SQR(ABS(POINTS(i,0))+ABS(POINTS(i,1))+ABS(POINTS(i,2)))
        FOR j = 0 TO 2
            POINTS(i,j) = POINTS(i,j) * (1/L)
        NEXT
    NEXT
END SUB

SUB ROUND
    DO
        CLS
        DRAWLINE
        SPHERIFY
    LOOP
END SUB

SUB DEMO
    DO
        KEYPRESS
    LOOP
END SUB


