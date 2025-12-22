
; Library maker macro.	Based on the code by Rudla Kudla, adapted to work better on DEVPAC 3.14

LSt_Begin	EQU	1
LSt_Init	EQU	2
LSt_Funcs	EQU	3
LSt_Code	EQU	4
LSt_Done	EQU	5

Lib_State	SET	LSt_Begin

Lib		MACRO	

;-------------------------------------------------------------------------------

		IFEQ	Lib_State-LSt_Begin		; Inizializza la Lib ?
;	In:	Name,Version,Revision,Date,BaseSize
 		moveq.l	#-1,d0		; Se una Lib è eseguita, ritorna un
 		rts			; errore !
Lib_ROMTag\@	dc.w	$4afc		; ???
		dc.l	Lib_ROMTag\@,_Lib_End
		dc.b	$80,\2,9,0	; ???
		dc.l	Lib_Name,Lib_IdString,Lib_Init\@
Lib_Init\@	dc.l	\5,Lib_Func,Lib_InitData\@,Lib_InitBis
Lib_InitData\@	dc.w	$a008,$0900,$800a
		dc.l	Lib_Name,$a00e0600,$90140002,$90160000
		dc.w	$8018
		dc.l	Lib_IdString,0
Lib_Name	dc.b	'\1.library',0
Lib_IdString	dc.b	'$VER: \1.library \2.\3 (\4)',13,10,0
		EVEN
Lib_Small	SET	1
Lib_State	SET	LSt_Init
		MEXIT
		ENDC

;----------------------------------------------------------------------------------

		IFC	'\1','FUNCTIONS'
		 IFNE	Lib_State-LSt_Init
		 dc.b	'Declare HEADER before FUNCTIONS !'
		 ENDC
Lib_Func
Lib_FuncNum	 SET	0
Lib_State	 SET	LSt_Funcs
		 IFNE	Lib_Small
		 dc.w	-1
		 ENDC
		 MEXIT
		ENDC

;------------------------------------------------------------------------------------

		IFC	'\1','Init'
Lib_InitBis
		 MEXIT
		ENDC

;-----------------------------------------------------------------------------
		
		IFC	'\1','CODE'
		 IFNE	Lib_State-LSt_Funcs
		 dc.b	'Declare FUNCS before CODE !'
		 ENDC
		 dc.w	-1
		 IFEQ	Lib_Small
		 dc.w	-1
		 ENDC
Lib_State	 SET	LSt_Code
		 MEXIT
		ENDC

;-----------------------------------------------------------------------------

		IFC	'\1','END'
_Lib_End
Lib_State	 SET	LSt_Done
		 MEXIT
		ENDC

;------------------------------------------------------------------------------

		IFC	'\1','LARGE'
Lib_Small	 SET	0
		ENDC

;-----------------------------------------------------------------------------
		
		IFNC	'\1',''
		 IFEQ	Lib_State-LSt_Funcs
Lib_FuncNum	 SET	Lib_FuncNum+1
		  IFND	_LVO\1
_LVO\1		   EQU	-Lib_FuncNum*6
		   ENDC
		  IFNE	Lib_Small
		  dc.w	\1-Lib_Func
		  ELSE
		  dc.l	\1
		  ENDC
		 ENDC
		ENDC

;--------------------------------------------------------------------------------------
		
		IFEQ	Lib_State-LSt_Code
\1
		ENDC
		ENDM





