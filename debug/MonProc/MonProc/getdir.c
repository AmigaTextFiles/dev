/*  GETDIR.C  - Does some simple lock and device-list manipulation
 *
 *  Copywrite (c) 1987 by Davide P. Cervone
 *  This code may be used so long as this copywrite notice is left in tact.
 */

#include "exec/types.h"
#include "exec/memory.h"
#include "libraries/dos.h"
#include "libraries/dosextens.h"

#define BCPL(x,y)         ((struct x *)(BADDR(y)))
#define BCPL_TO_CHAR(y)   ((char *)(BADDR(y)))
#define FILELOCK(x)       BCPL(FileLock,x)
#define DEVLIST(x)        BCPL(DeviceList,x)

#define FIBSIZE           ((ULONG)sizeof(struct FileInfoBlock))
#define RETURN(dir)       return((*dir == '\0')? NULL: dir)


/*
 *  BSTRcopy()
 *
 *  Copies a BCPL string into a C string and returns the length of the
 *  string.
 */

BSTRcpy(to,BCPLfrom)
char *to, *BCPLfrom;
{
   char *from = BCPL_TO_CHAR(BCPLfrom);

   strncpy(to,from+1,(int)(*from));
   *(to+(*from)) = '\0';
   return((int) *from);
}


/*
 *  GetPathFromLock()
 *
 *  GetPathFromLock looks up the path name to the file or directory specified
 *  by the lock.  The volume name is included in the returned string. 
 *  If an error occurs, the function returns NULL, and the path name is set
 *  to an empty string (a null byte).  The lock remains intact (it is not
 *  UnLocked).
 *
 *      dir         a pointer to a string area where the path name
 *                  will be stored.  No check is made to be sure that
 *                  the path name fits.
 *      lock        a lock on the file or directory whose path is to
 *                  be found.
 *
 *  Note:  there seems to be a problem with the RAM: device (AmigaDOS v1.1).  
 *  ParentDir() always returns NULL for a lock on the RAM-disk;  Therefore, 
 *  GetPathFromLock() always returns "RAM:" for any lock on the RAM: device.
 *
 *  Note:  this function finds the complete path name to the locked object,
 *  including the volume name.  ASSIGNed names will be translated to their
 *  physical names.  For instance, if you CD to the C: directory, and
 *  C: is ASSIGNed as SYS:C, and SYS: is ASSIGNed as your boot disk, and
 *  your boot disk is named "WorkBench", then if you call GetPathFromLock()
 *  with a lock in the C: directory, you will get back the string 
 *  "WorkBench:c", not "C:".
 */

char *GetPathFromLock(dir,lock)
char *dir;
struct FileLock *lock;
{
   struct FileLock *CurDir, *OldDir, *DupLock(), *ParentDir();
   struct FileInfoBlock *fib, *AllocMem();
   char *subdir = dir, *s, *s1, c;
   int len;

/*
 *  Clear the path name, and duplicate the lock (so we can UnLock our 
 *  duplicate without destroying the user's lock).  If DupLock returned
 *  NULL, then there was an error.  (An exclusive write lock, perhaps?)
 */

   *dir = '\0';
   CurDir = DupLock(lock);
   if (CurDir == NULL) return(NULL);

/*
 *  the FileInfoBlock must be longword alligned, so use AllocMem
 */
   fib = AllocMem(FIBSIZE,MEMF_CLEAR | MEMF_PUBLIC);
   if (fib != NULL)
   {
/*
 *  Get the device name from the volume entry in the device list
 *  that is pointed to by the file lock.  Since the device list is
 *  a shared list, use Forbid() and Permit() so it doesn't change while
 *  we are looking at it.  Add a colon, and set the subdir pointer to
 *  the character following the volume name.  Subdirectory names will be
 *  added starting there.
 */
      Forbid();
      subdir += BSTRcpy(dir,DEVLIST(FILELOCK(CurDir)->fl_Volume)->dl_Name);
      Permit();
      *subdir++ = ':';
      *subdir   = '\0';
/*
 *  While we have a valid lock (ParentDir() will return a NULL pointer
 *  when we reach the root of the disk), examine the directory (or file)
 *  that we have locked.  If we can't examine it, give an error, otherwise
 *  move up to the parent dir and unlock the old directory lock.  If we haven't
 *  moved up past the root, then we want to add the directory name (found
 *  in the FileInfoBlock structure returned by Examine()) to the path name.
 *  To do so, we shift any existing sub-directory names to the right leaving
 *  enough room for the new directory name (plus a slash, if needed).
 *
 *  Note:  the highest directory on a disk (the root), seems to have the same 
 *  name as the disk itself (look at the ASSIGN list, for instance), so 
 *  ParentDir() does not return NULL until we move past the root, that's why
 *  the ParentDir() call comes before we add the directory name into the 
 *  string.
 *
 *  For instance, if the current directory is "disk:a/b/c/d", and
 *  the CurDir lock is on "d", then the calls to ParentDir() will
 *  produce locks on "c", "b", "a", "disk", and then NULL.
 */
      while (CurDir != NULL)
      {
         if (!Examine(CurDir,fib))
         {
            *dir = '\0';
            UnLock(CurDir);
            CurDir = NULL;
         } else {
            OldDir = CurDir;
            CurDir = ParentDir(OldDir);
            UnLock(OldDir);

            if (CurDir != NULL)
            {
               len = strlen(fib->fib_FileName);
               for (s=subdir+strlen(subdir), s1=s+len+1;
                  s >= subdir; *s1-- = *s--);
               c = *subdir;
               strcpy(subdir,fib->fib_FileName);
               *s1 = (c != '\0')? '/': c;
            }
         }
      }
      FreeMem(fib,FIBSIZE);
   }
   RETURN(dir);
}


/*
 *  GetInfoVolume()
 *
 *  GetInfoVolume looks up the volume name from an InfoData structure and
 *  returns a C string containing the name.
 *
 *      name        a pointer to a string area where the volume name
 *                  will be stored.  No check is made to be sure that
 *                  the name fits.
 *      info        an InfoData structure that has been filed in by a call
 *                  to Info().
 *
 */

void GetInfoVolume(name,info)
char *name;
struct InfoData *info;
{
/*
 *  Get the device name from the volume entry in the device list
 *  that is pointed to by the InfoData.  Since the device list is
 *  a shared list, use Forbid() and Permit() so it doesn't change while
 *  we are looking at it.  Add a colon for looks.
 */
   Forbid();
   name += BSTRcpy(name,DEVLIST(info->id_VolumeNode)->dl_Name);
   Permit();
   *name++ = ':';
   *name   = '\0';
}
