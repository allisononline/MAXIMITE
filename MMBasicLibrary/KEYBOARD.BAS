100 PRINT "This program will print the characters received from"
110 PRINT "the keyboard (directly or connected via USB)."
120 PRINT "Use CTRL-C to exit the program."
130 '
140 DO
150   TIMER = 0             ' used to detect a group of keys
160   '
170   ' this loop will get a character from the keyboard
180   ' also it will print a blank line between groups of
190   ' characters received at high speed (ie, via USB)
200   DO
210     a$ = INKEY$         ' get the character
220     IF TIMER = 100 THEN TIMER = 101 : PRINT
230   LOOP WHILE a$ = ""
240   '
250   ' print the character in an easy to read format
260   PRINT "DECIMAL = "; FORMAT$(ASC(a$), "%3g");
270   PRINT "    ASCII = ";
280   IF a$ >= " " AND a$ <= "~" THEN PRINT a$;
290   PRINT 
300   '
310 LOOP
