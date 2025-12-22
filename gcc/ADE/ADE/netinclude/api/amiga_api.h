/* With KERNEL defined, this file doesn't include anything that needs
   struct SocketBase defined, so is now safe from resulting circular
   includes. */

#ifndef API_AMIGA_API_H
#define API_AMIGA_API_H

#ifndef KERNEL 
#define KERNEL 1
#endif

#ifndef AMIGA_API_H
#define AMIGA_API_H

#ifndef EXEC_TYPES_H
#include <exec/types.h> 
#endif

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h> 
#endif

#ifndef EXEC_SEMAPHORES_H
#include <exec/semaphores.h> 
#endif

#ifndef EXEC_TASKS_H
#include <exec/tasks.h>
#endif

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif

#ifndef PROTO_EXEC_H
#include <proto/exec.h>
#endif

#ifndef _CDEFS_H
#include <sys/cdefs.h>
#endif

#ifndef _SYS_TYPES_H_
#include <sys/types.h> 
#endif

#ifndef SYS_SOCKET_H
#include <sys/socket.h>                 /* some socket structures */  
#endif

#ifndef API_RESOLV_EXTRAS_H
#include <api/resolv_extras.h>          /* defines struct state */
#endif

#ifndef API_AMIGA_GENERIC_H
#include <api/amiga_generic.h>          /* defines struct newselbuf */
#endif

#ifndef GGTCP_CDEFS_H
#include <ggtcp/cdefs.h>               /* macros for argument passing */
#endif

#ifndef GGTCP_TIME_H
#include <ggtcp/time.h>                /* includes amiga timer stuff */
#endif

#ifndef GGTCP_QUEUE_H
#include <ggtcp/queue.h>               /* queue handling macros */
#endif

/*
 * structure for holding size and address of some dynamically allocated buffers
 * such as selitems for WaitSelect() and netdatabase entry structures
 */
struct DataBuffer {
  int		db_Size;
  void *	db_Addr;
};

typedef int (* fdCallback_t)(int fd __asm("d0"), int action __asm("d1") );

struct SocketBase {
  struct Library	libNode;
/* -- "Global" Errno -- */
  BYTE			flags;
  BYTE			errnoSize;                             /* 1, 2 or 4 */
 /* -- now we are longword aligned -- */
  UBYTE *		errnoPtr;                   /* this points to errno */
  LONG			defErrno;
/* Task pointer of owner task */
  struct Task *		thisTask;
/* task priority changes (WORDS so we keep structure longword aligned) */  
  BYTE			myPri;        /* task's priority just after libcall */
  BYTE			libCallPri;  /* task's priority during library call */
/* note: not long word aligned at this point */
/* -- descriptor sets -- */
  WORD			dTableSize; /* long word aligned again */
  struct socket	**	dTable;
  fdCallback_t		fdCallback;
/* GGTCP signal masks */
  ULONG			sigIntrMask;
  ULONG			sigIOMask;
  ULONG			sigUrgMask;
/* -- these are used by tsleep()/wakeup() -- */
  const char *		p_wmesg;
  queue_chain_t 	p_sleep_link;
  caddr_t		p_wchan;               /* event process is awaiting */
  struct timerequest *	tsleep_timer;
  struct MsgPort *	timerPort;
/* -- pointer to select buffer during Select() -- */
  struct newselbuf *	p_sb;
/* -- per process fields used by various 'library' functions -- */
/* buffer for inet_ntoa */
  char			inet_ntoa[20]; /* xxx.xxx.xxx.xxx\0 */
/* -- pointers for data buffers that MAY be used -- */
  struct DataBuffer	selitems;
  struct DataBuffer	hostents;
  struct DataBuffer	netents;
  struct DataBuffer	protoents;
  struct DataBuffer	servents;
/* -- variables for the syslog (see netinclude:sys/syslog.h) -- */
  UBYTE			LogStat;                                  /* status */
  UBYTE			LogMask;                     /* mask for log events */
  UWORD			LogFacility;                       /* facility code */
  const char *		LogTag;	           /* tag string for the log events */
/* -- resolver variables -- */
  LONG *		hErrnoPtr;
  LONG			defHErrno;
  LONG			res_socket;       /* socket used for resolver comm. */
  struct state          res_state;
};

/* 
 * Socket base flags 
 */
#define SBFB_COMPAT43	0L	    /* compat 43 code (without sockaddr_len) */

#define SBFF_COMPAT43   1L

/*
 * macro for getting error value pointed by the library base. All but
 * the lowest byte of the errno are assumed to stay zero. 
 */
#define readErrnoValue(base) ((base)->errnoPtr[(base)->errnoSize - 1])

extern struct SignalSemaphore syscall_semaphore;
extern struct List releasedSocketList;

/*
 *  Functions to put and remove application library to/from exec library list
 */
BOOL api_init(VOID);
BOOL api_show(VOID);
VOID api_hide(VOID);
VOID api_setfunctions(VOID);
VOID api_sendbreaktotasks(VOID);
VOID api_deinit(VOID);

/* Function which set Errno value */

VOID writeErrnoValue(struct SocketBase *, int);

/*
 * inline functions which changes (raises) task priority while it is
 * executing library functions
 */

static inline void ObtainSyscallSemaphore(struct SocketBase *libPtr)
{
  extern struct Task *GGTCP_Task;

  ObtainSemaphore(&syscall_semaphore);
  libPtr->myPri = SetTaskPri(libPtr->thisTask,
			     libPtr->libCallPri = GGTCP_Task->tc_Node.ln_Pri);
}

static inline void ReleaseSyscallSemaphore(struct SocketBase *libPtr)
{
  if (libPtr->libCallPri != (libPtr->myPri = SetTaskPri(libPtr->thisTask,
							libPtr->myPri)))
    SetTaskPri(libPtr->thisTask, libPtr->myPri);
  ReleaseSemaphore(&syscall_semaphore);
}

/*
 * inline function for searching library base when taskpointer is known
 */

static inline struct SocketBase *FindSocketBase(struct Task *task)
{
  extern struct List socketBaseList;
  struct Node *libNode;

  Forbid();
  for (libNode = socketBaseList.lh_Head; libNode->ln_Succ;
       libNode = libNode->ln_Succ)
    if (((struct SocketBase *)libNode)->thisTask == task) {
      Permit();
      return (struct SocketBase *)libNode;
    }
  /* here if Task wasn't in socketBaseList */
  Permit();
  return NULL;
}

#endif /* !AMIGA_API_H */
#endif /* API_AMIGA_API_H */
