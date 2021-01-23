10 ' PWM1.bas using Sound output pin
20 ' Keith Williams, Ron Pugh
30 Cls
40 Line(100, 100) - (300, 150), 1, B ' draws a box
50 Font #2 ' big print
60 Duty = 30 ' init to 30/70 PWM
70           ' 200 Hz duration about 33 minutes 50 % duty
80 '
90 GoSub 200
100 I$=Inkey$ : If I$="" Then GoTo 100 ' Test for keyboard input until key press
110 If I$="z" Then Duty = 15
120 If I$="x" Then Duty = 25
130 If I$="c" Then Duty = 40
140 If I$="v" Then Duty = 50
150 If I$="b" Then Duty = 60
160 If I$="n" Then Duty = 75
170 If I$="m" Then Duty = 100
180 GoTo 80
190 '
200 ' Subroutine to sound and print the duty cycle
210 Sound 200, 2000000, Duty
220 Print @(125,120) "Speed ";Duty;"% "
230 Return
