
BinSearch:
      ' The Binary search looks for b$ in array a$().
      ' It tests the value at the mid point of the array.
      ' If the value there is greater than the value we are looking for,
      ' the START point is set to where we just looked + 1.
      ' If it was less, then the END point is set to where we just
      ' looked - 1. Then the routine loops. So on each loop we halve
      ' the section of the array to search until the entry is found
      ' or either the Start or End point exceeds the array boundaries.

      ' Note that this search routine expects the array A$() to be in
      ' sequence which is CASE INSENSITIVE. e.g. aa comes before Ab
      ' If the array was sorted case sensitive then remove Lcase$().
      
      ' Call this routine with
      '   Array a$() sorted in ascending sequence
      '   StartIndx and EndIndx set to the lower and upper limits
      '     of a$() you wish to test.
      '   b$ set to the value to find.

      ' BinSearch returns Found = 1 if the value was found, 0 if not.
      ' If found, it returns Indx pointing to the matching element in a$()
 
      Found = 0
      Do
        ' Find mid point of the section of the array to search
        Indx = StartIndx + Fix((EndIndx - StartIndx)/2)
        If Lcase$(b$) = Lcase$(a$(Indx)) Then
          Found = 1
          ElseIf Lcase$(b$) > Lcase$(a$(Indx)) Then
            StartIndx = Indx + 1
          Else
            EndIndx = Indx - 1
        EndIf
      Loop Until Found = 1 Or StartIndx > EndIndx Or EndIndx < StartIndx
      Return

