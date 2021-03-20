Input "Input: "; InFile$
Open InFile$ For Input As #3
Open "ARRAYGEN.TMP" For Output As #4
Print #4, "Dim H%(8)"
Print #4, "Dim K%(64)"
For i = 0 To 7
    Input #3,HexVal$
    Print #4,"H%("+Str$(i)+")="+HexVal$;
    If i Mod(4) = 3 Then
        Print #4,""
    Else
        Print #4,":";
    EndIf
Next
For i = 0 To 63
    Input #3,HexVal$
    Print #4,"K%("+Str$(i)+")="+HexVal$;
    If i Mod(4) = 3 Then
        Print #4,""
    Else
        Print #4,":";
    EndIf
Next
Close #3
Close #4