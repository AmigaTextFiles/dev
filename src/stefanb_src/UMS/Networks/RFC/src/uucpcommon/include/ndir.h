
/*
 *  ndir.h -- header file for the ``ndir'' directory routines.
 *
 */

#ifndef _NDIR_H
#define _NDIR_H

#ifdef _DCC

#include <sys/dir.h>

#else

#ifndef LIBRARIES_DOS_H
#include <libraries/dos.h>
#endif

#ifndef DEV_BSIZE
#define DEV_BSIZE     512
#endif

#define DIRBLKSIZ	DEV_BSIZE
#define MAXNAMLEN	255

struct	direct {
    long    d_ino;		    /* inode number of entry */
    short   d_reclen;		    /* length of this record */
    short   d_namlen;		    /* length of string in d_name */
    char    d_name[MAXNAMLEN + 1];  /* name must be no longer than this */
};

/*
 * The DIRSIZ macro gives the minimum record length which will hold
 * the directory entry.  This requires the amount of space in struct direct
 * without the d_name field, plus enough space for the name with a
 * terminating null byte (dp->d_namlen+1), rounded up to a 4 byte boundary.
 */

#ifdef DIRSIZ
#undef DIRSIZ
#endif /* DIRSIZ */

#define DIRSIZ(dp) \
    ((sizeof(struct direct) - (MAXNAMLEN+1)) + (((dp)->d_namlen+1 + 3) &~ 3))

/*
 * Definitions for library routines operating on directories.
 */

typedef struct DIR {
    long lock;
    struct FileInfoBlock fib;
} DIR;

#endif	/* _DCC */

#endif
