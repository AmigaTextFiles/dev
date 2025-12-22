/* Definitions for SAS/C 6.51 and DICE 2.07.53
*/


long __oslibversion = 37;       /* Requires AmigaOS 2.0 */
#ifndef _DCC
static char ver[] = "$VER: dmake 3.8p4 " __AMIGADATE__;
#else
static char ver[] = "$VER: dmake 3.8p4 (" __DATE__ ")";
#endif
long __stack = 10000;           /* Estimate */

#ifndef _DCC
#include <stat.h>
#include <dos.h>

int my_stat(const char *name, struct stat *statstruct)
{
  /* SAS/C 6.51 stat() leaves a file lock if program has been aborted */
  /* As a workaround we must explicitly check the abort before stat() */

  chkabort();
  return stat(name, statstruct);
}
#endif

#ifdef _DCC
#include <exec/types.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <clib/dos_protos.h>
#include <sys/stat.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>

typedef struct FileInfoBlock    FileInfoBlock;

/* DICE normal stat() scans the parent directory for the file if the
 * initial Lock() attempt failed, to be able to stat even files currently
 * open for writing.
 * For DMake this behaviour is not needed and just timeconsuming, so
 * an own stat is needed.
 */
int
quickstat(const char *name, struct stat *stat_buf)
{
    __aligned FileInfoBlock fib;
    BPTR lock;
    int r = -1;

    chkabort();
    clrmem(stat_buf, sizeof(*stat_buf));
    fib.fib_FileName[0] = 0;

    lock = Lock(name, SHARED_LOCK);
    if (lock != NULL && Examine(lock, &fib))
      r = 0;
    if (lock == NULL) {
        errno = ENOENT;
        return(-1);
    }
    if (r >= 0) {
        stat_buf->st_size = fib.fib_Size;
        stat_buf->st_ino = (long)((struct FileLock *)BADDR(lock))->fl_Key;
        stat_buf->st_dev = (long)((struct FileLock *)BADDR(lock))->fl_Task;
        stat_buf->st_mode = (fib.fib_DirEntryType > 0) ? S_IFDIR : S_IFREG;
        stat_buf->st_ctime = stat_buf->st_mtime = fib.fib_Date.ds_Days * (1440 * 60) +
                                        fib.fib_Date.ds_Minute * 60 +
                                        fib.fib_Date.ds_Tick / 50;
        if ((fib.fib_Protection & 8) == 0)
            stat_buf->st_mode |= S_IREAD;
        if ((fib.fib_Protection & 4) == 0)
            stat_buf->st_mode |= S_IWRITE;
        if ((fib.fib_Protection & 2) == 0)
            stat_buf->st_mode |= S_IEXEC;
        if (fib.fib_Protection & 0x40)
            stat_buf->st_mode |= S_IEXEC;
    }
    UnLock(lock);
    if (r < 0)
        errno = ENOENT;
    return(r);
}
#endif
