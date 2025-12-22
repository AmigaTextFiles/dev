#ifndef KERN_AMIGA_TIME_H
#define KERN_AMIGA_TIME_H

#ifndef AMIGA_TIME_H
#define AMIGA_TIME_H


#ifndef _CDEFS_H_
#include <sys/cdefs.h>
#endif

#ifndef AMIGA_INCLUDES_H
#include <kern/amiga_includes.h>
#endif

/*
 * Globals defined in amiga_time.c
 */

extern struct Device     *TimerBase;

/*
 * Define an extended timerequest to make implementing the UNIX kernel function
 * timeout() easier.
 */

typedef void (*TimerCallback_t)(void);

struct timeoutRequest {
  struct timerequest timeout_request;	/* timer.device sees only this */
  struct timeval     timeout_timeval;   /* timeout interval */
  TimerCallback_t    timeout_function;  /* timeout function to be called */
};


/*
 * Command field must be TR_ADDREQUEST before this is called!
 * A request may be sent again ONLY AFTER PREVIOUS REQUEST HAS BEEN RETURNED!
 */
static inline void
sendTimeoutRequest(struct timeoutRequest *tr)
{
  tr->timeout_request.tr_time = tr->timeout_timeval;
  SendIO((struct IORequest *)&(tr->timeout_request));
}

/*
 * This MUST be called at splsoftclock()
 */
static inline void
handleTimeoutRequest(struct timeoutRequest *tr)
{
  /*
   * call the function
   */
  (*(tr->timeout_function))();
}

/*
 * prototypes for functions defined in kern/amiga_time.c
 */
ULONG timer_init(void);
void timer_deinit(void);
void timer_send(void);
struct timeoutRequest * createTimeoutRequest(TimerCallback_t fun,
					     ULONG seconds, ULONG micros);
void deleteTimeoutRequest(struct timeoutRequest *tr);
BOOL timer_poll(VOID);

#endif /* AMIGA_TIME_H */
#endif /* KERN_AMIGA_TIME_H */
