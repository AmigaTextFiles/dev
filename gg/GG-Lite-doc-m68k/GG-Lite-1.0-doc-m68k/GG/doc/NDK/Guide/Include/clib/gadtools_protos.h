@DATABASE "gg:doc/NDK/Guide/Include/clib/gadtools_protos.h"
@MASTER   "gg:os-include/clib/gadtools_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:42
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/gadtools_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/gadtools_protos.h" LINK File}

@ENDNODE
@NODE File "clib/gadtools_protos.h"
#ifndef  CLIB_GADTOOLS_PROTOS_H
#define  CLIB_GADTOOLS_PROTOS_H

/*
**      $VER: gadtools_protos.h 40.1 (17.5.1996)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
#ifndef  LIBRARIES_GADTOOLS_H
#include <@{"libraries/gadtools.h" LINK "gg:doc/NDK/Guide/Include/libraries/gadtools.h/File"}>
#endif

/*--- functions in V36 or higher (Release 2.0) ---*/

/* Gadget Functions */

@{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *CreateGadgetA( ULONG kind, struct Gadget *gad, CONST struct NewGadget *ng, CONST struct TagItem *taglist );
@{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *CreateGadget( ULONG kind, struct Gadget *gad, CONST struct NewGadget *ng, Tag tag1, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeGadgets" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 38}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gad );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GT_SetGadgetAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 42}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gad, struct Window *win, struct Requester *req, CONST struct TagItem *taglist );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GT_SetGadgetAttrs" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 47}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gad, struct Window *win, struct Requester *req, Tag tag1, ... );

/* Menu functions */

@{"struct Menu" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 60} *CreateMenusA( CONST struct NewMenu *newmenu, CONST struct TagItem *taglist );
@{"struct Menu" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 60} *CreateMenus( CONST struct NewMenu *newmenu, Tag tag1, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeMenus" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 60}( @{"struct Menu" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 60} *menu );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"LayoutMenuItemsA" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 64}( @{"struct MenuItem" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 88} *firstitem, APTR vi, CONST struct TagItem *taglist );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"LayoutMenuItems" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 69}( @{"struct MenuItem" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 88} *firstitem, APTR vi, Tag tag1, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"LayoutMenusA" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 73}( @{"struct Menu" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 60} *firstmenu, APTR vi, CONST struct TagItem *taglist );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"LayoutMenus" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 78}( @{"struct Menu" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 60} *firstmenu, APTR vi, Tag tag1, ... );

/* Misc Event-Handling Functions */

@{"struct IntuiMessage" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 763} *GT_GetIMsg( struct MsgPort *iport );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GT_ReplyIMsg" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 86}( @{"struct IntuiMessage" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 763} *imsg );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GT_RefreshWindow" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 90}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *win, struct Requester *req );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GT_BeginRefresh" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 94}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *win );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GT_EndRefresh" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 98}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *win, LONG complete );
@{"struct IntuiMessage" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 763} *GT_FilterIMsg( CONST struct IntuiMessage *imsg );
@{"struct IntuiMessage" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 763} *GT_PostFilterIMsg( struct IntuiMessage *imsg );
@{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *CreateContext( struct Gadget **glistptr );

/* Rendering Functions */

@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DrawBevelBoxA" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 114}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rport, LONG left, LONG top, LONG width, LONG height, CONST struct TagItem *taglist );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DrawBevelBox" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 119}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rport, LONG left, LONG top, LONG width, LONG height, Tag tag1, ... );

/* Visuals Functions */

@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"GetVisualInfoA" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 123}( @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen, CONST struct TagItem *taglist );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"GetVisualInfo" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 128}( @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen, Tag tag1, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeVisualInfo" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 132}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} vi );

/*--- functions in V39 or higher (Release 3) ---*/

@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"GT_GetGadgetAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 136}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gad, struct Window *win, struct Requester *req, CONST struct TagItem *taglist );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"GT_GetGadgetAttrs" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File" 141}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gad, struct Window *win, struct Requester *req, Tag tag1, ... );


#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_GADTOOLS_PROTOS_H */
@ENDNODE
