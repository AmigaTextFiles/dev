
;---;  AppIcon.r  ;------------------------------------------------------------
*
*	****	AppIcon support routines    ****
*
*	Author		Daniel Weber
*	Version		1.00
*	Last Revision	12.11.93
*	Identifier	app_defined
*       Prefix		app_	(AppIcon)
*				 ¯¯¯
*	Functions	InitAppIconImage	(CALL_)
*			InitAppIcon		(bsr)
*			RemAppIcon		(bsr)
*			OnAppIcon		(bsr)
*			OffApIcon		(bsr)
*
*	Notes		- the workbench.library and icon.library must already
*			  be open.
*			- every pointer etc. is stored in my AppIcon Structure
*			- InitAppIconImage needs cws_wbmessage (from startup4.r)
*
;------------------------------------------------------------------------------

	IFND	app_defined
app_defined	SET	1

;------------------
app_oldbase	EQU __BASE
	base	app_base
app_base:

;------------------
	opt	sto,o+,ow-,q+,qw-		;all optimisations on


;------------------
	incdir	'include:','routines:'
	include	ports.r
	include	structs.r



;------------------------------------------------------------------------------
*
* InitAppIconImage	- Initialize AppIcon Image
*
* Grap the current icon assigned to 'this' program.
*
* INPUT:	A0	AppIcon Structure (AppIconStruct_ from Structs.r)
*
* RESULT:	D0	Pointer to Image buffer or zero if failed
*
* NOTE:		This routines changes the main structure datas only if
*		it didn't failed.
*
;------------------------------------------------------------------------------

	IFD	xxx_InitAppIconImage
InitAppIconImage:
	movem.l	d0-a6,-(a7)
	clr.l	(a7)				;faked return value (error)
	move.l	a0,a4
	moveq	#0,d7
	moveq	#0,d4
	move.l	cws_homedir(pc),d1		;homedir support
	move.l	cws_wbmessage(pc),d0
	beq	.out
	move.l	d0,a3
	move.l	36(a3),d0			;sm_ArgList
	beq	.out
	move.l	d0,a3
	move.l	(a3),d1				;wa_Lock
.cd:	move.l	DosBase(pc),a6
	jsr	-126(a6)			;_LVOCurrentDir
	move.l	d0,d7
	move.l	4(a3),a0			;wa_Name
	move.l	IconBase(pc),a6
	jsr	-132(a6)		;_LVOGetDiskObjectNew (get .info file)
	exg	d0,d7
	move.l	d0,d1				;oldlock
	move.l	DosBase(pc),a6
	jsr	-126(a6)			;_LVOCurrentDir
	move.l	d7,d4				;d4: DiskObject
	beq.s	.out

	move.l	d7,a0
	move.l	18+4(a0),a3			;gg_GadgetRender +do_gadget
	move.w	4(a3),d0			;ig_Width
	move.w	6(a3),d6			;ig_Height
	move.w	d0,d5
	addq.l	#7,d0
	addq.l	#8,d0
	and.b	#$f0,d0
	mulu	d6,d0
	lsr.l	#3,d0
	mulu	8(a3),d0			;*depth (word*word, should be ok)
	move.l	d0,d7
	beq.s	.out				;no image dimensions (?)
	moveq	#20,d1				;ig_SIZEOF
	add.l	d1,d0
	move.l	#$10002,d1			;memf_chip + memf_clear
	move.l	4.w,a6
	jsr	-684(a6)			;AllocVec()	
	move.l	d0,a1
	move.l	a1,d0
	beq.s	.out

	movem.w	d5/d6,4(a1)			;set width and height
	move.w	8(a3),8(a1)			;depth
	move.b	14(a3),14(a1)			;PlanePic
	move.l	10(a3),a3			;ImageData
	lea	20(a1),a1			;ig_SIZEOF
	move.l	a1,-20+10(a1)			;ImageData

.loop:	move.b	(a3)+,(a1)+			;copy image
	subq.l	#1,d7
	bne.s	.loop

	movem.w	d5/d6,app_ai_Width(a4)
	move.l	d0,app_ai_pic(a4)		;gg_GadgetRender

	move.l	d0,app_AppImage(a4)
	move.l	d0,(a7)				;set return value
.out:	tst.l	d4
	beq.s	.done
	move.l	d4,a0
	move.l	IconBase(pc),a6
	jsr	_LVOFreeDiskObject(a6)
.done:	movem.l	(a7)+,d0-a6
	rts
	ENDC


;------------------------------------------------------------------------------
*
* InitAppIcon	- Initialize an AppIcon
*
* INPUT:	A0	AppIcon Structure (AppIconStruct_ from Structs.r)
*		A1	Message Port Structure (use PortStruct_ from Structs.r)
*
* RESULT:	D0	AppIcon Message Port or zero if failed (CCR)
*
;------------------------------------------------------------------------------

InitAppIcon:
	movem.l	d2-a6,-(a7)
	exg	a0,a1
	bsr	MakePort
	move.l	d0,app_AppPort(a1)
	beq.s	\error
	move.l	d0,a2
	clr.b	LN_PRI(a2)
	clr.l	LN_NAME(a2)
	move.l	a2,d0
\error:	movem.l	(a7)+,d2-a6
	rts



;------------------------------------------------------------------------------
*
* RemAppIcon	- Remove an AppIcon
*
* INPUT:	A0	AppIcon Structure (AppIconStruct_ from Structs.r)
*
* RESULT:	none
*
;------------------------------------------------------------------------------

RemAppIcon:
	movem.l	d0-a6,-(a7)
	move.l	a0,a2
	bsr	OffAppIcon			;remove AppIcon
	move.l	app_AppPort(a2),d0
	beq.s	1$
	move.l	d0,a0
	bsr	UnMakePort			;free Port
1$:	clr.l	app_AppPort(a2)
	move.l	app_AppImage(a2),d0
	beq.s	2$
	move.l	d0,a1				;free Image Buffer
	move.l	4.w,a6
	jsr	-690(a6)			;FreeVec()
2$:	movem.l	(a7)+,d0-a6
	rts



;------------------------------------------------------------------------------
*
* OnAppIcon	- Display AppIcon
*
* INPUT:	D0	id (this variable is strictly for your own use and is
*			    ignored by workbench)
*		D1	userdata (only for your own use - see above)
*		A0	AppIcon Structure (AppIconStruct_ from Structs.r)
*
* RESULT:	D0	AppIcon Structure or zero if failed (CCR)
*
;------------------------------------------------------------------------------

OnAppIcon:
	movem.l	d1-a6,-(a7)
	move.l	a0,a4
	lea	app_AppText(a4),a0		;icon text
	move.l	app_AppPort(a4),d0
	beq.s	1$
	move.l	d0,a1				;msgport
	sub.l	a2,a2				;no lock
	lea	app_AppIconDef(a4),a3		;diskobj
	move.l	a4,-(a7)
	sub.l	a4,a4				;no tag list
	move.l	WorkbenchBase(pc),a6
	jsr	-60(a6)				;AddAppIconA
	move.l	(a7)+,a4
	move.l	d0,app_AppIcon(a4)
	beq.s	1$
	move.l	a4,d0
1$:	movem.l	(a7)+,d1-a6
	rts



;------------------------------------------------------------------------------
*
* OffAppIcon	- Remove AppIcon from Workbench
*
* INPUT:	A0	AppIcon Structure (AppIconStruct_ from Structs.r)
*
* RESULT:	none
*
;------------------------------------------------------------------------------

OffAppIcon:
	movem.l	d0-a6,-(a7)
	move.l	a0,a4
	move.l	app_AppIcon(a4),d0
	beq.s	1$
	move.l	d0,a0
	move.l	WorkbenchBase(pc),a6
	jsr	-66(a6)			;RemoveAppIcon()
	clr.l	app_AppIcon(a4)
1$:	movem.l	(a7)+,d0-a6
	rts


;--------------------------------------------------------------------

	base	app_oldbase
	opt	rcl

;------------------
	ENDIF

 end

