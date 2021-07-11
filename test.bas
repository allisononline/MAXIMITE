i% = 1
curr! = 1 / i%
prev! = 0
Do
    Print curr!
    Inc i%, 2
    prev! = curr!
    curr! = 1 / i%
Loop Until curr! = prev!
