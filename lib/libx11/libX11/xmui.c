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
     Xmui
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Jan 10, 1996: Created.
***/


#include <intuition/intuition.h>
#include <clib/intuition_protos.h>
/*
#include <intuition/intuitionbase.h>

#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <graphics/displayinfo.h>
#include <devices/timer.h>
*/

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/gadtools.h>
/*
#include <proto/layers.h>
*/
#include <assert.h>
/*
#include <dos.h>
#include <signal.h>
#include <stdlib.h>
#include <time.h>
*/
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
#include <Xm/Form.h>
#include <Xm/Frame.h>
#include <Xm/RowColumn.h>
#include <Xm/Label.h>
#include <Xm/Separator.h>
#include <Xm/PushB.h>
#include <Xm/Text.h>
#include <Xm/Scale.h>
#include <Xm/SelectioB.h>
#include <Xm/TextF.h>
#include <Xm/SelectioB.h>
#include <Xm/CascadeB.h>
#include <Xm/DrawingA.h>
#include <Xm/ScrollBar.h>

#include "amigax_proto.h"
#include "amiga_x.h"

#define XMSTRINGDEFINES

#ifdef XMUIAPP
#include <libraries/mui.h>
#include <proto/muimaster.h>


extern Object *X11menustrip;

ListNode_t *pWidgetList,*pStringList;

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

BOOL arg_findarg(ArgList args,int nArgs, char *zArgName, int nArgValue){
  int i;
  for( i=0; i<nArgs; i++ )
    {
      if(!strcmp(args[i].name,zArgName))
	{
	  if(args[i].value==nArgValue) return TRUE;
	  else return FALSE;
	}
    }
  return FALSE;
}

void X11mui_init(void){
  pWidgetList=List_MakeNull();
  pStringList=List_MakeNull();
}

void X11mui_cleanup(void){
  List_FreeList(pWidgetList);
  List_FreeList(pStringList);
}

Widget MakeWidget(Widget parent,Object *self){
  int size=sizeof(struct _WidgetRec);
  Widget w=(Widget)calloc(size,1);
  if(!w) return 0;
  List_AddEntry(pWidgetList,(void*)w);
  if(parent)
    memcpy(w,parent,size); /* inherit all parent attributes */
  w->core.parent=parent;
  w->core.self=(struct _CorePart *)X11NewMUI(self);
  return w;
}

Widget XmCreateRowColumn (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{/*       File 'xmgr.o'*/
  Widget w;
  Object *g;
#ifdef DEBUGXEMUL
  printf("XmCreateRowColumn\n");
#endif

  assert(parent);
  assert(arglist);
  
  g=GroupObject,
  End;
  w=MakeWidget(parent,g);
  w->core.widget_class=X11_ROWCOLUMN;
  return((Widget)w);
}

enum { MEN_PROJECT=1,MEN_ABOUT,MEN_QUIT };

struct NewMenu MenuData1[] =
{
  { NM_TITLE, "Project"                  , 0 ,0 ,0             ,(APTR)MEN_PROJECT  },
  { NM_ITEM ,  "About"                   ,"?",0 ,0             ,(APTR)MEN_ABOUT    },
  { NM_ITEM ,  NM_BARLABEL               , 0 ,0 ,0             ,(APTR)0            },
  { NM_ITEM ,  "Quit"                    ,"Q",0 ,0             ,(APTR)MEN_QUIT     },
  { NM_END,NULL,0,0,0,(APTR)0 },
};

Widget XmCreateMenuBar (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{/*         File 'xmgr.o'*/
  Widget w;
#ifdef DEBUGXEMUL
  printf("XmCreateMenuBar\n");
#endif
/*
  Object *strip=MUI_MakeObject(MUIO_MenustripNM,MenuData1,0);
  set(X11DrawablesMUI[X11DrawablesMap[(XID)parent->core.self]],MUIA_Window_Menustrip,strip);
*/

  w=MakeWidget(parent,X11menustrip /* strip*/);
  w->core.widget_class=X11_MENUSTRIP;
  return(w);
}

Widget XmCreatePulldownMenu (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{/*    File 'xmgr.o'*/
#ifdef DEBUGXEMUL
  printf("XmCreatePulldownMenu\n");
#endif
  Widget w;
  Object *menu=MenuObject,MUIA_Menu_Title,name,End;

  DoMethod(X11DrawablesMUI[X11DrawablesMap[(XID)parent->core.self]],MUIM_Family_AddTail,menu);

/*
  DoMethod(X11menustrip,MUIM_Family_AddTail,menu);
  */
  w=MakeWidget(parent,menu);
  w->core.widget_class=X11_PULLDOWNMENU;
/*  w->core.window=X11NewMUI(win);*/
  return(w);
}

Widget XmCreateLabel (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{
  Widget w;
  Object *t;
#ifdef DEBUGXEMUL
  printf("XmCreateLabel\n");
#endif

  assert(parent);
  assert(arglist);

  t=TextObject,
    MUIA_Text_Contents,name,
  End,
  w=MakeWidget(parent,t);
  w->core.widget_class=X11_LABEL;
  return(w);
}

Widget XmCreateSeparator (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;

{
  Widget w;
  Object *s;
#ifdef DEBUGXEMUL
  printf("XmCreateSeparator\n");
#endif

  return 0;
  assert(parent);
  assert(arglist);

  if(arg_findarg(arglist,argcount,XmNorientation,XmVERTICAL)) {
    s=RectangleObject, MUIA_Rectangle_HBar, TRUE, MUIA_FixHeight, 8, End;
  } else {
    s=RectangleObject, MUIA_Rectangle_VBar, TRUE, MUIA_FixWidth, 8, End;
  }
  w=MakeWidget(parent,s);
  w->core.widget_class=X11_SEPARATOR;
  return(w);
}

Widget XmCreatePushButton (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{/*      File 'motifutils.o'*/
  Widget w;
  Object *b;
#ifdef DEBUGXEMUL
  printf("XmCreatePushButton\n");
#endif

  assert(parent);

  if(name && strlen(name)==0){
    return 0;
  }

  if((XID)parent->core.widget_class==X11_PULLDOWNMENU){

    b=MUI_MakeObject(MUIO_Menuitem,name,0,0,0);
/*
    APTR pObject;
    Object *object; 
    struct MinList *pList;
    int i=0;
    get(X11DrawablesMUI[X11DrawablesMap[(XID)parent->core.self]],MUIA_Family_List,&pList);
    pObject=pList->mlh_Head;
    while((object=NextObject(&pObject))!=NULL){
      printf("object nr:%d = %d\n",i++,object);
    }
*/
/*    if(i)*/
      DoMethod(X11DrawablesMUI[X11DrawablesMap[(XID)parent->core.self]],MUIM_Family_AddTail,b);
/*
    else
      DoMethod(X11DrawablesMUI[X11DrawablesMap[(XID)parent->core.self]],MUIM_Family_AddHead,b);
*/
    w=MakeWidget(parent,b);
    w->core.widget_class=X11_MENUSTRIP;
  } else {
    b=SimpleButton(name);
    w=MakeWidget(parent,b);
    w->core.widget_class=X11_BUTTON;
  }
  return(w);
}

Widget XmCreateForm (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{/*            File 'xmgr.o'*/
  Widget w;
  Object *f;
#ifdef DEBUGXEMUL
  printf("XmCreateForm\n");
#endif

  assert(parent);
  assert(arglist);

  f=RectangleObject,
    MUIA_Frame,MUIV_Frame_Group,
  End;

  w=MakeWidget(parent,f);
  w->core.widget_class=X11_FORM;

  return(w);
}

void XmTextShowPosition (widget, position)
     Widget    widget;
     XmTextPosition position;
{
  return;
}

void XmScaleSetValue (widget, value)
     Widget    widget;
     int       value;
{
  return;
}

Widget XmCreatePromptDialog (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{
  Widget w;
  Object *g=GroupObject,
  End;
  DoMethod(X11DrawablesMUI[X11DrawablesMap[(XID)parent->core.self]],OM_ADDMEMBER,g);
  w=MakeWidget(parent,g);
  w->core.widget_class=X11_PROMPTDIALOG;
  return((Widget)w);
}

Widget XmCreateTextField (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{
  Widget w;
  Object *g=GroupObject,
  End;
  w=MakeWidget(parent,g);
  w->core.widget_class=X11_TEXTFIELD;
  return((Widget)w);
}

Widget XmSelectionBoxGetChild (widget, child)
     Widget    widget;
     unsigned int child;
{
  return((Widget)NULL);
}

Boolean XtIsManaged(object)
     Widget object;
{
  return FALSE;
}

void XmTextSetInsertionPosition (widget, position)
     Widget    widget;
     XmTextPosition position;
{
}

Widget XmCreateCascadeButton (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{
  Widget w;

  if((XID)parent->core.widget_class==X11_PULLDOWNMENU||
     (XID)parent->core.widget_class==X11_MENUSTRIP){
    
    return XmCreatePushButton (parent, name, arglist, argcount);
  } else {
    Object *g=GroupObject,
    End;
    w=MakeWidget(parent,g);
    w->core.widget_class=X11_CASCADEBUTTON;
    return((Widget)w);
  }
}

Widget XmCreateDrawingArea (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{
  Widget w;
  Object *g=GroupObject,
  End;
  w=MakeWidget(parent,g);
  w->core.widget_class=X11_DRAWINGAREA;
  return((Widget)w);
}

Widget XmCreateText (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{
  Widget w;
  Object *g=GroupObject,
  End;
  w=MakeWidget(parent,g);
  w->core.widget_class=X11_TEXT;
  return((Widget)w);
}

Widget XmCreateFormDialog (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{
  Widget w;
  Object *grp,*win;

  win=WindowObject,
    MUIA_Window_ID, MAKE_ID( 'F','R','M',0 ),
    MUIA_Window_Title,name,
    Child,grp=GroupObject,
    End,
  End;
  DoMethod(X11DrawablesMUI[X11DrawablesMap[(XID)parent->core.self]],OM_ADDMEMBER,win);
  w=MakeWidget(parent,grp);
  w->core.widget_class=X11_FORMDIALOG;
  w->core.window=X11NewMUI(win);
  return(w);
}

Boolean XtIsSensitive(object)
     Widget object;
{
  return FALSE;
}

XmTextPosition XmTextGetInsertionPosition (widget)
     Widget    widget;
{
  return (XmTextPosition)NULL;
}

Widget XmCreateScale (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{
  Widget w;
  Object *g=GroupObject,
  End;
  w=MakeWidget(parent,g);
  w->core.widget_class=X11_SCALE;
  return((Widget)w);
}

void XmScaleGetValue (widget, value_return)
     Widget    widget;
     int       * value_return;
{
}

void XmMenuPosition (menu, event)
     Widget         menu;
     XButtonPressedEvent* event;
{
}

Widget XmCreateFileSelectionDialog (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{
  Widget w;
  Object *g=GroupObject,
  End;
  DoMethod(X11DrawablesMUI[X11DrawablesMap[(XID)parent->core.self]],OM_ADDMEMBER,g);
  w=MakeWidget(parent,g);
  w->core.widget_class=X11_FILESELECTIONDIALOG;
  return((Widget)w);
}

Widget XmCreatePopupMenu (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{
  Widget w;
  Object *g=GroupObject,
  End;
  w=MakeWidget(parent,g);
  w->core.widget_class=X11_POPUPMENU;
  return((Widget)w);
}

void XmTextReplace (widget, from_pos, to_pos, value)
     Widget      widget;
     XmTextPosition from_pos;
     XmTextPosition to_pos;
     char        * value;
{
}

Widget XmCreateScrollBar (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{
  Widget w;
  Object *g=GroupObject,
  End;
  w=MakeWidget(parent,g);
  w->core.widget_class=X11_SCROLLBAR;
  return((Widget)w);
}

Widget XmCreateFileSelectionBox (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{
  Widget w;
  Object *g=GroupObject,
  End;
  DoMethod(X11DrawablesMUI[X11DrawablesMap[(XID)parent->core.self]],OM_ADDMEMBER,g);
  w=MakeWidget(parent,g);
  w->core.widget_class=X11_FILESELECTIONBOX;
  return((Widget)w);
}

void XtManageChild(w)
     Widget w;
{/*           File 'xmgr.o'*/
#ifdef DEBUGXEMUL
  printf("XtManageChild\n");
#endif
  Widget parent;
  if(!w) return;
  parent=w->core.parent;
  if( parent && (XID)w->core.widget_class!=X11_MENUSTRIP &&
     (XID)w->core.widget_class!=X11_PULLDOWNMENU){
    DoMethod(X11DrawablesMUI[X11DrawablesMap[(XID)parent->core.self]],OM_ADDMEMBER,
	     X11DrawablesMUI[X11DrawablesMap[(XID)w->core.self]]);
    set(X11DrawablesMUI[X11DrawablesMap[(XID)w->core.self]],MUIA_ShowMe,TRUE);
  }
}

void XtManageChildren(children, num_children)
     WidgetList children;
     Cardinal num_children;
{/*        File 'fileswin.o'*/
#ifdef DEBUGXEMUL
  printf("XtManageChildren\n");
#endif
}

void XtUnmanageChild(w)
     Widget w;
{/*         File 'malerts.o'*/
#ifdef DEBUGXEMUL
  printf("XtUnmanageChild\n");
#endif
}

#include <Xm/ToggleB.h>

Widget XmCreateToggleButton (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{/*    File 'printwin.o'*/
#ifdef DEBUGXEMUL
  printf("XmCreateToggleButton\n");
#endif
  Widget w;
  if((XID)parent->core.widget_class==X11_PULLDOWNMENU){
    Object *b;

    b=MUI_MakeObject(MUIO_Menuitem,name,0,0,0);
    set(b,MUIA_Menuitem_Checkit,TRUE);
    DoMethod(X11DrawablesMUI[X11DrawablesMap[(XID)parent->core.self]],MUIM_Family_AddTail,b);
    w=MakeWidget(parent,b);
    w->core.widget_class=X11_MENUSTRIP;
    return w;
  } else {
    Object *b=TextObject,
      ButtonFrame,
      MUIA_Text_Contents, name,
      MUIA_Text_PreParse, "\33c",
      MUIA_InputMode    , MUIV_InputMode_Toggle,
      MUIA_Background   , MUII_ButtonBack,
    End;
    w=MakeWidget(parent,b);
    w->core.widget_class=X11_TOGGLEBUTTON;
    return((Widget)w);
  }
}

#include <Xm/ToggleBG.h>

Widget XmCreateToggleButtonGadget (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{/* File 'fileswin.o'*/
#ifdef DEBUGXEMUL
  printf("XmCreateToggleButtonGadget\n");
#endif
  return(0);
}

void XtUnrealizeWidget(w)
     Widget w;
{
  return(0);
}

Display *XtDisplayOfObject(object)
     Widget object;
{
  return(0);
}

XtLanguageProc XtSetLanguageProc(app_context, proc, client_data)
     XtAppContext app_context;
     XtLanguageProc proc;
     XtPointer client_data;
{
  return(0);
}

/*
Dimension XmStringHeight (fontlist, string)
     XmFontListfontlist;
     XmString  string;
{
  return 8;
}

void XmGetColors (screen, colormap, background, foreground, top_shadow, bottom_shadow, select)
     Screen    * screen;
     Colormap  colormap;
     Pixel     background;
     Pixel     * foreground;
     Pixel     * top_shadow;
     Pixel     * bottom_shadow;
     Pixel     * select;
{
}

XmFontListNextEntry()
{
}

Widget XmOptionButtonGadget (option_menu)
     Widget    option_menu;
{
}

Dimension XmStringWidth (fontlist, string)
     XmFontList fontlist;
     XmString  string;
{
}

Widget XtVaAppCreateShell(application_name, application_class,
			  widget_class, display, ...)
     String application_name;
     String application_class;
     WidgetClass widget_class;
     Display *display;
{
}

Widget XmVaCreateSimplePulldownMenu (parent, name, post_from_button,
				     callback, arg...)
     Widget    parent;
     String    name;
     int       post_from_button;
     XtCallbackProccallback;
{
}

Widget XmVaCreateSimpleRadioBox (parent, name, button_set, callback,
				 arg...)
     Widget    parent;
     String    name;
     int       button_set;
     XtCallbackProccallback;
{
}

char* XmFontListEntryGetTag (entry)
     XmFontListEntryentry;
{
}
*/

Boolean XmStringGetLtoR (string, tag, text)
     XmString string;
     XmStringCharSet tag;
     char      **text;
{/*         File 'fileswin.o'*/
#ifdef DEBUGXEMUL
  printf("XmStringGetLtoR\n");
#endif
  if( !text || !string ) return 0;
  if( strstr(text,string) ) return 1;
  return 0;
}

XmString XmStringCreateLtoR(char *string,XmStringCharSet charset){/*      File 'xmgr.o'*/
#ifdef DEBUGXEMUL
  printf("XmStringCreateLtoR\n");
#endif
  char *str=malloc(strlen(string)+1);
  if(!str) return 0;
  strcpy(str,string);
  List_AddEntry(pStringList,(void*)str);
  return(str);
}

void XmStringFree (string)
     XmString  string;
{/*            File 'xmgr.o'*/
#ifdef DEBUGXEMUL
  printf("XmStringFree\n");
#endif
  List_RemoveEntry(pStringList,(void*)string);
  return(0);

}

#include <Xm/Xm.h>

XmString XmStringCreate (text, tag)
     char      *text;
     char      *tag;
{/*          File 'motifutils.o'*/
#ifdef DEBUGXEMUL
  printf("XmStringCreate\n");
#endif
  
  return XmStringCreateLtoR(text,tag);
}

XIconSize *XAllocIconSize()
{/*          File 'magick/libMagick.lib' */
  XIconSize *xis=malloc(sizeof(XIconSize));
#ifdef DEBUGXEMUL
  printf("XAllocIconSize\n");
#endif
  return(xis);
}

XSizeHints *XAllocSizeHints()
{/*         File 'magick/libMagick.lib' */
  XSizeHints *xsh=malloc(sizeof(XSizeHints));
#ifdef DEBUGXEMUL
  printf("XAllocSizeHints\n");
#endif
  return(xsh);
}

XClassHint *XAllocClassHint()
{/*         File 'animate.o' */
  XClassHint *xch=malloc(sizeof(XClassHint));
#ifdef DEBUGXEMUL
  printf("XAllocClassHint\n");
#endif
  return(xch);
}

Widget XmCreateScrolledText (parent, name, arglist, argcount)
     Widget    parent;
     String    name;
     ArgList   arglist;
     Cardinal  argcount;
{/*    File 'monwin.o'*/
#ifdef DEBUGXEMUL
  printf("XmCreateScrolledText\n");
#endif
  Widget w;
  Object *text=ListviewObject,
    MUIA_Listview_Input, FALSE, 
    MUIA_Listview_List, FloattextObject,
      MUIA_Frame, MUIV_Frame_ReadList,
      MUIA_Floattext_Justify,TRUE,
    End,
  End;

  w=MakeWidget(parent,text);
  w->core.widget_class=X11_TEXTFIELD;
  return((Widget)w);
}

void XmTextSetString(Widget widget,char *value)
{/*         File 'tickwin.o'*/
#ifdef DEBUGXEMUL
  printf("XmTextSetString\n");
#endif
  if(!X11DrawablesMUI[X11DrawablesMap[(XID)widget->core.self]]) return 0;
  set(X11DrawablesMUI[X11DrawablesMap[(XID)widget->core.self]],MUIA_Floattext_Text, value);
  return(0);
}

Boolean XmToggleButtonGetState(Widget w){/*  File 'printwin.o'*/
  LONG val;
  Object *obj=X11DrawablesMUI[X11DrawablesMap[(XID)w->core.self]];
#ifdef DEBUGXEMUL
  printf("XmToggleButtonGetState\n");
#endif
  if(!obj) return FALSE;
  get(obj,MUIA_Selected,&val);
  return((int)val);
}

Boolean XmToggleButtonGadgetGetState(Widget w){/* File 'drawwin.o'*/
#ifdef DEBUGXEMUL
  printf("XmToggleButtonGadgetGetState\n");
#endif
  return(0);
}

void XmToggleButtonGadgetSetState(Widget w,int newstate,int notify)
{/* File 'fileswin.o'*/
#ifdef DEBUGXEMUL
  printf("XmToggleButtonGadgetSetState\n");
#endif
  return(0);
}

void XmToggleButtonSetState(Widget w,int newstate,int notify)
{/*  File 'printwin.o'*/
  Object *obj=X11DrawablesMUI[X11DrawablesMap[(XID)w->core.self]];
#ifdef DEBUGXEMUL
  printf("XmToggleButtonSetState\n");
#endif
  if(!obj) return;
  set(obj,MUIA_Selected,newstate);
}

Dimension XmStringHeight (fontlist, string)
     XmFontList fontlist;
     XmString  string;
{
  return NULL;
}

Dimension XmStringWidth (fontlist, string)
     XmFontList fontlist;
     XmString  string;
{
}

void XmGetColors (screen, colormap, background, foreground, top_shadow, bottom_shadow, select)
     Screen    * screen;
     Colormap  colormap;
     Pixel     background;
     Pixel     * foreground;
     Pixel     * top_shadow;
     Pixel     * bottom_shadow;
     Pixel     * select;
{
}

XmFontListEntry XmFontListNextEntry (context)
     XmFontContext context;
{
}

Widget XmOptionButtonGadget (option_menu)
     Widget    option_menu;
{
}

#endif /* XMUIAPP */
