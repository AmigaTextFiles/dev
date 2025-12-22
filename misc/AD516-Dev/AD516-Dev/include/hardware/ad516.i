	IFND	HARDWARE_AD516_I
HARDWARE_AD516_I	SET	1
**
**	$VER: ad516.i 0.1 (26.11.01)
**
**	Defines for direct hardware use of the Sunrize AD516 card.
**
**	Original definitions by Sunrize Industries
**
**	This version has been reworked and enhanced by Chris Brenner,
**	introducing new definitions and changing some of the old ones.
**
**	Most of the comments are summaries of observations of the
**	AD516 card's response to controlled stimuli. Being that these
**	are educated guesses, the comments may not be fully accurate.
**
**	(C) Copyright 1992 Sunrize Industries
**	(C) Copyright 2001 Chris Brenner
**


*AutoConfig IDs
SUNRIZEID	equ	$084f
AD516ID		equ	2

*AD516 registers - offset from base address of configured AD516 card
STATUS		equ	0	;byte
PORT		equ	2	;word
FIFO		equ	4	;word

*status register bits
WROK68 		equ	0	;clear = ok to write to PORT
RDOK68 		equ	1	;clear = ok to read from PORT
AD516INT	equ	2	;clear = interrupt was sent by AD516
WROKFIFO	equ	3	;set = ok to write to FIFO
RECLEFT		equ	6	;clear = FIFO has left input sample

*card commands
GetRev		equ	$003d	;return card revision number
LoadCode	equ	$003f	;load DSP code into card


*
* DSP software modules -- OR a module ID with a module flag to
* create a module command -- PLAY_BLOCK|ON enables the PLAY_BLOCK module
*

*modules IDs
CONVERSION	equ	$0013	;module function unknown
PLAY_BLOCK	equ	$0015	;audio data module
SMPTE		equ	$0017	;SMPTE module, usage unknown
MODE		equ	$0019	;module function unknown, but enabled anyway
PINT		equ	$001b	;module function unknown

*module control flags
ON		equ	$ff00	;turn module on
OFF		equ	$0000	;turn module off


*channel volume commands
InputVol	equ	$001d	;set record level
Chan1Vol	equ	$011d	;set channel 1 level
Chan2Vol	equ	$021d	;set channel 2 level
Chan3Vol	equ	$031d	;set channel 3 level
Chan4Vol	equ	$041d	;set channel 4 level
Chan5Vol	equ	$051d	;set channel 5 level
Chan6Vol	equ	$061d	;set channel 6 level
Chan7Vol	equ	$071d	;set channel 7 level
Chan8Vol	equ	$081d	;set channel 8 level
OutputVol	equ	$091d	;set master volume level

*playback gain commands
Chan1Gain	equ	$080b	;set channel 1 playback gain
Chan2Gain	equ	$070b	;set channel 2 playback gain
Chan3Gain	equ	$060b	;set channel 3 playback gain
Chan4Gain	equ	$050b	;set channel 4 playback gain
Chan5Gain	equ	$040b	;set channel 5 playback gain
Chan6Gain	equ	$030b	;set channel 6 playback gain
Chan7Gain	equ	$020b	;set channel 7 playback gain
Chan8Gain	equ	$010b	;set channel 8 playback gain

*playback activation commands
PlayChan1	equ	$0010	;play queued FIFO data through channel 1
PlayChan2	equ	$000e	;play queued FIFO data through channel 2
PlayChan3	equ	$000c	;play queued FIFO data through channel 3
PlayChan4	equ	$000a	;play queued FIFO data through channel 4
PlayChan5	equ	$0008	;play queued FIFO data through channel 5
PlayChan6	equ	$0006	;play queued FIFO data through channel 6
PlayChan7	equ	$0004	;play queued FIFO data through channel 7
PlayChan8	equ	$0002	;play queued FIFO data through channel 8

*misc commands
ReadPM		equ	$0001
CntrlRegAdj	equ	$0005
DataRegAdj	equ	$0009
PlaybackGain	equ	$000b	;see playback gain commands above
HiLowReq	equ	$001f	;read peak levels for all channels

*interrupt message bits
RECINT		equ	3	;clear = FIFO has recorded data to be read
RECINTLEFT	equ	4	;clear = left channel interrupt

*record control commands
RecordInOn	equ	$0033	;turn on record for specified input channel
RecordOutOn	equ	$0035
RecordOff	equ	$0037	;turn off record for specified input channel

*record control arguments
INPUTL		equ	$0000	;left input channel
INPUTR		equ	$000d	;right input channel

*definitions that are still a mystery
CHANLEFT	equ	$0100
CHANRIGHT	equ	$0200

SetFreq		equ	$0003
SetTimer	equ	$0007
RecDataReq	equ	$000d

MsgRecData	equ	$0003
MsgPlayData	equ	$0005

VAR0lo		equ	$0021
VAR0hi		equ	$0023
VAR1lo		equ	$0025
VAR1hi		equ	$0027
VAR2lo		equ	$0029
VAR2hi		equ	$002b
SetMix		equ	$0029
SetDelay2	equ	$002b
SetDelay	equ	$002d
SetFeedBack	equ	$002f

MovePlayPtr0	equ	$0031
MovePlayPtr1	equ	$0131
MovePlayPtr2	equ	$0231
MovePlayPtr3	equ	$0331

SMPTEreq	equ	$0039

CLEAR		equ	0

SerialNum	equ	$03f0
BoardRev	equ	$03f1
CFlags		equ	$03f2
Xtra		equ	$03f3


*
* Macros -- These macros require that an address register be equated to
* the label AD516BASE -- Use the EQUR assembler directive to do this.
*

READPORT	MACRO	;<Destination>
RPS\@
1$		btst.b	#RDOK68,(AD516BASE)
		bne.s	1$
		move.w	PORT(AD516BASE),\1
RPE\@
		ENDM


WRITEPORT	MACRO	;<Source>
WPS\@
1$		btst.b	#WROK68,(AD516BASE)
		bne.s	1$
		move.w	\1,PORT(AD516BASE)
WPE\@
		ENDM


WRITEPORTQ	MACRO	;<Source>
		move.w	\1,PORT(AD516BASE)
		ENDM


WAITFIFO	MACRO
WAS\@
1$		btst.b	#WROKFIFO,(AD516BASE)
		beq.s	1$
WAE\@
		ENDM


WRITEFIFO	MACRO	;<Source>,[Index Data Register],[Source Adjust]
WFS\@
1$		btst.b	#WROKFIFO,(AD516BASE)
		beq.s	1$
		IFNC	'\2',''
		IFNC	'\3',''
2$		move.w	(\1),FIFO(AD516BASE)
		addq.l	#\3,\1
		dbra	\2,2$
		ELSE
3$		move.w	\1,FIFO(AD516BASE)
		dbra	\2,3$
		ENDC
		ELSE
		move.w	\1,FIFO(AD516BASE)
		ENDC

WFE\@
		ENDM


WRITEFIFOQ	MACRO	;<Source>,[Index Data Register],[Source Adjust]
WQS\@
		IFNC	'\2',''
		IFNC	'\3',''
1$		move.w	(\1),FIFO(AD516BASE)
		addq.l	#\3,\1
		dbra	\2,1$
		ELSE
2$		move.w	\1,FIFO(AD516BASE)
		dbra	\2,2$
		ENDC
		ELSE
		move.w	\1,FIFO(AD516BASE)
		ENDC

WQE\@
		ENDM


COMMAND		MACRO	;<Command>,[Arg1],[Arg2]
CS\@
1$		btst.b	#WROK68,(AD516BASE)
		bne.s	1$
		move.w	#\1,PORT(AD516BASE)
		IFNC	'\2',''
2$		btst.b	#WROK68,(AD516BASE)
		bne.s	2$
		move.w	\2,PORT(AD516BASE)
		ENDC
		IFNC	'\3',''
3$		btst.b	#WROK68,(AD516BASE)
		bne.s	3$
		move.w	\3,PORT(AD516BASE)
		ENDC
CE\@
		ENDM


*I'm not exactly sure what this code does, but it seems to be necessary
*in order to get the AD516 card to respond after a hardware reset. Because
*of this, I call it WAKEUP.
WAKEUP		MACRO
WS\@
		move.l		#$1387,d1
1$		moveq		#0,d0
		move.w		PORT(AD516BASE),d0
		moveq		#0,d0
		move.w		FIFO(AD516BASE),d0
		move.w		#$003b,PORT(AD516BASE)
		dbra		d1,1$
WE\@
		ENDM
