5 Rem NUMBERS BY FRANK .P. DEC 83....
10 A$=""
20 Y=1
30 X=Int(Rnd*(10))
40 A$=A$+(Str$(X))
50 ? A$
60 Pause 6000/Y
70 Cls
80 Input B$
90 If A$ <> B$ Then GoTo 190
100 If Y<5 Then ? "THATS""S O.K."
110  Y=Y +1
120 If Y>=5 And Y<8 Then ? "WELL DONE"
130 If Y>=8 Then ? "EXCELLENT"
140 GoTo 30
190 ? "TOO BAD"
200 ? A$," WAS THE ANSWER"
210 ? B$, "WAS YOUR ANSWER"
220 ? "YOU LASTED FOR ";Y;"GOES"
