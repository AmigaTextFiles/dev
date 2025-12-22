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
     xtmui
   PURPOSE
     
   NOTES
     
   HISTORY
     terjepe - Jul 16, 1996: Created.
***/

#include <intuition/intuition.h>
#include <clib/intuition_protos.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/gadtools.h>
#include <assert.h>
#include <stdio.h>

#include "libX11.h"

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/IntrinsicP.h>
#include <X11/CoreP.h>
#include <X11/Stringdefs.h>

#include <X11/Xaw/Command.h>
#include <X11/Xaw/Box.h>

#include "amigax_proto.h"
#include "amiga_x.h"

#include "xtmui.h"

#ifdef XTMUI
#include <libraries/mui.h>
#include <proto/muimaster.h>

ObjApp_t *X11App = NULL;

ObjApp_t *createMUI_app(char *title);

extern Screen  amiga_screen[];
extern ListNode_t *pWidgetList,*pStringList;


Widget XtAppInitialize(app_context_return, application_class, options,
		       num_options, argc_in_out, argv_in_out, fallback_resources, args,
		       num_args)
     XtAppContext *app_context_return;
     _Xconst _XtString application_class;
     XrmOptionDescList options;
     Cardinal num_options;
     int *argc_in_out;           /* was type Cardinal * in R4 */
     String *argv_in_out;
     String *fallback_resources;
     ArgList args;
     Cardinal num_args;
{
  ObjApp_t *pObjApp;
  Widget w,root;

  XOpenDisplay("");
  X11mui_init();
  pObjApp=createMUI_app("Test");
  w=MakeWidget(NULL,(Object*)pObjApp->Canvas);
  root=MakeWidget(NULL,(Object*)pObjApp->Root);
  w->core.screen=&amiga_screen[0];
  w->core.screen->display=root;
  w->core.widget_class=X11_FORMDIALOG;
  return w;
}

Widget XtAppCreateShell(application_name, application_class,
			widget_class, display, args, num_args)
     _Xconst _XtString application_name;
     _Xconst _XtString application_class;
     WidgetClass widget_class;
     Display *display;
     ArgList args;
     Cardinal num_args;
{
  return XmCreateFormDialog (display, application_name,NULL,NULL);
}

#if 0
Widget XtCreateManagedWidget(
    _Xconst _XtString 	 name ,
    WidgetClass 	 widget_class ,
    Widget 		 parent ,
    ArgList 		 args ,
    Cardinal 		 num_args 
)
{/*   File 'e_edit.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtCreateManagedWidget\n");
#endif
  printf("name %s\n",name);
  printf("widget class %s\n",widget_class);
  printf("parent %d\n",parent);
  return(0);
}
#endif

ObjApp_t *createMUI_app(char *title){
  struct ObjApp * Object;

  if (!(Object = AllocVec( sizeof( struct ObjApp ), MEMF_PUBLIC|MEMF_CLEAR ))) return( NULL );
  Object->App = ApplicationObject,
		MUIA_Application_Author, "TP",
		MUIA_Application_Base, "NONE",
		MUIA_Application_Title, title,
		MUIA_Application_Version, "$VER: NONE XX.XX (XX.XX.XX)",
		MUIA_Application_Copyright, "NOBODY",
		MUIA_Application_Description, "NONE",
		SubWindow, Object->Root = WindowObject,
		  WindowContents, Object->Canvas=GroupObject, End,
		End,  
  End;

  if (!(Object->App)){
    FreeVec(Object);
    Object = NULL;
  }
  return(Object);
}


Widget XtInitialize(shell_name, application_class, options,
		    num_options, argc, argv)
     String shell_name;    /* unused */
     String application_class;
     XrmOptionDescRec options[];
     Cardinal num_options;
     Cardinal *argc;
     char *argv[];

{/*            File 'xlogo.o'*/
#ifdef DEBUGXEMUL
  printf("XtInitialize\n");
#endif
  X11App=createMUI_app(shell_name);

  return(X11App->App);
}

void XtMainLoop(){/*              File 'xlogo.o'*/
  int running=TRUE;
  ULONG sigs;
#ifdef DEBUGXEMUL
  printf("XtMainLoop\n");
#endif
/*  XtAppMainLoop(amiga_Context);*/
  while (running){
    switch (DoMethod(X11App->App,MUIM_Application_Input,&sigs)){
    case MUIV_Application_ReturnID_Quit: running=FALSE;
      break;
    }
    if (running && sigs) Wait(sigs);
  }
  return(0);
}

/*
extern struct IClass *MyClass;
#define MyObject NewObject(MyClass,NULL
*/

const ULONG sourcecolors[6] ={
  0xb4b4b4b4,0xb4b4b4b4,0xb4b4b4b4,
  0x00000000,0x00000000,0x00000000,
};

Widget XtCreateManagedWidget(name, widget_class, parent,
			     args, num_args)
     String name;
     WidgetClass widget_class;
     Widget parent;
     ArgList args;
     Cardinal num_args;
{
  Object *newobj=NULL,*bmobj=NULL;
  if(args && args[0].name==XtNbitmap){
    struct BitMap *bm=(struct BitMap*)args[0].value;
    bmobj=BitmapObject,
      ButtonFrame,
      MUIA_InputMode, MUIV_InputMode_RelVerify,
      MUIA_Bitmap_Bitmap,bm,
      MUIA_Bitmap_Height,bm->Rows,
      MUIA_Bitmap_Width,bm->BytesPerRow*8,
      MUIA_FixWidth,bm->BytesPerRow*8,
      MUIA_FixHeight,bm->Rows,
      MUIA_Bitmap_Transparent,0,
      MUIA_Bitmap_SourceColors,sourcecolors,
      MUIA_Background,MUII_ButtonBack,
    End;
  }

/*
  case xmDrawingAreaWidgetClass:
    newobj=MyObject,
        MUIA_FixWidth,100,
	MUIA_FixHeight,100,
      End;
    break;*/
  if(widget_class==commandWidgetClass){
    if(bmobj){
      newobj=bmobj;
      DoMethod(parent,OM_ADDMEMBER,newobj);
    } else
      return XmCreatePushButton(parent,name,args,num_args);
  } else if( widget_class==boxWidgetClass )
    return XmCreateRowColumn(parent,name,args,num_args);
  else { /* custom widget */
    Widget w=(Widget)calloc(widget_class->core_class.widget_size,1);
    Object *g;

    if(widget_class->core_class.widget_size<sizeof(struct _WidgetRec)){
      printf("widget class too small!\n");
      return(0);
    }
    if(!w) X11resource_exit(XTMUI1);
    List_AddEntry(pWidgetList,(void*)w);
    memcpy(w,widget_class,sizeof(struct _WidgetRec));
    w->core.parent=parent;

    g=GroupObject,
    End;
    DoMethod(X11DrawablesMUI[X11DrawablesMap[(XID)parent->core.self]],OM_ADDMEMBER,g);
    w->core.self=(struct _CorePart *)X11NewMUI(g);
    w->core.widget_class=X11_DRAWINGAREA;
    return w;
  }
}

void XtDestroyWidget(w)
     Widget w;
{
}


void XtRealizeWidget(w)
     Widget w;
{
  if((int)w->core.widget_class!=X11_FORMDIALOG) 
    XtManageChild(w);
  else
    set(X11DrawablesMUI[X11DrawablesMap[(XID)w->core.self]],MUIA_Window_Open,TRUE);
}

#endif /* XTMUI */
