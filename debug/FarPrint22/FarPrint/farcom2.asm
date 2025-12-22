		********************************
		*                              *
		*            FarCom            *
		*       Part II - SendIt       *
		*                              *
		*     by Torsten Jürgeleit     *
		*                              *
		********************************

	NOLIST
	INCLUDE "exec/types.i"
	INCLUDE "exec/memory.i"
	INCLUDE "exec/ports.i"
	INCLUDE "exec/nodes.i"
	INCLUDE "exec/libraries.i"
	INCLUDE "libraries/dosextens.i"
	INCLUDE "farcom.i"
	LIST

;---------------------------------------------------------------------------
; LONG SendIt(BYTE *text, BYTE *ident, USHORT cmd)
;
; Sends message/request to FarPort, completely reentrant, shouldn't work
; from interrupt code since we wait for the reply.
;---------------------------------------------------------------------------
	XDEF	_SendIt
_SendIt:
	PUSH	d1-d4/a0-a6

	; --- grab args from stack
	move.l	4+11*4(sp),a2			; a2 := text
	move.l	8+11*4(sp),a3			; a3 := ident
	move.w	12+11*4(sp),d2			; d2 := cmd

	; --- set same regs
	moveq	#0,d3				; d3 := default return value
	move.l	4,a6				; a6 := exec base

	; --- look for FarPrint port
	lea	far_port_name(pc),a1		; a1 := port name
	CALLSYS	FindPort
	tst.l	d0				; no port found ?
	beq	si_exit
	move.l	d0,a4				; a4 := far port

	; --- calc buffer size for FarMessage
	moveq	#FarMessage_Sizeof,d4		; d4 := buffer size
	cmp.w	#FM_ADDTXT,d2			; if cmd == FM_ADDTXT
	bne	si_add_ident_len

si_add_text_len:
	move.l	a2,a0				; a0 := text
	CALL	strlen
	add.l	d0,d4				; then add strlen(text)+1
	bra	si_alloc_buffer

si_add_ident_len:
	move.l	a3,a0				; a0 := ident
	CALL	strlen
	add.l	d0,d4				; else add strlen(ident)+1
	add.l	#MP_SIZE,d4			; and msg port size

si_alloc_buffer:
	; --- alloc buffer for FarMessage
	move.l	d4,d0				; d0 := buffer size
	move.l	#MEMF_PUBLIC|MEMF_CLEAR,d1	; d1 := mem attr
	CALLSYS	AllocMem
	tst.l	d0				; alloc mem failed
	beq	si_exit
	move.l	d0,a5				; a5 := far msg

	; --- check far msg cmd
	cmp.w	#FM_ADDTXT,d2			; cmd == FM_ADDTXT ?
	bne	si_request

	; --- init ADD msg
	move.w	d4,fm_ExecMessage+MN_LENGTH(a5)	; set msg len
	move.w	d2,fm_Command(a5)		; set cmd
	lea	FarMessage_Sizeof(a5),a1	; a1 := ptr to buffer in msg
	move.l	a1,fm_Text(a5)			; set text ptr
	move.l	a2,a0
	CALL	strcpy				; copy text to buffer

	; --- send ADD msg
	move.l	a4,a0				; a0 := far port
	move.l	a5,a1				; a1 := far msg
	CALLSYS	PutMsg

	; --- don;t wait for a reply, msg freed by FarPrint
	bra	si_exit

si_request:
	; --- alloc sig bit for msg port
	moveq	#-1,d0
	CALLSYS	AllocSignal
	cmp.l	#-1,d0
	beq	si_free_buffer

	; --- init far msg port
	move.b	d0,MP_SIGBIT(a5)
	move.b	#NT_MSGPORT,LN_TYPE(a5)
	move.b	#PA_SIGNAL,MP_FLAGS(a5)
	sub.l	a1,a1				; find ourself
	CALLSYS	FindTask
	move.l	d0,MP_SIGTASK(a5)
	lea	MP_MSGLIST(a5),a0
	NEWLIST	a0

	; --- init REQ msg
	lea	MP_SIZE(a5),a1			; a1 := far msg
	move.w	d2,fm_Command(a1)		; set cmd
	move.l	d4,d0
	sub.l	#MP_SIZE,d0
	move.w	d0,fm_ExecMessage+MN_LENGTH(a1)	; set msg len
	move.l	a5,fm_ExecMessage+MN_REPLYPORT(a1)	; set reply port
	move.l	a2,fm_Text(a1)			; set text ptr
	move.l	a1,a2				; a2 := far msg
	move.l	a3,a0				; a0 := ident
	lea	FarMessage_Sizeof(a2),a1	; a1 := ptr to buffer in msg
	move.l	a1,fm_Identifier(a2)		; set ident ptr
	CALL	strcpy				; copy ident to buffer

	; --- send REQ msg
	move.l	a4,a0				; a0 := far port
	move.l	a2,a1				; a1 := far msg
	CALLSYS	PutMsg

	; --- wait for a reply
	move.l	a5,a0				; a0 := reply port
	CALLSYS	WaitPort

	; --- get msg from reply port
	move.l	a5,a0				; a0 := reply port
	CALLSYS	GetMsg

	; --- get result from msg
	move.l	fm_Text(a2),d3			; d3 := result

	; --- free signal from far msg port
	moveq	#0,d0
	move.b	MP_SIGBIT(a5),d0
	CALLSYS	FreeSignal

si_free_buffer:
	; --- free far msg + port buffer
	move.l	a5,a1				; d0 := buffer
	move.l	d4,d0				; d0 := buffer size
	CALLSYS	FreeMem

si_exit:
	; --- set return value
	move.l	d3,d0

	PULL	d1-d4/a0-a6
	rts

far_port_name:
	dc.b	"FarPort",0
	CNOP	0,2

;---------------------------------------------------------------------------
; Get string length
;
; Input: a0 = string ptr	Output: d0 := string length + 1
;---------------------------------------------------------------------------

strlen:
	moveq	#0,d0				; d0 := len
	move.l	a0,d1				; ptr == NULL ?
	beq	sl_exit

sl_loop:
	addq.l	#1,d0				; inc len
	tst.b	(a0)+				; end of string ?
	bne	sl_loop

sl_exit:
	rts

;---------------------------------------------------------------------------
; Copy string
;
; Input: a0 = source ptr	Output: d0 := string length + 1
;	 a1 = dest ptr
;---------------------------------------------------------------------------

strcpy:
	moveq	#0,d0				; d0 := len
	move.l	a0,d1				; ptr == NULL ?
	beq	sc_exit

sc_loop:
	addq.l	#1,d0				; inc len
	move.b	(a0)+,(a1)+			; end of string ?
	bne	sc_loop

sc_exit:
	rts

	END
