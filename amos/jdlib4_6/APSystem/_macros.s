BUG	MACRO
bugme:	illegal
	lea	bugme(pc),a0
	move.w	#$4AFC,(a0)
	ENDM

Mlea	MACRO
	Dmove	memory_buffers,\2
	add.l	#\1,\2
	ENDM

Dlea	MACRO
	move.l	ExtAdr+ExtNb*16(a5),\2
	add.w	#\1-JD,\2
	ENDM

Dload	MACRO
	move.l	ExtAdr+ExtNb*16(a5),\1
	ENDM

Dmove	MACRO
	movem.l	a3,-(sp)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\1-JD,a3
	move.l	(a3),\2
	movem.l	(sp)+,a3
	ENDM

Dmove2	MACRO
	movem.l	a3,-(sp)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\1-JD,a3
	move.l	(a3),\3
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\2-JD,a3
	move.l	(a3),\4
	movem.l	(sp)+,a3
	ENDM

Dmove3	MACRO
	movem.l	a3,-(sp)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\1-JD,a3
	move.l	(a3),\4
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\2-JD,a3
	move.l	(a3),\5
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\3-JD,a3
	move.l	(a3),\6
	movem.l	(sp)+,a3
	ENDM

Dmove4	MACRO
	movem.l	a3,-(sp)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\1-JD,a3
	move.l	(a3),\5
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\2-JD,a3
	move.l	(a3),\6
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\3-JD,a3
	move.l	(a3),\7
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\4-JD,a3
	move.l	(a3),\8
	movem.l	(sp)+,a3
	ENDM

Dsave	MACRO
	movem.l	a3,-(sp)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\2-JD,a3
	move.l	\1,(a3)
	movem.l	(sp)+,a3
	ENDM

Dsave2	MACRO
	movem.l	a3,-(sp)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\3-JD,a3
	move.l	\1,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\4-JD,a3
	move.l	\2,(a3)
	movem.l	(sp)+,a3
	ENDM

Dsave3	MACRO
	movem.l	a3,-(sp)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\4-JD,a3
	move.l	\1,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\5-JD,a3
	move.l	\2,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\6-JD,a3
	move.l	\3,(a3)
	movem.l	(sp)+,a3
	ENDM

Dsave4	MACRO
	movem.l	a3,-(sp)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\5-JD,a3
	move.l	\1,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\6-JD,a3
	move.l	\2,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\7-JD,a3
	move.l	\3,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#\8-JD,a3
	move.l	\4,(a3)
	movem.l	(sp)+,a3
	ENDM

Bsave	MACRO
	movem.l	a0,-(sp)
	lea	\2(pc),a0
	move.b	\1,(a0)
	movem.l	(sp)+,a0
	ENDM

Wsave	MACRO
	movem.l	a0,-(sp)
	lea	\2(pc),a0
	move.w	\1,(a0)
	movem.l	(sp)+,a0
	ENDM

Wsave2	MACRO
	movem.l	a0,-(sp)
	lea	\3(pc),a0
	move.w	\1,(a0)
	lea	\4(pc),a0
	move.w	\2,(a0)
	movem.l	(sp)+,a0
	ENDM
