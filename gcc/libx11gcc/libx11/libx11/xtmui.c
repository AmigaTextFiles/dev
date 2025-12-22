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

#ifdef XTMUI
#include <intuition/intuition.h>
#include <clib/intuition_protos.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/gadtools.h>
#include <assert.h>
#include <stdio.h>

#include "libX11.h"

#define XLIB_ILLEGAL_ACCESS 1

#define XMSTRINGDEFINES 1

#include <Xm/XmStrDefs.h>

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/IntrinsicP.h>
#include <X11/CoreP.h>
#include <X11/StringDefs.h>

#include <X11/Xaw/Command.h>
#include <X11/Xaw/Box.h>

#include "x11display.h"

#include "xtmui.h"
#include "xmui.h"

#include <libraries/mui.h>
#include <proto/muimaster.h>

ObjApp_t *X11App = NULL;

ObjApp_t *createMUI_app(char *title);

extern ListNode_t *pWidgetList,*pStringList;


WidgetClass xmCascadeButtonWidgetClass = NULL;
WidgetClass xmDrawingAreaWidgetClass = NULL;
WidgetClass xmFrameWidgetClass = NULL;
WidgetClass xmLabelGadgetClass = NULL;
WidgetClass xmLabelWidgetClass = NULL;
WidgetClass xmPushButtonGadgetClass = NULL;
WidgetClass xmPushButtonWidgetClass = NULL;
WidgetClass xmRowColumnWidgetClass = NULL;
WidgetClass xmScaleWidgetClass = NULL;
WidgetClass xmScrolledWindowWidgetClass = NULL;
WidgetClass xmSeparatorGadgetClass = NULL;
WidgetClass xmTextFieldWidgetClass = NULL;
WidgetClass xmTextWidgetClass = NULL;
WidgetClass xmToggleButtonGadgetClass = NULL;


void X11InitClasses(void);
void X11ExitClasses(void);


void *
X11GetArg( char *str, ArgList aList, int nArgs )
{
  int i;

  for( i=0; i<nArgs; i++ ){
    if( !strcmp(aList[i].name,str) )
      return (void*)aList[i].value;
  }
  return NULL;
}

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
  pObjApp = createMUI_app("Test");
  w = MakeWidget(NULL,(Object*)pObjApp->Canvas);
  root=MakeWidget(NULL,(Object*)pObjApp->Root);
  w->core.screen = &DG.X11Screen[0];
  w->core.screen->display = root;
  w->core.widget_class = X11_FORMDIALOG;

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
    String 	 name ,
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
  } else {
    DoMethod(Object->Root, MUIM_Notify, MUIA_Window_CloseRequest, TRUE, Object->App, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);
  }
  return(Object);
}


Widget XtInitialize(shell_name, application_class, options,
		    num_options, argc, argv)
     _Xconst _XtString shell_name;    /* unused */
     _Xconst _XtString application_class;
     XrmOptionDescRec options[];
     Cardinal num_options;
     int *argc;
     char *argv[];

{/*            File 'xlogo.o'*/
#ifdef DEBUGXEMUL
  printf("XtInitialize\n");
#endif
  if( !DG.bX11Open ){
    XOpenDisplay("");
  }
  X11mui_init();
  X11InitClasses();

  X11App=createMUI_app(shell_name);

  return(X11App);
}

X11xtmui_cleanup()
{
  set(X11App->Root,MUIA_Window_Open,FALSE);
  MUI_DisposeObject(X11App->App);
  FreeVec(X11App);
}

void XtMainLoop()
{
  int running=TRUE;
  ULONG sigs;

#ifdef DEBUGXEMUL
  printf("XtMainLoop\n");
#endif
/*  XtAppMainLoop(amiga_Context);*/
  while ( running ) {
    int mui_input;

    mui_input = DoMethod(X11App->App,MUIM_Application_Input,&sigs);

    switch ( mui_input ){
    case MUIV_Application_ReturnID_Quit:
      running=FALSE;
      break;
    default:
      printf("%d\n",mui_input);
      break;
    }
    if (running && sigs) Wait(sigs);
  }

  X11xtmui_cleanup();
  X11mui_cleanup();
  XCloseDisplay("");

  return;
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
     _Xconst _XtString name;
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
  if( widget_class==commandWidgetClass ){
    if(bmobj){
      newobj=bmobj;
      DoMethod(parent,OM_ADDMEMBER,newobj);
    } else
      return XmCreatePushButton(parent,name,args,num_args);
  }
  else if( widget_class==boxWidgetClass )
    return XmCreateRowColumn(parent,name,args,num_args);
  else if( widget_class==xmLabelWidgetClass ){
    Widget w;
    char* str;
    
    str = (char*)X11GetArg( XmNlabelString, args, num_args );
    w = XmCreateLabel(parent,str,args,num_args);

    if( parent==X11App )
      DoMethod(X11App->Canvas,OM_ADDMEMBER,X11DrawablesMUI[X11DrawablesMap[(XID)w->core.self]]);

    return w;
   } if( widget_class==xmPushButtonWidgetClass ){
    Widget w;
    char* str;
    
    str = (char*)X11GetArg( XmNlabelString, args, num_args );
    w = XmCreatePushButton(parent,str,args,num_args);

    if( parent==X11App )
      DoMethod(X11App->Canvas,OM_ADDMEMBER,X11DrawablesMUI[X11DrawablesMap[(XID)w->core.self]]);

    return w;
   } else { /* custom widget */
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
  if( w == (Widget)X11App ){
    set(X11App->Root,MUIA_Window_Open,TRUE);
    return;
  }
  if((int)w->core.widget_class!=X11_FORMDIALOG) 
    XtManageChild(w);
  else
    set(X11DrawablesMUI[X11DrawablesMap[(XID)w->core.self]],MUIA_Window_Open,TRUE);
}

void
X11InitClasses(void)
{

  printf("sizeof classes %d\n",sizeof(struct _WidgetClassRec));
  xmCascadeButtonWidgetClass = (WidgetClass) calloc(sizeof(struct _WidgetClassRec),1);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)xmCascadeButtonWidgetClass);
#endif /* MEMORYTRACKING */

  xmDrawingAreaWidgetClass = (WidgetClass) calloc(sizeof(struct _WidgetClassRec),1);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)xmDrawingAreaWidgetClass);
#endif /* MEMORYTRACKING */

  xmFrameWidgetClass = (WidgetClass) calloc(sizeof(struct _WidgetClassRec),1);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)xmFrameWidgetClass);
#endif /* MEMORYTRACKING */

  xmLabelWidgetClass = (WidgetClass) calloc(sizeof(struct _WidgetClassRec),1);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)xmLabelWidgetClass);
#endif /* MEMORYTRACKING */

  xmPushButtonGadgetClass = (WidgetClass) calloc(sizeof(struct _WidgetClassRec),1);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)xmPushButtonGadgetClass);
#endif /* MEMORYTRACKING */

  xmPushButtonWidgetClass = (WidgetClass) calloc(sizeof(struct _WidgetClassRec),1);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)xmPushButtonWidgetClass);
#endif /* MEMORYTRACKING */

  xmRowColumnWidgetClass = (WidgetClass) calloc(sizeof(struct _WidgetClassRec),1);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)xmRowColumnWidgetClass);
#endif /* MEMORYTRACKING */

  xmScaleWidgetClass = (WidgetClass) calloc(sizeof(struct _WidgetClassRec),1);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)xmScaleWidgetClass);
#endif /* MEMORYTRACKING */

  xmScrolledWindowWidgetClass = (WidgetClass) calloc(sizeof(struct _WidgetClassRec),1);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)xmScrolledWindowWidgetClass);
#endif /* MEMORYTRACKING */

  xmSeparatorGadgetClass = (WidgetClass) calloc(sizeof(struct _WidgetClassRec),1);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)xmSeparatorGadgetClass);
#endif /* MEMORYTRACKING */

  xmTextFieldWidgetClass = (WidgetClass) calloc(sizeof(struct _WidgetClassRec),1);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)xmTextFieldWidgetClass);
#endif /* MEMORYTRACKING */

  xmTextWidgetClass = (WidgetClass) calloc(sizeof(struct _WidgetClassRec),1);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)xmTextWidgetClass);
#endif /* MEMORYTRACKING */

  xmToggleButtonGadgetClass = (WidgetClass) calloc(sizeof(struct _WidgetClassRec),1);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)xmToggleButtonGadgetClass);
#endif /* MEMORYTRACKING */

}

void
X11ExitClasses(void)
{
#if (MEMORYTRACKING!=0)
  List_RemoveEntry(pMemoryList,(void*)xmCascadeButtonWidgetClass);
  List_RemoveEntry(pMemoryList,(void*)xmDrawingAreaWidgetClass);
  List_RemoveEntry(pMemoryList,(void*)xmFrameWidgetClass);
  List_RemoveEntry(pMemoryList,(void*)xmLabelWidgetClass);
  List_RemoveEntry(pMemoryList,(void*)xmPushButtonGadgetClass);
  List_RemoveEntry(pMemoryList,(void*)xmPushButtonWidgetClass);
  List_RemoveEntry(pMemoryList,(void*)xmRowColumnWidgetClass);
  List_RemoveEntry(pMemoryList,(void*)xmScaleWidgetClass);
  List_RemoveEntry(pMemoryList,(void*)xmScrolledWindowWidgetClass);
  List_RemoveEntry(pMemoryList,(void*)xmSeparatorGadgetClass);
  List_RemoveEntry(pMemoryList,(void*)xmTextFieldWidgetClass);
  List_RemoveEntry(pMemoryList,(void*)xmTextWidgetClass);
  List_RemoveEntry(pMemoryList,(void*)xmToggleButtonGadgetClass);
#else
  free(xmCascadeButtonWidgetClass);
  free(xmDrawingAreaWidgetClass);
  free(xmFrameWidgetClass);
  free(xmLabelWidgetClass);
  free(xmPushButtonGadgetClass);
  free(xmPushButtonWidgetClass);
  free(xmRowColumnWidgetClass);
  free(xmScaleWidgetClass);
  free(xmScrolledWindowWidgetClass);
  free(xmSeparatorGadgetClass);
  free(xmTextFieldWidgetClass);
  free(xmTextWidgetClass);
  free(xmToggleButtonGadgetClass);
#endif /* MEMORYTRACKING */

}

void XtAddEventHandler(w, event_mask, nonmaskable, proc, client_data)
     Widget w;
     EventMask event_mask;
     Boolean nonmaskable;
     XtEventHandler proc;
     XtPointer client_data;
{
#ifdef DEBUGXEMUL
  printf("XtAddEventHandler\n");
#endif
  switch( event_mask ){
  case ButtonPressMask:
    {
      struct Hook* hook;

      hook = calloc(sizeof(struct Hook),1);
#if (MEMORYTRACKING!=0)
      List_AddEntry(pMemoryList,(void*)hook);
#endif /* MEMORYTRACKING */

      hook->h_Entry = (void*)proc;
      hook->h_Data = (APTR)client_data;

      DoMethod(X11DrawablesMUI[X11DrawablesMap[(XID)w->core.self]], MUIM_Notify, MUIA_Pressed, FALSE, X11App->App, 3, MUIM_CallHook, hook, w, client_data );
    }
    break;
  }
  return;
}

#endif /* XTMUI */
