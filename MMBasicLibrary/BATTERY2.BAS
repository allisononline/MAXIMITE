100 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
110 ' BATTERY.BAS
120 ' Program to test the capacity of a battery
130 ' V2.0   Geoff Graham   Jan 2011
140 '
150 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
160 '
170 ' This is an extended version of the battery test program described in
180 ' the May 2011 issue of Silicon Chip.  Additional features include:
190 '  - Will draw a graph of the battery voltage on the video output
200 '  - Choice of a constant current, power or resistance type of load
210 '  - Ability to save the data in an Excel compatible file
220 '  - Optional ability to use 5 relays for a finer level of load control
230 '
240 ' See the Silicon Chip article or the accompanying PDF for circuit details
250 '
260 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
270 '
280 ' Measured resistance of the five load resistors
290 ' These are constant values determined by measuring the actual resistance
300 ' with a digital multimeter.  They must be in descending order of values
310 ' if you only have 4 relays set the value of R5 to a very low value (eg, 0.0001)
320 '
330 R1 = 59.228
340 R2 = 29.789
350 R3 = 14.944
360 R4 =  7.516
370 R5 =  3.789
380 '
390 ' Correction for any error in measuring voltage (ie. actual V / Maximite V)
400 VCorrect = 1.019
410 '
420 ' default settings
430 DefaultType$ = "C"               ' constant current
440 DefaultBLoad = 200               ' load of 200 mA or mW
445 DefaultRLoad = 25                ' resistive load 25 ohms
450 DefaultThreshold = 0.9           ' cutout voltage to stop the test
460 '
470 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
480 MaxHist = 100 * 60        ' maximum history to be saved (in minutes)
490 Dim Hist(MaxHist)         ' array for holding the history data
500 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
510 ' Program Start
520 ' The program returns to here when the test has finished
530 '
540 ' Configure the input and output pins
550 Pin(11) = 1 : Pin(12) = 1 : Pin(13) = 1 : Pin(14) = 1 : Pin(15) = 1
560 SetPin 11, 9 : SetPin 12, 9 : SetPin 13, 9 : SetPin 14, 9 : SetPin 15, 9
570 SetPin 1,1
580 '
590 HScale = 2
595 mAhours = 0
600 '
610 Pin(0) = 1 : Print : Print : Cls
620 '
630 ' Get the test parameters from the user
640 Print "Battery capacity test utility V2.0"
650 ' define constants and arrays
655 Do
660   Print
670   Print "C = Constant current drain"
680   Print "P = Constant power drain"
690   Print "R = Constant resistive load"
700   Print "Select (default is "; DefaultType$; ") ";
710   Input Type$
715   If Asc(Type$) = 0 Then Type$ = DefaultType$
720   Type$ = Left$(UCase$(Type$), 1)
725 Loop Until Type$ = "C" Or Type$ = "P" Or Type$ = "R"
730 Print
740 '
750 If Type$ = "C" Then
760   Do
770     Print "Range is 600mA to 20mA"
780     Print "Enter current drain (default is"; DefaultBLoad; ") ";
790     Input BLoad
795     If BLoad = 0 Then Bload = DefaultBLoad
800   Loop While BLoad > 600 Or BLoad < 20
810 ElseIf Type$ = "P" Then
820   Do
830     Print "Range is 750mW to 25mW"
840     Print "Enter power drain (default is"; DefaultBLoad; ") ";
850     Input BLoad
855     If BLoad = 0 Then BLoad = DefaultBLoad
860   Loop While BLoad > 750 Or BLoad < 25
870 ElseIf Type$ = "R" Then
880   Do
900     Print "Range is 60 ohms to 1.8 ohms"
910     Print "Enter resistive load (default is"; DefaultRLoad; ") ";
920     Input BLoad
925     If BLoad = 0 Then BLoad = DefaultRLoad
930   Loop While BLoad > 60 And BLoad < 1.8
960 EndIf
970 '
975 Do
980   Print
990   Print "Enter the cutoff voltage (default is "; Format$(DefaultThreshold, "%3.1f"); ") ";
995   Print "Minimum cutoff is 0.5V"
1000   Input Threshold
1005   If Threshold = 0 Then Threshold = DefaultThreshold
1010 Loop While Threshold < 0.5 Or Threshold > 1.5
1020 Print
1030 '
1040 Do
1060   Input "Save the results to an Excel file (Y/N, default is N) ", SSave$
1070   SSave$ = Left$(UCase$(SSave$), 1)
1075   If Asc(SSave$) = 0 Then SSave$ = "N"
1080 Loop While Not(SSave$ = "Y" Or SSave$ = "N")
1089 '
1090 If SSave$ = "Y" Then
1100   Line Input "Filename (without an extension): "; FName$
1110   Open Left$(FName$, 8) + ".xls" For output As #1
1120   Line Input "Description of battery under test: "; R$
1130   Print #1, R$
1140   If Type$ = "C" Then Print #1, "Constant current of"; BLoad; "mA.  Cutoff at"; Threshold; "V"
1150   If Type$ = "P" Then Print #1, "Constant power of"; BLoad; "mW.  Cutoff at"; Threshold; "V"
1160   If Type$ = "R" Then Print #1, "Constant resistance of"; BLoad; " ohms.  Cutoff at"; Threshold; "V"
1170   Print #1 : Print #1, "Time", "Voltage", "Current", "mAH"
1180 EndIf
1190 '
1200 Print
1210 Line Input "Press ENTER to start the test "; T$
1220 Pin(15) = 0 : Pause 200                ' discharge any floating voltage
1230 Do While Pin(1) * VCorrect <= Threshold
1240   Print "Battery not inserted or not charged (voltage ="; Pin(1) * VCorrect; ")"
1250   Print "Insert battery to continue ";
1260   While Pin(1) * VCorrect <= Threshold : Wend
1270   Pause 750
1280 Loop
1290 '
1300 VScale = (Int(Pin(1) * VCorrect * 10) + 1)  ' set the vertical scale
1310 iHist = 0                                   ' zero the history
1320 GoSub 2790                                  ' draw the graph axies
1330 '
1340 Time$ = "00:00:00" : LASTTIME$ = "00:00:00" ' init the starting time
1350 BattV = Pin(1) * VCorrect                   ' initialise the battery voltage
1360 VStart = BattV
1370 VAverage = 0 : AveCnt = 0
1380 '
1390 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
1400 ' Main test loop
1410 Do
1420   '
1430   If Type$ = "C" Then
1440     ' Calculate the setting required to draw the test current
1450     PrevTL = (BattV/R1) * 1000
1460     For i = 2 To 31
1470       TL = 0
1480       If i And &b00001 Then TL = TL + BattV/R1
1490       If i And &b00010 Then TL = TL + BattV/R2
1500       If i And &b00100 Then TL = TL + BattV/R3
1510       If i And &b01000 Then TL = TL + BattV/R4
1520       If i And &b10000 Then TL = TL + BattV/R5
1530       TL = TL * 1000
1540       If PrevTL + (TL - PrevTL) / 2 > BLoad Then Exit For
1550       PrevTL = TL
1560     Next i
1570   ElseIf Type$ = "P" Then
1580     ' Calculate the setting required to draw the test power
1590     PrevTL = ((BattV * BattV)/R1) * 1000
1600     For i = 2 To 31
1610       TL = 0
1620       If i And &b00001 Then TL = TL + (BattV * BattV)/R1
1630       If i And &b00010 Then TL = TL + (BattV * BattV)/R2
1640       If i And &b00100 Then TL = TL + (BattV * BattV)/R3
1650       If i And &b01000 Then TL = TL + (BattV * BattV)/R4
1660       If i And &b10000 Then TL = TL + (BattV * BattV)/R5
1670       TL = TL * 1000
1680       If PrevTL + (TL - PrevTL) / 2 > BLoad Then Exit For
1690       PrevTL = TL
1700     Next i
1710   ElseIf Type$ = "R" Then
1720     ' Calculate the setting required to draw the test resistance
1730     PrevTL = R1
1740     For i = 2 To 31
1750       TL = 100000000
1760       If i And &b00001 Then TL = (TL * R1) / (TL + R1)
1770       If i And &b00010 Then TL = (TL * R2) / (TL + R2)
1780       If i And &b00100 Then TL = (TL * R3) / (TL + R3)
1790       If i And &b01000 Then TL = (TL * R4) / (TL + R4)
1800       If i And &b10000 Then TL = (TL * R5) / (TL + R5)
1810       If PrevTL - (PrevTL - TL) / 2 < BLoad Then Exit For
1820       PrevTL = TL
1830     Next i
1840     ' print "Selected nearest value of"; PrevTL; " ohms"
1850   Else
1860    Error "Invalid Type$"
1870   EndIf
1880   '
1890   i = i - 1
1900   '
1910   ' Set the reed relays to create the test load
1920   Pin(11) = Not(i And &b00001)
1930   Pin(12) = Not(i And &b00010)
1940   Pin(13) = Not(i And &b00100)
1950   Pin(14) = Not(i And &b01000)
1960   Pin(15) = Not(i And &b10000)
1970   '
1980   ' calculate the current drain at this setting
1990   TC = 0
2000   If i And &b00001 Then TC = TC + BattV/R1
2010   If i And &b00010 Then TC = TC + BattV/R2
2020   If i And &b00100 Then TC = TC + BattV/R3
2030   If i And &b01000 Then TC = TC + BattV/R4
2040   If i And &b10000 Then TC = TC + BattV/R5
2050   TC = TC * 1000                           ' current drain in mA
2060   mAhours = mAhours + TC/3600              ' accumulate the mAH reading for each second
2070   '
2080   ' every minute update the display
2090   If Right$(Time$, 2) = "00" Then
2100     Hist(iHist) = BattV : iHist = iHist + 1
2110     If iHist > MaxHist Then GoTo 2330
2120     If iHist > HScale * 60 Then
2130       HScale = HScale + 1
2140       GoSub 2790                           ' redraw the graph scale
2150     EndIf
2160     GoSub 2660                             ' add this reading to the graph
2170     GoSub 3090                             ' print the running summary
2180   EndIf
2190   '
2200   ' wait for the next second
2210   LoopCount = 1
2220   Do While Time$ = LASTTIME$
2230     BattV = BattV + Pin(1) * VCorrect      ' while we are waiting make many measurements
2240     LoopCount = LoopCount + 1              ' count the number of measurements
2250   Loop
2260   LASTTIME$ = Time$
2270   BattV = BattV/LoopCount                  ' and average
2280   '
2290 VAverage = VAverage + BattV : AveCnt = AveCnt + 1
2300 Loop While BattV >= Threshold
2310 '
2320 ' the test has finished - remove the load
2330 Pin(11) = 1 : Pin(12) = 1 : Pin(13) = 1 : Pin(14) = 1 : Pin(15) = 1
2340 '
2350 '
2360 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2370 ' print the summary
2380 GoSub 3090                                 ' update the running summary
2390 Print : T$ = "Test complete.  "
2400 T$ = T$ + "Battery capacity is " + Format$(mAhours, "%1.0fmAH") + " at a constant "
2410 If Type$ = "C" Then T$ = T$ + "current of" + Str$(BLoad) + "mA."
2420 If Type$ = "P" Then T$ = T$ + "power of" + Str$(BLoad) + "mW."
2430 If Type$ = "R" Then T$ = T$ + "resistance of" + Str$(BLoad) + " ohms."
2440 If SSave$ = "Y" Then Print #1 : Print #1 : Print #1, T$
2450 Print "  " + T$
2460 T$ = "Start voltage = " + Format$(VStart, "%3.2f") + ".  End voltage = " + Format$(BattV, "%3.2f")
2470 T$ = T$ + ".  Average voltage = " + Format$(VAverage/AveCnt, "%3.2f") + "."
2480 If SSave$ = "Y" Then Print #1, T$
2490 Print "    " + T$
2500 If SSave$ = "Y" Then Close #1
2510 '
2520 Print "    Press ENTER to test again or CTRL-C to quit...";
2530 Do                                          ' flash LED while waiting
2540   Pause 200 : If Inkey$ = Chr$(&H0D) Then GoTo 500
2550   Pin(0) = 0 : Pause 100 : Pin(0) = 1 : If Inkey$ = Chr$(&H0D) Then GoTo 500
2560 Loop
2570 '
2580 '
2590 '
2600 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2610 ' SUBROUTINES
2620 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2630 '
2640 ' Subroutine to print the trend line on the graph
2650 '
2660 For i = 1 To iHist - 1
2670   x1 = margin + (width / (HScale * 60)) * (i - 1)
2680   x2 = margin + (width / (HScale * 60)) * (i)
2690   y1 = height - ((Hist(i - 1) * 10) / VScale) * height
2700   y2 = height - ((Hist(i) * 10) / VScale) * height
2710   Line (x1, y1) - (x2, y2), 1
2720 Next i
2730 Return
2740 '
2750 '
2760 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2770 ' Subroutine to print the graph axies
2780 '
2790 height = MM.VRes - 100 : margin = 45 : width = MM.HRes - margin - 12
2800 '
2810 Cls
2820 Line (margin,height)-(margin, 0), 1 ' Draw the vert line
2830 Line (margin,height)-(margin + width ,height), 1  ' Draw the horiz line
2840 For i = 0 To VScale                        ' This loop draws the tick marks
2850   h = height - (height / VScale) * i
2860   t = margin - 5
2870   If i Mod 5 = 0 Then                      ' Special mark for a unit of 0.1V
2880     Locate margin - 42, h - 3
2890     If h - 3 < 0 Then Locate margin - 42, 0 ' fix if we are off the screen
2900     Print Left$(Format$(i/10,"%f"),3);"V"; ' Label the tick mark
2910     t = margin - 15
2920   EndIf
2930   Line (margin, h)-(t, h), 1               ' Draw the tick mark
2940 Next i
2950 For i = 0 To HScale
2960   t = margin + (width/Hscale) * i
2970   Line (t, height)-(t, height + 9), 1
2980   If i < 10 Then Locate t - 8, height + 14 Else Locate t - 11, height + 14
2990   Print i;
3000 Next i
3010 Locate margin + width/2 - 14, height + 25
3020 Print "Hours"
3030 Return
3040 '
3050 '
3060 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
3070 ' Subroutine to print the summary data below the graph
3080 '
3090 T$ = Left$(Time$, 5) + "    " + Format$(BattV, "%5.3fV  ") + "  " + Format$(TC, "%5.1fmA  ")
3100 T$ = T$ + " " + Format$(mAhours, "%5.0fmAH")
3110 Locate margin + (width - (Len(T$) * 6)) / 2, height + 40
3120 Print t$
3130 If SSave$ = "Y" Then Print #1, (iHist - 1)/60, BattV, TC, mAhours
3140 Return
3150 '
