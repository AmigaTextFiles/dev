/*****************************************************************************

 Notification

 *****************************************************************************/
OPT MODULE
OPT EXPORT

MODULE 'dos/dos', 'exec/ports'

-> Notification message
OBJECT dOpusNotify
    msg:mn                     -> Message header
    type:LONG                   -> Type of message
    userData:LONG               -> User-supplied data
    data:LONG                   -> Message-specific data
    flags:LONG                  -> Flags
    fib:PTR TO fileinfoblock    -> FIB for some messages
    name[1]:ARRAY OF CHAR       -> Name for some messages
ENDOBJECT

-> dn_Msg.mn_Node.ln_Type
CONST NT_DOPUS_NOTIFY     = 199

-> dn_Type
SET DN_WRITE_ICON,       -> Icon written
    DN_APP_ICON_LIST,    -> AppIcon added/removed
    DN_APP_MENU_LIST,    -> AppMenu added/removed
    DN_CLOSE_WORKBENCH,  -> Workbench closed
    DN_OPEN_WORKBENCH,   -> Workbench opened
    DN_RESET_WORKBENCH,  -> Workbench reset
    DN_DISKCHANGE,       -> Disk inserted/removed
    DN_OPUS_QUIT,        -> Main program quit
    DN_OPUS_HIDE,        -> Main program hide
    DN_OPUS_SHOW,        -> Main program show
    DN_OPUS_START,       -> Main program start
    DN_DOS_ACTION,       -> DOS action
    DN_REXX_UP           -> REXX started

-> Flags with DN_WRITE_ICON
SET DNF_ICON_REMOVED,      -> Icon removed
    DNF_ICON_CHANGED       -> Image changed

-> Flags with DN_DOS_ACTION
SET DNF_DOS_CREATEDIR,      -> CreateDir
    DNF_DOS_DELETEFILE,     -> DeleteFile
    DNF_DOS_SETFILEDATE,    -> SetFileDate
    DNF_DOS_SETCOMMENT,     -> SetComment
    DNF_DOS_SETPROTECTION,  -> SetProtection
    DNF_DOS_RENAME,         -> Rename
    DNF_DOS_CREATE,         -> Open file (create)
    DNF_DOS_CLOSE,          -> Close file
    DNF_DOS_RELABEL         -> Relabel disk
