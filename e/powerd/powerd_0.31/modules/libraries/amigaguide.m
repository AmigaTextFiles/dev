MODULE 'intuition/screens','utility/tagitem'

ENUM  APSH_TOOL_ID=11000,
    StartupMsgID=APSH_TOOL_ID+1,
    LoginToolID=APSH_TOOL_ID+2,
    LogoutToolID=APSH_TOOL_ID+3,
    ShutdownMsgID=APSH_TOOL_ID+4,
    ActivateToolID=APSH_TOOL_ID+5,
    DeactivateToolID=APSH_TOOL_ID+6,
    ActiveToolID=APSH_TOOL_ID+7,
    InactiveToolID=APSH_TOOL_ID+8,
    ToolStatusID=APSH_TOOL_ID+9,
    ToolCmdID=APSH_TOOL_ID+10,
    ToolCmdReplyID=APSH_TOOL_ID+11,
    ShutdownToolID=APSH_TOOL_ID+12

ENUM AGA_Dummy=TAG_USER,
    AGA_Path=AGA_Dummy+1,
    AGA_XRefList=AGA_Dummy+2,
    AGA_Activate=AGA_Dummy+3,
    AGA_Context=AGA_Dummy+4,
    AGA_HelpGroup=AGA_Dummy+5,
    AGA_Reserved1=AGA_Dummy+6,
    AGA_Reserved2=AGA_Dummy+7,
    AGA_Reserved3=AGA_Dummy+8,
    AGA_ARexxPort=AGA_Dummy+9,
    AGA_ARexxPortName=AGA_Dummy+10

OBJECT AmigaGuideMsg
  Msg:MN,         /* Embedded Exec message structure */
  Type:ULONG,       /* Type of message */
  Data:APTR,        /* Pointer to message data */
  DSize:ULONG,      /* Size of message data */
  DType:ULONG,      /* Type of message data */
  Pri_Ret:ULONG,      /* Primary return value */
  Sec_Ret:ULONG,      /* Secondary return value */
  System1:APTR,
  System2:APTR

/* Allocation description structure */
OBJECT NewAmigaGuide
  Lock:BPTR,          /* Lock on the document directory */
  Name:PTR TO UBYTE,     /* Name of document file */
  Screen:PTR TO Screen, /* Screen to place windows within */
  PubScreen:PTR TO UBYTE,  /* Public screen name to open on */
  HostPort:PTR TO UBYTE, /* Application's ARexx port name */
  ClientPort:PTR TO UBYTE, /* Name to assign to the clients ARexx port */
  BaseName:PTR TO UBYTE, /* Base name of the application */
  Flags:ULONG,        /* Flags */
  Context:PTR TO PTR TO UBYTE,    /* NULL terminated context table */
  Node:PTR TO UBYTE,     /* Node to align on first (defaults to Main) */
  Line:LONG,          /* Line to align on */
  Extens:PTR TO TagItem,  /* Tag array extension */
  Client:VOID         /* Private! MUST be NULL */

/* public Client flags */
FLAG HT_LOAD_INDEX,      /* Force load the index at init time */
    HT_LOAD_ALL,      /* Force load the entire database at init */
    HT_CACHE_NODE,      /* Cache each node as visited */
    HT_CACHE_DB,      /* Keep the buffers around until expunge */
    HT_UNIQUE=15,     /* Unique ARexx port name */
    HT_NOACTIVATE     /* Don't activate window */

CONST HTFC_SYSGADS=$80000000

/* Callback function ID's */
ENUM HTH_OPEN,
    HTH_CLOSE

CONST HTERR_NOT_ENOUGH_MEMORY=100,
    HTERR_CANT_OPEN_DATABASE=101,
    HTERR_CANT_FIND_NODE=102,
    HTERR_CANT_OPEN_NODE=103,
    HTERR_CANT_OPEN_WINDOW=104,
    HTERR_INVALID_COMMAND=105,
    HTERR_CANT_COMPLETE=106,
    HTERR_PORT_CLOSED=107,
    HTERR_CANT_CREATE_PORT=108,
    HTERR_KEYWORD_NOT_FOUND=113

/* Cross reference node */
OBJECT XRef
  Node:LN,          /* Embedded node */
  Pad:UWORD,        /* Padding */
//  DF:PTR TO DocFile,  /* Document defined in */
  DF:PTR TO UBYTE,   /* Document defined in */
  File:PTR TO UBYTE,   /* Name of document file */
  Name:PTR TO UBYTE,   /* Name of item */
  Line:LONG,       /* Line defined at */
  Reserved[2]:ULONG /* Don't touch! (V44) */

/* Types of cross reference nodes */
ENUM XR_GENERIC,
    XR_FUNCTION,
    XR_COMMAND,
    XR_INCLUDE,
    XR_MACRO,
    XR_STRUCT,
    XR_FIELD,
    XR_TYPEDEF,
    XR_DEFINE 

/* Callback handle */
OBJECT AmigaGuideHost
  Dispatcher:Hook,    /* Dispatcher */
  Reserved:ULONG,   /* Must be 0 */
  Flags:ULONG,
  UseCnt:ULONG,     /* Number of open nodes */
  SystemData:APTR,    /* Reserved for system use */
  UserData:APTR     /* Anything you want... */

/* Methods */
CONST HM_FINDNODE=1,
    HM_OPENNODE=2,
    HM_CLOSENODE=3,
    HM_EXPUNGE=10   /* Expunge DataBase */

/* HM_FINDNODE */
OBJECT opFindHost
  MethodID:ULONG,
  Attrs:PTR TO TagItem, /*  R: Additional attributes */
  Node:PTR TO UBYTE,     /*  R: Name of node */
  TOC:PTR TO UBYTE,      /*  W: Table of Contents */
  Title:PTR TO UBYTE,    /*  W: Title to give to the node */
  Next:PTR TO UBYTE,     /*  W: Next node to browse to */
  Prev:PTR TO UBYTE      /*  W: Previous node to browse to */

/* HM_OPENNODE, HM_CLOSENODE */
OBJECT opNodeIO
  MethodID:ULONG,
  Attrs:PTR TO TagItem, /*  R: Additional attributes */
  Node:PTR TO UBYTE,     /*  R: Node name and arguments */
  FileName:PTR TO UBYTE, /*  W: File name buffer */
  DocBuffer:PTR TO UBYTE,  /*  W: Node buffer */
  BuffLen:ULONG,        /*  W: Size of buffer */
  Flags:ULONG         /* RW: Control flags */

/* onm_Flags */
FLAG HTNF_KEEP,      /* Don't flush this node until database is closed. */
    HTNF_RESERVED1, /* Reserved for system use */
    HTNF_RESERVED2, /* Reserved for system use */
    HTNF_ASCII,     /* Node is straight ASCII */
    HTNF_RESERVED3, /* Reserved for system use */
    HTNF_CLEAN,     /* Remove the node from the database */
    HTNF_DONE     /* Done with node */

/* onm_Attrs */
CONST HTNA_Dummy=TAG_USER,
    HTNA_Screen=HTNA_Dummy+1,  /* (struct Screen *) Screen that window resides in */
    HTNA_Pens=HTNA_Dummy+2,  /* Pen array (from DrawInfo) */
    HTNA_Rectangle=HTNA_Dummy+3,  /* Window box */
    HTNA_HelpGroup=HTNA_Dummy+5 /* (ULONG) unique identifier */


/* HM_EXPUNGE */
OBJECT opExpungeNode
  MethodID:ULONG,
  Attrs:PTR TO TagItem    /*  R: Additional attributes */
