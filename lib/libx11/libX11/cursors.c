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
     cursors
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Jan 22, 1995: Created.
***/


#include <stdio.h>

#include <intuition/intuition.h>
#include <intuition/pointerclass.h>
#include <graphics/videocontrol.h>
#include <proto/intuition.h>

#include <stdlib.h>
#include <string.h>

#include "libX11.h"

#define DEBUGXEMUL_WARNING 1

#include <X11/X.h>
#include <X11/Xlib.h>

#include <libraries/mui.h>
#include <proto/muimaster.h>

UWORD DXC_ul_angle [16] = { 
	0x0000,
	0x7fe0,
	0x7fe0,
	0x6000,
	0x6000,
	0x6000,
	0x6000,
	0x6000,
	0x6000,
	0x6000,
	0x6000,
	0x0000,
	0x0000,
	0x0000,
	0x0000,
	0x0000,
	};

UWORD DXC_right_ptr [16] = { 
	0x0000,
	0x0080,
	0x0180,
	0x0380,
	0x0780,
	0x0f80,
	0x1f80,
	0x3f80,
	0x7f80,
	0x0f80,
	0x0d80,
	0x1880,
	0x1800,
	0x3000,
	0x3000,
	0x0000,
	};

UWORD DXC_arrow [16] = { 
	0x0000,
	0x0006,
	0x001e,
	0x007c,
	0x01fc,
	0x07f8,
	0x1ff8,
	0x01f0,
	0x03f0,
	0x0760,
	0x0e60,
	0x1c40,
	0x3840,
	0x7000,
	0x2000,
	0x0000,
	};

UWORD DXC_X_cursor [16] = {
  0x0000,0x700e,0x781e,0x7c3e,0x3e7c,0x1ff8,0x0ff0,0x07e0,
  0x07e0,0x0ff0,0x1ff8,0x3e7c,0x7c3e,0x781e,0x700e,0x0000,
};

UWORD DXC_crosshair [16] = { 
  0x0280,0x0280,0x0280,0x0280,0x0280,0x0280,0xfeff,0x0000,
  0xfeff,0x0280,0x0280,0x0280,0x0280,0x0280,0x0280,0x0000,
};

UWORD DXC_tcross [16] = { 
  0x0000,0x0100,0x0100,0x0100,0x0100,0x0100,0x0100,0x7ffc,
  0x0100,0x0100,0x0100,0x0100,0x0100,0x0100,0x0000,0x0000,
};

UWORD DXC_fleur [16] = { 
  0x0000,0x0180,0x03c0,0x07e0,0x0180,0x1188,0x318c,0x7ffe,
  0x7ffe,0x318c,0x1188,0x0180,0x07e0,0x03c0,0x0180,0x0000,
};

UWORD DXC_hand2 [16] = { 
  0x0000,0x7f80,0x8040,0x7e20,0x1010,0x0e10,0x1010,0x0e28,
  0x1044,0x0c82,0x0304,0x0248,0x0110,0x00a0,0x0040,0x0000,
};

UWORD DXC_pirate [16] = { 
  0x0780,0x0fc0,0x1fe0,0x3330,0x3330,0x1fe0,0x0fc0,0x0780,
  0x8784,0x8786,0x4308,0x3870,0x0780,0x1fe2,0xf03e,0x8004,
};

UWORD DXC_sizing [16] = { 
  0x0000,0x7f80,0x4000,0x4000,0x4000,0x47e0,0x4420,0x4422,
  0x4422,0x0422,0x07e2,0x0012,0x000a,0x0006,0x01fe,0x0000,
};

UWORD DXC_watch [16] = { 
  0x1fe0,0x1fe0,0x1fe0,0x3ff0,0x6118,0xc10c,0xc107,0xc387,
  0xc387,0xc407,0xc80c,0x6018,0x3ff0,0x1fe0,0x1fe0,0x1fe0,
};

UWORD DXC_xterm [16] = { 
  0x0000,0x0ee0,0x0380,0x0100,0x0100,0x0100,0x0100,0x0100,
  0x0100,0x0100,0x0100,0x0100,0x0100,0x0380,0x0ee0,0x0000,
};

UWORD DXC_left_ptr [] = { 
  0x8000,0xc000,0xe000,0xf000,0xf800,0xfc00,0xfe00,0xff00,
  0xf800,0xd800,0x8c00,0x0c00,0x0600,0x0600,0x0000,0x0000,
};

UWORD DXC_circle [] = { 
  0x0000,0x03c0,0x0ff0,0x1ff8,0x3c3c,0x381c,0x700e,0x700e,
  0x700e,0x700e,0x381c,0x3c3c,0x1ff8,0x0ff0,0x03c0,0x0000,
};

UWORD DXC_pencil [] = { 
  0x0e00,0x1100,0x1180,0x0940,0x0f40,0x0420,0x0220,0x0210,
  0x0110,0x0188,0x0088,0x0044,0x003c,0x001c,0x000c,0x0004,
};

UWORD DXC_dotbox [] = { 
  0x0000,0x0000,0x3ffc,0x2004,0x2004,0x2004,0x2004,0x2184,
  0x2184,0x2004,0x2004,0x2004,0x2004,0x3ffc,0x0000,0x0000,
};

UWORD DXC_hand1 [] = { 
  0x0000,0x000c,0x003c,0x00f0,0x01e0,0x03c0,0x07e0,0x0ff0,
  0x2fe0,0x7ff0,0x5ff0,0x07e0,0x07c0,0x4a00,0x6200,0x3400,
};

UWORD DXC_icon [] = { 
  0xffff,0xd555,0xaaab,0xd555,0xa00b,0xd005,0xa00b,0xd005,
  0xa00b,0xd005,0xa00b,0xd005,0xaaab,0xd555,0xaaab,0xffff,
};

UWORD DXC_sb_h_double_arrow [] = { 
  0x0000,0x0808,0x180c,0x3ffe,0x780f,0x3ffe,0x180c,0x0808,
  0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,
};

UWORD DXC_sb_left_arrow [] = { 
  0x0000,0x0800,0x1800,0x3fff,0x7800,0x3fff,0x1800,0x0800,
  0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,
};

UWORD DXC_sb_right_arrow [] = { 
  0x0020,0x0030,0x7ff8,0x003c,0x7ff8,0x0030,0x0020,0x0000,
  0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,
};

UWORD DXC_sb_up_arrow [] = { 
  0x1000,0x3800,0x7c00,0xfe00,0x2800,0x2800,0x2800,0x2800,
  0x2800,0x2800,0x2800,0x2800,0x2800,0x2800,0x0000,0x0000,
};

UWORD DXC_sb_down_arrow [] = { 
  0x1400,0x1400,0x1400,0x1400,0x1400,0x1400,0x1400,0x1400,
  0x1400,0x1400,0x1400,0x7f00,0x3e00,0x1c00,0x0800,0x0000,
};

UWORD DXC_sb_v_double_arrow [] = { 
  0x0000,0x0800,0x1c00,0x3e00,0x7f00,0x1400,0x1400,0x1400,
  0x1400,0x1400,0x1400,0x1400,0x7f00,0x3e00,0x1c00,0x0800,
};

UWORD DXC_top_left_arrow[] ={
  0x0000,0x6000,0x7800,0x3E00,0x3F80,0x1FE0,0x1FF8,0x0F80,
  0x0F80,0x0640,0x0620,0x0210,0x0208,0x0004,0x0002,0x0000
};

/*#include <intuition/intuitionbase.h>*/

/*
#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <graphics/displayinfo.h>
#include <devices/timer.h>
#include <proto/graphics.h>
#include <proto/gadtools.h>
#include <proto/layers.h>

#include <signal.h>
#include <time.h>
*/
#include <dos.h>
#include <stdlib.h>
#include <stdlib.h>

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/cursorfont.h>
#include "amigax_proto.h"
#include "amiga_x.h"

extern struct Screen *wb;
extern GC amiga_gc;

#define USEPOINTERCLASS 1

Cursor prevdefined=NULL;

byte PMinvert(byte b){
  byte br=(byte)(((b&128)>>7)+
		 ((b&64)>>5)+
		 ((b&32)>>3)+
		 ((b&16)>>1)+
		 ((b&8)<<1)+
		 ((b&4)<<3)+
		 ((b&2)<<5)+
		 ((b&1)<<7));
  return(br);
}

#define PWORDWIDTH	4

struct TagItem VCTags0[] =
{
  {VTAG_DEFSPRITERESN_GET,NULL},
  {TAG_DONE, NULL},
};

struct TagItem VCTags1[] =
{
  {VTAG_SPRITERESN_SET, SPRITERESN_35NS},
  {VTAG_DEFSPRITERESN_SET, SPRITERESN_35NS},
  {TAG_DONE, NULL},
};

struct TagItem VCTags2[] =
{
  {VTAG_SPRITERESN_SET, SPRITERESN_70NS},
  {TAG_DONE, NULL},
};

int X11AvailCursors=10,X11NumCursors=0;
typedef struct {
  Pixmap pm;
  VOID *pointer;
} X11InternalCursor;

X11InternalCursor *X11InternalCursors=NULL;

Cursor X11FontCursors[256];

void X11init_cursors(void){
  int i;
  for(i=0;i<256;i++) X11FontCursors[0]=NULL;
  X11InternalCursors=(X11InternalCursor*)malloc(X11AvailCursors*sizeof(X11InternalCursor));
  if(!X11InternalCursors) X11resource_exit(7);
}

void X11expand_cursors(void){
  X11InternalCursor *old=X11InternalCursors;
  X11InternalCursors=(X11InternalCursor*)malloc((X11AvailCursors+10)*sizeof(X11InternalCursor));
  if(!X11InternalCursors) X11resource_exit(8);
  memcpy(X11InternalCursors,old,X11AvailCursors*sizeof(X11InternalCursor));
  X11AvailCursors+=10;
  free(old);
}

Cursor X11NewCursor(Pixmap pm,VOID *pointer){
  X11InternalCursors[X11NumCursors].pm=pm;
  X11InternalCursors[X11NumCursors++].pointer=pointer;
  if(X11NumCursors==X11AvailCursors) X11expand_cursors();
  return(X11NumCursors-1);
}

void X11exit_cursors(void){
  int i;
  if(DG.bUse30){
    for(i=0;i<X11NumCursors;i++)
      if(X11InternalCursors[i].pointer!=NULL)
	DisposeObject(X11InternalCursors[i].pointer);
  } else {
  }
  free(X11InternalCursors);
}

Cursor XCreatePixmapCursor(display, source, mask,
			   foreground_color, background_color, x, y)
     Display *display;
     Pixmap source;
     Pixmap mask;
     XColor *foreground_color;
     XColor *background_color;
     unsigned int x, y;
{
  VOID *new_pointer=NULL;
  struct BitMap *bmp=NULL;
  CursorData *c;
  struct BitMap *bm=X11DrawablesBitmaps[X11DrawablesMap[source]].pBitMap;
  int size=bm->BytesPerRow*bm->Rows,i,bpr=bm->BytesPerRow;
  UWORD *data;
  Pixmap pm;
  
#ifdef DEBUGXEMUL_ENTRY
  printf("XCreatePixmapCursor %d\n",source);
#endif
#ifdef USEPOINTERCLASS
  if(!DG.bUse30){
#endif
    data=(UWORD*)AllocMem(size*2+8,MEMF_CHIP|MEMF_CLEAR);
    c=malloc(sizeof(CursorData));
    if(!c) return(NULL);
    c->size=size;
    c->hotx=x;
    c->hoty=y;
    c->cdata=data;
    if(data){
      for(i=0;i<bm->Rows;i++){
	*((char*)data+4+i*bpr*2)=/*PMinvert(*/(byte)*(bm->Planes[0]+i*bpr)/*)*/;
	*((char*)data+4+i*bpr*2+1)=/*PMinvert(*/(byte)*(bm->Planes[0]+i*bpr+1)/*)*/;
      }
    }
    {
      Cursor new=X11NewCursor(NULL,c);
      return(new);
    }
#ifdef USEPOINTERCLASS
  }else{
    int xres,yres;
    VideoControl(wb->ViewPort.ColorMap,VCTags0);
    if(VCTags0[0].ti_Data==POINTERXRESN_35NS){
      xres=POINTERXRESN_HIRES;
      yres=POINTERYRESN_HIGH;
    }else{
      xres=POINTERXRESN_LORES;
      yres=POINTERYRESN_DEFAULT;
    }
    pm=XCreatePixmap(NULL,NULL,X11DrawablesBitmaps[X11DrawablesMap[source]].width,
		     X11DrawablesBitmaps[X11DrawablesMap[source]].height,2);
    bmp=X11DrawablesBitmaps[X11DrawablesMap[pm]].pBitMap;
    XCopyArea(NULL,source,pm,amiga_gc,0,0,X11DrawablesBitmaps[X11DrawablesMap[pm]].width
	      ,X11DrawablesBitmaps[X11DrawablesMap[pm]].height,0,0);

    new_pointer = NewObject( NULL, "pointerclass",
			    POINTERA_BitMap, bmp,
			    POINTERA_WordWidth, (bm->BytesPerRow)>>1,
			    POINTERA_XResolution, xres,
			    POINTERA_YResolution, yres,
			    POINTERA_XOffset, -x,
			    POINTERA_YOffset, -y,
			    TAG_DONE );
/*
    SetWindowPointer(wb->FirstWindow,WA_Pointer,new_pointer,TAG_DONE);
    getchar();*/
  }
  {
    Cursor new=X11NewCursor(pm,new_pointer);
/*    printf("XCreatePixmapCursor ok %d\n",new);*/
    return(new);
  }
#endif
}
 
XFreeCursor(display, cursor)
     Display *display;
     Cursor cursor;
{
  int i;
#ifdef DEBUGXEMUL_ENTRY
  printf("XFreeCursor %d\n",cursor);
#endif
  for(i=0;i<X11NumDrawablesWindows;i++){
    _ActualWindow *actual=&X11ActualWindows[i];
    if(actual->cursor==cursor){
      XUndefineCursor(display,X11DrawablesWindowsInvMap[i]);
    }
  }
  if(cursor!=-1){
#ifdef USEPOINTERCLASS
    if(!DG.bUse30){
#endif
      CursorData *cd=(CursorData*)X11InternalCursors[cursor].pointer;
      FreeMem(cd->cdata,cd->size*2+8);
      free(cd);
#ifdef USEPOINTERCLASS
    }else{
      if(X11InternalCursors[cursor].pointer!=NULL)
	DisposeObject(X11InternalCursors[cursor].pointer);
      X11InternalCursors[cursor].pointer=NULL;
    }
#endif
  }
}

XUndefineCursor(display, win)
     Display *display;
     Window win;
{
  struct Window *w;
#ifdef DEBUGXEMUL_ENTRY
  printf("XUndefineCursor %d\n",win);
#endif
  if(win==(XID)0) return;
  if(X11Drawables[win]==X11SUBWINDOW||X11Drawables[win]==X11WINDOW){
    int parent=X11findparent(win);
    w=X11DrawablesWindows[X11DrawablesMap[parent]];
  }
  prevwin=-1;
  if(X11Drawables[win]==X11MUI){
    LONG l;
    extern Object *X11appwin;
    get(X11appwin,MUIA_Window_Open,&l);
    if(!l) return;
    if(!isopen(X11DrawablesMUI[X11DrawablesMap[win]])) return;
    w=_window(X11DrawablesMUI[X11DrawablesMap[win]]);
  }
  if(!w) return;
#ifdef USEPOINTERCLASS
  if(DG.bUse30) SetWindowPointer(w, TAG_DONE );
  else
#endif
    ClearPointer(w);
  prevdefined=NULL;
  return(0);
}

XSetCursor(Window win){
  if(X11Drawables[win]==X11MUI)
    XDefineCursor(NULL,win,X11DrawablesMUICursor[X11DrawablesMap[win]]);
}

XDefineCursor(display, win, cursor)
     Display *display;
     Window win;
     Cursor cursor;
{
  struct Window *w;
  _ActualWindow *actual;
  CursorData *cd;
#ifdef DEBUGXEMUL_ENTRY
  printf("XDefineCursor %d %d\n",win,cursor);
#endif
  if(cursor==-1||prevdefined==cursor) return(0);
  if(!DG.bX11Cursors) return;
  if(X11Drawables[win]==X11SUBWINDOW||X11Drawables[win]==X11WINDOW){
    int parent=X11findparent(win);
    w=X11DrawablesWindows[X11DrawablesMap[parent]];
  }
  prevwin=-1;
  if(X11Drawables[win]==X11MUI){
    LONG l;
    extern Object *X11appwin;
    get(X11appwin,MUIA_Window_Open,&l);
    if(!l) return;
    if(!isopen(X11DrawablesMUI[X11DrawablesMap[win]])) return;
    w=_window(X11DrawablesMUI[X11DrawablesMap[win]]);
    X11DrawablesMUICursor[X11DrawablesMap[win]]=cursor;
  }
  if(!w) return;

  if(X11Drawables[win]==X11WINDOW){
    actual=&X11ActualWindows[X11DrawablesMap[win]];
    if(!actual->mapped) {/*printf("window not mapped!\n");*/ return;}
    actual->cursor=cursor;
  }else if(X11Drawables[win]==X11SUBWINDOW){
    actual=&X11ActualWindows[X11DrawablesMap[X11findparent(win)]];
    if(!actual->mapped) {/*printf("subwindow not mapped\n");*/ return;}
    actual->cursor=cursor;
  }

#ifdef USEPOINTERCLASS
  if(cursor!=-1&&DG.bUse30){
    if(X11InternalCursors[cursor].pointer!=NULL){
      SetWindowPointer(w,WA_Pointer,X11InternalCursors[cursor].pointer,TAG_DONE);
    }
    prevdefined=cursor;
/*    printf("ok\n");*/
    return;
  }
#endif
  cd=(CursorData*)X11InternalCursors[cursor].pointer;
  if(!cd) return;
  if(cd->cdata){
    SetPointer(w,cd->cdata,16,16,-cd->hotx,-cd->hoty);
    prevdefined=cursor;
    return;
  } 
  XUndefineCursor(display,win);
  return;
}

Cursor XCreateFontCursor(Display *d,unsigned int n){
  int hotx,hoty;
  UWORD *data=NULL;
#ifdef DEBUGXEMUL_ENTRY
  printf("XCreateFontCursor\n");
#endif
  switch(n){
  case XC_ul_angle:  data=DXC_ul_angle; hotx=0;hoty=0; break;
  case XC_arrow:     data=DXC_arrow; hotx=7;hoty=0; break;
  case XC_right_ptr: data=DXC_right_ptr; hotx=15; hoty=0; break;
  case XC_X_cursor:  data=DXC_X_cursor; hotx=7; hoty=7;break;
  case XC_crosshair: data=DXC_crosshair; hotx=8; hoty=7;break;
  case XC_tcross:    data=DXC_tcross; hotx=7; hoty=7;break;
  case XC_fleur:     data=DXC_fleur; hotx=7; hoty=7;break;
  case XC_hand2:     data=DXC_hand2; hotx=0; hoty=0;break;
  case XC_pirate:    data=DXC_pirate; hotx=7; hoty=10;break;
  case XC_sizing:    data=DXC_sizing; hotx=7; hoty=7;break;
  case XC_watch:     data=DXC_watch; hotx=7; hoty=7;break;
  case XC_xterm:     data=DXC_xterm; hotx=7; hoty=7;break;

  case XC_left_ptr:  data=DXC_left_ptr; hotx=0; hoty=0;break;
  case XC_circle:    data=DXC_circle; hotx=7; hoty=7;break;
  case XC_pencil:    data=DXC_pencil; hotx=12; hoty=12;break;
  case XC_dotbox:    data=DXC_dotbox; hotx=8; hoty=8;break;
  case XC_hand1:     data=DXC_hand1; hotx=15; hoty=0;break;
  case XC_icon:      data=DXC_icon; hotx=7; hoty=7;break;
  case XC_sb_h_double_arrow: data=DXC_sb_h_double_arrow; hotx=7; hoty=7;break;
  case XC_sb_left_arrow:     data=DXC_sb_left_arrow; hotx=0; hoty=4;break;
  case XC_sb_right_arrow:    data=DXC_sb_right_arrow; hotx=7; hoty=4;break;
  case XC_sb_up_arrow:       data=DXC_sb_up_arrow; hotx=4; hoty=0;break;
  case XC_sb_down_arrow:     data=DXC_sb_down_arrow; hotx=4; hoty=7;break;
  case XC_sb_v_double_arrow: data=DXC_sb_v_double_arrow; hotx=7; hoty=7;break;
  case XC_top_left_arrow:    data=DXC_top_left_arrow; hotx=0; hoty=0;break;
  }
/*
  if(X11FontCursors[n]!=NULL){
    return(X11FontCursors[n]);
  }
*/
  if(data){
    Cursor cursor;
    Pixmap pm;
    struct BitMap *bmp;
    pm=XCreatePixmap(NULL,NULL,16,16,1);
    bmp=X11DrawablesBitmaps[X11DrawablesMap[pm]].pBitMap;
    memcpy(bmp->Planes[0],data,32);
/*    RectFill(&(wb->RastPort),20,20,60,60);
    BltBitMapRastPort(bmp,0,0,&(wb->RastPort),22,22,16,16,0xC0);
    getchar();*/
    cursor=XCreatePixmapCursor(NULL,pm,NULL,NULL,NULL,hotx,hoty);
    XFreePixmap(NULL,pm);
    X11FontCursors[n]=cursor;
    return(cursor);
  }
  return(-1);
}
Cursor XCreateGlyphCursor(display, source_font, mask_font,
			  source_char, mask_char, foreground_color,  background_color)
     Display *display;
     Font source_font, mask_font;
     unsigned int source_char, mask_char;
     XColor *foreground_color;
     XColor *background_color;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XCreateGlyphCursor\n");
#endif
  return(NULL);
}

Status XIconifyWindow(display, w, screen_number)
     Display *display;
     Window w;
     int screen_number;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XIconifyWindow\n");
#endif
  return(NULL);
}

XRecolorCursor(display, cursor, foreground_color,
               background_color)
     Display *display;
     Cursor cursor;
     XColor *foreground_color, *background_color;
{/*'xast.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XRecolorCursor\n");
#endif
  return(0);
}

