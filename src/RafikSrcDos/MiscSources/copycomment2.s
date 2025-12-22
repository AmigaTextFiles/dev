;
;recomment
;wrzuca 1 comentarz do drugiego pliku
;rtk zmuszony 1000 mod z aminetu
;950406

	ADDWATCH	a0,A
	ADDWATCH	a1-4,A
	ADDWATCH	name,A
	ADDWATCH	name2,A
	ADDWATCH	FileInfo,A

	

start:
;>>>>>>>>>>>>test
;	moveq	#1,d0
;	lea	test,a0
;>>>>>>>>>>>>test


	tst.l	d0
	beq.w	End

	moveq	#0,d1

	cmp.b	#'"',(a0)
	bne.s	.first
	moveq	#1,d1
	addq.l	#1,a0
.first
	lea	name,a1

	bsr	copyyy

	addq.l	#1,a0

	tst.b	d1
	beq.s	drugie
	addq.l	#2,a0
drugie
	lea	name2,a1
	bsr	copyyy

	lea	DosName,a1
	move.l	4.w,a6
	jsr	-408(a6)	;old open
	move.l	d0,a6
;144 comment!
;lock
	move.l	#name,d1
	moveq	#-2,d2
	jsr	-84(a6)	;lock
	move.l	d0,LockSave
	beq.s	DirError

	move.l	LockSave(pc),d1
	move.l	#FileInfo,d2
	jsr	-102(a6) ;examine
	tst.l	d0
	beq	DirError

	move.l	LockSave(pc),d1
	jsr	-90(a6)		;unlock

;.1
;	bra.w	.1

	move.l	#name2,d1
	move.l	#FileInfo+144,d2
	jsr	-180(a6)

DirError:
End:
	moveq	#0,d0
	rts
copyyy:
.1	move.b	(a0)+,(a1)+
	cmp.b	#$a,(a0)
	bne.s	.3
	addq.l	#4,sp
	bra.s	End
.3	tst.b	d1
	beq.s	.2
	cmp.b	#'"',(a0)
	beq.s	.zero
	bra.s	.1
.2
	cmp.b	#' ',(a0)
	bne.s	.1
.zero
	move.b	#0,(a1)+
	rts


LockSave:	dc.l	0
DosName:	dc.b	'dos.library',0
	dc.b	'$VER: Copy Comment v1.0 rtk/rdst/sct ',0


;test:
;	dc.b	'"dh0:archive/-Dozrzutu/modules/mod.jet.pp" '
;	dc.b	'"dh0:archive/-Dozrzutu/modules/mod.the nomination.pp" ',$a


	SECTION		'Finfoblock',DATA
FileInfo:
	ds.b	300
name:	ds.b	100
name2:	ds.b	100

