#ifndef API_AMIGA_LIBCALLENTRY_H
#define API_AMIGA_LIBCALLENTRY_H

#ifndef AMIGA_LIBCALLENTRY_H
#define AMIGA_LIBCALLENTRY_H

#ifndef _CDEFS_H_
#include <sys/cdefs.h>
#endif

#ifndef _ERRNO_H
#include <sys/errno.h>
#endif

#ifndef _SYS_SYSLOG_H_
#include <sys/syslog.h>
#endif

#ifndef _SYS_SOCKET_H_
#include <sys/socket.h>
#endif

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef API_AMIGA_API_H
#include <api/amiga_api.h>
#endif


/*
 * The following macros are written in each socket library functions
 * (execpt Errno()). they makes sure that the task that calls library
 * functions is the opener task of the socketbase it is using.
 */

extern const char wrongTaskErrorFmt[];

#define CHECK_TASK()					\
  if (libPtr->thisTask != SysBase->ThisTask) {		\
    struct Task * wTask = SysBase->ThisTask;		\
    log(LOG_CRIT, wrongTaskErrorFmt, wTask,		\
	wTask->tc_Node.ln_Name,	libPtr->thisTask,	\
	libPtr->thisTask->tc_Node.ln_Name);		\
    return -1;						\
  }      

#define CHECK_TASK_NULL()				\
  if (libPtr->thisTask != SysBase->ThisTask) {		\
    struct Task * wTask = SysBase->ThisTask;		\
    log(LOG_CRIT, wrongTaskErrorFmt, wTask,		\
	wTask->tc_Node.ln_Name,	libPtr->thisTask,	\
	libPtr->thisTask->tc_Node.ln_Name);		\
    return NULL;					\
  }      

#define CHECK_TASK2() CHECK_TASK_NULL()

#define CHECK_TASK_VOID()				\
  if (libPtr->thisTask != SysBase->ThisTask) {		\
    struct Task * wTask = SysBase->ThisTask;		\
    log(LOG_CRIT, wrongTaskErrorFmt, wTask,		\
	wTask->tc_Node.ln_Name,	libPtr->thisTask,	\
	libPtr->thisTask->tc_Node.ln_Name);		\
    return;						\
  }      

#define API_STD_RETURN(error, ret)	\
  if (error == 0)			\
     return ret;	       	        \
  writeErrnoValue(libPtr, error);	\
  return -1;
						
/*
 * getSock() gets a socket referenced by given filedescriptor if exists,
 * returns EBADF (bad file descriptor) if not. (because this now uses
 * struct socket * pointer and those are often register variables, perhaps
 * some kind of change is to be done here).
 */

static inline LONG getSock(struct SocketBase *p, int fd, struct socket **sop)
{
  register struct socket *so;
  
  if ((unsigned)fd >= p->dTableSize || (so = p->dTable[(short)fd]) == NULL)
    return (EBADF);
  *sop = so;
  return 0;
}

/*
 * Prototype for sdFind. This is located in amiga_syscalls.c and replaces
 * fdAlloc there. libPtr->nextDToSearch is dumped.
 */
LONG sdFind(struct SocketBase * libPtr, LONG *fdp);

#ifndef API_AMIGA_RAF_H
#include <api/amiga_raf.h>
#endif

#endif /* !AMIGA_LIBCALLENTRY_H */
#endif /* API_AMIGA_LIBCALLENTRY_H */
