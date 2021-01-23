'* * * * * * * * * * * * * * * * * * * * * * * * *
'*                                               *
'*            - M A X M A N  v1.1 -              *
'*                                               *
'*        For the Maximite Computer by           *
'*                                               *
'*              Nickolas Marentes                *
'*                                               *
'* DATE:April 2012  EMAIL:nickma@optusnet.com.au *
'*                                               *
'*               <GAME CONTROLS>                 *
'*                                               *
'* START GAME  = Any key for Keyboard control    *
'*             = Joy button for Joystick control *
'* MOVE MAXMAN = Cursor Keys or Joystick         *
'* PAUSE GAME  = Spacebar                        *
'* ABORT GAME  = ESC                             *
'*                                               *
'*      Extra life awarded at 10000 points       *
'*                                               *
'* * * * * * * * * * * * * * * * * * * * * * * * *

MODE 1

DATA 4,3,23,27,23,3,4,27,1
DATA 23,27,23,3,4,27,4,3,1
DATA 23,3,4,27,4,3,23,27,1
DATA 4,27,4,3,23,27,23,3,0

'JOYSTICK SELECT

CLS:wii=2
PRINT@(188,60)"--  M A X M A N  --":PRINT@(213,80)"Version 1.1"
LINE(160,110)-(325,230),1,b:LINE(160,110)-(325,138),1,bf:SOUND 400,50
PRINT@(177,120,2)"JOYSTICK CONFIGURATION"
PRINT@(165,150)"[1] - Atari Joystick"
PRINT@(165,170)"[2] - Wii Nunchuk (100khz)"
PRINT@(165,190)"[3] - Wii Nunchuk (400khz)"
PRINT@(165,210)"[4] - No Joystick"
PRINT@(114,300)"Some Wii Nunchuks do not operate at 400khz"
PRINT@(106,320)"Game runs slower when using Nunchuk at 100khz"

JOYSET:
k$=INKEY$
IF k$="2" OR k$="3" THEN wii=1
IF k$="1" OR k$="4" THEN wii=0
IF wii=2 THEN GOTO JOYSET
SOUND 200,50

'INITIALIZATION

CLS
FONT LOAD "MAXMAN.FNT" AS #6
OPEN"HISCORE.DAT"FOR INPUT AS#1:INPUT#1,hiscore:CLOSE#1
FOR x=11 TO 15:SETPIN x,2:NEXT
IF wii=0 THEN GOTO STARTLEVEL

'INITIALIZE Wii NUNCHUCK (I2C on Pins 12 & 13)

DIM nun(6)

IF k$="2" THEN I2CEN 10,100 ELSE I2CEN 400,100
I2CSEND &h52,0,2,&hF0,&h55
I2CSEND &h52,0,2,&hFB,&h00


STARTLEVEL:
LINE(7,9)-(160,127),0,bf:LINE(175,9)-(328,127),0,bf
LINE(7,275)-(327,337),0,bf:LINE(7,359)-(328,421),0,bf
LINE(31,335)-(304,360),0,bf:LINE(67,65)-(268,277),0,bf
LINE(3,191)-(332,211),0,bf:LINE(400,305)-(470,413),0,bf
FONT LOAD "SCREEN.FNT" AS #5:FONT #5:c=97
FOR y=1 TO 385 STEP 64:FOR x=0 TO 240 STEP 240
PRINT@(x,y)CHR$(c);:c=c+1:NEXT:NEXT
FONT #6:FONT unload #5
DIM m(27,30,3):DIM g(4,4):DIM t(4,2)

'Load Map/Dot array

FOR x=1 TO 26:FOR y=1 TO 29
IF PIXEL(x*12+4,y*14+5)=1 THEN m(x,y,1)=1
IF PIXEL(x*12+5,y*14+5)=1 THEN m(x,y,2)=1
PIXEL(x*12+4,y*14+5)=0:NEXT y,x

'Start or Continue level

IF status=1 THEN GOTO START
IF sc>hiscore THEN hiscore=sc:OPEN"HISCORE.DAT"FOR output AS#1:PRINT#1,hiscore:CLOSE#1
sc=0:dotcnt=0:level=1:lives=3:q2=93:xt=10000:GOSUB BOXCLS
FONT#2:PRINT@(393,310)sc:PRINT@(393,337)hiscore:PRINT@(393,365)level:FONT#6
CLRKBUFF: IF INKEY$<>"" THEN GOTO CLRKBUFF

PROMPT:
FONT#2:TIMER=0:PRINT@(129,183,5)"INSERT":PRINT@(143,205,5)"COIN"
COIN: k$=INKEY$
IF k$<>"" THEN v=0:GOTO GO
IF wii=1 THEN GOTO J1
IF PIN(15)=0 THEN v=1:GOTO GO
IF TIMER>300 THEN GOTO PROMPT ELSE GOTO COIN
J1:
I2CSEND &h52,0,1,0
I2CRCV &h52,0,6,nun(0)
'PRINT@(0,0)nun(1)"   "
IF (nun(5) AND 1)=0 THEN v=2:GOTO GO
IF TIMER>300 THEN GOTO PROMPT ELSE GOTO COIN

GO:
GOSUB BOXCLS:SOUND 300,100:PAUSE 50:SOUND 200,50
FONT#2:PRINT@(149,182)"GET":PRINT@(137,204)"READY"
PAUSE 3000:GOSUB BOXCLS:status=1

'Initialize Level Start variables

START:
FONT#2:PRINT@(393,310)sc:PRINT@(393,337)hiscore:PRINT@(393,365)level:FONT#6
px=166:py=327:pd=1:cd=1:pc=99:a=1:gscore=1:q1=1400:LINE (400,395)-(460,405),0,bf
FOR x=1 TO 4:g(x,1)=166:g(x,2)=201:g(x,3)=3:g(x,4)=x*100+50:NEXT
ST1: IF lives>a THEN LINE(400+a*8,395)-(403+a*8,405),1,bf:a=a+1:GOTO ST1

'Main Game Loop

MAINLOOP:
TIMER=0
pxd=INT((px-4)/12):pxx=pxd:IF ((px-4)/12)-pxd<>0 THEN pxd=0
pyd=INT((py-5)/14):pyy=pyd:IF ((py-5)/14)-pyd<>0 THEN pyd=0

IF gmode=0 THEN GOTO TARGET
pwrcnt=pwrcnt-1
IF pwrcnt=0 THEN gmode=0:gscore=1
GOTO CAUGHT

TARGET:
IF RND*100<level*2 THEN c=FIX(RND*(level AND 3))+1:t(c,1)=pxx:t(c,2)=pyy
IF tc>0 THEN tc=tc-1:GOTO CAUGHT
tc=400
IF tflag=0 THEN RESTORE
FOR a=1 TO 4:READ t(a,1),t(a,2):NEXT:READ tflag

CAUGHT:
IF hflag=0 OR gmode=1 THEN GOTO CONTROL
LOCATE px-8,py-9
IF hflag=1 THEN GOSUB BOXCLS
IF hflag<38 THEN PRINT CHR$(hflag/4+79);:SOUND 200-hflag*2,10
IF hflag>38 THEN PRINT CHR$(97);
IF hflag=45 THEN SOUND 150,35:PAUSE 170:SOUND 150,35
hflag=hflag+1
IF hflag<100 THEN GOTO GHOSTS
hflag=0:hit=0:lives=lives-1
FOR n=1 TO 4:g(n,1)=166:g(n,2)=201:g(n,3)=3:g(n,4)=n*150+100:NEXT
IF lives>0 THEN GOTO START
FOR x=1 TO 87:LINE(167-x,200)-(167+x,202),1,bf:SOUND x*4+50,10:PAUSE 5:NEXT
FOR y=1 TO 32:LINE(80,200-y)-(254,202+y),1,b:SOUND RND*300+50,10:PAUSE 10:NEXT
FONT#2:PRINT@(110,192,2)"GAME OVER":PAUSE 5000"":status=0:SOUND 100,100
ERASE m,g,t:GOTO STARTLEVEL


'SCAN SELECTED CONTROLLER

CONTROL:
k=ASC(INKEY$)
IF k=32 THEN GOSUB PAUSEGAME
IF k=27 THEN status=0:ERASE m,g,t:GOTO STARTLEVEL
IF v=0 THEN GOTO KEYSCAN
IF v=2 THEN GOTO NUNCHUCK

ATARI:
IF PIN(13)=0 THEN cd=1:k=130
IF PIN(14)=0 THEN cd=2:k=131
IF PIN(11)=0 THEN cd=3:k=128
IF PIN(12)=0 THEN cd=4:k=129
ON pd GOTO PLEFT,PRIGHT,PUP,PDOWN

NUNCHUCK:
I2CSEND &h52,0,1,0
I2CRCV &h52,0,6,nun(0)
IF nun(0)<85 THEN cd=1:k=130
IF nun(0)>170 THEN cd=2:k=131
IF nun(1)>170 THEN cd=3:k=128
IF nun(1)<85 THEN cd=4:k=129
ON pd GOTO PLEFT,PRIGHT,PUP,PDOWN

KEYSCAN:
IF k=130 THEN cd=1
IF k=131 THEN cd=2
IF k=128 THEN cd=3
IF k=129 THEN cd=4
ON pd GOTO PLEFT,PRIGHT,PUP,PDOWN


'PROCESS PACMAN

PLEFT:
IF k=131 THEN pd=2:pc=103:GOTO P001
P004: IF pxd=0 THEN GOTO P002
IF cd=3 AND m(pxd,pyd-1,1)=1 THEN pd=3:pc=107:GOTO ENDPAC
IF cd=4 AND m(pxd,pyd+1,1)=1 THEN pd=4:pc=111:GOTO ENDPAC
IF pxd=1 AND pyd=14 THEN PRINT@(8,192)"a":px=316:GOTO ENDPAC
IF m(pxd-1,pyd,1)=0 THEN pc=99:GOTO ENDPAC
IF m(pxd-1,pyd,2)=1 THEN SOUND 100,20:sx=pxd-1:sy=pyd:m(sx,sy,2)=0:LINE(px-12,py)-(px-11,py+1),0,b:GOSUB EATDOT
P002: LINE (px+10,py-5)-(px+11,py+5),0,b:px=px-2
P003: pc=pc+.25:IF pc>101 THEN pc=98
GOTO ENDPAC

PRIGHT:
IF k=130 THEN pd=1:pc=99:GOTO P004
P001: IF pxd=0 THEN GOTO P005
IF cd=3 AND m(pxd,pyd-1,1)=1 THEN pd=3:pc=107:GOTO ENDPAC
IF cd=4 AND m(pxd,pyd+1,1)=1 THEN pd=4:pc=111:GOTO ENDPAC
IF pxd=26 AND pyd=14 THEN PRINT@(308,192)"a":px=16:GOTO ENDPAC
IF m(pxd+1,pyd,1)=0 THEN pc=103:GOTO ENDPAC
IF m(pxd+1,pyd,2)=1 THEN SOUND 100,20:sx=pxd+1:sy=pyd:m(sx,sy,2)=0:LINE(px+13,py)-(px+14,py+1),0,b:GOSUB EATDOT
P005: LINE (px-9,py-5)-(px-7,py+5),0,bf:px=px+2
P006: pc=pc+.25:IF pc>105 THEN pc=102
GOTO ENDPAC

PUP:
IF k=129 THEN pd=4:pc=111:GOTO P007
P010: IF pyd=0 THEN GOTO P008
IF cd=1 AND m(pxd-1,pyd,1)=1 THEN pd=1:pc=99:GOTO ENDPAC
IF cd=2 AND m(pxd+1,pyd,1)=1 THEN pd=2:pc=103:GOTO ENDPAC
IF m(pxd,pyd-1,1)=0 THEN pc=107:GOTO ENDPAC
IF m(pxd,pyd-1,2)=1 THEN SOUND 100,20:sx=pxd:sy=pyd-1:m(sx,sy,2)=0:LINE(px+1,py-14)-(px+2,py-13),0,b:GOSUB EATDOT
P008: LINE (px-4,py+9)-(px+7,py+11),0,bf:py=py-2
P009: pc=pc+.25:IF pc>109 THEN pc=106
GOTO ENDPAC

PDOWN:
IF k=128 THEN pd=3:pc=107:GOTO P010
P007: IF pyd=0 THEN GOTO P011
IF cd=1 AND m(pxd-1,pyd,1)=1 THEN pd=1:pc=99:GOTO ENDPAC
IF cd=2 AND m(pxd+1,pyd,1)=1 THEN pd=2:pc=103:GOTO ENDPAC
IF m(pxd,pyd+1,1)=0 THEN pc=111:GOTO ENDPAC
IF m(pxd,pyd+1,2)=1 THEN SOUND 100,20:sx=pxd:sy=pyd+1:m(sx,sy,2)=0:LINE(px+1,py+14)-(px+2,py+15),0,b:GOSUB EATDOT
P011: LINE (px-4,py-10)-(px+7,py-8),0,bf:py=py+2
P012: pc=pc+.25:IF pc>113 THEN pc=110

ENDPAC: PRINT@(px-8,py-9)CHR$(pc);


'PROCESS GHOSTS

GHOSTS:
IF gmode=1 THEN GOTO GMODE1

GMODE0:
z=2
FOR n=1 TO 4
gx=FIX((g(n,1)-4)/12):dx=gx:IF ((g(n,1)-4)/12)-gx<>0 THEN gx=0
gy=FIX((g(n,2)-5)/14):dy=gy:IF ((g(n,2)-5)/14)-gy<>0 THEN gy=0
LOCATE g(n,1)-8,g(n,2)-9
IF hflag>0 AND g(n,4)>0 THEN g(n,4)=100
IF g(n,4)>0 THEN GOTO GREGEN
IF hflag=2 THEN LINE(g(n,1)-9,g(n,2)-10)-(g(n,1)+12,g(n,2)+11),0,bf:GOTO GM0
IF hflag<>0 THEN GOTO GM0
PRINT CHR$(g(n,3)+113);
GM0: ON g(n,3) GOTO GLEFT,GRIGHT,GUP,GDOWN

GMODE1:
z=z XOR 2
FOR n=1 TO 4
gx=FIX((g(n,1)-4)/12):dx=gx:IF ((g(n,1)-4)/12)-gx<>0 THEN gx=0
gy=FIX((g(n,2)-5)/14):dy=gy:IF ((g(n,2)-5)/14)-gy<>0 THEN gy=0
IF dx<pxx THEN t(n,1)=8 ELSE t(n,1)=19
IF dy<pyy THEN t(n,2)=72 ELSE t(n,2)=21
LOCATE g(n,1)-8,g(n,2)-9
IF hflag>0 AND g(n,4)>0 THEN g(n,4)=100
IF g(n,4)>0 THEN GOTO GREGEN
IF hflag=2 THEN LINE(g(n,1)-9,g(n,2)-10)-(g(n,1)+12,g(n,2)+11),0,bf:GOTO GM1
IF hflag<>0 THEN GOTO GM1
IF pwrcnt<85 AND z=0 THEN PRINT CHR$(119); ELSE PRINT CHR$(118);
GM1: ON g(n,3) GOTO GLEFT,GRIGHT,GUP,GDOWN

GREGEN:
IF gmode=1 AND g(n,4)>83 THEN g(n,4)=g(n,4)+1
g(n,4)=g(n,4)-1:LINE(156,172)-(180,172),1
IF g(n,4)=0 OR g(n,4)=43 THEN g(n,3)=INT(RND*2)+1:GOSUB BOXCLS:GOTO GM1
IF g(n,4)<43 THEN g(n,2)=g(n,2)-1:PRINT CHR$(116):GOTO LOOPEND
PRINT@(110+n*19,191)CHR$(116+f):GOTO LOOPEND

GUP:
IF hflag=0 THEN LINE(g(n,1)-8,g(n,2)+10)-(g(n,1)+11,g(n,2)+11),0,b
IF m(dx,dy+1,2)=1 THEN x=dx*12+5:y=(dy+1)*14+5:LINE (x,y)-(x+1,y+1),1,b
GU2: IF gy=0 THEN g(n,2)=g(n,2)-z:GOTO LOOPEND
IF gmode=1 THEN GOTO GU1
IF gx=pxx THEN t(n,1)=pxx:t(n,2)=pyy:GOTO GU1
IF gx>t(n,1) AND m(gx-1,gy,1)=1 THEN g(n,3)=1:gx=0:GOTO GL2
IF gx<t(n,1) AND m(gx+1,gy,1)=1 THEN g(n,3)=2:gx=0:GOTO GR2
GU1: IF m(gx,gy-1,1)=1 THEN g(n,2)=g(n,2)-z:GOTO LOOPEND
IF m(gx-1,gy,1)=1 THEN g(n,3)=1:gx=0:GOTO GL2
g(n,3)=2:gx=0:GOTO GR2

GDOWN:
IF hflag=0 THEN LINE(g(n,1)-8,g(n,2)-10)-(g(n,1)+11,g(n,2)-9),0,b
IF m(dx,dy-1,2)=1 THEN x=dx*12+5:y=(dy-1)*14+5:LINE (x,y)-(x+1,y+1),1,b
GD2: IF gy=0 THEN g(n,2)=g(n,2)+z:GOTO LOOPEND
IF gmode=1 THEN GOTO GD1
IF gx=pxx THEN t(n,1)=pxx:t(n,2)=pyy:GOTO GD1
IF gx>t(n,1) AND m(gx-1,gy,1)=1 THEN g(n,3)=1:gx=0:GOTO GL2
IF gx<t(n,1) AND m(gx+1,gy,1)=1 THEN g(n,3)=2:gx=0:GOTO GR2
GD1: IF m(gx,gy+1,1)=1 THEN g(n,2)=g(n,2)+z:GOTO LOOPEND
IF m(gx-1,gy,1)=1 THEN g(n,3)=1:gx=0:GOTO GL2
g(n,3)=2:gx=0:GOTO GR2

GLEFT:
IF hflag=0 THEN LINE(g(n,1)+11,g(n,2)-9)-(g(n,1)+12,g(n,2)+10),0,b
IF m(dx+1,dy,2)=1 THEN x=(dx+1)*12+5:y=dy*14+5:LINE (x,y)-(x+1,y+1),1,b
GL2: IF gx=0 THEN g(n,1)=g(n,1)-z:GOTO LOOPEND
IF gx=1 AND gy=14 THEN PRINT@(8,192)"a":g(n,1)=316:GOTO LOOPEND
IF gmode=1 THEN GOTO GL1
IF gy=pyy THEN t(n,1)=pxx:t(n,2)=pyy:GOTO GL1
IF gy>t(n,2) AND m(gx,gy-1,1)=1 THEN g(n,3)=3:gy=0:GOTO GU2
IF gy<t(n,2) AND m(gx,gy+1,1)=1 THEN g(n,3)=4:gy=0:GOTO GD2
GL1: IF m(gx-1,gy,1)=1 THEN g(n,1)=g(n,1)-z:GOTO LOOPEND
IF m(gx,gy-1,1)=1 THEN g(n,3)=3:gy=0:GOTO GU2
g(n,3)=4:gy=0:GOTO GD2

GRIGHT:
IF hflag=0 THEN LINE(g(n,1)-9,g(n,2)-9)-(g(n,1)-8,g(n,2)+11),0,b
IF m(dx-1,dy,2)=1 THEN x=(dx-1)*12+5:y=dy*14+5:LINE (x,y)-(x+1,y+1),1,b
GR2: IF gx=0 THEN g(n,1)=g(n,1)+z:GOTO LOOPEND
IF gx=26 AND gy=14 THEN PRINT@(308,192)"a":g(n,1)=16:GOTO LOOPEND
IF gmode=1 THEN GOTO GR1
IF gy=pyy THEN t(n,1)=pxx:t(n,2)=pyy:GOTO GR1
IF gy>t(n,2) AND m(gx,gy-1,1)=1 THEN g(n,3)=3:gy=0:GOTO GU2
IF gy<t(n,2) AND m(gx,gy+1,1)=1 THEN g(n,3)=4:gy=0:GOTO GD2
GR1: IF m(gx+1,gy,1)=1 THEN g(n,1)=g(n,1)+z:GOTO LOOPEND
IF m(gx,gy-1,1)=1 THEN g(n,3)=3:gy=0:GOTO GU2
g(n,3)=4:gy=0:GOTO GD2


LOOPEND:
IF g(n,1)>px-9 AND g(n,1)<px+9 AND g(n,2)>py-9 AND g(n,2)<py+9 THEN GOSUB EATME
NEXT n

IF q1>1000 AND px=162 AND py=243 THEN GOSUB BONUSSND:s=500:GOSUB SCORE:q1=1300
q1=q1+1
IF q1>1000 THEN PRINT@(157,234)CHR$(FIX(q2)):q2=q2+.25:IF q2=97 THEN q2=93
IF q1>1300 THEN q1=0:PRINT@(157,234)CHR$(97)

IF dotcnt=244 THEN PAUSE 2000:dotcnt=0:level=level+1:ERASE m,g,t:GOTO STARTLEVEL

POWER:
i=i+1:IF i=20 THEN i=0:f=f XOR 1
IF m(1,3,2)=1 THEN LINE(16,46)-(19,49),f,b
IF m(26,3,2)=1 THEN LINE(316,46)-(319,49),f,b
IF m(1,23,2)=1 THEN LINE(16,326)-(19,329),f,b
IF m(26,23,2)=1 THEN LINE(316,326)-(319,329),f,b

IF gmode=0 AND hflag=0 AND hit=1 THEN PRINT@(px-8,py-9)CHR$(98):PAUSE 1000:hflag=1
WAIT: IF TIMER<30 THEN GOTO WAIT
GOTO MAINLOOP


EATME:
IF gmode=0 THEN hit=1:RETURN
PRINT@(px-8,py-9)CHR$(gscore+88);
s=100:FOR a=1 TO gscore:s=s*2:NEXT:gscore=gscore+1:GOSUB SCORE
FOR a=100 TO 400 STEP 50:SOUND a,50:PAUSE 50:NEXT
LINE(g(n,1)-9,g(n,2)-10)-(g(n,1)+12,g(n,2)+11),0,bf
g(n,1)=166:g(n,2)=201:g(n,3)=3:g(n,4)=150+n*30
s=gs:gs=gs*2:GOTO SCORE

EATDOT:
s=10:dotcnt=dotcnt+1
IF sx>1 AND sx<26 THEN GOTO EA1
IF sy<>3 AND sy<>23 THEN GOTO EA1
s=50:gmode=1:gs=200:pwrcnt=320-((level-1) AND 3)*75:GOSUB BOXCLS
FOR a=1 TO 4
IF g(a,1)<pxx AND g(a,3)=2 THEN g(a,3)=1:GOTO EA2
IF g(a,1)>pxx AND g(a,3)=1 THEN g(a,3)=2:GOTO EA2
IF g(a,2)<pyy AND g(a,3)=4 THEN g(a,3)=3:GOTO EA2
IF g(a,2)>pyy AND g(a,3)=3 THEN g(a,3)=4
EA2: NEXT
EA1: SOUND 80,s*3

SCORE:
sc=sc+s:FONT#2:PRINT@(392,310)sc
IF sc<xt THEN FONT#6:RETURN
FOR a=1 TO 6
SOUND 500,50:PRINT@(400,394)"EXTRA":PAUSE 30
SOUND 300,50:PRINT@(400,394)"     ":PAUSE 30
NEXT
xt=99999:lives=lives+1:a=1
ST2: IF lives>a THEN LINE(400+a*8,395)-(403+a*8,405),1,bf:a=a+1:GOTO ST2
FONT#6:RETURN

BOXCLS:
LINE(129,176)-(206,227),0,bf
LINE(156,150)-(179,175),0,bf
LINE(156,172)-(180,172),1
RETURN

BONUSSND:
FONT#2:PRINT@(149,234)"500"
FOR a=1 TO 4
FOR b=100 TO 400 STEP 15:SOUND b,10:PAUSE 10
NEXT:NEXT
PRINT@(149,234)"   ":RETURN

PAUSEGAME:
FONT#2
PRINT@(130,235,5)"PAUSED":PAUSE 250
PRINT@(130,235,5)"PAUSED":PAUSE 250
IF ASC(INKEY$)<>32 THEN GOTO PAUSEGAME
FONT#6
RETURN

