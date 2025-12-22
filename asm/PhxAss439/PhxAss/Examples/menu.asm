**
**	Menu Example
**


	incdir	"include"
	include	"lib/exec.i"		; library offsets
	include	"lib/intuition.i"
	include	"lib/gadtools.i"

**  You should also define an include path for your Commodore **
** includes or make use of the PHXASSINC environment variable **
	include	"intuition/intuition.i"
	include	"libraries/gadtools.i"
	include	"graphics/rastport.i"
	include	"graphics/text.i"



	code


start:
	bsr	initialize
	beq	1$			;error during init?
	bsr	main			;main loop
1$:	bsr	cleanup			;free all
	moveq	#0,d0
	rts


main:
	move.l	GadtoolsBase,a6
	move.l	usrport,a0
	jsr	GT_GetIMsg(a6)		;fetch next IDCMP-Message
	tst.l	d0
	bne	2$			;deal with it
	move.l	SysBase,a6
	move.l	usrport,a0		;process sleeps until next
	jsr	WaitPort(a6)		; message arrives
	bra	main

2$:	move.l	d0,a1
	move.l	im_Class(a1),d3		;d2 message's IDCMP-Class
	move.w	im_Code(a1),d2		;d3 IDCMP-Code
	move.l	im_IAddress(a1),a2	;a2 object which generated this msg
	jsr	GT_ReplyIMsg(a6)

	cmp.l	#IDCMP_CLOSEWINDOW,d3	;clicked close gadget?
	beq	1$

	cmp.l	#IDCMP_MENUPICK,d3	;picked a menu item?
	bne	3$
	cmp.w	#MENUNULL,d2
	beq	main
	cmp.w	#(NOSUB<<11)|(2<<5)|0,d2 ;menu 0, item 2 : Quit ?
	beq	1$
	move.l	IntBase,a6
	move.l	menuptr,a0
	moveq	#0,d0
	move.w	d2,d0
	jsr	ItemAddress(a6)		;get addr of menu item
	move.l	d0,a0
	moveq	#$1f,d0
	and.w	d2,d0			;d0 menu number
	lsr.w	#5,d2
	moveq	#$3f,d1
	and.w	d3,d1			;d1 menu item number
	lsr.w	#6,d2			;d2 menu sub item number
	bsr	do_menu			;do menu action
3$:	bra	main

1$:	rts


do_menu:
; Perform an action for the selected menu item
; a6 = IntuitionBase
; a0 = MenuItem address
; d0 = menu number
; d1 = menu item number
; d2 = menu sub item number
	cmp.w	#0,d0			;first nenu
	bne	2$
	cmp.w	#0,d1			;and first menu item selected?
	bne	2$
	clr.l	-(sp)			;user picked "About..."
	move.l	winptr,a0
	lea	easyreq_about,a1
	move.l	sp,a2
	move.l	sp,a3
	jsr	EasyRequestArgs(a6)	;display short information
	addq.l	#4,sp
	bra	1$
2$:	cmp.w	#1,d0			;second menu?
	bne	1$
	move.l	mi_ItemFill(a0),a0	;pointer to menu item's name
	move.l	it_IText(a0),-(sp)
	move.l	sp,a3			;pass as an argument for EasyReq
	clr.l	-(sp)
	move.l	sp,a2
	move.l	winptr,a0		;show its name
	lea	easyreq_menupick,a1
	jsr	EasyRequestArgs(a6)
	addq.l	#8,sp
1$:	rts


initialize:
; open all reqiuired libraries, initialize menu and
; open a window on the workbench
; -> d0 = TRUE: ok, FALSE: error
	move.l	4,a6
	move.l	a6,SysBase
	lea	intname(pc),a1
	moveq	#36,d0
	jsr	OpenLibrary(a6)		;intuition.library v36
	move.l	d0,IntBase
	beq	1$
	lea	gadtname(pc),a1
	moveq	#36,d0
	jsr	OpenLibrary(a6)		;gadtools.library v36
	move.l	d0,GadtoolsBase
	beq	1$

	move.l	IntBase,a6
	lea	mywindow,a0
	lea	wintags(pc),a1
	jsr	OpenWindowTagList(a6)	;open a window on the workbench
	move.l	d0,winptr
	beq	1$
	move.l	d0,a2
	move.l	wd_UserPort(a2),usrport	;pointer to windows's IDCMPMsgPort
	move.l	GadtoolsBase,a6
	move.l	wd_WScreen(a2),a0
	sub.l	a1,a1
	jsr	GetVisualInfoA(a6)	;get pointer to VisualInfo
	move.l	d0,vinfo
	beq	1$
	move.l	d0,d7			;d7 VisualInfo
	lea	mymenu,a0
	sub.l	a1,a1			;CreateMenus() makes a real Intu-
	jsr	CreateMenusA(a6)	; ition menu from NewMenu
	move.l	d0,menuptr
	beq	1$
	move.l	menuptr,a0
	move.l	d7,a1
	lea	menutags(pc),a2
	jsr	LayoutMenusA(a6)	;arrange menus and menu entries
	tst.l	d0
	beq	1$
	move.l	IntBase,a6
	move.l	winptr,a0
	move.l	menuptr,a1
	jsr	SetMenuStrip(a6)	;assign menu to window
	tst.l	d0
	beq	1$

	moveq	#-1,d0			;ok, no problems
1$:	rts

wintags:
	dc.l	WA_Checkmark,cmimg
	dc.l	WA_NewLookMenus,1
	dc.l	TAG_DONE
menutags:
	dc.l	GTMN_Checkmark,cmimg
	dc.l	GTMN_NewLookMenus,1
	dc.l	TAG_DONE


cleanup:
; free all allocated resources
	move.l	IntBase,d0
	beq	1$
	move.l	d0,a6
	move.l	winptr,d0
	beq	5$
	move.l	d0,a2
	tst.l	wd_MenuStrip(a2)	;window has a menu attached?
	beq	6$
	move.l	a2,a0
	jsr	ClearMenuStrip(a6)	;remove menu
6$:	move.l	a2,a0
	jsr	CloseWindow(a6)		;close window
5$:	move.l	GadtoolsBase,d0
	beq	2$
	move.l	d0,a6
	move.l	vinfo,d0
	beq	4$
	move.l	d0,a0
	jsr	FreeVisualInfo(a6)	;free screen's VisualInfo
4$:	move.l	menuptr,d0
	beq	3$
	move.l	d0,a0
	jsr	FreeMenus(a6)		;free Menu structure
3$:	move.l	SysBase,a6
	move.l	GadtoolsBase,d0
	beq	2$
	move.l	d0,a1
	jsr	CloseLibrary(a6)	;close gadtools.library
2$:	move.l	SysBase,a6
	move.l	IntBase,d0
	beq	1$
	move.l	d0,a1
	jsr	CloseLibrary(a6)	;close intuition.library
1$:	rts


intname:
	dc.b	"intuition.library",0
gadtname:
	dc.b	"gadtools.library",0



	data


cmimg:					;new Checkmark Image (struct Image)
	dc.w	0,0,15,13,2
	dc.l	cmdata
	dc.b	%00000011		;plane pick
	dc.b	%00000000		;plane on/off
	dc.l	0

mywindow:				;struct NewWindow
	dc.w	16,16,256,128
	dc.b	0,1
; we're waiting for the following IDCMP messages
	dc.l	IDCMP_CLOSEWINDOW|IDCMP_MENUPICK
; window flags
	dc.l	WFLG_ACTIVATE|WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_CLOSEGADGET
	dc.l	0,0,win_title,0,0
	dc.w	128,32,-1,-1,WBENCHSCREEN
win_title:
	dc.b	"Menutest",0
	even


mymenu:					; the menu definition
	dc.b	NM_TITLE,0
	dc.l	menu1_name
	dcb.b	14,0
	dc.b	NM_ITEM,0
	dc.l	m1_item1_name
	dcb.b	14,0
	dc.b	NM_ITEM,0
	dc.l	NM_BARLABEL
	dcb.b	14,0
	dc.b	NM_ITEM,0
	dc.l	m1_item2_name
	dcb.b	14,0

	dc.b	NM_TITLE,0
	dc.l	menu2_name
	dcb.b	14,0
	dc.b	NM_ITEM,0
	dc.l	m2_item1_name
	dcb.b	14,0
	dc.b	NM_ITEM,0
	dc.l	m2_item2_name
	dcb.b	14,0
	dc.b	NM_ITEM,0
	dc.l	m2_item3_name
	dcb.b	14,0
	dc.b	NM_ITEM,0
	dc.l	m2_item4_name
	dcb.b	14,0

	dc.b	NM_TITLE,0
	dc.l	menu3_name
	dcb.b	14,0
	dc.b	NM_ITEM,0
	dc.l	m3_item1_name,0
	dc.w	CHECKIT|MENUTOGGLE
	dc.l	0,0

	dc.b	NM_END

menu1_name:
	dc.b	"Project",0
m1_item1_name:
	dc.b	"About...",0
m1_item2_name:
	dc.b	"Quit",0
menu2_name:
	dc.b	"Test menu",0
m2_item1_name:
	dc.b	"This",0
m2_item2_name:
	dc.b	"is",0
m2_item3_name:
	dc.b	"a",0
m2_item4_name:
	dc.b	"test",0
menu3_name:
	dc.b	"Checkmark",0
m3_item1_name:
	dc.b	"Toggle",0
	even

easyreq_about:	;EasyRequester, refer to intuition/intuition.i
	dc.l	EasyStruct_SIZEOF,0,1$,2$,3$
1$:	dc.b	"About this program...",0
2$:	dc.b	"This is an example for\n"
	dc.b	"programming menus.",0
3$:	dc.b	"Ok|Indeed|So what?",0
	even

easyreq_menupick:
	dc.l	EasyStruct_SIZEOF,0,1$,2$,3$
1$:	dc.b	"A Menu item was picked!",0
2$:	dc.b	"The user selected the menu\n"
	dc.b	"item named \"%s\".",0
3$:	dc.b	"Yes",0
	even



	bss


SysBase:	ds.l	1
IntBase:	ds.l	1
GadtoolsBase:	ds.l	1
menuptr:	ds.l	1
winptr:		ds.l	1
usrport:	ds.l	1
vinfo:		ds.l	1



	section	ImageData,data,chip

cmdata:
	dc.w	%0000011111000000
	dc.w	%0001111111110000
	dc.w	%0011111111111000
	dc.w	%0111111111111100
	dc.w	%1111111111111110
	dc.w	%1111111111111110
	dc.w	%1111111111111110
	dc.w	%1111111111111110
	dc.w	%1111111111111110
	dc.w	%0111111111111100
	dc.w	%0011111111111000
	dc.w	%0001111111110000
	dc.w	%0000011111000000
	dc.w	%1111100000111111
	dc.w	%1110000000001111
	dc.w	%1100000000000111
	dc.w	%1000000000000011
	dc.w	%0000000000000001
	dc.w	%0000000000000001
	dc.w	%0000000000000001
	dc.w	%0000000000000001
	dc.w	%0000000000000001
	dc.w	%1000000000000011
	dc.w	%1100000000000111
	dc.w	%1110000000001111
	dc.w	%1111100000111111


	end
