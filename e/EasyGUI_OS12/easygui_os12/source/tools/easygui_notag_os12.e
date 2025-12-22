OPT MODULE
OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui'
#endif

EXPORT PROC easygui(windowtitle,gui,info=NIL,screen=NIL,textattr=NIL,
                    newmenus=NIL,ghaddr=NIL:PTR TO LONG,awproc=NIL,
                    x=-1,y=-1) IS
  easyguiA(windowtitle,gui,
          [EG_INFO,   info,
           EG_SCRN,   screen,
           EG_FONT,   textattr,
           EG_MENU,   newmenus,
           EG_GHVAR,  ghaddr,
           EG_AWPROC, awproc,
           EG_LEFT,   x,
           EG_TOP,    y,
           NIL])

EXPORT PROC guiinit(windowtitle,gui,info=NIL,screen=NIL,textattr=NIL,
                    newmenus=NIL,awproc=NIL,x=-1,y=-1) IS
  guiinitA(windowtitle,gui,
          [EG_INFO,   info,
           EG_SCRN,   screen,
           EG_FONT,   textattr,
           EG_MENU,   newmenus,
           EG_AWPROC, awproc,
           EG_LEFT,   x,
           EG_TOP,    y,
           NIL])
