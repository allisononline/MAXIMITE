'1WDS1820.BAS     29 March 2012
'By Ian Delaney

PinNbr = 20

GetTemp PinNbr, Temp, power$, device$, code$
Print "The temperature is:" format$(Temp,"% 1.3f"); " degrees C"
print device$;code$;power$

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Subroutine to get the temperature from a Dallas DS18B20/DS18S22
'    or DSS20/DS1820 externally or parasite powered via 1-wire protocol.
' Reports temperature, device family, ROM Code and Power connection.
' Only 1 device allowed on the cable.
'                                                 Iandaus
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Sub GetTemp (PinNbr, Value,power$,device$, code$)
    Local T1, T2, t, a1,a2,a3,a4,a5,a6,a7,a8, device, presence, power
    Local Countrem, T1C, TConv, T1t, T1t16, Value12, a,b,c,d,e,f,g,h

    Tconv=750    'max time mS for temp conversion in parasite mode
                 ' for slowest device

''''''''''''''''''''''''''''''
'   Check a device is present
''''''''''''''''''''''''''''''
    OWReset PinNbr,presence               ' reset
    if presence = 0 then                  ' no device
        temp = 999.99
        device$ = "No device found!"
        code$ = ""
        power$ = ""
        exit sub
    endif

''''''''''''''''''''''''''''''''''''''''''''''
'   check whether power external or parasitic
''''''''''''''''''''''''''''''''''''''''''''''
    OWReset PinNbr,presence
    OWWrite PinNbr, 1,2,&hcc, &hb4
    OWRead PinNbr,4,1,power
    if power = 1 then 
        power$ = " using External Power."
    else
        power$ = " using Parasitic Power."
    endif

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   get ROM Code - useful if you want more than 1 device on wire
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    OWWrite PinNbr,1,1,&h33			'read ROM code
    OWRead PinNbr,0,8,a1,a2,a3,a4,a5,a6,a7,a8
    code$ = " with ROM Code "+ str$(a1)+" "+str$(a2)+" "+str$(a3)+" "+str$(a4)+" "
    code$ = code$ + str$(a5)+" "+str$(a6)+" "+str$(a7)+" "+str$(a8)

''''''''''''''''''''''''''''''''''''''''''''''
'   determine device family from code
''''''''''''''''''''''''''''''''''''''''''''''
    if a1=16 then
        device$ = "on DS1820/DS18S20"
    elseif a1=34 then
        device$ = "on DS18S22"    
    elseif a1=40 then
        device$ = "on DS18B20"
    else
        device$ = "Not known"    
    endif

''''''''''''''''''''''''''''''''''''''''''''''
'   read temperature
''''''''''''''''''''''''''''''''''''''''''''''
    owreset PinNbr                        ' reset before command (or use flag=9)
    OWWrite PinNbr, 8, 2, &hcc, &h44      ' start conversion

    'read external when bit goes hi, for parasitic just wait
    If power = 0 Then
        Pause Tconv
    Else
        t = Timer
        Do
            If Timer - t > 1000 Then Error "Sensor not responding"
            OWRead PinNbr, 4 , 1 , b            ' conversion done?
        Loop Until b = 1
    EndIf

    'read temperature from scratchpad and convert to degrees C + or -
    OWWrite PinNbr, 1, 2, &hcc, &hbe      ' command read data
    OWRead PinNbr, 2, 2, T1, T2           ' get the data
    OWReset PinNbr

''''''''''''''''''''''''''''''''''''''''''''''
'   calculate temp depending on device in use
''''''''''''''''''''''''''''''''''''''''''''''
    'Need to analyse type of chip to calculate temp from T1 and T2
    'T2 is MSB containing sign, T1 is LSB
    if a1=34 or a1=40 then          'DS18S22 or DS18B20 is 12 bit 
        If T2 And &b1000 Then       'negative temp
            'make 2s complement (1s complement+1)
            T2 = (T2 xor &b11111111)
            T1 = (T1 xor &b11111111)+1
            if T1=1 then T2=T2+1        'add the carry if required
            Value = ((T2 And &b111) * 256 + T1) / 16
            Value = -Value
        else                            'positive temp
            Value = ((T2 And &b111) * 256 + T1) / 16
        endif           
    elseif a1=16 then                   'DS18S20 or DS1820 is 9bit or calc to 12bit
        if T2 AND &b10000000 then       'if MSB of T2=1 then negative
            'Read 12bit resolution and adjust
            'read scratchpad using matchrom to get Count Remaining @byte 7
            OWWrite PinNbr,1,9,&h55,a1,a2,a3,a4,a5,a6,a7,a8  'read from scratchpad
            OWWrite PinNbr,0,1,&hbe
            OWRead PinNbr,0,8,a,b,c,d,e,f,g,h
            COUNTREM=g                
            'truncate 0.5deg value (or use integer division \)
            T1t = T1 AND &b11111110
            T1t=T1t / 2                   'make whole degrees
            'add compensation values read from scratchpad
            T1t16=T1t*16                  'make lsb 1/16 degree
            Value12 = T1t16 -4 +(16 - COUNTREM)    'add 12 bit value
            'take 2s complement
            T1C = (Value12 XOR &b11111111111) + 1 
            Value = T1C/16                'make decimal value in degrees
            Value = -Value
        else                              'positive temp
            Value = T1 / 2                '9bit value  
            'Read 12bit resolution and adjust
            'read scratchpad using matchrom
            OWWrite PinNbr,1,9,&h55,a1,a2,a3,a4,a5,a6,a7,a8  'read from scratchpad
            OWWrite PinNbr,0,1,&hbe
            OWRead PinNbr,0,8,a,b,c,d,e,f,g,h
            COUNTREM=g                
            T1t = T1 AND &b11111110      'truncate 0.5deg(or use integer division \)
            Value = T1t/2
            Value = Value - 0.25 + (16 - COUNTREM) /16   '12 bit value
        endif    
    endif
End Sub






