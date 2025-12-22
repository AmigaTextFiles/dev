; These are easylife internal error numbers. They are returned to AMOS as
; 16*256 + errn below
;
; They are returned from Easylife.Library in negative form in D0, if an
; error has occured. Positive error numbers from easylife.library are
; normal AMOS error numbers.
;
; NOTE: If an error has occured in Easylife.Library, the function called
;       will return with the zero bit set, and the error number in D0.
; 
;
;======================================================================
; IMPORTANT:
;
; Before including this file, you should set ELERR_INC_MESSAGES to:
;
; 0 = Just define the error number constants
; 1 = dc.b the error message strings seperated by null bytes also.
;======================================================================



;Check if these error have already been defined
;
IFND ELERR_PP_NoLib

ELERR_PP_NoLib		equ	0
ELERR_PP_EmptyFile	equ	1
ELERR_PP_Corrupt	equ	2
ELERR_PP_Encrypt1	equ	3
ELERR_PP_Encrypt2	equ	4
ELERR_PP_Memory		equ	5
ELERR_PP_Read		equ	6
ELERR_PP_Open		equ	7
ELERR_PP_Overflow	equ	8

ELERR_NotMessageBank	equ	9	
ELERR_ZoneTableFull	equ	10
ELERR_ZoneNotDefined	equ	11
ELERR_MultiNotReserved	equ	12
ELERR_ProtectFailed	equ	13
ELERR_DiskFontError	equ	14
ELERR_FontFail		equ	15
ELERR_NoOutputHandle	equ	16
ELERR_NoInputHandle	equ	17
ELERR_Pat_NoLib		equ	18
ELERR_Pat_NoDef		equ	19
ELERR_XPK		equ	20
ELERR_XPK_NoLib		equ	21
ELERR_UnmatchedTag	equ	22
ELERR_MUI_No_Lib	equ	23
ELERR_MUI_Bad_Object	equ	24	
ELERR_MUI_NoTagStart	equ	25

;Structure Commands.

ELERR_ArrayHigh		equ	30
ELERR_ArrayNeg		equ	31
ELERR_RangeLow		equ	32
ELERR_RangeHigh		equ	33
ELERR_Pointer		equ	34
ELERR_String		equ	35
ELERR_SubStruct		equ	36
ELERR_NoStruct		equ	37
ELERR_Unknown		equ	38
ELERR_Copy		equ	39
ELERR_InputL		equ	40
ELERR_InputT		equ	41

ENDC

IFGT	ELERR_INC_MESSAGES
	dc.b	"Unable To Open Powerpacker Library V35+",0
	dc.b	"You can't PPLoad an empty file",0
	dc.b	"Illegal powerpacker header",0
	dc.b	"File encrypted - Can't decrunch",0
	dc.b	"File encrypted - Can't decrunch",0
	dc.b 	"Out of memory while loading / decrunching file",0
	dc.b	"Error reading file",0
	dc.b	"Unable to open file",0
	dc.b	"Crunched File LONGER than source - Aborted",0


	dc.b	"Not a message bank",0
	dc.b	"Multi Zone Table Full - No space to set new zone",0
	dc.b	"Multi Zone Not Defined",0
	dc.b	"No Multi Zones Reserved",0
	dc.b	"Set Protection bits failed",0
	dc.b	"Can't open diskfont.library",0
	dc.b	"Unable to lock font",0		
	dc.b	"No STDOUT file handle exists",0	
	dc.b	"No STDIN file handle exists",0
	dc.b	"Can't open pattern.library",0
	dc.b	"No Default Pattern Defined",0
	dc.b	"An Xpk Error Has Occured",0
	dc.b	"Could Not Open XPK Master Library",0
	dc.b	"Unmatched tag",0
	dc.b	"Could Not Open MUI Master Library V8+ (MUI V2.1+)",0
	dc.b	"Illegal MUI Object Address",0
	dc.b	"Missing Elmui Begin Instruction",0


	dc.b	0,0,0,0	;26-29

	dc.b	"Array index value is too high",0
	dc.b	"Array index value is negative",0
	dc.b	"Value assigned is beyond lower limit of ranged integer",0
	dc.b	"Value assigned is beyond upper limit of ranged integer",0
	dc.b	"Value assigned points to wrong type of strucuture/no structure",0
	dc.b	"String assigned is longer than maximum length of this element",0
	dc.b	"Substructure addresses cannot be changed",0
	dc.b	"No structures are allocated",0
	dc.b	"Element/Structure not recognised",0
	dc.b	"Cannot copy between structures of different types",0
	dc.b	"Input string is of wrong length",0
	dc.b	"Input string is of wrong type",0	
ENDC

