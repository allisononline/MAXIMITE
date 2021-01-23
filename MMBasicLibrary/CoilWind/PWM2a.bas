10 ' PWM2ac.bas using Sound output pin
12 ' Plus nuber of turns (total count)
15 ' Mick Gulovsen, Ron Pugh
20 CLS
30 Line(100, 100) - (250, 150), 1, B1
40 Font 2 : Print@(120, 120) "Speed %"
50 Line(300, 100) - (400, 150), 1, B2
60 Line(100, 250) - (250, 300), 1, B3
70 Font 2 : Print@(105, 270) "Turns Count"
80 Line(300, 250) - (400, 300), 1, B4
90 Setpin 11,5
100 Duty = 30 ' init to 30/70 PWM
110 Sound 200, 200000, Duty ' 200 Hz duration about 33 minutes 30 % duty
130 FONT #2 ' big print
140 I$=Inkey$ : if I$="" then goto 270 'Test for keyboard input until key press
150 If I$="z" Then Duty = 15 : Print @(320, 120) " 15" : GoTo 230
160 If I$="x" Then Duty = 25 : Print @(320, 120) " 25" : GoTo 230
170 If I$="c" Then Duty = 40 : Print @(320, 120) " 40" : GoTo 230
180 If I$="v" Then Duty = 50 : Print @(320, 120) " 50" : GoTo 230
190 If I$="b" Then Duty = 60 : Print @(320, 120) " 60" : GoTo 230 
200 If I$="n" Then Duty = 75 : Print @(320, 120) " 75" : GoTo 230
210 If I$="m" Then Duty = 100 : Print @(320, 120) "100" : GoTo 230
220 GoTo 140
230 Sound 200, 200000, Duty 
250 GoTo 130
260 A=pin(11)
270 if pin(11) <>A then A=Pin(11): Font 2 : Print @(320, 270) A
280 goto 140 ' go back to check for key press