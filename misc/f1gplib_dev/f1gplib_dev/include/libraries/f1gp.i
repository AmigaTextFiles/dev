	IFND LIBRARIES_F1GP_I
LIBRARIES_F1GP_I SET 1
**
**	$VER: f1gp.i 36.1 (10.11.99)
**
**	f1gp.library definitions
**
**	(C) Copyright 1995-1999 Oliver Roberts
**	All Rights Reserved
**

   IFND    EXEC_TYPES_I
   include 'exec/types.i'
   ENDC

   IFND    EXEC_LIBRARIES_I
   include 'exec/libraries.i'
   ENDC

** Constants returned by f1gpDetect()
**
F1GPTYPE_STANDARD	equ	1
F1GPTYPE_WC		equ	2
F1GPTYPE_A600WWW	equ	3

** Definition of the F1GP library base structure.
** Fields MUST not be modified by user programs, but they can be read.
**
   STRUCTURE F1GPBase,LIB_SIZE
	LONG    F1GPType	 ; Current F1GP type - see constants above
	STRUCT  HunkStart,4*4	 ; Address of each of F1GP's hunks
	LONG    Seg1		 ; HunkStart[0] - 0x2c
	LONG    Seg3		 ; HunkStart[2] - 0x4990c/49910/49920
	LABEL   F1GPBase_SIZE

** Constants used by f1gpRequestNotification(), and in F1GPMessages

F1GPEVENT_QUITGAME	equ	1
F1GPEVENT_EXITCOCKPIT	equ	2

** Message structure used by the notification feature

   STRUCTURE F1GPMessage,0
	STRUCT ExecMessage,MN_SIZE
	ULONG EventType		; Type of event that has occured - see above
	LABEL	F1GPMessage_SIZE

** DisplayInfo structure returned by f1gpGetDisplayInfo()

F1GPDISP_SCANDOUBLED	equ	1
F1GPDISP_AGAFETCH4X	equ	2

   STRUCTURE F1GPDisplayInfo,0
	UWORD diwstrt
	UWORD diwstop
	UWORD diwhigh
	UWORD ddfstrt
	UWORD ddfstop
	UWORD bplcon1
        ULONG flags
        UWORD def_diwstrt
	UBYTE cwait1
	UBYTE cwait2
	LABEL F1GPDisplayInfo_SIZE


F1GPNAME	MACRO
		DC.B "f1gp.library",0
		ENDM

   ENDC		; LIBRARIES_F1GP_I
