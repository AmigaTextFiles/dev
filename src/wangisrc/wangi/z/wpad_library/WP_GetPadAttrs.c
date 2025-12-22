/***************************************************************************
 * WP_GetPadAttrs.c
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * WP_GetPadAttrs()
 */

#include "wpad_global.h"

/****** wpad.library/WP_GetPadAttrsA ******************************************
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

LONG LIBENT WP_GetPadAttrsA( REG(a0) struct Pad *pad, REG(a1) struct TagItem *tags)
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
				msg->wpm_Action = WPM_ACTION_GETATTRS;
				msg->wpm_Data = tags;
				PutMsg(pad->pad_MsgPort, msg);
				WaitPort(port);
				GetMsg(port);
			}
			DeleteMsgPort(port);
		}
	}
	return( 0 );
}
