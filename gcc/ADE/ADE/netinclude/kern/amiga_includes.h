#ifndef AMIGA_INCLUDES_H
#define AMIGA_INCLUDES_H

/*
 * Standard Amiga includes
 */
#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif

#ifndef EXEC_MEMORY_H
#include <exec/memory.h>
#endif

#ifndef EXEC_SEMAPHORES_H
#include <exec/semaphores.h>
#endif

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

#ifndef EXEC_DEVICES_H
#include <exec/devices.h>
#endif

#ifndef EXEC_EXECBASE_H
#include <exec/execbase.h>
#endif

#ifndef EXEC_IO_H
#include <exec/io.h>
#endif

#ifndef PROTO_EXEC_H
#include <proto/exec.h>
#endif

#ifndef PROTO_ALIB_H
#include <proto/alib.h>
#endif

#ifndef DOS_DOS_H
#include <dos/dos.h>
#endif

#ifndef _CDEFS_H_
#include <sys/cdefs.h>
#endif

#ifndef _SYS_TYPES_H_
#include <sys/types.h>
#endif

#ifndef _SYS_TIME_H_
#include <sys/time.h>
#endif

#if 0

/*
 * for built in functions in SASC
 */
#if __SASC
#define USE_BUILTIN_MATH
#ifndef _STRING_H
#include <string.h>
#endif
#elif __GNUC__
/* There is also built in functions in GNUC
 * -- however, we do not use them just now.
 *   Actually, we'll give 'em a shot. LW
 */
/*
#define _SIZE_T_        unsigned int            / sizeof() / (comment)

#ifdef _SIZE_T_
typedef _SIZE_T_ size_t;
#undef _SIZE_T_
#endif
*/
#ifndef NULL
#define NULL 0
#endif

#endif
/*
extern struct ExecBase *SysBase;
*/
/*
 * Amiga shared library prototypes
 */

#if __GNUC__

#ifndef PROTO_EXEC_H
#include <proto/exec.h>
#endif

#ifndef PROTO_TIMER_H
/*
 * predefine TimerBase to Library to follow SASC convention.
 */
/*
#define BASE_EXT_DECL extern struct Library * TimerBase;
#define BASE_NAME (struct Device *)TimerBase
*/
#include <inline/timer.h>
#endif

static inline VOID  
BeginIO(register struct IORequest *ioRequest)
{
  register struct IORequest *a1 __asm("a1") = ioRequest;
  register struct Device *a6 __asm("a6") = ioRequest->io_Device;
  __asm __volatile ("jsr a6@(-0x1e)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}

#elif __SASC
/*
#ifndef CLIB_EXEC_PROTOS_H
#include <clib/exec_protos.h>
#endif
#include <pragmas/exec_sysbase_pragmas.h>
#ifndef PROTO_TIMER_H
#include <proto/timer.h>
#endif
*/
#pragma msg 93 ignore push

#if 0

extern VOID pragmaed_AbortIO(struct IORequest *);
#pragma libcall DeviceBase pragmaed_AbortIO 24 901

static inline __asm VOID 
AbortIO(register __a1 struct IORequest *ioRequest)
{
#define DeviceBase ioRequest->io_Device
  pragmaed_AbortIO(ioRequest);
#undef DeviceBase
}

#endif

extern VOID pragmaed_BeginIO(struct IORequest *);
#pragma libcall DeviceBase pragmaed_BeginIO 1E 901

static inline __asm VOID 
BeginIO(register __a1 struct IORequest *ioRequest)
{
#define DeviceBase ioRequest->io_Device
  pragmaed_BeginIO(ioRequest);
#undef DeviceBase
}

#pragma msg 93 pop

#endif


/*
 * common inlines for both compilers
 */

static inline VOID
NewList(register struct List *list)
{
  list->lh_Head = (struct Node *)&list->lh_Tail;
  list->lh_Tail = NULL;
  list->lh_TailPred = (struct Node *)list;
}

#endif /* 0 */




/*
 * undef math log, because it conflicts with log() used for logging.
 */
#undef log

#undef BASE_EXT_DECL
#undef BASE_NAME

#endif /* !AMIGA_INCLUDES_H */

