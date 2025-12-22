/*****************************************************************************

 Inter-process communication

 *****************************************************************************/

OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/ports', 'exec/nodes', 'dos/dos', 'dos/dosextens', '*lists'

-> IPC message
OBJECT ipcMessage
    msg:mn                  -> Exec message
    command:LONG            -> Message command
    flags:LONG              -> Message flags
    data:PTR TO LONG        -> Message data
    data_free:PTR TO LONG   -> Data to be FreeVec()ed automatically
    sender:PTR TO ipcData   -> Sender IPC
ENDOBJECT

CONST REPLY_NO_PORT       = -1    -> Sync msg, no port supplied
CONST REPLY_NO_PORT_IPC   = -2    -> Sync msg from a non-IPC process

-> IPC process
OBJECT ipcData
    node:mln
    proc:PTR TO process             -> Process pointer
    startup_msg:ipcMessage          -> Startup message
    command_port:PTR TO mp          -> Port to send commands to
    list:PTR TO listLock            -> List we're a member of
    userdata:PTR TO LONG
    memory:PTR TO LONG              -> Memory
    reply_port:PTR TO mp            -> Port for replies
    flags:LONG                      -> Flags
ENDOBJECT

#define IPCDATA(ipc) ( ipc.userdata )
#define SET_IPCDATE(ipc,data) ( ipc.userdate := data )

-> Used in the stack paramter for IPC_Launch
CONST IPCF_GETPATH          = $80000000  -> Want copy of path list
#define IPCM_STACK(s)       ($FFFFFF)    -> Mask out stack value

-> Pre-defined commands
ENUM    IPC_COMMAND_BASE=$8000000,
        IPC_STARTUP,                -> Startup command
        IPC_ABORT,                  -> Abort!
        IPC_QUIT,                   -> Quit process
        IPC_ACTIVATE,               -> Activate process
        IPC_HELLO,                  -> Something saying hello
        IPC_GOODBYE,                -> Something saying goodbye
        IPC_HIDE,                   -> Process, hide thyself
        IPC_SHOW,                   -> Tell process to reveal itself
        IPC_RESET,                  -> Process should reset
        IPC_HELP,                   -> Help!
        IPC_NEW,                    -> Create something new
        IPC_GOT_GOODBYE,            -> Got goodbye from something
        IPC_IDENTIFY,               -> Identify yourself
        IPC_PRIORITY,               -> Change your priority to this
        IPC_REMOVE                  -> Remove yourself


-> Pre-defined signals
CONST IPCSIG_HIDE     = SIGBREAKF_CTRL_D
CONST IPCSIG_SHOW     = SIGBREAKF_CTRL_E
CONST IPCSIG_QUIT     = SIGBREAKF_CTRL_F
