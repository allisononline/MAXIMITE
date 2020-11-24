BYTES = 16

FUNCTION PAD$(STR$,SPC)
    FOR l = 0 TO SPC
        POKE VAR PAD$,l,48
    NEXT
    FOR l = 0 TO SPC
        POKE VAR PAD$,l+(SPC-LEN(STR$)+1),PEEK(VAR STR$,l)
    NEXT
END FUNCTION
    
Input FILE$
Open FILE$ For INPUT As #5
FOR j = 0 to (LOF(#5)-(LOF(#5) MOD(BYTES)))/BYTES
    STRING$ = Input$(BYTES,#5)
    Print PAD$(Bin$(Loc(#5)-1),8)+"  ";
    For i = 1 To BYTES
        Print PAD$(Hex$(Peek(VAR STRING$,i)),2)+" ";
        If i Mod(4) = 0 Then
            Print " ";
        EndIf
        IF PEEK(VAR STRING$,i) < 32 OR PEEK(VAR STRING$,i) > 126 THEN
            POKE VAR STRING$,i,46
        ENDIF
    NEXT
    Print STRING$
    IF j MOD(35) = 34 THEN
        DO
            KEY$ = INKEY$
        LOOP UNTIL KEY$ <> ""
    ENDIF
NEXT
CLOSE #5