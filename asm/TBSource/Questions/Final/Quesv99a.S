*************************************************
*						*
*		 (C)opyright 1991		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version 0.01a	25/07/1991			*
*	- 0.99a 05/08/1991			*
*						*
* BUGS:	Unknown	(Not finished)			*
*						*
* Version 0.99a	05/08/1991			*
*						*
* BUGS:	Unknown					*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"libraries/reqbase.i"
	INCLUDE	"graphics/gfx.i"
	INCLUDE	"graphics/gels.i"
	INCLUDE	"intuition.i"
;	INCLUDE "iff.i"

	INCLUDE	"dos.xref"
	INCLUDE	"gfx.xref"
	INCLUDE	"intuition.xref"
	INCLUDE	"exec.xref"
;	INCLUDE "iff.xref"

DesTop:		EQU	14	;Desciption Y-Top
QueTop:		EQU	67	;Question Y-Top
MulTop:		EQU	89	;Multiselect Y-Top
AnsTop:		EQU	190	;Answer Y-Top
NameTop:	EQU	95	;Name Y-Top
NumQTop:	EQU	45	;Number(of)Questions Y-Top
ScoTop:		EQU	55	;Score Y-Top
OptionTop:	EQU	40	;Option(Teacher BOOL gad) Y-Top

		section	Q,CODE

		openlib	Dos,ShutDown
		lib	Dos,Output
		move.l	d0,_stdout
		beq	ShutDown
	
		openlib	Intuition,ShutDown
		openlib	Gfx,ShutDown
;		openlib Iff,ShutDown
		openlib	Req,ShutDown
	
;Find our task

		move.l	#$00,a1
		lib	Exec,FindTask
		move.l	d0,OurTask
		move.l	d0,a0
		move.l	$b8(a0),OldTaskWinPtr

;Open Screen
		lea.l	NewScreen1(pc),a0
		lib	Intuition,OpenScreen
		move.l	d0,Screen1
		beq	NoScreen1
		move.l	d0,SToW1
		move.l	d0,SToW2
		move.l	d0,SToW3
		move.l	d0,SToW4
		add.l	#$2c,d0
		move.l	d0,ViewPort1

;Open Window1

StartWin1:	lea.l	NewWindow1(pc),a0
		lib	Intuition,OpenWindow
		move.l	d0,Window1
		beq	NoWindow1
		move.l	d0,a0
		move.l	$32(a0),RP1

;move requesters to Window1

		move.l	OurTask,a0
		move.l	Window1(pc),$b8(a0)

;Reserve memory for description
;
;We're going to add 12 bytes to the amount of memory to be reserved,
;just in case.

		move.l	#DesLeng+12,d0
		move.l	#MEMF_CLEAR!MEMF_PUBLIC,d1	;Type of memory wanted
		lib	Exec,AllocMem			;Allocate memory
		move.l	d0,DesMem1
		bne	AddMens1
		jsr	NoMem1				;Tell user about memory
		jmp	ShutDown

;Add Menus to Window1

AddMens1:	move.l	Window1(pc),a0
		lea.l	Menu1(pc),a1
		lib	Intuition,SetMenuStrip

Window1IDCMP:	move.l	Window1(pc),a0
		jsr	CheckIDCMP
		cmp.l	#VANILLAKEY,d2
		beq	VanillaKeys
		cmp.l	#GADGETUP,d2
		beq	GotAnswer
;		cmp.l	#GADGETDOWN,d2
;		beq	TeacherAction
		cmp.l	#MENUPICK,d2
		beq	Win1Menus
		cmp.l	#RAWKEY,d2
		beq	RawKeys
		jmp	Window1IDCMP

GetName:	jsr	MenusOff
		move.l	RP1(pc),a1
		clr.l	d0
		clr.l	d1
		lib	Gfx,Move

		move.l	RP1(pc),a1
		lib	Gfx,ClearScreen

		move.l	Window1(pc),a0
		lea.l	NameGad1(pc),a1
		move.l	#-1,d0
		lib	Intuition,AddGadget

		lea.l	NameGad1(pc),a0
		move.l	Window1(pc),a1
		move.l	#$00,a2
		move.l	#$01,d0
		lib	Intuition,RefreshGList

GetName1:	lea.l	NameGad1(pc),a0
		move.l	Window1(pc),a1
		move.l	#$00,a2
		lib	Intuition,ActivateGadget

GetName2:	move.l	Window1(pc),a0
		jsr	CheckIDCMP
		cmp.l	#GADGETUP,d2
		beq	GetName3
		jmp	GetName1

GetName3:	tst.b	(NameGad1Buf)
		beq	GetName1

GetName_OUT:	move.l	Window1(pc),a0
		lea.l	NameGad1(pc),a1
		lib	Intuition,RemoveGadget

		move.l	RP1(pc),a1
		clr.l	d0
		clr.l	d1
		lib	Gfx,Move

		move.l	RP1(pc),a1
		lib	Gfx,ClearScreen

		move.l	Window1(pc),a0
		move.l	#$00,a1
		lea.l	MenuBarName(pc),a2
		lib	Intuition,SetWindowTitles
		jsr	MenusOn
		rts

VanillaKeys:	cmp.w	#$1b,d3
		beq	Quit
		jmp	Window1IDCMP
RawKeys:	cmp.w	#$5f,d3
		beq	About
		jmp	Window1IDCMP

Win1Menus:	jsr	MenuNull
		cmp.l	#$00,d6
		beq	Win1Menus1
		cmp.l	#$01,d6
		beq	Win1Menus2
		jmp	Window1IDCMP
Win1Menus1:	cmp.l	#$00,d5
		beq	Game
		cmp.l	#$01,d5
		beq	GoToGetName
		cmp.l	#$02,d5
		beq	Load
		cmp.l	#$03,d5
		beq	Save
		cmp.l	#$04,d5
		beq	SaveAs
		cmp.l	#$05,d5
		beq	About
		cmp.l	#$06,d5
		beq	Quit
		jmp	Window1IDCMP
Win1Menus2:	cmp.l	#$00,d5
		beq	Student
		cmp.l	#$01,d5
		beq	Teacher
		jmp	Window1IDCMP

GoToGetName:	jsr	GetName
		jmp	Window1IDCMP

Student:	cmp.w	#$02,Mode
		bne	Window1IDCMP
		jsr	SaveQuestion
		move.w	#$00,Mode
		move.l	#$f800,d0		;First, Game!
		move.l	Window1(pc),a0
		lib	Intuition,OnMenu
		move.l	#$f820,d0		;Second, Enter name
		move.l	Window1(pc),a0
		lib	Intuition,OnMenu
		move.l	#$f860,d0		;Fourth, Save
		move.l	Window1(pc),a0
		lib	Intuition,OffMenu
		move.l	#$f880,d0		;Fifth, Save As
		move.l	Window1(pc),a0
		lib	Intuition,OffMenu

		move.l	Window1(pc),a0
		lea.l	FirstGad1(pc),a1
		move.l	#-1,d0
		move.l	#$00,a2
		lib	Intuition,RemoveGList

		jsr	EmptyPage
		jmp	Window1IDCMP

Teacher:	cmp.w	#$00,Mode
		bne	Window1IDCMP
		move.w	#$02,Mode
		move.w	#$00,QueCount
		move.l	#$f800,d0		;First, Game!
		move.l	Window1(pc),a0
		lib	Intuition,OffMenu
		move.l	#$f820,d0		;Second, Enter name
		move.l	Window1(pc),a0
		lib	Intuition,OffMenu
		move.l	#$f860,d0		;Fourth, Save
		move.l	Window1(pc),a0
		lib	Intuition,OnMenu
		move.l	#$f880,d0		;Fifth, Save As
		move.l	Window1(pc),a0
		lib	Intuition,OnMenu

		jsr	DoPage

		move.l	Window1(pc),a0
		lea.l	FirstGad1(pc),a1
		move.l	#-1,d0
		move.l	#-1,d1
		move.l	#$00,a2
		lib	Intuition,AddGList

;Refresh gadget so its drawn on the screen

		lea.l	FirstGad1(pc),a0
		move.l	Window1(pc),a1
		move.l	#$00,a2
		move.l	#-1,d0
		lib	Intuition,RefreshGList

		jsr	FindFirst
		jsr	PrintNumQ
		jsr	PrintTeach
		jmp	Window1IDCMP

TeacherAction:	cmp.w	#40,$26(a5)
		beq	GoAddQues
		cmp.w	#60,$26(a5)
		beq	GoClear
		cmp.w	#00,NumQ
		beq	Window1IDCMP
		cmp.w	#10,$26(a5)
		beq	GoFindFirst
		cmp.w	#20,$26(a5)
		beq	GoFindPrev
		cmp.w	#30,$26(a5)
		beq	GoFindNext
		cmp.w	#50,$26(a5)
		beq	GoUndo
		jmp	Window1IDCMP

GoFindFirst:	jsr	SaveQuestion
		jsr	FindFirst
		jsr	PrintTeach
		lea.l	DesStrGad2(pc),a5
		jmp	ActivateGads
GoFindPrev:	jsr	SaveQuestion
		cmp.w	#$00,QueCount
		beq	Window1IDCMP
		jsr	FindPrev
		jsr	PrintTeach
		lea.l	DesStrGad2(pc),a5
		jmp	ActivateGads
GoFindNext:	jsr	SaveQuestion
		move.w	NumQ(pc),d0
		sub.w	#1,d0
		cmp.w	QueCount(pc),d0
		beq	Window1IDCMP
		jsr	FindNext
		jsr	PrintTeach
		lea.l	DesStrGad2(pc),a5
		jmp	ActivateGads
GoAddQues:	jsr	SaveQuestion
		jsr	AddQues
		jsr	PrintNumQ
		jsr	PrintTeach
		lea.l	DesStrGad2(pc),a5
		jmp	ActivateGads
GoUndo:		jsr	FindFirst
		jsr	PrintTeach
		lea.l	DesStrGad2(pc),a5
		jmp	ActivateGads
GoClear:	jsr	Clear
		jsr	AddQues
		jsr	PrintNumQ
		jsr	PrintTeach
		lea.l	AStrGad1(pc),a5
		jmp	ActivateGads

PrintTeach:	cmp.w	#$00,NumQ
		beq	PrintTeach_OUT
		move.l	Window1(pc),a0		;remove gadgets
		lea.l	DesStrGad1(pc),a1
		move.l	#-1,d0
		move.l	#$00,a2
		lib	Intuition,RemoveGList

;Copy description into correct buffers

		move.l	DesMem1(pc),a0
		lea.l	DesStr1Buf(pc),a1
		move.l	#DesLeng,d0
		lib	Exec,CopyMem

;Copy current questions and answers into gadget buffers

		move.l	CurrentQue(pc),a0
		lea.l	QueStr1Buf(pc),a1
		move.l	#NextQues,d0
		lib	Exec,CopyMem

		move.l	Window1(pc),a0		;Add gadgets
		lea.l	DesStrGad1(pc),a1
		move.l	#-1,d0
		move.l	#-1,d1
		move.l	#$00,a2
		lib	Intuition,AddGList

;Refresh gadget so they're drawn on the screen

		lea.l	DesStrGad1(pc),a0
		move.l	Window1(pc),a1
		move.l	#$00,a2
		move.l	#-1,d0
		lib	Intuition,RefreshGList

		jsr	PrintScore
PrintTeach_OUT:	rts

;Copy description into memory

SaveQuestion:	cmp.w	#$00,NumQ
		beq	SaveQ_OUT
		lea.l	DesStr1Buf(pc),a0
		move.l	DesMem1(pc),a1
		move.l	#DesLeng,d0
		lib	Exec,CopyMem

;Copy current questions and answers into memory

		lea.l	QueStr1Buf(pc),a0
		move.l	CurrentQue,a1
		move.l	#NextQues,d0
		lib	Exec,CopyMem
SaveQ_OUT:	rts

DoTeach:	jsr	FindFirst
		jsr	PrintTeach
		jsr	PrintNumQ
		jmp	Window1IDCMP

ActivateGads:	cmp.w	#1,$26(a5)
		bne	TeacherAction
		move.l	(a5),a0
		cmp.l	#$00,a0
		bne	ActivateGads1
		lea.l	DesStrGad1(pc),a0
ActivateGads1:	move.l	Window1(pc),a1
		move.l	#$00,a2
		lib	Intuition,ActivateGadget
		jmp	Window1IDCMP	

Clear:		lea.l	RememberKey(pc),a0
		move.l	#TRUE,d0
		lib	Intuition,FreeRemember
		move.w	#$00,NumQ
		move.b	#$00,DesStr1Buf
		move.b	#$00,DesStr2Buf

;Clear description

		tst.l	DesMem1
		beq	ClearDes_OUT
		move.l	DesMem1(pc),a1
		move.l	#DesLeng+12,d0
		lib	Exec,FreeMem
		move.l	#$00,DesMem1

		move.l	#DesLeng+12,d0
		move.l	#MEMF_CLEAR!MEMF_PUBLIC,d1	;Type of memory wanted
		lib	Exec,AllocMem			;Allocate memory
		move.l	d0,DesMem1
		bne	ClearDes_OUT
		jsr	NoMem1				;Tell user about memory
		jmp	ShutDown

ClearDes_OUT:	rts

AddQues:	lea.l	RememberKey(pc),a0
		move.l	#NextQues,d0
		move.l	#MEMF_CLEAR!MEMF_PUBLIC,d1
		lib	Intuition,AllocRemember
		tst.l	d0
		bne	AddQues1
		jsr	NoMem1
		jsr	FindFirst
		rts
AddQues1:	move.l	d0,CurrentQue
		add.w	#1,NumQ
		rts

FindFirst:	move.w	#0,QueCount
		jsr	Find
		move.l	a4,QueBegin
		rts
FindPrev:	sub.w	#1,QueCount
		jsr	Find
		rts
FindNext:	add.w	#1,QueCount
		jsr	Find
		rts

Find:		move.l	#$00,d4
		lea.l	RememberKey(pc),a4
		move.l	(a4),a4
Find2:		cmp.w	QueCount(pc),d4
		beq	Find3
		add.w	#1,d4
		move.l	(a4),a4
		jmp	Find2
Find3:		move.l	$8(a4),a4
		move.l	a4,CurrentQue
		jsr	PrintScore
		rts
		
GotAnswer:	cmp.w	#$00,Mode
		beq	Window1IDCMP
		cmp.w	#$02,Mode
		beq	ActivateGads
		lea.l	AStrGad1Buf(pc),a3
		move.l	CAnsBegin(pc),a5
		move.l	QueBegin(pc),a4

;
;a3 = Gadget buffer start
;a4 = Question begin
;a5 = Correct answer start
;

		move.w	#$00,AnsCount
		move.l	a3,a1
		move.l	a5,a2
TestAnswer:	tst.b	(a2)		;If correct answer = 0
		beq	TestAnswer2
		cmp.b	(a1)+,(a2)+	;Compare correct & user answer
		beq	TestAnswer

TestAnswer1:	cmp.w	#09,AnsCount	;See if done last correct answer
		beq	WrongAnswer	;If have, user hasn't given correct answer
		add.l	#AnsLeng,a5	;If not, get next correct answer
		move.l	a5,a2		;Move it for checker
		tst.b	(a2)		;Next answer is empty
		beq	WrongAnswer	;So users answer was wrong
		move.l	a3,a1		;Get start of user answer
		add.w	#$01,AnsCount	;Get ready for next correct answer
		jmp	TestAnswer

TestAnswer2:	tst.b	(a1)		;If correct & user answer
		bne	TestAnswer1	;don't equal 0 answer is wrong
		jmp	RightAnswer	;so get next correct answer

;Wrong answer

WrongAnswer:	jsr	PrintScore

		move.w	#$00,LastAns
		jsr	GiveAnswer
		move.l	ViewPort1(pc),a0
		move.l	#$03,d0
		move.l	#$0f,d1
		clr.l	d2
		clr.l	d3
		lib	Gfx,SetRGB4

		lea.l	NewWrongWin1(pc),a0
		lib	Intuition,OpenWindow
		move.l	d0,WrongWin1
		beq	NoWrongWin1
		move.l	d0,a0
		move.l	$32(a0),a4

		move.l	a4,a0
		lea.l	WrongTxt2(pc),a1
		clr.l	d0
		clr.l	d1
		lib	Intuition,PrintIText

		move.l	WrongWin1,a0
		push	a3-a5
		jsr	CheckIDCMP
		pull	a3-a5
		move.l	WrongWin1(pc),a0
		jsr	ClearMSGs
		move.l	#$00,WrongWin1
		move.l	ViewPort1(pc),a0
		move.l	#$03,d0
		move.l	#06,d1
		move.l	#08,d2
		move.l	#11,d3
		lib	Gfx,SetRGB4
		jmp	TestAns_OUT

RightAnswer:	add.w	#1,Score

		jsr	PrintScore

		move.w	#$01,LastAns
		jsr	GiveAnswer
		move.l	ViewPort1(pc),a0
		move.l	#$03,d0
		clr.l	d1
		move.l	#$0a,d2
		clr.l	d3
		lib	Gfx,SetRGB4

		lea.l	NewRightWin1(pc),a0
		lib	Intuition,OpenWindow
		move.l	d0,RightWin1
		beq	NoRightWin1
		move.l	d0,a0
		move.l	$32(a0),a4

		move.l	a4,a0
		lea.l	RightTxt1(pc),a1
		clr.l	d0
		clr.l	d1
		lib	Intuition,PrintIText

		move.l	RightWin1,a0
		push	a3-a5
		jsr	CheckIDCMP
		pull	a3-a5
		move.l	RightWin1(pc),a0
		jsr	ClearMSGs
		move.l	#$00,RightWin1
		move.l	ViewPort1(pc),a0
		move.l	#$03,d0
		move.l	#06,d1
		move.l	#08,d2
		move.l	#11,d3
		lib	Gfx,SetRGB4
		jmp	TestAns_OUT

TestAns_OUT:	add.w	#$01,QueCount

;remove gadget, clear inputs and put it back

		move.l	Window1(pc),a0
		lea.l	AStrGad1(pc),a1
		lib	Intuition,RemoveGadget
		move.b	#$00,AStrGad1Buf
		move.l	Window1(pc),a0
		lea.l	AStrGad1(pc),a1
		move.l	#-1,d0
		lib	Intuition,AddGadget

		jmp	Ask

PutChProc:	tst.b	d0
		beq	PutChProc_OUT
		move.b	d0,(a3)+
PutChProc_OUT:	rts

PrintScore:	lea.l	fstrl(pc),a0
		lea.l	Score(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	ScoreText2(pc),a3
		lib	Exec,RawDoFmt

		lea.l	fstrl(pc),a0
		move.w	QueCount(pc),QueCount2
		add.w	#1,QueCount2
		lea.l	QueCount2(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	ScoreText4(pc),a3
		lib	Exec,RawDoFmt

;Clear old score

		move.l	RP1(pc),a1
		move.l	#$00,d0
		lib	Gfx,SetAPen

		move.l	RP1(pc),a1		;Question
		move.l	#440,d0
		move.l	#ScoTop,d1
		move.l	#638,d2
		move.l	#ScoTop+9,d3
		lib	Gfx,RectFill

;Print score

		move.l	RP1(pc),a0
		lea.l	ScoreTxt1(pc),a1
		move.l	#440,d0
		move.l	#ScoTop,d1
		lib	Intuition,PrintIText
		rts

PrintNumQ:	lea.l	fstrl(pc),a0
		lea.l	NumQ(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	NumQText2(pc),a3
		lib	Exec,RawDoFmt

;Clear old NumQ

		move.l	RP1(pc),a1
		move.l	#$00,d0
		lib	Gfx,SetAPen

		move.l	RP1(pc),a1		;Question
		move.l	#440,d0
		move.l	#NumQTop,d1
		move.l	#638,d2
		move.l	#NumQTop+9,d3
		lib	Gfx,RectFill

;Print NumQ

		move.l	RP1(pc),a0
		lea.l	NumQTxt1(pc),a1
		move.l	#440,d0
		move.l	#NumQTop,d1
		lib	Intuition,PrintIText
		rts

;Print answer

GiveAnswer:	move.w	#$00,d5
		move.l	CAnsBegin(pc),a5
GiveAnswer1:	move.l	d5,d4
		mulu.w	#10,d4			;Calculate place to print answer
		move.l	a5,AnsTextAdd		;Place address of answer text...
		move.l	RP1(pc),a0		;into IText structure
		lea.l	AnsTxt1(pc),a1
		move.l	#1,d0
		move.l	#MulTop,d1
		add.l	d4,d1
		lib	Intuition,PrintIText

		add.w	#1,d5
		add.l	#AnsLeng,a5
		tst.b	(a5)
		bne	GiveAnswer1

		cmp.w	#$01,LastAns
		bne	GiveAnswer_OUT
		jsr	HiLite
GiveAnswer_OUT:	rts

Game:		tst.b	(NameGad1Buf)		;See if we have the player's name or not
		bne	Game1			;continue if we do
		jsr	GetName			;ask for if we don't

Game1:		cmp.w	#$00,NumQ
		beq	Load

		move.l	#$f800,d0		;Disable menus (first, Game)
		move.l	Window1(pc),a0
		lib	Intuition,OffMenu
		move.l	#$f820,d0		;Second, Enter name
		move.l	Window1(pc),a0
		lib	Intuition,OffMenu
		move.l	#$f840,d0		;Third, Load
		move.l	Window1(pc),a0
		lib	Intuition,OffMenu
		move.l	#$ff01,d0		;Second menu list (Student, Teacher)
		move.l	Window1(pc),a0
		lib	Intuition,OffMenu
		move.w	#01,Mode

		jsr	DoPage			;Draw the boxes and add gadget
		jsr	AddaGad
		jsr	PrintDesc		;Print description of questions
						;(What to do)
;
;start asking...

StartAsk:	move.w	#$00,QueCount		;Reset question counter
		move.w	#$00,Score		;Reset score
		jsr	PressAnyKey
		jsr	PrintScore

;Calculate memory address of question (a4) and answer (a5)

Ask:		move.w	QueCount(pc),d4
		cmp.w	NumQ(pc),d4
		bcc	Game_Out		;Check if done all questions

		add.w	#$01,d4
		move.w	#$00,d3
		lea.l	RememberKey(pc),a4
		move.l	(a4),a4
		move.l	a4,QueBegin
Ask1:		add.w	#1,d3
		cmp.w	d3,d4
		beq	Ask2
		move.l	(a4),a4
		jmp	Ask1

Ask2:		move.l	$8(a4),a4		;Address of question
		move.l	a4,CurrentQue
		move.l	a4,a5
		add.l	#QueLeng,a5		;Address of answers
		move.l	a5,CAnsBegin
		move.l	QueCount(pc),d4
;
;d4 = QueCount
;
;a4 = Question address
;a5 = Answer address


		jsr	ResetPage

;Print question

		move.l	a4,QueTextAdd
		move.l	RP1(pc),a0
		lea.l	QueTxt1(pc),a1
		move.l	#1,d0
		move.l	#QueTop,d1
		lib	Intuition,PrintIText

		add.l	#LineLeng,a4
		move.l	a4,QueTextAdd
		move.l	RP1(pc),a0
		lea.l	QueTxt1(pc),a1
		move.l	#1,d0
		move.l	#QueTop+10,d1
		lib	Intuition,PrintIText

		lea.l	AStrGad1(pc),a0
		move.l	Window1(pc),a1
		move.l	#$00,a2
		lib	Intuition,ActivateGadget
		jmp	Window1IDCMP

;Print description

PrintDesc:	move.l	DesMem1(pc),DesTextAdd
		move.l	RP1(pc),a0
		lea.l	DesTxt1(pc),a1
		move.l	#1,d0
		move.l	#DesTop,d1
		lib	Intuition,PrintIText

		move.l	DesMem1(pc),d0
		add.l	#80,d0
		move.l	d0,DesTextAdd
		move.l	RP1(pc),a0
		lea.l	DesTxt1(pc),a1
		move.l	#1,d0
		move.l	#DesTop+10,d1
		lib	Intuition,PrintIText
		rts

Game_Out:

;Your score was ... etc texts.

		jsr	ClearPage

		move.w	#$00,Mode
		move.l	#$f800,d0		;Enable menus
		move.l	Window1(pc),a0
		lib	Intuition,OnMenu
		move.l	#$f820,d0
		move.l	Window1(pc),a0
		lib	Intuition,OnMenu
		move.l	#$f840,d0
		move.l	Window1(pc),a0
		lib	Intuition,OnMenu
		move.l	#$ff01,d0
		move.l	Window1(pc),a0
		lib	Intuition,OnMenu
		jmp	Window1IDCMP

PressAnyKey:	lea.l	NewAnyKeyWin1(pc),a0
		lib	Intuition,OpenWindow
		move.l	d0,AnyKeyWin1
		beq	NoAnyKeyWin1
		move.l	d0,a0
		move.l	$32(a0),a3

		move.l	a3,a0
		lea.l	AnyKeyTxt1(pc),a1
		clr.l	d0
		clr.l	d1
		lib	Intuition,PrintIText

		move.l	AnyKeyWin1,a0
		jsr	CheckIDCMP
		move.l	AnyKeyWin1(pc),a0
		jsr	ClearMSGs
		move.l	#$00,AnyKeyWin1
		rts

;Clear question area. Now a subroutine.

ResetPage:	move.l	RP1(pc),a1
		move.l	#$00,d0
		lib	Gfx,SetAPen

		move.l	RP1(pc),a1		;Question
		move.l	#1,d0
		move.l	#QueTop,d1
		move.l	#638,d2
		move.l	#QueTop+19,d3
		lib	Gfx,RectFill

		move.l	RP1(pc),a1		;Multibox
		move.l	#01,d0
		move.l	#MulTop-1,d1
		move.l	#638,d2
		move.l	#MulTop+98,d3
		lib	Gfx,RectFill

;Print numbers again

		move.l	RP1(pc),a0
		lea.l	Num1Txt1(pc),a1
		move.l	#00,d0
		move.l	#MulTop,d1
		lib	Intuition,PrintIText
		rts

;Clean the screen of all text and Answer-Gadget

ClearPage:	move.l	Window1(pc),a0
		lea.l	AStrGad1(pc),a1
		lib	Intuition,RemoveGadget

		move.l	RP1(pc),a1
		clr.l	d0
		clr.l	d1
		lib	Gfx,Move

		move.l	RP1(pc),a1
		lib	Gfx,ClearScreen
		rts

EmptyPage:	move.l	RP1(pc),a1
		clr.l	d0
		clr.l	d1
		lib	Gfx,Move

		move.l	RP1(pc),a1
		lib	Gfx,ClearScreen
		rts

;clear screen and add boxes to Window 1. Now a subroutine

DoPage:		move.l	RP1(pc),a1
		clr.l	d0
		clr.l	d1
		lib	Gfx,Move

		move.l	RP1(pc),a1
		lib	Gfx,ClearScreen

		move.l	RP1(pc),a0
		lea.l	TwoLineBox1(pc),a1	;What-to-do box
		move.l	#0,d0
		move.l	#DesTop,d1
		lib	Intuition,DrawBorder

		move.l	RP1(pc),a0
		lea.l	TwoLineBox1(pc),a1	;Question box
		move.l	#0,d0
		move.l	#QueTop,d1
		lib	Intuition,DrawBorder

		move.l	RP1(pc),a0
		lea.l	TenLineBox1(pc),a1	;Multi-question box
		move.l	#0,d0			;and answer
		move.l	#MulTop,d1
		lib	Intuition,DrawBorder

;Add all the texts to Window1

;		move.l	RP1(pc),a0
;		lea.l	Num1Txt1(pc),a1
;		move.l	#00,d0
;		move.l	#91,d1
;		lib	Intuition,PrintIText
		rts

;Add Gadget to Window 1

AddaGad:	move.l	Window1(pc),a0
		lea.l	AStrGad1(pc),a1
		move.l	#-1,d0
		lib	Intuition,AddGadget

;Refresh gadget so its drawn on the screen

		lea.l	AStrGad1(pc),a0
		move.l	Window1(pc),a1
		move.l	#$00,a2
		move.l	#$01,d0
		lib	Intuition,RefreshGList
		rts

About:		jsr	MenusOff
		move.l	Window1(pc),a0
		lea.l	AboutTxt1(pc),a1
		move.l	#$00,a2		;positive text
		lea.l	OKTxt(pc),a3	;a bit the wrong way around but...
		move.l	#$00,d0
		move.l	#$00,d1
		move.l	#$d0,d2
		move.l	#$50,d3
		lib	Intuition,AutoRequest
		jsr	MenusOn
		jmp	Window1IDCMP

Load:		jsr	MenusOff
		lea.l	LoadName(pc),a5
		move.l	#FRQABSOLUTEXYM+FRQLOADINGM,d5
		jsr	FileRequester
		tst.l	d0
		beq	Load_Out1

		lea.l	FRPathName(pc),a1
		move.l	a1,d1
		cmp.b	#$00,(a1)
		beq	Load_Out1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,QueFile
		bne	Load1
		jsr	FileError
		jmp	Load_Out1

;reading "logic"

Load1:		jsr	CheckFile
		tst.l	d0
		beq	Load_Out2

		jsr	KillQueMem1

;First load description for questions

Load1.1:	move.l	QueFile(pc),d1
		move.l	DesMem1(pc),d2
		move.l	#DesLeng,d3
		lib	Dos,Read
		tst.l	d0
		beq	Load7

;Then load the questions and answers

		move.l	#$00,d4

;We're going to add 12 bytes to the amount of memory to be reserved
;for each question set, just in case.

Load2:		lea.l	RememberKey(pc),a0
		move.l	#NextQues+12,d0
		move.l	#MEMF_CLEAR!MEMF_PUBLIC,d1
		lib	Intuition,AllocRemember
		tst.l	d0
		bne	Load2.1
		jsr	NoMem1
		jmp	Load6
Load2.1:	add.w	#1,d4
		cmp.w	NumQ(pc),d4
		bne	Load2

		move.l	#$00,d4
		lea.l	RememberKey(pc),a4
		move.l	(a4),a4
Load3:		move.l	QueFile(pc),d1
		move.l	$8(a4),a0
		move.l	a0,d2
		beq	Load8
		move.l	#NextQues,d3
		lib	Dos,Read
		tst.l	d0
		beq	Load5
		add.w	#1,d4
		cmp.w	NumQ(pc),d4
		beq	Load4
		cmp.l	#$00,(a4)
		beq	Load5
		move.l	(a4),a4
		jmp	Load3

Load4:		move.l	QueFile(pc),d1
		lib	Dos,Close
		move.l	#$00,QueFile
		jmp	Load_Out

Load5:		jsr	FileError
		jsr	KillQueMem1
		move.w	#$00,NumQ
		jmp	Load4
Load6:		jsr	KillQueMem1
		move.w	#$00,NumQ
		jmp	Load4
Load7:		jsr	FileError
		jsr	KillQueMem1
		move.w	#$00,NumQ
		jmp	Load4
Load8:		jsr	FileError
		jsr	KillQueMem1
		move.l	QueFile(pc),d1
		lib	Dos,Close
		move.l	#$00,QueFile
		jmp	Load_Out2

Load_Out:	jsr	MenusOn
		cmp.w	#$02,Mode
		bne	Game
		jmp	DoTeach
Load_Out1:	jsr	MenusOn
		jmp	Window1IDCMP
Load_Out2:	jsr	MenusOn
		move.w	#$00,NumQ
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
		move.l	d0,QueFile
		beq	Save1		;file doesn't exist...

;The file already exists so we'll ask if the user wants to replace old file 

		lea.l	AskReplace(pc),a0
		move.l	#$00,a1
		jsr	TwoGadRequest
		tst.l	d0
		beq	SaveOut

		move.l	QueFile(pc),d1
		lib	Dos,Close
		move.l	#$00,QueFile

SaveAsOut:	jsr	MenusOn

Save:		jsr	MenusOff
		jsr	SaveQuestion

Save1:		tst.l	QueFile
		bne	Save2
		lea.l	FRPathName(pc),a1
		move.l	a1,d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		move.l	d0,QueFile
		bne	Save2
		jsr	FileError
		jmp	SaveOut

		move.l	#"Ques",Que

Save2:		move.l	QueFile(pc),d1
		lea.l	Que(pc),a0
		move.l	a0,d2
		move.l	#8,d3
		lib	Dos,Write
		cmp.l	#-1,d0
		beq	SaveError

;Save description for questions

Save1.1:	move.l	QueFile(pc),d1
		move.l	DesMem1(pc),d2
		move.l	#DesLeng,d3
		lib	Dos,Write
		tst.l	d0
		beq	SaveError

		move.l	#$00,d4
		lea.l	RememberKey(pc),a4
		move.l	(a4),a4
Save3:		move.l	QueFile(pc),d1
		move.l	$8(a4),a0
		move.l	a0,d2
		beq	SaveError
		move.l	#NextQues,d3
		lib	Dos,Write
		tst.l	d0
		beq	SaveError
		add.w	#1,d4
		cmp.w	NumQ(pc),d4
		beq	Save4
		cmp.l	#$00,(a4)
		beq	SaveError
		move.l	(a4),a4
		jmp	Save3

Save4:		move.l	#"QEND",Que_END
		move.l	QueFile(pc),d1
		move.l	Que_END(pc),d2
		move.l	#4,d3
		lib	Dos,Write
		tst.l	d0
		beq	SaveError

;Close the file

Save5:		move.l	QueFile(pc),d1
		lib	Dos,Close
		move.l	#$00,QueFile
	
SaveOut:	jsr	MenusOn
		jmp	Window1IDCMP
SaveError:	jsr	FileError
		jmp	Save5

Quit:		cmp.w	#$01,Mode
		beq	Game_Out
		cmp.w	#$02,Mode
		bne	ShutDown
		jsr	MenusOff
		add.w	#CHECKED,StudentMFlags
		sub.w	#CHECKED,TeacherMFlags
		jsr	MenusOn
		jmp	Student

FileRequester:	move.l	a5,FRTitle
		move.l	d5,FRFlags
		lea.l	FileRequest1(pc),a0
		lib	Req,FileRequester
FROut:		rts

;d4 = Position to HiLite

HiLite:		move.w	AnsCount(pc),d4
		mulu.w	#10,d4
		move.l	RP1(pc),a0
		move.l	#01,d0
		move.l	#MulTop-1,d1
		add.l	d4,d1
		move.l	a0,a1
		move.l	d0,d2
		move.l	d1,d3
		move.l	#637,d4
		move.l	#10,d5
		move.l	#$30,d6			;replace with inverted source
		lib	Gfx,ClipBlit
HiLite_Out:	rts

CheckFile:	move.l	QueFile(pc),d1
		move.l	#0,d2
		move.l	#-1,d3
		lib	Dos,Seek
		move.l	QueFile(pc),d1
		lea.l	Que(pc),a0
		move.l	a0,d2
		move.l	#$08,d3
		flib	Dos,Read
		tst.l	d0
		bne	CheckFile1
		jsr	FileError
		move.l	#0,d0
		rts
CheckFile1:	move.l	Que(pc),d0
		cmp.l	#"Ques",d0
		bne	CheckFile2
		move.l	#-1,d0
		rts
CheckFile2:	move.l	Window1(pc),a0
		lea.l	WrongTxt1(pc),a1
		move.l	#$00,a2		;positive text
		lea.l	OKTxt(pc),a3	;a bit the wrong way around but...
		move.l	#$00,d0
		move.l	#$00,d1
		move.l	#$90,d2
		move.l	#$40,d3
		lib	Intuition,AutoRequest
		rts

KillQueMem1:	lea.l	RememberKey(pc),a0
		move.l	#TRUE,d0
		lib	Intuition,FreeRemember
KillQM1_Out:	rts

NoMem1:		move.l	Window1(pc),a0
		lea.l	NoMemTxt1(pc),a1
		move.l	#$00,a2		;positive text
		lea.l	OKTxt(pc),a3	;a bit the wrong way around but...
		move.l	#$00,d0
		move.l	#$00,d1
		move.l	#$90,d2
		move.l	#$40,d3
		lib	Intuition,AutoRequest
		rts

NoQues:		move.l	Window1(pc),a0
		lea.l	NoQuesTxt1(pc),a1
		move.l	#$00,a2		;positive text
		lea.l	OKTxt(pc),a3	;a bit the wrong way around but...
		move.l	#$00,d0
		move.l	#$00,d1
		move.l	#$90,d2
		move.l	#$40,d3
		lib	Intuition,AutoRequest
		rts

ShutDown:	move.l	OurTask(pc),a0
		move.l	OldTaskWinPtr(pc),$b8(a0)

ShutDown9000:	tst.l	QueFile
		beq	ShutDown8000
		move.l	QueFile(pc),d1
		lib	Dos,Close
		move.l	#$00,QueFile

ShutDown8000:	tst.l	DesMem1
		beq	ShutDown8100
		move.l	DesMem1(pc),a1
		move.l	#DesLeng+12,d0
		lib	Exec,FreeMem
		move.l	#$00,DesMem1

ShutDown8100:	jsr	KillQueMem1

ShutDown7200:	tst.l	AnyKeyWin1
		beq	ShutDown7100
		move.l	AnyKeyWin1(pc),a0
		jsr	ClearMSGs
ShutDown7100:	tst.l	WrongWin1
		beq	ShutDown7000
		move.l	WrongWin1(pc),a0
		jsr	ClearMSGs
ShutDown7000:	tst.l	RightWin1
		beq	ShutDown5000
		move.l	RightWin1(pc),a0
		jsr	ClearMSGs

ShutDown5000:	tst.l	Window1
		beq	ShutDown4500
		move.l	Window1(pc),a0
		lib	Intuition,ClearMenuStrip
		move.l	Window1(pc),a0
		jsr	ClearMSGs

ShutDown4500:	tst.l	Screen1
		beq	ShutDown3000
		move.l	Screen1(pc),a0
		lib	Intuition,CloseScreen

ShutDown3000:	tst.l	_ReqBase
		beq	ShutDown2000
		lea.l	FileRequest1(pc),a0
		lib	Req,PurgeFiles

ShutDown2000:

ShutDown1100:	tst.l	_IntuitionBase
		beq	ShutDown1000
		lib	Intuition,OpenWorkBench		;For that xtra touch
ShutDown1000:	closlib	Intuition
		closlib	Req
		closlib	Gfx
;		closlib	Iff
		closlib	Dos
ShutDownOut:	move.l	#RETURN_OK,d0
		rts

NoScreen1:	print	<"Couldn't open Screen1!",13,10>
		jmp	ShutDown
NoWrongWin1:	print	<"Couldn't open Wrong-Window1!",13,10>
		jmp	ShutDown
NoRightWin1:	print	<"Couldn't open Right-Window1!",13,10>
		jmp	ShutDown
NoAnyKeyWin1:	print	<"Couldn't open AnyKey-Window1!",13,10>
		rts
NoWindow1:	print	<"Couldn't open Window1!",13,10>
		jmp	ShutDown

MenusOn:	move.l	Window1(pc),a0
		lea.l	Menu1(pc),a1
		lib	Intuition,SetMenuStrip
		rts

MenusOff:	move.l	Window1(pc),a0
		lib	Intuition,ClearMenuStrip
		rts

MenuNull:	move.l	d3,d6	
				
		ror.l	#5,d6	
		lsr.l	#8,d6	
		lsr.l	#8,d6
		lsr.l	#8,d6
		lsr.l	#3,d6

		move.l	d3,d5

		ror.l	#5,d5	
		ror.l	#6,d5	
		lsr.l	#8,d5
		lsr.l	#8,d5
		lsr.l	#8,d5
		lsr.l	#2,d5
				
		move.l	#$00,d4
		move.w	d3,d4
		lsr.l	#5,d4
		lsr.l	#6,d4
		rts

CheckIDCMP:	move.l	$4,a6			;made this a SubRoutine...
		move.l	$56(a0),a2		;Give it the window structure in a0
		move.l	#0,d1
		move.b	$0f(a2),d1
		move.l	#0,d0
		bset.l	d1,d0
		jsr	_LVOWait(a6)	
	
GetMsg1:	move.l	a2,a0	
		jsr	_LVOGetMsg(a6)
		tst.l	d0
		beq	GetMsg2
	
		move.l	d0,a1 
		move.l	$14(a1),d2		;answers with Class in d2,
		move.w	$18(a1),d3		;Code in d3 and
		move.w	$1a(a1),a4		;Qualifier in a4
		move.l	$1c(a1),a5		;IAddress in a5
		jsr	_LVOReplyMsg(a6)
		jmp	GetMsg1
GetMsg2:	move.l	#-1,d0
		rts

ClearMSGs:	move.l	a0,d0
		tst.l	d0
		beq	ClearMsg3
		move.l	a0,a3
		lib	Exec,Forbid
		move.l	$56(a3),a2		;Give it the window structure in a0
ClearMsg1:	move.l	a2,a0	
		lib	Exec,GetMsg
		tst.l	d0
		beq	ClearMsg2
		move.l	d0,a1 
		lib	Exec,ReplyMsg
		jmp	ClearMsg1
ClearMsg2:	move.l	a3,a0
		lib	Intuition,CloseWindow
		lib	Exec,Permit
ClearMsg3:	rts

		INCLUDE	"FH1:Language/WF/Questions/QFileRequester.i"
		INCLUDE	"FH1:Language/WF/Questions/DosError.i"

;Question template

		INCLUDE	"FH1:Language/WF/Questions/Que.i"

;Structures

;Display stuff

Screen1		dc.l	0
ViewPort1	dc.l	0
Window1		dc.l	0
RP1		dc.l	0
WrongWin1	dc.l	0
RightWin1	dc.l	0
AnyKeyWin1	dc.l	0

;Library stuff (well what's needed anymore)

		libnames

;_IffBase	dc.l	0
;_IffLib	dc.b	"iff.library",0
;		ds.l	0

;File stuff

_stdout		dc.l	0
;IffFile	dc.l	0
QueFile		dc.l	0

;Memory stuff

QueBytes:	dc.l	0		;Amount of memory reserved
DesMem1:	dc.l	0		;Address of description

RememberKey:	dc.l	0		;Our editing memory list of
		dc.l	0		;questions & answers
		dc.l	0		;1=NextRemember, 2=Size, 3=Memory

;Other question stuff

QueCount:	dc.w	0		;Asking QueCount'th question
AnsCount:	dc.w	0		;Checking AnsCount'th answer,
					;also used for printing
Score:		dc.w	0		;Player score
QueCount2:	dc.w	0		;out of QueCount'th questions
LastAns:	dc.w	0		;Wrong (0) or right (1)?
QueBegin:	dc.l	0		;Question begin
CAnsBegin:	dc.l	0		;Correct answer begin
CurrentQue:	dc.l	0		;Current question 

;Task stuff

OurTask		dc.l	0
OldTaskWinPtr	dc.l	0

;Other stuff XIV

Mode:		dc.w	0		;0=Waiting, 1=Running, 2=Editing

;Texts, Part I

QName		dc.b	"Questions (C)opyright 1991 Tomi Blinnikka",0
LoadName	dc.b	"Load quiz.",0
SaveName	dc.b	"Save quiz.",0
		ds.l	0

;New screen & new window structures

NewScreen1	dc.w	0,0			;X,Y POS
Screen1MaxCol	dc.w	640 ;724		;WIDTH
Screen1MaxRow	dc.w	200; 283			;HEIGHT
		dc.w	3			;DEPTH
		dc.b	0,1			;COLORS
		dc.w	V_HIRES+V_SPRITES	;VIEWMODES
		dc.w	CUSTOMSCREEN		;TYPE
		dc.l	Screen1Font		;FONT
		dc.l	QName			;DEFULT TITLE
		dc.l	0			;GADGETS
		dc.l	0			;CUSTOMBITMAP

Screen1Font	dc.l	Screen1FontN		;NAME
		dc.w	8			;SIZE
		dc.b	0			;STYLE
		dc.b	0			;FLAGS
		ds.l	0
Screen1FontN	dc.b	"topaz.font",0
		ds.l	0

NewWindow1	dc.w	0,0			;X,Y POS
		dc.w	640 ;724		;WIDTH
		dc.w	200 ;283			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	GADGETDOWN+GADGETUP+VANILLAKEY+RAWKEY+MENUPICK
		dc.l	ACTIVATE+BACKDROP+BORDERLESS
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	0			;TITLE
SToW1		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	724,283,724,283		;MINIMUM SIZE
		dc.w	CUSTOMSCREEN		;TYPE

NewWrongWin1	dc.w	150,50			;X,Y POS
		dc.w	80			;WIDTH
		dc.w	25			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	VANILLAKEY+RAWKEY+INACTIVEWINDOW+CLOSEWINDOW+MOUSEBUTTONS
		dc.l	ACTIVATE+WINDOWCLOSE
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	0			;TITLE
SToW2		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	80,25,80,25		;MINIMUM SIZE
		dc.w	CUSTOMSCREEN		;TYPE

NewRightWin1	dc.w	150,50			;X,Y POS
		dc.w	80			;WIDTH
		dc.w	25			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	VANILLAKEY+RAWKEY+INACTIVEWINDOW+CLOSEWINDOW+MOUSEBUTTONS
		dc.l	ACTIVATE+WINDOWCLOSE
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	0			;TITLE
SToW3		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	80,25,80,25		;MINIMUM SIZE
		dc.w	CUSTOMSCREEN		;TYPE

NewAnyKeyWin1	dc.w	150,50			;X,Y POS
		dc.w	130			;WIDTH
		dc.w	25			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	VANILLAKEY+RAWKEY+INACTIVEWINDOW+CLOSEWINDOW+MOUSEBUTTONS
		dc.l	ACTIVATE+WINDOWCLOSE
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	0			;TITLE
SToW4		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	130,25,130,25		;MINIMUM SIZE
		dc.w	CUSTOMSCREEN		;TYPE

;Fonts

Topaz		dc.l	FontName
		dc.w	8
		dc.b	0
		dc.b	0
FontName	dc.b	"topaz.font",0
		ds.l	0

;Gadget structures

FirstGad1:	dc.l	PrevGad1	;Next Gadget
		dc.w	13		;"hit-box" left edge
		dc.w	OptionTop	;"hit-box" top  edge
		dc.w	51		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP	;flags
		dc.w	RELVERIFY+GADGIMMEDIATE	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	HGadBorder1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	FirstGad1Txt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	10		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

FirstGad1Txt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	6,1			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	FirstGad1Text1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
FirstGad1Text1:	dc.b	"First",0
		ds.l	0

PrevGad1:	dc.l	NextGad1	;Next Gadget
		dc.w	73		;"hit-box" left edge
		dc.w	OptionTop	;"hit-box" top  edge
		dc.w	51		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP	;flags
		dc.w	RELVERIFY+GADGIMMEDIATE	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	HGadBorder1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	PrevGad1Txt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	20		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

PrevGad1Txt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	10,1			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	PrevGad1Text1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
PrevGad1Text1:	dc.b	"Prev",0
		ds.l	0

NextGad1:	dc.l	AddGad1		;Next Gadget
		dc.w	133		;"hit-box" left edge
		dc.w	OptionTop	;"hit-box" top  edge
		dc.w	51		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP	;flags
		dc.w	RELVERIFY+GADGIMMEDIATE	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	HGadBorder1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	NextGad1Txt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	30		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

NextGad1Txt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	10,1			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	NextGad1Text1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
NextGad1Text1:	dc.b	"Next",0
		ds.l	0

AddGad1:	dc.l	UndoGad1	;Next Gadget
		dc.w	193		;"hit-box" left edge
		dc.w	OptionTop	;"hit-box" top  edge
		dc.w	51		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP	;flags
		dc.w	RELVERIFY+GADGIMMEDIATE	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	HGadBorder1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	AddGad1Txt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	40		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

AddGad1Txt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	13,1			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AddGad1Text1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
AddGad1Text1:	dc.b	"Add",0
		ds.l	0

UndoGad1:	dc.l	ClearGad1	;Next Gadget
		dc.w	253		;"hit-box" left edge
		dc.w	OptionTop	;"hit-box" top  edge
		dc.w	51		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP	;flags
		dc.w	RELVERIFY+GADGIMMEDIATE	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	HGadBorder1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	UndoGad1Txt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	50		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

UndoGad1Txt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	10,1			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	UndoGad1Text1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
UndoGad1Text1:	dc.b	"Undo",0
		ds.l	0

ClearGad1:	dc.l	DesStrGad1	;Next Gadget
		dc.w	313		;"hit-box" left edge
		dc.w	OptionTop	;"hit-box" top  edge
		dc.w	51		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP	;flags
		dc.w	RELVERIFY+GADGIMMEDIATE	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	HGadBorder1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	ClearGad1Txt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	60		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

ClearGad1Txt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	6,1			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	ClearGad1Text1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
ClearGad1Text1:	dc.b	"Clear",0
		ds.l	0

NameGad1:	dc.l	0		;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	NameTop		;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	GADGIMMEDIATE+RELVERIFY	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	OneLineBox1	;gadget rendering
		dc.l	OneLineBox1	;select rendering
		dc.l	NameGadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	NameGadInfo	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

NameGadInfo:	dc.l	NameGad1Buf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	NameLeng-2	;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char

		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

NameGadTxt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	0,-10			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	NameGad1Text		;TEXT
		dc.l	0			;NEXTTEXT

NameGad1Text:	dc.b	"Please enter your name:",0
		ds.l	0

MultiGad1	dc.l	MultiGad2	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP ;+GADGIMAGE
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt1	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText1		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText1	dc.b	"Gadget 1",0
		ds.l	0

MultiGad2	dc.l	MultiGad3	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+10-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt2	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	2		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt2	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText2		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText2	dc.b	"Gadget 2",0
		ds.l	0

MultiGad3	dc.l	MultiGad4	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+20-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP ;+GADGIMAGE
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt3	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	3		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt3	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText3		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText3	dc.b	"Gadget 3",0
		ds.l	0

MultiGad4	dc.l	MultiGad5	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+30-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt4	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	4		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt4	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText4		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText4	dc.b	"Gadget 4",0
		ds.l	0

MultiGad5	dc.l	MultiGad6	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+40-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP ;+GADGIMAGE
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt5	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	5		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt5	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText5		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText5	dc.b	"Gadget 5",0
		ds.l	0

MultiGad6	dc.l	MultiGad7	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+50-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt6	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	6		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt6	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText6		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText6	dc.b	"Gadget 6",0
		ds.l	0

MultiGad7	dc.l	MultiGad8	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+60-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP ;+GADGIMAGE
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt7	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	7		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt7	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText7		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText7	dc.b	"Gadget 7",0
		ds.l	0

MultiGad8	dc.l	MultiGad9	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+70-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt8	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	8		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt8	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText8		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText8	dc.b	"Gadget 8",0
		ds.l	0

MultiGad9	dc.l	MultiGad10	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+80-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP ;+GADGIMAGE
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt9	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	9		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt9	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText9		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText9	dc.b	"Gadget 9",0
		ds.l	0

MultiGad10	dc.l	0		;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+90-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt10	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	10		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt10	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText10		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText10	dc.b	"Gadget 10",0
		ds.l	0

DesStrGad1:	dc.l	DesStrGad2	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	DesTop		;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	GADGIMMEDIATE+RELVERIFY	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	0		;gadget text
		dc.l	0		;mutual exclude
		dc.l	DesStr1Info	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

DesStr1Info:	dc.l	DesStr1Buf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	LineLeng	;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char

		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

DesStrGad2:	dc.l	QueStrGad1	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	DesTop+10	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	GADGIMMEDIATE+RELVERIFY	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	0		;gadget text
		dc.l	0		;mutual exclude
		dc.l	DesStr2Info	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

DesStr2Info:	dc.l	DesStr2Buf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	LineLeng	;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char

		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

QueStrGad1:	dc.l	QueStrGad2	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	QueTop		;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	GADGIMMEDIATE+RELVERIFY	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	0		;gadget text
		dc.l	0		;mutual exclude
		dc.l	QueStr1Info	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

QueStr1Info:	dc.l	QueStr1Buf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	LineLeng	;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char

		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

QueStrGad2:	dc.l	MulStrGad1	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	QueTop+10	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	GADGIMMEDIATE+RELVERIFY	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	0		;gadget text
		dc.l	0		;mutual exclude
		dc.l	QueStr2Info	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

QueStr2Info:	dc.l	QueStr2Buf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	LineLeng	;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char

		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

MulStrGad1:	dc.l	MulStrGad2	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop		;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	GADGIMMEDIATE+RELVERIFY	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	0		;gadget text
		dc.l	0		;mutual exclude
		dc.l	MulStr1Info	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MulStr1Info:	dc.l	MulStr1Buf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	LineLeng	;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char

		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

MulStrGad2:	dc.l	MulStrGad3	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+10	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	GADGIMMEDIATE+RELVERIFY	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	0		;gadget text
		dc.l	0		;mutual exclude
		dc.l	MulStr2Info	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MulStr2Info:	dc.l	MulStr2Buf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	LineLeng	;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char

		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

MulStrGad3:	dc.l	MulStrGad4	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+20	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	GADGIMMEDIATE+RELVERIFY	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	0		;gadget text
		dc.l	0		;mutual exclude
		dc.l	MulStr3Info	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MulStr3Info:	dc.l	MulStr3Buf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	LineLeng	;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char

		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

MulStrGad4:	dc.l	MulStrGad5	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+30	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	GADGIMMEDIATE+RELVERIFY	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	0		;gadget text
		dc.l	0		;mutual exclude
		dc.l	MulStr4Info	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MulStr4Info:	dc.l	MulStr4Buf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	LineLeng	;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char

		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

MulStrGad5:	dc.l	MulStrGad6	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+40	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	GADGIMMEDIATE+RELVERIFY	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	0		;gadget text
		dc.l	0		;mutual exclude
		dc.l	MulStr5Info	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MulStr5Info:	dc.l	MulStr5Buf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	LineLeng	;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char

		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

MulStrGad6:	dc.l	MulStrGad7	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+50	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	GADGIMMEDIATE+RELVERIFY	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	0		;gadget text
		dc.l	0		;mutual exclude
		dc.l	MulStr6Info	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MulStr6Info:	dc.l	MulStr6Buf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	LineLeng	;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char

		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

MulStrGad7:	dc.l	MulStrGad8	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+60	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	GADGIMMEDIATE+RELVERIFY	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	0		;gadget text
		dc.l	0		;mutual exclude
		dc.l	MulStr7Info	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MulStr7Info:	dc.l	MulStr7Buf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	LineLeng	;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char

		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

MulStrGad8:	dc.l	MulStrGad9	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+70	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	GADGIMMEDIATE+RELVERIFY	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	0		;gadget text
		dc.l	0		;mutual exclude
		dc.l	MulStr8Info	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MulStr8Info:	dc.l	MulStr8Buf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	LineLeng	;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char

		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

MulStrGad9:	dc.l	MulStrGad10	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+80	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	GADGIMMEDIATE+RELVERIFY	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	0		;gadget text
		dc.l	0		;mutual exclude
		dc.l	MulStr9Info	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MulStr9Info:	dc.l	MulStr9Buf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	LineLeng	;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char

		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

MulStrGad10:	dc.l	AStrGad1	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+90	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	GADGIMMEDIATE+RELVERIFY	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	0		;gadget text
		dc.l	0		;mutual exclude
		dc.l	MulStr10Info	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MulStr10Info:	dc.l	MulStr10Buf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	LineLeng	;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char

		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

AStrGad1:	dc.l	0 ;MultiGad1	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	AnsTop		;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	GADGIMMEDIATE+RELVERIFY	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	OneLineBox1	;gadget rendering
		dc.l	OneLineBox1	;select rendering
		dc.l	0		;gadget text
		dc.l	0		;mutual exclude
		dc.l	Gad2StrInfo	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

Gad2StrInfo:	dc.l	AStrGad1Buf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	AnsLeng		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char

		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

;Menus

Menu1:		dc.l	Menu2			;NEXT MENU
		dc.w	0,1			;LEFT+TOP EDGE
		dc.w	100,8			;WIDTH+HEIGHT
		dc.w	MENUENABLED		;FLAGS
		dc.l	Menu1Name		;NAME
		dc.l	StartMenu1		;ITEMS
		dc.w	0,0			;Some Jazz-music here...		
		dc.w	0,0,0			;(with a good beat)

Menu1Name:	dc.b	"Main",0
		ds.l	0

Menu2:		dc.l	0 ;Menu3		;NEXT MENU
		dc.w	100,1			;LEFT+TOP EDGE
		dc.w	100,8			;WIDTH+HEIGHT
		dc.w	MENUENABLED		;FLAGS
		dc.l	Menu2Name		;NAME
		dc.l	ModeMenu1		;ITEMS
		dc.w	0,0			;Some Jazz-music here...		
		dc.w	0,0,0			;(with a good beat)

Menu2Name:	dc.b	"Mode",0
		ds.l	0

ModeMenu1:	dc.l	ModeMenu2		;NEXT ITEM
		dc.w	1,0			;LEFT+TOP EDGE
		dc.w	100,9			;WIDTH+HEIGHT
StudentMFlags:	dc.w	HIGHCOMP+ITEMENABLED+ITEMTEXT+CHECKIT+CHECKED	;FLAGS
		dc.w	$ffff			;MUTUAL EXCLUDE
		dc.b	$ff
		dc.b	%11111110
		dc.l	Menu2I1			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	0,0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu2I1:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,1			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu2I1Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I1Text:	dc.b	"   Student",0
		ds.l	0

ModeMenu2:	dc.l	0 			;NEXT ITEM
		dc.w	1,10			;LEFT+TOP EDGE
		dc.w	100,9			;WIDTH+HEIGHT
TeacherMFlags:	dc.w	HIGHCOMP+ITEMENABLED+ITEMTEXT+CHECKIT	;FLAGS
		dc.w	$ffff			;MUTUAL EXCLUDE
		dc.b	$ff
		dc.b	%11111101
		dc.l	Menu2I2			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	0,0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu2I2:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,1			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu2I2Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I2Text:	dc.b	"   Teacher",0
		ds.l	0

StartMenu1:	dc.l	ENameMenu1		;NEXT ITEM
		dc.w	1,1			;LEFT+TOP EDGE
		dc.w	120,8			;WIDTH+HEIGHT
		dc.w	HIGHCOMP+ITEMENABLED+COMMSEQ+ITEMTEXT
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	StartMenu1I1		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"G",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
StartMenu1I1:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	StartMenu1I1Text	;TEXT
		dc.l	0			;NEXTTEXT

StartMenu1I1Text:	dc.b	"Start!",0
			ds.l	0

ENameMenu1:	dc.l	LoadMenu1		;NEXT ITEM
		dc.w	1,10			;LEFT+TOP EDGE
		dc.w	120,8			;WIDTH+HEIGHT
		dc.w	HIGHCOMP+ITEMENABLED+COMMSEQ+ITEMTEXT
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	ENameMenu1I1		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"N",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
ENameMenu1I1:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	ENameMenu1I1Text	;TEXT
		dc.l	0			;NEXTTEXT

ENameMenu1I1Text:	dc.b	"Enter name",0
			ds.l	0

LoadMenu1:	dc.l	SaveMenu1		;NEXT ITEM
		dc.w	1,19			;LEFT+TOP EDGE
		dc.w	120,8			;WIDTH+HEIGHT
		dc.w	HIGHCOMP+ITEMENABLED+COMMSEQ+ITEMTEXT
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	LoadMenu1I1		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"L",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
LoadMenu1I1:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	LoadMenu1I1Text		;TEXT
		dc.l	0			;NEXTTEXT

LoadMenu1I1Text:	dc.b	"Load...",0
			ds.l	0

SaveMenu1:	dc.l	SaveAsMenu1		;NEXT ITEM
		dc.w	1,28			;LEFT+TOP EDGE
		dc.w	120,8			;WIDTH+HEIGHT
		dc.w	HIGHCOMP+COMMSEQ+ITEMTEXT ;+ITEMENABLED
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	SaveMenu1I1		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"S",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
SaveMenu1I1:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SaveMenu1I1Text		;TEXT
		dc.l	0			;NEXTTEXT

SaveMenu1I1Text:	dc.b	"Save",0
			ds.l	0

SaveAsMenu1:	dc.l	AboutMenu1		;NEXT ITEM
		dc.w	1,37			;LEFT+TOP EDGE
		dc.w	120,8			;WIDTH+HEIGHT
		dc.w	HIGHCOMP+COMMSEQ+ITEMTEXT ;+ITEMENABLED
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	SaveAsMenu1I1		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"W",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
SaveAsMenu1I1:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SaveAsMenu1I1Text	;TEXT
		dc.l	0			;NEXTTEXT

SaveAsMenu1I1Text:	dc.b	"Save as...",0
			ds.l	0

AboutMenu1:	dc.l	QuitMenu1		;NEXT ITEM
		dc.w	1,46			;LEFT+TOP EDGE
		dc.w	120,8			;WIDTH+HEIGHT
		dc.w	HIGHCOMP+ITEMENABLED+COMMSEQ+ITEMTEXT
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	AboutMenu1I1		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"A",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
AboutMenu1I1:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	AboutMenu1I1Text	;TEXT
		dc.l	0			;NEXTTEXT

AboutMenu1I1Text:	dc.b	"About",0
			ds.l	0

QuitMenu1:	dc.l	0			;NEXT ITEM
		dc.w	1,55			;LEFT+TOP EDGE
		dc.w	120,8			;WIDTH+HEIGHT
		dc.w	HIGHCOMP+ITEMENABLED+COMMSEQ+ITEMTEXT
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	QuitMenu1I2		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"Q",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
QuitMenu1I2:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	QuitMenu1I2Text		;TEXT
		dc.l	0			;NEXTTEXT

QuitMenu1I2Text:	dc.b	"Quit",0
			ds.l	0

;Borders, Images etc...

OneLineBox1	dc.w	-1		;Initial offsets from the origin
		dc.w	-2		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	BorderXY1	;XY's
		dc.l	0		;Next Border
		dc.b	0
		ds.l	0
BorderXY1	dc.w	0,0
		dc.w	639,0		
		dc.w	639,11
		dc.w	0,11
		dc.w	0,0
		dc.b	0
		ds.l	0

TwoLineBox1	dc.w	0		;Initial offsets from the origin
		dc.w	-2		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	BorderXY2	;XY's
		dc.l	0		;Next Border
		dc.b	0
		ds.l	0
BorderXY2	dc.w	0,0
		dc.w	639,0		
		dc.w	639,22
		dc.w	0,22
		dc.w	0,0
		dc.b	0
		ds.l	0

TenLineBox1	dc.w	0		;Initial offsets from the origin
		dc.w	-2		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	BorderXY3	;XY's
		dc.l	0		;Next Border
		dc.b	0
		ds.l	0
BorderXY3	dc.w	0,0
		dc.w	639,0		
		dc.w	639,101
		dc.w	0,101
		dc.w	0,0
		dc.b	0
		ds.l	0

HGadBorder1:	dc.w	-1		;Initial offsets from the origin
		dc.w	-1		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	HGadBorderXY1	;XY's
		dc.l	HGadBorder2	;Next Border
		dc.b	0
		ds.l	0
HGadBorderXY1:	dc.w	0,0
		dc.w	52,0		
		dc.w	52,11
		dc.w	0,11
		dc.w	0,0
		dc.b	0
		ds.l	0

HGadBorder2:	dc.w	-2		;Initial offsets from the origin
		dc.w	-3		;LeftEdge and TopEdge
		dc.b	3,1		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	HGadBorderXY2	;XY's
		dc.l	HGadBorder3	;Next Border
		dc.b	0
		ds.l	0
HGadBorderXY2:	dc.w	0,0
		dc.w	54,0		
		dc.w	54,15
		dc.w	0,15
		dc.w	0,0
		dc.b	0
		ds.l	0

HGadBorder3:	dc.w	-3		;Initial offsets from the origin
		dc.w	-4		;LeftEdge and TopEdge
		dc.b	3,1		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	HGadBorderXY3	;XY's
		dc.l	0		;Next Border
		dc.b	0
		ds.l	0
HGadBorderXY3:	dc.w	0,0
		dc.w	56,0		
		dc.w	56,17
		dc.w	0,17
		dc.w	0,0
		dc.b	0
		ds.l	0

;Texts, Part II

AboutTxt1:	dc.b	3,1			;PENS
		dc.w	0			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	AboutText1		;TEXT
		dc.l	AboutTxt2		;NEXTTEXT
		
AboutTxt2:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	10,20			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	AboutText2		;TEXT
		dc.l	AboutTxt3		;NEXTTEXT

AboutTxt3:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,30			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	AboutText3		;TEXT
		dc.l	AboutTxt4		;NEXTTEXT

AboutTxt4:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,50			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	AboutText4		;TEXT
		dc.l	0			;NEXTTEXT

OKTxt:		dc.b	3,1			;PENS
		dc.w	0			;MODE
		dc.w	6,3			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	OKText1			;TEXT
		dc.l	0			;NEXTTEXT

CancelTxt:	dc.b	3,1			;PENS
		dc.w	0			;MODE
		dc.w	6,3			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	CancelText1		;TEXT
		dc.l	0			;NEXTTEXT

WrongTxt1:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	FWrongText1		;TEXT
		dc.l	0			;NEXTTEXT

NoMemTxt1:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	NoMemText1		;TEXT
		dc.l	0			;NEXTTEXT

NoQuesTxt1:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	NoQuesText1		;TEXT
		dc.l	0			;NEXTTEXT

DesTxt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
DesTextAdd:	dc.l	0			;TEXT
		dc.l	0			;NEXTTEXT

QueTxt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
QueTextAdd:	dc.l	0			;TEXT
		dc.l	0			;NEXTTEXT

AnsTxt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	30,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
AnsTextAdd:	dc.l	0			;TEXT
		dc.l	0			;NEXTTEXT

WrongTxt2:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	17,13			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	WrongText1		;TEXT
		dc.l	0			;NEXTTEXT

RightTxt1:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	12,13			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	RightText1		;TEXT
		dc.l	0			;NEXTTEXT

AnyKeyTxt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	12,13			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AnyKeyText1		;TEXT
		dc.l	0			;NEXTTEXT

Num1Txt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	2,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Num1Text1		;TEXT
		dc.l	Num2Txt1		;NEXTTEXT

Num2Txt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	2,10			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Num2Text1		;TEXT
		dc.l	Num3Txt1		;NEXTTEXT

Num3Txt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	2,20			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Num3Text1		;TEXT
		dc.l	Num4Txt1		;NEXTTEXT

Num4Txt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	2,30			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Num4Text1		;TEXT
		dc.l	Num5Txt1		;NEXTTEXT

Num5Txt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	2,40			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Num5Text1		;TEXT
		dc.l	Num6Txt1		;NEXTTEXT

Num6Txt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	2,50			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Num6Text1		;TEXT
		dc.l	Num7Txt1		;NEXTTEXT

Num7Txt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	2,60			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Num7Text1		;TEXT
		dc.l	Num8Txt1		;NEXTTEXT

Num8Txt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	2,70			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Num8Text1		;TEXT
		dc.l	Num9Txt1		;NEXTTEXT

Num9Txt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	2,80			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Num9Text1		;TEXT
		dc.l	Num10Txt1		;NEXTTEXT

Num10Txt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	2,90			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Num10Text1		;TEXT
		dc.l	0			;NEXTTEXT

ScoreTxt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	2,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	ScoreText1		;TEXT
		dc.l	0			;NEXTTEXT

NumQTxt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	2,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	NumQText1		;TEXT
		dc.l	0			;NEXTTEXT

TimerTxt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	0,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	0			;TEXT
		dc.l	0			;NEXTTEXT

NoMemText1:	dc.b	"Out of memory, can't load!",0
NoQuesText1:	dc.b	"There aren't any questions",0
FWrongText1:	dc.b	"Not a question-answer file!",0

OKText1:	dc.b	"OK",0
CancelText1:	dc.b	"CANCEL!",0

WrongText1:	dc.b	"Wrong!",0
RightText1:	dc.b	"Correct",0
AnyKeyText1:	dc.b	"Press any key",0

Num1Text1:	dc.b	"01.",0
Num2Text1:	dc.b	"02.",0
Num3Text1:	dc.b	"03.",0
Num4Text1:	dc.b	"04.",0
Num5Text1:	dc.b	"05.",0
Num6Text1:	dc.b	"06.",0
Num7Text1:	dc.b	"07.",0
Num8Text1:	dc.b	"08.",0
Num9Text1:	dc.b	"09.",0
Num10Text1:	dc.b	"10.",0

NumQText1:	dc.b	"No.  of  questions "
NumQText2:	dc.b	"    0",0

ScoreText1:	dc.b	"Score "
ScoreText2:	dc.b	"    0 "
ScoreText3:	dc.b	"out of "
ScoreText4:	dc.b	"    0",0
fstrl:		dc.b	"%5.d",0

AboutText1:	dc.b	"   Questions -The Amiga version-",0
AboutText2:	dc.b	"           v.0.99a  by",0
AboutText3:	dc.b	"         Tomi Blinnikka",0
AboutText4:	dc.b	"        (C)opyright 1991",0
		ds.l	0

;Gadget buffers

MenuBarName:	dc.b	"Name: "
NameGad1Buf:	dcb.b	NameLeng,0

DesStr1Buf:	dcb.b	LineLeng,0
DesStr2Buf:	dcb.b	LineLeng,0
QueStr1Buf:	dcb.b	LineLeng,0
QueStr2Buf:	dcb.b	LineLeng,0
MulStr1Buf:	dcb.b	LineLeng,0
MulStr2Buf:	dcb.b	LineLeng,0
MulStr3Buf:	dcb.b	LineLeng,0
MulStr4Buf:	dcb.b	LineLeng,0
MulStr5Buf:	dcb.b	LineLeng,0
MulStr6Buf:	dcb.b	LineLeng,0
MulStr7Buf:	dcb.b	LineLeng,0
MulStr8Buf:	dcb.b	LineLeng,0
MulStr9Buf:	dcb.b	LineLeng,0
MulStr10Buf:	dcb.b	LineLeng,0
AStrGad1Buf:	dcb.b	AnsLeng,0

GadUnBuf:	dcb.b	QueLeng,0

		END

;GADGETDOWN+GADGETUP+

;turn on menu bar

;		move.l	Screen1(pc),a0
;		move.l	#$01,d0
;		lib	Intuition,ShowTitle


;turn off menu bar

;		move.l	Screen1(pc),a0
;		move.l	#$00,d0
;		lib	Intuition,ShowTitle


;Get length of text in given address (a0), including 0
;
;Input a0 = Address of null terminated text string
;
;Result d0 = Length

GetLength:	move.l	#$00,d0
GetLength2:	add.l	#1,d0
		tst.b	(a2)+
		bne	GetLength2
		add.l	#1,d0
		rts

;Get address of current question (QueCount)
;
;Input from QueCount
;
;Result a0 = Address of question

GetQueInfo:	move.l	#$00,d4
		lea.l	RememberKey(pc),a4
		move.l	(a4),a4
GetQInfo2:	cmp.w	QueCount(pc),d4
		beq	GetQInfo3
		add.w	#1,d4
		move.l	(a4),a4
		jmp	GetQInfo2
GetQInfo3:	move.l	$8(a4),a4
		move.l	a4,CurrentQue
		rts
