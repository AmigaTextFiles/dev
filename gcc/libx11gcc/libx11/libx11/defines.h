/* Copyright (c) 1996 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     defines
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Nov 10, 1996: Created.
***/

#ifndef DEFINES
#define DEFINES

typedef char boolean;

#ifndef         S_ISDIR         /* missing POSIX-type macros */
#define       S_ISDIR(mode)   (((mode)&S_IFMT) == S_IFDIR)
#define       S_ISBLK(mode)   (((mode)&S_IFMT) == S_IFBLK)
#define       S_ISCHR(mode)   (((mode)&S_IFMT) == S_IFCHR)
#define       S_ISREG(mode)   (((mode)&S_IFMT) == S_IFREG)
#endif
#ifndef         S_ISFIFO
#  ifdef        S_IFIFO
#    define     S_ISFIFO(mode)  (((mode)&S_IFMT) == S_IFIFO)
#  else
#    define     S_ISFIFO(mode)  0
#  endif
#endif
#ifndef         S_ISLINK
#  ifdef        S_IFLNK
#    define     S_ISLINK(mode)  (((mode)&S_IFMT) == S_IFLNK)
#  else
#    define     S_ISLINK(mode)  0
#  endif
#endif
#ifndef         S_ISSOCK
#  ifdef        S_IFSOCK
#    define     S_ISSOCK(mode)  (((mode)&S_IFMT) == S_IFSOCK)
#  else
#    define     S_ISSOCK(mode)  0
#  endif
#endif


#endif /* DEFINES */
