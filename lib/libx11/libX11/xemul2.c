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

/***
   NAME
     xemul2
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Oct 22, 1994: Created.
***/

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

#include <Xm/Xm.h>
#include <Xm/Protocols.h>
#include <Xm/Command.h>
#include <Xm/MessageB.h>
#include <Xm/FileSB.h>
#include <Xm/Frame.h>

#include "amigax_proto.h"
#include "amiga_x.h"

#define XMSTRINGDEFINES

XSetClassHint(display, w, class_hints)
     Display *display;
     Window w;
     XClassHint *class_hints;
{/*           File 'sunclock.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetClassHint\n");
#endif
  return(0);
}

XSetCommand(display, w, argv, argc)
     Display *display;
     Window w;
     char **argv;
     int argc;
{/*             File 'sunclock.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetCommand\n");
#endif
  return(0);
}

XSetIconName(Display *d,Window w,char *iname){/*            File 'sunclock.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetIconName\n");
#endif
  return(0);
}

int (*XSetErrorHandler(handler))()
     int (* handler)(Display *, XErrorEvent *);
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetErrorHandler\n");
#endif
  return(0);
}

XSetWMHints(display, w, wmhints)
     Display *display;
     Window w;
     XWMHints *wmhints;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetWMHints\n");
#endif
  return(0);
}
XSync(display, discard)
     Display *display;
     int discard;
{
/*  printf("XSync\n");*/
  return(0);
}

XGetErrorText(display, code, buffer_return, length)
     Display *display;
     int code;
     char *buffer_return;
     int length;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGetErrorText\n");
#endif
  return(0);
}

void XmAddProtocolCallback (shell, property, protocol, callback, closure)
     Widget      shell;
     Atom        property;
     Atom        protocol;
     XtCallbackProc callback;
     XtPointer   closure;
{/*   File 'motifutils.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmAddProtocolCallback\n");
#endif
  return(0);
}

Widget XmCommandGetChild (widget, child)
     Widget    widget;
     unsigned char child;
{/*       File 'comwin.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmCommandGetChild\n");
#endif
  return(0);
}

Widget XmCreateCommand (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{/*         File 'comwin.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmCreateCommand\n");
#endif
  return(0);
}

Widget XmCreateDialogShell (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{/*     File 'fileswin.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmCreateDialogShell\n");
#endif
  return(0);
}

      Widget XmCreateErrorDialog (parent, name, arglist, argcount)
           Widget    parent;
           String    name;
           ArgList   arglist;
           Cardinal  argcount;
{/*     File 'malerts.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmCreateErrorDialog\n");
#endif
  return(0);
}

Widget XmCreateFrame (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{/*           File 'fileswin.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmCreateFrame\n");
#endif
  return(0);
}

XmCreateLabelGadget(){/*     File 'fileswin.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmCreateLabelGadget\n");
#endif
  return(0);
}

#include <Xm/MainW.h>

Widget XmCreateMainWindow (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{/*      File 'xmgr.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmCreateMainWindow\n");
#endif
  return(0);
}

#include <Xm/RowColumn.h>


#include <Xm/RowColumn.h>

Widget XmCreateOptionMenu (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{/*      File 'motifutils.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmCreateOptionMenu\n");
#endif
  return(0);
}

#include <Xm/RowColumn.h>

#include <Xm/PushBG.h>

Widget XmCreatePushButtonGadget (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{/* File 'motifutils.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmCreatePushButtonGadget\n");
#endif
  return(0);
}

#include <Xm/RowColumn.h>

Widget XmCreateRadioBox (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{/*        File 'fileswin.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmCreateRadioBox\n");
#endif
  return(0);
}

#include <Xm/Xm.h>
#include <Xm/AtomMgr.h>

Atom XmInternAtom (display, name, only_if_exists)
     Display   * display;
     String    name;
     Boolean   only_if_exists;
{/*            File 'motifutils.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmInternAtom\n");
#endif
  return(0);
}

#include <Xm/List.h>

void XmListAddItemsUnselected (widget, items, item_count, position)
     Widget    widget;
     XmString  *items;
     int       item_count;
     int       position;
{/* File 'comwin.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmListAddItemUnselected\n");
#endif
  return(0);
}

#include <Xm/List.h>

void XmListDeletePos (widget, position)
     Widget    widget;
     int       position;
{/*         File 'comwin.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmListDeletePos\n");
#endif
  return(0);
}

#include <Xm/MainW.h>

void XmMainWindowSetAreas (widget, menu_bar, command_window,
			   horizontal_scrollbar, vertical_scrollbar, work_region)
     Widget    widget;
     Widget    menu_bar;
     Widget    command_window;
     Widget    horizontal_scrollbar;
     Widget    vertical_scrollbar;
     Widget    work_region;
{/*    File 'xmgr.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmMainWindowSetAreas\n");
#endif
  return(0);
}

#include <Xm/MessageB.h>

Widget XmMessageBoxGetChild (widget, child)
     Widget    widget;
     unsigned char child;
{/*    File 'malerts.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmMessageBoxGetChild\n");
#endif
  return(0);
}

#include <Xm/Text.h>

XmTextPosition XmTextGetLastPosition (widget)
     Widget    widget;
{/*   File 'monwin.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmTextGetLastPosition\n");
#endif
  return(0);
}

char *XmTextGetString(Widget widget){/*         File 'monwin.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmTextGetString\n");
#endif
  return(0);
}

void XmTextInsert(Widget widget,XmTextPosition position,char *value)
{/*            File 'monwin.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
	printf("WARNING: XmTextInsert\n");
#endif
	return(0);
}

void XmTextSetTopCharacter(Widget widget,XmTextPosition top_character)
{/*   File 'monwin.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmTextSetTopCharacter\n");
#endif
  return(0);
}

void XmUpdateDisplay(Widget w){/*         File 'xmgr.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmUpdateDisplay\n");
#endif
  return(0);
}

WidgetClass xmCascadeButtonWidgetClass;
WidgetClass xmDrawingAreaWidgetClass;
WidgetClass xmFrameWidgetClass;
WidgetClass xmLabelGadgetClass;
WidgetClass xmLabelWidgetClass;
WidgetClass xmPushButtonGadgetClass;
WidgetClass xmPushButtonWidgetClass;
WidgetClass xmRowColumnWidgetClass;
WidgetClass xmScaleWidgetClass;
WidgetClass xmScrolledWindowWidgetClass;
WidgetClass xmSeparatorGadgetClass;
WidgetClass xmTextFieldWidgetClass;
WidgetClass xmTextWidgetClass;
WidgetClass xmToggleButtonGadgetClass;

void cfree(char *data){/*                   File 'compwin.o'*/
  free(data);
}

double hypot(double x,double y){/*                   File 'events.o'*/
  double sq;
/*  printf("hypot %f %f\n",x,y);*/
  sq=(double)(sqrt(x*x+y*y));
/*  printf("sqrt %f\n",sq);*/
  return(sq);
}

/*
nonl(){/*_parms              File 'nonlwin.o'*/
  printf("nonl\n");
  return(0);
}
*/

int XGetWindowProperty(display, w, property, long_offset,
		       long_length, delete, req_type, actual_type_return,
		       actual_format_return, nitems_return, bytes_after_return,
		       prop_return)
     Display *display;
     Window w;
     Atom property;
     long long_offset, long_length;
     Bool delete;
     Atom req_type;
     Atom *actual_type_return;
     int *actual_format_return;
     unsigned long *nitems_return;
     unsigned long *bytes_after_return;
     unsigned char **prop_return;
{/*      File 'xdaliclock.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGetWindowProperty\n");
#endif
  return(0);
}

double erf(double x){
  printf("erf? %f\n",x);
  return(x);
}

double erfc(double x){
  printf("erfc? %f\n",x);
  return(x);
}

double lgamma(double x){
  printf("lgamma? %f\n",x);
  return(x);
}

XrmDatabase XrmGetDatabase(display)
     Display *display;
{/*          File 'magick/libMagick.lib' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XrmGetDatabase\n");
#endif
  return(0);
}

Window XGetSelectionOwner(display, selection)
     Display *display;
     Atom selection;
{/*      File 'magick/libMagick.lib' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGetSelectionOwner\n");
#endif
  return(0);
}

XGetIconSizes(){/*           File 'magick/libMagick.lib' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGetIconSizes\n");
#endif
  return(0);
}

void XrmCombineDatabase(source_db, target_db, override)
     XrmDatabase source_db;
     XrmDatabase *target_db;
     Bool override;
{/*      File 'magick/libMagick.lib' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XrmCombineDatabase\n");
#endif
  return(0);
}

Status XStringListToTextProperty(list, count, text_prop_return)
     char **list;
     int count;
     XTextProperty *text_prop_return;
{
  text_prop_return->value=*list;
  text_prop_return->format=8;
  text_prop_return->nitems=1;
  return(1);
}

XrmCombineFileDatabase(){/*  File 'magick/libMagick.lib' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XrmCombineFileDatabase\n");
#endif
  return(0);
}

XBitmapPad(){/*              File 'magick/libMagick.lib' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XBitmapPad\n");
#endif
  return(0);
}

void XrmPutFileDatabase(database, stored_db)
     XrmDatabase database;
     char *stored_db;
{/*      File 'magick/libMagick.lib' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XrmPutFileDatabase\n");
#endif
  return(0);
}

XConvertSelection(){/*       File 'magick/libMagick.lib' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XConvertSelection\n");
#endif
  return(0);
}

Status XGetCommand(display, w, argv_return, argc_return)
     Display *display;
     Window w;
     char ***argv_return;
     int *argc_return;
{/*             File 'display.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGetCommand\n");
#endif
  return(0);
}

void XFreeStringList(list)
     char **list;
{/*         File 'display.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XFreeStringList\n");
#endif
  return(0);
}

XtErrorHandler XtAppSetErrorHandler(app_context, handler)
     XtAppContext app_context;
     XtErrorHandler handler;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtAppSetErrorHandler\n");
#endif
  return(0);
}

XtWorkProcId XtAppAddWorkProc(app_context, proc, client_data)
     XtAppContext app_context;
     XtWorkProc proc;
     XtPointer client_data;

{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtAppAddWorkProc\n");
#endif
  return(0);
}
