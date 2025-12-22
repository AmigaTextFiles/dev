/* $Id: ports.h 25583 2007-03-26 23:38:53Z dariusb $ */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/lists'
MODULE 'target/exec/types'
{#include <exec/ports.h>}
NATIVE {EXEC_PORTS_H} CONST

CONST MP_SOFTINT = 16

/* MsgPort */
NATIVE {MsgPort} OBJECT mp
    {mp_Node}	ln	:ln
    {mp_Flags}	flags	:UBYTE
    {mp_SigBit}	sigbit	:UBYTE  /* Signal bit number */
    {mp_SigTask}	sigtask	:PTR /* Object to be signalled */
    {mp_MsgList}	msglist	:lh /* Linked list of messages */
ENDOBJECT

NATIVE {mp_SoftInt} DEF	/* Alias */

/* mp_Flags: Port arrival actions (PutMsg) */
NATIVE {PF_ACTION}	CONST PF_ACTION	= 3	/* Mask */
NATIVE {PA_SIGNAL}	CONST PA_SIGNAL	= 0	/* Signal task in mp_SigTask */
NATIVE {PA_SOFTINT}	CONST PA_SOFTINT	= 1	/* Signal SoftInt in mp_SoftInt/mp_SigTask */
NATIVE {PA_IGNORE}	CONST PA_IGNORE	= 2	/* Ignore arrival */

/* Message */
NATIVE {Message} OBJECT mn
    {mn_Node}	ln	:ln
    {mn_ReplyPort}	replyport	:PTR TO mp  /* message reply port */
    {mn_Length}	length	:UINT     /* total message length, in bytes */
				    /* (include the size of the Message
				       structure in the length) */
ENDOBJECT

NATIVE {MagicMessage} OBJECT magicmessage
    {mn_Node}	node	:ln
    {mn_ReplyPort}	replyport	:PTR TO mp  /* message reply port */
    {mn_Length}	length	:UINT     /* total message length, in bytes */
                    /* (include the size of the Message
                       structure in the length) */
    {mn_Magic}	magic	:ULONG       /* can be used to figure out the message sender */
    {mn_Version}	version	:ULONG     /* version can be used to extend a message in later versions */
ENDOBJECT

/* definition for entry Magic in Messages
   Magic is introduced to prevent Multiple Ports, for example if you´r using
   ScreenNotifications and DecorNotifications you must have two Ports as long
   as you cannot figure out which Messsage ist posted. With Magic this is no
   problem. */

NATIVE {MAGIC_DECORATOR}       CONST MAGIC_DECORATOR       = $8000001
NATIVE {MAGIC_SCREENNOTIFY}    CONST MAGIC_SCREENNOTIFY    = $8000002
