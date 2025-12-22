	IFND	SYSTEM_MODULES_I
SYSTEM_MODULES_I SET  1

**
**  $VER: modules.i V1.2
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**

	IFND	DPKERNEL_I
	include	'dpkernel/dpkernel.i'
	ENDC

******************************************************************************
* Module Control Structure.

VER_MODULE  = 1
TAGS_MODULE = ((ID_SPCTAGS<<16)|ID_MODULE)

   STRUCTURE	MD,HEAD_SIZEOF    ;Use standard header.
	WORD	MOD_Number        ;Number of the associated module.
	APTR	MOD_ModBase       ;Function jump table.
	APTR	MOD_Segment       ;
	WORD	MOD_TableType     ;Type of table to generate.
	WORD	MOD_empty         ;
	LONG	MOD_FunctionList  ;Array of functons.
	LONG	MOD_MinVersion    ;Min. required version of the module.
	LONG	MOD_MinRevision   ;Min. required revision of the module.
	APTR	MOD_Table         ;Pointer to start of table.
	APTR	MOD_Name          ;Name of the module.
	APTR	MOD_Public        ;Public details.

MODA_Number      = (TWORD|MOD_Number)
MODA_TableType   = (TWORD|MOD_TableType)
MODA_MinVersion  = (TLONG|MOD_MinVersion)
MODA_MinRevision = (TLONG|MOD_MinRevision)
MODA_Name        = (TAPTR|MOD_Name)

******************************************************************************
* Table-Type definitions.

JMP_DEFAULT = 1  ;Default LVO jump type.
JMP_AMIGAE  = 2  ;Amiga E jump table.

JMP_LIBRARY = JMP_AMIGAE
JMP_LVO     = JMP_DEFAULT

******************************************************************************
* Module file header.

MODULE_HEADER_V1 = $4D4F4401

    STRUCTURE   MT1,0
	LONG	MT_Version        ;Version/ID header.
	APTR	MT_Init           ;Init()
	APTR	MT_Close          ;Close()
	APTR	MT_Expunge        ;Expunge()
	WORD	MT_LVOType        ;Type of function table to generate.
	WORD	MT_OpenCount      ;Amount of programs with this module open.
	APTR	MT_Author         ;Author of the module.
	APTR	MT_FuncList       ;Pointer to function list.
	LONG	MT_CPUNumber      ;Type of CPU this module is compiled for.
	LONG	MT_ModVersion     ;Version of this module.
	LONG	MT_ModRevision    ;Revision of this module.
	LONG	MT_MinDPKVersion  ;Minimum DPK version required.
	LONG	MT_MinDPKRevision ;Minimum DPK revision required.
	LONG	MT_Open           ;Open()
	APTR	MT_ModBase        ;Generated function base for given CPU.
	APTR	MT_Copyright      ;Copyright details.
	APTR	MT_Date           ;Date of compilation.
	APTR	MT_Name           ;Name of the module.
	WORD	MT_DPKTable       ;Type of function table to get from DPK.
	WORD	MT_emp            ;Reserved.

******************************************************************************
* Private structure.

     STRUCTURE	ME1,0
	APTR	ME_Next         ;Next module in list.
	APTR	ME_Prev         ;Previous module in list.
	APTR	ME_Segment      ;Module segment.
	APTR	ME_Header       ;Pointer to module header.
	WORD	ME_ModuleID     ;Module ID.
	WORD	ME_BaseType     ;The tye of PersonalBase (eg JMP_LVO).
	APTR	ME_Name         ;Name of the module.
	APTR	ME_Public       ;Remember the details for the expunge.
	APTR	ME_PersonalBase ;Module's personal base structure.
	APTR	ME_PBMemory     ;PersonalBase memory allocation.

FUNC	MACRO
	dc.w	\1
	dc.l	\2
	ENDM

******************************************************************************

CPU_68000 = 1
CPU_68010 = 2
CPU_68020 = 3
CPU_68030 = 4
CPU_68040 = 5
CPU_68060 = 6

  ENDC	;SYSTEM_MODULES_I
