OPT NATIVE
MODULE 'target/exec/types', 'target/exec/lists', 'target/exec/nodes', 'target/exec/libraries', 'target/libraries/iffparse', 'target/dos/dos'
MODULE 'target/utility/tagitem'
{#include <datatypes/datatypes.h>}
NATIVE {DATATYPES_DATATYPES_H} CONST


NATIVE {ID_DTYP} CONST ID_DTYP = "DTYP"
NATIVE {ID_DTHD} CONST ID_DTHD = "DTHD"


NATIVE {DataTypeHeader} OBJECT datatypeheader
    {dth_Name}	name	:/*STRPTR*/ ARRAY OF CHAR           /* Name of the data type */
    {dth_BaseName}	basename	:/*STRPTR*/ ARRAY OF CHAR       /* Base name of the data type */
    {dth_Pattern}	pattern	:/*STRPTR*/ ARRAY OF CHAR        /* File name match pattern */
    {dth_Mask}	mask	:PTR TO INT           /* Comparision mask (binary) */
    {dth_GroupID}	groupid	:ULONG        /* DataType Group */
    {dth_ID}	id	:ULONG             /* DataType ID (same as IFF FORM type) */
    {dth_MaskLen}	masklen	:INT        /* Length of the comparision mask */
    {dth_Pad}	pad	:INT            /* Unused at present (must be 0) */
    {dth_Flags}	flags	:UINT          /* Flags -- see below */
    {dth_Priority}	priority	:UINT
ENDOBJECT

NATIVE {DTHSIZE}       CONST ->DTHSIZE       = SIZEOF datatypeheader

/* Types */
NATIVE {DTF_TYPE_MASK}  CONST DTF_TYPE_MASK  = $000F
NATIVE {DTF_BINARY}     CONST DTF_BINARY     = $0000
NATIVE {DTF_ASCII}      CONST DTF_ASCII      = $0001
NATIVE {DTF_IFF}        CONST DTF_IFF        = $0002
NATIVE {DTF_MISC}       CONST DTF_MISC       = $0003

NATIVE {DTF_CASE}       CONST DTF_CASE       = $0010      /* Case is important */

NATIVE {DTF_SYSTEM1}    CONST DTF_SYSTEM1    = $1000      /* For system use only */


/*****   Group ID and ID   ************************************************/

/* System file -- executable, directory, library, font and so on. */
NATIVE {GID_SYSTEM}      CONST GID_SYSTEM      = "syst"
NATIVE {ID_BINARY}       CONST ID_BINARY       = "bina"
NATIVE {ID_EXECUTABLE}   CONST ID_EXECUTABLE   = "exec"
NATIVE {ID_DIRECTORY}    CONST ID_DIRECTORY    = "dire"
NATIVE {ID_IFF}          CONST ID_IFF          = "iff\0"

/* Text, formatted or not */
NATIVE {GID_TEXT}        CONST GID_TEXT        = "text"
NATIVE {ID_ASCII}        CONST ID_ASCII        = "asci"

/* Formatted text combined with graphics or other DataTypes */
NATIVE {GID_DOCUMENT}    CONST GID_DOCUMENT    = "docu"

/* Sound */
NATIVE {GID_SOUND}       CONST GID_SOUND       = "soun"

/* Musical instrument */
NATIVE {GID_INSTRUMENT}  CONST GID_INSTRUMENT  = "inst"

/* Musical score */
NATIVE {GID_MUSIC}       CONST GID_MUSIC       = "musi"

/* Picture */
NATIVE {GID_PICTURE}     CONST GID_PICTURE     = "pict"

/* Animated pictures */
NATIVE {GID_ANIMATION}   CONST GID_ANIMATION   = "anim"

/* Animation with audio */
NATIVE {GID_MOVIE}       CONST GID_MOVIE       = "movi"


/**************************************************************************/


NATIVE {ID_CODE}         CONST ID_CODE         = "DTCD"


NATIVE {DTHookContext} OBJECT dthookcontext
    {dthc_SysBase}	sysbase	:PTR TO lib
    {dthc_DOSBase}	dosbase	:PTR TO lib
    {dthc_IFFParseBase}	iffparsebase	:PTR TO lib
    {dthc_UtilityBase}	utilitybase	:PTR TO lib

    /* File context */
    {dthc_Lock}	lock	:BPTR
    {dthc_FIB}	fib	:PTR TO fileinfoblock
    {dthc_FileHandle}	filehandle	:BPTR   /* Pointer to file handle 
						(may be NULL) */
    {dthc_IFF}	iff	:PTR TO iffhandle          /* Pointer to IFFHandle 
						(may be NULL) */
    {dthc_Buffer}	buffer	:/*STRPTR*/ ARRAY OF CHAR       /* Buffer... */
    {dthc_BufferLength}	bufferlength	:ULONG /* ... and corresponding length */
ENDOBJECT


NATIVE {ID_TOOL} CONST ID_TOOL = "DTTL"

NATIVE {Tool} OBJECT tool
    {tn_Which}	which	:UINT
    {tn_Flags}	flags	:UINT           /* Flags -- see below */
    {tn_Program}	program	:/*STRPTR*/ ARRAY OF CHAR         /* Application to use */
ENDOBJECT


NATIVE {TW_MISC} CONST TW_MISC = 0
NATIVE {TW_INFO}	CONST TW_INFO = 1
NATIVE {TW_BROWSE}	CONST TW_BROWSE = 2
NATIVE {TW_EDIT}	CONST TW_EDIT = 3
NATIVE {TW_PRINT}	CONST TW_PRINT = 4
NATIVE {TW_MAIL}	CONST TW_MAIL = 5


NATIVE {TF_LAUNCH_MASK}       CONST TF_LAUNCH_MASK       = $000F
NATIVE {TF_SHELL}             CONST TF_SHELL             = $0001
NATIVE {TF_WORKBENCH}         CONST TF_WORKBENCH         = $0002
NATIVE {TF_RX}                CONST TF_RX                = $0003


/* Tags for use with FindToolNodeA(), GetToolAttrsA() and so on */

NATIVE {TOOLA_Dummy}          CONST TOOLA_DUMMY          = TAG_USER
NATIVE {TOOLA_Program}        CONST TOOLA_PROGRAM        = (TOOLA_DUMMY + 1)
NATIVE {TOOLA_Which}          CONST TOOLA_WHICH          = (TOOLA_DUMMY + 2)
NATIVE {TOOLA_LaunchType}     CONST TOOLA_LAUNCHTYPE     = (TOOLA_DUMMY + 3)


NATIVE {ID_TAGS}      CONST ID_TAGS      = "DTTG"


/*************************************************************************/


->#ifndef	DATATYPE
NATIVE {DATATYPE} CONST
NATIVE {DataType} OBJECT datatype
    {dtn_Node1}	node1	:ln         /* These two nodes are for... */
    {dtn_Node2}	node2	:ln         /* ...system use only! */
    {dtn_Header}	header	:PTR TO datatypeheader
    {dtn_ToolList}	toollist	:lh      /* Tool nodes */
    {dtn_FunctionName}	functionname	:/*STRPTR*/ ARRAY OF CHAR  /* Name of comparision routine */
    {dtn_AttrList}	attrlist	:ARRAY OF tagitem      /* Object creation tags */
    {dtn_Length}	length	:ULONG        /* Length of the memory block */
ENDOBJECT
->#endif

NATIVE {DTNSIZE}	CONST ->DTNSIZE	= SIZEOF datatype


NATIVE {ToolNode} OBJECT toolnode
    {tn_Node}	node	:ln
    {tn_Tool}	tool	:tool
    {tn_Length}	length	:ULONG  /* Length of the memory block */
ENDOBJECT

NATIVE {TNSIZE}  CONST ->TNSIZE  = SIZEOF toolnode


->#ifndef ID_NAME
NATIVE {ID_NAME}   CONST ID_NAME   = "NAME"
->#endif


/* Text ID:s */
NATIVE {DTERROR_UNKNOWN_DATATYPE}        CONST DTERROR_UNKNOWN_DATATYPE        = 2000
NATIVE {DTERROR_COULDNT_SAVE}            CONST DTERROR_COULDNT_SAVE            = 2001
NATIVE {DTERROR_COULDNT_OPEN}            CONST DTERROR_COULDNT_OPEN            = 2002
NATIVE {DTERROR_COULDNT_SEND_MESSAGE}    CONST DTERROR_COULDNT_SEND_MESSAGE    = 2003

/* new for V40 */
NATIVE {DTERROR_COULDNT_OPEN_CLIPBOARD}  CONST DTERROR_COULDNT_OPEN_CLIPBOARD  = 2004
NATIVE {DTERROR_Reserved}                CONST DTERROR_RESERVED                = 2005
NATIVE {DTERROR_UNKNOWN_COMPRESSION}     CONST DTERROR_UNKNOWN_COMPRESSION     = 2006
NATIVE {DTERROR_NOT_ENOUGH_DATA}         CONST DTERROR_NOT_ENOUGH_DATA         = 2007
NATIVE {DTERROR_INVALID_DATA}            CONST DTERROR_INVALID_DATA            = 2008

NATIVE {DTMSG_TYPE_OFFSET}               CONST DTMSG_TYPE_OFFSET               = 2100
