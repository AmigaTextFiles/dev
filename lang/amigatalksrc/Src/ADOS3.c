/****h* AmigaTalk/ADOS3.c [3.0] ***************************************
*
* NAME
*    ADOS3.c
*
* DESCRIPTION
*    Relatively Dangerous DOS commands to use are in this file. <248>
*    ADOS1.c contains safe           DOS commands <246>,
*    ADOS2.c contains Unsafe         DOS commands <247> &
*    ADOS4.c contains Very Dangerous DOS commands <249>
*
*    PUBLIC OBJECT *HandleADosDanger( int numargs, OBJECT **args );
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*
* NOTES
*    $VER: AmigaTalk:Src/ADOS3.c 3.0 (24-Oct-2004) by J.T. Steichen
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
#include <dos/datetime.h>
#include <dos/exall.h>
#include <dos/notify.h>
#include <dos/rdargs.h>
#include <dos/record.h>
#include <dos/stdio.h>
#include <dos/var.h>
#include <dos/dosextens.h>

#ifndef __amigaos4__
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

// ---------- From TagFuncs.c: ----------------------------------------

IMPORT struct TagItem *ArrayToTagList( OBJECT *inArray );

// --------------------------------------------------------------------

/****i* addDosEntry() [3.0] ********************************
*
* NAME
*    AddDosEntry -- Add a Dos List entry to the lists 
*
* SYNOPSIS
*    LONG success = AddDosEntry( struct DosList *dlist );
*                   ^ <primitive 248 0 dosList>
* FUNCTION
*    Adds a device, volume or assign to the dos devicelist.  Can fail if it 
*    conflicts with an existing entry (such as another assign to the same
*    name or another device of the same name).  Volume nodes with different
*    dates and the same name CAN be added, or with names that conflict with
*    devices or assigns.  Note: the dos list does NOT have to be locked to
*    call this.  Do not access dlist after adding unless you have locked the
*    Dos Device list.
*
*    An additional note concerning calling this from within a handler:
*    in order to avoid deadlocks, your handler must either be multi-
*    threaded, or it must attempt to lock the list before calling this
*    function.  The code would look something like this:
*
*    if (AttemptLockDosList( LDF_xxx | LDF_WRITE ))
*       {
*       rc = AddDosEntry( ... );
*       UnLockDosList( LDF_xxx | LDF_WRITE );
*       }
*
*    If AttemptLockDosList() fails (i.e. it's locked already), check for
*    messages at your filesystem port (don't wait!) and try the
*    AttemptLockDosList() again.
************************************************************
*/

METHODFUNC OBJECT *addDosEntry( struct DosList *dl )
{
   if (!dl) // == NULL)
      return( o_nil );
      
   if (AddDosEntry( dl ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* allocDosObject() [3.0] *****************************
*
* NAME
*    AllocDosObject -- Creates a dos object 
*
* SYNOPSIS
*    void *ptr = AllocDosObject( ULONG type, struct TagItem *tags );
*                   ^ <primitive 248 1 type tags>
* FUNCTION
*    Create one of several dos objects, initializes it, and returns it
*    to you.  Note the DOS_STDPKT returns a pointer to the sp_Pkt of the
*    structure.
*
*    This function may be called by a task for all types and tags defined
*    in the V37 includes (DOS_FILEHANDLE through DOS_RDARGS and ADO_FH_Mode
*    through ADO_PromptLen, respectively).  Any future types or tags
*    will be documented as to whether a task may use them.
*
* BUGS
*    Before V39, DOS_CLI should be used with care since FreeDosObject()
*    can't free it.
************************************************************
*
*/

METHODFUNC OBJECT *allocDosObject( ULONG type, OBJECT *tagArray )
{
   struct TagItem *tags = NULL; 
   void           *rval = NULL;

   if (tagArray && (tagArray != o_nil))
      tags = ArrayToTagList( tagArray );

   // if (tags == NULL) NULL is valid!
   
   rval = AllocDosObject( type, tags );

   if (tags) // != NULL)    // Just in case FreeVec() changes.
      AT_FreeVec( tags, "allocDOSObjectTags", TRUE );

   if (!rval) // == NULL)
      return( o_false );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* attemptLockDosList() [3.0] *************************
*
* NAME
*    AttemptLockDosList -- Attempt to lock the Dos Lists for use 
*
* SYNOPSIS
*    struct DosList *dlist = AttemptLockDosList( ULONG flags );
*                   ^ <primitive 248 2 flags>
* FUNCTION
*    Locks the dos device list in preparation to walk the list.  If the
*    list is 'busy' then this routine will return NULL.  See LockDosList()
*    for more information.
*
* BUGS
*    In V36 through V39.23 dos, this would return NULL or 0x00000001 for
*    failure.  Fixed in V39.24 dos (after kickstart 39.106).
************************************************************
*
*/

METHODFUNC OBJECT *attemptLockDosList( ULONG flags )
{
   struct DosList *rval = AttemptLockDosList( flags );

   if (!rval) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* cliInitNewcli() [3.0] ******************************
*
* NAME
*    CliInitNewcli -- Set up a process to be a shell from initial packet
*
* SYNOPSIS
*    LONG flags = CliInitNewcli( struct DosPacket *packet );
*                   ^ <primitive 248 3 dosPacket>
* FUNCTION
*    This function initializes a process and CLI structure for a new
*    shell, from parameters in an initial packet passed by the system
*    (NewShell or NewCLI, etc).  The format of the data in the packet
*    is purposely not defined.  The setup includes all the normal fields
*    in the structures that are required for proper operation (current
*    directory, paths, input streams, etc).
*
*    It returns a set of flags containing information about what type
*    of shell invocation this is.
*
*    Definitions for the values of fn:
*       Bit 31     Set to indicate flags are valid
*       Bit  3     Set to indicate asynch system call
*       Bit  2     Set if this is a System() call
*       Bit  1     Set if user provided input stream
*       Bit  0     Set if RUN provided output stream
*
*    If Bit 31 is 0, then you must check IoErr() to determine if an error
*    occurred.  If IoErr() returns a pointer to your process, there has
*    been an error, and you should clean up and exit.  The packet will
*    have already been returned by CliInitNewcli().  If it isn't a pointer
*    to your process and Bit 31 is 0, reply the packet immediately.
*    (Note: this is different from what you do for CliInitRun().)
************************************************************
*
*/

METHODFUNC OBJECT *cliInitNewcli( struct DosPacket *dp )
{
   if (!dp) // == NULL)
      return( o_nil );
      
   return( AssignObj( new_int( (int) CliInitNewcli( dp ) ) ) );
}

/****i* cliInitRun() [3.0] *********************************
*
* NAME
*    CliInitRun -- Set up a process to be a shell from initial packet
*
* SYNOPSIS
*    LONG flags = CliInitRun( struct DosPacket *packet );
*                   ^ <primitive 248 4 dosPacket>
* FUNCTION
*    This function initializes a process and CLI structure for a new
*    shell, from parameters in an initial packet passed by the system
*    (Run, System(), Execute()).  The format of the data in the packet
*    is purposely not defined.  The setup includes all the normal fields
*    in the structures that are required for proper operation (current
*    directory, paths, input streams, etc).
*
*    It returns a set of flags containing information about what type
*    of shell invocation this is.
*
*    Definitions for the values of fn:
*       Bit 31     Set to indicate flags are valid
*       Bit  3     Set to indicate asynch system call
*       Bit  2     Set if this is a System() call
*       Bit  1     Set if user provided input stream
*       Bit  0     Set if RUN provided output stream
*
*    If Bit 31 is 0, then you must check IoErr() to determine if an error
*    occurred.  If IoErr() returns a pointer to your process, there has
*    been an error, and you should clean up and exit.  The packet will
*    have already been returned by CliInitNewcli().  If it isn't a pointer
*    to your process and Bit 31 is 0, you should wait before replying
*    the packet until after you've loaded the first command (or when you
*    exit).  This helps avoid disk "gronking" with the Run command.
*    (Note: this is different from what you do for CliInitNewcli().)
*
*    If Bit 31 is 1, then if Bit 3 is one, ReplyPkt() the packet
*    immediately (Asynch System()), otherwise wait until your shell exits
*    (Sync System(), Execute()).
*    (Note: this is different from what you do for CliInitNewcli().)
************************************************************
*
*/

METHODFUNC OBJECT *cliInitRun( struct DosPacket *dp )
{
   if (!dp) // == NULL)
      return( o_nil );
      
   return( AssignObj( new_int( (int) CliInitRun( dp ) ) ) );
}

/****i* createNewProc() [3.0] ******************************
*
* NAME
*    CreateNewProc -- Create a new process 
*
* SYNOPSIS
*    struct Process *process = CreateNewProc( struct TagItem *tags );
*                   ^ <primitive 248 5 tags>
* FUNCTION
*    This creates a new process according to the tags passed in.  See
*    dos/dostags.h for the tags.
*
*    You must specify one of NP_Seglist or NP_Entry.  NP_Seglist takes a
*    seglist (as returned by LoadSeg()).  NP_Entry takes a function
*    pointer for the routine to call.
*
*    There are many options, as you can see by examining dos/dostags.h.
*    The defaults are for a non-CLI process, with copies of your
*    CurrentDir, HomeDir (used for PROGDIR:), priority, consoletask,
*    windowptr, and variables.  The input and output filehandles default
*    to opens of NIL:, stack to 4000, and others as shown in dostags.h.
*    This is a fairly reasonable default setting for creating threads,
*    though you may wish to modify it (for example, to give a descriptive
*    name to the process.)
*
*    CreateNewProc() is callable from a task, though any actions that
*    require doing Dos I/O (DupLock() of currentdir, for example) will not
*    occur.
*
*    NOTE: if you call CreateNewProc() with both NP_Arguments, you must
*    not specify an NP_Input of NULL.  When NP_Arguments is specified, it
*    needs to modify the input filehandle to make ReadArgs() work properly.
*   
* RESULT
*    process - The created process, or NULL.  Note that if it returns
*         NULL, you must free any items that were passed in via
*         tags, such as if you passed in a new current directory
*         with NP_CurrentDir.
*
* BUGS
*    In V36, NP_Arguments was broken in a number of ways, and probably
*    should be avoided (instead you should start a small piece of your
*    own code, which calls RunCommand() to run the actual code you wish
*    to run).  In V37, NP_Arguments works, though see the note above.
************************************************************
*
*/

METHODFUNC OBJECT *createNewProc( OBJECT *tagArray )
{
   struct TagItem *tags = NULL; 
   struct Process *rval = NULL;

   if (tagArray && (tagArray != o_nil))
      tags = ArrayToTagList( tagArray );

   if (!tags) // == NULL) // at least one tag required!!
      {
      return( o_nil );
      }
   
   rval = CreateNewProc( tags );

   AT_FreeVec( tags, "createNewProcTags", TRUE );

   if (!rval) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* createProc() [3.0] *********************************
*
* NAME
*    CreateProc -- Create a new process
*
* SYNOPSIS
*    struct MsgPort *process = CreateProc( char *name,
*                                          LONG  pri,
*                                          BPTR  seglist,
*                                          LONG  stackSize );
*
*                   ^ <primitive 248 6 name pri segList stackSize>
* FUNCTION
*    CreateProc() creates a new AmigaDOS process of name 'name'.  AmigaDOS
*    processes are a superset of exec tasks.
*
*    A seglist, as returned by LoadSeg(), is passed as 'seglist'.
*    This represents a section of code which is to be run as a new
*    process. The code is entered at the first hunk in the segment list,
*    which should contain suitable initialization code or a jump to
*    such.  A process control structure is allocated from memory and
*    initialized.  If you wish to fake a seglist (that will never
*    have DOS UnLoadSeg() called on it), use this code:
*
*           DS.L    0   ;Align to longword
*           DC.L    16   ;Segment "length" (faked)
*           DC.L    0   ;Pointer to next segment
*           ...start of code...
*
*    The size of the root stack upon activation is passed as
*    'stackSize'.  'pri' specifies the required priority of the new
*    process.  The result will be the process msgport address of the new
*    process, or zero if the routine failed.  The argument 'name'
*    specifies the new process name.  A zero return code indicates
*    error.
*
*    The seglist passed to CreateProc() is not freed when it exits; it
*    is up to the parent process to free it, or for the code to unload
*    itself.
*
*    Under V36 and later, you probably should use CreateNewProc() instead.
************************************************************
*
*/

METHODFUNC OBJECT *createProc( char *name, 
                               LONG  pri, 
                               BPTR  seglist, 
                               LONG  stackSize
                             )
{
   struct MsgPort *rval = NULL;

   if (!seglist || !name || (stackSize < 1) || ((stackSize % 4) != 0))
      return( o_nil );
      
   if (!(rval = CreateProc( name, pri, seglist, stackSize ))) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* deleteVar() [3.0] **********************************
*
* NAME
*    DeleteVar -- Deletes a local or environment variable 
*
* SYNOPSIS
*    BOOL success = DeleteVar( char *varName, ULONG flags ); 
*                   ^ <primitive 248 7 varName flags>
* FUNCTION
*    Deletes a local or environment variable.
*
* BUGS
*    LV_VAR is the only type that can be global
************************************************************
*
*/

METHODFUNC OBJECT *deleteVar( char *name, ULONG flags )
{
   if (!name) // == NULL)
      return( o_nil );
      
   if (DeleteVar( name, flags ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* deviceProc() [3.0] *********************************
*
* NAME
*    DeviceProc -- Return the process MsgPort of specific I/O handler
*
* SYNOPSIS
*    struct MsgPort *process = DeviceProc( char *deviceName );
*                   ^ <primitive 248 8 deviceName>
* FUNCTION
*    DeviceProc() returns the process identifier of the process which
*    handles the device associated with the specified name. If no
*    process handler can be found then the result is zero. If the name
*    refers to an assign then a directory lock is returned in IoErr().
*    This lock should not be UnLock()ed or Examine()ed (if you wish to do
*    so, DupLock() it first).
*
* BUGS
*    In V36, if you try to DeviceProc() something relative to an assign
*    made with AssignPath(), it will fail.  This is because there's no
*    way to know when to unlock the lock.  If you're writing code for
*    V36 or later, it is highly advised you use GetDeviceProc() instead,
*    or make your code conditional on V36 to use GetDeviceProc()/
*    FreeDeviceProc().
************************************************************
*
*/

METHODFUNC OBJECT *deviceProc( char *name )
{
   struct MsgPort *rval = NULL;
   
   if (!name) // == NULL)
      return( o_nil );
      
   if (!(rval = DeviceProc( name ))) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* exitProgram() [3.0] ********************************
*
* NAME
*    Exit -- Exit from a program
*
* SYNOPSIS
*    void Exit( LONG returnCode );
*                   <primitive 248 9 returnCode>
* FUNCTION
*    Exit() is currently for use with programs written as if they
*    were BCPL programs.  This function is not normally useful for
*    other purposes.
*
*    In general, therefore, please DO NOT CALL THIS FUNCTION!
*
*    In order to exit, C programs should use the C language exit()
*    function (note the lower case letter "e").  Assembly programs should
*    place a return code in D0, and execute an RTS instruction with
*    their original stack ptr.
*
* IMPLEMENTATION
*    The action of Exit() depends on whether the program which called it
*    is running as a command under a CLI or not. If the program is
*    running under the CLI the command finishes and control reverts to
*    the CLI. In this case, returnCode is interpreted as the return code
*    from the program.
*
*    If the program is running as a distinct process, Exit() deletes the
*    process and release the space associated with the stack, segment
*    list and process structure.
************************************************************
*
*/

#ifdef     __SASC
METHODFUNC void exitProgram( LONG returnCode )
{
   Exit( returnCode );
   
   return;
}
#endif

/****i* freeArgs() [3.0] ***********************************
*
* NAME
*    FreeArgs - Free allocated memory after ReadArgs() 
*
* SYNOPSIS
*    void FreeArgs( struct RDArgs *rdArgs );
*                   <primitive 248 10 rdArgs>
* FUNCTION
*    Frees memory allocated to return arguments in from ReadArgs().  If
*    ReadArgs allocated the RDArgs structure it will be freed.  If NULL
*    is passed in this function does nothing.
************************************************************
*
*/

METHODFUNC void freeArgs( struct RDArgs *rdargs )
{
   FreeArgs( rdargs );

   return;
}

/****i* freeDeviceProc() [3.0] *****************************
*
* NAME
*    FreeDeviceProc -- Releases port returned by GetDeviceProc() 
*
* SYNOPSIS
*    void FreeDeviceProc( struct DevProc *devProc );
*                   <primitive 248 11 devProc>
* FUNCTION
*    Frees up the structure created by GetDeviceProc(), and any associated
*    temporary locks.
*
*    Decrements the counter incremented by GetDeviceProc().  The counter
*    is in an extension to the 1.3 process structure.  After calling
*    FreeDeviceProc(), do not use the port or lock again!  It is safe to
*    call FreeDeviceProc( NULL ).
************************************************************
*
*/

METHODFUNC void freeDeviceProc( struct DevProc *devproc )
{
   FreeDeviceProc( devproc );
      
   return;
}

/****i* freeDosEntry() [3.0] *******************************
*
* NAME
*    FreeDosEntry -- Frees an entry created by MakeDosEntry 
*
* SYNOPSIS
*    void FreeDosEntry( struct DosList *dlist );
*                   <primitive 248 12 dosList>
* FUNCTION
*    Frees an entry created by MakeDosEntry().  This routine should be
*    eliminated and replaced by a value passed to FreeDosObject()!
************************************************************
*
*/

METHODFUNC void freeDosEntry( struct DosList *dlist )
{
   if (dlist) // != NULL)
      FreeDosEntry( dlist );
      
   return;
}

/****i* freeDosObject() [3.0] ******************************
*
* NAME
*    FreeDosObject -- Frees an object allocated by AllocDosObject() 
*
* SYNOPSIS
*    void FreeDosObject( ULONG type, void *dosObject );
*                    <primitive 248 13 type dosObject>
* FUNCTION
*    Frees an object allocated by AllocDosObject().  Do NOT call for
*    objects allocated in any other way.
*
* BUGS
*    Before V39, DOS_CLI objects will only have the struct
*    CommandLineInterface freed, not the strings it points to.  This
*    is fixed in V39 dos.  Before V39, you can workaround this bug by
*    using FreeVec() on cli_SetName, cli_CommandFile, cli_CommandName,
*    and cli_Prompt, and then setting them all to NULL.  In V39 or
*    above, do NOT use the workaround.
************************************************************
*
*/

METHODFUNC void freeDosObject( ULONG type, char *ptr )
{
   if (!ptr) // == NULL)
      return;
         
   FreeDosObject( type, (void *) ptr );
   
   return;
}

/****i* fWrite() [3.0] *************************************
*
* NAME
*    FWrite -- Writes a number of blocks to an output (buffered) 
*
* SYNOPSIS
*    LONG count = FWrite( BPTR fh, char *aBuffer, ULONG blocklen, ULONG blockCount )
*                   ^ <primitive 248 14 bptrFileHandle aBuffer blockLen blockCount>
* FUNCTION
*    Attempts to write a number of blocks, each blocklen long, from the
*    specified buffer to the output stream.  May return less than the
*    number of blocks requested, if there is some error such as a full
*    disk or r/w error.  This call is buffered.
*
* RESULT
*    count - Number of _blocks_ written.  On an error, the number of
*            blocks actually written is returned.
************************************************************
*
*/

METHODFUNC OBJECT *fWrite( BPTR fh, char *buf, ULONG blocklen, ULONG blocks )
{
   LONG count = 0L;
   
   if (!buf || (blocklen < 1) || (blocks < 1))
      return( o_nil );
      
   SetIoErr( 0 );   
      
   count = FWrite( fh, buf, blocklen, blocks );
   
   if (IoErr() != 0)
      {
      // Do a UserInfo() here????
      return( o_nil );
      }
   else
      return( AssignObj( new_int( (int) count ) ) );
}

/****i* inhibit() [3.0] ************************************
*
* NAME
*    Inhibit -- Inhibits access to a filesystem 
*
* SYNOPSIS
*    BOOL success = Inhibit( char *fileSystem, LONG flag );
*                   ^ <primitive 248 15 fileSystem flag>
* FUNCTION
*    Sends an ACTION_INHIBIT packet to the indicated handler.  This stops
*    all activity by the handler until uninhibited.  When uninhibited,
*    anything may have happened to the disk in the drive, or there may no
*    longer be one.
*
* INPUTS
*    filesystem - Name of device to inhibit (with ':')
*    flag       - New status.  DOSTRUE = inhibited,
*                                FALSE = uninhibited
************************************************************
*
*/

METHODFUNC OBJECT *inhibit( char *system, LONG flag )
{
   int length = 0;
   
   if (!system) // == NULL)
      return( o_nil );
   
   length = StringLength( system );

   if (flag == TRUE)
      flag = DOSTRUE;
            
   if (system[ length ] != COLON_CHAR)
      {
      char newSys[ 512 ];
      
      if (length >= 512)
         {
         return( o_nil ); // Something very wrong here!
         }
      else
         {
         StringCopy( newSys, system );
         StringCat( newSys, ":" );

         if (Inhibit( newSys, flag ) == FALSE)
            return( o_false );
         else
            return( o_true );
         }
      }
   else
      {
      if (Inhibit( system, flag ) == FALSE)
         return( o_false );
      else
         return( o_true );
      }
}

/****i* replyPkt() [3.0] ***********************************
*
* NAME
*    ReplyPkt -- replies a packet to the person who sent it to you 
*
* SYNOPSIS
*    void ReplyPkt( struct DosPacket *dosPacket, LONG result1, LONG result2 );
*                   <primitive 248 16 dosPacket result1 result2>
* FUNCTION
*    This returns a packet to the process which sent it to you.  In
*    addition, puts your pr_MsgPort address in dp_Port, so using ReplyPkt()
*    again will send the message to you.  (This is used in "ping-ponging"
*    packets between two processes).  It uses result 1 & 2 to set the
*    dp_Res1 and dp_Res2 fields of the packet.
************************************************************
*
*/

METHODFUNC void replyPkt( struct DosPacket *packet, LONG result1, LONG result2 )
{
   if (!packet) // == NULL)
      return;
         
   ReplyPkt( packet, result1, result2 );
   
   return;
}

/****i* runCommand() [3.0] *********************************
*
* NAME
*    RunCommand -- Runs a program using the current process 
*
* SYNOPSIS
*    LONG rc = RunCommand( BPTR segList, ULONG stackSsize,
*                          char *argString, ULONG argSize );
*                   ^ <primitive 248 17 segList stackSize argString argSize>
* FUNCTION
*    Runs a command on your process/cli.  Seglist may be any language,
*    including BCPL programs.  Stacksize is in bytes.  argptr is a null-
*    terminated string, argsize is its length.  Returns the returncode the
*    program exited with in d0. Returns -1 if the stack couldn't be
*    allocated.
* 
*    NOTE: the argument string MUST be terminated with a newline to work
*    properly with ReadArgs() and other argument parsers.
* 
*    RunCommand also takes care of setting up the current input filehandle
*    in such a way that ReadArgs() can be used in the program, and restores
*    the state of the buffering before returning.  It also sets the value
*    returned by GetArgStr(), and restores it before returning.  NOTE:
*    the setting of the argument string in the filehandle was added in V37.
* 
*    It's usually appropriate to set the command name (via
*    SetProgramName()) before calling RunCommand().  RunCommand() sets
*    the value returned by GetArgStr() while the command is running.
************************************************************
*
*/

METHODFUNC OBJECT *runCommand( BPTR   seglist, 
                               ULONG  stacksize,
                               char  *argptr, 
                               ULONG  argsize
                             )
{
   LONG rc = 0L;
   
   if (!seglist) // == NULL)
      return( o_nil );
      
   if ((rc = RunCommand( seglist, stacksize, argptr, argsize )) == -1)
      return( o_false );
   else
      return( AssignObj( new_int( (int) rc ) ) );
}

/****i* seekFile() [3.0] ***********************************
*
* NAME
*    Seek -- Set the current position for reading and writing
*
* SYNOPSIS
*    LONG oldPosition = Seek( BPTR file, LONG position, LONG mode );
*                   ^ <primitive 248 18 bptrFileHandle position mode>
* FUNCTION
*    Seek() sets the read/write cursor for the file 'file' to the
*    position 'position'. This position is used by both Read() and
*    Write() as a place to start reading or writing. The result is the
*    current absolute position in the file, or -1 if an error occurs, in
*    which case IoErr() can be used to find more information. 'mode' can
*    be OFFSET_BEGINNING, OFFSET_CURRENT or OFFSET_END. It is used to
*    specify the relative start position. For example, 20 from current
*    is a position 20 bytes forward from current, -20 is 20 bytes back
*    from current.
* 
*    So that to find out where you are, seek zero from current. The end
*    of the file is a Seek() positioned by zero from end. You cannot
*    Seek() beyond the end of a file.
*
* BUGS
*    The V36 and V37 ROM filesystem (and V36/V37 l:fastfilesystem)
*    returns the current position instead of -1 on an error.  It sets
*    IoErr() to 0 on success, and an error code on an error.  This bug
*    was fixed in the V39 filesystem.
************************************************************
*
*/

METHODFUNC OBJECT *seekFile( BPTR file, LONG position, LONG mode )
{
   return( AssignObj( new_int( (int) Seek( file, position, mode ))));
}

/****i* selectInput() [3.0] ********************************
*
* NAME
*    SelectInput -- Select a filehandle as the default input channel 
*
* SYNOPSIS
*    BPTR old_fh = SelectInput( BPTR fh );
*                   ^ <primitive 248 19 bptrFileHandle>
* FUNCTION
*    Set the current input as the default input for the process.
*    This changes the value returned by Input().  old_fh should
*    be closed or saved as needed.
************************************************************
*
*/

METHODFUNC OBJECT *selectInput( BPTR fh )
{
   return( AssignObj( new_address( (ULONG) SelectInput( fh ))));
}

/****i* selectOutput() [3.0] *******************************
*
* NAME
*    SelectOutput -- Select a filehandle as the default output channel 
*
* SYNOPSIS
*    BPTR old_fh = SelectOutput( BPTR fh )
*                   ^ <primitive 248 20 bptrFileHandle>
* FUNCTION
*    Set the current output as the default output for the process.
*    This changes the value returned by Output().  old_fh should
*    be closed or saved as needed.
************************************************************
*
*/

METHODFUNC OBJECT *selectOutput( BPTR fh )
{
   return( AssignObj( new_address( (ULONG) SelectOutput( fh ) ) ) );
}

/****i* setArgStr() [3.0] **********************************
*
* NAME
*    SetArgStr -- Sets the arguments for the current process 
*
* SYNOPSIS
*    BOOL success oldptr = SetArgStr( char *argString );
*                          ^ <primitive 248 21 argString>
* FUNCTION
*    Sets the arguments for the current program.  The ptr MUST be reset
*    to it's original value before process exit.
************************************************************
*
*/

METHODFUNC OBJECT *setArgStr( char *newStr )
{
   if (!newStr) // == NULL)
      return( o_nil );
   
   if (SetArgStr( newStr ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* setFileSize() [3.0] ********************************
*
* NAME
*    SetFileSize -- Sets the size of a file 
*
* SYNOPSIS
*    LOMNG newsize = SetFileSize( BPTR fh, LONG offset, LONG mode );
*                   ^ <primitive 248 22 bptrFileHandle offset mode>
* FUNCTION
*    Changes the file size, truncating or extending as needed.  Not all
*    handlers may support this; be careful and check the return code.  If
*    the file is extended, no values should be assumed for the new bytes.
*    If the new position would be before the filehandle's current position
*    in the file, the filehandle will end with a position at the
*    end-of-file.  If there are other filehandles open onto the file, the
*    new size will not leave any filehandle pointing past the end-of-file.
*    You can check for this by looking at the new size (which would be
*    different than what you requested).
* 
*    The seek position should not be changed unless the file is made
*    smaller than the current seek position.  However, see BUGS.
* 
*    Do NOT count on any specific values to be in any extended area.
*
* BUGS
*    The RAM: filesystem and the normal Amiga filesystem act differently
*    in where the file position is left after SetFileSize().  RAM: leaves
*    you at the new end of the file (incorrectly), while the Amiga ROM
*    filesystem leaves the seek position alone, unless the new position
*    is less than the current position, in which case you're left at the
*    new EOF.
* 
*    The best workaround is to not make any assumptions about the seek
*    position after SetFileSize().   
************************************************************
*
*/

METHODFUNC OBJECT *setFileSize( BPTR fh, LONG offset, LONG mode )
{
   LONG rval = 0L;
   
   if ((rval = SetFileSize( fh, offset, mode )) == -1)
      return( o_false );
   else
      return( AssignObj( new_int( (int) rval ) ) );
}

/****i* setVBuf() [3.0] ************************************
*
* NAME
*    SetVBuf -- set buffering modes and size (V39)
*
* SYNOPSIS
*    LONG error = SetVBuf( BPTR fh, char *aBuffer, LONG type, LONG size );
*                   ^ <primitive 248 23 bptrFileHandle aBuffer type size>
* FUNCTION
*    Changes the buffering modes and buffer size for a filehandle.
*    With buff == NULL, the current buffer will be deallocated and a
*    new one of (approximately) size will be allocated.  If buffer is
*    non-NULL, it will be used for buffering and must be at least
*    max(size,208) bytes long, and MUST be longword aligned.  If size
*    is -1, then only the buffering mode will be changed.
* 
*    Note that a user-supplied buffer will not be freed if it is later
*    replaced by another SetVBuf() call, nor will it be freed if the
*    filehandle is closed.
* 
*    Has no effect on the buffersize of filehandles that were not created
*    by AllocDosObject().
*
* RESULT
*    error - 0 if successful.  NOTE: opposite of most dos functions!
*       NOTE: fails if someone has replaced the buffer without
*       using SetVBuf() - RunCommand() does this.  Remember to
*       check error before freeing user-supplied buffers!
************************************************************
*
*/

METHODFUNC OBJECT *setVBuf( BPTR fh, char *buff, LONG type, LONG size )
{
   LONG chk = (LONG) buff;
   
   if (!buff || ((chk % 4) != 0))
      return( o_nil );
      
   if (SetVBuf( fh, buff, type, size ) == FALSE)
      return( o_true );
   else
      return( o_false );
}

/****i* writeFile() [3.0] **********************************
*
* NAME
*    Write -- Write bytes of data to a file
*
* SYNOPSIS
*    LONG returnedLength =  Write( BPTR file, void *aBuffer, LONG length );
*                   ^ <primitive 248 24 bptrFileHandle aBuffer length>
* FUNCTION
*    Write() writes bytes of data to the opened file 'file'. 'length'
*    indicates the length of data to be transferred; 'buffer' is a
*    pointer to the buffer. The value returned is the length of
*    information actually written. So, when 'length' is greater than
*    zero, the value of 'length' is the number of characters written.
*    Errors are indicated by a value of -1.
*
*    Note: this is an unbuffered routine (the request is passed directly
*    to the filesystem.)  Buffered I/O is more efficient for small
*    reads and writes; see FPutC().
************************************************************
*
*/

METHODFUNC OBJECT *writeFile( BPTR file, void *buffer, LONG length )
{
   LONG rval = 0L;
   
   if (!buffer || (length < 1))
      return( o_nil );
      
   if ((rval = Write( file, buffer, length )) == -1)
      return( o_false );
   else
      return( AssignObj( new_int( (int) rval ) ) );
}

/****h* HandleADosDanger() [3.0] ***********************************
*
* NAME
*    HandleADosDanger()
*
* DESCRIPTION
*    Translate primitives (248) to AmigaDOS commands to the OS.
********************************************************************
*
*/

PRIVATE BOOL LibOpened = FALSE;

PUBLIC OBJECT *HandleADosDanger( int numargs, OBJECT **args )
{
#  ifdef __SASC
   IMPORT struct DosLibrary *DOSBase;
#  else 
   IMPORT struct    Library *DOSBase;
#  endif
   
   OBJECT *rval = o_nil;
      
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 248 );

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
      case 0:  // LONG success = AddDosEntry( struct DosList *dlist );
               //   ^ <primitive 248 0 dosList>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 248 );
         else
            rval = addDosEntry( (struct DosList *) addr_value( args[1] ) );

         break;
               
      case 1:  // void *ptr = AllocDosObject( ULONG type, struct TagItem *tags );
               //   ^ <primitive 248 1 type tags>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 248 );
         else
            rval = allocDosObject( (ULONG) int_value( args[1] ), args[2] );
         break;

      case 2:  // struct DosList *dlist = AttemptLockDosList( ULONG flags );
               //   ^ <primitive 248 2 flags>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 248 );
         else
            rval = attemptLockDosList( (ULONG) int_value( args[1] ) );

         break;
         
      case 3:  // LONG flags = CliInitNewcli( struct DosPacket *packet );
               //   ^ <primitive 248 3 dosPacket>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 248 );
         else
            rval = cliInitNewcli( (struct DosPacket *) addr_value( args[1] ) );

         break;

      case 4:  // LONG flags = CliInitRun( struct DosPacket *packet );
               //   ^ <primitive 248 4 dosPacket>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 248 );
         else
            rval = cliInitRun( (struct DosPacket *) addr_value( args[1] ) );

         break;
         
      case 5:  // struct Process *process = CreateNewProc( struct TagItem *tags );
               //   ^ <primitive 248 5 tags>
         if (is_array( args[1] ) == FALSE)
            (void) PrintArgTypeError( 248 );
         else
            rval = createNewProc( args[1] );

         break;
         
      case 6:  // struct MsgPort *process = CreateProc( char *name, LONG pri, BPTR seglist,
               //                                       LONG  stackSize );
               //   ^ <primitive 248 6 name pri segList stackSize>
         if (ChkArgCount( 5, numargs, 248 ) != 0)
            return( ReturnError() );

         if (!is_string( args[1] ) || !is_integer( args[2] )
                                   || !is_address( args[3] )
                                   || !is_integer( args[4] ))
            (void) PrintArgTypeError( 248 );
         else
            rval = createProc(      string_value( (STRING *) args[1] ),
                               (LONG)  int_value( args[2] ),
                               (BPTR) addr_value( args[3] ),
                               (LONG)  int_value( args[4] )
                             ); 
         break;
         
      case 7:  // BOOL success = DeleteVar( char *varName, ULONG flags ); 
               //   ^ <primitive 248 7 varName flags>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 248 );
         else
            rval = deleteVar(      string_value( (STRING *) args[1] ),
                              (ULONG) int_value( args[2] )
                            ); 
         break;
         
      case 8:  // struct MsgPort *process = DeviceProc( char *deviceName );
               //   ^ <primitive 248 8 deviceName>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 248 );
         else
            rval = deviceProc( string_value( (STRING *) args[1] ) );

         break;

#     ifdef __SASC
      case 9:  // void Exit( LONG returnCode );
               //   <primitive 248 9 returnCode>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 248 );
         else
            exitProgram( (LONG) int_value( args[1] ) );

         break;
#     endif
         
      case 10: // void FreeArgs( struct RDArgs *rdArgs );
               //   <primitive 248 10 rdArgs>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 248 );
         else
            freeArgs( (struct RDArgs *) addr_value( args[1] ) );

         break;
         
      case 11: // void FreeDeviceProc( struct DevProc *devProc );
               //   <primitive 248 11 devProc>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 248 );
         else
            freeDeviceProc( (struct DevProc *) addr_value( args[1] ) );

         break;
         
      case 12: // void FreeDosEntry( struct DosList *dlist );
               //   <primitive 248 12 dosList>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 248 );
         else
            freeDosEntry( (struct DosList *) addr_value( args[1] ) );

         break;
         
      case 13: // void FreeDosObject( ULONG type, void *dosObject );
               //   <primitive 248 13 type dosObject>
         if (!is_integer( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 248 );
         else
            freeDosObject(  (ULONG)  int_value( args[1] ),
                           (char *) addr_value( args[2] )
                         ); 
         break;
         
      case 14: // LONG count = FWrite( BPTR fh, char *aBuffer, ULONG blocklen, ULONG blockCount
               //   ^ <primitive 248 14 bptrFileHandle aBuffer blockLen blockCount>
         if (ChkArgCount( 5, numargs, 248 ) != 0)
            return( ReturnError() );

         if (!is_address( args[1] ) || !is_string(  args[2] )
                                    || !is_integer( args[3] )
                                    || !is_integer( args[4] ))
            (void) PrintArgTypeError( 248 );
         else
            rval = fWrite(  (BPTR) addr_value( args[1] ),
                                 string_value( (STRING *) args[2] ),
                           (ULONG)  int_value( args[3] ),
                           (ULONG)  int_value( args[4] )
                         ); 
         break;
         
      case 15: // BOOL success = Inhibit( char *fileSystem, LONG flag );
               //   ^ <primitive 248 15 fileSystem flag>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 248 );
         else
            rval = inhibit(     string_value( (STRING *) args[1] ),
                            (LONG) int_value( args[2] )
                          ); 
         break;
         
      case 16: // void ReplyPkt( struct DosPacket *dosPacket, LONG result1, LONG result2 );
               //   <primitive 248 16 dosPacket result1 result2>
         if (!is_address( args[1] ) || !is_integer( args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 248 );
         else
            replyPkt( (struct DosPacket *) addr_value( args[1] ),
                                    (LONG)  int_value( args[2] ),
                                    (LONG)  int_value( args[3] )
                    ); 
         break;
         
      case 17: // LONG rc = RunCommand( BPTR segList, ULONG stackSize,
               //                       char *argString, ULONG argSize );
               //   ^ <primitive 248 17 segList stackSize argString argSize>
         if (ChkArgCount( 5, numargs, 248 ) != 0)
            return( ReturnError() );

         if (!is_address( args[1] ) || !is_integer( args[2] )
                                    || !is_string(  args[3] )
                                    || !is_integer( args[4] ))
            (void) PrintArgTypeError( 248 );
         else
            rval = runCommand(  (BPTR) addr_value( args[1] ),
                               (ULONG)  int_value( args[2] ),
                                     string_value( (STRING *) args[3] ),
                               (ULONG)  int_value( args[4] )
                             ); 
         break;
         
      case 18: // LONG oldPosition = Seek( BPTR file, LONG position, LONG mode );
               //   ^ <primitive 248 18 bptrFileHandle position mode>
         if (!is_address( args[1] ) || !is_integer( args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 248 );
         else
            rval = seekFile( (BPTR) addr_value( args[1] ),
                             (LONG)  int_value( args[2] ),
                             (LONG)  int_value( args[3] )
                           ); 
         break;
         
      case 19: // BPTR old_fh = SelectInput( BPTR fh );
               //   ^ <primitive 248 19 bptrFileHandle>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 248 );
         else
            rval = selectInput( (BPTR) addr_value( args[1] ) );

         break;
         
      case 20: // BPTR old_fh = SelectOutput( BPTR fh )
               //   ^ <primitive 248 20 bptrFileHandle>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 248 );
         else
            rval = selectOutput( (BPTR) addr_value( args[1] ) );

         break;
         
      case 21: // char *oldptr = SetArgStr( char *argString );
               //   ^ <primitive 248 21 argString>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 248 );
         else
            rval = setArgStr( string_value( (STRING *) args[1] ) );

         break;
         
      case 22: // LONG newsize = SetFileSize( BPTR fh, LONG offset, LONG mode );
               //   ^ <primitive 248 22 bptrFileHandle offset mode>
         if (!is_address( args[1] ) || !is_integer( args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 248 );
         else
            rval = setFileSize( (BPTR) addr_value( args[1] ),
                                (LONG)  int_value( args[2] ),
                                (LONG)  int_value( args[3] )
                              ); 
         break;
         
      case 23: // LONG error = SetVBuf( BPTR fh, char *aBuffer, LONG type, LONG size );
               //   ^ <primitive 248 23 bptrFileHandle aBuffer type size>
         if (ChkArgCount( 5, numargs, 248 ) != 0)
            return( ReturnError() );

         if (!is_address( args[1] ) || !is_string(  args[2] )
                                    || !is_integer( args[3] )
                                    || !is_integer( args[4] ))
            (void) PrintArgTypeError( 248 );
         else
            rval = setVBuf( (BPTR) addr_value( args[1] ),
                                 string_value( (STRING *) args[2] ),
                            (LONG)  int_value( args[3] ),
                            (LONG)  int_value( args[4] )
                          ); 
         break;
         
      case 24: // LONG returnedLength =  Write( BPTR file, void *aBuffer, LONG length );
               //   ^ <primitive 248 24 bptrFileHandle aBuffer length>
         if (!is_address( args[1] ) || !is_string(  args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 248 );
         else
            rval = writeFile( (BPTR) addr_value( args[1] ),
                                   string_value( (STRING *) args[2] ),
                              (LONG)  int_value( args[3] )
                            ); 
         break;
         
      default:
         (void) PrintArgTypeError( 248 );
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

/* ----------------------- END of ADOS3.c file! ------------------------ */
