100 'MANDELBROT.BAS - Draws mandelbrot set fractal images
102 'By loki on the Back Shed  Aug 2012
103 'See topic (MM) Mandelbrot & Julia set fractals
105 'Specify initial values
110 RealOffset = -2.0
115 ImaginOffset = -1.2
130 MAXIT=70 'max iterations
165 PixelWidth = MM.HRES
170 PixelHeight = MM.VRES
175 GAP = PixelHeight / PixelWidth
180 SIZE = 2.8
185 XDelta = SIZE / PixelWidth
190 YDelta = (SIZE * GAP) / PixelHeight
195 CLS
200 'Loop processing - visit every pixel in screen area and base colour of pixel
201 ' on the number of iterations required to escape boundary conditions
202 ' If count hits max iterations then pixel hasn't escaped and is part of the set (the 'inner sea')
205 FOR X = 0 TO (PixelWidth - 1)
210   Cx = X * Xdelta + RealOffset
215   FOR Y = 0 TO (PixelHeight - 1)
220     Cy = Y * YDelta + ImaginOffset
225     Zr = 0.0
230     Zi = 0.0
235     COUNT = 0
240     'Begin Iteration loop, checking boundary conditions on each loop      
250     DO WHILE (( COUNT <= MAXIT ) AND (( Zr * Zr + Zi * Zi ) <= 4 ))
255       new_Zr = Zr * Zr - Zi * Zi + Cx
260       new_Zi = 2 * Zr * Zi + Cy
265       Zr = new_Zr
270       Zi = new_Zi
275       COUNT = COUNT + 1
280     LOOP
415     PIXEL(X,Y) = ((COUNT MOD 2) - 1) * -1
500   NEXT Y
510 NEXT X
520 DO
530   a$ = INKEY$
540 LOOP WHILE a$ = ""
600 'End listing 