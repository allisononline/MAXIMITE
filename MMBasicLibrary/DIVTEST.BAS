    ' Division practice for 6 year olds
    ' Author: YT2059 on The Back Shed forum
    ' Line numbers removed and DO loops added by Hugh Buckle

    Do
      CLS
      RANDOMIZE TIMER
      a=INT(RND(1)*91)+10
      b=INT(RND(1)*10)+1
      c=a/b
      m=a MOD b

      Do 
        Do
          PRINT a " /" b " =";
          INPUT d
          IF INT(c)<> d then Gosub Wrong
        Loop until INT(c)=d

        PRINT "remainder= ";
        INPUT r
        IF r<> m then Gosub Wrong
       Loop until r=m

     GOsub Excellent
    Loop

Excellent:
    REM well done
    PRINT " "
    PRINT "Well Done!"
    FOR i = 20 TO 200 STEP 10
      FOR q=20 TO 2000 STEP i
        SOUND q,10,50
        PAUSE 10
      NEXT q
    NEXT i
    Return

Wrong:
    REM Wrong
    PRINT "Wrong, Try again."
    PRINT " "
    FOR q=2000 TO 20 STEP -40
      SOUND q,10,50
      PAUSE 10
    NEXT q
    Return