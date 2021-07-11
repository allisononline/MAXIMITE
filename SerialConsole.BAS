Open "COM1:9600" As #3
Do
    If Loc(#3) > 0 Then
        Print Input$(1,#3);
    EndIf
    If Inkey$ <> "" Then
        Print #3, Inkey$
    EndIf
Loop
    
