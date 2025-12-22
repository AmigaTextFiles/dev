/*
 *	File:					CloseWindowSafely.h
 *	Description:	Two functions to close windows with shared msgports safely.
 *
 *	(C) 1994, Ketil Hunn
 *
 */

#ifndef CLOSEWINDOWSAFELY_H
#define CLOSEWINDOWSAFELY_H

__asm __saveds void mrCloseWindowSafely(register __a0 struct Window *win)
{
	struct IntuiMessage	*msg=(struct IntuiMessage *)win->UserPort->mp_MsgList.lh_Head;
	struct Node					*succ;

	Forbid();
	while(succ=msg->ExecMessage.mn_Node.ln_Succ)
	{
		if(msg->IDCMPWindow==win)
		{
	    Remove((struct Node *)msg);
	    ReplyMsg((struct Message *)msg);
		}
		msg=(struct IntuiMessage *)succ;
	}
	win->UserPort=NULL;
	ModifyIDCMP(win, 0L);
	Permit();

	CloseWindow(win);
}

#endif
