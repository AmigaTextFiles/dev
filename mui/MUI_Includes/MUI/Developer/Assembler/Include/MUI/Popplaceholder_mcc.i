	IFND	GOLEM_POPPLACEHOLDER_MCC_I
GOLEM_POPPLACEHOLDER_MCC_I	SET	1

*	Assembler version by Ilkka Lehtoranta (29-Nov-99)

*** Include stuff ***


	IFND	LIBRARIES_MUI_I
	INCLUDE	"libraries/mui.i"
	ENDC


*** MUI Defines ***

;#define MUIC_Popplaceholder  "Popplaceholder.mcc"
;#define MUIC_Popplaceholderp "Popplaceholder.mcp"
;#define PopplaceholderObject MUI_NewObject(MUIC_Popplaceholder

;#define MUIC_Popph  "Popplaceholder.mcc"
;#define MUIC_Popphp "Popplaceholder.mcp"
;#define PopphObject MUI_NewObject(MUIC_Popph

	IFND	CARLOS_MUI
MUISERIALNR_CARLOS	EQU	2447
TAGBASE_CARLOS		EQU	(TAG_USER | ( MUISERIALNR_CARLOS << 16))
CARLOS_MUI		SET	1
	ENDC

TBPPH	EQU	TAGBASE_CARLOS


*** Methods ***

MUIM_Popph_OpenAsl	EQU	(TBPPH + $0000)	; PRIVATE
MUIM_Popph_DoCut	EQU	(TBPPH + $0001)
MUIM_Popph_DoCopy	EQU	(TBPPH + $0002)
MUIM_Popph_DoPaste	EQU	(TBPPH + $0003)
MUIM_Popph_DoClear	EQU	(TBPPH + $0004)

*** Method structs ***


*** Special method values ***


*** Special method flags ***


*** Attributes ***


MUIA_Popph_Array	EQU	(TBPPH + $0010)	; v14 {IS.} APTR
MUIA_Popph_Separator	EQU	(TBPPH + $0011)	; v14 {ISG} CHAR default '|'
MUIA_Popph_Contents	EQU	(TBPPH + $0012)	; v14 {ISG} STRPTR
MUIA_Popph_StringKey	EQU	(TBPPH + $0013)	; v14 {IS.} CHAR
MUIA_Popph_PopbuttonKey	EQU	(TBPPH + $0014)	; v14 {IS.} CHAR
MUIA_Popph_StringMaxLen	EQU	(TBPPH + $0015)	; v14 {I..} ULONG
MUIA_Popph_CopyEntries	EQU	(TBPPH + $0016)	; v14 {ISG} BOOL
MUIA_Popph_PopAsl	EQU	(TBPPH + $0017)	; v15 {I..} BOOL
MUIA_Popph_AslActive	EQU	(TBPPH + $0018)	; v15 {..G} ULONG
MUIA_Popph_AslType	EQU	(TBPPH + $0019)	; v15 {I..} ULONG
MUIA_Popph_Avoid	EQU	(TBPPH + $001a)	; v15 {I..} ULONG
MUIA_Popph_StringType	EQU	(TBPPH + $001b)	; v15 {..G} ULONG
MUIA_Popph_ReplaceMode	EQU	(TBPPH + $001c)	; v15 {ISG} ULONG
MUIA_Popph_StringObject	EQU	(TBPPH + $001d)	; v15 {..G} APTR
MUIA_Popph_ListObject	EQU	(TBPPH + $001e)	; v15 {..G} APTR
MUIA_Popph_DropObject	EQU     (TBPPH + $001f)	; v15 {IS.} PRIVATE
MUIA_Popph_BufferPos	EQU	(TBPPH + $0020)	; v14 {ISG} PRIVATE
MUIA_Popph_MaxLen	EQU	(TBPPH + $0021)	; v14 {I.G} PRIVATE
MUIA_Popph_ContextMenu	EQU	(TBPPH + $0022) ; v15 {ISG} BOOL
MUIA_Popph_PopCycleChain	EQU	(TBPPH + $0023) ; v15 (ISG) BOOL
MUIA_Popph_Title		EQU	(TBPPH + $0024) ; v15 (IS.) STRPTR
MUIA_Popph_SingleColumn		EQU	(TBPPH + $0025) ; V15 (ISG) BOOL


*** Special attribute values ***

MUIV_Popph_StringType_String		EQU	0
MUIV_Popph_StringType_Betterstring	EQU	1
MUIV_Popph_StringType_Textinput		EQU	2

MUIV_Popph_Avoid_Betterstring		EQU	1<<0
MUIV_Popph_Avoid_Textinput		EQU	1<<1
MUIV_Popph_Avoid_Nlist			EQU	1<<2	;  not supported yet!

MUIV_Popph_InsertMode_DD_Default	EQU	1<<0
MUIV_Popph_InsertMode_DD_CursorPos	EQU	1<<1
MUIV_Popph_InsertMode_DD_Apend		EQU	1<<2
MUIV_Popph_InsertMode_DD_Prepend	EQU	1<<3
MUIV_Popph_InsertMode_DC_Default	EQU	1<<4
MUIV_Popph_InsertMode_DC_CursorPos	EQU	1<<5
MUIV_Popph_InsertMode_DC_Apend		EQU	1<<6
MUIV_Popph_InsertMode_DC_Prepend	EQU	1<<7

MUIV_Popph_InsertMode_Default	EQU	MUIV_Popph_InsertMode_DD_Default   | MUIV_Popph_InsertMode_DC_Default
MUIV_Popph_InsertMode_CursorPos	EQU	MUIV_Popph_InsertMode_DD_CursorPos | MUIV_Popph_InsertMode_DC_CursorPos
MUIV_Popph_InsertMode_Apend	EQU	MUIV_Popph_InsertMode_DD_Apend     | MUIV_Popph_InsertMode_DC_Apend
MUIV_Popph_InsertMode_Prepend	EQU	MUIV_Popph_InsertMode_DD_Prepend   | MUIV_Popph_InsertMode_DC_Prepend

*** Structures, Flags & Values ***


*** Configs ***



*** Other things ***

POPPH_MAX_KEY_LEN	EQU	50	;  touch this and die!
POPPH_MAX_STRING_LEN	EQU	128	;  touch this and die!


	ENDC	; GOLEM_POPPLACEHOLDER_MCC_I

