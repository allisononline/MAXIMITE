LIBRARY LOAD "FINVSQR.LIB"

TIMER = 0
FOR ifn = 0 TO 1000
    JUNK = 1/SQR(RND())
NEXT
PRINT TIMER