' PC Benchmark tests devised by US magazine Kilobaud in 1977.
' Subsequently adopted by the UK magazine Personal Computer World.
' Ported to MMBasic by CircuitGizmos on The Back Shed.
' See The Back Shed thread "BASIC Speed Benckmark Tests" 

Print "Maximite Benchmark tests"
Print " "

Print "Benchmark 1"
Timer = 0
For j = 1 To 1000
Next j
Print Timer / 1000
Print " "

Print "Benchmark 2"
Timer = 0
j = 0
BM2:
j = j+1
If j < 1000 GoTo BM2
Print Timer / 1000
Print " "

Print "Benchmark 3"
Timer = 0
j = 0
BM3:
j = j+1
a = j/j*j+j-j
If j < 1000 GoTo BM3
Print Timer / 1000
Print " "

Print "Benchmark 4"
Timer = 0
j = 0
BM4:
j = j+1
a = j/2*3+4-5
If j < 1000 GoTo BM4
Print Timer / 1000
Print " "

Print "Benchmark 5"
Timer = 0
j = 0
BM5:
j = j+1
m = j/2*3+4-5
GoSub 4000
If j < 1000 GoTo BM5
Print Timer / 1000
Print " "

Print "Benchmark 6"
Timer = 0
j = 0
Dim ray(5)
BM6:
j = j+1
m = j/2*3+4-5
GoSub 4000
For q = 1 To 5
Next q
If j < 1000 GoTo BM6
Print Timer / 1000
Print " "

Print "Benchmark 7"
Timer = 0
j = 0
Dim ray2(5)
BM7:
j = j+1
m = j/2*3+4-5
GoSub 4000
For q = 1 To 5
ray2(q) = m
Next q
If j < 1000 GoTo BM7
Print Timer / 1000
Print " "

Print "Benchmark 8"
Timer = 0
j = 0
BM8:
j = j+1
m = j^2
blog = Log(j)
csin = Sin(j)
If j < 1000 GoTo BM8
Print Timer / 1000

End

4000 Return
