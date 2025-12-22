;
;
; ACHTUNG !
;
; DIESE MACROS BITTE JE NACH WUNSCH ABÄNDERN !
;
;
; -----------------------------------------------------------------
;
;  CODE: PLY-2/TRSi
;
; -----------------------------------------------------------------  
;
; Well, insert you text in the following lines.... This is a
; trainermenu aswell! Change it a bit if you do not need the
; trainer-options or for the case that you prefer a Replayer
;				
; The crunched length is: 4.6 Kilobytes (max. 5 KB) 
;
; For any questions call me or the coder of this, PLY-2
;
;
; Bye, CONtROL/TRSi
;
;
; -----------------------------------------------------------------  



TEXTE	MACRO

text1
	dc.b	0,0,0,0
	dc.b	"* TRISTAR & RED SECTOR INC *",0,0
	dc.b	"PROUDLY PRESENTS",0,0
	dc.b	"WUERGBENCH",0,0
	dc.b	"CRACKING:NICHT NOETIG",0
	dc.b	"TRAINER:WAR SCHON DRIN",0,0
	dc.b	"COOLES DESIGN ODA WAS?",0
	dc.b	"ABER HALLO! ICH HAB AUCH MAL",0
	DC.B	"WIEDER WAS GEMACHT! UEBRIGENS,",0
	DC.B	"ICH BRAUCHE DRINGEND EINE NEUE",0
	dc.b	"VERSION VON VIRUSZ ODER SO WAS!",0
	dc.b	"(KICK 1.3)",0
	dc.b	"      ->PREZZ LMB",0,-1

text2	dc.b	0,0,0,0
	dc.b	"*** TRAINERMENU ***",0,0,0

trainy	equ	8	;Y-Coordinate der Trainer

	dc.b	"F1 UNLIMITED LIVES       OFF",0
	dc.b	"F2 UNLIMITED AMMO        OFF",0
	dc.b	"F3 UNLIMITED SHIELD      OFF",0
	dc.b	"F4 UNLIMITED SMARTBOMBS  OFF",0
	dc.b	"F5 CHEATKEYS             NAH",0,0
	dc.b	"DA OBEN MUSS NOCH EIN VERNUENFTIG",0
	dc.b	"LOGO HIN, ABER SONST:",0
	DC.B	"A - PASS - PASS..",0,-2


f1n	dc.b	"F1 UNLIMITED LIVES       OFF",0,-3
f2n	dc.b	"F2 UNLIMITED AMMO        OFF",0,-3
f3n	dc.b	"F3 UNLIMITED SHIELD      OFF",0,-3
f4n	dc.b	"F4 UNLIMITED SMARTBOMBS  OFF",0,-3
f5n	dc.b	"F5 CHEATKEYS             NAH",0,-3
f6n
f7n
f8n
f9n
f10n


f1y	dc.b	"F1 UNLIMITED LIVES       ON ",0,-3
f2y	dc.b	"F2 UNLIMITED AMMO        ON ",0,-3
f3y	dc.b	"F3 UNLIMITED SHIELD      ON ",0,-3
f4y	dc.b	"F4 UNLIMITED SMARTBOMBS  ON ",0,-3
f5y	dc.b	"F5 CHEATKEYS             YO!",0,-3
f6y
f7y
f8y
f9y
f10y

trainanz = 5					; ANZAHL: BITTE EINSTELLEN !


traintab blk.b	trainanz,0			;DA SIND NACHHER TRAINERWERTE
						;DRIN !
	EVEN

ttab	dc.l	f1n,f1y,f2n,f2y,f3n,f3y
	dc.l	f4n,f4y,f5n,f5y,f6n,f6y
	dc.l	f7n,f7y,f8n,f8y,f9n,f9y
	dc.l	f10n,f10y

text3
	dc.b	0,0,0
	DC.B	"SO, DAS IST DIE DRITTE SEITE...",0
	DC.B	"(1. SEITE: PREZENTATION, 2.",0
	DC.B	"SEITE: TRAINERMENU, 3.SEITE:",0
	DC.B	"ERLAEUTERUNGEN ODER GREETINGS",0
	DC.B	"ODER CREDITS ODER WASISCHNISCH...)",0,0
	dc.b	"SOEDERLE, FADEOUT IS JETZ AUCH",0
	DC.B	"DRIN...",0
	DC.B	0,-1
	EVEN

	ENDM
			;FÜR MUSIK BITTE EINSETZEN !
MT_INIT	MACRO
	rts
	ENDM
MT_EXIT MACRO
	rts
	ENDM

MT_VBL  MACRO		;NUR FALLS VBLANK-PLAYER
	rts
	ENDM		
	

*
; flineinit (#)Scrw
; lineinit (#)Scrw
; fline     (?)Screen D0-D3, A3=Multab
; clipfline (?)Screen,(#)scrw,(#)scrh, sonst wie filline
; line     (?)Screen D0-D3, A3=Multab

	
;;************* LINEDRAW ROUTINE *******************
;                 LINEDRAW ROUTINE FOR USE WITH FILLING:
; Preload:  d0=X1  d1=Y1  d2=X2  d3=Y2 A3=Multab
; $dff060=Screenwidth (word)  $dff072=-$8000 (longword)  $dff044=-1 (longword)
; Verbrät d0-d5

fline MACRO 			;(?)Screen
	cmp.w   d1,d3
	bgt.s   .line1
	exg     d0,d2
	exg     d1,d3
	beq.s   .out
.line1	moveq	#0,d4
	move.w  d1,d4
	add.w	d4,d4
	move.w	(a3,d4.w),d4
	move.w  d0,d5
	asr.w   #3,d5
	add.w   d5,d4
	add.l   \1,d4
	moveq   #0,d5
	sub.w   d1,d3
	sub.w   d0,d2
	bpl.s   .line2
	moveq   #1,d5
	neg.w   d2
.line2	move.w  d3,d1
	add.w   d1,d1
	cmp.w   d2,d1
	dbhi    d3,.line3
.line3	move.w  d3,d1
	sub.w   d2,d1
	bpl.s   .line4
	exg     d2,d3
.line4	addx.w  d5,d5
	add.w   d2,d2
	move.w  d2,d1
	sub.w   d3,d2
	addx.w  d5,d5
	and.w   #15,d0
	ror.w   #4,d0
	or.w    #$a4a,d0
	LWBLIT
	move.w  d2,$52(a6)
	sub.w   d3,d2
	lsl.w   #6,d3
	addq.w  #2,d3
	move.w  d0,$40(a6)
 	move.b  .oct(PC,d5.w),$43(a6)
	move.l  d4,$48(a6)
	move.l  d4,$54(a6)
	movem.w d1/d2,$62(a6)
	move.w  d3,$58(a6)
.out	rts
.oct	dc.l    $3431353,$b4b1757
	ENDM

;;
clipfline MACRO 	;(?)Screen,(#)scrw,(#)scrh ,sonst wie filline
	
	cmp.w   d0,d2
	bgt.s   .line0
	exg     d0,d2
	exg     d1,d3
.line0			;D0<=D2
	tst.w	d2
	bmi.w	.out

	tst.w	d0		;Links clippen
	bpl.s	.nlclip
	sub.w	d2,d0
	sub.w	d3,d1
	muls	d2,d1
	divs	d0,d1
	neg.w	d1
	add.w	d3,d1	
	moveq	#0,d0
.nlclip
	cmp.w	#(\2)-1,d0
	bgt.s	.fullrclip
	cmp.w	#(\2),d2	;Rechts clippen (für Filled!)
	blo.s	.nrclip
	move.w	#(\2)-1,d4
	sub.w	d0,d4
	move.w	d3,d5
	sub.w	d0,d2
	sub.w	d1,d3
	muls	d4,d3
	divs	d2,d3
	add.w	d1,d3	
	move.w	#(\2)-1,d2
	movem.w	d0-d3,-(sp)
	move.w	d2,d0
	move.w	d5,d1
	bsr	.yexecute
	movem.w	(sp)+,d0-d3	
	bra.s	.yexecute
.fullrclip
	move.w	#(\2)-1,d0
	move.w	#(\2)-1,d2
.nrclip

.yexecute
	cmp.w   d1,d3
	beq.w   .out
	bgt.s   .line1
	exg     d0,d2
	exg     d1,d3
.line1			;D1<D3
	tst.w	d3		;Linie ganz oberhalb oder unterhalb ?
	bmi.w	.out
	cmp.w	#(\3)-1,d1
	bgt.w	.out

	tst.w	d1
	bpl.s	.ntclip
				;Oben clippen
	tst.w	d3
	beq.w	.out
	sub.w	d2,d0
	sub.w	d3,d1
	muls	d3,d0
	divs	d1,d0
	neg.w	d0
	add.w	d2,d0	
	moveq	#0,d1
.ntclip
	cmp.w	#(\3),d3	;Unten clippen
	blo.s	.nbclip
	move.w	#(\3)-1,d4
	sub.w	d1,d4
	beq.w	.out
	sub.w	d0,d2
	sub.w	d1,d3
	muls	d4,d2
	divs	d3,d2
	add.w	d0,d2	
	move.w	#(\3)-1,d3
.nbclip
	moveq	#0,d4
	move.w  d1,d4
	add.w	d4,d4
	move.w	(a3,d4.w),d4
	move.w  d0,d5
	asr.w   #3,d5
	add.w   d5,d4
	add.l   \1,d4
	moveq   #0,d5
	sub.w   d1,d3
	sub.w   d0,d2
	bpl.s   .line2
	moveq   #1,d5
	neg.w   d2
.line2	move.w  d3,d1
	add.w   d1,d1
	cmp.w   d2,d1
	dbhi    d3,.line3
.line3	move.w  d3,d1
	sub.w   d2,d1
	bpl.s   .line4
	exg     d2,d3
.line4	addx.w  d5,d5
	add.w   d2,d2
	move.w  d2,d1
	sub.w   d3,d2
	addx.w  d5,d5
	and.w   #15,d0
	ror.w   #4,d0
	or.w    #$a4a,d0
	LWBLIT
	move.w  d2,$52(a6)
	sub.w   d3,d2
	lsl.w   #6,d3
	addq.w  #2,d3
	move.w  d0,$40(a6)
 	move.b  .oct(PC,d5.w),$43(a6)
	move.l  d4,$48(a6)
	move.l  d4,$54(a6)
	movem.w d1/d2,$62(a6)
	move.w  d3,$58(a6)
.out	rts
.oct	dc.l    $3431353,$b4b1757
	ENDM
;;
flineinit MACRO		;(#)Scrw
	PROCOFF
	LWBLIT
	PROCON
	move.w	#(\1)/8,$60(a6)
	move.l	#-$8000,$72(a6)
	move.l	#-1,$44(a6)
	ENDM

;;
lineinit MACRO		;(#)Scrw

	PROCOFF
	LWBLIT
	PROCON
	move.w	#(\1)/8,$60(a6)
	move.l	#-$8000,$72(a6)
	move.l	#-1,$44(a6)
	ENDM

;;
line	MACRO	;(?)Screen D0-D3, A3=Multab

	cmp.w	d0,d2		;Start&Endpunkte gleich ?
	bne.s	.noeq
	cmp.w	d1,d3
	bne.s	.noeq
	rts
.noeq
	move.w	d1,d4
	add.w	d4,d4
	move.w	(a3,d4.w),d4
	moveq	#-$10,d5
	and.w	d0,d5
	lsr.w	#3,d5
	add.w	d5,d4
	add.l	a1,d4
	clr.l	d5
	sub.w	d1,d3
	roxl.b	#1,d5
	tst.w	d3
	bge.s	.y2gy1
	neg.w	d3
.y2gy1	sub.w	d0,d2
	roxl.b	#1,d5
	tst.w	d2
	bge.s	.x2gx1
	neg.w	d2
.x2gx1	move.w	d3,d1
	sub.w	d2,d1
	bge.s	.dygdx
	exg	d2,d3
.dygdx	roxl.b	#1,d5
	move.b	okttab(pc,d5),d5
	add.w	d2,d2
	WBLIT
	move.w	d2,$62(a6)		;BLTBMOD
	sub.w	d3,d2
	bge.s	.signnl
	or.b	#$40,d5
.signnl	move.w	d2,$52(a6)		;BLTAPTL
	sub.w	d3,d2
	move.w	d2,$64(a6)		;BLTAMOD
	move.w	#$8000,$74(a6)		;BLTADAT
	move.w	#-1,$72(a6)		;BLTBDAT
	move.w	#$ffff,$44(a6)		;BLTAFWM
	and.w	#$f,d0
	ror.w	#4,d0
	or.w	#$0bca,d0
	move.w	d0,$40(a6)		;BLTCON0
	move.w	d5,$42(a6)		;BLTCON1
	move.l	d4,$48(a6)		;BLTCPT
	move.l	d4,$54(a6)		;BLTDPT
	move.w	#scrbw*planz,$60(a6)	;BLTCMOD
	move.w	#scrbw*planz,$66(a6)	;BLTDMOD
	lsl.w	#6,d3
	addq.w	#2,d3
	move.w	d3,$58(a6)		;BLTSIZE
	rts
okttab	dc.b	0*4+1,4*4+1,2*4+1,5*4+1,1*4+1,6*4+1,3*4+1,7*4+1
	ENDM


;System initialisieren
; 			>=(#)newcopper,(#)newint,(#)startadr
coldinit MACRO
hm_coldf equ 1
	ENDM
init 	MACRO
	IF \3<>0
	jmp	\3		
	org	\3
	load	\3
	ENDC
init_lab
	bsr	hm_owndesk
	bra.w	init_x
hm_owndesk
	lea	gfxname(pc),a1			;Save sys
	move.l	4.w,a6
	jsr	-408(a6)	;Openlib
	move.l	d0,a1
	move.l	38(a1),oldcopper
	move.l	34(a1),oldview
	move.l	a1,a6
	ifnd	hm_coldf
	 sub.l	a1,a1
	 jsr	-222(a6)	;Loadview
	 jsr	-270(a6)	;Waittof
	 jsr	-270(a6)
	Endc
	move.l	a6,a1
	move.l	4.w,a6
	jsr	-414(a6)	;Closelib
	move.w	#$8000,d0
	lea	$dff000,a6
	move.w	$2(a6),olddma			;save dma
	or.w	d0,olddma
	move.w	$1c(a6),oldena			;save irq enable
	or.w	d0,oldena
	move.l	$6c.w,oldint			;save interupt vector
	wblit
	move.w	#$7fff,d0
	move.w	d0,$9a(a6)
	move.w	d0,$96(a6)
	move.l	#\2,$6c.w
	move.w	#$c020,$9a(a6)			;start interupt
	move.w	$7c(a6),d0
	cmp.b	#$f8,d0
	bne.s	.ecs		;AGA?
	move.w	#$c00,$106(a6)
	clr.w	$1fc(a6)
.ecs	
	move.l	#\1,$80(a6)
	move.w	#$83f0,$96(a6)			;start copper
	rts
init_x
	ENDM
;System verlassen+Datenpuffer anlegen
exit 	MACRO
	bsr	hm_sysdesk
	moveq	#0,d0
	rts					;back to cli
hm_sysdesk
	lea	$dff000,a6
	wblit
	move.w	#$7fff,$9a(a6)
	move.w	#$7fff,$96(a6)
	wblit
	move.l	oldint(pc),$6c.w
	move.l	oldcopper(pc),$80(a6)
	move.w	oldena(pc),d0
	or.w	#$8000,d0
	move.w	d0,$9a(a6)
	move.w	olddma(pc),d0
	or.w	#$8000,d0
	move.w	d0,$96(a6)
	lea	gfxname(pc),a1
	move.l	4.w,a6
	jsr	-408(a6)	;Openlib
	move.l	d0,a6
	move.l	oldview,a1
	jsr	-222(a6)	;Loadview
	move.l	a6,a1
	move.l	4.w,a6
	jsr	-414(a6)	;Closelib
	lea	$dff000,a6
	rts
olddma		dc.w	0
oldena		dc.w	0
oldint		dc.l	0
oldcopper	dc.l	0
oldview		dc.l	0
gfxname		dc.b	'graphics.library',0,0
	ENDM
OWNDESK MACRO
	bsr	hm_owndesk	
	ENDM
SYSDESK MACRO
	bsr	hm_sysdesk	
	ENDM
	

; Maustaste überprüfen, zu \1 falls noch nicht 
msloop  MACRO	
	btst	#6,$bfe001
	bne	\1
	ENDM
; Sprites ausknipsen
sproff	MACRO
	move.w	#32,$96(a6)
	move.w	#15,d0
	lea.l	$dff140,a0
sl\@	clr.l	(a0)+
	dbf	d0,sl\@
	ENDM
; Multiplikationstabelle (long/word) generieren
;		>= (#)Dest(label),(#)Startwert,(#)Schrittw,(#)Anz
genmull	MACRO
	lea	\1,a0
	move.w	#(\4)-1,d1
	move.l	#\2,d0
gmll\@	move.l	d0,(a0)+
	addi.l	#\3,d0
	dbf	d1,gmll\@
	ENDM
genmulw	MACRO
	lea	\1,a0
	move.w	#(\4)-1,d1
	move.w	#\2,d0
gmlw\@	move.w	d0,(a0)+
	addi.w	#\3,d0
	dbf	d1,gmlw\@
	ENDM
*
********  INTERRUPTSMACROS  ********************
*
irqin   MACRO
	movem.l	d0-a6,-(a7)
	ENDM
;Faderinterruptroutine (mit JSR Aufrufen)
fadeirq	MACRO		
	subq.w	#1,hmfadcnt
	bne.s	fiend\@
	move.w	hmfadpau,hmfadcnt
	move.w	hmfadanz,d1
	move.l	hmwishcol,a0
 	lea	hmfadcolt,a1
	lea	$dff180,a2
fadl\@	clr.w	d6
	move.w	#$f,d4
	move.w	#$1,d5
	jsr	dofad\@
	jsr	dofad\@
	jsr	dofad\@
	move.w	d6,(a1)+
	move.w	d6,(a2)+
	addq.l	#2,a0
	dbf	d1,fadl\@
fiend\@	rts
dofad\@	move.w	(a0),d2		;Wish in d2
	move.w	(a1),d3		;Real in d3
	and.w	d4,d2
	and.w	d4,d3
	cmp.w	d3,d2
	beq.s	dofend\@
	bhi.s	addit\@
	sub.w	d5,d3
	bra.s	dofend\@
addit\@	add.w	d5,d3	
dofend\@ or.w	d3,d6
	asl.w	#4,d4
	asl.w	#4,d5
	rts
hmfadanz	dc.w 0
hmwishcol	dc.l 0
hmfadpau	dc.w 0
hmfadcnt	dc.w 0
hmfadcolt	blk.w 32,0
	ENDM
irqout  MACRO
	clr.w	wvblflg
	movem.l	(a7)+,d0-a6
	move.w	#$20,$dff09c
	rte
wvblflg	dc.w	0
	ENDM

; auf VBL warten
wvbl	MACRO
	move.w	#1,wvblflg
.wv\@	tst.w	wvblflg
	bne.s	.wv\@
	ENDM		
lwvbl	MACRO
	wvbl
	ENDM		

; per VBL faden
;		>= ?Farbtab.Pointer,?anz-1,?Speed(AnzVBLsPause)(>0)    ben. IRQIN
fade	MACRO
	move.w	\3,hmfadcnt
	move.w	\3,hmfadpau
	move.l	\1,hmwishcol
	move.w	\2,hmfadanz 
	ENDM
; Palette benutzen
;		>= (#)Fabtab.pointer,(#)anz
usepal	MACRO
	movem.l	d0/a0-a1,-(sp)
	move.w	#\2,d0
	move.w	d0,hmfadanz
	lea.l	\1,a0
	move.l	a0,hmwishcol
	lea.l	hmfadcolt,a1
upl\@	move.w	(a0),(a1)+
	dbf	d0,upl\@	
	movem.l	(sp)+,d0/a0-a1	
	ENDM
; Auf Rasterstrahl warten
;		>=X,Y
rasterwait MACRO
rl\@	cmp.w	#((\2)<<8)+(\1),$6(a6)
	bcs.s	rl\@
	ENDM

; TASTATURINTERRUPT  Instkey *inter, remkey

instkey MACRO
; 			>=(#)IRQ (-> D0:Tastaturcode)

	move.l	$68.w,oldkint
	move.l	#key_inter,$68.w
	move.w	#$8008,$9a(a6)
	bra.s	instkey_x

key_inter
	movem.l	d0-a6,-(sp)
	move.b	$bfed01,d0
	btst	#3,d0
	beq.s	.fintr
	move.b	$bfec01,d0
	bset	#6,$bfee01
	moveq	#2,d2
.lop2	move.b	$dff006,d1
.lop1	move.b	#$ff,$bfec01
	cmp.b	$dff006,d1
	beq.s	.lop1
	dbf	d2,.lop2

	bclr	#6,$bfee01
	tst.b	d0
	beq.s	.fintr
	ror.b	d0
	not.b	d0
	move.b	d0,key
	jsr	\1
.fintr
	movem.l	(sp)+,d0-a6
	move.w	#$8,$dff09c
	rte
key	dc.b	0,0	
oldkint	dc.l	0
instkey_x
	ENDM


remkey	MACRO
	move.l	oldkint,$68.w
	ENDM

; 	Screentab rotieren
;>=(#)scrtab,(#)scranz (2-8)
swapscr MACRO
	IF (\2)>1
	lea	\1(pc),a0
	ENDC
	IF (\2)=2
	movem.l	(a0),d0/d1
	move.l	d0,4(a0)
	move.l	d1,(a0)
	ENDC
	IF (\2)=3
	movem.l	(a0),d0-d2
	movem.l	d1-d2,(a0)
	move.l	d0,8(a0)
	ENDC
	IF (\2)=4
	movem.l	(a0),d0-d3
	movem.l	d1-d3,(a0)
	move.l	d0,12(a0)
	ENDC
	IF (\2)=5
	movem.l	(a0),d0-d4
	movem.l	d1-d4,(a0)
	move.l	d0,16(a0)
	ENDC
	IF (\2)=6
	movem.l	(a0),d0-d5
	movem.l	d1-d5,(a0)
	move.l	d0,20(a0)
	ENDC
	IF (\2)=7
	movem.l	(a0),d0-d6
	movem.l	d1-d6,(a0)
	move.l	d0,24(a0)
	ENDC
	IF (\2)=8
	movem.l	(a0),d0-d7
	movem.l	d1-d7,(a0)
	move.l	d0,28(a0)
	ENDC
	IF (\2)>8
	PRINTT "Fehler bei SWAPSCRMCR: Max 8 Screens!"
	move.w	#not_defined\@,d0
	ENDC
	ENDM

*****  COPPERMACROS  *******************************
*
; WAIT-Befehl
;		>=X,Y
wait	MACRO
	 dc.w	((\1)>>1)!((\2)<<8)!1,$fffe
	ENDM
; Bildschirmfarbe setzen
;		>=Farbe NR,Wert
copcol  MACRO
	 dc.w	$180+((\1)*2),\2
	ENDM
; DIW festlegen(als Copperliste)
;		>= winx,winy,winw,winh
copwin  MACRO
	dc.w	$8E,(\1)+((\2)<<8)
	dc.w	$90,(\3)+((\1)&255)+((((\2)+(\4)-1)&255)<<8)
	ENDM
; DDF	festlegen(als Clist)
;		>= winx,winy,winw in PIX.,winh,hresmode
copddf	MACRO
	IFEQ \5-0		;Lores
	 dc.w	$92,(((\1)-17)/2)&$fff8
	 dc.w   $94,((((\1)-17)/2)&$fff8)+((\3)/2)-8
	ENDC
	IFEQ \5-1		;Hires
	 dc.w	$92,(((\1)-9)/2)&$fffc
	 dc.w   $94,((((\1)-9)/2)&$fffc)+((\3)/4)-8
	ENDC
	ENDM
; Bitplane festlegen
;		>= planenr(1-6),startadresse
coppln	MACRO
	dc.w	$DC+((\1)*4),(\2)/65536
	dc.w	$DE+((\1)*4),(\2)&$FFFF
	ENDM
; Sprite festlegen
;		>= Spritenr(1-8),startadresse
copspr	MACRO
	dc.w	$11C+((\1)*4),(\2)/65536
	dc.w	$11E+((\1)*4),(\2)&$FFFF
	ENDM
; coppln-Befehl initialisieren
;		>= Coppln-Adresse,Screen-Adresse,dx wird verbraten
initcoppln MACRO
	move.l	#(\2),\3
	move.w	\3,\1+6
	swap	\3
	move.w	\3,\1+2
	ENDM
; Modulos festlegen
;		>=Wert
copemod MACRO
	dc.w	$10a,(\1)
	ENDM
copomod	MACRO
	dc.w	$108,(\1)
	ENDM
; Bildschirmmodus(BPLCON0) festlegen
;		>= BPLANZ,HIRES,DPLF,HAM,INTERLACE
copmode	MACRO
	dc.w	$100,((\1)<<12)+((\2)<<15)+((\3)<<10)+((\4)<<11)+((\5)<<2)
	ENDM
cprocoff MACRO
	dc.w	$96,$8400
	ENDM
cprocon	MACRO
	dc.w	$96,$400
	ENDM

; Copperliste starten
;		>= ?Adresse

initc	MACRO			;Komplettstart
	move.w	#$80,$96(a6)
	move.l	\1,$80(a6)
	clr.w	$88(a6)
	move.w	#$83c0,$96(a6)
	ENDM
startc  MACRO			;Nurstart
	move.l	\1,$80(a6)
	ENDM
*
****  Blittermacros  *****************************
*
; Auf Blitter warten
wblit   MACRO
.loop\@	btst	#14,$2(a6)
	bne.s	.loop\@
	ENDM
lwblit   MACRO
	wblit
	ENDM

; Prozessor während des Blittens an/aus
procoff MACRO
	move.w	#$8400,$96(a6)
	ENDM
procon	MACRO
	move.w	#$400,$96(a6)
	ENDM
; Blitter adjustieren
;		>= ABshift(FIX),ABCDDMA,Miniterm,Descend
fixadj	MACRO 
	move.l	#((\1)<<28)+((\2)<<24)+((\3)<<16)+((\1)<<12)+((\4)*2),$40(a6)
	ENDM
;		>= ABshift (Dx mampf) ,ABCDDMA,Miniterm,Descend
regadj	MACRO
	swap	\1
	move.w	#((\2)<<12)+((\3)<<4),\1
	lsr.l	#4,\1
	move.w  \1,$40(a6)
	and.w	#$f000,\1
	IFNE	\4
	 addq.w	#1,\1
	ENDC 
	move.w	\1,$42(a6)
	ENDM	

; Blitterposition festlegen
;		>=?Adresse
blita	MACRO
	move.l \1,$50(a6)
	ENDM
blitb	MACRO
	move.l \1,$4c(a6)
	ENDM
blitc	MACRO
	move.l \1,$48(a6)
	ENDM
blitd	MACRO
	move.l \1,$54(a6)
	ENDM
;		>=?Adresse,?Modulo
mblita	MACRO
	move.l \1,$50(a6)
	move.w \2,$64(a6)
	ENDM
mblitb	MACRO
	move.l \1,$4c(a6)
	move.w \2,$62(a6)
	ENDM
mblitc	MACRO
	move.l \1,$48(a6)
	move.w \2,$60(a6)
	ENDM
mblitd	MACRO
	move.l \1,$54(a6)
	move.w \2,$66(a6)
	ENDM
; Modulos
;	>=AMOD,DMOD
setadmod MACRO
	move.l	#((\1)<<16)+(\2),$64(a6)
	ENDM
;	>=BMOD,CMOD
setbcmod MACRO	
	move.l	#((\2)<<16)+(\1),$60(a6)
	ENDM
; Blitterfenster festlegen & Blitter starten
;		>=(#)Breite(in W.),(#)Höhe		
doblit	MACRO
	move.w #((\2)*64)+(\1),$58(a6)
	ENDM
*
******  VARSMACROS  ************************
*
; Blittervariablen definieren
defblit	MACRO
bltsize	equ	$58
bltcpth	equ	$48
bltcptl	equ	$4a
bltbpth	equ	$4c
bltbptl	equ	$4e
bltapth	equ	$50
bltaptl	equ	$52
bltdpth	equ	$54
bltdptl	equ	$56
bltcmod	equ	$60
bltbmod	equ	$62
bltamod	equ	$64
bltdmod	equ	$66
bltafwm	equ	$44
bltalwm	equ	$46
bltcon0	equ	$40
bltcon1	equ	$42
bltadat	equ	$74
bltbdat	equ	$72
bltcdat	equ	$70
	ENDM
; Playfieldvars definieren
defpln	MACRO
diwstrt	equ	$8e
diwstop	equ	$90
ddfstrt	equ	$92
ddfstop	equ	$94
bpl1pth	equ	$e0
bpl1ptl	equ	$e2
bpl2pth	equ	$e4
bpl2ptl	equ	$e6
bpl3pth	equ	$e8
bpl3ptl	equ	$ea
bpl4pth	equ	$ec
bpl4ptl	equ	$ee
bpl5pth	equ	$f0
bpl5ptl	equ	$f2
bpl6pth	equ	$f4
bpl6ptl	equ	$f6
bplcon0	equ	$100
bplcon1	equ	$102
bplsft	equ	$102
	ENDM
defspr	MACRO
spr0pth	equ	$120
spr0ptl	equ	$122
spr1pth	equ	$124
spr1ptl	equ	$126
spr2pth	equ	$128
spr2ptl	equ	$12a
spr3pth	equ	$12c
spr3ptl	equ	$12e
spr4pth	equ	$130
spr4ptl	equ	$132
spr5pth	equ	$134
spr5ptl	equ	$136
spr6pth	equ	$138
spr6ptl	equ	$13a
spr7pth	equ	$13c
spr7ptl	equ	$13e
spr0pos	equ	$140
spr0ctl	equ	$142
spr0data equ	$144
spr0datb equ	$146
spr1pos	equ	$148
spr1ctl	equ	$14a
spr1data equ	$14c
spr1datb equ	$14e
spr2pos	equ	$150
spr2ctl	equ	$152
spr2data equ	$154
spr2datb equ	$156
spr3pos	equ	$158
spr3ctl	equ	$15a
spr3data equ	$15c
spr3datb equ	$15e
spr4pos	equ	$160
spr4ctl	equ	$162
spr4data equ	$164
spr4datb equ	$166
spr5pos	equ	$168
spr5ctl	equ	$16a
spr5data equ	$16c
spr5datb equ	$16e
spr6pos	equ	$170
spr6ctl	equ	$172
spr6data equ	$174
spr6datb equ	$176
spr7pos	equ	$178
spr7ctl	equ	$17a
spr7data equ	$17c
spr7datb equ	$17e
	ENDM
; Sprite zeichnen
; 	>=?x,?y,?xadd,?yadd,?Höhe,(#)Sprctrl,(#)Attach
;	Verbrät d0-d3, diese nicht für ?-Werte benutzen !

calcsprite MACRO
	move.w	\2,d1
	add.w	\4,d1
	move.w	\1,d0
	add.w	\3,d0
	move.w	d0,d3
	and.w	#1,d3
	lsr.w	#1,d0
	move.w	d0,d2
	andi.w	#$ff,d2
	move.w	d1,d0
	add.l	\5,d0	;Höhe
	asl.w	#8,d1
	bcc.s	scne8\@
	bset	#2,d3
scne8\@	or.w	d1,d2
	asl.w	#8,d0
	bcc.s	scnl8\@
	bset	#1,d3
scnl8\@ or.w	d0,d3
	ifne	\7
	 bset	#7,d3
	endc
        move.w	d2,\6
	move.w	d3,(\6)+2
	ENDM
; Sprite zeichnen
; 	>=?x,?y,?xadd,?yadd,?Höhe,(#)Sprctrl,(#)Attach
;	Verbrät d0-d3, diese nicht für ?-Werte benutzen !

calcspritenowd MACRO
	move.w	\2,d1
	add.w	\4,d1
	move.w	\1,d0
	add.w	\3,d0
	move.w	d0,d3
	and.w	#1,d3
	lsr.w	#1,d0
	move.w	d0,d2
	andi.w	#$ff,d2
	move.w	d1,d0
	add.l	\5,d0	;Höhe
	asl.w	#8,d1
	bcc.s	scne8\@
	bset	#2,d3
scne8\@	or.w	d1,d2
	asl.w	#8,d0
	bcc.s	scnl8\@
	bset	#1,d3
scnl8\@ or.w	d0,d3
	ifne	\7
	 bset	#7,d3
	endc
	ENDM
******* FADEROUTINE **************

; Copper-Liste Faden 
;	=> Fadestrcut in a1, Copperliste in a2
cfadeirq MACRO
	subq.w	#1,8(a1)
	bne.s	fiend\@
	move.w	6(a1),8(a1)
	move.w	(a1),d1
	move.l	2(a1),a0
fadl\@	clr.w	d6
	move.w	#$f,d4
	move.w	#$1,d5
	bsr.s	dofad\@
	bsr.s	dofad\@
	bsr.s	dofad\@
	addq.l	#2,a2
	move.w	d6,(a2)+
	addq.l	#2,a0
	dbf	d1,fadl\@
fiend\@	rts
dofad\@	move.w	(a0),d2		;Wish in d2
	move.w	2(a2),d3	;Real in d3
	and.w	d4,d2
	and.w	d4,d3
	cmp.w	d3,d2
	beq.s	dofend\@
	bhi.s	addit\@
	sub.w	d5,d3
	bra.s	dofend\@
addit\@	add.w	d5,d3	
dofend\@ or.w	d3,d6
	asl.w	#4,d4
	asl.w	#4,d5
	rts
	ENDM
fadestruct MACRO		;wishpalette,anz,speed
	dc.w (\2)-1	;(0) Anz
	dc.l \1 	;(2) Pal*
	dc.w \3		;(6) Speed
	dc.w 1		;(8) Co
	ENDM
setfadestruct MACRO		;?Palptr,?Speed,*Struct
	move.l	\1,\3+2
	move.w	\2,\3+6
	ENDM


	section	"kl2",code_c
scrw	equ	352
scrbw	equ	scrw/8
scrh	equ	280
zomanz	equ	336
anf
	DEFPLN
	DEFBLIT
	INIT	cop0,inter,0
	SPROFF
	GENMULW	multab,0,scrbw,scrh


				**** SINTAB EXPANDEN ***
	lea	sinorig,a0
	lea	sin,a1
	lea	sin+1026,a2
	lea	sin+1024,a3
	lea	sin+2050,a4
	move.w	#256,d0
.sinl	move.w	(a0)+,d1
	move.w	d1,(a1)+
	move.w	d1,-(a2)
	neg.w	d1
	move.w	d1,(a3)+
	move.w	d1,-(a4)
	dbf	d0,.sinl	
	lea	sin,a0
	lea	sin+2048,a1
	lea	sin+4096,a2
	move.w	#511,d0
.sinl2
	move.l	(a0)+,d1
	move.l	d1,(a1)+
	move.l	d1,(a2)+
	dbf	d0,.sinl2	


	move.l	#-2,cop1
	move.l	#-2,cop2
	move.l	#-2,cop1x
	move.l	#-2,cop2x
	bsr	gwaitc


	lea	ccoltab,a0
	move.w	#zomanz-1,d0
	moveq	#0,d1
.cclop	
	move.w	d1,d2
	mulu	#5,d2
	divu	#zomanz,d2
	mulu	#$111,d2
	add.w	#$222,d2
	move.w	d2,(a0)+
	addq.w	#1,d1
	dbf	d0,.cclop

	moveq	#31,d0
	lea	$180(a6),a0
.cblop	move.w	#0,(a0)+
	dbf	d0,.cblop	



	STARTC	#copper
	WVBL
	bsr	calczom
	WVBL
	move.l	$68.w,okey
	move.l	#kinter,$68.w
	move.w	#$8008,$9a(a6)
	bsr	mti
	WVBL
	clr.w	frco

;;
mainloop

	WVBL
	bsr	calccol
					;5. Plane bearbeiten
	cmp.w	#100,frco
	bcs.w	.nothing
	cmp.w	#164,frco
	bcc.s	.nlogin
					;Logo reinblitten
	bsr	blitlog
.nlogin	

	cmp.w	#180,frco		;"P" rein
	bcs.s	.np2
	cmp.w	#180+4*7,frco
	bcc.s	.np2

	move.w	frco,d0
	sub.w	#180,d0
	bsr	drawp

.np2
	cmp.w	#250,frco		;"P" raus
	bcs.s	.np22
	cmp.w	#249+4*6,frco
	bcc.s	.np22

	move.w	#250+4*6,d0
	sub.w	frco,d0
	bsr	drawp
.np22
					;TEXT
	cmp.w	#50,frco
	bcs.s	.txtx


	move.l	ocurs,a1
	moveq	#0,d0
	bsr	drwcurs	
	tst.w	ftxtco
	beq.s	.dtxt
	bsr	fadetxt
	bra.s	.txtx
.dtxt
	bsr	drawtext
	bsr	drawtext
	btst	#6,$bfe001
	bne.s	.txtx
	bsr	drawtext
	bsr	drawtext
	bsr	drawtext
	bsr	drawtext
.txtx
.nothing	
	move.l	zstab1,a0
	lea	zomsiz1(pc),a2
	bsr	calccop

	move.l	zstab2,a0
	lea	zomsiz2(pc),a2
	bsr	calccop

	move.l	zstab3,a0
	lea	zomsiz3(pc),a2
	bsr	calccop

	move.l	zstab4,a0
	lea	zomsiz4(pc),a2
	bsr	calccop

	STARTC	coptab
	lea	zstab1(pc),a0
	bsr	swaps
	lea	zstab2(pc),a0
	bsr	swaps
	lea	zstab3(pc),a0
	bsr	swaps
	lea	zstab4(pc),a0
	bsr	swaps
	lea	coptab(pc),a0
	bsr	swaps
	tst.w	curstat
	bne.w	.ncons
					;CONSOLE
	move.b	omous,d1
	move.b	$bfe001,d0
	move.b	d0,omous
	btst	#6,d1
	beq.s	.nlmb
	btst	#6,d0
	bne.s	.nlmb
	move.w	#23*8,ftxtco
	clr.l	curwrt
	move.l	#text2,currd
	tst.w	page
	beq.s	.pg2
	move.l	#text3,currd
.pg2	
	move.w	#1,curstat
	addq.w	#1,page
	cmp.w	#3,page
	beq.s	prgx
	bra.s	.ncons
.nlmb
	tst.w	curstat
	bne.s	.ncons
	tst.w	tmode
	bpl.w	.ncons
	cmp.w	#1,page
	bne.s	.ncons
	moveq	#trainanz-1,d2
	moveq	#0,d0
	lea	traintab(pc),a0
	lea	otrtab(pc),a1
.loop
	move.b	(a0,d0.w),d1
	cmp.b	(a1,d0.w),d1
	bne.s	.dotrn
	addq.w	#1,d0
	dbf	d2,.loop	
	bra.s	.ncons
.dotrn
	move.b	d1,(a1,d0.w)
	move.w	d0,d2
	add.w	d0,d0
	and.w	#1,d1
	add.w	d1,d0
	asl.w	#2,d0
	lea	ttab(pc),a0
	move.l	(a0,d0.w),currd

	add.w	#trainy-1,d2
	mulu	#scrbw*8,d2
	move.l	d2,curwrt
	not.w	curstat
.ncons
;	move.w	#$c,$180(a6)
	bra	mainloop
prgx
	bsr	fadout
	WVBL
	move.l	okey,$68.w
	bsr	mte
	WVBL
	WVBL
	EXIT
okey	dc.l	0
page	dc.w	0
omous	dc.w	0

fadout	;§§

	STARTC	#copr1
	WVBL
	WVBL
	lea	txtsc,a0
	move.w	#scrbw*scrh/4-1,d0
.cl	move.l	#-1,(a0)+
	dbf	d0,.cl
	STARTC	#copr2
	WVBL	
	WVBL	
	moveq	#scrbw/4-1,d0
	lea	txtsc,a0
	lea	scrbw-2(a0),a1
.xlop
	WVBL
	move.w	#scrh-1,d1
	lea	(a0),a2
	lea	(a1),a3
	moveq	#0,d2
	moveq	#scrbw,d3
.ylop
	move.w	d2,(a2)
	move.w	d2,(a3)
	add.w	d3,a2
	add.w	d3,a3
	dbf	d1,.ylop
	addq.l	#2,a0
	subq.l	#2,a1
	sub.w	#$111,c2c+2
	dbf	d0,.xlop
	WVBL	
	STARTC	#cop0
	WVBL	
	WVBL	
	rts
	

kinter
	movem.l	d0-a6,-(sp)
	move.b	$bfed01,d0
	btst	#3,d0
	beq.s	.fintr
	move.b	$bfec01,d0
	bset	#6,$bfee01
	moveq	#2,d2
.lop2	move.b	$dff006,d1
.lop1	move.b	#$ff,$bfec01
	cmp.b	$dff006,d1
	beq.s	.lop1
	dbf	d2,.lop2

	bclr	#6,$bfee01
	tst.b	d0
	beq.s	.noke
	ror.b	d0
	not.b	d0
	move.b	d0,key
	tst.w	tmode
	bpl.w	.noke
	moveq	#0,d0
	move.b	key,d0
	sub.b	#$50,d0		;F1
	cmp.b	#trainanz,d0	;Fx
	bcc.s	.noke
	lea	traintab(pc),a0
	not.b	(a0,d0.w)	
.noke
.fintr
	movem.l	(sp)+,d0-a6
	move.w	#$8,$dff09c
	rte

key	dc.b	0,0	

swaps	movem.l	(a0),d0/d1
	move.l	d0,4(a0)
	move.l	d1,(a0)
	rts

drawp
	lea	txtsc+265*scrbw+40,a0
	lea	p2log(pc),a1
	and.w	#-4,d0
	lea	patt(pc),a2
	movem.w	(a2,d0.w),d1/d2
	moveq	#6,d0
.pp2log
	move.w	(a1)+,d3
	and.w	d1,d3
	move.w	d3,(a0)
	exg	d1,d2
	add.w	#scrbw,a0
	dbf	d0,.pp2log
	rts

zomsiz1	dc.w	0 ;zomanz-1
	dc.w	0,bpl1pth,bpl1ptl,0,0,10,0,34
zomsiz2	dc.w	zomanz/4			
	dc.w	8,bpl2pth,bpl2ptl,0,0,10,0,34
zomsiz3	dc.w	2*zomanz/4			
	dc.w	16,bpl3pth,bpl3ptl,0,0,10,0,34
zomsiz4	dc.w	3*zomanz/4			
	dc.w	24,bpl4pth,bpl4ptl,0,0,10,0,34

coptab	dc.l	cop1,cop2
zstab1	dc.l	zscr11,zscr21
zstab2	dc.l	zscr12,zscr22
zstab3	dc.l	zscr13,zscr23
zstab4	dc.l	zscr14,zscr24

pri	dc.w	0


;; ********* TEXT FADEN *******
fadetxt
	tst.w	ftxtco
	beq.w	.out

	subq.w	#8,ftxtco
	move.w	#23*8,d0
	sub.w	ftxtco,d0
	move.w	d0,d1
	and.w	#7,d0
	mulu	#10,d0
	lea	cpatt,a0

	lsr.w	#3,d1
	mulu	#scrbw*8,d1
	add.l	#txtsc+6+59*scrbw,d1

	move.l	d1,-(sp)

	moveq	#7,d2
	WBLIT
	FIXADJ	0,%1001,%11000000,0
	move.l	#-1,bltafwm(a6)
.loop	WBLIT
	move.w	(a0,d0.w),bltbdat(a6)
	move.w	#0,bltbdat(a6)
	BLITA	d1
	BLITD	d1
	DOBLIT	(scrbw-8)/2,1
	add.l	#scrbw,d1
	addq.w	#2,d0
	dbf	d2,.loop

	move.l	(sp)+,a1
	add.w	#9*scrbw,a1
	moveq	#-2,d0
	bsr	drwcurs

.out	rts
ftxtco	dc.w	0
;; ********* LOGO BLITTEN *******
blitlog
	move.w	frco,d0
	sub.w	#100,d0
	add.w	d0,d0
	lea	sin,a0
	asl.w	#2,d0
	move.w	(a0,d0.w),d0
	lsr.w	#3,d0
	add.w	#1,d0
	PROCOFF
	WBLIT
	SETADMOD 0,2*scrbw-32
	FIXADJ	0,%1001,%11000000,0
	BLITA	#logo
	move.w	#33,d1
	sub.w	d0,d1
	mulu	#scrbw*2,d1
	add.l	#txtsc+10*scrbw+6,d1
	BLITD	d1
	
	move.w	#$5555,bltbdat(a6)
	move.l	#-1,bltafwm(a6)
	asl.w	#6,d0
	add.w	#16,d0
	move.w	d0,bltsize(a6)
	
	nop
	rts

;; ********* FARBEN ************
calccol
	move.w	#15,d0
	lea	$180(a6),a0
	moveq	#0,d1
	lea	zomsiz1,a1
	lea	ccoltab,a2
.cclop
	moveq	#0,d2

	move.w	pri,d4
	moveq	#0,d4
	move.w	d4,d5
	move.w	d4,d6
	move.w	d4,d7
	addq.w	#1,d5	
	addq.w	#1,d6
	addq.w	#1,d7
	and.w	#3,d4
	and.w	#3,d5
	and.w	#3,d6
	and.w	#3,d7

	btst	#0,d1
	beq.w	.npl1
	move.w	(a1),d3
	bsr	.cadd
.npl1	
	btst	#1,d1
	beq.w	.npl2
	move.w	18(a1),d3
	bsr	.cadd
.npl2	
	btst	#2,d1
	beq.w	.npl3
	move.w	2*18(a1),d3
	bsr	.cadd
.npl3	
	btst	#3,d1
	beq.w	.npl4
	move.w	3*18(a1),d3
	bsr	.cadd
.npl4	
	addq.w	#1,d1
	cmp.w	#$fff,d2
	bcs.s	.nov
	move.w	#$fff,d2
.nov
	
	sub.w	fadc,d2
	bpl.s	.nfov
	moveq	#0,d2
.nfov
	move.w	d2,(a0)+
	move.w	d2,d3
	and.w	#$e0e,d2
	lsr.w	#1,d2
	and.w	#$0f0,d3
	add.w	d3,d3
	add.w	#$070,d3
	cmp.w	#$0f0,d3
	bcs.s	.nov2
	move.w	#$0f0,d3
.nov2
	or.w	d3,d2
	move.w	d2,30(a0)
	dbf	d0,.cclop	
	tst.w	fadc
	beq.s	.nadf
	sub.w	#$111,fadc
.nadf	
	rts
.cadd
	add.w	d3,d3
	add.w	(a2,d3.w),d2
	rts
fadc	dc.w	$fff
;; ******* WAITCOP ERSTELLEN ******
gwaitc
	lea	cop1,a0
	bsr	.doit
	lea	cop2,a0
.doit
	lea	caddt,a1
	move.w	#scrh-1,d0
	move.l	#$1f01fffe,d4
.loop
	move.w	#36,(a1)+
	add.l	#1<<24,d4
	bcc.s	.njmp2
	move.l	#$ffdffffe,(a0)+
	move.w	#40,-2(a1)
.njmp2	
	move.l	d4,(a0)+
	add.w	#32,a0
	dbf	d0,.loop
	move.w	#4,caddt
	rts		


;; ******* COPPER ERSTELLEN ******
;D1:Xoff
;D2:Yoff
;A0:Zscr
;A2:Zomsiz
calccop
	move.w	10(a2),d0
	add.w	12(a2),d0
	and.w	#2046,d0
	move.w	d0,10(a2)
	lea	sin,a1
	move.w	(a1,d0.w),d1
	asl.w	#2,d1
	lea	400(a1),a1
	move.w	(a1,d0.w),d2
	asl.w	#2,d2

	move.w	14(a2),d0
	add.w	16(a2),d0
	and.w	#2046,d0
	move.w	d0,14(a2)
	lea	sin,a1
	add.w	(a1,d0.w),d1
	lea	800(a1),a1
	add.w	(a1,d0.w),d2
	move.w	frco,d3
	asl.w	#4,d3
	sub.w	d3,d2

	addq.w	#1,(a2)
	cmp.w	#zomanz-1,(a2)
	bne.s	.znov
	move.w	#0,(a2)
	addq.w	#1,pri
.znov
	move.w	(a2),d0
	add.w	d0,d0
	lea	cstab,a1
	moveq	#0,d6
	move.w	(a1,d0.w),d6

	muls	cstabe,d2
	divs	d6,d2
	move.w	d2,d5
	add.w	#-scrh/2,d5

	muls.w	d6,d5

				;Erstmal blitten
	muls	cstabe,d1
	divs	d6,d1
	ext.l	d1
	add.l	#scrw/2,d1
	
	move.l	#65536*256,d4
	move.l	#65536*2,d3
	divu	d6,d3
.mxpl	tst.w	d1
	bpl.s	.mxpx
	add.w	d3,d1
	bra.s	.mxpl
.mxpx

.gslop
	move.l	d4,d3
	lsr.l	#1,d4

	divu	d6,d3		->Kachelgröße
	ext.l	d1
	divu	d3,d1
	swap	d1
	cmp.w	#scrw,d1
	bcc.s	.gslop

	mulu	#scrbw,d0
	add.l	#zomscr,d0
	move.l	d0,a1
	move.w	d1,d3
	not.w	d3
	lsr.w	#4,d1
	add.w	d1,d1
	add.w	d1,a1
	WBLIT
	PROCON
	SETADMOD 0,0
	BLITA	a1
	REGADJ	d3,%1001,%11110000,0
	move.l	#-1,bltafwm(a6)	
	BLITD	a0
	DOBLIT	scrbw/2+1,1
	addq.l	#2,a0
	move.l	a0,a1
	WBLIT
	FIXADJ	0,%1001,%00000000,0
	BLITA	a0
	add.w	#scrbw,a0
	BLITD	a0
	DOBLIT	scrbw/2,1

	move.l	a0,d0
	move.l	a0,d1
	move.w	4(a2),d0
	swap	d0
	and.l	#$ffff,d1
	or.l	6(a2),d1

	move.l	a1,d2
	move.l	a1,d3
	move.w	4(a2),d2
	swap	d2
	and.l	#$ffff,d3
	or.l	6(a2),d3

	move.l	coptab,a0
	add.w	2(a2),a0

	move.w	#scrh-1,d7

	lea	caddt,a1
.loop
	add.w	(a1)+,a0
	add.l	d6,d5
	btst	#16,d5
	beq.s	.eq	
	move.l	d0,(a0)
	move.l	d1,4(a0)
	dbf	d7,.loop
	move.l	#-2,(a0)
	rts

.eq
	move.l	d2,(a0)
	move.l	d3,4(a0)

	dbf	d7,.loop
	move.l	#-2,(a0)
	rts
;; ******* ZOOMEN BERECHNEN ******
calczom
	move.w	#zomanz-1,d0
	lea	zomscr,a0
	move.l	#1<<14,d5
	lea	cstab,a1
.zolop

	move.w	d5,(a1)+
	
	move.w	#scrw*2-1,d1
	moveq	#0,d2
	moveq	#7,d3

	move.w	d5,d4
	muls	#-scrw,d4

.zxlop
	move.l	d4,d6
	add.l	d5,d4

	swap	d2

	bclr	d3,(a0,d2.w)
	btst	#16,d4
	beq.s	.kset
	btst	#15,d4
	beq.s	.kset
	bset	d3,(a0,d2.w)
.kset
	swap	d2
	add.l	#1<<13,d2
	subq.w	#1,d3
	dbf	d1,.zxlop
	sub.l	#1<<14/(zomanz+1),d5
	add.w	#scrbw*2,a0
	dbf	d0,.zolop

	rts

;; ******* TEXT MALEN *********
;A0:Text A1:GFX
drawtext
	move.l	currd,a0
	move.w	curwrt,d0
	move.w	curwrt+2,d1
	add.w	d0,d1
	lea	txtsc+6+60*scrbw,a1
	add.w	d1,a1

	moveq	#-2,d0
	btst	#2,frco+1
	beq.s	.con
	moveq	#0,d0
.con	
	bsr	drwcurs
	tst.w	curstat
	beq.s	.out
	
	moveq	#0,d0
	move.b	(a0)+,d0
	move.l	a0,currd
	tst.b	d0
	beq.s	.linex
	lea	font,a3
	sub.b	#32,d0
	add.w	d0,a3
.found
	move.l	a1,a2
	clr.b	-scrbw(a1)
	clr.b	5*scrbw(a1)

.ylop
	move.b	(a3),d1
	move.b	d1,(a2)
	move.b	1*60(a3),d1
	move.b	d1,1*scrbw(a2)
	move.b	2*60(a3),d1
	move.b	d1,2*scrbw(a2)
	move.b	3*60(a3),d1
	move.b	d1,3*scrbw(a2)
	move.b	4*60(a3),d1
	move.b	d1,4*scrbw(a2)

.nfnd	addq.w	#1,curwrt
	addq.w	#1,a1
	moveq	#-2,d0
	bsr	drwcurs
.out	rts
.linex
	moveq	#0,d0
	bsr	drwcurs
	clr.w	curwrt
	add.w	#8*scrbw,curwrt+2


	tst.b	(a0)
	bpl.s	.procx
	clr.w	curstat
	cmp.b	#-1,(a0)
	beq.s	.procx
	move.b	(a0),tmode
	cmp.b	#-2,(a0)
	beq.s	.setcp
	move.l	tcurp,curwrt	
.procx
	move.w	curwrt,d0
	move.w	curwrt+2,d1
	add.w	d0,d1
	lea	txtsc+6+60*scrbw,a1
	add.w	d1,a1
	moveq	#-2,d0
	bsr	drwcurs
	rts
.setcp
	move.l	curwrt,tcurp
	rts

drwcurs	
	move.b	d0,-1*scrbw(a1)
	move.b	d0,(a1)
	move.b	d0,1*scrbw(a1)
	move.b	d0,2*scrbw(a1)
	move.b	d0,3*scrbw(a1)
	move.b	d0,4*scrbw(a1)
	move.b	d0,5*scrbw(a1)
	move.l	a1,ocurs
	rts	
ocurs	dc.l	txtsc
curstat	dc.w	1
curwrt	dc.w	0,0
currd	dc.l	text1
tmode	dc.w	0
tcurp	dc.w	0,0
inter
	IRQIN
	lea	$dff000,a6
	move.l	#txtsc,bpl1pth(a6)
	move.l	#txtsc,bpl5pth(a6)
	addq.w	#1,frco
	bcc.s	.nfrx
	move.w	#65535,frco
.nfrx	
	bsr	mtm
	IRQOUT
frco	dc.w	0
frcx	dc.w	0
patt
	dc.w	%0000000000000000
	dc.w	%0000000000000000

	dc.w	%0000000000000000
	dc.w	%1000100010001000

	dc.w	%0000000000000000
	dc.w	%1010101010101010

	dc.w	%0101010101010101
	dc.w	%1010101010101010

	dc.w	%0101010101010101
	dc.w	%1111111111111111

	dc.w	%0111011101110111
	dc.w	%1111111111111111

	dc.w	%1111111111111111
	dc.w	%1111111111111111

	dc.w	%1111111111111111
	dc.w	%1111111111111111

cpatt
	dc.w	0,0,0,0,0
	dc.w	%1010101010101010
	dc.w	%0101010101010101
	dc.w	%1010101010101010
	dc.w	%0101010101010101
	dc.w	%1010101010101010

	dc.w	%1111111111111111
	dc.w	%0111011101110111
	dc.w	%1111111111111111
	dc.w	%0111011101110111
	dc.w	%1111111111111111

	dc.w	%1111111111111111
	dc.w	%0101010101010101
	dc.w	%1111111111111111
	dc.w	%0101010101010101
	dc.w	%1111111111111111

	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000

	dc.w	%1010101010101010
	dc.w	%0101010101010101
	dc.w	%1010101010101010
	dc.w	%0101010101010101
	dc.w	%1010101010101010


	dc.w	%1010101010101010
	dc.w	%0000000000000000
	dc.w	%1010101010101010
	dc.w	%0000000000000000
	dc.w	%1010101010101010



	dc.w	%1000100010001000
	dc.w	%0000000000000000
	dc.w	%1000100010001000
	dc.w	%0000000000000000
	dc.w	%1000100010001000

	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000



	dc.w	%0001111100011111
	dc.w	%0001111100011111
	dc.w	%1111111111111111
	dc.w	%1111111111111111
	dc.w	%1111111111111111

	dc.w	%0001111100011111
	dc.w	%0001111100011111
	dc.w	%1111111111111111
	dc.w	%0001111100011111
	dc.w	%0001111100011111

	dc.w	%0001111100011111
	dc.w	%0001111100011111
	dc.w	%1111111111111111
	dc.w	%0001000000010000
	dc.w	%0001000000010000

	dc.w	%0001000000010000
	dc.w	%0001000000010000
	dc.w	%1111111111111111
	dc.w	%0001000000010000
	dc.w	%0001000000010000

	dc.w	%0001000000010000
	dc.w	%0001000000010000
	dc.w	%0001111100011111
	dc.w	%0001000000010000
	dc.w	%0001000000010000

	dc.w	%0001000000010000
	dc.w	%0001000000010000
	dc.w	%0001000000010000
	dc.w	%0001000000010000
	dc.w	%0001000000010000

	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0001000000010000
	dc.w	%0001000000010000
	dc.w	%0001000000010000

	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	


	TEXTE
otrtab	blk.b	trainanz,0
	EVEN
cop0	copmode	0,0,0,0,0
	dc.w	$180,0
	dc.l	-2


copper	copmode	5,0,0,0,0
	copddf	97,32,scrw,scrh
	copwin	113,32,scrw,scrh

	dc.w	$102,$ff
	copemod	0
	copomod	0
	dc.l	-2

copr1	copmode	0,0,0,0,0
	dc.w	$180,$fff
	dc.l	-2
copr2	copmode	1,0,0,0,0
	dc.w	$180,$0
c2c	dc.w	$182,$fff
	copddf	97,32,scrw,scrh
	copwin	113,32,scrw,scrh
	dc.l	-2



font:
;	incbin	"raw/tal8x5.font"

	dc.l	$609000,12,$60606060,8,$7C187C7C,$C6FE3EFE
	dc.l	$7C7C0000,$300060F0,$7CFC7E,$FCFEFE7C,$C6FC1EC6
	dc.l	$C0C6C67C,$FC7CFC7E,$FCCCC6C6,$C6C6FE00,$60D800
	dc.l	$18,$C030F0F0,$F80010,$E638C6C6,$C6C0600C
	dc.l	$C6C66060,$60703198,$C6C6C0,$C6C0C0C0,$C6300CCC
	dc.l	$C0EEE6C6,$C6C6C6C0,$30CCC6D6,$6C6C0C00,$604800,0
	dc.l	$C030F0F0,$F80020,$D6180C0C,$FEFCCC18,$7C7E0000
	dc.l	$C0001870,$FEFCC0,$C6F8F8CE,$FE300CF8,$C0FEF6C6
	dc.l	$FCD6FC7C,$30CC6CFE,$38383800,0,0,$C0306060
	dc.l	$60000040,$CE1838C6,$606C630,$C6066060,$60703000
	dc.l	$C6C6C0,$C6C0C0C6,$C630CCCC,$C0D6DEC6,$C0CAC606
	dc.l	$30CC7CEE,$6C186000,$600000,0,$60600000,$C000C080
	dc.l	$7C18FE7C,$6FC7C60,$7C0600C0,$30006060,$C6FC7E
	dc.l	$FCFEC07C,$C6FC78C6,$FEC6CE7C,$C074C6FC,$307838C6
	dc.l	$C618FE00

logo:
	dc.l	$FFFF87FF,$FFFE1FFF,$FF00FFFF,$FF803FFC,0
	dc.l	$1FFF007F,$FFFFFC01,$FFFFFFFF,$FFFF07FF,$FFFE0FFF
	dc.l	$FF00FFFF,$FF803FFF,$E0000000,$7FFFC07F,$FFFFFC01
	dc.l	$FFFFFFFF,$FFFC07FF,$FFFE03FF,$FF00FFFF,$FF803FFF
	dc.l	$FE000001,$FFFFF03F,$FFFFFC01,$FFFFFFFF,$FFF807FF
	dc.l	$FFFE00FF,$FF00FFFF,$FF803FFF,$FF800007,$FFFFF80F
	dc.l	$FFFFFC01,$FFFFFFFF,$FFE007FF,$FFFE007F,$FF00FFFF
	dc.l	$FF803FFF,$FFC0000F,$FFFFFE03,$FFFFFC01,$FFFFFFFF
	dc.l	$FFC007FF,$FFFE001F,$FF00FFFF,$FF803FFF,$FFE0000F
	dc.l	$FFFFFF80,$FFFFFC01,$FFFFFFFF,$FF8007FF,$FFFE0007
	dc.l	$FF00FFFF,$FF803FFF,$FFE0000F,$FFFFFFC0,$3FFFFC01
	dc.l	$FFFFFFFF,$FE0007FF,$FFFE0003,$FF00FFFF,$FF803FFF
	dc.l	$FFE0000F,$FFFFFFF0,$FFFFC01,$FFFFFFFF,$FC0007FF
	dc.l	$FFFE0000,$FF00FFFF,$FF803FFF,$FFE00007,$FFFFFFFC
	dc.l	$3FFFC01,$FFFFFFFF,$F00007FF,$FFFE0000,$3F00FFFF
	dc.l	$FF803FFF,$FFE00001,$FFFFFFFE,$FFFC01,$FFFFFFFF
	dc.l	$E00007FF,$FFFE0000,$1F00FFFF,$FF803FFF,$FFE00000
	dc.l	$7FFFFFFF,$803FFC01,$FFFFFFFF,$800007FF,$FFFE0000
	dc.l	$700FFFF,$FF803FFF,$FFE00000,$3FFFFFFF,$C00FFC01
	dc.l	$FFFFFFFF,$7FF,$FFFE0000,$100FFFF,$FF803FFF
	dc.l	$FFC00000,$FFFFFFF,$F003FC01,$FFFFFFFF,$7FF
	dc.l	$FFFE0000,$FFFF,$FF803FFF,$FF800000,$3FFFFFF
	dc.l	$FC00FC01,$FFFFFFFF,$7FF,$FFFE0000,$FFFF
	dc.l	$FF803FFF,$FE000000,$1FFFFFF,$FE003C01,$FFFFFFFF
	dc.l	$7FF,$FFFE0000,$FFFF,$FF803FFF,$C0000000,$7FFFFF
	dc.l	$FF800C01,$FFFFFFFF,$7FF,$FFFE0000,$FFFF
	dc.l	$FF800000,12,$1FFFFF,$FFE00001,$FFFFFFFF,$7FF
	dc.l	$FFFE0000,$FFFF,$FF800000,15,$FFFFF,$FFF00001
	dc.l	$FFFFFFFF,$7FF,$FFFE0000,$FFFF,$FF803000,15
	dc.l	$C003FFFF,$FFFC0001,$FFFFFFFF,$7FF,$FFFE0000
	dc.l	$FFFF,$FF803C00,15,$F000FFFF,$FFFF0001,$FFFFFFFF
	dc.l	$7FF,$FFFE0000,$FFFF,$FF803F80,15,$FC003FFF
	dc.l	$FFFF8001,$FFFFFFFF,$7FF,$FFFE0000,$FFFF
	dc.l	$FF803FE0,15,$FF001FFF,$FFFFE001,$FFFFFFFF,$7FF
	dc.l	$FFFE0000,$FFFF,$FF803FFC,15,$FFC007FF,$FFFFF801
	dc.l	$FFFFFFFF,$7FF,$FFFE0000,$FFFF,$FF803FFF
	dc.l	$8000000F,$FFF001FF,$FFFFFC01,$FFFFFFFF,$7FF
	dc.l	$FFFE0000,$FFFF,$FF803FFF,$E000000F,$FFFC00FF
	dc.l	$FFFFFC01,$FFFFFFFF,$7FF,$FFFE0000,$FFFF
	dc.l	$FF803FFF,$FC00000F,$FFFF003F,$FFFFFC01,$FFFFFFFF
	dc.l	$7FF,$FFFE0000,$FFFF,$FF803FFF,$FF00000F
	dc.l	$FFFFC00F,$FFFFFC01,$FFFFFFFF,$7FF,$FFFE0000
	dc.l	$FFFF,$FF803FFF,$FFE0000F,$FFFFF007,$FFFFF801
	dc.l	$FFFFFFFF,$7FF,$FFFE0000,$FFFF,$FF803FFF
	dc.l	$FFF8000F,$FFFFFC01,$FFFFF001,$FFFFFFFF,$7FF
	dc.l	$FFFE0000,$FFFF,$FF803FFF,$FFFE000F,$FFFFFF00
	dc.l	$7FFFC001,$FFFFFFFF,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.l	0

sinorig:		; wsintab1024

	dc.w	0,1,3,4,6,7,9,10,12,14,15,$11,$12,$14,$15,$17,$19
	dc.w	$1A,$1C,$1D,$1F,$20,$22,$24,$25,$27,$28,$2A,$2B
	dc.w	$2D,$2E,$30,$31,$33,$35,$36,$38,$39,$3B,$3C,$3E
	dc.w	$3F,$41,$42,$44,$45,$47,$48,$4A,$4B,$4D,$4E,$50
	dc.w	$51,$53,$54,$56,$57,$59,$5A,$5C,$5D,$5F,$60,$61
	dc.w	$63,$64,$66,$67,$69,$6A,$6C,$6D,$6E,$70,$71,$73
	dc.w	$74,$75,$77,$78,$7A,$7B,$7C,$7E,$7F,$80,$82,$83
	dc.w	$84,$86,$87,$88,$8A,$8B,$8C,$8E,$8F,$90,$92,$93
	dc.w	$94,$95,$97,$98,$99,$9B,$9C,$9D,$9E,$9F,$A1,$A2
	dc.w	$A3,$A4,$A6,$A7,$A8,$A9,$AA,$AB,$AD,$AE,$AF,$B0
	dc.w	$B1,$B2,$B3,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD
	dc.w	$BE,$BF,$C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9
	dc.w	$CA,$CB,$CC,$CD,$CE,$CF,$D0,$D1,$D2,$D3,$D3,$D4
	dc.w	$D5,$D6,$D7,$D8,$D9,$D9,$DA,$DB,$DC,$DD,$DD,$DE
	dc.w	$DF,$E0,$E1,$E1,$E2,$E3,$E3,$E4,$E5,$E6,$E6,$E7
	dc.w	$E8,$E8,$E9,$EA,$EA,$EB,$EB,$EC,$ED,$ED,$EE,$EE
	dc.w	$EF,$EF,$F0,$F1,$F1,$F2,$F2,$F3,$F3,$F4,$F4,$F4
	dc.w	$F5,$F5,$F6,$F6,$F7,$F7,$F7,$F8,$F8,$F9,$F9,$F9
	dc.w	$FA,$FA,$FA,$FB,$FB,$FB,$FB,$FC,$FC,$FC,$FC,$FD
	dc.w	$FD,$FD,$FD,$FE,$FE,$FE,$FE,$FE,$FE,$FF,$FF,$FF
	dc.w	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$100
	dc.w	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	dc.w	$FF,$FF,$FE,$FE,$FE,$FE,$FE,$FE,$FD,$FD,$FD,$FD
	dc.w	$FC,$FC,$FC,$FC,$FB,$FB,$FB,$FB,$FA,$FA,$FA,$F9
	dc.w	$F9,$F9,$F8,$F8,$F7,$F7,$F7,$F6,$F6,$F5,$F5,$F4
	dc.w	$F4,$F4,$F3,$F3,$F2,$F2,$F1,$F1,$F0,$EF,$EF,$EE
	dc.w	$EE,$ED,$ED,$EC,$EB,$EB,$EA,$EA,$E9,$E8,$E8,$E7
	dc.w	$E6,$E6,$E5,$E4,$E3,$E3,$E2,$E1,$E1,$E0,$DF,$DE
	dc.w	$DD,$DD,$DC,$DB,$DA,$D9,$D9,$D8,$D7,$D6,$D5,$D4
	dc.w	$D3,$D3,$D2,$D1,$D0,$CF,$CE,$CD,$CC,$CB,$CA,$C9
	dc.w	$C8,$C7,$C6,$C5,$C4,$C3,$C2,$C1,$C0,$BF,$BE,$BD
	dc.w	$BC,$BB,$BA,$B9,$B8,$B7,$B6,$B5,$B3,$B2,$B1,$B0
	dc.w	$AF,$AE,$AD,$AB,$AA,$A9,$A8,$A7,$A6,$A4,$A3,$A2
	dc.w	$A1,$9F,$9E,$9D,$9C,$9B,$99,$98,$97,$95,$94,$93
	dc.w	$92,$90,$8F,$8E,$8C,$8B,$8A,$88,$87,$86,$84,$83
	dc.w	$82,$80,$7F,$7E,$7C,$7B,$7A,$78,$77,$75,$74,$73
	dc.w	$71,$70,$6E,$6D,$6C,$6A,$69,$67,$66,$64,$63,$61
	dc.w	$60,$5F,$5D,$5C,$5A,$59,$57,$56,$54,$53,$51,$50
	dc.w	$4E,$4D,$4B,$4A,$48,$47,$45,$44,$42,$41,$3F,$3E
	dc.w	$3C,$3B,$39,$38,$36,$35,$33,$31,$30,$2E,$2D,$2B
	dc.w	$2A,$28,$27,$25,$24,$22,$20,$1F,$1D,$1C,$1A,$19
	dc.w	$17,$15,$14,$12,$11,15,14,12,10,9,7,6,4,3,1,0
	dc.w	$FFFF,$FFFD,$FFFC,$FFFA,$FFF9,$FFF7,$FFF6,$FFF4
	dc.w	$FFF2,$FFF1,$FFEF,$FFEE,$FFEC,$FFEB,$FFE9,$FFE7
	dc.w	$FFE6,$FFE4,$FFE3,$FFE1,$FFE0,$FFDE,$FFDC,$FFDB
	dc.w	$FFD9,$FFD8,$FFD6,$FFD5,$FFD3,$FFD2,$FFD0,$FFCF
	dc.w	$FFCD,$FFCB,$FFCA,$FFC8,$FFC7,$FFC5,$FFC4,$FFC2
	dc.w	$FFC1,$FFBF,$FFBE,$FFBC,$FFBB,$FFB9,$FFB8,$FFB6
	dc.w	$FFB5,$FFB3,$FFB2,$FFB0,$FFAF,$FFAD,$FFAC,$FFAA
	dc.w	$FFA9,$FFA7,$FFA6,$FFA4,$FFA3,$FFA1,$FFA0,$FF9F
	dc.w	$FF9D,$FF9C,$FF9A,$FF99,$FF97,$FF96,$FF94,$FF93
	dc.w	$FF92,$FF90,$FF8F,$FF8D,$FF8C,$FF8B,$FF89,$FF88
	dc.w	$FF86,$FF85,$FF84,$FF82,$FF81,$FF80,$FF7E,$FF7D
	dc.w	$FF7C,$FF7A,$FF79,$FF78,$FF76,$FF75,$FF74,$FF72
	dc.w	$FF71,$FF70,$FF6E,$FF6D,$FF6C,$FF6B,$FF69,$FF68
	dc.w	$FF67,$FF65,$FF64,$FF63,$FF62,$FF61,$FF5F,$FF5E
	dc.w	$FF5D,$FF5C,$FF5A,$FF59,$FF58,$FF57,$FF56,$FF55
	dc.w	$FF53,$FF52,$FF51,$FF50,$FF4F,$FF4E,$FF4D,$FF4B
	dc.w	$FF4A,$FF49,$FF48,$FF47,$FF46,$FF45,$FF44,$FF43
	dc.w	$FF42,$FF41,$FF40,$FF3F,$FF3E,$FF3D,$FF3C,$FF3B
	dc.w	$FF3A,$FF39,$FF38,$FF37,$FF36,$FF35,$FF34,$FF33
	dc.w	$FF32,$FF31,$FF30,$FF2F,$FF2E,$FF2D,$FF2D,$FF2C
	dc.w	$FF2B,$FF2A,$FF29,$FF28,$FF27,$FF27,$FF26,$FF25
	dc.w	$FF24,$FF23,$FF23,$FF22,$FF21,$FF20,$FF1F,$FF1F
	dc.w	$FF1E,$FF1D,$FF1D,$FF1C,$FF1B,$FF1A,$FF1A,$FF19
	dc.w	$FF18,$FF18,$FF17,$FF16,$FF16,$FF15,$FF15,$FF14
	dc.w	$FF13,$FF13,$FF12,$FF12,$FF11,$FF11,$FF10,$FF0F
	dc.w	$FF0F,$FF0E,$FF0E,$FF0D,$FF0D,$FF0C,$FF0C,$FF0C
	dc.w	$FF0B,$FF0B,$FF0A,$FF0A,$FF09,$FF09,$FF09,$FF08
	dc.w	$FF08,$FF07,$FF07,$FF07,$FF06,$FF06,$FF06,$FF05
	dc.w	$FF05,$FF05,$FF05,$FF04,$FF04,$FF04,$FF04,$FF03
	dc.w	$FF03,$FF03,$FF03,$FF02,$FF02,$FF02,$FF02,$FF02
	dc.w	$FF02,$FF01,$FF01,$FF01,$FF01,$FF01,$FF01,$FF01
	dc.w	$FF01,$FF01,$FF01,$FF01,$FF01,$FF01,$FF01,$FF00
	dc.w	$FF01,$FF01,$FF01,$FF01,$FF01,$FF01,$FF01,$FF01
	dc.w	$FF01,$FF01,$FF01,$FF01,$FF01,$FF01,$FF02,$FF02
	dc.w	$FF02,$FF02,$FF02,$FF02,$FF03,$FF03,$FF03,$FF03
	dc.w	$FF04,$FF04,$FF04,$FF04,$FF05,$FF05,$FF05,$FF05
	dc.w	$FF06,$FF06,$FF06,$FF07,$FF07,$FF07,$FF08,$FF08
	dc.w	$FF09,$FF09,$FF09,$FF0A,$FF0A,$FF0B,$FF0B,$FF0C
	dc.w	$FF0C,$FF0C,$FF0D,$FF0D,$FF0E,$FF0E,$FF0F,$FF0F
	dc.w	$FF10,$FF11,$FF11,$FF12,$FF12,$FF13,$FF13,$FF14
	dc.w	$FF15,$FF15,$FF16,$FF16,$FF17,$FF18,$FF18,$FF19
	dc.w	$FF1A,$FF1A,$FF1B,$FF1C,$FF1D,$FF1D,$FF1E,$FF1F
	dc.w	$FF1F,$FF20,$FF21,$FF22,$FF23,$FF23,$FF24,$FF25
	dc.w	$FF26,$FF27,$FF27,$FF28,$FF29,$FF2A,$FF2B,$FF2C
	dc.w	$FF2D,$FF2D,$FF2E,$FF2F,$FF30,$FF31,$FF32,$FF33
	dc.w	$FF34,$FF35,$FF36,$FF37,$FF38,$FF39,$FF3A,$FF3B
	dc.w	$FF3C,$FF3D,$FF3E,$FF3F,$FF40,$FF41,$FF42,$FF43
	dc.w	$FF44,$FF45,$FF46,$FF47,$FF48,$FF49,$FF4A,$FF4B
	dc.w	$FF4D,$FF4E,$FF4F,$FF50,$FF51,$FF52,$FF53,$FF55
	dc.w	$FF56,$FF57,$FF58,$FF59,$FF5A,$FF5C,$FF5D,$FF5E
	dc.w	$FF5F,$FF61,$FF62,$FF63,$FF64,$FF65,$FF67,$FF68
	dc.w	$FF69,$FF6B,$FF6C,$FF6D,$FF6E,$FF70,$FF71,$FF72
	dc.w	$FF74,$FF75,$FF76,$FF78,$FF79,$FF7A,$FF7C,$FF7D
	dc.w	$FF7E,$FF80,$FF81,$FF82,$FF84,$FF85,$FF86,$FF88
	dc.w	$FF89,$FF8B,$FF8C,$FF8D,$FF8F,$FF90,$FF92,$FF93
	dc.w	$FF94,$FF96,$FF97,$FF99,$FF9A,$FF9C,$FF9D,$FF9F
	dc.w	$FFA0,$FFA1,$FFA3,$FFA4,$FFA6,$FFA7,$FFA9,$FFAA
	dc.w	$FFAC,$FFAD,$FFAF,$FFB0,$FFB2,$FFB3,$FFB5,$FFB6
	dc.w	$FFB8,$FFB9,$FFBB,$FFBC,$FFBE,$FFBF,$FFC1,$FFC2
	dc.w	$FFC4,$FFC5,$FFC7,$FFC8,$FFCA,$FFCB,$FFCD,$FFCF
	dc.w	$FFD0,$FFD2,$FFD3,$FFD5,$FFD6,$FFD8,$FFD9,$FFDB
	dc.w	$FFDC,$FFDE,$FFE0,$FFE1,$FFE3,$FFE4,$FFE6,$FFE7
	dc.w	$FFE9,$FFEB,$FFEC,$FFEE,$FFEF,$FFF1,$FFF2,$FFF4
	dc.w	$FFF6,$FFF7,$FFF9,$FFFA,$FFFC,$FFFD,$FFFF,0,1,3,4
	dc.w	6,7,9,10,12,14,15,$11,$12,$14,$15,$17,$19,$1A,$1C
	dc.w	$1D,$1F,$20,$22,$24,$25,$27,$28,$2A,$2B,$2D,$2E
	dc.w	$30,$31,$33,$35,$36,$38,$39,$3B,$3C,$3E,$3F,$41
	dc.w	$42,$44,$45,$47,$48,$4A,$4B,$4D,$4E,$50,$51,$53
	dc.w	$54,$56,$57,$59,$5A,$5C,$5D,$5F,$60,$61,$63,$64
	dc.w	$66,$67,$69,$6A,$6C,$6D,$6E,$70,$71,$73,$74,$75
	dc.w	$77,$78,$7A,$7B,$7C,$7E,$7F,$80,$82,$83,$84,$86
	dc.w	$87,$88,$8A,$8B,$8C,$8E,$8F,$90,$92,$93,$94,$95
	dc.w	$97,$98,$99,$9B,$9C,$9D,$9E,$9F,$A1,$A2,$A3,$A4
	dc.w	$A6,$A7,$A8,$A9,$AA,$AB,$AD,$AE,$AF,$B0,$B1,$B2
	dc.w	$B3,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF
	dc.w	$C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9,$CA,$CB
	dc.w	$CC,$CD,$CE,$CF,$D0,$D1,$D2,$D3,$D3,$D4,$D5,$D6
	dc.w	$D7,$D8,$D9,$D9,$DA,$DB,$DC,$DD,$DD,$DE,$DF,$E0
	dc.w	$E1,$E1,$E2,$E3,$E3,$E4,$E5,$E6,$E6,$E7,$E8,$E8
	dc.w	$E9,$EA,$EA,$EB,$EB,$EC,$ED,$ED,$EE,$EE,$EF,$EF
	dc.w	$F0,$F1,$F1,$F2,$F2,$F3,$F3,$F4,$F4,$F4,$F5,$F5
	dc.w	$F6,$F6,$F7,$F7,$F7,$F8,$F8,$F9,$F9,$F9,$FA,$FA
	dc.w	$FA,$FB,$FB,$FB,$FB,$FC,$FC,$FC,$FC,$FD,$FD,$FD
	dc.w	$FD,$FE,$FE,$FE,$FE,$FE,$FE,$FF,$FF,$FF,$FF,$FF
	dc.w	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$100,$FF,$FF
	dc.w	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	dc.w	$FE,$FE,$FE,$FE,$FE,$FE,$FD,$FD,$FD,$FD,$FC,$FC
	dc.w	$FC,$FC,$FB,$FB,$FB,$FB,$FA,$FA,$FA,$F9,$F9,$F9
	dc.w	$F8,$F8,$F7,$F7,$F7,$F6,$F6,$F5,$F5,$F4,$F4,$F4
	dc.w	$F3,$F3,$F2,$F2,$F1,$F1,$F0,$EF,$EF,$EE,$EE,$ED
	dc.w	$ED,$EC,$EB,$EB,$EA,$EA,$E9,$E8,$E8,$E7,$E6,$E6
	dc.w	$E5,$E4,$E3,$E3,$E2,$E1,$E1,$E0,$DF,$DE,$DD,$DD
	dc.w	$DC,$DB,$DA,$D9,$D9,$D8,$D7,$D6,$D5,$D4,$D3,$D3
	dc.w	$D2,$D1,$D0,$CF,$CE,$CD,$CC,$CB,$CA,$C9,$C8,$C7
	dc.w	$C6,$C5,$C4,$C3,$C2,$C1,$C0,$BF,$BE,$BD,$BC,$BB
	dc.w	$BA,$B9,$B8,$B7,$B6,$B5,$B3,$B2,$B1,$B0,$AF,$AE
	dc.w	$AD,$AB,$AA,$A9,$A8,$A7,$A6,$A4,$A3,$A2,$A1,$9F
	dc.w	$9E,$9D,$9C,$9B,$99,$98,$97,$95,$94,$93,$92,$90
	dc.w	$8F,$8E,$8C,$8B,$8A,$88,$87,$86,$84,$83,$82,$80
	dc.w	$7F,$7E,$7C,$7B,$7A,$78,$77,$75,$74,$73,$71,$70
	dc.w	$6E,$6D,$6C,$6A,$69,$67,$66,$64,$63,$61,$60,$5F
	dc.w	$5D,$5C,$5A,$59,$57,$56,$54,$53,$51,$50,$4E,$4D
	dc.w	$4B,$4A,$48,$47,$45,$44,$42,$41,$3F,$3E,$3C,$3B
	dc.w	$39,$38,$36,$35,$33,$31,$30,$2E,$2D,$2B,$2A,$28
	dc.w	$27,$25,$24,$22,$20,$1F,$1D,$1C,$1A,$19,$17,$15
	dc.w	$14,$12,$11,15,14,12,10,9,7,6,4,3,1,0,$FFFF,$FFFD
	dc.w	$FFFC,$FFFA,$FFF9,$FFF7,$FFF6,$FFF4,$FFF2,$FFF1
	dc.w	$FFEF,$FFEE,$FFEC,$FFEB,$FFE9,$FFE7,$FFE6,$FFE4
	dc.w	$FFE3,$FFE1,$FFE0,$FFDE,$FFDC,$FFDB,$FFD9,$FFD8
	dc.w	$FFD6,$FFD5,$FFD3,$FFD2,$FFD0,$FFCF,$FFCD,$FFCB
	dc.w	$FFCA,$FFC8,$FFC7,$FFC5,$FFC4,$FFC2,$FFC1,$FFBF
	dc.w	$FFBE,$FFBC,$FFBB,$FFB9,$FFB8,$FFB6,$FFB5,$FFB3
	dc.w	$FFB2,$FFB0,$FFAF,$FFAD,$FFAC,$FFAA,$FFA9,$FFA7
	dc.w	$FFA6,$FFA4,$FFA3,$FFA1,$FFA0,$FF9F,$FF9D,$FF9C
	dc.w	$FF9A,$FF99,$FF97,$FF96,$FF94,$FF93,$FF92,$FF90
	dc.w	$FF8F,$FF8D,$FF8C,$FF8B,$FF89,$FF88,$FF86,$FF85
	dc.w	$FF84,$FF82,$FF81,$FF80,$FF7E,$FF7D,$FF7C,$FF7A
	dc.w	$FF79,$FF78,$FF76,$FF75,$FF74,$FF72,$FF71,$FF70
	dc.w	$FF6E,$FF6D,$FF6C,$FF6B,$FF69,$FF68,$FF67,$FF65
	dc.w	$FF64,$FF63,$FF62,$FF61,$FF5F,$FF5E,$FF5D,$FF5C
	dc.w	$FF5A,$FF59,$FF58,$FF57,$FF56,$FF55,$FF53,$FF52
	dc.w	$FF51,$FF50,$FF4F,$FF4E,$FF4D,$FF4B,$FF4A,$FF49
	dc.w	$FF48,$FF47,$FF46,$FF45,$FF44,$FF43,$FF42,$FF41
	dc.w	$FF40,$FF3F,$FF3E,$FF3D,$FF3C,$FF3B,$FF3A,$FF39
	dc.w	$FF38,$FF37,$FF36,$FF35,$FF34,$FF33,$FF32,$FF31
	dc.w	$FF30,$FF2F,$FF2E,$FF2D,$FF2D,$FF2C,$FF2B,$FF2A
	dc.w	$FF29,$FF28,$FF27,$FF27,$FF26,$FF25,$FF24,$FF23
	dc.w	$FF23,$FF22,$FF21,$FF20,$FF1F,$FF1F,$FF1E,$FF1D
	dc.w	$FF1D,$FF1C,$FF1B,$FF1A,$FF1A,$FF19,$FF18,$FF18
	dc.w	$FF17,$FF16,$FF16,$FF15,$FF15,$FF14,$FF13,$FF13
	dc.w	$FF12,$FF12,$FF11,$FF11,$FF10,$FF0F,$FF0F,$FF0E
	dc.w	$FF0E,$FF0D,$FF0D,$FF0C,$FF0C,$FF0C,$FF0B,$FF0B
	dc.w	$FF0A,$FF0A,$FF09,$FF09,$FF09,$FF08,$FF08,$FF07
	dc.w	$FF07,$FF07,$FF06,$FF06,$FF06,$FF05,$FF05,$FF05
	dc.w	$FF05,$FF04,$FF04,$FF04,$FF04,$FF03,$FF03,$FF03
	dc.w	$FF03,$FF02,$FF02,$FF02,$FF02,$FF02,$FF02,$FF01
	dc.w	$FF01,$FF01,$FF01,$FF01,$FF01,$FF01,$FF01,$FF01
	dc.w	$FF01,$FF01,$FF01,$FF01,$FF01,$FF00,$FF01,$FF01
	dc.w	$FF01,$FF01,$FF01,$FF01,$FF01,$FF01,$FF01,$FF01
	dc.w	$FF01,$FF01,$FF01,$FF01,$FF02,$FF02,$FF02,$FF02
	dc.w	$FF02,$FF02,$FF03,$FF03,$FF03,$FF03,$FF04,$FF04
	dc.w	$FF04,$FF04,$FF05,$FF05,$FF05,$FF05,$FF06,$FF06
	dc.w	$FF06,$FF07,$FF07,$FF07,$FF08,$FF08,$FF09,$FF09
	dc.w	$FF09,$FF0A,$FF0A,$FF0B,$FF0B,$FF0C,$FF0C,$FF0C
	dc.w	$FF0D,$FF0D,$FF0E,$FF0E,$FF0F,$FF0F,$FF10,$FF11
	dc.w	$FF11,$FF12,$FF12,$FF13,$FF13,$FF14,$FF15,$FF15
	dc.w	$FF16,$FF16,$FF17,$FF18,$FF18,$FF19,$FF1A,$FF1A
	dc.w	$FF1B,$FF1C,$FF1D,$FF1D,$FF1E,$FF1F,$FF1F,$FF20
	dc.w	$FF21,$FF22,$FF23,$FF23,$FF24,$FF25,$FF26,$FF27
	dc.w	$FF27,$FF28,$FF29,$FF2A,$FF2B,$FF2C,$FF2D,$FF2D
	dc.w	$FF2E,$FF2F,$FF30,$FF31,$FF32,$FF33,$FF34,$FF35
	dc.w	$FF36,$FF37,$FF38,$FF39,$FF3A,$FF3B,$FF3C,$FF3D
	dc.w	$FF3E,$FF3F,$FF40,$FF41,$FF42,$FF43,$FF44,$FF45
	dc.w	$FF46,$FF47,$FF48,$FF49,$FF4A,$FF4B,$FF4D,$FF4E
	dc.w	$FF4F,$FF50,$FF51,$FF52,$FF53,$FF55,$FF56,$FF57
	dc.w	$FF58,$FF59,$FF5A,$FF5C,$FF5D,$FF5E,$FF5F,$FF61
	dc.w	$FF62,$FF63,$FF64,$FF65,$FF67,$FF68,$FF69,$FF6B
	dc.w	$FF6C,$FF6D,$FF6E,$FF70,$FF71,$FF72,$FF74,$FF75
	dc.w	$FF76,$FF78,$FF79,$FF7A,$FF7C,$FF7D,$FF7E,$FF80
	dc.w	$FF81,$FF82,$FF84,$FF85,$FF86,$FF88,$FF89,$FF8B
	dc.w	$FF8C,$FF8D,$FF8F,$FF90,$FF92,$FF93,$FF94,$FF96
	dc.w	$FF97,$FF99,$FF9A,$FF9C,$FF9D,$FF9F,$FFA0,$FFA1
	dc.w	$FFA3,$FFA4,$FFA6,$FFA7,$FFA9,$FFAA,$FFAC,$FFAD
	dc.w	$FFAF,$FFB0,$FFB2,$FFB3,$FFB5,$FFB6,$FFB8,$FFB9
	dc.w	$FFBB,$FFBC,$FFBE,$FFBF,$FFC1,$FFC2,$FFC4,$FFC5
	dc.w	$FFC7,$FFC8,$FFCA,$FFCB,$FFCD,$FFCF,$FFD0,$FFD2
	dc.w	$FFD3,$FFD5,$FFD6,$FFD8,$FFD9,$FFDB,$FFDC,$FFDE
	dc.w	$FFE0,$FFE1,$FFE3,$FFE4,$FFE6,$FFE7,$FFE9,$FFEB
	dc.w	$FFEC,$FFEE,$FFEF,$FFF1,$FFF2,$FFF4,$FFF6,$FFF7
	dc.w	$FFF9,$FFFA,$FFFC,$FFFD,$FFFF,0,1,3,4,6,7,9,10,12
	dc.w	14,15,$11,$12,$14,$15,$17,$19,$1A,$1C,$1D,$1F,$20
	dc.w	$22,$24,$25,$27,$28,$2A,$2B,$2D,$2E,$30,$31,$33
	dc.w	$35,$36,$38,$39,$3B,$3C,$3E,$3F,$41,$42,$44,$45
	dc.w	$47,$48,$4A,$4B,$4D,$4E,$50,$51,$53,$54,$56,$57
	dc.w	$59,$5A,$5C,$5D,$5F,$60,$61,$63,$64,$66,$67,$69
	dc.w	$6A,$6C,$6D,$6E,$70,$71,$73,$74,$75,$77,$78,$7A
	dc.w	$7B,$7C,$7E,$7F,$80,$82,$83,$84,$86,$87,$88,$8A
	dc.w	$8B,$8C,$8E,$8F,$90,$92,$93,$94,$95,$97,$98,$99
	dc.w	$9B,$9C,$9D,$9E,$9F,$A1,$A2,$A3,$A4,$A6,$A7,$A8
	dc.w	$A9,$AA,$AB,$AD,$AE,$AF,$B0,$B1,$B2,$B3,$B5,$B6
	dc.w	$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,$C0,$C1,$C2
	dc.w	$C3,$C4,$C5,$C6,$C7,$C8,$C9,$CA,$CB,$CC,$CD,$CE
	dc.w	$CF,$D0,$D1,$D2,$D3,$D3,$D4,$D5,$D6,$D7,$D8,$D9
	dc.w	$D9,$DA,$DB,$DC,$DD,$DD,$DE,$DF,$E0,$E1,$E1,$E2
	dc.w	$E3,$E3,$E4,$E5,$E6,$E6,$E7,$E8,$E8,$E9,$EA,$EA
	dc.w	$EB,$EB,$EC,$ED,$ED,$EE,$EE,$EF,$EF,$F0,$F1,$F1
	dc.w	$F2,$F2,$F3,$F3,$F4,$F4,$F4,$F5,$F5,$F6,$F6,$F7
	dc.w	$F7,$F7,$F8,$F8,$F9,$F9,$F9,$FA,$FA,$FA,$FB,$FB
	dc.w	$FB,$FB,$FC,$FC,$FC,$FC,$FD,$FD,$FD,$FD,$FE,$FE
	dc.w	$FE,$FE,$FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	dc.w	$FF,$FF,$FF,$FF,$FF,$FF,$100,$FF,$FF,$FF,$FF,$FF
	dc.w	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FE,$FE
	dc.w	$FE,$FE,$FE,$FD,$FD,$FD,$FD,$FC,$FC,$FC,$FC,$FB
	dc.w	$FB,$FB,$FB,$FA,$FA,$FA,$F9,$F9,$F9,$F8,$F8,$F7
	dc.w	$F7,$F7,$F6,$F6,$F5,$F5,$F4,$F4,$F4,$F3,$F3,$F2
	dc.w	$F2,$F1,$F1,$F0,$EF,$EF,$EE,$EE,$ED,$ED,$EC,$EB
	dc.w	$EB,$EA,$EA,$E9,$E8,$E8,$E7,$E6,$E6,$E5,$E4,$E3
	dc.w	$E3,$E2,$E1,$E1,$E0,$DF,$DE,$DD,$DD,$DC,$DB,$DA
	dc.w	$D9,$D9,$D8,$D7,$D6,$D5,$D4,$D3,$D3,$D2,$D1,$D0
	dc.w	$CF,$CE,$CD,$CC,$CB,$CA,$C9,$C8,$C7,$C6,$C5,$C4
	dc.w	$C3,$C2,$C1,$C0,$BF,$BE,$BD,$BC,$BB,$BA,$B9,$B8
	dc.w	$B7,$B6,$B5,$B3,$B2,$B1,$B0,$AF,$AE,$AD,$AB,$AA
	dc.w	$A9,$A8,$A7,$A6,$A4,$A3,$A2,$A1,$9F,$9E,$9D,$9C
	dc.w	$9B,$99,$98,$97,$95,$94,$93,$92,$90,$8F,$8E,$8C
	dc.w	$8B,$8A,$88,$87,$86,$84,$83,$82,$80,$7F,$7E,$7C
	dc.w	$7B,$7A,$78,$77,$75,$74,$73,$71,$70,$6E,$6D,$6C
	dc.w	$6A,$69,$67,$66,$64,$63,$61,$60,$5F,$5D,$5C,$5A
	dc.w	$59,$57,$56,$54,$53,$51,$50,$4E,$4D,$4B,$4A,$48
	dc.w	$47,$45,$44,$42,$41,$3F,$3E,$3C,$3B,$39,$38,$36
	dc.w	$35,$33,$31,$30,$2E,$2D,$2B,$2A,$28,$27,$25,$24
	dc.w	$22,$20,$1F,$1D,$1C,$1A,$19,$17,$15,$14,$12,$11
	dc.w	15,14,12,10,9,7,6,4,3,1,0,$FFFF,$FFFD,$FFFC,$FFFA
	dc.w	$FFF9,$FFF7,$FFF6,$FFF4,$FFF2,$FFF1,$FFEF,$FFEE
	dc.w	$FFEC,$FFEB,$FFE9,$FFE7,$FFE6,$FFE4,$FFE3,$FFE1
	dc.w	$FFE0,$FFDE,$FFDC,$FFDB,$FFD9,$FFD8,$FFD6,$FFD5
	dc.w	$FFD3,$FFD2,$FFD0,$FFCF,$FFCD,$FFCB,$FFCA,$FFC8
	dc.w	$FFC7,$FFC5,$FFC4,$FFC2,$FFC1,$FFBF,$FFBE,$FFBC
	dc.w	$FFBB,$FFB9,$FFB8,$FFB6,$FFB5,$FFB3,$FFB2,$FFB0
	dc.w	$FFAF,$FFAD,$FFAC,$FFAA,$FFA9,$FFA7,$FFA6,$FFA4
	dc.w	$FFA3,$FFA1,$FFA0,$FF9F,$FF9D,$FF9C,$FF9A,$FF99
	dc.w	$FF97,$FF96,$FF94,$FF93,$FF92,$FF90,$FF8F,$FF8D
	dc.w	$FF8C,$FF8B,$FF89,$FF88,$FF86,$FF85,$FF84,$FF82
	dc.w	$FF81,$FF80,$FF7E,$FF7D,$FF7C,$FF7A,$FF79,$FF78
	dc.w	$FF76,$FF75,$FF74,$FF72,$FF71,$FF70,$FF6E,$FF6D
	dc.w	$FF6C,$FF6B,$FF69,$FF68,$FF67,$FF65,$FF64,$FF63
	dc.w	$FF62,$FF61,$FF5F,$FF5E,$FF5D,$FF5C,$FF5A,$FF59
	dc.w	$FF58,$FF57,$FF56,$FF55,$FF53,$FF52,$FF51,$FF50
	dc.w	$FF4F,$FF4E,$FF4D,$FF4B,$FF4A,$FF49,$FF48,$FF47
	dc.w	$FF46,$FF45,$FF44,$FF43,$FF42,$FF41,$FF40,$FF3F
	dc.w	$FF3E,$FF3D,$FF3C,$FF3B,$FF3A,$FF39,$FF38,$FF37
	dc.w	$FF36,$FF35,$FF34,$FF33,$FF32,$FF31,$FF30,$FF2F
	dc.w	$FF2E,$FF2D,$FF2D,$FF2C,$FF2B,$FF2A,$FF29,$FF28
	dc.w	$FF27,$FF27,$FF26,$FF25,$FF24,$FF23,$FF23,$FF22
	dc.w	$FF21,$FF20,$FF1F,$FF1F,$FF1E,$FF1D,$FF1D,$FF1C
	dc.w	$FF1B,$FF1A,$FF1A,$FF19,$FF18,$FF18,$FF17,$FF16
	dc.w	$FF16,$FF15,$FF15,$FF14,$FF13,$FF13,$FF12,$FF12
	dc.w	$FF11,$FF11,$FF10,$FF0F,$FF0F,$FF0E,$FF0E,$FF0D
	dc.w	$FF0D,$FF0C,$FF0C,$FF0C,$FF0B,$FF0B,$FF0A,$FF0A
	dc.w	$FF09,$FF09,$FF09,$FF08,$FF08,$FF07,$FF07,$FF07
	dc.w	$FF06,$FF06,$FF06,$FF05,$FF05,$FF05,$FF05,$FF04
	dc.w	$FF04,$FF04,$FF04,$FF03,$FF03,$FF03,$FF03,$FF02
	dc.w	$FF02,$FF02,$FF02,$FF02,$FF02,$FF01,$FF01,$FF01
	dc.w	$FF01,$FF01,$FF01,$FF01,$FF01,$FF01,$FF01,$FF01
	dc.w	$FF01,$FF01,$FF01,$FF00,$FF01,$FF01,$FF01,$FF01
	dc.w	$FF01,$FF01,$FF01,$FF01,$FF01,$FF01,$FF01,$FF01
	dc.w	$FF01,$FF01,$FF02,$FF02,$FF02,$FF02,$FF02,$FF02
	dc.w	$FF03,$FF03,$FF03,$FF03,$FF04,$FF04,$FF04,$FF04
	dc.w	$FF05,$FF05,$FF05,$FF05,$FF06,$FF06,$FF06,$FF07
	dc.w	$FF07,$FF07,$FF08,$FF08,$FF09,$FF09,$FF09,$FF0A
	dc.w	$FF0A,$FF0B,$FF0B,$FF0C,$FF0C,$FF0C,$FF0D,$FF0D
	dc.w	$FF0E,$FF0E,$FF0F,$FF0F,$FF10,$FF11,$FF11,$FF12
	dc.w	$FF12,$FF13,$FF13,$FF14,$FF15,$FF15,$FF16,$FF16
	dc.w	$FF17,$FF18,$FF18,$FF19,$FF1A,$FF1A,$FF1B,$FF1C
	dc.w	$FF1D,$FF1D,$FF1E,$FF1F,$FF1F,$FF20,$FF21,$FF22
	dc.w	$FF23,$FF23,$FF24,$FF25,$FF26,$FF27,$FF27,$FF28
	dc.w	$FF29,$FF2A,$FF2B,$FF2C,$FF2D,$FF2D,$FF2E,$FF2F
	dc.w	$FF30,$FF31,$FF32,$FF33,$FF34,$FF35,$FF36,$FF37
	dc.w	$FF38,$FF39,$FF3A,$FF3B,$FF3C,$FF3D,$FF3E,$FF3F
	dc.w	$FF40,$FF41,$FF42,$FF43,$FF44,$FF45,$FF46,$FF47
	dc.w	$FF48,$FF49,$FF4A,$FF4B,$FF4D,$FF4E,$FF4F,$FF50
	dc.w	$FF51,$FF52,$FF53,$FF55,$FF56,$FF57,$FF58,$FF59
	dc.w	$FF5A,$FF5C,$FF5D,$FF5E,$FF5F,$FF61,$FF62,$FF63
	dc.w	$FF64,$FF65,$FF67,$FF68,$FF69,$FF6B,$FF6C,$FF6D
	dc.w	$FF6E,$FF70,$FF71,$FF72,$FF74,$FF75,$FF76,$FF78
	dc.w	$FF79,$FF7A,$FF7C,$FF7D,$FF7E,$FF80,$FF81,$FF82
	dc.w	$FF84,$FF85,$FF86,$FF88,$FF89,$FF8B,$FF8C,$FF8D
	dc.w	$FF8F,$FF90,$FF92,$FF93,$FF94,$FF96,$FF97,$FF99
	dc.w	$FF9A,$FF9C,$FF9D,$FF9F,$FFA0,$FFA1,$FFA3,$FFA4
	dc.w	$FFA6,$FFA7,$FFA9,$FFAA,$FFAC,$FFAD,$FFAF,$FFB0
	dc.w	$FFB2,$FFB3,$FFB5,$FFB6,$FFB8,$FFB9,$FFBB,$FFBC
	dc.w	$FFBE,$FFBF,$FFC1,$FFC2,$FFC4,$FFC5,$FFC7,$FFC8
	dc.w	$FFCA,$FFCB,$FFCD,$FFCF,$FFD0,$FFD2,$FFD3,$FFD5
	dc.w	$FFD6,$FFD8,$FFD9,$FFDB,$FFDC,$FFDE,$FFE0,$FFE1
	dc.w	$FFE3,$FFE4,$FFE6,$FFE7,$FFE9,$FFEB,$FFEC,$FFEE
	dc.w	$FFEF,$FFF1,$FFF2,$FFF4,$FFF6,$FFF7,$FFF9,$FFFA
	dc.w	$FFFC,$FFFD,$FFFF


p2log
	dc.w	%11111111111100
	dc.w	%10000110110100
	dc.w	%11110010110100
	dc.w	%10000110110100
	dc.w	%10011110110100
	dc.w	%10011110110100
	dc.w	%11111111111100
mti	MT_INIT
mte	MT_EXIT
mtm	MT_VBL

ende	
	printt	"Soviel is schon wech:"
	printv	ende-anf
	section	"Würg",bss_c
multab	ds.w	scrh

caddt	ds.w	scrh

ccoltab	ds.w	zomanz
cstab	ds.w	zomanz-2
cstabe	ds.w	1

cop1	ds.l	scrh*9+20
cop1x	ds.l	1
cop2	ds.l	scrh*9+20
cop2x	ds.l	1

logosc	ds.w	32*scrbw
txtsc	ds.w	scrbw*scrh/2

zomscr	ds.w	zomanz*scrbw


zscr11	ds.w	scrbw+2
zscr12	ds.w	scrbw+2
zscr13	ds.w	scrbw+2
zscr14	ds.w	scrbw+2
zscr21	ds.w	scrbw+2
zscr22	ds.w	scrbw+2
zscr23	ds.w	scrbw+2
zscr24	ds.w	scrbw+2

	ds.w	100
sin	ds.w	3072
memx
