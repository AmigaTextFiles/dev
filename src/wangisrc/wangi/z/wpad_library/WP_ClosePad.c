/***************************************************************************
 * WP_ClosePad.c
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * WP_ClosePad()
 */

#include "wpad_global.h"

/****** wpad.library/WP_ClosePadA ******************************************
*
*   NAME   
*
*   SYNOPSIS
*
*   FUNCTION
*
*   INPUTS
*
*   RESULT
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
*****************************************************************************
*
*/

VOID LIBENT WP_ClosePadA( REG(a0) struct Pad *pad, REG(a1) struct TagItem *tags )
{
	if( pad )
	{
		struct MsgPort *port;

		/* Open message port */
		if( port = CreateMsgPort() )
		{
			struct WPMsg *msg;
			if( msg = AllocVec(sizeof(struct WPMsg), MEMF_CLEAR) )
			{
				msg->wpm_Node.ln_Type = NT_MESSAGE;
				msg->wpm_Length = sizeof(struct WPMsg);
				msg->wpm_ReplyPort = port;
				msg->wpm_Action = WPM_ACTION_DIE;
				msg->wpm_Data = NULL;
				PutMsg(pad->pad_MsgPort, msg);
				WaitPort(port);
				GetMsg(port);
				FreeVec(msg);
				/* The thread should now be terminated... */
			}
			DeleteMsgPort(port);
		}
	}
}
