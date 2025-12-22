/* $VER: datatypes.h 39.6 (22.4.1993) */
OPT NATIVE
PUBLIC MODULE 'target/libraries/iff_shared4'
MODULE 'target/exec/types', 'target/exec/lists', 'target/exec/nodes', 'target/exec/libraries', 'target/libraries/iffparse', 'target/dos/dos'
MODULE 'target/utility/tagitem'
{MODULE 'datatypes/datatypes'}

NATIVE {ID_DTYP} CONST ID_DTYP = "DTYP"

/*****************************************************************************/

NATIVE {ID_DTHD} CONST ID_DTHD = "DTHD"

NATIVE {datatypeheader} OBJECT datatypeheader
    {name}	name	:/*STRPTR*/ ARRAY OF CHAR				/* Descriptive name of the data type */
    {basename}	basename	:/*STRPTR*/ ARRAY OF CHAR				/* Base name of the data type */
    {pattern}	pattern	:/*STRPTR*/ ARRAY OF CHAR				/* Match pattern for file name. */
    {mask}	mask	:PTR TO INT				/* Comparision mask */
    {groupid}	groupid	:ULONG				/* Group that the DataType is in */
    {id}	id	:ULONG				/* ID for DataType (same as IFF FORM type) */
    {masklen}	masklen	:INT				/* Length of comparision mask */
    {pad}	pad	:INT				/* Unused at present (must be 0) */
    {flags}	flags	:UINT				/* Flags */
    {priority}	priority	:UINT				/* Priority */
ENDOBJECT

NATIVE {DTHSIZE}	CONST DTHSIZE	= $20	->SIZEOF datatypeheader

/*****************************************************************************/

/* Basic type */
NATIVE {DTF_TYPE_MASK}	CONST DTF_TYPE_MASK	= $000F
NATIVE {DTF_BINARY}	CONST DTF_BINARY	= $0000
NATIVE {DTF_ASCII}	CONST DTF_ASCII	= $0001
NATIVE {DTF_IFF}		CONST DTF_IFF		= $0002
NATIVE {DTF_MISC}	CONST DTF_MISC	= $0003

/* Set if case is important */
NATIVE {DTF_CASE}	CONST DTF_CASE	= $0010

/* Reserved for system use */
NATIVE {DTF_SYSTEM1}	CONST DTF_SYSTEM1	= $1000

/*****************************************************************************
 *
 * GROUP ID and ID
 *
 * This is used for filtering out objects that you don't want.	For
 * example, you could make a filter for the ASL file requester so
 * that it only showed the files that were pictures, or even to
 * narrow it down to only show files that were ILBM pictures.
 *
 * Note that the Group ID's are in lower case, and always the first
 * four characters of the word.
 *
 * For ID's; If it is an IFF file, then the ID is the same as the
 * FORM type.  If it isn't an IFF file, then the ID would be the
 * first four characters of name for the file type.
 *
 *****************************************************************************/

/* System file, such as; directory, executable, library, device, font, etc. */
NATIVE {GID_SYSTEM}	CONST GID_SYSTEM	= "syst"

/* Formatted or unformatted text */
NATIVE {GID_TEXT}	CONST GID_TEXT	= "text"

/* Formatted text with graphics or other DataTypes */
NATIVE {GID_DOCUMENT}	CONST GID_DOCUMENT	= "docu"

/* Sound */
NATIVE {GID_SOUND}	CONST GID_SOUND	= "soun"

/* Musical instruments used for musical scores */
NATIVE {GID_INSTRUMENT}	CONST GID_INSTRUMENT	= "inst"

/* Musical score */
NATIVE {GID_MUSIC}	CONST GID_MUSIC	= "musi"

/* Still picture */
NATIVE {GID_PICTURE}	CONST GID_PICTURE	= "pict"

/* Animated picture */
NATIVE {GID_ANIMATION}	CONST GID_ANIMATION	= "anim"

/* Animation with audio track */
NATIVE {GID_MOVIE}	CONST GID_MOVIE	= "movi"

/*****************************************************************************/

/* A code chunk contains an embedded executable that can be loaded
 * with InternalLoadSeg. */
NATIVE {ID_CODE} CONST ID_CODE = "DTCD"

/* DataTypes comparision hook context (Read-Only).  This is the
 * argument that is passed to a custom comparision routine. */
NATIVE {dthookcontext} OBJECT dthookcontext
    /* Libraries that are already opened for your use */
    {sysbase}	sysbase	:PTR TO lib
    {dosbase}	dosbase	:PTR TO lib
    {iffparsebase}	iffparsebase	:PTR TO lib
    {utilitybase}	utilitybase	:PTR TO lib

    /* File context */
    {lock}	lock	:BPTR		/* Lock on the file */
    {fib}	fib	:PTR TO fileinfoblock		/* Pointer to a FileInfoBlock */
    {filehandle}	filehandle	:BPTR	/* Pointer to the file handle (may be NULL) */
    {iff}	iff	:PTR TO iffhandle		/* Pointer to an IFFHandle (may be NULL) */
    {buffer}	buffer	:/*STRPTR*/ ARRAY OF CHAR		/* Buffer */
    {bufferlength}	bufferlength	:ULONG	/* Length of the buffer */
ENDOBJECT

/*****************************************************************************/

NATIVE {ID_TOOL} CONST ID_TOOL = "DTTL"

NATIVE {tool} OBJECT tool
    {which}	which	:UINT				/* Which tool is this */
    {flags}	flags	:UINT				/* Flags */
    {program}	program	:/*STRPTR*/ ARRAY OF CHAR				/* Application to use */
ENDOBJECT

NATIVE {TSIZE}	CONST ->TSIZE	= SIZEOF tool

/* defines for tn_Which */
NATIVE {TW_INFO}			CONST TW_INFO			= 1
NATIVE {TW_BROWSE}		CONST TW_BROWSE		= 2
NATIVE {TW_EDIT}			CONST TW_EDIT			= 3
NATIVE {TW_PRINT}		CONST TW_PRINT		= 4
NATIVE {TW_MAIL}			CONST TW_MAIL			= 5

/* defines for tn_Flags */
NATIVE {TF_LAUNCH_MASK}		CONST TF_LAUNCH_MASK		= $000F
NATIVE {TF_SHELL}		CONST TF_SHELL		= $0001
NATIVE {TF_WORKBENCH}		CONST TF_WORKBENCH		= $0002
NATIVE {TF_RX}			CONST TF_RX			= $0003

/*****************************************************************************/

NATIVE {ID_TAGS}	CONST ID_TAGS	= "DTTG"

/*****************************************************************************/

->#ifndef	DATATYPE
NATIVE {DATATYPE} CONST
NATIVE {datatype} OBJECT datatype
    {node1}	node1	:ln		/* Reserved for system use */
    {node2}	node2	:ln		/* Reserved for system use */
    {header}	header	:PTR TO datatypeheader		/* Pointer to the DataTypeHeader */
    {toollist}	toollist	:lh		/* List of tool nodes */
    {functionname}	functionname	:/*STRPTR*/ ARRAY OF CHAR	/* Name of comparision routine */
    {attrlist}	attrlist	:ARRAY OF tagitem		/* Object creation tags */
    {length}	length	:ULONG		/* Length of the memory block */
ENDOBJECT
->#endif

NATIVE {DTNSIZE}	CONST DTNSIZE	= $3A	->SIZEOF datatype

/*****************************************************************************/

NATIVE {toolnode} OBJECT toolnode
    {node}	node	:ln				/* Embedded node */
    {tool}	tool	:tool				/* Embedded tool */
    {length}	length	:ULONG				/* Length of the memory block */
ENDOBJECT

NATIVE {TNSIZE}	CONST TNSIZE	= 26	->SIZEOF toolnode

/*****************************************************************************/

->#ifndef	ID_NAME
->"CONST ID_NAME" is on-purposely missing from here (it can be found in 'libraries/iff_shared4')
->#endif

/*****************************************************************************/

/* Text ID's */
NATIVE {DTERROR_UNKNOWN_DATATYPE}		CONST DTERROR_UNKNOWN_DATATYPE		= 2000
NATIVE {DTERROR_COULDNT_SAVE}			CONST DTERROR_COULDNT_SAVE			= 2001
NATIVE {DTERROR_COULDNT_OPEN}			CONST DTERROR_COULDNT_OPEN			= 2002
NATIVE {DTERROR_COULDNT_SEND_MESSAGE}		CONST DTERROR_COULDNT_SEND_MESSAGE		= 2003

/* New for V40 */
NATIVE {DTERROR_COULDNT_OPEN_CLIPBOARD}		CONST DTERROR_COULDNT_OPEN_CLIPBOARD		= 2004
NATIVE {DTERROR_Reserved}			CONST DTERROR_RESERVED			= 2005
NATIVE {DTERROR_UNKNOWN_COMPRESSION}		CONST DTERROR_UNKNOWN_COMPRESSION		= 2006
NATIVE {DTERROR_NOT_ENOUGH_DATA}			CONST DTERROR_NOT_ENOUGH_DATA			= 2007
NATIVE {DTERROR_INVALID_DATA}			CONST DTERROR_INVALID_DATA			= 2008

/* New for V44 */
CONST DTERROR_NOT_AVAILABLE			= 2009

/* Offset for types */
NATIVE {DTMSG_TYPE_OFFSET}			CONST DTMSG_TYPE_OFFSET			= 2100
