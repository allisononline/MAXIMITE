angle = 5
DO
CLS
x1 = (MM.HRES/2) - (100 * SIN(angle*PI/180))
x1 = CINT(x1)
y1 = (MM.VRES/2) + 100
y1 = CINT(y1)
x2 = (MM.HRES/2) - (100 * SIN((180+angle)*PI/180))
x2 = CINT(x2)
y2 = (MM.VRES/2) + 100
y2 = CINT(y2)
x3 = (MM.HRES/2) - (100 * SIN((angle+90)*PI/180))
x3 = CINT(x3)
y3 = (MM.VRES/2) + 100
y3 = CINT(y3)
x4 = (MM.HRES/2) - (100 * SIN((270+angle)*PI/180))
x4 = CINT(x4)
y4 = (MM.VRES/2) + 100
y4 = CINT(y4)
LINE (x1, y1) - (x3, y3), 3
LINE (x4, y4) - (x2, y2), 3
LINE (x1, y1) - (x4, y4), 3
LINE (x3, y3) - (x2, y2), 3
angle = angle + 5
IF angle = 360 THEN
angle = 0
ENDIF
TONE 5000, 5000, 5
PAUSE 250
LOOP
