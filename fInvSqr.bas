Function Qrsqrt(number)
    Dim i%
    Dim x2,y
    Dim yaddr% = Peek(VarAddr y)
    Const threehalfs = 1.5

    x2 = number * 0.5
    y = number
    i% = Peek(Integer yaddr%)
    i% = &H5FE6EB3BD314E800 - (i% >> 1)
    Poke Integer yaddr%,i%
    y = y * (threehalfs-(x2*y*y))
    y = y * (threehalfs-(x2*y*y))
    Qrsqrt = y
End Function

Timer = 0
Print Qrsqrt(1337)
Print Timer
Timer = 0
Print 1/Sqr(1337)
Print Timer
