/* $Id: amigaguide_lib.h 44.1 1999/03/14 08:27:51 olsen Exp olsen $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/lists', 'target/exec/nodes', 'target/exec/semaphores', 'target/intuition/intuition', 'target/intuition/screens', 'target/intuition/classusr', 'target/dos/dos', 'target/utility/tagitem'
MODULE 'target/exec/ports', 'target/utility/hooks'
{MODULE 'libraries/amigaguide'}

NATIVE {APSH_TOOL_ID} CONST APSH_TOOL_ID = 11000
NATIVE {STARTUPMSGID}		CONST STARTUPMSGID		= (APSH_TOOL_ID+1)	/* Startup message */
NATIVE {LOGINTOOLID}		CONST LOGINTOOLID		= (APSH_TOOL_ID+2)	/* Login a tool SIPC port */
NATIVE {LOGOUTTOOLID}		CONST LOGOUTTOOLID		= (APSH_TOOL_ID+3)	/* Logout a tool SIPC port */
NATIVE {SHUTDOWNMSGID}		CONST SHUTDOWNMSGID		= (APSH_TOOL_ID+4)	/* Shutdown message */
NATIVE {ACTIVATETOOLID}		CONST ACTIVATETOOLID		= (APSH_TOOL_ID+5)	/* Activate tool */
NATIVE {DEACTIVATETOOLID}	CONST DEACTIVATETOOLID	= (APSH_TOOL_ID+6)	/* Deactivate tool */
NATIVE {ACTIVETOOLID}		CONST ACTIVETOOLID		= (APSH_TOOL_ID+7)	/* Tool Active */
NATIVE {INACTIVETOOLID}		CONST INACTIVETOOLID		= (APSH_TOOL_ID+8)	/* Tool Inactive */
NATIVE {TOOLSTATUSID}		CONST TOOLSTATUSID		= (APSH_TOOL_ID+9)	/* Status message */
NATIVE {TOOLCMDID}		CONST TOOLCMDID		= (APSH_TOOL_ID+10)	/* Tool command message */
NATIVE {TOOLCMDREPLYID}		CONST TOOLCMDREPLYID		= (APSH_TOOL_ID+11)	/* Reply to tool command */
NATIVE {SHUTDOWNTOOLID}		CONST SHUTDOWNTOOLID		= (APSH_TOOL_ID+12)	/* Shutdown tool */

/* Attributes accepted by GetAmigaGuideAttr() */
NATIVE {AGA_DUMMY}		CONST AGA_DUMMY		= (TAG_USER)
NATIVE {AGA_PATH}		CONST AGA_PATH		= (AGA_DUMMY+1)
NATIVE {AGA_XREFLIST}		CONST AGA_XREFLIST		= (AGA_DUMMY+2)
NATIVE {AGA_ACTIVATE}		CONST AGA_ACTIVATE		= (AGA_DUMMY+3)
NATIVE {AGA_CONTEXT}		CONST AGA_CONTEXT		= (AGA_DUMMY+4)

NATIVE {AGA_HELPGROUP}		CONST AGA_HELPGROUP		= (AGA_DUMMY+5)
    /* (ULONG) Unique identifier */

NATIVE {AGA_RESERVED1}		CONST AGA_RESERVED1		= (AGA_DUMMY+6)
NATIVE {AGA_RESERVED2}		CONST AGA_RESERVED2		= (AGA_DUMMY+7)
NATIVE {AGA_RESERVED3}		CONST AGA_RESERVED3		= (AGA_DUMMY+8)

NATIVE {AGA_AREXXPORT}		CONST AGA_AREXXPORT		= (AGA_DUMMY+9)
    /* (struct MsgPort *) Pointer to the ARexx message port (V40) */

NATIVE {AGA_AREXXPORTNAME}	CONST AGA_AREXXPORTNAME	= (AGA_DUMMY+10)
   /* (STRPTR) Used to specify the ARexx port name (V40) (not copied) */

   /* (BOOL) Disable "ONOPEN", "ONCLOSE" and "LINK RX", "LINK RXS", "LINK SYSTEM" commands (V41) */

NATIVE {amigaguidemsg} OBJECT amigaguidemsg
    {msg}	msg	:mn			/* Embedded Exec message structure */
    {type}	type	:ULONG			/* Type of message */
    {data}	data	:APTR			/* Pointer to message data */
    {dsize}	dsize	:ULONG			/* Size of message data */
    {dtype}	dtype	:ULONG			/* Type of message data */
    {pri_ret}	pri_ret	:ULONG			/* Primary return value */
    {sec_ret}	sec_ret	:ULONG			/* Secondary return value */
    {system1}	system1	:APTR
    {system2}	system2	:APTR
ENDOBJECT

/* Allocation description structure */
NATIVE {newamigaguide} OBJECT newamigaguide
    {lock}	lock	:BPTR			/* Lock on the document directory */
    {name}	name	:/*STRPTR*/ ARRAY OF CHAR			/* Name of document file */
    {screen}	screen	:PTR TO screen			/* Screen to place windows within */
    {pubscreen}	pubscreen	:/*STRPTR*/ ARRAY OF CHAR			/* Public screen name to open on */
    {hostport}	hostport	:/*STRPTR*/ ARRAY OF CHAR			/* Application's ARexx port name */
    {clientport}	clientport	:/*STRPTR*/ ARRAY OF CHAR		/* Name to assign to the clients ARexx port */
    {basename}	basename	:/*STRPTR*/ ARRAY OF CHAR			/* Base name of the application */
    {flags}	flags	:ULONG			/* Flags */
    {context}	context	:ARRAY OF /*STRPTR*/ ARRAY OF CHAR			/* NULL terminated context table */
    {node}	node	:/*STRPTR*/ ARRAY OF CHAR			/* Node to align on first (defaults to Main) */
    {line}	line	:VALUE			/* Line to align on */
    {extens}	extens	:ARRAY OF tagitem			/* Tag array extension */
    {client}	client	:PTR			/* Private! MUST be NULL */
ENDOBJECT

/* public Client flags */
NATIVE {HTF_LOAD_INDEX}		CONST HTF_LOAD_INDEX		= $1			/* Force load the index at init time */
NATIVE {HTF_LOAD_ALL}		CONST HTF_LOAD_ALL		= $2			/* Force load the entire database at init */
NATIVE {HTF_CACHE_NODE}		CONST HTF_CACHE_NODE		= $4			/* Cache each node as visited */
NATIVE {HTF_CACHE_DB}		CONST HTF_CACHE_DB		= $8			/* Keep the buffers around until expunge */
NATIVE {HTF_UNIQUE}		CONST HTF_UNIQUE		= $8000		/* Unique ARexx port name */
NATIVE {HTF_NOACTIVATE}		CONST HTF_NOACTIVATE		= $10000		/* Don't activate window */

NATIVE {HTFC_SYSGADS}		CONST HTFC_SYSGADS		= $80000000

/* Callback function ID's */
NATIVE {HTH_OPEN}		CONST HTH_OPEN		= 0
NATIVE {HTH_CLOSE}		CONST HTH_CLOSE		= 1

NATIVE {HTERR_NOT_ENOUGH_MEMORY}		CONST HTERR_NOT_ENOUGH_MEMORY		= 100
NATIVE {HTERR_CANT_OPEN_DATABASE}	CONST HTERR_CANT_OPEN_DATABASE	= 101
NATIVE {HTERR_CANT_FIND_NODE}		CONST HTERR_CANT_FIND_NODE		= 102
NATIVE {HTERR_CANT_OPEN_NODE}		CONST HTERR_CANT_OPEN_NODE		= 103
NATIVE {HTERR_CANT_OPEN_WINDOW}		CONST HTERR_CANT_OPEN_WINDOW		= 104
NATIVE {HTERR_INVALID_COMMAND}		CONST HTERR_INVALID_COMMAND		= 105
NATIVE {HTERR_CANT_COMPLETE}		CONST HTERR_CANT_COMPLETE		= 106
NATIVE {HTERR_PORT_CLOSED}		CONST HTERR_PORT_CLOSED		= 107
NATIVE {HTERR_CANT_CREATE_PORT}		CONST HTERR_CANT_CREATE_PORT		= 108
NATIVE {HTERR_KEYWORD_NOT_FOUND}		CONST HTERR_KEYWORD_NOT_FOUND		= 113

/* Cross reference node */
NATIVE {xref} OBJECT xref
    {node}	node	:ln			/* Embedded node */
    {pad}	pad	:UINT			/* Padding */
    {df}	df	:PTR				/* Document defined in */
    {file}	file	:/*STRPTR*/ ARRAY OF CHAR			/* Name of document file */
    {name}	name	:/*STRPTR*/ ARRAY OF CHAR			/* Name of item */
    {line}	line	:VALUE			/* Line defined at */
->    {reserved}	reserved[2]	:ARRAY OF ULONG		/* Don't touch! (V44) */
ENDOBJECT

/* Types of cross reference nodes */
NATIVE {XR_GENERIC}	CONST XR_GENERIC	= 0
NATIVE {XR_FUNCTION}	CONST XR_FUNCTION	= 1
NATIVE {XR_COMMAND}	CONST XR_COMMAND	= 2
NATIVE {XR_INCLUDE}	CONST XR_INCLUDE	= 3
NATIVE {XR_MACRO}	CONST XR_MACRO	= 4
NATIVE {XR_STRUCT}	CONST XR_STRUCT	= 5
NATIVE {XR_FIELD}	CONST XR_FIELD	= 6
NATIVE {XR_TYPEDEF}	CONST XR_TYPEDEF	= 7
NATIVE {XR_DEFINE}	CONST XR_DEFINE	= 8

/* Callback handle */
NATIVE {amigaguidehost} OBJECT amigaguidehost
    {dispatcher}	dispatcher	:hook		/* Dispatcher */
    {reserved}	reserved	:ULONG			/* Must be 0 */
    {flags}	flags	:ULONG
    {usecnt}	usecnt	:ULONG			/* Number of open nodes */
    {systemdata}	systemdata	:APTR		/* Reserved for system use */
    {userdata}	userdata	:APTR			/* Anything you want... */
ENDOBJECT

/* Methods */
NATIVE {HM_FINDNODE}	CONST HM_FINDNODE	= 1
NATIVE {HM_OPENNODE}	CONST HM_OPENNODE	= 2
NATIVE {HM_CLOSENODE}	CONST HM_CLOSENODE	= 3
NATIVE {HM_EXPUNGE}	CONST HM_EXPUNGE	= 10		/* Expunge DataBase */

/* HM_FINDNODE */
NATIVE {opfindhost} OBJECT opfindhost
    {methodid}	methodid	:ULONG
    {attrs}	attrs	:ARRAY OF tagitem		/*  R: Additional attributes */
    {node}	node	:/*STRPTR*/ ARRAY OF CHAR			/*  R: Name of node */
    {toc}	toc	:/*STRPTR*/ ARRAY OF CHAR			/*  W: Table of Contents */
    {title}	title	:/*STRPTR*/ ARRAY OF CHAR			/*  W: Title to give to the node */
    {next}	next	:/*STRPTR*/ ARRAY OF CHAR			/*  W: Next node to browse to */
    {prev}	prev	:/*STRPTR*/ ARRAY OF CHAR			/*  W: Previous node to browse to */
ENDOBJECT

/* HM_OPENNODE, HM_CLOSENODE */
NATIVE {opnodeio} OBJECT opnodeio
    {methodid}	methodid	:ULONG
    {attrs}	attrs	:ARRAY OF tagitem		/*  R: Additional attributes */
    {node}	node	:/*STRPTR*/ ARRAY OF CHAR			/*  R: Node name and arguments */
    {filename}	filename	:/*STRPTR*/ ARRAY OF CHAR		/*  W: File name buffer */
    {docbuffer}	docbuffer	:/*STRPTR*/ ARRAY OF CHAR		/*  W: Node buffer */
    {bufflen}	bufflen	:ULONG			/*  W: Size of buffer */
    {flags}	flags	:ULONG			/* RW: Control flags */
ENDOBJECT

/* onm_Flags */
NATIVE {HTNF_KEEP}	CONST HTNF_KEEP	= $1	/* Don't flush this node until database is
				 * closed. */
NATIVE {HTNF_RESERVED1}	CONST HTNF_RESERVED1	= $2	/* Reserved for system use */
NATIVE {HTNF_RESERVED2}	CONST HTNF_RESERVED2	= $4	/* Reserved for system use */
NATIVE {HTNF_ASCII}	CONST HTNF_ASCII	= $8	/* Node is straight ASCII */
NATIVE {HTNF_RESERVED3}	CONST HTNF_RESERVED3	= $10	/* Reserved for system use */
NATIVE {HTNF_CLEAN}	CONST HTNF_CLEAN	= $20	/* Remove the node from the database */
NATIVE {HTNF_DONE}	CONST HTNF_DONE	= $40	/* Done with node */

/* onm_Attrs */
NATIVE {HTNA_DUMMY}	CONST HTNA_DUMMY	= (TAG_USER)
NATIVE {HTNA_SCREEN}	CONST HTNA_SCREEN	= (HTNA_DUMMY+1)	/* (struct Screen *) Screen that window resides in */
NATIVE {HTNA_PENS}	CONST HTNA_PENS	= (HTNA_DUMMY+2)	/* Pen array (from DrawInfo) */
NATIVE {HTNA_RECTANGLE}	CONST HTNA_RECTANGLE	= (HTNA_DUMMY+3)	/* Window box */

NATIVE {HTNA_HELPGROUP}	CONST HTNA_HELPGROUP	= (HTNA_DUMMY+5)	/* (ULONG) unique identifier */


/* HM_EXPUNGE */
NATIVE {opexpungenode} OBJECT opexpungenode
    {methodid}	methodid	:ULONG
    {attrs}	attrs	:ARRAY OF tagitem		/*  R: Additional attributes */
ENDOBJECT
