   ' ANALOG CLOCK
   ' Case Study Problem B3: Program 1
   ' ---------------------------------------------------------------------------
   ' written by Eugene Villar http://seavsoftwares.codedgraphic.com/home_page.html
   ' ~ This program draws a very simple analog clock.
   ' modified for Maximite BASIC by Bob Devries
   ' modified for colour by Geoff Graham

   If MM.Device$ <> "Colour Maximite" Then
      Print "This program requires the Colour Maximite"
      End
   EndIf

   Timer = Val(Left$(Time$,2)) * 3600 + Val(Mid$(Time$,4,2)) * 60 + Val(Right$(Time$,2))
   ' Clock border
   Mode 3
   Cls
   Line(0,0)-(480,432),Cyan,BF:Line(11,12)-(469,421),0,BF
   GoSub L001
   Colour Green
   Locate 20,20:Print "MAXIMITE"
   Locate 20,30:Print "MMBASIC v";:GoSub L002 :Print version$;
   Colour White
   Circle(240,216), 200, Yellow
   Circle(240,216),199, Yellow
   For i=0 To 59
   rads=i*3.14159265/30
   If i Mod 5 <> 0 Then
   x1=Sin(rads)*195+240
   y1=-Cos(rads)*195+216
   Else
   x1=Sin(rads)*190+240
   y1=-Cos(rads)*190+216
   EndIf
   x2=Sin(rads)*200+240
   y2=-Cos(rads)*200+216
   Line(x1,y1)-(x2,y2),Yellow
   Next i
   ' Previous hand positions
   PHrX = 240: PHrY = 216
   PMnX = 240: PMnY = 216
   PScX = 240: PScY = 216
   ' Clock display loop
   Do
     ' Wait for a second to elapse
   t$=Time$: Timed = Val(Left$(t$,2)) * 3600 + Val(Mid$(t$,4,2)) * 60 + Val(Right$(t$,2))
   Do
   Pin(0)=0
   Pause 999
   Pin(0)=1
   Loop Until Int(Timer)/1000 <> Timed
     ' Calculate the time values
   T$=Time$:TimeNow = Val(Left$(T$,2)) * 3600 + Val(Mid$(t$,4,2)) * 60 + Val(Right$(t$,2))
   Second = TimeNow Mod 60
   Minute = (TimeNow \ 60) Mod 60
   Minute = Minute + Second \ 60
   Hour = TimeNow / 3600
     If Hour >= 12 Then Hour = Hour - 12
     ' Compute the angles (converted to radians)
     HrAng = .523599 * (Hour + Minute/60)
     MnAng = .10472 * (Minute + Second/60)
     ScAng = .10472 * Second
     ' Compute the hands' endpoints
   HrX = Sin(HrAng) * 120 + 240: HrY = 0 - Cos(HrAng) * 120 + 216
   MnX = Sin(MnAng) * 180 + 240: MnY = 0 - Cos(MnAng) * 180 + 216
   ScX = Sin(ScAng) * 190 + 240: ScY = 0 - Cos(ScAng) * 190 + 216

     ' make the tick sound
     Sound 3000, 5, 1

     ' Draw the current hands
     ' we erase then immediately redraw to avoid flicker
     ' then one final redraw incase the hands overlapped
   Line(240, 216)-(PScx, PScy),0     ' Erase the previous second hand
   Line(240, 216)-(ScX, ScY),Red     ' Draw the second hand
   Line(240, 216)-(PMnx, PMny),0     ' Erase the previous minute hand
   Line(240, 216)-(MnX, MnY),Purple  ' Draw the minute hand
   Line(240, 216)-(PHrx, PHry),0     ' Erase the previous hour hand
   Line(240, 216)-(HrX, HrY),Purple  ' Draw the hour hand

     ' Save the hands' position
     PHrX = HrX: PHrY = HrY
     PMnX = MnX: PMnY = MnY
     PScX = ScX: PScY = ScY
   Loop Until Inkey$ = Chr$(27)
   End
L001: 'WeekDay.bas    Ray Thomas      September 2000
   Dim TxtDay$(7)
   Dim TxtMonth$(12)
   Data "Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"
   Data "January","February","March","April","May","June","July"
   Data "August","September","October","November","December"
   For Count = 0 To 6
          Read TxtDay$(Count)
   Next Count
   For Count = 0 To 11
          Read TxtMonth$(Count)
   Next Count
   UserDate$ = Date$
   '*** Split out the day, month and year ***
   Day = Val(Left$(UserDate$, 2))
   Month = Val(Mid$(UserDate$, 4, 2))
   Year = Val(Right$(UserDate$, 4))
   OldYear = Year
   OldMonth=Month
   '*** start the print out
   Suffix$ = "th"
   If Day Mod 10 = 1 Then Suffix$ = "st"
   If Day Mod 10 = 2 Then Suffix$ = "nd"
   If Day Mod 10 = 3 Then Suffix$ = "rd"
   If Day > 10 And Day < 14 Then Suffix$ = "th"
   '*** For any date in Jan or Feb add 12 to the month and
   '*** subtract 1 from the year
   If Month < 3 Then
          Month = Month + 12
          Year = Year - 1
   EndIf
   '*** Add 1 to the month and multiply by 2.61
   '*** Drop the fraction (not round) afterwards
   Month = Month + 1
   Month = Fix(Month * 2.61)
   '*** Add Day, Month and the last two digits of the year
   NewYear$ = Str$(Year)
   Year = Val(Right$(NewYear$, 2))
   DMY = Day + Month + Year
   Century = Val(Left$(NewYear$, 2))
   '*** Add a quarter of the last two digits of the year
   '*** (truncated not rounded)
   Year = Fix(Year / 4)
   DMY = DMY + Year
   '*** Add the following factors for the year
   If Century = 18 Then Century = 2
   If Century = 19 Then Century = 0
   If Century = 20 Then Century = 6
   If Century = 21 Then Century = 4
   DMY = DMY + Century
   '*** The day of the week is the modulus of DMY divided by 7
   DMY = DMY Mod 7
   prt$=TxtDay$(DMY)+", "+Str$(Day)+Suffix$+" of "+TxtMonth$(OldMonth-1)+", "+Str$(OldYear)
   prtlen=Len(prt$)
   Locate (480-(prtlen*6))/2,0:Print CLR$(Black, Cyan) prt$
   Return
L002: ver$=Str$(MM.Ver)
L003: verpos=Instr(ver$,".")
   If verpos = 0 Then ver$=ver$+".0":GoTo L003
   ver1$=Left$(ver$,verpos-1)
   ver2$=Mid$(ver$,verpos+1,2)
   ver3$=Right$(ver$,Len(ver$)-verpos)
   ver4$=Str$(Val(Left$(ver3$,2)))
   If Len(ver3$)>2 Then ver5=Val(Right$(ver3$,2)):ver5$=Chr$(ver5+64)
   version$=ver1$+"."+ver4$+ver5$
   Return
