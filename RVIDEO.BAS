Open "RVIDEO.DAT" For OUTPUT As #5
    For i = 0 To ((MM.HRes/8)*MM.VRes)
        Print #5, Peek(RVIDEO,i);
    Next
Close #5
