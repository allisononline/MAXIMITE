Centre.X = MM.Hres/2
Centre.Y = MM.Vres/2
PixelColour = RGB(0,255,0)

For i = 0 To 2
    For j = 0 To 255
        If j > 0 Then
            PixelColour = PixelColour + (&H100^i)
        EndIf
        For k = 0 To 255
            Dot.X = Sin((2*Pi)/768*((i*256)+(j/2)))*(255-k)
            Dot.Y = Cos((2*Pi)/768*((i*256)+(j/2)))*(255-k)
            Pixel Centre.X+Dot.X,Centre.Y+Dot.Y,PixelColour+(k*(&H100^((i+2) Mod 3)))
        Next
    Next
    For j = 0 To 255
        If j > 0 Then
            PixelColour = PixelColour - (&H100^((i+1) Mod 3))
        EndIf
        For k = 0 To 255
            Dot.X = Sin(((2*Pi)/768)*((i*256)+(j/2)+128))*(255-k)
            Dot.Y = Cos(((2*Pi)/768)*((i*256)+(j/2)+128))*(255-k)
            Pixel Centre.X+Dot.X,Centre.Y+Dot.Y,PixelColour+(k*(&H100^((i+2) Mod 3)))
        Next
    Next
Next
