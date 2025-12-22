/* $Id: amigaguide.h,v 1.11 2005/11/10 15:39:41 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/lists', 'target/exec/nodes', 'target/exec/semaphores', 'target/intuition/intuition', 'target/intuition/screens', 'target/intuition/classusr', 'target/dos/dos', 'target/utility/tagitem'
MODULE 'target/exec/ports', 'target/utility/hooks'
{#include <libraries/amigaguide.h>}
NATIVE {LIBRARIES_AMIGAGUIDE_H} CONST

NATIVE {APSH_TOOL_ID}     CONST APSH_TOOL_ID     = 11000
NATIVE {StartupMsgID}     CONST STARTUPMSGID     = (APSH_TOOL_ID+1)  /* Startup message */
NATIVE {LoginToolID}      CONST LOGINTOOLID      = (APSH_TOOL_ID+2)  /* Login a tool SIPC port */
NATIVE {LogoutToolID}     CONST LOGOUTTOOLID     = (APSH_TOOL_ID+3)  /* Logout a tool SIPC port */
NATIVE {ShutdownMsgID}    CONST SHUTDOWNMSGID    = (APSH_TOOL_ID+4)  /* Shutdown message */
NATIVE {ActivateToolID}   CONST ACTIVATETOOLID   = (APSH_TOOL_ID+5)  /* Activate tool */
NATIVE {DeactivateToolID} CONST DEACTIVATETOOLID = (APSH_TOOL_ID+6)  /* Deactivate tool */
NATIVE {ActiveToolID}     CONST ACTIVETOOLID     = (APSH_TOOL_ID+7)  /* Tool Active */
NATIVE {InactiveToolID}   CONST INACTIVETOOLID   = (APSH_TOOL_ID+8)  /* Tool Inactive */
NATIVE {ToolStatusID}     CONST TOOLSTATUSID     = (APSH_TOOL_ID+9)  /* Status message */
NATIVE {ToolCmdID}        CONST TOOLCMDID        = (APSH_TOOL_ID+10) /* Tool command message */
NATIVE {ToolCmdReplyID}   CONST TOOLCMDREPLYID   = (APSH_TOOL_ID+11) /* Reply to tool command */
NATIVE {ShutdownToolID}   CONST SHUTDOWNTOOLID   = (APSH_TOOL_ID+12) /* Shutdown tool */

/* Attributes accepted by GetAmigaGuideAttr() */
NATIVE {AGA_Dummy}         CONST AGA_DUMMY         = (TAG_USER)
NATIVE {AGA_Path}          CONST AGA_PATH          = (AGA_DUMMY+1)
NATIVE {AGA_XRefList}      CONST AGA_XREFLIST      = (AGA_DUMMY+2)
NATIVE {AGA_Activate}      CONST AGA_ACTIVATE      = (AGA_DUMMY+3)
NATIVE {AGA_Context}       CONST AGA_CONTEXT       = (AGA_DUMMY+4)

NATIVE {AGA_HelpGroup}     CONST AGA_HELPGROUP     = (AGA_DUMMY+5)
    /* (ULONG) Unique identifier */

NATIVE {AGA_Reserved1}     CONST AGA_RESERVED1     = (AGA_DUMMY+6)
NATIVE {AGA_Reserved2}     CONST AGA_RESERVED2     = (AGA_DUMMY+7)
NATIVE {AGA_Reserved3}     CONST AGA_RESERVED3     = (AGA_DUMMY+8)

NATIVE {AGA_ARexxPort}     CONST AGA_AREXXPORT     = (AGA_DUMMY+9)
    /* (struct MsgPort *) Pointer to the ARexx message port (V40) */

NATIVE {AGA_ARexxPortName} CONST AGA_AREXXPORTNAME = (AGA_DUMMY+10)
   /* (STRPTR) Used to specify the ARexx port name (V40) (not copied) */

NATIVE {AGA_Secure}        CONST AGA_SECURE        = (AGA_DUMMY+11)
   /* (BOOL) Disable "ONOPEN", "ONCLOSE" and "LINK RX", "LINK RXS",
      "LINK SYSTEM" commands (V41) */

NATIVE {AMIGAGUIDECONTEXT} CONST

NATIVE {AmigaGuideMsg} OBJECT amigaguidemsg
    {agm_Msg}	msg	:mn     /* Embedded Exec message structure */
    {agm_Type}	type	:ULONG    /* Type of message */
    {agm_Data}	data	:APTR    /* Pointer to message data */
    {agm_DSize}	dsize	:ULONG   /* Size of message data */
    {agm_DType}	dtype	:ULONG   /* Type of message data */
    {agm_Pri_Ret}	pri_ret	:ULONG /* Primary return value */
    {agm_Sec_Ret}	sec_ret	:ULONG /* Secondary return value */
    {agm_System1}	system1	:APTR
    {agm_System2}	system2	:APTR
ENDOBJECT

/* Allocation description structure */
NATIVE {NewAmigaGuide} OBJECT newamigaguide
    {nag_Lock}	lock	:BPTR       /* Lock on the document directory */
    {nag_Name}	name	:/*STRPTR*/ ARRAY OF CHAR       /* Name of document file */
    {nag_Screen}	screen	:PTR TO screen     /* Screen to place windows within */
    {nag_PubScreen}	pubscreen	:/*STRPTR*/ ARRAY OF CHAR  /* Public screen name to open on */
    {nag_HostPort}	hostport	:/*STRPTR*/ ARRAY OF CHAR   /* Application's ARexx port name */
    {nag_ClientPort}	clientport	:/*STRPTR*/ ARRAY OF CHAR /* Name to assign to the clients
                                       ARexx port */
    {nag_BaseName}	basename	:/*STRPTR*/ ARRAY OF CHAR   /* Base name of the application */
    {nag_Flags}	flags	:ULONG      /* Flags */
    {nag_Context}	context	:ARRAY OF /*STRPTR*/ ARRAY OF CHAR    /* NULL terminated context table */
    {nag_Node}	node	:/*STRPTR*/ ARRAY OF CHAR       /* Node to align on first
                                      (defaults to Main) */
    {nag_Line}	line	:VALUE       /* Line to align on */
    {nag_Extens}	extens	:ARRAY OF tagitem     /* Tag array extension */
    {nag_Client}	client	:PTR     /* Private! MUST be NULL */
ENDOBJECT

/* public Client flags */
NATIVE {HTF_LOAD_INDEX} CONST HTF_LOAD_INDEX = 1 SHL 0  /* Force load the index at init time */
NATIVE {HTF_LOAD_ALL}   CONST HTF_LOAD_ALL   = 1 SHL 1  /* Force load the entire database at init */
NATIVE {HTF_CACHE_NODE} CONST HTF_CACHE_NODE = 1 SHL 2  /* Cache each node as visited */
NATIVE {HTF_CACHE_DB}   CONST HTF_CACHE_DB   = 1 SHL 3  /* Keep the buffers around until expunge */
NATIVE {HTF_UNIQUE}     CONST HTF_UNIQUE     = 1 SHL 15 /* Unique ARexx port name */
NATIVE {HTF_NOACTIVATE} CONST HTF_NOACTIVATE = 1 SHL 16 /* Don't activate window */

NATIVE {HTFC_SYSGADS}   CONST HTFC_SYSGADS   = $80000000

/* Callback function ID's */
NATIVE {HTH_OPEN}  CONST HTH_OPEN  = 0
NATIVE {HTH_CLOSE} CONST HTH_CLOSE = 1

NATIVE {HTERR_NOT_ENOUGH_MEMORY}  CONST HTERR_NOT_ENOUGH_MEMORY  = 100
NATIVE {HTERR_CANT_OPEN_DATABASE} CONST HTERR_CANT_OPEN_DATABASE = 101
NATIVE {HTERR_CANT_FIND_NODE}     CONST HTERR_CANT_FIND_NODE     = 102
NATIVE {HTERR_CANT_OPEN_NODE}     CONST HTERR_CANT_OPEN_NODE     = 103
NATIVE {HTERR_CANT_OPEN_WINDOW}   CONST HTERR_CANT_OPEN_WINDOW   = 104
NATIVE {HTERR_INVALID_COMMAND}    CONST HTERR_INVALID_COMMAND    = 105
NATIVE {HTERR_CANT_COMPLETE}      CONST HTERR_CANT_COMPLETE      = 106
NATIVE {HTERR_PORT_CLOSED}        CONST HTERR_PORT_CLOSED        = 107
NATIVE {HTERR_CANT_CREATE_PORT}   CONST HTERR_CANT_CREATE_PORT   = 108
NATIVE {HTERR_KEYWORD_NOT_FOUND}  CONST HTERR_KEYWORD_NOT_FOUND  = 113

NATIVE {AMIGAGUIDEHOST} CONST

/* Cross reference node */
NATIVE {XRef} OBJECT xref
    {xr_Node}	node	:ln        /* Embedded node */
    {xr_Pad}	pad	:UINT         /* Padding */
    {xr_DF}	df	:NATIVE {struct DocFile*} PTR          /* Document defined in */
    {xr_File}	file	:/*STRPTR*/ ARRAY OF CHAR        /* Name of document file */
    {xr_Name}	name	:/*STRPTR*/ ARRAY OF CHAR        /* Name of item */
    {xr_Line}	line	:VALUE        /* Line defined at */
->    {xr_Reserved}	reserved[2]	:ARRAY OF ULONG /* Don't touch! (V44) */
ENDOBJECT

NATIVE {XRSIZE} CONST ->XRSIZE = SIZEOF xref

/* Types of cross reference nodes */
NATIVE {XR_GENERIC}  CONST XR_GENERIC  = 0
NATIVE {XR_FUNCTION} CONST XR_FUNCTION = 1
NATIVE {XR_COMMAND}  CONST XR_COMMAND  = 2
NATIVE {XR_INCLUDE}  CONST XR_INCLUDE  = 3
NATIVE {XR_MACRO}    CONST XR_MACRO    = 4
NATIVE {XR_STRUCT}   CONST XR_STRUCT   = 5
NATIVE {XR_FIELD}    CONST XR_FIELD    = 6
NATIVE {XR_TYPEDEF}  CONST XR_TYPEDEF  = 7
NATIVE {XR_DEFINE}   CONST XR_DEFINE   = 8

/* Callback handle */
NATIVE {AmigaGuideHost} OBJECT amigaguidehost
    {agh_Dispatcher}	dispatcher	:hook /* Dispatcher */
    {agh_Reserved}	reserved	:ULONG   /* Must be 0 */
    {agh_Flags}	flags	:ULONG
    {agh_UseCnt}	usecnt	:ULONG     /* Number of open nodes */
    {agh_SystemData}	systemdata	:APTR /* Reserved for system use */
    {agh_UserData}	userdata	:APTR   /* Anything you want... */
ENDOBJECT

/* Methods */
NATIVE {HM_FINDNODE}   CONST HM_FINDNODE   = 1
NATIVE {HM_OPENNODE}   CONST HM_OPENNODE   = 2
NATIVE {HM_CLOSENODE}  CONST HM_CLOSENODE  = 3
NATIVE {HM_EXPUNGE}   CONST HM_EXPUNGE   = 10 /* Expunge DataBase */

/* HM_FINDNODE */
NATIVE {opFindHost} OBJECT opfindhost
    {MethodID}	methodid	:ULONG
    {ofh_Attrs}	attrs	:ARRAY OF tagitem /*  R: Additional attributes */
    {ofh_Node}	node	:/*STRPTR*/ ARRAY OF CHAR  /*  R: Name of node */
    {ofh_TOC}	toc	:/*STRPTR*/ ARRAY OF CHAR   /*  W: Table of Contents */
    {ofh_Title}	title	:/*STRPTR*/ ARRAY OF CHAR /*  W: Title to give to the node */
    {ofh_Next}	next	:/*STRPTR*/ ARRAY OF CHAR  /*  W: Next node to browse to */
    {ofh_Prev}	prev	:/*STRPTR*/ ARRAY OF CHAR  /*  W: Previous node to browse to */
ENDOBJECT

/* HM_OPENNODE, HM_CLOSENODE */
NATIVE {opNodeIO} OBJECT opnodeio
    {MethodID}	methodid	:ULONG
    {onm_Attrs}	attrs	:ARRAY OF tagitem     /*  R: Additional attributes */
    {onm_Node}	node	:/*STRPTR*/ ARRAY OF CHAR      /*  R: Node name and arguments */
    {onm_FileName}	filename	:/*STRPTR*/ ARRAY OF CHAR  /*  W: File name buffer */
    {onm_DocBuffer}	docbuffer	:/*STRPTR*/ ARRAY OF CHAR /*  W: Node buffer */
    {onm_BuffLen}	bufflen	:ULONG   /*  W: Size of buffer */
    {onm_Flags}	flags	:ULONG     /* RW: Control flags */
ENDOBJECT

/* onm_Flags */
NATIVE {HTNF_KEEP}      CONST HTNF_KEEP      = 1 SHL 0 /* Don't flush this node until database is
                                * closed. */
NATIVE {HTNF_RESERVED1} CONST HTNF_RESERVED1 = 1 SHL 1 /* Reserved for system use */
NATIVE {HTNF_RESERVED2} CONST HTNF_RESERVED2 = 1 SHL 2 /* Reserved for system use */
NATIVE {HTNF_ASCII}     CONST HTNF_ASCII     = 1 SHL 3 /* Node is straight ASCII */
NATIVE {HTNF_RESERVED3} CONST HTNF_RESERVED3 = 1 SHL 4 /* Reserved for system use */
NATIVE {HTNF_CLEAN}     CONST HTNF_CLEAN     = 1 SHL 5 /* Remove the node from the database */
NATIVE {HTNF_DONE}      CONST HTNF_DONE      = 1 SHL 6 /* Done with node */

/* onm_Attrs */
NATIVE {HTNA_Dummy}     CONST HTNA_DUMMY     = (TAG_USER)
NATIVE {HTNA_Screen}    CONST HTNA_SCREEN    = (HTNA_DUMMY+1) /* (struct Screen *) Screen that
                                       * window resides in */
NATIVE {HTNA_Pens}      CONST HTNA_PENS      = (HTNA_DUMMY+2) /* Pen array (from DrawInfo) */
NATIVE {HTNA_Rectangle} CONST HTNA_RECTANGLE = (HTNA_DUMMY+3) /* Window box */

NATIVE {HTNA_HelpGroup} CONST HTNA_HELPGROUP = (HTNA_DUMMY+5) /* (ULONG) unique identifier */


/* HM_EXPUNGE */
NATIVE {opExpungeNode} OBJECT opexpungenode
    {MethodID}	methodid	:ULONG
    {oen_Attrs}	attrs	:ARRAY OF tagitem /*  R: Additional attributes */
ENDOBJECT
