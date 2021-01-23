'****** Program for setting and reading time on DS1307 Real Time Clock
'****** Author: Ian Quirk 
 CLS

 INPUT "Do you want to set the external clock"; temp$
 if temp$ <> "y" and temp$ <> "Y" GOTO Readtime
 Start_i2c_clock
 INPUT "Do you want to set Time (T) Date (D) or Both (B)"; temp$
 if temp$ = "T" or temp$ = "t" then
 SetTime
 elseif temp$ = "D" or temp$ = "d" then
 SetDate
 ElseIf temp$ = "B" or temp$ = "b" then
 SetTime
 SetDate
  ENDIF
' CLS
Readtime:
 delay = 10000
 
DO WHILE a$ = ""
   a$ = INKEY$
 read_i2cRTC (minutes,hours,days,months,year)
  
   'LOCATE 50, 50
   PRINT "Confirming I2C Time"
   PRINT Hours;": ";minutes;"   ";days;"/";months;"/";year+2000
   PRINT "internal time"
   print TIME$, DATE$
   PAUSE delay
 LOOP
	''''''''''''''
'get time subroutine  insert this subroutine to set Maximite time from dsi307
' readi2cRTC and bcd_bin also required.
'''''''''''''''''''''
  GetTime:          ' Get time and date
  read_i2cRTC (minutes,hours,days,months,year)
  in$ = FORMAT$(days)+"-"+ FORMAT$(months) +"-"+ FORMAT$(year+2000)
     Date$ = in$
    in$ = FORMAT$(Hours) +":"+ FORMAT$(minutes)
     Time$ = in$
     Return

''''''''''''''
'set time subroutine
'''''''''''''''''''''
 SUB SetTime:          ' set time 
  local t1$, hrs, mins
  Print "Enter Time  HH : MM "
  Input in$
   Time$ = in$
  t1$ = "&h"+LEFT$(in$,2)
  hrs = VAL(t1$)
  t1$ = "&h"+RIGHT$(in$,2)
  mins = VAL(t1$)
' bin_bcd (mins,hrs) 
	print hrs;": ";mins,
	 Set_i2cRTC ( 1,mins,hrs,0)
	 
     END SUB
     
	 	''''''''''''''
'set Date subroutine
'''''''''''''''''''''
 SUB SetDate:          ' set  date
  local t1$, temp, in$
  Print "Enter Date DD/MM/YY "
  Input in$
  t1$ = "&h"+LEFT$(in$,2)   ' make equivelent hex string = BCD
  dys = VAL(t1$)
  t1$ = "&h"+mid$(in$,4,2)
  mths = VAL(t1$)
  t1$ = "&h"+RIGHT$(in$,2)
  yr = VAL(t1$)
  Date$ = (LEFT$(in$,6) +"20"+RIGHT$(in$,2))
	 temp = 0
   Set_i2cRTC ( 4,dys,mths,yr)
     END SUB
   '------------------------------------------------
' Initalise RTC and turm off square wave out and zer0 Seconds regesters  
'------------------------------------------------------------------- 
   SUB Start_i2c_clock:
   I2CEN 100, 100			' i2c enable 100kHz, 100ms timeout
  I2CSEND  &h68, 0, 2,0,0	' i2c send adress, option, send length, data,data..
   I2CSEND  &h68, 0, 2,7,0	' i2c send adress, option, send length, data,data..
  I2CDIS			' i2c disable   
      END SUB
  '-------------------------------------------------------
'*******Sub to Read DS1307 RTC and return *************
'       Minutes
'       Hours
'       Date (day of Month)
'       Month
'       Year ( 2 didget can add 20 to front)
'*****************************************************  
  SUB read_i2cRTC (min,hrs,dys,mth,yr)
  Local temp(8), tmp
 ' MSb Bit6 Bit5 Bit4 Bit3 Bit2 Bit1 LSb
 I2CEN 100, 100			' i2c enable 100kHz, 200ms timeout
 I2CRCV &h68, 0, 6, temp(0),1,&h01		' i2c read adress, option, recieve length, rec buffer
 print "Result = "; MM.i2c
 I2CDIS			' i2c disable
	tmp = temp(0)
  bcd_bin (tmp,min)
	tmp = temp(1)
  bcd_bin (tmp,hrs)
	tmp = temp(3)
  bcd_bin (tmp,dys)
	tmp = temp(4)
  bcd_bin (tmp,mth)
	tmp  = temp(5)
  bcd_bin (tmp,yr)
 
   END SUB
   
 '----------------------------------------------------------------
'******************Sub Procedure Write data to DS13207 RTC********
'------------------------------------------------------------------- 
    SUB Set_i2cRTC (SAdrs,Dat1,Dat2,Dat3)
  Local temp(4) 
   temp(0) = SAdrs
	  temp(1) = Dat1
	  temp(2) = Dat2
    temp(3) =  Dat3
    print
    print temp(0), temp(1), temp(2), temp(3)
 ' MSb Bit6 Bit5 Bit4 Bit3 Bit2 Bit1 LSb
 I2CEN 100, 100			' i2c enable 100kHz, 100ms timeout
 I2CSEND &h68, 0, 2,temp(0)		' i2c send adress, option, send length, data,data..
  I2CDIS			' i2c disable
  END SUB
  
'-----------------------------------------------------
'***** Sub Procedure - convert BCD to binary *****
'----------------------------------------------------
SUB bcd_bin (Val,Vout)
local temp
	' convert the DS1307 BCD values to binary
	temp = val AND &b00001111
	Vout = (val AND &b11110000) * 10 / 16 + temp
	
 	END SUB
