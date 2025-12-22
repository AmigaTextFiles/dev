#ifndef CLIB_EXTRAS_THREAD_PROTOS_H
#define CLIB_EXTRAS_THREAD_PROTOS_H

#ifndef EXTRAS_THREADS_H
#include <extras/threads.h>
#endif

struct Thread *thread_StartThread(ULONG Tags, ... );
void thread_EndThread(struct Thread *Thread, APTR NullForNow);

BOOL  thread_PutTMsg(struct Thread *Thread, struct ThreadMessage *TM);
BOOL  thread_PutTMsg_Sync(struct Thread *Thread, struct ThreadMessage *TMsg);

ULONG thread_PutTMsg_TagList(struct Thread *Thread, ULONG Command, ULONG Tag, ...);

void thread_ReplyCurrentMsg(struct Thread *Thread);

// Used by apps to send messages to thread ReplyPort must be set.
// ONLY to be used with threads that use TA_MsgHandler;

#define TH_StartThread      thread_StartThread
#define TH_EndThread        thread_EndThread
#define TH_PutTMsg          thread_PutTMsg
#define TH_PutTMsg_TagList  thread_PutTMsg_TagList


#endif /* CLIB_EXTRAS_THREAD_PROTOS_H */
