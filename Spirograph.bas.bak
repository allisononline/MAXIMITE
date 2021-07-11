#DEFINE "SquareSize","200"
#DEFINE "CircleRadius","40"

Xpos = 0
Ypos = 0
SpiroAngle = 0

Sub MovePos
    If Ypos = SquareSize Then
        If Xpos = SquareSize Then
            Inc Ypos,-1
        Else
            Inc Xpos
        EndIf
    ElseIf Ypos = 0 Then
        If Xpos = 0 Then
            Inc Ypos
        Else
            Inc Xpos,-1
        EndIf
    ElseIf Xpos = SquareSize Then
        If Ypos = 0 Then
            Inc Xpos,-1
        Else
            Inc Ypos,-1
        EndIf
    ElseIf Xpos = 0 Then
        If Ypos = SquareSize Then
            Inc Xpos
        Else
            Inc Ypos
        EndIf
    EndIf
End Sub

Do
    MovePos
    SpiroAngle = (SpiroAngle + 1) Mod 360
    DotX = (MM.Hres/2)+Xpos-(SquareSize/2)+(Sin(Rad(SpiroAngle))*CircleRadius)
    DotY = (MM.Vres/2)+Ypos-(SquareSize/2)+(Cos(Rad(SpiroAngle))*CircleRadius)
    Pixel DotX,DotY
Loop


