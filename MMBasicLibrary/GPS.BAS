10 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
20 ' Demonstration of parsing the NMEA string produced by a GPS module
30 ' Geoff Graham - Sept 2011
40 '
50 ' All GPS modules are guaranteed to produce the GPRMC string
60 ' See http://home.mira.net/~gnb/gps/nmea.html for details of the string
70 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
80 '
100 max = 20                                  ' maximum nbr of params
110 DIM arg$(max)                             ' used to hold the data fields
120 '
130 OPEN "COM1:4800" AS #1
140 '
150 DO                                       ' loop forever
160   GOSUB 800                              ' get the next line
170   IF arg$(0) = "GPRMC" THEN              ' GPRMC contains lat/long
180     IF arg$(2) = "A" THEN                ' "A" means locked on to satellites
190       PRINT "Latitude = ";  LEFT$(arg$(3), 2); " "; MID$(arg$(3), 3);
200       PRINT " "; arg$(4);
210       PRINT "   Longitude = "; LEFT$(arg$(5), 3); " "; MID$(arg$(5), 4);
220       PRINT " "; arg$(6)
230     ELSE
240       PRINT "GPS searching..."
250     ENDIF
260   ENDIF
270 LOOP
280 '
290 '
300 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
310 ' subroutine to load the GPS data fields into the array arg$()
320 ' returns with the array populated
800 DO                                      ' subroutine start
810   DO WHILE INPUT$(1, #1) <> "$" : LOOP  ' wait for the start
820   FOR i = 0 TO max
830     arg$(i) = ""                        ' clear ready for data
840     DO                                  ' loops until a specific exit
850       x$ = INPUT$(1, #1)                ' get the character
860       IF x$ = "," THEN EXIT             ' new data field, increment i
870       IF x$ = "*" THEN RETURN           ' we have all the data so return
880       arg$(i) = arg$(i) + x$            ' add to the data
890     LOOP                                ' loop back for the next char
900   NEXT i                                ' move to the next data field
910   PRINT "Corrupt data..."               ' exceeded max data items
920 LOOP
