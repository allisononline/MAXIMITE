'JULIA.BAS - Draws Julia set fractal images
'by loki

Mode 3
Cls

'Specify initial values
RealOffset = -1.30
ImaginOffset = -1.22
'------------------------------------------------*
'Set the Julia set constant [eg C = -1.2 + 0.8i]
CRealVal = -0.78
CImagVal = -0.20
'------------------------------------------------*
MAXIT=80 'max iterations
PixelWidth = MM.HRes
PixelHeight = MM.VRes
GAP = PixelHeight / PixelWidth
SIZE = 2.50
XDelta = SIZE / PixelWidth
YDelta = (SIZE * GAP) / PixelHeight

'Loop processing - visit every pixel
For X = 0 To (PixelWidth - 1)
  CX = X * Xdelta + RealOffset
  For Y = 0 To (PixelHeight - 1)
    CY = Y * YDelta + ImaginOffset
    Zr = CX
    Zi = CY
    COUNT = 0
    'Begin Iteration loop
    Do While (( COUNT <= MAXIT ) And (( Zr * Zr + Zi * Zi ) < 4 ))
      new_Zr = Zr * Zr - Zi * Zi + CRealVal
      new_Zi = 2 * Zr * Zi + CImagVal
      Zr = new_Zr
      Zi = new_Zi
      COUNT = COUNT + 1
    Loop
    Pixel(X,Y) = COUNT Mod 8
  Next Y
Next X
Do
  a$ = Inkey$
Loop While a$ = ""
