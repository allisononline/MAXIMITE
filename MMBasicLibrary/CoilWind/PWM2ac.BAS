    ' PWM2ac.bas using Sound output pin
    ' Plus number of turns (total count)
    ' Mick Gulovsen, Ron Pugh
    ' This is the same as PWM2A.BAS but without line numbers and
    ' in a more structured programming form.

    Cls
    Line(100, 100) - (300, 150), 1, B ' draws a box
    Font 2 : Print@(120, 120) "Speed %"
    Line(300, 100) - (400, 150), 1, B
    Line(100, 250) - (250, 300), 1, B
    Font 2 : Print@(105, 270) "Turns Count"
    Line(300, 250) - (400, 300), 1, B

    SetPin 11,5

    Font 2    ' big print
    Soundit 30 ' init to 30/70 PWM
               ' 200 Hz duration about 33 minutes 50 % duty

    Do    ' loop for ever

       Do  ' Print count while waiting for change of Duty
         If Pin(11) <> A Then
           A=Pin(11)
           Font 2
           Print @(320,270) A
         EndIf
         I$=Inkey$
       Loop Until I$<>""

       If     I$="z" Then
         Soundit 15
       ElseIf I$="x" Then
         Soundit 20
       ElseIf I$="x" Then
         Soundit 25
       ElseIf I$="c" Then
         Soundit 40
       ElseIf I$="v" Then
         Soundit 50
       ElseIf I$="b" Then
         Soundit 60
       ElseIf I$="n" Then
         Soundit 75
       ElseIf I$="m" Then
         Soundit 100
       EndIf

    Loop

Sub Soundit Duty
    Sound 200, 2000000, Duty
    Print @(320,120) Duty;" "
End Sub
