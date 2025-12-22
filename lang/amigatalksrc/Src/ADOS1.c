/****h* AmigaTalk/ADOS1.c [3.0] ***************************************
*
* NAME
*    ADOS1.c
*
* DESCRIPTION
*    Relatively safe DOS commands to use are in this file. <246>
*    ADOS2.c contains Unsafe         DOS commands <247>,
*    ADOS3.c contains Dangerous      DOS commands <248> &
*    ADOS4.c contains Very Dangerous DOS commands <249>
* FUNCTIONAL INTERFACE:
*
*    PUBLIC OBJECT *HandleADosSafe( int numargs, OBJECT **args );
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*    09-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*    $VER: AmigaTalk:Src/ADOS1.c 3.0 (24-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/io.h>

#include <AmigaDOSErrs.h>

#include <dos/dos.h>
#include <dos/var.h>
#include <dos/datetime.h>
#include <dos/dosextens.h>

#ifndef __amigaos4__
# include <clib/dos_protos.h>
#else

# define __USE_INLINE__

# include <proto/dos.h>

IMPORT struct DOSIFace *IDOS; // -lauto will take care of this

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Constants.h"
#include "Object.h"

#include <proto/locale.h>

#include "StringConstants.h"

#include "FuncProtos.h"

#include "IStructs.h"

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT OBJECT *PrintArgTypeError( int primnumber );

PUBLIC char *ioErrStrs[ 67 ] = { NULL, };

// ---------------------------------------------------------

// From dos/dos.h:

// #define BADDR(x) (APTR)((ULONG)(x) << 2))

// Convert address into a BPTR:

// #define MKBADDR(x)	(((LONG)(x)) >> 2)


/****i* AbortPacket() [3.0] ********************************
*
* NAME
*    AbortPacket() <primitive 246 0 mport dpacket>
*
* DESCRIPTION
*    Aborts an asynchronous packet, if possible.  This 
*    attempts to abort a packet sent earlier with SendPkt to
*    a handler.  There is no guarantee that any given handler 
*    will allow a packet to be aborted, or if it is aborted 
*    whether function requested completed first or completely.
*    After calling AbortPkt(), you must wait for the packet 
*    to return before reusing it or deallocating it.
*
* INPUTS
*    port - port the packet was sent to
*    pkt  - the packet you wish aborted
*
* BUGS
*    As of V37, this function does nothing.
************************************************************
*
*/
#ifndef __amigaos4__
METHODFUNC void AbortPacket( struct MsgPort *mp, struct DosPacket *dp )
{
   if ((mp) && (dp)) // mp != NULL && dp != NULL)
      AbortPkt( mp, dp );
      
   return;
}
#endif

/****i* addBuffers() [3.0] *********************************
*
* NAME
*    addBuffers()   ^ <primitive 246 1 filesystem number>
*
* SYNOPSIS
*    BOOL success = AddBuffers( char *filesystem, LONG number );
*
* FUNCTION
*    Adds buffers to a filesystem.  If it succeeds, the number of current
*    buffers is returned in IoErr().  Note that "number" may be negative.
*    The amount of memory used per buffer, and any limits on the number of
*    buffers, are dependant on the filesystem in question.
*    If the call succeeds, the number of buffers in use on the filesystem
*    will be returned by IoErr().
*
* INPUTS
*    filesystem - Name of device to add buffers to (with ':').
*    number     - Number of buffers to add.  May be negative.
*
* BUGS
*    The V36 ROM filesystem (FFS/OFS) doesn't return the right number of
*    buffers unless preceded by an AddBuffers(fs,-1) (in-use buffers aren't
*    counted).  This is fixed in V37.
*
*    The V37 and before ROM filesystem doesn't return success, it returns
*    the number of buffers.  The best way to test for this is to consider
*    0 (FALSE) failure, -1 (DOSTRUE) to mean that IoErr() will have the
*    number of buffers, and any other positive value to be the number of
*    buffers.  It may be fixed in some future ROM revision.
************************************************************
*
*/

METHODFUNC OBJECT *addBuffers( char *filesystem, LONG number )
{
   if (!filesystem) // == NULL)
      return( o_false );
         
   if (AddBuffers( filesystem, number ) == DOSTRUE)
      return( o_true );
   else 
      return( o_false );
}

/****i* cliPointer() [3.0] *********************************
*
* NAME
*    Cli()    ^ <primitive 246 2>
*
* SYNOPSIS
*    struct CommandLineInterface *cli_ptr = Cli( void );
*
* FUNCTION
*    Returns a pointer to the CLI structure of the current process, or NULL
*    if the process has no CLI structure.
*
* RESULT
*    cli_ptr - pointer to the CLI structure, or NULL.
************************************************************
*
*/

METHODFUNC OBJECT *cliPointer( void )
{
   return( AssignObj( new_int( (int) Cli() ) ) );
}

/****i* compareDates() [3.0] *******************************
*
* NAME
*    CompareDates   ^ <primitive 246 3 date1 date2>
*
* SYNOPSIS
*    LONG result = CompareDates( struct DateStamp *date1,
*                                struct DateStamp *date2 );
*
* FUNCTION
*    Compares two times for relative magnitide.  <0 is returned if date1 is
*    later than date2, 0 if they are equal, or >0 if date2 is later than
*    date1.  NOTE:  this is NOT the same ordering as strcmp!
************************************************************
*
*/

METHODFUNC OBJECT *compareDates( struct DateStamp *d1, 
                                 struct DateStamp *d2 
                               )
{
   if (!d1 || !d2) // == NULL)
      return( o_nil );

   return( AssignObj( new_int( (int) CompareDates( d1, d2 ) ) ) );
}

/****i* currentDir() [3.0] *********************************
*
* NAME
*    CurrentDir   ^ <primitive 246 4 bptrLock>
*
* SYNOPSIS
*    BPTR oldLock = CurrentDir( BPTR lock );
*
* FUNCTION
*    CurrentDir() causes a directory associated with a lock to be made
*    the current directory.   The old current directory lock is returned.
*
*    A value of zero is a valid result here, this 0 lock represents the
*    root of file system that you booted from.
*
*    Any call that has to Open() or Lock() files (etc) requires that
*    the current directory be a valid lock or 0.
*
* INPUTS
*    lock - BCPL pointer to a lock
*
* RESULTS
*    oldLock - BCPL pointer to a lock
*
* SEE ALSO
*    Lock(), UnLock(), Open(), DupLock()
************************************************************
*
*/

METHODFUNC OBJECT *currentDir( BPTR lock )
{
   // Zero is a valid value for lock & returned lock:

   return( AssignObj( new_int( (int) CurrentDir( lock ) ) ) );
}

/****i* dateToStr() [3.0] **********************************
*
* NAME
*    DateToStr   ^ <primitive 246 5 dateTime>
*
* SYNOPSIS
*    BOOL success = DateToStr( struct DateTime *dt );
*
* FUNCTION
*    DateToStr converts an AmigaDOS DateStamp to a human
*    readable ASCII string as requested by your settings in the
*    DateTime structure.
************************************************************
*
*/

METHODFUNC OBJECT *dateToStr( struct DateTime *dt )
{
   if (!dt) // == NULL) 
      return( o_false );

   if (DateToStr( dt ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* delay() [3.0] **************************************
*
* NAME
*    Delay   <primitive 246 6 ticks>
*
* SYNOPSIS
*    void Delay( ULONG ticks );
*
* FUNCTION
*    The argument 'ticks' specifies how many ticks (50 per second) to
*    wait before returning control.
************************************************************
*
*/

METHODFUNC void delay( ULONG ticks )
{
   if (ticks > 0)
      Delay( ticks );
      
   return;
}

/****i* endNotify() [3.0] **********************************
*
* NAME
*    EndNotify <primitive 246 7 notifyStruct>
*
* SYNOPSIS
*    void EndNotify( struct NotifyRequest *notifystructure );
*
* FUNCTION
*    Removes a notification request.  Safe to call even if StartNotify()
*    failed.  For NRF_SEND_MESSAGE, it searches your port for any messages
*    about the object in question and removes and replies them before
*    returning.
*
* INPUTS
*    notifystructure - a structure passed to StartNotify()
*
* SEE ALSO
*    StartNotify(), <dos/notify.h>
************************************************************
*
*/

METHODFUNC void endNotify( struct NotifyRequest *notifystructure )
{
   if (notifystructure) // != NULL)
      EndNotify( notifystructure );

   return;
}

/****i* errorReport() [3.0] ********************************
*
* NAME
*    ErrorReport ^ <primitive 246 8 code type arg1 deviceMPort>
*
* SYNOPSIS
*    BOOL status = ErrorReport( LONG code, LONG type, 
*                               ULONG arg1, struct MsgPort *device );
*
* FUNCTION
*    Based on the request type, this routine formats the appropriate
*    requester to be displayed.  If the code is not understood, it returns
*    DOSTRUE immediately.  Returns DOSTRUE if the user selects CANCEL or
*    if the attempt to put up the requester fails, or if the process
*    pr_WindowPtr is -1.  Returns FALSE if the user selects Retry.  The
*    routine will retry on DISKINSERTED for appropriate error codes.
*    These return values are the opposite of what AutoRequest returns.
*
*    Note: this routine sets IoErr() to code before returning.
*
* RESULT
*    status - Cancel/Retry indicator (0 means Retry)
************************************************************
*
*/

METHODFUNC OBJECT *errorReport( LONG            code, 
                                LONG            type, 
                                ULONG           arg1, 
                                struct MsgPort *device
                              )
{
   OBJECT *rval = o_nil;
   int     chk  = 0;
   
   if (!device) // == NULL)
      return( rval );
      
   switch (code)
      {
      case ERROR_DISK_NOT_VALIDATED:
      case ERROR_DISK_WRITE_PROTECTED:
      case ERROR_DISK_FULL:
      case ERROR_DEVICE_NOT_MOUNTED:
      case ERROR_NOT_A_DOS_DISK:
      case ERROR_NO_DISK:
      case ABORT_DISK_ERROR:    // read/write error
      case ABORT_BUSY:          // you MUST replace...
         chk = ErrorReport( code, type, arg1, device );
         
         if (chk == DOSTRUE)
            rval = o_true;
         else 
            rval = o_false;

         break;
         
      default:
         break;
      }

   return( rval );
}

/****i* fault() [3.0] **************************************
*
* NAME
*    Fault()  ^ <primitive 246 9 code header buffer length>
*
* SYNOPSIS
*    LONG len = Fault( LONG code, char *header, char *buffer, LONG len );
*
* FUNCTION
*    This routine obtains the error message text for the given error code.
*    The header is prepended to the text of the error message, followed
*    by a colon.  Puts a null-terminated string for the error message into
*    the buffer.  By convention, error messages should be no longer than 80
*    characters (+1 for termination), and preferably no more than 60.
*    The value returned by IoErr() is set to the code passed in.  If there
*    is no message for the error code, the message will be "Error code
*    <number>\n".
*
*    The number of characters put into the buffer is returned, which will
*    be 0 if the code passed in was 0.
*
* RESULT
*    len    - number of characters put into buffer (may be 0)
*
* SEE ALSO
*    IoErr(), SetIoErr(), PrintFault()
************************************************************
*
*/

METHODFUNC OBJECT *fault( LONG code, char *header, char *buffer, LONG len )
{
   if (!buffer || len < 1)
      return( o_nil );

   return( AssignObj( new_int( (int) Fault( code, header, buffer, len ))));
}

/****i* fGetC() [3.0] **************************************
*
* NAME
*    FGetC  ^ <primitive 246 10 bptrFH>
*
* SYNOPSIS
*    LONG char = FGetC( BPTR fh );
*
* FUNCTION
*    Reads the next character from the input stream.  A -1 is
*    returned when EOF or an error is encountered.  This call is buffered.
*    Use Flush() between buffered and unbuffered I/O on a filehandle.
*
* RESULT
*    char - character read (0-255) or -1
*
* BUGS
*    In V36, after an EOF was read, EOF would always be returned from
*    FGetC() from then on.  Starting in V37, it tries to read from the
*    handler again each time (unless UnGetC(fh,-1) was called).
*
* SEE ALSO
*    FPutC(), UnGetC(), Flush()
************************************************************
*
*/

METHODFUNC OBJECT *fGetC( BPTR fh )
{
   LONG chr = -1;
   
   if (!fh) // == NULL)
      return( o_nil );

   chr = FGetC( fh );

   if (chr == -1)
      return( o_nil );
   else 
      return( AssignObj( new_int( (int) chr ) ) );
}

/****i* fGetS() [3.0] **************************************
*
* NAME
*    FGets ^ <primitive 246 11 bptrFH buffer length>
*
* SYNOPSIS
*    char *buffer = FGets( BPTR fh, char *buf, ULONG len );
*
* FUNCTION
*    This routine reads in a single line from the specified input stopping
*    at a NEWLINE character or EOF.  In either event, UP TO the number of
*    len specified bytes minus 1 will be copied into the buffer.  Hence if
*    a length of 50 is passed and the input line is longer than 49 bytes,
*    it will return 49 characters.  It returns the buffer pointer normally,
*    or NULL if EOF is the first thing read.
*
*    If terminated by a newline, the newline WILL be the last character in
*    the buffer.  This is a buffered read routine.  The string read in IS
*    null-terminated.
*
* INPUTS
*    fh   - filehandle to use for buffered I/O
*    buf  - Area to read bytes into.
*    len  - Number of bytes to read, must be > 0.
*    flag - TRUE means use the GlobalObjects/CommonFuncs FGetS() function.
*
* SEE ALSO
*    FRead(), FPuts(), FGetC()
************************************************************
*
*/

METHODFUNC OBJECT *fGets( BPTR fh, char *buffer, ULONG length, BOOL flag )
{
   char *str = NULL;
   
   if (!fh || !buffer || length < 1)
      return( o_nil );

   if (flag == FALSE)
      str = FGets( fh, buffer, length );
   else
      str = FGetS( buffer, length, (FILE *) fh ); // No newline at end of string.
      
   if (!str) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_str( str ) ) );
}

/****i* findCliProc() [3.0] ********************************
*
* NAME
*    FindCliProc -- returns a pointer to the requested CLI process
*                   ^ <primitive 246 12 cliNumber>
* SYNOPSIS
*    struct Process *proc = FindCliProc( ULONG num );
*
* RESULT
*    proc - Pointer to given CLI process
*
* SEE ALSO
*    Cli(), Forbid(), MaxCli()
************************************************************
*
*/

METHODFUNC OBJECT *findCliProc( ULONG number )
{
   struct Process *proc = NULL;  

   Forbid();

      if (number > MaxCli())
         {
         Permit();

         return( o_nil );
         }
      
      proc = FindCliProc( number );

   Permit();

   if (proc == NULL)   
      return( o_nil );
   else
      return( AssignObj( new_int( (int) proc ) ) );
}

/****i* findVar() [3.0] ************************************
*
* NAME
*    FindVar -- Finds a local variable (V36)
*               ^ <primitive 246 13 name type>
* SYNOPSIS
*    struct LocalVar *var = FindVar( char *name, ULONG type ); 
*
* FUNCTION
*    Finds a local variable structure.
*
* INPUTS
*    name - pointer to a variable name.  Note variable names follow
*           filesystem syntax and semantics.
*
*    type - type of variable to be found (see <dos/var.h>)
************************************************************
*
*/

METHODFUNC OBJECT *findVar( char *name, ULONG type )
{
   struct LocalVar *var = NULL;
   
   if (!name) // == NULL)
      return( o_nil );

   if (!(var = FindVar( name, type ))) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_int( (int) var ) ) );
}

/****i* fPutC() [3.0] **************************************
*
* NAME
*    FPutC -- Write a character to the specified output (buffered)
*             ^ <primitive 246 14 bptrFH character>
* SYNOPSIS
*    LONG char = FPutC( BPTR fh, LONG chr );
*
* FUNCTION
*    Writes a single character to the output stream.  This call is
*    buffered.  Use Flush() between buffered and unbuffered I/O on a
*    filehandle.  Interactive filehandles are flushed automatically
*    on a newline, return, '\0', or line feed.
*
* RESULT
*    char - either the character written, or EOF for an error.
************************************************************
*
*/

METHODFUNC OBJECT *fPutC( BPTR fh, LONG chr )
{
   LONG chk = 0L;
   
   if (!fh) // == NULL)
      return( o_nil );

   chk = FPutC( fh, chr & 0xFF );
   
   if (chk == EOF)
      return( o_nil );
   else
      return( AssignObj( new_int( (int) chk ) ) );
}

/****i* fPutS() [3.0] **************************************
*
* NAME
*    FPuts -- Writes a string the the specified output (buffered)
*             ^ <primitive 246 15 bptrFH string>
* SYNOPSIS
*    LONG error = FPuts( BPTR fh, char *str );
*
* FUNCTION
*    This routine writes an unformatted string to the filehandle.
*    This routine is buffered.
*
* RESULT
*    error - 0 normally, otherwise -1.  Note that this is opposite of
*            most other Dos functions, which return success.
************************************************************
*
*/

METHODFUNC OBJECT *fPutS( BPTR fh, char *string )
{
   LONG err = 0L;
   
   if (!fh || !string) // == NULL)
      return( o_nil );

   if ((err = FPuts( fh, string )) == -1)
      return( o_false );
   else
      return( o_true );
}

/****i* getArgStr() [3.0] **********************************
*
* NAME
*    GetArgStr -- Returns the arguments for the process
*                 ^ <primitive 246 16>
* SYNOPSIS
*    char *ptr = GetArgStr( void );
*
* FUNCTION
*    Returns a pointer to the (null-terminated) arguments for the program
*    (process).  This is the same string passed in A0 on startup from CLI.
************************************************************
*
*/

METHODFUNC OBJECT *getArgStr( void )
{
   char *sptr = NULL;
   
   if (!(sptr = GetArgStr())) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_str( sptr ) ) );
}

/****i* getConsoleTask() [3.0] *****************************
*
* NAME
*    GetConsoleTask  ^ <primitive 246 17>
*
* SYNOPSIS
*    struct MsgPort *port = GetConsoleTask( void );
*
* FUNCTION
*    Returns the default console task's port (pr_ConsoleTask) for the
*    current process.
*
* SEE ALSO
*    SetConsoleTask(), Open()
************************************************************
*
*/

METHODFUNC OBJECT *getConsoleTask( void )
{
   struct MsgPort *mport = NULL;
   
   if (!(mport = GetConsoleTask())) // == NULL)   
      return( o_nil );
   else
      return( AssignObj( new_int( (int) mport ) ) );
}

/****i* getCurrentDirName() [3.0] **************************
*
* NAME
*    GetCurrentDirName -- returns the current directory name
*                         ^ <primitive 246 18 buffer length>
* SYNOPSIS
*    BOOL success = GetCurrentDirName( char *buf, LONG len );
*
* FUNCTION
*    Extracts the current directory name from the CLI structure and puts it 
*    into the buffer.  If the buffer is too small, the name is truncated 
*    appropriately and a failure code returned.  If no CLI structure is 
*    present, a null string is returned in the buffer, and failure from
*    the call (with IoErr() == ERROR_OBJECT_WRONG_TYPE);
*
* INPUTS
*    buf     - Buffer to hold extracted name
*    len     - Number of bytes of space in buffer
************************************************************
*
*/

METHODFUNC OBJECT *getCurrentDirName( char *buffer, LONG length )
{
   if (!buffer || length < 1)
      return( o_false );

   if (GetCurrentDirName( buffer, length ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* getDeviceProc() [3.0] ******************************
*
* NAME
*    GetDeviceProc -- Finds a handler to send a message to
*                     ^ <primitive 246 19 name devProc>
* SYNOPSIS
*    struct DevProc *devproc = GetDeviceProc( char *name, struct DevProc *devproc );
*
* FUNCTION
*    Finds the handler/filesystem to send packets regarding 'name' to.
*    This may involve getting temporary locks.  It returns a structure
*    that includes a lock and msgport to send to to attempt your operation.
*    It also includes information on how to handle multiple-directory
*    assigns (by passing the DevProc back to GetDeviceProc() until it
*    returns NULL).
*
*    The initial call to GetDeviceProc() should pass NULL for devproc.  If
*    after using the returned DevProc, you get an ERROR_OBJECT_NOT_FOUND,
*    and (devproc->dvp_Flags & DVPF_ASSIGN) is true, you should call
*    GetDeviceProc() again, passing it the devproc structure.  It will
*    either return a modified devproc structure, or NULL (with
*    ERROR_NO_MORE_ENTRIES in IoErr()).  Continue until it returns NULL.
*
*    This call also increments the counter that locks a handler/fs into
*    memory.  After calling FreeDeviceProc(), do not use the port or lock
*    again!
*
* INPUTS
*    name    - name of the object you wish to access.  This can be a
*         relative path ("foo/bar"), relative to the current volume
*         (":foo/bar"), or relative to a device/volume/assign
*         ("foo:bar").
*    devproc - A value returned by GetDeviceProc() before, or NULL
*
* RESULT
*    devproc - a pointer to a DevProc structure or NULL
*
* BUGS
*    Counter not currently active in 2.0.
*    In 2.0 and 2.01, you HAD to check DVPF_ASSIGN before calling it again.
*    This was fixed for the 2.02 release of V36.
*
* SEE ALSO
*    FreeDeviceProc(), DeviceProc(), AssignLock(), AssignLate(),
*    AssignPath()
************************************************************
*
*/

METHODFUNC OBJECT *getDeviceProc( char *name, struct DevProc *devproc )
{
   struct DevProc *dproc = NULL;
   
   if (!name) // ==  NULL)
      return( o_nil );

   dproc = GetDeviceProc( name, devproc );
   
   return( AssignObj( new_int( (int) dproc ))); // dproc == NULL is a valid value.
}

/****i* getFileSysTask() [3.0] *****************************
*
* NAME
*    GetFileSysTask -- Returns the default filesystem for the process
*                      ^ <primitive 246 20>
* SYNOPSIS
*    struct MsgPort *port = GetFileSysTask( void )
*
* FUNCTION
*    Returns the default filesystem task's port 
*    (pr_FileSystemTask) for the current process.
************************************************************
*
*/

METHODFUNC OBJECT *getFileSysTask( void )
{
   struct MsgPort *mport = NULL;
   
   if (!(mport = GetFileSysTask())) // == NULL)   
      return( o_nil );
   else
      return( AssignObj( new_int( (int) mport ) ) );
}

/****i* getProgramDir() [3.0] ******************************
*
* NAME
*    GetProgramDir -- Returns a lock on the directory the program was loaded
*                     from.  ^ <primitive 246 21>
*
* SYNOPSIS
*    BPTR lock = GetProgramDir( void )
*
* FUNCTION
*    Returns a shared lock on the directory the program was loaded from.
*    This can be used for a program to find data files, etc, that are stored
*    with the program, or to find the program file itself.  NULL returns are
*    valid, and may occur, for example, when running a program from the
*    resident list.  You should NOT unlock the lock.
*
* RESULT
*    lock - A lock on the directory the current program was loaded from,
*           or NULL if loaded from resident list, etc.
*
* BUGS
*    Should return a lock for things loaded via resident.  Perhaps should
*    return currentdir if NULL.
************************************************************
*
*/

METHODFUNC OBJECT *getProgramDir( void )
{
   return( AssignObj( new_int( (int) GetProgramDir() ) ) );
}

/****i* getProgramName() [3.0] *****************************
*
* NAME
*    GetProgramName -- Returns the current program name
*                      ^ <primitive 246 22 buffer length>
* SYNOPSIS
*    BOOL success = GetProgramName( char *buf, LONG len )
*
* FUNCTION
*    Extracts the program name from the CLI structure and puts it 
*    into the buffer.  If the buffer is too small, the name is truncated.
*    If no CLI structure is present, a null string is returned in the
*    buffer, and failure from the call (with IoErr() ==
*    ERROR_OBJECT_WRONG_TYPE);
*
* INPUTS
*    buf     - Buffer to hold extracted name
*    len     - Number of bytes of space in buffer
************************************************************
*
*/

METHODFUNC OBJECT *getProgramName( char *buffer, LONG length )
{
   if (!buffer || length < 1)
      return( o_false );
      
   if (GetProgramName( buffer, length ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* getPrompt() [3.0] **********************************
*
* NAME
*    GetPrompt -- Returns the prompt for the current process
*                 ^ <primitive 246 23 buffer length>
* SYNOPSIS
*    BOOL success = GetPrompt( char *buf, LONG len );
*
* FUNCTION
*    Extracts the prompt string from the CLI structure and puts it 
*    into the buffer.  If the buffer is too small, the string is truncated 
*    appropriately and a failure code returned.  If no CLI structure is 
*    present, a null string is returned in the buffer, and failure from
*    the call (with IoErr() == ERROR_OBJECT_WRONG_TYPE);
*
* INPUTS
*    buf     - Buffer to hold extracted prompt
*    len     - Number of bytes of space in buffer
************************************************************
*
*/

METHODFUNC OBJECT *getPrompt( char *buffer, LONG length )
{
   if (!buffer || length < 1)
      return( o_false );
      
   if (GetPrompt( buffer, length ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* getVar() [3.0] *************************************
*
* NAME
*    GetVar -- Returns the value of a local or global variable (V36)
*              ^ <primitive 246 24 name buffer size flags>
* SYNOPSIS
*    LONG len = GetVar( char *name, char *buffer, LONG size, LONG flags ); 
*
* FUNCTION
*    Gets the value of a local or environment variable.  It is advised to
*    only use ASCII strings inside variables, but not required.  This stops
*    putting characters into the destination when a \n is hit, unless
*    GVF_BINARY_VAR is specified.  (The \n is not stored in the buffer.)
*
* INPUTS
*    name   - pointer to a variable name.
*    buffer - a user allocated area which will be used to store
*             the value associated with the variable.
*    size   - length of the buffer region in bytes.
*    flags  - combination of type of var to get value of (low 8 bits), and
*             flags to control the behavior of this routine.  Currently
*             defined flags include:
*
*         GVF_GLOBAL_ONLY - tries to get a global env variable.
*         GVF_LOCAL_ONLY  - tries to get a local variable.
*         GVF_BINARY_VAR  - don't stop at \n
*         GVF_DONT_NULL_TERM - no null termination (only valid
*                              for binary variables). (V37)
*
*       The default is to try to get a local variable first, then
*       to try to get a global environment variable.
*
* RESULT
*    len -   Size of environment variable.  -1 indicates that the
*            variable was not defined (if IoErr() returns
*      ERROR_OBJECT_NOT_FOUND - it returns ERROR_BAD_NUMBER if
*      you specify a size of 0).  If the value would overflow
*      the user buffer, the buffer is truncated.  The buffer
*      returned is null-terminated (even if GVF_BINARY_VAR is
*      used, unless GVF_DONT_NULL_TERM is in effect).  If it
*      succeeds, len is the number of characters put in the buffer
*      (not including null termination), and IoErr() will return the
*      the size of the variable (regardless of buffer size).
*
* BUGS
*    LV_VAR is the only type that can be global.
*    Under V36, we documented (and it returned) the size of the variable,
*    not the number of characters transferred.  For V37 this was changed
*    to the number of characters put in the buffer, and the total size
*    of the variable is put in IoErr().
*    GVF_DONT_NULL_TERM only works for local variables under V37.  For
*    V39, it also works for globals.
*
* SEE ALSO
*    SetVar(), DeleteVar(), FindVar(), <dos/var.h>
************************************************************
*
*/

METHODFUNC OBJECT *getVar( char *name, char *buffer, LONG size, LONG flags )
{
   LONG retn = 0L;
   
   if (!name || !buffer || size < 1)
      return( o_nil );

   if ((retn = GetVar( name, buffer, size, flags )) == -1)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) retn ) ) );
}

/****i* ioErr() [3.0] **************************************
*
* NAME
*    IoErr -- Return extra information from the system
*             ^ <primitive 246 25>
* SYNOPSIS
*    LONG error = IoErr( void );
*
* FUNCTION
*    Most I/O routines return zero to indicate an error. When this 
*    happens (or whatever the defined error return for the routine)
*    this routine may be called to determine more information. It is
*    also used in some routines to pass back a secondary result.
*
*    Note: there is no guarantee as to the value returned from IoErr()
*    after a successful operation, unless specified by the routine.
*
* RESULTS
*    error - integer
*
* SEE ALSO
*    Fault(), PrintFault(), SetIoErr()
************************************************************
*
*/

METHODFUNC OBJECT *ioErr( void )
{
   return( AssignObj( new_int( (int) IoErr() ) ) );
}

/****i* isFileSystem() [3.0] *******************************
*
* NAME
*    IsFileSystem -- returns whether a Dos handler is a filesystem
*                    ^ <primitive 246 26 name>
* SYNOPSIS
*    BOOL result = IsFileSystem( char *name )
*
* FUNCTION
*    Returns whether the device is a filesystem or not.  A filesystem
*    supports seperate files storing information.  It may also support
*    sub-directories, but is not required to.  If the filesystem doesn't
*    support this new packet, IsFileSystem() will use Lock(":",...) as
*    an indicator.
*
* INPUTS
*    name   - Name of device in question, with trailing ':'.
*
* RESULT
*    result - Flag to indicate if device is a file system
*
* SEE ALSO
*    Lock()
************************************************************
*
*/

METHODFUNC OBJECT *isFileSystem( char *name )
{
   if (!name) // == NULL)
      return( o_false );
   
   if (IsFileSystem( name ) == FALSE)   
      return( o_false );
   else
      return( o_true );
}

/****i* isInteractive() [3.0] ******************************
*
* NAME
*    IsInteractive -- Discover whether a file is "interactive"
*                     ^ <primitive 246 27 bptrFH>
* SYNOPSIS
*    BOOL status = IsInteractive( BPTR file )
*
* FUNCTION
*    The return value 'status' indicates whether the file associated
*    with the file handle 'file' is connected to a virtual terminal.
*
* INPUTS
*    file - BCPL pointer to a file handle
************************************************************
*
*/

METHODFUNC OBJECT *isInteractive( BPTR file )
{
   if (!file) // == NULL)
      return( o_false );
   
   if (IsInteractive( file ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* matchEnd() [3.0] ***********************************
*
* NAME
*    MatchEnd -- Free storage allocated for MatchFirst()/MatchNext()
*                <primitive 246 28 ap> 
* SYNOPSIS
*    void MatchEnd( struct AnchorPath *ap );
*
* FUNCTION
*    Return all storage associated with a given search.
*
* INPUTS
*    AnchorPath - Anchor used for MatchFirst()/MatchNext()
*                 MUST be longword aligned!
*
* SEE ALSO
*    MatchFirst(), ParsePattern(), Examine(), CurrentDir(), Examine(),
*    MatchNext(), ExNext(), <dos/dosasl.h>
************************************************************
*
*/

METHODFUNC void matchEnd( struct AnchorPath *ap )
{
   if (ap) // != NULL) // && ((ap % 4) == 0))
      MatchEnd( ap );
      
   return;
}

/****i* matchFirst() [3.0] *********************************
*
* NAME
*    MatchFirst -- Finds file that matches pattern
*                  ^ <primitive 246 29 pattern ap>
* SYNOPSIS
*    LONG error = MatchFirst( char *pat, struct AnchorPath *ap );
*
* FUNCTION
*    Locates the first file or directory that matches a given pattern.
*    MatchFirst() is passed your pattern (you do not pass it through
*    ParsePattern() - MatchFirst() does that for you), and the control
*    structure.  MatchFirst() normally initializes your AnchorPath
*    structure for you, and returns the first file that matched your
*    pattern, or an error.  Note that MatchFirst()/MatchNext() are unusual
*    for Dos in that they return 0 for success, or the error code (see
*    <dos/dos.h>), instead of the application getting the error code
*    from IoErr().
* 
*    When looking at the result of MatchFirst()/MatchNext(), the ap_Info
*    field of your AnchorPath has the results of an Examine() of the object.
*    You normally get the name of the object from fib_FileName, and the
*    directory it's in from ap_Current->an_Lock.  To access this object,
*    normally you would temporarily CurrentDir() to the lock, do an action
*    to the file/dir, and then CurrentDir() back to your original directory.
*    This makes certain you affect the right object even when two volumes
*    of the same name are in the system.  You can use ap_Buf (with
*    ap_Strlen) to get a name to report to the user.
* 
*    To initialize the AnchorPath structure (particularily when reusing
*    it), set ap_BreakBits to the signal bits (CDEF) that you want to take
*    a break on, or NULL, if you don't want to convenience the user.
*    ap_Flags should be set to any flags you need or all 0's otherwise.
*    ap_FoundBreak should be cleared if you'll be using breaks.
* 
*    If you want to have the FULL PATH NAME of the files you found,
*    allocate a buffer at the END of this structure, and put the size of
*    it into ap_Strlen.  If you don't want the full path name, make sure
*    you set ap_Strlen to zero.  In this case, the name of the file, and
*    stats are available in the ap_Info, as per usual.
* 
*    Then call MatchFirst() and then afterwards, MatchNext() with this
*    structure.  You should check the return value each time (see below)
*    and take the appropriate action, ultimately calling MatchEnd() when
*    there are no more files or you are done.  You can tell when you are
*    done by checking for the normal AmigaDOS return code
*    ERROR_NO_MORE_ENTRIES.
* 
*    Note: patterns with trailing slashes may cause MatchFirst()/MatchNext()
*    to return with an ap_Current->an_Lock on the object, and a filename
*    of the empty string ("").
*
*    See ParsePattern() for more information on the patterns.
*
* INPUTS
*    pat        - Pattern to search for
*    AnchorPath - Place holder for search.  MUST be longword aligned!
*
* RESULT
*    error - 0 for success or error code.  (Opposite of most Dos calls!)
*
* BUGS
*    A bug that has not been fixed for V37 concerns a pattern of a
*    single directory name (such as "l").  If you enter such a directory
*    via DODIR, it re-locks l relative to the current directory.  Thus
*    you must not change the current directory before calling MatchNext()
*    with DODIR in that situation.  If you aren't using DODIR to enter
*    directories you can ignore this.  This may be fixed in some upcoming
*    release.
* 
* SEE ALSO
*    MatchNext(), ParsePattern(), Examine(), CurrentDir(), Examine(),
*    MatchEnd(), ExNext(), <dos/dosasl.h>
************************************************************
*
*/

METHODFUNC OBJECT *matchFirst( char *pat, struct AnchorPath *ap )
{
   LONG chk = 0L;
   
   if (!pat || !ap) // == NULL)
      return( o_false );
      
   if ((chk = MatchFirst( pat, ap )) == 0)
      return( o_true );
   else
      return( o_false );
}

/****i* matchNext() [3.0] **********************************
*
* NAME
*    MatchNext - Finds the next file or directory that matches pattern
*                ^ <primitive 246 30 ap>
* SYNOPSIS
*    LONG error = MatchNext( struct AnchorPath *ap );
*
* FUNCTION
*    Locates the next file or directory that matches a given pattern.
*    See <dos/dosasl.h> for more information.  Various bits in the flags
*    allow the application to control the operation of MatchNext().
*
*    See MatchFirst() for other notes.
*
* INPUTS
*    AnchorPath - Place holder for search.  MUST be longword aligned!
*
* RESULT
*    error - 0 for success or error code.  (Opposite of most Dos calls)
*
* BUGS
*    See MatchFirst().
*
* SEE ALSO
*    MatchFirst(), ParsePattern(), Examine(), CurrentDir(), Examine(),
*    MatchEnd(), ExNext(), <dos/dosasl.h>
************************************************************
*
*/

METHODFUNC OBJECT *matchNext( struct AnchorPath *ap )
{
   LONG chk = 0L;
   
   if (!ap) // == NULL)
      return( o_false );
      
   if ((chk = MatchNext( ap )) == 0)
      return( o_true );
   else
      return( o_false );
}

/****i* maxCli() [3.0] *************************************
*
* NAME
*    MaxCli -- returns the highest CLI process number possibly in use
*              ^ <primitive 246 31>
* SYNOPSIS
*    LONG number = MaxCli( void );
*
* FUNCTION
*    Returns the highest CLI number that may be in use.  CLI numbers are
*    reused, and are usually as small as possible.  To find all CLIs, scan
*    using FindCliProc() from 1 to MaxCLI().  The number returned by
*    MaxCli() may change as processes are created and destroyed.
*
* RESULT
*    number - The highest CLI number that _may_ be in use.
*
* SEE ALSO
*    FindCliProc(), Cli()
************************************************************
*
*/

METHODFUNC OBJECT *maxCli( void )
{
   return( AssignObj( new_int( (int) MaxCli() ) ) );
}

/****i* parentDir() [3.0] **********************************
*
* NAME
*    ParentDir -- Obtain the parent of a directory or file
*                 ^ <primitive 246 32 bptrLock>
* SYNOPSIS
*    BPTR newlock = ParentDir( BPTR lock )
*
* FUNCTION
*    The argument 'lock' is associated with a given file or directory.
*    ParentDir() returns 'newlock' which is associated the parent
*    directory of 'lock'.
*
*    Taking the ParentDir() of the root of the current filing system
*    returns a NULL (0) lock.  Note this 0 lock represents the root of
*    file system that you booted from (which is, in effect, the parent
*    of all other file system roots.)
*
* INPUTS
*    lock - BCPL pointer to a lock
*
* RESULTS
*    newlock - BCPL pointer to a lock
************************************************************
*
*/

METHODFUNC OBJECT *parentDir( BPTR lock )
{
   return( AssignObj( new_address( (ULONG) ParentDir( lock ) ) ) );
}

/****i* parentOfFH() [3.0] *********************************
*
* NAME
*    ParentOfFH -- returns a lock on the parent directory of a file
*                  ^ <primitive 246 33 bptrFH>
* SYNOPSIS
*    BPTR lock = ParentOfFH( BPTR fh );
*
* FUNCTION
*    Returns a shared lock on the parent directory of the filehandle.
*
* INPUTS
*    fh   - Filehandle you want the parent of.
*
* RESULT
*    lock - Lock on parent directory of the filehandle or NULL for failure.
*
* SEE ALSO
*    Parent(), Lock(), UnLock() DupLockFromFH()
************************************************************
*
*/

METHODFUNC OBJECT *parentOfFH( BPTR fh )
{
   if (!fh) // == NULL)
      return( o_nil );
   else 
      return( AssignObj( new_address( (ULONG) ParentOfFH( fh ) ) ) );
}

/****i* pathPart() [3.0] ***********************************
*
* NAME
*    PathPart -- Returns a pointer to the end of the next-to-last
*                component of a path.  ^ <primitive 246 34 path>
*
* SYNOPSIS
*    char *fileptr = PathPart( char *path );
*
* FUNCTION
*    This function returns a pointer to the character after the next-to-last
*    component of a path specification, which will normally be the directory
*    name.  If there is only one component, it returns a pointer to the
*    beginning of the string.  The only real difference between this and
*    FilePart() is the handling of '/'.
*
* INPUTS
*    path - pointer to an path string.  May be relative to the current
*           directory or the current disk.
*
* RESULT
*    fileptr - pointer to the end of the next-to-last component of the path.
*
* EXAMPLE
*    PathPart("xxx:yyy/zzz/qqq") would return a pointer to the last '/'.
*    PathPart("xxx:yyy") would return a pointer to the first 'y').
*
*    Use realPathPart() instead!!
************************************************************
*
*/

METHODFUNC OBJECT *pathPart( char *path )
{
   if (!path) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_str( PathPart( path ) ) ) );
}

/****i* printFault() [3.0] *********************************
*
* NAME
*    PrintFault -- Returns the text associated with a DOS error code (V36)
*                  ^ <primitive 246 35 code header>
* SYNOPSIS
*    BOOL success = PrintFault( LONG code, char *header );
*
* FUNCTION
*    This routine obtains the error message text for the given error code.
*    This is similar to the Fault() function, except that the output is
*    written to the default output channel with buffered output.
*    The value returned by IoErr() is set to the code passed in.
************************************************************
*
*/

METHODFUNC OBJECT *printFault( LONG code, char *header )
{
   if (PrintFault( code, header ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* putStr() [3.0] *************************************
*
* NAME
*    PutStr -- Writes a string the the default output (buffered)
*              ^ <primitive 246 36 string>
* SYNOPSIS
*    LONG error = PutStr( char *str );
*
* FUNCTION
*    This routine writes an unformatted string to the default output.  No 
*    newline is appended to the string and any error is returned.  This
*    routine is buffered.
*
* INPUTS
*    str   - Null-terminated string to be written to default output
*
* RESULT
*    error - 0 for success, -1 for any error.  NOTE: this is opposite
*            most Dos function returns!
************************************************************
*
*/

METHODFUNC OBJECT *putStr( char *string )
{
   if (!string) // == NULL)
      return( o_nil );
   
   if (PutStr( string ) == FALSE)
      return( o_true );
   else
      return( o_false );   
}

/****i* readFile() [3.0] ***********************************
*
* NAME
*    Read -- Read bytes of data from a file
*            ^ <primitive 246 37 bptrFH buffer length>
* SYNOPSIS
*    LONG actualLength = Read( BPTR file, void *buffer, LONG length );
*
* FUNCTION
*    Data can be copied using a combination of Read() and Write().
*    Read() reads bytes of information from an opened file (represented
*    here by the argument 'file') into the buffer given. The argument
*    'length' is the length of the buffer given.
* 
*    The value returned is the length of the information actually read.
*    So, when 'actualLength' is greater than zero, the value of
*    'actualLength' is the the number of characters read. Usually Read
*    will try to fill up your buffer before returning. A value of zero
*    means that end-of-file has been reached. Errors are indicated by a
*    value of -1.
* 
*    Note: this is an unbuffered routine (the request is passed directly
*    to the filesystem.)  Buffered I/O is more efficient for small
*    reads and writes; see FGetC().
*
* INPUTS
*    file - BCPL pointer to a file handle
*    buffer - pointer to buffer
*    length - integer
*
* RESULTS
*    actualLength - integer
*
* SEE ALSO
*    Open(), Close(), Write(), Seek(), FGetC()
************************************************************
*
*/

METHODFUNC OBJECT *readFile( BPTR file, char *buffer, LONG length )
{
   if (!file || (length < 1) || !buffer) // == NULL)
      return( o_nil );

   return( AssignObj( new_int( (int) Read( file, (void *) buffer, length ))));
}

/****i* readArgs() [3.0] ***********************************
*
* NAME
*    ReadArgs - Parse the command line input
*               ^ <primitive 246 38 template array rdArgs> 
* SYNOPSIS
*    struct RDArgs *result = ReadArgs( char          *template, 
*                                      LONG          *array,
*                                      struct RDArgs *rdargs
*                                    );
*
* FUNCTION
*    Parses and argument string according to a template.  Normally gets
*    the arguments by reading buffered IO from Input(), but also can be
*    made to parse a string.  MUST be matched by a call to FreeArgs().
* 
*    ReadArgs() parses the commandline according to a template that is
*    passed to it.  This specifies the different command-line options and
*    their types.  A template consists of a list of options.  Options are
*    named in "full" names where possible (for example, "Quick" instead of
*    "Q").  Abbreviations can also be specified by using "abbrev=option"
*    (for example, "Q=Quick").
* 
*    Options in the template are separated by commas.  To get the results
*    of ReadArgs(), you examine the array of longwords you passed to it
*    (one entry per option in the template).  This array should be cleared
*    (or initialized to your default values) before passing to ReadArgs().
*    Exactly what is put in a given entry by ReadArgs() depends on the type
*    of option.  The default is a string (a sequence of non-whitespace
*    characters, or delimited by quotes, which will be stripped by
*    ReadArgs()), in which case the entry will be a pointer.
* 
*    Options can be followed by modifiers, which specify things such as
*    the type of the option.  Modifiers are specified by following the
*    option with a '/' and a single character modifier.  Multiple modifiers
*    can be specified by using multiple '/'s.  Valid modifiers are:
* 
*    /S - Switch.  This is considered a boolean variable, and will be
*         set if the option name appears in the command-line.  The entry
*         is the boolean (0 for not set, non-zero for set).
* 
*    /K - Keyword.  This means that the option will not be filled unless
*         the keyword appears.  For example if the template is "Name/K",
*         then unless "Name=<string>" or "Name <string>" appears in the
*         command line, Name will not be filled.
* 
*    /N - Number.  This parameter is considered a decimal number, and will
*         be converted by ReadArgs.  If an invalid number is specified,
*         an error will be returned.  The entry will be a pointer to the
*         longword number (this is how you know if a number was specified).
* 
*    /T - Toggle.  This is similar to a switch, but when specified causes
*         the boolean value to "toggle".  Similar to /S.
* 
*    /A - Required.  This keyword must be given a value during command-line
*         processing, or an error is returned.
* 
*    /F - Rest of line.  If this is specified, the entire rest of the line
*         is taken as the parameter for the option, even if other option
*         keywords appear in it.
* 
*    /M - Multiple strings.  This means the argument will take any number
*         of strings, returning them as an array of strings.  Any arguments
*         not considered to be part of another option will be added to this
*         option.  Only one /M should be specified in a template.  Example:
*         for a template "Dir/M,All/S" the command-line "foo bar all qwe"
*         will set the boolean "all", and return an array consisting of
*         "foo", "bar", and "qwe".  The entry in the array will be a pointer
*         to an array of string pointers, the last of which will be NULL.
* 
*         There is an interaction between /M parameters and /A parameters.
*         If there are unfilled /A parameters after parsing, it will grab
*         strings from the end of a previous /M parameter list to fill the
*         /A's.  This is used for things like Copy ("From/A/M,To/A").
* 
*    ReadArgs() returns a struct RDArgs if it succeeds.  This serves as an
*    "anchor" to allow FreeArgs() to free the associated memory.  You can
*    also pass in a struct RDArgs to control the operation of ReadArgs()
*    (normally you pass NULL for the parameter, and ReadArgs() allocates
*    one for you).  This allows providing different sources for the
*    arguments, providing your own string buffer space for temporary
*    storage, and extended help text.  See <dos/rdargs.h> for more
*    information on this.  Note: if you pass in a struct RDArgs, you must
*    still call FreeArgs() to release storage that gets attached to it,
*    but you are responsible for freeing the RDArgs yourself.
* 
*    If you pass in a RDArgs structure, you MUST reset (clear or set)
*    RDA_Buffer for each new call to RDArgs.  The exact behavior if you
*    don't do this varies from release to release and case to case; don't
*    count on the behavior!
* 
*    See BUGS regarding passing in strings.
*    
* INPUTS
*    template - formatting string
*    array    - array of longwords for results, 1 per template entry
*    rdargs   - optional rdargs structure for options.  AllocDosObject
*               should be used for allocating them if you pass one in.
*
* BUGS
*    Currently (V37 and before) it requires any strings passed in to have
*    newlines at the end of the string.  This may or may not be fixed in
*    the future.
*
* SEE ALSO
*    FindArg(), ReadItem(), FreeArgs(), AllocDosObject()
************************************************************
*
*/

METHODFUNC OBJECT *readArgs( char          *Template, 
                             LONG          *array,
                             struct RDArgs *rdargs
                           )
{
   struct RDArgs *rval = NULL;
   
   if (!Template || !array) // == NULL)
      return( o_nil );
   
   if (!(rval = ReadArgs( Template, array, rdargs ))) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* readItem() [3.0] ***********************************
*
* NAME
*    ReadItem - reads a single argument/name from command line
*               ^ <primitive 246 39 buffer maxChars inputCSource>
* SYNOPSIS
*    LONG value = ReadItem( char *buffer, LONG maxchars, 
*                           struct CSource *input );
*
* FUNCTION
*    Reads a "word" from either Input() (buffered), or via CSource, if it
*    is non-NULL (see <dos/rdargs.h> for more information).  Handles
*    quoting and some '*' substitutions (*e and *n) inside quotes (only).
*    See dos/dos.h for a listing of values returned by ReadItem()
*    (ITEM_XXXX).  A "word" is delimited by whitespace, quotes, '=', or
*    an EOF.
*
*    ReadItem always unreads the last thing read (UnGetC(fh,-1)) so the
*    caller can find out what the terminator was.
*
* INPUTS
*    buffer   - buffer to store word in.
*    maxchars - size of the buffer
*    input    - CSource input or NULL (uses FGetC(Input()))
*
* RESULT
*    value - See <dos/dos.h> for return values. (-2 to +2)
*
* BUGS
*    Doesn't actually unread the terminator.
*
* SEE ALSO
*    ReadArgs(), FindArg(), UnGetC(), FGetC(), Input(), <dos/dos.h>,
*    <dos/rdargs.h>, FreeArgs()
************************************************************
*
*/

METHODFUNC OBJECT *readItem( char           *buffer,
                             LONG            maxChars,
                             struct CSource *input
                           )
{
   if (!buffer || (maxChars < 1))
      return( o_nil );
   
   return( AssignObj( new_int( (int) ReadItem( buffer, maxChars, input ))));   
}

/****i* readLink() [3.0] ***********************************
*
* NAME
*    ReadLink -- Reads the path for a soft filesystem link
*                ^ <primitive 246 40 mport bptrLock path buffer size>
* SYNOPSIS
*    BOOL success = ReadLink( struct MsgPort *port, BPTR lock,
*                             char *path, char *buffer, 
*                             ULONG size );
*
* FUNCTION
*    ReadLink() takes a lock/name pair (usually from a failed attempt
*    to use them to access an object with packets), and asks the
*    filesystem to find the softlink and fill buffer with the modified
*    path string.  You then start the resolution process again by
*    calling GetDeviceProc() with the new string from ReadLink().
* 
*    Soft-links are resolved at access time by a combination of the
*    filesystem (by returning ERROR_IS_SOFT_LINK to dos), and by
*    Dos (using ReadLink() to resolve any links that are hit).
*
* INPUTS
*    port - msgport of the filesystem
*    lock - lock this path is relative to on the filesystem
*    path - path that caused the ERROR_IS_SOFT_LINK
*    buffer - pointer to buffer for new path from handler.
*    size - size of buffer.
*
* SEE ALSO
*    MakeLink(), Open(), Lock(), GetDeviceProc()
************************************************************
*
*/

METHODFUNC OBJECT *readLink( struct MsgPort *port, 
                             BPTR            lock,
                             char           *path, 
                             char           *buffer, 
                             ULONG           size
                           )
{
   if (!port || !path || !buffer || (size < 1))
      return( o_nil );
   
   if (ReadLink( port, lock, path, buffer, size ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* sameDevice() [3.0] *********************************
*
* NAME
*    SameDevice -- Are two locks on the same partition of 
*                  the device? 
*                  ^ <primitive 246 41 bptrLock1 bptrLock2>
*
* SYNOPSIS
*    BOOL same = SameDevice( BPTR lock1, BPTR lock2 );
*
* FUNCTION
*    SameDevice() returns whether two locks refer to partitions that
*    are on the same physical device (if it can figure it out).  This
*    may be useful in writing copy routines to take advantage of
*    asynchronous multi-device copies.
*
*    Entry existed in V36 and always returned 0.
*
* INPUTS
*    lock1,lock2 - locks
*
* RESULT
*    whether they're on the same device as far as Dos can determine.
************************************************************
*
*/

METHODFUNC OBJECT *sameDevice( BPTR lock1, BPTR lock2 )
{
   if (SameDevice( lock1, lock2 ) == FALSE)
      return( o_false );
   else
      return( o_true );   
}

/****i* sameLock() [3.0] ***********************************
*
* NAME
*    SameLock -- returns whether two locks are on the same object
*                ^ <primitive 246 42 bptrLock1 bptrLock2>
* SYNOPSIS
*    LONG value = SameLock( BPTR lock1, BPTR lock2 );
*
* FUNCTION
*    Compares two locks.  Returns LOCK_SAME if they are on the same object,
*    LOCK_SAME_VOLUME if on different objects on the same volume, and
*    LOCK_DIFFERENT if they are on different volumes.  Always compare
*    for equality or non-equality with the results, in case new return
*    values are added.
*
* INPUTS
*    lock1 - 1st lock for comparison
*    lock2 - 2nd lock for comparison
*
* RESULT
*    value -   LOCK_SAME, LOCK_SAME_VOLUME, or LOCK_DIFFERENT
*
* BUGS
*    Should do more extensive checks for NULL against a real lock, checking
*    to see if the real lock is a lock on the root of the boot volume.
*
*    In V36, it would return LOCK_SAME_VOLUME for different volumes on the
*    same handler.  Also, LOCK_SAME_VOLUME was LOCK_SAME_HANDLER (now
*    an obsolete define, see <dos/dos.h>).
*
* SEE ALSO
*    <dos/dos.h>
************************************************************
*
*/

METHODFUNC OBJECT *sameLock( BPTR lock1, BPTR lock2 )
{
   return( AssignObj( new_int( (int) SameLock( lock1, lock2 ))));
}

/****i* setComment() [3.0] *********************************
*
* NAME
*    SetComment -- Change a files' comment string
*                  ^ <primitive 246 43 name comment>
* SYNOPSIS
*    BOOL success = SetComment( char *name, char *comment );
*
* FUNCTION
*    SetComment() sets a comment on a file or directory. The comment is
*    a pointer to a null-terminated string of up to 80 characters in the
*    current ROM filesystem (and RAM:).  Note that not all filesystems
*    will support comments (for example, NFS usually will not), or the
*    size of comment supported may vary.
*
* SEE ALSO
*    Examine(), ExNext(), SetProtection()
************************************************************
*
*/

METHODFUNC OBJECT *setComment( char *name, char *comment )
{
   if (!name) // == NULL)
      return( o_nil );
      
   if (SetComment( name, comment ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* setFileDate() [3.0] ********************************
*
* NAME
*    SetFileDate -- Sets the modification date for a file or dir
*                   ^ <primitive 246 44 name dateStamp> 
* SYNOPSIS
*    BOOL success = SetFileDate( char *name, struct DateStamp *date );
*
* FUNCTION
*    Sets the file date for a file or directory.  Note that for the Old
*    File System and the Fast File System, the date of the root directory
*    cannot be set.  Other filesystems may not support setting the date
*    for all files/directories.
************************************************************
*
*/

METHODFUNC OBJECT *setFileDate( char *name, struct DateStamp *date )
{
   if (!name || !date) // == NULL)
      return( o_nil );

   if (SetFileDate( name, date ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* setIoErr() [3.0] ***********************************
*
* NAME
*    SetIoErr -- Sets the value returned by IoErr()
*                ^ <primitive 246 45 code>
* SYNOPSIS
*    LONG oldcode = SetIoErr( LONG code );
*
* FUNCTION
*    This routine sets up the secondary result (pr_Result2) return code 
*    (returned by the IoErr() function).
*
* RESULT
*    oldcode - The previous error code.
************************************************************
*
*/

METHODFUNC OBJECT *setIoErr( LONG code )
{
   return( AssignObj( new_int( (int) SetIoErr( code ))));
}

/****i* setPrompt() [3.0] **********************************
*
* NAME
*    SetPrompt -- Sets the CLI/shell prompt for the current process
*                 ^ <primitive 246 46 name>
* SYNOPSIS
*    BOOL success = SetPrompt( char *name );
*
* FUNCTION
*    Sets the text for the prompt in the cli structure.  If the prompt is 
*    too long to fit, a failure is returned, and the old value is left
*    intact.  It is advised that you inform the user of this condition.
*    This routine is safe to call even if there is no CLI structure.
*
* BUGS
*    This clips to a fixed (1.3 compatible) size.
************************************************************
*
*/

METHODFUNC OBJECT *setPrompt( char *name )
{
   if (SetPrompt( name ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* setProtection() [3.0] ******************************
*
* NAME
*    SetProtection -- Set protection for a file or directory
*                     ^ <primitive 246 47 name maskbits> 
* SYNOPSIS
*    BOOL success = SetProtection( char *name, LONG mask );
*
* FUNCTION
*    SetProtection() sets the protection attributes on a file or
*    directory.  See <dos/dos.h> for a listing of protection bits.
*
*    The archive bit should be cleared by the filesystem whenever the file
*    is changed.  Backup utilities will generally set the bit after
*    backing up each file.
* 
*    The V36 Shell looks at the execute bit, and will refuse to execute
*    a file if it is set.
* 
*    Other bits will be defined in the <dos/dos.h> include files.  Rather
*    than referring to bits by number you should use the definitions in
*    <dos/dos.h>.
************************************************************
*
*/

METHODFUNC OBJECT *setProtection( char *name, LONG mask )
{
   if (!name) // == NULL)
      return( o_nil );
      
   if (SetProtection( name, mask ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* splitName() [3.0] **********************************
*
* NAME
*    SplitName -- splits out a component of a pathname into a buffer
*                 ^ <primitive 246 48 name sepr buffer oldpos size>
* SYNOPSIS
*    WORD newpos = SplitName( char *name, UBYTE separator,
*                             char *buf, WORD oldpos, LONG size );
*
* FUNCTION
*    This routine splits out the next piece of a name from a given file
*    name.  Each piece is copied into the buffer, truncating at size-1
*    characters.  The new position is then returned so that it may be
*    passed in to the next call to splitname.  If the separator is not
*    found within 'size' characters, then size-1 characters plus a null will
*    be put into the buffer, and the position of the next separator will
*    be returned.
* 
*    If a a separator cannot be found, -1 is returned (but the characters
*    from the old position to the end of the string are copied into the
*    buffer, up to a maximum of size-1 characters).  Both strings are
*    null-terminated.
* 
*    This function is mainly intended to support handlers.
* 
* INPUTS
*    name      - Filename being parsed.
*    separator - Separator charactor to split by.
*    buf       - Buffer to hold separated name.
*    oldpos    - Current position in the file.
*    size      - Size of buf in bytes (including null termination).
*
* RESULT
*    newpos    - New position for next call to splitname.  -1 for last one.
*
* BUGS
*    In V36 and V37, path portions greater than or equal to 'size' caused
*    the last character of the portion to be lost when followed by a
*    separator.  Fixed for V39 dos.  For V36 and V37, the suggested work-
*    around is to call SplitName() with a buffer one larger than normal
*    (for example, 32 bytes), and then set buf[size-2] to '0' (for example,
*    buf[30] = '\0';).
*
* SEE ALSO
*    FilePart(), PathPart(), AddPart()
************************************************************
*
*/

METHODFUNC OBJECT *splitName( char *name, UBYTE separator,
                              char *buf,  WORD  oldpos, 
                              LONG  size 
                            )
{
   WORD newpos = 0;
   
   if (!name || !buf || (size < 1))
      return( o_nil );
      
   newpos = SplitName( name, separator, buf, oldpos, size );
   
   return( AssignObj( new_int( (int) newpos ) ) );
}

/****i* strToDate() [3.0] **********************************
*
* NAME
*    StrToDate -- Converts a string to a DateStamp
*                 ^ <primitive 246 49 dateTime>
* SYNOPSIS
*    BOOL success = StrToDate( struct DateTime *datetime );
*
* FUNCTION
*    Converts a human readable ASCII string into an AmigaDOS
*    DateStamp.
*
* RESULT
*    success   - a zero return indicates that a conversion could
*    not be performed. A non-zero return indicates that the
*    DateTime.dat_Stamp variable contains the converted
*    values.
*
* SEE ALSO
*    DateStamp(), DateToStr(), <dos/datetime.h>
************************************************************
*
*/

METHODFUNC OBJECT *strToDate( struct DateTime *datetime )
{
   if (!datetime) // == NULL)
      return( o_nil );
      
   if (StrToDate( datetime ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* strToLong() [3.0] **********************************
*
* NAME
*    StrToLong -- string to long value (decimal)
*                 ^ <primitive 246 50 string valuePtr>
* SYNOPSIS
*    LONG characters = StrToLong( char *string, LONG *value )
*
* FUNCTION
*    Converts decimal string into LONG value.  Returns number of characters
*    converted.  Skips over leading spaces & tabs (included in count).  If
*    no decimal digits are found (after skipping leading spaces & tabs),
*    StrToLong returns -1 for characters converted, and puts 0 into value.
*
* RESULT
*    result - the value the string was converted to.
************************************************************
*
*/

METHODFUNC OBJECT *strToLong( char *string )
{
   LONG howMany = -1L;
   LONG value   = 0L;
   
   if (!string) // == NULL)
      return( o_nil );

   howMany = StrToLong( string, &value );

   if (howMany < 0)
      return( o_nil );
   else
      return( AssignObj( new_int( (int) value ) ) );   
}

/****i* unGetC() [3.0] *************************************
*
* NAME
*    UnGetC -- Makes a char available for reading again. (buffered)
*              ^ <primitive 246 51 bptrFH character>
* SYNOPSIS
*    LONG value = UnGetC( BPTR fh, LONG character )
*
* FUNCTION
*    Pushes the character specified back into the input buffer.  Every
*    time you use a buffered read routine, you can always push back 1
*    character.  You may be able to push back more, though it is not
*    recommended, since there is no guarantee on how many can be
*    pushed back at a given moment.
*
*    Passing -1 for the character will cause the last character read to
*    be pushed back.  If the last character read was an EOF, the next
*    character read will be an EOF.
* 
*    Note: UnGetC can be used to make sure that a filehandle is set up
*    as a read filehandle.  This is only of importance if you are writing
*    a shell, and must manipulate the filehandle's buffer.
*
* INPUTS
*    fh     - filehandle to use for buffered I/O
*    character - character to push back or -1
*
* RESULT
*    value - true if character was pushed back, or false 
*            if the character cannot be pushed back.
************************************************************
*
*/

METHODFUNC OBJECT *unGetC( BPTR fh, LONG chr )
{
   if (!fh) // == NULL)
      return( o_nil );
      
   if (UnGetC( fh, chr ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* vFPrintf() [3.0] ***********************************
*
* NAME
*    VFPrintf -- format and print a string to a file (buffered)
*                ^ <primitive 246 52 bptrFH format argv>
* SYNOPSIS
*    LONG count = VFPrintf( BPTR fh, char *fmt, LONG *argv )
*
* FUNCTION
*    Writes the formatted string and values to the given file.  This
*    routine is assumed to handle all internal buffering so that the
*    formatting string and resultant formatted values can be arbitrarily
*    long.  Any secondary error code is returned in IoErr().  This routine
*    is buffered.
*
* INPUTS
*    fh    - Filehandle to write to
*    fmt   - RawDoFmt() style formatting string
*    argv  - Pointer to array of formatting values
*
* RESULT
*    count - Number of bytes written or -1 (EOF) for an error
*
* BUGS
*    The prototype for FPrintf() currently forces you to cast the first
*    varargs parameter to LONG due to a deficiency in the program
*    that generates fds, prototypes, and amiga.lib stubs.
*
* SEE ALSO
*    VPrintf(), VFWritef(), RawDoFmt(), FPutC()
************************************************************
*
*/

METHODFUNC OBJECT *vFPrintf( BPTR fh, char *fmt, LONG *argv )
{
   LONG count = 0L;
   
   if (!fh) // == NULL)
      return( o_nil );

   count = VFPrintf( fh, fmt, argv );
   
   if (count < 0)
      return( o_nil );      
   else
      return( AssignObj( new_int( (int) count ) ) );
}

/****i* vPrintf() [3.0] ************************************
*
* NAME
*    VPrintf -- format and print string (buffered)
*               ^ <primitive 246 53 format argv>
* SYNOPSIS
*    LONG count = VPrintf( char *fmt, LONG *argv );
*
* FUNCTION
*    Writes the formatted string and values to Output().  This routine is 
*    assumed to handle all internal buffering so that the formatting string
*    and resultant formatted values can be arbitrarily long.  Any secondary
*    error code is returned in IoErr().  This routine is buffered.
*
*    Note: RawDoFmt assumes 16 bit ints, so you will usually need 'l's in
*    your formats (ex: %ld versus %d).
*
* INPUTS
*    fmt   - exec.library RawDoFmt() style formatting string
*    argv  - Pointer to array of formatting values
*   
* RESULT
*    count - Number of bytes written or -1 (EOF) for an error
*
* BUGS
*    The prototype for Printf() currently forces you to cast the first
*    varargs parameter to LONG due to a deficiency in the program
*    that generates fds, prototypes, and amiga.lib stubs.
*
* SEE ALSO
*    VFPrintf(), VFWritef(), RawDoFmt(), FPutC()
************************************************************
*
*/

METHODFUNC OBJECT *vPrintf( char *fmt, LONG *argv )
{
   LONG count = VPrintf( fmt, argv );
   
   if (count < 0)
      return( o_nil );      
   else
      return( AssignObj( new_int( (int) count ) ) );
}

/****i* waitForChar() [3.0] ********************************
*
* NAME
*    WaitForChar -- Determine if chars arrive within a time limit
*                   ^ <primitive 246 54 bptrFH timeout>
* SYNOPSIS
*    BOOL status = WaitForChar( BPTR file, LONG timeout );
*
* FUNCTION
*    If a character is available to be read from 'file' within the
*    time (in microseconds) indicated by 'timeout', WaitForChar()
*    returns -1 (TRUE). If a character is available, you can use Read()
*    to read it.  Note that WaitForChar() is only valid when the I/O
*    stream is connected to a virtual terminal device. If a character is
*    not available within 'timeout', a 0 (FALSE) is returned.
*
* BUGS
*    Due to a bug in the timer.device in V1.2/V1.3, specifying a timeout
*    of zero for WaitForChar() can cause the unreliable timer & floppy
*    disk operation.
*
* INPUTS
*    file - BCPL pointer to a file handle
*    timeout - integer
*
* SEE ALSO
*    Read(), FGetC()
************************************************************
*
*/

METHODFUNC OBJECT *waitForChar( BPTR file, LONG timeout )
{
   if (!file) // == NULL)
      return( o_nil );
      
   if (WaitForChar( file, timeout ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* filePart() [3.0] ***********************************
*
* NAME
*    FilePart -- Returns the last component of a path
*                    ^ <primitive 246 55 pathFileName>
* SYNOPSIS
*    char *fileptr = FilePart( char *path );
*
* FUNCTION
*    This function returns a pointer to the last component of a string path
*    specification, which will normally be the file name.  If there is only
*    one component, it returns a pointer to the beginning of the string.
*
* EXAMPLE
*    FilePart("xxx:yyy/qqq") would return a pointer to the first 'q'.
*    FilePart("xxx:yyy") would return a pointer to the first 'y').
************************************************************
*
*/

METHODFUNC OBJECT *filePart( char *path )
{
   char *rval = NULL;
   
   if (!path) // == NULL)
      return( o_nil );
      
   if (!(rval = FilePart( path ))) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_str( rval ) ) );
}

/****i* realPathPart() [3.0] ***********************************
*
* NAME
*    realPathPart --  ^ <primitive 246 56 path>
*
* SYNOPSIS
*    char *fileptr = realPathPart( char *path );
*
* FUNCTION
*    Returns a pointer to the path-only part of a pathFileName
************************************************************
*
*/

METHODFUNC OBJECT *realPathPart( char *path )
{
   char rval[512];
   
   if (!path) // == NULL)
      return( o_nil );
      
   (void) GetPathName( rval, path, 512 ); // In CommonFuncs.c
   
   return( AssignObj( new_str( rval ) ) );
}

/****i* ConvertMaskt() [3.0] *******************************
*
* NAME
*    ConvertMask --  ^ <primitive 246 57 protectionString>
*
* SYNOPSIS
*    LONG = ConvertMask( char *protectionString );
*
* FUNCTION
*    Change a string of protection-bit specifiers to a 
*    protection bit-mask.  The format of the string is:
*
*      +xxxx-xxxx where x can be H S P A R W E D.
*
************************************************************
*
*/

METHODFUNC OBJECT *ConvertMask( char *protectString )
{
   LONG  rval   = 0L;
   int   length = 0, i = 0;
   char *cp     = NULL;
      
   if (!protectString) // == NULL)
      return( o_nil );
      
   length = StringLength( protectString );
   
   cp = protectString;
   
   while (i < length)
      {
      if (*(cp + i) == PLUS_CHAR)
         {
         i++;
         
         while (i < length && *(cp + i) != MINUS_CHAR)
            {
            switch (*(cp + i))
               {
               case SMALL_H_CHAR:
               case CAP_H_CHAR:
#                 ifdef   __SASC
                  rval |= FIBF_HIDDEN;
#                 else
                  rval |= FIBF_HOLD;
#                 endif
                  break;
                  
               case CAP_S_CHAR:
               case SMALL_S_CHAR:
                  rval |= FIBF_SCRIPT;
                  break;
                                 
               case CAP_P_CHAR:
               case SMALL_P_CHAR:
                  rval |= FIBF_PURE;
                  break;

               case CAP_A_CHAR:
               case SMALL_A_CHAR:
                  rval |= FIBF_ARCHIVE;
                  break;

               case CAP_R_CHAR:
               case SMALL_R_CHAR:
                  rval &= ~FIBF_READ;
                  break;

               case CAP_W_CHAR:
               case SMALL_W_CHAR:
                  rval &= ~FIBF_WRITE;
                  break;

               case CAP_E_CHAR:
               case SMALL_E_CHAR:
                  rval &= ~FIBF_EXECUTE;
                  break;

               case CAP_D_CHAR:
               case SMALL_D_CHAR:
                  rval &= ~FIBF_DELETE;
                  break;
                  
               case SPACE_CHAR:
                  break;
               }
               
            i++;
            }
         }
      
      if (*(cp + i) == MINUS_CHAR)     
         {
         i++;
         
         while (i < length && *(cp + i) != PLUS_CHAR)
            {
            switch (*(cp + i))
               {
               case CAP_H_CHAR:
               case SMALL_H_CHAR:
#                 ifdef __SASC
                  rval &= ~FIBF_HIDDEN;
#                 else
                  rval &= ~FIBF_HOLD;
#                 endif
                  break;
                  
               case CAP_S_CHAR:
               case SMALL_S_CHAR:
                  rval &= ~FIBF_SCRIPT;
                  break;
                                 
               case CAP_P_CHAR:
               case SMALL_P_CHAR:
                  rval &= ~FIBF_PURE;
                  break;

               case CAP_A_CHAR:
               case SMALL_A_CHAR:
                  rval &= ~FIBF_ARCHIVE;
                  break;

               case CAP_R_CHAR:
               case SMALL_R_CHAR:
                  rval |= FIBF_READ;
                  break;

               case CAP_W_CHAR:
               case SMALL_W_CHAR:
                  rval |= FIBF_WRITE;
                  break;

               case CAP_E_CHAR:
               case SMALL_E_CHAR:
                  rval |= FIBF_EXECUTE;
                  break;

               case CAP_D_CHAR:
               case SMALL_D_CHAR:
                  rval |= FIBF_DELETE;
                  break;
                  
               case SPACE_CHAR:
                  break;
               }
               
            i++;
            }
         }

      i++;
      }

   return( AssignObj( new_int( (int) rval ) ) );
}

/****i* TranslateIoErr() [3.0] *************************************
*
* NAME
*    TranslateIoErr()  ^ <primitive 246 58 errorCode>
*
* DESCRIPTION
*    Translate IoErr() number into an error String.
********************************************************************
*
*/

METHODFUNC OBJECT *TranslateIoErr( LONG errorCode )
{
   OBJECT *rval = o_nil;
   
   switch (errorCode)
      {
      case RETURN_OK:
         rval = AssignObj( new_str( ioErrStrs[0] ) );
         break;
      
      case RETURN_WARN:   
         rval = AssignObj( new_str( ioErrStrs[1] ) );
         break;
      
      case RETURN_ERROR:   
         rval = AssignObj( new_str( ioErrStrs[2] ) );
         break;
      
      case RETURN_FAIL:   
         rval = AssignObj( new_str( ioErrStrs[3] ) );
         break;
      
      case ERROR_NO_FREE_STORE:
         rval = AssignObj( new_str( ioErrStrs[4] ) );
         break;
         
      case ERROR_TASK_TABLE_FULL:
         rval = AssignObj( new_str( ioErrStrs[5] ) );
         break;
         
      case ERROR_BAD_TEMPLATE:
         rval = AssignObj( new_str( ioErrStrs[6] ) );
         break;
         
      case ERROR_BAD_NUMBER:
         rval = AssignObj( new_str( ioErrStrs[7] ) );
         break;
         
      case ERROR_REQUIRED_ARG_MISSING:
         rval = AssignObj( new_str( ioErrStrs[8] ) );
         break;
         
      case ERROR_KEY_NEEDS_ARG:
         rval = AssignObj( new_str( ioErrStrs[9] ) );
         break;
         
      case ERROR_TOO_MANY_ARGS:
         rval = AssignObj( new_str( ioErrStrs[10] ) );
         break;
         
      case ERROR_UNMATCHED_QUOTES:
         rval = AssignObj( new_str( ioErrStrs[11] ) );
         break;
         
      case ERROR_LINE_TOO_LONG:
         rval = AssignObj( new_str( ioErrStrs[12] ) );
         break;
         
      case ERROR_FILE_NOT_OBJECT:
         rval = AssignObj( new_str( ioErrStrs[13] ) );
         break;
         
      case ERROR_INVALID_RESIDENT_LIBRARY:
         rval = AssignObj( new_str( ioErrStrs[14] ) );
         break;
         
      case ERROR_NO_DEFAULT_DIR:
         rval = AssignObj( new_str( ioErrStrs[15] ) );
         break;
         
      case ERROR_OBJECT_IN_USE:
         rval = AssignObj( new_str( ioErrStrs[16] ) );
         break;
         
      case ERROR_OBJECT_EXISTS:
         rval = AssignObj( new_str( ioErrStrs[17] ) );
         break;
         
      case ERROR_DIR_NOT_FOUND:
         rval = AssignObj( new_str( ioErrStrs[18] ) );
         break;
         
      case ERROR_OBJECT_NOT_FOUND:
         rval = AssignObj( new_str( ioErrStrs[19] ) );
         break;
         
      case ERROR_BAD_STREAM_NAME:
         rval = AssignObj( new_str( ioErrStrs[20] ) );
         break;
         
      case ERROR_OBJECT_TOO_LARGE:
         rval = AssignObj( new_str( ioErrStrs[21] ) );
         break;
         
      case ERROR_ACTION_NOT_KNOWN:
         rval = AssignObj( new_str( ioErrStrs[22] ) );
         break;
         
      case ERROR_INVALID_COMPONENT_NAME:
         rval = AssignObj( new_str( ioErrStrs[23] ) );
         break;
         
      case ERROR_INVALID_LOCK:
         rval = AssignObj( new_str( ioErrStrs[24] ) );
         break;
         
      case ERROR_OBJECT_WRONG_TYPE:
         rval = AssignObj( new_str( ioErrStrs[25] ) );
         break;
         
      case ERROR_DISK_NOT_VALIDATED:
         rval = AssignObj( new_str( ioErrStrs[26] ) );
         break;
         
      case ERROR_DISK_WRITE_PROTECTED:
         rval = AssignObj( new_str( ioErrStrs[27] ) );
         break;
         
      case ERROR_RENAME_ACROSS_DEVICES:
         rval = AssignObj( new_str( ioErrStrs[28] ) );
         break;
         
      case ERROR_DIRECTORY_NOT_EMPTY:
         rval = AssignObj( new_str( ioErrStrs[29] ) );
         break;
         
      case ERROR_TOO_MANY_LEVELS:
         rval = AssignObj( new_str( ioErrStrs[30] ) );
         break;
         
      case ERROR_DEVICE_NOT_MOUNTED:
         rval = AssignObj( new_str( ioErrStrs[31] ) );
         break;
         
      case ERROR_SEEK_ERROR:
         rval = AssignObj( new_str( ioErrStrs[32] ) );
         break;
         
      case ERROR_COMMENT_TOO_BIG:
         rval = AssignObj( new_str( ioErrStrs[33] ) );
         break;
         
      case ERROR_DISK_FULL:
         rval = AssignObj( new_str( ioErrStrs[34] ) );
         break;
         
      case ERROR_DELETE_PROTECTED:
         rval = AssignObj( new_str( ioErrStrs[35] ) );
         break;
         
      case ERROR_WRITE_PROTECTED:
         rval = AssignObj( new_str( ioErrStrs[36] ) );
         break;
         
      case ERROR_READ_PROTECTED:
         rval = AssignObj( new_str( ioErrStrs[37] ) );
         break;
         
      case ERROR_NOT_A_DOS_DISK:
         rval = AssignObj( new_str( ioErrStrs[38] ) );
         break;
         
      case ERROR_NO_DISK:
         rval = AssignObj( new_str( ioErrStrs[39] ) );
         break;
         
      case ERROR_NO_MORE_ENTRIES:
         rval = AssignObj( new_str( ioErrStrs[40] ) );
         break;
         
      case ERROR_IS_SOFT_LINK:
         rval = AssignObj( new_str( ioErrStrs[41] ) );
         break;
         
      case ERROR_OBJECT_LINKED:
         rval = AssignObj( new_str( ioErrStrs[42] ) );
         break;
         
      case ERROR_BAD_HUNK:
         rval = AssignObj( new_str( ioErrStrs[43] ) );
         break;
         
      case ERROR_NOT_IMPLEMENTED:
         rval = AssignObj( new_str( ioErrStrs[44] ) );
         break;
         
      case ERROR_RECORD_NOT_LOCKED:
         rval = AssignObj( new_str( ioErrStrs[45] ) );
         break;
         
      case ERROR_LOCK_COLLISION:
         rval = AssignObj( new_str( ioErrStrs[46] ) );
         break;
         
      case ERROR_LOCK_TIMEOUT:
         rval = AssignObj( new_str( ioErrStrs[47] ) );
         break;
         
      case ERROR_UNLOCK_ERROR:
         rval = AssignObj( new_str( ioErrStrs[48] ) );
         break;
         
      case ABORT_DISK_ERROR:
         rval = AssignObj( new_str( ioErrStrs[49] ) );
         break;
         
      case ABORT_BUSY:
         rval = AssignObj( new_str( ioErrStrs[50] ) );
         break;
         
      case ERROR_BUFFER_OVERFLOW:
         rval = AssignObj( new_str( ioErrStrs[51] ) );
         break;
         
      case ERROR_BREAK:
         rval = AssignObj( new_str( ioErrStrs[52] ) );
         break;
         
      case ERROR_NOT_EXECUTABLE:
         rval = AssignObj( new_str( ioErrStrs[53] ) );
         break;
         
      /* Error message numbers I've added: */

      case NO_UPDATE_PERFORMED:
         rval = AssignObj( new_str( ioErrStrs[54] ) );
         break;
         
      case TAPE_UNFORMATTED:
         rval = AssignObj( new_str( ioErrStrs[55] ) );
         break;
         
      case TAPE_NOT_READY:
         rval = AssignObj( new_str( ioErrStrs[56] ) );
         break;
         
      case TAPE_COMMAND_PROBLEM:
         rval = AssignObj( new_str( ioErrStrs[57] ) );
         break;
         
      case ERROR_ON_OPENING_SCREEN:
         rval = AssignObj( new_str( ioErrStrs[58] ) );
         break;
         
      case ERROR_ON_OPENING_WINDOW:
         rval = AssignObj( new_str( ioErrStrs[59] ) );
         break;
         
      case ERROR_ON_GADTOOLS_INIT:
         rval = AssignObj( new_str( ioErrStrs[60] ) );
         break;
         
      case ERROR_LIBRARY_NOT_OPENED:
         rval = AssignObj( new_str( ioErrStrs[61] ) );
         break;
         
      case MENU_NUMBER_OUT_OF_RANGE:
         rval = AssignObj( new_str( ioErrStrs[62] ) );
         break;
         
      case ITEM_NUMBER_OUT_OF_RANGE:
         rval = AssignObj( new_str( ioErrStrs[63] ) );
         break;
         
      case SUB_NUMBER_OUT_OF_RANGE:
         rval = AssignObj( new_str( ioErrStrs[64] ) );
         break;
         
      case NULL_POINTER_FOUND:
         rval = AssignObj( new_str( ioErrStrs[65] ) );
         break;
      }
      
   return( rval );
}

/****h* HandleADos() [3.0] *****************************************
*
* NAME
*    HandleADosSafe()
*
* DESCRIPTION
*    Translate primitives (246) to AmigaDOS commands to the OS.
********************************************************************
*
*/

PRIVATE BOOL LibOpened = FALSE;

PUBLIC OBJECT *HandleADosSafe( int numargs, OBJECT **args )
{
#  ifdef  __SASC
   IMPORT struct DosLibrary *DOSBase;
#  else
   IMPORT struct Library *DOSBase;
#  endif
   
   OBJECT *rval = o_nil;
         
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 246 );
      return( rval );
      }

   if (!DOSBase) // == NULL)
      {
#     ifdef  __SASC
      if (!(DOSBase = (struct DosLibrary *) OpenLibrary( DOSNAME, 44L )))
         return( rval );
#     else
      if ((DOSBase = OpenLibrary( DOSNAME, 50L )))
         {
	 if (!(IDOS = (struct DOSIFace *) GetInterface( DOSBase, "main", 1, NULL)))
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
#     ifdef  __SASC
      case 0:  // void AbortPacket( struct MsgPort *mp, struct DosPacket *dp );
               // <primitive 246 0 mp dp>
         if (!is_address( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            AbortPacket( (struct MsgPort   *) addr_value( args[1] ),
                         (struct DosPacket *) addr_value( args[2] )
                       );
         break;
#     endif
      
      case 1:  // boolean = addBuffers( char *filesystem, LONG number );
               // ^ <primitive 246 1 filesystem number>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = addBuffers(     string_value( (STRING *) args[1] ),
                               (LONG) int_value( args[2] )
                             );
         break;

      case 2:  // cliPointer = cliPointer( void );
               // ^ <primitive 246 2>
         rval = cliPointer();
         break;

      case 3:  // integer = compareDates( struct DateStamp *d1, struct DateStamp *d2 );
               // ^ <primitive 246 3 dateStamp1 dateStamp2>
         if (!is_address( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = compareDates( (struct DateStamp *) addr_value( args[1] ),
                                 (struct DateStamp *) addr_value( args[2] )
                               );
         break;

      case 4:  // oldLock = currentDir( BPTR lock );
               // ^ <primitive 246 4 bptrLock>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = currentDir( (BPTR) addr_value( args[1] ) );

         break;

      case 5:  // boolean = dateToStr( struct DateTime *dt );
               // ^ <primitive 246 5 dateTime>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = dateToStr( (struct DateTime *) addr_value( args[1] ) );

         break;

      case 6:  // void delay( ULONG ticks );
               // <primitive 246 6 ticks>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            delay( (ULONG) int_value( args[1] ) );

         break;

      case 7:  // void endNotify( struct NotifyRequest *notifystructure )
               // <primitive 246 7 notifyStructure>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            endNotify( (struct NotifyRequest *) addr_value( args[1] ) );

         break;

      case 8:  // boolean = errorReport( LONG code, LONG type, ULONG arg1, 
               //                        struct MsgPort *device );
               // ^ <primitive 246 8 code type arg1 deviceMPort>
         if (ChkArgCount( 5, numargs, 246 ) != 0)
            return( ReturnError() );

         if (!is_integer( args[1] ) || !is_integer( args[2] )
                                    || !is_integer( args[3] )
                                    || !is_address( args[4] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = errorReport( (LONG)  int_value( args[1] ),
                                (LONG)  int_value( args[2] ),
                                (ULONG) int_value( args[3] ),

                                (struct MsgPort *) addr_value( args[4] )
                              );
         break;

      case 9:  // length = fault( LONG code, char *header, char *buffer, LONG len );
               // ^ <primitive 246 9 code header buffer length>
         if (ChkArgCount( 5, numargs, 246 ) != 0)
            return( ReturnError() );

         if (!is_integer( args[1] ) || !is_string(   args[2] )
                                    || !is_string(   args[3] )
                                    || !is_integer(  args[4] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = fault( (LONG) int_value( args[1] ),
                              string_value( (STRING *) args[2] ),
                              string_value( (STRING *) args[3] ),
                          (LONG) int_value( args[4] )
                        );
         break;

      case 10: // chr = fGetC( BPTR fh )
               // ^ <primitive 246 10 bptrFH>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = fGetC( (BPTR) addr_value( args[1] ) );

         break;

      case 11: // string = fGets( BPTR fh, char *buffer, ULONG length, BOOL flag );
               // ^ <primitive 246 11 bptrFH buffer length flag>
         if (ChkArgCount( 5, numargs, 246 ) != 0)
            return( ReturnError() );

         if (!is_address( args[1] ) || !is_string(   args[2] )
                                    || !is_integer(  args[3] )
                                    || !is_integer(  args[4] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = fGets( (BPTR) addr_value( args[1] ),
                               string_value( (STRING *) args[2] ),

                          (ULONG) int_value( args[3] ),
                          (BOOL)  int_value( args[4] )
                        );
         break;

      case 12: // process = findCliProc( ULONG number );
               // ^ <primitive 246 12 number>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = findCliProc( (ULONG) int_value( args[1] ) );

         break;

      case 13: // struct LocalVar = findVar( char *name, ULONG type );
               // ^ <primitive 246 13 name type>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = findVar(      string_value( (STRING *) args[1] ),
                            (ULONG) int_value( args[2] )
                          );
         break;

      case 14: // chr = fPutC( BPTR fh, LONG chr );
               // ^ <primitive 246 14 bptrFH chr>
         if (!is_address( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = fPutC( (BPTR) addr_value( args[1] ),
                          (LONG)  int_value( args[2] )
                        );
         break;

      case 15: // boolean = fPutS( BPTR fh, char *string );
               // ^ <primitive 246 15 bptrFH string>
         if (!is_address( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = fPutS( (BPTR) addr_value( args[1] ),
                               string_value( (STRING *) args[2] )
                        );
         break;

      case 16: // string = getArgStr( void );
               // ^ <primitive 246 16>
         rval = getArgStr();
         break;

      case 17: // mport = getConsoleTask( void );
               // ^ <primitive 246 17>
         rval = getConsoleTask();
         break;

      case 18: // boolean = getCurrentDirName( char *buffer, LONG length ); 
               // ^ <primitive 246 18 buffer length>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = getCurrentDirName(     string_value( (STRING *) args[1] ),
                                      (LONG) int_value( args[2] )
                                    );
         break;

      case 19: // devProc = getDeviceProc( char *name, struct DevProc *devproc );
               // ^ <primitive 246 19 name devProc>
         if (!is_string( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = getDeviceProc(                  string_value( (STRING *) args[1] ),
                                  (struct DevProc *) addr_value( args[2] )
                                );
         break;
               
      case 20: // mport = getFileSysTask( void );
               // ^ <primitive 246 20>
         rval = getFileSysTask();
         break;

      case 21: // bptrLock = getProgramDir( void )
               // ^ <primitive 246 21>
         rval = getProgramDir();
         break;
         
      case 22: // boolean = getProgramName( char *buffer, LONG length );
               // ^ <primitive 246 22 buffer length>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = getProgramName(     string_value( (STRING *) args[1] ),
                                   (LONG) int_value( args[2] )
                                 );
         break;

      case 23: // boolean = getPrompt( char *buffer, LONG length );
               // ^ <primitive 246 buffer length>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = getPrompt(     string_value( (STRING *) args[1] ),
                              (LONG) int_value( args[2] )
                            );
         break;

      case 24: // length = getVar( char *name, char *buffer, LONG size, LONG flags );
               // ^ <primitive 246 24 name buffer size flags>
         if (ChkArgCount( 5, numargs, 246 ) != 0)
            return( ReturnError() );

         if (!is_string( args[1] ) || !is_string(   args[2] )
                                   || !is_integer(  args[3] )
                                   || !is_integer(  args[4] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = getVar( string_value( (STRING *) args[1] ),
                           string_value( (STRING *) args[2] ),

                           (LONG) int_value( args[3] ),
                           (LONG) int_value( args[4] )
                         );
         break;

      case 25: // value = ioErr( void );
               // ^ <primitive 246 25>
         rval = ioErr();
         break;
         
      case 26: // boolean = isFileSystem( char *name );
               // ^ <primitive 246 26 name>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = isFileSystem( string_value( (STRING *) args[1] ) );

         break;

      case 27: // boolean = isInteractive( BPTR file );
               // ^ <primitive 246 27 bptrFile>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = isInteractive( (BPTR) addr_value( args[1] ) );

         break;
               
      case 28: // void matchEnd( struct AnchorPath *ap );
               // <primitive 246 28 ap>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            matchEnd( (struct AnchorPath *) addr_value( args[1] ) );

         break;

      case 29: // boolean = matchFirst( char *pat, struct AnchorPath *ap );
               // ^ <primitive 246 29 pattern ap>
         if (!is_string( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = matchFirst(                     string_value( (STRING *) args[1] ),
                               (struct AnchorPath *) addr_value( args[2] )
                             );
         break;

      case 30: // boolean = matchNext( struct AnchorPath *ap );
               // ^ <primitive 246 30 ap>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = matchNext( (struct AnchorPath *) addr_value( args[1] ) );

         break;

      case 31: // number = maxCli( void );
               // ^ <primitive 246 31>
         rval = maxCli();
         break;
         
      case 32: // bptrLock = parentDir( BPTR lock );
               // ^ <primitive 246 33 lock>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = parentDir( (BPTR) addr_value( args[1] ) );

         break;

      case 33: // bptrLock = parentOfFH( BPTR fh );
               // ^ <primitive 246 33 fh>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = parentOfFH( (BPTR) addr_value( args[1] ) );

         break;

      case 34: // str = pathPart( char *path );
               // ^ <primitive 246 34 path>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = pathPart( string_value( (STRING *) args[1] ) );

         break;
               
      case 35: // boolean = printFault( LONG code, char *header );
               // ^ <primitive 246 35 code header>
         if (!is_integer( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = printFault( (LONG) int_value( args[1] ),
                                   string_value( (STRING *) args[2] )
                             );
         break;

      case 36: // boolean = putStr( char *string );
               // ^ <primitive 246 36 string>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = putStr( string_value( (STRING *) args[1] ) );

         break;
               
      case 37: // length = readFile( BPTR file, void *buffer, LONG length );
               // ^ <primitive 246 37 file buffer length>
         if (!is_address( args[1] ) || !is_string(  args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = readFile( (BPTR) addr_value( args[1] ),
                                  string_value( (STRING *) args[2] ),
                             (LONG)  int_value( args[3] )
                           );
         break;

      case 38: // rdArgs = readArgs( char *template, LONG *array, struct RDArgs *rdargs );
               // ^ <primitive 246 38 template array rdArgs>
         if (!is_string( args[1] ) || !is_address( args[2] )
                                   || !is_address( args[3] ))
            (void) PrintArgTypeError( 246 );
         else 
            rval = readArgs(                 string_value( (STRING *) args[1] ),
                                      (LONG *) addr_value( args[2] ),
                             (struct RDArgs *) addr_value( args[3] )
                           );
         break;
               
      case 39: // value = readItem( char *buffer, LONG maxChars, struct CSource *input );
               // ^ <primitive 246 39 buffer maxChars input>

         if (!is_string( args[1] ) || !is_integer( args[2] )
                                   || !is_address( args[3] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = readItem(                  string_value( (STRING *) args[1] ),
                                         (LONG)  int_value( args[2] ),
                             (struct CSource *) addr_value( args[3] )
                           );
         break;

      case 40: // boolean = readLink( struct MsgPort *port, BPTR lock, char *path, 
               //                     char           *buffer, ULONG size );
               // ^ <primitive 246 40 port lock path buffer size>
         if (ChkArgCount( 6, numargs, 246 ) != 0)
            return( ReturnError() );

         if (!is_address( args[1] ) || !is_address( args[2] )
                                    || !is_string(  args[3] )
                                    || !is_string(  args[4] )
                                    || !is_integer( args[5] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = readLink(  (struct MsgPort *) addr_value( args[1] ),
                                          (BPTR)  int_value( args[2] ),
                                   string_value(  (STRING *) args[3] ),
                                   string_value(  (STRING *) args[4] ),
                                        (ULONG)  addr_value( args[5] )
                           );
         break;

      case 41: // boolean = sameDevice( BPTR lock1, BPTR lock2 );
               // ^ <primitive 246 41 lock1 lock2>
         if (!is_address( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = sameDevice( (BPTR) addr_value( args[1] ),
                               (BPTR) addr_value( args[2] )
                             );
         break;

      case 42: // value = sameLock( BPTR lock1, BPTR lock2 );
               // ^ <primitive 246 42 bptrLock1 bptrLock2>
         if (!is_address( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = sameLock( (BPTR) addr_value( args[1] ),
                             (BPTR) addr_value( args[2] )
                           );
         break;
               
      case 43: // boolean = setComment( char *name, char *comment );
               // ^ <primitive 246 43 name comment>
         if (!is_string( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = setComment( string_value( (STRING *) args[1] ),
                               string_value( (STRING *) args[2] )
                             );
         break;

      case 44: // boolean = setFileDate( char *name, struct DateStamp *date );
               // ^ <primitive 246 44 name dateStamp>
         if (!is_string( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = setFileDate(                    string_value( (STRING *) args[1] ),
                                (struct DateStamp *) addr_value( args[2] )
                              );
         break;
               
      case 45: // longvalue = setIoErr( LONG code );
               // ^ <primitive 246 45 code>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = setIoErr( (LONG) int_value( args[1] ) );

         break;

      case 46: // boolean = setPrompt( char *name );
               // ^ <primitive 246 46 name>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = setPrompt( string_value( (STRING *) args[1] ) );

         break;
               
      case 47: // boolean = setProtection( char *name, LONG mask );
               // ^ <primitive 246 47 name mask>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = setProtection(     string_value( (STRING *) args[1] ),
                                  (LONG) int_value( args[2] )
                                );
         break;

      case 48: // splitName( char *name, UBYTE sep, char *buf, WORD oldpos, LONG size ); 
               // ^ <primitive 246 48 name sep buf oldpos size>
         if (ChkArgCount( 6, numargs, 246 ) != 0)
            return( ReturnError() );

         if (!is_string( args[1] ) || !is_integer( args[2] )
                                   || !is_string(  args[3] )
                                   || !is_integer( args[4] )
                                   || !is_integer( args[5] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = splitName(      string_value( (STRING *) args[1] ),
                              (UBYTE) int_value( args[2] ),
                                   string_value( (STRING *) args[3] ),
                              (WORD)  int_value( args[4] ),
                              (LONG)  int_value( args[5] )
                            );
         break;
               
      case 49: // boolean = strToDate( struct DateTime *datetime );
               // ^ <primitive 246 49 dateTime>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = strToDate( (struct DateTime *) addr_value( args[1] ) );

         break;
               
      case 50: // longvalue = strToLong( char *string )
               // ^ <primitive 246 50 string>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = strToLong( string_value( (STRING *) args[1] ) );

         break;

      case 51: // boolean = unGetC( BPTR fh, LONG chr );
               // ^ <primitive 246 51 bptrFH chr>
         if (!is_address( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = unGetC( (BPTR) addr_value( args[1] ),
                           (LONG)  int_value( args[2] )
                         );
         break;

               
      case 52: // count = vFPrintf( BPTR fh, char *fmt, LONG *argv );
               // ^ <primitive 246 52 bptrFH format argv>
         if (!is_address( args[1] ) || !is_string( args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = vFPrintf( (BPTR)   addr_value( args[1] ),
                                    string_value( (STRING *) args[2] ),
                              (LONG *) int_value( args[3] )
                           );
         break;

      case 53: // count = vPrintf( char *fmt, LONG *argv );
               // ^ <primitive 246 53 format argv>
         if (!is_string( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = vPrintf(        string_value( (STRING *) args[1] ),
                            (LONG *) addr_value( args[2] )
                          );
         break;

      case 54: // BOOL status = WaitForChar( BPTR file, LONG timeout );
               // ^ <primitive 246 54 bptrFH timeout>
         if (!is_address( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 246 );
         else
            rval = waitForChar( (BPTR) addr_value( args[1] ),
                                (LONG)  int_value( args[2] )
                              );
         break;

      case 55: // filePart: pathFileName
               //   ^ <primitive 246 55 pathFileName>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = filePart( string_value( (STRING *) args[1] ) );
         
         break;

      case 56: // realPathPart: pathFileName
               //   ^ <primitive 246 56 path>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = realPathPart( string_value( (STRING *) args[1] ) );
         
         break;

      case 57: // stringToProtectionMask: protectionString
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = ConvertMask( string_value( (STRING *) args[1] ) );
         
         break;

      case 58: // char *TranslateIoErr( LONG errorCode );
               //   ^ <primitive 246 58 errorCode>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 246 );
         else
            rval = TranslateIoErr( (LONG) int_value( args[1] ) );
         
         break;
                  
      default:
         (void) PrintArgTypeError( 246 );
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

/* ----------------------- END of ADOS1.c file! ------------------------ */
