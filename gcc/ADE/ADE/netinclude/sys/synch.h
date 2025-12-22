#ifndef SYS_SYNCH_H
#define SYS_SYNCH_H

#include <sys/types.h>
#include <exec/types.h>
#include <exec/execbase.h>
#include <sys/time.h>
#include <machine/param.h>
#include <api/amiga_api.h>


extern BOOL sleep_init(void);
extern void tsleep_send_timeout(struct SocketBase *, const struct timeval *);
extern void tsleep_abort_timeout(struct SocketBase *, const struct timeval *);
extern void tsleep_enter(struct SocketBase *, caddr_t, const char *);
extern int  tsleep_main(struct SocketBase *, ULONG blockmask);
extern int  tsleep(struct SocketBase *, caddr_t, const char *,const struct timeval *);
extern void wakeup(caddr_t);
extern BOOL spl_init(void);
//extern int spl_n(int );
//typedef int spl_t;
#ifdef SPL0
#undef SPL0
#endif
#ifdef SPLSOFTCLOCK
#undef SPLSOFTCLOCK
#endif
#ifdef SPLNET
#undef SPLNET
#endif
#ifdef SPLIMP
#undef SPLIMP
#endif
#define SPL0         0
#define SPLSOFTCLOCK 1
#define SPLNET       2
#define SPLIMP       3


/*
 * Spl-levels used in this implementation
 */

/*
 * Spl-function prototypes and definitions.
 *
 * spl_t is the return type of the spl_n(). It should be used when defining
 * storage to store the return value, using int may be little slower :-) 
 */

extern BOOL spl_init(void);

#ifdef DEBUG

typedef int spl_t;
extern spl_t spl_n(spl_t newlevel);

#define spl0()          spl_n(SPL0)
#define splsoftclock()  spl_n(SPLSOFTCLOCK)
#define splnet()        spl_n(SPLNET)
#define splimp()        spl_n(SPLIMP)
#define splx(s)         spl_n(s)

#else

typedef BYTE spl_t;		/* the type of SysBase->TDNestCnt */

extern struct ExecBase * SysBase;

static inline spl_t spl_n(spl_t new_level)
{
  spl_t old_level = SysBase->TDNestCnt;

  if (new_level != SPL0)
    SysBase->TDNestCnt = new_level;
  else {
    SysBase->TDNestCnt = 1;
    Permit();
  }
  return old_level;
}

static inline spl_t spl_const(spl_t new_level)
{
  spl_t old_level = SysBase->TDNestCnt;

  SysBase->TDNestCnt = new_level;

  return old_level;
}

static inline spl_t
spl_0(void)
{
  spl_t oldlevel = SysBase->TDNestCnt;

  if (oldlevel != SPL0) {
    SysBase->TDNestCnt = 1;
    Permit();
  }

  return oldlevel;
}

#define spl0()          spl_0()
#define splsoftclock()  spl_const(SPLSOFTCLOCK)
#define splnet()        spl_const(SPLNET)
#define splimp()        spl_const(SPLIMP)
#define splx(s)         spl_n(s)

#endif /* DEBUG */



#endif /* !SYS_SYNCH_H */
