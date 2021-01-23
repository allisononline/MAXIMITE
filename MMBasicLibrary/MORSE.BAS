100 'SAMPLE PROGRAM TO DEMONSTRATE THE MAXIMITE
105 'Morse code - MORSE.BAS 20101211 Ver 1:00 Reg Gauci
110 '
115 'A dash = 3 dots.
120 'The space between the signals forming the same letter is equal to 1 dot
125 'The space between 2 letters is equal to 3 dots
130 'The space between 2 words is equal to 7 dots
135 'Change freq to change frequency (Hz) of the sound
140 'Change dit to change the tone spacing
145 freq = 2000 : dit = 40 : dah = dit*3 : WORDdelay = dit*3 : LINEdelay = dit*7
150 '
155 DIM morse$(122)
160 FOR A = 32 TO 122
165    READ morse$(A)
170 NEXT A
175 '
180 CLS
185 PRINT
190 PRINT:PRINT "Illegal characters are ignored." :PRINT
195 PRINT "CTRL+C to exit"
200 PRINT:PRINT "Type a message and see it appear as Morse Code." :PRINT
205 INPUT "What is your message "; message$
210 PRINT
215 '
220 L = LEN(message$)                           'L equals the number of character in the message
225 '
230 FOR char = 1 TO L                           'Loop L times
235   ch$ = morse$(ASC(MID$(message$,char,1)))  'enter the value of the read character from morse$ into chr$
240 '
245   FOR ditdah = 1 TO LEN(ch$)                'Loop for the number of dots and dashes in morse$
250     IF MID$(ch$, ditdah, 1) = " " THEN      'if a space is encountered print a space and pause for WORDdelay
255       PRINT " ";
260       PAUSE WORDdelay
265     ELSE
270       IF MID$(ch$, ditdah, 1) = "." THEN    'if a dot is encountered print a dit sound a dit and pause for length of a dit + WORDdelay
275         PRINT ".";
280         SOUND freq, dit
285         PIN(0) = 1
290         PAUSE dit
295         PIN(0) = 0
300         PAUSE WORDdelay
305       ELSE
310         PRINT "-";                          'otherwise it is a dah print a dah sound a dah and pause for length of a dah + WORDdelay
315         SOUND freq, dah
320         PIN(0) = 1
325         PAUSE dah
330         PIN(0) = 0
335         PAUSE WORDdelay
340       ENDIF
345     ENDIF
350   NEXT ditdah
355 PRINT " ";
360 NEXT char                                   'loop until all Morse items for current input are done
365 '
370 PRINT "   ";
375 PAUSE LINEdelay                             'Pause for the lenght of Wspc
380 '
385 PRINT : PRINT
390 INPUT "Go again (Y/N)"; Z$: IF UCASE$(LEFT$(Z$, 1))="Y" THEN 195
395 END
400 '
405 '
410 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
415    DATA    " "      '      space   32      
420    DATA    ""       '      !       33      
425    DATA    .-..-.   '      "       34      Quotation
430    DATA    ""       '      #       35      
435    DATA    ""       '      $       36      
440    DATA    ""       '      %       37      
445    DATA    ""       '      &       38      
450    DATA    .----.   '      '       39      Apostrophy
455    DATA    -.--.-   '      (       40      Bracket
460    DATA    -.--.-   '      )       41      Bracket
465    DATA    ""       '      *       42      
470    DATA    ""       '      +       43      
475    DATA    --..--   '      ,       44      Comma
480    DATA    -....-   '      -       45      Hyphen
485    DATA    .-.-.-   '      .       46      Full Stop
490    DATA    -..-.    '      /       47      Slash
495    DATA    -----    '      0       48      
500    DATA    .----    '      1       49      
505    DATA    ..---    '      2       50      
510    DATA    ...--    '      3       51      
515    DATA    ....-    '      4       52      
520    DATA    .....    '      5       53      
525    DATA    -....    '      6       54      
530    DATA    --...    '      7       55      
535    DATA    ---..    '      8       56      
540    DATA    ----.    '      9       57      
545    DATA    ---...   '      :       58      Colon
550    DATA    ""       '      ;       59      
555    DATA    ""       '      <       60      
560    DATA    -...-    '      =       61      Equal
565    DATA    ""       '      >       62      
570    DATA    ..--..   '      ?       63      Question
575    DATA    .--.-.   '      @       64      AT
580    DATA    .-       '      A       65      
585    DATA    -...     '      B       66      
590    DATA    -.-.     '      C       67      
595    DATA    -..      '      D       68      
600    DATA    .        '      E       69      
605    DATA    ..-.     '      F       70      
610    DATA    --.      '      G       71      
615    DATA    ....     '      H       72      
620    DATA    ..       '      I       73      
625    DATA    .---     '      J       74      
630    DATA    -.-      '      K       75      
635    DATA    .-..     '      L       76      
640    DATA    --       '      M       77      
645    DATA    -.       '      N       78      
650    DATA    ---      '      O       79      
655    DATA    .--.     '      P       80      
660    DATA    --.-     '      Q       81      
665    DATA    .-.      '      R       82      
670    DATA    ...      '      S       83      
675    DATA    -        '      T       84      
680    DATA    ..-      '      U       85      
685    DATA    ...-     '      V       86      
690    DATA    .--      '      w       87      
695    DATA    -..-     '      X       88      
700    DATA    -.--     '      Y       89      
705    DATA    --..     '      Z       90      
710    DATA    ""       '      [       91      
715    DATA    ""       '      \       92      
720    DATA    ""       '      ]       93      
725    DATA    ""       '      ^       94      
730    DATA    ""       '      _       95      
735    DATA    ""       '      `       96      
740    DATA    .-       '      a       97      
745    DATA    -...     '      b       98      
750    DATA    -.-.     '      c       99      
755    DATA    -..      '      d       100     
760    DATA    .        '      e       101     
765    DATA    ..-.     '      f       102     
770    DATA    --.      '      g       103     
775    DATA    ....     '      h       104     
780    DATA    ..       '      i       105     
785    DATA    .---     '      j       106     
790    DATA    -.-      '      k       107     
795    DATA    .-..     '      l       108     
800    DATA    --       '      m       109     
805    DATA    -.       '      n       110     
810    DATA    ---      '      o       111     
815    DATA    .--.     '      p       112     
820    DATA    --.-     '      q       113     
825    DATA    .-.      '      r       114     
830    DATA    ...      '      s       115     
835    DATA    -        '      t       116     
840    DATA    ..-      '      u       117     
845    DATA    ...-     '      v       118     
850    DATA    .--      '      w       119     
855    DATA    -..-     '      x       120     
860    DATA    -.--     '      y       121     
865    DATA    --..     '      z       122     
