/****h* AmigaTalk/ADOS4.c [3.0] ***************************************
*
* NAME
*    ADOS4.c
*
* DESCRIPTION
*    Very Dangerous DOS commands to use are in this file. <249>
*    ADOS1.c contains safe      DOS commands <246>,
*    ADOS2.c contains Unsafe    DOS commands <247> &
*    ADOS3.c contains Dangerous DOS commands <248>
*
* FUNCTIONAL INTERFACE:
*
*    PUBLIC OBJECT *HandleADosVD( int numargs, OBJECT **args );
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*
* NOTES
*    $VER: AmigaTalk:Src/ADOS4.c 3.0 (24-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/io.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <dos/dos.h>
#include <dos/dosextens.h>

#ifdef     __SASC
# include <clib/dos_protos.h>
#else

# define __USE_INLINE__

# include <proto/dos.h>

IMPORT struct DOSIFace *IDOS;

#endif

#include <utility/tagitem.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Constants.h"
#include "StringConstants.h"
#include "Object.h"

#include "FuncProtos.h"

#include "IStructs.h"

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT OBJECT *PrintArgTypeError( int primnumber );
IMPORT int     ChkArgCount( int need, int numargs, int primnumber );

IMPORT UBYTE *AllocProblem;
IMPORT UBYTE *UserProblem;
IMPORT UBYTE *ATalkProblem;

// ---------- From TagFuncs.c: ----------------------------------------

IMPORT struct TagItem *ArrayToTagList( OBJECT *inArray );

// --------------------------------------------------------------------

/****i* addSegment() [3.0] *********************************
*
* NAME
*    AddSegment - Adds a resident segment to the resident list 
*
* SYNOPSIS
*    BOOL success = AddSegment( char *segmentName, BPTR bptrSegList, LONG useCount );
*                   ^ <primitive 249 0 segmentName bptrSegList useCount>
* FUNCTION
*    Adds a segment to the Dos resident list, with the specified Seglist
*    and type (stored in seg_UC - normally 0).  NOTE: currently unused
*    types may cause it to interpret other registers (d4-?) as additional
*    parameters in the future.
*
*    Do NOT build Segment structures yourself!
************************************************************
*
*/

METHODFUNC OBJECT *addSegment( char *name, BPTR seglist, LONG useCount )
{
   if (!name || !seglist) // == NULL)
      return( o_nil );
      
   if (AddSegment( name, seglist, useCount ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* deleteFile() [3.0] *********************************
*
* NAME
*    DeleteFile -- Delete a file or directory
*
* SYNOPSIS
*    BOOL success = DeleteFile( char *fileOrDirName );
*                   ^ <primitive 249 1 fileOrDirName>
* FUNCTION
*    This attempts to delete the file or directory specified by 'name'.
*    An error is returned if the deletion fails. Note that all the files
*    within a directory must be deleted before the directory itself can
*    be deleted.
************************************************************
*
*/

METHODFUNC OBJECT *deleteFile( char *name )
{
   if (!name) // == NULL)
      return( o_nil );
      
   if (DeleteFile( name ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* doPacket() [3.0] ***********************************
*
* NAME
*    DoPkt -- Send a dos packet and wait for reply 
*
* SYNOPSIS
*    LONG result1 = DoPkt( struct MsgPort *port, LONG action,
*                          LONG arg1, LONG arg2, LONG arg3,
*                          LONG arg4, LONG arg5 );
*                   ^ <primitive 249 2 msgPort action arg1 arg2 arg3 arg4 arg5>
* FUNCTION
*    Sends a packet to a handler and waits for it to return.  Any secondary
*    return will be available in D1 AND from IoErr().  DoPkt() will work
*    even if the caller is an exec task and not a process; however it will
*    be slower, and may fail for some additional reasons, such as being
*    unable to allocate a signal.  DoPkt() uses your pr_MsgPort for the
*    reply, and will call pr_PktWait.  (See BUGS regarding tasks, though).
*
*    Only allows 5 arguments to be specified.  For more arguments (packets
*    support a maximum of 7) create a packet and use SendPkt()/WaitPkt().
*
* INPUTS
*    port    - pr_MsgPort of the handler process to send to.
*    action  - the action requested of the filesystem/handler
*    arg1, arg2, arg3, arg4,arg5 - arguments, depend on the action, may not
*          be required.
*
* RESULT
*    result1 - the value returned in dp_Res1, or FALSE if there was some
*              problem in sending the packet or recieving it.
*    result2 - Available from IoErr() AND in register D1.
*
* BUGS
*    Using DoPkt() from tasks doesn't work in V36. Use AllocDosObject(),
*    PutMsg(), and WaitPort()/GetMsg() for a workaround, or you can call
*    CreateNewProc() to start a process to do Dos I/O for you.  In V37,
*    DoPkt() will allocate, use, and free the MsgPort required.
*
* NOTES
*    Callable from a task (under V37 and above).
************************************************************
*
*/

METHODFUNC OBJECT *doPacket( struct MsgPort *port, 
                             LONG action,
                             LONG arg1, LONG arg2, LONG arg3,
                             LONG arg4, LONG arg5 
                           )
{
   LONG rval = 0L;
   
   if (!port) // == NULL)
      return( o_nil );
      
   rval = DoPkt( port, action, arg1, arg2, arg3, arg4, arg5 );

   if (rval == FALSE)
      return( o_false );
   else
      return( AssignObj( new_int( (int) rval ) ) );
}

/****i* format() [3.0] *************************************
*
* NAME
*    Format -- Causes a filesystem to initialize itself 
*
* SYNOPSIS
*    BOOL success = Format( char *filesystem, char *volumename,
*                           ULONG dostype );
*                   ^ <primitive 249 3 fileSystem volumeName dosType>
* FUNCTION
*    Interface for initializing new media on a device.  This causes the
*    filesystem to write out an empty disk structure to the media, which
*    should then be ready for use.  This assumes the media has been low-
*    level formatted and verified already.
*
*    The filesystem should be inhibited before calling Format() to make
*    sure you don't get an ERROR_OBJECT_IN_USE.
*
* INPUTS
*    filesystem - Name of device to be formatted.  ':' must be supplied.
*    volumename - Name for volume (if supported).  No ':'.
*    dostype    - Type of format, if filesystem supports multiple types.
*
* BUGS
*    Existed, but was non-functional in V36 dos.  (The volumename wasn't
*    converted to a BSTR.)  Workaround: require V37, or under V36
*    convert volumename to a BPTR to a BSTR before calling Format().
*    Note: a number of printed packet docs for ACTION_FORMAT are wrong
*    as to the arguments.
************************************************************
*
*/

METHODFUNC OBJECT *format( char  *filesystem, 
                           char  *volumename,
                           ULONG  dosType
                         )
{
   int length = 0;
   
   if (!filesystem || !volumename) // == NULL)
      return( o_nil );
   
   length = StringLength( volumename );
   
   if (volumename[ length ] == COLON_CHAR)
      volumename[ length ] = NIL_CHAR; // Strip colon from volumename

   length = StringLength( filesystem );
   
   if (filesystem[ length ] != COLON_CHAR)
      {
      char *newName = (char *) AT_AllocVec( length + 2, 
                                            MEMF_CLEAR | MEMF_ANY,
                                            "formatName", TRUE 
                                          );
      
      if (!newName) // == NULL)
         return( o_nil );
      else   
         {
         StringNCopy( newName, filesystem, length );
         StringCat( newName, ":" );
         } 
      
      if (Format( newName, volumename, dosType ) == FALSE)
         {
         AT_FreeVec( newName, "formatName", TRUE );

         return( o_false );
         }
      else
         {
         AT_FreeVec( newName, "formatName", TRUE );

         return( o_true );
         }
      }
   else
      {               
      if (Format( filesystem, volumename, dosType ) == FALSE)
         return( o_false );
      else
         return( o_true );
      }
}

/****i* internalLoadSeg() [3.0] ****************************
*
* NAME
*    InternalLoadSeg -- Low-level load routine 
*
* SYNOPSIS
*    BPTR seglist = InternalLoadSeg( BPTR  fh,
*                                    BPTR  table,
*                                    LONG *functionarray,
*                                    LONG *stack
*                                  );
*                   ^ <primitive 249 4 bptrFileHandle bptrTable funcArray stack>
* FUNCTION
*    Loads from fh.  Table is used when loading an overlay, otherwise
*    should be NULL.  Functionarray is a pointer to an array of functions.
*    Note that the current Seek position after loading may be at any point
*    after the last hunk loaded.  The filehandle will not be closed.  If a
*    stacksize is encoded in the file, the size will be stuffed in the
*    LONG pointed to by stack.  This LONG should be initialized to your
*    default value: InternalLoadSeg() will not change it if no stacksize
*    is found. Clears unused portions of Code and Data hunks (as well as
*    BSS hunks).  (This also applies to LoadSeg() and NewLoadSeg()).
* 
*    If the file being loaded is an overlaid file, this will return
*    -(seglist).  All other results will be positive.
* 
*    NOTE to overlay users: InternalLoadSeg() does NOT return seglist in
*    both D0 and D1, as LoadSeg does.  The current ovs.asm uses LoadSeg(),
*    and assumes returns are in D1.  We will support this for LoadSeg()
*    ONLY.
*
* INPUTS
*    fh            - Filehandle to load from.
*    table         - When loading an overlay, otherwise ignored.
*    functionarray - Array of function to be used for read, alloc, and free.
*       FuncTable[0] ->  Actual = ReadFunc(readhandle,buffer,length),DOSBase
*                   D0                D1         D2     D3      A6
*       FuncTable[1] ->  Memory = AllocFunc(size,flags), Execbase
*                   D0                 D0   D1      a6
*       FuncTable[2] ->  FreeFunc(memory,size), Execbase
*                            A1     D0     A6
*    stack         - Pointer to storage (ULONG) for stacksize.
************************************************************
*
*/
#ifdef __SASC
METHODFUNC OBJECT *internalLoadSeg( BPTR  fh,
                                    BPTR  table,
                                    LONG *functionarray,
                                    LONG *stack 
                                  )
{
   BPTR segList = 0; // NULL;
   
   if (!functionarray || !stack) // == NULL)
      return( o_nil );
      
   if (!(segList = InternalLoadSeg( fh, table, functionarray, stack ))) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) segList ) ) );
}
#endif

/****i* internalUnLoadSeg() [3.0] **************************
*
* NAME
*    InternalUnLoadSeg -- Unloads a seglist loaded with InternalLoadSeg() 
*
* SYNOPSIS
*    BOOL success = InternalUnLoadSeg( BPTR seglist,
*                                      void (*FreeFunc)( char *, ULONG )
*                                    );
*                   ^ <primitive 249 5 bptrSegList freeFuncPtr>
* FUNCTION
*    Unloads a seglist using freefunc to free segments.  Freefunc is called
*    as for InternalLoadSeg.  NOTE: will call Close() for overlaid
*    seglists.
*
* RESULT
*    success - returns whether everything went OK (since this may close
*         files).  Also returns FALSE if seglist was NULL.
************************************************************
*
*/
#ifdef __SASC
METHODFUNC OBJECT *internalUnLoadSeg( BPTR seglist,
                                      void (*FreeFunc)( char *, ULONG )
                                    )
{
   if (!seglist || !FreeFunc) // == NULL)
      return( o_nil );
      
   if (InternalUnLoadSeg( seglist, FreeFunc ) == FALSE)
      return( o_false );
   else
      return( o_true );
}
#endif

/****i* loadSeg() [3.0] ************************************
*
* NAME
*    LoadSeg -- Scatterload a loadable file into memory
*
* SYNOPSIS
*    BPTR seglist = LoadSeg( char *segmentName )
*                   ^ <primitive 249 6 segmentName>
* FUNCTION
*    The file 'name' should be a load module produced by the linker.
*    LoadSeg() scatterloads the CODE, DATA and BSS segments into memory,
*    chaining together the segments with BPTR's on their first words.
*    The end of the chain is indicated by a zero.  There can be any number
*    of segments in a file.  All necessary re-location is handled by
*    LoadSeg().
* 
*    In the event of an error any blocks loaded will be unloaded and a
*    NULL result returned.
* 
*    If the module is correctly loaded then the output will be a pointer
*    at the beginning of the list of blocks. Loaded code is unloaded via
*    a call to UnLoadSeg().
************************************************************
*
*/

METHODFUNC OBJECT *loadSeg( char *name )
{
   BPTR segList = 0; // NULL;
   
   if (!name) // == NULL)
      return( o_nil );
      
   if (!(segList = LoadSeg( name ))) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) segList ) ) );
}

/****i* newLoadSeg() [3.0] *********************************
*
* NAME
*    NewLoadSeg -- Improved version of LoadSeg for stacksizes 
*
* SYNOPSIS
*    BPTR seglist = NewLoadSeg( char *file, struct TagItem *tags );
*                   ^ <primitive 249 7 fileName tagArray>
* FUNCTION
*    Does a LoadSeg on a file, and takes additional actions based on the
*    tags supplied.
*
*    Clears unused portions of Code and Data hunks (as well as BSS hunks).
*    (This also applies to InternalLoadSeg() and LoadSeg()).
*
*    NOTE to overlay users: NewLoadSeg() does NOT return seglist in
*    both D0 and D1, as LoadSeg does.  The current ovs.asm uses LoadSeg(),
*    and assumes returns are in D1.  We will support this for LoadSeg()
*    ONLY.
*
* INPUTS
*    file - Filename of file to load
*    tags - pointer to tagitem array
*
* RESULT
*    seglist - Seglist loaded, or NULL
*
* BUGS
*    No tags are currently defined.
*
* SEE ALSO
*    LoadSeg(), UnLoadSeg(), InternalLoadSeg(), InternalUnLoadSeg()
************************************************************
*
*/
#ifdef __SASC
METHODFUNC OBJECT *newLoadSeg( char *file, OBJECT *tagArray )
{
   struct TagItem *tags    = NULL; 
   BPTR            segList = 0; // NULL;
   
   if (!file) // == NULL)
      return( o_nil );
      
   if ((tagArray) && (tagArray != o_nil))
      tags = ArrayToTagList( tagArray );

   if (!tags) // == NULL)
      {
      return( o_nil );
      }

   if ((segList = NewLoadSeg( file, tags )) == FALSE)
      {
      AT_FreeVec( tags, "loadSegTags", TRUE );
      
      return( o_nil );
      }
   else
      {
      AT_FreeVec( tags, "loadSegTags", TRUE );

      return( AssignObj( new_address( (ULONG) segList ) ) );
      }
}
#endif

/****i* remAssignList() [3.0] ******************************
*
* NAME
*    RemAssignList -- Remove an entry from a multi-dir assign 
*
* SYNOPSIS
*    BOOL success = RemAssignList( char *assignName, BPTR lock );
*                   ^ <primitive 249 8 assignName bptrLock>
* FUNCTION
*    Removes an entry from a multi-directory assign.  The entry removed is
*    the first one for which SameLock with 'lock' returns that they are on
*    the same object.  The lock for the entry in the list is unlocked (not
*    the entry passed in).
*
* BUGS
*    In V36 through V39.23 dos, it would fail to remove the first lock
*    in the assign.  Fixed in V39.24 dos (after the V39.106 kickstart).
************************************************************
*
*/

METHODFUNC OBJECT *remAssignList( char *name, BPTR lock )
{
   int length = 0;
   
   if (!name) // == NULL)
      return( o_nil );
   
   length = StringLength( name );
   
   if (name[ length ] == COLON_CHAR)
      name[ length ] = NIL_CHAR;

   if (RemAssignList( name, lock ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* remDosEntry() [3.0] ********************************
*
* NAME
*    RemDosEntry -- Removes a Dos List entry from it's list 
*
* SYNOPSIS
*    BOOL success = RemDosEntry( struct DosList *dlist );
*                   ^ <primitive 249 9 dosList>
* FUNCTION
*    This removes an entry from the Dos Device list.  The memory associated
*    with the entry is NOT freed.  NOTE: you must have locked the Dos List
*    with the appropriate flags before calling this routine.  Handler
*    writers should see the AddDosEntry() caveats about locking and use
*    a similar workaround to avoid deadlocks.
************************************************************
*
*/

METHODFUNC OBJECT *remDosEntry( struct DosList *dlist )
{
   if (!dlist) // == NULL)
      return( o_nil );
      
   if (RemDosEntry( dlist ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* remSegment() [3.0] *********************************
*
* NAME
*    RemSegment - Removes a resident segment from the resident list 
*
* SYNOPSIS
*    BOOL success = RemSegment( struct Segment *segment );
*                   ^ <primitive 249 10 segmentObject>
* FUNCTION
*    Removes a resident segment from the Dos resident segment list,
*    unloads it, and does any other cleanup required.  Will only succeed
*    if the seg_UC (usecount) is 0.
************************************************************
*
*/

METHODFUNC OBJECT *remSegment( struct Segment *segment )
{
   if (!segment) // == NULL)
      return( o_nil );
      
   if (RemSegment( segment ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* sendPkt() [3.0] ************************************
*
* NAME
*    SendPkt -- Sends a packet to a handler 
*
* SYNOPSIS
*    void SendPkt( struct DosPacket *packet, 
*                  struct MsgPort   *port,
*                  struct MsgPort   *replyport );
*                <primitive 249 11 dosPacket msgPort replyPort>
* FUNCTION
*    Sends a packet to a handler and does not wait.  All fields in the
*    packet must be initialized before calling this routine.  The packet
*    will be returned to replyport.  If you wish to use this with
*    WaitPkt(), use the address of your pr_MsgPort for replyport.
************************************************************
*
*/

METHODFUNC void sendPkt( struct DosPacket *packet, 
                         struct MsgPort   *port,
                         struct MsgPort   *replyport
                       )
{
   if (!packet || !port || !replyport) // == NULL)
      return;

   SendPkt( packet, port, replyport );
         
   return;
}

/****i* setConsoleTask() [3.0] *****************************
*
* NAME
*    SetConsoleTask -- Sets the default console for the process 
*
* SYNOPSIS
*    struct MsgPort *oldport = SetConsoleTask( struct MsgPort *port );
*                   ^ <primitive 249 12 msgPort>
* FUNCTION
*    Sets the default console task's port (pr_ConsoleTask) for the
*    current process.
************************************************************
*
*/

METHODFUNC OBJECT *setConsoleTask( struct MsgPort *port )
{
   struct MsgPort *rval = NULL;
   
   if (!port) // == NULL)
      return( o_nil );
      
   if (!(rval = SetConsoleTask( port ))) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* setFileSysTask() [3.0] *****************************
*
* NAME
*    SetFileSysTask -- Sets the default filesystem for the process 
*
* SYNOPSIS
*    struct MsgPort *oldport = SetFileSysTask( struct MsgPort *port );
*                   ^ <primitive 249 13 msgPort>
* FUNCTION
*    Sets the default filesystem task's port (pr_FileSystemTask) for the
*    current process.
************************************************************
*
*/

METHODFUNC OBJECT *setFileSysTask( struct MsgPort *port )
{
   struct MsgPort *rval = NULL;
   
   if (!port) // == NULL)
      return( o_nil );
      
   if (!(rval = SetFileSysTask( port ))) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* systemTagList() [3.0] ******************************
*
* NAME
*    SystemTagList -- Have a shell execute a command line 
*
* SYNOPSIS
*    LONG error = SystemTagList( char *command, struct TagItem *tags );
*                   ^ <primitive 249 14 command tagArray>
* FUNCTION
*    Similar to Execute(), but does not read commands from the input
*    filehandle.  Spawns a Shell process to execute the command, and
*    returns the returncode the command produced, or -1 if the command
*    could not be run for any reason.  The input and output filehandles
*    will not be closed by System, you must close them (if needed) after
*    System returns, if you specified them via SYS_Input or SYS_Output.
* 
*    By default the new process will use your current Input() and Output()
*    filehandles.  Normal Shell command-line parsing will be done
*    including redirection on 'command'.  The current directory and path
*    will be inherited from your process.  Your path will be used to find
*    the command (if no path is specified).
* 
*    Note that you may NOT pass the same filehandle for both SYS_Input
*    and SYS_Output.  If you want input and output to both be to the same
*    CON: window, pass a SYS_Input of a filehandle on the CON: window,
*    and pass a SYS_Output of NULL.  The shell will automatically set
*    the default Output() stream to the window you passed via SYS_Input,
*    by opening "*" on that handler.
* 
*    If used with the SYS_Asynch flag, it WILL close both it's input and
*    output filehandles after running the command (even if these were
*    your Input() and Output()!)
* 
*    Normally uses the boot (ROM) shell, but other shells can be specified
*    via SYS_UserShell and SYS_CustomShell.  Normally, you should send
*    things written by the user to the UserShell.  The UserShell defaults
*    to the same shell as the boot shell.
* 
*    The tags are passed through to CreateNewProc() (tags that conflict
*    with SystemTagList() will be filtered out).  This allows setting
*    things like priority, etc for the new process.  The tags that are
*    currently filtered out are:
* 
*       NP_Seglist
*       NP_FreeSeglist
*       NP_Entry
*       NP_Input
*       NP_Output
*       NP_CloseInput
*       NP_CloseOutput
*       NP_HomeDir
*       NP_Cli
*
* RESULT
*    error - 0 for success, result from command, or -1.  Note that on
*            error, the caller is responsible for any filehandles or other
*    things passed in via tags.  -1 will only be returned if
*    dos could not create the new shell.  If the command is not
*    found the shell will return an error value, normally
*    RETURN_ERROR.
************************************************************
*
*/

METHODFUNC OBJECT *systemTagList( char *command, OBJECT *tagArray )
{
   struct TagItem *tags    = NULL;
   LONG            errCode = 0L;
   
   if (!command) // == NULL)
      return( o_nil );

   if ((tagArray) && (tagArray != o_nil))
      tags = ArrayToTagList( tagArray );

   if (!tags) // == NULL)
      {
      return( o_nil );
      }

   if ((errCode = SystemTagList( command, tags )) == -1)
      {
      AT_FreeVec( tags, "systemTags", TRUE );

      return( o_false );
      }
   else if (errCode == 0)
      {
      AT_FreeVec( tags, "systemTags", TRUE );

      return( o_true );
      }
   else
      {
      AT_FreeVec( tags, "systemTags", TRUE );

      return( AssignObj( new_int( (int) errCode ) ) );
      }
}

/****i* unLoadSeg() [3.0] **********************************
*
* NAME
*    UnLoadSeg -- Unload a seglist previously loaded by LoadSeg()
*
* SYNOPSIS
*    void UnLoadSeg( BPTR seglist );
*               ^ <primitive 249 15 bptrSegList>
* FUNCTION
*    Unload a seglist loaded by LoadSeg().  'seglist' may be zero.
*    Overlaid segments will have all needed cleanup done, including
*    closing files.
************************************************************
*
*/

METHODFUNC OBJECT *unLoadSeg( BPTR seglist )
{
   if (!seglist) // == NULL)
      return( o_nil );
      
   UnLoadSeg( seglist );

   return( o_true );
}

/****i* waitPkt() [3.0] ************************************
*
* NAME
*    waitPkt -- Waits for a packet to arrive at your pr_MsgPort 
*
* SYNOPSIS
*    struct DosPacket *packet = WaitPkt( struct MsgPort *taskReplyPort );
*                               ^ <primitive 249 16 msgPort>
* FUNCTION
*    Waits for a packet to arrive at your pr_MsgPort.  If anyone has
*    installed a packet wait function in pr_PktWait, it will be called.
*    The message will be automatically GetMsg()ed so that it is no longer
*    on the port.  It assumes the message is a dos packet.  It is NOT
*    guaranteed to clear the signal for the port.
************************************************************
*
*/

METHODFUNC OBJECT *waitPkt( struct MsgPort *taskReplyPort )
{
   if (!taskReplyPort || (taskReplyPort == (struct MsgPort *) o_nil))
      return( o_nil );
      
   return( AssignObj( new_address( (ULONG) WaitPkt( taskReplyPort ) ) ) );
}

/****h* HandleADosVD() [3.0] *****************************************
*
* NAME
*    HandleADosSafeVD()
*
* DESCRIPTION
*    Translate primitives (249) to AmigaDOS commands to the OS.
********************************************************************
*
*/

PRIVATE BOOL LibOpened = FALSE;

PUBLIC OBJECT *HandleADosVD( int numargs, OBJECT **args )
{
#  ifdef __SASC
   IMPORT struct DosLibrary *DOSBase;
#  else
   IMPORT struct    Library *DOSBase;
#  endif

   OBJECT *rval = o_nil;
      
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 249 );
      return( rval );
      }
         
   if (!DOSBase) // == NULL)
      {
#     ifdef __SASC
      if (!(DOSBase = (struct DosLibrary *) OpenLibrary( DOSNAME, 44L )))
         return( rval );
#     else
      if ((DOSBase = OpenLibrary( DOSNAME, 50L )))
         {
	 if (!(IDOS = (struct DOSIFace *) GetInterface( DOSBase, "main", 1, NULL )))
	    {
	    CloseLibrary( DOSBase );
	    return( rval );
	    }
	 }
      else
         return( rval );
#     endif
      
      LibOpened = TRUE;
      }         

   switch (int_value( args[0] ))
      {
      case 0:  // success = AddSegment( char *segmentName, BPTR bptrSegList, LONG useCount );
               //    ^ <primitive 249 0 segmentName bptrSegList useCount>
         if (!is_string( args[1] ) || !is_address( args[2] )
                                   || !is_integer( args[3] ))
            (void) PrintArgTypeError( 249 );
         else
            rval = addSegment(      string_value( (STRING *) args[1] ),
                               (BPTR) addr_value( args[2] ),
                               (LONG)  int_value( args[3] )
                             );
         break;
         
      case 1:  // BOOL success = DeleteFile( char *fileOrDirName );
               //    ^ <primitive 249 1 fileOrDirName>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 249 );
         else
            rval = deleteFile( string_value( (STRING *) args[1] ) );

         break;
         
      case 2:  // LONG result1 = DoPkt( struct MsgPort *port, LONG action, LONG arg1,
               //                       LONG arg2, LONG arg3, LONG arg4, LONG arg5 );
               //    ^ <primitive 249 2 msgPort action arg1 arg2 arg3 arg4 arg5>
         if (ChkArgCount( 8, numargs, 249 ) != 0)
            return( ReturnError() );

         if (!is_address( args[1] ) || !is_integer( args[2] )
                                    || !is_integer( args[3] )
                                    || !is_integer( args[4] )
                                    || !is_integer( args[5] )
                                    || !is_integer( args[6] )
                                    || !is_integer( args[7] ))
            (void) PrintArgTypeError( 249 );
         else
            rval = doPacket( (struct MsgPort *) addr_value( args[1] ),
                                         (LONG)  int_value( args[2] ),
                                         (LONG)  int_value( args[3] ),
                                         (LONG)  int_value( args[4] ),
                                         (LONG)  int_value( args[5] ),
                                         (LONG)  int_value( args[6] ),
                                         (LONG)  int_value( args[7] )
                           );
         break;
         
      case 3:  // BOOL success = Format( char *filesystem, char *volumename, ULONG dostype );
               //    ^ <primitive 249 3 fileSystem volumeName dosType>
         if (!is_string( args[1] ) || !is_string(  args[2] )
                                   || !is_integer( args[3] ))
            (void) PrintArgTypeError( 249 );
         else
            rval = format(      string_value( (STRING *) args[1] ),
                                string_value( (STRING *) args[2] ),
                           (ULONG) int_value( args[3] )
                         );
         break;

#     ifdef __SASC
      case 4:  // BPTR seglist = InternalLoadSeg( BPTR  fh, BPTR  table, LONG *functionarray,
               //                                 LONG *stack );
               //    ^ <primitive 249 4 bptrFileHandle bptrTable funcArray stack>
         if (ChkArgCount( 5, numargs, 249 ) != 0)
            return( ReturnError() );

         if (!is_address( args[1] ) || !is_address( args[2] )
                                    || !is_integer( args[3] )
                                    || !is_integer( args[4] ))
            (void) PrintArgTypeError( 249 );
         else
            rval = internalLoadSeg(   (BPTR) addr_value( args[1] ),
                                      (BPTR) addr_value( args[2] ),
                                    (LONG *)  int_value( args[3] ),
                                    (LONG *)  int_value( args[4] ) 
                                  );
         break;
         
      case 5:  // success = InternalUnLoadSeg( BPTR seglist, void (*FreeFunc)( char *, ULONG )
               //    ^ <primitive 249 5 bptrSegList freeFuncPtr>
         if (!is_address( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 249 );
         else
            rval = internalUnLoadSeg( (BPTR) addr_value( args[1] ),
                                      (void (*)( char *, ULONG )) addr_value( args[2] )
                                    );
         break;
#     endif
         
      case 6:  // BPTR seglist = LoadSeg( char *segmentName )
               //    ^ <primitive 249 6 segmentName>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 249 );
         else
            rval = loadSeg( string_value( (STRING *) args[1] ) );

         break;

#     ifdef __SASC
      case 7:  // BPTR seglist = NewLoadSeg( char *file, struct TagItem *tags );
               //    ^ <primitive 249 7 fileName tagArray>
         if (!is_string( args[1] ) || !is_array( args[2] ))
            (void) PrintArgTypeError( 249 );
         else
            rval = newLoadSeg( string_value( (STRING *) args[1] ), args[2] );

         break;
#     endif
         
      case 8:  // BOOL success = RemAssignList( char *assignName, BPTR lock );
               //    ^ <primitive 249 8 assignName bptrLock>
         if (!is_string( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 249 );
         else
            rval = remAssignList(      string_value( (STRING *) args[1] ),
                                  (BPTR) addr_value( args[2] )
                                );
         break;
         
      case 9:  // BOOL success = RemDosEntry( struct DosList *dlist );
               //    ^ <primitive 249 9 dosList>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 249 );
         else
            rval = remDosEntry( (struct DosList *) addr_value( args[1] ) );
            
         break;
         
      case 10: // BOOL success = RemSegment( struct Segment *segment );
               //    ^ <primitive 249 10 segmentObject>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 249 );
         else
            rval = remSegment( (struct Segment *) addr_value( args[1] ) );
            
         break;
         
      case 11: // void SendPkt( struct DosPacket *packet, struct MsgPort *port,
               //               struct MsgPort   *replyport );
               //    <primitive 249 11 dosPacket msgPort replyPort>
         if (ChkArgCount( 4, numargs, 249 ) != 0)
            return( ReturnError() );

         if (!is_address( args[1] ) || !is_address( args[2] )
                                    || !is_address( args[3] ))
            (void) PrintArgTypeError( 249 );
         else
            sendPkt( (struct DosPacket *) addr_value( args[1] ),
                     (struct MsgPort   *) addr_value( args[2] ),
                     (struct MsgPort   *) addr_value( args[3] )
                   );
         break;
         
      case 12: // struct MsgPort *oldport = SetConsoleTask( struct MsgPort *port );
               //    ^ <primitive 249 12 msgPort>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 249 );
         else
            rval = setConsoleTask( (struct MsgPort *) addr_value( args[1] ) );
            
         break;
         
      case 13: // struct MsgPort *oldport = SetFileSysTask( struct MsgPort *port );
               //    ^ <primitive 249 13 msgPort>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 249 );
         else
            rval = setFileSysTask( (struct MsgPort *) addr_value( args[1] ) );
            
         break;
         
      case 14: // LONG error = SystemTagList( char *command, struct TagItem *tags );
               //    ^ <primitive 249 14 command tagArray>
         if (!is_string( args[1] ) || !is_array( args[2] ))
            (void) PrintArgTypeError( 249 );
         else
            rval = systemTagList( string_value( (STRING *) args[1] ), args[2] );

         break;
         
      case 15: // BOOL success = UnLoadSeg( BPTR seglist );
               //    ^ <primitive 249 15 bptrSegList>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 249 );
         else
            rval = unLoadSeg( (BPTR) addr_value( args[1] ) );
            
         break;
         
      case 16: // struct DosPacket *packet = WaitPkt( struct MsgPort *taskReplyPort );
               //    ^ <primitive 249 16 msgPort>
         rval = waitPkt( (struct MsgPort *) addr_value( args[1] ) );
         
         break;

      default:
         (void) PrintArgTypeError( 249 );
         break;
      }

   if (LibOpened == TRUE)
      {
#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IDOS );
      IDOS = NULL;
#     endif

      CloseLibrary( (struct Library *) DOSBase );
      LibOpened = FALSE;
      }

   return( rval );
}

/* ----------------------- END of ADOS4.c file! ------------------------ */
