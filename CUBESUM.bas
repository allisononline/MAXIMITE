MAXIMUM = 9999
CUBE1 = 0
CUBE2 = 0
Do While (CUBE1+1)^3 < MAXIMUM
    CUBE1 = CUBE1 + 1
Loop
Open "CUBES.TXT" For OUTPUT As #3
Do
    CUBE2 = 0
    Do
        Print #3, (CUBE1^3) + (CUBE2^3)
        CUBE2 = CUBE2 + 1
    Loop Until (CUBE1^3)+(CUBE2^3) > MAXIMUM Or CUBE1 = CUBE2
    CUBE1 = CUBE1 - 1
Loop Until CUBE1 = 0
Close #3