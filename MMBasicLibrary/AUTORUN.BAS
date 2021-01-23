 10 ' Sample AUTORUN.BAS file
 20 '
 30 ' set the programmable function keys
 40 OPTION F1 "RUN"+CHR$(13)
 50 OPTION F2 "SAVE"+CHR$(13)
 60 OPTION F3 "LIST"+CHR$(13)
 70 OPTION F4 "EDIT "
 80 OPTION F5 "RUN "+CHR$(34)
 90 OPTION F6 "SAVE "+CHR$(34)
100 OPTION F7 "LIST "
110 OPTION F8 "PRINT "
120 OPTION F9 "IF "
130 OPTION F10 "ENDIF"
140 OPTION F11 "FOR "
150 OPTION F12 "NEXT "
160'
170' set the prompt to show the current directory
180 OPTION PROMPT CWD$ + "> "
190'
200' clear this program from memory
210 NEW

