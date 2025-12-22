/*
 * Following is the basis of the whole system (including the dispatcher).
 * Therefore I'd like to call it the kernel though it's probably
 * too small for a real kernel or even a microkernel and it doesn't all run in
 * supervisor mode like a kernel usually does...
 *
 * Anyway - the interface to the interrupt mechanism of the "hardware"
 * and other important stuff consists of 6 well-known and 4 private functions:
 *
 * void RaiseInt(ULONG intnum);
 *
 *   Generates a certain interrupt (immediately if not in disabled state).
 *
 * APTR SwitchContext(APTR newstack);
 *
 *   Switches the underlying user context (stack) to a new one.
 *   Returns the old one. Must be called from interrupt code.
 *
 * APTR AddContext(APTR oldstack,APTR function,APTR data);
 *
 *   Can be used to build a new context on top of some old one or some
 *   fresh stackspace (oldstack). Returns the new top of stack.
 *   'function' gets called with 'data' provided and in disabled state.
 *   Falling through the end of it returns to the old context.
 *
 * void FallAsleep(void);
 *
 *   Puts the whole system asleep and waits until some interrupts had happened.
 *
 * As always: Don't use private stuff - it's explained here to be able to port
 *            or understand it, not to use it.
 */

#include <stdio.h>
#include <signal.h>
#include <setjmp.h>
#include <sys/time.h>
#include <hardware/intbits.h>
#include <clib/_exec.h>
#include <amigem/utils.h>
#include "exec.h"
#include "machine.h"

#ifdef ABSEXECBASE
#define SYSBASE (*(struct ExecBase **)(ABSEXECBASE))
#else
struct ExecBase *sysbase;
#define SYSBASE sysbase
#endif

#include <amigem/fd_lib.h>
#define LIBBASE struct ExecBase *SysBase

#define cacheclearu		      (*(void (*)(void))SysBase->functable[0])
#define cachecleare	  (*(void (*)(APTR,ULONG,ULONG))SysBase->functable[1])
#define cachepredma	 (*(APTR (*)(APTR,LONG *,ULONG))SysBase->functable[2])
#define cachepostdma	 (*(void (*)(APTR,LONG *,ULONG))SysBase->functable[3])
#define setjmp			    (*(int (*)(jmp_buf))SysBase->functable[4])
#define longjmp		       (*(void (*)(jmp_buf,int))SysBase->functable[5])
#define kill			  (*(int (*)(pid_t,int))SysBase->functable[6])
#define getpid			     (*(pid_t (*)(void))SysBase->functable[7])
#define sigprocmask \
	    (*(int (*)(int,const sigset_t *,sigset_t *))SysBase->functable[8])
#define sigsuspend	   (*(int (*)(const sigset_t *))SysBase->functable[9])
#define setitimer \
 (*(int (*)(int,struct itimerval *,struct itimerval *))SysBase->functable[11])

/*
 * How to map signals to interrupts.
 */
static const WORD maptabl[][2]=
{
  { SIGALRM,INTB_VERTB },
  { SIGUSR1,INTB_SOFTINT }
};

void handler(int sig);

/*
 * This initializes some things.
 */
void InitKernel(struct ExecBase *SysBase)
{
  int i;
  struct sigaction sa;

  SYSBASE=SysBase;

  sigemptyset(&SysBase->used);
  sigemptyset(&SysBase->currentints);
  SysBase->currentcontext=NULL;

  for(i=0;i<sizeof(maptabl)/(sizeof(WORD))/2;i++)
  {
    SysBase->inttabl[maptabl[i][0]]=maptabl[i][1];
    SysBase->sigtabl[maptabl[i][1]]=maptabl[i][0];
    sigaddset(&SysBase->used,maptabl[i][0]);
  }
  sa.sa_handler=&handler;
  sa.sa_mask=SysBase->used;
  sa.sa_flags=0;
  for(i=0;i<sizeof(maptabl)/(sizeof(WORD))/2;i++)
    (*(void (*)(int,struct sigaction *,struct sigaction *))SysBase->functable[10])
      (maptabl[i][0],&sa,NULL); /* sigaction() */
  {
    struct itimerval t;

    t.it_interval.tv_sec =t.it_value.tv_sec =0;
    t.it_interval.tv_usec=t.it_value.tv_usec=20000;
    setitimer(ITIMER_REAL,&t,NULL);
  }
}

FD0F(20,p,void,Disable)
{
  sigprocmask(SIG_BLOCK,&SysBase->used,NULL); /* To make it reentrant disable always */
  SysBase->IDNestCnt++;
}

FD0F(21,p,void,Enable)
{
  if(!SysBase->IDNestCnt--)
  {
    if(SysBase->currentcontext!=NULL) /* Save to call from supervisor mode */
      sigprocmask(SIG_SETMASK,&SysBase->currentints,NULL);
    else
      sigprocmask(SIG_UNBLOCK,&SysBase->used,NULL);
  }
}

FD0(6,void,Private_1) /* FallAsleep */
{
  sigsuspend(&SysBase->used);
}

/* Call function over base register A5 */
FC2F(0,b,void,IntHandler,A5,APTR is_data,A1,struct ExecBase *SysBase,A6)
;

FC2(0,void,super,A0,int sig,D0,APTR stack,SP)
{
  sigset_t omask;
  struct ExecBase *SysBase=SYSBASE;

  sigaddset(&SysBase->currentints,sig);
  sigprocmask(SIG_SETMASK,&SysBase->currentints,&omask);
  if(SysBase->IntVects[SysBase->inttabl[sig]].iv_Code)
    IntHandler(SysBase->IntVects[SysBase->inttabl[sig]].iv_Code,
               SysBase->IntVects[SysBase->inttabl[sig]].iv_Data,SysBase);
  sigdelset(&SysBase->currentints,sig);
  sigprocmask(SIG_SETMASK,&omask,NULL);
}

struct jb /* You cannot build the address of a jmp_buf but of a struct jb */
{ jmp_buf jb; };

#define JB2SP(jb) ((char *)&(jb)-CONTEXTOFFSET)
#define SP2JB(sp) (((struct jb *)((char *)(sp)+CONTEXTOFFSET))->jb)

/*
 * This function is single-threaded by setting all bits in the signal mask
 * of sigaction(). It calls itself recursively on the supervisor stack
 * (if not already done) then reenables all signals not currently delivered.
 * The current position on the user stack is memorized as the current context.
 */
void handler(int sig)
{
  volatile struct ExecBase *SysBase=SYSBASE;

  if(!SysBase->currentcontext)
  {
    struct jb jb;
    SysBase->currentcontext=JB2SP(jb.jb);
    if(!setjmp(jb.jb))
    {
      super(&__super,sig,STACKPOINTER(SysBase->SysStkLower,SysBase->SysStkUpper));
      longjmp(SP2JB(SysBase->currentcontext),1);
    }
    SysBase->currentcontext=NULL;
  }else
    ___super(NULL,sig,NULL);
}

FD1(7,APTR,Private_2,APTR newstack,A0) /* SwitchContext */
{
  APTR ret;
  Disable();
    ret=SysBase->currentcontext;
    SysBase->currentcontext=newstack;
  Enable();
  return ret;
}

FC3(0,void,newcontext,A0,APTR function,A1,APTR data,A2,APTR stack,SP)
{
  volatile APTR f2=function,d2=data,sp=stack;
  volatile struct ExecBase *SysBase=SYSBASE;

  struct jb jb;

  if(!setjmp(jb.jb))
  {
    struct jb *t;
    t=(struct jb *)SysBase->newstack;
    SysBase->newstack=(APTR)&jb;
    longjmp(t->jb,1);
  }
  SysBase->currentcontext=NULL;
  SysBase->IDNestCnt=0;
  IntHandler(f2,d2,(struct ExecBase *)SysBase);
  SysBase->IDNestCnt=-1;
  longjmp(SP2JB(sp),1);
}

FD3(8,APTR,Private_3,APTR oldstack,A0,APTR function,A1,APTR data,A2) /* AddContext */
{
  APTR ret;
  struct jb jb;
  Disable();
  SysBase->newstack=(APTR)&jb;
  if(!setjmp(jb.jb))
    newcontext(&__newcontext,function,data,oldstack);
  ret=JB2SP(*SysBase->newstack);
  Enable();
  return ret;
}

FD1(9,void,Private_4,ULONG intnum,D0) /* RaiseInt */
{
  kill(getpid(),SysBase->sigtabl[intnum]);
}

FD0(106,void,CacheClearU)
{ cacheclearu(); }

FD3(107,void,CacheClearE,APTR address,A0,ULONG length,D0,ULONG flags,D1)
{ cachecleare(address,length,flags); }

FD3(127,APTR,CachePreDMA,APTR address,A0,LONG *length,A1,ULONG flags,D0)
{ return cachepredma(address,length,flags); }

FD3(128,void,CachePostDMA,APTR address,A0,LONG *length,A1,ULONG flags,D0)
{ cachepostdma(address,length,flags); }
