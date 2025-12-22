/*
   amiterm.h         Amiga graphics macros

   Copyright (C) 1997 Tony Belding, <tlbelding@htcomp.net>

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

/* System includes */
#include <graphics/gfxmacros.h>
#include <intuition/screens.h>
#include <intuition/gadgetclass.h>
#include <intuition/intuition.h>
#include <exec/memory.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <libraries/asl.h>
#include <proto/asl.h>

#include <libraries/reqtools.h>
#include <proto/reqtools.h>


/* PROTOTYPES FOR AMITERM.C */

extern BOOL save_prefs(void);
extern BOOL load_prefs(void);
extern void default_prefs(void);
extern void amiga_open_graphics_screen(void);
extern NODE *lam_prefs(void);
extern NODE *lam_version(void);
extern void amiga_splitscreen(void);
extern void amiga_fullscreen(void);
extern void amiga_textscreen(void);
extern void get_con_position(void);
extern void logofill(void);
extern void ami_print(char *);
extern void set_palette(int,unsigned int,unsigned int,unsigned int);
extern void get_palette(int,unsigned int *,unsigned int *,unsigned int*);
extern int check_amiga_stop(void);
extern void amiga_wait(unsigned int);

/* PROTOTYPES FOR MM.AMIGA.C */

extern NODE *lmm_screensize(void);
extern NODE *lmm_pixel(NODE *);
extern NODE *lmm_turtle(NODE *);
extern NODE *lmm_alert(NODE *);
extern NODE *lmm_getlist(NODE *);
extern NODE *lmm_getint(NODE *);
extern NODE *lmm_filerequest(NODE *);
extern NODE *lmm_waitclick(NODE *);
extern NODE *lmm_waitkey(NODE *);
extern NODE *lmm_showimage(NODE *);

/* Filehandle for the AmigaDOS console window. */
extern BPTR console;

/* name of our public screen, so "ed" and "CON:" can find it */
extern char screenname[];

/* Many of the macros refer to the graphics window */
extern struct Window* win;


/* Amiga window does not have a visible flag so we store this separately */
extern int current_vis;


/* How much space to leave for recording */
#define GR_SIZE 1

/********************************************************************/
/* Define or declare everything needed by GRAPHIC.C */

#define prepare_to_draw  if(win==NULL)amiga_splitscreen()
#define done_drawing

#define prepare_to_draw_turtle
#define done_drawing_turtle

#define screen_height (win->Height - (win->BorderTop + win->BorderBottom))
#define screen_width  (win->Width - (win->BorderLeft + win->BorderRight))

#define screen_left   (win->BorderLeft)
#define screen_right  (win->Width - win->BorderRight - 1)
#define screen_top    (win->BorderTop)
#define screen_bottom (win->Height - win->BorderBottom - 1)

#define screen_x_center (screen_left+screen_width/2)
#define screen_y_center (screen_top+screen_height/2)

#define turtle_height (18.0*0.5)
#define turtle_half_bottom (6.0*0.5)
#define turtle_side (19.0*0.5)

#define turtle_left_max          (-(screen_width/2))
#define turtle_right_max         ((screen_width-1)/2)
#define turtle_top_max           (screen_height/2)
#define turtle_bottom_max        (-((screen_height-1)/2))

#define screen2x( sx) ((sx) - win->BorderLeft - (screen_width/2.0))
#define screen2y( sy) (win->BorderTop + (screen_height/2.0) - (sy))

#define x2screen(x) (win->BorderLeft + (screen_width/2.0) + (x))
#define y2screen(y) (win->BorderTop + (screen_height/2.0) - (y))

#define screen_x_coord x2screen(turtle_x)
#define screen_y_coord y2screen(turtle_y)

#define clear_screen     erase_screen()

#define line_to(x,y)     if (current_vis==0)\
                              Draw( win->RPort, (int)(x),(int)(y));\
                         else Move( win->RPort, (int)(x),(int)(y));

#define move_to(x,y)       Move( win->RPort, (int)(x),(int)(y))
#define draw_string(s)     Text( win->RPort, (char*)(s), strlen( (char*)(s)))
#define label( s)          draw_string(s)

#define set_pen_vis(v)     current_vis = (v)
#define set_pen_mode(m)    SetDrMd( win->RPort, m)
#define set_pen_color(c)   SetAPen( win->RPort, MapColor(c));
#define pen_color          RevMapColor(GetAPen( win->RPort))
#define set_back_ground(c) SetBPen( win->RPort, MapColor(c))
#define set_pen_width(w)
#define set_pen_height(h)
#define set_pen_x(x)       Move( win->RPort, (int)(x), win->RPort->cp_y)
#define set_pen_y(y)       Move( win->RPort, win->RPort->cp_x, (int)(y))

#define full_screen amiga_fullscreen()
#define split_screen amiga_splitscreen()
#define text_screen amiga_textscreen()

/* This seems wrong, but we would really need a reverse color lookup
   to do any better (I think)
*/
#define back_ground 1

/*
   pen_info is a stucture type with fields for the various
   pen characteristics.  The types are system dependant.
*/

typedef struct {
   WORD     x;
   WORD     y;
   int      vis;
   ULONG    fcolor;
   ULONG    bcolor;
   UWORD    pattern;
   ULONG    mode;
} pen_info;

#define p_info_x(p) (p).x
#define p_info_y(p) (p).y

#define pen_width    1
#define pen_height   1
#define pen_mode     GetDrMd( win->RPort)
#define pen_vis      current_vis
#define pen_x        (win->RPort->cp_x)
#define pen_y        (win->RPort->cp_y)

#define get_node_pen_pattern Get_node_pen_pattern()
#define get_node_pen_mode    Get_node_pen_mode()


/* Various pen mode settings */
#define pen_reverse          SetDrMd( win->RPort, COMPLEMENT)
#define pen_erase            SetDrMd( win->RPort, JAM2 | INVERSVID)
#define pen_down             SetDrMd( win->RPort, JAM1)


/*
   These defines cover the fixed palette area of a Logo screen.  Anything
   above 15 is subject to being allocated and redefined.
*/
#define WB_GRAY   0
#define BLACK     1
#define WHITE     2
#define WB_BLUE   3
#define BLUE      4
#define GREEN     5
#define CYAN      6
#define RED       7
#define MAGENTA   8
#define YELLOW    9
#define BROWN     10
#define TAN       11
#define FOREST    12
#define AQUA      13
#define SALMON    14
#define PURPLE    15
#define ORANGE    16
#define GRAY      18

#define button  0
#define mouse_x win->MouseX
#define mouse_y win->MouseY

void save_pen(struct pen_info  *p);
void restore_pen(struct pen_info *p);

#define plain_xor_pen() pen_reverse

typedef struct {      /* structure for user preferences */
   ULONG DisplayID;
   UWORD DisplayWidth;
   UWORD DisplayHeight;
   UWORD DisplayDepth;
   UWORD OverscanType;
   char font[80];
   char editor[256];
} BAL_Prefs;

extern BAL_Prefs prefs;

/* Make a noise for the given pitch and duration */
#define tone(pitch,duration)
#define get_pen_pattern(p)       /* Maybe this could be implemented? */
#define set_pen_pattern(p)       /* and this */
#define set_list_pen_pattern(p)  /* What is this? */

extern ULONG MapColor( FIXNUM logo_color);
extern FIXNUM RevMapColor( ULONG);
extern NODE *Get_node_pen_pattern( void);
extern NODE *Get_node_pen_mode( void);
extern void erase_screen( void);


/* I have no clue why this should be defined here, since it is part of
   math.c... just tradition I guess!
*/
extern double degrad;
