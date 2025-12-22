**************************************************
* Amos Professional Compiler Intuition Interface *
**************************************************

* Version 1.01  27/10/1996  by Fabrizio Bazzo
* via del Carso, 29    34170  Gorizia   ITALY

* If you want to modify the source and release an
* enhanced version, please send me a copy!

sysbase =	4
			;Exec
OpenLibrary =	-408
CloseLibrary =	-414
Wait =		-318
GetMsg =	-372
ReplyMsg =	-378
Forbid =	-132
FindTask =	-294
WaitPort =	-384
			;Intuition
OpenWindow =	-204
CloseWindow =	-72
WbenchToFront =	-342
WbenchToBack =	-336
DrawBorder =	-108
AutoRequest =	-348
PrintIText =	-216
			;Graphics
Draw =		-246
Move =		-240
Text =		-60
SetAPen =	-342
RectFill =	-306
OpenFont =	-72
CloseFont =	-78
			;Dos
Execute =	-222
Open =		-30
Close =		-36
			;ReqTools
rtAllocRequest =	-30
rtFreeRequest =		-36
rtFileRequest =		-54
rtEZrequest =		-66
rtPaletteRequest =	-102

CallExec:	macro
		move.l sysbase,a6
		jsr \1(a6)
		endm
CallDos:	macro
		move.l dosbase,a6
		jsr \1(a6)
		endm
CallIntu:	macro
		move.l intbase,a6
		jsr \1(a6)
		endm
CallGfx:	macro
		move.l gfxbase,a6
		jsr \1(a6)
		endm
CallRT:		macro
		move.l rtbase,a6
		jsr \1(a6)
		endm
Glom:		macro
		movem.l d0-d7/a0-a6,-(sp)
		endm
Splut:		macro
		movem.l (sp)+,d0-d7/a0-a6
		endm

;	begin of startup  code

	clr.l	WBMsg		
	sub.l	a1,a1		;Own Task
	CallExec FindTask	;Where?
	move.l	d0,a4
	tst.l	$ac(a4)		;fromWB?
	beq.b	fromWB		;da
fromCLI:			;no command line to deal with
	bra.b	run		;go!
fromWB:	lea	$5c(a4),a0
	CallExec WaitPort	;Wait 4 Start msg
	lea	$5c(a4),a0	
	CallExec GetMsg		;Got it
	move.l	d0,WBMsg
run:	bsr.b	OpenAll
	move.l	d0,-(sp)	;Get Return-Code
	tst.l	WBMsg		;from WB?
	beq.b	exit		;niet: CLI
	CallExec Forbid
	move.l	WBMsg(pc),a1	;Reply it	
	CallExec ReplyMsg		
exit:	move.l	(sp)+,d0	;Get Return-Code
	rts			;end of program
	cnop 0,2
WBMsg:	dc.l	0

;	end of startup code

OpenAll:
OpenRT:		lea rtname(pc),a1	; Open reqtools
		clr.l d0
		CallExec OpenLibrary
		tst.l d0
		bne.b GotIt
		lea intname(pc),a1
		clr.l d0
		CallExec OpenLibrary	;open intuition
		beq.w CloseAll
SysRequest:	move.l d0,intbase
		move.l #0,a0		;autorequest window
		lea body1(pc),a1
		move.l	#0,a2
		lea kotxt(pc),a3	;reqtools not found!
		clr.l	d0
		move.l	#$440,d1	;flags
		move.l	#300,d2
		move.l	#70,d3
		CallIntu AutoRequest
		bra.b	CloseAll	;Cancel selected
		
GotIt:		move.l d0,rtbase
		move.l d0,a0
		move.l $2a(a0),intbase	; borrow a few pointers
		move.l $2e(a0),gfxbase
		move.l $32(a0),dosbase
OpenNW:		lea newwdw(pc),a0	; open window
		CallIntu OpenWindow
		beq.b CloseAll
		move.l d0,wdwp

		bsr.b main

CloseAll:				; close what we have opened
Xwdw:		cmp.l #0,wdwp
		beq.b Xint
		move.l wdwp,a0
		CallIntu CloseWindow
Xint:		cmp.l #0,intbase
		beq.b X_RT
		move.l intbase,a1
		CallExec CloseLibrary
X_RT:		cmp.l #0,rtbase
		beq.b Xprg
		move.l rtbase,a1
		CallExec CloseLibrary
Xprg:		rts	

		
main:	CallIntu WBenchtofront

	move.l	#nil,d1		;new stdin-out
	move.l	#1005,d2
	CallDos Open
	tst.l	d0
	beq.W	Xmain
	move.l	d0,nhdl		;NIL handle

	move.l	wdwp,a0		;draw borders
	move.l	$32(a0),rport	;rport
	moveq	#1,d5		;counter 1..6
	lea	strarr(pc),a2	;default strings
strbxs:	move.w	#102,d0		;x
	move.w	#14,d1
	mulu	d5,d1		;y
	move.l	rport,a0	;draw borders
	lea	strbox(pc),a1	;border
	CallIntu DrawBorder
	move.l	(a2)+,a0	;next string
	bsr.w	drwstr
	addq	#1,d5
	cmp.w	#5,d5
	bne.b	strbxs
	move.w	#-1,ctype	;start with WBtype
	bsr.w	typrot		;draw current type 

	move.l	#0,d0		;type=RT_FILEREQ
	move.l	#0,a0		;^tags
	CallRT rtAllocRequest
	move.l	d0,reqstr
	beq.w	Xnil

sleep:	move.l wdwp,a0
	move.l $56(a0),a0
	move.l a0,a5		;user port
	move.b $0f(a0),d1	;Sigbit
	moveq #0,d0
	bset d1,d0
	CallExec Wait

awake:	move.l a5,a0
	CallExec GetMsg
	move.l d0,a1
	move.l $14(a1),d4	;im_class
	move.l $1c(a1),a4	;im_Iaddress
	CallExec ReplyMsg
	cmpi.l #$200,d4		;closewindow?
	beq.w	Xreq
	cmpi.l #$40,d4		;gadup
	beq.b	dogad
	cmpi.l	#$20,d4		;gdwn
	beq.b	newset
	bra.b sleep

dogad:	move.w	$26(a4),d2	;ID
	move.w	d2,d5		;for box selection
	clr.l	d7		;dir flag
	cmp	#1,d2
	beq.b	newfile		;source
	cmp	#2,d2		;dest
	beq.b	newfile
	cmp	#3,d2		;libs
	beq.b	newpath
	cmp	#4,d2		;temp
	beq.b	newpath
	cmp	#5,d2		;config
	beq.b	newfile
	cmp	#11,d2		;cmp-type
	beq.b	newtype
	cmp	#12,d2		;about
	beq.b	who
	cmp	#13,d2		;quit
	beq.b	qreq
	cmp	#14,d2		;compile
	beq.w	comp
*	else
	bra.w	sleep

newset:	move.w	$26(a4),d2	;ID
	subq	#6,d2
	bchg	d2,settings
	bra.w	sleep

newpath:
	move.l	#8,d7		;dir flag
newfile:
	bsr.w	getfile
	tst.l	d6		;got file?
	beq.w	sleep
	bsr.w	update
	bra.w	sleep
	
newtype:			;cycle compiled type
	bsr.w	typrot
	bra.w	sleep	
		
qreq:	lea	yn(pc),a2	;quit request
	lea	qtxt(pc),a1
	move.l	#0,a0		;no tags
	move.l	#0,a3		;no reqinfo
	move.l	#0,a4		;no argarray
	CallRT rtEZrequest
	move.l	d0,ezresp
	bne.b	Xreq		;confirm quit
	bra.w	sleep

who:	lea	seen(pc),a2	;who wrote this #@§*?
	lea	me(pc),a1
	move.l	#0,a0		;no tags
	move.l	#0,a3		;no reqinfo
	move.l	#0,a4		;no argarray
	CallRT rtEZrequest
	bra.w	sleep
	
comp:	bsr.w	build		;build cmd string
	move.l	#buffer,d1
	move.l	nhdl,d2
	move.l	nhdl,d3
	CallDos Execute
	lea	buffer(pc),a0
	move.b	#0,(a0)		;clear file buffer
	bra.w	sleep

Xreq:	move.l	reqstr,a1	;close/dealloc. and exit
	CallRT rtFreeRequest
	
Xnil:	move.l	nhdl,d1
	CallDos Close

Xmain:	rts

getfile:
	move.l	reqstr,a0
	adda.l	#8,a0
	move.l	d7,(a0)		;get dir if D7=8, else get file
_file:	move.l	reqstr,a1	;req struct
	lea	buffer(pc),a2	;buffer
	lea	freqtit(pc),a3	;^title	
	move.l	#0,a0		;^tags
	CallRT rtFileRequest
	move.l	d0,d6		;filereq->dir	path
Xgfile:	rts			;buffer		filename


update:	lea	strarr(pc),a1	;settings buffer
	move.l	d5,d4
	sub.l	#1,d4
	lsl.l	#2,d4
	adda.l	d4,a1		;get destination address
	move.l	(a1),a1
	move.l	a1,a2
	move.l	reqstr,a0
	move.l	$10(a0),a0
	cmp	#3,d5		;src or dst add quotes
	bge.b	noqu
	move.b	#'"',(a1)+
noqu:	bsr.w	strcopy		;copy path
	cmp.b	#':',-2(a1)	;check if root
	beq.b	xnull
	move.b	#'/',-1(a1)	;slash over NULL
	bra.b	upd1
xnull:	adda	#-1,a1		;next byte will overwrite NULL
	upd1:	tst.l	d7		;check path-only flag
	beq.b	upd2
	move.b	#0,(a1)		;NULL after : or /
	bra.b	quote		
upd2:	lea	buffer(pc),a0	;copy filename
	bsr.w	strcopy
quote:	cmp	#3,d5		;src or dst add quotes
	bge.b	inbox
	move.b	#'"',-1(a1)	;over NULL
	move.b	#0,(a1)
inbox:	move.l	a2,a0		;display up to 34 bytes
	bsr.w	strlen		;d6=len
	sub.l	#34,d6
	bmi.b	lenok		;<=34
	adda.l	d6,a0
lenok:	bsr.w	drwstr		;d5 still holds ID
	clr.l	d7		;clear dir flag
	rts

build:	lea	stubs(pc),a2	;array of ^cmd bits
	lea	buffer(pc),a1
	move.l	(a2)+,a0
	move.b	#'"',(a1)+	;avoid 'RAM DISK:'-type space problems 
	bsr.w	strcopy		;system path
	adda.l	#-1,a1
	moveq	#4,d0
cmp1:	move.l	(a2)+,a0	;apcmp > <...,src,dst,to,typ
noqu1:	bsr.b	strcopy
noqu2:	move.b	#' ',-1(a1)	;space over NULL
	dbra	d0,cmp1
	move.w	ctype,d0	;0,1,2,3
	add	#$30,d0		;ascii
	move.b	d0,-1(a1)	;compiled type
	move.b	#' ',(a1)+
	move.l	(a2)+,a0	;def,err,wb,long,inclib
	moveq	#0,d0		;test flags
nxtopt:	btst	d0,settings	;d1
	bne.b	useit		;use Do-it option
*	else
	cmp	#4,d0		;special case INCLIB
	bne.b	addno
	adda.l	#3,a0		;skip INC
addno:	move.b	#'N',(a1)+
	move.b	#'O',(a1)+
useit:	bsr.b	strcopy		;use new settings
	move.b	#' ',-1(a1)
	move.l	(a2)+,a0
	addq	#1,d0
	cmp	#5,d0
	bne.b	nxtopt
	bsr.b	strcopy		;tmp=,Temp,libs=,system
	adda.l	#-1,a1
	move.l	(a2)+,a0
	bsr.b	strcopy
	move.b	#'"',-1(a1)
	move.b	#' ',(a1)+
	move.l	(a2)+,a0	;libs=
	bsr.b	strcopy
	adda.l	#-1,a1
	move.l	(a2)+,a0	;libs
	bsr.b	strcopy
	move.b	#'"',-1(a1)
	move.b	#0,(a1)		;end with NULL
	rts

strcopy:			;A0:source,0 A1:dst
sc1:	move.b	(a0)+,(a1)+
	bne.b	sc1
	rts

strlen:	move.l	a0,-(sp)
	moveq.l	#0,d6		;A0:string,0 D6:len
sl1:	addq.l	#1,d6
	cmp.b	#0,(a0)+
	bne.b	sl1
	move.l	(sp)+,a0	
	rts
	
drwstr:				;A0: string,0  d5: box 1..5
	lea	jolly(pc),a1
	bsr.b	strcopy
	move.l	rport,a1	;clear old strings
	moveq	#0,d0
	CallGfx SetAPen
	move.l	rport,a1
	move.w	#104,d0		;x0
	move.w	#14,d1
	mulu	d5,d1
	addq	#1,d1		;y0
	move.w	#376,d2		;x1
	move.w	d1,d3
	addq	#8,d3		;y1
	CallGfx RectFill	
	lea	itstr(pc),a1
	move.l	rport,a0	;draw new strings
	move.w	#102,d0		;x
	move.w	#14,d1
	mulu.w	d5,d1		;y
	addq	#2,d1
	CallIntu PrintIText	
	rts

typrot:	moveq	#0,d0		;cycle compiled type
	move.l	rport,a1
	CallGfx SetAPen
	move.l	rport,a1
	move.w	#403,d0		;x0
	move.w	#74,d1
	move.w	#464,d2		;x1
	move.w	#85,d3
	CallGfx RectFill	
	move.w	ctype,d4
	addq	#1,d4
	cmp	#4,d4
	bne.b	oktype
	moveq	#0,d4
oktype:	move.w	d4,ctype
	lsl.l	#2,d4	
	lea	types,a1
	move.l	0(a1,d4.l),a0	;source
	lea	typdef(pc),a1
	bsr.w	strcopy
	lea	typ0(pc),a1
	move.l	rport,a0	;draw new strings
	move.w	#403,d0		;x
	move.w	#74,d1
	CallIntu PrintIText
	rts

;patchItxt:
;	moveq	#27,d0
;	lea	itfptr,a0
;pit0:	move.l	(a0)+,a1
;	move.l	topaz80,(a1)
;	dbra	d0,pit0
;	rts
	cnop 0,2
intbase:	dc.l 0
gfxbase:	dc.l 0
dosbase:	dc.l 0
rtbase:		dc.l 0
wdwp:		dc.l 0
rport:		dc.l 0
topaz80:	dc.l 0
reqstr:		dc.l 0
ezresp:		dc.l 0
nhdl:		dc.l 0
ctype:		dc.w 0
settings:	dc.b %1,0	;bit0=DEF bit4=INCLIB

rtname:		dc.b 'reqtools.library',0
	cnop 0,2	
intname:	dc.b 'intuition.library',0
	cnop 0,2
freqtit:	dc.b 'What? Where?',0
	cnop 0,2
fontname:	dc.b 'topaz.font',0
	cnop 0,2
nil:		dc.b 'Nil:',0
	cnop 0,2	
buffer:		blk.b 256,0
	cnop 0,2
	
	
newwdw:	dc.w 64		;left offset
	dc.w 50		;top offset 90
	dc.w 500	;width
	dc.w 89		;height 140
	dc.b 0		;detailPen
	dc.b 1		;blockPen
	dc.l $260	;IDCMP Gup $40 Gdown $20 close $200
	dc.l $100e	;flags $1000 active
	dc.l gadg1	;firstGadget
	dc.l 0		;checkMark
	dc.l title	;title
scrpw:	dc.l 0,0	;screen (WB 0),superbm
	dc.w 0,0,0,0	;maxw
	dc.w $1		;type (WB 1)
	cnop 0,2	
		
******* TextAttr ******
font:	dc.l fontname
	dc.w 8		; topaz_heighty or nothing
	dc.b 0
	dc.b 0
	cnop 0,2
	
******* Gadgets ***
gadg1:	dc.l gadg2			;next
	dc.w 10,13,82,12,$0,$1,1	;left,top,w,h,flags,act,type 
	dc.l bord1,0,gtxt1,0,0		;grend,selrend,txt,mut,info
	dc.w 1				;ID
	dc.l 0				;usr
gadg2:	dc.l gadg3
	dc.w 10,27,82,12,$0,$1,1
	dc.l bord1,0,g2txt1,0,0
	dc.w 2
	dc.l 0
gadg3:	dc.l gadg4
	dc.w 10,41,82,12,$0,$1,1
	dc.l bord1,0,g3txt1,0,0
	dc.w 3
	dc.l 0
gadg4:	dc.l gadg6
	dc.w 10,55,82,12,$0,$1,1
	dc.l bord1,0,g4txt1,0,0
	dc.w 4
	dc.l 0
gadg6:	dc.l gadg7			;compilation flags
	dc.w 470,13,16,10,$86,$102,1
	dc.l img1,img2,g6txt1,0,0
	dc.w 6
	dc.l 0
gadg7:	dc.l gadg8
	dc.w 470,25,16,10,$6,$102,1
	dc.l img1,img2,g7txt1,0,0
	dc.w 7
	dc.l 0
gadg8:	dc.l gadg9
	dc.w 470,37,16,10,$86,$102,1
	dc.l img1,img2,g8txt1,0,0
	dc.w 8
	dc.l 0
gadg9:	dc.l gadg10
	dc.w 470,49,16,10,$6,$102,1
	dc.l img1,img2,g9txt1,0,0
	dc.w 9
	dc.l 0
gadg10:	dc.l gadg11
	dc.w 470,61,16,10,$6,$102,1
	dc.l img1,img2,g10txt1,0,0
	dc.w 10
	dc.l 0
gadg11:	dc.l gadg12			;compiled type
	dc.w 470,74,16,10,$4,$1,1
	dc.l img3,0,0,0,0
	dc.w 11
	dc.l 0
gadg12:	dc.l gadg13			;about
	dc.w 10,73,82,12,$0,$1,1
	dc.l bord1,0,g12txt1,0,0
	dc.w 12
	dc.l 0
gadg13:	dc.l gadg14			;quit
	dc.w 156,73,82,12,$0,$1,1
	dc.l bord1,0,g13txt1,0,0
	dc.w 13
	dc.l 0
gadg14:	dc.l 0				;compile
	dc.w 302,73,82,12,$0,$1,1
	dc.l bord1,0,g14txt1,0,0
	dc.w 14
	dc.l 0

******* Border ***
bord1:	dc.w 0,11		;left,top
	dc.b 1,0,0,5		;col,bak,mode,pairs
	dc.l coor1,bord2
coor1:	dc.w 1,0,81,0,81,-11,80,-10,80,0 
bord2:	dc.w 81,0
	dc.b 2,0,0,5
	dc.l coor2,0
coor2:	dc.w -1,0,-81,0,-81,11,-80,10,-80,0 

strbox:	dc.w 280,0
	dc.b 1,0,0,5
	dc.l coor3,sbox2
coor3:	dc.w -1,0,-280,0,-280,10,-279,9,-279,0
sbox2:	dc.w 1,10
	dc.b 2,0,0,5
	dc.l coor4,0
coor4:	dc.w 0,0,279,0,279,-10,278,-9,278,0

******* Image *******
img1:	dc.w 0,1,16,10,2	;left,top,w,h,dep
	dc.l OfBmap
	dc.b %11,%0		;pick,on/off
	dc.l 0			;next
img2:	dc.w 0,1,16,10,2
	dc.l OnBmap
	dc.b %11,%0
	dc.l 0
img3:	dc.w 0,0,16,10,2
	dc.l CyBmap
	dc.b %11,%0
	dc.l 0
	
******* IntuiText ***
gtxt1:	dc.b 1,0,0,0
	dc.w 8,3		;left,top
itf1:	dc.l font,gdef,gtxt2
gtxt2:	dc.b 2,0,0,0
	dc.w 6,2
itf2:	dc.l font,gdef,0
gdef:	dc.b 'Source :',0
	cnop 0,2
g2txt1:	dc.b 1,0,0,0
	dc.w 8,3		;left,top
itf3:	dc.l font,g2def,g2txt2
g2txt2:	dc.b 2,0,0,0
	dc.w 6,2
itf4:	dc.l font,g2def,0
g2def:	dc.b 'Dest   :',0
	cnop 0,2
g3txt1:	dc.b 1,0,0,0
	dc.w 8,3		;left,top
itf5:	dc.l font,g3def,g3txt2
g3txt2:	dc.b 2,0,0,0
	dc.w 6,2
itf6:	dc.l font,g3def,0
g3def:	dc.b 'Libs   :',0
	cnop 0,2
g4txt1:	dc.b 1,0,0,0
	dc.w 8,3		;left,top
itf7:	dc.l font,g4def,g4txt2
g4txt2:	dc.b 2,0,0,0
	dc.w 6,2
itf8:	dc.l font,g4def,0
g4def:	dc.b 'Temp   :',0
	cnop 0,2
g5txt1:	dc.b 1,0,0,0
	dc.w 8,3		;left,top
itf9:	dc.l font,g5def,g5txt2
g5txt2:	dc.b 2,0,0,0
	dc.w 6,2
itf10:	dc.l font,g5def,0
g5def:	dc.b 'Config :',0
	cnop 0,2
g6txt1:	dc.b 1,0,0,0
	dc.w -64,3		;left,top
itf11:	dc.l font,g6def,g6txt2
g6txt2:	dc.b 2,0,0,0
	dc.w -66,2
itf12:	dc.l font,g6def,0
g6def:	dc.b 'DEFAULT',0
	cnop 0,2
g7txt1:	dc.b 1,0,0,0
	dc.w -64,3		;left,top
itf13:	dc.l font,g7def,g7txt2
g7txt2:	dc.b 2,0,0,0
	dc.w -66,2
itf14:	dc.l font,g7def,0
g7def:	dc.b 'ERRORS',0
	cnop 0,2
g8txt1:	dc.b 1,0,0,0
	dc.w -64,3		;left,top
itf15:	dc.l font,g8def,g8txt2
g8txt2:	dc.b 2,0,0,0
	dc.w -66,2
itf16:	dc.l font,g8def,0
g8def:	dc.b 'WB2BACK',0
	cnop 0,2
g9txt1:	dc.b 1,0,0,0
	dc.w -64,3		;left,top
itf17:	dc.l font,g9def,g9txt2
g9txt2:	dc.b 2,0,0,0
	dc.w -66,2
itf18:	dc.l font,g9def,0
g9def:	dc.b 'LONGJMP',0
	cnop 0,2
g10txt1:	dc.b 1,0,0,0
		dc.w -64,3		;left,top
itf19:		dc.l font,g10def,g10txt2
g10txt2:	dc.b 2,0,0,0
		dc.w -66,2
itf20:		dc.l font,g10def,0
g10def:		dc.b 'INCLIB',0
	cnop 0,2
g12txt1:	dc.b 1,0,0,0
		dc.w 20,3		;left,top
itf21:		dc.l font,g12def,g12txt2
g12txt2:	dc.b 2,0,0,0
		dc.w 18,2
itf22:		dc.l font,g12def,0
g12def:		dc.b 'ABOUT',0
	cnop 0,2
g13txt1:	dc.b 1,0,0,0
		dc.w 28,3		;left,top
itf23:		dc.l font,g13def,g13txt2
g13txt2:	dc.b 2,0,0,0
		dc.w 26,2
itf24:		dc.l font,g13def,0
g13def:		dc.b 'QUIT',0
	cnop 0,2
g14txt1:	dc.b 1,0,0,0
		dc.w 8,3		;left,top
itf25:		dc.l font,g14def,g14txt2
g14txt2:	dc.b 2,0,0,0
		dc.w 6,2
itf26:		dc.l font,g14def,0
g14def:		dc.b 'COMPILE!',0
	cnop 0,2
typ0:	dc.b 1,0,0,0	;type
	dc.w 6,3
itf27:	dc.l font,typdef,typ1
typ1:	dc.b 2,0,0,0
	dc.w 4,2
itf28:	dc.l font,typdef,0
typdef:	blk.b 8,0	
t0def:	dc.b 'WBENCH',0
t1def:	dc.b 'CLI',0
t2def:	dc.b 'CLI_DET',0
t3def:	dc.b '.AMOS',0
	cnop 0,2
body1:	dc.b 0,1,1,0	;auto front-back-mode,pad
	dc.w 18,15	;aut left-top
	dc.l 0,_des,0
kotxt:	dc.b 0,1,1,0
	dc.w 6,3
	dc.l 0,kot,0
itstr:	dc.b 1,0,0,0
	dc.w 4,0
	dc.l font,jolly,0
	cnop 0,2
title:	dc.b 'ApcII V1.01',0
	cnop 0,2
_des:	dc.b 'I need reqtools.library V37+',0
	cnop 0,2
kot:	dc.b 'Oops!',0
	cnop 0,2
yn:	dc.b 'Da|Niet',0
	cnop 0,2
qtxt:	dc.b 'Quit APCII? Sure?  :^{',0
	cnop 0,2
seen:	dc.b 'So what?',0
	cnop 0,2
me:	dc.b ' AMOS Pro Compiler',$a,'Intuition Interface',$a
	dc.b ' by Fabrizio Bazzo',0	
jolly:	dc.b 'I am a very long dummy text',0
	blk.b 12,0
	cnop 0,2
source:	dc.b '"ProgramToCompile.AMOS"',0
	blk.b	78,0
	cnop 0,2
destin:	dc.b '"ProgramCompiled"',0
	blk.b 84,0
	cnop 0,2
system:	dc.b 'Work:Amos_Pro/APSystem/',0
	blk.b 77,0
	cnop 0,2
temp:	dc.b 'RAM DISK:'
	blk.b 96,0
	cnop 0,2
cmd0:	dc.b 'APCMP" <NIL: >CON:68/61/492/75/Compiling...',0
	cnop 0,2
to:	dc.b 'TO',0
	cnop 0,2
type:	dc.b 'TYPE=',0
	cnop 0,2
nodef:	dc.b 'DEF',0
	cnop 0,2
err:	dc.b 'ERR',0
	cnop 0,2
wb:	dc.b 'WB',0
	cnop 0,2
long:	dc.b 'LONG',0
	cnop 0,2
inclib:	dc.b 'INCLIB',0	
	cnop 0,2
tmp:	dc.b 'TEMP="',0
	cnop 0,2
libs:	dc.b 'LIBS="'
	cnop 0,2	
strarr:	dc.l source,destin,system,temp
types:	dc.l t0def,t1def,t2def,t3def
stubs:	dc.l system,cmd0,source,to,destin,type,nodef,err,wb,long,inclib,tmp
	dc.l temp,libs,system
;itfptr:dc.l itf1,itf2,itf3,itf4,itf5,itf6,itf7,itf8,itf9,itf10,itf11,itf12
;	dc.l itf13,itf14,itf15,itf16,itf17,itf18,itf19,itf20,itf21,itf22
;	dc.l itf23,itf24,itf25,itf26,itf27,itf28
	cnop 0,2

	Section GadsData,DATA_C

OnBmap:	dc.w	$0000,$0001,$001b,$0033,$0663,$0bc3,$0183,$0003,$3fff,$0000
	dc.w	$0000,$7ffe,$6000,$6000,$6000,$6000,$6000,$6000,$4000,$0000
OfBmap:	dc.w	$0000,$0001,$0003,$0003,$0003,$0003,$0003,$0003,$3fff,$0000
	dc.w	$0000,$7ffe,$6000,$6000,$6000,$6000,$6000,$6000,$4000,$0000
CyBmap: dc.w	$0001,$0003,$07c3,$0c63,$0cf3,$0c63,$0c03,$07c3,$0003,$7fff
	dc.w	$fffe,$c000,$c000,$c000,$c000,$c000,$c000,$c000,$c000,$8000
