#ifndef _INLINE_WIZARD_H
#define _INLINE_WIZARD_H

#ifndef CLIB_WIZARD_PROTOS_H
#define CLIB_WIZARD_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif
#ifndef  LIBRARIES_WIZARD_H
#include <libraries/wizard.h>
#endif
//#ifndef  PRAGMA_WIZARD_LIB_H
//#include <pragma/wizard_lib.h>
//#endif

#ifndef WIZARD_BASE_NAME
#define WIZARD_BASE_NAME WizardBase
#endif

#define WZ_OpenSurfaceA(name, memaddr, tagptr) \
	LP3(0x1e, APTR, WZ_OpenSurfaceA, STRPTR, name, a0, APTR, memaddr, a1, struct TagItem *, tagptr, a2, \
	, WIZARD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define WZ_OpenSurface(name, memaddr, tags...) \
	({ULONG _tags[] = {tags}; WZ_OpenSurfaceA((name), (memaddr), (struct TagItem *) _tags);})
#endif

#define WZ_CloseSurface(surface) \
	LP1NR(0x24, WZ_CloseSurface, APTR, surface, a0, \
	, WIZARD_BASE_NAME)

#define WZ_AllocWindowHandleA(screen, user_sizeof, surface, tagptr) \
	LP4(0x2a, struct WizardWindowHandle *, WZ_AllocWindowHandleA, struct Screen *, screen, d0, ULONG, user_sizeof, d1, APTR, surface, a0, struct TagItem *, tagptr, a1, \
	, WIZARD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define WZ_AllocWindowHandle(screen, user_sizeof, surface, tags...) \
	({ULONG _tags[] = {tags}; WZ_AllocWindowHandleA((screen), (user_sizeof), (surface), (struct TagItem *) _tags);})
#endif

#define WZ_CreateWindowObjA(winhandle, id, tagptr) \
	LP3(0x30, struct NewWindow *, WZ_CreateWindowObjA, struct WizardWindowHandle *, winhandle, a0, ULONG, id, d0, struct TagItem *, tagptr, a1, \
	, WIZARD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define WZ_CreateWindowObj(winhandle, id, tags...) \
	({ULONG _tags[] = {tags}; WZ_CreateWindowObjA((winhandle), (id), (struct TagItem *) _tags);})
#endif

#define WZ_OpenWindowA(winhandle, newwin, tagptr) \
	LP3(0x36, struct Window *, WZ_OpenWindowA, struct WizardWindowHandle *, winhandle, a0, struct NewWindow *, newwin, a1, struct TagItem *, tagptr, a2, \
	, WIZARD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define WZ_OpenWindow(winhandle, newwin, tags...) \
	({ULONG _tags[] = {tags}; WZ_OpenWindowA((winhandle), (newwin), (struct TagItem *) _tags);})
#endif

#define WZ_CloseWindow(winhandle) \
	LP1NR(0x3c, WZ_CloseWindow, struct WizardWindowHandle *, winhandle, a0, \
	, WIZARD_BASE_NAME)

#define WZ_FreeWindowHandle(winhandle) \
	LP1NR(0x42, WZ_FreeWindowHandle, struct WizardWindowHandle *, winhandle, a0, \
	, WIZARD_BASE_NAME)

#define WZ_LockWindow(winhandle) \
	LP1NR(0x48, WZ_LockWindow, struct WizardWindowHandle *, winhandle, a0, \
	, WIZARD_BASE_NAME)

#define WZ_UnlockWindow(winhandle) \
	LP1(0x4e, ULONG, WZ_UnlockWindow, struct WizardWindowHandle *, winhandle, a0, \
	, WIZARD_BASE_NAME)

#define WZ_LockWindows(surface) \
	LP1NR(0x54, WZ_LockWindows, APTR, surface, a0, \
	, WIZARD_BASE_NAME)

#define WZ_UnlockWindows(surface) \
	LP1NR(0x5a, WZ_UnlockWindows, APTR, surface, a0, \
	, WIZARD_BASE_NAME)

#define WZ_GadgetHelp(windowhandle, sfgadget) \
	LP2(0x60, STRPTR, WZ_GadgetHelp, struct WizardWindowHandle *, windowhandle, a0, APTR, sfgadget, a1, \
	, WIZARD_BASE_NAME)

#define WZ_GadgetConfig(windowhandle, sfgadget) \
	LP2(0x66, STRPTR, WZ_GadgetConfig, struct WizardWindowHandle *, windowhandle, a0, struct Gadget *, sfgadget, a1, \
	, WIZARD_BASE_NAME)

#define WZ_MenuHelp(windowhandle, menucode) \
	LP2(0x6c, STRPTR, WZ_MenuHelp, struct WizardWindowHandle *, windowhandle, a0, ULONG, menucode, d0, \
	, WIZARD_BASE_NAME)

#define WZ_MenuConfig(windowhandle, menucode) \
	LP2(0x72, STRPTR, WZ_MenuConfig, struct WizardWindowHandle *, windowhandle, a0, ULONG, menucode, d0, \
	, WIZARD_BASE_NAME)

#define WZ_InitEasyStruct(surface, easystruct, id, size) \
	LP4(0x78, struct EasyStruct *, WZ_InitEasyStruct, APTR, surface, a0, struct EasyStruct *, easystruct, a1, ULONG, id, d0, ULONG, size, d1, \
	, WIZARD_BASE_NAME)

#define WZ_SnapShotA(surface, tagptr) \
	LP2(0x7e, BOOL, WZ_SnapShotA, APTR, surface, a0, struct TagItem *, tagptr, a1, \
	, WIZARD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define WZ_SnapShot(surface, tags...) \
	({ULONG _tags[] = {tags}; WZ_SnapShotA((surface), (struct TagItem *) _tags);})
#endif

#ifndef NO_INLINE_STDARG
#define WZ_GadgetKeyTags(windowhandle, code, Qualifier, tags...) \
	({ULONG _tags[] = {tags}; WZ_GadgetKey((windowhandle), (code), (Qualifier), (Tag) _tags);})
#endif

#define WZ_DrawVImageA(vimage, x, y, w, h, type, rp, drinfo, tagptr) \
	LP9(0x8a, BOOL, WZ_DrawVImageA, struct WizardVImage *, vimage, a0, WORD, x, d0, WORD, y, d1, WORD, w, d2, WORD, h, d3, WORD, type, d4, struct RastPort *, rp, d5, struct DrawInfo *, drinfo, d6, struct TagItem *, tagptr, a1, \
	, WIZARD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define WZ_DrawVImage(vimage, x, y, w, h, type, rp, drinfo, tags...) \
	({ULONG _tags[] = {tags}; WZ_DrawVImageA((vimage), (x), (y), (w), (h), (type), (rp), (drinfo), (struct TagItem *) _tags);})
#endif

#define WZ_EasyRequestArgs(surface, window, id, args) \
	LP4(0x90, LONG, WZ_EasyRequestArgs, APTR, surface, a0, struct Window *, window, a1, ULONG, id, d0, void *, args, a2, \
	, WIZARD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define WZ_EasyRequest(surface, window, id, tags...) \
	({ULONG _tags[] = {tags}; WZ_EasyRequestArgs((surface), (window), (id), (void *) _tags);})
#endif

#define WZ_GetNode(minlist, nr) \
	LP2(0x96, struct WizardNode *, WZ_GetNode, struct MinList *, minlist, a0, ULONG, nr, d0, \
	, WIZARD_BASE_NAME)

#define WZ_ListCount(list) \
	LP1(0x9c, ULONG, WZ_ListCount, struct MinList *, list, a0, \
	, WIZARD_BASE_NAME)

#define WZ_NewObjectA(surface, d0arg, tagptr) \
	LP3(0xa2, struct Gadget *, WZ_NewObjectA, APTR, surface, a1, ULONG, d0arg, d0, struct TagItem *, tagptr, a0, \
	, WIZARD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define WZ_NewObject(surface, d0arg, tags...) \
	({ULONG _tags[] = {tags}; WZ_NewObjectA((surface), (d0arg), (struct TagItem *) _tags);})
#endif

#define WZ_GadgetHelpMsg(winhandle, winhaddress, iaddress, MouseX, MouseY, flags) \
	LP6(0xa8, BOOL, WZ_GadgetHelpMsg, struct WizardWindowHandle *, winhandle, a0, struct WizardWindowHandle **, winhaddress, a1, APTR *, iaddress, a2, WORD, MouseX, d0, WORD, MouseY, d1, UWORD, flags, d2, \
	, WIZARD_BASE_NAME)

#define WZ_ObjectID(Surface, id, Objectname) \
	LP3(0xae, BOOL, WZ_ObjectID, APTR, Surface, a0, ULONG *, id, a2, STRPTR, Objectname, a1, \
	, WIZARD_BASE_NAME)

#define WZ_InitNodeA(wizardnode, entrys, tagptr) \
	LP3NR(0xb4, WZ_InitNodeA, struct WizardNode *, wizardnode, a0, ULONG, entrys, d0, struct TagItem *, tagptr, a1, \
	, WIZARD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define WZ_InitNode(wizardnode, entrys, tags...) \
	({ULONG _tags[] = {tags}; WZ_InitNodeA((wizardnode), (entrys), (struct TagItem *) _tags);})
#endif

#define WZ_InitNodeEntryA(wizardnode, entry, tagptr) \
	LP3NR(0xba, WZ_InitNodeEntryA, struct WizardNode *, wizardnode, a0, ULONG, entry, d0, struct TagItem *, tagptr, a1, \
	, WIZARD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define WZ_InitNodeEntry(wizardnode, entry, tags...) \
	({ULONG _tags[] = {tags}; WZ_InitNodeEntryA((wizardnode), (entry), (struct TagItem *) _tags);})
#endif

#define WZ_CreateImageBitMap(TransPen, DrInfo, newimage, screen, reg) \
	LP5(0xc0, struct BitMap *, WZ_CreateImageBitMap, UWORD, TransPen, d0, struct DrawInfo *, DrInfo, a0, struct WizardNewImage *, newimage, a1, struct Screen *, screen, a2, UBYTE *, reg, a3, \
	, WIZARD_BASE_NAME)

#define WZ_DeleteImageBitMap(bm, newimage, screen, reg) \
	LP4NR(0xc6, WZ_DeleteImageBitMap, struct BitMap *, bm, a0, struct WizardNewImage *, newimage, a1, struct Screen *, screen, a2, UBYTE *, reg, a3, \
	, WIZARD_BASE_NAME)

#define WZ_GetDataAddress(surface, Type, ID) \
	LP3(0xcc, APTR, WZ_GetDataAddress, APTR, surface, a0, ULONG, Type, d0, ULONG, ID, d1, \
	, WIZARD_BASE_NAME)

#define WZ_GadgetObjectname(winhandle, gad) \
	LP2(0xd2, STRPTR, WZ_GadgetObjectname, struct WizardWindowHandle *, winhandle, a0, struct Gadget *, gad, a1, \
	, WIZARD_BASE_NAME)

#define WZ_MenuObjectname(winhandle, code) \
	LP2(0xd8, STRPTR, WZ_MenuObjectname, struct WizardWindowHandle *, winhandle, a0, ULONG, code, d0, \
	, WIZARD_BASE_NAME)

#define WZ_WindowGadgets(surface, ID) \
	LP2(0xde, ULONG, WZ_WindowGadgets, APTR, surface, a0, ULONG, ID, d0, \
	, WIZARD_BASE_NAME)

#endif /*  _INLINE_WIZARD_H  */
