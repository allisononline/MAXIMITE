10 CENTRE.X = (MM.HRes/2)
20 CENTRE.Y = (MM.VRes/2)
30 UNIT = 50
40 ANGLE.X = 0
50 ANGLE.Y = 0
60 ANGLE.Z = 0
62 INIT.X = UNIT
64 INIT.Y = UNIT
66 INIT.Z = UNIT
68 POINT.X = INIT.X
70 POINT.Y = INIT.Y
71 POINT.Z = INIT.Z
70 DRAW.X = INIT.X
80 DRAW.Y = INIT.Y
82 INCRE = 15
84 LENGTH = UNIT
86 DIM POINT(8,3)
88 i = 0
90 x = 0
92 y = 0
94 z = 0
98 DO WHILE i < 8
100           IF i MOD(2) > 0 THEN
102                   POINT(i,2) = UNIT
104           ELSE
106                   POINT(i,2) = (0-UNIT)
108           ENDIF
100           IF i MOD(4) > 1 THEN
102                   POINT(i,1) = UNIT
104           ELSE
106                   POINT(i,1) = (0-UNIT)
108           ENDIF
100           IF i > 3 THEN
102                   POINT(i,0) = UNIT
104           ELSE
106                   POINT(i,0) = (0-UNIT)
108           ENDIF
114       i = i + 1
116 LOOP
118 i = 0
118 DO
120           CLS
119           i=0
120           DO WHILE i < 8
352                  PRINT ANGLE.X,ANGLE.Y,ANGLE.Z
354                  PRINT POINT(i,0),POINT(i,1),POINT(i,2)
358                  i=i+1
360           LOOP
350 LINE(CENTRE.X+POINT(0,0),CENTRE.Y+POINT(0,1))-(CENTRE.X+POINT(1,0),CENTRE.Y+POINT(1,1))
350 LINE(CENTRE.X+POINT(4,0),CENTRE.Y+POINT(4,1))-(CENTRE.X+POINT(5,0),CENTRE.Y+POINT(5,1))
350 LINE(CENTRE.X+POINT(0,0),CENTRE.Y+POINT(0,1))-(CENTRE.X+POINT(4,0),CENTRE.Y+POINT(4,1))
350 LINE(CENTRE.X+POINT(1,0),CENTRE.Y+POINT(1,1))-(CENTRE.X+POINT(5,0),CENTRE.Y+POINT(5,1))
350 LINE(CENTRE.X+POINT(2,0),CENTRE.Y+POINT(2,1))-(CENTRE.X+POINT(3,0),CENTRE.Y+POINT(3,1))
350 LINE(CENTRE.X+POINT(6,0),CENTRE.Y+POINT(6,1))-(CENTRE.X+POINT(7,0),CENTRE.Y+POINT(7,1))
350 LINE(CENTRE.X+POINT(2,0),CENTRE.Y+POINT(2,1))-(CENTRE.X+POINT(6,0),CENTRE.Y+POINT(6,1))
350 LINE(CENTRE.X+POINT(3,0),CENTRE.Y+POINT(3,1))-(CENTRE.X+POINT(7,0),CENTRE.Y+POINT(7,1))
350 LINE(CENTRE.X+POINT(0,0),CENTRE.Y+POINT(0,1))-(CENTRE.X+POINT(2,0),CENTRE.Y+POINT(2,1))
350 LINE(CENTRE.X+POINT(1,0),CENTRE.Y+POINT(1,1))-(CENTRE.X+POINT(3,0),CENTRE.Y+POINT(3,1))
350 LINE(CENTRE.X+POINT(4,0),CENTRE.Y+POINT(4,1))-(CENTRE.X+POINT(6,0),CENTRE.Y+POINT(6,1))
350 LINE(CENTRE.X+POINT(5,0),CENTRE.Y+POINT(5,1))-(CENTRE.X+POINT(7,0),CENTRE.Y+POINT(7,1))
112           INPUT keypress$         
112           If keypress$ <> "" THEN
114                  i = 0
116                  DO WHILE i < 8
117                  If Keypress$ = "q" OR Keypress$ = "e" Then
118    x=(POINT(i,0)*COS(RAD(15)))-(POINT(i,1)*SIN(RAD(15)))
118    y=(POINT(i,0)*SIN(RAD(15)))+(POINT(i,1)*COS(RAD(15)))
120                     POINT(i,0) = x
122                     POINT(i,1) = y
119                  ElseIf Keypress$ = "w" OR Keypress$ = "s" Then
118    y=(POINT(i,1)*COS(RAD(15)))-(POINT(i,2)*SIN(RAD(15)))
118    z=(POINT(i,1)*SIN(RAD(15)))+(POINT(i,2)*COS(RAD(15)))
120                     POINT(i,1) = y
122                     POINT(i,2) = z
119                  ElseIf Keypress$ = "a" OR Keypress$ = "d" Then
118    x=(POINT(i,0)*COS(RAD(15)))-(POINT(i,2)*SIN(RAD(15)))
118    z=(POINT(i,0)*SIN(RAD(15)))+(POINT(i,2)*COS(RAD(15)))
120                     POINT(i,0) = x
122                     POINT(i,2) = z
120                  EndIf
364                  i = i + 1
366                  LOOP
366             EndIf
367 Loop
