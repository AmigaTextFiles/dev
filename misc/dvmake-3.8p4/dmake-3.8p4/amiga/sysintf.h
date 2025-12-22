/*
** assorted bits of system interface, for common routines inside dmake.
** System specific code can be found in the config.h files for each
** of the system specifications.
*/
#ifdef _DCC
#include <sys/stat.h>
#define STAT quickstat            /* Faster than stat() */
int quickstat(const char *, struct stat *); /* Defined in sasc.c */
#else
#define STAT my_stat            /* needed because of bug in SAS/C stat() */
#include <stat.h>
int my_stat(const char *, struct stat *); /* Defined in sasc.c */
#endif

#define VOID_LCACHE(l,m)
#define Hook_std_writes(A)
#define GETPID getpid()

#define _POSIX_PATH_MAX 256     /* This is handled wrong in posix.h! */

/*
** standard C items
*/
#include <time.h>

/*
** DOS interface standard items
*/
#define getswitchar()   '-'

/* To get make_env() and free_env() in sysintf.c */
#define __ZTC__ 1


/*
** make parameters
*/
#define MAX_PATH_LEN    1024
