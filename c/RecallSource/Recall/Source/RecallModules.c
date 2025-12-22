/*
 *	File:					RecallModules.c
 *	Description:	
 *
 *	(C) 1995, Ketil Hunn
 *
 */

#ifndef RECALLMODULES_C
#define	RECALLMODULES_C

/*** INCLUDES ************************************************************************/
#ifndef	EXEC_MEMORY_H
#include <exec/memory.h>
#endif

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif

#ifndef CLIB_EXEC_PROTOS_H
#include <clib/exec_protos.h>
#endif

#ifndef RECALLMODULES_H
#include "RecallModules.h"
#endif

/*** FUNCTIONS ***********************************************************************/
struct RecallMsg *AllocMessage(struct MsgPort *port, ULONG type)
{
	struct RecallMsg	*msg;

	if(msg=AllocVec(sizeof(struct RecallMsg), MEMF_CLEAR|MEMF_PUBLIC))
	{
		msg->msg.mn_Node.ln_Type	=NT_MESSAGE;
		msg->msg.mn_Length				=sizeof(struct RecallMsg);
		msg->msg.mn_ReplyPort			=port;
		msg->moduleType						=type;
	}
	return msg;
}

struct RecallMsg *SendMessageA(	struct MsgPort		*port,
																struct RecallMsg	*msg,
																struct TagItem		*taglist)
{
	msg->taglist=taglist;
	PutMsg(port, (struct Message *)msg);
	WaitPort(msg->msg.mn_ReplyPort);
	return (struct RecallMsg *)(GetMsg(msg->msg.mn_ReplyPort));
}

struct RecallMsg *SendMessage(struct MsgPort		*port,
															struct RecallMsg	*msg,
															Tag								tag1, ...)
{
	return SendMessageA(port, msg, (struct TagItem *)&tag1);
}

#endif
