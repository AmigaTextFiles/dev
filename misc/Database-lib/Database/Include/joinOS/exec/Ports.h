/* Ports.h
 *
 * Functions and structures needed for Exex-alike interprocess-communication.
 */

#ifndef _PORTS_H_
#define _PORTS_H_ 1

#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifdef _AMIGA

#include <exec/ports.h>

#else

#ifndef _LISTS_H_
#include <joinOS/exec/Lists.h>
#endif

#ifndef _TASKS_H_
#include <joinOS/exec/Tasks.h>
#endif

/* --- Structures for Exec-Messagesystem ------------------------------------ */

/* Message port structure.
 * This is the equivalent to the AmigaOS Exec messageports. This structure is
 * used to handle messages and requests, to do interprocess communication
 * between any task (processes or devices or threads) under Windoof.
 */
struct MsgPort
{
	struct Node mp_Node; /* a standard node structure, useful for tasks that
								 * might want to redezvous with a particular message
								 * port by name */
	UBYTE mp_Flags;		/* are used to indicate message arrival actions
								 * must be set to PA_SIGNAL, or PA_IGNORE, other flags
								 * are not supported */
	UBYTE mp_SigBit;		/* the signal bit number, used for task signalisation */
	struct Task *mp_SigTask;	/* the task that should be signalized */
	struct List mp_MsgList;		/* is the list header for all messages queued to
										 * this port. */
};

#define mp_SoftInt mp_SigTask		/* Alias */

/* mp_Flags: Port arrival actions (PutMsg()).
 */
#define PF_ACTION		3	/* Mask */
#define PA_SIGNAL		0	/* Signal task in mp_SigTask */
#define PA_SOFTINT	1	/* Signal SoftInt in mp_SoftInt/mp_SigTask */
#define PA_IGNORE		2	/* Ignore arrival */

/* Message structure.
 * A message contains both, system header information and the actual message
 * content. The system header of the Message structure is defined as follows:
 */
struct Message
{
	struct Node mn_Node;
	struct MsgPort *mn_ReplyPort;
	UWORD mn_Length;
};
/* If you want to send a message, allocate memory for the Message structure
 * and the message itself in a single step using AllocMem(,MEMF_PUBLIC), then
 * set the mn_ReplyPort to your own message port (previously allocated using
 * CreatePort() or CreateMsgPort()) and the length field of the structure to
 * the byte size of the whole structure. Send the message to the desired
 * message port using PutMsg().
 *
 * EXAMPLE: Send the text "Hello World" to the message port "Foo".
 *
 *	struct MsgPort *replyport, *destination;
 *	struct Message *msg;
 *	ULONG Size;
 *
 *	// Calculate the size of the message:
 *	size = sizeof (struct Message) + strlen ("Hello World") + 1;
 *
 *	if (msg = (struct Message *)AllocMem (size, MEMF_PUBLIC))
 *	{
 *		if (replyport = CreateMsgPort ())
 *		{
 *			msg->mn_Node.ln_Type = NT_MESSAGE;
 *			msg->mn_Length = size;
 *			msg->mn_ReplyPort = replyport;
 *			strcpy (((char*)msg) + sizeof(struct Message), "Hello World");
 *
 *			// Now try to sen the message to a public port called "Foo"
 *			Forbid();
 *			if (destination = FindPort("Foo")) PutMsg (destination, msg);
 *			Permit();
 *
 *			if (destination)
 *			{
 *				printf ("Message is send...\n");
 *				// Now let's wait till the otherone responds...
 *				WaitPort (replyport);
 *				printf ("Otherone has replied.\n");
 *			}
 *			else printf ("Couldn't find message port \"Foo\".\n");
 *
 *			// Clean up
 *			DeleteMsgPort (replyport);
 *		}
 *		else printf ("Could not create message port.\n");
 *
 *		FreeMem (msg, size);
 * }
 *	else printf ("Could not get memory for message.\n");
 */

#endif		/* _AMIGA */

#endif		/* _PORTS_H_ */
