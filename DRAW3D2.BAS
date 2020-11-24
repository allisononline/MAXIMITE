SUB BINFORMAT
    Input "ENTER .OBJ FILE",FILENAME$
    Open FILENAME$ For INPUT As #3
    OPEN "OUTPUT.BIN" FOR OUTPUT AS #4
    DO 
    InLine$ = ""
    InData$ = SPACE$(10)
    Line Input #3,INLINE$
    DO WHILE i < LEN(INLINE$)
        j = 0
        DO UNTIL MID$(INLINE$,i,1) = " "
            POKE VAR InData$,j,PEEK(INLINE$,i)
            i = i + 1
            j = j + 1
        LOOP
        PRINT VAL(InData$)
    LOOP
END SUB
        

SUB REFORMAT
    Input "ENTER .OBJ FILE",FILENAME$
    Open FILENAME$ For INPUT As #3
    OPEN "OUTPUT.TMP" FOR OUTPUT AS #4
    DO 
    InLine$ = ""
    Line Input #3,INLINE$
    IF LEFT$(INLINE$,2)="v " OR LEFT$(INLINE$,2)="f " OR LEFT$(INLINE$,2)="l " THEN 
        IF LEFT$(INLINE$,2)="v " THEN
            POINTS = POINTS + 1
        ENDIF
        FOR i = 1 TO LEN(INLINE$)
            IF  MID$(INLINE$,i,1) = "/" THEN
                DO 
                    i = i + 1
                LOOP UNTIL MID$(INLINE$,i,1) = " " OR MID$(INLINE$,i) = ""
            ENDIF
            IF MID$(INLINE$,i,1) = " " THEN
                DO 
                    i = i + 1
                LOOP UNTIL MID$(INLINE$,i,1) <> " " OR MID$(INLINE$,i) = "" 
                PRINT ",";
                PRINT #4,",";
            ENDIF
            PRINT #4,MID$(INLINE$,i,1);
            PRINT MID$(INLINE$,i,1);
        NEXT
        PRINT #4,","
        PRINT ","
    ENDIF
LOOP UNTIL EOF(#3) <> 0
PRINT #4,POINTS
PRINT POINTS
Close #3
Close #4
END SUB

SUB PROCVERTEX
    MAGX = 2
    ANGLE = 0
    INCRE = 15
    POINTS = 114076
    CENTRE.X = MM.HRES/2
    CENTRE.Y = MM.VRES/2
    Open "ROI.TMP" FOR INPUT AS #3
    IF POINTS > MEMMAX THEN
        POINTS = MEMMAX
    ENDIF
    DIM POINTS(POINTS,3)
    i = 0
    DO WHILE i < POINTS
        INPUT #3,a$,b,c,d
        PRINT @(0,0), i
            IF LEFT$(a$,1) = "v" THEN
                b = b * MAGX
                c = c * MAGX
                d = d * MAGX
                y=(c*Cos(Rad(-INCRE)))-(d*Sin(Rad(-INCRE)))
                z=(c*Sin(Rad(-INCRE)))+(d*Cos(Rad(-INCRE)))
                x=(b*Cos(Rad(135)))-(d*Sin(Rad(135)))
                z=(b*Sin(Rad(135)))+(d*Cos(Rad(135)))
                    b = x - 50
                    c = y - 50
                    d = z - 50
                ANGLE=DEG(ATN(b/(240+d)))
                b = (TAN(RAD(ANGLE))*240)
                ANGLE=DEG(ATN(c/(240+d)))
                c = (TAN(RAD(ANGLE))*240)
                PIXEL(CENTRE.X+b,CENTRE.Y-c)=7
                IF i < POINTS THEN
                    POINTS(i,0) = b
                    POINTS(i,1) = c
                    POINTS(i,2) = d
                    i = i + 1
                ENDIF
            ENDIF
    LOOP
END SUB

SUB DRAWLINE
    DO
        INPUT #3,a$,b,c,d
        IF a$ = "f" or a$ = "l" THEN
            x1 = CENTRE.X+POINTS(b,0)
            y1 = CENTRE.Y-POINTS(b,1)
            x2 = CENTRE.X+POINTS(c,0)
            y2 = CENTRE.Y-POINTS(c,1)
            IF b > 0 and b < MEMMAX and c > 0 and c < MEMMAX THEN
                LINE(x1,y1)-(x2,y2),7
                IF d > 0  and d < MEMMAX THEN        
                    x3 = CENTRE.X+POINTS(d,0)
                    y3 = CENTRE.Y-POINTS(d,1)
                    LINE(x2,y2)-(x3,y3),7
                    LINE(x3,y3)-(x1,y1),7
                ENDIF
            ENDIF
        ENDIF
    LOOP UNTIL EOF(#3) <> 0
    CLOSE #3
    CLEAR
END SUB
    
'REFORMAT
'PROCVERTEX
'DRAWLINE
'KILL "OUTPUT.TMP"
'END
