@DATABASE "gg:doc/NDK/Guide/Include/clib/intuition_protos.h"
@MASTER   "gg:os-include/clib/intuition_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:49
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/intuition_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/intuition_protos.h" LINK File}

@ENDNODE
@NODE File "clib/intuition_protos.h"
#ifndef  CLIB_INTUITION_PROTOS_H
#define  CLIB_INTUITION_PROTOS_H

/*
**      $VER: intuition_protos.h 40.1 (17.5.1996)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif
#ifndef  INTUITION_CLASSES_H
#include <@{"intuition/classes.h" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File"}>
#endif
#ifndef  INTUITION_CGHOOKS_H
#include <@{"intuition/cghooks.h" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File"}>
#endif
#ifndef  INTUITION_CLASSUSR_H
#include <@{"intuition/classusr.h" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File"}>
#endif
/* Public functions @{"OpenIntuition" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 29}() and Intuition() are intentionally */
/* not documented. */
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"OpenIntuition" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 29}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Intuition" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 33}( @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *iEvent );
@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} @{"AddGadget" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 37}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, struct Gadget *gadget, ULONG position );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"ClearDMRequest" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 41}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ClearMenuStrip" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 45}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ClearPointer" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 49}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"CloseScreen" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 53}( @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CloseWindow" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 57}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"CloseWorkBench" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 61}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CurrentTime" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 65}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *seconds, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *micros );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"DisplayAlert" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 69}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} alertNumber, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} height );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DisplayBeep" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 73}( @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"DoubleClick" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 77}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} sSeconds, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} sMicros, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} cSeconds, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} cMicros );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DrawBorder" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 81}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, CONST struct Border *border, LONG leftOffset, LONG topOffset );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DrawImage" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 85}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, struct Image *image, LONG leftOffset, LONG topOffset );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"EndRequest" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 89}( @{"struct Requester" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 144} *requester, struct Window *window );
@{"struct Preferences" LINK "gg:doc/NDK/Guide/Include/intuition/preferences.h/File" 58} *GetDefPrefs( struct Preferences *preferences, LONG size );
@{"struct Preferences" LINK "gg:doc/NDK/Guide/Include/intuition/preferences.h/File" 58} *GetPrefs( struct Preferences *preferences, LONG size );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InitRequester" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 101}( @{"struct Requester" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 144} *requester );
@{"struct MenuItem" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 88} *ItemAddress( CONST struct Menu *menuStrip, ULONG menuNumber );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"ModifyIDCMP" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 109}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, ULONG flags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ModifyProp" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 113}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadget, struct Window *window, struct Requester *requester, ULONG flags, ULONG horizPot, ULONG vertPot, ULONG horizBody, ULONG vertBody );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"MoveScreen" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 117}( @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen, LONG dx, LONG dy );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"MoveWindow" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 121}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, LONG dx, LONG dy );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"OffGadget" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 125}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadget, struct Window *window, struct Requester *requester );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"OffMenu" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 129}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, ULONG menuNumber );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"OnGadget" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 133}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadget, struct Window *window, struct Requester *requester );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"OnMenu" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 137}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, ULONG menuNumber );
@{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *OpenScreen( CONST struct NewScreen *newScreen );
@{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *OpenWindow( CONST struct NewWindow *newWindow );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"OpenWorkBench" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 149}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"PrintIText" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 153}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, CONST struct IntuiText *iText, LONG left, LONG top );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RefreshGadgets" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 157}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadgets, struct Window *window, struct Requester *requester );
@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} @{"RemoveGadget" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 161}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, struct Gadget *gadget );
/* The official calling sequence for @{"ReportMouse" LINK "gg:doc/NDK/Guide/intuition/ReportMouse"} is given below. */
/* Note the register order.  For the complete story, read the @{"ReportMouse" LINK "gg:doc/NDK/Guide/intuition/ReportMouse"} */
/* autodoc. */
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ReportMouse" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 165}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} flag, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ReportMouse1" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 169}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, LONG flag );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"Request" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 171}( @{"struct Requester" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 144} *requester, struct Window *window );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ScreenToBack" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 175}( @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ScreenToFront" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 179}( @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SetDMRequest" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 183}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, struct Requester *requester );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SetMenuStrip" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 187}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, struct Menu *menu );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetPointer" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 191}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, UWORD *pointer, LONG height, LONG width, LONG xOffset, LONG yOffset );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetWindowTitles" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 195}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, CONST_STRPTR windowTitle, CONST_STRPTR screenTitle );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ShowTitle" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 199}( @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen, LONG showIt );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SizeWindow" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 203}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, LONG dx, LONG dy );
@{"struct View" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 64} *ViewAddress( VOID );
@{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *ViewPortAddress( CONST struct Window *window );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"WindowToBack" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 215}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"WindowToFront" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 219}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"WindowLimits" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 223}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, LONG widthMin, LONG heightMin, ULONG widthMax, ULONG heightMax );
/*--- start of next generation of names -------------------------------------*/
@{"struct Preferences" LINK "gg:doc/NDK/Guide/Include/intuition/preferences.h/File" 58} *SetPrefs( CONST struct Preferences *preferences, LONG size, LONG inform );
/*--- start of next next generation of names --------------------------------*/
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"IntuiTextLength" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 231}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct IntuiText" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 656} *iText );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"WBenchToBack" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 235}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"WBenchToFront" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 239}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
/*--- start of next next next generation of names ---------------------------*/
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AutoRequest" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 243}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, CONST struct IntuiText *body, CONST struct IntuiText *posText, CONST struct IntuiText *negText, ULONG pFlag, ULONG nFlag, ULONG width, ULONG height );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"BeginRefresh" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 247}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window );
@{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *BuildSysRequest( struct Window *window, CONST struct IntuiText *body, CONST struct IntuiText *posText, CONST struct IntuiText *negText, ULONG flags, ULONG width, ULONG height );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"EndRefresh" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 255}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, LONG complete );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeSysRequest" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 259}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window );
/* The return codes for @{"MakeScreen()" LINK "gg:doc/NDK/Guide/intuition/MakeScreen"}, @{"RemakeDisplay()" LINK "gg:doc/NDK/Guide/intuition/RemakeDisplay"}, and @{"RethinkDisplay()" LINK "gg:doc/NDK/Guide/intuition/RethinkDisplay"} */
/* are only valid under V39 and greater.  Do not examine them when running */
/* on pre-V39 systems! */
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"MakeScreen" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 263}( @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"RemakeDisplay" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 267}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"RethinkDisplay" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 271}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
/*--- start of next next next next generation of names ----------------------*/
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AllocRemember" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 275}( @{"struct Remember" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1430} **rememberKey, ULONG size, ULONG flags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeRemember" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 279}( @{"struct Remember" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1430} **rememberKey, LONG reallyForget );
/*--- start of 15 Nov 85 names ------------------------*/
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"LockIBase" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 283}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} dontknow );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"UnlockIBase" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 287}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ibLock );
/*--- functions in V33 or higher (Release 1.2) ---*/
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"GetScreenData" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 291}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} buffer, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} size, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} type, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RefreshGList" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 295}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadgets, struct Window *window, struct Requester *requester, LONG numGad );
@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} @{"AddGList" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 299}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, struct Gadget *gadget, ULONG position, LONG numGad, struct Requester *requester );
@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} @{"RemoveGList" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 303}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *remPtr, struct Gadget *gadget, LONG numGad );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ActivateWindow" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 307}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RefreshWindowFrame" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 311}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"ActivateGadget" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 315}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadgets, struct Window *window, struct Requester *requester );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"NewModifyProp" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 319}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadget, struct Window *window, struct Requester *requester, ULONG flags, ULONG horizPot, ULONG vertPot, ULONG horizBody, ULONG vertBody, LONG numGad );
/*--- functions in V36 or higher (Release 2.0) ---*/
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"QueryOverscan" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 323}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} displayID, @{"struct Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27} *rect, LONG oScanType );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"MoveWindowInFrontOf" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 327}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, struct Window *behindWindow );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ChangeWindowBox" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 331}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, LONG left, LONG top, LONG width, LONG height );
@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *SetEditHook( struct Hook *hook );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetMouseQueue" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 339}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, ULONG queueLength );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ZipWindow" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 343}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window );
/*--- public screens ---*/
@{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *LockPubScreen( CONST_STRPTR name );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"UnlockPubScreen" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 351}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen );
@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *LockPubScreenList( VOID );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"UnlockPubScreenList" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 359}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"NextPubScreen" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 363}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen, STRPTR namebuf );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetDefaultPubScreen" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 367}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name );
@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} @{"SetPubScreenModes" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 371}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} modes );
@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} @{"PubScreenStatus" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 375}( @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen, ULONG statusFlags );

@{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *ObtainGIRPort( struct GadgetInfo *gInfo );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ReleaseGIRPort" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 383}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GadgetMouse" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 387}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadget, struct GadgetInfo *gInfo, WORD *mousePoint );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GetDefaultPubScreen" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 391}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} nameBuffer );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"EasyRequestArgs" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 395}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, CONST struct EasyStruct *easyStruct, ULONG *idcmpPtr, CONST APTR args );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"EasyRequest" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 400}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, CONST struct EasyStruct *easyStruct, ULONG *idcmpPtr, ... );
@{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *BuildEasyRequestArgs( struct Window *window, CONST struct EasyStruct *easyStruct, ULONG idcmp, CONST APTR args );
@{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *BuildEasyRequest( struct Window *window, CONST struct EasyStruct *easyStruct, ULONG idcmp, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SysReqHandler" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 413}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, ULONG *idcmpPtr, LONG waitInput );
@{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *OpenWindowTagList( CONST struct NewWindow *newWindow, CONST struct TagItem *tagList );
@{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *OpenWindowTags( CONST struct NewWindow *newWindow, ULONG tag1Type, ... );
@{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *OpenScreenTagList( CONST struct NewScreen *newScreen, CONST struct TagItem *tagList );
@{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *OpenScreenTags( CONST struct NewScreen *newScreen, ULONG tag1Type, ... );

/*      new Image functions */
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DrawImageState" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 435}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, struct Image *image, LONG leftOffset, LONG topOffset, ULONG state, CONST struct DrawInfo *drawInfo );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"PointInImage" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 439}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} point, @{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *image );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"EraseImage" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 443}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, struct Image *image, LONG leftOffset, LONG topOffset );

@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"NewObjectA" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 447}( @{"struct IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *classPtr, CONST_STRPTR classID, CONST struct TagItem *tagList );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} NewObject( @{"struct IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *classPtr, CONST_STRPTR classID, ULONG tag1, ... );

@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DisposeObject" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 464}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} object );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 468}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} object, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tagList );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetAttrs" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 473}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} object, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} tag1, ... );

@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetAttr" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 477}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} attrID, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} object, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *storagePtr );

/*      special set attribute call for gadgets */
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetGadgetAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 481}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadget, struct Window *window, struct Requester *requester, CONST struct TagItem *tagList );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetGadgetAttrs" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 486}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gadget, struct Window *window, struct Requester *requester, ULONG tag1, ... );

/*      for class implementors only */
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"NextObject" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 490}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} objectPtrPtr );
@{"struct IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *MakeClass( CONST_STRPTR classID, CONST_STRPTR superClassID, CONST struct IClass *superClassPtr, ULONG instanceSize, ULONG flags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddClass" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 498}( @{"struct IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *classPtr );


@{"struct DrawInfo" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 66} *GetScreenDrawInfo( struct Screen *screen );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeScreenDrawInfo" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 506}( @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen, struct DrawInfo *drawInfo );

@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"ResetMenuStrip" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 510}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *window, struct Menu *menu );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemoveClass" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 514}( @{"struct IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *classPtr );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"FreeClass" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 518}( @{"struct IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *classPtr );
/*--- functions in V39 or higher (Release 3) ---*/
@{"struct ScreenBuffer" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 645} *AllocScreenBuffer( struct Screen *sc, struct BitMap *bm, ULONG flags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeScreenBuffer" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 526}( @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *sc, struct ScreenBuffer *sb );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ChangeScreenBuffer" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 530}( @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *sc, struct ScreenBuffer *sb );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ScreenDepth" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 534}( @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen, ULONG flags, APTR reserved );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ScreenPosition" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 538}( @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen, ULONG flags, LONG x1, LONG y1, LONG x2, LONG y2 );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ScrollWindowRaster" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 542}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *win, LONG dx, LONG dy, LONG xMin, LONG yMin, LONG xMax, LONG yMax );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"LendMenus" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 546}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *fromwindow, struct Window *towindow );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"DoGadgetMethodA" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 550}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gad, struct Window *win, struct Requester *req, Msg message );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"DoGadgetMethod" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 555}( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *gad, struct Window *win, struct Requester *req, ULONG methodID, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetWindowPointerA" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 559}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *win, CONST struct TagItem *taglist );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetWindowPointer" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 564}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *win, ULONG tag1, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"TimedDisplayAlert" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 568}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} alertNumber, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} height, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} time );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"HelpControl" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File" 572}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *win, ULONG flags );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_INTUITION_PROTOS_H */
@ENDNODE
