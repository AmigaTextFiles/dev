	IFND SYSTEM_MISC_I
SYSTEM_MISC_I  SET  1

**
**	$VER: misc.i V2.1
**
**	(C) Copyright 1996-1998 DreamWorld Productions.
**	    All Rights Reserved
**

	IFND	DPKERNEL_I
	include	'dpkernel/dpkernel.i'
	ENDC

******************************************************************************
* Object Referencing structure.

VER_REFERENCE  = 2
TAGS_REFERENCE = ((ID_SPCTAGS<<16)|ID_REFERENCE)

    STRUCTURE	REF,HEAD_SIZEOF  ;Standard header.
	APTR	REF_Next         ;Next reference.
	APTR	REF_Prev         ;Previous reference.
	WORD	REF_ClassID      ;ID of the class.
	WORD	REF_Pad          ;Reserved.
	APTR	REF_ClassName    ;Name of the class.
	APTR	REF_ModName      ;Name of the module containing the object.
	APTR	REF_prvConfig    ;CheckFile code.
	WORD	REF_ModNumber    ;Module ID number.
	APTR	REF_Extension    ;File extension string.
	APTR	REF_Module       ;Pointer to opened module.
	APTR	REF_Task
	APTR	REF_ConfigFile   ;FileName.
	APTR	REF_FileHead

REFA_ClassID    = (TWORD|REF_ClassID)
REFA_ClassName  = (TAPTR|REF_ClassName)
REFA_ModName    = (TAPTR|REF_ModName)
REFA_ModNumber  = (TWORD|REF_ModNumber)
REFA_Extension  = (TAPTR|REF_Extension)
REFA_ConfigFile = (TAPTR|REF_ConfigFile)
REFA_FileHead   = (TAPTR|REF_FileHead)

******************************************************************************
* Universal Structure.

VER_UNIVERSE  = 1
TAGS_UNIVERSE = ((ID_SPCTAGS<<16)|ID_UNIVERSE)

   STRUCTURE	UN,HEAD_SIZEOF
	APTR	UN_Palette
	WORD	UN_Planes
	WORD	UN_ScrWidth
	WORD	UN_ScrHeight
	WORD	UN_Width
	WORD	UN_ByteWidth
	WORD	UN_Height
	APTR	UN_Task
	LONG	UN_Frequency
	LONG	UN_AmtColours
	WORD	UN_ScrMode
	WORD	UN_BmpType
	APTR	UN_Source
	APTR	UN_JoyData
	APTR	UN_Raster
	WORD	UN_ScrXOffset
	WORD	UN_ScrYOffset
	WORD	UN_BmpYOffset
	WORD	UN_BmpXOffset
	WORD	UN_Channel
	WORD	UN_Priority
	LONG	UN_Length
	WORD	UN_Octave
	WORD	UN_Volume
	LONG	UN_BmpFlags
	BYTE	UN_Name
	WORD	UN_Gutter
	WORD	UN_Colour
	WORD	UN_Point

  ENDC	;SYSTEM_MISC_I
