/* Copyright (c) 1996 by Terje Pedersen.  All Rights Reserved   */
/*                                                              */
/* By using this code you will agree to these terms:            */
/*                                                              */
/* 1. You may not use this code for profit in any way or form   */
/*    unless an agreement with the author has been reached.     */
/*                                                              */
/* 2. The author is not responsible for any damages caused by   */
/*    the use of this code.                                     */
/*                                                              */
/* 3. All modifications are to be released to the public.       */
/*                                                              */
/* Thats it! Have fun!                                          */
/* TP                                                           */
/*                                                              */

#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>

#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <graphics/displayinfo.h>
#include <devices/timer.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/gadtools.h>
#include <proto/layers.h>

#include <dos.h>
#include <signal.h>
#include <stdlib.h>
#include <time.h>
#include <stdio.h>

#include "libX11.h"

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/IntrinsicP.h>
#include <X11/CoreP.h>

int (*XSynchronize(Display*d, Bool onoff))(Display *d,Bool onoff){
}

/*int XSynchronize(Display *d,Bool onoff){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSynchronize\n");
#endif
  return(0);
}*/

KeyCode XKeysymToKeycode(display, keysym)
     Display *display;
     KeySym keysym;
{/*        File 'xvmisc.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XKeysymToKeycode\n");
#endif
  return(0);
}

getwd(){/*                   File 'xvmisc.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: getwd\n");
#endif
  return(0);
}
/*
XUngrabServer(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XUngrabServer\n");
#endif
  return(0);
}

XTranslateCoordinates(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XTranslateCoordinates\n");
#endif
  return(0);
}
*/
umask(){/*                   File 'xvbrowse.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: umask\n");
#endif
  return(0);
}
/*
XGrabButton(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGrabButton\n");
#endif
  return(0);
}

XSetTransientForHint(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetTransientForHint\n");
#endif
  return(0);
}

XSetCloseDownMode(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetCloseDownMode\n");
#endif
  return(0);
}

XDeleteProperty(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XDeleteProperty\n");
#endif
  return(0);
}

XGrabServer(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGrabServer\n");
#endif
  return(0);
}

random(){
  return(rand());
}

TDelay(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: TDelay\n");
#endif
  return(0);
}
*/

endpwent(){/*                File 'xvdir.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: endpwent\n");
#endif
  return(0);
}
/*
XStoreBytes(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XStoreBytes\n");
#endif
  return(0);
}

XSetSubwindowMode(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetSubwindowMode\n");
#endif
  return(0);
}

srandom(n){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: srandom\n");
#endif
  srand(n);
}

XGetNormalHints(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGetNormalHints\n");
#endif
  return(0);
}

XUngrabButton(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XUngrabButton\n");
#endif
  return(0);
}
*/
mknod(){/*                   File 'xvbrowse.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: mknod\n");
#endif
  return(0);
}
/*
XKillClient(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XKillClient\n");
#endif
  return(0);
}
*/

void XtRemoveCallback(object, callback_name, callback, client_data)
     Widget object;
     _Xconst _XtString callback_name;
     XtCallbackProc callback;
     XtPointer client_data;
{/*        File 'Paint.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: _XtRemoveCallback\n");
#endif
  return(0);
}

RWGetMsg(){/*                File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: RWGetMsg\n");
#endif
  return(0);
}

void XtMoveWidget(w, x, y)
     Widget w;
     Position x;
     Position y;
{/*            File 'PaintRegion.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtMoveWidget\n");
#endif
  return(0);
}

char *XtCalloc(num, size)
Cardinal num;
Cardinal size;
{/*                File 'graphic.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtCalloc\n");
#endif
  return(0);
}

RWtableGetEntry(){/*         File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: RWtableGetEntry\n");
#endif
  return(0);
}

RWtableGetWriterList(){/*    File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: RWtableGetWriterList\n");
#endif
  return(0);
}

void XtAugmentTranslations(w, translations)
     Widget w;
     XtTranslations translations;
{/*   File 'operation.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtAugmentTranslations\n");
#endif
  return(0);
}

RWtableGetReaderID(){/*      File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: RWtableGetReaderID\n");
#endif
  return(0);
}

XawToggleSetCurrent(){/*     File 'operation.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XawToggleSetCurrent\n");
#endif
  return(0);
}

XShapeCombineMask(){/*       File 'PaintRegion.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XShapeCombineMask\n");
#endif
  return(0);
}

void XtPopup(popup_shell, grab_kind)
     Widget popup_shell;
     XtGrabKind grab_kind;
{/*                 File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtPopup\n");
#endif
  return(0);
}

void XtCallCallbacks(object, callback_name, call_data)
     Widget object;
     _Xconst _XtString callback_name;
     XtPointer call_data;
{/*      File 'Colormap.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtCallCallbackList\n");
#endif
  return(0);
}

Widget XtNameToWidget(Widget reference,_Xconst _XtString names){/*          File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtNameToWidget\n");
#endif
  return(0);
}

char *XtRealloc(ptr, num)
     char *ptr;
     Cardinal num;
{/*               File 'operation.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtRealloc\n");
#endif
  return(0);
}

RWtableGetWriter(){/*        File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: RWtableGetWriter\n");
#endif
  return(0);
}

void XtSetTypeConverter(from_type, to_type, converter, convert_args,
			num_args, cache_type, destructor)
     _Xconst _XtString from_type; 
     _Xconst _XtString   to_type;
     XtTypeConverter converter;
     XtConvertArgList convert_args;
     Cardinal num_args;
     XtCacheType cache_type;
     XtDestructor destructor;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtSetTypeConverter\n");
#endif
  return(0);
}

XtAccelerators XtParseAcceleratorTable(table)
     _Xconst _XtString table;
{/* File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtParseAcceleratorTable\n");
#endif
  return(0);
}

void XtInstallAccelerators(destination, source)
     Widget destination;
     Widget source;
{/*   File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtInstallAccelerators\n");
#endif
  return(0);
}
/*
XAllowEvents(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XAllowEvents\n");
#endif
  return(0);
}
*/

void XtCallActionProc(widget, action, event, params, num_params)
     Widget widget;
     _Xconst _XtString action;
     XEvent *event;
     String *params;
     Cardinal num_params;
{/*        File 'text.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtCallActionProc\n");
#endif
  return(0);
}

String XtName(Widget object){/*                  File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtName\n");
#endif
  return(0);
}

void XtSetKeyboardFocus(subtree, descendant)
     Widget subtree, descendant;
{/*      File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtSetKeyboardFocus\n");
#endif
  return(0);
}

void XtRemoveEventHandler(w, event_mask, nonmaskable, proc,
			  client_data)
     Widget w;
     EventMask event_mask;
     Boolean nonmaskable;
     XtEventHandler proc;
     XtPointer client_data;
{/*    File 'protocol.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtRemoveEventHandler\n");
#endif
  return(0);
}

void XtReleaseGC(object, gc)
     Widget object;
     GC gc;
{/*             File 'cutCopyPaste.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtReleaseGC\n");
#endif
  return(0);
}

void XtResizeWidget(w, width, height, border_width)
     Widget w;
     _XtDimension width;
     _XtDimension height;
     _XtDimension border_width;
{/*          File 'fatBitsEdit.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtResizeWidget\n");
#endif
  return(0);
}

RWtableGetId(){/*            File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: RWtableGetId\n");
#endif
  return(0);
}

WriteAsciiPNMfd(){/*         File 'graphic.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: WriteAsciiPNMfd\n");
#endif
  return(0);
}

RWtableGetReader(){/*        File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: RWtableGetReader\n");
#endif
  return(0);
}

XawTextSinkSetTabs(){/*      File 'help.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XawTextSinkSetTabs\n");
#endif
  return(0);
}

void XtRemoveTimeOut(id)
     XtIntervalId id;
{/*         File 'grab.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtRemoveTimeOut\n");
#endif
  return(0);
}

void XtPopdown(popup_shell)
     Widget popup_shell;
{/*               File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtPopdown\n");
#endif
  return(0);
}

XawScrollbarSetThumb(){/*    File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XawScrollbarSetThumb\n");
#endif
  return(0);
}

void _XtInherit(void){/*              File 'Paint.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: _XtInherit\n");
#endif
  return(0);
}

RWtableGetReaderList(){/*    File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: RWtableGetReaderList\n");
#endif
  return(0);
}

XawDialogAddButton(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XawDialogAddButton\n");
#endif
  return(0);
}
