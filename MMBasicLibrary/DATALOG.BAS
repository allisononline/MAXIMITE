100 ''''''''''''''''''''''''''''''''''''''''''''''''''''''
110 ' DATALOG.BAS
120 ' Every second this program will:
130 '  - measure the voltage on pins 1 to 10
140 '  - get the logic level on pins 11 to 20
150 '  - display the data on both the USB and video outputs
160 '  - record it in the file DATALOG.XLS
170 ''''''''''''''''''''''''''''''''''''''''''''''''''''''
180 '
190 ' configure pins 1 to 10 as analog inputs
200 FOR i = 1 TO 10 : SETPIN i, 1 : NEXT i
210 '
220 ' configure pins 11 to 20 as digital inputs
230 FOR i = 11 TO 20 : SETPIN i, 2 : NEXT i
240 '
250 ' zero the data file and print the heading
260 OPEN "DATALOG.XLS" FOR output AS #1
270 PRINT #1, "TIME"; CHR$(9);
280 FOR i = 1 TO 20 : PRINT #1, "PIN";i;CHR$(9); : NEXT
285 PRINT #1
290 CLOSE #1
300 '
310 ' start the loop
320 TIME$ = "00:00:00"       ' zero the time
330 DO
340   TIMER = 0              ' used to time one second
350   t = t - 1
360   IF t <= 0 THEN         ' clear screen every 10 loops
370     PRINT CHR$(27) + "[2J";
380     CLS
390     t = 10
400   ENDIF
410   ' position the cursor at the top of the screen
420   LOCATE 0, 0            ' Cursor home (video)
430   PRINT CHR$(27) + "[H"; ' Cursor home (USB)
440   LOCATE 0, 0            ' Cursor home (video)
450   PRINT "    Run Time: "; TIME$: PRINT
460   ' da$ is used to hold the analog data for the card
465   ' dd$ is used to hold the digital data
470   da$ = TIME$ + CHR$(9) : dd$ = ""
480   FOR i = 1 TO 10
485     ' handle the analog pins
490     PRINT "    Pin "; FORMAT$(i, "%2g = ");
520     PRINT FORMAT$(PIN(i) * 0.995, "%1.3f"); "V      ";
530     da$ = da$ + STR$(PIN(i)) + CHR$(9)
550     ' handle the digital inputs
555     PRINT "    Pin "; FORMAT$(i+10, "%2g = ");
560     IF PIN(i+10) THEN PRINT "HIGH" ELSE PRINT "LOW "
570     dd$ = dd$ + STR$(PIN(i+10)) + CHR$(9)
600   NEXT i
610   OPEN "DATALOG.XLS" FOR append AS #1
620   PRINT #1, da$; dd$
630   CLOSE #1
640   '
650   ' wait for the one second mark to come up
660   DO WHILE TIMER < 1000 : LOOP
670 LOOP
