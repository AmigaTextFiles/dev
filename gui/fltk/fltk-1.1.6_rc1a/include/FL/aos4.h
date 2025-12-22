//
// "$Id: win32.H,v 1.15.2.3.2.13 2004/11/20 03:19:57 easysw Exp $"
//
// WIN32 header file for the Fast Light Tool Kit (FLTK).
//
// Copyright 1998-2004 by Bill Spitzak and others.
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Library General Public
// License as published by the Free Software Foundation; either
// version 2 of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Library General Public License for more details.
//
// You should have received a copy of the GNU Library General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA.
//
// Please report all bugs and problems to "fltk-bugs@fltk.org".
//

// Do not directly include this file, instead use <FL/x.H>.  It will
// include this file if __amigaos4__ is defined.  This is to encourage
// portability of even the system-specific code...

#ifndef Fl_X_H
#  error "Never use <FL/aos4.H> directly; include <FL/x.H> instead."
#endif // !Fl_X_H

#include <stdio.h>
#include <math.h>
#include <exec/types.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/dos.h>
#include <proto/graphics.h>
#include <proto/layers.h>
#include <proto/Picasso96API.h>

#include <graphics/regions.h>
#include <graphics/rpattr.h>
#include <graphics/gfxmacros.h>

#include <devices/clipboard.h>

#undef FOREVER

// clipboard support
struct cbbuf {
  ULONG size;     /* size of memory allocation            */
  ULONG count;    /* number of characters after stripping */
  UBYTE *mem;     /* pointer to memory containing data    */
};

#define MAKE_ID(a,b,c,d) ((a<<24L) | (b<<16L) | (c<<8L) | d)

#define ID_FORM MAKE_ID('F','O','R','M')
#define ID_FTXT MAKE_ID('F','T','X','T')
#define ID_CHRS MAKE_ID('C','H','R','S')

//extern struct IntuitionIFace *IIntuition;

// some random X equivalents
typedef struct Window *FLTKWindow;

struct XPoint {int x, y;};
struct XRectangle {int x, y, width, height;};
typedef struct Region *Fl_Region;

extern struct RastPort *actual_rp;
extern FLTKWindow fl_window;
extern BOOL update;

FL_EXPORT void fl_clip_region(Fl_Region);
FL_EXPORT Fl_Region fl_clip_region();

extern void draw_arc(struct RastPort *rp,UWORD cx,UWORD cy,UWORD rx,UWORD ry,double a1,double a2);
extern void draw_pie(struct RastPort *rp,UWORD cx,UWORD cy,UWORD rx,UWORD ry,WORD a1,WORD a2);
extern void get_origin(int &dx, int &dy);
extern void set_origin(int dx, int dy);

inline struct Region *installclipregion (struct Window *w, struct Region *r)
{
  struct Region *oldreg = NULL;
  struct Layer *l = w->WLayer;

  if (update = l->Flags & LAYERUPDATING) ILayers->EndUpdate(l,FALSE);
  oldreg = ILayers->InstallClipRegion (l, r);
  if (update) ILayers->BeginUpdate(l);

  return oldreg;
}

inline void XDestroyRegion(Fl_Region r) {
  if (r) {
    //IGraphics->DisposeRegion(r);
    //r = NULL;
  }
}

inline Fl_Region XRectangleRegion(int x, int y, int w, int h) {
    Fl_Region region;
    static struct Rectangle rect;

    int dx, dy;
    get_origin(dx,dy);
    x += dx;
    y += dy;

    if (region = IGraphics->NewRegion()) {
      rect.MinX = x;
      rect.MinY = y;
      rect.MaxX = x+w-1;
      rect.MaxY = y+h-1;

      IGraphics->ClearRegion(region);
      IGraphics->OrRectRegion(region, &rect);
    }

    return region;
}

#define XMapWindow(a,b)     { IIntuition->ZipWindow(b); }
#define XUnmapWindow(a,b)   { IIntuition->ZipWindow(b); }

#include "Fl_Window.H"
// this object contains all aos4-specific stuff about a window:
// Warning: this object is highly subject to change!
class FL_EXPORT Fl_X {
public:
  FLTKWindow xid;
  struct RastPort *other_xid;  // for double-buffered windows
  Fl_Window* w;
  Fl_Region region;
  Fl_X *next;                  // linked tree to support subwindows
  Fl_X *xidChildren, *xidNext; // more subwindow tree
  int wait_for_expose;
  //HDC private_dc; // used for OpenGL
  APTR cursor;
  static Fl_X* first;
  static Fl_X* i(const Fl_Window* w) {return w->i;}
  static int fake_X_wm(const Fl_Window* w,int &X, int &Y,
                         int &bt,int &bx,int &by);
  static void make(Fl_Window*);
  void flush() {w->flush();}
};

inline FLTKWindow fl_xid(const Fl_Window*w) {Fl_X *temp = Fl_X::i(w); return temp ? temp->xid : 0;}

extern uint32 fl_current_color;
inline uint32 fl_RGB() {return fl_current_color;}

extern FL_EXPORT APTR fl_display;
extern FL_EXPORT FLTKWindow fl_window;
extern FL_EXPORT APTR fl_gc;
extern FL_EXPORT APTR fl_palette; // non-zero only on 8-bit displays!
extern FL_EXPORT APTR fl_GetDC(Window);
extern FL_EXPORT APTR fl_msg;

// off-screen pixmaps: create, destroy, draw into, copy to window
typedef struct RastPort *Fl_Offscreen;

extern Fl_Offscreen fl_create_offscreen(int w, int h);
extern void fl_copy_offscreen(int x,int y,int w,int h, Fl_Offscreen bitmap, int srcx,int srcy);
extern void fl_delete_offscreen(Fl_Offscreen bitmap);
extern void fl_begin_offscreen(Fl_Offscreen bitmap);
extern void fl_end_offscreen();

// Bitmap masks
typedef struct RastPort *Fl_Bitmask;

extern FL_EXPORT Fl_Bitmask fl_create_bitmask(int w, int h, const uchar *data);
extern FL_EXPORT Fl_Bitmask fl_create_alphamask(int w, int h, int d, int ld, const uchar *data);
extern FL_EXPORT void fl_delete_bitmask(Fl_Bitmask bm);

// Dummy function to register a function for opening files via the window manager...
inline void fl_open_callback(void (*)(const char *)) {}

extern FL_EXPORT int fl_parse_color(const char* p, uchar& r, uchar& g, uchar& b);

