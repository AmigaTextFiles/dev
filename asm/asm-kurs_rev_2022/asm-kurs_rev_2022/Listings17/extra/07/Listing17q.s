
; Listings17q.s = intro-gammelok.s	; A1200 config

; ------------------------------------------------------------------
;
; Crackintro #2 from Ply-2/TRSi
;
; ------------------------------------------------------------------
;
; Crunched lenght is 3.5 Kilobytes (max. 4 KB)
;
; Include a Replayer if you want...
;
; Well, edit the text in line ...280 ff (up to l.300)
;
; For any questions call me or Ply-2
;
;
; Later, yours CONtROL/TRSi
;
; ------------------------------------------------------------------
;
;
;
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
scrw	equ	1008
scrbw	equ	scrw/8
scrh	equ	256
tbw	equ	368/8
tth	equ	80
bth	equ	160
anf
	DEFPLN
	DEFBLIT
	INIT	cop0,inter,0
	SPROFF
	GENMULW	multab,0,scrbw,scrh
	bsr	drawlogo
	bsr	copylogo
	lea	toptxt,a0
	lea	tpage+20*3*tbw,a1
	bsr	drawtext
	lea	text,a0
	lea	bpage+12*3*tbw+2,a1
	bsr	drawtext
	WVBL
	move.w	#0,scrloff
	WVBL
	STARTC	#copper
	moveq	#110,d0
al
	WVBL
	dbf	d0,al
mainloop
	tst.w	scroll1
	beq.s	.out
	msloop	mainloop
.out
	move.w	#1,scrloff
	SETFADESTRUCT #rpal1,#2,fadst
	bsr	wfad
	SETFADESTRUCT #rpal2,#2,fadst
	bsr	wfad
	SETFADESTRUCT #xpal,#2,fadst	
	bsr	wfad
	bra.w	prgx

prgx
	EXIT
wfad	moveq	#31,d0
.lop	WVBL
	addq.w	#4,tscrl
	cmp.w	#73*4,tscrl
	bcs	.nbut
	move.w	#73*4,tscrl	

.nbut	dbf	d0,.lop
	rts
	
;; ******* TEXT MALEN *********
drawtext
.lin	
	move.l	a1,-(sp)
.llop	
	move.b	(a0)+,d0
	tst.b	d0
	beq.s	.linex
	lea	asctab,a2
	lea	font,a3
.srclp	
	tst.b	(a2)
	beq.s	.nfnd
	cmp.b	(a2)+,d0
	beq.s	.found
	addq.l	#1,a3
	bra.s	.srclp
.found
	move.l	a1,a2
	moveq	#7,d0
.ylop	move.b	(a3),d1
	move.b	d1,(a2)
	move.b	42(a3),d1
	move.b	d1,tbw(a2)
	move.b	2*42(a3),d1
	move.b	d1,2*tbw(a2)
	add.w	#3*42,a3
	add.w	#3*tbw,a2
	dbf	d0,.ylop
.nfnd	addq.l	#1,a1
	bra.s	.llop
.linex
	move.l	(sp)+,a1
	add.w	#tbw*3*15,a1
	cmp.b	#-1,(a0)
	bne.s	.lin
	rts
	
;; ******* LOGO KOPIEREN *****
copylogo
	WBLIT
	moveq	#15,d7
	SETADMOD scrbw,0
	BLITD	#scrbuf
	moveq	#0,d6
.loop
	move.w	d6,d5
	REGADJ	d5,%1001,%11110000,0
	BLITA	#logscr
	DOBLIT	scrbw/2,scrh/2
	WBLIT
	WBLIT
	addq.w	#1,d6
	dbf	d7,.loop	
	rts

;; ******* LOGO MALEN *****
drawlogo
	WBLIT
	flineinit scrw
	lea	vec+12,a0
	lea	multab,a3
.oloop	movem.w	(a0)+,d0/d1
	movem.w	d0/d1,-(sp)
.iloop
	movem.w	(a0)+,d2/d3
	cmp.w	#32768,d2
	beq.s	.eofl
	movem.w	d2/d3,-(sp)
	bsr	drawl
	movem.w	(sp)+,d0/d1
	bra.s	.iloop
.eofl	move.w	d3,d6
	movem.w	(sp)+,d2/d3
	bsr	drawl
	tst.w	d6
	beq.s	.oloop
	PROCOFF
	WBLIT
	FIXADJ 0,%1001,%11110000,5
	setadmod 0,0
	move.l	#-1,bltafwm(a6)
	BLITA	#logscr+scrbw*scrh-2
	BLITD	#logscr+scrbw*scrh-2
	DOBLIT	scrbw/2,scrh
	rts

drawl	add.w	d0,d0
	add.w	d2,d2
	add.w	#352,d0
	add.w	#352,d2
	fline	#logscr
inter
	IRQIN
	lea	$dff000,a6

	move.l	#tpage,bpl1pth(a6)
	move.l	#tpage+tbw,bpl2pth(a6)
	move.l	#tpage+2*tbw,bpl3pth(a6)
	sub.w	#1,tscrl
	bpl.s	.nto
	move.w	#0,tscrl
.nto
	move.w	tscrl,d0
	lsr.w	#2,d0
	add.w	#25,d0
	move.b	d0,tyscrl
	

	lea	scroll1,a0
	bsr	calcs
	move.w	d1,lc2+6
	swap	d1
	move.w	d1,lc2+2

	move.w	d2,lc1+6
	swap	d2
	move.w	d2,lc1+2

	lea	scroll2,a0
	bsr	calcs
	move.w	d1,lc3+6
	swap	d1
	move.w	d1,lc3+2

	move.w	d2,lc4+6
	swap	d2
	move.w	d2,lc4+2

	lea	scroll3,a0
	bsr	calcs
	move.w	d1,lc5+6
	swap	d1
	move.w	d1,lc5+2

	move.l	#bpage,d1
	move.w	d1,bc1+6
	swap	d1
	move.w	d1,bc1+2
	move.l	#bpage+tbw,d1
	move.w	d1,bc2+6
	swap	d1
	move.w	d1,bc2+2
	move.l	#bpage+2*tbw,d1
	move.w	d1,bc3+6
	swap	d1
	move.w	d1,bc3+2

;	move.l	#fpage,bpl1pth(a6)
;	move.l	#fpage+scrbw*scrh/2,bpl3pth(a6)
;	move.l	#fpage+scrbw*scrh,bpl5pth(a6)
	
	subq.w	#1,bfco
	bne.s	.nfls

	lea	bcl+4,a0
	moveq	#6,d0
.bcll	move.w	#$fff,2(a0)
	addq.l	#4,a0
	dbf	d0,.bcll	
.nfls

	tst.w	bfco
	bpl.s	.nfad
	lea	fadst,a1
	lea	bcl,a2
	bsr	cf
.nfad
	IRQOUT
bfco	dc.w	100
fadst	fadestruct bpal,8,2

calcs
	move.w	(a0),d0
	add.w	2(a0),d0
	tst.w	scrloff
	bne.s	.scro
	cmp.w	#scrw,d0
	bcs.s	.nsr
.scro	moveq	#0,d0
.nsr	move.w	d0,(a0)
	bsr	.c2
	move.l	d1,d2
	move.w	#scrw,d0
	sub.w	(a0),d0
.c2	moveq	#0,d1
	move.w	d0,d1
	lsr.w	#4,d1
	add.w	d1,d1
	add.l	#scrbuf,d1
	not.w	d0
	and.w	#$f,d0
	mulu	#scrbw*scrh/2,d0
	add.l	d0,d1
	rts
cf	cfadeirq
scrloff	dc.w	1
scroll1	dc.w	0,1
scroll2	dc.w	0,2
scroll3	dc.w	0,3

tscrl	dc.w	73*4

vec:	; trsibig.vob
	dc.w	1,0,$77,0,$7F,1,$84,3,$88,6,$8E,12,$93,$12,$98
	dc.w	$1B,$9B,$24,$9D,$2D,$9E,$38,$9E,$45,$9C,$4F,$99
	dc.w	$58,$93,$63,$90,$67,$AE,$92,$E1,$92,$E8,$8F,$EB
	dc.w	$8C,$EC,$89,$EC,$85,$EB,$82,$E8,$7F,$E4,$7C,$DF
	dc.w	$7B,$CA,$7B,$C0,$77,$B9,$72,$AF,$66,$A8,$5B,$A3
	dc.w	$4D,$A0,$3E,$A0,$30,$A2,$26,$A8,$18,$AC,$13,$B3
	dc.w	12,$BF,3,$C6,0,$137,0,$137,$FA,$118,$C8,$118,$32
	dc.w	$D5,$32,$CD,$34,$CA,$36,$C8,$39,$C7,$3D,$C8,$42
	dc.w	$CB,$46,$CE,$48,$D5,$49,$E8,$49,$EF,$4A,$F5,$4D
	dc.w	$FB,$53,$107,$62,$10E,$70,$112,$7D,$113,$85,$113
	dc.w	$93,$110,$A1,$109,$AF,$101,$B7,$F5,$C1,$EC,$C4
	dc.w	$AA,$C4,$5C,$49,$70,$49,$75,$48,$79,$45,$7C,$42
	dc.w	$7D,$3D,$7B,$37,$77,$34,$73,$33,$6D,$32,$52,$32
	dc.w	$52,$FA,$32,$C8,$32,$32,$21,$32,$8000,$FFFF


asctab	dc.b	"ABCDEFGHIJKLMNOPQRSTUVWXYZ,!.:-1234567890*",0

toptxt
	dc.b	"    *TRISTAR AND RED SECTOR INCOOPERATED* ",0
	dc.b	"                 IRGENDWAS",0
	dc.b	"         CRACKED BY WASISCHNISCH",0,-1
;		"                                             "

text	dc.b	"IRGENDWIE IST DA WAS MIT DEM DESIGN IN DIE",0
	DC.B	"HOSEN GEGANGEN... NAJA, SPARIGES INTRO FUER",0
	DC.B	"SPARIGE KILOBYTES...",0
	dc.b	"                                   ",0
	dc.b	-1
	EVEN
cop0	copmode	0,0,0,0,0
	dc.w	$180,0
	dc.l	-2

bpal	dc.w	$000,$0F0,$0C0,$0A0,$080,$060,$040,$020
rpal1	dc.w	$000,$FF,$Cc,$aA,$88,$66,$44,$22
rpal2	dc.w	$000,$F,$C,$A,$8,$6,$4,$2

copper	copmode	0,0,0,0,0
	copddf	97,0,368,300
	copwin	113,0,344,300
	dc.w	$102,$ff
	dc.w	$180,$000,$182,$F00,$184,$D00,$186,$B00
	dc.w	$188,$A00,$18a,$800,$18c,$700,$18e,$520
tyscrl	WAIT	0,98
	copmode	3,0,0,0,0

	WAIT	0,99
	copmode	0,0,0,0,0
lc1	coppln	1,0
lc2	coppln	2,0
lc3	coppln	3,0
lc4	coppln	4,0
lc5	coppln	5,0
	dc.w	$180,$000,$182,$0f2,$184,$004,$186,$9f4
	dc.w	$188,$004,$18a,$0f4,$18c,$008,$18e,$9f8
	dc.w	$190,$004,$192,$0f4,$194,$008,$196,$9f8
	dc.w	$198,$008,$19a,$0f8,$19c,$00c,$19e,$9fc

	dc.w	$1a0,$004,$1a2,$0f4,$1a4,$008,$1a6,$9f8
	dc.w	$1a8,$008,$1aa,$0f8,$1ac,$00c,$1ae,$9fc
	dc.w	$1b0,$008,$1b2,$0f8,$1b4,$00c,$1b6,$9fc
	dc.w	$1b8,$00c,$1ba,$0fc,$1bc,$00f,$1be,$9ff

	copemod	scrbw-46
	copomod	scrbw-46
	WAIT	0,100
	copmode	5,0,0,0,0
	WAIT	0,100+127
	copmode 0,0,0,0,0

bcl	dc.w	$180,$000,$182,$000,$184,$000,$186,$000
	dc.w	$188,$000,$18a,$000,$18c,$000,$18e,$000


bc1	coppln	1,0
bc2	coppln	2,0
bc3	coppln	3,0
	copemod	2*tbw
	copomod	2*tbw
	dc.w	$102,$77
	WAIT	0,101+128
	copmode	3,0,0,0,0	

	WAIT	20,198
	dc.w	$180,$fff
	WAIT	20,199
	dc.w	$180,0
	wait	446,255
	Wait	20,43
	dc.w	$180,$1
	Wait	20,44
	dc.w	$180,$2
	Wait	20,45
	dc.w	$180,$3
	Wait	20,46
	dc.w	$180,$4
	Wait	20,47
	dc.w	$180,$5
	Wait	20,48
	dc.w	$180,$6
	Wait	20,49
	dc.w	$180,$7
	Wait	20,50
	dc.w	$180,$8
	Wait	20,51
	dc.w	$180,$9
	Wait	20,52
	dc.w	$180,$a
	Wait	20,53
	dc.w	$180,$b
	Wait	20,54
	dc.w	$180,$c
	dc.l	-2
font:	; nice.font
	incbin	"nice.font"

ende	
	printt	"Soviel is schon wech:"
	printv	ende-anf
	section	"Würg",bss_c
multab	ds.w	scrh
xpal	ds.w	8
logscr	ds.w	scrbw*(scrh+1)/2
	ds.w	scrbw*scrh/2

tpage	ds.w	tbw*tth*3/2
bpage	ds.w	tbw*bth*3/2

scrbuf	ds.w	scrh/4*scrbw*16
	ds.w	scrbw
scre
	ds.w	1000

