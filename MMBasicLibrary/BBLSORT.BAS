    ' Bubble Sort Routine  copied from GW-BASIC online manual
    ' by Hugh Buckle - Jan 2012
    ' A modified version to show the use of a Defined Subroutine
    ' Requires MMBasic 3.1 or later

    ' It sorts a text array into ascending sequence and is reasonably
    ' efficient for small amounts of data.
    ' This version sorts a text array; if yours is numeric just
    ' remove the dollar signs and Lcase$().

    ' This sample sorts the names in the DATA statements.

    ' Note that the sorted sequence is as you would find in a dictionary,
    ' telephone directory, Excel or Word. That is, the sort is
    ' case insensitive. If you omit the Lcase() function in the
    ' bubble sort routine you get the normal BASIC sort sequence which
    ' IS case sensitive, so all the words starting with a Capital letter
    ' would appear before those which don't.
    ' It's up to you which you choose.


    ' The next 5 lines just provide some data to sort in array A$()
    Data Hugh,Andrew,Geoffrey,Victor,George,Isaac,James
    Data John,ABB,aab,AC,Fred,Lance,Joe,William,Aaron,aardvark

    j=17
    Dim A$(j)
    Print "Unsorted: ";
    For i = 1 To j
      Read A$(i)
      Print A$(i);",";
      If i=9 Then Print: Print "          ";
    Next
    Print
    Print

   '  Invoke the bubble sort routine
    GoSub BblSort

    ' Show the result
    Print "Sorted:   ";
    For i = 1 To j
      Print A$(i);",";
      If i=9 Then Print: Print "          ";
    Next
    End


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
      If LCase$(A$(n)) > LCase$(A$(n+1)) Then
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
