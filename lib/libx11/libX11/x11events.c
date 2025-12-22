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
     events
   PURPOSE
     add eventhandling to libX11
   NOTES
     
   HISTORY
     Terje Pedersen - Oct 23, 1994: Created.
***/

#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>

#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <graphics/displayinfo.h>
#include <devices/timer.h>
#include <devices/keymap.h>
#include <devices/inputevent.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/gadtools.h>
#include <proto/layers.h>
#include <proto/keymap.h>

#include <dos.h>
#include <signal.h>
#include <stdlib.h>
#include <time.h>
#include <stdio.h>

#include "libX11.h"
#define DEBUGXEMUL_WARNING 1

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>

#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/IntrinsicP.h>
#include <X11/CoreP.h>
#define XK_MISCELLANY
#include <X11/keysymdef.h>

#include "amigax_proto.h"
#include "amiga_x.h"

/* external */
extern Display amigaX_display;
extern Visual  amiga_visual;
extern Screen  amiga_screen[];

extern struct Library *KeymapBase;

/* internal */

EventGlobals_s EG;

#define	BUFFERLEN	80
char X11Abuffer[BUFFERLEN];

/* internal prototypes */

void ALookupKey(struct IntuiMessage *im);
char lookup_key(char *key);
void amiga_get_event(void);
int handle_buttons(XEvent *event,int code);

/*
short XKeys[]={

          /* 0 */ 0,
	  /* 1 */ 0,
	  /* 2 */ 0,
	  /* 3 */ 0,
	  /* 4 */ 0,
	  /* 5 */ 0,
	  /* 6 */ 0,
	  /* 7 */ 0,
	  /* 8 */ XK_BackSpace,
	  /* 9 */ XK_Tab,
	  /* 10 */ XK_Linefeed,
	  /* 11 */ XK_Clear,
	  /* 12 */ XK_Return,
	  /* 13 */ XK_Pause,
	  /* 14 */ XK_Scroll_Lock,
	  /* 15 */ XK_KP_0,
	  /* 16 */ XK_Q,
	  /* 17 */ XK_W,
	  /* 18 */ XK_E,
	  /* 19 */ XK_R,
	  /* 20 */ XK_T,
	  /* 21 */ XK_Y,
	  /* 22 */ XK_U,
	  /* 23 */ XK_I,
	  /* 24 */ XK_O,
	  /* 25 */ XK_P,
	  /* 26 */ XK_bracketleft,
	  /* 27 */ XK_bracketright,
	  /* 28 */ 0,
	  /* 29 */ XK_KP_1,
	  /* 30 */ XK_KP_2,
	  /* 31 */ XK_KP_3,
	  /* 32 */ XK_A,
	  /* 33 */ XK_S,
	  /* 34 */ XK_D,
	  /* 35 */ XK_F,
	  /* 36 */ XK_G,
	  /* 37 */ XK_H,
	  /* 38 */ XK_J,
	  /* 39 */ XK_K,
	  /* 40 */ XK_L,
	  /* 41 */ 0,
	  /* 42 */ 0,
	  /* 43 */ 0,
	  /* 44 */ 0,
	  /* 45 */ XK_KP_4,
	  /* 46 */ XK_KP_5,
	  /* 47 */ XK_KP_6,
	  /* 48 */ 0,
	  /* 49 */ XK_Z,
	  /* 50 */ XK_X,
	  /* 51 */ XK_C,
	  /* 52 */ XK_V,
	  /* 53 */ XK_B,
	  /* 54 */ XK_N,
	  /* 55 */ XK_M,
	  /* 56 */ 0,
	  /* 57 */ 0,
	  /* 58 */ 0,
	  /* 59 */ 0,
	  /* 60 */ XK_KP_Decimal,
	  /* 61 */ XK_KP_7,
	  /* 62 */ XK_KP_8,
	  /* 63 */ XK_KP_9,
	  /* 64 */ 0,
	  /* 65 */ 0,
	  /* 66 */ 0,
	  /* 67 */ XK_KP_Equal,
	  /* 68 */ 0,
	  /* 69 */ XK_Escape,
	  /* 70 */ 0,
	  /* 71 */ 0,
	  /* 72 */ 0,
	  /* 73 */ 0,
	  /* 74 */ XK_PK_Substract,
	  /* 75 */ 0,
	  /* 76 */ 0,
	  /* 77 */ 0,
	  /* 78 */ 0,
	  /* 79 */ 0,
	  /* 80 */ XK_F1,
	  /* 81 */ XK_F2,
	  /* 82 */ XK_F3,
	  /* 83 */ XK_F4,
	  /* 84 */ XK_F5,
	  /* 85 */ XK_F6,
	  /* 86 */ XK_F7,
	  /* 87 */ XK_F8,
	  /* 88 */ XK_F9,
	  /* 89 */ XK_F10,
	  /* 90 */ XK_KP_F1,
	  /* 91 */ XK_KP_F2,
	  /* 92 */ XK_KP_Divide,
	  /* 93 */ XK_PK_Multiply,
	  /* 94 */ XK_PK_Add,
	  /* 95 */ 0,
	  /* 96 */ XK_Shift_L,
	  /* 97 */ XK_Shift_R,
	  /* 98 */ XK_Caps_Lock,
	  /* 99 */ XK_Control_L,
	  /* 100 */ XK_Alt_L,
	  /* 101 */ XK_Alt_R,
	  /* 102 */ XK_Meta_L,
	  /* 103 */ XK_Meta_R,
	  /* 104 */ 0,
	  /* 105 */ 0,
	  /* 106 */ 0,
	  /* 107 */ 0,
	  /* 108 */ 0,
	  /* 109 */ 0,
	  /* 110 */ 0,
	  /* 111 */ 0,
	  /* 112 */ 0,
	  /* 113 */ 0,
	  /* 114 */ 0,
	  /* 115 */ 0,
	  /* 116 */ 0,
	  /* 117 */ 0,
	  /* 118 */ 0,
	  /* 119 */ 0,
	  /* 120 */ 0,
	  /* 121 */ 0,
	  /* 122 */ 0,
	  /* 123 */ 0,
	  /* 124 */ 0,
	  /* 125 */ 0,
	  /* 126 */ 0,
	  /* 127 */ 0,
	  /* 128 */ 0,
	  /* 129 */ XK_1,
	  /* 130 */ XK_2,
	  /* 131 */ XK_3,
	  /* 132 */ XK_4,
	  /* 133 */ XK_5,
	  /* 134 */ XK_6,
	  /* 135 */ XK_7,
	  /* 136 */ XK_8,
	  /* 137 */ XK_9,
	  /* 138 */ XK_0,
	  /* 139 */ XK_minus,
	  /* 140 */ XK_equal,
	  /* 141 */ XK_backslash,
	  /* 142 */ 0,
	  /* 143 */ XK_KP_0,
	  /* 144 */ XK_Q,
	  /* 145 */ XK_W,
	  /* 146 */ XK_E,
	  /* 147 */ XK_R,
	  /* 148 */ XK_T,
	  /* 149 */ XK_Y,
	  /* 150 */ XK_U,
	  /* 151 */ XK_I,
	  /* 152 */ XK_O,
	  /* 153 */ XK_P,
	  /* 154 */ XK_bracketleft,
	  /* 155 */ XK_bracketright,
	  /* 156 */ 0,
	  /* 157 */ XK_End,
	  /* 158 */ 0,
	  /* 159 */ 0,
	  /* 160 */ XK_A,
	  /* 161 */ XK_S,
	  /* 162 */ XK_D,
	  /* 163 */ XK_F,
	  /* 164 */ XK_G,
	  /* 165 */ XK_H,
	  /* 166 */ XK_J,
	  /* 167 */ XK_K,
	  /* 168 */ XK_L,
	  /* 169 */ XK_semicolon,
	  /* 170 */ 0,
	  /* 171 */ 0,
	  /* 172 */ 0,
	  /* 173 */ XK_KP_1,
	  /* 174 */ XK_KP_2,
	  /* 175 */ XK_KP_3,
	  /* 176 */ 0,
	  /* 177 */ XK_Z,
	  /* 178 */ XK_X,
	  /* 179 */ XK_C,
	  /* 180 */ XK_V,
	  /* 181 */ XK_B,
	  /* 182 */ XK_N,
	  /* 183 */ XK_M,
	  /* 184 */ XK_comma,
	  /* 185 */ XK_period,
	  /* 186 */ XK_slash,
	  /* 187 */ XK_comma,
	  /* 188 */ XK_KP_Decimal,
	  /* 189 */ XK_Home,
	  /* 190 */ 0,
	  /* 191 */ 0,
	  /* 192 */ 0,
	  /* 193 */ XK_BackSpace,
	  /* 194 */ XK_Tab,
	  /* 195 */ XK_KP_Equal,
	  /* 196 */ XK_Return,
	  /* 197 */ XK_Escape,
	  /* 198 */ XK_Delete,
	  /* 199 */ 0,
	  /* 200 */ 0,
	  /* 201 */ 0,
	  /* 202 */ XK_PK_Substract,
	  /* 203 */ 0,
	  /* 204 */ XK_Up,
	  /* 205 */ XK_Down,
	  /* 206 */ XK_Right,
	  /* 207 */ XK_Left,
	  /* 208 */ XK_F1,
	  /* 209 */ XK_F2,
	  /* 210 */ XK_F3,
	  /* 211 */ XK_F4,
	  /* 212 */ XK_F5,
	  /* 213 */ XK_F6,
	  /* 214 */ XK_F7,
	  /* 215 */ XK_F8,
	  /* 216 */ XK_F9,
	  /* 217 */ XK_F10,
	  /* 218 */ XK_KP_F1,
	  /* 219 */ XK_KP_F2,
	  /* 220 */ 0,
	  /* 221 */ 0,
	  /* 222 */ XK_PK_Add,
	  /* 223 */ 0,
	  /* 224 */ XK_Shift_L,
	  /* 225 */ XK_Shift_R,
	  /* 226 */ XK_Caps_Lock,
	  /* 227 */ XK_Control_L,
	  /* 228 */ XK_Alt_L,
	  /* 229 */ XK_Alt_R,
	  /* 230 */ XK_Meta_L,
	  /* 231 */ XK_Meta_R,
	  /* 232 */ 0,
	  /* 233 */ 0,
	  /* 234 */ 0,
	  /* 235 */ 0,
	  /* 236 */ 0,
	  /* 237 */ 0,
	  /* 238 */ 0,
	  /* 239 */ 0,
	  /* 240 */ 0,
	  /* 241 */ 0,
	  /* 242 */ 0,
	  /* 243 */ 0,
	  /* 244 */ 0,
	  /* 245 */ 0,
	  /* 246 */ 0,
	  /* 247 */ 0,
	  /* 248 */ 0,
	  /* 249 */ 0,
	  /* 250 */ 0,
	  /* 251 */ 0,
	  /* 252 */ 0,
	  /* 253 */ 0,
	  /* 254 */ 0,
	  /* 255 */ XK_Delete,
};
*/

long Xevent_to_mask[LASTEvent] = {
	0,						/* no event 0 */
	0,						/* no event 1 */
	KeyPressMask,					/* KeyPress */
	KeyReleaseMask,					/* KeyRelease */
	ButtonPressMask,				/* ButtonPress */
	ButtonReleaseMask,				/* ButtonRelease */
	PointerMotionMask|PointerMotionHintMask|Button1MotionMask|
		Button2MotionMask|Button3MotionMask|Button4MotionMask|
		Button5MotionMask|ButtonMotionMask,	/* MotionNotify */
	EnterWindowMask,				/* EnterNotify */
	LeaveWindowMask,				/* LeaveNotify */
	FocusChangeMask,				/* FocusIn */
	FocusChangeMask,				/* FocusOut */
	KeymapStateMask,				/* KeymapNotify */
	ExposureMask,					/* Expose */
	ExposureMask,					/* GraphicsExpose */
	ExposureMask,					/* NoExpose */
	VisibilityChangeMask,				/* VisibilityNotify */
	SubstructureNotifyMask,				/* CreateNotify */
	StructureNotifyMask|SubstructureNotifyMask,	/* DestroyNotify */
	StructureNotifyMask|SubstructureNotifyMask,	/* UnmapNotify */
	StructureNotifyMask /*|SubstructureNotifyMask*/,	/* MapNotify */
	SubstructureRedirectMask,			/* MapRequest */
	SubstructureNotifyMask|StructureNotifyMask,	/* ReparentNotify */
	StructureNotifyMask /*|SubstructureNotifyMask*/,	/* ConfigureNotify */
	SubstructureRedirectMask,			/* ConfigureRequest */
	SubstructureNotifyMask|StructureNotifyMask,	/* GravityNotify */
	ResizeRedirectMask,				/* ResizeRequest */
	SubstructureNotifyMask|StructureNotifyMask,	/* CirculateNotify */
	SubstructureRedirectMask,			/* CirculateRequest */
	PropertyChangeMask,				/* PropertyNotify */
	0,						/* SelectionClear */
	0,						/* SelectionRequest */
	0,						/* SelectionNotify */
	ColormapChangeMask,				/* ColormapNotify */
	0,						/* ClientMessage */
	0,						/* MappingNotify */
};

/* funcs */

char lookup_key(char *key)
{
  if(strcmp(key,"space")==0) return(' ');
  else if(strcmp(key,"comma")==0) return(',');
  else if(strcmp(key,"greater")==0) return('>');
  else if(strcmp(key,"less")==0) return('<');
  return(0);
}

void amiga_get_event(void)
{
  struct IntuiMessage *winmsg=NULL;
  int i;

  EG.nPeeked=0;
  for(i=0;i<X11NumDrawablesWindows;i++){
    EG.X11eventwin=X11DrawablesWindows[i];
    if(EG.X11eventwin&&X11ActualWindows[i].mapped){
      EG.nEventDrawable=X11DrawablesWindowsInvMap[i];
      winmsg = (struct IntuiMessage *)GetMsg(EG.X11eventwin->UserPort);
      if(winmsg) break;
    }
  }

  if(winmsg){
    EG.nMouseX=winmsg->MouseX;
    EG.nBorderX=EG.X11eventwin->BorderLeft;
    EG.nMouseY=winmsg->MouseY;
    EG.nBorderY=EG.X11eventwin->BorderTop;
    EG.nClass=winmsg->Class;
    EG.nCode=winmsg->Code;
    EG.nQual=winmsg->Qualifier&255;
    EG.nButtonMask=(EG.nButtonMask&(0xff00))|EG.nQual;
    EG.nTime=(unsigned long)(winmsg->Seconds*1000+winmsg->Micros/1000);
    ALookupKey(winmsg);
    ReplyMsg((struct Message *)winmsg);
    EG.bHaveWinMsg=1;
  }else{ /*EG.nClass=EG.nCode=EG.nQual=0;*/EG.bHaveWinMsg=0;}
}

X11NewInternalXEvent(XEvent *event,int size){
  _InternalXEvent *new=(_InternalXEvent *)malloc(sizeof(_InternalXEvent));
  if(!new) X11resource_exit(EVENTS1);
  List_AddEntry(pMemoryList,(void*)new);
  new->xev=malloc(size);
  List_AddEntry(pMemoryList,(void*)new->xev);
  if(!new->xev) X11resource_exit(EVENTS2);
  memcpy(new->xev,event,size);
  new->next=NULL;
  new->size=size;
  if(EG.X11InternalEvents==NULL) EG.X11InternalEvents=new;
  else EG.X11InternalEventsLast->next=new;
  EG.X11InternalEventsLast=new;
}

void X11init_events(void)
{
  EG.nButtonMask=0;
  EG.nPrevInside=-1;
  EG.nPeeked=0;
  EG.bDontWait=0;
  EG.bButtonSwitch=0;
  EG.bHaveWinMsg=0;
  EG.X11InternalEvents=NULL;
  EG.X11eventwin=NULL;
  EG.fwindowsig=0;
}

int X11NextInternalXEvent(XEvent *event){
  if(EG.X11InternalEvents!=NULL){
    _InternalXEvent *old=EG.X11InternalEvents;

    EG.X11InternalEvents=EG.X11InternalEvents->next;
    memcpy(event,old->xev,old->size);
    List_RemoveEntry(pMemoryList,(void*)old->xev);
    List_RemoveEntry(pMemoryList,(void*)old);
    return(1);
  }
  return 0;
}

/*
int X11NextInternalXEvent(XEvent *event){
  if(EG.X11InternalEvents!=NULL){
    static _InternalXEvent *old=NULL,*prev=NULL;

    if(old==NULL){
      old=EG.X11InternalEvents;
      prev=NULL;
    }
    
    while(old!=NULL){
      int win=old->xev->xclient.window;
      if(win==EG.nEventDrawable||
	 (X11Drawables[win]==X11SUBWINDOW&&
	  X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[win]]].parent==EG.nEventDrawable)||EG.bX11ReleaseAll)
/*      if(old->xev->type==ClientMessage||
	 old->xev->type!=ClientMessage)*/{
/*	if(old->xev->type==ClientMessage) printf("clientmessage released! to %d\n",EG.nEventDrawable);*/
	memcpy(event,old->xev,old->size);
/*
	printf("releasing internal event to %d: ",event->xany.window);
	switch(event->type){
	case Expose: printf("expose\n"); break;
	case MapNotify: printf("MapNotify\n"); break;
	case UnmapNotify: printf("UnmapNotify\n"); break;
	case VisibilityNotify: printf("VisibilityNotify\n"); break;
	}
*/
	if(prev==NULL) EG.X11InternalEvents=EG.X11InternalEvents->next;
	else{
	  if(prev->next==EG.X11InternalEventsLast) EG.X11InternalEventsLast=prev;
	  prev->next=old->next;
	}
	List_RemoveEntry(pMemoryList,(void*)old->xev);
	List_RemoveEntry(pMemoryList,(void*)old);
	prev=old;
	old=old->next;
	return(1);
      }
      prev=old;
      old=old->next;
      EG.bX11SkippedClient=1;
    }
  }
  return(0);
}
*/
void X11exit_events(void){
  XEvent event;
  EG.bX11ReleaseAll=1;
  while(EG.X11InternalEvents) X11NextInternalXEvent(&event);
}

void X11AddExpose(Drawable win,struct Window *ewin){
  XEvent ievent;
  int i;
  for(i=0;i<X11NumDrawables;i++){
    if((X11Drawables[i]==X11SUBWINDOW&&
	X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[i]]].parent==win/*&&
	X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[i]]].mapped*/)||
       i==win){
      ievent.type=Expose; ievent.xexpose.count=0;
/*
      printf("Adding expose event to %d\n",i);
*/
      ievent.xexpose.window=ievent.xany.window=i;
/*      printf("adding expose event (%d) to %d\n",Expose,i);*/
      if(i==win && ewin &&X11Drawables[i]==X11WINDOW){
	ievent.xexpose.x=ewin->LeftEdge; ievent.xexpose.y=ewin->TopEdge;
	ievent.xexpose.width=ewin->Width-(ewin->BorderLeft+ewin->BorderRight);
	ievent.xexpose.height=ewin->Height-(ewin->BorderTop+ewin->BorderBottom);
      } else if (i==win && X11Drawables[i]==X11SUBWINDOW) {
	ievent.xexpose.width=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[i]]].width;
	ievent.xexpose.height=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[i]]].height;
	ievent.xexpose.x=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[i]]].x;
	ievent.xexpose.y=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[i]]].y;
      }
      X11NewInternalXEvent(&ievent,sizeof(XExposeEvent));
    }
  }
}

void X11AddConfigure(Drawable win,struct Window *ewin){
  XEvent ievent;

  ievent.type=ConfigureNotify;
  ievent.xconfigure.window=ievent.xany.window=win;
  if(ewin){
    ievent.xconfigure.x=/*ewin->LeftEdge+*/ewin->BorderLeft;
    ievent.xconfigure.y=/*ewin->TopEdge+*/ewin->BorderTop;
    ievent.xconfigure.width=ewin->Width-(ewin->BorderLeft+ewin->BorderRight);
    ievent.xconfigure.height=ewin->Height-(ewin->BorderTop+ewin->BorderBottom);
  } else {
    ievent.xconfigure.width=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[win]]].width;
    ievent.xconfigure.height=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[win]]].height;
    ievent.xconfigure.x=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[win]]].x;
    ievent.xconfigure.y=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[win]]].y;
  }
  X11NewInternalXEvent(&ievent,sizeof(XConfigureEvent));
}

void X11AddInternalEvent(Window win,int type,int size){
  XEvent ievent;
  ievent.type=type;
  ievent.xany.window=win;
  X11NewInternalXEvent(&ievent,size);
}

void X11AddInternal(Window win,int type,int size){
  XEvent ievent;
  int i;
  for(i=0;i<X11NumDrawables;i++){
    if((X11Drawables[i]==X11SUBWINDOW&&
	X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[i]]].parent==win)||
       i==win){
/*
      printf("adding internal event to %d :",i);
      switch(type){
      case MapNotify: printf("MapNotify\n"); break;
      case UnmapNotify: printf("UnmapNotify\n"); break;
      case VisibilityNotify: printf("VisibilityNotify\n"); break;
      }
*/
      ievent.type=type;
      ievent.xany.window=i;
      switch(type){
      case UnmapNotify: ievent.xunmap.window=i; break;
      case MapNotify: ievent.xmap.window=i; break;
      }
      X11NewInternalXEvent(&ievent,size);
    }
  }
}

XNextEvent(display, event_return)
     Display *display;
     XEvent *event_return;
{
/*  int gotone=EG.bHaveWinMsg;*/
#ifdef DEBUGXEMUL_ENTRY
  printf("(events)XNextEvent [%d]\n",event_return->xbutton.subwindow);
#endif 
  if(X11NextInternalXEvent(event_return)){
    EG.bX11SkippedClient=0;
/*    printf("returning internal ");
    if(event_return->type==Expose) printf("expose event to %d\n",event_return->xany.window);
    else
      if(event_return->type==MapNotify) printf("mapping event to %d\n",event_return->xany.window);
      else printf("whats this? %d\n",event_return->type);*/
    return;
  }

  if(!EG.nPeeked) XPending(display);

  event_return->type=0;
  event_return->xany.window=0;

  if(EG.bDontWait){
    if(!EG.nPeeked)XPeekEvent(display,event_return);
  }else
    if(!EG.bHaveWinMsg)
      if(EG.fwindowsig){
	while(!XPending(display)){
	  Wait(EG.fwindowsig);
	}
      }
  if(EG.fwindowsig){
    if(!EG.nPeeked)XPeekEvent(display,event_return);
  }else return(0);
  EG.nPeeked=0;
  EG.bDontWait=0;
  return(0);
}

int XPending(Display *display){
#ifdef DEBUGXEMUL_ENTRY
  printf("(events)XPending\n");
#endif
  if(EG.X11InternalEvents!=NULL&&!EG.bX11SkippedClient){
    return(1);
  }
  if(X11NumDrawablesWindows){
    if(!EG.bHaveWinMsg) amiga_get_event();
    if(EG.bHaveWinMsg) return(1);
    else return(0);
  }else return(0);
  return (1);
}

XPeekEvent(Display *display, XEvent *event){
#ifdef DEBUGXEMUL_ENTRY
  printf("(events)XPeekEvent\n");
#endif
  EG.nPeeked=1;
  event->type=0;
  if(!EG.fwindowsig) return(0);
  return(get_intuievent(event));
}

XSelectInput(display, win, event_mask)
     Display *display;
     Window win;
     long event_mask;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("(events)XSelectInput %d mask [%x]\n",win,event_mask);
#endif
  X11DrawablesMask[win]=event_mask;
/*  EG.nEventDrawable=win;*/
  return(0);
}

XChangeWindowAttributes(display, w, valuemask, attributes)
     Display *display;
     Window w;
     unsigned long valuemask;
     XSetWindowAttributes *attributes;
{/* File 'xmgr.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XChangeWindowAttributes %d mask %d\n",w,valuemask);
#endif
  if(valuemask&CWEventMask){
    XSelectInput(display,w,(long)attributes->event_mask);
  }
  if(valuemask&CWColormap){
    XSetWindowColormap(display,w,attributes->colormap);
  }
  if(valuemask&CWCursor)
    XDefineCursor(display,w,attributes->cursor);
  return(0);
}

XSetStandardProperties(display, w, window_name, icon_name,
		       icon_pixmap, argv, argc, hints)
     Display *display;
     Window w;
     char *window_name;
     char *icon_name;
     Pixmap icon_pixmap;
     char **argv;
     int argc;
     XSizeHints *hints;
{/*  File 'grafikk.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("(events)XSetStandardProperties %d\n",w);
#endif
  if(X11Drawables[w]!=X11WINDOW) return; /* not window */
  X11ActualWindows[X11DrawablesMap[w]].name=window_name;
  return(0);
}

int handle_buttons(XEvent *event,int code){
  switch(code){
  case SELECTDOWN:
    event->xbutton.button=Button1; EG.nButtonMask|=Button1Mask; break;
  case SELECTUP:
    event->xbutton.button=Button1; EG.nButtonMask&=(0xFFFF-Button1Mask); break;
  case MENUDOWN:
    event->xbutton.button=Button3; EG.nButtonMask|=Button3Mask; break;
  case MENUUP:
    event->xbutton.button=Button3; EG.nButtonMask&=(0xFFFF-Button3Mask); break;
  case MIDDLEDOWN:
    event->xbutton.button=Button2; EG.nButtonMask|=Button2Mask; break;
  case MIDDLEUP:
    event->xbutton.button=Button2; EG.nButtonMask&=(0xFFFF-Button2Mask); 
    break;
  default:
    break;
  }
/*  printf("mask %x button %d (%d)\n",EG.nButtonMask,event->xbutton.button,EG.nQual);*/
}

int get_intuievent(XEvent *event){
  int buttoncode=0;
  if(!event) return(0);
  if(EG.X11InternalEvents!=NULL)
    if(X11NextInternalXEvent(event)) return;

/*
  printf("get_intuievent [%d]\n",EG.bHaveWinMsg);
*/
  if(!EG.bHaveWinMsg) amiga_get_event();

  event->type=0;
  event->xbutton.button=0;
  if(EG.bHaveWinMsg){
    int inside=0;
    EG.bHaveWinMsg=0;
    if(DG.bSubWins) inside=check_inside_subwindows(EG.X11eventwin,EG.nMouseX-EG.nBorderX,
					       EG.nMouseY-EG.nBorderY);
    event->xany.window=EG.nEventDrawable;
    if(EG.nPrevInside!=inside){
      XEvent ievent;
/*
      if(inside>DG.nNumChildren) printf("children overflow\n");
*/
      X11DrawablesChildren[0].id=amiga_screen[0].root;
      ievent.type=LeaveNotify;
      if(EG.nPrevInside<=0) ievent.xany.window=EG.nEventDrawable;
      else ievent.xany.window=X11DrawablesChildren[EG.nPrevInside].id;
      X11NewInternalXEvent(&ievent,sizeof(XEnterWindowEvent));
      ievent.type=EnterNotify;
      X11NewInternalXEvent(&ievent,sizeof(XLeaveWindowEvent));
      EG.nPrevInside=inside;
    }
    if(inside>0){
      event->xany.window=X11DrawablesChildren[inside].id;
    } else event->xany.window=EG.nEventDrawable;
/*
    printf("inside %d eventdrawable %d\n",X11DrawablesChildren[inside].id,EG.nEventDrawable);
*/
    switch(EG.nClass){
    case IDCMP_CLOSEWINDOW:
#ifdef DEBUGXEMUL0
      printf("(events)window is closing!\n");
#endif
/*      XFreeGC(displayp, gc);*/
      force_exit(0);
      break;
    case IDCMP_VANILLAKEY:
      if(inside>0) event->xkey.window=inside;
      else event->xkey.window=EG.nEventDrawable;
      event->xkey.state=EG.nQual;
      event->xkey.keycode=EG.nCode;
      if(inside>0){
	event->xkey.subwindow=X11DrawablesChildren[inside].id;
	event->xbutton.x-=X11DrawablesChildren[inside].x;
	event->xbutton.y-=X11DrawablesChildren[inside].y;
      }
      event->type=KeyPress;
      event->xkey.type=event->type;
      break;
    case IDCMP_RAWKEY:
#ifdef DEBUGXEMUL0
#endif
      event->xkey.state=EG.nQual;
      event->xkey.time=EG.nTime;
      event->xkey.keycode=0;
      if(EG.nCode==98||EG.nCode==100||EG.nCode==101){
	EG.bButtonSwitch=1;
      } else if(EG.nCode==226||EG.nCode==228||EG.nCode==229){
	EG.bButtonSwitch=0;
      }
      if(inside>0){
	event->xkey.subwindow=X11DrawablesChildren[inside].id;
	event->xbutton.x-=X11DrawablesChildren[inside].x;
	event->xbutton.y-=X11DrawablesChildren[inside].y;
      }
      if(EG.nCode<128) event->type=KeyPress;
      else event->type=KeyRelease;
      event->xkey.type=event->type;

      if(EG.nCode==97||EG.nCode==225||EG.nCode==96||EG.nCode==224){
	break; /*shift*/
      }
      if(EG.nCode==101||EG.nCode==229||EG.nCode==100||EG.nCode==228){
	break; /* alt */
      }
      if(EG.nCode==99||EG.nCode==227){
	break; /*ctrl */
      }
      if(EG.nCode==103||EG.nCode==230||EG.nCode==102||EG.nCode==231){
	break; /* amiga */
      }
      if(EG.nCode==98||EG.nCode==226){
	break; /* caps */
      }

/*
      event->xkey.keycode=EG.nCode;
*/
      event->xkey.keycode=X11Abuffer[0];
      break;
/*    case IDCMP_REFRESHWINDOW:*/
    case IDCMP_CHANGEWINDOW:{
      extern int adjx,adjy,prevx;
      event->type=ConfigureNotify;
      DG.nDisplayWidth=EG.X11eventwin->Width-(EG.X11eventwin->BorderLeft+EG.X11eventwin->BorderRight);
      DG.nDisplayHeight=EG.X11eventwin->Height-(EG.X11eventwin->BorderTop+EG.X11eventwin->BorderBottom);
      event->xconfigure.window=EG.nEventDrawable;
      event->xconfigure.width=DG.nDisplayWidth;
      event->xconfigure.height=DG.nDisplayHeight;
      event->xconfigure.x=/*EG.X11eventwin->LeftEdge+*/ EG.X11eventwin->BorderLeft;
      event->xconfigure.y=/*EG.X11eventwin->TopEdge+*/ EG.X11eventwin->BorderTop;
      {
	XRectangle r;
	XSetClipMask(&amigaX_display,NULL,None);
/*
	r.x=EG.X11eventwin->BorderLeft;
	r.y=EG.X11eventwin->BorderTop;
*/
	r.x=0;
	r.y=0;
	r.width=DG.nDisplayWidth;r.height=DG.nDisplayHeight;
	XSetClipRectangles(&amigaX_display,NULL,0,0,&r,1,0);
      }
/*      {
	X11userdata *Xud;
	Xud=(X11userdata*)(EG.X11eventwin->UserData);
	SetRast(EG.X11eventwin->RPort,Xud->background);
      }*/
/*      RefreshWindowFrame(EG.X11eventwin);*/
      X11AddInternal(event->xany.window,MapNotify,sizeof(XMapEvent));
      X11AddExpose(event->xany.window,EG.X11eventwin);
    }
      break;
    case IDCMP_MOUSEBUTTONS:
/*
      printf("(events)mousebuttons! [%d] qual [%x]\n",EG.nCode,EG.nQual);
*/
      if(EG.bButtonSwitch){
	if(EG.nCode==MENUDOWN||EG.nCode==SELECTDOWN) EG.nCode=MIDDLEDOWN;
	else if(EG.nCode==MENUUP||EG.nCode==SELECTUP) EG.nCode=MIDDLEUP;
      }
      buttoncode=EG.nCode;
      handle_buttons(event,EG.nCode);
      event->xbutton.x=EG.nMouseX-EG.nBorderX;
      event->xbutton.y=EG.nMouseY-EG.nBorderY;
      if(inside>0){
	event->xbutton.subwindow=X11DrawablesChildren[inside].id;
	event->xbutton.x-=X11DrawablesChildren[inside].x;
	event->xbutton.y-=X11DrawablesChildren[inside].y;
      }
      event->xbutton.state=EG.nQual;
      event->xbutton.time=EG.nTime;
      {
	if(EG.nCode==SELECTUP||EG.nCode==MENUUP||EG.nCode==MIDDLEUP){
	  event->type=ButtonRelease;
	}
	else{
	  event->type=ButtonPress;
	}
      }
      handle_buttons(event,buttoncode);
      break;
    case IDCMP_MOUSEMOVE:
#ifdef DEBUGXEMUL0
      printf("(events)mousemove! [%d,%d]\n",EG.nMouseX-EG.nBorderX,EG.nMouseY-EG.nBorderY);
#endif
      event->type=MotionNotify;
      event->xbutton.x=EG.nMouseX-EG.nBorderX;
      event->xbutton.y=EG.nMouseY-EG.nBorderY;
      event->xbutton.state=EG.nQual;
      if(inside>0){
	event->xbutton.subwindow=X11DrawablesChildren[inside].id;
	event->xbutton.x-=X11DrawablesChildren[inside].x;
	event->xbutton.y-=X11DrawablesChildren[inside].y;
      }
      event->xbutton.time=EG.nTime;
      break;
    case IDCMP_ACTIVEWINDOW:
#ifdef DEBUGXEMUL0
      printf("(events)active window %d !\n",EG.nEventDrawable);
#endif
      EG.nQual=0;
      event->type=EnterNotify;
      amiga_screen[0].root=EG.nEventDrawable;
      break;
    case IDCMP_INACTIVEWINDOW:
      EG.nQual=0;
#ifdef DEBUGXEMUL0
      printf("(events)inactive window! %d\n",EG.nEventDrawable);
#endif
      event->type=LeaveNotify;
      break;
    default:
#ifdef DEBUGXEMUL0
      printf("(events)other code\n");
#endif
      break;
    }
    EG.nCode=0;
    if(inside==0) inside=EG.nEventDrawable;
/*    printf(" inside(%d) mask %d event %d = %d\n",inside,X11DrawablesMask[inside],Xevent_to_mask[event->type],(X11DrawablesMask[inside]&(Xevent_to_mask[event->type])));*/
    if((X11DrawablesMask[event->xany.window]&(Xevent_to_mask[event->type]))!=0/*==Xevent_to_mask[event->type]*/){
#ifdef DEBUGXEMUL
      printf("accepted %x %x inside %d\n",event->type,X11DrawablesMask[EG.nEventDrawable],inside);
#endif
      return(1);
    }
/*
    if(([0]&(Xevent_to_mask[event->type]))!=0 /*==Xevent_to_mask[event->type]*/){
      event->xkey.window=amiga_screen[0].root;
#ifdef DEBUGXEMUL
      printf("root accepted %x %x inside %d\n",event->type,amigamask[inside],inside);
#endif
      return(1);
    }
*/
#ifdef DEBUGXEMUL0
    printf("not accepted %x %x inside %d!\n",event->type,X11DrawablesMask[EG.nEventDrawable],inside);
#endif
  {
    if( X11Drawables[event->xany.window]==X11SUBWINDOW ){ /* give the parent the event */
      int parent=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[event->xany.window]]].parent;
      if((X11DrawablesMask[parent]&(Xevent_to_mask[event->type]))!=0){
	switch(EG.nClass){
	case IDCMP_MOUSEBUTTONS:
	case IDCMP_MOUSEMOVE:
	  event->xbutton.x=EG.nMouseX-EG.nBorderX;
	  event->xbutton.y=EG.nMouseY-EG.nBorderY;
	  break;
	}
	event->xany.window=parent;
	return 1;
      }
    }
  }
    event->type=0;
  }
  EG.bHaveWinMsg=0;
  EG.nCode=0;
  return(0);
}

int XLookupString(event_structure, buffer_return, bytes_buffer,
		  keysym_return, status_in_out)
     XKeyEvent *event_structure;
     char *buffer_return;
     int bytes_buffer;
     KeySym *keysym_return;
     XComposeStatus *status_in_out;/* may not be implemented */
{
#ifdef DEBUGXEMUL_ENTRY
  printf("(events)XLookupString [%d]\n",X11Abuffer[0]);
#endif
  if(keysym_return)*keysym_return=0;
  *buffer_return=0;
  EG.nCode=0;

  if(event_structure->type==KeyPress||event_structure->type==KeyRelease){
    if(!event_structure->keycode){
      X11Abuffer[0]=0;
      return 0;
    }
    if(keysym_return)*keysym_return=(XID)event_structure->keycode;
    strncpy(buffer_return,X11Abuffer,bytes_buffer);
    return 1;
/*
    if(event_structure->keycode>223&&event_structure->keycode<232){
      if(keysym_return)*keysym_return=event_structure->keycode-128;
      X11Abuffer[0]=0;
      return 0;
    }else
      if(event_structure->keycode>95&&event_structure->keycode<104){
	if(keysym_return)*keysym_return=event_structure->keycode;
	X11Abuffer[0]=0;
	return 0;
      } else
	if(event_structure->keycode>75&&event_structure->keycode<80){
	  if(keysym_return){
	    switch(event_structure->keycode){
	    case 76:
	    case 204: *keysym_return=XK_Up; break;
	    case 77:
	    case 205: *keysym_return=XK_Down; break;
	    case 78:
	    case 206: *keysym_return=XK_Right; break;
	    case 79:
	    case 207: *keysym_return=XK_Left; break;
	    }
	  }
	  X11Abuffer[0]=0;
	  return 0;
	} else{
	  X11Abuffer[1]=0;
	  if(keysym_return)*keysym_return=(XID)X11Abuffer[0];
	  strncpy(buffer_return,X11Abuffer,bytes_buffer);
	  X11Abuffer[0]=0;
	  return 1;
	}
*/
  }
}

void ALookupKey(struct IntuiMessage *im){
  WORD actual;
  struct InputEvent ie ={0};
  int q=im->Qualifier&255;
  if (im->Class != IDCMP_RAWKEY||!im->Code) return;
/*
  X11Abuffer[0]=0;
*/
  ie.ie_Class = IECLASS_RAWKEY;
  ie.ie_SubClass = 0;
  ie.ie_Code = im->Code /*&127*/;
  if(q==1||q==2 /*||q==8 */) ie.ie_Qualifier = im->Qualifier&255;
  else {
    ie.ie_Qualifier = 0;
  }
/*
  ie.ie_Qualifier= im->Qualifier&255;
*/

/*  printf("qualifier %d\n",ie.ie_Qualifier);*/
  if(im->IAddress){
    ie.ie_EventAddress = (APTR *) *((ULONG *)im->IAddress);
    actual = MapRawKey(&ie, X11Abuffer, BUFFERLEN, NULL);
  }
/*
  if(X11Abuffer[0]==0){
    unsigned char key;
    switch(q){
    case 1: key=XK_Shift_L&0xff; break;
    case 2: key=XK_Shift_R&0xff; break;
    case 4: key=XK_Shift_L&0xff; break;
    case 8: key=XK_Control_L&0xff; break;
    case 16: key=XK_Alt_L&0xff; break;
    case 32: key=XK_Alt_R&0xff; break;
    case 64: key=XK_Meta_L&0xff; break;
    case 128: key=XK_Meta_R&0xff; break;
    }
    X11Abuffer[0]=key;
  }
*/
}

XRefreshKeyboardMapping(map_event)
     XMappingEvent *map_event;
{/* File 'class1.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XRefreshKeyboardMapping\n");
#endif
  return(0);
}

XFlush(Display *d){
  XEvent event;
#ifdef DEBUGXEMUL_ENTRY
  printf("XFlush..");
#endif
  if(X11NumDrawablesWindows)
    while(XPending(&amigaX_display)){
      get_intuievent(&event);
    }
#ifdef DEBUGXEMUL
  printf("Flushed..\n");
#endif
  return(0);
}


int XEventsQueued(display, mode)
     Display *display;
     int mode;
{/*           File 'xast.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XEventsQueued\n");
#endif
/*  if()
    return(XPeekEvent(&amigaX_display,&peekevent));*/
  EG.bDontWait=1;
  return(XPending(&amigaX_display));
}

Bool XQueryPointer(display, w, root_return, child_return,
		   root_x_return, root_y_return,
		   win_x_return, win_y_return, mask_return)
     Display *display;
     Window w;
     Window *root_return, *child_return;
     int *root_x_return, *root_y_return;
     int *win_x_return, *win_y_return;
     unsigned int *mask_return;

{
  XEvent event;
  int old;
  struct Window *win=Agetwin(w);
  prevwin=-1;
#ifdef DEBUGXEMUL_ENTRY
  printf("XQueryPointer reative to [%d] %d\n",w,EG.nEventDrawable);
#endif
  if(!win) return 0;
  if(X11Drawables[w]==X11WINDOW){
    *win_x_return=win->MouseX-win->BorderLeft;
    *win_y_return=win->MouseY-win->BorderTop;
  } else if(X11Drawables[w]==X11SUBWINDOW){
    int child=X11DrawablesSubWindows[X11DrawablesMap[w]];
    *win_x_return=win->MouseX-X11DrawablesChildren[child].x-win->BorderLeft;
    *win_y_return=win->MouseY-X11DrawablesChildren[child].y-win->BorderTop;
  }
  if(root_x_return) *root_x_return=win->MouseX-win->BorderLeft;
  if(root_y_return) *root_y_return=win->MouseY-win->BorderTop;
/*
} else {
    struct Window *win=X11DrawablesWindows[X11DrawablesMap[EG.nEventDrawable]];
    if(!win) return 0;
    *win_x_return=-win->BorderLeft+win->MouseX/*EG.nMouseX-EG.nBorderX*/;
    *win_y_return=-win->BorderTop+win->MouseY/*EG.nMouseY-EG.nBorderY*/;
    if(root_x_return) *root_x_return=/*win->LeftEdge+*/*win_x_return;
    if(root_y_return) *root_y_return=/*win->TopEdge+*/*win_y_return;
  }
*/
  old=EG.nEventDrawable;
  EG.nEventDrawable=w;
  if(XPending(display)){
    get_intuievent(&event);
  } else{
    if(EG.fwindowsig) Wait(EG.fwindowsig); 
    get_intuievent(&event);
  }
  *mask_return=EG.nButtonMask;
  EG.nEventDrawable=old;
  return(TRUE);
}


Bool XCheckIfEvent(display, event_return, predicate, arg)
     Display *display;
     XEvent *event_return;
     Bool (*__stdargs predicate)(Display *,XEvent*,char *data);
     char *arg;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XCheckIfEvent\n");
#endif
  if(XPending(display)){
    XNextEvent(display,event_return);
    if(predicate(display,event_return,arg)) return(1);
  }
  return(0);
}

XWindowEvent(display, w, event_mask, event_return)
     Display *display;
     Window w;
     long event_mask;
     XEvent *event_return;
{/*            File 'xvbutt.o' */
  long old;
#ifdef DEBUGXEMUL_ENTRY
  printf("XWindowEvent %d\n",w);
#endif
  old=X11DrawablesMask[w];
  X11DrawablesMask[w]=event_mask;
  do{
    XNextEvent(display,event_return);
  }while(!(Xevent_to_mask[event_return->type]&event_mask));
  X11DrawablesMask[w]=old;
}

Bool XCheckTypedEvent(display, event_type, event_return)
     Display *display;
     int event_type;
     XEvent *event_return;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XCheckTypedEvent\n");
#endif
  do{
    XNextEvent(display,event_return);
  }while(event_return->type!=event_type && XPending(display));
}

int
  select(int nfds, int *readfds, int *writefds, int *exceptfds,
	 struct timeval *timeout)
{/*                  File 'usleep.o'*/
#ifdef DEBUGXEMUL
#endif
  if(timeout==NULL){
    if(EG.fwindowsig) Wait(EG.fwindowsig);
  } else X11delayfor(timeout->tv_secs,timeout->tv_micro);
  return(0);
}

#define XK_MISCELLANY
#define XK_LATIN1
#include <X11/keysymdef.h>

char X11str[10];

KeySym XLookupKeysym(event, index)
     XKeyEvent *event;
     int index;
{/*           File 'w_canvas.o'*/
  int retval=0;
#ifdef DEBUGXEMUL_ENTRY
  printf("XLookupKeysym\n");
#endif
  switch(event->keycode){
  case 227: case 99: retval=XK_Control_L; break;
  case 225: case 97: retval=XK_Shift_R; break;
  case 224: case 96: retval=XK_Shift_L; break;
  case 101: case 229: retval=XK_Alt_R; break;
  case 100: case 228: retval=XK_Alt_L; break;
  case 103: case 231: retval=XK_Meta_R; break;
  case 102: case 230: retval=XK_Meta_L; break;
  case 98: case 226: retval=XK_Caps_Lock; break;
  case 76: case 204: retval=XK_Up; break;
  case 77: case 205: retval=XK_Down; break;
  case 78: case 206: retval=XK_Right; break;
  case 79: case 207: retval=XK_Left; break;
  case 68: case 196: retval=XK_Return; break;
  case 69: case 197: retval=XK_Escape; break;
  case 61: case 189: retval=XK_Home; break;
  case 65: case 193: retval=XK_BackSpace; break;
  case 70: case 198: retval=XK_Delete; break;
  case 57: case 185: retval=XK_period; break;
  case 58: case 186: retval=XK_slash; break;
  }
  if(!retval)
  {
    KeySym keysym;
    XComposeStatus status;
    XLookupString(event,X11str,4,&keysym, &status);
    strcpy(X11Abuffer,X11str);
    retval=event->keycode;
  }else X11str[0]=retval;
  return((KeySym)retval);
}

char *XKeysymToString(keysym)
     KeySym keysym;
{
  switch(keysym){
  case XK_Return: strcpy(X11str,"Return"); break;
  case XK_Left: strcpy(X11str,"Left"); break;
  case XK_Right: strcpy(X11str,"Right"); break;
  case XK_Up: strcpy(X11str,"Up"); break;
  case XK_Down: strcpy(X11str,"Down"); break;
  case XK_Delete: strcpy(X11str,"Delete"); break;
  case XK_BackSpace: strcpy(X11str,"BackSpace"); break;
  case XK_Escape: strcpy(X11str,"Escape"); break;
  case XK_period: strcpy(X11str,"period"); break;
  case XK_slash: strcpy(X11str,"slash"); break;
  }
  return(X11str);
}

Bool XCheckWindowEvent(display, w, event_mask, event_return)
     Display *display;
     Window w;
     long event_mask;
     XEvent *event_return;
{
  long old;
  int parent=X11findparent(w);
#ifdef DEBUGXEMUL_ENTRY
  printf("XCheckWindowEvent %d\n",w);
#endif
  EG.nEventDrawable=parent;
  old=X11DrawablesMask[w];
  X11DrawablesMask[w]=event_mask;
  event_return->type=0;
  if(XPending(display))
    XNextEvent(display,event_return);
  X11DrawablesMask[w]=old;
  if(Xevent_to_mask[event_return->type]&event_mask) return(1);
  return(0);
}

XSetInputFocus(display, focus, revert_to, time)
     Display *display;
     Window focus;
     int revert_to;
     Time time;
{/*          File 'xtb/libxtb.lib' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XSetInputFocus %d\n",focus);
#endif
  if(X11Drawables[focus]==X11WINDOW){
    ActivateWindow(X11DrawablesWindows[X11DrawablesMap[focus]]);
    EG.nEventDrawable=focus;
  }
  return(0);
}

int XGrabPointer(display, grab_window, owner_events,
		 event_mask, pointer_mode, keyboard_mode, confine_to, cursor, time)
     Display *display;
     Window grab_window;
     Bool owner_events;
     unsigned int event_mask;
     int pointer_mode, keyboard_mode;
     Window confine_to;
     Cursor cursor;
     Time time;
{/*            File 'xvgam.o' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XGrabPointer\n");
#endif
  if(cursor) XDefineCursor(display, grab_window, cursor);
  EG.GrabMask=X11DrawablesMask[grab_window];
  EG.GrabWin=grab_window;
  XSelectInput(display,grab_window,event_mask);
  return(0);
}

XUngrabPointer(display, time)
     Display *display;
     Time time;
{/*          File 'xvgam.o' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XUngrabPointer\n");
#endif
  XUndefineCursor(display,NULL);
  X11DrawablesMask[EG.GrabWin]=EG.GrabMask;
  return(0);
}

XSetNormalHints(display, w, hints)
     Display *display;
     Window w;
     XSizeHints *hints;
{/*         File 'sunclock.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XSetNormalHints\n");
#endif
  if(X11ActualWindows[X11DrawablesMap[w]].mapped){
    XWindowChanges values;
    values.x=hints->x; 
    values.y=hints->y;
    values.width=hints->width;
    values.height=hints->height;
   
    XConfigureWindow(display,w,CWX|CWY|CWWidth|CWHeight,&values);
  }
  return(0);
}

XIfEvent(display, event_return, predicate, args)
     Display *display;
     XEvent *event_return;
     Bool (*__stdargs predicate)(Display *,XEvent*,char *data);
     char *args;
{/*                File 'magick/libMagick.lib' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XIfEvent\n");
#endif
  while(1){
    XNextEvent(display,event_return);
    if(predicate(display,event_return,args)) break;
  }

  return(0);
}

Status XSendEvent(display, w, propagate, event_mask, event_send)
     Display *display;
     Window w;
     Bool propagate;
     long event_mask;
     XEvent *event_send;
{/*              File 'xvevent.o' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XSendEvent %d %d (%d)\n",propagate,event_mask,event_send->type);
#endif
  event_send->xclient.window=w;
  X11NewInternalXEvent(event_send,sizeof(XEvent));
  return(0);
}

XPutBackEvent(display, event)
     Display *display;
     XEvent *event;
{/*           File 'w_canvas.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XPutBackEvent %d\n",event->type);
#endif
  X11NewInternalXEvent(event,sizeof(XEvent));
  return(0);
}

int XtGrabPointer(
    Widget 		 widget,
    _XtBoolean 		 owner_events,
    unsigned int	 event_mask,
    int 		 pointer_mode,
    int 		 keyboard_mode,
    Window 		 confine_to,
    Cursor 		 cursor,
    Time 		 t
){/*           File 'windlib.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtGrabPointer\n");
#endif
  return(0);
}

int XtGrabKeyboard(
    Widget 		widget,
    _XtBoolean 		owner_events,
    int 		pointer_mode,
    int 		keyboard_mode,
    Time 		t
){/*          File 'file.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtGrabKeyboard\n");
#endif
  return(0);
}

XWarpPointer(display, src_w, dest_w, src_x, src_y,
	     src_width, src_height, dest_x, dest_y)
     Display *display;
     Window src_w, dest_w;
     int src_x, src_y;
     unsigned int src_width, src_height;
     int dest_x, dest_y;
{/*            File 'events.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XWarpPointer\n");
#endif
  return(0);
}

Bool XCheckMaskEvent(display, event_mask, event_return)
     Display *display;
     long event_mask;
     XEvent *event_return;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XCheckMaskEvent\n");
#endif

  if(XPending(display)){
    XPeekEvent(display,event_return);
    if(Xevent_to_mask[event_return->type] & event_mask) return 1;
  }
  return(0);
}

XPeekIfEvent(display, event_return, predicate, arg)
     Display *display;
     XEvent *event_return;
     Bool (*__stdargs predicate)(Display *,XEvent*,char *data);
     XPointer arg;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XPeekIfEvent\n");
#endif
  EG.bSkipInternal=1;
  do{
    XNextEvent(display,event_return);
    if( !predicate(display,event_return,arg) ) XPutBackEvent(display,event_return);
  }while( !predicate(display,event_return,arg) && XPending(display) );
  EG.bSkipInternal=0;
  if( !predicate(display,event_return,arg) ){
    XFlush( display );
    do{
      XNextEvent(display,event_return);
    }while( !predicate(display,event_return,arg) );
  }
}

#ifndef XMUIAPP
XSizeHints *XAllocSizeHints(){
  void *data=calloc(sizeof(XSizeHints),1);
  List_AddEntry(pMemoryList,(void*)data);
  return data;
}

XClassHint *XAllocClassHint(){
  void *data=calloc(sizeof(XClassHint),1);
  List_AddEntry(pMemoryList,(void*)data);
  return data;
}
#endif

XFree(data)
     void *data;
{
  List_RemoveEntry(pMemoryList,(void*)data);
  return(0);
}

Bool XCheckTypedWindowEvent(display, w, event_type, event_return)
     Display *display;
     Window w;
     int event_type;
     XEvent *event_return;
{/*  File 'xvevent.o' */
#if (DEBUGXEMUL_ENTRY)
  printf("XCheckTypedWindowEvent\n");
#endif
  while (XPending(display)){
    XNextEvent(display,event_return);
    if( event_return->type==event_type && event_return->xany.window==w  ) return 1;
  }
  return(0);
}
