
#ifndef _TEK_MSG_H
#define	_TEK_MSG_H

/*
**	tek/msg.h
**
**	message IPC
*/

#include <tek/exec.h>
#include <tek/util.h>


typedef struct					/* message. strictly private */
{
	THNDL handle;				/* object handle for linking to msg queue and memory manager */
	TUINT size;					/* full size of the msg, including data */
	TUINT status;				/* delivery status */
	TPORT *replyport;			/* msgport to which msg is replied/acknowledged to */
	TAPTR sender;				/* sender object */
}	TMSG;


/* 
**	msg status.
*/

#define TMSG_STATUS_UNDEFINED		0x00		/* msg status undefined */
#define TMSG_STATUS_SENT			0x01		/* msg has been sent successfully */
#define TMSG_STATUS_FAILED			0x02		/* msg has not been delivered successfully */
#define TMSG_STATUS_REPLIED			0x03		/* msg successfully returned to the sender */
#define TMSG_STATUS_ACKD			0x04		/* msg successfully acknowledged to the sender */
#define TMSG_STATUS_PENDING			0x10		/* msg is pending in a message port queue */


/* 
**	msg tags.
**
*/

#define TMSGTAGS_					(TTAG_USER + 0x400)
#define TMsg_Size					(TTAG) (TMSGTAGS_ + 0)		/* size of a message */
#define TMsg_Status					(TTAG) (TMSGTAGS_ + 1)		/* message delivery status */
#define TMsg_Sender					(TTAG) (TMSGTAGS_ + 2)		/* message sender symbolic name */
#define TMsg_SenderHost				(TTAG) (TMSGTAGS_ + 3)		/* message sender host name */
#define TMsg_SenderPort				(TTAG) (TMSGTAGS_ + 4)		/* message sender port nr */


/* 
**	msg allocation support macros.
*/

#define TTaskAllocMsg(task,size) TMMUAlloc(((TTASK *) (task))->msgmmu, size)
#define TFreeMsg(msg) TMMUFree((((TMSG *) (msg)) - 1)->handle.mmu, msg);


/* 
**	msg accessor macros.
*/

#define TGetMsgStatus(msg)	((((TMSG *) (msg)) - 1)->status)
#define TGetMsgSize(msg)	((((TMSG *) (msg)) - 1)->size - sizeof(TMSG))


TBEGIN_C_API

extern TVOID TPutMsg(TPORT *msgport, TAPTR msg)									__ELATE_QCALL__(("qcall lib/tek/msg/putmsg"));
extern TVOID TPutReplyMsg(TPORT *msgport, TPORT *replyport, TAPTR msg)			__ELATE_QCALL__(("qcall lib/tek/msg/putreplymsg"));
extern TAPTR TGetMsg(TPORT *port)												__ELATE_QCALL__(("qcall lib/tek/msg/getmsg"));
extern TVOID TAckMsg(TAPTR msg)													__ELATE_QCALL__(("qcall lib/tek/msg/ackmsg"));
extern TVOID TReplyMsg(TAPTR msg)												__ELATE_QCALL__(("qcall lib/tek/msg/replymsg"));
extern TVOID TDropMsg(TAPTR msg)												__ELATE_QCALL__(("qcall lib/tek/msg/dropmsg"));
extern TAPTR TSendMsg(TAPTR task, TPORT *msgport, TAPTR msg)					__ELATE_QCALL__(("qcall lib/tek/msg/sendmsg"));
extern TUINT TGetMsgAttrs(TAPTR mem, TTAGITEM *tags)							__ELATE_QCALL__(("qcall lib/tek/msg/getmsgattrs"));
extern TSTRPTR TGetMsgSender(TAPTR msg)											__ELATE_QCALL__(("qcall lib/tek/msg/getmsgsender"));

TEND_C_API


#endif
