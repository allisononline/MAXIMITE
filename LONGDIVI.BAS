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

FUNCTION SEQUENCE
    i = 1
    DO 
        SEQUENCE = VAL(MID$(FACE$,COLUMN,i))
        IF DIVISOR > SEQUENCE THEN
            FACE$ = FACE$ + "0"
        ENDIF
        i = i + 1
    LOOP UNTIL SEQUENCE => DIVISOR 
END FUNCTION

DIVIDEND = VAL(WORD$(MM.CMDLINE$,1))
DIVISOR = VAL(WORD$(MM.CMDLINE$,2))
IF DIVISOR = 0 THEN
    ERROR "CANNOT DIVIDE BY ZERO"
ENDIF
FACE$ = STR$(DIVIDEND)
COLUMN = 1
PRINT DIVIDEND
PRINT DIVISOR
WORKING = SEQUENCE()
DO
    PRINT WORKING
    WORKING = WORKING - DIVISOR
LOOP UNTIL WORKING < DIVISOR
PRINT WORKING
