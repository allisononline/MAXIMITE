DIM gameVerbs$(30), gameCommands$(10), Dirs$(4), objCarryNums(10)
DIM roomDescs$(10), roomHelp$(10), roomExits(10,4)
DIM objKeys$(75), objDescs$(75), objRoomNums(75), objLinks(75), objTakeVal(75), objTakeCode(75)
DIM objEvid(10)
numVerbs = 24
numRooms = 10
numComms = 8
numNouns = 59
invCarryNum = 0
roomNum = 0
currVerb = 0
currNoun = 0
timeElaps = 0
timeAvail = 1000
grimCond = 0
Dirs$(1) = "NORTH"
Dirs$(2) = "EAST"
Dirs$(3) = "SOUTH"
Dirs$(4) = "WEST"

mainProgram

Sub mainProgram
    readData
    gameIntro
    roomNum = 1
    newRoom
    Print
    Do 
        gameInput
    Loop
End Sub

Sub gameInput
    userInput$ = ""
    timeElaps = timeElaps + 3
    If timeElaps > timeAvail Then
        Print "SORRY... YOU RAN OUT OF TIME"
        End
    Endif
    Input "NOW WHAT ? ", userInput$
    userInput$ = UCase$(userInput$)
    Print
    inputSpace = InStr(userInput$, " ")
    If inputSpace Then
        inputVerb$ = Left$(userInput$ , inputSpace - 1)
        For currVerb = 1 To numVerbs
            If inputVerb$ = gameVerbs$(currVerb) Then
                L = Len(userInput$)
                inputNoun$ = Mid$(userInput$, inputSpace + 1, L)
                For currNoun = 1 To numNouns
                    If inputNoun$ = objKeys$(currNoun) And (objRoomNums(currNoun) = roomNum Or objRoomNums(currNoun100)) Then
                        Exit For
                    Endif
                    If currNoun = numNouns Then
                        currNoun = 0
                    EndIf
                Next
                Exit For
            Endif
            If currVerb = numVerbs Then
                currVerb = 0
            EndIf
        Next
        gameVerb
    Else
        inputVerb$ = userInput$
        gameCommand
    EndIf
End Sub

Sub newRoom
    cls
    Print roomDescs$(roomNum)
End Sub

Sub gameMove
    For J = 1 To 4
        If Dirs$(J) = inputNoun$ Then
            If roomExits(roomNum, J) Then
                roomNum = roomExits(roomNum, J)
                newRoom
                Exit Sub
            EndIf
        Endif
    Next
    Print "I CAN'T GO THAT DIRECTION "
End Sub

Sub readData
    Restore
    For i = 1 To numRooms
        Read roomDescs$(i)
        For J = 1 To 4
            Read roomExits(i,j)
        Next
    Next
    For i = 1 To 10
        Read roomHelp$(i)
    Next
    For i = 1 To numComms
        Read gameCommands$(i)
    Next
    For i = 1 To numVerbs
        Read gameVerbs$(i)
    Next
    For i = 1 To numNouns
        Read objKeys$(i),objDescs$(i),objRoomNums(i),objLinks(i),objTakeVal(i),objTakeCode(i)
    Next
End Sub

Sub dataReset
    invCarryNum = 0
    timeElaps = 0
    timeAvail = 1000
    grimCond = 0
    readData
End Sub

Sub gameVocab
    Cls
    Print Tab(16);
    Rem  INVERSE
    Print " COMMANDS "
    Rem NORMAL
    For i = 1 To numComms
        PRINT gameCommands$(i) + ".";
    Next
    Print
    Print
    Print Tab(17);
    Rem INVERSE
    Print " VERBS " 
    Rem NORMAL
    For i = 1 TO numVerbs
        Print gameVerbs$(i) + ".";
    Next
    Print
    Print
    Print Tab(17);
    Rem INVERSE
    Print " NOUNS "
    Rem NORMAL
    For i = 1 TO numNouns
        Print gameNouns$(i) + ".";
    Next
    Print "< PRESS ANY KEY >";
    Do While InKey$ = ""
    Loop
End Sub

Sub gameIntro
    Cls
    Print
    Print
    Print Tab(8) + "*******  *******    ***"
    Print Tab(8) + "*******  *******   *****"
    Print Tab(8) + "**         **     *** ***"
    Print Tab(8) + "**         **     **   **"
    Print Tab(8) + "**         **     **   **"
    Print Tab(8) + "**         **     *******"
    Print Tab(8) + "**         **     *******"
    Print Tab(8) + "**         **     **   **"
    Print Tab(8) + "**         **     **   **"
    Print Tab(8) + "**         **     **   **"
    Print Tab(8) + "*******  ******   **   **"
    Print Tab(8) + "*******  ******   **   **"
    Print
    Print
    Print
    Print "By Susan Drake Lipscom and"
    Print "   Margaret AnumNouns Zuanich.............1984"
    Print "Adapted for Apple II by D. Rioual...2018"
    Print "Adapted for Maximite 2 by Allison ..2022"
    Print
    Print "< PRESS ANY KEY >";
    Do While Inkey$ = ""
    Loop

    Cls
    Print Tab(12): Rem Colour Black, White : Print " WELCOME TO CIA ": Rem Colour White, Black : Print : Print : Print
    Print "YOU ARE A CIA AGENT. THE DEPARTMENT HAS JUST RECEIVED A TIP THAT THE RUSSIAN AMBASSADOR, VLADIMIR GRIMINSKY, IS PASSING CLASSIFIED INFORMATION TO THE KGB."
    Print
    Print "YOU HAVE 2 HOURS WHILE THE AMBASSADOR IS GONE TO COLLECT EVIDENCE. YOU START IN YOUR OFFICE AND THEN PROCEED TO HIS APARTMENT. GOOD LUCK!"
    Print
    Print "< PRESS ANY KEY > ";
    Do While Inkey$ = ""
    Loop
End Sub

Sub gameCommand
    For C = 1 To numComms
        If Left$(userInput$,3) = Left$(gameCommands$(C),3) Then
            Select Case C
                Case 1
                    commHelp
                Case 2
                    commQuit
                Case 3
                    commInv
                Case 4
                    commLook
                Case 5
                    commTime
                Case 6
                    commScore
                Case 7
                    commRestart
                Case 8
                    commVocab
                Case Else
                    Print "INVALID COMMAND CODE " + Format$(C)
            End Select
            Exit Sub
        EndIf
    Next
    For i = 1 To 4
        If userInput$ = Left$(Dirs$(i),1) Or userInput$ = Dirs$(i) Then
        inputNoun$ = Dirs$(i)
        gameMove
        Exit Sub
    Next
    Print "I CAN'T UNDERSTAND " + userInput$
End Sub

Sub commHelp
    Print roomHelp$(roomNum)
End Sub

Sub commQuit
    Input "ARE YOU SURE YOU WANT TO QUIT? "; userInput$
    If userInput$ = "YES" Or userInput$ = "Y" Then
        commTime
        commScore
        End
    EndIf
End Sub
        
Sub commInv
    If invCarryNum Then
        Print "YOU HAVE"
        For i = 1 To invCarryNum
            Print objKeys$(objCarryNums(i))
        Next
    Else
        Print "YOU AREN'T CARRYING ANYTHING"
    EndIf
End Sub


Sub commLook
    Print roomDescs$(roomNum)
End Sub

Sub commTime
    Print "ELAPSED TIME IS "+ Format$(timeElaps)+ " MINUTES."
End Sub

Sub commScore
    If invCarryNum Then
            S = 0
            For i = 1 To invCarryNum
                S = S + objTakeVal(ObjCarryNums(i))
            Next
            Print "YOU HAVE " + Format$(S) + " POINTS FOR EVIDENCE."
    Else
        Print "YOU AREN'T CARRYING ANYTHING"
    EndIf
End Sub

Sub commRestart
    Input "ARE YOU SURE YOU WANT TO RESTART?"; userInput$
    If userUnput$ = "YES" Then
        dataReset
    Else
        Print "SINCE YOU DON'T WANT TO RESTART"
    EndIf
End Sub

Sub commVocab
    cls
    Print Tab(16); 
    Rem INVERSE 
    Print " COMMANDS "
    Rem NORMAL
    For i = 1 To numComms
        Print gameCommands$(i) + ".";
    Next
    Print
    Print
    Print Tab(17);
    Rem INVERSE
    Print " VERBS " 
    Rem NORMAL
    For i = 1 TO numVerbs
        Print gameVerbs$(i) + ".";
    Next
    Print
    Print
    Print Tab(17);
    Rem INVERSE
    Print " NOUNS "
    Rem NORMAL
    For i = 1 TO numNouns
        PRINT objKeys$(i) + ".";
    Next
    Print "< PRESS ANY KEY >";
    Do While InKey$ = ""
    Loop
    newRoom
End Sub

Sub gameVerb
    If currNoun Then
        If objTakeCode(currNoun) = 2 Then
            Select Case currVerb
                Case 1
                    verbLook
                Case 2, 3
                    verbGet
                Case 4, 5, 6
                    verbGo
                Case 7
                    verbOpen
                Case 8
                    verbRead
                Case 9
                    verbDrop
                Case 10
                    verbCall
                Case 11
                    verbUnscrew
                Case 12
                    verbSpray
                Case 13
                    verbPush
                Case 14
                    verbLoad
                Case 15
                    verbRun
                Case 16
                    verbDrink
                Case 17, 18
                    verbEat
                Case 19
                    verbUnwrap
                Case 20
                    verbTalk
                Case 21
                    verbShoot
                Case 22
                    verbUnlock
                Case 23
                    verbOn
                Case 24
                    verbOff
                Case Else
                    Print "INVALID VERB NUMBER " + Format$(currVerb)
            End Select
        Else
            Print "YOU CAN'T " + inputVerb$ + " " + inputNoun$ + " YET."
        Endif
    Else
        If currVerb = 0 Then
            Print "I DON'T KNOW HOW TO " + inputVerb$
        Else
            Print "I DON'T KNOW HOW"
        EndIf
    EndIf
End Sub 

Sub verbLook
    If objRoomNums(currNoun) = roomNum Then
        Do While objLinks(currNoun)
            Print objDescs$(currNoun)
            currNoucurrNoun = objLinks(currNoun)
        Loop
    EndIf
End Sub

Sub verbTake
    K = objTakeCode(currNoun)
    Select Case K
        Case 1
            If invCarryNum < 6 Then
                If objRoomNums(currNoun) = 100 Then
                    Print "YOU ALREADY HAVE IT"
                Else
                    Print "TAKEN"
                    objRoomNums(currNoun) = 100
                    invCarryNum = invCarryNum + 1
                    carriedObjs(invCarryNum) = currNoun
                EndIf
            Else
                Print "YOU CAN'T CARRY ANYTHING ELSE"
            EndIf
        Case 2
            Print "YOU CAN'T TAKE "inputNoun$" YET. "
        Case 3
            Print "SILLY, THAT TOO HEAVY TO CARRY"
        Case 4
            Print "THAT'S RIDICULOUS!"
        Case 5
            Print "YOU CAN'T TAKE "inputNoun$" YET. "
        Case Else
            Print "INVALID TAKE CODE FOR OBJECT " + objKeys$(currNoun) + Format$(objTakeCode(currNoun))
    End Select
End Sub

Sub verbGo
    gameMove
End Sub

Sub verbOpen
    Select Case currNoun
        Case 12
            If objTakeCode(12) = 4 And objTakeCode(13) = 4 Then
                Print "OPENED"
                roomExits(2,1) = 3
            ElseIf objTakeCode(12) = 5 Then
                Print "THE DOOR IS LOCKED."
            ElseIf objTakeCode(13) = 5 Then
                Print "YOU DIDN'T DISCONNECT THE ALARM. IT GOES OFF AND THE POLICE COME AND ARREST YOU...END OF GAME."
                End
            Else
                Print "CAN'T GET THROUGH DOOR YET"
            EndIf
        Case 18
            Input "COMBINATION "; C$
            If C$ = "2-4-8" Then
                Print "OPENED"
                objDescs$(18) = objDescs$(18) + "PARTS OF AN RR-13 RIFLE ARE INSIDE THE PADDED CASED."
            Else
                Print "SORRY - YOU DON'T HAVE THE RIGHT COMBINATION"
            Endif
        Case 44
            Input "COMBINATION ";C$
            If C$ = "20-15-9" Then
                Print "OPENED"
                objLinks(44) = 45
                objTakeCode(45) = 1
                objDescs$(44) = objDescs$(44) + "    INSIDE IS:"
            Else
                Print "SORRY - COMBINATION ISN'T RIGHT"
            Endif
        Case 49
            Print "OPENED"
            objTakeCode(51) = 1
            objLinks(49) = 51
            roomDescs$(10) = Left$(roomDescs$(10),184) + "OPEN"
        Case 17
            Print "YOU STAB YOURSELF WITH THE TIP WHICH IS A POISONED DART. YOU ARE RUSHED TO THE HOSPITAL"
            Print "END OF GAME"
            End
        Case 21
            Print "OPENED"
            objLinks(21) = 57
            objTakeCode(57) = 1
        Case 37
            Print "OPENED"
            objLinks(37) = 38
            objTakeCode(38) = 1
            roomDescs$(8) = Left$(roomDescs$(8),169) + "OPEN"
        Case Else
            Print "A " + inputNoun$ + " CAN'T BE OPENED"
    End Select
End Sub

Sub verbRead
    Select Case roomNum
        Case 3
            If currNoun = 16 Then
                Print "THE TELEPHONE BILL IS MADE OUT TO"
                Print Tab$(2) + "322-9678"
                Print Tab$(2) + "-V.GRIM, P.O. X"
                Print Tab$(2) + "GRAND CENTRAL STATION NYC"
                Print "THE AMOUNT IS $247.36 FOR LONG DISTANCE CHARGES TO WASHINGTON D.C."
            Endif
        Case 20
            Print "YOU CAN JUST MAKE OUT THIS MESSAGE","HEL-ZXT.93.ZARF.1"
        Case 23
            Print "THE BILL IS MADE OUT TO"
            Print Tab$(2) + "322-8721"
            Print Tab$(2) + "AMBASSADOR VLADIMIR ARIMINSKI"
            Print Tab$(2) + "14 PARKSIDE AVENUE - NYC."
            Print "THE BILL IS FOR $68.34 FOR MOSTLY LOCAL CALLS."
        Case 25
            Print "322-8721"
        Case 30
            Print "322-9678"
        Case 42
            Print "20-15-9"
        Case 56
            Print "322-8721"
        Case Else
            Print "NOTHING TO READ"
    End Select
End Sub

Sub verbDrop
    For i = 1 To invCarryNum
        If currNoucurrNoun = carriedObjs(i) Then
            objRoomNums(carriedObjs(i)) = roomNums
            carriedObjs(i) = carriedObjs(invCarryNum)
            invCarryNum = invCarryNum - 1
            Print "DROPPED"
            Exit Sub
        Endif
    Next
    Print "YOU AREN'T CARRYING A " + currNoun$
End Sub

Sub verbCall
    If currNoucurrNoun = 53 And (roomNum = 5 Or roomNum = 6 Or roomNum = 9) Then
        Print "RING...RING"
        Print "HELLO, AGENT. THIS IS YOUR CONTROL"
        Print "SPEAKING"
        Print "LIST YOUR TANGIBLE EVIDENCE"
        Ev = 0
        Ll = 0
        For i = 1 To invCarryNum
            objEvid(i) = 0
        Next
        Do 
            Input userInput$
            If userInput$ = "" Then
                Exit Do
            EndIf
            For i = 1 To invCarryNum
                If Userinput$ = objKeys$(carriedObjs(i)) Then
                    For J = 1 To Ll
                        If objEvid(J) = carriedObjs(i) Then
                            Print "YOU ALREADY SAID " + userInput$
                            Exit For
                        EndIf
                        If J = LI Then
                            Ev = Ev + objTakeVal(carriedObjs(i))
                            Ll = Ll + 1
                            objEvid(Ll) = carriedObjs(i)
                        EndIf
                    Next
                Else
                    Print "YOU'RE NOT CARRYING A " + Userinput$
                Endif
            Next
        Loop
        If Ev > = 40 Then
            Print "FANTASTIC JOB!!"
            Print "WE'LL BE OVER IN A FLASH !"
            Print "TO ARREST THE SUSPECT"
            timeElaps = timeElaps + 6
            If timeElaps > timeAvail Then
                Print "SORRY... YOU RAN OUT OF TIME"
                End
            EndIf
            Print "  -------------"
            Print "AMBASSADOR GRIMINSKI ARRIVES HOME AT 10:30 TO FIND OPERATIVES WAITING TO ARREST HIM."
            Print "  -------------"
            Print "YOU ARE HANDSOMELY REWARDED FOR YOUR CLEVER SLEUTHING."
            Print "YOU SOLVED THE MYSTERY IN "+ Format$(timeElaps) + " MINUTES."
            End
        Else
            Print "I'M SORRY YOU HAVE INSUFFICIENT EVIDENCE FOR A CONVICTION. CALL ME WHEN YOU HAVE MORE INFORMATION"
        EndIf
    ElseIf currNoun <> 53 Then
        Print "IT'S NO USE TO CALL " + inputNoun$
    Else
        Print "YOU'RE NOT NEAR A PHONE"
    Endif
End Sub

Sub verbUnscrew
    If currNoucurrNoun = 13 Then
        For i = 1 To invCarryNum
            If Objkeys$(carriedObjs(i)) = "SCREWDRIVER" Then
                Print "THE ALARM SYSTEM IS OFF" 
                objTakeCode(13) = 4
                Odirs$(13) = "THE ALARM IS DISABLED"
                Exit Sub
            Endif
        Next
        Print "YOU HAVE NOTHING TO UNSCREW WITH"
        Exit Sub
    Endif
    Print "YOU CAN'T UNSCREW A " + inputNoun$
End Sub
 
Sub verbSpray
    If currNoucurrNoun = 14 Or currNoucurrNoun = 10 Then
        For i = 1 To invCarryNum
            If carriedObjs(i) = 10 Then
                    Print "THE DOG IS DRUGGED AND FALLS HARMLESSLY","AT YOUR FEET."
                    roomExits(3,1) = 5
                    roomExits(3,2) = 9
                    roomExits(3,4) = 4
                    roomDescs$(3) = Left$ (roomDescs$(3),176) + " THE DRUGGED DOG IS ON THE FLOOR."
                    objDescs$(14) = "THE FIERCE DOBERMAN LIES DRUGGED ON THE FLOOR."
                    carriedObjs(i) = carriedObjs(invCarryNum)
                    invCarryNum = invCarryNum - 1
                    Print "THE DRUG IS USED UP AND NO LONGER IN YOUR INVENTORY."
                    Exit Sub
            Endif
        Next
        Print "YOU HAVE NOTHING TO SPRAY WITH"
        Exit Sub
    Else
        Print "YOU CAN'T SPRAY A " + inputNoun$
    EndIf
End Sub

Sub verbPush
    If currNoun = 26 Then
        Print "THE PANEL POPS OPEN TO REVEAL THE ENTRANCE TO A PREVIOUSLY HIDDEN ROOM."
        roomExits(5,2) = 6
        objDescs$(26) = Left$(objDescs$(26),35) + "A HIDDEN ROOM CAN BE SEEN BEHIND ONE PANEL."
        Exit Sub
    Endif
    Print "IT DOESN'T DO ANY GOOD TO PUSH A " + currNoun$
End Sub

Sub verbLoad
    If currNoun = 28 Then
        If objRoomNums(28) = 6 Then
            Print "THE PROGRAM IS ALREADY LOADED"
            Exit Sub
        Else
            Print "THAT WON'T HELP YOU"
            Exit Sub
        Endif
    Endif
    Print "CAN'T LOAD A " + currNoun$
End Sub

Sub verbRun
    If currNoun = 28 Then
        If objTakeCode(31) = 5 Or objTakeCode(32) = 5 Or objTakeCode(33) = 5 Then
            Print "THE COMPUTER CAN'T RUN THE PROGRAM YET."
        Else
            objTakeCode(28) = 1
            Print "THE PROGRAM DIALS A WASHINGTON D.C. NUMBER. A MESSAGE APPEARS ON THE MONITOR."
            Input "PLEASE LOG IN "; C$
            If C$ = "HEL-ZXT.93.ZARF.1" Then
                Print "THE FOLLOWING MESSAGE APPEARS ON THE MONITOR: THIS IS THE UNITED STATES DEFENSE DEPARTMENT'S TOP SECRET ACCOUNT FOR WEAPONS DEVELOPMENT AND RADAR RESISTANT AIRCRAFT DATA. ALL INFORMATION IS CLASSIFIED."
            Else
                If grimCond = 0 Then
                    grimCond = 2
                    Print
                    Print "INVALID LOGON CODE - THE SCREEN GOES BLANK. YOU HEAR FOOTSTEPS. GRIMINSKI LOOMS IN THE DORWAY WITH AN 8-M LUGAR IN HAND. YOU'D BETTER HAVE BROUGHT THE PPK-3 PISTOL FROM THE DEPARTMENT OR YOU'RE FINISHED!"
                    gameInput
                    If Inputverb$ = "SHOOT" Then
                        verbShoot
                    Endif
                Else
                    Print "INVALID LOGON CODE"
                EndIf
            EndIf
        Endif
    Else
        Print "YOU CAN'T RUN A " + currNoun$
    EndIf
End Sub

Sub verbDrink
    If currNoucurrNoun = 36 Then
        Print "YOU ARE POISONED, STAGGER TO THE PHONE AND CALL THE AMBULANCE...END OF GAME"
        End
    Else
        Print "YOU CAN'T DRINK " + currNoun$
    EndIf
End Sub

Sub verbEat
    If currNoucurrNoun = 39 Or currNoucurrNoun = 54 Then
        Print "YOU FOOL! THESE ARE CYANIDE CAPSULES. YOU FALL WRITHING TO THE FLOOR AND DIE IN AGONY ... END OF GAME."
        End
    ElseIf currNoucurrNoun = 45 Then
        Print "YOU IDIOT!  THE GUM IS A PLASTIC EXPLOSIVE. YOU HAVE JUST BLOWN YOURSELF TO SMITHEREENS!! ... END OF GAME."
        End
    Else
        Print "YOU CAN'T " + inputVerb$ + " " + inputNoun$
    EndIf
End Sub

Sub verbUnwrap
    If currNoun = 45 Then
        Print "THE WRAPPER CONCEALS A TINY STRIP OF MICROFILM."
        objTakeCode(46) = 1
    Else  
        Print "IT DOESN'T HELP TO UNWRAP " + inputNoun$
    EndIf
End Sub

Sub verbTalk
    If currNoun = 14 Then
        Print "HE DOESN'T SPEAK ENGLISH!"
    Else
        Print "THAT WON'T HELP YOU"
    EndIf
End Sub

Sub verbShoot
    If currNoun = 8 Or currNoun = 14 Or currNoun = 58 Then
        For i = 1 To invCarryNum
            If carriedObjs(i) = 8 Then
                If roomNum = 3 Then
                    Print "THE DOG BITES YOUR HAND!"
                ElseIf roomNum = 6 Then
                    If grimCond = 2 Then
                        Print "YOUR SHOT GRAZES HIS FOREHEAD. HE CRASHES TO THE FLOOR UNCONSCIOUS. YOU HAVE TIME TO GATHER ADDITIONAL EVIDENCE TO APPREHEND HIM."
                        grimCond = 1
                        roomDescs$(6) = Left$(roomDescs$(6),201) + "GRIMINSKI IS LYING UNCONSCIOUS ON THE FLOOR"
                    Else
                        Print "THAT WON'T HELP"
                    EndIf
                Else
                    Print "THAT JUST MAKES A BIG MESS!"
                Endif
                Exit Sub
            EndIf
        Next
        If roomNum = 6 And grimCond = 2 Then
            Print "YOU DON'T HAVE THE PISTOL. ANYTHING ELSE TAKES TOO MUCH TIME."
            Print "IT'S HOPELESS! GRIMINSKI FIRES.... YOU CRUMPLE TO THE FLOOR...END OF GAME"
            End
        Else
            Print "YOU HAVE NOTHING TO SHOOT WITH."
        EndIf
    ElseIf roomNum = 6 And grimCond = 2 Then
        Print "IT'S HOPELESS! GRIMINSKI FIRES.... YOU CRUMPLE TO THE FLOOR...END OF GAME"
        End
    Else
        Print "THAT WON'T HELP"
    Endif
End Sub

Sub verbUnlock
    If currNoun = 12 Then
        For i = 1 To invCarryNum
            If Objkeys$(carriedObjs(i)) = "KEY" Then
                Print "UNLOCKED"
                objTakeCode(12) = 4
                Exit Sub
            Endif
        Next
        Print "YOU HAVE NOTHING TO USE TO UNLOCK THE DOOR "
        Exit Sub
    Else
        Print "YOU CAN'T " + Inputverb$ + " A " + inputNoun$
    EndIf
End Sub
    
Sub verbOn
    If (currNoun > = 31 And currNoun < = 33) Then
        If currNoun = 31 Then
            M = 137
        ElseIf currNoun = 32 Then
            M = 57
        ElseIf currNoun = 33 Then
            M = 111
        Endif
        objDescs$(currNoun) = Left$(objDescs$(currNoun),M) + " ON"
        Print "ON"
        objTakeCode(currNoun) = 3
    Else
        Print "YOU CAN'T TURN ON A " + inputNoun$
    EndIf
End Sub

Sub verbOff
    If (currNoun > = 31 And currNoun < = 33) Then
        If currNoun = 31 Then M = 137
        Endif
        If currNoun = 32 Then M = 57
        Endif
        If currNoun = 33 Then M = 111
        Endif
        objDescs$(currNoun) = Left$(objDescs$(currNoun),M) + " OFF"
        Print "OFF"
        objTakeCode(currNoun) = 5
    Else
        Print "YOU CAN'T TURN OFF A "N$: Return
    EndIf
End Sub

Data "YOU ARE IN YOUR OFFICE AT THE CIA. ON THE SHELVES ARE TOOLS YOU'VE USED IN PAST MISSIONS. AMBASSADOR GRIMINSKI'S  APARTMENT IS NORTH.",2,0,0,0
Data "YOU ARE AT 14 PARKSIDE AVENUE THE ENTRANCE TO AMBASSADOR GRIMINSKI'S SMALL BUT ELEGANT BACHELOR APARTMENT. YOU SEE A HEAVY WOODEN DOOR WITH A NOTICE ON IT WARNING OF AN ALARM SYSTEM.",0,0,1,0
Data "THIS IS THE MARBLED FOYER OF THE AMBASSADOR'S APARTMENT. THERE IS A TABLE IN THE CORNER. THE MASTER BEDROOM IS EAST, THE DRAWING ROOM IS NORTH AND A CLOSET WEST. A FIERCE DOG CHARGES TO ATTACK.",0,0,2,0
Data "YOU ARE IN THE FRONT HALL CEDAR CLOSET. HEAVY OVERCOATS AND A TRENCHCOAT ARE HANGING UP. BOOTS ARE ON THE FLOOR AND OTHER ITEMS ARE IN THE CORNER.",0,3,0,0
Data "YOU ARE IN THE DRAWING ROOM. A DESK IS HERE. A SOFA AND A COFFEE TABLE ARE IN FRONT OF THE FIREPLACE SET INTO THE  PANELED EAST WALL. THE DINING ROOM IS NORTH.",7,0,3,0
Data "YOU CAN SEE A MICROCOMPUTER AND PHONE MODEM AND MONITOR ON A TABLE AGAINST THE EAST WALL OF THIS OVER-SIZED CLOSET. A PHONE IS BY THE COMPUTER. A CHAIR AND SHELVES ARE HERE.",0,0,0,5
Data "YOU ARE STANDING IN A SMALL FORMAL DINING ROOM. THE TABLE SEATS SIX GUESTS. A SIDEBOARD WITH A TRAY ON IT IS AGAINST THE EAST WALL. THE KITCHEN IS TO THE NORTH. ",8,0,5,0
Data "YOU ARE IN THE APARTMENT KITCHEN WHICH SHIMMERS WITH POLISHED CHROME APPLIANCES AND BUTCHER BLOCK COUNTERS. A LONG CABINET ABOVE THE STAINLESS STEEL SINKS IS CLOSED.",0,0,7,0
Data "THIS IS AMBASSADOR GRIMINSKI'S BEDROOM. A BED AND BEDSIDE TABLE ARE HERE. A SAFE IS IN THE WALL ABOVE THE BUREAU. THE BATHROOM AND DRESSING AREA ARE TO THE NORTH.",10,0,0,3
Data "YOU ARE IN A COMBINED BATHROOM AND DRESSING AREA. THE AMBASSADOR'S CLOTHES ARE HANGING NEATLY ON RODS AND  OPEN SHELVES HOLD TOWELS AND SWEATERS. THE MEDICINE CABINET IS CLOSED.",0,0,9,0
Data "YOU'LL NEED SOME TOOLS TO GET INTO THE APARTMENT."
Data "MAYBE YOUR TOOLS WILL HELP YOU."
Data "SOMETHING FROM YOUR OFFICE COULD BE HELPFUL NOW."
Data "FIRST IMPRESSIONS CAN BE DECEIVING."
Data "THERE IS MORE HERE THAN MEETS THE EYE."
Data "RUNNING A PROGRAM IS ALWAYS INTERESTING."
Data "I CAN'T HELP YOU HERE."
Data "BE SUSPICIOUS OF ITEMS IN SMALL BOTTLES."
Data "THINGS ARE OFTEN NOT WHAT THEY SEEM."
Data "DON'T OVERLOOK THE OBVIOUS."
Data "HELP","QUIT","INVENTORY","LOOK","TIME","SCORE","RESTART","VOCABULARY"
Data "LOOK","GET","TAKE","GO","CRAWL","WALK","OPEN","READ","DROP","CALL","UNSCREW","SPRAY","PUSH","LOAD","RUN","DRINK","EAT","CHEW","UNWRAP","TALK","SHOOT","UNLOCK","ON","OFF"
Data "NORTH","IT DOESN'T HELP",100,0,0,4
Data "EAST", "IT DOESN'T HELP",100,0,0,4
Data "SOUTH","IT DOESN'T HELP",100,0,0,4
Data "WEST", "IT DOESN'T HELP",100,0,0,4
Data "SHELVES","SHELVES FOR WEAPONS AND TOOLS LINE THE WALL NEXT TO YOUR DESK. THERE ARE NUMEROUS ITEMS WHICH MAY HELP YOU ON YOUR ASSIGNMENT.",1,6,0,3
Data "SCREWDRIVER","AN ALL-PURPOSE SCREWDRIVER WITH COLLAPSIBLE HANDLE.",1,7,0,1
Data "BOMB","A MARK MX HIGH-INTENSITY SMOKE BOMB",1,8,0,1
Data "PISTOL","AN AUTOMATIC PPK-3 PISTOL",1,9,0,1
Data "KEY","A SKELETON KEY",1,10,0,1
Data "DRUG","A SMALL CAN OF INSTA-KNOCKOUT DRUG",1,11,0,1
Data "GUN","A MARK 3K HARPOON GUN WITH GRAPPLE AND  LINE.",1,0,0,1
Data "DOOR","THE HEAVY DOOR IS PAINTED BLACK. A BRASSKEYHOLE AND DOORKNOB ARE HERE. YOU CAN SEE THE CIRCULAR HOLES ON EITHERSIDE OF THE DOOR WHICH MUST RADIATE AN ELECTRONIC ALARM BEAM.",2,13,0,5
Data "ALARM","THE ALARM IS SCREWED INTO PLACE.",2,0,0,5
Data "DOG","THE SAVAGE DOBERMAN LEAPS TOWARD YOU WITH BARED FANGS. HE WILL NOT LET YOU PAST HIM.",3,0,0,4
Data "TABLE","THE VENETIAN FRONT HALL TABLE HAS A TORTOISESHELL LETTER TRAY ON IT FOR BUSINESS CARDS AND MAIL. THERE IS A LETTER IN THE TRAY.",3,0,0,1
Data "LETTER","THIS IS APPARENTLY A TELEPHONE BILL THAT HAS BEEN PAID AND IS BEING SENT TO THE TELEPHONE COMPANY",3,0,10,1
Data "UMBRELLA","THERE IS A BLACK BUSINESSMAN'S UMBRELLA WITH A POINTED END.",4,18,0,1
Data "BRIEFCASE","THERE IS A BLACK LEATHER BRIEFCASE WITH A COMBINATION LOCK.",4,0,0,1
Data "DESK","THE LARGE OAK DESK HAS A BLOTTER AND PEN SET ON IT. A PHONE IS HERE. A BLANK NOTE PAD IS BY THE PHONE. THE DESK HAS A PIGEONHOLE AND ONE DRAWER IN IT.",5,0,0,1
Data "PAD","ALTHOUGH THE NOTEPAD IS BLANK YOU CAN SEE THE INDENTATION OF WRITING ON IT.",5,0,0,1
Data "DRAWER","THIS IS A STANDARD PULL DESK DRAWER.",5,0,0,4
Data "PIGEONHOLE","THE PIGEONHOLE HAS A PAID BILL IN IT.",5,0,0,4
Data "BILL","THE BILL IS FROM THE TELEPHONE COMPANY.",5,0,0,1
Data  "PHONE","THIS IS A BEIGE PUSHBUTTON DESK PHONE.",5,25,0,4
Data "NUMBER","THE TELEPHONE NUMBER IS PRINTED ON THE BASE.",5,0,0,4
Data "PANEL","THE PANELS ARE TONGUE-IN-GROOVE. ONE OFTHE PANELS SEEMS MORE WORN THAN THE OTHERS.",5,0,0,4
Data "SHELVES","THERE ARE SOFTWARE PROGRAMS AND BLANK DISKS AND MANUALS ON THE SHELVES.",6,0,0,4
Data "PROGRAM","ONE PROGRAM IS FOR COMMUNICATING WITH THE U.S DEFENSE DEPARTMENT'S MAIN FRAME COMPUTER.",6,0,10,5
Data "PHONE","THIS IS A STANDARD DESK-TYPE DIAL TELEPHONE. THE RECEIVER IS SET INTO A MODEM.",6,30,0,4
Data "NUMBER","THE TELEPHONE NUMBER IS PRINTED ON THE BASE.",6,0,0,1
Data "COMPUTER","THIS IS A STANDARD BUSINESS TYPE OF MICROCOMPUTER WITH A KEYBOARD AND A PROGRAM IN ONE OF THE DISK DRIVES. THE ON/OFF SWITCH IS OFF.",6,0,0,5
Data "MONITOR","THIS IS A HI-RES COLOR MONITOR. THE ON/OFF SWITCH IS OFF.",6,0,0,5
Data "MODEM","THE PHONE MODEM IS ONE THAT CAN USE AN AUTOMATIC DIALING COMMUNICATIONS PROGRAM. THE ON/OFF SWITCH IS OFF.",6,0,0,5
Data "TRAY","THE SILVER TRAY HOLDS A DECANTER PARTIALLY FILLED WITH CLARET.",7,0,0,1
Data "DECANTER","THE DECANTER IS OF ETCHED CRYSTAL. IT PROBABLY HOLDS SOME CLARET",7,0,0,1
Data "CLARET","AN AMBER LIQUID",7,0,0,1
Data "CABINET","THIS IS A FAIRLY STANDARD KITCHEN CABINET.",8,0,0,4
Data "BOTTLE","A BOTTLE OF CAPSULES ARE HERE.",8,39,0,2
Data "CAPSULE", "THE CAPSULES ARE ELONGATED AND HAVE A SLIGHT AROMA OF BURNT ALMONDS.",8,0,0,1
Data "TABLE","THE BEDSIDE TABLE HAS A PHONE ON IT. A PIECE OF PAPER AND A LAMP ARE HERE.",9,0,0,3
Data "PHONE","THERE IS A NUMBER PRINTED ON THE PHONE.",9,0,0,4
Data "PAPER","A PIECE OF MONOGRAMMED WRITING PAPER",9,43,0,1
Data "COMBINATION","THERE IS A COMBINATION WRITTEN ON IT.",9,0,0,4
Data "SAFE","THIS IS A STANDARD COMBINATION SAFE.",9,0,0,4
Data "GUM","A PACK OF STICK TYPE PEPPERMINT GUM. EACH STICK IS WRAPPED IN PAPER.",9,0,0,2
Data "MICROFILM","THE MICROFILM HAS BEEN DEVELOPED BUT YOU CAN'T SEE IT WITHOUT SPECIAL EQUIPMENT. NEVERTHELESS IT'S PRETTY CERTAIN WHAT YOU HAVE FOUND.",9,0,10,2
Data "SHELVES","A VERY SOPHISTICATED CAMERA IS ON ONE OF THE SHELVES.",10,0,0,4
Data "CAMERA","THIS CAMERA IS USED TO PHOTOGRAPH DOCUMENTS ON MICROFILM.",10,0,10,1
Data "CABINET","THIS IS A LARGE MIRRORED BATHROOM CABINET.",10,0,0,4
Data "BUREAU","A WALL SAFE IS SET INTO THE WALL ABOVE THE LOW MAHOGANY CARVED BUREAU.",9,0,0,3
Data "BOTTLES","BOTTLES OF FIXER AND PHOTOFLO ARE ON THE SHELVES.",10,52,0,2
Data "TANK","THERE IS A FILM DEVELOPING TANK AND A FILM APRON AND TANK COVER HERE TOO.",10,0,0,2
Data "HEADQUARTERS","HEADQUARTERS",100,0,0,4
Data "CAPSULES","THE CAPSULES ARE ELONGATED AND HAVE A SLIGHT AROMA OF BURNT ALMONDS.",8,0,0,1
Data "SIDEBOARD","A LARGE ORNATE SIDEBOARD WITH A BEVELED GLASS MIRROR DOMINATES THE EAST WALL.",7,34,0,4
Data "NUMBER","THE NUMBER IS PRINTED ON THE PHONE",9,0,0,1
Data "PAPER","THE NUMBERS 2-4-8 ARE WRITTEN ON A PIECE OF PAPER ON THE TOP OF THE DRAWER.",5,0,0,2
Data "GRIMINSKI","THE WHITE-HAIRED MAN IS DRESSED IN EVENING CLOTHES",6,0,0,4
Data "CORNER","YOU ARE LOOKING AT THE CORNER OF THE CLOSET.",4,17,0,4