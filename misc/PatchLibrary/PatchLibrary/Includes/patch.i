	IFND LIBRARIES_PATCH_I
LIBRARIES_PATCH_I SET 1
**
**	$Filename: libraries/patch.i $
**	$Release: 1.0 $
**
**	(C) Copyright 1993 Stefan Fuchs
**	All rights reserved
**
**      definition of patch.library public structures, returncodes and macros


	IFND EXEC_TYPES_I
	include "exec/types.i"
	ENDC


 STRUCTURE NewPatch,0
	APTR	NPAT_NewCode		;pointer to the patch code to be installed
	ULONG	NPAT_NewCodeSize	;optional length of NPAT_NewCode in bytes
	APTR	NPAT_LibraryName	;pointer to the LibraryName
	UWORD	NPAT_LibVersion		;version of Library to open
	WORD	NPAT_LVO		;LVO of function to patch
	WORD	NPAT_Priority		;Priority (-127...+126) of the patch
	UWORD	NPAT_Flags		;currently none defined (keep zero)
	APTR	NPAT_PatchName		;optional pointer to an IDString
	LONG	NPAT_Result2		;optional pointer to longword for Result2

 LABEL NPAT_SIZEOF


;ErrorCodes:
PATERR_Ok		equ	0	;Everything Ok
PATERR_PatchInUse	equ	1	;Patch Usecount <> 0
PATERR_InvalidHandle	equ	2	;Pointer to patch is not (no longer) valid
PATERR_OutOfMem		equ	3	;Out of memory
PATERR_OpenLib		equ	4	;Failed to open requested library
PATERR_FuncNotStd	equ	5	;Function to patch is not in the standard format
PATERR_PatchInstalled	equ	6	;Can't remove patch because another program has installed a non-patch.library patch later


;---------------------------------------------------------------
;--- FALLBACK - Call this macro instead of a 'rts' instruction
;--- in your patchcode, if you want to return to the original
;--- library code
;---------------------------------------------------------------
FALLBACK	MACRO
	move.l (sp),-(sp)
	clr.l 4(sp)
	rts

	ENDM

	ENDC	;LIBRARIES_PATCH_I
