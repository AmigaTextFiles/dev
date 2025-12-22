/*
 *  OpenTriton -- A free release of the triton.library source code
 *  Copyright (C) 1993-1998  Stefan Zeiger
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */


struct TR_AppPrefs
{
  UBYTE version;
  BOOL  frames_width;
  UBYTE frames_title;
  UWORD frames_type[5];
  BOOL  frames_raised[5];
  ULONG pentype[8];
  ULONG pendata[8];
  ULONG imgtype[4];
  ULONG imgdata[4];
  UBYTE pubscreen[32];
  ULONG flags;
};

// Prefs version
#define TR_PREFSVERSION         3

// Prefs flags
#define TRPF_RETURNARROW        0x00000001L
#define TRPF_SIMPLEREFRESH      0x00000002L

// Image types
#define TRIT_BFPATTERN          0L
#define TRIT_GRAPHICSPEN        1L
#define TRIT_TRITONIMAGE        100L

#ifndef TR_EXTERNAL_ONLY
struct TR_AppPrefs TR_DefaultAppPrefs=
{
  TR_PREFSVERSION,
  1,2,
  BBFT_BUTTON,BBFT_ICONDROPBOX,BBFT_RIDGE,BBFT_BUTTON,BBFT_BUTTON,
  TRUE,TRUE,FALSE,FALSE,FALSE,
  TRPT_SYSTEMPEN,TRPT_SYSTEMPEN,TRPT_SYSTEMPEN,TRPT_SYSTEMPEN,TRPT_SYSTEMPEN,TRPT_SYSTEMPEN,TRPT_SYSTEMPEN,TRPT_SYSTEMPEN,
  TEXTPEN,HIGHLIGHTTEXTPEN,BACKGROUNDPEN,FILLPEN,BACKGROUNDPEN,BACKGROUNDPEN,TEXTPEN,TEXTPEN,
  TRIT_BFPATTERN,TRIT_BFPATTERN,TRIT_BFPATTERN,TRIT_BFPATTERN,
  TRBF_NONE,TRBF_SHINE_BACKGROUND,TRBF_NONE,TRBF_FILL,
  NULL,
  NULL
};
#endif

struct TR_ScreenNode
{
  struct Node node;
  UBYTE version;
  ULONG id;
  UBYTE pubname[32];
  UBYTE title[124];
  UBYTE fontname[32];
  ULONG fontsize;
  ULONG flags;
  ULONG screenmode;
  ULONG width;
  ULONG height;
  ULONG depth;
  ULONG backfilltype;
  UBYTE backfillname[124];
  struct Screen *screen;
  struct Window *backfillwindow;
};
