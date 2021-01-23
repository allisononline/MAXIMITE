   '**********************************
   '*           Maxi-Font            *
   '*   Font Editor by Dennis Wyatt  *
   '*      Using mmBasic for the     *
   '*        Maximite computer       *
   '*             V 3.1              *
   '**********************************
   ' get maximum screen dimension-split into 20 parts
   Max_x=MM.HRes : Min_x=Cint(Max_x/20)
   Max_y=MM.VRes : Min_y=Cint(max_y/20)
   Cls
   addchar=1
   '***********************************
   ' Set to Capture SD card errors
   '***********************************
   Option Error Continue
   '***********************************
   '*     Show front page
   '***********************************
   Font Load "gothic.fnt" As #4 : Font #4
   Print @(0,1) "200000000000004"
   Print @(0,33) "1" 
   Print @(max_x-32,33) "1"
   Print @(0,65) "1"
   Print @(max_x-32,65) "1"
   Print @(0,92) "300000000000005"
   '**********************************************
   '*   return to font 1 and unload gothic font
   '*      need the memory
   '**********************************************
   Font #1 
   Font unload #4
   Font Load "invade.fnt" As #5
   Font #5
   Print @(40,57) "0  2  4"
   Print @(15*min_x,57) "1  3  5"
   Font #1
   Print @(9*min_x,37) "Welcome to"
   Font #1,3
   Print @(7.3*min_x,52)"MaxiFont"
   Line (0,124)-(max_x,124),1
   Font #1,1
   Print @(2*min_x,130)"This program will help you to design some interesting fonts, with"
   Print @(2*min_x,145)"the added scope of allowing the design of program sprites, for the"
   Print @(2*min_x,160)"inclusion into some Maximite games, or just make some gothic borders."
   Print @(2*min_x,190)"The design of the font should take into account the available"
   Print @(2*min_x,205)"memory in the system. This is about 37 Kb, for arrays, used in the"
   Print @(2*min_x,220)"design process. This limits the number of characters, in the editor"
   Print @(2*min_x,235)"at one time. A 255 pixel wide font by 64 pixels high can only have"
   Print @(2*min_x,250)"2 Characters, if I rewrite the code. A 10 pixel by 10 pixel font can"
   Print @(2*min_x,265)"have only 70 characters in the editor at one time."
   Print @(2*min_x,280)"You can always append the files together later. Once saved the font"
   Print @(2*min_x,295)"takes up one quarter the size."
   Print @(2*min_x,310)"It would be easier to design a smaller font and just piece them"
   Print @(2*min_x,325)"together to form one large picture."
   Print @(2*min_x,340)"If you encounter an out of memory error, then reduce the number of "
   Print @(2*min_x,355)"Characters"
   Print @(9*min_x,385)"press any key"
   Do While (Inkey$="")
   Font #5
   Pause 100
   frontpage=Not frontpage
   If (frontpage=1) Then
   Print @(40,57)"1  3  5" @(15*min_x,57)"0  2  4"
   Else
   Print @(40,57)"0  2  4" @(15*min_x,57)"1  3  5"
   EndIf
   Loop
   For a=1 To 5
   Pause 150
   On a GoTo explode1,explode2,explode3,explode4,explode5
explode1: 
	Print @(40,57)"6  6  6" @(15*min_x,57)"6  6  6"
	Next a
explode2: 
	Print @(40,57)"7  7  7" @(15*min_x,57)"7  7  7"
	Next a
explode3: 
	Print @(40,57)"8  8  8" @(15*min_x,57)"8  8  8"
	Next a
explode4: 
	Print @(40,57)"9  9  9" @(15*min_x,57)"9  9  9"
	Next a
explode5: 
	t$=Chr$(59)+"  "+Chr$(59)+"  "+Chr$(59)
   	Print @(40,57)t$ @(15*min_x,57) t$ 
	Next a
   	Font #1 
	Font unload #5
  	t$="               "
   Line(2*min_x,130)-(max_x,max_y),0,BF
   Print @(0,130)"";
Fontwidth:
	? t$;
	Input "Width of Font? ",fwidth
   		If (fwidth>255) Then
   			? t$+"Cannot be bigger than 255 pixels"
			GoTo Fontwidth
   		EndIf
Fontheight: 
	? t$; 
	Input "Height of Font ? ",fheight
   	If (fheight > 64) Then
   		? t$+"Cannot be higher than 64 pixels"
		GoTo Fontheight
   	EndIf
   	If (fheight =0) Then
   		? t$+"Cannot be lower than 1 pixels"
		GoTo Fontheight
   	EndIf
Fontnumber:
	? t$;
	Input "Number of Characters ? ",fnumber
   	If (fnumber =0) Then
   		? t$+"Cannot be less than 1 Character"
		GoTo Fontnumber
   	EndIf
   	If (fnumber >128) Then
   		? t$+"Cannot be more than 128 Characters"
		GoTo Fontnumber
   	EndIf
Fontstart: 
	? t$; : Input "Start Character set at ?";fstart
   	If (fstart<32) Then
   		? t$+"Cannot be less than 32 "
		GoTo Fontstart
   	EndIf

   Cls

   Option base 0

   Dim values(4)

   Dim plot(fnumber,fwidth,fheight)

   Line (0,0)-(max_x-1,100),1,BF
   Line (10,10)-(max_x-11,90),0,BF

   GoSub UpdateFontDetails

   Line (0,101)-(max_x-1,max_y-1),1,B
   Line (2,103)-(6*min_x,max_y-3),1,B

   screenx=Max_x-1-(7*min_x)

Setupgrid: 
	screenstepx=Cint(screenx/fwidth-1)
   	countxmax=screenstepx*fwidth+7*min_x
   	screeny=max_y-104
	screenstepy=Cint(screeny/fheight-1)
   	countymax=screenstepy*fheight+104
   	Line (7*min_x,103)-(19*min_x,19*min_y),0,BF
   	For countx = 7*min_x To countxmax Step screenstepx
   		Line (countx,103)-(countx,countymax),1
   	Next countx
   	For county = 103 To countymax Step screenstepy
   		Line (7*min_x,county)-(countxmax,county),1
   	Next county
   	box_x=screenstepx-2
	box_y=screenstepy-2
   	cursorx=7*min_x+1
	cursory=104
   GoSub Instructions
   GoSub Displayfontchar               ' read font info into display
   Timer=0
   plotx=1 : ploty=1 : charxy=1
   Print @(160,15)"X-Position"
	GoSub update_x_position
   Print @(160,30)"Y-Position"
	GoSub update_y_position
   Print @(160,45)"Character #"
	GoSub update_char_number
   Print @(160,60)"Character code "
	GoSub update_char_code
   Do
   	text$=Inkey$
   	If (text$<>"") Then GoSub Continueloop
   		timerloop=Timer
   		If (timerloop>oldloop+100) Then
   			oldloop=oldloop+100
   			cmode=Not cmode
   			GoSub flash_cursor_pos
   		EndIf
   Loop

flash_cursor_pos: 
	Line (cursorx,cursory)-(cursorx+box_x,cursory+box_y),cmode,BF
   	Return

Continueloop: 
	If (Asc(text$)=131) Then
   		If (plotx=fwidth) Then
   			'  do nothing at right edge already
   		Else
   			cursorx=cursorx+screenstepx
   			plotx=plotx+1
   			GoSub update_x_position
   		EndIf
   			If (plot(charxy,plotx-1,ploty)=0) Then direction=1 : GoSub clear_right
   			If(plot(charxy,plotx-1,ploty)=1) Then direction=1 : GoSub draw_right
   		EndIf
   	EndIf

   	If (Asc(text$)=130) Then
   		If (plotx=1) Then
   			'  do nothing at left edge already
   		Else
   			cursorx=cursorx-screenstepx
   			plotx=plotx-1
   			GoSub update_x_position
   		EndIf
   		If (plot(charxy,plotx+1,ploty)=0) Then direction=-1 : GoSub clear_right
   		If(plot(charxy,plotx+1,ploty)=1) Then direction=-1 :GoSub draw_right
   		EndIf
   	EndIf

   	If (Asc(text$)=128) Then
   		If (ploty=1) Then
   			'  do nothing at top edge already
   		Else
   			cursory=cursory-screenstepy
   			ploty=ploty-1
   			GoSub update_y_position
   		EndIf
   		If (plot(charxy,plotx,ploty+1)=0) Then direction=-1 : GoSub clear_down
   		If(plot(charxy,plotx,ploty+1)=1) Then direction=-1 :GoSub clear_up
   		EndIf
   	EndIf

   	If (Asc(text$)=129) Then
   		If (ploty=fheight) Then
   			'  do nothing at bottom edge already
   		Else
   			cursory=cursory+screenstepy
   			ploty=ploty+1
   			GoSub update_y_position
   			If (plot(charxy,plotx,ploty-1)=0) Then direction=1 : GoSub clear_down
   			If(plot(charxy,plotx,ploty-1)=1) Then direction=1 :GoSub clear_up
   		EndIf
   	EndIf

   	If(text$="-") Then GoSub Char_up

   	If (Asc(text$)=132) Then GoSub Insert_char

   	If(text$="e"Or text$="E") Then
   		Cls 
		? "Hope you found this tool useful!"
		End
   	EndIf

   If (text$="c" Or text$="C") Then GoSub Copy_char

   If (text$="v" Or text$="V") Then GoSub Vertical_flip

   If (text$="h" Or text$="H") Then GoSub horizontal_flip

   If (Asc(text$)=139) Then GoSub Set_plot

   If(text$="+") Then GoSub Char_down

   If (Asc(text$)=32) Then GoSub Clear_plot

   If (text$="s" Or text$="S") Then GoSub Save_font

   If (text$="l" Or text$="L") Then GoTo Load_font

update_x_position: 
	Print @(220,15)plotx;"    "
   	Return

update_y_position: 
	Print @(220,30)ploty;"    "
   	Return

update_char_number: 
	Print @(230,45)charxy;"    "
	Return

update_char_code: 
	Print @(245,60)fstart+charxy-1;"    "
   	Return

clear_right: 
	tempx=cursorx-(direction*screenstepx)
   	Line (tempx,cursory)-(tempx+box_x,cursory+box_y),0,BF
   	Return

draw_right: 
	tempx=cursorx-(direction*screenstepx)
   	Line (tempx,cursory)-(tempx+box_x,cursory+box_y),1,BF
   	Return

clear_down: 
	tempy=cursory-(direction*screenstepy)
   	Line (cursorx,tempy)-(cursorx+box_x,tempy+box_y),0,BF
   	Return

clear_up: 
	tempy=cursory-(direction*screenstepy)
   	Line (cursorx,tempy)-(cursorx+box_x,tempy+box_y),1,BF
   	Return

Set_plot: 
	Pixel(52+plotx,292+ploty)=1
   	plot(charxy,plotx,ploty)=1
   	Return

Clear_plot: 
	plot(charxy,plotx,ploty)=0
   	Pixel(52+plotx,292+ploty)=0
   	Return

Save_font: 
	GoSub Clear_box
	Print @(270,20)"                           "
   	Print @(270,20); 
	Input "Filename to Save : ",savename$
   	If (Right$(savename$,3)<>"fnt") Then savename$=savename$+".fnt"

Insert_save_font: 
	Open savename$ For output As #1
   	typefile$="save"
   	On MM.Errno GoTo No_sd_card, Card_protected, no_space_left, All_root_gone, Invalid_filename, Cannot_find_file
   	Print #1,fheight","fwidth","fstart","fstart+fnumber-addchar
   	For numchar=1 To fnumber
   		For row = 1 To fheight
   			temp$=""
   			For column=1 To fwidth
   				If (plot(numchar,column,row)=1) Then temp$=temp$+"X"
   				If (plot(numchar,column,row)=0) Then temp$=temp$+" "
   			Next column
   			Print #1,temp$
   		Next row
	next numchar

   	If addchar=0 Then GoSub Insert_Char_now
   	Close #1
   		GoSub Clear_box
   	Print @(270,20)"save ok"
   	Return

Load_font: 
	GoSub Clear_box
	Print @(270,20)"                           "
   	Print @(270,20);
	Input "Filename to load : ",fname$
   	If (Right$(fname$,3)<>"fnt") Then fname$=fname$+".fnt"

Insert_Load_Font: 
	Open fname$ For input As #2
   	typefile$="load"
   	On MM.Errno GoTo No_sd_card, Card_protected, no_space_left, All_root_gone, Invalid_filename, Cannot_find_file
   	Line Input #2,temp$
   	Erase values
    	Dim values(4)
   	pointer=1: fwidth =0: fheight=0 :fnumber=0 :fstart=0
   	For a= 1 To Len(temp$)
   		a$=Mid$(temp$,a,1)
   		If (a$=",") Then
       			values(pointer)=Val(rwidth$)
       			pointer=pointer+1
      			rwidth$=""
   		Else
      			rwidth$=rwidth$+a$
   		EndIf
   	Next a
   	values(4)= Val(rwidth$)
   	fwidth=values(2)
   	fheight=Val(temp$)
   	fstart=values(3)
   	fnumber=values(4)-values(3)+1
   	Erase plot
	GoSub My_pause
    	Dim plot(fnumber,fwidth,fheight)
   	GoSub My_pause
   	For a= 1 To fnumber
   		For c=1 To fheight
   			Line Input #2,temp$
   			For b=1 To fwidth
   				If (Mid$(temp$,b,1)=Chr$(32)) Then
   					plot(a,b,c)=0
   				Else
   					plot(a,b,c)=1
   				EndIf
   			Next b
		next c
	next a
   	Close #2
   	GoSub Clear_box
   	Print @(270,20)"load ok"
   		GoSub UpdateFontDetails
   		GoTo Setupgrid
Char_up: 
	If (charxy =1) Then
   		'rem do nothing
   	Else
   		charxy=charxy-1
   		GoSub update_char_number
   		GoSub Displayfontchar
   	EndIf
   	Return

Char_down: 
	If (charxy =fnumber) Then
   		'rem do nothing
   	Else
   		charxy=charxy+1
   		GoSub update_char_number
   		GoSub Displayfontchar
   	EndIf
   	Return

Displayfontchar: 
   	Line (52,292)-(52+fwidth,292+fheight),0,BF
   	a=charxy
	If (a=0) Then a=1
   	cursorx=7*min_x+2 : cursory=105
   	plotx=1 :ploty=1
   	For c=1 To fheight
   		For b=1 To fwidth
   			tempx=cursorx+(b-1)*screenstepx
			tempy=cursory+(c-1)*screenstepy
   			temp2x=tempx+box_x		
			temp2y=tempy+box_y
   			If (plot(a,b,c)=0) Then
   				Line (tempx,tempy)-(temp2x,temp2y),0,BF
   			Else
   				Line (tempx,tempy)-(temp2x,temp2y),1,BF
   				Pixel(52+b,292+c)=1
   			EndIf
   		Next b
	next c
   	GoSub update_char_number
   	Return

UpdateFontDetails:
	Print @(100,15) "     " @(20,15)"Width ";fwidth
   	Print @(50,30) "     " @(20,30)"Height ";fheight
   	Print @(130,45) "      " @(20,45)"Characters in Set ";fnumber
   	Print @(80,60) "    "@(20,60)"Start Character ";fstart
   	Return

Instructions: 
   	Print @(10,110)"Move  --- Cursor keys"
   	Print @(10,125)"Set     ___ Left Alt."
   	Print @(10,140)"Erase       --- Space"
   	Print @(10,155)"Load       --- l or L"
   	Print @(10,170)"Save       --- s or S"
   	Print @(10,185)"Char Up    ___ +"
   	Print @(10,200)"Char Down  --- -"
   	Print @(10,215)"Add Char   ___ Insert"
   	Print @(10,230)"Copy Char  ___ c or C"
   	Print @(10,245)"Flip Vert. ___ v or V"
   	Print @(10,260)"Flip Horiz.___ h or H"
   	Print @(10,275)"Exit       ___ e or E"
   	Line (4,290)- (6*min_x-2,max_y-6),1,B
   	Print @(10,300)"Pixel" @(10,320)"Size"
   	Line (50,291)-(6*min_x-4,max_y-70),0,BF
   	Line (50,290)-(50+fwidth+4,290+fheight+4),1,B
   	Print @(30,Max_y-65)"Code Written by"
   	Print @(15,Max_y-45)"Dennis Wyatt ";
	Font Load "copyr.fnt" As #6 
	Font #6
   	Print " ";
	Font #1 
	Font unload #6
	Print " 2011"
   	Print @(15,Max_y-25)"dpwyatt@iinet.net.au"
   	Return

My_pause: 		'pause routine for array erasure completion
   	Timer=0
   	Do While timertemp<3000
   	timertemp=Timer
   	Loop
   	Return
No_sd_card: 
	Print @(270,40)"ERROR -No SD Card present"
   	Print @(270,55)"Please insert card and re-enter"
   	Print @(270,70)"Filename at the prompt above"
   	Pause 2000
   	If (typefile$="save") Then
   		GoTo Save_font
   	Else
   		GoTo Load_font
   	EndIf

Card_protected: 
	Print @(270,40)"Card is Write Protected"
   	Print @(270,55)"Please write enable and re-enter"
   	Print @(270,70)"Filename at the prompt above"
   	If (typefile$="save") Then
   	GoTo Save_font
   		Else
   	GoTo Load_font
   	EndIf
no_space_left: 
	Print @(270,40)"not enough space"
   	Print @(270,55)"Please rectify and re-enter"
   	Print @(270,70)"Filename at the prompt above"
   	If (typefile$="save") Then
   		GoTo Save_font
   	Else
   		GoTo Load_font
   	EndIf

All_root_gone: 
	Print @(270,40)"All root dir. taken"
   	If (typefile$="save") Then
   		GoTo Save_font
   	Else
   		GoTo Load_font
   	EndIf

Invalid_filename:
	Print @(270,40)"Invalid Filename"
   	Print @(270,55)"Please rectify and re-enter"
   	Print @(270,70)"Filename at the prompt above"
   	If (typefile$="save") Then
   		GoTo Save_font
   	Else
   		GoTo Load_font
   	EndIf
Cannot_find_file: 
	Print @(270,40)"Cannot find File"
   	Print @(270,55)"Please re-enter"
   	Print @(270,70)"Filename at the prompt above"
   	If (typefile$="save") Then
   		GoTo Save_font
   	Else
   		GoTo Load_font
   	EndIf

Insert_char: 		' insert character function
   	addchar=0
   	savename$="temp.fnt"
   	GoSub Insert_save_font
   	fname$="temp.fnt"
   	GoSub Insert_Load_Font
   	addchar=1
   	Kill "temp.fnt"
   	Return

Insert_Char_now: 
	temp$=""
   	For column=1 To fwidth
   		temp$=temp$+" "
   	Next column
   	For row = 1 To fheight
   		Print #1,temp$
   	Next row
   	Return

Clear_box: 
	Line (270,20)-(19*min_x,80),0,bf
   	Return

Copy_char: 		' Copy function
   	GoSub Clear_box

Copy_input1_error: 
	Print @(270,20);
   	Input "Copy which Character # ";copychar
   		If copychar>fnumber Then
   		Print @(270,35)"Not that many Char."
		GoTo Copy_input1_error
   	EndIf

Copy_input2_error: 
	Print @(270,35);
   	Input "To which Character # ";tochar
   	If tochar>fnumber Then
   		Print @(270,50) "Not that many Char."
		GoTo Copy_input2_error
   	EndIf
   	For copy1= 1 To fwidth
   		For copy2= 1 To fheight
   			plot(tochar,copy1,copy2)=plot(copychar,copy1,copy2)
   		Next copy2
	Next copy1
   	Print @(270,50)"                          "
   	Print @(270,50)"done"
  	Return

Vertical_flip: 		' flip vertical function
   	For flipV = 1 To Int(fheight/2)
   		For flipV1 = 1 To fwidth
   			flipvtemp=plot(charxy,flipV1,flipV)
   			plot(charxy,flipV1,flipV)=plot(charxy,flipV1,fheight-flipV+1)
   			plot(charxy,flipV1,fheight-flipV+1)=flipvtemp
   		Next flipV1
	Next flipV
   	GoSub Clear_box
   	Print @(270,20)"Vertical Flip Done"
   	GoSub Displayfontchar
   	Return

horizontal_flip: 			' flip horizontal function
   	For flipH = 1 To Int(fwidth/2)
   		For flipH1 = 1 To fheight
   			fliphtemp=plot(charxy,flipH,flipH1)
   			plot(charxy,flipH,flipH1)=plot(charxy,fwidth-flipH+1,flipH1)
   			plot(charxy,fwidth-flipH+1,flipH1)=fliphtemp
   		Next fliph1
   	Next flipH
   	GoSub Clear_box
   	Print @(270,20)"Horizontal Flip Done"
   	GoSub Displayfontchar
   	Return                                                                                 