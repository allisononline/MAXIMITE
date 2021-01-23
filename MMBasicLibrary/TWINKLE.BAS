10 ' Twinkle demonstrates the ability of
20 ' Maximite to control individual pixels
30 '
40 OPTION base 1
50 nbr = mm.vres * 10
60 CLS
70 DIM p(nbr,2)
80 h = 1
90  DO
100    x = RND * mm.hres
110    y = RND * mm.vres
120    PSET (x,y)              ' Turn on a star
130    p(h,1) = x              ' And save it
140    p(h,2) = y
150    h = h + 1               ' Next new star
160    IF h > nbr THEN h = 1
170    PRESET (p(h,1), p(h,2)) ' Erase the old
180    count = count + 1
190    LOCATE mm.hres/2 - 20, mm.vres/2 - 5
200    PRINT count;
210 LOOP                       ' Loop forever
