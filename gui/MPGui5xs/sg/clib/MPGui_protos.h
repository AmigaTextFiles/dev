#ifndef CLIB_MPGUI_PROTOS_H
#define CLIB_MPGUI_PROTOS_H

/* MPGui - requester library */

/* mark@topic.demon.co.uk */
/* mpaddock@cix.compulink.co.uk */

/* Prototypes for MPGui.library */

/* $VER: MPGui_protos.h 5.3 (16.2.97)
 */

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif
#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif
#ifndef LIBRARIES_MPGUI_H
#include <libraries/mpgui.h>
#endif

struct MPGuiHandle *AllocMPGuiHandleA(struct TagItem * TagList);
struct MPGuiHandle *AllocMPGuiHandle(Tag tag1, ...);
void FreeMPGuiHandle(struct MPGuiHandle * );
char *MPGuiError(struct MPGuiHandle * );
char *SyncMPGuiRequest(char *,struct MPGuiHandle * );
ULONG MPGuiResponse(struct MPGuiHandle *gh);
BOOL SetMPGuiGadgetValue(struct MPGuiHandle *gh,char *Title,char *Value);
char *MPGuiCurrentAttrs(struct MPGuiHandle *gh);
BOOL ReadMPGui(char *fname,struct MPGuiHandle *gh);
BOOL WriteMPGui(char *fname,struct MPGuiHandle *gh);
void RefreshMPGui(struct MPGuiHandle *gh);
struct Window *MPGuiWindow(struct MPGuiHandle *gh);

#endif
