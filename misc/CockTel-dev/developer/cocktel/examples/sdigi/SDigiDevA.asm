*******************************************************************
* $CRT 04 Apr 1996 : hb
*
* $AUT Holger Burkarth
* $DAT >>SDigiDevA.asm<<   07 Apr 1996    08:38:39 - (C) ProDAD
*******************************************************************/

*\
** ACHTUNG  ACHTUNG  ACHTUNG  ACHTUNG  ACHTUNG  ACHTUNG  ACHTUNG
**
** Der folgende Source-Code ist ein unbearbeitetes Experiment aus
** den proDAD Labors und soll nur der Veranschauung dienen.
**
** ACHTUNG  ACHTUNG  ACHTUNG  ACHTUNG  ACHTUNG  ACHTUNG  ACHTUNG
*/


*
* mcpp:masm -c lc abc:sdigidevA.asm
*




	INCDIR "CC:incl_asm/"

        INCLUDE "exec/ports.i"
        INCLUDE "exec/libraries.i"


 STRUCTURE  DEV,LIB_SIZE
    APTR    DEV_ActIO
    STRUCT  DEV_IOList,LH_SIZE
    APTR    DEV_CIA
    APTR    DEV_CIACR
    APTR    DEV_CIALO
    APTR    DEV_CIAHI
    UBYTE   DEV_STOPMASK
    UBYTE   DEV_STARTMASK

    LABEL   DEV_SIZE


 STRUCTURE  IO,MN_SIZE
    APTR    IO_DEVICE
    APTR    IO_UNIT
    UWORD   IO_COMMAND
    UBYTE   IO_FLAGS
    BYTE    IO_ERROR
    ULONG   IO_ACTUAL
    ULONG   IO_LENGTH
    APTR    IO_DATA

    ULONG   IO_Frquence
    UWORD   IO_MicroDelay

    LABEL   IO_SIZE




	xdef	_IntPort,_InterruptFunc

ExecBase	= 4
Signal		= -324
RemHead		= -258
ReplyMsg	= -378

_IntPort:
	move.b #0,$bfe301	; Port auf Eingabe
	ori.b  #6,$bfd200	; rechte und linke Kanäle intitialisieren
	move.b #2,$bfd000	; linken Kanal lesen

;	 move.b #4,$bfd000	; rechten Kanal lesen
	rts



; a1=IO
; a5=Dev

_InterruptFunc:
	move.l  a1,a5
	tst.l   DEV_ActIO(a5)
	bne.s   l_Start

	lea     DEV_IOList(a5),a0
	jsr     RemHead(a6)
	move.l  d0,DEV_ActIO(a5)
	beq.s   l_End

	move.l  d0,a1

	move.b  DEV_STOPMASK(a5),d0 	; Interval stoppen
	move.l  DEV_CIACR(a5),a0
	and.b   d0,(a0)

	move.b  IO_MicroDelay(a1),d0	; hi
	move.l  DEV_CIAHI(a5),a0
	move.b  d0,(a0)

	move.b  IO_MicroDelay+1(a1),d0	; lo
	move.l  DEV_CIALO(a5),a0
	move.b  d0,(a0)

	move.b  DEV_STARTMASK(a5),d0 	; Interval starten
	move.l  DEV_CIACR(a5),a0
	or.b    d0,(a0)
	bra     l_Start


l_Start	move.l  DEV_ActIO(a5),a1

	move.l  IO_DATA(a1),a0
	move.b  $bfe101,d0
	subi.b  #128,d0

	move.l  IO_ACTUAL(a1),d1

        move.b  d0,(a0,d1.l)
        addq.l  #1,d1
        move.l  d1,IO_ACTUAL(a1)
        cmp.l   IO_LENGTH(a1),d1
        bpl     signalEnde              ; das Ende ist erreicht
        rts

signalEnde:
	moveq   #0,d0
	move.l  d0,DEV_ActIO(a5)
	jmp     ReplyMsg(a6)		; a1 ist bereits gesetzt


l_End	move.b  DEV_STOPMASK(a5),d0 	; Interval stoppen
	move.l  DEV_CIACR(a5),a0
	and.b   d0,(a0)
	rts


	end
