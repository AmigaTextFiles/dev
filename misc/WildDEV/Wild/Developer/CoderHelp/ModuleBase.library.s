
; To have a working module:
; Search MODB_ and replace with ??_ (?? is the prefix of your moduledata struct)
; Search MODULETYPE and replace with the type (Display,Broker,Draw,Light,..)
; Change the LIBRARY name and BASE (w?m_SIZEOF, even if NOW are all the same)
; Add some more specific includes
; Add the tags you support at the list (find Supported)
; Set correctly the TYPES (A-H) :

; NB: I default provide the TrackRefresh system, but you can eliminate if you want.

; REMEMBER TO ADD THE SPECIFIC FUNCS EVEN IN THE LIST BELOW ! (*!*)

		include	WildInc.gs
		include	Wild/wild.i
		include PyperLibMaker.i
		include	PyperMacro.i
		include	Wild/modules_macros.i

MODTYPES1	EQU	TYPEA_FULLCOMPATIBLE<<24+TYPEB_FULLCOMPATIBLE<<16+TYPEC_FULLCOMPATIBLE<<8+TYPED_FULLCOMPATIBLE
MODTYPES2	EQU	TYPEE_FULLCOMPATIBLE<<24+TYPEF_FULLCOMPATIBLE<<16+TYPEG_FULLCOMPATIBLE<<8+TYPEH_FULLCOMPATIBLE

		Lib	ModuleBase,1,0,18.7.1998,wdm_SIZEOF
		Lib	FUNCTIONS
		Lib	OpenLib
		Lib	CloseLib
		Lib	ExpugneLib
		Lib	ExtFuncLib

		Lib	SetModuleTags
		Lib	GetModuleTags
		Lib	SetUpModule
		Lib	CloseModule
		Lib	RefreshModule
						;HERE!	      (*!*)
		Lib	CODE

		Lib	Init
		exg	a0,d0
		move.l	d0,LIB_SIZE(a0)
		move.l	#MODTYPES1,wm_Types(a0)
		move.l	#MODTYPES2,wm_Types+4(a0)
		clr.w	wm_CNT(a0)
		
		; Here you can do the First init !
		; Take care !!! Preserve A0(LibBase) and D0(Don'tKnow)
		
		exg	a0,d0
		rts

		Lib	OpenLib
		add.w	#1,LIB_OPENCNT(a6)
		bset	#LIBB_DELEXP,LIB_FLAGS(a6)	; MODULES DEFAULT ARE WANTED TO FREE THEIR MEMORY WHEN CLOSED SO THE EXPUGNE FLAG IS SET ,USUALLY. CLEAR IT ONLY IF REALLY NEEDED.
		
		; Here you can do any init you want, but take care: EVERY time the
		; lib is opened, this init is done. The first time-only init is
		; in the Init routine
		
		move.l	a6,d0
		rts

		Lib	CloseLib
		subq.w	#1,LIB_OPENCNT(a6)
		bne.b	ExtFuncLib
		btst	#LIBB_DELEXP,LIB_FLAGS(a6)
		beq.b	ExtFuncLib

		Lib	ExpugneLib
		movem.l	d2/a5/a6,-(sp)
		tst.w	LIB_OPENCNT(a6) 
		bne.b	.still_openned

		;On this place free all resources which has been
		;allocated in init part. a6 contain library base.

		move.l	LIB_SIZE(a6),d2
		move.l	a6,a5
		move.l	4.w,a6
		move.l	a5,a1
		jsr	_LVORemove(a6)
		move.l	a5,a1
		moveq	#0,d0
		move.w	LIB_NEGSIZE(a5),d0
		sub.w	d0,a1
		add.w	LIB_POSSIZE(a5),d0
		jsr	_LVOFreeMem(a6)
		move.l	d2,d0
		movem.l	(sp)+,d2/a5/a6
		rts
.still_openned
		Lib	ExtFuncLib
		moveq	#0,d0
		rts

Supported	dc.l	WIDI_Screen,0	; Tag,Default
SupportedEnd	dc.l	TAG_DONE	; Taglist of supported tags.

		include	include/wild/modules_refreshtrack.i

		Lib	SetModuleTags	; a0:app,a1:Tags
		movem.l	a2-a6,-(a7)
		movea.l	a0,a5
		movea.l	wap_EngineData+we_MODULETYPE(a5),a4	; a4:moddata
		movea.l	a1,a3
		lea.l	MODB_TrackRefresh(a4),a2
		movea.l	wm_WildBase(a6),a6
		movea.l	wi_UtilityBase(a6),a6
		bsr	TrackRefresh
		or.l	#WAF_RefreshEngine,wap_Flags(a5)
		
		; DO NOT GET ANY TAG VALUE HERE from wt_Tags: they may change.
		; GET ONLY THE CHANGED TAGS, AND IF YOU NEED TO CHANGE
		; SOME TAGS IN wt_Tags, DO IT NOW, DIRECTLY, NOT CALLING
		; WILD'S SetWAppTags!
		; Example: you are a displaymodule, and need to round the width
		; of the view: do it now, call FindTagItem and change ti_Data.
		; Or use my SetTagData macro.
		
		movem.l	(a7)+,a2-a6		
		rts
		
		Lib	GetModuleTags
		rts
		
		Lib	SetUpModule		; A0:App,A1:Tags
		movem.l	a2-a6,-(a7)
		movea.l	a0,a5			; a5:WApp
		movea.l	a1,a4			; A4:Tags
		movea.l	wm_WildBase(a6),a6	; A6:WildBase
		move.l	#MODB_SIZEOF,d0
		AllocFastByWapp	a5,WILD
		move.l	d0,wap_EngineData+we_MODULETYPE(a5)
		movea.l	d0,a3			; A3:ModData
		lea.l	MODB_TrackRefresh(a3),a2
		movea.l	wi_UtilityBase(a6),a6
		bsr	InitTrack

		; Here do the APPLICATION SPECIFIC INITIALIZATION!	
		
		movem.l	(a7)+,a2-a6					
		rts
		
		Lib	CloseModule		; a0:App
		movem.l	a2-a6,-(a7)
		movea.l	a0,a5			; a5:wapp
		movea.l	wap_EngineData+we_MODULETYPE(a5),a3	; a3:moddata
		lea.l	MODB_TrackRefresh(a3),a2
		movea.l	wm_WildBase(a6),a6
		movea.l	wi_UtilityBase(a6),a6
		bsr	FreeTrack

		; Here free all for THIS APPLICATION

		move.l	a3,a1
		movea.l	wap_WildBase(a5),a6
		Call	FreeVecPooled				
		movem.l	(a7)+,a2-a6
		rts
		
		Lib	RefreshModule		; A0:Wapp
		movem.l	a2-a6,-(a7)
		movea.l	a0,a5			; A5:Wapp
		movea.l	wm_WildBase(a6),a6
		movea.l	wi_UtilityBase(a6),a6
		movea.l	wap_EngineData+we_MODULETYPE(a5),a3	; a3:moddata
		lea.l	MODB_TrackRefresh(a3),a2
		bsr	HaveChanges		; A0:Changed tags.s TO FREE !!!!
		movea.l	a0,a4			; A4:Changed tags
		
		; Here REFRESH UP THE MODULE, changing according to the new tags (a4, contains the FILTERED TAGLIST OF THE NEW CHANGES)
		; The value of all the tags are in wa_Tags(a5)
		; IF YOU HAVE TO GET SOME TAGS, DO IT HERE, NOT IN SetModuleTags!
		; Because, after the SetModuleTags, all other modules may change the tags
		; on the fly, before the next RefreshModule. (example, a display module may
		; need to round to 32 multiple the width, so if you get the width in 
		; SetModuleTags, you don't know if it is the definitive (rounded) width
		; of the first.)
		; DO NOT CHANGE ANY TAG IN wt_Tags HERE !!! YOU MUST DO IN SetModuleTags!!
				
		movea.l	wap_WildBase(a5),a6
		movea.l	wi_UtilityBase(a6),a6
		movea.l	a4,a0
		Call	FreeTagItems
		lea.l	MODB_TrackRefresh(a3),a2
		bsr	ReInitTrack
		movem.l	(a7)+,a2-a6
		rts
			
		; Specific module funcs here!	

		Lib	END