10 ' Count Demo, Mick Gulovsen, Ron Pugh
20 '
30 Setpin 11,5
40 A=pin(11)
50 Print A
60 B=pin(11)
70 IF B>A then A=B: goto 50
80 goto 60