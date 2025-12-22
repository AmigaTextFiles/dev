
/*
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	tek/kn/linux/exec.c
**	posix kernel backend
**
**	written for Linux - but this might be posix compliant, well mostly
*/


#include <tek/type.h>
#include <tek/kn/exec.h>
#include <tek/kn/linux/exec.h>


/* 
**	MEMORY ALLOCATION
**
*/

TAPTR kn_alloc(TUINT size)
{
	TUINT *mem = malloc(size + sizeof(void *) * 2);
	if (mem)
	{
		*mem = size;
		return (TAPTR) (mem + 2);
	}
	return TNULL;
}


TAPTR kn_alloc0(TUINT size)
{
	TUINT *mem = malloc(size + sizeof(void *) * 2);
	if (mem)
	{
		*mem = size;
		memset(mem + 2, 0, size);
		return (TAPTR) (mem + 2);
	}
	return TNULL;
}


TVOID kn_free(TAPTR mem)
{
	free(((TUINT *) mem) - 2);
}


TAPTR kn_realloc(TAPTR oldmem, TUINT newsize)
{
	TUINT *mem = realloc(((TUINT *) oldmem) - 2, newsize + sizeof(void *) * 2);
	if (mem)
	{
		*mem = newsize;
		return (TAPTR) (mem + 2);
	}
	return TNULL;
}


TUINT kn_getsize(TAPTR mem)
{
	return *(((TUINT *) mem) - 2);
}



/* 
**	MEMORY MANIPULATION
**
*/

TVOID kn_memcopy(TAPTR from, TAPTR to, TUINT numbytes)
{
	memcpy(to, from, numbytes);
}


TVOID kn_memcopy32(TAPTR from, TAPTR to, TUINT numbytes)
{
	memcpy(to, from, numbytes);
}


TVOID kn_memset(TAPTR dest, TUINT numbytes, TUINT8 fillval)
{
	memset(dest, (int) fillval, numbytes);
}


TVOID kn_memset32(TAPTR dest, TUINT numbytes, TUINT fillval)
{
	TUINT i, *m = dest;
	for (i = 0; i < numbytes >> 2; ++i)
	{
		*m++ = fillval;
	}
}



/* 
**	LOCK
**
*/

TBOOL kn_initlock(TKNOB *lock)
{
	if (sizeof(TKNOB) >= sizeof(pthread_mutex_t))
	{
		pthread_mutexattr_t attr;
		pthread_mutexattr_init(&attr);
		/*pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);*/
		if (pthread_mutexattr_setkind_np(&attr, PTHREAD_MUTEX_RECURSIVE_NP) == 0)
		{
			pthread_mutex_init((pthread_mutex_t *) lock, &attr);
			pthread_mutexattr_destroy(&attr);
			return TTRUE;
		}
		pthread_mutexattr_destroy(&attr);
	}
	else
	{
		pthread_mutex_t *mut = kn_alloc(sizeof(pthread_mutex_t));
		if (mut)
		{
			pthread_mutexattr_t attr;
			pthread_mutexattr_init(&attr);
			/*pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);*/
			if (pthread_mutexattr_setkind_np(&attr, PTHREAD_MUTEX_RECURSIVE_NP) == 0)
			{
				pthread_mutex_init(mut, &attr);
				pthread_mutexattr_destroy(&attr);
				*((pthread_mutex_t **) lock) = mut;
				return TTRUE;
			}
			pthread_mutexattr_destroy(&attr);
		}
	}

	dbkprintf(20,"*** TEKLIB kernel: could not create lock\n");
	return TFALSE;
}


TVOID kn_destroylock(TKNOB *lock)
{
	if (sizeof(TKNOB) >= sizeof(pthread_mutex_t))
	{
		if (pthread_mutex_destroy((pthread_mutex_t *) lock) == EBUSY) dbkprintf(10,"*** kn_destroylock(0): mutex_destroy busy!\n");
	}
	else
	{
		if (pthread_mutex_destroy(*((pthread_mutex_t **) lock)) == EBUSY) dbkprintf(10,"*** kn_destroylock(1): mutex_destroy busy!\n");
		kn_free(*((pthread_mutex_t **) lock));
	}
}


TVOID kn_lock(TKNOB *lock)
{
	if (sizeof(TKNOB) >= sizeof(pthread_mutex_t))
	{
		if (pthread_mutex_lock((pthread_mutex_t *) lock)) dbkprintf(10,"*** kn_lock(0): mutex_lock\n");
	}
	else
	{
		if (pthread_mutex_lock(*((pthread_mutex_t **) lock))) dbkprintf(10,"*** kn_lock(1): mutex_lock\n");
	}
}


TVOID kn_unlock(TKNOB *lock)
{
	if (sizeof(TKNOB) >= sizeof(pthread_mutex_t))
	{
		if (pthread_mutex_unlock((pthread_mutex_t *) lock)) dbkprintf(10,"*** kn_unlock(0): mutex_unlock\n");
	}
	else
	{
		if (pthread_mutex_unlock(*((pthread_mutex_t **) lock))) dbkprintf(10,"*** kn_unlock(1): mutex_unlock\n");
	}
}



/* 
**	TIMER
**
*/

TBOOL kn_inittimer(TKNOB *timer)
{
	if (sizeof(TKNOB) >= sizeof(struct posixtimer))
	{
		struct posixtimer *t = (struct posixtimer *) timer;
		if (pthread_cond_init(&t->cond, NULL) == 0)
		{
			pthread_mutex_init(&t->mutex, NULL);
			gettimeofday(&t->timeval, NULL);
			return TTRUE;
		}
	}
	else
	{
		struct posixtimer *t = kn_alloc(sizeof(struct posixtimer));
		if (t)
		{
			if (pthread_cond_init(&t->cond, NULL) == 0)
			{
				pthread_mutex_init(&t->mutex, NULL);
				gettimeofday(&t->timeval, NULL);
				*((struct posixtimer **) timer) = t;
				return TTRUE;
			}
			kn_free(t);
		}
	}

	dbkprintf(20,"*** TEKLIB kernel: could not create timer\n");
	return TFALSE;
}


TVOID kn_destroytimer(TKNOB *timer)
{
	if (sizeof(TKNOB) >= sizeof(struct posixtimer))
	{
		struct posixtimer *t = (struct posixtimer *) timer;

		if (pthread_mutex_destroy(&t->mutex)) dbkprintf(10,"*** kn_destroytimer: mutex_destroy(0)\n");
		if (pthread_cond_destroy(&t->cond)) dbkprintf(10,"*** kn_destroytimer: cond_destroy(0)\n");
	}
	else
	{
		struct posixtimer *t = *((struct posixtimer **) timer);

		if (pthread_mutex_destroy(&t->mutex)) dbkprintf(10,"*** kn_destroytimer: mutex_destroy(1)\n");
		if (pthread_cond_destroy(&t->cond)) dbkprintf(10,"*** kn_destroytimer: cond_destroy(1)\n");

		kn_free(t);
	}
}


TVOID kn_querytimer(TKNOB *timer, TTIME *tektime)
{
	float sec;
	struct posixtimer *t;

	if (sizeof(TKNOB) >= sizeof(struct posixtimer))
	{
		t = (struct posixtimer *) timer;
	}
	else
	{
		t = *((struct posixtimer **) timer);
	}
	
	gettimeofday((struct timeval *) tektime, NULL);

	sec = 	((float)(tektime->sec - t->timeval.tv_sec)) + 
		0.000001f * tektime->usec - 0.000001f * t->timeval.tv_usec;

	tektime->sec = (TUINT) sec;
	tektime->usec = (sec - tektime->sec) * 1000000;
}


TVOID kn_timedelay(TKNOB *timer, TTIME *tektime)
{
	if (tektime)
	{
		struct timeval now;
		struct timespec then;
	
		struct posixtimer *t;
		if (sizeof(TKNOB) >= sizeof(struct posixtimer))
		{
			t = (struct posixtimer *) timer;
		}
		else
		{
			t = *((struct posixtimer **) timer);
		}
	
		pthread_mutex_lock(&t->mutex);

		gettimeofday(&now, NULL);
	
		then.tv_sec = now.tv_sec + tektime->sec;
		then.tv_nsec = now.tv_usec + tektime->usec;
		if (then.tv_nsec >= 1000000)
		{
			then.tv_nsec -= 1000000;
			then.tv_sec++;
		}
		then.tv_nsec *= 1000;
	
		if (pthread_cond_timedwait(&t->cond, &t->mutex, &then) != ETIMEDOUT)
		{
			dbkprintf(10,"*** TEKLIB kn_timedelay: pthread_cond_timedwait\n");
		}

		pthread_mutex_unlock(&t->mutex);
	}
}


TVOID kn_resettimer(TKNOB *timer)
{
	struct posixtimer *t;

	if (sizeof(TKNOB) >= sizeof(struct posixtimer))
	{
		t = (struct posixtimer *) timer;
	}
	else
	{
		t = *((struct posixtimer **) timer);
	}

	gettimeofday(&t->timeval, NULL);
}



/* 
**	EVENT
**
*/

TBOOL kn_initevent(TKNOB *event)
{
	if (sizeof(TKNOB) >= sizeof(struct posixevent))
	{
		struct posixevent *evt = (struct posixevent *) event;
		if (pthread_cond_init(&evt->cond, NULL) == 0)
		{
			pthread_mutex_init(&evt->mutex, NULL);
			evt->status = 0;
			return TTRUE;
		}
	}
	else
	{
		struct posixevent *evt = kn_alloc(sizeof(struct posixevent));
		if (evt)
		{
			if (pthread_cond_init(&evt->cond, NULL) == 0)
			{
				pthread_mutex_init(&evt->mutex, NULL);
				evt->status = 0;
				*((struct posixevent **) event) = evt;
				return TTRUE;
			}
			kn_free(evt);
		}
	}

	dbkprintf(20,"*** TEKLIB kernel: could not create event\n");
	return TFALSE;
}


TVOID kn_destroyevent(TKNOB *event)
{
	if (sizeof(TKNOB) >= sizeof(struct posixevent))
	{
		struct posixevent *evt = (struct posixevent *) event;
		if (pthread_mutex_destroy(&evt->mutex)) dbkprintf(10,"*** kn_destroyevent: mutex_destroy(0)\n");
		if (pthread_cond_destroy(&evt->cond)) dbkprintf(10,"*** kn_destroyevent: cond_destroy(0)\n");
	}
	else
	{
		struct posixevent *evt = *((struct posixevent **) event);
		if (pthread_mutex_destroy(&evt->mutex)) dbkprintf(10,"*** kn_destroyevent: mutex_destroy(1)\n");
		if (pthread_cond_destroy(&evt->cond)) dbkprintf(10,"*** kn_destroyevent: cond_destroy(1)\n");
		kn_free(evt);
	}
}


TVOID kn_doevent(TKNOB *event)
{
	struct posixevent *evt;
	if (sizeof(TKNOB) >= sizeof(struct posixevent))
	{
		evt = (struct posixevent *) event;
	}
	else
	{
		evt = *((struct posixevent **) event);
	}
	if (pthread_mutex_lock(&evt->mutex)) dbkprintf(10,"*** kn_doevent: mutex_lock\n");
	evt->status = 1;
	if (pthread_cond_signal(&evt->cond)) dbkprintf(10,"*** kn_doevent: cond_signal\n");
	if (pthread_mutex_unlock(&evt->mutex)) dbkprintf(10,"*** kn_doevent: mutex_unlock\n");
}


TVOID kn_waitevent(TKNOB *event)
{
	struct posixevent *evt;
	if (sizeof(TKNOB) >= sizeof(struct posixevent))
	{
		evt = (struct posixevent *) event;
	}
	else
	{
		evt = *((struct posixevent **) event);
	}
	if (pthread_mutex_lock(&evt->mutex)) dbkprintf(10,"*** kn_waitvent: mutex_lock\n");
	while (evt->status == 0)
	{
		if (pthread_cond_wait(&evt->cond, &evt->mutex)) dbkprintf(10,"*** kn_waitevent: cond_wait\n");
	}
	evt->status = 0;
	if (pthread_mutex_unlock(&evt->mutex)) dbkprintf(10,"*** kn_waitvent: mutex_unlock\n");
}


TBOOL kn_timedwaitevent(TKNOB *event, TKNOB *timer, TTIME *tektime)
{
	TBOOL occured;
	
	struct timeval now;
	struct timespec then;
	int retcode;

	struct posixevent *evt;

	if (sizeof(TKNOB) >= sizeof(struct posixevent))
	{
		evt = (struct posixevent *) event;
	}
	else
	{
		evt = *((struct posixevent **) event);
	}

	pthread_mutex_lock(&evt->mutex);

	if (tektime)
	{
		gettimeofday(&now, NULL);
	
		then.tv_sec = now.tv_sec + tektime->sec;
		then.tv_nsec = now.tv_usec + tektime->usec;
		if (then.tv_nsec >= 1000000)
		{
			then.tv_nsec -= 1000000;
			then.tv_sec++;
		}
		then.tv_nsec *= 1000;
	
		retcode = 0;
		while (evt->status == 0 && retcode != ETIMEDOUT)
		{
			retcode = pthread_cond_timedwait(&evt->cond, &evt->mutex, &then);
		}
		occured = evt->status;
		evt->status = 0;
	}
	else
	{
		occured = evt->status;
		evt->status = 0;
	}

	pthread_mutex_unlock(&evt->mutex);

	return occured;
}



/* 
**	THREAD
**
**	flaw: we assume that the first TSD key created has index 0.
**
*/

static void *posixthread_entry(struct posixthread *thread)
{
	pthread_key_t tsdkey = 0;

	pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL);

	if (pthread_setspecific(tsdkey, (void *) thread) != 0)
	{
		dbkprintf(20,"*** TEKLIB kernel: failed to set TSD key 0\n");
	}

	(*thread->function)(thread->data);

	/*pthread_exit(NULL);*/
	return NULL;
}


TBOOL kn_initthread(TKNOB *thread, TVOID (*function)(TAPTR task), TAPTR data)
{
	if (sizeof(TKNOB) >= sizeof(struct posixthread))
	{
		struct posixthread *t = (struct posixthread *) thread;
		pthread_attr_t attr;

		t->function = function;
		t->data = data;

		if (pthread_attr_init(&attr) == 0)
		{
			if (pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED) == 0)
			{
				if (pthread_create(&t->pthread, &attr, (void *(*)(void *)) posixthread_entry, t) == 0)
				{
					pthread_attr_destroy(&attr);
					return TTRUE;
				}
			}
			pthread_attr_destroy(&attr);
		}
	}
	else
	{
		struct posixthread *t = kn_alloc(sizeof(struct posixthread));
		if (t)
		{
			pthread_attr_t attr;
	
			t->function = function;
			t->data = data;
	
			if (pthread_attr_init(&attr) == 0)
			{
				if (pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED) == 0)
				{
					if (pthread_create(&t->pthread, &attr, (void *(*)(void *)) posixthread_entry, t) == 0)
					{
						pthread_attr_destroy(&attr);
						*((struct posixthread **) thread) = t;
						return TTRUE;
					}
				}
				pthread_attr_destroy(&attr);
			}
			kn_free(t);
		}
	}

	dbkprintf(20,"*** TEKLIB kernel: could not create thread\n");
	return TFALSE;
}


TBOOL kn_initbasecontext(TKNOB *thread, TAPTR data)
{
	if (sizeof(TKNOB) >= sizeof(struct posixthread))
	{
		struct posixthread *t = (struct posixthread *) thread;

		kn_memset(t, sizeof(struct posixthread), 0);

		if (pthread_key_create(&t->tsdkey, NULL) == 0)
		{
			if (t->tsdkey == 0)
			{
				if (pthread_setspecific(t->tsdkey, thread) == 0)
				{				
					sigset_t newmask;
					sigemptyset(&newmask);
					sigaddset(&newmask, SIGPIPE);
					sigprocmask(SIG_BLOCK, &newmask, NULL);

					pthread_mutex_init(&t->proclock, NULL);

					pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL);
					t->data = data;
					return TTRUE;
				}
			}
			else
			{
				dbkprintf(20,"*** TEKLIB kernel: TSD key created != 0\n");
			}
			pthread_key_delete(t->tsdkey);
		}
	}
	else
	{
		struct posixthread *t = kn_alloc0(sizeof(struct posixthread));
		if (t)
		{
			if (pthread_key_create(&t->tsdkey, NULL) == 0)
			{
				if (t->tsdkey == 0)
				{
					if (pthread_setspecific(t->tsdkey, t) == 0)
					{
						sigset_t newmask;
						sigemptyset(&newmask);
						sigaddset(&newmask, SIGPIPE);
						sigprocmask(SIG_BLOCK, &newmask, NULL);

						pthread_mutex_init(&t->proclock, NULL);

						pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL);
						t->data = data;
						*((struct posixthread **) thread) = t;
						return TTRUE;
					}
				}
				else
				{
					dbkprintf(20,"*** TEKLIB kernel: TSD key created != 0\n");
				}
				pthread_key_delete(t->tsdkey);
			}
		}
	}	

	dbkprintf(20,"*** TEKLIB kernel: could not establish basecontext\n");
	return TFALSE;
}


TVOID kn_destroybasecontext(TKNOB *thread)
{
	if (sizeof(TKNOB) >= sizeof(struct posixthread))
	{
		pthread_mutex_destroy(&((struct posixthread *) thread)->proclock);
		pthread_key_delete(((struct posixthread *) thread)->tsdkey);
	}
	else
	{
		pthread_mutex_destroy(&(*((struct posixthread **) thread))->proclock);
		pthread_key_delete((*((struct posixthread **) thread))->tsdkey);
		kn_free(*((struct posixthread **) thread));
	}
}


TVOID kn_deinitthread(TKNOB *thread)
{

}


TVOID kn_destroythread(TKNOB *thread)
{
	if (sizeof(TKNOB) < sizeof(struct posixthread))
	{
		kn_free(*((struct posixthread **) thread));
	}
}


TAPTR kn_findself(TVOID)
{
	pthread_key_t tsdkey = 0;
	return ((struct posixthread *) pthread_getspecific(tsdkey))->data;
}



TINT kn_getrandomseed(TKNOB *timer)
{
	struct timeval nt1, nt2;

	gettimeofday(&nt1, NULL);
	gettimeofday(&nt2, NULL);
	
	return (nt1.tv_usec + nt2.tv_usec * 4279 + nt2.tv_sec);
}




#if 0

/* 
**	posix-special:
**
*/

TVOID kn_lockbasecontext(TKNOB *thread)
{
	if (sizeof(TKNOB) >= sizeof(struct posixthread))
	{
		if (pthread_mutex_lock(&((struct posixthread *) thread)->proclock)) dbkprintf(10,"lockbasecontext1\n");
	}
	else
	{
		if (pthread_mutex_lock(&(*((struct posixthread **) thread))->proclock)) dbkprintf(10,"lockbasecontext2\n");
	}
}

TVOID kn_unlockbasecontext(TKNOB *thread)
{
	if (sizeof(TKNOB) >= sizeof(struct posixthread))
	{
		if (pthread_mutex_unlock(&((struct posixthread *) thread)->proclock)) dbkprintf(10,"unlockbasecontext1\n");
	}
	else
	{
		if (pthread_mutex_unlock(&(*((struct posixthread **) thread))->proclock)) dbkprintf(10,"unlockbasecontext2\n");
	}
}

#endif
