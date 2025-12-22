
;---;  commodity.r  ;----------------------------------------------------------
*
*	****	Commodities Support Routines    ****
*
*	Author		Daniel Weber
*	Version		1.10
*	Last Revision	28.05.93
*	Identifier	csr_defined
*       Prefix		csr_	(commodities support routines)
*				 ¯         ¯       ¯
*	Functions	InitBroker, RemoveBroker, InstallHotKey, RemCX
*			EnabeCX, DisableCX
*
*	Note		- The commodity.library (v37) must already be open
*			  and available using the CxBase(pc) effective address.
*			- Some descriptions taken from the AmigaMails (easier
*			  and more precise).
*
;------------------------------------------------------------------------------

;------------------
	ifnd	csr_defined
csr_defined	SET	1

;------------------
csr_oldbase	equ __BASE
	base	csr_base
csr_base:

;------------------
	opt	sto,o+,ow-,q+,qw-		;all optimisations on

;------------------

	incdir	'include:','routines:'
	include	ports.r
	include	structs.r
	include libraries/commodities.i
;	incequ	lvo.s

;------------------------------------------------------------------------------

	IFND	EVT_HOTKEY
EVT_HOTKEY	EQU	1	;like in the AmigaMails (keep the compatibility)
	ENDC

;------------------------------------------------------------------------------
*
* InitBroker	- Initialize and start broker (port will be created)
*
* INPUT		A0	Message Port Structure (use PortStruct_ from Structs.r)
*		A1	New Broker Structure (BrokerStruct_ from Structs.r)
*
* RESULT	D0	Broker (co)
*		D1	Broker Message Port
*
;------------------------------------------------------------------------------
	IFD	xxx_InitBroker

InitBroker:
	movem.l	d2-a6,-(a7)
	bsr	MakePort
	beq.s	\error
	move.l	d0,d6
	move.l	d0,nb_Port(a1)

; The commodities.library function CxBroker() adds a broker to the master list.
; It takes two arguments, a pointer to a NewBroker structure and a pointer to
; a LONG.  The NewBroker structure contains information to set up the broker.
; If the second argument is not NULL, CxBroker will fill it in with an error
; code.

	move.l	a1,a0			;broker
	moveq	#0,d0			;NULL
	move.l	CxBase(pc),a6
	jsr	-36(a6)			;_LVOCxBroker(a6)
	move.l	d0,d7
	beq	\error2

	move.l	d6,d1			;message port
	move.l	d7,d0			;broker (co)
\out:	movem.l	(a7)+,d2-a6
	rts

;------------------
\error2:				;no broker
	move.l	d6,a0
	move.l	a0,d6
	beq.s	\error
	bsr	UnMakePort
\error:	moveq	#0,d0			;no port
	moveq	#0,d1
	bra.s	\out

	ENDC

;------------------------------------------------------------------------------
*
* RemoveBroker	- Remove broker from system and close/remove port
*
* INPUT		D0	Flag (0: remove all,  -: remove only broker)
*		A0	Broker (co)
*		A1	Message Port
*
;------------------------------------------------------------------------------
	IFD	xxx_RemoveBroker

RemoveBroker:
	movem.l	d0-a6,-(a7)

; It's time to clean up.  Start by removing the broker from the Commodities
; master list.  The DeleteCxObjAll() function will take care of removing a
; CxObject and all those connected to it from the Commodities network.

	move.l	a1,a4				;just store it
	move.l	CxBase(pc),a6
	tst.l	d0
	beq.s	\all
	jsr	-48(a6)			;_LVODeleteCxObj(a6)
	bra.s	\port

\all:	jsr	-54(a6)			;_LVODeleteCxObjAll(a6)
\port:	move.l	a4,a0
	bsr	UnMakePort
	movem.l	(a7)+,d0-a6
	rts

	ENDC

;------------------------------------------------------------------------------
*
* InstallHotKey	- install a HotKey (HotKey triad)
*
* INPUT		D0	ID (user specified)
*		A0	HotKey String
*		A1	Broker
*		A2	Broker Message Port
*
* RESULT	D0	Filter object or zero if failed
*
;------------------------------------------------------------------------------
	IFD	xxx_InstallHotKey

InstallHotKey:
	movem.l	d1-a6,-(a7)
	move.l	d0,d6			;store ID
	move.l	a1,a4			;store broker

; This filter passes input events that match the string pointed to by hotkey.

	move.l	CxBase(pc),a6
	move.l	#CX_FILTER,d0
	sub.l	a1,a1
	jsr	-30(a6)			;_LVOCreateCxObj(a6)	;CxFilter
	move.l	d0,d7
	beq	\error
	move.l	a4,a0			;broker
	move.l	d0,a1			;filter
	jsr	-84(a6)			;_LVOAttachCxObj(a6)

; CxSender() creates a sender CxObject.  Every time a sender gets a CxMessage,
; it sends a new CxMessage to the port pointed to in the first argument.
; CxSender()'s second argument will be the ID of any CxMessages the sender
; sends to the port.  The data pointer associated with the CxMessage will
; point to a *COPY* of the InputEvent structure associated with the orginal
; CxMessage.

	move.l	#CX_SEND,d0
	move.l	a2,a0			;broker_mp (port)
	move.l	d6,a1			;ID
	jsr	-30(a6)			;_LVOCreateCxObj(a6)	;CxSender
	move.l	d0,d6
	beq	\error
	move.l	d7,a0			;filter
	move.l	d0,a1			;sender object
	jsr	-84(a6)			;_LVOAttachCxObj(a6)
	
; CxTranslate() creates a translate CxObject. When a translate CxObject gets
; a CxMessage, it deletes the original CxMessage and adds a new input event
; to the input.device's input stream after the Commodities input handler.
; CxTranslate's argument points to an InputEvent structure from which to create
; the new input event.  In this example, the pointer is NULL, meaning no new
; event should be introduced.

	move.l	#CX_TRANSLATE,d0
	sub.l	a0,a0			;NULL
	sub.l	a1,a1
	jsr	-30(a6)			;_LVOCreateCxObj(a6)	;CxTranslate
	move.l	d0,d5
	beq	\error
	move.l	d7,a0			;filter
	move.l	d0,a1			;translate object
	jsr	-84(a6)			;_LVOAttachCxObj(a6)

	move.l	d7,a0			;filter, check for errors
	jsr	-66(a6)			;_LVOCxObjError(a6)
	tst.l	d0
	bne.s	\error

	move.l	d7,d0			;filter
\out:	movem.l	(a7)+,d1-a6
	rts

\error:	moveq	#0,d0
	bra.s	\out

	ENDC

;------------------------------------------------------------------------------
*
* RemCX		- remove a commodities object plus all object connected to
*		  this network.
*
* INPUT		A0	cx object  (f.e: HotKey filter)
*
;------------------------------------------------------------------------------
	IFD	xxx_RemCX

RemCX:	movem.l	d0-a6,-(a7)
	move.l	CxBase(pc),a6
	jsr	-54(a6)			;_LVODeleteCxObjAll(a6)
	movem.l	(a7)+,d0-a6
	rts

	ENDC

;------------------------------------------------------------------------------
*
* EnableCX	- activate commodity object
*
* INPUT		A0	Broker
*
;------------------------------------------------------------------------------
	IFD	xxx_EnableCX

EnableCX:
	movem.l	d0-a6,-(a7)	
	moveq	#1,d0
	move.l	CxBase(pc),a6
	jsr	-42(a6)			;_LVOActivateCxObj(a6)
	movem.l	(a7)+,d0-a6
	rts

	ENDC

;------------------------------------------------------------------------------
*
* DisableCX	- deactivate commodity object
*
* INPUT		A0	Broker
*
;------------------------------------------------------------------------------
	IFD	xxx_DisableCX

DisableCX:
	movem.l	d0-a6,-(a7)	
	moveq	#0,d0
	move.l	CxBase(pc),a6
	jsr	-42(a6)			;_LVOActivateCxObj(a6)
	movem.l	(a7)+,d0-a6
	rts

	ENDC

;------------------------------------------------------------------------------

;------------------
	base	csr_oldbase

;------------------
	opt	rcl

;------------------
	endif

 end

