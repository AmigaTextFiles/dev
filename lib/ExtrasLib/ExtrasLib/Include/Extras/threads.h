#ifndef EXTRAS_THREADS_H
#define EXTRAS_THREADS_H

#ifndef EXEC_NODES_H
#include "exec/nodes.h"
#endif /* EXEC_NODES_H */

#ifndef EXEC_LISTS_H
#include "exec/lists.h"
#endif /* EXEC_LISTS_H */

#ifndef EXEC_TASKS_H
#include "exec/tasks.h"
#endif /* EXEC_TASKS_H */

#ifndef EXEC_PORTS_H
#include <exec/ports.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

/* TAGS */
#define TA_DUMMY(x)    (TAG_USER + (x))
                                   // Defaults
#define TA_Name       TA_DUMMY(1) // "Thread"
#define TA_Stack      TA_DUMMY(2) // 8192
#define TA_Priority   TA_DUMMY(3) // -1

//#define TA_Entry      TA_DUMMY(4) // Entry
#define TA_MsgHandler TA_DUMMY(5) // Required

#define TA_UserData   TA_DUMMY(6) // (APTR)

/* Proto for thread entry

ULONG __asm __saveds ThreadMsgHandler( register __a0 struct Thread *T,
                                       register __a1 struct ThreadMessage *TMsg)

*/

/* Readable ONLY unless otherwise marked */
struct Thread
{
  struct Node t_Node; // Application use
  STRPTR TName; 
  struct Process *t_Process;
  struct MsgPort *t_MsgPort;
  struct ThreadMessage *t_CurrentMsg;
  APTR   UserData;    // Application use
  APTR   ThreadData;  // App/Thread use
};

// ThreadMessage.tm_Command

/* USER messages MUST NOT HAVE 1<<31 set */

#define TMSG_DUMMY(x)     ((1<<31) + (x))
#define TMSG_INTERNAL_BIT TMSG_DUMMY(0)  // User messages must not have this bit set.
#define TMSG_DIE          TMSG_DUMMY(1)  // All threads shoul respect this message.
#define TMSG_SIGNAL       TMSG_DUMMY(2)  // Thread has been Signaled.
#define TMSG_SIGNALED     TMSG_DUMMY(2)  // Thread has been Signaled.

/* Basic thread message */
struct ThreadMessage
{
  struct Message  tm_Msg;
  ULONG           tm_Command;
  // User data follows
};

struct TMsg_TagList
{
  struct Message  tm_Msg;
  ULONG           tm_Command,
                  tm_RetVal;
  struct TagItem  *tm_TagList;
};

struct TMsg_Signal
{
  struct ThreadMessage TMsg;
  ULONG  Signal;
};



#endif /* EXTRAS_THREADS_H */
