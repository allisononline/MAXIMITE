Open "COM1:19200" As #3
Cls

Do
    a$ = ""
    b$ = ""
    a$ = InKey$
    If a$ <> "" Then
        Print #3,a$;
    EndIf
    If Loc(#3) > 0 Then
        b$ = Input$(1,#3)
    EndIf
    If Asc(b$) > 31 Then
        Print b$;
    EndIf
    If Asc(b$) = 13 Then
        Print ""
    EndIf
Loop