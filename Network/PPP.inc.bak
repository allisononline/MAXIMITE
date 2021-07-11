#DEFINE "RxBufLength","4000"
#DEFINE "PPPMaxSize","1600"
#DEFINE "PPPFlag","&H7E"
#DEFINE "PPPAddress","&HFF"
#DEFINE "PPPControl","&H03"

'Open "COM1:115200" As #7
GenerateLittleTable
GenerateBigTable
Value$ = FrameCheckSeq$("hello")
Print Hex$(Asc(Left$(Value$,1))),Hex$(Asc(Right$(Value$,1)))

Function PPPGeneralFrame$(Protocol,Information$)
    Header$ = Chr$(PPPFlag)+Chr$(PPPAddress)+Chr$(PPPControl)+Chr$(Protocol>>8)+Chr$(Protocol And &HFF)
    Padding$ = String$(4-((Len(Information$)+4) Mod 4),Chr$(&H00))
    PPPGeneralFrame$ = Header$ + Information$ + Padding$
    Cat PPPGeneralFrame$, FrameCheckSeq$(PPPGeneralFrame$)
    Cat PPPGeneralFrame$, Chr$(PPPFlag)
End Function

Sub GenerateBigTable
    Dim BigEndTable(256)
    Local crc = &H8000
    local i = 1
    Do
        If crc And &H8000 Then
            crc = (crc << 1) Xor &H1021
        Else
            crc = crc << 1
        EndIf
        For j = 0 To i-1
            BigEndTable(i+j) = crc Xor BigEndTable(j)
        Next
        i = i << 1
    Loop While i < 256
End Sub

Sub GenerateLittleTable
    Dim LittleEndTable(256)
    Local crc = 1
    Local i = 128
    Do
        If crc And 1 Then
            crc = (crc >> 1) Xor &H8408
        Else
            crc = crc >> 1
        EndIf
        For j = 0 To 255 Step 2*i
            LittleEndTable(i+j) = crc Xor LittleEndTable(j)
        Next
        i = i >> 1
    Loop While i > 0
End Sub

Function FrameCheckSeq$(InString$)
    Local remain = 0
    For i = 1 To Len(InString$)
'        remain = remain Xor Asc(Mid$(InString$,i,1))
        remain = (remain >> 8) Xor LittleEndTable(Asc(Mid$(InString$,i,1)) Xor (remain And &HFF))
    Next
    FrameCheckSeq$ = Chr$(remain >> 8)+Chr$(remain And &HFF)
End Function
