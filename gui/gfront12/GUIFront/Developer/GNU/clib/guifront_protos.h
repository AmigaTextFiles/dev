#ifndef  CLIB_GUIFRONT_PROTOS_H
#define  CLIB_GUIFRONT_PROTOS_H

/*
** $VER: guifront_protos.h 38.1 (18.6.95)
** Includes Release 38.1
**
** C prototypes. For use with 32 bit integers only.
**
** (C) Copyright 1994-1995, Michael Berg
** All Rights Reserved
*/

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  LIBRARIES_GUIFRONT_H
#include <libraries/guifront.h>
#endif

/* Public entries */

GUIFrontApp *GF_CreateGUIAppA(char * const appid, struct TagItem * const tags);
void GF_DestroyGUIApp(GUIFrontApp * const appidhandle);
ULONG GF_GetGUIAppAttrA(GUIFrontApp * const appidhandle, struct TagItem * const tags);
ULONG GF_SetGUIAppAttrA(GUIFrontApp * const appidhandle, struct TagItem * const tags);
void GF_DestroyGUI(GUIFront * const frontgui);
GUIFront *GF_CreateGUIA(GUIFrontApp * const frontguiapp, ULONG * const layouttags,
                        GadgetSpec ** const gadgetlist, struct TagItem * const ctrltags);
ULONG GF_GetGUIAttrA(GUIFront * const frontgui, struct TagItem * const tags);
ULONG GF_SetGUIAttrA(GUIFront * const frontgui, struct TagItem * const tags);
struct IntuiMessage *GF_GetIMsg(GUIFrontApp * const appidhandle);
ULONG GF_Wait(GUIFrontApp * const appidhandle, ULONG const othersignals);
void GF_ReplyIMsg(struct IntuiMessage * const intuimessage);
BOOL GF_SetAliasKey(GUIFront * const frontgui, UBYTE const rawkey, UWORD const gadgetid);
void GF_BeginRefresh(GUIFront * const frontgui);
void GF_EndRefresh(GUIFront * const frontgui, const BOOL all);
void GF_SetGadgetAttrsA(GUIFront * const frontgui, struct Gadget * const gadget,
                        struct TagItem * const tags);
ULONG GF_GetGadgetAttrsA(GUIFront * const frontgui, struct Gadget * const gadget,
                         struct TagItem * const tags);
void GF_LockGUI(GUIFront * const frontgui);
void GF_UnlockGUI(GUIFront * const frontgui);
void GF_LockGUIApp(GUIFrontApp * const frontguiapp);
void GF_UnlockGUIApp(GUIFrontApp * const frontguiapp);

BOOL GF_LoadPrefs(char * const filename);
BOOL GF_SavePrefs(char * const filename);
void GF_LockPrefsList(void);
void GF_UnlockPrefsList(void);
PrefsHandle *GF_FirstPrefsNode(void);
PrefsHandle *GF_NextPrefsNode(PrefsHandle * const prefshandle);
void GF_CopyAppID(PrefsHandle * const prefshandle, char * const dest);
GF_GetPrefsAttrA(char * const appid, struct TagItem * const taglist);
GF_SetPrefsAttrA(char * const appid, struct TagItem * const taglist);
BOOL GF_DeletePrefs(char * const appid);
BOOL GF_DefaultPrefs(char * const appid);
BOOL GF_NotifyPrefsChange(struct Task * const task, const ULONG signals);
void GF_EndNotifyPrefsChange(struct Task * const task);
BOOL GF_AslRequest(APTR const requester, struct TagItem * const tags);
long GF_EasyRequestArgs(GUIFrontApp * const app,struct Window * const window,
                        struct EasyStruct * const easystruct,ULONG * const idcmpptr, APTR const arglist);
BOOL GF_ProcessListView(GUIFront * const gui, GadgetSpec * const gadgetspec,
                        struct IntuiMessage * const imsg, UWORD * const ordinal);
/* New in 37.3 */
void GF_SignalPrefsVChange(char * const appid);
/* New in 38.1 */
ULONG GF_GetPubScreenAttrA(char * const pubname, struct TagItem * const tags);
ULONG GF_SetPubScreenAttrA(char * const pubname, struct TagItem * const tags);

/* Varargs prototypes */

GUIFrontApp *GF_CreateGUIApp(char * const appid, ...);
ULONG GF_GetGUIAppAttr(GUIFrontApp * const guiapp, ...);
ULONG GF_SetGUIAppAttr(GUIFrontApp * const guiapp, ...);
GUIFront *GF_CreateGUI(GUIFrontApp * const guiapp, ULONG * const layoutlist,
                       GadgetSpec ** const gspecs, ...);
ULONG GF_GetGUIAttr(GUIFront * const gui, ...);
ULONG GF_SetGUIAttr(GUIFront * const gui, ...);
void GF_SetGadgetAttrs(GUIFront * const gui, struct Gadget * const gad, ...);
ULONG GF_GetGadgetAttrs(GUIFront * const gui, struct Gadget * const gad, ...);
GF_GetPrefsAttr(char * const appid, ...);
GF_SetPrefsAttr(char * const appid, ...);
BOOL GF_AslRequestTags(APTR const requester, ...);
long GF_EasyRequest(GUIFrontApp * const guiapp,struct Window * const window,
                    struct EasyStruct * const easystruct,ULONG * const idcmpptr, ...);
/* New in 38.1 */
ULONG GF_GetPubScreenAttr(char * const pubname, ...);
ULONG GF_SetPubScreenAttr(char * const pubname, ...);

#endif /* CLIB_GUIFRONT_PROTOS_H */
