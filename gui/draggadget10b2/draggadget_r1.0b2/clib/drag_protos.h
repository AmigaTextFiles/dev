#ifndef CLIB_DRAG_PROTOS_H
#define CLIB_DRAG_PROTOS_H

/* $VER: drag_protos.h 40.2 (23.7.97)
*/

APTR CreateDContext(struct Screen *scr);
void DeleteDContext(APTR dcontext);
APTR AddDropWindow(APTR dcontext, ULONG id, ULONG userdata,
                   struct Window *win, struct MsgPort *port);
void RemoveDropWindow(APTR dropwin);
APTR NewDragGroup(void);
void FreeDragGroup(APTR dgroup);

#endif
