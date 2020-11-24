CENTRE.X = MM.HRES/2
CENTRE.Y = MM.VRES/2
POINTS = 1
LINES = 1
INCRE = 15
InLine$ = ""
MAGX = 1
MEMMAX = 1024

SUB REFORMAT
    Input "ENTER .OBJ FILE,MAGx ",FILENAME$,MAGX
    IF MAGX = 0 THEN
        MAGX = 1
    ENDIF
    Open FILENAME$ For INPUT As #3
    OPEN "OUTPUT.TMP" FOR OUTPUT AS #4
    DO 
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
    Open "OUTPUT.TMP" FOR INPUT AS #3
    ANGLE = 0
    IF POINTS > MEMMAX THEN
        POINTS = MEMMAX
    ENDIF
    DIM POINTS(POINTS,3)
    FOR i = 1 TO POINTS
        INPUT #3,a$,b,c,d
'        PRINT i
            IF a$ = "v" THEN
                b = b * MAGX
                c = c * MAGX
                d = d * MAGX
'                y=(c*Cos(Rad(-INCRE)))-(d*Sin(Rad(-INCRE)))
'                z=(c*Sin(Rad(-INCRE)))+(d*Cos(Rad(-INCRE)))
'                x=(b*Cos(Rad(135)))-(d*Sin(Rad(135)))
'                z=(b*Sin(Rad(135)))+(d*Cos(Rad(135)))
                    b = b - 50
                    c = c - 50
'                    d = z' + 150
'                PIXEL(CENTRE.X+b,CENTRE.Y-c)=7
                ANGLE=DEG(ATN(b/(240+d)))
'                PRINT ANGLE;
                b = (TAN(RAD(ANGLE))*240)
                ANGLE=DEG(ATN(c/(240+d)))
'                PRINT ANGLE;
                c = (TAN(RAD(ANGLE))*240)
                PIXEL(CENTRE.X+b,CENTRE.Y-c)=7
                POINTS(i,0) = b
                POINTS(i,1) = c
                POINTS(i,2) = d
            ENDIF
    NEXT
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
    
REFORMAT
'PROCVERTEX
'DRAWLINE
'KILL "OUTPUT.TMP"
END