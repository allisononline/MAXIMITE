10 CENTRE.X = (MM.HRes/2)
20 CENTRE.Y = (MM.VRes/2)
22 DRAW.X.1 = 0
24 DRAW.X.2 = 0
26 DRAW.Y.1 = 0
28 DRAW.Y.2 = 0
30 UNIT = 50
82 INCRE = 15
86 Dim POINT(8,4)
87 Dim VERTEX(12,2)
88 i = 0
90 x = 0
92 y = 0
94 z = 0
96 w = 0
98 Do While i < 8
100           If i Mod(2) > 0 Then
102                   POINT(i,2) = UNIT
104           Else
106                   POINT(i,2) = (0-UNIT)
108           EndIf
100           If i Mod(4) > 1 Then
102                   POINT(i,1) = UNIT
104           Else
106                   POINT(i,1) = (0-UNIT)
108           EndIf
100           If i > 3 Then
102                   POINT(i,0) = UNIT
104           Else
106                   POINT(i,0) = (0-UNIT)
108           EndIf
110           POINT(i,3) = 1
114       i = i + 1
116 Loop
118 VERTEX(0,0) = 0 : VERTEX(0,1) = 1
118 VERTEX(1,0) = 4 : VERTEX(1,1) = 5
118 VERTEX(2,0) = 0 : VERTEX(2,1) = 4
119 VERTEX(3,0) = 1 : VERTEX(3,1) = 5
119 VERTEX(4,0) = 2 : VERTEX(4,1) = 3
119 VERTEX(5,0) = 6 : VERTEX(5,1) = 7
119 VERTEX(6,0) = 2 : VERTEX(6,1) = 6
119 VERTEX(7,0) = 3 : VERTEX(7,1) = 7
119 VERTEX(8,0) = 0 : VERTEX(8,1) = 2
119 VERTEX(9,0) = 1 : VERTEX(9,1) = 3
119 VERTEX(10,0) = 4 : VERTEX(10,1) = 6
119 VERTEX(11,0) = 5 : VERTEX(11,1) = 7
118 Do
112           keypress$ = InKey$
112           If keypress$ <> "" Then
114           CLS
114                  i = 0
116                  Do While i < 8
117                  If keypress$ = "q" Then
118    x=(POINT(i,0)*Cos(Rad(INCRE)))-(POINT(i,1)*Sin(Rad(INCRE)))
118    y=(POINT(i,0)*Sin(Rad(INCRE)))+(POINT(i,1)*Cos(Rad(INCRE)))
120                     POINT(i,0) = x
122                     POINT(i,1) = y
117                  ElseIf keypress$ = "e" Then
118    x=(POINT(i,0)*Cos(Rad(-INCRE)))-(POINT(i,1)*Sin(Rad(-INCRE)))
118    y=(POINT(i,0)*Sin(Rad(-INCRE)))+(POINT(i,1)*Cos(Rad(-INCRE)))
120                     POINT(i,0) = x
122                     POINT(i,1) = y
119                  ElseIf LEFT$(keypress$,1) = "w" Then
118    y=(POINT(i,1)*Cos(Rad(INCRE)))-(POINT(i,2)*Sin(Rad(INCRE)))
118    z=(POINT(i,1)*Sin(Rad(INCRE)))+(POINT(i,2)*Cos(Rad(INCRE)))
120                     POINT(i,1) = y
122                     POINT(i,2) = z
119                  ElseIf LEFT$(keypress$,1) = "s" Then
118    y=(POINT(i,1)*Cos(Rad(-INCRE)))-(POINT(i,2)*Sin(Rad(-INCRE)))
118    z=(POINT(i,1)*Sin(Rad(-INCRE)))+(POINT(i,2)*Cos(Rad(-INCRE)))
120                     POINT(i,1) = y
122                     POINT(i,2) = z
119                  ElseIf LEFT$(keypress$,1) = "a" Then
118    x=(POINT(i,0)*Cos(Rad(INCRE)))-(POINT(i,2)*Sin(Rad(INCRE)))
118    z=(POINT(i,0)*Sin(Rad(INCRE)))+(POINT(i,2)*Cos(Rad(INCRE)))
120                     POINT(i,0) = x
122                     POINT(i,2) = z
119                  ElseIf LEFT$(keypress$,1) = "d" Then
118    x=(POINT(i,0)*Cos(Rad(-INCRE)))-(POINT(i,2)*Sin(Rad(-INCRE)))
118    z=(POINT(i,0)*Sin(Rad(-INCRE)))+(POINT(i,2)*Cos(Rad(-INCRE)))
120                     POINT(i,0) = x
122                     POINT(i,2) = z
120                  EndIf
354                  Print POINT(i,0),POINT(i,1),POINT(i,2)
364                  i = i + 1
365                  Loop
368           i = 0
372           DO WHILE i < 12
367           ANGLE = DEG(ATN(POINT(VERTEX(i,0),0)/(240+POINT(VERTEX(i,0),2))))
368           PRINT ANGLE
368           DRAW.X.1 = CENTRE.X+POINT(VERTEX(i,0),0)
367           ANGLE = DEG(ATN(POINT(VERTEX(i,0),1)/(240+POINT(VERTEX(i,0),2))))
370           DRAW.Y.1 = CENTRE.Y+POINT(VERTEX(i,0),1)
367           ANGLE = DEG(ATN(POINT(VERTEX(i,1),0)/(240+POINT(VERTEX(i,1),2))))
372           DRAW.X.2 = CENTRE.X+POINT(VERTEX(i,1),0)
367           ANGLE = DEG(ATN(POINT(VERTEX(i,1),1)/(240+POINT(VERTEX(i,1),2))))
374           DRAW.Y.2 = CENTRE.Y+POINT(VERTEX(i,1),1)
350           Line(DRAW.X.1,DRAW.Y.1)-(DRAW.X.2,DRAW.Y.2)
352           i = i + 1
354           LOOP
366             EndIf
368             keypress$ = ""
367 Loop

