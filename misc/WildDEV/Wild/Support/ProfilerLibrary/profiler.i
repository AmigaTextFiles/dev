	include	exec/types.i
	include	exec/lists.i
	include	exec/libraries.i
	include	exec/exec_lib.i
	include	libraries/dos_lib.i
	include	dos/dos.i
	
	STRUCTURE	ProfilerBase,LIB_SIZE+4
		LONG	prob_UtilityBase
		LONG	prob_DOSBase
		LABEL	prob_SIZEOF


	STRUCTURE	ProfilerHandler,0
		APTR	ph_Pool			; memory pool
		APTR	ph_Name			; name of the profiler session !
		APTR	ph_TimerBase		; opened for every task !
		APTR	ph_TimerIO		; to open the device !
		APTR	ph_TimerMSG		; msg port of the iorequest !
		STRUCT	ph_EventList,MLH_SIZE	; events. must be sorted in time.
		APTR	ph_NextEvent		; next event to happen.
		APTR	ph_Output		; output filehandle.
		STRUCT	ph_LastShot,8		; last event reached in that moment.
		LONG	ph_Cycles		; number of cycles
		LABEL	ph_SIZEOF
	
	STRUCTURE	ProfilerEvent,MLN_SIZE
		STRUCT	pe_ETime,8		; last time happened...
		APTR	pe_Name			; name of the event
		STRUCT	pe_Duration,8		; the duration: time from the predent start
		STRUCT	pe_Sum,8		; sum of all cycles.
		LABEL	pe_SIZE

_LVOCreateProfilerHandler	EQU	-30	; a0:tags	ret: d0:ph
_LVODeleteProfilerHandler	EQU	-36	; a0:ph		ret:
_LVOAddEvent			EQU	-42	; a0:ph a1:tags	ret: pe
_LVORemEvent			EQU	-48	; a0:ph a1:pe	ret:
_LVONewCycle			EQU	-54	; a0:ph	
_LVOEventReached		EQU	-60	; a0:ph
_LVOEndCycle			EQU	-66	; a0:ph
_LVOCreateLog			EQU	-72	; a0:ph a1:Tags	ret: success

PROF_TAGBASE	EQU	$801EAA00

PRF_Name	EQU	PROF_TAGBASE+1	; name of handler or event
PRF_EventsArray	EQU	PROF_TAGBASE+2	; fast way to load events: a 0 terminated array pointing to names of events.
PRF_Output	EQU	PROF_TAGBASE+3	; a output fh, for logs. 

; CreateProfilerHandler needs PRF_Name. Optional: EventsArray & Output
; AddEvent needs PRF_Name.
; ***IMPORTANT!*** NO PRF_EventsArray management: that's only for CreateProfilerHandles.
; CreateLog needs PRF_Output if you haven't specified in CreateProfilerHandler

	IFND	FLAG_PROFILE
FLAG_PROFILE	SET	1		; that flag activates or eliminates the profiling
	ENDC

PIArrayEntry	MACRO	;\1:name
		IFNC	'','\1'
		dc.l	.ea\1
		ENDC
		ENDM

PINameEntry	MACRO	;\1:name
		IFNC	'','\1'
.ea\1		dc.b	'\1',0
		ENDC
		ENDM

ProfilerOpen	MACRO				; only opens the lib
		IFNE	FLAG_PROFILE
		movem.l	d0-d1/a0-a1/a6,-(a7)
		movea.l	4.w,a6
		lea.l	proname,a1
		moveq.l	#0,d0
		jsr	_LVOOpenLibrary(a6)
		move.l	d0,_ProBase
		bra	op\@
_ProBase	dc.l	0
proname		dc.b	'profiler.library',0
		cnop	0,4
op\@		movem.l	(a7)+,d0-d1/a0-a1/a6
		ENDC
		ENDM
		
ProfilerQuit	MACRO
		IFNE	FLAG_PROFILE
		movem.l	d0-d1/a0-a1/a6,-(a7)
		movea.l	4.w,a6
		movea.l	_ProBase,a1
		jsr	_LVOCloseLibrary(a6)
		movem.l	(a7)+,d0-d1/a0-a1/a6
		ENDC
		ENDM

;example: ProfilerInit.TestApp Event1,Event2,Event3

ProfilerInit	MACRO			; \0 is the name!!! args:\1-\i names of events!
		IFNE	FLAG_PROFILE
		tst.l	_ProHandle
		bne	no\@
		movem.l	d0-d1/a0-a1/a6,-(a7)	
		movea.l	4.w,a6
		lea.l	proname,a1
		moveq.l	#0,d0
		jsr	_LVOOpenLibrary(a6)
		move.l	d0,_ProBase
		beq	pi\@
		movea.l	d0,a6
		lea.l	prtags\@,a0
		jsr	_LVOCreateProfilerHandler(a6)
		move.l	d0,_ProHandle
		bra	pi\@
_ProHandle	dc.l	0
_ProBase	dc.l	0
prtags\@	dc.l	PRF_Name,tname\@
		dc.l	PRF_EventsArray,evarray\@
		dc.l	0,0
evarray\@	PIArrayEntry	\1
		PIArrayEntry	\2
		PIArrayEntry	\3
		PIArrayEntry	\4
		PIArrayEntry	\5
		PIArrayEntry	\6
		PIArrayEntry	\7
		PIArrayEntry	\8
		PIArrayEntry	\9
		PIArrayEntry	\a
		PIArrayEntry	\b
		PIArrayEntry	\c
		PIArrayEntry	\d
		PIArrayEntry	\e
		PIArrayEntry	\f
		PIArrayEntry	\g
		PIArrayEntry	\h
		PIArrayEntry	\i
		dc.l	0		
		PINameEntry	\1
		PINameEntry	\2
		PINameEntry	\3
		PINameEntry	\4
		PINameEntry	\5
		PINameEntry	\6
		PINameEntry	\7
		PINameEntry	\8
		PINameEntry	\9
		PINameEntry	\a
		PINameEntry	\b
		PINameEntry	\c
		PINameEntry	\d
		PINameEntry	\e
		PINameEntry	\f
		PINameEntry	\g
		PINameEntry	\h
		PINameEntry	\i
tname\@		dc.b	'\0',0
proname		dc.b	'profiler.library',0
		cnop	0,4
pi\@		movem.l	(a7)+,d0-d1/a0-a1/a6
no\@
		ENDC
		ENDM		

ProfilerStore	MACRO	; ea
		IFNE	FLAG_PROFILE
		move.l	_ProHandle,\1
		ENDC
		ENDM

ProfilerCycle	MACRO
		IFNE	FLAG_PROFILE
		movem.l	d0-d1/a0-a1/a6,-(a7)
		movea.l	_ProBase,a6
		IFC	'','\1'
		movea.l	_ProHandle,a0
		ELSE
		movea.l	\1,a0
		ENDC
		jsr	_LVONewCycle(a6)
		movem.l	(a7)+,d0-d1/a0-a1/a6
		ENDC
		ENDM

ProfilerEvent	MACRO
		IFNE	FLAG_PROFILE
		movem.l	d0-d1/a0-a1/a6,-(a7)
		movea.l	_ProBase,a6
		IFC	'','\1'
		movea.l	_ProHandle,a0
		ELSE
		movea.l	\1,a0
		ENDC
		jsr	_LVOEventReached(a6)
		movem.l	(a7)+,d0-d1/a0-a1/a6
		ENDC
		ENDM

ProfilerEnd	MACRO
		IFNE	FLAG_PROFILE
		movem.l	d0-d1/a0-a1/a6,-(a7)
		movea.l	_ProBase,a6
		IFC	'','\1'
		movea.l	_ProHandle,a0
		ELSE
		movea.l	\1,a0
		ENDC
		jsr	_LVOEndCycle(a6)
		movem.l	(a7)+,d0-d1/a0-a1/a6
		ENDC
		ENDM

ProfilerClose	MACRO
		IFNE	FLAG_PROFILE
		movem.l	d0-d1/a0-a1/a6,-(a7)
		movea.l	_ProBase,a6
		IFC	'','\1'
		movea.l	_ProHandle,a0
		ELSE
		movea.l	\1,a0
		ENDC
		jsr	_LVODeleteProfilerHandler(a6)
		movea.l	a6,a1
		movea.l	4.w,a6
		jsr	_LVOCloseLibrary(a6)
		movem.l	(a7)+,d0-d1/a0-a1/a6
		ENDC
		ENDM

ProfilerLog	MACRO	; \1=filename
		IFNE	FLAG_PROFILE
		movem.l	d0-d2/a0-a1/a5-a6,-(a7)
		movea.l	4.w,a6
		lea.l	dosname\@,a1
		moveq.l	#36,d0
		jsr	_LVOOpenLibrary(a6)
		tst.l	d0
		beq	no\@
		movea.l	d0,a6			; a6:dosbase
		movea.l	d0,a5			; a5:dosbase
		IFC	'','\1'
		jsr	_LVOOutput(a6)
		ELSE
		move.l	#outname\@,d1
		move.l	#MODE_NEWFILE,d2
		jsr	_LVOOpen(a6)
		ENDC
		move.l	d0,outfh\@
		movea.l	_ProBase,a6
		movea.l	_ProHandle,a0
		lea.l	logtags\@,a1
		jsr	_LVOCreateLog(a6)
		IFNC	'','\1'
		move.l	outfh\@,d1
		movea.l	a5,a6
		jsr	_LVOClose(a6)
		ENDC
		movea.l	a5,a1
		movea.l	4.w,a6
		jsr	_LVOCloseLibrary(a6)
		bra	no\@
logtags\@	dc.l	PRF_Output
outfh\@		dc.l	0
		dc.l	0,0
dosname\@	dc.b	'dos.library',0
		IFNC	'','\1'
outname\@	dc.b	'\1',0
		ENDC
		cnop	0,4
no\@		movem.l	(a7)+,d0-d2/a0-a1/a5-a6
		ENDC
		ENDM
