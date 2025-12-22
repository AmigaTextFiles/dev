/****************************************************************************

 Support file for DOpus modules

 ****************************************************************************/
OPT MODULE
OPT EXPORT

MODULE 'dos/dos', 'intuition/intuition', 'intuition/screens', '*ipc'

-> Defines a function in a module
OBJECT moduleFunction
    id:LONG                     -> Function ID code
    name:PTR TO CHAR            -> Function name
    desc:LONG                   -> Locale string ID for function description
    flags:LONG                  -> Function flags
    template:PTR TO CHAR        -> Command template
ENDOBJECT

-> Function flags
CONST FUNCF_NEED_SOURCE       = 1           -> Needs a source directory
CONST FUNCF_NEED_DEST         = 2           -> Needs a destination directory
CONST FUNCF_NEED_FILES        = 4           -> Needs some files to work with
CONST FUNCF_NEED_DIRS         = 8           -> Needs some files to work with
CONST FUNCF_NEED_ENTRIES      = $C
CONST FUNCF_CAN_DO_ICONS      = $40         -> Function can do icons
CONST FUNCF_SINGLE_SOURCE     = $100        -> Only a single source needed
CONST FUNCF_SINGLE_DEST       = $200        -> Only a single destination needed
CONST FUNCF_WANT_DEST         = $800        -> Want destinations, don't need them
CONST FUNCF_WANT_SOURCE       = $1000       -> Want source, don't need it
CONST FUNCF_WANT_ENTRIES      = $80000      -> Want entries
CONST FUNCF_PRIVATE           = $20000000   -> Function is private


-> Defines all the functions in a module
OBJECT moduleInfo
    ver:LONG                                -> Module version
    name:PTR TO CHAR                        -> Module name
    locale_name:PTR TO CHAR                 -> Catalog name
    flags:LONG                              -> Module flags
    function_count:LONG                     -> Number of functions in module
    function[1]:ARRAY OF moduleFunction     -> Definition of first function
ENDOBJECT


/*** If the module has more than one function, the additional ModuleFunction
     structures MUST follow the ModuleInfo structure in memory. Eg,

     ModuleInfo module_info={....};
     ModuleFunction more_funcs[2]={{...},{...}};                           ***/


-> Flags for ModuleInfo
CONST MODULEF_CALL_STARTUP        = 1  -> Call ModuleEntry() on startup
CONST MODULEF_STARTUP_SYNC        = 2  -> Run Synchronously on startup

-> ID passed to Module_Entry() if module is run on startup
CONST FUNCID_STARTUP          = $FFFFFFFF

-> Callback commands
CONST EXTCMD_GET_SOURCE         = 0   -> Get current source path
CONST EXTCMD_NEXT_SOURCE        = 1   -> Get next source path
CONST EXTCMD_UNLOCK_SOURCE      = 2   -> Unlock source paths
CONST EXTCMD_GET_ENTRY          = 3   -> Get entry
CONST EXTCMD_END_ENTRY          = 4   -> End entry
CONST EXTCMD_RELOAD_ENTRY       = 5   -> Reload entry
CONST EXTCMD_CHECK_ABORT        = 9   -> Check abort status
CONST EXTCMD_ENTRY_COUNT        = 10  -> Get entry count
CONST EXTCMD_GET_WINDOW         = 11  -> Get window handle
CONST EXTCMD_GET_DEST           = 12  -> Get next destination
CONST EXTCMD_END_SOURCE         = 13  -> Cleanup current source path
CONST EXTCMD_END_DEST           = 14  -> Cleanup current destination path
CONST EXTCMD_ADD_FILE           = 16  -> Add a file to a lister
CONST EXTCMD_GET_HELP           = 17  -> Get help on a topic
CONST EXTCMD_GET_PORT           = 18  -> Get ARexx port name
CONST EXTCMD_GET_SCREEN         = 19  -> Get public screen name
CONST EXTCMD_REPLACE_REQ        = 20  -> Show exists/replace? requester
CONST EXTCMD_REMOVE_ENTRY       = 21  -> Mark an entry for removal
CONST EXTCMD_GET_SCREENDATA     = 22  -> Get DOpus screen data
CONST EXTCMD_FREE_SCREENDATA    = 23  -> Free screen data
CONST EXTCMD_SEND_COMMAND       = 30  -> Send a command to DOpus
CONST EXTCMD_DEL_FILE           = 31  -> Delete a file from a lister
CONST EXTCMD_DO_CHANGES         = 32  -> Perform changes
CONST EXTCMD_LOAD_FILE          = 33  -> Load files to listers


-> Structures used with callback commands
OBJECT function_entry
    pad[2]:ARRAY OF LONG
    name:PTR TO CHAR        -> File name
    entry:PTR TO LONG       -> Entry pointer (don't touch!)
    type:INT                -> Type of file
    flags:INT               -> File flags
ENDOBJECT

OBJECT path_node
    pad[2]:ARRAY OF LONG
    buffer[512]:ARRAY OF CHAR   -> Contains path string
    path:PTR TO CHAR            -> Points to path string
    lister:PTR TO LONG          -> Lister pointer
    flags:LONG                  -> Flags
ENDOBJECT


/****************************************************************************

 Packets used to send commands

 ****************************************************************************/

-> EXTCMD_END_ENTRY
OBJECT endentry_packet
    entry:PTR TO function_entry     -> Entry pointer
    deselect:INT                    -> TRUE to deselect entry
ENDOBJECT

-> EXTCMD_ADD_FILE
OBJECT addfile_packet
    path:PTR TO CHAR                -> Path to add file to
    fib:fileinfoblock               -> FileInfoBlock to add
    lister:PTR TO LONG              -> Lister pointer
ENDOBJECT

-> EXTCMD_DEL_FILE
OBJECT delfile_packet
    path:PTR TO CHAR            -> Path to delete file from
    name:PTR TO CHAR            -> Name of file to delete
    lister:PTR TO LONG          -> Lister pointer
ENDOBJECT

-> EXTCMD_LOAD_FILE
OBJECT loadfile_packet
    path:PTR TO CHAR        -> Path of file
    name:PTR TO CHAR        -> File name
    flags:INT               -> Flags field
    reload:INT              -> TRUE to reload existing file
ENDOBJECT

CONST LFF_ICON        = 1


-> EXTCMD_REPLACE_REQ
OBJECT replacereq_packet
    window:PTR TO window            -> Window to open over
    screen:PTR TO screen            -> Screen to open on
    ipc:PTR TO ipcData              -> Your process IPC pointer
    file1:PTR TO fileinfoblock      -> First file
    file2:PTR TO fileinfoblock      -> Second file
    flags:INT                       -> Flags
ENDOBJECT

-> Result code from EXTCMD_REPLACE_REQ
CONST REPLACE_ABORT       = -1
CONST REPLACE_LEAVE       = 0
CONST REPLACE_REPLACE     = 1
CONST REPLACEF_ALL        = 2


-> EXTCMD_GET_SCREENDATA
OBJECT dOpusScreenData
    screen:PTR TO screen        -> Screen pointer
    draw_info:PTR TO drawinfo   -> DrawInfo pointer
    depth:INT                   -> Screen depth
    pen_alloc:INT               -> Mask of allocated pens
    pen_array[16]:ARRAY OF INT  -> Pen array
    pen_count:INT               -> Number of pens
ENDOBJECT

-> EXTCMD_SEND_COMMAND
OBJECT command_packet
    command:PTR TO CHAR     -> Command to send
    flags:LONG              -> Command flags
    result:PTR TO CHAR      -> Will point to result string
    rc:LONG                 -> Return code
ENDOBJECT

CONST COMMANDF_RESULT     = 1
