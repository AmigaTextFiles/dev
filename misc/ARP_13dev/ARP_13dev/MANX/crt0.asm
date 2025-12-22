; Initial startup routine for Aztec 'C' and ARP
; NB: This should allow access to all Aztec Features, math, etc.
;     Could be made smaller if only for CLI, only for Workbench,
;     Could be made smaller if only this or that.
;
; Created 11/08/87 by -+=SDB+=- from crt0.a68 file provided by Manx
; Copyright (c) 1987 by Scott Ballantyne, may be freely
; used by Arp Supporters/users

	INCLUDE "asmsupp.i"
	INCLUDE "exec/types.i"
;	 INCLUDE "exec/exec_lib.i"
	INCLUDE "exec/alerts.i"
	INCLUDE "libraries/arpbase.i"

	XLIB	OpenLibrary
	XLIB	Alert

	mc68881
	entry	.begin
	public	.begin
.begin
	bsr	_geta4			;get A4
	lea	__H1_end,a1
	lea	__H2_org,a2
	cmp.l	a1,a2			;check if BSS and DATA together
	bne	start			;no, don't have to clear
	move.w	#((__H2_end-__H2_org)/4)-1,d1
	bmi	start			;skip if no bss
	move.l	#0,d2
loop
	move.l	d2,(a1)+                ;clear out memory
	dbra	d1,loop

start
	move.l	sp,__savsp		;save stack pointer
	move.l	4,a6			;get Exec's library base pointer
	move.l	a6,_SysBase		;put where we can get it
	movem.l d0/a0,-(sp)             ;save CLI command parameters

	btst.b	#4,$129(a6)             ;check for 68881 flag in AttnFlags
	beq	1$			;skip if not
	lea	2$,a5
	jsr	-30(a6)                 ;do it in supervisor mode
	bra	1$
2$
	clr.l	-(sp)
	frestore (sp)+                  ;reset the ffp stuff
	rte				;and return
1$

    if 0

	lea	ARPNAME,a1		;get name of arp_library
	moveq.l #ArpVersion,d0
	SYSCALL OpenLibrary
	move.l	d0,_ArpBase		; set up pointer
;	 move.l  d0,_DOSBase		 ; also as Dos pointer
	bne	3$			; skip if okay
	add.w	#8,sp
	GURU	AG_OpenLib!AO_ArpLib
3$
	move.l	d0,a0
	move.l	DosBase(a0),_DOSBase    ; Give free dos.library
	move.l	GfxBase(a0),_GfxBase    ; Give free graphics.library
	move.l	IntuiBase(a0),_IntuitionBase ; and free intuition.library

    endc

	jsr	__main			;call the startup stuff
4$
	add.w	#8,sp			;pop args
	rts				;and return

; ARPNAME:	  ArpName

	public	_geta4
_geta4:
	far	data
	lea	__H1_org+32766,a4
	rts

	public	__main,__H0_org

	dseg

	public	_SysBase,__savsp  ; ,_DOSBase
	public	__H1_org,__H1_end,__H2_org,__H2_end
;	 public  _ArpBase
;	 public  _IntuitionBase,_GfxBase

