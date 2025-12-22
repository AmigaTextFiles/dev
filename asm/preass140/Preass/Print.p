; Print 1.0
; 
; (c) 1994 Cyborg 

	include "Dh1:startrek/startrek.inc"
	Include "sys:demos/ASL_lib.inc"

	Spalten=79
	zeilen=66
	Writelaenge=5281

;---------------------------------------------------------------------------

even
bra.b START
dc.b 0,`$VER: Print 1.0 (C) CYBORG 94`,0

even
start:
	move.l d0,laenge
	move.l a0,adresse
.l1:	cmpi.b #$0a,(a0)+
	bne .l1
	move.b #$00,-1(a0)
	include "sys:coder/startup.i"
	{* IncVar: Laenge,Adresse*}
	{* LibNamesOff *}
Main:	Dosbase=Openlibrary("dos.library",#0)
	checkf DosBase,ende
	FH=Open(Adresse,#Mode_Old)
	checkf FH,ende
	seek(FH,#0,#Offset_End)
	Filelaenge=Seek(FH,#0,#Offset_Beginning)
	memoryblock=Allocmem(Filelaenge,#0)
	checkf memoryblock,ende
	read(FH,Memoryblock,Filelaenge)
	Printhandle=open("RAM:TESTFile",#Mode_New)
	checkf Printhandle,ende
	OutputHandle=Output()
	jsr print
ende:	checkf memoryblock,ende0
	freemem(memoryblock,Filelaenge)
ende0:	checkf printhandle,ende1
	close(Printhandle)
ende1:	checkf fh,ende2
	close(fh)
ende2:	checkf DosBase,ende3
	Closelibrary(DosBase)
ende3:	clr.l d0
	RTS

Print:	move.l memoryblock,a0
	{* IncBlock: Puffer,5280*}
	lea (a0),a2
	add.l filelaenge,a2
	moveq.l #0,d5
.l0:	moveq.l #0,d6
	moveq.l #0,d7
	lea puffer,a1
.l1:	move.b (a0)+,d0
	addi.l #1,d5
	cmpa.l a0,a2
	beq .ende
	cmp.l filelaenge,d5
	beq .ende
	cmpi.b #$09,d0
	beq .ersetze_durch_Space
	cmpi.b #$0c,d0
	beq .ersetze_durch_Space
	cmpi.b #$0a,d0
	beq .ausfuellen
	cmpi.b #$0d,d0
	beq .ausfuellen
	move.b d0,(a1)+
.l5:	addq.l #1,d6
	cmpi.l #Spalten,d6
	bne.b .l1
.l3:	move.b #$0a,(a1)+
	moveq.l #0,d6
	addq.l #1,d7
	cmpi.l #zeilen,d7
	bne.s .l1
	move.b #$0c,(a1)+
	movem.l d6-d7/a0-a2,-(sp)
	write(Printhandle,#puffer,#Writelaenge)
	Write(Outputhandle,#Puffer,#Writelaenge)
	movem.l (sp)+,d6-d7/a0-a2
	cmpi.l #Writelaenge,d0
	bne .ende0
	bra.w .l0
.ende:	move.b #$20,(a1)+
	addq.l #1,d6
	cmpi.l #Spalten,d6
	bne .ende
	addq.l #1,d7
	mulu d7,d6
	write(Printhandle,#puffer,d6)
	write(OutPuthandle,#puffer,d6)
.ende0:	RTS
.ausfuellen:
	move.b #$20,(a1)+
	addq.l #1,d6
	cmpi.l #Spalten,d6
	bne .ausfuellen
	bra .l3
.ersetze_durch_Space:
	move.b #$20,(a1)+
	bra .l5
