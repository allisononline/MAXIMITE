    ' Bubble Sort Routine  copied from GW-BASIC online manual
    ' by Hugh Buckle - Jan 2012
    ' Requires MMBasic 3.1 or later


BblSort:
    ' Bubble sort routine
    ' Runs sequentially through an array testing each element against the
    ' next. If it is greater than the next, the two values are swapped.
    ' This process is repeated until no more swaps are made.
    '   A$() is the array to be sorted
    '   j is the number of elements in the array
    Flips = 1
    Do
      Flips = 0
      For n=1 To j-1
      If A$(n) > A$(n+1) Then
        SWAP A$(n),A$(n+1)
        Flips = 1
      EndIf
      Next
    Loop While Flips = 1
    Return

Sub SWAP X$,Y$
    ' This function mimics GW-Basic SWAP X,Y function
    Local Z$
    Z$ = X$
    X$ = Y$
    Y$ = Z$
End Sub
