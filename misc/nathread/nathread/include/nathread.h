#ifndef _NATHREAD_H
#define _NATHREAD_H 1

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif
#ifndef DOS_DOSTAGS_H
#include <dos/dostags.h>
#endif

#include <sys/time.h>

//-----------------------------------------------------------------------------

struct nathread_thread_s;
struct nathread_cond_s;
struct nathread_mutex_s;

#ifndef NATHREAD_THREAD_F
#define NATHREAD_THREAD_F 1
typedef APTR (*nathread_thread_f)(APTR);
#endif
#ifndef NATHREAD_THREAD_T
#define NATHREAD_THREAD_T 1
typedef struct nathread_thread_s	*nathread_thread_t;
#endif
#ifndef NATHREAD_MUTEX_T
#define NATHREAD_MUTEX_T 1
typedef struct nathread_mutex_s *nathread_mutex_t;
#endif
#ifndef NATHREAD_COND_T
#define NATHREAD_COND_T 1
typedef struct nathread_cond_s *nathread_cond_t;
#endif

#define NATHREAD_ENTRY     (TAG_USER + 1)
#define NATHREAD_NAME      (TAG_USER + 2)
#define NATHREAD_BASENAME  (TAG_USER + 3)
#define NATHREAD_PRIORITY  (TAG_USER + 4)
#define NATHREAD_STACKSIZE (TAG_USER + 5)
#define NATHREAD_DATA      (TAG_USER + 6)
#define NATHREAD_OPENBSD   (TAG_USER + 7)

//-----------------------------------------------------------------------------

int nathread_init(void);
int nathread_exit(void);

int nathread_thread_init(nathread_thread_t *, struct TagItem *);
void nathread_thread_exit(APTR);
int nathread_thread_join(nathread_thread_t, APTR *);
int nathread_thread_setpriority(nathread_thread_t, int);

int nathread_mutex_init(nathread_mutex_t *);
int nathread_mutex_exit(nathread_mutex_t *);
int nathread_mutex_lock(nathread_mutex_t *);
int nathread_mutex_trylock(nathread_mutex_t *);
int nathread_mutex_unlock(nathread_mutex_t *);

int nathread_cond_init(nathread_cond_t *);
int nathread_cond_exit(nathread_cond_t *);
int nathread_cond_wait(nathread_cond_t *, nathread_mutex_t *);
int nathread_cond_signal(nathread_cond_t *);
int nathread_cond_broadcast(nathread_cond_t *);

#define nathread_thread_inittaglist(__p, ...) \
	({unsigned long _tags[] = { __VA_ARGS__ }; \
	nathread_thread_init(__p, (struct TagItem *)_tags);})

//-----------------------------------------------------------------------------

#endif /* _NATHREAD_H */

