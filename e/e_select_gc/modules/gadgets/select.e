OPT MODULE
OPT EXPORT

/* $VER: select.h 40.14 (8.1.99) */
/* © 1999 by Massimo Tantignone  */
/* E module by Victor Ducedre    */

/* Public definitions for the "select gadget" BOOPSI class */

ENUM SGA_Dummy=$800A0000,
     SGA_ACTIVE,
     SGA_LABELS,
     SGA_MINITEMS,
     SGA_FULLPOPUP,
     SGA_POPUPDELAY,
     SGA_POPUPPOS,
     SGA_STICKY,
     SGA_TEXTATTR,
     SGA_TEXTFONT,
     SGA_TEXTPLACE,
     SGA_UNDERSCORE,
     SGA_JUSTIFY,
     SGA_QUIET,
     SGA_SYMBOL,
     SGA_SYMBOLWIDTH,
     SGA_SYMBOLONLY,
     SGA_SEPARATOR,
     SGA_LISTFRAME,
     SGA_DROPSHADOW,
     SGA_ITEMHEIGHT,
     SGA_LISTJUSTIFY,
     SGA_ACTIVEPENS,
     SGA_ACTIVEBOX,
     SGA_BORDERSIZE,
     SGA_FULLWIDTH,
     SGA_FOLLOWMODE,
     SGA_REPORTALL,
     SGA_REFRESH,
     SGA_ITEMSPACING,
     SGA_MINTIME,       /* Min anim duration (40.14) */
     SGA_MAXTIME,       /* Max anim duration (40.14) */
     SGA_PANELMODE      /* Window? Blocking? (40.14) */

ENUM SGJ_LEFT=0, SGJ_CENTER, SGJ_RIGHT

ENUM SGPOS_ONITEM=0, SGPOS_ONTOP, SGPOS_BELOW, SGPOS_RIGHT

ENUM SGFM_NONE=0, SGFM_KEEP, SGFM_FULL

ENUM SGPM_WINDOW=0, SGPM_DIRECT_NB, SGPM_DIRECT_B

CONST SGS_NOSYMBOL=$FFFFFFFF

/* Public structures for the "select gadget" BOOPSI class */

