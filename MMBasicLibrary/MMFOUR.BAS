   10: REM This programme was originally found on a demo
   20: REM tape for the MicroBee computer. It was ported
   30: REM to GWbasic and then Qbasic for use on a BBS
   40: REM in 1995.
   50: REM In 2011 yet another port, this time to
   60: REM MMBasic to run on the Maximite computer.
   70: REM Glenn Littleford. www.thebackshed.com
   80: CLS
   90: PRINT TAB(10); "F O U R - R O W": PRINT : PRINT TAB(15); "Ver 1.3"
  100: PRINT : PRINT
  110: PRINT "Try to beat the computer in a simple yet addictive"
  120: PRINT "game similar to CONNECT FOUR": PRINT
  130: PRINT "Using the < and > keys position the arrow above"
  140: PRINT "the column you want, then use the space key to"
  150: PRINT "drop your marker. Press Q to quit."
  160: PRINT : PRINT "Hit any key to continue"
  170: RANDOMIZE TIMER
  180: DIM t(11), s(44), n(7)
  190: IF INKEY$ = "" THEN GOTO 190
  200: CLS
  210: e = 0: f = 0: g = 0
  220: FOR a = 1 TO 44: s(a) = 0: NEXT a
  230: IF s2 = 4 AND s1 = 0 THEN LOCATE 0, 165: PRINT "You really havn't got the hang of this, have you?"
  240: IF s1 - s2 = 3 THEN LOCATE 0,165: PRINT "You think your good, dont ya!"
  250: IF s2 - s1 = 5 THEN LOCATE 0,165: PRINT "Your loosing, ha ha."
  260: FOR x = 1 TO 141 STEP 20
  270:   LINE (x, 20)-(x, 140)
  280:   FOR y = 20 TO 120 STEP 20
  290:     LINE (x - 1, y)-(x + 1, y)
  300:   NEXT
  310: NEXT
  320: LINE (1, 140)-(141, 140)
  330: LOCATE 150,25 : PRINT "Four in a Row"
  340: LOCATE 150,45 : PRINT "Scores...."
  350: LOCATE 150,60 : PRINT "  You:"; s1
  360: LOCATE 150,70 : PRINT "   Me:"; s2
  370: LOCATE 150,80 : PRINT "Drawn:"; s3
  380: LOCATE 150,100 : PRINT "Keys...."
  390: LOCATE 150,115 : PRINT "< > to move"
  400: LOCATE 150,125 : PRINT "[SPACE] to drop"
  410: LOCATE 150,135 : PRINT "Q to quit"
  420: CIRCLE (153,62),3
  430: LINE (150,70)-(156,76),1,"BF"
  440: w = 36
  450: FOR c = 1 TO 7
  460:   n(c) = w
  470:   w = w + 1
  480: NEXT c
  490: c = 4
  500: s4 = s1 + s2 + s3
  510: IF s4 / 2 <> INT(s4 / 2) THEN GOTO 1170
  520: m1$ = "  My Move" : GOSUB 2000
  530: IF g <> 0 THEN g = 0 : GOTO 190
  540: v = 0: x = 0: y = 0: z = 0
  550: j=j+1
  560: IF j>7 THEN
  570:   j=0
  580:   GOTO 670
  590: ELSE
  600:   c=c+1
  610:   IF c>7 THEN c=1
  620: ENDIF
  630: p = c
  640: IF n(c) > 0 THEN GOSUB 1520
  650: IF f <> 0 THEN j = 0 : GOTO 1030
  660: GOTO 550
  670: IF x <> 0 THEN c = x : GOTO 1030
  680: IF y <> 0 THEN  c = y: GOTO 740
  690: IF z <> 0 THEN  c = z: GOTO 740
  700: c=INT(RND()*7)+1
  710: IF n(c)<1 THEN 700
  720: v = v + 1
  730: IF c <> 4 AND v < 5 THEN GOTO 700
  740: IF n(c) < 8 THEN f = 0: GOTO 1030
  750: IF v < 10 THEN GOTO 870
  760: IF v / 3 = INT(v / 3) THEN  m = 1
  770: m1$ = "Now what do I do ???": GOSUB 2130
  780: IF v < 21 THEN GOTO 870
  790: FOR t1=1 TO 200
  800:   LOCATE RND()*300, RND()*300
  810:   PRINT "?"
  820:   SOUND RND()*1000+20,20 : PAUSE 20
  830: NEXT t1
  840: PAUSE 1000
  850: e = 1
  860: GOTO 1420
  870: n(c) = n(c) - 7
  880: z = 0
  890: GOSUB 1520
  900: n(c) = n(c) + 7
  910: IF f <> 0 THEN
  920:   f = 0
  930:   IF v < 9 THEN GOTO 700
  940: ENDIF
  950: IF z <> 0 THEN
  960:   z = 0
  970:   IF v < 6 THEN GOTO 700
  980: ENDIF
  990: IF x <> 0 THEN
 1000:   x = 0
 1010:   GOTO 700
 1020: ENDIF
 1030: ne=((n(c)-c)/7)*20+30
 1040: m=c*20-9
 1050: LINE (m - 5, ne - 5)-(m + 5, ne + 5), 1, BF
 1060: s(n(c)) = 5
 1070: n(c) = n(c) - 7
 1080: IF f<>0 THEN
 1090:   m1$="I Win! haha!    Press any key."
 1100:   GOSUB 2130
 1110:   FOR noise1 = 1 TO 3 : FOR noise2=1000 TO 4000 STEP 500
 1120:     SOUND noise2,100 : PAUSE 100
 1130:   NEXT noise2 : NEXT noise1
 1140:   s2=s2+1
 1150:   GOTO 190
 1160: ENDIF
 1170: m1$ = "Your Move": GOSUB 2000
 1180: IF g <> 0 THEN
 1190:   g = 0
 1200:   GOTO 190
 1210: ENDIF
 1220: p = c
 1230: LINE (0, 0)-(200, 19), 0, BF
 1240: CIRCLE (p*20-9,10),6
 1250: K1$ = INKEY$
 1260: IF K1$ = "," OR K1$ = "." OR K1$ = "q" THEN GOTO 1290
 1270: IF K1$ = " " THEN GOTO 1340
 1280: GOTO 1250
 1290: IF K1$ = "." AND c < 7 THEN c = c + 1
 1300: IF K1$ = "," AND c > 1 THEN c = c - 1
 1310: IF K1$ = "q" OR K1$ = "Q" THEN GOTO 2200
 1320: REM
 1330: GOTO 1220
 1340: w1 = 0
 1350: ne=((n(c)-c)/7)*20+30
 1360: m=p*20-9
 1370: IF (n(c)-c)/7 < 0 THEN GOTO 1220
 1380: CIRCLE (m, ne), 6
 1390: s(n(c)) = 1
 1400: e = 0
 1410: GOSUB 1520
 1420: IF e<>0 THEN
 1430:   m1$="you win.        Press any key."
 1440:   GOSUB 2000
 1450:   SOUND 50,500 : PAUSE 500 : SOUND 30,700
 1460:   s1=s1+1
 1470:   PAUSE 2000
 1480:   GOTO 190
 1490: ENDIF
 1500: n(c) = n(c) - 7
 1510: GOTO 520
 1520: p=c*20-9
 1530: PAUSE 200
 1540: LINE (0, 0)-(300, 19), 0, BF
 1550: LINE (p - 5, 5)-(p + 5, 15), 1, BF
 1560: FOR a = 0 TO 11
 1570:   t(a) = 0
 1580: NEXT a
 1590: i = 0
 1600: o = n(c)
 1610: FOR u = o TO o + 21 STEP 7
 1620:   IF u > 42 THEN GOTO 1640
 1630:   t(i) = t(i) + s(u)
 1640: NEXT u
 1650: i = i + 1
 1660: k = c - 3
 1670: IF k < 1 THEN  k = 1
 1680: FOR a = k TO c + 3
 1690:   IF a > 4 OR a > c THEN GOTO 1810
 1700:   FOR B = a TO a + 3
 1710:     t(i) = t(i) + s(o - c + B)
 1720:   NEXT B
 1730:   i = i + 1
 1740:   w = o - (c - a) * 8
 1750:   IF w < 1 OR w > 18 THEN GOTO 1810
 1760:   FOR d = 0 TO 3
 1770:     t(i) = t(i) + s(w)
 1780:     w = w + 8
 1790:   NEXT d
 1800:   i = i + 1
 1810:   IF a > 7 THEN GOTO 1900
 1820:   IF a < 4 OR a < c THEN GOTO 1900
 1830:   w = o + (c - a) * 6
 1840:   IF w < 4 OR w > 21 THEN GOTO 1900
 1850:   FOR d = 0 TO 3
 1860:     t(i) = t(i) + s(w)
 1870:     w = w + 6
 1880:   NEXT d
 1890:   i = i + 1
 1900: NEXT a
 1910: FOR h = 0 TO i
 1920:   d = t(h)
 1930:   IF d = 4 THEN e = 1
 1940:   IF d = 15 THEN f = c
 1950:   IF d = 10 THEN z = c
 1960:   IF d = 3 THEN x = c
 1970:   IF h <> 0 AND d = 2 THEN y = c
 1980: NEXT h
 1990: RETURN
 2000: a = 0
 2010: a = a + 1
 2020: IF a > 7 THEN
 2030:   GOTO 2110
 2040: ELSE
 2050:   IF s(a) = 0 THEN
 2060:     a = 0
 2070:     GOTO 2130
 2080:   ENDIF
 2090: ENDIF
 2100: GOTO 2010
 2110: m1$ = "Its a draw"
 2120: g = 1
 2130: LOCATE 10,150
 2140: PRINT m1$; "               ";
 2150: IF m = 0 THEN GOTO 2180
 2160: m = 0
 2170: GOTO 2130
 2180: IF g <> 0 THEN s3 = s3 + 1
 2190: RETURN
 2200: CLS
 2210: PRINT : PRINT
 2220: PRINT TAB(20); "Thanks for playing."
 2230: PRINT
 2240: PRINT TAB(20); "www.thebackshed.com"
 2250: END
>