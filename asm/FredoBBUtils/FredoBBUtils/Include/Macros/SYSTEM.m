* macro SYSTEM_OFF
* - sauvegarde les vecteurs système
* - inhibe le système (interruptions, multitache)
* - passe en mode superviseur

SYSTEM_OFF	MACRO
	movem.l	d0-a6,-(sp)
	lea	gfxname,a1
	move.l	4,a6
	jsr	-408(a6)
	move.l	d0,a0
	move.l	38(a0),systemsafe+9*4	;sauver coplist système
	movem.l	$64,d0-d7		;sauver vecteurs interrupt
	movem.l	d0-d7,systemsafe
	move	sr,systemsafe+8*4	;sauver sr
	move.l	sp,systemsafe+10*4	;sauver sp
	move.l	#in\@,a0
	move.l	a0,d0
	move.l	a0,d1
	move.l	a0,d2
	move.l	a0,d3
	move.l	a0,d4
	move.l	a0,d5
	move.l	a0,d6
	move.l	a0,d7
	movem.l	d0-d7,$64
Wait\@:	jmp	Wait\@
	movem.l	(sp)+,d0-a6
	even
systemsafe:
	ds.l	11
gfxname:dc.b	"graphics.library",0
	even
in\@	move	#$2700,sr
	ENDM

* macro SYSTEM_ON
* - rétablit le du système

SYSTEM_ON	MACRO
	movem.l	d0-a6,-(sp)
	lea	$dff000,a0
	movem.l	systemsafe,d0-d7
	movem.l	d0-d7,$64
	move	systemsafe+8*4,sr
	move	#$83e0,$96(a0)	;dmacon
	move.l	systemsafe+10*4,sp
	move.l	systemsafe+9*4,$80(a0)	;cop1lc
	clr.l	$88(a0)			;copjmp1
	movem.l	(sp)+,d0-a6
	ENDM
