#ifndef BEAST_H
#define BEAST_H

/****h* Beast/Beast.h [0.1]
*
*	NAME
*	  Beast.h -- Beast types and constants
*
*	COPYRIGHT
*	  Maverick Software Development
*
*	FUNCTION
*
*	AUTHOR
*	  Jacco van Weert / Frans Slothouber
*	  GNU-C support by Jeroen Vermeulen
*
*	CREATION DATE
*	  3-May-95
*
*	MODIFICATION HISTORY
*
*	NOTES
*
******
*/

#include <exec/types.h>
#include <exec/lists.h>
#include <exec/nodes.h>

typedef unsigned long BST_Method  ;
typedef unsigned long BST_MethodFlags ;

#define	TAG_USER	0x80000000
#define	TAG_DONE	0x00000000

#ifdef __SAS__
#define rfcall(fn,p1,p2,p3) BST_MethodFlags __asm fn (register __d3 p1, register __a2 p2, register __a3 p3)
#endif

#ifdef _DCC
#define rfcall(fn,p1,p2,p3) BST_MethodFlags fn ( __D3 p1, __A2 p2, __A3 p3)
#endif

#ifdef __GNUC__
#define rfcall(fn,p1,p2,p3) BST_MethodFlags fn (void);                  \
               static inline BST_MethodFlags real_ ## fn (              \
               BST_MethodFlags     p1, ULONG *p2, ULONG *p3)

#define self_call(result,fn,p1,p2,p3) {                                 \
        register BST_MethodFlags  selfcall_ ## p1 asm("d3") = p1;    \
        register ULONG		 *selfcall_ ## p2 asm("a2") = p2;    \
        register ULONG		 *selfcall_ ## p3 asm("a3") = p3;    \
        result = fn ();                                                 \
      }
#endif /* GCC section */



/****** Beast.h/BST_Class [0.1]
*
*	NAME
*	  BST_Class -- a beast class
*
************************************
*/
struct BST_Class
{
  struct Node       bc_Node;
  ULONG             bc_Size;
  ULONG		    bc_Flags;
/*  struct MinList    bc_IntputPorts;
  struct MinList    bc_OutputPorts; */
  struct MinList    bc_Methods;
  ULONG		    bc_ObjectCount;
  struct Library   *bc_ExtClass;
  ULONG             bc_Userdata;  /* NOT USED --  */
};

	/**** The BSTC_Flags (bc_Flags) ****/
#define		CLASSB_B52CLASS		0
#define		CLASSF_B52CLASS		(1L<<0)


/****** Beast.h/class_MethodList [0.1]
*
*  NAME
*    class_MethodList -- list with methods
*
*****************************************
*/
struct class_MethodList
{
  struct MinNode  cml_Node ;
  BST_Method      cml_MethodID ;
  struct MinList *cml_HookList ;
};


/****** Beast.h/BST_Object [0.1]
*
*  NAME
*    BST_Object -- a standard object
*
************************************
*/
struct BST_Object
{
  struct MinNode     obj_Node;
  APTR		     obj_DataSection;
  struct MinList     obj_InputList;
  struct MinList     obj_OutputList;
  struct BST_Class  *obj_Class;
  struct BST_Object *obj_Parent;
  struct MinList     obj_Childs;
  ULONG		     obj_Flags;
};


/****** Beast.h/obj_InputLink [0.1]
*
*  NAME
*    obj_InputLink --
*
***********************************
*/
struct obj_InputLink
{
  struct MinNode          oil_Node ;
  struct BST_Object      *oil_Object ;
  struct obj_OutputLink  *oil_FromMethodOOL ;
  BST_Method              oil_InputMethod ;
} ;

/****** Beast.h/obj_OutputLink [0.1]
*
*  NAME
*    obj_OutputLink --
*
*************************************
*/
struct obj_OutputLink
{
  struct MinNode         ool_Node ;
  struct BST_Object     *ool_Object ;
  struct obj_InputLink  *ool_ToMethodOIL ;
  BST_Method             ool_OutputMethod ;
} ;




/****** Beast.h/BST_base [0.1]
*
*  NAME
*    BST_base --
*
******
*/

struct BST_base
{
  struct BST_Object  bb_Base ;
  struct MinList     bb_DefinedClasses ;
} ;





/********************************
 ****			     ****
 **** BEAST Standard methods ****
 ****			     ****
 ********************************/

#define	OBM_bits_FUNCTION 0xF0000000
#define	OBM_type_None	  0x00000000

#define	OBM_bits_FAMILY	  0x0F000000
#define	OBM_type_Plain	  0x00000000
#define	OBM_type_System	  0x01000000
#define	OBM_type_General  0x02000000
#define	OBM_type_B52	  0x03000000
#define	OBM_type_BeaVis	  0x04000000
#define	OBM_type_BFS	  0x05000000
#define	OBM_type_BeaMM	  0x06000000
#define	OBM_type_BEASTAR  0x07000000

	/**** Numbers   0x0000040 - 0x000007f Free */
#define OBM_local0	0x0000040
	/**** Numbers   0x0000100 - 0x00007ff Free */
#define OBM_local1	0x0000100
	/**** Numbers 	0x0004000 - 0x0004fff Free */
#define OBM_local2	0x0004000
	/**** Numbers   0x0100000 - 0x01fffff Free */
#define	OBM_local3	0x0100000


#define OBM_INPUT       0x0000080
#define OBM_OUTPUT      0x0000081
#define OBM_INPUT2      0x0000082
#define OBM_OUTPUT2     0x0000083
#define OBM_INPUT3      0x0000084
#define OBM_OUTPUT3     0x0000085
#define OBM_INPUT4      0x0000086
#define OBM_OUTPUT4     0x0000087
#define OBM_SYSINPUT    0x0000088
#define OBM_SYSOUTPUT   0x0000089
#define OBM_IDCMPINPUT	0x000008A
#define OBM_IDCMPOUTPUT	0x000008B
#define OBM_BVSINPUT	0x000008C
#define OBM_BVSOUTPUT	0x000008D
#define OBM_BEAMMINPUT  0x000008E
#define OBM_BEAMMOUTPUT	0x000008F
#define OBM_BFSINPUT	0x0000090
#define	OBM_BFSOUTPUT	0x0000091

#define	OBM_CONTENTSINPUT  0x0000092
/**** BTA_Flags for the OBM_CONTENTSINPUT method ****/
#define		CONTENTSINPUT_FIXED		1
#define		CONTENTSINPUT_END		5

#define OBM_CONTENTSOUTPUT 0x0000093
/**** BTA_Flags for the OBM_CONTENTSOUTPUT method ****/
#define		CONTENTSOUTPUT_FULL		0
#define		CONTENTSOUTPUT_FIXED		1
#define		CONTENTSOUTPUT_UNTILBYTE	2
#define		CONTENTSOUTPUT_UNTILWORD	3
#define		CONTENTSOUTPUT_UNTILLONG	4
#define		CONTENTSOUTPUT_END		5

#define	OBM_ALLOCMEM	0x0000100
#define	OBM_FREEMEM	0x0000101
#define	OBM_LOCKMEM	0x0000102
#define	OBM_UNLOCKMEM	0x0000103


#define OBM_GETATTR     0x0001000
#define OBM_SETATTR     0x0001001

#define	OBM_UPDATE	0x0001100

#define OBM_INIT        0x0040000
#define OBM_DISPOSE     0x0040001
#define OBM_DOWNFALL	0x0040002

#define	OBM_DUPLICATE	0x0050000
#define	OBM_COPY	0x0050001
#define	OBM_MOVE	0x0050002
/**** BTA_Flags for the OBM_MOVE method ****/
#define		MOVEB_START	0
#define		MOVEF_START	(1L<<0)
#define		MOVEB_END	1
#define		MOVEF_END	(1L<<1)
#define		MOVEB_DRAG	2
#define		MOVEF_DRAG	(1L<<2)

#define	OBM_SIZE	0x0050003
#define	OBM_INSERT	0x0050004
#define	OBM_ADDHEAD	0x0050005
#define	OBM_ADDTAIL	0x0050006
#define	OBM_REMOVE	0x0050007
#define	OBM_REMHEAD	0x0050008
#define	OBM_REMTAIL	0x0050009


/*********************************
 **** Beast System classes methods
 ****/
#define	OBM_GETEACH	0x0000000|OBM_type_System
#define	OBM_FOREACH	0x0000001|OBM_type_System

#define	OBM_EVENTLOOP	0x0001000|OBM_type_System
#define	OBM_ADDEVENT	0x0001001|OBM_type_System
#define	OBM_REMEVENT	0x0001002|OBM_type_System



/**********************************
 **** Beast General classes methods
 ****/
#define	OBM_SEARCHOBJECT	0x0000000|OBM_type_General
/**** BTA_Flags for the OBM_SEARCHOBJECT method ****/
#define		SEARCHOBJECTMODE_bits		0x0000000F
#define		SEARCHOBJECTMODEB_ONELEVEL	0
#define		SEARCHOBJECTMODEF_ONELEVEL	(1L<<0)
#define		SEARCHOBJECTMODEB_ALLCHILDREN	1
#define		SEARCHOBJECTMODEF_ALLCHILDREN	(1L<<1)


#define	OBM_reply_SEARCHOBJECT	0x0000001|OBM_type_General


/***************************
 **** BeaVis classes methods
 ****/
#define	OBM_DRAW		0x0000000|OBM_type_BeaVis
#define	OBM_ENTEROBJECT		0x0000001|OBM_type_BeaVis
#define	OBM_LEAVEOBJECT		0x0000002|OBM_type_BeaVis
#define	OBM_OBJECTDOWN		0x0000003|OBM_type_BeaVis
#define	OBM_OBJECTUP		0x0000004|OBM_type_BeaVis
#define OBM_CLOSEOBJECT		0x0000005|OBM_type_BeaVis

#define	OBM_DOLAYOUT		0x0000100|OBM_type_BeaVis
#define	OBM_ASKLAYOUT		0x0000101|OBM_type_BeaVis
#define	OBM_REPLYLAYOUT		0x0000102|OBM_type_BeaVis
#define	OBM__GETLAYOUTreply	0x0000103|OBM_type_BeaVis

#define OBM_SIZE_TOPLEFT	0x0000200|OBM_type_BeaVis
#define	OBM_SIZE_TOPRIGHT	0x0000201|OBM_type_BeaVis
#define	OBM_SIZE_DOWNRIGHT	0x0000202|OBM_type_BeaVis
#define	OBM_SIZE_DOWNLEFT	0x0000203|OBM_type_BeaVis
/**** BTA_Flags for the OBM_SIZE_xx methods ****/
#define		SIZEB_START	0
#define		SIZEF_START	(1L<<0)
#define		SIZEB_END	1
#define		SIZEF_END	(1L<<1)


/************************
 **** BFS classes methods
 ****/
#define OBM_LOCKFILE		0x0000000|OBM_type_BFS
#define	OBM_READFILE		0x0000001|OBM_type_BFS

/***********************************
 ****			     	****
 **** BEAST Standard Attributes ****
 ****			     	****
 ***********************************/

#define BST_bits_System	0x7F000000
#define BST_TAG (TAG_USER+0x40000000)

#define BTB_Ignore		29
#define BTF_Ignore		(1L<<29)
#define	BTB_Attributes		28
#define BTF_Attributes		(1L<<28)
#define BTB_UserTag		27
#define BTF_UserTag		(1L<<27)

#define	BST_bits_Types		0x00F00000
#define	BTA_type_Plain		0x00000000
#define	BTA_type_CString	0x00100000
#define	BTA_type_Object		0x00200000
#define	BTA_type_Pointer	0x00300000
#define	BTA_type_TagList	0x00400000
#define	BTA_type_Flags		0x00500000
#define	BTA_type_Tag		0x00600000
#define	BTA_type_Filename	0x00700000

#define	BST_bits_Family		0x000F0000
#define	BTA_type_System		0x00000000
#define	BTA_type_General	0x00010000
#define	BTA_type_B52		0x00020000
#define	BTA_type_BeaVis		0x00030000
#define	BTA_type_BFS		0x00040000
#define	BTA_type_BeaMM		0x00050000
#define	BTA_type_BEASTAR	0x00060000


/************
 **** Control
 ****/
#define BTA_CONTROL		BST_TAG|BTF_Attributes|0x000
#define	BTA_NumberOf		BTA_CONTROL+0x01

/*************
 **** Position
 ****/
#define BTA_POSITION		BST_TAG|BTF_Attributes|0x100
#define	BTA_X			BTA_POSITION+0x00|BTA_type_Plain
#define	BTA_Y			BTA_POSITION+0x01|BTA_type_Plain
#define	BTA_Width		BTA_POSITION+0x02|BTA_type_Plain
#define BTA_Height		BTA_POSITION+0x03|BTA_type_Plain
#define	BTA_Size		BTA_POSITION+0x04|BTA_type_Plain
#define	BTA_InnerX		BTA_POSITION+0x05|BTA_type_Plain
#define	BTA_InnerY		BTA_POSITION+0x06|BTA_type_Plain
#define	BTA_InnerWidth		BTA_POSITION+0x07|BTA_type_Plain
#define BTA_InnerHeight		BTA_POSITION+0x08|BTA_type_Plain


/**********
 **** Types
 ****/
#define	BTA_TYPES		BST_TAG|BTF_Attributes|0x200
#define BTA_LongNumber		BTA_TYPES+0x00|BTA_type_Plain
#define	BTA_Flags		BTA_TYPES+0x01|BTA_type_Plain

#define	BTA_Pointer		BTA_TYPES+0x0A|BTA_type_Pointer
#define	BTA_ByteNumber		BTA_TYPES+0x0B|BTA_type_Plain
#define	BTA_WordNumber		BTA_TYPES+0x0C|BTA_type_Plain
#define	BTA_FFPNumber		BTA_TYPES+0x0D|BTA_type_Plain

/***************
 **** Identifier
 ****/
#define	BTA_IDENTIFIER		BST_TAG|BTF_Attributes|0x300
#define	BTA_Title		BTA_IDENTIFIER+0x00|BTA_type_CString
#define	BTA_MainObject		BTA_IDENTIFIER+0x01|BTA_type_Object
#define	BTA_Object1		BTA_IDENTIFIER+0x02|BTA_type_Object
#define	BTA_Object2		BTA_IDENTIFIER+0x03|BTA_type_Object
#define	BTA_Object3		BTA_IDENTIFIER+0x04|BTA_type_Object
#define	BTA_Object4		BTA_IDENTIFIER+0x05|BTA_type_Object
#define	BTA_Object5		BTA_IDENTIFIER+0x06|BTA_type_Object
#define	BTA_Object6		BTA_IDENTIFIER+0x07|BTA_type_Object
#define	BTA_Object7		BTA_IDENTIFIER+0x08|BTA_type_Object
#define	BTA_Object8		BTA_IDENTIFIER+0x09|BTA_type_Object
#define	BTA_Object9		BTA_IDENTIFIER+0x0A|BTA_type_Object
#define	BTA_Method		BTA_IDENTIFIER+0x0B|BTA_type_Plain
#define	BTA_TagList		BTA_IDENTIFIER+0x0C|BTA_type_TagList
#define	BTA_ClassName		BTA_IDENTIFIER+0x0D|BTA_type_CString
#define	BTA_FromObject		BTA_IDENTIFIER+0x0E|BTA_type_Object
#define	BTA_ToObject		BTA_IDENTIFIER+0x0F|BTA_type_Object


/***********
 **** System
 ****/
#define	BTA_SYSTEM		BST_TAG|BTF_Attributes|0x400
#define	BTA_MemBlock		BTA_SYSTEM+0x00|BTA_type_Pointer
#define	BTA_MemHandle		BTA_SYSTEM+0x01|BTA_type_Pointer
#define	BTA_MemFlags		BTA_SYSTEM+0x02|BTA_type_Plain
#define		MEMB_MOVEABLE_DISK	24
#define		MEMF_MOVEABLE_DISK	(1L<<24)
#define		MEMB_MOVEABLE_MEMORY	25
#define		MEMF_MOVEABLE_MEMORY	(1L<<25)
#define		MEMB_DISCARDABLE	26
#define		MEMF_DISCARDABLE	(1L<<26)
#define	BTA_MemSize		BTA_SYSTEM+0x03|BTA_type_Plain
#define	BTA_Signals		BTA_SYSTEM+0x04|BTA_type_Flags
#define	BTA_Signals_AND		BTA_SYSTEM+0x05|BTA_type_Flags
#define	BTA_Signals_OR		BTA_SYSTEM+0x06|BTA_type_Flags
#define	BTA_Signals_XOR		BTA_SYSTEM+0x07|BTA_type_Flags
#define	BTA_MsgPort		BTA_SYSTEM+0x08|BTA_type_Pointer
#define	BTA_Message		BTA_SYSTEM+0x09|BTA_type_Pointer

/********************************************
 **** BEAST GENERAL CLASS TAG and definitions
 ****/
#define	BTA_GENERAL		BST_TAG|BTF_Attributes|BTA_type_General
#define	BTA_TagListObject	BTA_GENERAL+0x0000|BTA_type_Object
#define	BTA_TagListSize		BTA_GENERAL+0x0001|BTA_type_Plain

/**** BTA_Flags for the OBM_SIZE of BST_MemoryClass */
#define		MEMSIZEB_RETAIN		0
#define		MEMSIZEF_RETAIN		(1L<<0)



/****************************************
 **** BEAST BFS CLASS TAG and definitions
 ****/
#define	BFS_FILESYSTEM		BST_TAG|BTF_Attributes|BTA_type_BFS
#define	BFS_UserName		BFS_FILESYSTEM+0x0000|BTA_type_CString
#define	BFS_UserPassword	BFS_FILESYSTEM+0x0001|BTA_type_CString
#define	BFS_SystemName		BFS_FILESYSTEM+0x0002|BTA_type_CString
#define	BFS_MountName		BFS_FILESYSTEM+0x0003|BTA_type_CString
#define	BFS_LockName		BFS_FILESYSTEM+0x0004|BTA_type_CString
#define	BFS_LockObject		BFS_FILESYSTEM+0x0005|BTA_type_Object
#define	BFS_LockFlags		BFS_FILESYSTEM+0x0006|BTA_type_Flags
#define		LOCKMODE_bits		0x0000000F
#define		LOCKMODEB_READ		0
#define		LOCKMODEF_READ		(1L<<0)
#define		LOCKMODEB_WRITE		1
#define		LOCKMODEF_WRITE		(1L<<1)
#define		LOCKMODEB_NEW		2
#define		LOCKMODEF_NEW		(1L<<2)

/************************************************
 **** BEAST VISUAL (BeaVis) TAG's and definitions
 ****/
#define	BVS_SYSTEM		BST_TAG|BTF_Attributes|BTA_type_BeaVis
#define	BVS_BorderType		BVS_SYSTEM+0x0000|BTA_type_Plain
#define		BORDERTYPE_NONE		0
#define		BORDERTYPE_LINE		1
#define		BORDERTYPE_BUTTON	2
#define		BORDERTYPE_STRING	3
#define		BORDERTYPE_XEN		4
#define	BVS_ColorScheme		BVS_SYSTEM+0x0001|BTA_type_Plain
#define		COLORSCHEME_NORMAL	0
#define		COLORSCHEME_PRESSED	1
#define	BVS_RenderMode		BVS_SYSTEM+0x0002|BTA_type_Plain
#define		RENDERMODE_NONE		0
#define		RENDERMODE_LIGHT	1
#define		RENDERMODE_MEDIUM	2
#define		RENDERMODE_HEAVY	3
#define		RENDERMODE_FULL		4
#define	BVS_IRastport		BVS_SYSTEM+0x0003|BTA_type_Pointer
#define	BVS_RectGadgetFlags	BVS_SYSTEM+0x0004|BTA_type_Flags
#define		RECTGADGETB_ADDED	0
#define		RECTGADGETF_ADDED	(1L<<0)
#define		RECTGADGETB_PRESSED	1
#define		RECTGADGETF_PRESSED	(1L<<1)
#define		RECTGADGETB_ENTERED	2
#define		RECTGADGETF_ENTERED	(1L<<2)
#define		RECTGADGETB_RENDERED	3
#define		RECTGADGETF_RENDERED	(1L<<3)
#define	BVS_TextFlags		BVS_SYSTEM+0x0005|BTA_type_Flags
#define		TEXTTYPE_bits		0x0000000F
#define		TEXTTYPEB_NORMAL	0
#define		TEXTTYPEF_NORMAL	(1L<<0)
#define		TEXTTYPEB_BOLD		1
#define		TEXTTYPEF_BOLD		(1L<<1)
#define		TEXTTYPEB_ITALIC	2
#define		TEXTTYPEF_ITALIC	(1L<<2)
#define		TEXTTYPEB_WIDE		3
#define		TEXTTYPEF_WIDE		(1L<<3)
#define		TEXTTYPEB_UNDERLINED	4
#define		TEXTTYPEF_UNDERLINED	(1L<<4)
#define		TEXTJUST_bits		0x000000F0
#define		TEXTJUSTB_LEFT		8
#define		TEXTJUSTF_LEFT		(1L<<8)
#define		TEXTJUSTB_RIGHT		9
#define		TEXTJUSTF_RIGHT		(1L<<9)
#define		TEXTJUST_CENTER_H	TEXTJUSTF_LEFT+TEXTJUSTF_RIGHT
#define		TEXTJUSTB_TOP		10
#define		TEXTJUSTF_TOP		(1L<<10)
#define		TEXTJUSTB_BOTTOM	11
#define		TEXTJUSTF_BOTTOM	(1L<<11)
#define		TEXTJUST_CENTER_V	TEXTJUSTF_TOP+TEXTJUSTF_BOTTOM
#define	BVS_TextTitle		BVS_SYSTEM+0x0006|BTA_type_CString
#define BVS_ImageFlags		BVS_SYSTEM+0x0007|BTA_type_Flags
#define		IMAGEFILL_bits		0x0000F000
#define		IMAGEFILL_NONE		0x00000000
#define		IMAGEFILL_SOLID		0x00001000
#define		IMAGEFILL_CHECKERED	0x00002000
#define		IMAGEFILL_LIGHTCHECK	0x00003000
#define		IMAGEPICT_bits		0x00F00000
#define		IMAGEPICT_NONE		0x00000000
#define		IMAGEPICT_ONCE		0x00100000
#define		IMAGEPICT_ALL		0x00200000
#define	BVS_ObjectType		BVS_SYSTEM+0x0008|BTA_type_Flags
#define		OBJECTTYPEFAMILY_bits			0x000000FF
#define		OBJECTTYPEFAMILY_default		0x00000000
#define		OBJECTTYPEFAMILY_TEXTBUTTON		0x00000001
#define		OBJECTTYPEFAMILY_WINDOWLAYOUT		0x00000002
#define		OBJECTTYPEFAMILY_DRAGBARLAYOUT		0x00000003
#define		OBJECTTYPEFAMILY_WINDOWCONTENTSLAYOUT	0x00000004
#define		OBJECTTYPEFAMILY_DRAGBARBUTTON		0x00000005
#define		OBJECTTYPEFAMILY_LAYOUT			0x00000006
#define		OBJECTTYPEFAMILY_STRINGGADGET		0x00000007
#define		OBJECTTYPEFAMILY_LABEL1			0x00000008
#define		OBJECTTYPEFAMILY_LABEL2			0x00000009
#define		OBJECTTYPEFAMILY_LABEL3			0x0000000A
#define		OBJECTTYPEFAMILY_LABEL4			0x0000000B
#define		OBJECTTYPEFAMILY_WINDOWSTATUSBAR	0x0000000C
#define		OBJECTTYPEFAMILY_IMAGEBUTTON		0x0000000D
#define	BVS_LayoutType		BVS_SYSTEM+0x0009|BTA_type_Flags	/**** The same as BVS_ObjectType ****/
#define	BVS_PositionType	BVS_SYSTEM+0x000A|BTA_type_Flags	/**** The same as BVS_ObjectType ****/
#define	BVS_IWindow		BVS_SYSTEM+0x000B|BTA_type_Pointer
#define	BVS_ImageTitle		BVS_SYSTEM+0x000C|BTA_type_Filename
#define	BVS_WindowTitle		BVS_SYSTEM+0x000D|BTA_type_CString
#define	BVS_FontAttr		BVS_SYSTEM+0x000E|BTA_type_Pointer
#define	BVS_FontHeight		BVS_SYSTEM+0x000F|BTA_type_Plain
#define	BVS_FontStyle		BVS_SYSTEM+0x0010|BTA_type_Plain
#define	BVS_FontFlags		BVS_SYSTEM+0x0011|BTA_type_Flags
#define	BVS_FontName		BVS_SYSTEM+0x0012|BTA_type_CString


#define	BVS_ForegroundColor 	BVS_SYSTEM+0x0104|BTA_type_Plain
#define	BVS_BackgroundColor 	BVS_SYSTEM+0x0105|BTA_type_Plain
#define	BVS_OutlineColor 	BVS_SYSTEM+0x0106|BTA_type_Plain
#define BVS_Shine100Color	BVS_SYSTEM+0x0107|BTA_type_Plain
#define BVS_Shine75Color	BVS_SYSTEM+0x0108|BTA_type_Plain
#define BVS_Shine50Color	BVS_SYSTEM+0x0109|BTA_type_Plain
#define BVS_Shine25Color	BVS_SYSTEM+0x010A|BTA_type_Plain
#define BVS_Shadow100Color	BVS_SYSTEM+0x010B|BTA_type_Plain
#define BVS_Shadow75Color	BVS_SYSTEM+0x010C|BTA_type_Plain
#define BVS_Shadow50Color	BVS_SYSTEM+0x010D|BTA_type_Plain
#define BVS_Shadow25Color	BVS_SYSTEM+0x010E|BTA_type_Plain
#define BVS_Fill100Color	BVS_SYSTEM+0x010F|BTA_type_Plain
#define BVS_Fill75Color		BVS_SYSTEM+0x0110|BTA_type_Plain
#define BVS_Fill50Color		BVS_SYSTEM+0x0111|BTA_type_Plain
#define BVS_Fill25Color		BVS_SYSTEM+0x0112|BTA_type_Plain
#define BVS_Mark100Color	BVS_SYSTEM+0x0113|BTA_type_Plain
#define BVS_Mark75Color		BVS_SYSTEM+0x0114|BTA_type_Plain
#define BVS_Mark50Color		BVS_SYSTEM+0x0115|BTA_type_Plain
#define BVS_Mark25Color		BVS_SYSTEM+0x0116|BTA_type_Plain
#define	BVS_Back100Color	BVS_SYSTEM+0x0117|BTA_type_Plain
#define BVS_Back75Color		BVS_SYSTEM+0x0118|BTA_type_Plain
#define	BVS_Back50Color		BVS_SYSTEM+0x0119|BTA_type_Plain
#define BVS_Back25Color		BVS_SYSTEM+0x011A|BTA_type_Plain
#define	BVS_TextColor		BVS_SYSTEM+0x011B|BTA_type_Plain
#define	BVS_ImageForeColor	BVS_SYSTEM+0x011C|BTA_type_Plain
#define BVS_ImageBackColor	BVS_SYSTEM+0x011D|BTA_type_Plain

#define	BVS_X1			BVS_SYSTEM+0x0200|BTA_type_Plain
#define	BVS_Y1			BVS_SYSTEM+0x0201|BTA_type_Plain
#define	BVS_Z1			BVS_SYSTEM+0x0202|BTA_type_Plain
#define	BVS_X2			BVS_SYSTEM+0x0203|BTA_type_Plain
#define	BVS_Y2			BVS_SYSTEM+0x0204|BTA_type_Plain
#define	BVS_Z2			BVS_SYSTEM+0x0205|BTA_type_Plain
#define BVS_LayoutWidth		BVS_SYSTEM+0x0206|BTA_type_Plain
#define	BVS_LayoutHeight	BVS_SYSTEM+0x0207|BTA_type_Plain
#define BVS_LayoutDepth		BVS_SYSTEM+0x0208|BTA_type_Plain
#define BVS_LayoutLeft		BVS_SYSTEM+0x0209|BTA_type_Plain
#define	BVS_LayoutTop		BVS_SYSTEM+0x020A|BTA_type_Plain
#define	BVS_LayoutRight		BVS_SYSTEM+0x020B|BTA_type_Plain
#define BVS_LayoutBottom	BVS_SYSTEM+0x020C|BTA_type_Plain
#define	BVS_LayoutPlacement	BVS_SYSTEM+0x020D|BTA_type_Plain
#define		LAYOUTPLACEMENT_D_bits	0xFF000000
#define		LAYOUTPLACEMENT_P_bits	0x00000FFF		/* Position number */
#define BVS_LayoutFlags		BVS_SYSTEM+0x020E|BTA_type_Plain
#define		LAYOUTFLAGS_W_bits	0x0000000F
#define		LAYOUTFLAGS_H_bits	0x000000F0
#define		LAYOUTFLAGS_L_bits	0x00000F00
#define		LAYOUTFLAGS_T_bits	0x0000F000
#define		LAYOUTFLAGS_R_bits	0x000F0000
#define		LAYOUTFLAGS_B_bits	0x00F00000
#define		LAYOUTFLAGS_OR_bits	0x0F000000
#define		LAYOUTFLAGS_bits	0xF0000000

#define		LAYOUTFLAGS_W_bits	0x0000000F
#define		LAYOUTFLAGS_W_FRAC	0x00000001		/* FRAC = Fraction number */
#define		LAYOUTFLAGS_W_PARENT	0x00000002		/* PARENT = Taken value from the parent */
#define		LAYOUTFLAGS_W_INTERN	0x00000003		/* INTERN = The owner will take care of the values...automagically */
#define		LAYOUTFLAGS_H_bits	0x000000F0
#define		LAYOUTFLAGS_H_FRAC	0x00000010
#define		LAYOUTFLAGS_H_PARENT	0x00000020
#define		LAYOUTFLAGS_H_INTERN	0x00000030
#define		LAYOUTFLAGS_L_bits	0x00000F00
#define		LAYOUTFLAGS_L_FRAC	0x00000100
#define		LAYOUTFLAGS_L_PARENT	0x00000200
#define		LAYOUTFLAGS_T_bits	0x0000F000
#define		LAYOUTFLAGS_T_FRAC	0x00001000
#define		LAYOUTFLAGS_T_PARENT	0x00002000
#define		LAYOUTFLAGS_R_bits	0x000F0000
#define		LAYOUTFLAGS_R_FRAC	0x00010000
#define		LAYOUTFLAGS_R_PARENT	0x00020000
#define		LAYOUTFLAGS_B_bits	0x00F00000
#define		LAYOUTFLAGS_B_FRAC	0x00100000
#define		LAYOUTFLAGS_B_PARENT	0x00200000
#define		LAYOUTFLAGS_OR_Horz	0x01000000		/* The elements are horizontal oriented */
#define		LAYOUTFLAGS_OR_Vert	0x02000000
#define		LAYOUTFLAGSF_RENDERED	0x10000000

#define	BVS_BorderWidth		BVS_SYSTEM+0x0210|BTA_type_Plain
#define	BVS_TextWidth		BVS_SYSTEM+0x0211|BTA_type_Plain
#define	BVS_TextHeight		BVS_SYSTEM+0x0212|BTA_type_Plain
#define	BVS_MarginLeft		BVS_SYSTEM+0x0213|BTA_type_Plain
#define	BVS_MarginTop		BVS_SYSTEM+0x0214|BTA_type_Plain
#define	BVS_MarginRight		BVS_SYSTEM+0x0215|BTA_type_Plain
#define	BVS_MarginBottom	BVS_SYSTEM+0x0216|BTA_type_Plain
#define BVS_ImageWidth		BVS_SYSTEM+0x0217|BTA_type_Plain
#define	BVS_ImageHeight		BVS_SYSTEM+0x0218|BTA_type_Plain

#define	BVS_2dPoint		BVS_SYSTEM+0x0300|BTA_type_Plain
#define	BVS_2dLine		BVS_SYSTEM+0x0301|BTA_type_Plain
#define	BVS_2dRectangle		BVS_SYSTEM+0x0302|BTA_type_Plain
#define BVS_2dText		BVS_SYSTEM+0x0303|BTA_type_Plain


/**********************************************
 **** Method Flags for the OBJ_DoMethod routine
 ****/

#define MTHF_DOCHILDREN		0x00000001
#define MTHF_DOPARENTS		0x00000002
#define MTHF_DISPOSED     	0x00000004	/* INTERNAL: Somewhere an object must be disposed */
#define MTHF_EVENTDISPOSE	0x00000008 	/* INTERNAL: MUST be used in combination with the MTHF_DISPOSED
						   flag, now *also* the eventobject will be disposed. */
#define MTHF_PASSTOCHILD	0x00000010
#define MTHF_BREAKPASSTOCHILD	0x00000020	/* No more delegation through any children. */

#define	MTHF_ERROR	  	0x00000040
#define MTHF_FATALERROR		0x00000080
#define MTHF_BREAK		0x00000100

#define	MTHF_B52_bits		0x0000F000	/* Methodflags used by B52 */

/*****************
 **** Beast macros
 ****/
#define eq ==
#define Macro_GetInstance Object->obj_DataSection;
#define Macro_SetAttr( Structure, Attribute ) case Attribute: Structure = cur_ti->ti_Data; break;
#define Macro_GetAttr( Structure, Attribute ) case Attribute: cur_ti->ti_Data = Structure; break;

#endif	 /* BEAST_BEAST_H */
