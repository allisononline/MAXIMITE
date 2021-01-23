10 CLS
20 INPUT "How many seconds between Temperature measurements"; delay
30 CLS
40 delay = delay * 1000
50 ds1621_addr = &h48
60 config_cmd = &hAC
70 ' MSb Bit6 Bit5 Bit4 Bit3 Bit2 Bit1 LSb
80 ' Done THF TLF NVB X X POL 1SHOT
90 config_reg = &b00000001
100 start_convert_cmd = &hEE
110 read_temp_cmd = &hAA
120 DIM temp(2)
130 I2CEN 100, 100
140 DO WHILE a$ = ""
150   a$ = INKEY$
160   I2CSEND ds1621_addr, 1, 2, config_cmd, config_reg
170   I2CSEND ds1621_addr, 0, 1, start_convert_cmd
180   I2CSEND ds1621_addr, 1, 1, read_temp_cmd
190   I2CRCV ds1621_addr, 0, 2, temp(0)
200   temp = (temp(0) * 256 + temp(1)) / 128 * 5 / 10
210   IF temp(0) >= 128 THEN
220     temp = temp - 256
230   ENDIF
240   LOCATE 50, 50
250   PRINT "As at " TIME$ " Temperature is" temp " degrees C "
260   PAUSE delay
270 LOOP
280 I2CDIS
