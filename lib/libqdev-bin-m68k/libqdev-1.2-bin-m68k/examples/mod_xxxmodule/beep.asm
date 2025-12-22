;
; beep.asm
; by megacz
;
; This is very primitive 'beep' alike proggy that is based on the
; 'sinewave.asm' taken from Amiga Hardware Reference Manual.
; I did implement the sound interval, so it actually beeps, where
; the original proggy just fires the DMA so the sound never stops.
; To load it as a KTP module, you will have assemble it and then
; disassemble with machine code output turned on, so that non-PC
; relative parts get computed statically. This is important since
; code and/or data within module is not scatter-loaded!
;

CUSTOM		EQU	$DFF000

dmacon		EQU	$096
aud0		EQU	$0A0
intena		EQU	$09A
intreq		EQU	$09C

AUD0LCH		EQU	aud0
AUD0LEN		EQU	aud0+$04
AUD0PER		EQU	aud0+$06
AUD0VOL		EQU	aud0+$08

DMACON		EQU	dmacon
DMAF_SETCLR	EQU	$8000
DMAF_AUD0	EQU	$0001
DMAF_MASTER	EQU	$0200

INTENA		EQU	intena
INTREQ		EQU	intreq

INTB_AUD0	EQU	7
INTF_AUD0	EQU	(1<<7)

SetIntVector	EQU	-162
Wait		EQU	-318
FindTask	EQU	-294
Signal		EQU	-324

CTRL_C		EQU	$1000
DMA_INIT	EQU	(DMAF_SETCLR!DMAF_AUD0!DMAF_MASTER)
DMA_KILL	EQU	(DMAF_AUD0)
INT_INIT	EQU	(DMAF_SETCLR!INTF_AUD0)
INT_KILL	EQU	(INTF_AUD0)



_entry:
	MOVEM.L	A0-A2,-(SP)		; Save regs we are about to use
	MOVE.L	$4.w,A6			; Load 'exec.library' base ptr
	MOVEQ.L	#INTB_AUD0,D0		; Stuff audio0 interrupt number
	LEA	_interrupt(PC),A1	; Load Interrupt struct. addr.
	LEA	_handler(PC),A0		; Load interrupt handler code
	MOVE.L	A0,18(A1)		; Attach the handler to is_Code
	LEA	_count(PC),A0		; Load interrupt counter addr.
	MOVE.L	A0,14(A1)		; Attach it to the is_Data
	JSR	SetIntVector(A6)	; Install our tricky interrupt 
	MOVE.L	D0,A2			; Copy the result, the old int.
	LEA	CUSTOM,A0		; Load Amiga hardware address
	LEA	_sample(PC),A1		; Load the sine wave address
	MOVE.L	A1,AUD0LCH(A0)		; Attach the pointer to DMA reg
	MOVE.W	#4,AUD0LEN(A0)		; Set waveform length(in words)
	MOVE.W	#64,AUD0VOL(A0)		; Set new channel volume, max.
	MOVE.W	#447,AUD0PER(A0)	; Set overall period(waveform)
	MOVE.W	#DMA_INIT,DMACON(A0)	; Let the DMA feed the Paula
	MOVE.W	#INTF_AUD0,INTREQ(A0)	; Set interrupts for audio0
	MOVE.W	#INT_INIT,INTENA(A0)	; Enable interrupts for audio0
	MOVE.L	#CTRL_C,D0		; SIGBREAKF_CTRL_C for Wait()
	JSR	Wait(A6)		; Let the proc. Wait() for sig
	LEA	CUSTOM,A0		; Load Amiga hardware address
	MOVE.W	#DMA_KILL,DMACON(A0)	; Stop the DMA, and thus sound
	MOVEQ.L	#INTB_AUD0,D0		; Stuff audio0 interrupt number
	MOVE.L	A2,A1			; Pass old interrupt code addr
	JSR	SetIntVector(A6)	; Restore previous interrupt
	MOVEM.L	(SP)+,A0-A2		; Restore the registers used
	MOVEQ	#0,D0			; All OK
	RTS
_handler:
	SUBQ.L	#1,(A1)			; Decrease the _count by one
	TST.L	(A1)			; Check if _count had reached 0
	BNE.S	_quit			; Nope, not yet so allow ints
	LEA	CUSTOM,A0		; Load Amiga hardware address
	MOVE.W	#INT_KILL,INTENA(A0)	; Disable interrupts for audio0
	MOVE.L	$4.w,A6			; Load 'exec.library' base ptr
	MOVE.L	#0,A1			; Stuff FindTask() with NULL
	JSR	FindTask(A6)		; Find last active(us) task
	MOVE.L	D0,A1			; Pass its address first arg.
	MOVE.L	#CTRL_C,D0		; The sigmask in second arg.
	JSR	Signal(A6)		; And Signal() it up right away
_quit:
	MOVEQ	#0,D0			; Z flag
	RTS
	EVEN
_sample:
	DC.B	0, 90, 127, 90, 0, -90, -127, -90
	EVEN
_count:
	DC.L	100000			; Len. of the beep, no of ints
	EVEN
_interrupt:
	DC.L	0
	DC.L	0
	DC.B	2
	DC.B	0
	DC.L	0
	DC.L	0			; is_Data
	DC.L	0			; is_Code
	EVEN
	END
