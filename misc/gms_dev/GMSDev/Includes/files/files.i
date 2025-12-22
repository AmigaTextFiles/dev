	IFND FILES_FILES_I
FILES_FILES_I  SET  1

**
**  $VER: files.i V1.0
**
**  File Definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**
**

	IFND    DPKERNEL_I
	include 'dpkernel/dpkernel.i'
	ENDC

****************************************************************************
* Module information.

FileModVersion  = 1
FileModRevision = 0

****************************************************************************
* Mini structures for source and destination operations.

;Filename structure.

   STRUCTURE	FN,0
	WORD	FN_ID           ;ID_FILENAME
	APTR	FN_Name         ;Pointer to filename.
	LABEL	FN_SIZEOF       ;Private.

;Memory pointer structure.

   STRUCTURE	MPTR,0
	WORD	MPTR_ID           ;ID_MEMPOINTER
	APTR	MPTR_Address      ;Pointer to memory area.
	LONG	MPTR_Size         ;Must supply a size unless you are a MemBlock.
	LABEL	MPTR_SIZEOF       ;Private.


	;Example: FILENAME "HD1:Picture.iff"

FILENAME MACRO
	dc.w	ID_FILENAME
	dc.l	.name\@
.name\@	dc.b	\1,0
	even
	ENDM

	;Example: MEMPTR $530

MEMPTR	MACRO
	dc.w	ID_MEMPTR
	dc.l	\1
	dc.l	\2
	ENDM

*****************************************************************************
* File Object.

VER_FILE  =	1
TAGS_FILE =	(ID_SPCTAGS<<16)|ID_FILE

   STRUCTURE	FL,HEAD_SIZEOF   ;Standard header.
	LONG	FL_BytePos       ;Current position in file.
	LONG	FL_Flags         ;File flags.
	APTR	FL_Source        ;Points to the Source descriptor.
	APTR	FL_Prev          ;Previous file in chain.
	APTR	FL_Next          ;Next file in chain.
	APTR	FL_DataProcessor ;Not available for program use.

*****************************************************************************
* File tags.

FLA_Flags   = (TLONG|FL_Flags)
FLA_Source  = (TAPTR|FL_Source)

*****************************************************************************
* Opening flags for Files and Directories.

FL_OLDFILE     = 0
FL_WRITE       = (1<<0)
FL_EXCLUSIVE   = (1<<1)
FL_DATAPROCESS = (1<<2)
FL_FIND        = (1<<3)
FL_NOUNPACK    = (1<<4)
FL_NOBUFFER    = (1<<5)
FL_NEWFILE     = (1<<6)
FL_ALPHASORT   = (1<<7)
FL_READ        = (1<<8)
FL_AUTOCREATE  = (1<<9)

FL_NOPACK      = FL_NOUNPACK

****************************************************************************
* Permission flags for Files and Directories.

FPT_READ     = $00000001
FPT_WRITE    = $00000002
FPT_EXECUTE  = $00000004
FPT_DELETE   = $00000008
FPT_SCRIPT   = $00000010
FPT_HIDDEN   = $00000020
FPT_ARCHIVE  = $00000040
FPT_PASSWORD = $00000080

*****************************************************************************
* Directory Object.

VER_DIRECTORY  = 1
TAGS_DIRECTORY = (ID_SPCTAGS<<16)|ID_DIRECTORY

   STRUCTURE	DIR,HEAD_SIZEOF
	APTR	DIR_ChildDir     ;First sub-directory under this dir.
	APTR	DIR_ChildFile    ;First file under this directory.
	APTR	DIR_Source       ;Location of the directory.
	LONG	DIR_Flags        ;Opening flags (see file flags).
	APTR	DIR_Next         ;Next directory in this list.
	APTR	DIR_Prev         ;Previous directory in this list.

DIRA_Source = (TAPTR|DIR_Source)
DIRA_Flags  = (TLONG|DIR_Flags)

  ENDC	;FILES_FILES_I

