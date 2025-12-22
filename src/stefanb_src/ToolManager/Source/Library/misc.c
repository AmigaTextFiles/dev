/*
 * misc.c  V3.1
 *
 * ToolManager library miscellaneous routines
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

#include "toolmanager.h"

#ifdef _DCC
/* VarArgs stub for OpenWindowTagList */
struct Window *OpenWindowTags(struct NewWindow *nw, Tag tag1, ...)
{
 return(OpenWindowTagList(nw, (struct TagItem *) &tag1));
}

/* VarArgs stub for NewObjectA */
APTR NewObject(struct IClass *class, UBYTE *classID, Tag tag1, ... )
{
 return(NewObjectA(class, classID, (struct TagItem *) &tag1));
}

/* VarArgs stub for SetAttrsA */
ULONG SetAttrs(APTR obj, Tag tag1, ...)
{
 return(SetAttrsA(obj, (struct TagItem *) &tag1));
}

/* VarArgs stub for SetGadgetAttrsA */
ULONG SetGadgetAttrs(APTR obj, struct Window *w, struct Requester *r, Tag tag1,
                     ...)
{
 return(SetGadgetAttrsA(obj, w, r, (struct TagItem *) &tag1));
}
#endif

/* Reply all messages and then delete port */
void SafeDeleteMsgPort(struct MsgPort *mp)
{
 struct Message *msg;

 /* Scan message port list and reply messages */
 while (msg = GetMsg(mp)) ReplyMsg(msg);

 /* Delete message port */
 DeleteMsgPort(mp);
}

/* Include global miscellaneous code */
#include "/global_misc.c"
