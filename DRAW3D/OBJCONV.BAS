CENTRE.X = MM.HRES/2
CENTRE.Y = MM.VRES/2
POINTS = 0
LINES = 0
INCRE = 0
InLine$ = ""

CLEAR
Input "ENTER .OBJ FILE, MAGx ",FILENAME$,MAGX
Open FILENAME$ For INPUT As #3
OPEN "OUTPUT.TMP" FOR OUTPUT AS #4
DO 
    Line Input #3,INLINE$
    IF LEFT$(INLINE$,2)="v " OR LEFT$(INLINE$,2)="f " OR LEFT$(INLINE$,2)="l " THEN 
        IF LEFT$(INLINE$,2)="v " THEN
            POINTS = POINTS + 1
        ELSE
            LINES = LINES + 1
        ENDIF
        FOR i = 1 TO LEN(INLINE$)
            IF MID$(INLINE$,i,1) = " " THEN
                DO
                    i = i + 1
                LOOP UNTIL MID$(INLINE$,i+1,1) <> " " 
                PRINT #4,",";
'                PRINT ",";
            ELSE
                PRINT #4,MID$(INLINE$,i,1);
'                PRINT MID$(INLINE$,i,1);
            ENDIF
        NEXT
        PRINT #4,",,"
'        PRINT ",,"
    ENDIF
LOOP UNTIL EOF(#3) <> 0
Close #3
Close #4
Open "OUTPUT.TMP" FOR INPUT AS #3
ANGLE = 0
DIM POINTS(POINTS,3)
DIM LINES(LINES,2)
FOR i = 0 TO POINTS
    INPUT #3,a$,b,c,d
        IF a$ = "v" THEN
            b = b * MAGX
            c = c * MAGX
            d = d * MAGX
            POINTS(i,0) = b
            POINTS(i,1) = c
            POINTS(i,2) = d
            y=(c*Cos(Rad(-INCRE)))-(d*Sin(Rad(-INCRE)))
            z=(c*Sin(Rad(-INCRE)))+(d*Cos(Rad(-INCRE)))
                c = y
                d = z
'            PIXEL(CENTRE.X+b,CENTRE.Y-c)=7
            ANGLE=DEG(ATN(b/(240+d)))
'            PRINT ANGLE;
            b = CENTRE.X+(TAN(RAD(ANGLE))*240)
            ANGLE=DEG(ATN((c)/(240+d)))
'            PRINT ANGLE;
            c = CENTRE.Y-(TAN(RAD(ANGLE))*240)
            PIXEL(b,c)=7
        ENDIF
NEXT
x1=0
y1=0
x2=0
y2=0
FOR i = 0 to 50
    INPUT #3, a$,b,c,d
    x1 = CENTRE.X+POINTS(LINES(i,0),b)
    y1 = CENTRE.Y+POINTS(LINES(i,0),c)
    x2 = CENTRE.X+POINTS(LINES(i,1),b)
    y2 = CENTRE.Y+POINTS(LINES(i,1),c)
    LINE(x1,y1)-(x2,y2),7
NEXT
PRINT POINTS,LINES
CLOSE #3
