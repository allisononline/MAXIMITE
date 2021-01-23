10 : Rem "Prey" was published by Phil Cohen in ETI magazine September 1982.
20 : Rem Originally written for the Apple II.
30 : Rem In the same year I ported it to run on the Microbee computer,
40 : Rem and added a few features using the Microbee's more advanced
50 : Rem graphics commands and screen resolution.
60 : Rem In 2011, 29 years later, I found the same ETI magazine, and
70 : Rem decided to rewite it MMBasic to run on the Maximite, just for fun.
80 : Rem Glenn Littleford. www.thebackshed.com
90 : Cls
100 : Print Tab(10); "***Prey***" : Print
110 : Print "Prey is a life simulation program. It plots the "
120 : Print "population numbers of a predator, like a fox, "
130 : Print "and a prey."
150 : Print "You first set up their initial environment, to """
160 : Print "see if it can sustain stable populations, and "
170 : Print "then introduce a change some time during the"
180 : Print "10 year simulation. For example, reduce the "
190 : Print "territory, ( land clearing ), increase the"
200 : Print "food yield ( plant carrots ), or cull the prey"
210 : Print "when they threaten your land productivity."
220 : Print "The program will then plot the effect on prey"
230 : Print "and predator populations." : Print
240 : Input "Press ENTER to continue"; a$
250 : TR = 500: P1 = 180: P2 = 75: YD = 15
260 : L1=10 : L2=20 : CU=1
270 : Cls
280 : Print "*** Prey ***" : Print
290 : Print "Option  Description                Value" : Print
300 : Print "  1    Size of territory           "; TR
310 : Print "  2    Prey Population             "; Int(P1)
320 : Print "  3    Predator Population         "; Int(P2)
330 : Print "  4    Food yield per unit area    "; YD
340 : Print "  5    Prey natural life span      "; L1
350 : Print "  6    Predator natural life span  "; L2
360 : Print "  7    Prey Cull Losses            "; CU
370 : Print "  8    Done, move to next step"
380 : Print "  9    Reset to defaults"
390 : Print "  Q    Quit"
400 : Print
410 : Input "Which would you like to alter "; A$
420 : If a$="Q" Or a$="q" Then GoTo 1200
430 : A=Val(a$) : If A>9 Or A<1 Then GoTo 270
440 : Print
450 : On A GoTo 460, 470, 480, 490, 500, 510, 520, 530, 250, 1200
460 : Input "Territory Size"; TR: GoTo 270
470 : Input "Prey Population"; P1: GoTo 270
480 : Input "Predator Population"; P2: GoTo 270
490 : Input "Food yeild per unit area"; YD: GoTo 270
500 : Input "prey natural life span"; L1: GoTo 270
510 : Input "Predator natural life span"; L2: GoTo 270
520 : Input "Prey cull losses"; CU: GoTo 270
530 : Input "Year for change ( 0-10 )"; YR
540 : YX=Int(20*YR)
550 : Input "Which variable to change ( 1-7 )"; V
560 : If V > 7 Or V < 1 Then GoTo 550
570 : Print "Value to be set at year "; YR; " ";
580 : Input VL
590 : Cls
600 :  Locate 10,0 : Print "*** Prey ***"
610 : Line (100,0)-(300,159),1,"B"
620 : For i=100 To 300 Step 20
630 :   Line (i,159)-(i,162)
640 :   Locate i-10,170 : Print (i-100)/20
650 : Next I
660 : Locate 0,30 : Print "Territory:";
670 : Locate 0,45 : Print "Prey Pop :";
680 : Locate 0,60 : Print "Pred Pop :";
690 : Locate 0,75 : Print "Yield    :";
700 : Locate 0,90 : Print "Cull     :";
710 : Locate 0,105 : Print "Pred Life:";
720 : Locate 0,120 : Print "Prey Life:";
730 : Line (0,148)-(12,148) : Locate 15,145 : Print "Prey";
740 : For i=0 To 12 Step 2 : Line (i,160)-(i,157) : Next i : Locate 15,156 : Print "Predator";
750 : X = 0
760 : KL = (P1 * P2) / TR
770 : FD = TR * YD
780 : If P1 = 0 Then B1 = 0: GoTo 800
790 : B1 = FD / P1
800 : If B1 > P1 / 4 Then B1 = P1 / 4
810 : B2 = 10 * KL / P2
820 : If B2 > P2 / 4 Then B2 = P2 / 4
830 : M1 = (P1 - B1) / L1
840 : M2 = (P2 - B2) / L2
850 : P1 = P1 - M1 - KL + B1 - CU
860 : P2 = P2 - M2 + B2
870 : If P1 < 0 Then P1 = 0
880 : If P2 < 0 Then P2 = 0
890 : Y = 159 - (.5 * P1)
900 : If Y < 0 Then Y = 0: If Y > 159 Then Y = 159
910 : If X = 0 Then GoTo 930
920 : Line (X+100 - 1, OY)-(X+100, Y)
930 : OY = Y
940 : Y = 159 - (.8 * P2)
950 : If Y > 1 And Y < 158 And Int(X / 2) = X / 2 Then Line (X+100, Y - 1)-(X+100, Y + 1)
960 : X = X + 1
970 : Locate 60,30 : Print TR; " ";
980 : Locate 60,45 : Print Int(P1); " ";
990 : Locate 60,60 : Print Int(P2); " ";
1000 : Locate 60,75 : Print YD; " ";
1010 : Locate 60,90 : Print CU; " "
1020 : Locate 60,105 : Print L1; " ";
1030 : Locate 60,120 : Print L2; " ";
1040 : If X <> YX Then GoTo 1160
1050 : Locate 0,187
1060 : Print "Year "; YR; " ";
1070 : On V GoTo 1080, 1090, 1100, 1110, 1120, 1130, 1140
1080 : Print "Territory "; TR; : TR = VL: GoTo 1150
1090 : Print "Prey Pop"; Int(P1); : P1 = VL: GoTo 1150
1100 : Print "Pred Pop "; Int(P2); : P2 = VL: GoTo 1150
1110 : Print "Yield "; YD; : YD = VL: GoTo 1150
1120 : Print "Prey Life "; L1; : L1 = VL: GoTo 1150
1130 : Print "Pred Life "; L2; : L2 = VL: GoTo 1150
1140 : Print "Cull "; CU; : CU = VL
1150 : Print " -> "; VL; "  ";
1160 : Pause 50
1170 : If X < 200 Then GoTo 760
1180 : Locate 140,200 : Input "Press ENTER to continue "; A$
1190 : GoTo 270
1200 : Cls
1210 : Print : Print
1220 : Print Tab(20); "Thanks for playing"
1230 : Print
1240 : Print Tab(20); "www.thebackshed.com"
1220 : End
>
