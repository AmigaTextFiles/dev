*********************************************************************************
*										*
*                      ****   ASL Support  ****					*
*										*
*	Author		René Eberhard						*
*	Version		0.30							*
*	Last Revision	14.11.94						*
*	Identifier	asl_defined						*
*       Prefix		asl_   (asl)						*
*                               ¯¯¯ 		         			*
*				 						*
*-----------------------------[ UPDATES ]---------------------------------------*
*										*
*	-REB!	09-Apr-93	Start this Project				*
*	-SWA!	14.11.94	Register chaos fixed...				*
*										*
*********************************************************************************
*---------------------------[ Functions ]---------------------------------------*
*										*
* - InitASLFR, ResetASLFR, DisplayASLFR, LockToASLFR_Tag,			*
*   DefFontToASLFR_Tag, ASLFR_GetFileName, ASLFR_GetPathName, SetLoadName	*
*   ASL_DoValidTags								*
*										*
*---------------------------[ COMMENT ]-----------------------------------------*
*	    									*
*********************************************************************************

	IFND	asl_support
asl_support	SET	1

asls_oldbase	equ __BASE
	BASE	asls_base

asls_base:
		
;---------------[ Some includes ]-------------------------------------------

	include	"ASLSupport.i"
		
;---------------------------------------------------------------------------

	IFND	USE_NEWROUTINES
	NEED_	InitASLFR
	NEED_	ResetASLFR
	NEED_	DisplayASLFR
	NEED_	LockToASLFR_Tag
	NEED_	FontToASLFR_Tag
	NEED_	ASLFR_GetFileName
	NEED_	ASLFR_GetPathName
	NEED_	SetLoadName
	NEED_	ASL_DoValidTags
	ENDIF
		
;---------------------------------------------------------------------------
*********************************************************************************
*										*
* NAME    : InitASLFR								*
*										*
* SYNOPSIS: 									*
*       Result = InitASLFR (MyReqStruct,ReqTagList,MyOwnInitialTagList)		*
*       D0.L                A0.L	A1.L       A2.L 			*
*										*
* FUNCTION: Allocate an ASLFR structure and memory for the filename/path	*
*           handling								*
*										*
* RESULT  : Pointer to MyReqStruct or FALSE 					*
*										*
* COMMENT : - The standard asl_LoadName_SIZE is 512 bytes			*
*           - The standard asl_Path/Filename_SIZE is 256 bytes			*
*	    - This routine needs 68 bytes of stack without system calls		*
*	    - A2.L MUST BE NULL if there is no MyOwnInitialTagList		*
*										*
*********************************************************************************
	IFD	xxx_InitASLFR
InitASLFR:
	NEED_	ResetASLFR
	NEED_	ASL_DoValidTags
	NEED_	LockToASLFR_Tag
	NEED_	SetLoadName

	PUSHM.L	d1-a6			;Store all registers

	link    a5,#asli_SIZEOF

	move.l	a0,asli_Requester(a5)	;Store MyReqStruct
	move.l	a1,asli_ReqTagList(a5)	;Store ReqTagList 
	move.l	a2,asli_MyTagList(a5)	;Store MyTagList 

	move.l	a0,a4			;MyReqStruct

;---------------		
;---------------[ Allocate memory ]-----------------------------------------
;---------------		

	move.l	AbsExecBase,a6			;Get Execbase
	tst.l	aslfrs_LoadName(a4)		;Still initialized?
	bne	\Exit				;Yes

	move.l	#asl_LoadName_SIZE,d0		;Allocate aslfrs_LoadName
	move.l	#MEMF_CLEAR,d1
	JSRLIB_	AllocMem
	move.l	d0,aslfrs_LoadName(a4)		;Put memorybase into structure
	beq	\MasterExit

	move.l	#asl_PathName_SIZE,d0		;Allocate aslfrs_InitialDrawe
	move.l	#MEMF_CLEAR,d1
	JSRLIB_	AllocMem
	move.l	d0,aslfrs_InitialDrawer(a4)	;Put memorybase into structure
	beq	\MasterExit

	move.l	#asl_FileName_SIZE,d0		;Allocate aslfrs_InitialFile
	move.l	#MEMF_CLEAR,d1
	JSRLIB_	AllocMem
	move.l	d0,aslfrs_InitialFile(a4)	;Put memorybase into structure
	beq	\MasterExit

;---------------		
;---------------[ DO ASLFS_InitialLoadName ]--------------------------------
;---------------		

	tst.l	asli_MyTagList(a5)
	beq	\Asl			;No TagList

	move.l	UtilBase(PC),a6			;Get ASLFR_InitialDrawer
	move.l	#ASLFS_InitialLoadName,d0
	move.l	asli_MyTagList(a5),a0		;MyTagList
	JSRLIB_	FindTagItem
	tst.l	d0			;Tag in List?
	beq.s	\ELN			;Tag not in List -> End of LoadName
	move.l	d0,a0
	tst.l	ti_Data(a0)		;Tag initialized ?
	beq.s	\ELN			;Tag not initialized -> End of LoadName

	move.l	ti_Data(a0),a2		;Pointer to DefaultLoadName
	move.l	asli_Requester(a5),a0	;Restore MyReqStruct
	move.l	asli_ReqTagList(a5),a1	;Restore ReqTagList 
	bsr	SetLoadName		;Init Name
	tst.l	d0
	bne.s	\Win			;Everything is OK

\ELN:

;---------------		
;---------------[ DO ASLFS_InitialLock ]------------------------------------
;---------------		

	move.l	UtilBase(PC),a6		;Get ASLFR_InitialDrawer
	move.l	#ASLFS_InitialLock,d0
	move.l	asli_MyTagList(a5),a0	;MyTagList
	JSRLIB_	FindTagItem
	tst.l	d0			;Tag in List?
	beq.s	\EIL			;Tag not in List -> End of InitialLock
	move.l	d0,a0
	move.l	ti_Data(a0),d1		;Lock in D1.L
	beq.s	\EIL			;Tag not in List -> End of InitialLock

	move.l	asli_Requester(a5),a0	;Restore MyReqStruct
	move.l	asli_ReqTagList(a5),a1	;Restore ReqTagList 
	bsr	LockToASLFR_Tag		;Init Name
	tst.l	d0
	bne.s	\EIL			;Everything is OK

	bsr	ASL_DoValidTags		;Something is wrong

\EIL:

;---------------		
;---------------[ DO ASLFS_Window ]-----------------------------------------
;---------------		

\Win:	move.l	UtilBase(PC),a6		;Get ASLFS_Window
	move.l	#ASLFS_Window,d0
	move.l	asli_MyTagList(a5),a0	;MyTagList
	JSRLIB_	FindTagItem
	tst.l	d0			;Tag in List?
	beq.s	\EWIN			;Tag not in List -> End of Window
	move.l	d0,a0
	move.l	ti_Data(a0),d7		;Save Windowpointer
	beq.s	\EWIN			;Windowpointer not initialized -> End of Window

	move.l	#ASLFR_Window,d0	;Get ASLFR_Window (Requester TagList)
	move.l	asli_ReqTagList(a5),a0	;Requester TagList
	JSRLIB_	FindTagItem
	tst.l	d0			;Tag in List?
	beq.s	\EWIN			;Tag not in List -> End of Window
	move.l	d0,a0
	move.l	d7,ti_Data(a0)		;Put WindowPointer into Requester TagList

\EWIN:

;---------------		
;---------------[ Init ASL requester ]--------------------------------------
;---------------		

\Asl:	move.l	AslBase(PC),a6		;Get AslBase
	tst.l	aslfrs_Requester(a4)	;Still initialised?
	bne.s	\Exit			;Yes

	move.l	asli_ReqTagList(a5),a0	;Taglist
	moveq	#ASL_FileRequest,d0	;Type = FileRequest
	JSRLIB_	AllocAslRequest
	move.l	d0,aslfrs_Requester(a4)	;Store requester
	beq	\MasterExit


\Exit:	unlk    a5

	POPM.L	d1-a6			;Restore all registers
	move.l	a0,d0			;Restore MyReqStruct
	rts

;---------------		
;---------------[ Master exit ]---------------------------------------------
;---------------		

\MasterExit:

	unlk    a5

	move.l	a4,a0			;Init for FailInitASLFR
	bra.s	FailInitASLFR
		
;---------------[ Stackvariabeln ]------------------------------------------

			FORESET
asli_Requester:		FO.L	1
asli_ReqTagList:	FO.L	1
asli_MyTagList:		FO.L	1
asli_SIZEOF		FOVAL

	ENDC

;---------------------------------------------------------------------------
*********************************************************************************
*										*
* NAME    : ResetASLFR								*
*										*
* SYNOPSIS: 									*
*       Result = ResetASLFR (MyReqStruct)					*
*       D0.L                 A0.L						*
*										*
* FUNCTION: Reset all memory and ASL entrys					*
*										*
* RESULT  : Always FALSE		 					*
*										*
*********************************************************************************
	IFD	xxx_ResetASLFR
ResetASLFR:
	PUSHM.L	d1-a6
	
FailInitASLFR:
	move.l	a0,a5			;Store MyReqStruct

	move.l	AslBase(PC),a6		;Get AslBase
	move.l	aslfrs_Requester(a5),d0	;Requster allocated ?
	beq.s	\NoReq			;No
	move.l	d0,a0
	JSRLIB_	FreeAslRequest
	clr.l	aslfrs_Requester(a5)

\NoReq:
	move.l	AbsExecBase,a6		;Get Execbase
	move.l	aslfrs_LoadName(a5),d0	;Memory base
	beq.s	\NoLoadName
	move.l	d0,a1			;MemoryBlock
	move.l	#asl_LoadName_SIZE,d0	;Memory size
	JSRLIB_	FreeMem			;Free LoadName
	clr.l	aslfrs_LoadName(a5)

\NoLoadName:
	move.l	aslfrs_InitialDrawer(a5),d0	;Memory base
	beq.s	\NoInitialDrawer
	move.l	d0,a1				;MemoryBlock
	move.l	#asl_PathName_SIZE,d0		;Memory size
	JSRLIB_	FreeMem				;Free InitialDrawer
	clr.l	aslfrs_InitialDrawer(a5)

\NoInitialDrawer:
	move.l	aslfrs_InitialFile(a5),d0	;Memory base
	beq.s	\NoInitialFile
	move.l	d0,a1				;MemoryBlock
	move.l	#asl_FileName_SIZE,d0		;Memory size
	JSRLIB_	FreeMem				;Free InitialDrawer
	clr.l	aslfrs_InitialFile(a5)

\NoInitialFile:
	POPM.L	d1-a6			;Restore all registers
	moveq	#0,d0			;FALSE
	rts

	ENDC
;---------------------------------------------------------------------------
*********************************************************************************
*										*
* NAME    : DisplayASLFR							*
*										*
* SYNOPSIS: 									*
*       Result = DisplayASLFR (MyReqStruct,Tags)				*
*       D0.L                   A0.L	   A1.L					*
*										*
* RESULT  : Pointer to MyReqStruct or FALSE by an error or CANCEL		*
*										*
*********************************************************************************
	IFD	xxx_DisplayASLFR
DisplayASLFR:
	PUSHM.L	d1-a6
	move.l	a0,a5				;Store MyReqStruct
	
	move.l	AslBase(PC),a6
	move.l	aslfrs_Requester(a5),d0		;Requester
	beq.s	\Exit				;Requester NOT initialised
	move.l	d0,a0
	JSRLIB_	AslRequest			;Disply requester
	tst.l	d0
	beq	\Exit				;Error or CANCEL
		
;---------------[ Copy path and filename into aslfrs_LoadName buffer ]------

	move.l	a5,d0			;Init result
	move.l	aslfrs_Requester(a5),a0
	move.l	fr_Drawer(a0),a1	;Pointer to pathname
	move.l	fr_File(a0),a2		;Pointer to filename
	move.l	aslfrs_LoadName(a5),d0	;Pointer to loadname buffer
	beq.s	\Exit			;LoadName buffer NOT initialised
	move.l	d0,a3				

	tst.b	(a1)			;Pathname?
	beq.s	\PathOk			;No

10$	move.b	(a1)+,(a3)+		;Copy pathname
	tst.b	(a1)			;End of pathname?
	bne.s	10$			;No --> Loop

	cmp.b	#":",-1(a3)		;Signed end of volume/assign?
	beq.s	\PathOk
	cmp.b	#"/",-1(a3)		;Signed end of directory?
	beq.s	\PathOk
	move.b	#"/",(a3)+		;Indicate end of directory

\PathOk:
	clr.b	(a3)			;Terminate with NULL if there is
					;no filename

	tst.b	(a2)			;Filename?
	beq	\Exit			;No --> Exit

20$	move.b	(a2)+,(a3)+		;Copy filename
	tst.b	(a2)			;End of filename?
	bne.s	20$			;No --> Loop

	clr.b	(a3)			;Terminate with NULL

;---------------[ Exit ]----------------------------------------------------

\Exit:	POPM.L	d1-a6				;Restore all registers
	rts

	ENDC
;---------------------------------------------------------------------------
*********************************************************************************
*										*
* NAME    : LockToASLFR_Tag							*
*										*
* SYNOPSIS: 									*
*       Result = LockToASLFR_Tag (Lock,MyReqStruct,Tags)			*
*       D0.L                      D1.L A0.L        A1.L				*
*										*
* RESULT  : Pointer to MyReqStruct or FALSE by error.				*
*										*
*********************************************************************************
	IFD	xxx_LockToASLFR_Tag
LockToASLFR_Tag:
	NEED_	ResetASLFR

	PUSHM.L	d1-a6

	move.l	a0,a5			;Store MyReqStruct
	move.l	a1,a4			;Store TagList
	move.l	d1,d7			;Store Lock
		
;---------------[ Find ASLFR_InitialDrawer ]--------------------------------

	move.l	UtilBase(PC),a6		;Get ASLFR_InitialDrawer
	move.l	#ASLFR_InitialDrawer,d0
	move.l	a4,a0			;TagList
	JSRLIB_	FindTagItem
	tst.l	d0
	beq	\Exit			;ASLFR_InitialDrawer not in TagList
	move.l	d0,a4			;Store pointer to Tag entry

;---------------[ Lock to ASCII, put buffer in TagList ]--------------------

\Mem:	move.l	DosBase(PC),a6
	move.l	d7,d1				;Lock
	move.l	aslfrs_InitialDrawer(a5),d2	;Buffer
	move.l	#asl_PathName_SIZE,d3		;Length
	JSRLIB_	NameFromLock
	tst.l	d0
	beq.s	\Exit

	move.l	aslfrs_InitialDrawer(a5),ti_Data(a4)	;Put buffer into TagList
	move.l	a5,d0					;Result

\Exit:	POPM.L	d1-a6					;Restore all registers
	rts

	ENDC
;---------------------------------------------------------------------------
*********************************************************************************
*										*
* NAME    : DefFontToASLFR_Tag							*
*										*
* SYNOPSIS: 									*
*       DefFontToASLFR_Tag (TextAttr,Tags)					*
*                           A0.L     A1.L					*
*										*
* RESULT  : none								*
*										*
* COMMENT : DO NOT USE THIS FUNCTION						*
*	    This function has not much sense.					*
*	    You have the same effect, if you set ASLFR_TextAttr,0		*
*	    This function is a test for another function called			*
*	    NewFontToASLFR_Tag. It is comming soon.				*
*           Put in A0.L a pointer to the TextAttr stucture. Use ta_SIZEOF.	*
*										*
*********************************************************************************
	IFD	xxx_FontToASLFR_Tag
DefFontToASLFR_Tag:

	PUSHM.L	d0-a6
	move.l	a0,a3			;Store my own TextAttr structure
	move.l	a1,a4			;Store TagList
		
;---------------[ Find ASLFR_TextAttr ]-------------------------------------

	move.l	UtilBase(PC),a6		;Get ASLFR_TextAttr
	move.l	#ASLFR_TextAttr,d0
	move.l	a4,a0			;TagList
	JSRLIB_	FindTagItem
	tst.l	d0
	beq	\Exit			;ASLFR_InitialDrawer not in TagList
	move.l	d0,a4			;Store pointer to Tag entry

;---------------[ Fill TextAttr structure ]---------------------------------

	move.l	GfxBase(PC),a6
	move.l	gb_DefaultFont(a6),a0		;Defaultfont
	move.l	LN_NAME(a0),ta_Name(a3)		;Put in Name
	move.w	tf_YSize(a0),ta_YSize(a3)	;Put in YSize
	move.b	tf_Style(a0),ta_Style(a3)	;Put in Style
	move.b	tf_Flags(a0),ta_Flags(a3)	;Put in Flags

	move.l	a3,ti_Data(a4)			;Put in TextAttr in TagList

\Exit:	POPM.L	d0-a6				;Restore all registers
	rts

	ENDC
;---------------------------------------------------------------------------
*********************************************************************************
*										*
* NAME    : ASLFR_GetFileName							*
*										*
* SYNOPSIS: 									*
*       Result = ASLFR_GetFileName (MyReqStruct)				*
*       D0.L                        A0.L       					*
*										*
* RESULT  : Pointer to filename 						*
*										*
* COMMENT : This is the ACTUAL filename. Use CopyString_ to copy the		*
*  	    filename into your own buffer					*
*										*
*********************************************************************************
	IFD	xxx_ASLFR_GetFileName
ASLFR_GetFileName:
	tst.l	aslfrs_Requester(a0)
	beq.s	\Rtn

	move.l	aslfrs_Requester(a0),a0
	move.l	fr_File(a0),d0		;Pointer to filename

\Rtn:	rts
	ENDC
;---------------------------------------------------------------------------
*********************************************************************************
*										*
* NAME    : ASLFR_GetPathName							*
*										*
* SYNOPSIS: 									*
*       Result = ASLFR_GetPathName (MyReqStruct)				*
*       D0.L                        A0.L       					*
*										*
* RESULT  : Pointer to pathname 						*
*										*
* COMMENT : This is the ACTUAL pathname. Use CopyString_ to copy the		*
*  	    pathname into your own buffer					*
*										*
*********************************************************************************
	IFD	xxx_ASLFR_GetPathName
ASLFR_GetPathName:
	tst.l	aslfrs_Requester(a0)
	beq.s	\Rtn

	move.l	aslfrs_Requester(a0),a0
	move.l	fr_Drawer(a0),d0	;Pointer to pathname

\Rtn:	rts
	ENDC
;---------------------------------------------------------------------------
*********************************************************************************
*										*
* NAME    : SetLoadName								*
*										*
* SYNOPSIS: 									*
*       Result = SetLoadName (MyReqStruct,TagList,DefaultLoadName)		*
*       D0.L                  A0.L        A1.L    A2.L				*
*										*
* RESULT  : Pointer to aslfrs_LoadName or FALSE by error.			*
*										*
* COMMENT : - The DefaultLoadName must be NULL TERMINATED			*
*	    - Include ASLFR_InitialDrawer and ASLFR_InitialFile in your		*
*	      TagList.								*
*	    - This routine needs 84 bytes of stack without system calls		*
*	    - (Consult the ASLSupport.DOC for more details)			*
*										*
*********************************************************************************
	IFD	xxx_SetLoadName
SetLoadName:

	PUSHM.L	d1-a6

	link    a5,#asll_SIZEOF

	move.l	a0,asll_Requester(a5)	;Store MyReqStruct
	move.l	a1,asll_TagList(a5)	;Store TagList
	move.l	a2,asll_LoadName(a5)	;Store DefaultLoadName
	move.l	a0,a4			;MyReqStruct SAVE A4.L

	move.l	aslfrs_LoadName(a4),d0	;Get loadname buffer
	beq	\Exit			;NOT initialized -> Exit (FAIL)
	move.l	d0,asll_LoadNameBuffer(a5)

;---------------[ Initialize Taglist ]--------------------------------------

	move.l	UtilBase(PC),a6		;Get ASLFR_InitialDrawer
	move.l	#ASLFR_InitialDrawer,d0
	move.l	asll_TagList(a5),a0	;TagList
	JSRLIB_	FindTagItem
	move.l	d0,asll_DrawerTag(a5)	;Store tag entry
	beq.s	\TFile			;ASLFR_InitialDrawer not in TagList

	move.l	d0,a1
	lea	ASLS_NullName(PC),a0
	move.l	a0,ti_Data(a1)		;Important to do!!


\TFile:	move.l	#ASLFR_InitialFile,d0
	move.l	asll_TagList(a5),a0	;TagList
	JSRLIB_	FindTagItem
	move.l	d0,asll_FileTag(a5)	;Store tag entry
	beq.s	\FGet			;ASLFR_InitialDrawer not in TagList

	move.l	d0,a1
	lea	ASLS_NullName(PC),a0
	move.l	a0,ti_Data(a1)		;Important to do!!

;---------------
;---------------[ Get path and file part ]----------------------------------
;---------------

\FGet:	move.l	DosBase(PC),a6
	move.l	aslfrs_InitialDrawer(a4),a0	;Get drawer buffer
	clr.b	(a0)				;Clr aslfrs_InitialDrawer
	move.l	asll_LoadName(a5),d1		;Pointer to DefaultLoadName
	JSRLIB_	PathPart
	move.l	d0,d5
	cmp.l	asll_LoadName(a5),d0		;Same string adresse?
	beq.s	\File				;There is a pathname


;---------------
;---------------[ Copy pathname into aslfrs_InitialDrawer ]-----------------
;---------------

\Path:	move.l	#asl_PathName_SIZE-1,d7		;Max size of pathname
	move.l	aslfrs_InitialDrawer(a4),a0	;Destination drawer buffer
	move.l	aslfrs_LoadName(a4),a1		;Destination loadname buffer
	move.l	asll_LoadName(a5),a2		;Source

\PCopy:	move.b	(a2),(a0)+			;Copy complete pathname
	move.b	(a2),(a1)+			;Copy into LoadName buffer
	addq.l	#1,a2
	cmp.l	a2,d5
	bls.s	\PTag
	dbf	d7,\PCopy			;--> Loop

	move.l	aslfrs_InitialDrawer(a4),a0	;Buffer overflow
	clr.b	(a0)				;Clr aslfrs_InitialDrawer
	move.l	aslfrs_LoadName(a4),a1		
	clr.b	(a1)				;Clr aslfrs_LoadName
	clr.l	d0				;FAIL
	bra	\Exit

;---------------[ Put buffer in TagList ]-----------------------------------

\PTag:	clr.b	(a0)					;Set end of aslfrs_InitialDrawer
	move.l	a1,asll_LoadNameBuffer(a5)		;Pointer after "/" or ":"

	tst.l	asll_DrawerTag(a5)
	beq.s	\File
	move.l	asll_DrawerTag(a5),a0			;Tag entry
	move.l	aslfrs_InitialDrawer(a4),ti_Data(a0)	;Put buffer into TagList

;---------------
;---------------[ Copy filename into aslfrs_InitialFile ]-------------------
;---------------

\File:	move.l	asll_LoadName(a5),d1		;Pointer to DefaultLoadName
	JSRLIB_	FilePart
	move.l	d0,a2

	move.l	aslfrs_InitialFile(a4),a0	;Destination file buffer
	move.l	asll_LoadNameBuffer(a5),a1	;Destination loadname buffer
	move.l	#asl_FileName_SIZE-1,d7		;Max size of filename

\FCopy:	move.b	(a2),(a0)+			;Copy pathname
	move.b	(a2)+,(a1)+			;Copy  LoadName
	beq.s	\FTag				;Init Tag
	dbf	d7,\FCopy			;--> Loop

	move.l	aslfrs_InitialFile(a4),a0	;Buffer overflow
	clr.b	(a0)				;Clr aslfrs_InitialFile
	move.l	aslfrs_LoadName(a4),a1		
	clr.b	(a1)				;Clr aslfrs_LoadName
	clr.l	d0				;FAIL
	bra	\Exit

;---------------[ Put buffer in TagList ]-----------------------------------

\FTag:	tst.l	asll_FileTag(a5)
	beq.s	\Exit
	move.l	asll_FileTag(a5),a0			;Tag entry
	move.l	aslfrs_InitialFile(a4),ti_Data(a0)	;Put buffer into TagList

	move.l	aslfrs_LoadName(a4),d0			;Init result

;---------------[ Exit ]----------------------------------------------------

\Exit:	unlk	a5
	POPM.L	d1-a6
	rts
			FORESET
asll_Requester:		FO.L	1
asll_TagList:		FO.L	1
asll_FileTag:		FO.L	1	;ASLFR_InitialFile
asll_DrawerTag:		FO.L	1	;ASLFR_InitialDrawer
asll_LoadName:		FO.L	1	;Input loadname
asll_LoadNameBuffer:	FO.L	1	;Actual pointer in buffer
asll_FileName:		FO.L	1	;Pointer to Filename
asll_SIZEOF		FOVAL

	ENDC
;---------------------------------------------------------------------------
*********************************************************************************
*										*
* NAME    : ASL_DoValidTags							*
*										*
* SYNOPSIS: 									*
*       ASL_DoValidTags (MyReqStruct,TagList)					*
*                        A0.L        A1.L    					*
*										*
* RESULT  : none								*
*										*
* COMMENT : - This function initialize a ASL Taglist.				*
*	      If you are not shure what is in it, use this function.		*
*	      If there are some invalid entrys , the enforcer says "hello"	*
*										*
*********************************************************************************
	IFD	xxx_ASL_DoValidTags
ASL_DoValidTags:

	PUSHM.L	d0-a6

	move.l	a0,a4			;Store MyReqStruct
	move.l	a1,a5			;Store TagList
		
;---------------[ Searching for ASLFR_InitialDrawer ]-----------------------

	move.l	UtilBase(PC),a6		;Get ASLFR_InitialDrawer
	move.l	#ASLFR_InitialDrawer,d0
	move.l	a5,a0			;TagList
	JSRLIB_	FindTagItem
	tst.l	d0
	beq.s	\ND			;ASLFR_InitialDrawer not in TagList

	move.l	d0,a1
	lea	ASLS_NullName(PC),a0
	move.l	a0,ti_Data(a1)		;Important to do!!

;---------------[ Searching for ASLFR_InitialFile ]-------------------------

\ND:	move.l	#ASLFR_InitialFile,d0
	move.l	a5,a0			;TagList
	JSRLIB_	FindTagItem
	tst.l	d0
	beq.s	\Rtn			;ASLFR_InitialFile not in TagList

	move.l	d0,a1
	lea	ASLS_NullName(PC),a0
	move.l	a0,ti_Data(a1)		;Important to do!!


\Rtn:	POPM.L	d0-a6			;Restore all registers
	rts

	ENDC

;---------------------------------------------------------------------------
	BASE	asls_oldbase

	ENDC
;---------------------------------------------------------------------------
