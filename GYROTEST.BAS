MPU = &H68
Dim DATA(6)

I2C OPEN 32,1000
I2C WRITE MPU,0,2,&H6B,&H00
Do
    I2C WRITE MPU,1,1,&H43
    I2C READ MPU,0,6,DATA(0)
    Cls
    For i = 0 To 5
        Print DATA(i);
    Next
    Pause 500
Loop
