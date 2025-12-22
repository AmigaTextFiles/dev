;
; ** $VER: amigaguide.h 39.4 (22.3.93)
; ** Includes Release 40.15
; **
; ** C prototypes. For use with 32 bit integers only.
; **
; ** (C) Copyright 1990-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"

;XIncludeFile "intuition/all.pb"

XIncludeFile "exec/lists.pb"
XIncludeFile "exec/nodes.pb"
XIncludeFile "exec/semaphores.pb"
XIncludeFile "dos/dos.pb"
XIncludeFile "utility/tagitem.pb"
XIncludeFile "utility/hooks.pb"


#APSH_TOOL_ID = 11000
#StartupMsgID  = (#APSH_TOOL_ID+1) ;  Startup message
#LoginToolID  = (#APSH_TOOL_ID+2) ;  Login a tool SIPC port
#LogoutToolID  = (#APSH_TOOL_ID+3) ;  Logout a tool SIPC port
#ShutdownMsgID  = (#APSH_TOOL_ID+4) ;  Shutdown message
#ActivateToolID  = (#APSH_TOOL_ID+5) ;  Activate tool
#DeactivateToolID = (#APSH_TOOL_ID+6) ;  Deactivate tool
#ActiveToolID  = (#APSH_TOOL_ID+7) ;  Tool Active
#InactiveToolID  = (#APSH_TOOL_ID+8) ;  Tool Inactive
#ToolStatusID  = (#APSH_TOOL_ID+9) ;  Status message
#ToolCmdID  = (#APSH_TOOL_ID+10) ;  Tool command message
#ToolCmdReplyID  = (#APSH_TOOL_ID+11) ;  Reply to tool command
#ShutdownToolID  = (#APSH_TOOL_ID+12) ;  Shutdown tool

;  Attributes accepted by GetAmigaGuideAttr()
#AGA_Dummy  = (#TAG_USER)
#AGA_Path  = (#AGA_Dummy+1)
#AGA_XRefList  = (#AGA_Dummy+2)
#AGA_Activate  = (#AGA_Dummy+3)
#AGA_Context  = (#AGA_Dummy+4)

#AGA_HelpGroup  = (#AGA_Dummy+5)
    ;  (ULONG) Unique identifier

#AGA_Reserved1  = (#AGA_Dummy+6)
#AGA_Reserved2  = (#AGA_Dummy+7)
#AGA_Reserved3  = (#AGA_Dummy+8)

#AGA_ARexxPort  = (#AGA_Dummy+9)
    ;  (struct MsgPort *) Pointer to the ARexx message port (V40)

#AGA_ARexxPortName = (#AGA_Dummy+10)
   ;  (STRPTR) Used to specify the ARexx port name (V40) (not copied)


;typedef void *AMIGAGUID###ECONT###EXT

Structure AmigaGuideMsg

    agm_Msg.Message   ;  Embedded Exec message structure
    agm_Type.l   ;  Type of message
    *agm_Data.l   ;  Pointer to message data
    agm_DSize.l   ;  Size of message data
    agm_DType.l   ;  Type of message data
    agm_Pri_Ret.l   ;  Primary return value
    agm_Sec_Ret.l   ;  Secondary return value
    *agm_System1.l
    *agm_System2.l
EndStructure

;  Allocation description structure
Structure NewAmigaGuide

    nag_Lock.l   ;  Lock on the document directory
    *nag_Name.b   ;  Name of document file
    *nag_Screen.Screen   ;  Screen to place windows within
    *nag_PubScreen.b   ;  Public screen name to open on
    *nag_HostPort.b   ;  Application's ARexx port name
    *nag_ClientPort.b  ;  Name to assign to the clients ARexx port
    *nag_BaseName.b   ;  Base name of the application
    nag_Flags.l   ;  Flags
    *nag_Context.l   ;  NULL terminated context table
    *nag_Node.b   ;  Node to align on first (defaults to Main)
    nag_Line.l   ;  Line to align on
    *nag_Extens.TagItem   ;  Tag array extension
    *nag_Client.l   ;  Private! MUST be NULL
EndStructure

;  public Client flags
#HTF_LOAD_INDEX  = (1 << 0)   ;  Force load the index at init time
#HTF_LOAD_ALL  = (1 << 1)   ;  Force load the entire database at init
#HTF_CACHE_NODE  = (1 << 2)   ;  Cache each node as visited
#HTF_CACHE_DB  = (1 << 3)   ;  Keep the buffers around until expunge
#HTF_UNIQUE  = (1 << 15)  ;  Unique ARexx port name
#HTF_NOACTIVATE  = (1 << 16)  ;  Don't activate window

#HTFC_SYSGADS  = $80000000

;  Callback function ID's
#HTH_OPEN  = 0
#HTH_CLOSE  = 1

#HTERR_NOT_ENOUGH_MEMORY  = 100
#HTERR_CANT_OPEN_DATABASE = 101
#HTERR_CANT_FIND_NODE  = 102
#HTERR_CANT_OPEN_NODE  = 103
#HTERR_CANT_OPEN_WINDOW  = 104
#HTERR_INVALID_COMMAND  = 105
#HTERR_CANT_COMPLETE  = 106
#HTERR_PORT_CLOSED  = 107
#HTERR_CANT_CREATE_PORT  = 108
#HTERR_KEYWORD_NOT_FOUND = 113

;  Cross reference node
Structure XRef

    xr_Node.Node   ;  Embedded node
    xr_Pad.w   ;  Padding
    *xr_DF.l ;.DocFile    ;  Document defined in
    *xr_File.b   ;  Name of document file
    *xr_Name.b   ;  Name of item
    xr_Line.l   ;  Line defined at
EndStructure

#XRSIZE = 32 ; (SizeOf (Structure XRef))

;  Types of cross reference nodes
#XR_GENERIC = 0
#XR_FUNCTION = 1
#XR_COMMAND = 2
#XR_IncludeFile = 3
#XR_MACRO = 4
#XR_STRUCT = 5
#XR_FIELD = 6
#XR_TYPEDEF = 7
#XR_DEFINE = 8

;  Callback handle
Structure AmigaGuideHost

    agh_Dispatcher.Hook  ;  Dispatcher
    agh_Reserved.l   ;  Must be 0
    agh_Flags.l
    agh_UseCnt.l   ;  Number of open nodes
    *agh_SystemData.l  ;  Reserved for system use
    *agh_UserData.l   ;  Anything you want...
EndStructure

;  Methods
#HM_FINDNODE = 1
#HM_OPENNODE = 2
#HM_CLOSENODE = 3
#HM_EXPUNGE = 10  ;  Expunge DataBase

;  HM_FINDNODE
Structure opFindHost

    MethodID.l
    *ofh_Attrs.TagItem  ;   R: Additional attributes
    *ofh_Node.b   ;   R: Name of node
    *ofh_TOC.b   ;   W: Table of Contents
    *ofh_Title.b   ;   W: Title to give to the node
    *ofh_Next.b   ;   W: Next node to browse to
    *ofh_Prev.b   ;   W: Previous node to browse to
EndStructure

;  HM_OPENNODE, HM_CLOSENODE
Structure opNodeIO

    MethodID.l
    *onm_Attrs.TagItem  ;   R: Additional attributes
    *onm_Node.b   ;   R: Node name and arguments
    *onm_FileName.b  ;   W: File name buffer
    *onm_DocBuffer.b  ;   W: Node buffer
    onm_BuffLen.l   ;   W: Size of buffer
    onm_Flags.l   ;  RW: Control flags
EndStructure

;  onm_Flags
#HTNF_KEEP = (1 << 0) ;  Don't flush this node until database is
;      * closed.
#HTNF_RESERVED1 = (1 << 1) ;  Reserved for system use
#HTNF_RESERVED2 = (1 << 2) ;  Reserved for system use
#HTNF_ASCII = (1 << 3) ;  Node is straight ASCII
#HTNF_RESERVED3 = (1 << 4) ;  Reserved for system use
#HTNF_CLEAN = (1 << 5) ;  Remove the node from the database
#HTNF_DONE = (1 << 6) ;  Done with node

;  onm_Attrs
#HTNA_Dummy = (#TAG_USER)
#HTNA_Screen = (#HTNA_Dummy+1) ;  (struct Screen *) Screen that window resides in
#HTNA_Pens = (#HTNA_Dummy+2) ;  Pen array (from DrawInfo)
#HTNA_Rectangle = (#HTNA_Dummy+3) ;  Window box

#HTNA_HelpGroup = (#HTNA_Dummy+5) ;  (ULONG) unique identifier


;  HM_EXPUNGE
Structure opExpungeNode

    MethodID.l
    *oen_Attrs.TagItem  ;   R: Additional attributes
EndStructure

