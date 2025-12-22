;****h* Beast/BeastConstants ************************************************
;*
;*	NAME
;*	  BeastConstants -- Constants definition for BEAST. (v0.1)
;*
;*	COPYRIGHT
;*	  Maverick Software Development
;*
;*	FUNCTION
;*
;*	AUTHOR
;*	  Jacco van Weert
;*
;*	CREATION DATE
;*	  23-Apr-95
;*
;*	MODIFICATION HISTORY
;*
;*	NOTES
;*
;****************************************************************************

	IFND	BEAST_I
BEAST_I	SET	1

PUSH	MACRO
	move.l	\1,-(sp)
	ENDM
POP	MACRO
	move.l	(sp)+,\1
	ENDM
PUSHM	MACRO
	movem.l	\1,-(sp)
	ENDM
POPM	MACRO
	movem.l	(sp)+,\1
	ENDM
IF_BEQ  MACRO
	tst.l	\1
	beq.\0	\2
	ENDM
IF_BNE  MACRO
	tst.l	\1
	bne.\0	\2
	ENDM


	IFND	UTILITY_TAGITEM_I
	INCLUDE	"utility/tagitem.i"
	ENDC
	IFND	UTILITY_HOOKS_I
	INCLUDE	"utility/hooks.i"
	ENDC

;****** BeastConstants/BSTC_Root ********************************************
;*
;*	NAME
;*	  BSTC_Root -- Root class. (v0.1)
;*
;****************************************************************************
			rsreset
BSTC_Root:		rs.b	LN_SIZE
BSTC_Size:		rs.l	1		;* Size of the total Class.
BSTC_Flags		rs.l	1
;BSTC_InputPorts:	rs.b	MLH_SIZE
;BSTC_OutputPorts:	rs.b	MLH_SIZE
BSTC_Methods:		rs.b	MLH_SIZE	;* List of supported methods (CLSS_MLxx)
BSTC_ObjectCount:	rs.l	1		;* How many objects created of this class?
BSTC_ExtClass:		rs.l	1		;* Pointer to ExtClass library
BSTC_UserData:		rs.l	1
BSTC_RootSIZE:		rs.w	0

;	**** The BSTC_Flags
	BITDEF	CLASS,B52CLASS,0

;****** BeastConstants/CLSS_MethodList **************************************
;*
;*	NAME
;*	  CLSS_MethodList -- List of methods. (v0.1)
;*
;****************************************************************************
			rsreset
CLSS_MethodList:	rs.b	MLN_SIZE
CLSS_MLMethodID:	rs.l	1		;* Method ID
CLSS_MLHookList:	rs.b	MLH_SIZE	;* List of method calls
CLSS_MethodListSIZE:	rs.w	0


;****** BeastConstants/ML_Hook **********************************************
;*
;*	NAME
;*	  ML_Hook -- Method hook. (v0.1)
;*
;****************************************************************************
			rsreset
ML_Hook:		rs.b	h_SIZEOF
ML_HookSIZE:		rs.w	0

;****** BeastConstants/BSTO_System ******************************************
;*
;*	NAME
;*	  BSTO_System -- Standard Object. (v0.1)
;*
;****************************************************************************
			rsreset
OBJ_BSTObject:		rs.b	MLN_SIZE
OBJ_DataSection:	rs.l	1		;* Pointer to the data section (WILL NOT CHANGE)
OBJ_InputList:		rs.b	MLH_SIZE	;* Pointer a list of inputs
OBJ_OutputList:		rs.b	MLH_SIZE	;* Pointer a list of outputs
OBJ_Class:		rs.l	1		;* ^ObjectClass
OBJ_Parent:		rs.l	1		;* Parent-Object
OBJ_Childs:		rs.b	MLH_SIZE	;* Childs-Objects
OBJ_Flags:		rs.l	1		;* Object-Flags
OBJ_SystemSIZE:		rs.w	0

	BITDEF	OBJ,Dispose,0			;* The object must be disposed
	BITDEF	OBJ,Skip,1			;* This object will be skipped in the method calls
	BITDEF	OBJ,SubClass,2			;* Object is an integral part of another object.

;****** BeastConstants/OBJ_InputOutput **************************************
;*
;*	NAME
;*	  OBJ_InputOutput -- (v0.1)
;*
;****************************************************************************

;	**********************************
;	**** OIL ObjectInputLink structure
			rsreset
OIL_Connection:		rs.b	MLN_SIZE	;* OIL = Object Input Link
OIL_Object:		rs.l	1		;* Pointer to *this* object
OIL_FromMethodOOL:	rs.l	1		;* Pointer to the connected input OOL structure
OIL_InputMethod:	rs.l	1		;* The input method ID
OIL_ConnectionSIZE:	rs.w	0

;	***********************************
;	**** OOL ObjectOutputLink structure
			rsreset
OOL_Connection:		rs.b	MLN_SIZE	;* OOL = Object Output Link
OOL_Object:		rs.l	1		;* Pointer to *this* object
OOL_ToMethodOIL:	rs.l	1		;* Pointer to the connected output OIL structure
OOL_OutputMethod:	rs.l	1		;* The output method ID
OOL_ConnectionSIZE:	rs.w	0


;	**********************************************
;	**** CIL ClassInputLink structure OBSOLETE!!!!
			rsreset
CIL_Input:		rs.b	MLN_SIZE
CIL_InputMethod:	rs.l	1
CIL_InputPortname:	rs.l	1
CIL_InputSIZE:		rs.w	0

;	***********************************************
;	**** COL ClassOutputLink structure OBSOLETE!!!!
			rsreset
COL_Output:		rs.b	MLN_SIZE
COL_OutputMethod:	rs.l	1
COL_OutputPortname:	rs.l	1
COL_OutputSIZE:		rs.w	0




;****** BeastConstants/BST_Base *********************************************
;*
;*	NAME
;*	  BST_Base -- Base structure. (v0.1)
;*
;****************************************************************************
			rsreset
BST_Base:		rs.b	OBJ_SystemSIZE
BST_DefinedClasses:	rs.b	MLH_SIZE
BST_BaseSIZE:		rs.w	0

;****** BeastConstants/BST_StandardMethods **********************************
;*
;*	NAME
;*	  BST_StandardMethods -- Standard methods. (v0.1)
;*
;*	RESULT
;*
;****************************************************************************

OBM_bits_FUNCTION =$F0000000
OBM_type_None	  =$00000000

OBM_bits_FAMILY	  =$0F000000
OBM_type_Plain	  =$00000000
OBM_type_System	  =$01000000
OBM_type_General  =$02000000
OBM_type_B52	  =$03000000
OBM_type_BeaVis	  =$04000000
OBM_type_BFS	  =$05000000
OBM_type_BeaMM	  =$06000000
OBM_type_BEASTAR  =$07000000


;	/**** Numbers   $0000040 - $000007f Free */
OBM_local0	=$0000040
;	/**** Numbers   $0000100 - $00007ff Free */
OBM_local1	=$0000100
;	/**** Numbers 	$0004000 - $0004fff Free */
OBM_local2	=$0004000
;	/**** Numbers   $0100000 - $01fffff Free */
OBM_local3	=$0100000

OBM_INPUT       =$0000080
OBM_OUTPUT      =$0000081
OBM_INPUT2      =$0000082
OBM_OUTPUT2     =$0000083
OBM_INPUT3      =$0000084
OBM_OUTPUT3     =$0000085
OBM_INPUT4      =$0000086
OBM_OUTPUT4     =$0000087
OBM_SYSINPUT    =$0000088
OBM_SYSOUTPUT   =$0000089
OBM_IDCMPINPUT	=$000008A
OBM_IDCMPOUTPUT	=$000008B
OBM_BVSINPUT	=$000008C
OBM_BVSOUTPUT	=$000008D
OBM_BEAMMINPUT  =$000008E
OBM_BEAMMOUTPUT	=$000008F
OBM_BFSINPUT	=$0000090
OBM_BFSOUTPUT	=$0000091
OBM_CONTENTSINPUT  = $0000092

OBM_CONTENTSOUTPUT = $0000093
;**** BTA_Flags for the OBM_CONTENTSOUTPUT method ****/
CONTENTSOUTPUT_FULL		=	0
CONTENTSOUTPUT_FIXED		=	1
CONTENTSOUTPUT_UNTILBYTE	=	2
CONTENTSOUTPUT_UNTILWORD	=	3
CONTENTSOUTPUT_UNTILLONG	=	4
CONTENTSOUTPUT_END		=	5


OBM_ALLOCMEM	=$0000100
OBM_FREEMEM	=$0000101
OBM_LOCKMEM	=$0000102
OBM_UNLOCKMEM	=$0000103

OBM_GETATTR     =$0001000
OBM_SETATTR     =$0001001

OBM_UPDATE	=$0001100

OBM_INIT        =$0040000
OBM_DISPOSE     =$0040001

OBM_DUPLICATE	=$0050000
OBM_COPY	=$0050001
OBM_MOVE	=$0050002
;**** BTA_Flags for the OBM_MOVE method ****
	BITDEF	MOVE,START,0
	BITDEF	MOVE,END,1
	BITDEF	MOVE,DRAG,2

OBM_SIZE	=$0050003
OBM_INSERT	=$0050004
OBM_ADDHEAD	=$0050005
OBM_ADDTAIL	=$0050006
OBM_REMOVE	=$0050007
OBM_REMHEAD	=$0050008
OBM_REMTAIL	=$0050009

;**********************************
;**** Beast System classes methods
;****
OBM_GETEACH	=$0000000+OBM_type_System
OBM_FOREACH	=$0000001+OBM_type_System

OBM_EVENTLOOP	=$0001000+OBM_type_System
OBM_ADDEVENT	=$0001001+OBM_type_System
OBM_REMEVENT	=$0001002+OBM_type_System


;**********************************
;**** Beast General classes methods
;****
OBM_SEARCHOBJECT	=$0000000+OBM_type_General
;**** BTA_Flags for the OBM_SEARCHOBJECT method ****/
SEARCHOBJECTMODE_bits	=$0000000F
	BITDEF	SEARCHOBJECTMODE,ONELEVEL,0
	BITDEF	SEARCHOBJECTMODE,ALLCHILDREN,1

OBM_reply_SEARCHOBJECT	=$0000001+OBM_type_General


;***************************
;**** BeaVis classes methods
;****
OBM_DRAW		=$0000000+OBM_type_BeaVis
OBM_ENTEROBJECT		=$0000001+OBM_type_BeaVis
OBM_LEAVEOBJECT		=$0000002+OBM_type_BeaVis
OBM_OBJECTDOWN		=$0000003+OBM_type_BeaVis
OBM_OBJECTUP		=$0000004+OBM_type_BeaVis

OBM_DOLAYOUT		=$0000100+OBM_type_BeaVis
OBM_ASKLAYOUT		=$0000101+OBM_type_BeaVis
OBM_REPLYLAYOUT		=$0000102+OBM_type_BeaVis
OBM__GETLAYOUTreply	=$0000103+OBM_type_BeaVis

OBM_SIZE_TOPLEFT	=$0000200+OBM_type_BeaVis
OBM_SIZE_TOPRIGHT	=$0000201+OBM_type_BeaVis
OBM_SIZE_DOWNRIGHT	=$0000202+OBM_type_BeaVis
OBM_SIZE_DOWNLEFT	=$0000203+OBM_type_BeaVis
;**** BTA_Flags for the OBM_SIZE_xx methods ****
	BITDEF	SIZE,START,0
	BITDEF	SIZE,END,1


;************************
;**** BFS classes methods
;****
OBM_LOCKFILE		=$0000000+OBM_type_BFS
OBM_READFILE		=$0000001+OBM_type_BFS

;***********************************
;****			     	****
;**** BEAST Standard Attributes ****
;****			     	****
;***********************************

BST_bits_System		=$7F000000
BST_TAG 		=TAG_USER+$40000000

	BITDEF	BT,Ignore,29
	BITDEF	BT,Attributes,28
	BITDEF	BT,UserTag,27

BST_bits_Types		=$00F00000
BTA_type_Plain		=$00000000
BTA_type_CString	=$00100000
BTA_type_Object		=$00200000
BTA_type_Pointer	=$00300000
BTA_type_TagList	=$00400000
BTA_type_Flags		=$00500000
BTA_type_Tag		=$00600000
BTA_type_Filename	=$00700000

BST_bits_Family		=$000F0000
BTA_type_System		=$00000000
BTA_type_General	=$00010000
BTA_type_B52		=$00020000
BTA_type_BeaVis		=$00030000
BTA_type_BFS		=$00040000
BTA_type_BeaMM		=$00050000
BTA_type_BEASTAR	=$00060000


;************
;**** Control
;****/
BTA_CONTROL		=BST_TAG+BTF_Attributes+$000
BTA_NumberOf		=BTA_CONTROL+$01

;*************
;**** Position
;****/
BTA_POSITION		=BST_TAG+BTF_Attributes+$100
BTA_X			=BTA_POSITION+$00+BTA_type_Plain
BTA_Y			=BTA_POSITION+$01+BTA_type_Plain
BTA_Width		=BTA_POSITION+$02+BTA_type_Plain
BTA_Height		=BTA_POSITION+$03+BTA_type_Plain
BTA_Size		=BTA_POSITION+$04+BTA_type_Plain
BTA_InnerX		=BTA_POSITION+$05+BTA_type_Plain
BTA_InnerY		=BTA_POSITION+$06+BTA_type_Plain
BTA_InnerWidth		=BTA_POSITION+$07+BTA_type_Plain
BTA_InnerHeight		=BTA_POSITION+$08+BTA_type_Plain


;**********
;**** Types
;****/
BTA_TYPES		=BST_TAG+BTF_Attributes+$200
BTA_LongNumber		=BTA_TYPES+$00+BTA_type_Plain
BTA_Flags		=BTA_TYPES+$01+BTA_type_Flags

BTA_Pointer		=BTA_TYPES+$0A+BTA_type_Pointer
BTA_ByteNumber		=BTA_TYPES+$0B+BTA_type_Plain
BTA_WordNumber		=BTA_TYPES+$0C+BTA_type_Plain
BTA_FFPNumber		=BTA_TYPES+$0D+BTA_type_Plain

;***************
;**** Identifier
;****
BTA_IDENTIFIER		=BST_TAG+BTF_Attributes+$300
BTA_Title		=BTA_IDENTIFIER+$00+BTA_type_CString
BTA_MainObject		=BTA_IDENTIFIER+$01+BTA_type_Object
BTA_Object1		=BTA_IDENTIFIER+$02+BTA_type_Object
BTA_Object2		=BTA_IDENTIFIER+$03+BTA_type_Object
BTA_Object3		=BTA_IDENTIFIER+$04+BTA_type_Object
BTA_Object4		=BTA_IDENTIFIER+$05+BTA_type_Object
BTA_Object5		=BTA_IDENTIFIER+$06+BTA_type_Object
BTA_Object6		=BTA_IDENTIFIER+$07+BTA_type_Object
BTA_Object7		=BTA_IDENTIFIER+$08+BTA_type_Object
BTA_Object8		=BTA_IDENTIFIER+$09+BTA_type_Object
BTA_Object9		=BTA_IDENTIFIER+$0A+BTA_type_Object
BTA_Method		=BTA_IDENTIFIER+$0B+BTA_type_Plain
BTA_TagList		=BTA_IDENTIFIER+$0C+BTA_type_TagList
BTA_ClassName		=BTA_IDENTIFIER+$0D+BTA_type_CString
BTA_FromObject		=BTA_IDENTIFIER+$0E+BTA_type_Object
BTA_ToObject		=BTA_IDENTIFIER+$0F+BTA_type_Object


;***********
;**** SYSTEM
;****
BTA_SYSTEM		=BST_TAG+BTF_Attributes+$400
BTA_MemBlock		=BTA_SYSTEM+$00+BTA_type_Pointer
BTA_MemHandle		=BTA_SYSTEM+$01+BTA_type_Pointer
BTA_MemFlags		=BTA_SYSTEM+$02+BTA_type_Flags
	BITDEF	MEM,MOVEABLE_DISK,24
	BITDEF	MEM,MOVEABLE_MEMORY,25
	BITDEF	MEM,DISCARDABLE,26
BTA_MemSize		=BTA_SYSTEM+$03+BTA_type_Plain
BTA_Signals		=BTA_SYSTEM+$04+BTA_type_Flags
BTA_Signals_AND		=BTA_SYSTEM+$05+BTA_type_Flags
BTA_Signals_OR		=BTA_SYSTEM+$06+BTA_type_Flags
BTA_Signals_XOR		=BTA_SYSTEM+$07+BTA_type_Flags
BTA_MsgPort		=BTA_SYSTEM+$08+BTA_type_Pointer
BTA_Message		=BTA_SYSTEM+$09+BTA_type_Pointer

;********************************************
;**** BEAST GENERAL CLASS TAG and definitions
;****
BST_GENERAL		=BST_TAG+BTF_Attributes+BTA_type_General
BTA_TagListObject	=BST_GENERAL+$0000+BTA_type_Object
BTA_TagListSize		=BST_GENERAL+$0001+BTA_type_Plain

;**** BTA_Flags for the OBM_SIZE of BST_MemoryClass
	BITDEF	MEMSIZE,RETAIN,0




;****************************************
;**** BEAST BFS CLASS TAG and definitions
;****
BFS_FILESYSTEM		=BST_TAG+BTF_Attributes+BTA_type_BFS
BFS_UserName		=BFS_FILESYSTEM+$0000+BTA_type_CString
BFS_UserPassword	=BFS_FILESYSTEM+$0001+BTA_type_CString
BFS_SystemName		=BFS_FILESYSTEM+$0002+BTA_type_CString
BFS_MountName		=BFS_FILESYSTEM+$0003+BTA_type_CString
BFS_LockName		=BFS_FILESYSTEM+$0004+BTA_type_CString
BFS_LockObject		=BFS_FILESYSTEM+$0005+BTA_type_Object
BFS_LockFlags		=BFS_FILESYSTEM+$0006+BTA_type_Flags
LOCKMODE_bits	=	$0000000F
	BITDEF	LOCKMODE,READ,0
	BITDEF	LOCKMODE,WRITE,1
	BITDEF	LOCKMODE,NEW,2

;************************************************
;**** BEAST VISUAL (BeaVis) TAG's and definitions
;****
BVS_SYSTEM		=BST_TAG+BTF_Attributes+BTA_type_BeaVis
BVS_BorderType		=BVS_SYSTEM+$0000+BTA_type_Plain
BORDERTYPE_NONE		=	0
BORDERTYPE_LINE		=	1
BORDERTYPE_BUTTON	=	2
BORDERTYPE_STRING	=	3
BORDERTYPE_XEN		=	4

BVS_ColorScheme		=BVS_SYSTEM+$0001+BTA_type_Plain
COLORSCHEME_NORMAL	=	0
COLORSCHEME_PRESSED	=	1

BVS_RenderMode		=BVS_SYSTEM+$0002+BTA_type_Plain
RENDERMODE_NONE		=	0
RENDERMODE_LIGHT	=	1
RENDERMODE_MEDIUM	=	2
RENDERMODE_HEAVY	=	3
RENDERMODE_FULL		=	4

BVS_IRastport		=BVS_SYSTEM+$0003+BTA_type_Pointer
BVS_RectGadgetFlags	=BVS_SYSTEM+$0004+BTA_type_Flags
	BITDEF	RECTGADGET,ADDED,0
	BITDEF	RECTGADGET,PRESSED,1
	BITDEF	RECTGADGET,ENTERED,2
	BITDEF	RECTGADGET,RENDERED,3
BVS_TextFlags		=BVS_SYSTEM+$0005+BTA_type_Flags
TEXTTYPE_bits		=$0000000F
	BITDEF	TEXTTYPE,NORMAL,0
	BITDEF	TEXTTYPE,BOLD,1
	BITDEF	TEXTTYPE,ITALIC,2
	BITDEF	TEXTTYPE,WIDE,3
	BITDEF	TEXTTYPE,UNDERLINED,4
TEXTJUST_bits		=$000000F0
	BITDEF	TEXTJUST,LEFT,8
	BITDEF	TEXTJUST,RIGHT,9
TEXTJUST_CENTER_H	=TEXTJUSTF_LEFT+TEXTJUSTF_RIGHT
	BITDEF	TEXTJUST,TOP,10
	BITDEF	TEXTJUST,BOTTOM,11
TEXTJUST_CENTER_V	=TEXTJUSTF_TOP+TEXTJUSTF_BOTTOM
BVS_TextTitle		=BVS_SYSTEM+$0006+BTA_type_CString
BVS_ImageFlags		=BVS_SYSTEM+$0007+BTA_type_Flags
IMAGEFILL_bits		=$0000F000
IMAGEFILL_NONE		=$00000000
IMAGEFILL_SOLID		=$00001000
IMAGEFILL_CHECKERED	=$00002000
IMAGEFILL_LIGHTCHECK	=$00003000
IMAGEPICT_bits		=$00F00000
IMAGEPICT_NONE		=$00000000
IMAGEPICT_ONCE		=$00100000
IMAGEPICT_ALL		=$00200000

BVS_ObjectType		=BVS_SYSTEM+$0008+BTA_type_Flags
OBJECTTYPEFAMILY_bits			=$000000FF
OBJECTTYPEFAMILY_default		=$00000000
OBJECTTYPEFAMILY_TEXTBUTTON		=$00000001
OBJECTTYPEFAMILY_WINDOWLAYOUT		=$00000002
OBJECTTYPEFAMILY_DRAGBARLAYOUT		=$00000003
OBJECTTYPEFAMILY_WINDOWCONTENTSLAYOUT	=$00000004
OBJECTTYPEFAMILY_DRAGBARBUTTON		=$00000005
OBJECTTYPEFAMILY_LAYOUT			=$00000006
OBJECTTYPEFAMILY_STRINGGADGET		=$00000007
OBJECTTYPEFAMILY_LABEL1			=$00000008
OBJECTTYPEFAMILY_LABEL2			=$00000009
OBJECTTYPEFAMILY_LABEL3			=$0000000A
OBJECTTYPEFAMILY_LABEL4			=$0000000B
OBJECTTYPEFAMILY_WINDOWSTATUSBAR	=$0000000C
OBJECTTYPEFAMILY_IMAGEBUTTON		=$0000000D

BVS_LayoutType		=BVS_SYSTEM+$0009+BTA_type_Flags
BVS_PositionType	=BVS_SYSTEM+$000A+BTA_type_Flags
BVS_IWindow		=BVS_SYSTEM+$000B+BTA_type_Pointer
BVS_ImageTitle		=BVS_SYSTEM+$000C+BTA_type_Filename
BVS_WindowTitle		=BVS_SYSTEM+$000D+BTA_type_CString
BVS_FontAttr		=BVS_SYSTEM+$000E+BTA_type_Pointer
BVS_FontHeight		=BVS_SYSTEM+$000F+BTA_type_Plain
BVS_FontStyle		=BVS_SYSTEM+$0010+BTA_type_Plain
BVS_FontFlags		=BVS_SYSTEM+$0011+BTA_type_Flags
BVS_FontName		=BVS_SYSTEM+$0012+BTA_type_CString


BVS_ForegroundColor 	=BVS_SYSTEM+$0104+BTA_type_Plain
BVS_BackgroundColor 	=BVS_SYSTEM+$0105+BTA_type_Plain
BVS_OutlineColor 	=BVS_SYSTEM+$0106+BTA_type_Plain
BVS_Shine100Color	=BVS_SYSTEM+$0107+BTA_type_Plain
BVS_Shine75Color	=BVS_SYSTEM+$0108+BTA_type_Plain
BVS_Shine50Color	=BVS_SYSTEM+$0109+BTA_type_Plain
BVS_Shine25Color	=BVS_SYSTEM+$010A+BTA_type_Plain
BVS_Shadow100Color	=BVS_SYSTEM+$010B+BTA_type_Plain
BVS_Shadow75Color	=BVS_SYSTEM+$010C+BTA_type_Plain
BVS_Shadow50Color	=BVS_SYSTEM+$010D+BTA_type_Plain
BVS_Shadow25Color	=BVS_SYSTEM+$010E+BTA_type_Plain
BVS_Fill100Color	=BVS_SYSTEM+$010F+BTA_type_Plain
BVS_Fill75Color		=BVS_SYSTEM+$0110+BTA_type_Plain
BVS_Fill50Color		=BVS_SYSTEM+$0111+BTA_type_Plain
BVS_Fill25Color		=BVS_SYSTEM+$0112+BTA_type_Plain
BVS_Mark100Color	=BVS_SYSTEM+$0113+BTA_type_Plain
BVS_Mark75Color		=BVS_SYSTEM+$0114+BTA_type_Plain
BVS_Mark50Color		=BVS_SYSTEM+$0115+BTA_type_Plain
BVS_Mark25Color		=BVS_SYSTEM+$0116+BTA_type_Plain
BVS_Back100Color	=BVS_SYSTEM+$0117+BTA_type_Plain
BVS_Back75Color		=BVS_SYSTEM+$0118+BTA_type_Plain
BVS_Back50Color		=BVS_SYSTEM+$0119+BTA_type_Plain
BVS_Back25Color		=BVS_SYSTEM+$011A+BTA_type_Plain
BVS_TextColor		=BVS_SYSTEM+$011B+BTA_type_Plain
BVS_ImageForeColor	=BVS_SYSTEM+$011C+BTA_type_Plain
BVS_ImageBackColor	=BVS_SYSTEM+$011D+BTA_type_Plain

BVS_X1			=BVS_SYSTEM+$0200+BTA_type_Plain
BVS_Y1			=BVS_SYSTEM+$0201+BTA_type_Plain
BVS_Z1			=BVS_SYSTEM+$0202+BTA_type_Plain
BVS_X2			=BVS_SYSTEM+$0203+BTA_type_Plain
BVS_Y2			=BVS_SYSTEM+$0204+BTA_type_Plain
BVS_Z2			=BVS_SYSTEM+$0205+BTA_type_Plain
BVS_LayoutWidth		=BVS_SYSTEM+$0206+BTA_type_Plain
BVS_LayoutHeight	=BVS_SYSTEM+$0207+BTA_type_Plain
BVS_LayoutDepth		=BVS_SYSTEM+$0208+BTA_type_Plain
BVS_LayoutLeft		=BVS_SYSTEM+$0209+BTA_type_Plain
BVS_LayoutTop		=BVS_SYSTEM+$020A+BTA_type_Plain
BVS_LayoutRight		=BVS_SYSTEM+$020B+BTA_type_Plain
BVS_LayoutBottom	=BVS_SYSTEM+$020C+BTA_type_Plain
BVS_LayoutPlacement	=BVS_SYSTEM+$020D+BTA_type_Plain
LAYOUTPLACEMENT_D_bits	=	$FF000000
LAYOUTPLACEMENT_P_bits	=	$00000FFF		/* Position number */

BVS_LayoutFlags		=BVS_SYSTEM+$020E+BTA_type_Plain
LAYOUTFLAGS_OR_bits	=	$0F000000
LAYOUTFLAGS_bits	=	$F0000000

LAYOUTFLAGS_W_bits	=	$0000000F
LAYOUTFLAGS_W_FRAC	=	$00000001		/* FRAC = Fraction number */
LAYOUTFLAGS_W_PARENT	=	$00000002		/* PARENT = Taken value from the parent */
LAYOUTFLAGS_W_INTERN	=	$00000003		/* INTERN = The owner will take care of the values...automagically */
LAYOUTFLAGS_H_bits	=	$000000F0
LAYOUTFLAGS_H_FRAC	=	$00000010
LAYOUTFLAGS_H_PARENT	=	$00000020
LAYOUTFLAGS_H_INTERN	=	$00000030
LAYOUTFLAGS_L_bits	=	$00000F00
LAYOUTFLAGS_L_FRAC	=	$00000100
LAYOUTFLAGS_L_PARENT	=	$00000200
LAYOUTFLAGS_T_bits	=	$0000F000
LAYOUTFLAGS_T_FRAC	=	$00001000
LAYOUTFLAGS_T_PARENT	=	$00002000
LAYOUTFLAGS_R_bits	=	$000F0000
LAYOUTFLAGS_R_FRAC	=	$00010000
LAYOUTFLAGS_R_PARENT	=	$00020000
LAYOUTFLAGS_B_bits	=	$00F00000
LAYOUTFLAGS_B_FRAC	=	$00100000
LAYOUTFLAGS_B_PARENT	=	$00200000
LAYOUTFLAGS_OR_Horz	=	$01000000		/* The elements are horizontal oriented */
LAYOUTFLAGS_OR_Vert	=	$02000000
LAYOUTFLAGSF_RENDERED	=	$10000000

BVS_BorderWidth		=BVS_SYSTEM+$0210+BTA_type_Plain
BVS_TextWidth		=BVS_SYSTEM+$0211+BTA_type_Plain
BVS_TextHeight		=BVS_SYSTEM+$0212+BTA_type_Plain
BVS_MarginLeft		=BVS_SYSTEM+$0213+BTA_type_Plain
BVS_MarginTop		=BVS_SYSTEM+$0214+BTA_type_Plain
BVS_MarginRight		=BVS_SYSTEM+$0215+BTA_type_Plain
BVS_MarginBottom	=BVS_SYSTEM+$0216+BTA_type_Plain
BVS_ImageWidth		=BVS_SYSTEM+$0217+BTA_type_Plain
BVS_ImageHeight		=BVS_SYSTEM+$0218+BTA_type_Plain

BVS_2dPoint		=BVS_SYSTEM+$0300+BTA_type_Plain
BVS_2dLine		=BVS_SYSTEM+$0301+BTA_type_Plain
BVS_2dRectangle		=BVS_SYSTEM+$0302+BTA_type_Plain
BVS_2dText		=BVS_SYSTEM+$0303+BTA_type_Plain


;**********************************************
;**** Method Flags for the OBJ_DoMethod routine
;****
	BITDEF	MTH,DOCHILDREN,0
	BITDEF	MTH,DOPARENTS,1
	BITDEF	MTH,DISPOSED,2		;/* INTERNAL: Somewhere an object must be disposed */
	BITDEF	MTH,EVENTDISPOSE,3 	;/* INTERNAL: MUST be used in combination with the MTHF_DISPOSED
					;	   flag, now *also* the eventobject will be disposed. */
	BITDEF	MTH,PASSTOCHILD,4
	BITDEF	MTH,BREAKPASSTOCHILD,5

	BITDEF	MTH,ERROR,6
	BITDEF	MTH,FATALERROR,7
	BITDEF	MTH,BREAK,8

MTHF_B52_bits		=$0000F000	;/* Methodflags used by B52 */


;****** BeastConstants/BST_macros *******************************************
;*
;*	NAME
;*	  BST_macros -- (v0.1)
;*
;****************************************************************************

Macro_GetInstance	MACRO	;	Object, Instance
			move.l	OBJ_DataSection(\1),\2
			ENDM

OBJ_m_DoMethod	MACRO	; Object, MethodID, TagList, MethodFlags
		moveq		#\4,d3
		move.l		\1,a0
		move.l		#\2,d0
		move.l		\3,a1
		CALLBEAST	OBJ_DoMethod
		ENDM

		ENDC	;	BEAST_I
