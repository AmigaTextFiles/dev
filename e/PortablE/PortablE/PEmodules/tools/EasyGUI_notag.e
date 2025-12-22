OPT MODULE, POINTER

MODULE 'tools/easygui', 'utility/tagitem'

PROC easygui(windowtitle,gui:ILIST,info=NIL,screen=NIL,textattr=NIL,
                    newmenus=NIL,ghaddr=NIL:PTR TO LONG,awproc=NIL,
                    x=-1,y=-1)
	DEF ret
ret := easyguiA(windowtitle,gui,
          [EG_INFO,   info,
           EG_SCRN,   screen,
           EG_FONT,   textattr,
           EG_MENU,   newmenus,
           EG_GHVAR,  ghaddr,
           EG_AWPROC, awproc,
           EG_LEFT,   x,
           EG_TOP,    y,
           NIL]:tagitem)
ENDPROC ret

PROC guiinit(windowtitle,gui:ILIST,info=NIL,screen=NIL,textattr=NIL,
                    newmenus=NIL,awproc=NIL,x=-1,y=-1)
	DEF ret:PTR TO guihandle
ret := guiinitA(windowtitle,gui,
          [EG_INFO,   info,
           EG_SCRN,   screen,
           EG_FONT,   textattr,
           EG_MENU,   newmenus,
           EG_AWPROC, awproc,
           EG_LEFT,   x,
           EG_TOP,    y,
           NIL]:tagitem)
ENDPROC ret
