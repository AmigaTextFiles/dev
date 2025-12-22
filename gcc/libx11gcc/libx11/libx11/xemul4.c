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
     xemul4
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Feb 14, 1995: Created.
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

XIOErrorHandler XSetIOErrorHandler(XIOErrorHandler h)
{/*      File 'main.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetIOErrorHandler\n");
#endif
  return(0);
}


listWidgetClass(){/*         File 'w_dir.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: listWidgetClass\n");
#endif
  return(0);
}

void XtGetSelectionValue(w, selection, target, callback, client_data,
			 time)
     Widget w;
     Atom selection;
     Atom target;
     XtSelectionCallbackProc callback;
     XtPointer client_data;
     Time time;
{/*     File 'e_edit.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtGetSelectionValue\n");
#endif
  return(0);
}

void XtSetSensitive(w, sensitive)
     Widget w;
     Boolean sensitive;

{/*          File 'w_cmdpanel.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtSetSensitive\n");
#endif
  return;
}

void XtInstallAllAccelerators(destination, source)
     Widget destination;
     Widget source;
{/* File 'main.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtInstallAllAccelerators\n");
#endif
  return(0);
}

Widget XtCreateWidget(name, object_class, parent, args, num_args)
     _Xconst _XtString name;
     WidgetClass object_class;
     Widget parent;
     ArgList args;
     Cardinal num_args;
{/*          File 'w_canvas.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtCreateWidget\n");
#endif
  return(0);
}

int XGeometry(display, screen, position, default_position, bwidth,
	      fwidth, fheight, xadder, yadder, x_return, y_return,
	      width_return, height_return)
     Display *display;
     int screen;
     char *position,*default_position;
     unsigned int bwidth;
     unsigned int fwidth, fheight;
     int xadder, yadder;
     int *x_return,*y_return,*width_return,*height_return;
{/*               File 'main.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XGeometry\n");
#endif
  if(strlen(position)>1)
    XParseGeometry(position,x_return,y_return,width_return,height_return);
  else
    XParseGeometry(default_position,x_return,y_return,width_return,height_return);
  return(0);
}
/*
XDefaultDepthOfScreen(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XDefaultDepthOfScreen\n");
#endif
  return(0);
}
*/
boxWidgetClass(){/*          File 'w_color.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: boxWidgetClass\n");
#endif
  return(0);
}
/*
XUnloadFont(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XUnloadFont\n");
#endif
  return(0);
}
*/
void XtStringConversionWarning(src, dst_type)
      _Xconst _XtString src; 
      _Xconst _XtString	dst_type;
{/* File 'w_util.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtStringConversionWarning\n");
#endif
  return(0);
}
/*
XSetWMProtocols(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetWMProtocols\n");
#endif
  return(0);
}
*/
transientShellWidgetClass(){/* File 'e_edit.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: transientShellWidgetClass\n");
#endif
  return(0);
}
/*
XGetFontProperty(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGetFontProperty\n");
#endif
  return(0);
}
*/
FMT8BIT(){/*                 File 'w_msgpanel.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: FMT8BIT\n");
#endif
  return(0);
}

labelWidgetClass(){/*        File 'e_edit.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: labelWidgetClass\n");
#endif
  return(0);
}
/*
XFreeFontNames(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XFreeFontNames\n");
#endif
  return(0);
}
*/
void XtAppAddConverter(app_context, from_type, to_type, converter,
		       convert_args, num_args)
     XtAppContext app_context;
     _Xconst _XtString from_type;
     _Xconst _XtString to_type;
     XtConverter converter;
     XtConvertArgList convert_args;
     Cardinal num_args;
{/*       File 'w_util.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtAppAddConverter\n");
#endif
  return(0);
}

viewportWidgetClass(){/*     File 'e_edit.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: viewportWidgetClass\n");
#endif
  return(0);
}

void XtVaGetValues(Widget object,... )
{/*           File 'w_color.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtVaGetValues\n");
#endif
  return(0);
}

void XtTranslateCoords(
    Widget 		 widget ,
    _XtPosition		 x ,
    _XtPosition		 y ,
    Position*		 rootx_return ,
    Position*		 rooty_return 
)
{/*       File 'e_edit.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtTranslateCoords\n");
#endif
  return(0);
}

smeBSBObjectClass(){/*       File 'e_edit.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: smeBSBObjectClass\n");
#endif
  return(0);
}

toggleWidgetClass(){/*       File 'e_edit.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: toggleWidgetClass\n");
#endif
  return(0);
}

XWMHints *XGetWMHints(display, w)
     Display *display;
     Window w;
{/*             File 'main.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGetWMHints\n");
#endif
  return(0);
}

commandWidgetClass(){/*      File 'e_edit.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: commandWidgetClass\n");
#endif
  return(0);
}

formWidgetClass(){/*         File 'e_edit.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: formWidgetClass\n");
#endif
  return(0);
}

Widget XtCreatePopupShell(
    _Xconst _XtString	name ,
    WidgetClass 	widgetClass ,
    Widget 		parent ,
    ArgList 		args ,
    Cardinal 		num_args

)
{/*      File 'e_edit.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtCreatePopupShell\n");
#endif
  return(0);
}

asciiTextWidgetClass(){/*    File 'e_edit.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: asciiTextWidgetClass\n");
#endif
  return(0);
}

void XtOverrideTranslations(w, translations)
     Widget w;
     XtTranslations translations;
{/*  File 'e_edit.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtOverrideTranslations\n");
#endif
  return(0);
}

scrollbarWidgetClass(){/*    File 'w_color.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: scrollbarWidgetClass\n");
#endif
  return(0);
}

menuButtonWidgetClass(){/*   File 'e_edit.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: menuButtonWidgetClass\n");
#endif
  return(0);
}

simpleMenuWidgetClass(){/*   File 'e_edit.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: simpleMenuWidgetClass\n");
#endif
  return(0);
}

execl(){
  return 0;
}

fork(){
  return 0;
}

flock(){
  return 0;
}

mpthd_switch(){/*            File 'program.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: mpthd_switch\n");
#endif
  return(0);
}

mpthd_me_reg(){/*            File 'program.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: _mpthd_me_reg\n");
#endif
  return(0);
}
mpthd_init(){/*              File 'program.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: _mpthd_init\n");
#endif
  return(0);
}
mpthd_setup(){/*             File 'program.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: _mpthd_setup\n");
#endif
  return(0);
}

/* xnmr */

XmListItemExists(){/*        File 'thermo.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmListItemExists\n");
#endif
  return(0);
}

xmCascadeButtonGadgetClass(){/* File 'xnmr.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: xmCascadeButtonGadgetClass\n");
#endif
  return(0);
}

topLevelShellWidgetClass(){/* File 'computation.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: topLevelShellWidgetClass\n");
#endif
  return(0);
}

XmListSelectItem(){/*        File 'thermo.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmListSelectItem\n");
#endif
  return(0);
}

XmTextFieldGetString(){/*    File 'display.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmTextFieldGetString\n");
#endif
  return(0);
}

XmFontListFreeFontContext(){/* File 'xnmr.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmFontListFreeFontContext\n");
#endif
  return(0);
}

XmCreateWarningDialog(){/*   File 'xnmr.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmCreateWarningDialog\n");
#endif
  return(0);
}

XmListGetSelectedPos(){/*    File 'options.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmListGetSelectedPos\n");
#endif
  return(0);
}

XmFontListAdd(){/*           File 'xnmr.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmFontListAdd\n");
#endif
  return(0);
}
/*
XtHasCallbacks(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtHasCallbacks\n");
#endif
  return(0);
}
*/

XmCreateQuestionDialog(){/*  File 'xnmr.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmCreateQuestionDialog\n");
#endif
  return(0);
}

Boolean XtIsSubclass(Widget w,WidgetClass c){/*            File 'computation.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtIsSubclass\n");
#endif
  return(0);
}

Widget XtVaCreatePopupShell(_Xconst _XtString name,WidgetClass c, Widget w,... ){/*    File 'computation.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtVaCreatePopupShell\n");
#endif
  return(0);
}

XmTextFieldSetString(){/*    File 'options.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmTextFieldSetString\n");
#endif
  return(0);
}

Widget XtVaAppInitialize(
    XtAppContext *app_context_return,
    _Xconst _XtString	application_class,
    XrmOptionDescList	options ,
    Cardinal		num_options,
    int*		argc_in_out,
    String*		argv_in_out,
    String*		fallback_resources,...
)
{

  Widget wid;

#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtVaAppInitialize\n");
#endif

 // wid = XtAppInitialize(app_context_return,application_class,options,num_options,argc_in_out,argv_in_out,0,0,0);

  return( wid );
}

XmFileSelectionBoxGetChild(){/* File 'file.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmFileSelectionBoxGetChild\n");
#endif
  return(0);
}

void XtUngrabKeyboard(Widget w,Time t){/*        File 'file.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtUngrabKeyboard\n");
#endif
  return(0);
}

xmDialogShellWidgetClass(){/* File 'computation.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: xmDialogShellWidgetClass\n");
#endif
  return(0);
}

void XtAppError(XtAppContext app_context, _Xconst _XtString message){/*              File 'xnmr.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtAppError\n");
#endif
  return(0);
}

XmRepTypeInstallTearOffModelConv(){/* File 'xnmr.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmRepTypeInstallTearOffModelConv\n");
#endif
  return(0);
}

xmPanedWindowWidgetClass(){/* File 'help.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: xmPanedWindowWidgetClass\n");
#endif
  return(0);
}

XmCreateScrolledList(){/*    File 'file.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmCreateScrolledList\n");
#endif
  return(0);
}

long XMaxRequestSize(Display *d){/*         File 'xnmr.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XMaxRequestSize\n");
#endif
  return(0);
}

xmFormWidgetClass(){/*       File 'file.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: xmFormWidgetClass\n");
#endif
  return(0);
}

xmScrollBarWidgetClass(){/*  File 'windlib.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: xmScrollBarWidgetClass\n");
#endif
  return(0);
}

XmFontListInitFontContext(){/* File 'xnmr.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmFontListInitFontContext\n");
#endif
  return(0);
}

XmProcessTraversal(){/*      File 'computation.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmProcessTraversal\n");
#endif
  return(0);
}

XmStringCreateSimple(){/*    File 'computation.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmStringCreateSimple\n");
#endif
  return(0);
}

void XtUninstallTranslations(Widget widget){/* File 'windlib.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtUninstallTranslations\n");
#endif
  return(0);
}

XmListDeleteAllItems(){/*    File 'file.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmListDeleteAllItems\n");
#endif
  return(0);
}

void XtUngrabPointer(Widget widget,Time t){/*         File 'windlib.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtUngrabPointer\n");
#endif
  return(0);
}

XmListDeselectPos(){/*       File 'file.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmListDeselectPos\n");
#endif
  return(0);
}

XmListSelectPos(){/*         File 'file.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmListSelectPos\n");
#endif
  return(0);
}

xmMainWindowWidgetClass(){/* File 'xnmr.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: xmMainWindowWidgetClass\n");
#endif
  return(0);
}

XmListDeleteItems(){/*       File 'thermo.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmListDeleteItems\n");
#endif
  return(0);
}

XmFontListGetNextFont(){/*   File 'xnmr.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmFontListGetNextFont\n");
#endif
  return(0);
}

/*
XRotDrawString(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XRotDrawString\n");
#endif
  return(0);
}
*/

XmListSetBottomItem(){/*     File 'thermo.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmListSetBottomItem\n");
#endif
  return(0);
}

void XtVaGetApplicationResources(
    Widget		widget,
    XtPointer		base,
    XtResourceList	resources,
    Cardinal		num_resources,
    ...
){/* File 'xnmr.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtVaGetApplicationResources\n");
#endif
  return(0);
}
/*
tempnam(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: tempnam\n");
#endif
  return(0);
}
*/
XmListAddItems(){/*          File 'file.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmListAddItems\n");
#endif
  return(0);
}

void XtAddCallbacks(
    Widget 		widget,
    _Xconst _XtString	callback_name,
    XtCallbackList 	callbacks
){/*          File 'windlib.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtAddCallbacks\n");
#endif
  return(0);
}

void XtSetMappedWhenManaged(
    Widget 		widget,
    _XtBoolean 		mapped_when_managed
){/*  File 'simulation.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtSetMappedWhenManaged\n");
#endif
  return(0);
}
/*
rint(double d){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: rint\n");
#endif
  return(abs(d));
}
*/

XmScrolledWindowSetAreas(){/* File 'windlib.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmScrolledWindowSetAreas\n");
#endif
  return(0);
}

/*
#include <sys/commifmt.h>

S_ISDIR(mode){
  if(mode&S_IFDIR) return(1);
  return(0);
}

S_ISREG(mode){
  if(mode&S_IFREG) return(1);
  return(0);
}
*/

getdtablesize(){
  return(32);
}
