Window1IDCMP1:	move.l	Window1(pc),a0
		jsr	CheckIDCMP
		jmp	WindowIDCMP
Window2IDCMP1:	move.l	Window2(pc),a0
		jsr	CheckIDCMP
		jmp	WindowIDCMP
Window3IDCMP1:	move.l	Window3(pc),a0
		jsr	CheckIDCMP
		jmp	WindowIDCMP
Window4IDCMP1:	move.l	Window4(pc),a0
		jsr	CheckIDCMP
		jmp	WindowIDCMP

WindowIDCMP:	cmp.l	#CLOSEWINDOW,d2
		beq	Quit
		cmp.l	#GADGETDOWN,d2
		beq	ButtonDown
		cmp.l	#GADGETUP,d2
		beq	Activategads
		cmp.l	#VANILLAKEY,d2
		beq	VanillaKeys
		cmp.l	#MENUPICK,d2
		beq	Win1Menus
		cmp.l	#RAWKEY,d2
		beq	RawKeys
		jmp	Window1IDCMP

Activategads:	move.l	#$01,CheckSum
		move.l	(a5),a0
		lea.l	FontSizeGad(pc),a1	;take this out when you've
		cmp.l	#$00,(a5)		;got different sized fonts
		beq	ActivateGads1
		cmp.l	(a5),a1
		bne	ActivateGads2
		move.l	(a1),a0
		jmp	ActivateGads2
ActivateGads1:	lea.l	SerBRKTGad(pc),a0
ActivateGads2:	move.l	Window1(pc),a1
		move.l	#$00,a2
		lib	Intuition,ActivateGadget
		jmp	Window1IDCMP	

VanillaKeys:	cmp.w	#$1b,d3
		beq	Quit
		jmp	Window1IDCMP
RawKeys:	cmp.w	#$5f,d3
		beq	Quit		;Change to help
		jmp	Window1IDCMP

Win1Menus:	jsr	MenuNull
		cmp.l	#$00,d6
		beq	Win1Menus9
		cmp.l	#$01,d6
		beq	Win1Menus1
		jmp	Window1IDCMP
Win1Menus1:	cmp.l	#$00,d5
		beq	AskedWin1
		cmp.l	#$01,d5
		beq	AskedWin2
		cmp.l	#$02,d5
		beq	AskedWin3
		cmp.l	#$03,d5
		beq	AskedWin4
		jmp	Window1IDCMP	
Win1Menus9:	cmp.l	#$00,d5
		beq	Load
		cmp.l	#$01,d5
		beq	Save
		cmp.l	#$02,d5
		beq	SaveAs
		cmp.l	#$03,d5
		beq	About
		cmp.l	#$04,d5
		beq	Quit
		jmp	Window1IDCMP

AskedWin1:	cmp.w	#$01,ActiveWinNum
		beq	Window1IDCMP
		jmp	StartWin1
AskedWin2:	cmp.w	#$02,ActiveWinNum
		beq	Window1IDCMP
		jmp	StartWin2
AskedWin3:	cmp.w	#$03,ActiveWinNum
		beq	Window1IDCMP
		jmp	StartWin3
AskedWin4:	cmp.w	#$04,ActiveWinNum
		beq	Window1IDCMP
		jmp	StartWin4

ButtonDown:	move.l	#$01,CheckSum

;Activate first string gadget again

		lea.l	SerBRKTGad(pc),a0
		move.l	Window1(pc),a1
		move.l	#$00,a2
		lib	Intuition,ActivateGadget

		lea.l	StopB1Gad(pc),a1
		cmp.l	a1,a5
		beq	ButtonDown1
		lea.l	StopB2Gad(pc),a1
		cmp.l	a1,a5
		beq	ButtonDown2
		lea.l	DataB7Gad(pc),a1
		cmp.l	a1,a5
		beq	ButtonDown3
		lea.l	DataB8Gad(pc),a1
		cmp.l	a1,a5
		beq	ButtonDown4
		lea.l	ParityNGad(pc),a1
		cmp.l	a1,a5
		beq	ButtonDown5
		lea.l	ParityEGad(pc),a1
		cmp.l	a1,a5
		beq	ButtonDown6
		lea.l	ParityOGad(pc),a1
		cmp.l	a1,a5
		beq	ButtonDown7
		lea.l	ParityMGad(pc),a1
		cmp.l	a1,a5
		beq	ButtonDown8
		lea.l	ParitySGad(pc),a1
		cmp.l	a1,a5
		beq	ButtonDown9
		lea.l	DuplexFGad(pc),a1
		cmp.l	a1,a5
		beq	ButtonDown10
		lea.l	DuplexHGad(pc),a1
		cmp.l	a1,a5
		beq	ButtonDown11
		lea.l	DuplexEGad(pc),a1
		cmp.l	a1,a5
		beq	ButtonDown12
		jmp	Window1IDCMP
ButtonDown1:	move.w	#$86,$c(a1)
		lea.l	StopB2Gad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	StopB1Gad(pc),a0
		move.l	Window1(pc),a1
		move.l	#$02,d0
		lib	Intuition,RefreshGList
		jmp	Window1IDCMP
ButtonDown2:	move.w	#$86,$c(a1)
		lea.l	StopB1Gad(pc),a0
		move.w	#$6,$c(a0)
		move.l	Window1(pc),a1
		move.l	#$02,d0
		lib	Intuition,RefreshGList
		jmp	Window1IDCMP
ButtonDown3:	move.w	#$86,$c(a1)
		lea.l	DataB8Gad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	DataB7Gad(pc),a0
		move.l	Window1(pc),a1
		move.l	#$02,d0
		lib	Intuition,RefreshGList
		jmp	Window1IDCMP
ButtonDown4:	move.w	#$86,$c(a1)
		lea.l	DataB7Gad(pc),a0
		move.w	#$6,$c(a0)
		move.l	Window1(pc),a1
		move.l	#$02,d0
		lib	Intuition,RefreshGList
		jmp	Window1IDCMP
ButtonDown5:	move.w	#$86,$c(a1)
		lea.l	ParityEGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParityOGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParityMGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParitySGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParityNGad(pc),a0
		move.l	Window1(pc),a1
		move.l	#$05,d0
		lib	Intuition,RefreshGList
		jmp	Window1IDCMP
ButtonDown6:	move.w	#$86,$c(a1)
		lea.l	ParityNGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParityOGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParityMGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParitySGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParityNGad(pc),a0
		move.l	Window1(pc),a1
		move.l	#$05,d0
		lib	Intuition,RefreshGList
		jmp	Window1IDCMP
ButtonDown7:	move.w	#$86,$c(a1)
		lea.l	ParityNGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParityEGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParityMGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParitySGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParityNGad(pc),a0
		move.l	Window1(pc),a1
		move.l	#$05,d0
		lib	Intuition,RefreshGList
		jmp	Window1IDCMP
ButtonDown8:	move.w	#$86,$c(a1)
		lea.l	ParityNGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParityEGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParityOGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParitySGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParityNGad(pc),a0
		move.l	Window1(pc),a1
		move.l	#$05,d0
		lib	Intuition,RefreshGList
		jmp	Window1IDCMP
ButtonDown9:	move.w	#$86,$c(a1)
		lea.l	ParityNGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParityEGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParityOGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParityMGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	ParityNGad(pc),a0
		move.l	Window1(pc),a1
		move.l	#$05,d0
		lib	Intuition,RefreshGList
		jmp	Window1IDCMP
ButtonDown10:	move.w	#$86,$c(a1)
		lea.l	DuplexHGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	DuplexEGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	DuplexFGad(pc),a0
		move.l	Window1(pc),a1
		move.l	#$03,d0
		lib	Intuition,RefreshGList
		jmp	Window1IDCMP
ButtonDown11:	move.w	#$86,$c(a1)
		lea.l	DuplexFGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	DuplexEGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	DuplexFGad(pc),a0
		move.l	Window1(pc),a1
		move.l	#$03,d0
		lib	Intuition,RefreshGList
		jmp	Window1IDCMP
ButtonDown12:	move.w	#$86,$c(a1)
		lea.l	DuplexFGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	DuplexHGad(pc),a0
		move.w	#$6,$c(a0)
		lea.l	DuplexFGad(pc),a0
		move.l	Window1(pc),a1
		move.l	#$03,d0
		lib	Intuition,RefreshGList
		jmp	Window1IDCMP

Load:		jsr	MenusOff
		lea.l	LoadName(pc),a5
		move.l	#FRQABSOLUTEXYM+FRQLOADINGM,d5
		jsr	FileRequester
		tst.l	d0
		beq	LoadOut

		lea.l	FRPathName(pc),a1
		move.l	a1,d1
		cmp.b	#$00,(a1)
		beq	LoadOut
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,ConfigFile
		bne	Load1
		jsr	FileError
		jmp	LoadOut

Load1:		move.l	ConfigFile(pc),d1
		lea.l	CONFIG(pc),a0
		move.l	a0,d2
		lea.l	CONFIG(pc),a1
		lea.l	CONFIG_END(pc),a2
		sub.l	a1,a2
		move.l	a2,d3
		lib	Dos,Read

Load2:		move.l	ConfigFile(pc),d1
		lib	Dos,Close
		move.l	#$00,ConfigFile
		move.l	#$01,CheckSum
		jsr	SetGads
		lea.l	StopB1Gad(pc),a0
		move.l	Window1(pc),a1
		move.l	#-1,d0
		lib	Intuition,RefreshGList

LoadOut:
		jsr	MenusOn
		jmp	Window1IDCMP

SaveAs:		jsr	MenusOff
		lea.l	SaveName(pc),a5
		move.l	#FRQABSOLUTEXYM+FRQSAVINGM,d5
		jsr	FileRequester
		tst.l	d0
		beq	SaveOut

		lea.l	FRPathName(pc),a1
		move.l	a1,d1
		cmp.b	#$00,(a1)
		beq	SaveOut
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,ConfigFile
		beq	ConfigNExists		;ConfigNotExists..

;The file already exists so we'll ask if the user wants to replace old file 

		lea.l	AskReplace(pc),a0
		move.l	#$00,a1
		jsr	TwoGadRequest
		tst.l	d0
		beq	SaveOut

		move.l	ConfigFile(pc),d1
		lib	Dos,Close
		move.l	#$00,ConfigFile

SaveAsOut:	jsr	MenusOn

Save:		jsr	MenusOff
;		jsr	SetSer

Save1:		tst.l	ConfigFile
		bne	Save2
		lea.l	FRPathName(pc),a1
		move.l	a1,d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		move.l	d0,ConfigFile
		bne	Save2
		jsr	FileError
		jmp	SaveOut
Save2:		move.l	ConfigFile(pc),d1
		lea.l	CONFIG(pc),a0
		move.l	a0,d2
		move.l	a0,a1
;		lea.l	CONFIG(pc),a1
		lea.l	CONFIG_END(pc),a2
		sub.l	a1,a2
		move.l	a2,d3
		lib	Dos,Write
		cmp.l	#-1,d0
		bne	Save3
		jsr	FileError

;Close the file

Save3:		move.l	ConfigFile(pc),d1
		lib	Dos,Close
		move.l	#$00,ConfigFile
		move.l	#$00,CheckSum
	
SaveOut:	jsr	MenusOn
		jmp	Window1IDCMP

FileRequester:	move.l	a5,FRTitle
		move.l	d5,FRFlags
		lea.l	FileRequest1(pc),a0
		lib	Req,FileRequester
FROut:		rts

Quit:		cmp.l	#$01,CheckSum
		bne	ShutDown
		jsr	MenusOff
		lea.l	NewQuitWin1(pc),a0
		lib	Intuition,OpenWindow
		tst.l	d0
		bne	Quit1
		print	<"Couldn't open Quitting-window",13,10>,_stdout
		jmp	ShutDown
Quit1:		move.l	d0,QuitWin1
		move.l	QuitWin1,a1
		move.l	$32(a1),a0
		lea.l	QuitWin1Txt1,a1
		move.w	#$10,d0
		move.w	#$10,d1
		lib	Intuition,PrintIText
		move.l	Screen1,a0
		lib	Intuition,DisplayBeep

QuitIDCMP:	move.l	QuitWin1(pc),a0
		jsr	CheckIDCMP
		cmp.l	#GADGETUP,d2
		beq	QuitIDCMP1
		cmp.l	#VANILLAKEY,d2
		bne	QuitIDCMP
		cmp.w	#$1b,d3
		beq	QuitIDCMP2
		cmp.w	#"y",d3
		beq	QuitIDCMP3
		cmp.w	#"Y",d3
		beq	QuitIDCMP3
		cmp.w	#"n",d3
		beq	QuitIDCMP2
		cmp.w	#"N",d3
		beq	QuitIDCMP2
		jmp	QuitIDCMP

QuitIDCMP1:	cmp.w	#$2,$26(a5)
		beq	QuitIDCMP3
		cmp.w	#$3,$26(a5)
		bne	QuitIDCMP
QuitIDCMP2:	move.l	Window1(pc),a0
		lea.l	Menu1(pc),a1
		jsr	MenusOn
		move.l	QuitWin1(pc),a0
		jsr	ClearMSGs
		move.l	#0,QuitWin1
		jmp	Window1IDCMP
QuitIDCMP3:	jsr	MenusOn
		move.l	QuitWin1(pc),a0
		jsr	ClearMSGs
		move.l	#0,QuitWin1
		jmp	ShutDown

About:		jsr	MenusOff
		lea.l	NewAbWindow1(pc),a0
		lib	Intuition,OpenWindow
		tst.l	d0
		bne	About1
		print	<"Couldn't open About-window!",13,10>,_stdout
		jmp	ShutDown
About1:		move.l	d0,AbWin

		move.l	d0,a0
		move.l	$32(a0),AbRP

		move.l	AbRP(pc),a1		;Color the background
		move.l	#$02,d0
		lib	Gfx,SetRast

		move.l	AbWin(pc),a1		;Draw the Gads again
		lea.l	YNGad1(pc),a0
		move.l	#$00,a2
		move.l	#-1,d0
		lib	Intuition,RefreshGList

		move.l	AbRP(pc),a0		;Border
		lea.l	AbBorder1(pc),a1
		move.l	#$00,d0
		move.l	#$00,d1
		lib	Intuition,DrawBorder

		move.l	AbRP(pc),a0		;Texts
		lea.l	AboutTxt1(pc),a1
		move.l	#$00,d0
		move.l	d0,d1
		lib	Intuition,PrintIText

About2:		move.l	AbWin(pc),a0
		jsr	CheckIDCMP
		cmp.l	#GADGETUP,d2
		beq	AboutOut
		cmp.l	#VANILLAKEY,d2
		beq	AboutKeys
		jmp	About2

AboutKeys:	cmp.w	#$1b,d3
		beq	AboutOut
		cmp.w	#"y",d3
		beq	AboutOut
		cmp.w	#"Y",d3
		beq	AboutOut
		cmp.w	#"n",d3
		beq	AboutOut
		cmp.w	#"N",d3
		beq	AboutOut
		jmp	About2

AboutOut:	move.l	AbWin(pc),a0
		jsr	ClearMSGs
		move.l	#$0,AbWin
		jsr	MenusOn
		jmp	Window1IDCMP
