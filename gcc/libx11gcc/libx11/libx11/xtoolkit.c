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
     Xtoolkit
   PURPOSE
     Xtoolkit functions to libX11
   NOTES
     
   HISTORY
     Terje Pedersen - Oct 23, 1994: Created.
***/

#ifdef NEEDXTOOLKIT

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

#include <assert.h>
#include <dos.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <varargs.h>
#include <time.h>
#include <stdio.h>

#include "libX11.h"

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/IntrinsicP.h>
#include <X11/Core.h>
#include <X11/CoreP.h>
#include <X11/StringDefs.h>

#include <X11/Xm/XmStrDefs.h>

#include <libraries/mui.h>
#include <proto/muimaster.h>

#include "libx11.h"

#include "x11display.h"
#include "x11events.h"

#undef memset

/*******************************************************************************************/
/* external */
extern char lookup_key(char *key);
extern int askmode;
extern struct DosLibrary *DOSBase;

extern int gettimeofday(struct timeval *tp,struct timezone *tzp);

/*******************************************************************************************/
/* internal */

static XtActionProc buttonfunc = 0,buttonfunckey[6];
static XtActionProc keyup = 0;
static XtActionList amiga_actions;
static Cardinal amiga_num_actions = 0;
static int curevent = 0;
static int amiga_wait = 0;
static int num_amiga_keys = 0;
static unsigned long amiga_interval = 0;
static char proctype[20];

Pixmap amiga_bitmap;

extern String *_XtFallbackResource;

typedef struct _TimerEventRec {
        struct timeval        te_timer_value;
	struct _TimerEventRec *te_next;
	Display		      *te_dpy;
	XtTimerCallbackProc   te_proc;
	XtAppContext	      app;
	XtPointer	      te_closure;
} TimerEventRec;

static TimerEventRec Xevs[20];
static XtTimerCallbackProc procs[20];
static XtPointer datas[20];
static ULONG Xt_interval[20];

typedef struct {
  int key;
  XtActionProc proc;
}  amiga_table;

static amiga_table akeys[40];

XtAppContext  amiga_Context;
Display       *amiga_Disp;
struct _WidgetRec amigaWG;
struct _WidgetRec *a_wid;
struct _WidgetRec *app_wg;

static XEvent event;

static char applicationname[40];

/*******************************************************************************************/
/*
ULONG askscreenmode(void);

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

ULONG
askscreenmode()
{
  struct ScreenModeRequester *modereq;

  if(!(modereq =
       AllocAslRequestTags(ASL_ScreenModeRequest,ASLSM_DoDepth,TRUE,ASLSM_DoHeight,TRUE,ASLSM_DoWidth,TRUE,ASLSM_DoOverscanType,TRUE,ASLSM_DoAutoScroll,TRUE,/*ASLSM_TitleText,title,*/ASLSM_InitialTopEdge,0,ASLSM_InitialHeight,512,ASLSM_InitialDisplayDepth,DG.nDisplayDepth,ASLSM_InitialDisplayWidth,DG.nDisplayWidth,ASLSM_InitialDisplayHeight,DG.nDisplayHeight,ASLSM_InitialDisplayID,DG.X11ScreenID,/*ASLSM_Window,wnd,*/TAG_DONE))){
    return(0);
  }
  if(!modereq)
    return(0);
  else
    AslRequest (modereq,0L);
  DG.X11ScreenID = modereq->sm_DisplayID;
  DG.nDisplayDepth = modereq->sm_DisplayDepth;
  if( DG.nDisplayDepth>DG.nDisplayMaxDepth )
    DG.nDisplayMaxDepth = DG.nDisplayDepth;
  if( modereq->sm_DisplayWidth>DG.nDisplayMaxWidth )
    DG.nDisplayMaxWidth = modereq->sm_DisplayWidth;
  if( modereq->sm_DisplayHeight>DG.nDisplayMaxHeight )
    DG.nDisplayMaxHeight = modereq->sm_DisplayHeight;

  FreeAslRequest (modereq);

  return((ULONG)DG.X11ScreenID);
}
*/

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XtShellStrings()
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XtShellStrings\n");
#endif

  return(0);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void __stdargs
_XtCheckSubclass( Widget w,
		  WidgetClass object_class,
		  String message )
{
}


Boolean 
_XtCheckSubclassFlag(Widget w, _XtXtEnum object)
{
  return FALSE;
}

#undef XtWindow
/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Window
XtWindow(Widget w)
{
  return((((struct _WidgetRec*)w)->core.window));
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

int
X11addresources( XrmOptionDescRec *options,
		 Cardinal num_options,
		 int *argc,String *argv,
		 char *class )
{
  int i,a,found=0;
  XrmValue value;
  XrmDatabase db;

  db=XtDatabase(amiga_Disp);
  for( a=0; a<*argc; a++ ){
    for( i=0; i<num_options; i++ ){
      if( !strncmp(argv[a],options[i].option,strlen(argv[a])) ){
	char tempname[120];

	strcpy(tempname,applicationname);
	strcat(tempname,options[i].specifier);
	if( !(options[i].argKind==XrmoptionNoArg) ){
	  if( a==*argc-1 )
	    printf("missing argument!\n");
	  else {
	    value.addr=argv[++a];
	    XrmPutResource(&db,tempname,(char const*)options[i].argKind,&value);
	    found++;
	  }
	} else {
	  value.addr=options[i].value;
	  XrmPutResource(&db,tempname,(char const*)options[i].argKind,&value);
	}
	found++;
      }
    }
  }
  {
    extern XrmDatabase X11DefaultResources;
    X11DefaultResources=db;
  }
  *argc-=found;
  for( i=0; i<*argc; i++ )
    argv[i]=argv[found+i];
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Display *
XtOpenDisplay( XtAppContext app_context, 
	       _Xconst _XtString display_name,
	       _Xconst _XtString application_name,
	       _Xconst _XtString application_class,
	       XrmOptionDescRec* options,
	       Cardinal num_options,
	       int *argc,         /* was Cardinal * in Release 4 */
	       String *argv )
{
#ifdef DEBUGXEMUL_ENTRY
  printf("(Xtoolkit)XtOpenDisplay\n");
#endif
  amiga_Disp=XOpenDisplay(display_name);
#ifdef XMUIAPP
  X11mui_init();
#endif

  return(amiga_Disp);
}

Object *X11appobj,*X11appwin,*X11appgrp,*X11menustrip;

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
XtCloseDisplay( Display* display )
{
#ifdef DEBUGXEMUL_ENTRY
  printf("(Xtoolkit)XtCloseDisplay\n");
#endif
#ifdef XMUIAPP 
  MUI_DisposeObject(X11appobj);
  X11mui_cleanup();
#endif
  XCloseDisplay(display);

  return;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XtActionProc
lookup_func( char* func )
{
  int i;

  for( i=0; i<amiga_num_actions; i++ )
    if( !strcmp(func,amiga_actions[i].string) )
      return(amiga_actions[i].proc);

  return(NULL);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

ParseKeys( _Xconst _XtString table )
{
  char *p=strstr(table,"<Key>");

  while( p ){
    char *q,*r;
    char key[20],func[40];

    p=p+5;
    q=strchr(p,':');
    *q++=0;
    strcpy(key,p);
    r=strchr(q,'(');
    *r=0;
    q=strrchr(q,'\t');
    *q++=0;
    strcpy(func,q);
    p=strstr(r+1,"<Key>");

    if( num_amiga_keys<40 ){
      akeys[num_amiga_keys].proc=lookup_func(func);
      if( strlen(key)==1 )
	akeys[num_amiga_keys].key=key[0];
      else
	akeys[num_amiga_keys].key=Events_LookupKey(key);
/*      printf("(Xtoolkit)key [%s] func [%s] [%d]\n",key,func,akeys[num_amiga_keys].proc);*/
      num_amiga_keys++;
    } else
      printf("(Xtoolkit)actions overflow!\n");
  }
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XtActionProc
getfunc( char *ptr )
{
  char *q=strchr(ptr,':')+1,*p;
  XtActionProc func;

  while( !isalpha(*q) ) q++;
  if( (p=strchr(q,'(')) ) *p=0;
  func=lookup_func(q);
  if( p ) *p='(';

  return(func);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XtTranslations
XtParseTranslationTable( _Xconst _XtString table )
{
  char *ptr;

#ifdef DEBUGXEMUL_ENTRY
  printf("(Xtoolkit)XtParseTranslationTable\n");
#endif

  if( strstr(table,"<Key>") )
    ParseKeys(table);
  if( (ptr=strstr(table,"<ButtonPress>")) ){
    buttonfunc=getfunc(ptr);
  }
  if( (ptr=strstr(table,"<Btn1Down>")) )
    buttonfunckey[0]=getfunc(ptr);
  if( (ptr=strstr(table,"<Btn1Up>")) )
    buttonfunckey[1]=getfunc(ptr);
  if( (ptr=strstr(table,"<Btn2Down>")) )
    buttonfunckey[2]=getfunc(ptr);
  if( (ptr=strstr(table,"<Btn2Up>")) )
    buttonfunckey[3]=getfunc(ptr);
  if( (ptr=strstr(table,"<Btn3Down>")) )
    buttonfunckey[4]=getfunc(ptr);
  if( (ptr=strstr(table,"<Btn3Up>")) )
    buttonfunckey[5]=getfunc(ptr);

  if((ptr=strstr(table,"<KeyUp>"))){
    keyup=getfunc(ptr);
  }
  
  return(0);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtAppAddActions(app_context, actions, num_actions)
     XtAppContext app_context;
     XtActionList actions;
     Cardinal num_actions;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("(Xtoolkit)XtAppAddActions\n");
#endif
  amiga_actions=actions;
  amiga_num_actions=num_actions;
  return;
}

struct timeval Xt_time[20],Xt_time2;

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtAppNextEvent(app, xevent)
	XtAppContext app;
	XEvent *xevent;
{
  int i,gotone=0;
  long t2;
  xevent->type=0;
  xevent->xkey.keycode=0;
  gettimeofday(&Xt_time2,0);
  t2=(long)(Xt_time2.tv_sec*1000+Xt_time2.tv_usec/1000);
  while( Events_Get(xevent) && !gotone ){
    if(xevent->type==KeyPress){
      char buf[20];
      KeySym k;
      XLookupString((XKeyEvent *)xevent,buf,20,&k,NULL);
      if(!keyup){
/*	printf("adding 0 key event %d\n",xevent->xbutton.button);*/
	for(i=0;i<num_amiga_keys;i++)
	  if(buf[0]==akeys[i].key){
/*	    printf("adding key [%c]\n\n",buf[0]);*/
	    XtAppAddTimeOut(app,0,(XtTimerCallbackProc)akeys[i].proc,NULL);
	    proctype[curevent-1]=1;
	    gotone=1;
	    break;
	  }
      }else{
/*	printf("adding 1 key event %d\n",xevent->xbutton.button);*/
	XtAppAddTimeOut(app,0,(XtTimerCallbackProc)keyup,&xevent->xkey);
	gotone=1;
	proctype[curevent-1]=1;
      }
    }else if(xevent->type==ButtonPress){
/*      printf("adding mouse event %d\n",xevent->xbutton.button);*/
      if(buttonfunc)
	XtAppAddTimeOut(app,0,(XtTimerCallbackProc)buttonfunc,&xevent->xbutton);
      else{
	switch(xevent->xbutton.button){
	case 1: 
	  XtAppAddTimeOut(app,0,(XtTimerCallbackProc)buttonfunckey[0],&xevent->xbutton);
	  break;
	case 2: 
	  XtAppAddTimeOut(app,0,(XtTimerCallbackProc)buttonfunckey[2],&xevent->xbutton);
	  break;
	case 3: 
	  XtAppAddTimeOut(app,0,(XtTimerCallbackProc)buttonfunckey[4],&xevent->xbutton);
	  break;
	}
      }
      gotone=1;
      proctype[curevent-1]=1;
    }
  }
  amiga_wait = 0;
  if(curevent>0){
    long t1;
    int oldest=-1,i;
    long oldesttime=Xt_time[curevent-1].tv_sec;
    Widget w=NULL;
nextev:
    curevent--;
/*    printf("events %d\n",curevent);*/
    if(curevent>0){
      for(i=0;i<=curevent;i++){
/*	printf("testing %d %d\n",i,Xt_time[i].tv_sec);*/
	if(Xt_time[i].tv_sec<oldesttime){ 
	  oldesttime=Xt_time[i].tv_sec; oldest=i;
/*	  printf("ok older!\n");*/
	}
      }
      if(oldest!=-1){
	XtTimerCallbackProc p;
	XtPointer d;
	struct timeval t;
/*	printf("not last (i %d last %d)!\n",oldest,curevent);*/
	p=procs[curevent];   procs[curevent]=procs[oldest];     procs[oldest]=p;
	d=datas[curevent];   datas[curevent]=datas[oldest];     datas[oldest]=d;
	t=Xt_time[curevent]; Xt_time[curevent]=Xt_time[oldest]; Xt_time[oldest]=t;
      }
    }
    t1=(long)(Xt_time[curevent].tv_sec*1000+Xt_time[curevent].tv_usec/1000);
    /*    printf("diff %d interval %d delaying %d\n",t2-t1,Xt_interval[curevent],
	  Xt_interval[curevent]-(t2-t1));*/
    if(t2-t1<Xt_interval[curevent]){
      long d=(int)((Xt_interval[curevent]-(t2-t1))/*/20*/);
      if(d>1){
	X11delayfor(0,d);
      }
/*      else printf("delay %d ?\n",d);*/
    }
    if(!procs[curevent]){
/*
      printf("fatal error! can't call 0 !\n");
      getchar();
*/
      if(curevent>0) goto nextev;
      else return;
    }
    if(proctype[curevent]){
/*      printf("calling type 1\n");*/
      ((__stdargs XtActionProc)procs[curevent])(w,(XEvent *)datas[curevent],NULL,(Cardinal*)&amiga_interval);
    }
    else{
/*      printf("calling type 2 (%d)\n",procs[curevent]);*/
      ((__stdargs XtTimerCallbackProc)procs[curevent])((XtPointer)datas[curevent],(XtIntervalId*)&amiga_interval);
    }
  } else
    amiga_wait = 1;
}


/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XtIntervalId XtAppAddTimeOut(app_context, interval, proc, client_data)
     XtAppContext app_context;
     unsigned long interval;
     XtTimerCallbackProc proc;
     XtPointer client_data;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("(Xtoolkit)XtAppAddTimeOut interval %d event no %d\n",interval,curevent);
#endif
  if(curevent<20){
/*    printf("adding event %d %d\n",proc,client_data);*/
    procs[curevent]=proc;
    datas[curevent]=client_data;

    gettimeofday(&Xt_time[curevent],0);
/*    printf("time %d\n",Xt_time[curevent].tv_sec);*/
    Xt_interval[curevent]=interval;
/*    printf("interval %d\n",interval);*/
    proctype[curevent]=0;
    curevent++;
  } /* else printf("(Xtoolkit)event overflow!\n");*/
  return(0);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtAppMainLoop(app_context)
     XtAppContext app_context;
{
#ifndef XTMUI
#ifdef DEBUGXEMUL_ENTRY
  printf("(Xtoolkit)XtAppMainLoop\n");
#endif
/* add the expose event */
  XtAppAddTimeOut(app_context,0,(XtTimerCallbackProc)amiga_actions[0].proc,NULL);
  memset(&event,0,sizeof(XEvent));
  for (;;) {
    XtAppNextEvent(app_context, &event);
/*    XtDispatchEvent(&event);*/
    if( amiga_wait ){
      Wait(EG.fwindowsig);
      amiga_wait = 0;
    }

  }
#else
  ULONG sigs;
  int running=1;

  set(X11appwin,MUIA_Window_Open,TRUE);
  while (running){
    int mui_input;
    mui_input = DoMethod(X11appobj,MUIM_Application_Input,&sigs);
    switch ( mui_input ){
    case MUIV_Application_ReturnID_Quit: 
      running =0 ;
      break;
    }
    if (running && sigs) Wait(sigs);
  }
  set(X11appwin,MUIA_Window_Open,FALSE);
#endif /* XTMUI */
  return;
}

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

extern struct NewMenu MenuData1[];

#ifndef XTMUI
/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Widget XtAppCreateShell(application_name, application_class,
			widget_class, display, args, num_args)
     _Xconst _XtString application_name;
     _Xconst _XtString application_class;
     WidgetClass widget_class;
     Display *display;
     ArgList args;
     Cardinal num_args;
{
  Window newwin=0;
  int i,gotsize=0;
/*  Widget wid=(Widget)malloc(sizeof(Widget));*/
#ifdef DEBUGXEMUL_ENTRY
  printf("(Xtoolkit)XtAppCreateShell [%d]\n",sizeof(Arg));
#endif

  a_wid=&amigaWG;
  for(i=0;i<num_args;i++){
/*    printf("(Xtoolkit)arg[%d] %s=%d\n",i,args[i].name,args[i].value);*/
    if(!strcmp(args[i].name,"maxWidth")||!strcmp(args[i].name,"Width")){
      gotsize=1;
      DG.nDisplayWidth=(int)(args[i].value);
    }else if(!strcmp(args[i].name,"maxHeight")||!strcmp(args[i].name,"Height")){
      DG.nDisplayHeight=(int)(args[i].value);
    }else if(strcmp(args[i].name,"depth")==0){
      DG.nDisplayDepth=(int)(args[i].value);
    }
  }
#if 0
  if( DG.nDisplayWidth>1280 )
    wbapp=1;
#endif
  if(gotsize)
    if( !DG.vUseWB ){
      ULONG id=0;
      extern int X11windepth;
/*      if(askmode) id=askscreenmode();*/
#if 0
       newwin=AmigaCreateWindow(DG.nDisplayWidth,DG.nDisplayHeight,DG.nDisplayDepth,0,id);
#else
      X11windepth = DG.nDisplayDepth;
      newwin = XCreateSimpleWindow(display,DG.X11Screen[0].root,0,0,DG.nDisplayWidth,DG.nDisplayHeight,0,0,0);
#endif
      ((struct _WidgetRec*)a_wid)->core.window=newwin;
    }
  ((struct _WidgetRec*)a_wid)->core.screen  =&DG.X11Screen[0];
  ((struct _WidgetRec*)a_wid)->core.name = application_name;
  XSelectInput (&DG.X11Display, newwin, KeyPressMask | KeyReleaseMask | ButtonPressMask | ButtonReleaseMask);
#ifdef XMUIAPP
  {
    Widget w;
    X11appwin=WindowObject,
      MUIA_Window_Title, "Application root",
      MUIA_Window_ID, MAKE_ID('A', 'P', 'P', 'R'),
      MUIA_Window_Menustrip, X11menustrip = MUI_MakeObject(MUIO_MenustripNM,MenuData1,0),
      WindowContents, X11appgrp=GroupObject,
      End,
    End;

    X11appobj=ApplicationObject,
      MUIA_Application_Author, "NONE",
      MUIA_Application_Base, application_name,
      MUIA_Application_Title, application_name,
      MUIA_Application_Version, "$VER: 0.07 ",
      MUIA_Application_Copyright, "libX11 generated",
      MUIA_Application_Description, "Something cool..",
    SubWindow, X11appwin,
    End;
    w=MakeWidget(NULL,X11appgrp);
    w->core.screen=DefaultScreenOfDisplay(display);
    w->core.window=X11NewMUI(X11appwin);
/*    w->core.self=X11NewMUI(X11appobj);*/
    DoMethod(X11appwin, MUIM_Notify, MUIA_Window_CloseRequest, TRUE, X11appobj, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);
    return(w);
  }
#else
  return((struct _WidgetRec*)a_wid);
#endif
}

#endif

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

applicationShellWidgetClass()
{
#ifdef DEBUGXEMUL_ENTRY
  printf("(Xtoolkit)applicationShellWidgetClass\n");
#endif
  return(0);
}

char *dotdisp=".display";
char *workbenchstr="Workbench";
#ifndef XTMUI

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

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
  int i,found=0;
  XrmDatabase db;
  XrmValue value;
  char *display_name=NULL;
  char appdisp[50];
#ifdef DEBUGXEMUL_ENTRY
  printf("(Xtoolkit)XtAppInitialize\n");
#endif
  XtToolkitInitialize();
  XrmInitialize();
  strcpy(applicationname,application_class /*argv_in_out[0]*/);
  strcpy(appdisp,application_class);
  strcat(appdisp,".display");
  amiga_Context = XtCreateApplicationContext();

  _XtFallbackResource=fallback_resources;
  db=XtDatabase(amiga_Disp);

  X11addresources(options,num_options,argc_in_out,argv_in_out,application_class);
  db=XtDatabase(amiga_Disp);
  if(!XrmGetResource(db,dotdisp,NULL,NULL,&value)){
    value.addr=workbenchstr;
    XrmPutResource(&db,dotdisp,NULL,&value);
  }
  for(i=1;i<*argc_in_out;i++){
    if(XrmGetResource(db,argv_in_out[i],NULL,NULL,&value)){
      argv_in_out[i][0]='.';
      value.addr=argv_in_out[++i];
      XrmPutResource(&db,argv_in_out[i-1],NULL,&value);
      found+=2;
    }
  }
  X11DefaultResources=db;
  *argc_in_out-=found;
  if(XrmGetResource(XtDatabase(&DG.X11Display),appdisp,NULL,NULL,&value))
    display_name=value.addr;
  else
    if(XrmGetResource(XtDatabase(&DG.X11Display),dotdisp,NULL,NULL,&value))
      display_name=value.addr;
    
  amiga_Disp = XtOpenDisplay(amiga_Context, display_name, application_class,NULL,options,num_options,argc_in_out,argv_in_out);
  app_wg = XtAppCreateShell(application_class,application_class, 0 /*applicationShellWidgetClass*/, 
                         amiga_Disp, args, num_args);
  return(app_wg);
}

#endif

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtGetApplicationResources(object, base, resources, num_resources,
			       args, num_args)
     Widget object;
     XtPointer base;
     XtResourceList resources;
     Cardinal num_resources;
     ArgList args;
     Cardinal num_args;
{
  XrmValue value;
  XrmDatabase db;
  int i,found;
  void *addr;
  char *appname,tempname[256];
#ifdef DEBUGXEMUL_ENTRY
  printf("XtGetApplicationResources\n");
#endif
  XrmInitialize();
  db=XtDatabase(amiga_Disp);
  appname=((struct _WidgetRec*)object)->core.name;
  for(i=0;i<num_resources;i++){
    int immediate=0;
    char *dest=(char*)base+resources[i].resource_offset;
    found=0;
    strcpy(tempname,appname);
    strcat(tempname,".");
    strcat(tempname,resources[i].resource_name);
    if(strcmp(resources[i].default_type,XtRImmediate)==0) immediate=1;
//    if(strcmp(resources[i].default_type,XtRBoolean)==0) immediate=1;
    if(XrmGetResource(db,tempname,NULL,NULL,&value)){
      addr=(void*)value.addr;
      found=1;
/*
      immediate=1;
      if(immediate){
*/
	if(strcmp(resources[i].resource_type,"Int")==0)
	  *((int*)dest)=atoi((char*)addr);
	else if(strcmp(resources[i].resource_type,"Boolean")==0){
	  if(stricmp((char*)addr,"False")==0||
	     stricmp((char*)addr,"No")==0) *((char*)(dest))=0;
	  else *((char*)(dest))=1;
	} else if(strcmp(resources[i].resource_type,"String")==0){
	  *(int*)((char*)base+resources[i].resource_offset)=(int*)addr;
	} else if(strcmp(resources[i].resource_type,XtRFloat)==0){
	  *((float*)((char*)base+resources[i].resource_offset))=atof((char const*)addr);
	}
/*
      }else {
	if(strcmp(resources[i].resource_type,"Int")==0)
	  *((int*)(dest))=*(int*)addr;
	else if(strcmp(resources[i].resource_type,"Boolean")==0){
	  *((char*)(dest))=*(char*)addr;
	} else if(strcmp(resources[i].resource_type,"String")==0){
	  *(int*)((char*)base+resources[i].resource_offset)=(int*)addr;
	} else if(strcmp(resources[i].resource_type,XtRFloat)==0){
	  *((float*)((char*)base+resources[i].resource_offset))=*(float*)addr;
	}
      }
*/ 
    }
    else{
/*      int data=0;*/
      addr=(void*)resources[i].default_addr;
/*      if(!addr && !immediate ) addr= &data;*/
      if( immediate ){
	if(strcmp(resources[i].resource_type,"Int")==0){
	  *((int*)((char*)base+resources[i].resource_offset))=(int)addr;
	} else if(strcmp(resources[i].resource_type,"Boolean")==0){
	  *((char*)((char*)base+resources[i].resource_offset))=(char)addr;
	} /* else if(strcmp(resources[i].resource_type,"String")==0){
	  *(int*)((char*)base+resources[i].resource_offset)=(int)addr;
	} else if(strcmp(resources[i].resource_type,XtRFloat)==0){
	  *((float*)((char*)base+resources[i].resource_offset))=*(float*)addr;
	}*/
      } else {
	if(strcmp(resources[i].resource_type,"Int")==0){
	  *((int*)((char*)base+resources[i].resource_offset))=*(int*)addr;
	} else if(strcmp(resources[i].resource_type,"Boolean")==0){
	  *((char*)((char*)base+resources[i].resource_offset))=*(char*)addr;
	} else if(strcmp(resources[i].resource_type,"String")==0){
	  *(int*)((char*)base+resources[i].resource_offset)=(int*)addr;
	} else if(strcmp(resources[i].resource_type,XtRFloat)==0){
	  *((float*)((char*)base+resources[i].resource_offset))=*(float*)addr;
	}
      }     
    }
  }

  return;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Boolean XtDispatchEvent (event)
    XEvent  *event;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtDispatchEvent\n");
#endif
  return(False);
}

#ifndef XTMUI
/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtRealizeWidget(w)
     Widget w;
{
  LONG l;
#ifdef XMUIAPP
  assert(w);
  get(X11DrawablesMUI[(XID)w->core.window],MUIA_Window_Open,&l);
  if(!l)
    set(X11DrawablesMUI[(XID)w->core.window],MUIA_Window_Open,TRUE);
#else
  XrmValue value;
  extern int usewb;
  Window newwin;
#ifdef DEBUGXEMUL_ENTRY
  printf("XtRealizeWidget\n");
#endif
  DG.vUseWB = 1;
  DG.Scr = DG.wb;
  X11init_cmaps();
  newwin=AmigaCreateWindow(DG.nDisplayWidth,DG.nDisplayHeight,DG.nDisplayDepth,0,0);
  ((struct _WidgetRec*)a_wid)->core.window=newwin;
    
  if(XrmGetResource(XtDatabase(&DG.X11Display),".title",NULL,NULL,&value)){
    XStoreName(&DG.X11Display,newwin,value.addr);
  }
  return;
#endif
}

#endif

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtToolkitInitialize()
{
#ifdef DEBUGXEMUL
  printf("XtToolkitInitialize\n");
#endif
  return;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XtAppContext XtCreateApplicationContext()
{
#ifdef DEBUGXEMUL
  printf("XtCreateApplicationContext\n");
#endif
  return(0);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XtStrings()
{
#ifdef DEBUGXEMUL
  printf("XtStrings\n");
#endif
  return(0);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

#ifndef XTMUI
void XtAddEventHandler(w, event_mask, nonmaskable, proc, client_data)
     Widget w;
     EventMask event_mask;
     Boolean nonmaskable;
     XtEventHandler proc;
     XtPointer client_data;
{/*       File 'xmgr.o'*/
#ifdef DEBUGXEMUL
  printf("XtAddEventHandler\n");
#endif
  return;
}
#endif
/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtAddCallback(object, callback_name, callback, client_data)
     Widget object;
     _Xconst _XtString callback_name;
     XtCallbackProc callback;
     XtPointer client_data;
{/*           File 'xmgr.o'*/
#ifdef DEBUGXEMUL
  printf("XtAddCallback\n");
#endif
  return;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtAddGrab(w, exclusive, spring_loaded)
     Widget w;
     Boolean exclusive;
     Boolean spring_loaded;
{/*               File 'malerts.o'*/
#ifdef DEBUGXEMUL
  printf("XtAddGrab\n");
#endif
  return;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XtInputMask XtAppPending(app_context)
     XtAppContext app_context;
{/*            File 'malerts.o'*/
#ifdef DEBUGXEMUL
  printf("XtAppPending\n");
#endif
  return(0);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtAppProcessEvent(app_context, mask)
     XtAppContext app_context;
     XtInputMask mask;
{/*       File 'motifutils.o'*/
#ifdef DEBUGXEMUL
  printf("XtAppProcessEvent\n");
#endif
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtFree(ptr)
char *ptr;
{/*                  File 'fileswin.o'*/
#ifdef DEBUGXEMUL
  printf("XtFree\n");
#endif
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtGetValues(wid, args, num_args)
     Widget wid;
     ArgList args;
     Cardinal num_args;
{/*             File 'events.o'*/
  int i;
  Object *obj;
  XID object;
#ifdef DEBUGXEMUL
  printf("XtGetValues\n");
#endif

  if(!wid) return;
  object=(XID)wid->core.self;
  if(X11Drawables[object]!=X11MUI) return;
  obj=X11DrawablesMUI[X11DrawablesMap[object]];
  for(i=0;i<num_args;i++){
    unsigned short *ptr=(unsigned short*)(args[i].value);
/*    printf("%d\n",args[i].value);*/
    *ptr=0;
    if(strcmp(args[i].name,XtNwidth)==0){
      *ptr=(unsigned short)_mwidth(obj);
    }else if(strcmp(args[i].name,XtNheight)==0){
      *ptr=(unsigned short)_mheight(obj);
    }
/*    printf("value %s set to %d\n",args[i].name,*ptr);*/
  }
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

char *XtMalloc(size)
Cardinal size;
{/*                File 'helpwin.o'*/
#ifdef DEBUGXEMUL
  printf("XtMalloc\n");
#endif
  return((char*)malloc(size));
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtRemoveGrab(w)
     Widget w;
{/*            File 'malerts.o'*/
#ifdef DEBUGXEMUL
  printf("XtRemoveGrab\n");
#endif
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtSetValues(object, args, num_args)
     Widget object;
     ArgList args;
     Cardinal num_args;
{
  int i;
#ifdef DEBUGXEMUL
  printf("XtSetValues\n");
#endif
  return;

  for( i=0; i<num_args; i++ ){
    if(strcmp(args[i].name,XtNwidth)==0){
      DG.nDisplayWidth=args[i].value;
    }else if(strcmp(args[i].name,XtNheight)==0){
      DG.nDisplayHeight=args[i].value;
    }else if(strcmp(args[i].name,XtNbackgroundPixmap)==0){
      amiga_bitmap=args[i].value;
    }
  }
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Widget XtVaCreateManagedWidget(name, widget_class, parent,args,num_args)
     _Xconst _XtString name;
     WidgetClass widget_class;
     Widget parent;
     ArgList args;
     Cardinal num_args;
{/* File 'xmgr.o'*/
#ifdef DEBUGXEMUL
  printf("XtVaCreateManagedWidget\n");
#endif
  return(NULL);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Widget XtVaCreateWidget(name, object_class, parent,args,num_args)
     _Xconst _XtString name;
     WidgetClass object_class;
     Widget parent;
     ArgList args;
     Cardinal num_args;
{/*        File 'labelwin.o'*/
#ifdef DEBUGXEMUL
  printf("XtVaCreateWidget\n");
#endif
  return(0);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtVaSetValues(Widget object,... )
{
/*
  va_list arglist;
  int count;
  char *argstr;
  int argval;
  BOOL bGotOne=TRUE;
  Object *obj;

  va_start(arglist,count);
  
  while(bGotOne){
    argstr=va_arg(arglist,char *);
    if(!argstr) bGotOne=FALSE;
    else argval=va_arg(arglist,int);
    if(!strcmp(argstr,XmNwidth)){
      obj=X11DrawablesMUI[X11DrawablesMap[(XID)object->core.self]];
      set(obj,MUIA_FixWidth,argval);
    } else if(!strcmp(argstr,XmNheight)){
      obj=X11DrawablesMUI[X11DrawablesMap[(XID)object->core.self]];
      set(obj,MUIA_FixHeight,argval);
    }
  }
*/
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtWarning(message)
     _XtString message;
{/*               File 'xmgr.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtWarning\n");
#endif
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XtAppContext XtWidgetToApplicationContext(object)
     Widget object;
{/* File 'motifutils.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtWidgetToApplicationContext\n");
#endif
  return(0);
}

#ifndef XTMUI

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtDestroyWidget(object)
     Widget object;
{/*         File 'xdaliclock.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtDestroyWidget\n");
#endif
  return;
}
#endif

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtGetApplicationNameAndClass(display,name_return,class_return)
     Display *display;
     String  *name_return;
     String  *class_return;
{/* File 'xdaliclock.o'*/
#ifdef DEBUGXEMUL_ENTERY
  printf("XtGetApplicationNameAndClass\n");
#endif
  *name_return=applicationname;
  return;
}

#undef XtParent

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Widget XtParent(Widget widget){
  if(widget) return(widget->core.parent);
  else return NULL;
}

#undef XtScreen

Screen *XtScreen(Widget widget){
  if(widget)return(widget->core.screen);
  else return NULL;
}

#undef XtDisplay

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Display *XtDisplay(Widget widget){
  if(widget) return(DisplayOfScreen(widget->core.screen));
  else return NULL;
}


/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

GC XtGetGC(object, value_mask, values)
     Widget object;
     XtGCMask value_mask;
     XGCValues *values;
{/*                 File 'xlogo.o'*/
#ifdef DEBUGXEMUL_ENTERY
  printf("XtGetGC\n");
#endif
  return(XCreateGC(NULL,NULL,value_mask,values));
}

/*

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/
XtCreateManagedWidget(){/*   File 'xlogo.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtCreateManagedWidget\n");
#endif

  return(0);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Widget XtInitialize(shell_name, application_class, options,
		    num_options, argc, argv)
     String shell_name;    /* unused */
     String application_class;
     XrmOptionDescRec options[];
     Cardinal num_options;
     Cardinal *argc;
     char *argv[];

{/*            File 'xlogo.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XtInitialize\n");
#endif

  return(XtAppInitialize(NULL,application_class,options,num_options,NULL,NULL,NULL,NULL,NULL));
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XtMainLoop()
{/*              File 'xlogo.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XtMainLoop\n");
#endif
  XtAppMainLoop(amiga_Context);

  return(0);
}
*/


/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Window XtWindowOfObject(object)
     Widget object;
{/*        File 'xlogo.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtWindowOfObject\n");
#endif
  return(0);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XtInputId XtAppAddInput(app_context, source, condition, proc, client_data)
     XtAppContext app_context;
     int source;
     XtPointer condition;
     XtInputCallbackProc proc;
     XtPointer client_data;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtAppAddInput\n");
#endif
  return (XtInputId)0;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtRemoveInput(id)
     XtInputId id;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtRemoveInput\n");
#endif
}


/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtDestroyApplicationContext(app_context)
     XtAppContext app_context;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtDestroyApplicationContext\n");
#endif
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

int _XtInheritTranslations;

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtCreateWindow(app_context)
     XtAppContext app_context;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtCreateWindow\n");
#endif
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtRemoveAllCallbacks(app_context)
     XtAppContext app_context;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtRemoveAllCallbacks\n");
#endif
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void XtPopupSpringLoaded(app_context)
     XtAppContext app_context;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtPopupSpringLoaded\n");
#endif
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

#ifndef XTMUI
Widget XtCreateManagedWidget(
    _Xconst _XtString 	name,
    WidgetClass 	widget_class,
    Widget 		parent,
    ArgList 		args,
    Cardinal 		num_args
)
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtCreateManagedWidget\n");
#endif
}
#endif

#endif /* NEEDXTOOLKIT */
