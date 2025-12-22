
; Useful macros. Last updated 13-Aug-1996


;-----------------------------------------------------------------
; macro : Call
; \1 : _LVO function
;-----------------------------------------------------------------

Call		MACRO
		jsr	_LVO\1(a6)
		ENDM



;-----------------------------------------------------------------
; macro : Callxxx
; \1 : _LVO function in xxx.library
;-----------------------------------------------------------------

CallExec	MACRO
		LibBase exec
		jsr	_LVO\1(a6)
		ENDM

CallDos		MACRO
		LibBase dos
		jsr	_LVO\1(a6)
		ENDM

CallInt		MACRO
		LibBase intuition
		jsr	_LVO\1(a6)
		ENDM

CallGfx		MACRO
		LibBase graphics
		jsr	_LVO\1(a6)
		ENDM

CallCyb		MACRO
		LibBase cybergraphics
		jsr	_LVO\1(a6)
		ENDM





;-----------------------------------------------------------------
; macro: Print
; \1 : <string>
;-----------------------------------------------------------------

Print		MACRO
		LibBase	dos
		move.l	#.ps\@,d1
		Call	PutStr
		bra	.ha\@
.ps\@		dc.b	"\1",10,0
		even
.ha\@		
		ENDM

;-----------------------------------------------------------------
; macro: PrintS
; \1 : string label
;-----------------------------------------------------------------

PrintS		MACRO
		LibBase	dos
		move.l	#\1,d1
		Call	PutStr
		ENDM

;-----------------------------------------------------------------
; macro: PrintF
; \1 : string label, assume data is in <label>dt
;-----------------------------------------------------------------

PrintF		MACRO
		movem.l	d0-d7/a0-a3,-(sp)
		lea.l	\1,a0
		lea.l	\1dt,a1
		lea.l	__TempString,a3
		lea.l	__StackChar,a2
		move.l	$4.w,a6
		JSRLIB	RawDoFmt
		PrintS	__TempString
		movem.l	(sp)+,d0-d7/a0-a3
		ENDM

__StackChar	move.b	d0,(a3)+
		rts

__TempString	ds.b	1024

;-------------------------------------------------------------------





;-----------------------------------------------------------------
; macro: Save
; \1 : <filename>
; \2 : <address>
; \3 : <lenght>
;-----------------------------------------------------------------

Save		MACRO
		LibBase	dos
		move.l	#name\@,d1
		move.l	#MODE_NEWFILE,d2
		jsr	_LVOOpen(a6)
		tst.l	d0
		beq	err\@

		move.l	d0,handle\@
		move.l	d0,d1
		move.l	#\2,d2
		move.l	#\3,d3
		jsr	_LVOWrite(a6)

		move.l	handle\@,d1
		jsr	_LVOClose(a6)
		bra	err\@

name\@		dc.b	"\1",0
		even
handle\@	dc.l	0

err\@
		ENDM





;-----------------------------------------------------------------
; macro: SetCopBpl
;
; \1 : label holding address of first bitplane
; \2 : bitplane size
; \3 : number of bitplanes
; \4 : copper address (bitplane #0) 
;-----------------------------------------------------------------

SetCopBpl	MACRO
		move.l	\1,d0
		lea.l	\4,a0
		move.w	#\3-1,d7
.l\@		move.w	d0,6(a0)
		swap	d0
		move.w	d0,2(a0)
		swap	d0
		add.l	#\2,d0
		addq.l	#8,a0
		dbf	d7,.l\@
		ENDM





;-----------------------------------------------------------------
; macro: SetCopper
;
; \1 : Copperlist to load
;-----------------------------------------------------------------

SetCopper	MACRO
		move.l	#\1,$dff080
		clr.w	$dff088
		ENDM




;-----------------------------------------------------------------
; usage of storage macros LoadData and FreeData:
;
; Load your stuff with LoadData, specify MEMF_CHIP or MEMF_FAST
; You can now access the data from the address stored at <nickname>
; When the data is not needed anymore, do a FreeData <nickname>
;-----------------------------------------------------------------


;-----------------------------------------------------------------
; macro: FreeData
; \1 : <nickname>
;-----------------------------------------------------------------

FreeData	MACRO
		tst.l	\1
		beq.s	.e\@
		move.l	$4.w,a6
		move.l	\1,a1
		move.l	\1+4,d0
		Call	FreeMem
		clr.l	\1	; if you FreeData once more
.e\@
		ENDM

;-----------------------------------------------------------------
; macro: LoadData -> d0 (0=fail)
;
; \1 : <filename>
; \2 : MEMF_CHIP or MEMF_FAST
; \3 : <nickname> for use with FreeData later on
;-----------------------------------------------------------------

LoadData	MACRO
		LibBase dos
		move.l	#.name,d1		; name
		move.l	#ACCESS_READ,d2		; mode of file
		Call	Lock			; lock file
		beq	.quit			; quit!
		move.l	d0,.lock		; save lock

		move.l	d0,d1
		Call	OpenFromLock
		beq	.quit
		move.l	d0,.file

		move.l	.lock,d1
		move.l	#.fib,d2
		Call	Examine
		beq	.quit

		move.l	$4.w,a6
		move.l	.fib+fib_Size,d0
		move.l	#\2,d1			; MEMF_CHIP or MEMF_FAST
		Call	AllocMem
		beq	.quit
		move.l	d0,.return

		LibBase	dos
		move.l	.file,d1
		move.l	d0,d2
		move.l	.fib+fib_Size,d3
		Call	Read
		bra	.quit

.return		dc.l	0
.file		dc.l	0
.lock		dc.l	0
.name		dc.b	"\1",0
		cnop	0,4
.fib		ds.b	fib_SIZEOF

.quit		LibBase	dos
		move.l	.file,d1
		beq.s	.nof
		Call	Close
.nof
		move.l	.lock,d1
		beq.s	.nol
		Call	UnLock

.nol		move.l	.return,d0
		move.l	.fib+fib_Size,\3+4
		move.l	d0,\3
		bra.s	mdone\@
\3		dc.l	0,0
mdone\@
		ENDM



;-----------------------------------------------------------------
; macro: SetDMA
; \1 : DMA bits
;-----------------------------------------------------------------

SetDMA:		MACRO
		move.w	#DMAF_SETCLR!\1,$dff096
		ENDM

;-----------------------------------------------------------------
; macro: ClrDMA
; \1 : DMA bits or "ALL"
;-----------------------------------------------------------------

ClrDMA:		MACRO
		IFC	"\1","ALL"
	        move.w	#$3FFF,$dff096
		ELSE
		move.w	#\1,$dff096
		ENDC	
		ENDM
