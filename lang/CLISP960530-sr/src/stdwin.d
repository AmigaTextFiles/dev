# STDWIN-Interface für CLISP
# Bruno Haible, Matthias Lindner 29.8.1993

#include "lispbibl.c"

# If STDWIN is not defined, we are compiling this as a separate module.
#ifndef STDWIN
#define STDWIN_MODULE
#endif

#ifdef STDWIN_MODULE

struct {
  object stdwin_drawproc_alist;
}
module__stdwin__object_tab;

uintC module__stdwin__object_tab_size = sizeof(module__stdwin__object_tab)/sizeof(object);

object_initdata module__stdwin__object_tab_initdata[sizeof(module__stdwin__object_tab)/sizeof(object)] = {
  { "NIL" },
};

#define OM(name)  (module__stdwin__object_tab.name)

#else

#define OM(name)  O(name)

#endif

#if defined(STDWIN) || defined(STDWIN_MODULE)

#include <stdwin.h>  # "stdwin/H/stdwin.h"


#                           Foreign Function Interface
#                           ==========================

# We call library functions that can do callbacks. When we pass a parameter
# to such a library function, maybe it first does a callback - which may
# involve garbage collection - and only then looks at the parameter.
# Therefore all the parameters, especially strings, must be located in
# areas that are not moved by garbage collection.

# with_string(string,charptr,len,statement);
# copies the contents of string (which should be a Lisp string) to a safe area,
# binds the variable charptr pointing to it and the variable len to its length,
# and executes the statement.
  #define with_string(string,charptrvar,lenvar,statement)  \
    { var uintL lenvar;                                      \
      var reg2 uintB* ptr1 = unpack_string(string,&lenvar);  \
     {var DYNAMIC_ARRAY(_EMA_,charptrvar##_data,uintB,lenvar);    \
      {var reg1 uintB* ptr2 = &charptrvar##_data[0];         \
       var reg3 uintL count;                                 \
       dotimesL(count,lenvar, { *ptr2++ = *ptr1++; } );      \
      }                                                      \
      {var char* charptrvar = (char*) &charptrvar##_data[0]; \
       statement                                             \
      }                                                      \
      FREE_DYNAMIC_ARRAY(charptrvar##_data);                 \
    }}


#                           Initialization and clean-up
#                           +++++++++++++++++++++++++++

# We free the programmer from the duty to call (STDWIN::WINIT).

local boolean initialized = FALSE; # tells whether winit() has been called

local void initialize (void);
local void initialize()
  { begin_call();
    winit();
    wmenusetdeflocal(TRUE); # change STDWIN's default behaviour for menus
    end_call();
    OM(stdwin_drawproc_alist) = NIL;
    initialized = TRUE;
  }

# (STDWIN::INIT) calls winit().
LISPFUNN(stdwin_init,0)
{
  if (!initialized) initialize();
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::DONE) calls wdone().
LISPFUNN(stdwin_done,0)
{
  if (initialized)
    { begin_call();
      wdone();
      end_call();
      initialized = FALSE;
    }
  value1 = NIL; mv_count=1; # returns NIL
}

# check_init(); checks that STDWIN has been initialized.
  #define check_init()  \
    if (!initialized) initialize()

#                         Creating and destroying windows
#                         +++++++++++++++++++++++++++++++

# OM(stdwin_drawproc_alist) is a list of conses (win . drawproc),
# where drawproc is the Lisp function for redrawing the window win.

# Looks up a given window in OM(stdwin_drawproc_alist):
  local object find_win (void* win);
  local object find_win(win)
    var reg3 void* win;
    { var reg2 object key = type_untype_object(machine_type,win);
      var reg1 object l;
      for (l = OM(stdwin_drawproc_alist); consp(l); l = Cdr(l))
        { if (eq(Car(Car(l)),key)) { return Car(l); } }
      return NIL;
    }

# General redrawing function:
  local void drawproc (WINDOW* win, int left, int top, int right, int bottom);
  local void drawproc(win,left,top,right,bottom)
    var reg3 WINDOW* win;
    var reg4 int left;
    var reg5 int top;
    var reg6 int right;
    var reg7 int bottom;
    { begin_callback();
     {var reg1 object acons = find_win(win);
      if (consp(acons))
        { var reg2 object fun = Cdr(acons);
          if (!nullp(fun))
            { pushSTACK(fun);
              pushSTACK(type_untype_object(machine_type,win));
              pushSTACK(L_to_I(left));
              pushSTACK(L_to_I(top));
              pushSTACK(L_to_I(right));
              pushSTACK(L_to_I(bottom));
              funcall(STACK_5,5);
              skipSTACK(1);
        }   }
      end_callback();
    }}

# (STDWIN::DRAWPROC-ALIST) returns the OM(stdwin_drawproc_alist).
# Why should this be useful?? Remove!??
LISPFUNN(stdwin_drawproc_alist,0)
{ value1 = OM(stdwin_drawproc_alist); mv_count=1; }

# (STDWIN::WOPEN title drawproc) calls wopen().
LISPFUNN(stdwin_wopen,2)
{ if (!mstringp(STACK_1)) { STACK_1 = O(leer_string); }
  # Pre-allocate the conses for the alist:
  pushSTACK(allocate_cons()); pushSTACK(allocate_cons());
  check_init();
 {var reg3 WINDOW* win;
  with_string_0(STACK_(1+2),title,
    { begin_call();
      win = wopen(title,(nullp(STACK_(0+2)) ? NULL : drawproc));
      end_call();
    });
  {var reg1 object acons = popSTACK();
   var reg2 object newcons = popSTACK();
   if (win==NULL)
     { value1 = NIL; }
     else
     { value1 = Car(acons) = type_untype_object(machine_type,win);
       Cdr(acons) = STACK_0;
       Car(newcons) = acons;
       Cdr(newcons) = OM(stdwin_drawproc_alist);
       OM(stdwin_drawproc_alist) = newcons;
  }  }
  mv_count=1;
  skipSTACK(2);
}}

# (STDWIN::WCLOSE win) calls wclose().
LISPFUNN(stdwin_wclose,1)
{ var reg3 object arg = popSTACK();
  check_init();
 {var reg2 WINDOW* win = (WINDOW*)TheMachine(arg);
  var reg1 object acons = find_win(win);
  if (consp(acons))
    { OM(stdwin_drawproc_alist) = deleteq(OM(stdwin_drawproc_alist),acons);
      begin_call();
      wclose(win);
      end_call();
    }
  value1 = NIL; mv_count=1; # returns NIL
}}

# test_window(arg) checks that an argument is an STDWIN window, and returns it.
  local WINDOW* test_window (object arg);
  local WINDOW* test_window(arg)
    var reg2 object arg;
    { var reg1 WINDOW* win = (WINDOW*)TheMachine(arg);
      check_init();
      if (nullp(find_win(win)))
        { pushSTACK(arg);
          pushSTACK(TheSubr(subr_self)->name);
          # type_error ??
          //: DEUTSCH "~: Argument ~ ist kein STDWIN:WINDOW."
          //: ENGLISH "~: argument ~ is not a STDWIN:WINDOW"
          //: FRANCAIS "~ : L'argument ~ n'est pas de type STDWIN:WINDOW."
          fehler(error,  GETTEXT("~: argument ~ is not a STDWIN:WINDOW"));
        }
      return win;
    }

#                          Changing defaults
#                          -----------------

# (STDWIN::SCROLLBAR-P) calls wgetdefscrollbars().
LISPFUNN(stdwin_scrollbar_p,0)
{ var int h_p;
  var int v_p;
  check_init();
  begin_call();
  wgetdefscrollbars(&h_p,&v_p);
  end_call();
  value1 = (h_p ? T : NIL); value2 = (v_p ? T : NIL); mv_count=2;
}

# (STDWIN::SET-SCROLLBAR-P horizontal-bar-p vertical-bar-p) calls wsetdefscrollbars().
LISPFUNN(stdwin_set_scrollbar_p,2)
{ var reg2 int h_p = (nullp(STACK_1) ? FALSE : TRUE);
  var reg1 int v_p = (nullp(STACK_0) ? FALSE : TRUE);
  check_init();
  begin_call();
  wsetdefscrollbars(h_p,v_p);
  end_call();
  STACK_to_mv(2); # returns two values: h_p and v_p
}

# (STDWIN::DEFAULT-WINDOW-SIZE) calls wgetdefwinsize().
LISPFUNN(stdwin_default_window_size,0)
{ var int w;
  var int h;
  check_init();
  begin_call();
  wgetdefwinsize(&w,&h);
  end_call();
  pushSTACK(L_to_I(w)); pushSTACK(L_to_I(h));
  STACK_to_mv(2); # returns two values: w and h
}

# (STDWIN::SET-DEFAULT-WINDOW-SIZE width height) calls wsetdefwinsize().
LISPFUNN(stdwin_set_default_window_size,2)
{ var reg2 sintL w = I_to_L(STACK_1);
  var reg1 sintL h = I_to_L(STACK_0);
  check_init();
  begin_call();
  wsetdefwinsize(w,h);
  end_call();
  STACK_to_mv(2); # returns two values: w and h
}

# (STDWIN::DEFAULT-WINDOW-POSITION) calls wgetdefwinpos().
LISPFUNN(stdwin_default_window_position,0)
{ var int x;
  var int y;
  check_init();
  begin_call();
  wgetdefwinpos(&x,&y);
  end_call();
  pushSTACK(L_to_I(x)); pushSTACK(L_to_I(y));
  STACK_to_mv(2); # returns two values: x and y
}

# (STDWIN::SET-DEFAULT-WINDOW-POSITION x y) calls wsetdefwinpos().
LISPFUNN(stdwin_set_default_window_position,2)
{ var reg2 sintL x = I_to_L(STACK_1);
  var reg1 sintL y = I_to_L(STACK_0);
  check_init();
  begin_call();
  wsetdefwinpos(x,y);
  end_call();
  STACK_to_mv(2); # returns two values: x and y
}

#                              The output model
#                              ++++++++++++++++

# (STDWIN::SCREEN-SIZE) calls wgetscrsize().
# (STDWIN::WINDOW-SIZE win) calls wgetwinsize().
# (STDWIN::WINDOW-POSITION win) calls wgetwinpos().
# (STDWIN::WINDOW-DOCUMENT-SIZE win) calls wgetdocsize().
# (STDWIN::SET-WINDOW-DOCUMENT-SIZE win width height) calls wsetdocsize().
# (STDWIN::WINDOW-TITLE win) calls wgettitle().
# (STDWIN::SET-WINDOW-TITLE win string) calls wsettitle().
# (STDWIN::SET-WINDOW-CURSOR win string) calls wfetchcursor() and wsetwincursor().

# (STDWIN::SCREEN-SIZE) calls wgetscrsize().
LISPFUNN(stdwin_screen_size,0)
{ var int w;
  var int h;
  check_init();
  begin_call();
  wgetscrsize(&w,&h);
  end_call();
  pushSTACK(L_to_I(w)); pushSTACK(L_to_I(h));
  STACK_to_mv(2); # returns two values: w and h
}

# (STDWIN::WINDOW-SIZE win) calls wgetwinsize().
LISPFUNN(stdwin_window_size,1)
{ var reg2 object arg = popSTACK();
  var reg1 WINDOW* win = test_window(arg);
  var int w;
  var int h;
  begin_call();
  wgetwinsize(win,&w,&h);
  end_call();
  pushSTACK(L_to_I(w)); pushSTACK(L_to_I(h));
  STACK_to_mv(2); # returns two values: w and h
}

# (STDWIN::WINDOW-POSITION win) calls wgetwinpos().
LISPFUNN(stdwin_window_position,1)
{ var reg2 object arg = popSTACK();
  var reg1 WINDOW* win = test_window(arg);
  var int x;
  var int y;
  begin_call();
  wgetwinpos(win,&x,&y);
  end_call();
  pushSTACK(L_to_I(x)); pushSTACK(L_to_I(y));
  STACK_to_mv(2); # returns two values: x and y
}

# (STDWIN::WINDOW-DOCUMENT-SIZE win) calls wgetdocsize().
LISPFUNN(stdwin_window_document_size,1)
{ var reg2 object arg = popSTACK();
  var reg1 WINDOW* win = test_window(arg);
  var int w;
  var int h;
  begin_call();
  wgetdocsize(win,&w,&h);
  end_call();
  pushSTACK(L_to_I(w)); pushSTACK(L_to_I(h));
  STACK_to_mv(2); # returns two values: w and h
}

# (STDWIN::SET-WINDOW-DOCUMENT-SIZE win width height) calls wsetdocsize().
LISPFUNN(stdwin_set_window_document_size,3)
{ var reg3 WINDOW* win = test_window(STACK_2);
  var reg2 sintL w = I_to_L(STACK_1);
  var reg1 sintL h = I_to_L(STACK_0);
  begin_call();
  wsetdocsize(win,w,h);
  end_call();
  STACK_to_mv(2); # returns two values: w and h
  skipSTACK(1);
}

# (STDWIN::WINDOW-TITLE win) calls wgettitle().
LISPFUNN(stdwin_window_title,1)
{ var reg2 object arg = popSTACK();
  var reg1 WINDOW* win = test_window(arg);
  var reg3 char* title;
  begin_call();
  title = wgettitle(win);
  end_call();
  value1 = (title==NULL ? NIL : asciz_to_string(title)); mv_count=1;
}

# (STDWIN::SET-WINDOW-TITLE win string) calls wsettitle().
LISPFUNN(stdwin_set_window_title,2)
{ var reg4 WINDOW* win = test_window(STACK_1);
  if (!mstringp(STACK_0)) { fehler_string(STACK_0); }
  with_string_0(STACK_0,title,
    { begin_call();
      wsettitle(win,title);
      end_call();
    });
  value1 = STACK_0; mv_count=1; # returns the string
  skipSTACK(2);
}

  nonreturning_function(local, fehler_not_cursor_type, (object string));
  local void fehler_not_cursor_type(string)
    var reg2 object string;
    { pushSTACK(string);
      pushSTACK(TheSubr(subr_self)->name);      
      //: DEUTSCH "~: Argument ~ benennt keinen Cursor-Typ."
      //: ENGLISH "~: argument ~ does not name a cursor type"
      //: FRANCAIS "~ : L'argument ~ n'est pas le nom d'un CURSOR."
      fehler(error, GETTEXT("~: argument ~ does not name a cursor type"));
    }

# (STDWIN::SET-WINDOW-CURSOR win string) calls wfetchcursor() and wsetwincursor().
LISPFUNN(stdwin_set_window_cursor,2)
{ var reg4 WINDOW* win = test_window(STACK_1);
  if (!mstringp(STACK_0)) { fehler_string(STACK_0); }
  with_string_0(STACK_0,cursor_name,
    { begin_call();
     {var reg5 CURSOR* cur = wfetchcursor(cursor_name);
      if (cur == NULL)
        { end_call();
          fehler_not_cursor_type(STACK_0);
        }
      wsetwincursor(win,cur);
      end_call();
    }});
  value1 = STACK_0; mv_count=1; # returns the string
  skipSTACK(2);
}

# (STDWIN::WINDOW-SHOW win left top right bottom) calls wshow().
# (STDWIN::WINDOW-ORIGIN win) calls wgetorigin().
# (STDWIN::SET-WINDOW-ORIGIN win x y) calls wsetorigin().
# (STDWIN::WINDOW-CHANGE win left top right bottom) calls wchange().
# (STDWIN::WINDOW-UPDATE win) calls wupdate().

# (STDWIN::WINDOW-SHOW win left top right bottom) calls wshow().
LISPFUNN(stdwin_window_show,5)
{ var reg5 WINDOW* win = test_window(STACK_4);
  var reg4 sintL left   = I_to_L(STACK_3);
  var reg3 sintL top    = I_to_L(STACK_2);
  var reg2 sintL right  = I_to_L(STACK_1);
  var reg1 sintL bottom = I_to_L(STACK_0);
  begin_call();
  wshow(win,left,top,right,bottom);
  end_call();
  skipSTACK(5);
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::WINDOW-ORIGIN win) calls wgetorigin().
LISPFUNN(stdwin_window_origin,1)
{ var reg2 object arg = popSTACK();
  var reg1 WINDOW* win = test_window(arg);
  var int x;
  var int y;
  begin_call();
  wgetorigin(win,&x,&y);
  end_call();
  pushSTACK(L_to_I(x)); pushSTACK(L_to_I(y));
  STACK_to_mv(2); # returns two values: x and y
}

# (STDWIN::SET-WINDOW-ORIGIN win x y) calls wsetorigin().
LISPFUNN(stdwin_set_window_origin,3)
{ var reg3 WINDOW* win = test_window(STACK_2);
  var reg2 sintL x = I_to_L(STACK_1);
  var reg1 sintL y = I_to_L(STACK_0);
  begin_call();
  wsetorigin(win,x,y);
  end_call();
  STACK_to_mv(2); # returns two values: x and y
  skipSTACK(1);
}

# (STDWIN::WINDOW-CHANGE win left top right bottom) calls wchange().
LISPFUNN(stdwin_window_change,5)
{ var reg5 WINDOW* win = test_window(STACK_4);
  var reg4 sintL left   = I_to_L(STACK_3);
  var reg3 sintL top    = I_to_L(STACK_2);
  var reg2 sintL right  = I_to_L(STACK_1);
  var reg1 sintL bottom = I_to_L(STACK_0);
  begin_call();
  wchange(win,left,top,right,bottom);
  end_call();
  skipSTACK(5);
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::WINDOW-UPDATE win) calls wupdate().
LISPFUNN(stdwin_window_update,1)
{ var reg1 WINDOW* win = test_window(popSTACK());
  begin_call();
  wupdate(win);
  end_call();
  value1 = NIL; mv_count=1; # returns NIL
}

#                           Drawing in a document
#                           +++++++++++++++++++++

#                          Preparation for drawing
#                          -----------------------

# (STDWIN::BEGIN-DRAWING win) calls wbegindrawing().
# (STDWIN::END-DRAWING win) calls wenddrawing().

# (STDWIN::BEGIN-DRAWING win) calls wbegindrawing().
LISPFUNN(stdwin_begin_drawing,1)
{ var reg1 WINDOW* win = test_window(popSTACK());
  begin_call();
  wbegindrawing(win);
  end_call();
  value1 = NIL; mv_count=0; # returns nothing
}

# (STDWIN::END-DRAWING win) calls wenddrawing().
LISPFUNN(stdwin_end_drawing,1)
{ var reg1 WINDOW* win = test_window(popSTACK());
  begin_call();
  wenddrawing(win);
  end_call();
  value1 = NIL; mv_count=0; # returns nothing
}

# These cannot be used: they are not implemented in STDWIN-ALFA.
# (STDWIN::CLIP left top right bottom) calls wcliprect().
# (STDWIN::NOCLIP) calls wnoclip().

#                           Graphical primitives
#                           --------------------

# (STDWIN::DRAW-LINE x1 y1 x2 y2) calls wdrawline().
LISPFUNN(stdwin_draw_line,4)
{ var reg4 sintL x1 = I_to_L(STACK_3);
  var reg3 sintL y1 = I_to_L(STACK_2);
  var reg2 sintL x2 = I_to_L(STACK_1);
  var reg1 sintL y2 = I_to_L(STACK_0);
  check_init();
  begin_call();
  wdrawline(x1,y1,x2,y2);
  end_call();
  skipSTACK(4);
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::XOR-LINE x1 y1 x2 y2) calls wxorline().
LISPFUNN(stdwin_xor_line,4)
{ var reg4 sintL x1 = I_to_L(STACK_3);
  var reg3 sintL y1 = I_to_L(STACK_2);
  var reg2 sintL x2 = I_to_L(STACK_1);
  var reg1 sintL y2 = I_to_L(STACK_0);
  check_init();
  begin_call();
  wxorline(x1,y1,x2,y2);
  end_call();
  skipSTACK(4);
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::DRAW-BOX left top right bottom) calls wdrawbox().
LISPFUNN(stdwin_draw_box,4)
{ var reg4 sintL left   = I_to_L(STACK_3);
  var reg3 sintL top    = I_to_L(STACK_2);
  var reg2 sintL right  = I_to_L(STACK_1);
  var reg1 sintL bottom = I_to_L(STACK_0);
  check_init();
  begin_call();
  wdrawbox(left,top,right,bottom);
  end_call();
  skipSTACK(4);
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::PAINT left top right bottom) calls wpaint().
LISPFUNN(stdwin_paint,4)
{ var reg4 sintL left   = I_to_L(STACK_3);
  var reg3 sintL top    = I_to_L(STACK_2);
  var reg2 sintL right  = I_to_L(STACK_1);
  var reg1 sintL bottom = I_to_L(STACK_0);
  check_init();
  begin_call();
  wpaint(left,top,right,bottom);
  end_call();
  skipSTACK(4);
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::INVERT left top right bottom) calls winvert().
LISPFUNN(stdwin_invert,4)
{ var reg4 sintL left   = I_to_L(STACK_3);
  var reg3 sintL top    = I_to_L(STACK_2);
  var reg2 sintL right  = I_to_L(STACK_1);
  var reg1 sintL bottom = I_to_L(STACK_0);
  check_init();
  begin_call();
  winvert(left,top,right,bottom);
  end_call();
  skipSTACK(4);
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::ERASE left top right bottom) calls werase().
LISPFUNN(stdwin_erase,4)
{ var reg4 sintL left   = I_to_L(STACK_3);
  var reg3 sintL top    = I_to_L(STACK_2);
  var reg2 sintL right  = I_to_L(STACK_1);
  var reg1 sintL bottom = I_to_L(STACK_0);
  check_init();
  begin_call();
  werase(left,top,right,bottom);
  end_call();
  skipSTACK(4);
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::SHADE left top right bottom percent) calls wshade().
LISPFUNN(stdwin_shade,5)
{ var reg4 sintL left   = I_to_L(STACK_4);
  var reg3 sintL top    = I_to_L(STACK_3);
  var reg2 sintL right  = I_to_L(STACK_2);
  var reg1 sintL bottom = I_to_L(STACK_1);
  if (mfloatp(STACK_0))
    { # percent := (round (* percent 100))
      pushSTACK(fixnum(100)); funcall(L(mal),2);
      pushSTACK(value1); funcall(L(round),1);
      pushSTACK(value1);
    }
 {var reg5 sintL percent = I_to_L(STACK_0);
  check_init();
  begin_call();
  wshade(left,top,right,bottom,percent);
  end_call();
  skipSTACK(5);
  value1 = NIL; mv_count=1; # returns NIL
}}

# (STDWIN::DRAW-CIRCLE x y radius) calls wdrawcircle().
LISPFUNN(stdwin_draw_circle,3)
{ var reg3 sintL x = I_to_L(STACK_2);
  var reg2 sintL y = I_to_L(STACK_1);
  var reg1 sintL radius = I_to_L(STACK_0);
  check_init();
  begin_call();
  wdrawcircle(x,y,radius);
  end_call();
  skipSTACK(3);
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::XOR-CIRCLE x y radius) calls wxorcircle().
LISPFUNN(stdwin_xor_circle,3)
{ var reg3 sintL x = I_to_L(STACK_2);
  var reg2 sintL y = I_to_L(STACK_1);
  var reg1 sintL radius = I_to_L(STACK_0);
  check_init();
  begin_call();
  wxorcircle(x,y,radius);
  end_call();
  skipSTACK(3);
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::FILL-CIRCLE x y radius) calls wfillcircle().
LISPFUNN(stdwin_fill_circle,3)
{ var reg3 sintL x = I_to_L(STACK_2);
  var reg2 sintL y = I_to_L(STACK_1);
  var reg1 sintL radius = I_to_L(STACK_0);
  check_init();
  begin_call();
  wfillcircle(x,y,radius);
  end_call();
  skipSTACK(3);
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::DRAW-ARC x y rx ry angle1 angle2) calls wdrawelarc().
LISPFUNN(stdwin_draw_arc,6)
{ var reg6 sintL x = I_to_L(STACK_5);
  var reg5 sintL y = I_to_L(STACK_4);
  var reg4 sintL rx = I_to_L(STACK_3);
  var reg3 sintL ry = I_to_L(STACK_2);
  var reg2 sintL angle1 = I_to_L(STACK_1);
  var reg1 sintL angle2 = I_to_L(STACK_0);
  check_init();
  begin_call();
  wdrawelarc(x,y,rx,ry,angle1,angle2);
  end_call();
  skipSTACK(6);
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::XOR-ARC x y rx ry angle1 angle2) calls wxorelarc().
LISPFUNN(stdwin_xor_arc,6)
{ var reg6 sintL x = I_to_L(STACK_5);
  var reg5 sintL y = I_to_L(STACK_4);
  var reg4 sintL rx = I_to_L(STACK_3);
  var reg3 sintL ry = I_to_L(STACK_2);
  var reg2 sintL angle1 = I_to_L(STACK_1);
  var reg1 sintL angle2 = I_to_L(STACK_0);
  check_init();
  begin_call();
  wxorelarc(x,y,rx,ry,angle1,angle2);
  end_call();
  skipSTACK(6);
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::FILL-ARC x y rx ry angle1 angle2) calls wfillelarc().
LISPFUNN(stdwin_fill_arc,6)
{ var reg6 sintL x = I_to_L(STACK_5);
  var reg5 sintL y = I_to_L(STACK_4);
  var reg4 sintL rx = I_to_L(STACK_3);
  var reg3 sintL ry = I_to_L(STACK_2);
  var reg2 sintL angle1 = I_to_L(STACK_1);
  var reg1 sintL angle2 = I_to_L(STACK_0);
  check_init();
  begin_call();
  wfillelarc(x,y,rx,ry,angle1,angle2);
  end_call();
  skipSTACK(6);
  value1 = NIL; mv_count=1; # returns NIL
}

#                       Text drawing primitives
#                       -----------------------

# (STDWIN::DRAW-CHAR x y char) calls wdrawchar().
LISPFUNN(stdwin_draw_char,3)
{ var reg2 sintL x = I_to_L(STACK_2);
  var reg1 sintL y = I_to_L(STACK_1);
  if (!string_char_p(STACK_0)) { fehler_string_char(STACK_0); }
  check_init();
  begin_call();
  wdrawchar(x,y,char_code(STACK_0));
  end_call();
  skipSTACK(3);
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::DRAW-TEXT x y string) calls wdrawtext().
LISPFUNN(stdwin_draw_text,3)
{ var reg6 sintL x = I_to_L(STACK_2);
  var reg5 sintL y = I_to_L(STACK_1);
  var reg1 object string = STACK_0;
  if (!stringp(string)) { fehler_string(string); } # muß ein String sein
  check_init();
  with_string(string,chars,len,
    if (len > 0)
      { begin_call();
        wdrawtext(x,y,chars,len);
        end_call();
      }
    );
  skipSTACK(3);
  value1 = NIL; mv_count=1; # returns NIL
}

#                       Text measuring primitives
#                       -------------------------

# (STDWIN::LINE-HEIGHT) calls wlineheight().
LISPFUNN(stdwin_line_height,0)
{ check_init();
  begin_call();
 {var reg1 sintL h = wlineheight();
  end_call();
  value1 = L_to_I(h); mv_count=1;
}}

# (STDWIN::CHAR-WIDTH char) calls wcharwidth().
LISPFUNN(stdwin_char_width,1)
{ var reg1 object ch = popSTACK();
  if (!string_char_p(ch))
    { pushSTACK(ch); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(S(string_char)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(ch); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: Argument ~ ist kein String-Char."
      //: ENGLISH "~: argument ~ is not a string-char"
      //: FRANCAIS "~: L'argument ~ n'est pas un caractère de type STRING-CHAR."
      fehler(type_error, GETTEXT("~: argument ~ is not a string-char"));
    }
  check_init();
  begin_call();
 {var reg2 sintL w = wcharwidth(char_code(ch));
  end_call();
  value1 = L_to_I(w); mv_count=1;
}}

# (STDWIN::TEXT-WIDTH string) calls wtextwidth().
LISPFUNN(stdwin_text_width,1)
{ var reg1 object string = popSTACK();
  if (!stringp(string)) { fehler_string(string); } # muß ein String sein
 {var reg4 sintL w;
  check_init();
  with_string(string,chars,len,
    { begin_call();
      w = wtextwidth(chars,len);
      end_call();
    });
  value1 = L_to_I(w); mv_count=1;
}}

# (STDWIN::TEXT-BREAK string width) calls wtextbreak().
LISPFUNN(stdwin_text_break,2)
{ var reg1 object string = STACK_1;
  if (!stringp(string)) { fehler_string(string); } # muß ein String sein
 {var reg6 sintL width = I_to_L(STACK_0);
  var reg4 sintL w;
  check_init();
  with_string(string,chars,len,
    { begin_call();
      w = wtextbreak(chars,len,width);
      end_call();
    });
  value1 = L_to_I(w); mv_count=1;
  skipSTACK(2);
}}

#                             Text style
#                             ----------

# (STDWIN::SET-TEXT-FONT font-name font-style font-size) sets the current font.
LISPFUNN(stdwin_set_text_font,3)
{ var reg4 object string = STACK_2;
  if (!stringp(string)) { fehler_string(string); } # muß ein String sein
 {var reg5 sintL style = I_to_L(STACK_1);
  var reg6 sintL size = I_to_L(STACK_0);
  check_init();
  with_string_0(string,fontname,
    { begin_call();
      wsetfont(fontname);
      switch (style)
        { case 0: wsetplain();      break;
          case 1: wsethilite();     break;
          case 2: wsetinverse();    break;
          case 3: wsetitalic();     break;
          case 4: wsetbold();       break;
          case 5: wsetbolditalic(); break;
          case 6: wsetunderline();  break;
          default: break;
        }
      wsetsize(size);
      end_call();
    });
  skipSTACK(3);
  value1 = NIL; mv_count=1; # returns NIL
}}

#                               Events
#                               ++++++

# returns an event as a set of multiple values (no consing!)
# return_event(event);
  local Values return_event (EVENT* ep);
  local Values return_event(ep)
    var reg1 EVENT* ep;
    { # cf. stdwin/H/stdwin.h, definition of 'struct _event'
      var reg2 uintC mvcount;
      pushSTACK(L_to_I(ep->type));
      pushSTACK(type_untype_object(machine_type,ep->window));
      # the next values provide more specific information
      switch (ep->type)
        { case WE_CHAR:
            pushSTACK(L_to_I(ep->u.character));
            mvcount=3; break;
          case WE_COMMAND:
            pushSTACK(L_to_I(ep->u.command));
            mvcount=3; break;
          case WE_MENU:
            pushSTACK(L_to_I(ep->u.m.id));
            pushSTACK(L_to_I(ep->u.m.item));
            mvcount=4; break;
          case WE_DRAW:
            pushSTACK(L_to_I(ep->u.area.left));
            pushSTACK(L_to_I(ep->u.area.top));
            pushSTACK(L_to_I(ep->u.area.right - ep->u.area.left));
            pushSTACK(L_to_I(ep->u.area.bottom - ep->u.area.top));
            mvcount=6; break;
          case WE_MOUSE_DOWN: case WE_MOUSE_MOVE: case WE_MOUSE_UP:
            pushSTACK(L_to_I(ep->u.where.h));
            pushSTACK(L_to_I(ep->u.where.v));
            pushSTACK(L_to_I(ep->u.where.clicks));
            pushSTACK(L_to_I(ep->u.where.button));
            pushSTACK(L_to_I(ep->u.where.mask));
            mvcount=7; break;
          case WE_LOST_SEL:
            pushSTACK(L_to_I(ep->u.sel));
            mvcount=3; break;
          case WE_KEY:
            pushSTACK(L_to_I(ep->u.key.code));
            pushSTACK(L_to_I(ep->u.key.mask));
            mvcount=4; break;
          default:
            mvcount=2; break;
        }
      STACK_to_mv(mvcount);
    }

#                         STDWIN-generated events
#                         -----------------------

# This section was written by Pierpaolo Bernardi <bernardp@cli.di.unipi.it>.

# (STDWIN::WINDOW-SET-TIMER win decisec) calls wsettimer().
LISPFUNN(stdwin_window_set_timer,2)
{ var reg1 decisec = I_to_L(popSTACK());
  var reg2 WINDOW* win = test_window(popSTACK());
  begin_call();
  wsettimer(win,decisec);
  end_call();
  value1 = NIL; mv_count = 1;
}

#                           The input model
#                           +++++++++++++++

# (STDWIN::GET-EVENT) calls wgetevent().
# (STDWIN::GET-EVENT-NO-HANG) calls wpollevent().

# (STDWIN::GET-EVENT) calls wgetevent().
LISPFUNN(stdwin_get_event,0)
{ check_init();
 {var EVENT event;
  begin_call();
  wgetevent(&event);
  end_call();
  return_event(&event);
}}

# (STDWIN::GET-EVENT-NO-HANG) calls wpollevent().
LISPFUNN(stdwin_get_event_no_hang,0)
{ check_init();
 {var EVENT event;
  begin_call();
  wpollevent(&event);
  end_call();
  return_event(&event);
}}

#                  Getting and setting the active window
#                  +++++++++++++++++++++++++++++++++++++

# (STDWIN::ACTIVE-WINDOW) calls wgetactive().
# (STDWIN::SET-ACTIVE-WINDOW win) calls wsetactive().

# (STDWIN::ACTIVE-WINDOW) calls wgetactive().
LISPFUNN(stdwin_active_window,0)
{ var reg1 WINDOW* win;
  check_init();
  begin_call();
  win = wgetactive();
  end_call();
  value1 = (nullp(find_win(win)) ? NIL : type_untype_object(machine_type,win));
  mv_count=1;
}

# (STDWIN::SET-ACTIVE-WINDOW win) calls wsetactive().
LISPFUNN(stdwin_set_active_window,1)
{ var reg1 WINDOW* win = test_window(STACK_0);
  begin_call();
  wsetactive(win);
  end_call();
  value1 = popSTACK(); mv_count=1; # returns win
}

#                                  Menus
#                                  +++++

# The documentation says that the menu id's should be in the range [1..255] and
# unique within the application. We therefore manage the menu id's here.
  #define menu_id_MAX  255
  local unsigned int menu_id_max = 0; # maximum menu id that has been used for now
  local MENU* menu_id[1+menu_id_MAX]; # menu_id[1..menu_id_max] are in use

# (STDWIN::MENU-CREATE title) calls wmenucreate().
LISPFUNN(stdwin_menu_create,1)
{ var reg2 object string = popSTACK();
  if (!stringp(string)) { fehler_string(string); } # muß ein String sein
  check_init();
  # find a free menu id:
 {var reg1 unsigned int id;
  for (id = menu_id_max; id > 0; id--) { if (menu_id[id] == NULL) break; }
  if (id == 0)
    { if (menu_id_max < menu_id_MAX)
        { id = ++menu_id_max; menu_id[id] = NULL; }
        else
        { pushSTACK(TheSubr(subr_self)->name);
          //: DEUTSCH "~: STDWIN begrenzt die Anzahl der aktiven Menüs."
          //: ENGLISH "~: STDWIN limits the number of active menus"
          //: FRANCAIS "~ : STDWIN n'a qu'un nombre limité de menus."
          fehler(error, GETTEXT("~: STDWIN limits the number of active menus"));
    }   }
  with_string_0(string,title,
    { begin_call();
      menu_id[id] = wmenucreate(id,title);
      end_call();
    });
  value1 = fixnum(id); mv_count=1;
}}

# test_menu(arg) checks that an argument is an STDWIN menu, and returns its id.
  local int test_menu (object arg);
  local int test_menu(arg)
    var reg2 object arg;
    { if (posfixnump(arg))
        { var reg1 uintL id = posfixnum_to_L(arg);
          if ((id > 0) && (id <= menu_id_max))
            { var reg3 MENU* mp = menu_id[id];
              if (!(mp == NULL))
                { return id; }
        }   }
      pushSTACK(arg);
      pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: Argument ~ ist kein STDWIN:MENU."
      //: ENGLISH "~: argument ~ is not a STDWIN:MENU"
      //: FRANCAIS "~ : L'argument ~ n'est pas de type STDWIN:MENU."
      fehler(error, GETTEXT("~: argument ~ is not a STDWIN:MENU"));
   }

# (STDWIN::MENU-DELETE menu) calls wmenudelete().
LISPFUNN(stdwin_menu_delete,1)
{ var reg1 int id = test_menu(popSTACK());
  begin_call();
  wmenudelete(menu_id[id]);
  end_call();
  if (id==menu_id_max) { menu_id_max--; } else { menu_id[id] = NULL; }
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::MENU-ATTACH window menu) calls wmenuattach().
LISPFUNN(stdwin_menu_attach,2)
{ var reg2 WINDOW* win = test_window(STACK_1);
  var reg1 int id = test_menu(STACK_0);
  begin_call();
  wmenuattach(win,menu_id[id]);
  end_call();
  skipSTACK(2);
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::MENU-DETACH window menu) calls wmenudetach().
LISPFUNN(stdwin_menu_detach,2)
{ var reg2 WINDOW* win = test_window(STACK_1);
  var reg1 int id = test_menu(STACK_0);
  begin_call();
  wmenudetach(win,menu_id[id]);
  end_call();
  skipSTACK(2);
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::MENU-SIZE menu) returns the number of items in a menu.
LISPFUNN(stdwin_menu_size,1)
{ var reg1 int id = test_menu(popSTACK());
  value1 = L_to_I(((_FAKEMENU*)(menu_id[id]))->nitems); mv_count=1;
}

# (STDWIN::MENU-ADD-ITEM menu label [shortcut]) calls wmenuadditem().
LISPFUN(stdwin_menu_add_item,2,1,norest,nokey,0,NIL)
{ var reg2 int id = test_menu(STACK_2);
  var reg1 object string = STACK_1;
  if (!stringp(string)) { fehler_string(string); } # muß ein String sein
 {var reg3 object shortcut = STACK_0;
  var reg4 int sc;
  if (eq(shortcut,unbound) || nullp(shortcut)) { sc = -1; }
  elif (string_char_p(shortcut)) { sc = char_code(shortcut); }
  else { fehler_string_char(STACK_0); } # auch #\Control-x etc. zulassen??
  {var reg5 int result;
   with_string_0(string,label,
     { begin_call();
       result = wmenuadditem(menu_id[id],label,sc);
       end_call();
     });
   skipSTACK(3);
   value1 = L_to_I(result); mv_count=1; # returns the item's number
}}}

# test_item(id,arg) checks that an argument is a valid menu item.
  local int test_item (int id, object arg);
  local int test_item(id,arg)
    var reg1 int id;
    var reg1 object arg;
    { if (posfixnump(arg))
        { var reg1 uintL item = posfixnum_to_L(arg);
          if (item < ((_FAKEMENU*)(menu_id[id]))->nitems)
            { return item; }
        }
      pushSTACK(arg);
      pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: Argument ~ ist kein STDWIN:MENU-ITEM."
      //: ENGLISH "~: argument ~ is not a STDWIN:MENU-ITEM"
      //: FRANCAIS "~ : L'argument ~ n'est pas de type STDWIN:MENU-ITEM."
      fehler(error, GETTEXT("~: argument ~ is not a STDWIN:MENU-ITEM"));
    }

# (STDWIN::SET-MENU-ITEM-LABEL menu item-number label) calls wmenusetitem().
LISPFUNN(stdwin_set_menu_item_label,3)
{ var reg1 object string = STACK_0;
  if (!stringp(string)) { fehler_string(string); } # muß ein String sein
 {var reg2 int id = test_menu(STACK_2);
  var reg3 int item = test_item(id,STACK_1);
  with_string_0(string,label,
    { begin_call();
      wmenusetitem(menu_id[id],item,label);
      end_call();
    });
  value1 = STACK_0; mv_count=1; # returns the string
  skipSTACK(3);
}}

# (STDWIN::MENU-ITEM-ENABLE menu item-number) calls wmenuenable().
LISPFUNN(stdwin_menu_item_enable,2)
{ var reg1 int id = test_menu(STACK_1);
  var reg2 int item = test_item(id,STACK_0);
  begin_call();
  wmenuenable(menu_id[id],item,TRUE);
  end_call();
  value1 = T; mv_count=1; # returns T
  skipSTACK(2);
}

# (STDWIN::MENU-ITEM-DISABLE menu item-number) calls wmenuenable().
LISPFUNN(stdwin_menu_item_disable,2)
{ var reg1 int id = test_menu(STACK_1);
  var reg2 int item = test_item(id,STACK_0);
  begin_call();
  wmenuenable(menu_id[id],item,FALSE);
  end_call();
  value1 = NIL; mv_count=1; # returns NIL
  skipSTACK(2);
}

# (STDWIN::SET-MENU-ITEM-CHECKMARK menu item-number flag) calls wmenucheck().
LISPFUNN(stdwin_set_menu_item_checkmark,3)
{ var reg1 int id = test_menu(STACK_2);
  var reg2 int item = test_item(id,STACK_1);
  var reg3 int flag = (nullp(STACK_0) ? FALSE : TRUE);
  begin_call();
  wmenucheck(menu_id[id],item,flag);
  end_call();
  value1 = STACK_0; mv_count=1; # returns flag
  skipSTACK(3);
}

#                            The text caret
#                            ++++++++++++++

# This section was written by Pierpaolo Bernardi <bernardp@cli.di.unipi.it>.

# (STDWIN::WINDOW-SET-CARET win h v) calls wsetcaret().
LISPFUNN(stdwin_window_set_caret,3)
{ var reg2 object arg = STACK_2;
  var reg1 WINDOW* win = test_window(arg);
  var int h = I_to_L(STACK_1);
  var int v = I_to_L(STACK_0);
  begin_call();
  wsetcaret(win,h,v);
  end_call();
  skipSTACK(3);
  value1 = NIL; mv_count = 1;
}

# (STDWIN::WINDOW-NO-CARET win) calls wnocaret().
LISPFUNN(stdwin_window_no_caret,1)
{ var reg1 WINDOW* win = test_window(popSTACK());
  begin_call();
  wnocaret(win);
  end_call();
  value1 = NIL; mv_count = 1;
}

#                            Dialogue tools
#                            ++++++++++++++

# (STDWIN::USER-MESSAGE message) calls wmessage().
LISPFUNN(stdwin_user_message,1)
{ var reg1 object string = popSTACK();
  if (!stringp(string)) { fehler_string(string); } # muß ein String sein
  check_init();
  with_string_0(string,message,
    { begin_call();
      wmessage(message);
      end_call();
    });
  value1 = NIL; mv_count=1; # returns NIL
}

# (STDWIN::USER-ASK question [default-reply]) calls waskstr().
LISPFUN(stdwin_user_ask,1,1,norest,nokey,0,NIL)
{ var reg8 object string1 = STACK_1;
  if (!stringp(string1)) { fehler_string(string1); } # muß ein String sein
 {var reg7 object string2 = (mstringp(STACK_0) ? STACK_0 : O(leer_string));
  check_init();
  with_string_0(string1,question,
    { with_string(string2,default_chars,default_len,
        { var reg6 uintL reply_len = default_len + 10000; # reicht hoffentlich
          # Buffer für die Antwort reservieren:
          var DYNAMIC_ARRAY(_EMA_,reply_chars,char,reply_len);
          # default in reply umkopieren:
          { var reg2 char* ptr1 = default_chars;
            var reg1 char* ptr2 = reply_chars;
            var reg3 uintL count;
            dotimesL(count,default_len, { *ptr2++ = *ptr1++; } );
            *ptr2 = '\0';
          }
          begin_call();
         {var reg1 int result = waskstr(question,reply_chars,reply_len);
          end_call();
          value1 = (result ? asciz_to_string(reply_chars) : NIL); mv_count=1;
          FREE_DYNAMIC_ARRAY(reply_chars);
        }});
    });
  skipSTACK(2);
}}

#endif

#ifdef STDWIN_MODULE

#                  STDWIN as a linkable module for CLISP
#                  =====================================

#undef LISPFUN
#define LISPFUN LISPFUN_F
#undef LISPSYM
#define LISPSYM(name,printname,package)  { package, printname },
#define stdwin  "STDWIN"

subr_ module__stdwin__subr_tab [65] = {
  LISPFUNN(stdwin_init,0)
  LISPFUNN(stdwin_done,0)
  LISPFUNN(stdwin_drawproc_alist,0)
  LISPFUNN(stdwin_wopen,2)
  LISPFUNN(stdwin_wclose,1)
  LISPFUNN(stdwin_scrollbar_p,0)
  LISPFUNN(stdwin_set_scrollbar_p,2)
  LISPFUNN(stdwin_default_window_size,0)
  LISPFUNN(stdwin_set_default_window_size,2)
  LISPFUNN(stdwin_default_window_position,0)
  LISPFUNN(stdwin_set_default_window_position,2)
  LISPFUNN(stdwin_screen_size,0)
  LISPFUNN(stdwin_window_size,1)
  LISPFUNN(stdwin_window_position,1)
  LISPFUNN(stdwin_window_document_size,1)
  LISPFUNN(stdwin_set_window_document_size,3)
  LISPFUNN(stdwin_window_title,1)
  LISPFUNN(stdwin_set_window_title,2)
  LISPFUNN(stdwin_set_window_cursor,2)
  LISPFUNN(stdwin_window_show,5)
  LISPFUNN(stdwin_window_origin,1)
  LISPFUNN(stdwin_set_window_origin,3)
  LISPFUNN(stdwin_window_change,5)
  LISPFUNN(stdwin_window_update,1)
  LISPFUNN(stdwin_begin_drawing,1)
  LISPFUNN(stdwin_end_drawing,1)
  LISPFUNN(stdwin_draw_line,4)
  LISPFUNN(stdwin_xor_line,4)
  LISPFUNN(stdwin_draw_box,4)
  LISPFUNN(stdwin_paint,4)
  LISPFUNN(stdwin_invert,4)
  LISPFUNN(stdwin_erase,4)
  LISPFUNN(stdwin_shade,5)
  LISPFUNN(stdwin_draw_circle,3)
  LISPFUNN(stdwin_xor_circle,3)
  LISPFUNN(stdwin_fill_circle,3)
  LISPFUNN(stdwin_draw_arc,6)
  LISPFUNN(stdwin_xor_arc,6)
  LISPFUNN(stdwin_fill_arc,6)
  LISPFUNN(stdwin_draw_char,3)
  LISPFUNN(stdwin_draw_text,3)
  LISPFUNN(stdwin_line_height,0)
  LISPFUNN(stdwin_char_width,1)
  LISPFUNN(stdwin_text_width,1)
  LISPFUNN(stdwin_text_break,2)
  LISPFUNN(stdwin_set_text_font,3)
  LISPFUNN(stdwin_window_set_timer,2)
  LISPFUNN(stdwin_get_event,0)
  LISPFUNN(stdwin_get_event_no_hang,0)
  LISPFUNN(stdwin_active_window,0)
  LISPFUNN(stdwin_set_active_window,1)
  LISPFUNN(stdwin_menu_create,1)
  LISPFUNN(stdwin_menu_delete,1)
  LISPFUNN(stdwin_menu_attach,2)
  LISPFUNN(stdwin_menu_detach,2)
  LISPFUNN(stdwin_menu_size,1)
  LISPFUN(stdwin_menu_add_item,2,1,norest,nokey,0,NIL)
  LISPFUNN(stdwin_set_menu_item_label,3)
  LISPFUNN(stdwin_menu_item_enable,2)
  LISPFUNN(stdwin_menu_item_disable,2)
  LISPFUNN(stdwin_set_menu_item_checkmark,3)
  LISPFUNN(stdwin_window_set_caret,3)
  LISPFUNN(stdwin_window_no_caret,1)
  LISPFUNN(stdwin_user_message,1)
  LISPFUN(stdwin_user_ask,1,1,norest,nokey,0,NIL)
};

uintC module__stdwin__subr_tab_size = 65;

subr_initdata module__stdwin__subr_tab_initdata[65] = {
  LISPSYM(stdwin_init,"INIT",stdwin)
  LISPSYM(stdwin_done,"DONE",stdwin)
  LISPSYM(stdwin_drawproc_alist,"DRAWPROC-ALIST",stdwin)
  LISPSYM(stdwin_wopen,"WOPEN",stdwin)
  LISPSYM(stdwin_wclose,"WCLOSE",stdwin)
  LISPSYM(stdwin_scrollbar_p,"SCROLLBAR-P",stdwin)
  LISPSYM(stdwin_set_scrollbar_p,"SET-SCROLLBAR-P",stdwin)
  LISPSYM(stdwin_default_window_size,"DEFAULT-WINDOW-SIZE",stdwin)
  LISPSYM(stdwin_set_default_window_size,"SET-DEFAULT-WINDOW-SIZE",stdwin)
  LISPSYM(stdwin_default_window_position,"DEFAULT-WINDOW-POSITION",stdwin)
  LISPSYM(stdwin_set_default_window_position,"SET-DEFAULT-WINDOW-POSITION",stdwin)
  LISPSYM(stdwin_screen_size,"SCREEN-SIZE",stdwin)
  LISPSYM(stdwin_window_size,"WINDOW-SIZE",stdwin)
  LISPSYM(stdwin_window_position,"WINDOW-POSITION",stdwin)
  LISPSYM(stdwin_window_document_size,"WINDOW-DOCUMENT-SIZE",stdwin)
  LISPSYM(stdwin_set_window_document_size,"SET-WINDOW-DOCUMENT-SIZE",stdwin)
  LISPSYM(stdwin_window_title,"WINDOW-TITLE",stdwin)
  LISPSYM(stdwin_set_window_title,"SET-WINDOW-TITLE",stdwin)
  LISPSYM(stdwin_set_window_cursor,"SET-WINDOW-CURSOR",stdwin)
  LISPSYM(stdwin_window_show,"WINDOW-SHOW",stdwin)
  LISPSYM(stdwin_window_origin,"WINDOW-ORIGIN",stdwin)
  LISPSYM(stdwin_set_window_origin,"SET-WINDOW-ORIGIN",stdwin)
  LISPSYM(stdwin_window_change,"WINDOW-CHANGE",stdwin)
  LISPSYM(stdwin_window_update,"WINDOW-UPDATE",stdwin)
  LISPSYM(stdwin_begin_drawing,"BEGIN-DRAWING",stdwin)
  LISPSYM(stdwin_end_drawing,"END-DRAWING",stdwin)
  LISPSYM(stdwin_draw_line,"DRAW-LINE",stdwin)
  LISPSYM(stdwin_xor_line,"XOR-LINE",stdwin)
  LISPSYM(stdwin_draw_box,"DRAW-BOX",stdwin)
  LISPSYM(stdwin_paint,"PAINT",stdwin)
  LISPSYM(stdwin_invert,"INVERT",stdwin)
  LISPSYM(stdwin_erase,"ERASE",stdwin)
  LISPSYM(stdwin_shade,"SHADE",stdwin)
  LISPSYM(stdwin_draw_circle,"DRAW-CIRCLE",stdwin)
  LISPSYM(stdwin_xor_circle,"XOR-CIRCLE",stdwin)
  LISPSYM(stdwin_fill_circle,"FILL-CIRCLE",stdwin)
  LISPSYM(stdwin_draw_arc,"DRAW-ARC",stdwin)
  LISPSYM(stdwin_xor_arc,"XOR-ARC",stdwin)
  LISPSYM(stdwin_fill_arc,"FILL-ARC",stdwin)
  LISPSYM(stdwin_draw_char,"DRAW-CHAR",stdwin)
  LISPSYM(stdwin_draw_text,"DRAW-TEXT",stdwin)
  LISPSYM(stdwin_line_height,"LINE-HEIGHT",stdwin)
  LISPSYM(stdwin_char_width,"CHAR-WIDTH",stdwin)
  LISPSYM(stdwin_text_width,"TEXT-WIDTH",stdwin)
  LISPSYM(stdwin_text_break,"TEXT-BREAK",stdwin)
  LISPSYM(stdwin_set_text_font,"SET-TEXT-FONT",stdwin)
  LISPSYM(stdwin_window_set_timer,"WINDOW-SET-TIMER",stdwin)
  LISPSYM(stdwin_get_event,"GET-EVENT",stdwin)
  LISPSYM(stdwin_get_event_no_hang,"GET-EVENT-NO-HANG",stdwin)
  LISPSYM(stdwin_active_window,"ACTIVE-WINDOW",stdwin)
  LISPSYM(stdwin_set_active_window,"SET-ACTIVE-WINDOW",stdwin)
  LISPSYM(stdwin_menu_create,"MENU-CREATE",stdwin)
  LISPSYM(stdwin_menu_delete,"MENU-DELETE",stdwin)
  LISPSYM(stdwin_menu_attach,"MENU-ATTACH",stdwin)
  LISPSYM(stdwin_menu_detach,"MENU-DETACH",stdwin)
  LISPSYM(stdwin_menu_size,"MENU-SIZE",stdwin)
  LISPSYM(stdwin_menu_add_item,"MENU-ADD-ITEM",stdwin)
  LISPSYM(stdwin_set_menu_item_label,"SET-MENU-ITEM-LABEL",stdwin)
  LISPSYM(stdwin_menu_item_enable,"MENU-ITEM-ENABLE",stdwin)
  LISPSYM(stdwin_menu_item_disable,"MENU-ITEM-DISABLE",stdwin)
  LISPSYM(stdwin_set_menu_item_checkmark,"SET-MENU-ITEM-CHECKMARK",stdwin)
  LISPSYM(stdwin_window_no_caret,"WINDOW-NO-CARET",stdwin)
  LISPSYM(stdwin_user_message,"USER-MESSAGE",stdwin)
  LISPSYM(stdwin_user_message,"USER-MESSAGE",stdwin)
  LISPSYM(stdwin_user_ask,"USER-ASK",stdwin)
};

void module__stdwin__init_function_1(module)
  var module_* module;
  { }

void module__stdwin__init_function_2(module)
  var module_* module;
  { }

#endif

