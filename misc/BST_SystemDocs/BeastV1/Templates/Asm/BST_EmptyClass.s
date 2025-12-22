;****h* Beast/BST_EmptyClass **************************************************
;*
;*	NAME
;*	  BST_EmptyClass -- (V1 Bravo)
;*
;*	COPYRIGHT
;*	  Maverick Software Development
;*
;*	FUNCTION
;*
;*	SUPERCLASS
;*
;*	BEAST ATTRIBUTES
;*
;*	NEW ATTRIBUTES
;*
;*	BEAST METHODS
;*
;*	NEW METHODS
;*
;*	AUTHOR
;*	  Jacco van Weert
;*
;*	CREATION DATE
;*	  4-Apr-95
;*
;*	MODIFICATION HISTORY
;*
;*	NOTES
;*
;****************************************************************************


	include	exec/types.i
	include	exec/nodes.i
	include	exec/lists.i
	include	exec/libraries.i
	include	exec/resident.i
	include exec/tasks.i
	INCLUDE	exec/exec_lib.i
	INCLUDE	exec/execbase.i
	INCLUDE	exec/initializers.i
	INCLUDE	exec/interrupts.i
	INCLUDE	exec/memory.i
	INCLUDE	exec/ports.i
	INCLUDE	libraries/dos.i

	INCLUDE	"Beast:Include/BST_System/Beast.i"
	INCLUDE	"Beast:Include/BST_System/Beast_lib.i"


;****** BST_EmptyClass/BST_EmptyInstance *********************************
;*
;*	NAME
;*	  BST_EmptyInstance -
;*
;*************************************************************************
			rsreset
			include	"Beast:Instances/BST_System/Asm/BST_EmptyClass.instance"
BST_EmptyInstanceSIZE:	rs.w	0


;		***********************************
;		**** definition of the library base
		rsreset
ClassLib	rs.b	$22
cl_SysLib	rs.l	1
cl_DosLib	rs.l	1
cl_SegList	rs.l	1
cl_Flags	rs.b	1
cl_pad		rs.b	1
Class_Sizeof	rs.l	0

MYPRI 		equ	0
VERSION		equ	1
REVISION	equ	1

libname	macro
	dc.b	'BST_EmptyClass'
	dc.b	'\<VERSION>','.','\<REVISION>'
	dc.b	' (1 Apr 1996)',$0d,$0a,0
	endm

Start:
	moveq	#0,d0
	rts

initDDescript
	dc.w	RTC_MATCHWORD
	dc.l	initDDescript
	dc.l	EndCode
	dc.b	RTF_AUTOINIT
	dc.b	VERSION
	dc.b	NT_LIBRARY
	dc.b	MYPRI
	dc.l	ClassName
	dc.l	idString
	dc.l	Init

ClassName	dc.b	'BST_EmptyClass',0
		even
idString 	libname
		even
dosName		DOSNAME
		even
Init
	dc.l	Class_Sizeof
	dc.l	funcTable
	dc.l	dataTable
	dc.l	initRoutine

funcTable
;			Standard functions
	dc.l	Open
	dc.l	Close
	dc.l	Expunge
	dc.l	Null
;			Library Functions

;			End of Functions
	dc.l	-1

dataTable
	INITBYTE LH_TYPE,NT_LIBRARY
	INITLONG LN_NAME,ClassName
	INITBYTE LIB_FLAGS,LIBF_SUMUSED!LIBF_CHANGED
	INITWORD LIB_VERSION,VERSION
	INITWORD LIB_REVISION,REVISION
	INITLONG LIB_IDSTRING,idString
	dc.l		0


;########################################
;####################### INIT ###########
initRoutine
	move.l	a5,-(sp)
	move.l	d0,a5

	move.l	a6,cl_SysLib(a5)
	move.l	a0,cl_SegList(a5)

	bsr	Init_Class

	move.l	a5,d0
	move.l	(sp)+,a5
	rts

;####################################
;#################### OPEN ##########
Open:
	addq.w	#1,LIB_OPENCNT(a6)
	bclr	#LIBB_DELEXP,cl_Flags(a6)
	move.l	a6,d0
	rts

;#####################################
;################ CLOSE ##############
Close:	moveq	#0,d0
	subq.w	#1,LIB_OPENCNT(a6)
	bne.s	.ll1

;	**** Disabled for debugging only

;	btst	#LIBB_DELEXP,cl_Flags(a6)
;	beq.s	.ll1

	bsr	Expunge
.ll1	rts

;###################################
;############### EXPUNGE ###########
Expunge:
	movem.l	d2/a5/a6,-(sp)
	move.l	a6,a5
	move.l	cl_SysLib(a5),a6
;			-- See of any-one has us open
	tst.w	LIB_OPENCNT(a5)
	beq.s	.ll1
;			-- We're still open. Set the delayed expunge flag
	bset	#LIBB_DELEXP,cl_Flags(a5)
	moveq	#0,d0
	bra.s	Expunge_End
;					Go ahead get rid of us.
.ll1:
	move.l	 cl_SegList(a5),d2
	move.l	 a5,a1			Unlink us from the library list
	CALLEXEC Remove

;	move.l	 cl_DosLib(a5),a1	Close all other things
;	CALLEXEC CloseLibrary
;
; Close here the things you opened in the init routine.
;
	bsr	 Exit_Class

	moveq	 #0,d0			Free our memory
	move.l	 a5,a1
	move.w	 LIB_NEGSIZE(a5),d0
	sub.l	 d0,a1
	add.w	 LIB_POSSIZE(a5),d0
	CALLEXEC FreeMem

	move.l	d2,d0
Expunge_End:
	movem.l	(sp)+,d2/a5/a6
	rts

;#################################
;#################################
Null			; The fourth standard function, see ref. manual.
	moveq	#0,d0
	rts

;****** BST_EmptyClass/Init_Class [1.0]
;*
;*	NAME
;*	  Init_Class -
;*
;**********************************
Init_Class:
	PUSHM	 d0-d7/a0-a6
	lea	 BeastName,a1
	moveq 	 #0,d0
	CALLEXEC OpenLibrary
	move.l	 d0,_BeastBase

;	*********************
;	**** Create the class
	lea	  ClassName,a0
	suba.l	  a1,a1
	moveq	  #BST_EmptyInstanceSIZE,d0
	CALLBEAST BST_MakeClass
	move.l	  d0,a2
	move.l	  d0,_ClassBase
	beq.s	  .out

;	******************************
;	**** Add the class(a2) methods

	move.l	  a2,a0
	lea	  mth_Init,a1		;* OBM_INIT
	move.l	  #OBM_INIT,d0
	CALLBEAST CLSS_AddMethod

	move.l	  a2,a0
	lea	  mth_Dispose,a1	;* OBM_DISPOSE
	move.l	  #OBM_DISPOSE,d0
	CALLBEAST CLSS_AddMethod

	move.l	  a2,a0
	lea	  mth_SetAttr,a1	;* OBM_SETATTR
	move.l	  #OBM_SETATTR,d0
	CALLBEAST CLSS_AddMethod

	move.l	  a2,a0
	lea	  mth_GetAttr,a1	;* OBM_GETATTR
	move.l	  #OBM_GETATTR,d0
	CALLBEAST CLSS_AddMethod

	move.l	  a2,a0
	CALLBEAST BST_AddClass

.out:	POPM	  d0-d7/a0-a6
	rts

;****** BST_EmptyClass/Exit_Class [1.0]
;*
;*	NAME
;*	  Exit_Class
;*
;***********************************
Exit_Class:
	PUSHM	  d0-d7/a0-a6

	move.l	  _ClassBase,a0
	CALLBEAST BST_RemoveClass
	move.l	  _ClassBase,a0
	CALLBEAST BST_FreeClass

;	************************
;	**** Close the libraries
	move.l	  _BeastBase,a1
	CALLEXEC  CloseLibrary

	POPM	  d0-d7/a0-a6
	rts

;****** BST_EmptyClass/mth_GetAttr ***********************************
;*
;*	NAME
;*	  mth_GetAttrMethod - (V1 Bravo)
;*
;*	INPUTS
;*	  d3 - MethodFlags
;*	  a2 - Object
;*	  a3 - TagList
;*
;*************************************************************************
mth_GetAttr:
	PUSH	  a6
	move.l	  a3,a0
	lea	  ga_SupTags,a1
	CALLBEAST BST_FillAttrTagList
	POP	  a6
	rts

;	************************************************
;	****	D4 = Number of this filled item
;	****	A0 = Pointer to { TAG, xxxx_data }
;	****	A2 = Pointer to the object
;	****	A3 = Pointer to the start of the TagList
;	****	A5 = Pointer to the Instance

ga_title:	move.l	Title(a5),4(a0)
		rts

ga_SupTags:	dc.l	BTA_Title,ga_title
		dc.l	TAG_DONE

;****** BST_EmptyClass/SetAttr [1.0] ********
;*
;*	NAME
;*	  SetAttr
;*
;*	INPUTS
;*	  as a normal method.
;*
;********************************************
SetAttr:
	PUSH	  a6
	move.l	  a3,a0
	lea	  sa_SupTags,a1
	CALLBEAST BST_FillAttrTagList
	POP	  a6
	rts

;	************************************************
;	****	D4 = Number of this filled item
;	****	A0 = Pointer to { TAG, xxxx_data }
;	****	A2 = Pointer to the object
;	****	A3 = Pointer to the start of the TagList
;	****	A5 = Pointer to the Instance

sa_title:	move.l	4(a0),Title(a5)
		rts

sa_SupTags:	dc.l	BTA_Title,sa_title
		dc.l	TAG_DONE


;****** BST_EmptyClass/mth_SetAttr *************************************
;*
;*	NAME
;*	  mth_SetAttr - (V1 Bravo)
;*
;*	INPUTS
;*	  d3 - MethodFlags
;*	  a2 - Object
;*	  a3 - TagList
;*
;*************************************************************************
mth_SetAttr:
	bsr	SetAttr
	rts

;****** BST_EmptyClass/mth_Init ****************************************
;*
;*	NAME
;*	  mth_Init - (V1 Bravo)
;*
;*	INPUTS
;*	  d3 - MethodFlags
;*	  a2 - Object
;*	  a3 - TagList
;*
;*	RESULT
;*	  d0 - New MethodFlags
;*
;*************************************************************************
mth_Init:
	bsr	SetAttr
	rts

;****** BST_EmptyClass/mth_Dispose *************************************
;*
;*	NAME
;*	  mth_Dispose - (V1 Bravo)
;*
;*	INPUTS
;*	  d3 - MethodFlags
;*	  a2 - Object
;*	  a3 - TagList
;*
;*	RESULT
;*	  d0 - New MethodFlags
;*
;*************************************************************************
mth_Dispose:
	PUSH	a6

;	************************************************
;	**** EXAMPLE: to get the pointer to the instance
;	****
	Macro_GetInstance a2,a6		;**** Object = a2, Instance = a6

	POP	a6
	move.l	d3,d0
	rts


EndCode:

;****i* BST_EmptyClass/DataSection ***************************************
;*
;*	NAME
;*	  DataSection - (V1 Bravo)
;*
;*************************************************************************
	SECTION	DATA

BeastName:	BEASTNAME
		even
_BeastBase:	dc.l	0
_ClassBase:	dc.l	0

	END
