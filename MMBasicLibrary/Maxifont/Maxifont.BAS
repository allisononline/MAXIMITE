10 '*********************************************
20 '*       Maxifont startup program            *
30 '*     Detects which version of firmware     *
40 '*       V2.7B , V3.0 , V3.0A or V3.1        *
50 '*********************************************
60 version = MM.VER
70 IF version = 3.01 THEN RUN "Maxf3_1.bas"
80 IF version = 3 or version = 3.0001 THEN RUN "Maxf3_0.bas"
90 IF version = 2.0702 THEN RUN "MaxF2_7.bas"
100 CLS
120 PRINT " Sorry your firmware version is not supported yet"
130 END    