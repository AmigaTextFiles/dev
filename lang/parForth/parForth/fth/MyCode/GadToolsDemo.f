include? API.f      parForthExtensions/API.f
include? GadTools.f parForthExtensions/GadTools.f

ANEW GadToolsDemo.f

\ vectored execution of ECHO *******************************************************
\ menu and gadgets should output text to the shell when GadTools.f is included and MAIN is executed
\ if turnkeyed the application may be run and detached from a shell so output to T:GadToolsOutput instead
DEFER ECHO
: $+.          ( n c1$ -- c2$ )  STRING >R R@ $! STR     R@ +PLACE R> ;	\ append STR(n) to c1$
: $+0$         ( 0$ c1$ -- c2$ ) STRING >R R@ $! 0$COUNT R@ +PLACE R> ;	\ append 0$ to c1$  
: 'EchoToShell ( c$ -- ) $. CR ;
: EchoToShell  ( -- ) ['] 'EchoToShell IS ECHO ;
: 'EchoToT     ( c$ -- ) C" ECHO >>T:GadToolsOutput " STRING >R R@ $! R@ $+! R@ $>0$ R> (DOS) ;
: EchoToT      ( -- ) ['] 'EchoToT IS ECHO ;

\ GadgetTools Windows **************************************************************
EchoToShell
" GadTools Gadgets" WINDOW MyWindow
" Companion Window" WINDOW Companion

: CloseBoth ( -- ) ." CloseWindows" CR MyWindow wClose Companion wClose Listening OFF ;

MyWindow Events
IDCMP_CloseWindow DOES CloseBoth
Events.End

Menus
menu" Menu1"
	CommKey A
	item" Item1"	DO: " M1I1" ECHO ;DO
	CommKey B
	item" Item2" 	DO: " M1I2" ECHO ;DO
menu" Menu2"
	CommKey C
	item" Item1" 	DO: " M2I1" ECHO ;DO
	CommKey D
	item" Item2" 	DO: " M2I2" ECHO ;DO
	Bar
	item" Item3" 	DO: " M2I3" ECHO ;DO
menu" Menu3"
	item" Item1"
		CommKey E
		sub" Sub1" 	DO: " M3I1S1" ECHO ;DO
		CommKey F
		sub" Sub2" 	DO: " M3I1S2" ECHO ;DO
		Bar
		sub" Sub3" 	DO: " M3I1S3" ECHO ;DO
	item" Item2" 	DO: " M3I2" ECHO ;DO
	Bar
	item" Item3" 	DO: " M3I3" ECHO ;DO
Menus.End

Arial15
Gadgets
	\ column 1
	10	0	100	25	" Buttons"					LABEL		LB1
	10	25	100	25 	" VIC ^20"					BUTTON		bt20		DO: " bt20 clicked"  ECHO ;DO
	10	50	100	25 	" Commodore ^64"			BUTTON		bt64		DO: " bt64 clicked"  ECHO ;DO
	10	75	100	25 	" Amiga ^500"				BUTTON		bt500		DO: " bt500 clicked" ECHO ;DO
	10	100	100	25 	" AmigaOne ^XE"				BUTTON		btXE		DO: " btXE clicked"  ECHO ;DO
	10	125	100	25 	" ^AROS i386"				BUTTON		bt386		DO: " bt386 clicked" ECHO ;DO
	10	180	100	25	" Integer" 0				INTEGER		IN1			DO: IN1	  Choice gGet " IN1 is " $+. ECHO ;DO

	\ column 2
	125	0	100	25	" Checkboxes"				LABEL		LB2
	125	25	25	25 	" VIC 20" 					CHECKBOX 	cb20  ON	DO: cb20  Choice gGet " cb20 is "  $+. ECHO ;DO
	125	50	25	25 	" Commodore 64" 			CHECKBOX 	cb64  OFF	DO: cb64  Choice gGet " cb64 is "  $+. ECHO ;DO
	125	75	25	25 	" Amiga 500" 				CHECKBOX 	cb500 OFF	DO: cb500 Choice gGet " cb500 is " $+. ECHO ;DO
	125	100	25	25 	" AmigaOne XE" 				CHECKBOX 	cbXE  OFF	DO: cbXE  Choice gGet " cbXE is "  $+. ECHO ;DO
	125	125	25	25 	" AROS i386" 				CHECKBOX 	cb386 OFF	DO: cb386 Choice gGet " cb386 is " $+. ECHO ;DO
	125	180	100 25	" String" Default" Hello"	ASTRING		ST1			DO: ST1   Choice gGet " ST1 is "  $+0$ ECHO ;DO

	\ column 3
	260	20	125	25 	" Cycle"					CYCLE		CY1			DO: CY1   Choice gGet " CY1 is " $+. ECHO ;DO
Choices Choice" VIC 20" Choice" Commodore 64" Choice" Amiga 500" Choice" AmigaOne XE" Choice" AROS i386" Choices.End
	260	70	125	60 	" ListView"					LISTVIEW	LV1			DO: LV1   Choice gGet " LV1 is " $+. ECHO ;DO
Choices Choice" VIC 20" Choice" Commodore 64" Choice" Amiga 500" Choice" AmigaOne XE" Choice" AROS i386" Choices.End
	270	155	125	15 	" MX (Radio)"    			MX			MX1			DO: MX1	  Choice gGet " MX1 is " $+. ECHO ;DO
Choices Choice" VIC 20" Choice" Commodore 64" Choice" Amiga 500" Choice" AmigaOne XE" Choice" AROS i386" Choices.End

	\ column 4
	410	20	100 25	" Number" 41361				NUMBER		NM1
	Vertical OFF
	410	70	100	25	" Slider" 0 15 0			SLIDER		SL1			DO: SL1	  Choice gGet " SL1 is " $+. ECHO ;DO
	410	120	100	100	" Palette" 4 0				PALETTE 	PA1			DO: PA1   Choice gGet " PA1 is " $+. ECHO ;DO
Gadgets.End

\ synch the choices of the cycle, mx, and listview gadgets
: .Chosen   ( u -- ) " Chosen value: " $+. ECHO ;
: Synch ( u -- ) DUP .Chosen DUP CY1 Choice gSet DUP LV1 Choice gSet DUP LV1 GTLV_MAKEVISIBLE gSet MX1 Choice gSet ;

\ change actions of these gadgets
GADGET CY1 DO: CY1 Choice gGet Synch ;DO
GADGET MX1 DO: MX1 Choice gGet Synch ;DO
GADGET LV1 DO: LV1 Choice gGet Synch ;DO

Companion Events
IDCMP_CloseWindow DOES CloseBoth
Events.End

ScreenFont
Menus
menu" Menu1"
	CommKey A
	item" Item1"	DO: " M1I1" ECHO ;DO
	CommKey B
	item" Item2" 	DO: " M1I2" ECHO ;DO
Menus.End

Arial15
Gadgets
	0	0	100	25 	" VIC ^20"					BUTTON		bt200		DO: " bt200 clicked" ECHO ;DO
Gadgets.End
ScreenFont

: main ( -- )
	MyWindow  Bordered #CENTER #CENTER 560 270 wOpen
	Companion Bordered #RIGHT  #BOTTOM 25 %scSize wOpen LISTEN ;

Main
