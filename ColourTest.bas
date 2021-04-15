Centre.X = MM.Hres/2
Centre.Y = MM.Vres/2
PixelColour = RGB(255,0,0)

For i = 0 To 2
    For j = 0 To 255
        Pixel (i*255)+j,Centre.Y,PixelColour
        PixelColour = PixelColour + (&H100^i)
