@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "tools/easygui.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

/* osvers: 37+  */

/* this module contains 11068 bytes of code! */

/* ... and 46 reloc entries */

PROC easygui@{fg shine}(windowtitle,gui,info=0,screen=0,textattr=0,newmenus=0)@{fg text}
PROC guiinit@{fg shine}(windowtitle,gui,info=0,screen=0,textattr=0,newmenus=0)@{fg text}
PROC setscrollvisible@{fg shine}(gh,gad,visible)@{fg text}
PROC setlistvselected@{fg shine}(gh,gad,active)@{fg text}
PROC setscrolltotal@{fg shine}(gh,gad,total)@{fg text}
PROC guimessage@{fg shine}(guihandle)@{fg text}
PROC setinteger@{fg shine}(gh,gad,new)@{fg text}
PROC setcycle@{fg shine}(gh,gad,active)@{fg text}
PROC disposegui@{fg shine}(gui,x=0)@{fg text}
PROC setmx@{fg shine}(gh,gad,active)@{fg text}
PROC setstr@{fg shine}(gh,gad,new)@{fg text}
PROC cleangui@{fg shine}(guihandle)@{fg text}
PROC setslide@{fg shine}(gh,gad,new)@{fg text}
PROC setscrolltop@{fg shine}(gh,gad,top)@{fg text}
PROC findgadget@{fg shine}(gh,list)@{fg text}
PROC setcheck@{fg shine}(gh,gad,bool)@{fg text}
PROC setlistvlabels@{fg shine}(gh,gad,labs)@{fg text}

/* 1 private global variable@{fg shine}(s)@{fg text} in this module */

@{fg shine}(----)@{fg text} OBJECT guihandle
@{fg shine}(   0)@{fg text}   wnd:PTR TO window
@{fg shine}(   4)@{fg text}   sig:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=68 */

CONST RENDERFIXED=19,
      NUM=17,
      MX=10,
      BEVELR=5,
      SCROLL=13,
      LISTV=9,
      MAXGUI=27,
      EQROWS=1,
      ROWS=0,
      SPACE=25,
      SPACEH=24,
      RENDER=18,
      IMAGE=22,
      SPACEV=26,
      BAR=23,
      SLIDE=14,
      TEXT=16,
      CHECK=7,
      STR=15,
      EQCOLS=3,
      COLS=2,
      PALETTE=12,
      IBUTTON=21,
      SBUTTON=20,
      BUTTON=6,
      INTEGER=8,
      CYCLE=11,
      BEVEL=4
@endnode
