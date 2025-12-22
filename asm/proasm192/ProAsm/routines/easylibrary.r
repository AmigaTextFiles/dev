
;---;  easylibrary.r  ;--------------------------------------------------------
*
*	****	library open/close handler    ****
*
*	Author		Daniel Weber
*	Version		1.74
*	Last Revision	15.11.93
*	Identifier	ely_defined
*       Prefix		ely_	(easy library)
*				 ¯    ¯     ¯
*	Functions	OpenLibrary, CloseLibrary
*			elh_openlibrary (OpenLibrary),
*			elh_closelibrary (CloseLibrary)
*
*	Note		- base on Rene Eberhard's easylibrary system.
*			- elh_* routines supported for a transparent use of
*			  both (old and new) library handlers.
*			- A small dummy routine will be assembled if no
*			  libraries are selected (moveq #1,d0/rts).
*			- Library version: 'DOS.LIB SET 36' to open dos.library v36.
*
;------------------------------------------------------------------------------
*	Flags
*
*	ely_LARGE	if the library bases are not within a 32Kb range
*	ely_NOALERT	if no build in alert system is requested
*
*		AMIGAGUIDE.LIB   -->	AmigaGuideBase
*		ARP.LIB		 -->	ArpBase
*		ASL.LIB		 -->	AslBase
*		BULLET.LIB	 -->	BulletBase
*		CANDO.LIB	 -->	CanDoBase
*		CX.LIB		 -->	CommoditiesBase (=CxBase)
*		COMMODITIES.LIB	 -->	CommoditiesBase	(=CxBase)
*		DATATYPES.LIB	 -->	DatatypesBase
*		DECRUNCH.LIB	 -->	DecrunchBase
*		DISKFONT.LIB	 -->	DiskFontBase
*		DOS.LIB		 -->	DosBase
*		DOS36.LIB	 -->	DosBase (v36)
*		EXPANSION.LIB	 -->	ExpansionBase
*		EXPLODE.LIB	 -->	ExplodeBase
*		GADTOOLS.LIB	 -->	GadToolsBase
*		GRAPHICS.LIB	 -->	GfxBase
*		ICON.LIB	 -->	IconBase
*		IEEEDOUBBAS.LIB	 -->	IEEEDoubBasBase
*		IEEEDOUBTRANS.LIB-->	IEEEDoubTransBase
*		IEEESINGTRANS.LIB-->	IEEESingTransBase
*		IFF.LIB		 -->	IffBase
*		IFFPARSE.LIB	 -->	IffParseBase
*		INTUITION.LIB	 -->	IntBase
*		KEYMAP.LIB	 -->	KeymapBase
*		LAYERS.LIB	 -->	LayersBase
*		LOCALE.LIB	 -->	LocalBase
*		MATHTRANS.LIB	 -->	MathTransBase
*		NIHONGO.LIB	 -->	NihongoBase (=ngbase)
*		NOFRAG.LIB	 -->	NoFragBase
*		PPACKER.LIB	 -->	PPackerBase
*		PROMMU.LIB	 -->	ProMMUBase
*		REQ.LIB		 -->	ReqBase
*		REXX.LIB	 -->	RexxBase
*		TRANSLATOR.LIB	 -->	TranslatorBase
*		UTILITY.LIB	 -->	UtilBase
*		VERSION.LIB	 -->	VersionBase
*		WORKBENCH.LIB	 -->	WorkbenchBase
*		XPKMASTER.LIB	 -->	XPKMasterBase
*
*		DX.BASE if the bases are extern handled!
*
;------------------------------------------------------------------------------


;------------------
	ifnd	ely_defined
ely_defined	SET	1

;------------------
ely_oldbase	equ __BASE
	base	ely_base
ely_base:

;------------------
	opt	sto,o+,ow-,q+,qw-		;all optimisations on

;------------------

;------------------------------------------------------------------------------
*
* pre-definitions to keep the compatibility with older easylibrary handler
*
;------------------------------------------------------------------------------
	IFD	CX.LIB
COMMODITIES.LIB	SET	1
	ENDC

	IFD	DOS36.LIB
DOS.LIB	SET	36
	ENDC

* check if the library handler is really used

ely_used_	MACRO
	IFD	\1
ely_used	SET	1
	ENDC
	ENDM

	ely_used_	AMIGAGUIDE.LIB
	ely_used_	ARP.LIB
	ely_used_	ASL.LIB
	ely_used_	BULLET.LIB
	ely_used_	CANDO.LIB
	ely_used_	CX.LIB
	ely_used_	COMMODITIES.LIB
	ely_used_	DATATYPES.LIB
	ely_used_	DECRUNCH.LIB
	ely_used_	DISKFONT.LIB
	ely_used_	DOS.LIB
	ely_used_	DOS36.LIB
	ely_used_	EXPANSION.LIB
	ely_used_	EXPLODE.LIB
	ely_used_	GADTOOLS.LIB
	ely_used_	GRAPHICS.LIB
	ely_used_	ICON.LIB
	ely_used_	IEEEDOUBBAS.LIB
	ely_used_	IEEEDOUBTRANS.LIB
	ely_used_	IEEESINGTRANS.LIB
	ely_used_	IFF.LIB
	ely_used_	IFFPARSE.LIB
	ely_used_	INTUITION.LIB
	ely_used_	KEYMAP.LIB
	ely_used_	LAYERS.LIB
	ely_used_	LOCALE.LIB
	ely_used_	MATHTRANS.LIB
	ely_used_	NIHONGO.LIB
	ely_used_	NOFRAG.LIB
	ely_used_	PPACKER.LIB
	ely_used_	PROMMU.LIB
	ely_used_	REQ.LIB
	ely_used_	REXX.LIB
	ely_used_	TRANSLATOR.LIB
	ely_used_	UTILITY.LIB
	ely_used_	VERSION.LIB
	ely_used_	WORKBENCH.LIB
	ely_used_	XPKMASTER.LIB


;------------------------------------------------------------------------------
*
* OpenLibrary
*
* RESULT	D0	NULL if an error occured else <> 0
*		A0	ONLY IF AN ERROR HAS OCCURED, Pointer to LibName
*
*
;------------------------------------------------------------------------------
	IFD	ely_used
elh_openlibrary:
OpenLibrary:
	movem.l	d1-a6,-(a7)		;[!]stack gets patched some lines below
	lea	ely_base(pc),a5
	lea	ely_librarylist(pc),a4
	move.l	4.w,a6

.loop:	moveq	#1,d0			;if an error occured (return value = 1)
	move.w	(a4)+,d1
	beq	.out			;finished
	lea	(a5,d1.w),a1		;name offset
	move.w	(a4)+,d0		;version#
	IFND	ely_LARGE
	move.w	(a4)+,d1
	lea	(a5,d1.w),a3		;base offset
	ELSE
	move.l	(a4)+,a3		;base address
	ENDC
	move.l	a1,a2			;save name for display alert
	jsr	-552(a6)		;_LVOOpenLibrary(a6)
	move.l	d0,(a3)
	bne.s	.loop

;------------------------------------------------
;Show Alert if a library couldn't be opened (routine taken from Eberhards
;easylibrary handler)
;
	IFND	ely_NOALERT

INTUITION.LIB	SET	1

	lea	ely_intuitionname(pc),a1
	jsr	-408(a6)		;_LVOOldOpenLibrary(a6)
	tst.l	d0
	beq.s	\FatalAlert

	move.l	d0,a6			;IntuitionBase
	lea	ely_alertlibtext(pc),a0	;Patch alert text

	moveq	#-1,d0			;Clr char counter
1$	addq.w	#1,d0			;Add char counter
	cmp.w	#29,d0			;more than 29 chars ?
	bge.s	3$			;Yes .. hmm
	move.b	(a2)+,(a0)+
	bne.s	1$
	bra.s	4$

3$	clr.b	(a0)			;NULL byte terminated
4$	lea	ely_alerttext(pc),a0	;Text
	moveq	#0,d0			;Code
	moveq	#56,d1			;Heigth
	jsr	-90(a6)			;_LVODisplayAlert(a6)

	move.l	a6,a1
	move.l	4.w,a6
	jsr	-414(a6)		;_LVOCloseLibrary(a6)
	bra.s	.errexit

\FatalAlert:
	move.l	4.w,a6
	move.l	#$00030000,d7		;open library error
	jsr	-108(a6)		;_LVOAlert(a6)
	ELSE
	move.l	a2,7*4(a7)		;patch A0
	ENDC

.errexit:
	moveq	#0,d0
.out:	movem.l	(a7)+,d1-a6
	tst.l	d0
	rts
	ELSE
OpenLibrary:
elh_openlibrary:
	moveq	#1,d0			;error free return value
CloseLibrary:
elh_closelibrary:
	rts
	ENDC


;------------------------------------------------------------------------------
*
* CloseLibrary
*
;------------------------------------------------------------------------------
	IFD	ely_used
elh_closelibrary:
CloseLibrary:
	movem.l	d0-a6,-(a7)
	lea	ely_base(pc),a5
	lea	ely_librarylist(pc),a4
	move.l	4.w,a6

.loop:	tst.w	(a4)			;no more entries
	beq	.out			;finished
	addq.l	#4,a4			;skip name and version

	IFND	ely_LARGE
	move.w	(a4)+,d1
	lea	(a5,d1.w),a3		;base
	ELSE
	move.l	(a4)+,a3
	ENDC
	tst.l	(a3)
	beq.s	.loop
	move.l	(a3),a1
	jsr	-414(a6)		;_LVOCloseLibrary(a6)
	clr.l	(a3)			;mark it as cleared
	bra.s	.loop
.out:	movem.l	(a7)+,d0-a6
	rts

	ENDC

;------------------------------------------------------------------------------
*
* library handler structure
*
;------------------------------------------------------------------------------
	IFD	ely_used
ely_llentry	MACRO		; dc.w name%,version,(base%|base)
	IFD	\1
	sw	\2%

.ely_val	SET	\1
	IFMI	.ely_val		; negative version number?
.ely_val	SET	-.ely_val	; make positive
	ENDC

	IFLT	30,.ely_val
	dc.w	0
	ELSE
	dc.w	.ely_val
	ENDC

	IFND	ely_LARGE
	sw	\3%
	ELSE
	dc.l	\3
	ENDC

	ENDC
	ENDM


ely_librarylist:
	ely_llentry	AMIGAGUIDE.LIB,ely_amigaguidename,AmigaGuideBase
	ely_llentry	ARP.LIB,ely_arpname,ArpBase
	ely_llentry	ASL.LIB,ely_aslname,AslBase
	ely_llentry	BULLET.LIB,ely_bulletname,BulletBase
	ely_llentry	CANDO.LIB,ely_candoname,CandoBase
	ely_llentry	COMMODITIES.LIB,ely_commoditiesname,CxBase
	ely_llentry	DATATYPES.LIB,ely_datatypesname,DatatypesBase
	ely_llentry	DECRUNCH.LIB,ely_decrunchname,DecrunchBase
	ely_llentry	DISKFONT.LIB,ely_diskfontname,DiskFontBase
	ely_llentry	DOS.LIB,ely_dosname,DosBase
	ely_llentry	EXPANSION.LIB,ely_expansionname,ExpansionBase
	ely_llentry	EXPLODE.LIB,ely_explodename,ExplodeBase
	ely_llentry	GADTOOLS.LIB,ely_gadtoolsname,GadToolsBase
	ely_llentry	GRAPHICS.LIB,ely_gfxname,GfxBase
	ely_llentry	ICON.LIB,ely_iconname,IconBase
	ely_llentry	IEEEDOUBBAS.LIB,ely_ieeedoubbasname,IEEEDoubBasBase
	ely_llentry	IEEEDOUBTRANS.LIB,ely_ieeedoubtransname,IEEEDoubTransBase
	ely_llentry	IEEESINGTRANS.LIB,ely_ieeesingtransname,IEEESingTransBase
	ely_llentry	IFF.LIB,ely_iffname,IffBase
	ely_llentry	IFFPARSE.LIB,ely_iffparsename,IffParseBase
	ely_llentry	INTUITION.LIB,ely_intuitionname,IntBase
	ely_llentry	KEYMAP.LIB,ely_keymapname,KeymapBase
	ely_llentry	LAYERS.LIB,ely_layersname,LayersBase
	ely_llentry	LOCALE.LIB,ely_localename,LocalBase
	ely_llentry	MATHTRANS.LIB,ely_mathtransname,MathTransBase
	ely_llentry	NIHONGO.LIB,ely_nihongoname,NihongoBase
	ely_llentry	NOFRAG.LIB,ely_nofragname,NoFragBase
	ely_llentry	PPACKER.LIB,ely_ppackername,PPackerBase
	ely_llentry	PROMMU.LIB,ely_prommuname,ProMMUBase
	ely_llentry	REQ.LIB,ely_reqname,ReqBase
	ely_llentry	REXX.LIB,ely_rexxname,RexxBase
	ely_llentry	TRANSLATOR.LIB,ely_translatorname,TranslatorBase
	ely_llentry	UTILITY.LIB,ely_utilityname,UtilBase
	ely_llentry	VERSION.LIB,ely_versionname,VersionBase
	ely_llentry	WORKBENCH.LIB,ely_workbenchname,WorkbenchBase
	ely_llentry	XPKMASTER.LIB,ely_xpkmastername,XPKMasterBase
	dc.w	0						;end sign
	ENDC

;------------------------------------------------------------------------------
*
* library names
*
;------------------------------------------------------------------------------
	IFD AMIGAGUIDE.LIB
ely_amigaguidename:	dc.b	"amigaguide.library",0
	ENDC

	IFD ARP.LIB
ely_arpname:		dc.b	"arp.library",0
	ENDC

	IFD ASL.LIB
ely_aslname:		dc.b	"asl.library",0
	ENDC

	IFD BULLET.LIB
ely_bulletname:		dc.b	"bullet.library",0
	ENDC

	IFD CANDO.LIB
ely_candoname:		dc.b	"cando.library",0
	ENDC

	IFD COMMODITIES.LIB
ely_commoditiesname:	dc.b	"commodities.library",0
	ENDC

	IFD DATATYPES.LIB
ely_datatypesname:	dc.b	"datatypes.library",0
	ENDC

	IFD DECRUNCH.LIB
ely_decrunchname:	dc.b	"decrunch.library",0
	ENDC

	IFD DISKFONT.LIB
ely_diskfontname:	dc.b	"diskfont.library",0
	ENDC

	IFD DOS.LIB
ely_dosname:		dc.b	"dos.library",0
	ENDC

	IFD EXPANSION.LIB
ely_expansionname:	dc.b	"expansion.library",0
	ENDC

	IFD EXPLODE.LIB
ely_explodename:	dc.b	"explode.library",0
	ENDC

	IFD GADTOOLS.LIB
ely_gadtoolsname:	dc.b	"gadtools.library",0
	ENDC

	IFD GRAPHICS.LIB
ely_gfxname:		dc.b	"graphics.library",0
	ENDC

	IFD ICON.LIB
ely_iconname:		dc.b	"icon.library",0
	ENDC

	IFD IEEEDOUBBAS.LIB
ely_ieeedoubbasname:	dc.b	"mathieeedoubbas.library",0
	ENDC

	IFD IEEEDOUBTRANS.LIB
ely_ieeedoubtransname:	dc.b	"mathieeedoubtrans.library",0
	ENDC

	IFD IEEESINGTRANS.LIB
ely_ieeesingtransname:	dc.b	"mathieeesingtrans.library",0
	ENDC

	IFD IFF.LIB
ely_iffname:		dc.b	"iff.library",0
	ENDC

	IFD IFFPARSE.LIB
ely_iffparsename:	dc.b	"iffparse.library",0
	ENDC

	IFD INTUITION.LIB		;always be defined for 'Alert'
ely_intuitionname:	dc.b	"intuition.library",0
	ENDC

	IFD KEYMAP.LIB
ely_keymapname:		dc.b	"keymap.library",0
	ENDC

	IFD LAYERS.LIB
ely_layersname:		dc.b	"layers.library",0
	ENDC

	IFD LOCALE.LIB
ely_localename:		dc.b	"locale.library",0
	ENDC

	IFD MATHTRANS.LIB
ely_mathtransname:	dc.b	"mathtrans.library",0
	ENDC

	IFD NIHONGO.LIB
ely_nihongoname:	dc.b	"nihongo.library",0
	ENDC

	IFD NOFRAG.LIB
ely_nofragname:		dc.b	"nofrag.library",0
	ENDC

	IFD PPACKER.LIB
ely_ppackername:	dc.b	"powerpacker.library",0
	ENDC

	IFD PROMMU.LIB
ely_prommuname:		dc.b	"prommu.library",0
	ENDC

	IFD REQ.LIB
ely_reqname:		dc.b	"req.library",0
	ENDC

	IFD REXX.LIB
ely_rexxname:		dc.b	"rexxsyslib.library",0
	ENDC

	IFD TRANSLATOR.LIB
ely_translatorname:	dc.b	"translator.library",0
	ENDC

	IFD UTILITY.LIB
ely_utilityname:	dc.b	"utility.library",0
	ENDC

	IFD VERSION.LIB
ely_versionname:	dc.b	"version.library",0
	ENDC

	IFD WORKBENCH.LIB
ely_workbenchname:	dc.b	"workbench.library",0
	ENDC

	IFD XPKMASTER.LIB
ely_xpkmastername:	dc.b	"xpkmaster.library",0
	ENDC

	even

;------------------------------------------------------------------------------
*
* bases
*
;------------------------------------------------------------------------------
	IFND DX.BASE

ely_libbase_	MACRO
	IFD	\1
;*	IFND	\2			;was not a good idea
\2:	dc.l	0
;*	ENDC
	ENDC
	ENDM

ely_libbase2_	MACRO
	IFD	\1			;special handling for the support
;*	IFND	\2			;of two names
;*	IFND	\3
\3:
\2:	dc.l	0
;*	ENDC
;*	ENDC

	IFD	\2
	IFND	\3
\3:	EQU	\2
	ENDC
	ELSE
	IFD	\3
\2:	EQU	\3
	ENDC
	ENDC

	ENDC
	ENDM




	ely_libbase_	AMIGAGUIDE.LIB,AmigaGuideBase
	ely_libbase_	ARP.LIB,ArpBase
	ely_libbase_	ASL.LIB,AslBase
	ely_libbase_	BULLET.LIB,BulletBase
	ely_libbase_	CANDO.LIB,CanDoBase
	ely_libbase2_	COMMODITIES.LIB,CommoditiesBase,CxBase
	ely_libbase_	DATATYPES.LIB,DatatypesBase
	ely_libbase_	DECRUNCH.LIB,DecrunchBase
	ely_libbase_	DISKFONT.LIB,DiskFontBase
	ely_libbase_	DOS.LIB,DosBase
	ely_libbase_	DOS36.LIB,DosBase
	ely_libbase_	EXPANSION.LIB,ExpansionBase
	ely_libbase_	EXPLODE.LIB,ExplodeBase
	ely_libbase_	GADTOOLS.LIB,GadToolsBase
	ely_libbase_	GRAPHICS.LIB,GfxBase
	ely_libbase_	ICON.LIB,IconBase
	ely_libbase_	IEEEDOUBBAS.LIB,IEEEDoubBasBase
	ely_libbase_	IEEEDOUBTRANS.LIB,IEEEDoubTransBase
	ely_libbase_	IEEESINGTRANS.LIB,IEEESingTransBase
	ely_libbase_	IFF.LIB,IffBase
	ely_libbase_	IFFPARSE.LIB,IffParseBase
	ely_libbase_	INTUITION.LIB,IntBase
	ely_libbase_	KEYMAP.LIB,KeymapBase
	ely_libbase_	LAYERS.LIB,LayersBase
	ely_libbase_	LOCALE.LIB,LocaleBase
	ely_libbase_	MATHTRANS.LIB,MathTransBase
	ely_libbase2_	NIHONGO.LIB,NihongoBase,ngbase
	ely_libbase_	NOFRAG.LIB,NoFragBase
	ely_libbase_	PPACKER.LIB,PPackerBase
	ely_libbase_	PROMMU.LIB,ProMMUBase
	ely_libbase_	REQ.LIB,ReqBase
	ely_libbase_	REXX.LIB,RexxBase
	ely_libbase_	TRANSLATOR.LIB,TranslatorBase
	ely_libbase_	UTILITY.LIB,UtilBase
	ely_libbase_	VERSION.LIB,VersionBase
	ely_libbase_	WORKBENCH.LIB,WorkbenchBase
	ely_libbase_	XPKMASTER.LIB,XPKMasterBase

	ENDC

;------------------------------------------------------------------------------
*
* Data & Texts etc...
*
;------------------------------------------------------------------------------
	IFD	ely_used
	IFND	ely_NOALERT
ely_alerttext:
	dc.b	0,32,18,gea_progname,0,-1
	dc.b	0,32,30,"Fatal error occured: "
	dc.b	"Unable to open "
ely_alertlibtext:
	ds.b	30,-1				;ATTENTION: Only 29 entrys
	dc.b	0,-1
	dc.b	0,32,42,"Press left mouse button to continue"
	dc.b	0,0
	even
	ENDC
	ENDC

;------------------------------------------------------------------------------
	base	ely_oldbase

;------------------
	opt	rcl

;------------------
	endif

	end

