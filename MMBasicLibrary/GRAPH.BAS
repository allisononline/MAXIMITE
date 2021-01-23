100 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
110 ' GRAPH.BAS
120 ' Demonstration program showing the ability to graph data
130 ' It will graph the voltage on pins 1 to 10 using both line and
140 ' bar graphs.  This will run on either VGA or composite displays.
150 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
160 '
170 DIM barval(10)
180 CLS
190 ' general drawing parameters, the same for both graphs
200 height = mm.vres/2 - mm.vres/17 : margin = 45 : width = mm.hres - margin
210 '
220 ' parameters for the bar graphs
230 bx = margin : by = mm.vres-10
240 dx = bx : dy = by : GOSUB 640      ' draw the axies for the bar graph
250 '
260 ' parameters for the analog line graph
270 ax = margin : ay = height
280 dx = ax : dy = ay : GOSUB 640      ' draw the axies for the line graph
290 '
300 average = 20                       ' averaging for the line graph
310 printx = Width/2 - 45 : printy = ay + 8
320 '
330 FOR i = 1 TO 10 : SETPIN i, 1  : NEXT i   ' Initialise the I/O pins
340 TIME$ = "0:0:0"                     ' Zero the clock
350 '
360 '
370 FOR i  = ax + 1 TO ax + width - 1
380 ''''''''''''''''''''' draw the line graph '''''''''''''''''''''''''
390    volt = 0
400    FOR j = 1 TO average
410        volt = volt + PIN(1)       ' Take multiple readings
420    NEXT j
430    volt = volt/average
440    LINE (i,ay - Height)-(i + 10, ay - 1), 0, bf ' Blank previous
450    h = ay - (height / 3.3) * volt    ' Calculate the vertical coordinate
460    IF i = ax + 1 THEN h_last = h  ' Setup a start point
470    LINE (i - 1, h_last)-(i, h), 1 ' Graph the voltage level
480    h_last = h                     ' remember for the next time around
490    LOCATE printx, printy          ' Position for printing the voltage
500    PRINT TIME$; "   CHANNEL 1 = ";
510    PRINT FORMAT$(volt, "%5.3fV")  ' And print the voltage
520    '
530    '
540    ''''''''''''''''''''' draw the bar graphs ''''''''''''''''''''''
550    FOR j = 1 TO 10
560      barval(j) = (barval(j) * 9 + (height / 3.3) * PIN(j)) / 10
570      st = (width/10)*(j - 1) + bx + 10
580      LINE (st, by)-(st + 20, by-barval(j)),1,bf
590      LINE (st, by-barval(j))-(st + 20, by-height),0,bf
600    NEXT j
610 NEXT i
620 GOTO 370                          ' Loop forever
630 '
640 ''''''''''''' Subroutine to draw the graph axies '''''''''''''
650 'CLS
660 LINE (dx,dy)-(dx, dy - height), 1 ' Draw the vert line
670 LINE (dx,dy)-(dx + Width ,dy), 1  ' Draw the horiz line
680 FOR i = 0 TO 33                   ' This loop draws the tick marks
690     h = dy - (height / 33) * i
700     t = dx - 5
710     IF i MOD 5 = 0 THEN t = dx-8  ' Longer tick mark if unit of 0.5V
720     IF i MOD 10 = 0 THEN          ' Special mark for a unit of 1V
730         LOCATE dx - 42, h - 3
740         PRINT LEFT$(FORMAT$(i/10,"%f"),3);"V"; ' Label the tick mark
750         t = dx - 15
760     ENDIF
770     LINE (dx, h)-(t, h), 1        ' Draw the tick mark
780 NEXT i
790 RETURN
