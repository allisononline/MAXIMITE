100 ' BATTERY.BAS
105 ' Program to test the capacity of a battery
110 ' See Silicon Chip May 2011 for circuit details
115 ' V1.0
120 '
125 '
130 ' Measured resistance of the four load resistors
135 ' These are constant values determined by measuring the actual resistance
140 ' with a digital multimeter.  They must be in descending order of values
145 R1 = 56.00
150 R2 = 22.00
155 R3 =  8.20
160 R4 =  3.33
165 '
170 ' Measured value of the 3.3 volt supply
175 Vdd = 3.29
180 '
185 '
190 ' Default terminating voltage level and test current
195 TerminatingVolts = 1.0
200 TestCurrent = 120
205 '
210 '
215 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
220 ' Configure the input and output pins
225 PIN(11) = 1 : PIN(12) = 1 : PIN(13) = 1 : PIN(14) = 1
230 SETPIN 11, 9 : SETPIN 12, 9 : SETPIN 13, 9 : SETPIN 14, 9
235 SETPIN 1,1
240 '
245 '
250 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
255 ' Get the operating parameters from the user
260 ' check each response to make sure that it is within acceptable range
265 '
270 CLS : PRINT "Battery test V1.0" : PRINT
275 DO
280   INPUT "Enter the approx test current in mA (600 to 25): ", TestCurrent
285 LOOP WHILE TestCurrent < 25 OR TestCurrent > 600
290 '
295 DO
300   PRINT "Enter the terminating voltage ";
305   PRINT "(default "; FORMAT$(TerminatingVolts, "%4.2f"); "): ";
310   INPUT "", TerminatingVolts
315 LOOP WHILE TerminatingVolts < 0.5 OR TerminatingVolts > 2
320 '
325 PRINT
330 IF PIN(1) / 3.3 * Vdd < TerminatingVolts THEN
335   PRINT "To start the test place the charged battery in the holder";
340   DO : LOOP WHILE PIN(1) / 3.3 * Vdd < TerminatingVolts
345   PRINT : PRINT
350 ENDIF
355 '
360 '
365 '
370 TIME$ = "0:0:0"
375 LASTTIME$ = TIME$
380 PRINT "TIME    ", "VOLTS   ", "CURRENT", "     ACCUMULATED"
385 PRINT "========================================================"
390 '
395 '
400 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
405 ' Main test loop
410 DO
415   BattV = PIN(1) / 3.3 * Vdd              ' measure the battery voltage
420   '
425   ' Calculate the setting required to draw the test current
430   PrevTC = BattV/R1 * 1000
435   FOR i = 2 TO 15
440     TC = 0
445     IF i AND &b0001 THEN TC = TC + BattV/R1
450     IF i AND &b0010 THEN TC = TC + BattV/R2
455     IF i AND &b0100 THEN TC = TC + BattV/R3
460     IF i AND &b1000 THEN TC = TC + BattV/R4
465     TC = TC * 1000
470     IF PrevTC + (TC - PrevTC) / 2 > TestCurrent THEN EXIT FOR
475     PrevTC = TC
480   NEXT i
485   i = i - 1
490   '
495   ' Set the reed relays to draw the test current
500   PIN(11) = NOT(i AND &b0001)
505   PIN(12) = NOT(i AND &b0010)
510   PIN(13) = NOT(i AND &b0100)
515   PIN(14) = NOT(i AND &b1000)
520   '
525   mAhours = mAhours + PrevTC/3600        ' accumulate the mAH reading
530   '
535   IF RIGHT$(TIME$, 2) = "00" THEN
540     PRINT TIME$,FORMAT$(BattV, "%5.3fV  "),FORMAT$(PrevTC, "%5.1fmA  "),; 
545     PRINT FORMAT$(mAhours, "%5.0fmAH")
550   ENDIF
555   '
560   ' wait for the next second
565   DO WHILE TIME$ = LASTTIME$ : LOOP
570   LASTTIME$ = TIME$
575   '
580 LOOP WHILE BattV > TerminatingVolts
585 '
590 PIN(11) = 1 : PIN(12) = 1 : PIN(13) = 1 : PIN(14) = 1
595 '
600 '
605 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
610 ' print the summary
615 PRINT : PRINT "Test complete.  ";
620 PRINT "Battery capacity is "; FORMAT$(mAhours, "%5.0fmAH")
625 PRINT : PRINT
