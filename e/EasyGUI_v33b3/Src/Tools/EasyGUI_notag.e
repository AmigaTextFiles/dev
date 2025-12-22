OPT MODULE

MODULE 'tools/easygui'

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
