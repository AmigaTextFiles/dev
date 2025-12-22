
#ifndef _TEK_KERNEL_LINUX_EXEC_H
#define _TEK_KERNEL_LINUX_EXEC_H

#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <signal.h>
#include <sys/time.h>
#include <errno.h>


struct posixthread
{
	pthread_t pthread;	
	void *data;
	void (*function)(void *);
	pthread_key_t tsdkey;
	
	pthread_mutex_t proclock;		/* process-wide sock errno lock (basecontext only) */
};


struct posixevent
{
	pthread_mutex_t mutex;
	pthread_cond_t cond;
	int status;
};

struct posixtimer
{
	pthread_mutex_t mutex;
	pthread_cond_t cond;
	struct timeval timeval;
};



/* 
**	posix special:
*/

extern TVOID kn_lockbasecontext(TKNOB *thread);
extern TVOID kn_unlockbasecontext(TKNOB *thread);


#endif
