#ifndef  CLIB_GUIFRONT_PROTOS_H
#define  CLIB_GUIFRONT_PROTOS_H

/*
** $VER: guifront_protos.h 37.3 (29.10.94)
** Includes Release 37.3
**
** C prototypes. For use with 32 bit integers only.
**
** (C) Copyright 1994, Michael Berg
** All Rights Reserved
*/

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  LIBRARIES_GUIFRONT_H
#include <libraries/guifront.h>
#endif

/* Public entries */

GUIFrontApp *GF_CreateGUIAppA(char * const, struct TagItem * const);
void GF_DestroyGUIApp(GUIFrontApp * const);
ULONG GF_GetGUIAppAttrA(GUIFrontApp * const, struct TagItem * const);
ULONG GF_SetGUIAppAttrA(GUIFrontApp * const, struct TagItem * const);
void GF_DestroyGUI(GUIFront * const);
GUIFront *GF_CreateGUIA(GUIFrontApp * const, ULONG * const, GadgetSpec ** const, struct TagItem * const);
ULONG GF_GetGUIAttrA(GUIFront * const, struct TagItem * const);
ULONG GF_SetGUIAttrA(GUIFront * const, struct TagItem * const);
struct IntuiMessage *GF_GetIMsg(GUIFrontApp * const);
ULONG GF_Wait(GUIFrontApp * const, ULONG const);
void GF_ReplyIMsg(struct IntuiMessage * const);
BOOL GF_SetAliasKey(GUIFront * const, UBYTE const, UWORD const);
void GF_BeginRefresh(GUIFront * const);
void GF_EndRefresh(GUIFront * const, const BOOL);
void GF_SetGadgetAttrsA(GUIFront * const, struct Gadget * const, struct TagItem * const);
ULONG GF_GetGadgetAttrsA(GUIFront * const, struct Gadget * const, struct TagItem * const);
void GF_LockGUI(GUIFront * const);
void GF_UnlockGUI(GUIFront * const);
void GF_LockGUIApp(GUIFrontApp * const);
void GF_UnlockGUIApp(GUIFrontApp * const);

BOOL GF_LoadPrefs(char * const);
BOOL GF_SavePrefs(char * const);
void GF_LockPrefsList(void);
void GF_UnlockPrefsList(void);
PrefsHandle *GF_FirstPrefsNode(void);
PrefsHandle *GF_NextPrefsNode(PrefsHandle * const);
void GF_CopyAppID(PrefsHandle * const, char * const);
GF_GetPrefsAttrA(char * const, struct TagItem * const);
GF_SetPrefsAttrA(char * const, struct TagItem * const);
BOOL GF_DeletePrefs(char * const);
BOOL GF_DefaultPrefs(char * const);
BOOL GF_NotifyPrefsChange(struct Task * const, const ULONG);
void GF_EndNotifyPrefsChange(struct Task * const);
BOOL GF_AslRequest(APTR const, struct TagItem * const);
long GF_EasyRequestArgs(GUIFrontApp * const,struct Window * const,struct EasyStruct * const,ULONG * const, APTR const);
BOOL GF_ProcessListView(GUIFront * const, GadgetSpec * const, struct IntuiMessage * const, UWORD * const);
void GF_SignalPrefsVChange(char * const);

/* Varargs prototypes */

GUIFrontApp *GF_CreateGUIApp(char * const, ...);
ULONG GF_GetGUIAppAttr(GUIFrontApp * const, ...);
ULONG GF_SetGUIAppAttr(GUIFrontApp * const, ...);
GUIFront *GF_CreateGUI(GUIFrontApp * const, ULONG * const, GadgetSpec ** const, ...);
ULONG GF_GetGUIAttr(GUIFront * const, ...);
ULONG GF_SetGUIAttr(GUIFront * const, ...);
void GF_SetGadgetAttrs(GUIFront * const, struct Gadget * const, ...);
ULONG GF_GetGadgetAttrs(GUIFront * const, struct Gadget * const, ...);
GF_GetPrefsAttr(char * const, ...);
GF_SetPrefsAttr(char * const, ...);
BOOL GF_AslRequestTags(APTR const, ...);
long GF_EasyRequest(GUIFrontApp * const,struct Window * const,struct EasyStruct * const,ULONG * const, ...);

#endif /* CLIB_GUIFRONT_PROTOS_H */
