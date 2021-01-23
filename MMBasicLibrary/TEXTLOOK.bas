' Dump a text file to screen, showing all printables and non-printables.
' Non-printables denoted by their ASCII codes
' Author: Rodney Entwistle from a Unix idea in the 1980s
'
Input "Enter filename: ",fname$  ' Dump this file
Open fname$ For input As #1
ch_per_line=12: lines_per_page=35  ' To fit screen size
count=0:line_no=1:ch_count=0   ' Initiate counters
Font 1,1,1:Print Format$(ch_count+1,"%5.0f");:Font 1,1,0 'Look after first line
Do  ' Sequentially read entire file
  a$=Input$(1,#1)   ' Read a single ASCII character"
  If (Asc(a$)>32 And Asc(a$)<>127) Then     ' Select printables
    Print "     ";a$;
  Else
    Print "  \";Format$(Asc(a$),"%03.0f");   ' Select non-printables
  EndIf
  count=count+1:ch_count=ch_count+1
  If count=ch_per_line Then   ' End of line
    line_no=line_no+1
    Font 1,1,1:Print Chr$(10);Chr$(13);Format$(ch_count+1,"%5.0f");:Font 1,1,0
    count=0
  EndIf
  If line_no=lines_per_page Then   ' End of page
    Font 1,1,1
    Print Chr$(13);"  Press space bar for next page or 'q' to end: ";
key:    Do: b$=Inkey$: Loop Until b$<>""  'Wait for key to be pressed
    If b$="q" Or b$="Q" Then GoTo finish
    If b$<>Chr$(32) Then GoTo key
    Print Chr$(10);Chr$(10);Chr$(13);  ' move to new line
    Print Format$(ch_count+1,"%5.0f");  ' Print character number
    Font 1,1,0
    line_no=0
  EndIf
Loop Until Eof(#1)
finish:  Close #1
