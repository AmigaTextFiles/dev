/****h* AmigaTalk/ADOS2.c [3.0] ***************************************
*
* NAME
*    ADOS2.c
*
* DESCRIPTION
*    Relatively UnSafe DOS commands to use are in this file. <247>
*    ADOS1.c contains safe           DOS commands <246>,
*    ADOS3.c contains Dangerous      DOS commands <248> &
*    ADOS4.c contains Very Dangerous DOS commands <249>
* FUNCTIONAL INTERFACE:
*
*    PUBLIC OBJECT *HandleADosUnSafe( int numargs, OBJECT **args );
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*
* NOTES
*    $VER: AmigaTalk:Src/ADOS2.c 3.0 (24-Oct-2004) by J.T. Steichen
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
#include <dos/dosextens.h>

#ifndef __amigaos4__
#include <clib/dos_protos.h>
#else

# define __USE_INLINE__

# include <proto/dos.h>

IMPORT struct DOSIFace *IDOS; // -lauto will take care of this

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Constants.h"
#include "StringConstants.h"
#include "Object.h"

#include "FuncProtos.h"

#include "IStructs.h"

IMPORT OBJECT *PrintArgTypeError( int primnumber );

IMPORT OBJECT *o_nil, *o_true, *o_false;

/****i* addPart() [3.0] ************************************
*
* NAME
*    AddPart -- Appends a file/dir to the end of a path
*                    ^ <primitive 247 0 dirName fileName size>
* SYNOPSIS
*    BOOL success = AddPart( char *dirname, char *filename, ULONG size )
*
* FUNCTION
*    This function adds a file, directory, or subpath name to a directory
*    path name taking into account any required separator characters.  If
*    filename is a fully-qualified path it will totally replace the current
*    value of dirname.
*   
* INPUTS
*    dirname  - the path to add a file/directory name to.
*    filename - the filename or directory name to add.  May be a relative
*          pathname from the current directory (example: foo/bar).
*          Can deal with leading '/'(s), indicating one directory up
*          per '/', or with a ':', indicating it's relative to the
*          root of the appropriate volume.
*    size     - size in bytes of the space allocated for dirname.  Must
*          not be 0.
*
* RESULT
*    success - non-zero for ok, FALSE if the buffer would have overflowed.
*         If an overflow would have occured, dirname will not be
*         changed.
************************************************************
*
*/

METHODFUNC OBJECT *addPart( char *dirname, char *filename, ULONG size )
{
   if (!dirname || !filename || (size < 1))
      return( o_nil );
      
   if (AddPart( dirname, filename, size ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* assignAdd() [3.0] **********************************
*
* NAME
*    AssignAdd -- Adds a lock to an assign for multi-directory assigns
*                    ^ <primitive 247 1 assignName bptrLock>
* SYNOPSIS
*    BOOL success = AssignAdd( char *name, BPTR lock );
*
* FUNCTION
*    Adds a lock to an assign, making or adding to a multi-directory
*    assign.  Note that this only will succeed on an assign created with
*    AssignLock(), or an assign created with AssignLate() which has been
*    resolved (converted into a AssignLock()-assign).
*
*    NOTE: you should not use the lock in any way after making this call
*    successfully.  It becomes the part of the assign, and will be unlocked
*    by the system when the assign is removed.  If you need to keep the
*    lock, pass a lock from DupLock() to AssignLock().
*
* INPUTS
*    name - Name of device to assign lock to (without trailing ':')
*    lock - Lock associated with the assigned name
*
* RESULT
*    success - Success/failure indicator.  On failure, 
*              the lock is not unlocked.
************************************************************
*
*/

METHODFUNC OBJECT *assignAdd( char *name, BPTR lock )
{
   if (!name) // == NULL)
      return( o_nil );

   if (name[ StringLength( name ) ] == COLON_CHAR)
      name[ StringLength( name ) ] = NIL_CHAR;
      
   if (AssignAdd( name, lock ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* assignLate() [3.0] *********************************
*
* NAME
*    AssignLate -- Creates an assignment to a specified path later
*                    ^ <primitive 247 2 assignName pathFileName>
* SYNOPSIS
*    BOOL success = AssignLate( char *name, char *path );
*
* FUNCTION
*    Sets up a assignment that is expanded upon the FIRST reference to the
*    name.  The path (a string) would be attached to the node.  When
*    the name is referenced (Open("FOO:xyzzy"...), the string will be used
*    to determine where to set the assign to, and if the directory can be
*    locked, the assign will act from that point on as if it had been
*    created by AssignLock().
*
*    A major advantage is assigning things to unmounted volumes, which
*    will be requested upon access (useful in startup sequences).
*
* INPUTS
*    name - Name of device to be assigned (without trailing COLON_CHAR)
*    path - Name of late assignment to be resolved on the first reference.
************************************************************
*
*/

METHODFUNC OBJECT *assignLate( char *name, char *path )
{
   if (!name || !path) // == NULL)
      return( o_nil );
 
   if (name[ StringLength( name ) ] == COLON_CHAR)
      name[ StringLength( name ) ] = NIL_CHAR;

   if (AssignLate( name, path ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* assignLock() [3.0] *********************************
*
* NAME
*    AssignLock -- Creates an assignment to a locked object
*                    ^ <primitive 247 3 assignName bptrLock>
* SYNOPSIS
*    BOOL success = AssignLock( char *name, BPTR lock );
*
* FUNCTION
*    Sets up an assign of a name to a given lock.  Passing NULL for a lock 
*    cancels any outstanding assign to that name.  If an assign entry of
*    that name is already on the list, this routine replaces that entry.  If
*    an entry is on the list that conflicts with the new assign, then a
*    failure code is returned.
*
*    NOTE: you should not use the lock in any way after making this call
*    successfully.  It becomes the assign, and will be unlocked by the
*    system when the assign is removed.  If you need to keep the lock,
*    pass a lock from DupLock() to AssignLock().
************************************************************
*
*/

METHODFUNC OBJECT *assignLock( char *name, BPTR lock )
{
   if (!name) // == NULL)
      return( o_nil );

   if (name[ StringLength( name ) ] == COLON_CHAR)
      name[ StringLength( name ) ] = NIL_CHAR;
      
   if (AssignLock( name, lock ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* assignPath() [3.0] *********************************
*
* NAME
*    AssignPath -- Creates an assignment to a specified path
*                    ^ <primitive 247 4 assignName pathName>
* SYNOPSIS
*    BOOL success = AssignPath( char *name, char *path );
*
* FUNCTION
*    Sets up a assignment that is expanded upon EACH reference to the name.
*    This is implemented through a new device list type (DLT_ASSIGNPATH, or
*    some such).  The path (a string) would be attached to the node.  When
*    the name is referenced (Open("FOO:xyzzy"...), the string will be used
*    to determine where to do the open.  No permanent lock will be part of
*    it.  For example, you could AssignPath() c2: to df2:c, and references
*    to c2: would go to df2:c, even if you change disks.
*
*    The other major advantage is assigning things to unmounted volumes,
*    which will be requested upon access (useful in startup sequences).
************************************************************
*
*/

METHODFUNC OBJECT *assignPath( char *name, char *path )
{
   if (!name || !path) // == NULL)
      return( o_nil );

   if (name[ StringLength( name ) ] == COLON_CHAR)
      name[ StringLength( name ) ] = NIL_CHAR;
      
   if (AssignPath( name, path ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* changeMode() [3.0] *********************************
*
* NAME
*    ChangeMode - Change the current mode of a lock or filehandle
*                    ^ <primitive 247 5 type bptrLockOrFH newMode>
* SYNOPSIS
*    BOOL success = ChangeMode( ULONG type, BPTR object, ULONG newmode );
*
* FUNCTION
*    This allows you to attempt to change the mode in use by a lock or
*    filehandle.  For example, you could attempt to turn a shared lock
*    into an exclusive lock.  The handler may well reject this request.
*    Warning: if you use the wrong type for the object, the system may
*    crash.
*
* INPUTS
*    type    - Either CHANGE_FH or CHANGE_LOCK
*    object  - A lock or filehandle
*    newmode - The new mode you want
************************************************************
*
*/

METHODFUNC OBJECT *changeMode( ULONG type, BPTR object, ULONG newmode )
{
   if ((type != CHANGE_FH) || (type != CHANGE_LOCK))
      return( o_nil );
      
   if (ChangeMode( type, object, newmode ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* checkSignal() [3.0] ********************************
*
* NAME
*    CheckSignal -- Checks for break signals
*                    ^ <primitive 247 6 signalMask>
* SYNOPSIS
*    ULONG signals = CheckSignal( ULONG mask );
*
* FUNCTION
*    This function checks to see if any signals specified in the mask have
*    been set and if so, returns them.  Otherwise it returns 0.
*    All signals specified in mask will be cleared.
************************************************************
*
*/

METHODFUNC OBJECT *checkSignal( ULONG mask )
{
   return( AssignObj( new_int( (int) CheckSignal( mask ) ) ) );
}

/****i* closeFile() [3.0] **********************************
*
* NAME
*    Close -- Close an open file
*                    ^ <primitive 247 7 bptrFileHandle>
* SYNOPSIS
*    BOOL success = Close( BPTR file );
*
* FUNCTION
*    The file specified by the file handle is closed. You must close all
*    files you explicitly opened, but you must not close inherited file
*    handles that are passed to you (each filehandle must be closed once
*    and ONLY once).  If Close() fails, the file handle is still
*    deallocated and should not be used.
*
* RESULTS
*    success - returns if Close() succeeded.  Note that it might fail
*         depending on buffering and whatever IO must be done to
*         close a file being written to.  NOTE: this return value
*         did not exist before V36! 
************************************************************
*
*/

METHODFUNC OBJECT *closeFile( BPTR file )
{
   if (Close( file ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* createDir() [3.0] **********************************
*
* NAME
*    CreateDir -- Create a new directory
*                    ^ <primitive 247 8 dirName>
* SYNOPSIS
*    BPTR lock = CreateDir( char *name )
*
* FUNCTION
*    CreateDir creates a new directory with the specified name. An error
*    is returned if it fails.  Directories can only be created on
*    devices which support them, e.g. disks.  CreateDir returns an
*    exclusive lock on the new directory if it succeeds.
************************************************************
*
*/

METHODFUNC OBJECT *createDir( char *name )
{
   BPTR rval = 0; // NULL;
   
   if (!name) // == NULL)
      return( o_nil );
      
   if (!(rval = CreateDir( name ))) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* dateStamp() [3.0] **********************************
*
* NAME
*    DateStamp -- Obtain the date and time in internal format
*                    ^ <primitive 247 9 dateStampObject>
* SYNOPSIS
*    struct DateStamp *ds = DateStamp( struct DateStamp *ds );
*
* FUNCTION
*    DateStamp() takes a structure of three longwords that is set to the
*    current time.  The first element in the vector is a count of the
*    number of days.  The second element is the number of minutes elapsed
*    in the day.  The third is the number of ticks elapsed in the current
*    minute.  A tick happens 50 times a second.  DateStamp() ensures that
*    the day and minute are consistent.  All three elements are zero if
*    the date is unset. DateStamp() currently only returns even
*    multiples of 50 ticks.  Therefore the time you get is always an even
*    number of ticks.
*
*    Time is measured from Jan 1, 1978.
*
* RESULTS
*    The array is filled as described and returned (for pre-V36 
*    compabability).
************************************************************
*
*/

METHODFUNC OBJECT *dateStamp( struct DateStamp *ds )
{
   if (!ds) // == NULL)
      return( o_nil );
      
   return( AssignObj( new_address( (ULONG) DateStamp( ds ) ) ) );
}

/****i* dupLock() [3.0] ************************************
*
* NAME
*    DupLock -- Duplicate a lock
*                    ^ <primitive 247 10 bptrLock>
* SYNOPSIS
*    BPTR lock = DupLock( BPTR lock );
*
* FUNCTION
*    DupLock() is passed a shared filing system lock.  This is the ONLY
*    way to obtain a duplicate of a lock... simply copying is not
*    allowed.
*
*    Another lock to the same object is then returned.  It is not
*    possible to create a copy of a exclusive lock.
*
*    A zero return indicates failure.
************************************************************
*
*/

METHODFUNC OBJECT *dupLock( BPTR lock )
{
   BPTR rval = DupLock( lock );
   
   if (!rval) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* dupLockFromFH() [3.0] ******************************
*
* NAME
*    DupLockFromFH -- Gets a lock on an open file
*                    ^ <primitive 247 11 bptrFileHandle>
* SYNOPSIS
*    BPTR lock = DupLockFromFH( BPTR fh );
*
* FUNCTION
*    Obtain a lock on the object associated with fh.  Only works if the
*    file was opened using a non-exclusive mode.  Other restrictions may be
*    placed on success by the filesystem.
************************************************************
*
*/

METHODFUNC OBJECT *dupLockFromFH( BPTR fh )
{
   BPTR rval = DupLockFromFH( fh );
   
   if (!rval) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* exAll() [3.0] **************************************
*
* NAME
*    ExAll -- Examine an entire directory
*                    ^ <primitive 247 12 bptrLock aBuffer size type exAllControl>
* SYNOPSIS
*    BOOL continue = ExAll( BPTR lock, char *buffer, 
*                           LONG size, LONG type, 
*                           struct ExAllControl *control );
*
* FUNCTION
*    Examines an entire directory.  
*
*    Lock must be on a directory.  Size is the size of the buffer supplied.
*    The buffer will be filled with (partial) ExAllData structures, as
*    specified by the type field.
*
*    Type is a value from those shown below that determines which information is
*    to be stored in the buffer.  Each higher value adds a new thing to the list
*    as described in the table below:-
*
*      ED_NAME        FileName
*      ED_TYPE        Type
*      ED_SIZE        Size in bytes
*      ED_PROTECTION  Protection bits
*      ED_DATE        3 longwords of date
*      ED_COMMENT     Comment (will be NULL if no comment)
*                     Note: the V37 ROM/disk filesystem returns this
*                           incorrectly as a BSTR.  See BUGS for a workaround.
*      ED_OWNER       owner user-id and group-id (if supported)  (V39)
*
*    Thus, ED_NAME gives only filenames, and ED_OWNER gives everything.
*
*    NOTE: V37 dos.library, when doing ExAll() emulation, and RAM: filesystem
*    will return an error if passed ED_OWNER.  If you get ERROR_BAD_NUMBER,
*    retry with ED_COMMENT to get everything but owner info.  All filesystems
*    supporting ExAll() must support through ED_COMMENT, and must check Type
*    and return ERROR_BAD_NUMBER if they don't support the type.
*
*    The V37 ROM/disk filesystem doesn't fill in the comment field correctly
*    if you specify ED_OWNER.  See BUGS for a workaround if you need to use
*    ED_OWNER.
*
*    The ead_Next entry gives a pointer to the next entry in the buffer.  The
*    last entry will have NULL in ead_Next.
*
*    The control structure is required so that FFS can keep track if more than
*    one call to ExAll is required.  This happens when there are more names in
*    a directory than will fit into the buffer.  The format of the control
*    structure is as follows:-
*
*    NOTE: the control structure MUST be allocated by AllocDosObject!!!
*
*    Entries:  This field tells the calling application how many entries are
*          in the buffer after calling ExAll.  Note: make sure your code
*          handles the 0 entries case, including 0 entries with continue
*          non-zero.
*
*    LastKey:  This field ABSOLUTELY MUST be initialised to 0 before calling
*          ExAll for the first time.  Any other value will cause nasty
*          things to happen.  If ExAll returns non-zero, then this field
*          should not be touched before making the second and subsequent
*          calls to ExAll.  Whenever ExAll returns non-zero, there are more
*          calls required before all names have been received.
*
*          As soon as a FALSE return is received then ExAll has completed
*          (if IoErr() returns ERROR_NO_MORE_ENTRIES - otherwise it returns
*          the error that occured, similar to ExNext.)
*
*    MatchString
*          If this field is NULL then all filenames will be returned.  If
*          this field is non-null then it is interpreted as a pointer to
*          a string that is used to pattern match all file names before
*          accepting them and putting them into the buffer.  The default
*          AmigaDOS caseless pattern match routine is used.  This string
*          MUST have been parsed by ParsePatternNoCase()!
*
*    MatchFunc: 
*          Contains a pointer to a hook for a routine to decide if the entry
*          will be included in the returned list of entries.  The entry is
*          filled out first, and then passed to the hook.  If no MatchFunc is
*          to be called then this entry should be NULL.  The hook is
*          called with the following parameters (as is standard for hooks):
*   
*          BOOL = MatchFunc( hookptr, data, typeptr )
*               a0   a1   a2
*          (a0 = ptr to hook, a1 = ptr to filled in ExAllData, a2 = ptr
*           to longword of type).
*
*          MatchFunc should return FALSE if the entry is not to be
*          accepted, otherwise return TRUE.
*
*      Note that Dos will emulate ExAll() using Examine() and ExNext()
*      if the handler in question doesn't support the ExAll() packet.
*
* EXAMPLE
*
*   eac = AllocDosObject(DOS_EXALLCONTROL,NULL);
*   if (!eac) ...
*   ...
*   eac->eac_LastKey = 0;
*   do {
*       more = ExAll(lock, EAData, sizeof(EAData), ED_FOO, eac);
*       if ((!more) && (IoErr() != ERROR_NO_MORE_ENTRIES)) {
*           \* ExAll failed abnormally *\
*           break;
*       }
*       if (eac->eac_Entries == 0) {
*           \* ExAll failed normally with no entries *\
*           continue;                   \* ("more" is *usually* zero) *\
*       }
*       ead = (struct ExAllData *) EAData;
*       do {
*           \* use ead here *\
*           ...
*           \* get next ead *\
*           ead = ead->ed_Next;
*       } while (ead);
*
*   } while (more);
*   ...
*   FreeDosObject(DOS_EXALLCONTROL,eac);
*
* BUGS
*    The V37 ROM/disk filesystem incorrectly returned comments as BSTR's
*    (length plus characters) instead of CSTR's (null-terminated).  See
*    the next bug for a way to determine if the filesystem is a V37
*    ROM/disk filesystem.  Fixed in V39.
*
*    The V37 ROM/disk filesystem incorrectly handled values greater than
*    ED_COMMENT.  Because of this, ExAll() information is trashed if
*    ED_OWNER is passed to it.  Fixed in V39.  To work around this, use
*    the following code to identify if a filesystem is a V37 ROM/disk
*    filesystem:
*
* // return TRUE if this is a V37 ROM filesystem, which doesn't (really)
* // support ED_OWNER safely
*
* BOOL CheckV37(BPTR lock)
* {
*    struct FileLock *l = BADDR(lock);
*    struct Resident *resident;
*    struct DosList *dl;
*    BOOL result = FALSE;
* 
*    dl = LockDosList(LDF_READ|LDF_DEVICES);
* 
*    // if the lock has a volume and no device, we won't find it,
*   // so we know it's not a V37 ROM/disk filesystem
*    do {
*        dl = NextDosEntry(dl,LDF_READ|LDF_DEVICES);
*        if (dl && (dl->dol_Task == l->fl_Task))
*        {
*       // found the filesystem - test isn't actually required,
*      // but we know the filesystem we're looking for will always
*      // have a startup msg.  If we needed to examine the message,
*      // we would need a _bunch_ of checks to make sure it's not
*      // either a small value (like port-handler uses) or a BSTR.
*       if (dl->dol_misc.dol_handler.dol_Startup)
*       {
*          // try to make sure it's the ROM fs or l:FastFileSystem
*          if (resident =
*              FindRomTag(dl->dol_misc.dol_handler.dol_SegList))
*          {
*             if (resident->rt_Version < 39 &&
*                 (strncmp(resident->rt_IdString,"fs 37.",
*                     StringLength("fs 37.")) == 0 ||
*                  strncmp(resident->rt_Name,"ffs 37.",
*                     StringLength("ffs 37.")) == 0))
*             {
*                result = TRUE;
*             }
*          }
*       }
*       break;
*        }
*    } while (dl);
*
*    UnLockDosList(LDF_READ|LDF_DEVICES);
* 
*    return result;
* }
* 
* INPUTS
*    lock    - Lock on directory to be examined.
*    buffer  - Buffer for data returned (MUST be at least word-aligned,
*              preferably long-word aligned).
*    size    - Size in bytes of 'buffer'.
*    type    - Type of data to be returned.
*    control - Control data structure (see notes above).  MUST have been
*         allocated by AllocDosObject!
*
* RESULT
*    continue - Whether or not ExAll is done.  If FALSE is returned, either
*       ExAll has completed (IoErr() == ERROR_NO_MORE_ENTRIES), or
*       an error occurred (check IoErr()).  If non-zero is returned,
*       you MUST call ExAll again until it returns FALSE.
*
************************************************************
*
*/

METHODFUNC OBJECT *exAll( BPTR lock, struct ExAllData *buffer, 
                          LONG size, LONG type, 
                          struct ExAllControl *control
                        )
{
   if (!buffer || (size < 1) || !control) // == NULL)
      return( o_nil );
      
   if (ExAll( lock, buffer, size, type, control ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* exAllEnd() [3.0] ***********************************
*
* NAME
*    ExAllEnd -- Stop an ExAll()
*                    <primitive 247 13 bptrLock aBuffer size type exAllControl>
* SYNOPSIS
*    ExAllEnd( BPTR lock, char *buffer, LONG size, 
*              LONG type, struct ExAllControl *control );
*
* FUNCTION
*    Stops an ExAll() on a directory before it hits NO_MORE_ENTRIES.
*    The full set of arguments that had been passed to ExAll() must be
*    passed to ExAllEnd(), so it can handle filesystems that can't abort
*    an ExAll() directly.
*
* INPUTS
*    lock    - Lock on directory to be examined.
*    buffer  - Buffer for data returned (MUST be at least word-aligned,
*              preferably long-word aligned).
*    size    - Size in bytes of 'buffer'.
*    type    - Type of data to be returned.
*    control - Control data structure (see notes above).  MUST have been
*              allocated by AllocDosObject!
************************************************************
*
*/

METHODFUNC void exAllEnd( BPTR lock, struct ExAllData *buffer, LONG size, 
                          LONG type, struct ExAllControl *control
                        )
{
   if (!buffer || (size < 1) || !control) // == NULL)
      return;
      
   ExAllEnd( lock, buffer, size, type, control );

   return;
}

/****i* examine() [3.0] ************************************
*
* NAME
*    Examine -- Examine a directory or file associated with a lock
*                    ^ <primitive 247 14 bptrLock fibStruct>
* SYNOPSIS
*    BOOL success = Examine( BPTR lock, struct FileInfoBlock *fib );
*
* FUNCTION
*    Examine() fills in information in the FileInfoBlock concerning the
*    file or directory associated with the lock. This information
*    includes the name, size, creation date and whether it is a file or
*    directory.  FileInfoBlock must be longword aligned.  Examine() gives
*    a return code of zero if it fails.
*
*    You may make a local copy of the FileInfoBlock, as long as it is
*    never passed to ExNext().
*
* INPUTS
*    lock     - BCPL pointer to a lock
*    infoBlock - pointer to a FileInfoBlock (MUST be longword aligned)
*
* RESULTS
*    success - boolean
*
* SPECIAL NOTE
*    FileInfoBlock must be longword-aligned.  AllocDosObject() will
*    allocate them correctly for you.
*
* SEE ALSO
*    Lock(), UnLock(), ExNext(), ExamineFH(), <dos/dos.h>,
*    AllocDosObject(), ExAll()
************************************************************
*
*/

METHODFUNC OBJECT *examine( BPTR lock, struct FileInfoBlock *fib )
{
   if (!fib) // == NULL)
      return( o_nil );
      
   if (Examine( lock, fib ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* examineFH() [3.0] **********************************
*
* NAME
*    ExamineFH -- Gets information on an open file
*                    ^ <primitive 247 15 bptrFileHandle fibStruct>
* SYNOPSIS
*    BOOL success = ExamineFH( BPTR fh, struct FileInfoBlock *fib );
*
* FUNCTION
*    Examines a filehandle and returns information about the file in the
*    FileInfoBlock.  There are no guarantees as to whether the fib_Size
*    field will reflect any changes made to the file size it was opened,
*    though filesystems should attempt to provide up-to-date information
*    for it.
************************************************************
*
*/

METHODFUNC OBJECT *examineFH( BPTR fh, struct FileInfoBlock *fib )
{
   if (!fib) // == NULL)
      return( o_nil );
      
   if (ExamineFH( fh, fib ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* execute() [3.0] ************************************
*
* NAME
*    Execute -- Execute a CLI command
*                    ^ <primitive 247 16 command bptrInput bptrOutput>
* SYNOPSIS
*    BOOL success = Execute( char *commandString, BPTR input, BPTR output );
*
* FUNCTION
*    This function attempts to execute the string commandString as a
*    Shell command and arguments. The string can contain any valid input
*    that you could type directly in a Shell, including input and output
*    redirection using < and >.  Note that Execute() doesn't return until
*    the command(s) in commandstring have returned.
*
*    The input file handle will normally be zero, and in this case
*    Execute() will perform whatever was requested in the commandString
*    and then return. If the input file handle is nonzero then after the
*    (possibly empty) commandString is performed subsequent input is read
*    from the specified input file handle until end of that file is
*    reached.
*
*    In most cases the output file handle must be provided, and is used
*    by the Shell commands as their output stream unless output
*    redirection was specified. If the output file handle is set to zero
*    then the current window, normally specified as *, is used. Note
*    that programs running under the Workbench do not normally have a
*    current window.
*
*    Execute() may also be used to create a new interactive Shell process
*    just like those created with the NewShell command. In order to do
*    this you would call Execute() with an empty commandString, and pass
*    a file handle relating to a new window as the input file handle.
*    The output file handle would be set to zero. The Shell will read
*    commands from the new window, and will use the same window for
*    output. This new Shell window can only be terminated by using the
*    EndCLI command.
*
*    Under V37, if an input filehandle is passed, and it's either
*    interactive or a NIL: filehandle, the pr_ConsoleTask of the new
*    process will be set to that filehandle's process (the same applies
*    to SystemTagList()).
*
*    For this command to work the program Run must be present in C: in
*    versions before V36 (except that in 1.3.2 and any later 1.3 versions,
*    the system first checks the resident list for Run).
************************************************************
*
*/

METHODFUNC OBJECT *execute( char *command, BPTR input, BPTR output )
{
   if (!command) // == NULL)
      return( o_nil );
      
   if (Execute( command, input, output ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* exNext() [3.0] *************************************
*
* NAME
*    ExNext -- Examine the next entry in a directory
*                    ^ <primitive 247 17 bptrLock fibStruct>
* SYNOPSIS
*    BOOL success = ExNext( BPTR lock, struct FileInfoBlock *fib );
*
* FUNCTION
*    This routine is passed a directory lock and a FileInfoBlock that
*    have been initialized by a previous call to Examine(), or updated
*    by a previous call to ExNext().  ExNext() gives a return code of zero
*    on failure.  The most common cause of failure is reaching the end
*    of the list of files in the owning directory.  In this case, IoErr
*    will return ERROR_NO_MORE_ENTRIES and a good exit is appropriate.
*
*    So, follow these steps to examine a directory:
*    1) Pass a Lock and a FileInfoBlock to Examine().  The lock must
*       be on the directory you wish to examine.
*    2) Pass ExNext() the same lock and FileInfoBlock.
*    3) Do something with the information returned in the FileInfoBlock.
*       Note that the fib_DirEntryType field is positive for directories,
*       negative for files.
*    4) Keep calling ExNext() until it returns FALSE.  Check IoErr()
*       to ensure that the reason for failure was ERROR_NO_MORE_ENTRIES.
*
*    Note: if you wish to recursively scan the file tree and you find
*    another directory while ExNext()ing you must Lock that directory and
*    Examine() it using a new FileInfoBlock.  Use of the same
*    FileInfoBlock to enter a directory would lose important state
*    information such that it will be impossible to continue scanning
*    the parent directory.  While it is permissible to UnLock() and Lock()
*    the parent directory between ExNext() calls, this is NOT recommended.
*    Important state information is associated with the parent lock, so
*    if it is freed between ExNext() calls this information has to be
*    rebuilt on each new ExNext() call, and will significantly slow down
*    directory scanning.
*
*    It is NOT legal to Examine() a file, and then to ExNext() from that
*    FileInfoBlock.   You may make a local copy of the FileInfoBlock, as
*    long as it is never passed back to the operating system.
************************************************************
*
*/

METHODFUNC OBJECT *exNext( BPTR lock, struct FileInfoBlock *fib )
{
   if (!fib) // == NULL)
      return( o_nil );
      
   if (ExNext( lock, fib ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* findArg() [3.0] ************************************
*
* NAME
*    FindArg - find a keyword in a template
*                    ^ <primitive 247 18 template keyword>
* SYNOPSIS
*    LONG index = FindArg( char *template, char *keyword );
*
* FUNCTION
*    Returns the argument number of the keyword, or -1 if it is not a
*    keyword for the template.  Abbreviations are handled.
************************************************************
*
*/

METHODFUNC OBJECT *findArg( char *Template, char *keyword )
{
   LONG rval = 0L;
   
   if (!Template || !keyword) // == NULL)
      return( o_nil );
      
   if ((rval = FindArg( Template, keyword )) == -1)
      return( o_false );
   else
      return( AssignObj( new_int( (int) rval ) ) );
}

/****i* findDosEntry() [3.0] *******************************
*
* NAME
*    FindDosEntry -- Finds a specific Dos List entry
*                    ^ <primitive 247 19 dosList devName flags>
* SYNOPSIS
*    struct DosList *newdlist = FindDosEntry( struct DosList *dlist,
*                                             char *name, ULONG flags );
*
* FUNCTION
*    Locates an entry on the device list.  Starts with the entry dlist.
*
*    NOTE:  Must be called with the device list locked
*    (LockDosList()), no references may be made to dlist 
*    after unlocking.
************************************************************
*
*/

METHODFUNC OBJECT *findDosEntry( struct DosList *dlist,
                                 char           *name, 
                                 ULONG           flags
                               )
{
   struct DosList *rval = NULL;
   
   if (!name || !dlist) // == NULL)
      return( o_nil );

   if (name[ StringLength( name ) ] == COLON_CHAR)
      name[ StringLength( name ) ] = NIL_CHAR;
      
   if (!(rval = FindDosEntry( dlist, name, flags ))) // == NULL)
      return( o_false );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* findSegment() [3.0] ********************************
*
* NAME
*    FindSegment - Finds a segment on the resident list
*                    ^ <primitive 247 20 name startSegment systemBool>
* SYNOPSIS
*    struct Segment *s = FindSegment( char *name, 
*                                     struct Segment *start, 
*                                     LONG system );
*
* FUNCTION
*    Finds a segment on the Dos resident list by name and type, starting
*    at the segment AFTER 'start', or at the beginning if start is NULL.
*    If system is zero, it will only return nodes with a seg_UC of 0
*    or more.  It does NOT increment the seg_UC, and it does NOT do any
*    locking of the list.  You must Forbid() lock the list to use this
*    call.
*
*    To use an entry you have found, you must: if the seg_UC is 0 or more,
*    increment it, and decrement it (under Forbid()!) when you're done
*    the the seglist.
*
*    The other values for seg_UC are:
*       -1   - system module, such as a filesystem or shell
*       -2   - resident shell command
*       -999 - disabled internal command, ignore
*    Negative values should never be modified.  All other negative
*    values between 0 and -32767 are reserved to AmigaDos and should not
*    be used.
*
* INPUTS
*    name   - name of segment to find
*    start  - segment to start the search after (can be NULL)
*    system - true for system segment, false for normal segments
*
* RESULT
*    segment - the segment found or NULL
************************************************************
*
*/

METHODFUNC OBJECT *findSegment( char           *name, 
                                struct Segment *start, 
                                LONG            system 
                              )
{
   struct Segment *sptr = NULL;
   
   if (!name) // == NULL)
      return( o_nil );

   if (system == FALSE)      
      {
      Forbid();

      if (!(sptr = FindSegment( name, start, system ))) // == NULL)
         {
         Permit();
         return( o_false );
         }
      else
         {
         Permit();
         return( AssignObj( new_address( (ULONG) sptr ) ) );
         }
      }
   else
      {
      if (!(sptr = FindSegment( name, start, system ))) // == NULL)
         return( o_false );
      else
         return( AssignObj( new_address( (ULONG) sptr ) ) );
      }
}

/****i* flushFH() [3.0] ************************************
*
* NAME
*    Flush -- Flushes buffers for a buffered filehandle
*                    ^ <primitive 247 21 bptrFileHandle>
* SYNOPSIS
*    LONG success = Flush( BPTR fh );
*
* FUNCTION
*    Flushes any pending buffered writes to the filehandle.  All buffered
*    writes will also be flushed on Close().  If the filehandle was being
*    used for input, it drops the buffer, and tries to Seek() back to the
*    last read position  (so subsequent reads or writes will occur at the
*    expected position in the file).
*
* BUGS
*    Before V37 release, Flush() returned a random value.  As of V37,
*    it always returns success (this will be fixed in some future
*    release).
*
*    The V36 and V37 releases didn't properly flush filehandles which
*    have never had a buffered IO done on them.  This commonly occurs
*    on redirection of input of a command, or when opening a file for
*    input and then calling CreateNewProc() with NP_Arguments, or when
*    using a new filehandle with SelectInput() and then calling
*    RunCommand().  This is fixed in V39.  A workaround would be to
*    do FGetC(), then UnGetC(), then Flush().
************************************************************
*
*/
#ifndef __amigaos4__
METHODFUNC OBJECT *flushFH( BPTR fh )
{
   if (!fh) // == NULL)
      return( o_nil );
      
   if (Flush( fh ) == FALSE)
      return( o_false );
   else
      return( o_true );
}
#endif

/****i* fRead() [3.0] **************************************
*
* NAME
*    FRead -- Reads a number of blocks from an input (buffered)
*                    ^ <primitive 247 22 bptrFileHandle aBuffer blkSize blkCount>
* SYNOPSIS
*    LONG count = FRead( BPTR fh, char *buf, ULONG blocklen,
*                        ULONG blocks );
*
* FUNCTION
*    Attempts to read a number of blocks, each blocklen long, into the
*    specified buffer from the input stream.  May return less than
*    the number of blocks requested, either due to EOF or read errors.
*    This call is buffered.
*
* RESULT
*    count - Number of _blocks_ read, or 0 for EOF.  On an error,
*            the number of blocks actually read is returned.
************************************************************
*
*/

METHODFUNC OBJECT *fRead( BPTR fh, char *buf, ULONG blockSize,
                          ULONG blockCount
                        )
{
   LONG count = 0L;
   
   if (!buf || (blockSize < 1) || (blockCount < 1))
      return( o_nil );
   
   SetIoErr( 0 );
   
   count = FRead( fh, buf, blockSize, blockCount );

   if (IoErr() != RETURN_OK)      
      {
      // Perhaps we should UserInfo() this & return the count anyway!
      return( o_false );
      }
   else
      return( AssignObj( new_int( (int) count ) ) );
}

/****i* infoDisk() [3.0] ***********************************
*
* NAME
*    Info -- Returns information about the disk
*                    ^ <primitive 247 23 bptrLock infoData>
* SYNOPSIS
*    BOOL success = Info( BPTR lock, struct InfoData *parmBlock );
*
* FUNCTION
*    Info() can be used to find information about any disk in use.
*    'lock' refers to the disk, or any file on the disk. The parameter
*    block is returned with information about the size of the disk,
*    number of free blocks and any soft errors.
*
* SPECIAL NOTE:
*    InfoData structure must be longword aligned.
************************************************************
*
*/

METHODFUNC OBJECT *infoDisk( BPTR lock, struct InfoData *blk )
{
   if (!blk) // == NULL)
      return( o_nil );
      
   if (Info( lock, blk ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* input() [3.0] **************************************
*
* NAME
*    Input -- Identify the program's initial input file handle
*                    ^ <primitive 247 24>
* SYNOPSIS
*    BPTR file = Input( void )
*
* FUNCTION
*    Input() is used to identify the initial input stream allocated when
*    the program was initiated.  Never close the filehandle returned by
*    Input!
*
* RESULTS
*    file - BCPL pointer to a file handle
************************************************************
*
*/

METHODFUNC OBJECT *input( void )
{
   return( AssignObj( new_address( (ULONG) Input() ) ) );
}

/****i* lock() [3.0] ***************************************
*
* NAME
*    Lock -- Lock a directory or file
*                    ^ <primitive 247 25 name accessMode>
* SYNOPSIS
*    BPTR lock  = Lock( char *name, LONG accessMode );
*
* FUNCTION
*    A filing system lock on the file or directory 'name' is returned if
*    possible.
*
*    If the accessMode is ACCESS_READ, the lock is a shared read lock;
*    if the accessMode is ACCESS_WRITE then it is an exclusive write
*    lock.  Do not use random values for mode.
* 
*    If Lock() fails (that is, if it cannot obtain a filing system lock
*    on the file or directory) it returns a zero.
* 
*    Tricky assumptions about the internal format of a lock are unwise,
*    as are any attempts to use the fl_Link or fl_Access fields.
************************************************************
*
*/

METHODFUNC OBJECT *lock( char *name, LONG accessmode )
{
   BPTR rval = 0L;
   
   if (!name) // == NULL)
      return( o_nil );
      
   if (!(rval = Lock( name, accessmode ))) // == NULL)
      return( o_false );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* lockDosList() [3.0] ********************************
*
* NAME
*    LockDosList -- Locks the specified Dos Lists for use
*                    ^ <primitive 247 26 flags>
* SYNOPSIS
*    struct DosList *dlist = LockDosList( ULONG flags );
*
* FUNCTION
*    Locks the dos device list in preparation to walk the list.
*    If the list is 'busy' then this routine will not return until it is 
*    available.  This routine "nests": you can call it multiple times, and
*    then must unlock it the same number of times.  The dlist
*    returned is NOT a valid entry: it is a special value.  Note that
*    for 1.3 compatibility, it also does a Forbid() - this will probably
*    be removed at some future time.
*    
*    The pointer returned by this is NOT
*    an actual DosList pointer - you should use one of the other DosEntry
*    calls to get actual pointers to DosList structures (such as
*    NextDosEntry()), passing the value returned by LockDosList()
*    as the dlist value.
* 
*    Note for handler writers: you should never call this function with
*    LDF_WRITE, since it can deadlock you (if someone has it read-locked
*    and they're trying to send you a packet).  Use AttemptLockDosList()
*    instead, and effectively busy-wait with delays for the list to be
*    available.  The other option is that you can spawn a process to
*    add the entry safely.
* 
*    As an example, here's how you can search for all volumes of a specific
*    name and do something with them:
*
*    2.0 way:
*
*      dl = LockDosList(LDF_VOLUMES|LDF_READ);
*      while (dl = FindDosEntry(dl,name,LDF_VOLUMES))
*      {
*         Add to list of volumes to process or break out of
*         the while loop.
*         (You could try using it here, but I advise
*         against it for compatability reasons if you
*         are planning on continuing to examine the list.)
*      }
*      
*      process list of volumes saved above, or current entry if
*      you're only interested in the first one of that name.
*
*      UnLockDosList(LDF_VOLUMES|LDF_READ);
*              \* must not use dl after this! *\
*
*    1.3/2.0 way:
*
*      if (version >= 36)
*         dl = LockDosList(LDF_VOLUMES|LDF_READ);
*      else {
*         Forbid();
*         // tricky! note dol_Next is at offset 0!
*         dl = &(...->di_DeviceList);
*      }
*
*      while (version >= 36 ?
*            dl = FindDosEntry(dl,name,LDF_VOLUMES) :
*                 dl = yourfindentry(dl,name,DLT_VOLUME))
*      {
*         Add to list of volumes to process, or break out of
*         the while loop.
*         Do NOT lock foo1/foo2 here if you will continue
*         to examine the list - it breaks the forbid
*         and the list may change on you.
*      }
*      
*      process list of volumes saved above, or current entry if
*      you're only interested in the first one of that name.
*
*      if (version >= 36)
*         UnLockDosList(LDF_VOLUMES|LDF_READ);
*      else
*         Permit();
*      \* must not use dl after this! *\
*      ...
*
*      struct DosList *
*      yourfindentry (struct DosList *dl, STRPTRname, type)
*      {
*      \* tricky - depends on dol_Next being at offset 0,
*         and the initial ptr being a ptr to di_DeviceList! *\
*         while (dl = dl->dol_Next)
*         {
*             if (dl->dol_Type == type &&
*            stricmp(name,BADDR(dl->dol_Name)+1) == 0)
*             {
*            break;
*             }
*         }
*         return dl;
*      }
************************************************************
*
*/

METHODFUNC OBJECT *lockDosList( ULONG flags )
{
   return( AssignObj( new_address( (ULONG) LockDosList( flags ))));
}

/****i* lockRecord() [3.0] *********************************
*
* NAME
*    LockRecord -- Locks a portion of a file
*                  ^ <primitive 247 27 bptrFileHandle offset recordLen lockType timeout>
* SYNOPSIS
*    BOOL success = LockRecord( BPTR fh, ULONG offset, ULONG length,
*                               ULONG mode, ULONG timeout
*                             );
*
* FUNCTION
*    This locks a portion of a file for exclusive access.  Timeout is how
*    long to wait in ticks (1/50 sec) for the record to be available.
*
*    Valid modes are:
*      REC_EXCLUSIVE
*      REC_EXCLUSIVE_IMMED
*      REC_SHARED
*      REC_SHARED_IMMED
*    For the IMMED modes, the timeout is ignored.
*
*    Record locks are tied to the filehandle used to create them.  The
*    same filehandle can get any number of exclusive locks on the same
*    record, for example.  These are cooperative locks, they only
*    affect other people calling LockRecord().
************************************************************
*
*/

METHODFUNC OBJECT *lockRecord( BPTR  fh,
                               ULONG offset, 
                               ULONG length,
                               ULONG mode, 
                               ULONG timeout 
                             )
{
   if (!fh) // == NULL)
      return( o_nil );
      
   if (LockRecord( fh, offset, length, mode, timeout ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* lockRecords() [3.0] ********************************
*
* NAME
*    LockRecords -- Lock a series of records
*                    ^ <primitive 247 28 recordLock timeout>
* SYNOPSIS
*    BOOL success = LockRecords( struct RecordLock *record_array,
*                                ULONG timeout );
*
* FUNCTION
*    This locks several records within a file for exclusive access.
*    Timeout is how long to wait in ticks for the records to be available.
*    The wait is applied to each attempt to lock each record in the list.
*    It is recommended that you always lock a set of records in the same
*    order to reduce possibilities of deadlock.
* 
*    The array of RecordLock structures is terminated by an entry with
*    rec_FH of NULL.
************************************************************
*
*/

METHODFUNC OBJECT *lockRecords( struct RecordLock *record_array,
                                ULONG              timeout
                              )
{
   if (!record_array) // == NULL)
      return( o_nil );
      
   if (LockRecords( record_array, timeout ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* makeDosEntry() [3.0] *******************************
*
* NAME
*    MakeDosEntry -- Creates a DosList structure
*                    ^ <primitive 247 29 name type>
* SYNOPSIS
*    struct DosList *newdlist = MakeDosEntry( char *name, LONG type );
*
* FUNCTION
*    Create a DosList structure, including allocating a name and correctly
*    null-terminating the BSTR.  It also sets the dol_Type field, and sets
*    all other fields to 0.  This routine should be eliminated and replaced
*    by a value passed to AllocDosObject()!
************************************************************
*
*/

METHODFUNC OBJECT *makeDosEntry( char *name, LONG type )
{
   struct DosList *rval = NULL;
   
   if (!name) // == NULL)
      return( o_nil );
      
   if (!(rval = MakeDosEntry( name, type ))) // == NULL)
      return( o_false );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* makeLink() [3.0] ***********************************
*
* NAME
*    MakeLink -- Creates a filesystem link
*                ^ <primitive 247 30 linkName destPathBPTRLock softFlag>
* SYNOPSIS
*    BOOL success = MakeLink( char *name, LONG dest, LONG soft );
*
* FUNCTION
*    Create a filesystem link from 'name' to dest.  For "soft-links",
*    dest is a pointer to a null-terminated path string.  For "hard-
*    links", dest is a lock (BPTR).  'soft' is FALSE for hard-links,
*    non-zero otherwise.
*
*    Soft-links are resolved at access time by a combination of the
*    filesystem (by returning ERROR_IS_SOFT_LINK to dos), and by
*    Dos (using ReadLink() to resolve any links that are hit).
* 
*    Hard-links are resolved by the filesystem in question.  A series
*    of hard-links to a file are all equivalent to the file itself.
*    If one of the links (or the original entry for the file) is 
*    deleted, the data remains until there are no links left.
*
* INPUTS
*    name - Name of the link to create
*    dest - CPTR to path string, or BPTR lock
*    soft - FALSE for hard-links, non-zero for soft-links
************************************************************
*
*/

METHODFUNC OBJECT *makeLink( char *name, LONG dest, LONG soft )
{
   if (!name || !dest) // == NULL)
      return( o_nil );
      
   if (MakeLink( name, dest, soft ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* matchPattern() [3.0] *******************************
*
* NAME
*    MatchPattern --  Checks for a pattern match with a string
*                    ^ <primitive 247 31 pattern string>
* SYNOPSIS
*    BOOL match = MatchPattern( char *pat, char *str );
*
* FUNCTION
*    Checks for a pattern match with a string.  The pattern must be a
*    tokenized string output by ParsePattern().  This routine is
*    case-sensitive.
*
*    NOTE: this routine is highly recursive.  You must have at least
*    1500 free bytes of stack to call this (it will cut off it's
*    recursion before going any deeper than that and return failure).
*    That's _currently_ enough for about 100 levels deep of #, (, ~, etc.
*
* RESULT
*    match - success or failure of pattern match.  On failure,
*            IoErr() will return 0 or ERROR_TOO_MANY_LEVELS
************************************************************
*
*/

METHODFUNC OBJECT *matchPattern( char *pat, char *str )
{
   BOOL rval = FALSE;
   
   if (!pat || !str) // == NULL)
      return( o_nil );
      
   SetIoErr( 0 );
   
   if ((rval = MatchPattern( pat, str )) == FALSE)
      {
      if (IoErr() == ERROR_TOO_MANY_LEVELS)
         {
         // UserInfo() this condition????
         return( o_nil );
         }
      else
         return( o_false );
      }
   else
      return( o_true );
}

/****i* matchPatternNoCase() [3.0] *************************
*
* NAME
*    MatchPatternNoCase --  Checks for a pattern match with a string
*                    ^ <primitive 247 32 pattern string>
* SYNOPSIS
*    BOOL match = MatchPatternNoCase( char *pat, char *str );
*
* FUNCTION
*    Checks for a pattern match with a string.  The pattern must be a
*    tokenized string output by ParsePatternNoCase().  This routine is
*    NOT case-sensitive.
*
*    NOTE: this routine is highly recursive.  You must have at least
*    1500 free bytes of stack to call this (it will cut off it's
*    recursion before going any deeper than that and return failure).
*    That's _currently_ enough for about 100 levels deep of #, (, ~, etc.
*
* RESULT
*    match - success or failure of pattern match.  On failure,
*            IoErr() will return 0 or ERROR_TOO_MANY_LEVELS
************************************************************
*
*/

METHODFUNC OBJECT *matchPatternNoCase( char *pat, char *str )
{
   BOOL rval = FALSE;
   
   if (!pat || !str) // == NULL)
      return( o_nil );
      
   SetIoErr( 0 );
   
   if ((rval = MatchPatternNoCase( pat, str )) == FALSE)
      {
      if (IoErr() == ERROR_TOO_MANY_LEVELS)
         {
         // UserInfo() this condition????
         return( o_nil );
         }
      else
         return( o_false );
      }
   else
      return( o_true );
}

/****i* nameFromFH() [3.0] *********************************
*
* NAME
*    NameFromFH -- Get the name of an open filehandle
*                    ^ <primitive 247 33 bptrFileHandle aBuffer length>
* SYNOPSIS
*    BOOL success = NameFromFH( BPTR fh, char *buffer, LONG length );
*
* FUNCTION
*    Returns a fully qualified path for the filehandle.  This routine is
*    guaranteed not to write more than len characters into the buffer.  The
*    name will be null-terminated.  See NameFromLock() for more information.
* 
*    Note: Older filesystems that don't support ExamineFH() will cause
*    NameFromFH() to fail with ERROR_ACTION_NOT_SUPPORTED.
************************************************************
*
*/

METHODFUNC OBJECT *nameFromFH( BPTR fh, char *buffer, LONG length )
{
   if (!buffer || (length < 1))
      return( o_nil );
      
   if (NameFromFH( fh, buffer, length ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* nameFromLock() [3.0] *******************************
*
* NAME
*    NameFromLock -- Returns the name of a locked object
*                    ^ <primitive 247 34 bptrLock aBuffer length>
* SYNOPSIS
*    BOOL success = NameFromLock( BPTR lock, char *buffer, LONG length );
*
* FUNCTION
*    Returns a fully qualified path for the lock.  This routine is
*    guaranteed not to write more than len characters into the buffer.  The
*    name will be null-terminated.  NOTE: if the volume is not mounted,
*    the system will request it (unless of course you set pr_WindowPtr to
*    -1).  If the volume is not mounted or inserted, it will return an
*    error.  If the lock passed in is NULL, "SYS:" will be returned. If
*    the buffer is too short, an error will be returned, and IoErr() will
*    return ERROR_LINE_TOO_LONG.
*
* BUGS
*    Should return the name of the boot volume instead of SYS: for a NULL
*    lock.
************************************************************
*
*/

METHODFUNC OBJECT *nameFromLock( BPTR lock, char *buffer, LONG length )
{
   if (!buffer || (length < 1))
      return( o_nil );
      
   if (NameFromLock( lock, buffer, length ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* nextDosEntry() [3.0] *******************************
*
* NAME
*    NextDosEntry -- Get the next Dos List entry
*                    ^ <primitive 247 35 dosList flags>
* SYNOPSIS
*    struct DosList *newdlist = NextDosEntry( struct DosList *dlist,
*                                             ULONG           flags
*                                           );
* 
* FUNCTION
*    Find the next Dos List entry of the right type.  You MUST have locked
*    the types you're looking for.  Returns NULL if there are no more of
*    that type in the list.
*
* INPUTS
*    dlist    - The current device entry.
*    flags    - What type of entries to look for.
*
* RESULT
*    newdlist - The next device entry of the right type or NULL.
*
* SEE ALSO
*    AddDosEntry(), RemDosEntry(), FindDosEntry(), LockDosList(),
*    MakeDosEntry(), FreeDosEntry()
************************************************************
*
*/

METHODFUNC OBJECT *nextDosEntry( struct DosList *dlist,
                                 ULONG           flags
                               )
{
   struct DosList *rval = NULL;
   
   if (!dlist) // == NULL)
      return( o_nil );
      
   if (!(rval = NextDosEntry( dlist, flags ))) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* openFile() [3.0] ***********************************
*
* NAME
*    Open -- Open a file for input or output
*            ^ <primitive 247 36 fileName accessMode>
* SYNOPSIS
*    BPTR file = Open( char *name, LONG accessMode );
*
* FUNCTION
*    The named file is opened and a file handle returned.  If the
*    accessMode is MODE_OLDFILE, an existing file is opened for reading
*    or writing. If the value is MODE_NEWFILE, a new file is created for
*    writing. MODE_READWRITE opens a file with an shared lock, but
*    creates it if it didn't exist.  Open types are documented in the
*    <dos/dos.h> or <libraries/dos.h> include file.
*
*    The 'name' can be a filename (optionally prefaced by a device
*    name), a simple device such as NIL:, a window specification such as
*    CON: or RAW: followed by window parameters, or "*", representing the
*    current window.  Note that as of V36, "*" is obsolete, and CONSOLE:
*    should be used instead.
* 
*    If the file cannot be opened for any reason, the value returned
*    will be zero, and a secondary error code will be available by
*    calling the routine IoErr().
*
* INPUTS
*    name      - pointer to a null-terminated string
*    accessMode - integer
*
* RESULTS
*    file - BCPL pointer to a file handle
*
* SEE ALSO
*    Close(), ChangeMode(), NameFromFH(), ParentOfFH(), ExamineFH()
************************************************************
*
*/

METHODFUNC OBJECT *openFile( char *name, LONG accessmode )
{
   BPTR rval = 0; // NULL;

   if (!name) // == NULL)
      return( o_nil );
      
   if (!(rval = Open( name, accessmode ))) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* openFromLock() [3.0] *******************************
*
* NAME
*    OpenFromLock -- Opens a file you have a lock on
*                    ^ <primitive 247 37 bptrLock>
* SYNOPSIS
*    BPTR fh = OpenFromLock( BPTR lock )
*
* FUNCTION
*    Given a lock, this routine performs an open on that lock.  If the open
*    succeeds, the lock is (effectively) relinquished, and should not be
*    UnLock()ed or used.  If the open fails, the lock is still usable.
*    The lock associated with the file internally is of the same access
*    mode as the lock you gave up - shared is similar to MODE_OLDFILE,
*    exclusive is similar to MODE_NEWFILE.
************************************************************
*
*/

METHODFUNC OBJECT *openFromLock( BPTR lock )
{
   BPTR rval = 0; // NULL;

   if (!(rval = OpenFromLock( lock ))) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* output() [3.0] *************************************
*
* NAME
*    Output -- Identify the programs' initial output file handle
*              ^ <primitive 247 38>
* SYNOPSIS
*    BPTR file = Output( void );
*
* FUNCTION
*    Output() is used to identify the initial output stream allocated
*    when the program was initiated.  Never close the filehandle returned
*    by Output().
************************************************************
*
*/

METHODFUNC OBJECT *output( void )
{
   return( AssignObj( new_address( (ULONG) Output() ) ) );
}

/****i* parsePattern() [3.0] *******************************
*
* NAME
*    ParsePattern -- Create a tokenized string for MatchPattern()
*                    ^ <primitive 247 39 source dest destLength>
* SYNOPSIS
*    LONG IsWild = ParsePattern( char *Source, char *Dest, LONG DestLength );
*
* FUNCTION
*    Tokenizes a pattern, for use by MatchPattern().  Also indicates if
*    there are any wildcards in the pattern (i.e. whether it might match
*    more than one item).  Note that Dest must be at least 2 times as
*    large as Source plus bytes to be (almost) 100% certain of no
*    buffer overflow.  This is because each input character can currently
*    expand to 2 tokens (with one exception that can expand to 3, but
*    only once per string).  Note: this implementation may change in
*    the future, so you should handle error returns in all cases, but
*    the size above should still be a reasonable upper bound for a buffer
*    allocation.
* 
* INPUTS
*    source     - unparsed wildcard string to search for.
*    dest       - output string, gets tokenized version of input.
*    DestLength - length available in destination (should be at least as
*                 twice as large as source + 2 bytes).
*
* RESULT
*    IsWild - 1 means there were wildcards in the pattern,
*             0 means there were no wildcards in the pattern,
*            -1 means there was a buffer overflow or other error
************************************************************
*
*/

METHODFUNC OBJECT *parsePattern( char *Source, char *Dest, LONG DestLength )
{
   if (!Source || !Dest || (DestLength < 10))
      return( o_nil );

   return( AssignObj( new_int( (int) ParsePattern( Source, Dest, DestLength ))));
}

/****i* parsePatternNoCase() [3.0] *************************
*
* NAME
*    ParsePatternNoCase -- Create a tokenized string.
*                          ^ <primitive 247 40 source dest destLength>
* SYNOPSIS
*    LONG IsWild = ParsePatternNoCase( char *Source, char *Dest, LONG DestLength );
*
* FUNCTION
*    Tokenizes a pattern, for use by MatchPatternNoCase().  Also indicates
*    if there are any wildcards in the pattern (i.e. whether it might match
*    more than one item).  Note that Dest must be at least 2 times as
*    large as Source plus 2 bytes.
*
*    For a description of the wildcards, see ParsePattern().
*
* RESULT
*    IsWild - 1 means there were wildcards in the pattern,
*             0 means there were no wildcards in the pattern,
*            -1 means there was a buffer overflow or other error
************************************************************
*
*/

METHODFUNC OBJECT *parsePatternNoCase( char *Source, char *Dest, LONG DestLength )
{
   if (!Source || !Dest || (DestLength < 10))
      return( o_nil );

   return( AssignObj( new_int( (int) ParsePatternNoCase( Source, Dest, DestLength ))));
}

/****i* relabel() [3.0] ************************************
*
* NAME
*    Relabel -- Change the volume name of a volume
*                    ^ <primitive 247 41 volumeName newName>
* SYNOPSIS
*    BOOL success = Relabel( char *volumename, char *name )
*
* FUNCTION
*    Changes the volumename of a volume, if supported by the filesystem.
************************************************************
*
*/

METHODFUNC OBJECT *relabel( char *volumename, char *newName )
{
   if (!volumename || !newName) // == NULL)
      return( o_nil );
      
   if (Relabel( volumename, newName ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* rename() [3.0] *************************************
*
* NAME
*    Rename -- Rename a directory or file
*                    ^ <primitive 247 42 oldName newName>
* SYNOPSIS
*    BOOL success = Rename( char *oldName, char *newName );
*
* FUNCTION
*    Rename() attempts to rename the file or directory specified as
*    'oldName' with the name 'newName'. If the file or directory
*    'newName' exists, Rename() fails and returns an error.  Both
*    'oldName' and the 'newName' can contain a directory specification.
*    In this case, the file will be moved from one directory to another.
* 
*    Note: it is impossible to Rename() a file from one volume to
*    another.
************************************************************
*
*/

METHODFUNC OBJECT *renameFile( char *oldName, char *newName )
{
   if (!oldName || !newName) // == NULL)
      return( o_nil );
      
   if (Rename( oldName, newName ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* setCurrentDirName() [3.0] **************************
*
* NAME
*    SetCurrentDirName -- Sets the directory name for the process
*                    ^ <primitive 247 43 dirName>
* SYNOPSIS
*    BOOL success = SetCurrentDirName( char *name );
*
* FUNCTION
*    Sets the name for the current dir in the cli structure.  If the name
*    is too long to fit, a failure is returned, and the old value is left
*    intact.  It is advised that you inform the user of this condition.
*    This routine is safe to call even if there is no CLI structure.
*
* BUGS
*    This clips to a fixed (1.3 compatible) size.
************************************************************
*
*/

METHODFUNC OBJECT *setCurrentDirName( char *name )
{
   if (!name) // == NULL)
      return( o_nil );
      
   if (SetCurrentDirName( name ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* setMode() [3.0] ************************************
*
* NAME
*    SetMode - Set the current behavior of a handler
*                    ^ <primitive 247 44 bptrFileHandle mode>
* SYNOPSIS
*    BOOL success = SetMode( BPTR fh, LONG mode );
*
* FUNCTION
*    SetMode() sends an ACTION_SCREEN_MODE packet to the handler in
*    question, normally for changing a CON: handler to raw mode or
*    vice-versa.  For CON:, use 1 to go to RAW: mode, 0 for CON: mode.
************************************************************
*
*/

METHODFUNC OBJECT *setMode( BPTR fh, LONG mode )
{
   if (SetMode( fh, mode ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* setOwner() [3.0] ***********************************
*
* NAME
*    SetOwner -- Set owner information for a file or directory (V39)
*                    ^ <primitive 247 45 name ownerUID>
* SYNOPSIS
*    BOOL success = SetOwner( char *name, LONG owner_info );
*
* FUNCTION
*    SetOwner() sets the owner information for the file or directory.
*    This value is a 32-bit value that is normally split into 16 bits
*    of owner user id (bits 31-16), and 16 bits of owner group id (bits
*    15-0).  However, other than returning them as shown by Examine()/
*    ExNext()/ExAll(), the filesystem take no interest in the values.
*    These are primarily for use by networking software (clients and
*    hosts), in conjunction with the FIBF_OTR_xxx and FIBF_GRP_xxx
*    protection bits.
* 
*    This entrypoint did not exist in V36, so you must open at least V37
*    dos.library to use it.  V37 dos.library will return FALSE to this
*    call.
************************************************************
*
*/

METHODFUNC OBJECT *setOwner( char *name, LONG owner_info )
{
   if (!name) // == NULL)
      return( o_nil );
      
   if (SetOwner( name, owner_info ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* setProgramDir() [3.0] ******************************
*
* NAME
*    SetProgramDir -- Sets the directory returned by GetProgramDir
*                    ^ <primitive 247 46 bptrLock>
* SYNOPSIS
*    BPTR oldlock = SetProgramDir( BPTR lock );
*
* FUNCTION
*    Sets a shared lock on the directory the program was loaded from.
*    This can be used for a program to find data files, etc, that are
*    stored with the program, or to find the program file itself.  NULL
*    is a valid input.  This can be accessed via GetProgramDir() or
*    by using paths relative to PROGDIR:.
************************************************************
*
*/

METHODFUNC OBJECT *setProgramDir( BPTR lock )
{
   return( AssignObj( new_address( (ULONG) SetProgramDir( lock ))));
}

/****i* setProgramName() [3.0] *****************************
*
* NAME
*    SetProgramName -- Sets the name of the program being run
*                    ^ <primitive 247 47 programName>
* SYNOPSIS
*    BOOL success = SetProgramName( char *name )
*
* FUNCTION
*    Sets the name for the program in the cli structure.  If the name is 
*    too long to fit, a failure is returned, and the old value is left
*    intact.  It is advised that you inform the user if possible of this
*    condition, and/or set the program name to an empty string.
*    This routine is safe to call even if there is no CLI structure.
*
* BUGS
*    This clips to a fixed (1.3 compatible) size.
************************************************************
*
*/

METHODFUNC OBJECT *setProgramName( char *name )
{
   if (!name) // == NULL)
      return( o_nil );
      
   if (SetProgramName( name ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* setVar() [3.0] *************************************
*
* NAME
*    SetVar -- Sets a local or environment variable 
*                    ^ <primitive 247 48 name aBuffer size flags>
* SYNOPSIS
*    BOOL success = SetVar( char *name, char *buffer,
*                           LONG size, ULONG flags ); 
*
* FUNCTION
*    Sets a local or environment variable.  It is advised to only use
*    ASCII strings inside variables, but not required.
*
* INPUTS
*    name   - pointer to an variable name.  Note variable names follow
*             filesystem syntax and semantics.
*    buffer - a user allocated area which contains a string that is the
*             value to be associated with this variable.
*    size   - length of the buffer region in bytes.  -1 means buffer
*             contains a null-terminated string.
*    flags  - combination of type of var to set (low 8 bits), and
*             flags to control the behavior of this routine.
*             Currently defined flags include:
*
*      GVF_LOCAL_ONLY  - set a local (to your process) variable.
*      GVF_GLOBAL_ONLY - set a global environment variable.
*
*      The default is to set a local environment variable.
*
* BUGS
*    LV_VAR is the only type that can be global
************************************************************
*
*/

METHODFUNC OBJECT *setVar( char *name, char *buffer,
                           LONG  size, ULONG flags
                         )
{
   if (!name || !buffer) // == NULL)
      return( o_nil );
      
   if (SetVar( name, buffer, size, flags ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* startNotify() [3.0] ********************************
*
* NAME
*    StartNotify -- Starts notification on a file or directory 
*                    ^ <primitive 247 49 notifyRequest>
* SYNOPSIS
*    BOOL success = StartNotify( struct NotifyRequest *nr );
*
* FUNCTION
*    Posts a notification request.  Do not modify the notify structure while
*    it is active.  You will be notified when the file or directory changes.
*    For files, you will be notified after the file is closed.  Not all
*    filesystems will support this: applications should NOT require it.  In
*    particular, most network filesystems won't support it.
*
* INPUTS
*    notifystructure - A filled-in NotifyRequest structure
************************************************************
*
*/

METHODFUNC OBJECT *startNotify( struct NotifyRequest *nr )
{
   if (!nr) // == NULL)
      return( o_nil );
      
   if (StartNotify( nr ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* unLock() [3.0] *************************************
*
* NAME
*    UnLock -- Unlock a directory or file
*                    <primitive 247 50 bptrLock>
* SYNOPSIS
*    void UnLock( BPTR lock )
*
* FUNCTION
*    The filing system lock (obtained from Lock(), DupLock(), or
*    CreateDir()) is removed and deallocated.
************************************************************
*
*/

METHODFUNC void unLock( BPTR lock )
{
   UnLock( lock );
   
   return;
}

/****i* unLockDosList() [3.0] ******************************
*
* NAME
*    UnLockDosList -- Unlocks the Dos List 
*                     <primitive 247 51 flags>
* SYNOPSIS
*    void UnLockDosList( ULONG flags );
*
* FUNCTION
*    Unlocks the access on the Dos Device List.  You MUST pass the same
*    flags you used to lock the list.
*
* INPUTS
*    flags - MUST be the same flags passed to (Attempt)LockDosList()
************************************************************
*
*/

METHODFUNC void unLockDosList( ULONG flags )
{
   UnLockDosList( flags );
   
   return;
}

/****i* unLockRecord() [3.0] *******************************
*
* NAME
*    UnLockRecord -- Unlock a record 
*                    ^ <primitive 247 52 bptrFileHandle offset length>
* SYNOPSIS
*    BOOL success = UnLockRecord( BPTR fh, ULONG offset, ULONG length )
*
* FUNCTION
*    This releases the specified lock on a file.  Note that you must use
*    the same filehandle you used to lock the record, and offset and length
*    must be the same values used to lock it.  Every LockRecord() call must
*    be balanced with an UnLockRecord() call.
************************************************************
*
*/

METHODFUNC OBJECT *unLockRecord( BPTR fh, ULONG offset, ULONG length )
{
   if (length < 1)
      return( o_nil );
      
   if (UnLockRecord( fh, offset, length ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* unLockRecords() [3.0] ******************************
*
* NAME
*    UnLockRecords -- Unlock a list of records 
*                    ^ <primitive 247 53 recordLock>
* SYNOPSIS
*    BOOL success = UnLockRecords( struct RecordLock *record_array );
*
* FUNCTION
*    This releases an array of record locks obtained using LockRecords.
*    You should NOT modify the record_array while you have the records
*    locked.  Every LockRecords() call must be balanced with an
*    UnLockRecords() call.
************************************************************
*
*/

METHODFUNC OBJECT *unLockRecords( struct RecordLock *record_array )
{
   if (!record_array) // == NULL)
      return( o_nil );
      
   if (UnLockRecords( record_array ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* vFWritef() [3.0] ***********************************
*
* NAME
*    VFWritef - write a BCPL formatted string to a file (buffered) 
*                    ^ <primitive 247 54 bptrFileHandle formatStr argv>
* SYNOPSIS
*    LONG count = VFWritef( BPTR fh, char *fmt, LONG *argv );
*
* FUNCTION
*    Writes the formatted string and values to the specified file.  This
*    routine is assumed to handle all internal buffering so that the
*    formatting string and resultant formatted values can be arbitrarily
*    long.  The formats are in BCPL form.  This routine is buffered.
*
* INPUTS
*    fh    - filehandle to write to
*    fmt   - BCPL style formatting string
*    argv  - Pointer to array of formatting values
*
* RESULT
*    count - Number of bytes written or -1 for error
*
* BUGS
*    As of V37, VFWritef() does NOT return a valid return value.  In
*    order to reduce possible errors, the prototypes supplied for the
*    system as of V37 have it typed as VOID.
*
* SEE ALSO
*    VFPrintf(), VFPrintf(), FPutC()
************************************************************
*
*/
#ifndef __amigaos4__
METHODFUNC OBJECT *vFWritef( BPTR fh, char *fmt, LONG *argv )
{
   if (!fmt) // == NULL)
      return( o_nil );
      
   VFWritef( fh, fmt, argv );

   return( o_true );
}
#endif

/****i* writeChars() [3.0] *********************************
*
* NAME
*    WriteChars -- Writes bytes to the the default output (buffered) 
*                    ^ <primitive 247 55 aBuffer length>
* SYNOPSIS
*    LONG count = WriteChars( char *buf, LONG buflen );
*
* FUNCTION
*    This routine writes a number of bytes to the default output.  The
*    length is returned.  This routine is buffered.
*
* INPUTS
*    buf    - buffer of characters to write
*    buflen - number of characters to write
*
* RESULT
*    count - Number of bytes written.  -1 (EOF) indicates an error
*
* SEE ALSO
*    FPuts(), FPutC(), FWrite(), PutStr()
************************************************************
*
*/

METHODFUNC OBJECT *writeChars( char *buf, LONG buflength )
{
   LONG count = -1;
   
   if (!buf || (buflength < 1))
      return( o_nil );
      
   if ((count = WriteChars( buf, buflength )) == -1)
      return( o_false );
   else
      return( AssignObj( new_int( (int) count ) ) );
}

/****h* HandleADosUnSafe() [3.0] ***********************************
*
* NAME
*    HandleADosUnSafe()
*
* DESCRIPTION
*    Translate primitives (247) to AmigaDOS commands to the OS.
********************************************************************
*
*/

PRIVATE BOOL LibOpened = FALSE;

PUBLIC OBJECT *HandleADosUnSafe( int numargs, OBJECT **args )
{
#  ifdef  __SASC
   IMPORT struct DosLibrary *DOSBase;
#  else
   IMPORT struct Library *DOSBase;
#  endif

   OBJECT *rval = o_nil;
      
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 247 );
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
      case 0:  // BOOL success = AddPart( char *dirname, char *filename, ULONG size );
               //   ^ <primitive 247 0 dirName fileName size>
         if (!is_string( args[1] ) || !is_string(  args[2] ) 
                                   || !is_integer( args[3] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = addPart(      string_value( (STRING *) args[1] ),
                                 string_value( (STRING *) args[2] ),
                            (ULONG) int_value( args[3] )
                          );
         break;
         
      case 1:  // BOOL success = AssignAdd( char *name, BPTR lock );
               //   ^ <primitive 247 1 assignName bptrLock>
         if (!is_string( args[1] ) || !is_address(  args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = assignAdd(      string_value( (STRING *) args[1] ),
                              (BPTR) addr_value( args[2] )
                            );
         break;
         
      case 2:  // BOOL success = AssignLate( char *name, char *path );
               //   ^ <primitive 247 2 assignName pathFileName>
         if (!is_string( args[1] ) || !is_string(  args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = assignLate( string_value( (STRING *) args[1] ),
                               string_value( (STRING *) args[2] )
                             );
         break;
         
      case 3:  // BOOL success = AssignLock( char *name, BPTR lock );
               //   ^ <primitive 247 3 assignName bptrLock>
         if (!is_string( args[1] ) || !is_address(  args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = assignLock(      string_value( (STRING *) args[1] ),
                               (BPTR) addr_value( args[2] )
                             );
         break;
         
      case 4:  // BOOL success = AssignPath( char *name, char *path );
               //   ^ <primitive 247 4 assignName pathName>
         if (!is_string( args[1] ) || !is_string(  args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = assignPath( string_value( (STRING *) args[1] ),
                               string_value( (STRING *) args[2] )
                             );
         break;
         
      case 5:  // BOOL success = ChangeMode( ULONG type, BPTR object, ULONG newmode );
               //   ^ <primitive 247 5 type bptrLockOrFH newMode>
         if (!is_integer( args[1] ) || !is_address( args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = changeMode( (ULONG)  int_value( args[1] ),
                                (BPTR) addr_value( args[2] ),
                               (ULONG)  int_value( args[3] )
                             );
         break;
         
      case 6:  // ULONG signals = CheckSignal( ULONG mask );
               //   ^ <primitive 247 6 signalMask>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            rval = checkSignal( (ULONG) int_value( args[1] ) );
         
         break;
         
      case 7:  // BOOL success = Close( BPTR file );
               //   ^ <primitive 247 7 bptrFileHandle>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            rval = closeFile( (BPTR) addr_value( args[1] ) );
         
         break;
         
      case 8:  // BPTR lock = CreateDir( char *name )
               //   ^ <primitive 247 8 dirName>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            rval = createDir( string_value( (STRING *) args[1] ) );

         break;
         
      case 9:  // struct DateStamp *ds = DateStamp( struct DateStamp *ds );
               //   ^ <primitive 247 9 dateStampObject>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            rval = dateStamp( (struct DateStamp *) addr_value( args[1] ) );

         break;
         
      case 10: // BPTR lock = DupLock( BPTR lock );
               //   ^ <primitive 247 10 bptrLock>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            rval = dupLock( (BPTR) addr_value( args[1] ) );

         break;
         
      case 11: // BPTR lock = DupLockFromFH( BPTR fh );
               //   ^ <primitive 247 11 bptrFileHandle>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            rval = dupLockFromFH( (BPTR) addr_value( args[1] ) );
         
         break;
         
      case 12: // BOOL continue = ExAll( BPTR lock, char *buffer, LONG size, LONG type,
               //                        struct ExAllControl *control );
               //   ^ <primitive 247 12 bptrLock aBuffer size type exAllControl>
         if (!is_address( args[1] ) || !is_integer( args[2] )
                                    || !is_integer( args[3] )
                                    || !is_integer( args[4] )
                                    || !is_address( args[5] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = exAll(                  (BPTR) addr_value( args[1] ),
                             (struct ExAllData *)  int_value( args[2] ),
                                           (LONG)  int_value( args[3] ),
                                           (LONG)  int_value( args[4] ),
                          (struct ExAllControl *) addr_value( args[5] )
                        );
         break;

      case 13: // ExAllEnd( BPTR lock, char *buffer, LONG size, LONG type,
               //           struct ExAllControl *control );
               //   <primitive 247 13 bptrLock aBuffer size type exAllControl>
         if (!is_address( args[1] ) || !is_address( args[2] )
                                    || !is_integer( args[3] )
                                    || !is_integer( args[4] )
                                    || !is_address( args[5] ))
            (void) PrintArgTypeError( 247 );
         else
            exAllEnd(                  (BPTR) addr_value( args[1] ),
                         (struct ExAllData *) addr_value( args[2] ),
                                       (LONG)  int_value( args[3] ),
                                       (LONG)  int_value( args[4] ),
                      (struct ExAllControl *) addr_value( args[5] )
                    );
         break;
         
      case 14: // BOOL success = Examine( BPTR lock, struct FileInfoBlock *fib );
               //   ^ <primitive 247 14 bptrLock fibStruct>
         if (!is_address( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = examine(                   (BPTR) addr_value( args[1] ),
                            (struct FileInfoBlock *) addr_value( args[2] )
                          );
         break;
         
      case 15: // BOOL success = ExamineFH( BPTR fh, struct FileInfoBlock *fib );
               //   ^ <primitive 247 15 bptrFileHandle fibStruct>
         if (!is_address( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = examineFH(                   (BPTR) addr_value( args[1] ),
                              (struct FileInfoBlock *) addr_value( args[2] )
                            );
         break;
         
      case 16: // BOOL success = Execute( char *commandString, BPTR input, BPTR output );
               //   ^ <primitive 247 16 command bptrInput bptrOutput>
         if (!is_string( args[1] ) || !is_address( args[2] )
                                   || !is_address( args[3] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = execute(      string_value( (STRING *) args[1] ),
                            (BPTR) addr_value( args[2] ),
                            (BPTR) addr_value( args[3] )
                          );
         break;
         
      case 17: // BOOL success = ExNext( BPTR lock, struct FileInfoBlock *fib );
               //   ^ <primitive 247 17 bptrLock fibStruct>
         if (!is_address( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = exNext(                   (BPTR) addr_value( args[1] ),
                           (struct FileInfoBlock *) addr_value( args[2] )
                         );
         break;
         
      case 18: // LONG index = FindArg( char *template, char *keyword );
               //   ^ <primitive 247 18 template keyword>
         if (!is_string( args[1] ) || !is_string(  args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = findArg( string_value( (STRING *) args[1] ),
                            string_value( (STRING *) args[2] )
                          );
         break;
         
      case 19: // struct DosList *newdlist = FindDosEntry( struct DosList *dlist,
               //                                          char *name, ULONG flags );
               //   ^ <primitive 247 19 dosList devName flags>
         if (!is_address( args[1] ) || !is_string(  args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = findDosEntry( (struct DosList *) addr_value( args[1] ),
                                                  string_value( (STRING *) args[2] ),
                                            (ULONG)  int_value( args[3] )
                               );
         break;
         
      case 20: // struct Segment *s = FindSegment( char *name, struct Segment *start, 
               //                                  LONG system );
               //   ^ <primitive 247 20 segmentName startSegment systemBool>
         if (!is_string( args[1] ) || !is_address( args[2] )
                                   || !is_integer( args[3] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = findSegment( string_value( (STRING *) args[1] ),
                                (struct Segment *) addr_value( args[2] ),
                                            (LONG)  int_value( args[3] )
                              );
         break;

#     ifdef    __SASC
      case 21: // LONG success = Flush( BPTR fh );
               //   ^ <primitive 247 21 bptrFileHandle>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            rval = flushFH( (BPTR) addr_value( args[1] ) );
         
         break;
#     endif
         
      case 22: // LONG count = FRead( BPTR fh, char *buf, ULONG blocklen, ULONG blocks );
               //   ^ <primitive 247 22 bptrFileHandle aBuffer blkSize blkCount>
         if (!is_address( args[1] ) || !is_string(  args[2] )
                                    || !is_integer( args[3] )
                                    || !is_integer( args[4] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = fRead( (BPTR)  addr_value( args[1] ),
                                string_value( (STRING *) args[2] ),
                           (ULONG) int_value( args[3] ),
                           (ULONG) int_value( args[4] )
                        );
         break;
         
      case 23: // BOOL success = Info( BPTR lock, struct InfoData *parmBlock );
               //   ^ <primitive 247 23 bptrLock infoData>
         if (!is_address( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = infoDisk(              (BPTR) addr_value( args[1] ),
                             (struct InfoData *) addr_value( args[2] )
                           );
         break;
         
      case 24: // BPTR file = Input( void );
               //   ^ <primitive 247 24>
         rval = input();
         
         break;
         
      case 25: // BPTR lock  = Lock( char *name, LONG accessMode );
               //   ^ <primitive 247 25 name accessMode>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = lock(     string_value( (STRING *) args[1] ),
                         (LONG) int_value( args[2] )
                       );
         break;
         
      case 26: // struct DosList *dlist = LockDosList( ULONG flags );
               //   ^ <primitive 247 26 flags>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            rval = lockDosList( (ULONG) int_value( args[1] ) );
         
         break;
         
      case 27: // BOOL success = LockRecord( BPTR fh, ULONG offset, ULONG length,
               //                            ULONG mode, ULONG timeout );
               // ^ <primitive 247 27 bptrFileHandle offset recordLen lockType timeout>
         if (!is_address( args[1] ) || !is_integer( args[2] )
                                    || !is_integer( args[3] )
                                    || !is_integer( args[4] )
                                    || !is_integer( args[5] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = lockRecord( (BPTR)  addr_value( args[1] ),
                                (ULONG) int_value( args[2] ),
                                (ULONG) int_value( args[3] ),
                                (ULONG) int_value( args[4] ),
                                (ULONG) int_value( args[5] )
                             );
         break;
         
      case 28: // BOOL success = LockRecords( struct RecordLock *record_array, ULONG timeout);
               //  ^ <primitive 247 28 recordLock timeout>
         if (!is_address( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = lockRecords( (struct RecordLock *) addr_value( args[1] ),
                                              (ULONG)  int_value( args[2] )
                              );
         break;
         
      case 29: // struct DosList *newdlist = MakeDosEntry( char *name, LONG type );
               //  ^ <primitive 247 29 name type>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = makeDosEntry(     string_value( (STRING *) args[1] ),
                                 (LONG) int_value( args[2] )
                               );
         break;
         
      case 30: // BOOL success = MakeLink( char *name, LONG dest, LONG soft );
               //  ^ <primitive 247 30 linkName destPathBPTRLock softFlag>
         if (!is_string( args[1] ) || !is_address( args[2] )
                                   || !is_integer( args[3] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = makeLink(      string_value( (STRING *) args[1] ),
                             (LONG) addr_value( args[2] ),
                             (LONG)  int_value( args[3] )
                           );
         break;
         
      case 31: // BOOL match = MatchPattern( char *pat, char *str );
               //  ^ <primitive 247 31 pattern string>
         if (!is_string( args[1] ) || !is_string(  args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = matchPattern( string_value( (STRING *) args[1] ),
                                 string_value( (STRING *) args[2] )
                               );
         break;
         
      case 32: // BOOL match = MatchPatternNoCase( char *pat, char *str );
               //  ^ <primitive 247 32 pattern string>
         if (!is_string( args[1] ) || !is_string(  args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = matchPatternNoCase( string_value( (STRING *) args[1] ),
                                       string_value( (STRING *) args[2] )
                                     );
         break;
         
      case 33: // BOOL success = NameFromFH( BPTR fh, char *buffer, LONG length );
               //  ^ <primitive 247 33 bptrFileHandle aBuffer length>
         if (!is_address( args[1] ) || !is_string(  args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = nameFromFH( (BPTR) addr_value( args[1] ),
                                    string_value( (STRING *) args[2] ),
                               (LONG)  int_value( args[3] )
                             );
         break;
         
      case 34: // BOOL success = NameFromLock( BPTR lock, char *buffer, LONG length );
               //  ^ <primitive 247 34 bptrLock aBuffer length>
         if (!is_address( args[1] ) || !is_string(  args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = nameFromLock( (BPTR) addr_value( args[1] ),
                                      string_value( (STRING *) args[2] ),
                                  (LONG) int_value( args[3] )
                               );
         break;
         
      case 35: // struct DosList *newdlist = NextDosEntry( struct DosList *dlist,
               //                                          ULONG flags );   
               //  ^ <primitive 247 35 dosList flags>
         if (!is_address( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = nextDosEntry( (struct DosList *) addr_value( args[1] ),
                                 (ULONG)             int_value( args[2] )
                               );
         break;
         
      case 36: // BPTR file = Open( char *name, LONG accessMode );
               //  ^ <primitive 247 36 fileName accessMode>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = openFile(     string_value( (STRING *) args[1] ),
                             (LONG) int_value( args[2] )
                           );
         break;
         
      case 37: // BPTR fh = OpenFromLock( BPTR lock );
               //  ^ <primitive 247 37 bptrLock>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            rval = openFromLock( (BPTR) addr_value( args[1] ) );

         break;
         
      case 38: // BPTR file = Output( void );
               //  ^ <primitive 247 38>
         rval = output();
         break;
         
      case 39: // LONG IsWild = ParsePattern( char *Source, char *Dest, LONG DestLength );
               //  ^ <primitive 247 39 source dest destLength>
         if (!is_string( args[1] ) || !is_string(  args[2] )
                                   || !is_integer( args[3] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = parsePattern( string_value( (STRING *) args[1] ),
                                 string_value( (STRING *) args[2] ),
                                 (LONG) int_value( args[3] )
                               );
         break;
         
      case 40: // LONG IsWild = ParsePatternNoCase( char *Source, char *Dest, LONG DestLength );
               //  ^ <primitive 247 40 source dest destLength>
         if (!is_string( args[1] ) || !is_string(  args[2] )
                                   || !is_integer( args[3] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = parsePatternNoCase( string_value( (STRING *) args[1] ),
                                       string_value( (STRING *) args[2] ),
                                       (LONG) int_value( args[3] )
                                     );
         break;
         
      case 41: // BOOL success = Relabel( char *volumename, char *name );
               //  ^ <primitive 247 41 volumeName newName>
         if (!is_string( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = relabel( string_value( (STRING *) args[1] ),
                            string_value( (STRING *) args[2] )
                          );
         break;
         
      case 42: // BOOL success = Rename( char *oldName, char *newName );
               //  ^ <primitive 247 42 oldName newName>
         if (!is_string( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = renameFile( string_value( (STRING *) args[1] ),
                               string_value( (STRING *) args[2] )
                             );
         break;
         
      case 43: // BOOL success = SetCurrentDirName( char *name );
               //  ^ <primitive 247 43 dirName>
         if (is_string( args[1] )  == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            rval = setCurrentDirName( string_value( (STRING *) args[1] ) );
         
         break;
         
      case 44: // BOOL success = SetMode( BPTR fh, LONG mode );
               //  ^ <primitive 247 44 bptrFileHandle mode>
         if (!is_address( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = setMode( (BPTR) addr_value( args[1] ),
                            (LONG)  int_value( args[2] )
                          );
         break;
         
      case 45: // BOOL success = SetOwner( char *name, LONG owner_info );
               //  ^ <primitive 247 45 name ownerUID>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = setOwner(     string_value( (STRING *) args[1] ),
                             (LONG) int_value( args[2] )
                           );
         break;
         
      case 46: // BPTR oldlock = SetProgramDir( BPTR lock );
               //  ^ <primitive 247 46 bptrLock>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            rval = setProgramDir( (BPTR) addr_value( args[1] ) );

         break;
         
      case 47: // BOOL success = SetProgramName( char *name );
               //  ^ <primitive 247 47 programName>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            rval = setProgramName( string_value( (STRING *) args[1] ) );
         
         break;
         
      case 48: // BOOL success = SetVar( char *name, char *buffer, LONG size, ULONG flags ); 
               //  ^ <primitive 247 48 name aBuffer size flags>
         if (!is_string( args[1] ) || !is_string(  args[2] )
                                   || !is_integer( args[3] )
                                   || !is_integer( args[4] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = setVar(      string_value( (STRING *) args[1] ),
                                string_value( (STRING *) args[2] ),
                           (LONG)  int_value( args[3] ),
                           (ULONG) int_value( args[4] )
                         );
         break;
         
      case 49: // BOOL success = StartNotify( struct NotifyRequest *nr );
               //  ^ <primitive 247 49 notifyRequest>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            rval = startNotify( (struct NotifyRequest *) addr_value( args[1] ) );
         
         break;
         
      case 50: // void UnLock( BPTR lock );
               //    <primitive 247 50 bptrLock>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            unLock( (BPTR) addr_value( args[1] ) );
         
         break;
         
      case 51: // void UnLockDosList( ULONG flags );
               //    <primitive 247 51 flags>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            unLockDosList( (ULONG) int_value( args[1] ) );

         break;
         
      case 52: // BOOL success = UnLockRecord( BPTR fh, ULONG offset, ULONG length );
               //    ^ <primitive 247 52 bptrFileHandle offset length>
         if (!is_address( args[1] ) || !is_integer( args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = unLockRecord( (BPTR)  addr_value( args[1] ),
                                 (ULONG)  int_value( args[2] ),
                                 (ULONG)  int_value( args[3] )
                               );
         break;
         
      case 53: // BOOL success = UnLockRecords( struct RecordLock *record_array );
               //    ^ <primitive 247 53 recordLock>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            rval = unLockRecords( (struct RecordLock *) addr_value( args[1] ) );

         break;
#     ifdef    __SASC
      case 54: // LONG count = VFWritef( BPTR fh, char *fmt, LONG *argv );
               //    ^ <primitive 247 54 bptrFileHandle formatStr argv>
         if (!is_address( args[1] ) || !is_string(  args[2] )
                                    || !is_address( args[3] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = vFWritef( (BPTR)   addr_value( args[1] ),
                                    string_value( (STRING *) args[2] ),
                             (LONG *) addr_value( args[3] )
                           );
         break;
#     endif
         
      case 55: // LONG count = WriteChars( char *buf, LONG buflen );
               //    ^ <primitive 247 55 aBuffer length>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 247 );
         else
            rval = writeChars(     string_value( (STRING *) args[1] ),
                               (LONG) int_value( args[2] )
                             );

         break;

      case 56: // getFileNameFrom: fileInfoBlock
               //    ^ <primitive 247 56 fileInfoBlock>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            {
            struct FileInfoBlock *fib = (struct FileInfoBlock *) addr_value( args[1] );
            
            if (fib) // != NULL)
               rval = new_str( fib->fib_FileName );
            else
               rval = o_nil;
            } 

         break;

      case 57: // getFileSizeFrom: fileInfoBlock
               //    ^ <primitive 247 57 fileInfoBlock>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            {
            struct FileInfoBlock *fib = (struct FileInfoBlock *) addr_value( args[1] );
            
            if (fib) // != NULL)
               rval = new_int( (int) fib->fib_Size );
            else
               rval = o_nil;
            } 

         break;

      case 58: // getBlockCountFrom: fileInfoBlock
               //    ^ <primitive 247 58 fileInfoBlock>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            {
            struct FileInfoBlock *fib = (struct FileInfoBlock *) addr_value( args[1] );
            
            if (fib) // != NULL)
               rval = new_int( (int) fib->fib_NumBlocks );
            else
               rval = o_nil;
            } 

         break;

      case 59: // getCommentFrom: fileInfoBlock
               //    ^ <primitive 247 59 fileInfoBlock>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            {
            struct FileInfoBlock *fib = (struct FileInfoBlock *) addr_value( args[1] );
            
            if (fib) // != NULL)
               rval = new_str( fib->fib_Comment );
            else
               rval = o_nil;
            } 

         break;

      case 60: // getProtectionBitsFrom: fileInfoBlock
               //    ^ <primitive 247 60 fileInfoBlock>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            {
            struct FileInfoBlock *fib = (struct FileInfoBlock *) addr_value( args[1] );
            
            if (fib) // != NULL)
               rval = new_int( (int) fib->fib_Protection );
            else
               rval = o_nil;
            } 

         break;

      case 61: // getDateStampObjectFrom: fileInfoBlock
               //    ^ <primitive 247 61 fileInfoBlock>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            {
            struct FileInfoBlock *fib = (struct FileInfoBlock *) addr_value( args[1] );
            
            if (fib) // != NULL)
               rval = new_int( (int) &(fib->fib_Date) );
            else
               rval = o_nil;
            } 

         break;

      case 62: // getOwnerUIDFrom: fileInfoBlock
               //    ^ <primitive 247 62 fileInfoBlock>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            {
            struct FileInfoBlock *fib = (struct FileInfoBlock *) addr_value( args[1] );
            
            if (fib) // != NULL)
               rval = new_int( (int) fib->fib_OwnerUID );
            else
               rval = o_nil;
            } 

         break;

      case 63: // getOwnerGIDFrom: fileInfoBlock
               //    ^ <primitive 247 63 fileInfoBlock>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            {
            struct FileInfoBlock *fib = (struct FileInfoBlock *) addr_value( args[1] );
            
            if (fib) // != NULL)
               rval = new_int( (int) fib->fib_OwnerGID );
            else
               rval = o_nil;
            } 

         break;

      case 64: // isFileIn: fileInfoBlock
               //    ^ <primitive 247 64 fileInfoBlock>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            {
            struct FileInfoBlock *fib = (struct FileInfoBlock *) addr_value( args[1] );
            
            if (fib) // != NULL)
               {
               if (fib->fib_DirEntryType < 0)
                  rval = o_true;
               else
                  rval = o_false;
               }
            else
               rval = o_nil;
            } 

         break;

      case 65: // makeInfoDataObject
               //    ^ <primitive 247 65>
         {
         struct InfoData *id = (struct InfoData *) AT_AllocVec( sizeof( struct InfoData ),
                                                                MEMF_CLEAR | MEMF_ANY,
                                                                "infoDataObject",
                                                                TRUE
                                                              );
         
         if (!id) // == NULL)
            break;
         else
            rval = new_address( (ULONG) id );
         }

         break;

      case 66: // disposeInfoDataObject: infoDataObject
               //    ^ <primitive 247 66 infoDataObject>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 247 );
         else
            {
            OBJECT *temp = args[1];
            
            AT_FreeVec( (struct InfoData *) addr_value( args[1] ), 
                        "infoDataObject", TRUE 
                      );

            obj_dec( temp );
            }

         break;

      default:
         (void) PrintArgTypeError( 247 );
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

/* ----------------------- END of ADOS2.c file! ------------------------ */
