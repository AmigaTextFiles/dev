
; Listing17i2.s = starwarstxt.s

; fixare absaddressing!

;
;            SSSSSSSSS TTTTTTTTT  AAAAAAAA  RRRRRRRRR
;           SS     SS     TT      AA     AA   RR   RRR
;          SS             TT      AA      AA   RRRRRR
;         SSSSSSSS       TT       AAAAAAAAAAA   RR  RR
;              SS        TT       AA       AA    RR  RRR
;       SS    SS        TT        AA        AA    RR   RR
;      SSSSSSSS         TT        AA        AA     RR    RR
;
;                        W   A   R   S
;                       S C R O L L E R
;
; Original concept by Aurora. Adapted and optimized by The Cave
; Dweller of Future Mirror Inc. V1.0 runs (ofcourse) within 1
; scan and 1 bitplane, but the routine is designed to be able to
; run a 3 to 4 bitplane font within 1 scan. I'm just too lazy to
; code that now !!!
;------------------------------------------------------------------
h=320

WAITBLIT	MACRO
wb\@	btst	#14,2(a5)
	bne.s	wb\@
	ENDM


	SECTION	STARWARS,CODE_C
	
	lea	$dff000,a5
	move.w	#$4000,$9a(a5)
	move.l	#copper,$84(a5)
	roxl	$8a(a5)
	move.w	#0,$1fc(a5)
	lea	$50000,a0
	move	#$2000,d0
kl	clr	(a0)+
	dbf	d0,kl
	bsr	MAKECOPPER
	bsr	INIT
	move.w	#$FFFF,4(a6)
	move.l	#blitskiptable,8(a6)
	bsr.s	SCAN
	move.w	#$c000,$9a(a5)
	rts


scan	cmp.b	#$ff,6(a5)	;test VB
	bne.s	scan
	btst	#10,$16(a5)
	beq.s	scan

	bsr	GETUP	
	bsr	BLITSQUEEZE
	bsr	DRAWLINE

	btst	#6,$bfe001
	bne.s	scan
exit	rts	

GETUP:
	WAITBLIT
	move.l	#$50000,$0050(a5)	      ;source a
	move.l	#$50000-40,$54(a5)  ;dest d
	move.w	#0,$0064(a5)      ;a modulo
	move.w	#0,$0066(a5)          ;d modulo
	move.l	#$09F00000,$0040(a5)  :mode:copy
	move.l	#$FFFFFFFF,$0044(a5)  ;mask
	move.w	#(h+17)*64+20,$0058(a5)          ;copy 1024*1
	rts

DRAWLINE	add.b	#1,12(a6)	;17 lines fit
	cmp.b	#17,12(a6)	;in 1 textline
	bge.s	DRAW
	rts
DRAW	moveq.l	#0,d0
	move.b	d0,12(a6)
	lea	$50000+40*h,a1
	move	#19,d2	;20 chars per line
	move.l	(a6),d1
	lea	txt(pc),a0
	lea	(a0,d1.l),a0
	add.l	#20,(a6)	;1 CHAR. FURTHER
	tst.b	(a0)
	bne.s	newletter
	move.l	#0,(a6)
	bra.s	DRAW
newletter:	
	move.b	(a0)+,d0	;GET CHARACTER
	ext	d0
DRAWLETTER	
	sub	#$20,d0	;OFFSET=[SPACE] (=$20)
	asl	#5,d0	;2~5 EQUALS 2*16
	WAITBLIT
	move.l	#$ffffffff,$44(a5)    ;FULL MASK
	move.l	#$19f00000,$40(a5);BLITMODE: COPY
	move	#$0000,$64(a5)    ;SOURCE MODULO
	move	#$0026,$66(a5)    ;SCREEN MODULO
	lea	source(pc),a2             ;FONT OFFSET
	move.l	a1,d1          ;DESTINATION
	adda	d0,a2                 ;GET CHAR
	move.l	a2,$50(a5)            ;BLITSOURCE
	move.l	d1,$54(a5)            ;BLITDESTIN
	move	#16*64+1,$58(a5)  ;SEND BLITTER A GO
 	addq.l	#2,a1

	dbf	d2,newletter
	rts

; NOW FOLLOWS THE GREAT ROUTINE TO SQUEEZE A LINE TOGETHER

BLITSQUEEZE	move.w	4(a6),d0
	bpl.s	LEFTSIDE
	move.l	8(a6),a0
endoftab	move.b	(a0)+,d0
	cmp.b	#$ff,d0
	bne.s	notyetend
	lea	blitskiptable(pc),a0
	bra.s	endoftab
 
notyetend	move.l	a0,8(a6)
	and.w	#$ff,d0
	move.w	#$a0,d2
	add.w	d0,d2
	move.w	d0,4(a6)
	bsr	RIGHTSIDE
	rts	
 
LEFTSIDE	move.w	#$FFFF,4(a6)
	move.w	#$9F,d2
	sub.w	d0,d2

	move.l	#$50000,a0
	move.w	d2,d1
	lsr.w	#3,d1
	lea	0(a0,d1.w),a1
	WAITBLIT
	move.l	a1,$50(a5)	;source a
	move.l	#buffer,$54(a5)	;dest d
	move.w	#$26,$64(a5)    ;a modulo
	move.w	#0,$66(a5)	;d modulo
	move.l	#$09F00000,$40(a5);mode:copy
	move.l	#$FFFFFFFF,$44(a5);mask
	move.w	#h*64+1,$58(a5)	;copy 1024*1

	lsr.w	#1,d1
	addq.w	#1,d1
	moveq.l	#40,d3
	sub.w	d1,d3
	sub.w	d1,d3
	add.w	#h*64,d1
	WAITBLIT
	move.l	a0,$50(a5)	      ;source a
	move.l	a0,$54(a5)	      ;dest d
	move.l	#$19F00000,$40(a5)  ;copy+shift
	move.w	d3,$64(a5)	      ;a modulo
	move.w	d3,$66(a5)	      ;d modulo
	move.l	#$FFFFFFFE,$44(a5)  ;mask (!)
	move.w	d1,$58(a5)

	moveq.l	#-1,d1
	btst	#3,d2
	beq.s	NotTooLarge
	and.w	#$ff,d1
NotTooLarge	and.w	#7,d2
	lsr.w	d2,d1
	WAITBLIT
	move.l	a1,$48(a5)	      ;source c
	move.l	a1,$54(a5)          ;dest d
	move.l	#buffer,$4C(a5)  ;source b
	move.l	#$07CA0000,$40(a5)  ;mode:?
	move.w	#0,$62(a5)	      ;modulo b
	move.w	#$26,$60(a5)      ;modulo c
	move.w	#$26,$66(a5)      ;modulo d
	move.w	d1,$74(a5)          ;bltadat
	move.l	#$FFFFFFFF,$44(a5)  ;masks
	move.w	#h*64+1,$58(a5)          ;1024*1
	rts	
 
RIGHTSIDE	move.l	#$50000,a0
	move.w	d2,d1
	lsr.w	#3,d1
	bclr	#0,d1
	subq.w	#2,d1
	lea	0(a0,d1.w),a1
	WAITBLIT
	move.l	a1,$50(a5)
	move.l	#buffer,$54(a5)
	move.w	#$24,$64(a5)
	move.w	#0,$66(a5)
	move.l	#$09F00000,$40(a5)
	move.l	#$FFFFFFFF,$44(a5)
	move.w	#h*64+2,$58(a5)
	moveq.l	#40,d3
	sub.w	d1,d3
	lsr.w	#1,d3
	add.w	#h*64,d3
	lea	2(a1),a2
	WAITBLIT
	move.l	a2,$50(a5)
	move.l	a1,$54(a5)
	move.l	#$F9F00000,$40(a5)
	move.w	d1,$64(a5)
	move.w	d1,$66(a5)
	move.l	#$FFFFFFFF,$44(a5)
	move.w	d3,$58(a5)

	moveq.l	#-1,d1
	btst	#3,d2
	beq.s	NTL2
	and.w	#$ff,d1
NTL2	and.w	#7,d2
	lsr.w	d2,d1
	not.w	d1
	WAITBLIT
	move.l	a1,$48(a5)
	move.l	a1,$54(a5)
	move.l	#buffer,$4C(a5)
	move.l	#$07CA0000,$40(a5)
	move.w	#0,$62(a5)
	move.w	#$24,$60(a5)
	move.w	#$24,$66(a5)
	move.w	#$FFFF,$74(a5)	;bltadat
	move.w	#$FFFF,$44(a5)	;bltafwm
	move.w	d1,$46(a5)
	move.w	#h*64+2,$58(a5)
	rts	
 
; HORIZONTAL SKIPS ARE DONE USING THE COPPERLIST. THIS IS AN EASIER
; WAY THAN TO DO IT WITH THE BLITTER !

makecopper:	lea	copskiptable(pc),a0
	lea	colortable(pc),a2
	lea	copdat(pc),a1
	move.w	#$00a2,d7
	move.w	#$87,d0
	move.b	d0,(a1)+
	move.b	#$0f,(a1)+
	move.w	#$fffe,(a1)+
	
	move.l	#$01002200,(a1)+


writecopper	move.b	d0,(a1)+
	move.b	#$0f,(a1)+
	move.w	#$fffe,(a1)+
	move.w	#$0108,(a1)+
	move.w	(a0)+,d1
	sub.w	#40,d1
	move.w	d1,(a1)+
	move.w	#$010A,(a1)+
	move.w	d1,(a1)+

	cmp	#$f000,(a2)	;endtab
	beq.s	Nocolorchange
	move.w	#$0186,(a1)+
	move.w	(a2)+,(a1)+
	move.w	#$0184,(a1)+
	move.w	(a2)+,(a1)+
	move.w	#$0182,(a1)+
	move.w	(a2)+,(a1)+

nocolorchange	addq.b	#1,d0
	bcc.s	notpal
	move.l	#$FFE1FFFE,(a1)+
notpal	dbra	d7,writecopper
	move.l	#$01000200,(a1)+;bitmaps off
	move.l	#$fffffffe,(a1)+;copperend
	rts	

; DATA GRAVEYARD. (SCREEN ADRESSES & COUNTERS)
 
data	dc.l	0
	dc.l	0
	dc.l	0
	dc.b	0
	even

init	lea	$dff000,a5
	lea	data(pc),a6

	lea	planes(pc),a0
	move.l	#$50000,d0
	swap	d0
	move.w	d0,2(a0)
	swap	d0
	move.w	d0,6(a0)
	add.l	#40*2,d0
	swap	d0
	move.w	d0,10(a0)
	swap	d0
	move.w	d0,14(a0)
	

	move.w	#7,d1
	lea	$0144(a5),a4	;empty sprites
clrspr	clr.l	(a4)
	lea	8(a4),a4
	dbra	d1,clrspr
	rts	

;COPPERLIST...

copper	dc.w	$008e,$2981
	dc.w	$0090,$29c1
	dc.w	$0092,$0038
	dc.w	$0094,$00d0

planes	dc.w	$00e0,0
	dc.w	$00e2,0
	dc.w	$00e4,0
	dc.w	$00e6,0

	dc.w	$0100,$0200
	dc.w	$0102,$0000
	dc.w	$0108,$0078
	dc.w	$010A,$0078

colors	dc.w	$0180,$0000 



copdat	ds.w	1200

copskiptable	dc.w	$0078,$00C8,$00A0,$00C8,$00A0
	dc.w	$00C8,$00A0,$00A0,$00A0,$00A0
	dc.w	$00A0,$00A0,$00A0,$00A0,$00A0
	dc.w	$0078,$00A0,$00A0,$0078,$00A0
	dc.w	$0078,$0078,$00A0,$0078,$0078
	dc.w	$0078,$0078,$0078,$0078,$0078
	dc.w	$0078,$0078,$0078,$0078,$0078
	dc.w	$0050,$0078,$0078,$0050,$0078
	dc.w	$0078,$0050,$0078,$0050,$0050
	dc.w	$0078,$0050,$0078,$0050,$0050
	dc.w	$0050,$0078,$0050,$0050,$0050
	dc.w	$0050,$0050,$0050,$0050,$0050
	dc.w	$0050,$0050,$0050,$0050,$0050
	dc.w	$0050,$0050,$0028,$0050,$0050
	dc.w	$0050,$0050,$0028,$0050,$0050
	dc.w	$0028,$0050,$0050,$0028,$0050
	dc.w	$0028,$0050,$0028,$0050,$0028
	dc.w	$0050,$0028,$0050,$0028,$0050
	dc.w	$0028,$0028,$0050,$0028,$0028
	dc.w	$0050,$0028,$0028,$0050,$0028
	dc.w	$0028,$0028,$0050,$0028,$0028
	dc.w	$0028,$0028,$0028,$0050,$0028
	dc.w	$0028,$0028,$0028,$0028,$0028
	dc.w	$0028,$0028,$0028,$0028,$0028
	dc.w	$0028,$0028,$0000,$0028,$0028
	dc.w	$0028,$0028,$0000,$0028,$0028
	dc.w	$0028,$0028,$0000,$0028,$0028
	dc.w	$0028,$0000,$0028,$0028,$0028
	dc.w	$0000,$0028,$0028,$0028,$0028
	dc.w	$0000,$0028,$0028,$0028,$0000
	dc.w	$0028,$0028,$0000,$0028,$0028
	dc.w	$0028,$0000,$0028,$0028,$0028
	dc.w	$0000,$0028,$0028,$0000,$0028
	dc.w	$0028,$0000,$0000,$0028,$0028
	dc.w	$0028,$0000,$0028,$0028,$0000
	dc.w	$0028,$0028,$0000,$0028,$0028
	dc.w	$0000,$0028,$0028,$0000,$0028
	dc.w	$0000,$0028,$0028,$0000,$0028
	dc.w	$0028,$0028,$0028,$0000,$0028

	
blitskiptable:	dc.b	$71
	dc.b	$3E
	dc.b	$5D
	dc.b	$9B
	dc.b	$1E
	dc.b	$6B
	dc.b	$2D
	dc.b	$4B
	dc.b	$87
	dc.b	$0E
	dc.b	$6F
	dc.b	$33
	dc.b	$50
	dc.b	$8A
	dc.b	$15
	dc.b	$5D
	dc.b	$96
	dc.b	$23
	dc.b	$3F
	dc.b	$77
	dc.b	$06
	dc.b	$6B
	dc.b	$33
	dc.b	$4E
	dc.b	$84
	dc.b	$17
	dc.b	$5A
	dc.b	$8F
	dc.b	$24
	dc.b	$3E
	dc.b	$72
	dc.b	$09
	dc.b	$5D
	dc.b	$90
	dc.b	$29
	dc.b	$42
	dc.b	$74
	dc.b	$0F
	dc.b	$4D
	dc.b	$7E
	dc.b	$1B
	dc.b	$95
	dc.b	$33
	dc.b	$63
	dc.b	$02
	dc.b	$5D
	dc.b	$8C
	dc.b	$2D
	dc.b	$44
	dc.b	$72
	dc.b	$15
	dc.b	$4E
	dc.b	$7B
	dc.b	$20
	dc.b	$90
	dc.b	$36
	dc.b	$62
	dc.b	$09
	dc.b	$50
	dc.b	$7B
	dc.b	$24
	dc.b	$8F
	dc.b	$39
	dc.b	$63
	dc.b	$0E
	dc.b	$96
	dc.b	$42
	dc.b	$6B
	dc.b	$18
	dc.b	$7E
	dc.b	$2C
	dc.b	$54
	dc.b	$03
	dc.b	$9B
	dc.b	$4B
	dc.b	$72
	dc.b	$23
	dc.b	$84
	dc.b	$36
	dc.b	$5C
	dc.b	$0F
	dc.b	$8A
	dc.b	$3E
	dc.b	$63
	dc.b	$18
	dc.b	$74
	dc.b	$2A
	dc.b	$4E
	dc.b	$96
	dc.b	$05
	dc.b	$87
	dc.b	$3F
	dc.b	$62
	dc.b	$1B
	dc.b	$72
	dc.b	$2C
	dc.b	$4E
	dc.b	$92
	dc.b	$09
	dc.b	$77
	dc.b	$33
	dc.b	$54
	dc.b	$96
	dc.b	$11
	dc.b	$63
	dc.b	$21
	dc.b	$41
	dc.b	$81
	dc.b	$00
	dc.b	$FF

colortable:	

;	registers:	$184,$186,$182
;		  |    |    |
	dc.w	$000,$000,$000
	dc.w	$111,$111,$111
	dc.w	$121,$121,$111
	dc.w	$131,$131,$121
	dc.w	$241,$241,$121
	dc.w	$251,$251,$121
	dc.w	$261,$261,$131
	dc.w	$372,$372,$231
	dc.w	$382,$382,$241
	dc.w	$492,$492,$241
	dc.w	$4a2,$4a2,$251
	dc.w	$5b2,$5b2,$351
	dc.w	$6c2,$6c2,$361
	dc.w	$7d2,$7d2,$461
	dc.w	$8e2,$8e2,$471
	dc.w	$8f2,$8f2,$481
	dc.w	$f000



source:
	dc.l	0,0,0,0,0,0,0,0,$FE00FE00,$FE00FE00,$FE007C00
	dc.l	$7C007C00,$7C007C00,$7C00,$7C007C00,$7C007C00
	dc.l	$7CF87CF8,$7CF87CF8,$7CF8F9F0,$F9F00000,0,0,0,0
	dc.l	$FFFEFFFE,$FFFEFFFE,$FFFEFFFE,$FFFEFFFE,$FFFEFFFE
	dc.l	$FFFEFFFE,$FFFEFFFE,$FFFEFFFE,0,$7003F,$FF07FF
	dc.l	$3FFF7FFF,$7FFF7FFF,$7FFF7FFF,$3FFF0FFF,$3FA00E2
	dc.l	$1800FE00,$FF80FFE0,$FFF0FFF0,$FFF0FFF0,$FFF0FFE0
	dc.l	$FF20FA00,$E0002000,0,0,0,0,0,0,0,0,0,$3E003E00
	dc.l	$3E003E00,$3E007C00,$7C000000,0,0,0,0,$6001E0
	dc.l	$3E007E0,$7E00FC0,$F800F80,$F800F80,$FC007E0
	dc.l	$7E003E0,$1E00060,$C000F00,$F800FC0,$FC007E0
	dc.l	$3E003E0,$3E003E0,$7E00FC0,$FC00F80,$F000C00,0
	dc.l	$1000380,$7C0FFFE,$7FFC3FF8,$3FF87FFC,$FFFE07C0
	dc.l	$3800100,0,$7C0,$7C007C0,$7C07FFC,$7FFC7FFC
	dc.l	$7FFC7FFC,$7C007C0,$7C007C0,0,0,0,0,0,$3E0
	dc.l	$3E003E0,$3E003E0,$7C007C0,0,0,0,$7FFC7FFC
	dc.l	$7FFC7FFC,$7FFC0000,0,0,0,0,0,0,0,$7C0,$7C007C0
	dc.l	$7C007C0,$3E003E0,$7C007C0,$7C007C0,$F800F80
	dc.l	$F800F80,$1F001F00,$1F001F00,$3E003E00,$7C01FF0
	dc.l	$3FF87FFC,$7FFCFE7E,$FF3EFFBE,$FBFEF9FE,$FCFE7FFC
	dc.l	$7FFC3FF8,$1FF007C0,$7C00FC0,$1FC01FC0,$1FC007C0
	dc.l	$7C007C0,$7C007C0,$7C007C0,$7C007C0,$7C03E00
	dc.l	$FFE0FFF8,$FFFCFFFE,$FFFE003E,$FFE3FFC,$7FF8FFE0
	dc.l	$F800FFFE,$FFFEFFFE,$FFFEFFFE,$FFE07FF8,$3FFC1FFE
	dc.l	$FFE003E,$7C0078,$7C003E,$3EFFFE,$FFFEFFFC
	dc.l	$FFF8FFE0,$1F005F0,$DF01DF0,$3DF07DF0,$FFFEFFFE
	dc.l	$FFFEFFFE,$FFFE01F0,$1F001F0,$1F001F0,$FFFEFFFE
	dc.l	$FFFEFFFE,$FFFEF800,$FFE07FF8,$3FFC0FFE,$3EFFFE
	dc.l	$FFFEFFFC,$FFF8FFE0,$FFC3FFC,$7FFC7FFC,$FC00F800
	dc.l	$FFF0FFF8,$FFFCF83E,$F83EF83E,$FFFEFFFE,$7FFC3FF8
	dc.l	$FFFE7FFE,$3FFE1FFE,$FFE007C,$7FC03F8,$1F800F8
	dc.l	$1F001F0,$3F003E0,$7E007C0,$3FF87FFC,$FFFEF83E
	dc.l	$F83EF83E,$7FFC3FF8,$7FFCF83E,$F83EF83E,$FFFEFFFE
	dc.l	$7FFC3FF8,$3FF87FFC,$FFFEFFFE,$F83EF83E,$F83E7FFE
	dc.l	$3FFE1FFE,$3E007E,$7FFC7FFC,$7FF83FE0,0,$F80
	dc.l	$F800F80,$F800F80,$F80,$F800F80,$F800F80,0,0,$7C0
	dc.l	$7C007C0,$7C007C0,$7C0,$7C007C0,$7C007C0,$F800F80
	dc.l	0,0,$4000C00,$1C003FFE,$7FFEFFFE,$7FFE3FFE
	dc.l	$1C000C00,$4000000,0,$3FFE,$3FFE3FFE,$3FFE3FFE
	dc.l	$3FFE,$3FFE3FFE,$3FFE3FFE,0,0,0,$400060,$70FFF8
	dc.l	$FFFCFFFE,$FFFCFFF8,$700060,$400000,$FFE0FFF8
	dc.l	$FFFCFFFE,$FFFE003E,$7FE07FE,$7FC07F8,$7C0
	dc.l	$7C007C0,$7C007C0,0,$1C003A,$760774,$FB007F8
	dc.l	$1BF81CF0,$2FF033E0,$3DC01FC0,$F800380,$1FF0
	dc.l	$3FF87FFC,$7FFCFC7E,$F83EF83E,$FFFEFFFE,$FFFEFFFE
	dc.l	$FFFEF83E,$F83EF83E,$FFE0FFF8,$FFFCFFFE,$FFFE003E
	dc.l	$F87CF878,$F87CF83E,$F83EFFFE,$FFFEFFFC,$FFF8FFE0
	dc.l	$7E01FF8,$3FFC7FFE,$7FFCFC38,$F800F800,$F800F800
	dc.l	$FC387FFC,$7FFE3FFC,$1FF807E0,$FFC0FFF0,$FFF8FFFC
	dc.l	$FFFC007E,$F83EF83E,$F83EF83E,$F87EFFFC,$FFFCFFF8
	dc.l	$FFF0FFC0,$FFFEFFFC,$FFF8FFF0,$FFE0F800,$FFC0FF80
	dc.l	$FF00FE00,$F800FFE0,$FFF0FFF8,$FFFCFFFE,$FFFEFFFC
	dc.l	$FFF8FFF0,$FFE0F800,$FFC0FF80,$FF00FE00,$F800F800
	dc.l	$F800F800,$F800F800,$7E01FF8,$3FFC7FFE,$7FFCFC38
	dc.l	$F800F9FE,$F9FEF9FE,$FC3E7FFE,$7FFE3FFC,$1FF807E0
	dc.l	$F83EF83E,$F83EF83E,$F83EF83E,$FFFEFFFE,$FFFEFFFE
	dc.l	$FFFEF83E,$F83EF83E,$F83EF83E,$FE00FE0,$FE00FE0
	dc.l	$FE007C0,$7C007C0,$7C007C0,$7C00FE0,$FE00FE0
	dc.l	$FE00FE0,$3E003E,$3E003E,$3E003E,$3E003E,$3E003E
	dc.l	$387E7FFC,$FFFC7FF8,$3FF00FC0,$F80EF81E,$F83EF87E
	dc.l	$F8FEF9FC,$FBF8FFF0,$FFE0FFC0,$FFE0FFF0,$FFF8FDFC
	dc.l	$F8FEF87C,$F800F800,$F800F800,$F800F800,$F800F800
	dc.l	$F800F800,$F800FFFE,$FFFEFFFE,$FFFEFFFE,$F83EFC7E
	dc.l	$FEFEFFFE,$FFFEFFFE,$FFFEFFFE,$FBBEF93E,$F83EF83E
	dc.l	$F83EF83E,$F83EF83E,$F83EFC3E,$FE3EFF3E,$FFBEFFFE
	dc.l	$FFFEFFFE,$FBFEF9FE,$F8FEF87E,$F83EF83E,$F83EF83E
	dc.l	$7C01FF0,$3FF87FFC,$7FFCFC7E,$F83EF83E,$F83EF83E
	dc.l	$FC7E7FFC,$7FFC3FF8,$1FF007C0,$FFE0FFF8,$FFFCFFFE
	dc.l	$FFFE003E,$3EFFFE,$FFFEFFFC,$FFF8FFE0,$F800F800
	dc.l	$F800F800,$7C01FF0,$3FF87FFC,$7FFCFC7E,$F83EF83E
	dc.l	$F9FEF9FE,$FDFE7FFC,$7FFC3FFE,$1FFE07CE,$FFE0FFF8
	dc.l	$FFFCFFFE,$FFFE003E,$3EFFFE,$FFFEFFFC,$FFF8FFF0
	dc.l	$F9F8F8FC,$F87EF83E,$FFE3FFE,$7FFEFFFE,$FFFEF800
	dc.l	$FFE07FF8,$3FFC0FFE,$3EFFFE,$FFFEFFFC,$FFF8FFE0
	dc.l	$FFFEFFFE,$FFFEFFFE,$FFFE07C0,$7C007C0,$7C007C0
	dc.l	$7C007C0,$7C007C0,$7C007C0,$F83EF83E,$F83EF83E
	dc.l	$F83EF83E,$F83EF83E,$F83EF83E,$FC7E7FFC,$7FFC3FF8
	dc.l	$1FF007C0,$F83EF83E,$FC7C7C7C,$7C7C7C78,$3EF83EF8
	dc.l	$1EF01FF0,$1FF00FE0,$FE00FE0,$7C007C0,$F83EF83E
	dc.l	$F83EFC7E,$7C7C7C7C,$7D7C7FFC,$3FF83FF8,$3FF83FF8
	dc.l	$3FF81EF0,$1EF01EF0,$F83EF83E,$F83E7C7C,$7C7C7FFC
	dc.l	$3FF81FF0,$1FF03FF8,$7FFC7C7C,$7C7CF83E,$F83EF83E
	dc.l	$F83EF83E,$F83E7C7C,$7C7C7FFC,$3FF81FF0,$FE007C0
	dc.l	$7C007C0,$7C007C0,$7C007C0,$FFFEFFFE,$FFFEFFFE
	dc.l	$FFFC01F8,$3F007E0,$FC01F80,$3F007FFE,$FFFEFFFE
	dc.l	$FFFEFFFE
	dc.b	0,0


txt:	
	DC.B	'>                  <'
	DC.B	'>  THIS DISK WAS   <'
	DC.B	'>BROUGHT TO YOU BY:<'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>   - FUTURE       <'
	DC.B	'>     MIRROR -     <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>  CONTACT US AT:  <'
	DC.B	'>                  <'
	DC.B	'>  STEFAAN PONNET  <'
	DC.B	'>  STATIESTRAAT 94 <'
	DC.B	'>  2600   BERCHEM  <'
	DC.B	'>     BELGIUM      <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>FAST GREETINGS TO:<'
	DC.B	'>******************<'
	DC.B	'>                  <'
	DC.B	'>    - T.F.A. -    <'
	DC.B	'>                  <'
	DC.B	'>-SHOGUN/BARRICADE-<'
	DC.B	'>                  <'
	DC.B	'>    - T.W.C. -    <'
	DC.B	'>                  <'
	DC.B	'> -MR.SPIV/CAVE-   <'
	DC.B	'> (COOL CRUNCHER!) <'
	DC.B	'>                  <'
	DC.B	'> @@@@@@@@@@@@@@@  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>   SEE YOU ALL    <'
	DC.B	'>    VERY SOON     <'
	DC.B	'>      ----        <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'
	DC.B	'>                  <'

	DC.B	0

	section	bau,bss_c

buffer:
	ds.b	40000










