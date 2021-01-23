''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Battery Management Program for Caravan 12V System                            '
' CVANBMON.BAS                                                                 '
' Copright Doug Pankhurst May 2012                                             '
' additional routines copyright Geoff Graham 2012                              '
' Written for MMBasic V4.0, copyright Geoff Graham 2012                        '
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' File Version:    0.81    11 Oct 2012                                         '
' Version Info:
' - add in intro palava
' - start implimentation of running graph
' - re-impliment arrays for bat and solar volts, input and load cuurent
' - base code stable, now start on graphing code
' - re-write averaging and log file code
' - changed log file to hourly writes
' - altered static display layout
' - use 1 sec interrupt and 1 min log array write                                                                '
' - use arrays for input and load current, solar volts, the same as bat volts  '
' - include solar volts in 1 min average display                               '
' - detect debug mode                                                          '
' - configure display screen on terminal to show caravan data                  '
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' This program monitors a 12V Battery System, monitoring the battery voltage,
' the amount of charge supplied into the system via an input current shunt, the
' amount of charge used by the system via a load current shunt and calculates
' the charge/discharge state of the battery by comparing current in versus
' current out. It also estimates time to 50% capacity based on battery voltage
' and current discharge rate.
' Real time data is displayed on a 16 x 2 LCD display and sent via the USB to
' TerraTerm on a PC as well as historical
' data recorded to a log file for later analysis.
' Future enhancements planned include:-
'   - change asking initial questions/definitions by utilising a config file
'   - re-write graphing components to utilise Colour MM to VGA display
'   - warning indicators and load dis-connect relay for critical battery state;
'   - wireless link to internal caravan monitor
'   - WiFi or Web-In-A-Box interface for Android phone/tablet.
' (Note: These are longer term plans; any assistance/suggestions welcome)
'
' The program is highly commented - these can be deleted to save space when
' the program enters production with the exception of the copyright notices.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Utilises a range of subroutines and defined funtions based on software from
' Doug Pankhurst, Geoff Graham, Tom Pankhurst and also from programs provided
' in the MMBASIC Software library, authors unknown.
' The data collection and logging routines are based in part on DATLOG.BAS
' from the MMBASIC Library.
' The LCD subroutines provided by Geoff Graham.
' This code is free for anyone to use or modify as long as they acknowledge it's
' source and credit the contributors above.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' A general synopsis of the program is as follows:-
' Define and initialise variables and constants;
' Get and set current date and time;
' Initialise I/O pins used and also clear LCD;
' Initialise display static data
' Initialise interrupt routine to handle 1 second interrupt for data scan
' Enter main loop; wait for interrupt then handle 1 second, 1 minute, hourly
'  and end of day occurrences. Interrupt provides battery volts, solar volts,
'  reference volts, input current and load current.
'  1 minute flag allows averaging battery and solar volts, input and load
'  currents each minute. Also plugs new averages into log array
' Hourly flag writes 1 hours worth of average data from array to log file
' End of day flag closes out log file and creates new log file
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Main Entry to Program                                                       '
'
EntryPoint:  SetTick 0,0     ' Disable timer interrupt
'
' Constants
TAB$ = Chr$(9)
ESC$ = Chr$(27)
COMMA$ = Chr$(44)
TRUE = 1
FALSE = 0
HIGH = 1
LOW = 0

' Global Variables

BVolts = 0             ' Battery Voltage read from Pin 1. Read as one fifth of
                       ' real voltage via 5:1 resistive divider. Eg. 2.500
                       ' reading equates to a battery voltage of 12.50V

Dim BVArray(59)        ' Battary Volts 60 element array

BVAElements = 60       ' number of elements

BatCharge = 100        ' Battery state of charge as a percentage where
                       ' 12.7V or higher is 100%, down to 12.0V being 30%

AverageBV=0            ' Average battery voltage over last 60 seconds

Dim BVAArray(59)       ' array of average bat volts caculated each minute

DeltaBV = 0            ' Battery voltage variation over 60 seconds. The
                       ' difference between the first and the last used to
                       ' calculate the "Time to 50% discharge point"

Time2Discharge = 0     ' Time to 50% discharge

SVolts = 0             ' Solar Array voltage - not yet implimented in h/w

Dim SVArray(59)        ' Solar Volts 60 element array

SVAElements = 60       ' number of elements

AverageSV = 0          ' Average Solar Panel volts over last 60 seconds

InputCurrent = 0       ' Charging current into battery/load read from Pin 2
                       ' Note: 2.5V reading equates to 50mA across the shunt
                       ' which in turn equates to 50A through shunt.
                       ' This can be both battery charging current
                       ' and load current.

Dim ICArray(59)        ' Input Current 60 element array

ICAElements = 60       ' number of elements

AverageIC = 0          ' Average input (generator) current over last 60 seconds

Dim ICAArray(59)       ' array to hold 1 hours worth of averages

LoadCurrent = 0        ' Load current of caravan - can be supplied from the
                       ' batteries and the charging current from the charging
                       ' systems (solar, AC Mains or generator).
                       ' Read from pin 3

Dim LCArray(59)        ' Load Current 60 element array

LCAElements = 60       ' number of elements

AverageLC = 0          ' Average load current over last 60 seconds

Dim LCAArray(59)       ' array to hold 1 hours worth of averages

BatCurrent = 0         ' A calculated value; if positive, it represents a
                       ' charging current into the battery; if negative, it
                       ' represents a discharge current out of the battery.

AverageBC = 0          ' Average charge/discharge current over last min
                       ' calculated by AverageLC-AverageIC                       ' c

InputCurrentAH = 0     ' Input current as an amp hour calculated value -
                       ' this is an accumulating value over 24 hours
                       ' Previous days values are dummy values to allow
                       ' initial calculations
PreviousICAH$ = ""     ' string holding yesterdays Input Current AHs

PreviousICAH = 0       ' yesterdays Input Current AHs


LoadCurrentAH = 0      ' Load current as an amp hour calculated value -
                       ' this is an accumulating value over 24 hours

PreviousLCAH = 0       ' yesterdays Load Current AHs

PreviousLCAH$ = ""     ' string holding yesterdays Load Current AHs

BatCurrentAH = 0       ' Bat charge (pos value) or discharge (neg value)
                       ' as an amp hour calculated value  -
                       ' this is an accumulating value over 24 hours

PreviousBCAH = 0       ' yesterdays Bat Current AHs

PreviousBCAH$ = ""     ' string holding yesterdays Bat Current AHs

LCDLine1$ = ""         ' Battery voltage and capacity
LCDLine2$ = ""         ' Input current and load current
                       ' Note: Input current minus load current will give
                       ' battery charging current if positive or battery
                       ' discharge current if negative.

Dim LogFileArray$(59)  ' Array to hold 1 hours worth of 1 minute average
                       ' readings. Single field with - time, battery volts
                       ' solar panel volts, input (generator) current and
                       ' load current as a single CSV string

LFAElements = 60       ' number of elements

LogArray$ = ""         ' String to use for plugging into log array

NewDataFlag = 0        ' second flag - set each second by the interrupt
                       ' routine when new voltage and current values are
                       ' collected. Cleared as soon as data processed
                       ' in main loop

MinFlag = 0            ' minute flag - set once every min at 00 seconds
                       ' by sec interrupt process and cleared by
                       ' min processing code.

HourFlag = 0           ' Hour Flag - set on the hour to enable
                       ' writing the 60 average readings in the log array
                       ' to be writtent to file

EODFlag = 0            ' End of Day Flag - set at midnight to enable
                       ' daily log file to be closed and new
                       ' log file created by LogFileCreate subroutine

SecsSinceStart = 0     ' Number of seconds since data collection start

StabLoopVal = 10       ' Stabilisation loop count for voltage readings

' Set debug to true or false to determine if working live or data simulation.
DEBUG = TRUE    'TRUE is debug mode.

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Carry out initialisation routines here - enable interrupt last
' OK. Lets get some initial configuration issues out of the way. This will
' all disappear once a config file is used.

Entry:
Cls
Line Input "Do you want to run in debug mode Y/N? ", debug_mode$
If debug_mode$="Y" Then
  DEBUG=TRUE
Else
  DEBUG=FALSE
EndIf

'GETSETDT.BAS - A routine To get the current date/time from the user
'and update the internal clock. Test for Duinomite and if so, skips date
' and time routines as it has an RTC.
' Un-comment the next three lines to enable
If MM.Device$ <> "DuinoMite" Then
  Line Input "Enter date time in the form DD-MM-YY ?",getdate$
  Date$=getdate$
  Line Input "Enter time in the form HH:MM:SS ?",gettime$
  Time$=gettime$
EndIf
Cls                 ' clear the screen ready to start program
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Fill LogFileArray$ array with initial values of space
For LAx=0 To 59 Step 1
  LogFileArray$(LAx)=" "
Next LAx
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Call subroutine to display all static data
' Important note: This is to the USB i/f ONLY at this stage
DisplayStatic

TPrintStatus "Initialisation Complete:"

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Create Log File on program entry and then at start of new day, that is,
' straight after midnight
CreateLogFile     'call create log file subroutine
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Wait until 00 seconds to start for clean entry.
MinTurnover$="59"
Do While MinTurnover$ <> "00"
  MinTurnover$=Mid$(Time$,7,2)
Loop
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Set up all in itial values to default for orderly entry, primarily for
' use in debug mode.
PreviousICAH = 50
PreviousLCAH = 45
PreviousBCAH = 5
AverageBV = 12.85
OldABV = 12.9
AverageSV = 18.5
AverageIC = 12
AverageLC = 9
AverageBC = 2
LFAPointer = 0

' Fill the battery volts array so % charge works
For Ax=0 To 59
  BVArray(Ax) = 12.75
Next Ax

' end of initialisation routines
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Enable timer tick interrupts to start data collection at 01 seconds
SetTick 1000,GetData   ' Every other second, get battery voltage and current
                       ' data through the GetData interrupt routine.


' Main program loop
Main:
Do While NewDataFlag = 0   ' wait until interrupt provides fresh data
Loop

' temporary loop for testing purposes lets program run for just 4 minutes
If DEBUG Then
  If SecsSinceStart > 600 Then   ' run for 10 minutes in debug mode
    GoTo ExitPoint
  EndIf
EndIf

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' 1 second processing code
' Write out time and date to display
TPrintAt 1,1,Time$ + "   " + Date$

' Push most recent values into array
For Ax = BVAElements-1 To 1 Step -1
  BVArray(Ax) = BVArray(Ax-1)
Next Ax
BVArray(0) = BVolts

For Ax = SVAElements-1 To 1 Step -1
  SVArray(Ax) = SVArray(Ax-1)
Next Ax
SVArray(0) = SVolts

For Ax = ICAElements-1 To 1 Step -1
  ICArray(Ax) = ICArray(Ax-1)
Next Ax
ICArray(0) = InputCurrent

For Ax = LCAElements-1 To 1 Step -1
  LCArray(Ax) = LCArray(Ax-1)
Next Ax
LCArray(0) = LoadCurrent

' Convert all values returned from interrupt to strings
BVolts$ = Format$(BVolts,"%+6.2fV")          ' BVolts = actual battery volts
SVolts$ = Format$(SVolts,"%+6.2fV")          ' Solar Array volts
InputCurrent$ = Format$(InputCurrent,"%+6.1fA") ' InputCurrent = 0 to 50Amps
LoadCurrent$ = Format$(LoadCurrent,"%+6.1fA")   ' LoadCurrent = 0 to 50Amps

' Charge/Discharge Current is InputCurrent-LoadCurrent - if positive
'  it is a charging current into battery, if negative, it is a
'  discharging current out of battery
BatCurrent = InputCurrent-LoadCurrent
' ... now convert to string
BatCurrent$ = Format$(BatCurrent,"%+6.1fA")

' Convert both input, output & battery instantaneous currents into Amp Hours
InputCurrentAH = InputCurrentAH + (InputCurrent/3600) ' use 1 sec interrupt
LoadCurrentAH = LoadCurrentAH + (LoadCurrent/3600)    ' rate for calculation
BatCurrentAH = InputCurrentAH-LoadCurrentAH
' ... now convert to strings
InputCurrentAH$ = Format$(InputCurrentAH,"%+5.2fahrs") ' Input chg in ah
LoadCurrentAH$ = Format$(LoadCurrentAH,"%+5.2fahrs")   ' Load dischg in ah
BatCurrentAH$ = Format$(BatCurrentAH,"%+5.2fahrs") ' actual charge

' Note: All AH accumulating totals are plugged into last day values
' then reset to zero at midnight except previous values which only
' change at midnight
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Set the rest of the variables to strings - some will have default
' values until after 2 minutes have passed
  AverageBV$ = Format$(AverageBV,"%+6.2fV") ' min average bat volts
  AverageSV$ = Format$(AverageSV,"%+6.2fV") ' min average solar volts
  AverageIC$ = Format$(AverageIC,"%+6.2fA") ' min average input amps
  AverageLC$ = Format$(AverageLC,"%+6.2fA") ' min average load amps
  AverageBC$ = Format$(AverageBC,"%+6.2fA") ' min average bat amps
  PreviousICAH$ = Format$(PreviousICAH,"%+5.2fahrs") ' y'days Input chg in ah
  PreviousLCAH$ = Format$(PreviousLCAH,"%+5.2fahrs") ' y'days Load dischg in ah
  PreviousBCAH$ = Format$(PreviousBCAH,"%+5.2fahrs") ' y'days actual bat charge

' Print out to LCD - this is peculular to my development system. If you want to
' impliment an LCD display, uncomment and develop yourself.
' InitLCD
' PrintLCD 1,BVolts$
' PrintLCD 2,LoadCurrent$

' Now update terminal display with all values
TPrintAt 22,4,BVolts$
TPrintAt 22,5,SVolts$
TPrintAt 22,6,InputCurrent$
TPrintAt 22,7,LoadCurrent$
TprintAt 22,8,BatCurrent$
TPrintAt 55,4,AverageBV$
TPrintAt 55,5,AverageSV$
TPrintAt 66,7,BatCharge$
TPrintAt 34,35,Time2Discharge$
TPrintAt 55,6,AverageIC$
TPrintAt 55,7,AverageLC$
TPrintAt 55,8,AverageBC$
TPrintAt 22,12,InputCurrentAH$
TPrintAt 22,13,LoadCurrentAH$
TPrintAt 22,14,BatCurrentAH$
TPrintAt 55,12,PreviousICAH$
TPrintAt 55,13,PreviousLCAH$
TPrintAt 55,14,PreviousBCAH$
TPrintStatus "Running: "

NewDataFlag = 0      ' clear new data flag ready for next interrupt
'
' End of second processing code, now check for minute, hour or end of day
' flags and process accordingly

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Check for minute flag, calculate the average of the last 60 seconds of
' readings, plug them into the log file array at the log file array pointer
If MinFlag Then
  ' calculate average for last minute
  OldABV = AverageBV
  AverageBV = 0
  For Ax = 0 To 59
    AverageBV = AverageBV + BVArray(Ax)
  Next Ax
  AverageBV = AverageBV/60

   AverageSV = 0
  For Ax = 0 To 59
    AverageSV = AverageSV + SVArray(Ax)
  Next Ax
  AverageSV = AverageSV/60

  AverageIC = 0
  For Ax = 0 To 59
    AverageIC = AverageIC + ICArray(Ax)
  Next Ax
  AverageIC = AverageIC/60

  AverageLC = 0
  For Ax = 0 To 59
    AverageLC = AverageLC + LCArray(Ax)
  Next Ax
  AverageLC = AverageLC/60

  AverageBC = AverageIC - AverageLC
  ' Note AverageBC can be negative or positive

  ' Calculate battery change as percentage and fill charge state graph
  ' - first set graph to 0%
  For GraphY = 2 To 16
    TPrintAt 72,GraphY,"  "
  Next GraphY

  ' now calculate charge and paint capacity graph
  BV0percent = 12   '12V equates to 30% charge
  BatCharge = 25    'start point % charge

  For yg = 16 To 2 Step -1
    If AverageBV > BV0percent Then
      TPrintAt 72,yg,"XX"
      BatCharge = BatCharge + 5
    Else
      TPrintAt 72,yg,"  "
    EndIf
    BV0percent = BV0percent + 0.05
  Next yg
  ' ... now convert to string
  BatCharge$ = Format$(BatCharge,"%+3.0f")+"%"  ' Battery charge as %

  ' Calculate time to 50% discharge of battery
  DeltaBV = OldABV - AverageBV
  If Sgn(DeltaBV) = +1 Then
       DVRate = BVArray(0)         ' set initial values for rate of discharge
    Time2Discharge = 0             ' and time to discharge
    Do While DVRate > 12.2         ' 12.2 volts equates to 50% discharge
      DVRate = DVRate - DeltaBV    ' loop through calculating the amount
                                   ' of time to get the current voltage
                                   ' down to the 50% discharge point
      Time2Discharge = Time2Discharge + 1 ' increment minutes to discharge count
    Loop
    ' Time to 50% discharge in mins
    Time2Discharge$ = Format$(Time2Discharge,"%+3.0f minutes")
  Else
    Time2Discharge$ = "Charging      " ' if current voltage is greater than
  EndIf                                ' previous minute

  ' ... now convert to strings
  AverageBV$ = Format$(AverageBV,"%+6.2fV")       ' min average bat volts
  AverageSV$ = Format$(AverageSV,"%+6.2fV")       ' min average solar volts
  AverageIC$ = Format$(AverageIC,"%+6.2fA")       ' min average input amps
  AverageLC$ = Format$(AverageLC,"%+6.2fA")       ' min average load amps
  AverageBC$ = Format$(AverageBC,"%+6.2fA")     ' min average bat amps
  PreviousICAH$ = Format$(PreviousICAH,"%+5.2fahrs") ' y'days Input chg in ah
  PreviousLCAH$ = Format$(PreviousLCAH,"%+5.2fahrs") ' y'days Load dischg in ah
  PreviousBCAH$ = Format$(PreviousBCAH,"%+5.2fahrs") ' y'days actual bat charge

  ' ... now make into a single string to plug into array
  LogArray$=AverageBV$+COMMA$+AverageSV$+COMMA$ ' bit more next
  LogArray$=LogArray$+AverageIC$+COMMA$+AverageLC$+COMMA$

  ' ... now plug into log file array and average arrays
  LogFileArray$(LFAPointer)=LogArray$
  BVAArray(LFAPointer) = AverageBV
  ICAArray(LFAPointer) = AverageIC
  LCAArray(LFAPointer) = AverageLC

   ' ... now write out graph
  If AverageBV > 12.8 Then
    ABV = 13
  Else
    ABV = Cint((AverageBV-12.2)*20)
  EndIf
  If AverageBV < 12.2 Then
    ABV = 0
  Else
    ABV = Cint((AverageBV-12.2)*20)
  EndIf
  If AverageIC > 25 Then
    AIC = 13
  Else
    AIC = Cint(AverageIC/2)
  EndIf
  If AverageIC < 1 Then
    AIC = 0
  Else
    AIC = Cint(AverageIC/2)
  EndIf
  If AverageLC > 25 Then
    ALC = 13
  Else
    ALC = Cint(AverageLC/2)
  EndIf
  If AverageLC < 1 Then
    ALC = 0
  Else
    ALC = Cint(AverageLC/2)
  EndIf
' ...so now lets paint out simple graph of bat volts, input and
' output currents
  For Gy = 0 To 13
    If ABV = Gy Then
      TPrintAt LFAPointer + 10,31 - Gy,"="
    Else
      TPrintAt LFAPointer + 10,31 - Gy," "
    EndIf
    If AIC = Gy Then TPrintAt LFAPointer + 10,31 - Gy,"+"
    If ALC = Gy Then TPrintAt LFAPointer + 10,31 - Gy,"-"
  Next Gy

  LFAPointer = LFAPointer + 1          ' LFA pointer reset by eod routine

  MinFlag = 0                          ' reset the min flag
EndIf
' End of minute processing

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Check for hour flag - if true then append log array out to file
' (we want to limit log file writes to 24 per day to keep
' SD card writes as low as possible.
' - enter with LogFileArray, a 60 deep element string array
If HourFlag Then              ' set each hour in interrupt routine
  For LAx=0 To 59 Step 1
    Print #1,LogFileArray$(LAx)
  Next LAx

' clear out graph area ready to start next 60 minute graph
  For Gy = 18 To 31
    For Gx = 10 To 69
      TPrintAt Gx,Gy," "
    Next Gx
  Next Gy

  LFAPointer = 0              ' reset array pointer
  HourFlag = 0                ' clear hour flag until next hour
EndIf
' End of hour processing code

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Check for end of day - if true then close log file and create new file
' for new day. Re-display the static data just in case of corruption (if you
' happy no corruption then get rid of this re-write of static data)
If EODFlag Then
  Close #1                ' close out last days log file
  DisplayStatic           ' re-write all static display data
  ' ... Now Save all the amp hour readings and reset ready for next day
  PreviousICAH$ = InputCurrentAH$
  InputCurrentAH = 0
  PreviousLCAH$ = LoadCurrentAH$
  LoadCurrentAH = 0
  PreviousBCAH$ = BatCurrentAH$
  BatCurrentAH = 0

  CreateLogFile           ' create new log file with todays date
  EODFlag = 0             ' clear end of day flag until next midnight
EndIf
' End of day processing code

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
GoTo Main                  ' back to Main ready for next interrupt

ExitPoint:                  ' Program Exit
TPrintStatus "Program Ended."
' End running program and return to command prompt.
Close #1
Option Prompt ">"
Error "End of running program - controlled close"

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Interrupt Routine Initialisation and Handling

GetData:               ' Timer Interrupt handler
                       ' Analogue input pins
  SetPin 1,1           ' Pin 1 - battery voltage - battery divided by 5
  SetPin 2,1           ' Pin 2 - input current shunt - 0 to 2.5V = 0 to 50A
  SetPin 3,1           ' Pin 3 - load current shunt - 0 to 2.5V = 0 to 50A
  SetPin 4,1           ' Pin 4 - reference voltage - 2.5V
  ' SetPin x,1           Pin x - Solar Array volts - not yet in h/w

' Get the reference  voltage - unsure as to how important this is?
' - it sort of depends on how accurate the front end h/w is, how accurate MM
' is in reading analogue value and how accurate you want your readings to be
' I guess if timing is critical to limit time in the interrupt routine you
' can the stabilise routines
If Not Debug Then
 RVoltsCntr = 0        ' Stabilasion loop count
  RefVolts = 0         ' Reference Voltage
  GetPin4 = 0          ' Referance voltage pin reading
  CorrectionFactor = 0 ' Calculated correction factor
  For RVoltsCntr = 1 To StabLoopVal
       GetPin4 = Pin(4)
       RefVolts = RefVolts + GetPin4
  Next RVoltsCntr
  RefVolts = RefVolts/StabLoopVal       ' Average out reference voltage
  CorrectionFactor = 2.5/RefVolts       ' Calculate correction factor so it can
                                        ' be applied to following readings
Else
 RefVolts=2.5
EndIf

' Get the battery voltage
If Not Debug Then
  BVoltsCntr=0
  BVolts = 0
  GetPin1 = 0
  For BVoltsCntr = 1 To StabLoopVal
    GetPin1 = Pin(1)
    BVolts = BVolts + GetPin1
  Next BVoltsCntr
  BVolts = BVolts/StabLoopVal          ' Average out Battery voltage
  BVolts = BVolts*5                    ' Correct for resitive divider
  BVolts = BVolts*CorrectionFactor     ' Apply calculated correction factor

Else
  BVolts=AverageBV - (Rnd(1)/10)  ' this can be all manipulated to simulate
  If BVolts < 11.5 Then BVolts = 11.5   ' whatever values you want
EndIf

' Get the Solar Array voltage
If Not Debug Then
  SVoltsCntr=0
  SVolts=0
  'GetPinx = 0
  For SVoltsCntr = 1 To StabLoopVal
  ' GetPinx = Pin(x)   ' not yet defines in h/w
  ' SVolts = SVolts + GetPinx
  Next SVoltsCntr
  SVolts = SVolts/StabLoopVal          ' same as for BVolts
  SVolts = SVolts*5
  SVolts = SVolts*CorrectionFactor

Else
 SVolts=AverageSV -(Rnd(1)/5)
 If SVolts< 0 Then SVolots = 0
EndIf

' Get the input current as a voltage
If Not Debug Then
  ICurrCntr=0
  InputCurrent = 0
  GetPin2 = 0
  For ICurrCntr = 1 To StabLoopVal
       GetPin2 = Pin(2)
       InputCurrent = InputCurrent + GetPin2
  Next ICurrCntr
  InputCurrent = InputCurrent/StabLoopVal   ' Average out voltage representing
                                            ' input current
  InputCurrent = InputCurrent*20 ' Correct for opamp amplification - 2.5V by 20
                               ' now gives a value equating to ratio 50mV = 50A
                               ' Apply calculated correction factor
  InputCurrent = InputCurrent*CorrectionFactor

Else
 InputCurrent=AverageIC-Rnd(1)
 If InputCurrent < 0 Then InputCurrent = 0
EndIf

' Get the load current as a voltage
If Not Debug Then
  LCurrCntr=0
  LoadCurrent = 0
  GetPin3 = 0
  For LCurrCntr = 1 To StabLoopVal
       GetPin3 = Pin(3)
       LoadCurrent = LoadCurrent + GetPin3
  Next LCurrCntr
  LoadCurrent = LoadCurrent/StabLoopVal ' Average out voltage representing
                                        ' load current
  LoadCurrent = LoadCurrent*20 ' Correct for opamp amplification - 2.5V by 20
                               ' now gives a value equating to ratio 50mV = 50A
  LoadCurrent = LoadCurrent*CorrectionFactor

Else
 LoadCurrent=AverageLC-(Rnd(1)*0.5)      ' load current decreases at half
 If LoadCurrent < 0 Then LoadCurrent = 0 ' input current rate to simulate
EndIf                                    ' loss of sun at evening

' Get the current time, extract the minutes component
' logging averaged data to log array
CurrentSecs$ = Mid$(Time$,7,2)  ' extract minutes
If CurrentSecs$ = "00" Then
  MinFlag = 1
EndIf

' Get the current time, test for hour turnover and
' set HourFlag to 1 to initiate logging collected data to file
CurrentMins$ = Mid$(Time$,4,2) ' extract minutes
If CurrentSecs$ = "00" And CurrentMins$ = "00" Then
  HourFlag = 1
EndIf

' Get the current time, test for midnight and
' set EODFlag to 1 to initiate logging collected data to file
CurrentHrs$ = Mid$(Time$,1,2)  ' extract hours
If CurrentSecs$ = "00" And CurrentMins$ = "00" And CurrentHrs$ = "00" Then
  EODFlag = 1
EndIf

' Increment seconds counter
SecsSinceStart = SecsSinceStart + 1
NewDataFlag = 1                ' set to indicate fresh data

IReturn                        ' Returns with the following values:-
                               ' BVolts = actual battery volts
                               ' SVolts = actual solar Array volts
                               ' InputCurrent=0 to 50 equalling 0 to 50Amps
                               ' LoadCurrent=0 to 50 equalling 0 to 50Amps
                               ' Note: All values have had the correction
                               ' factor applied.
                               ' EODFlag set at midnight
'End of Interrupt code
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Defined Functions
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Defined Subroutines
' - InitLCD - initialise LCD
' - PrintLCD - print to LCD
' - Set DTSecs - set date time into secs since midnight 1 jan 2012
'    - not currently used
' - Create Data File -
' - TPrintAt - terminal print a specific column and row
' - TermDisplayStatic - write static terminal display data
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' LCD driver for MMBasic 3.1 or later (uses defined subroutines)
' Geoff Graham, Jan 2012
'
' Will drive a standard 16 x 2 LCDs
' For example:  futurlec.com       LCD16X2
'               altronics.com.au   Z7001
'               jaycar.com.au      QP5512
'
' To use:
'  - Setup the LCD with the command:    InitLCD
'  - Display a line using the command:  PrintLCD LineNbr, Text$
'
' See documentation (LCD.PDF) for the schematic
' Maximite pin 11 is RS, pin 12 is EN
' pins 13 to 16 are D4 to D7
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Initialise the LCD
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub InitLCD
  For i = 11 To 16 : SetPin i, 9 : Next i  ' all open collector
  LCD_Nibble &B0011, 0, 5                  ' reset
  LCD_Nibble &B0011, 0, 5                  ' reset
  LCD_Nibble &B0011, 0, 5                  ' reset
  LCD_Nibble &B0010, 0, 2                  ' 4 bit mode
  LCD_Nibble &B0010 : LCD_Nibble &B1100    ' 4 bits, 2 lines
  LCD_Nibble &B0000 : LCD_Nibble &B1100    ' display on, no cursor
  LCD_Nibble &B0000 : LCD_Nibble &B0110    ' increment on write
  LCD_Nibble &B0000 : LCD_Nibble &B0001    ' clear the display
  Pause 2
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Display a line on the LCD
' argument #1 is the line to be used (1 or 2)
' argument #2 is the line to display (can be any length)
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub PrintLCD ( LineNumber, Line$ )
  Local i, c

  ' first send the cursor position (in two nibbles)
  LCD_Nibble &B1000 + (LineNumber - 1) * 4 : LCD_Nibble 0

  ' then send the text character by character (two nibbles per character)
  For i = 1 To 16
    c = Asc(Mid$(Line$ + Space$(16), i, 1))
    LCD_Nibble Int(c/16), 1 : LCD_Nibble c, 1
  Next i
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Send the lower 4 bits (called a nibble) to the LCD
' argument #1 is the nibble to send
' argument #2 is true if data, false if command (default is command)
' argument #3 is delay after the data has been sent (default is zero)
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub LCD_Nibble ( Data, Flag, Wait_mSec )
  Pin(11) = Flag
  Pin(13) = Data And &B00000001
  Pin(14) = Data And &B00000010
  Pin(15) = Data And &B00000100
  Pin(16) = Data And &B00001000
  Pin(12) = 1 : Pin(12) = 0
  Pause Wait_mSec
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' TPRINTAT - a subroutine to move the print position on a terminal to a
' character column and row and print the string of characters passed.
' - will over write character(s)already on the display.
' TPRINTAT txpos,typos,ttext$
' - where txpos is the character position in a line, typos is the
'   line number and ttext$ is the text to print at that location
' - 0,0 is top left and assumes an 80 x 36 terminal display
Sub TPRINTAT (txpos,typos,ttext$)
  Print @(txpos*6,typos*12);ttext$;
End Sub
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' TPrintStatus Status$ - a subroutine to clear line 35 and print a status
'  message - expects a string to print
Sub TPrintStatus Status$
  TPrintAt 53,35,"                              "
  TPrintAt 53,35,Status$
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Set up terminal display with static data (field names etc.)
' - uses the TPRINTAT subroutine to print at defined positions
Sub DisplayStatic
  Cls
  TPrintAt 25,1,"CARAVAN POWER MONITOR"
  TPrintAt 71,1,".--------."
  TPrintAt 1,2,"Instantaneous Readings"
  TPrintAt 34,2,"Minute Average Readings"
  TPrintAt 71,2,"|  | 100%|"
  TPrintAt 1,3,"----------------------------"
  TPrintAt 34,3,"----------------------------"
  TPrintAt 64,3,"Battery|  |  95%|"
  TPrintAt 1,4,"Battery Volts      ="
  TPrintAt 34,4,"Battery Volts      ="
  TPrintAt 65,4,"State |  |  90%|"
  TPrintAt 1,5,"Solar Array Volts  ="
  TPrintAt 34,5,"Solar Array Volts  ="
  TPrintAt 67,5,"of  |  |  85%|"
  TPrintAt 1,6,"Input Current      ="
  TPrintAt 34,6,"Input Current      ="
  TPrintAt 65,6,"Charge|  |  80%|"
  TPrintAt 1,7,"Load Current       ="
  TPrintAt 34,7,"Load Current       ="
  TPrintAt 71,7,"|  |  75%|"
  TPrintAt 1,8,"Bat Chg/Dis Curr   ="
  TPrintAt 34,8,"Bat Chg/Dis Curr   ="
  TPrintAt 71,8,"|  |  70%|"
  TPrintAt 71,9,"|  |  65%|"
  TPrintAt 1,10,"Daily Accumulating Readings"
  TPrintAt 1,11,"------------------------------"
  TPrintAt 34,10,"Previous Days Total Readings"
  TPrintAt 34,11,"-----------------------------"
  TPrintAt 71,10,"|  |  60%|"
  TPrintAt 71,11,"|  |  55%|"
  TPrintAt 1,12,"Input Charge       ="
  TPrintAt 34,12,"Input Charge       ="
  TPrintAt 71,12,"|  |  50%|"
  TPrintAt 1,13,"Load Discharge     ="
  TPrintAt 34,13,"Load Discharge     ="
  TPrintAt 71,13,"|  |  45%|"
  TPrintAt 1,14,"Battery Chg/DisChg ="
  TPrintAt 34,14,"Battery Chg/DisChg ="
  TPrintAt 71,14,"|  |  40%|"
  TPrintAt 71,15,"|  |  35%|"
  TPrintAt 71,16,"|  |  30%|"
  TPrintAt 71,17,"'--------'"
  TPrintAt 1,18,"-more-"
  TPrintAt 1,19,"12.80V"
  TPrintAt 78,19,"24A"
  TPrintAt 1,20,"12.75V"
  TPrintAt 78,20,"22A"
  TPrintAt 1,21,"12.70V"
  TPrintAt 78,21,"20A"
  TPrintAt 1,22,"12.65V"
  TPrintAt 78,22,"18A"
  TPrintAt 1,23,"12.60V"
  TPrintAt 78,23,"16A"
  TPrintAt 1,24,"12.55V"
  TPrintAt 78,24,"14A"
  TPrintAt 1,25,"12.50V"
  TPrintAt 78,25,"12A"
  TPrintAt 1,26,"12.45V"
  TPrintAt 78,26,"10A"
  TPrintAt 1,27,"12.40V"
  TPrintAt 79,27,"8A"
  TPrintAt 1,28,"12.35V"
  TPrintAt 79,28,"6A"
  TPrintAt 1,29,"12.30V"
  TPrintAt 79,29,"4A"
  TPrintAt 1,30,"12.25V"
  TPrintAt 79,30,"2A"
  TPrintAt 1,31,"-less-"
  TPrintAt 10,32,"|.:.|.:.|.:.|.:.|.:.|.:.|.:.|.:.|.:.|.:.|.:.|.:.|.:.|.:.|.:."
  TPrintAt 1,33,"Minutes  0   4   8   12  16  20  24  28  32  36  40  44  48  52  56  60"
  TPrintAt 1,35,"Time to 50% battery discharge = "
End Sub
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Create Log File with todays date as name
Sub CreateLogFile
  Year$ = Mid$(Date$,9,2)        ' get date and create Log File name string
  Month$ = Mid$(Date$,4,2)       ' in the format YYMMDD.CSV
  Day$ = Left$(Date$,2)
  LogFileName$="B:" + Year$ + Month$ + Day$ + ".CSV"
  Open LogFileName$ For Output As #1
  Print #1, "Battery Voltage";COMMA$;
  Print #1, "Solar Array Voltage";COMMA$;
  Print #1, "Input Current";COMMA$;
  Print #1, "Load Current"

End Sub

