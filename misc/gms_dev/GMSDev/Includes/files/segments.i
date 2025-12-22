	IFND FILES_SEGMENTS_I
FILES_SEGMENTS_I  SET  1

**
**	$VER: segments.i (June 1998)
**
**	Segment Definitions.
**
**	(C) Copyright 1996-1998 DreamWorld Productions.
**	    All Rights Reserved
**

	IFND    DPKERNEL_I
	include 'dpkernel/dpkernel.i'
	ENDC

****************************************************************************
* Segment object.

SEGVERSION   = 2
TAGS_SEGMENT = (ID_SPCTAGS<<16)|ID_SEGMENT

   STRUCTURE	SEG,HEAD_SIZEOF  ;Standard header.
	APTR	SEG_Prev         ;Previous segment.
	APTR	SEG_Next         ;Next segment.
	LONG	SEG_MemType      ;Memory type (eg MEM_DATA).
	APTR	SEG_Address      ;Pointer to segment start.
	APTR	SEG_Source       ;Source of segment (NB: FileName only).
	WORD	SEG_CPU          ;The CPU type.
	WORD	SEG_emp          ;...
	WORD	SEG_Size         ;Total size of the segment (in bytes).

SGA_Address = (TAPTR|SEG_Address)
SGA_MemType = (TAPTR|SEG_MemType)
SGA_Next    = (TAPTR|SEG_Next)
SGA_Prev    = (TAPTR|SEG_Prev)
SGA_Source  = (TAPTR|SEG_Source)
SGA_Size    = (TLONG|SEG_Size)

  ENDC	;FILES_SEGMENTS_I

