/* $VER: ports.h 39.0 (15.10.1991) */
OPT NATIVE, INLINE
MODULE 'target/exec/nodes', 'target/exec/lists'->, 'target/exec/tasks'
MODULE 'target/exec/types'
{#include <exec/ports.h>}
NATIVE {EXEC_PORTS_H} CONST

CONST MP_SOFTINT = 16

->IsMsgPortEmpty() is taken from 'exec/lists' where it can't refer to the MsgPort
PROC IsMsgPortEmpty(port:PTR TO mp) IS NATIVE {-IsMsgPortEmpty(} port {)} ENDNATIVE !!BOOL


/****** MsgPort *****************************************************/

NATIVE {MsgPort} OBJECT mp
    {mp_Node}	ln	:ln
    {mp_Flags}	flags	:UBYTE
    {mp_SigBit}	sigbit	:UBYTE		/* signal bit number	*/
    {mp_SigTask}	sigtask	:PTR		/* object to be signalled */
    {mp_MsgList}	msglist	:lh	/* message linked list	*/
ENDOBJECT

NATIVE {mp_SoftInt} DEF	/* Alias */

/* mp_Flags: Port arrival actions (PutMsg) */
NATIVE {PF_ACTION}	CONST PF_ACTION	= 3	/* Mask */
NATIVE {PA_SIGNAL}	CONST PA_SIGNAL	= 0	/* Signal task in mp_SigTask */
NATIVE {PA_SOFTINT}	CONST PA_SOFTINT	= 1	/* Signal SoftInt in mp_SoftInt/mp_SigTask */
NATIVE {PA_IGNORE}	CONST PA_IGNORE	= 2	/* Ignore arrival */


/****** Message *****************************************************/

NATIVE {Message} OBJECT mn
    {mn_Node}	ln	:ln
    {mn_ReplyPort}	replyport	:PTR TO mp  /* message reply port */
    {mn_Length}	length	:UINT		    /* total message length, in bytes */
				    /* (include the size of the Message */
				    /* structure in the length) */
ENDOBJECT
