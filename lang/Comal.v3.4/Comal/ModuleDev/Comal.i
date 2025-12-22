	IFND	EXEC_TYPES_I

**
** Structure Building Macros
**
STRUCTURE   MACRO		            ; structure name, initial offset
\1	        EQU     0
SOFFSET     SET     \2
	          ENDM

FPTR	      MACRO		            ; function pointer (32 bits - all bits valid)
\1	        EQU     SOFFSET
SOFFSET     SET     SOFFSET+4
	          ENDM

BOOL	      MACRO		            ; boolean (16 bits)
\1	        EQU     SOFFSET
SOFFSET     SET     SOFFSET+2
	          ENDM

BYTE	      MACRO		            ; byte (8 bits)
\1	        EQU     SOFFSET
SOFFSET     SET     SOFFSET+1
	          ENDM

UBYTE	      MACRO		            ; unsigned byte (8 bits)
\1	        EQU     SOFFSET
SOFFSET     SET     SOFFSET+1
	          ENDM

WORD	      MACRO		            ; word (16 bits)
\1	        EQU     SOFFSET
SOFFSET     SET     SOFFSET+2
	          ENDM

UWORD	      MACRO		            ; unsigned word (16 bits)
\1	        EQU     SOFFSET
SOFFSET     SET     SOFFSET+2
	          ENDM

LONG	      MACRO		            ; long (32 bits)
\1	        EQU     SOFFSET
SOFFSET     SET     SOFFSET+4
	          ENDM

ULONG	      MACRO		            ; unsigned long (32 bits)
\1	        EQU     SOFFSET
SOFFSET     SET     SOFFSET+4
	          ENDM

FLOAT	      MACRO		            ; C float (32 bits)
\1	        EQU     SOFFSET
SOFFSET     SET     SOFFSET+4
	          ENDM
DOUBLE	    MACRO		            ; C double (64 bits)
\1	        EQU	    SOFFSET
SOFFSET	    SET	    SOFFSET+8
	          ENDM

APTR	      MACRO		            ; untyped pointer (32 bits - all bits valid)
\1	        EQU     SOFFSET
SOFFSET     SET     SOFFSET+4
	          ENDM

RPTR	      MACRO		            ; signed relative pointer (16 bits)
\1	        EQU     SOFFSET
SOFFSET     SET     SOFFSET+2
	          ENDM

LABEL	      MACRO		            ; Define a label without bumping the offset
\1	        EQU     SOFFSET
	          ENDM

STRUCT	    MACRO		            ; Define a sub-structure
\1	        EQU     SOFFSET
SOFFSET     SET     SOFFSET+\2
	          ENDM

ALIGNWORD   MACRO		            ; Align structure offset to nearest word
SOFFSET     SET     (SOFFSET+1)&$fffffffe
	    ENDM

ALIGNLONG   MACRO		            ; Align structure offset to nearest longword
SOFFSET     SET     (SOFFSET+3)&$fffffffc
	          ENDM


	ENDC	; EXEC_TYPES_I


  STRUCTURE COMALSTRUC,0     ; Comal structure
    UWORD CS_BreakFlags      ;
    UWORD CS_Flags           ; See definitions below
    APTR  CS_CurrWorkBottom  ; Current start of workspace
    APTR  CS_CurrWorkTop     ; Current top of workspace
    APTR  CS_MinStack        ; Safe low value of stack
    APTR  CS_IO_Screen       ; Input/output screen
    APTR  CS_CommPort        ; Port to comunicate with parent
    APTR  CS_ID              ; ASCII ID string for this project
    APTR  CS_MainPrgBuf      ; Main program buffer
    APTR  CS_PrgEnv          ; Current program environment
    APTR  CS_WorkStart       ; Start of workspace
    APTR  CS_WorkEnd         ; End of useable workspace
    ULONG CS_WorkLength      ; Total length of workspace
    APTR  CS_SortTable       ; String sort table
    APTR  CS_ComalPath       ; Home directory for comal
  LABEL COMALSTRUC_SIZEOF

; Break flags definitions (bit numbers)
BF_Esc:       EQU     0

; Flags definition (bit numbers)
F_EscMinus:   EQU     0      ; Trap escaping is active (TRAP ESC-)
F_EscPress:   EQU     1      ; Break pressed during TRAP ESC-


  STRUCTURE MODULESTRUC,0       ; Module structure
    APTR  MS_NextModule         ; Link to next module structure
    APTR  MS_Name               ; Pointer to name of module
    UBYTE MS_Type               ; Modules type - see below
    UBYTE MS_Flags              ; Flags - se below
    APTR  MS_PrgMem             ; Segment or program buffer
    APTR  MS_PrgEnv             ; Only used in comal modules
    APTR  MS_ModuleLine         ; Only used in comal modules
    WORD  MS_NumType            ; Number of types defined in modul
    APTR  MS_Types              ; Array of types defined in module
    WORD  MS_NumName            ; Number of names defined in modul
    APTR  MS_Names              ; Array of exported names
    APTR  MS_Signal             ; Address of signal routine

  LABEL MODULESTRUC_SIZEOF

; Module types
LOCALMODULE   EQU     1         ; Local module
EXTERNMODULE  EQU     2         ; External module
CODEMODULE    EQU     3         ; External machine coded module

;***********************************************************************
;
;         Standard type identifiers
;
;***********************************************************************

StringTypeId:  EQU     -1
FloatTypeId:   EQU     -2
UlongTypeId:   EQU     -3
LongTypeId:    EQU     -4
UshortTypeId:  EQU     -5
ShortTypeId:   EQU     -6
UbyteTypeId:   EQU     -7
ByteTypeId:    EQU     -8
StrucTypeId:   EQU     -9
ArrayTypeId:   EQU    -10
FuncTypeId:    EQU    -11
ProcTypeId:    EQU    -12
PointerTypeId: EQU    -13

; Comal library vector offsets
;
_LVOErrorNumber:       EQU    -6   ; Send error code
_LVOErrorText:         EQU   -12   ; Send error text
_LVOExecBreak:         EQU   -18   ; Execute break
_LVOLockComalWindow:   EQU   -24   ; Get shared lock for standard IO window
_LVOUnlockComalWindow: EQU   -30   ; Release lock for standard IO window
_LVOAddComalDevice:    EQU   -36   ; Add new IO device
_LVORemComalDevice:    EQU   -42   ; Remove IO device
_LVOComalWait:         EQU   -48   ; Wait for signal
_LVOAddExcept:         EQU   -54   ; Add exception routine
_LVORemExcept:         EQU   -60   ; Remove exception routine
_LVOAddSignal:         EQU   -66   ; Add Comal signal
_LVORemSignal:         EQU   -72   ; Remove Comal signal
_LVOGetAccept:         EQU   -78   ; Set up requester
