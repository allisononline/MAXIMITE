CLEAR
STRING$=""
NUM = 0
INPUT FILE$,NUM
OPEN FILE$ FOR RANDOM AS #4
OPEN "OUTPUT.TXT" FOR OUTPUT AS #5
SEEK #4,1
DO
    STRING$ = ""
    LINE INPUT #4, STRING$
    IF LEN(STRING$) > NUM THEN
        STRING$ = MID$(STRING$,NUM+1)
    ELSE
        STRING$ = ""
    ENDIF
'    PRINT LEN(STRING$)-NUM
    PRINT STRING$
    PRINT #5, STRING$
LOOP UNTIL LOC(#4) > LOF(#4)
CLOSE #4
CLOSE #5