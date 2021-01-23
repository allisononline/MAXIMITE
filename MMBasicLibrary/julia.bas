100 'JULIA.BAS - Draws Julia set fractal images
102 'By loki on the Back Shed   Aug 2012
103 'See topic (MM) Mandelbrot & Julia set fractals
105 'Specify initial values
120 RealOffset = -1.30
125 ImaginOffset = -1.22
126 '------------------------------------------------*
130 'Set the Julia set constant [eg C = -1.2 + 0.8i]
135 CRealVal = -0.78 
140 CImagVal = -0.20
141 '------------------------------------------------*
145 MAXIT=80 'max iterations
180 PixelWidth = MM.HRES
185 PixelHeight = MM.VRES
190 GAP = PixelHeight / PixelWidth
200 SIZE = 2.50
205 XDelta = SIZE / PixelWidth
210 YDelta = (SIZE * GAP) / PixelHeight
215 CLS
220 'Loop processing - visit every pixel
225 FOR X = 0 TO (PixelWidth - 1)
230   CX = X * Xdelta + RealOffset
235   FOR Y = 0 TO (PixelHeight - 1)
240     CY = Y * YDelta + ImaginOffset
245     Zr = CX
250     Zi = CY
255     COUNT = 0
260     'Begin Iteration loop      
265     DO WHILE (( COUNT <= MAXIT ) AND (( Zr * Zr + Zi * Zi ) < 4 ))
270       new_Zr = Zr * Zr - Zi * Zi + CRealVal 
275       new_Zi = 2 * Zr * Zi + CImagVal
280       Zr = new_Zr
285       Zi = new_Zi
290       COUNT = COUNT + 1
295     LOOP
415     PIXEL(X,Y) = COUNT MOD 2
500   NEXT Y
510 NEXT X
520 DO
530   a$ = INKEY$
540 LOOP WHILE a$ = ""
600 'End listing 