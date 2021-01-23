' Dump a text file to screen, page by page, wrapping lines if required.
' Lines must be <= 255 characters
' Author: Rodney Entwistle from a UNIX idea in the 1980s
'
Input "Enter filename: ",fname$
Open fname$ For input As #1
lines_per_page=34  'integer
ch_per_line=75     'integer
count=0:line_no=1
Do
  Font #1,1,1:Print Format$(line_no,"%4.0f");:Font #1,1,0
  Line Input #1,a$  'len(a$)>255 not allowed
  wraps=Fix(Len(a$)/ch_per_line)+1 'how many screen lines?
  If ((Len(a$) Mod ch_per_line)=0) And (Len(a$)<>0) Then
   wraps=wraps-1   'Take care of special cases
  EndIf
  For i=1 To wraps
    Print Tab(6);Mid$(a$,(i-1)*ch_per_line+1,ch_per_line)
    count=count+1
    If count=lines_per_page Then
      Print Chr$(10);Chr$(13);: Font #1,1,1
      Print "  Press space bar for next page or 'q' to end: ";:Font #1,1,0
key:  Do: b$=Inkey$: Loop Until b$<>""  'Wait for space bar press
      If b$="q" Or b$="Q" Then GoTo finish
      If b$<>Chr$(32) Then GoTo key
      Print Chr$(10);Chr$(13);  ' move to new line
      count=0
    EndIf
  Next
  line_no=line_no+1
Loop Until Eof(#1)
finish:  Close #1
