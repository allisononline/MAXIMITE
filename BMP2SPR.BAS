Input Filename$
Open Filename$ For Random As #3
Seek #3, &H02+1
FileSize = ReadNumber(4)
Seek #3, &H0A+1
StartAddress = ReadNumber(4)
Seek #3, &H12+1
Width = ReadNumber(4)
Height = ReadNumber(4)
Seek #3, &H1C+1
ColourDepth = ReadNumber(2)



Function ReadNumber(Length)
    For i = 0 To Length - 1
        ReadNumber = ReadNumber + (Asc(Input$(1,#3))*(&H100^(i-1)))
    Next
End Function

