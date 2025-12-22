#ifndef _AMIGAOS_H_
#define _AMIGAOS_H_

#include "dirfd.h"

int fchdir (int fd);

#ifdef __NEWLIB__
int execvp(const char *file, char *const argv[]);
#endif

typedef unsigned int u_int;
typedef unsigned short u_short;

#ifdef __NEWLIB__

/* Blatantly ripped from glibc, but it's all GPL in here, anyway */
enum
{
  MS_RDONLY = 1,                /* Mount read-only.  */
#define MS_RDONLY       MS_RDONLY
  MS_NOSUID = 2,                /* Ignore suid and sgid bits.  */
#define MS_NOSUID       MS_NOSUID
  MS_NODEV = 4,                 /* Disallow access to device special files.  */
#define MS_NODEV        MS_NODEV
  MS_NOEXEC = 8,                /* Disallow program execution.  */
#define MS_NOEXEC       MS_NOEXEC
  MS_SYNCHRONOUS = 16,          /* Writes are synced at once.  */
#define MS_SYNCHRONOUS  MS_SYNCHRONOUS
  MS_REMOUNT = 32,              /* Alter flags of a mounted FS.  */
#define MS_REMOUNT      MS_REMOUNT
  MS_MANDLOCK = 64,             /* Allow mandatory locks on an FS.  */
#define MS_MANDLOCK     MS_MANDLOCK
  S_WRITE = 128,                /* Write on file/directory/symlink.  */
#define S_WRITE         S_WRITE
  S_APPEND = 256,               /* Append-only file.  */
#define S_APPEND        S_APPEND
  S_IMMUTABLE = 512,            /* Immutable file.  */
#define S_IMMUTABLE     S_IMMUTABLE
  MS_NOATIME = 1024,            /* Do not update access times.  */
#define MS_NOATIME      MS_NOATIME
  MS_NODIRATIME = 2048,         /* Do not update directory access times.  */
#define MS_NODIRATIME   MS_NODIRATIME
  MS_BIND = 4096,               /* Bind directory at different place.  */
#define MS_BIND         MS_BIND
};

struct statfs
  {
    long f_bsize;
    long f_blocks;
    long f_bfree;
    long f_bavail;
    long f_ffree;
    long f_fsid;
    long f_files;
	char f_fstypename[100];
  };

#endif


#endif
