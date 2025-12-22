@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "intuition/gadgetclass.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT gplayout
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(   8)@{fg text}   initial:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT gpgoinactive
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(   8)@{fg text}   abort:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT gpgoactive
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(   8)@{fg text}   ievent:PTR TO inputevent
@{fg shine}(  12)@{fg text}   termination:PTR TO LONG
@{fg shine}(  16)@{fg text}   mousex:INT
@{fg shine}(  18)@{fg text}   mousey:INT
@{fg shine}(  20)@{fg text}   tabletdata:PTR TO tabletdata
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=24 */

@{fg shine}(----)@{fg text} OBJECT gpinput
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(   8)@{fg text}   ievent:PTR TO inputevent
@{fg shine}(  12)@{fg text}   termination:PTR TO LONG
@{fg shine}(  16)@{fg text}   mousex:INT
@{fg shine}(  18)@{fg text}   mousey:INT
@{fg shine}(  20)@{fg text}   tabletdata:PTR TO tabletdata
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=24 */

@{fg shine}(----)@{fg text} OBJECT gprender
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(   8)@{fg text}   rport:PTR TO rastport
@{fg shine}(  12)@{fg text}   redraw:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT gphelptest
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(   8)@{fg text}   mousex:INT
@{fg shine}(  10)@{fg text}   mousey:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT gphittest
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(   8)@{fg text}   mousex:INT
@{fg shine}(  10)@{fg text}   mousey:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

CONST STRINGA_FONT=$80032008,
      STRINGA_WORKBUFFER=$80032004,
      STRINGA_UNDOBUFFER=$80032003,
      STRINGA_BUFFER=$80032002,
      GA_SYSGTYPE=$8003001E,
      STRINGA_ALTKEYMAP=$80032007,
      LORIENT_HORIZ=1,
      GM_HELPTEST=5,
      GM_HITTEST=0,
      STRINGA_BUFFERPOS=$80032005,
      GMRF_PREVACTIVE=$20,
      GMRF_NEXTACTIVE=16,
      GMRB_PREVACTIVE=5,
      GMRB_NEXTACTIVE=4,
      GMR_PREVACTIVE=$20,
      GMR_NEXTACTIVE=16,
      GMR_MEACTIVE=0,
      GM_GOINACTIVE=4,
      GM_GOACTIVE=2,
      GM_HANDLEINPUT=3,
      GA_RELSPECIAL=$80030027,
      LAYOUTA_DUMMY=$80038000,
      STRINGA_DUMMY=$80032000,
      PGA_DUMMY=$80031000,
      GA_ID=$80030010,
      GA_DUMMY=$80030000,
      GMRF_VERIFY=8,
      GMRB_VERIFY=3,
      GMR_VERIFY=8,
      GA_RELVERIFY=$80030016,
      GMR_HELPCODE=$10000,
      GA_DISABLED=$8003000E,
      GA_USERDATA=$80030011,
      GREDRAW_UPDATE=2,
      STRINGA_DISPPOS=$80032006,
      GA_IMMEDIATE=$80030015,
      STRINGA_TEXTVAL=$80032012,
      GMR_HELPHIT=-1,
      GMR_NOHELPHIT=0,
      GM_RENDER=1,
      GA_SELECTRENDER=$8003000C,
      GA_LABELIMAGE=$80030023,
      GA_FOLLOWMOUSE=$80030017,
      GA_IMAGE=$8003000A,
      PGA_HORIZPOT=$80031003,
      LAYOUTA_ORIENTATION=$80038003,
      STRINGA_JUSTIFICATION=$80032010,
      GA_SYSGADGET=$8003001D,
      GA_ENDGADGET=$80030014,
      GA_GZZGADGET=$8003000F,
      GA_INTUITEXT=$80030022,
      GA_TEXT=$80030009,
      LAYOUTA_LAYOUTOBJ=$80038001,
      GREDRAW_REDRAW=1,
      STRINGA_LONGVAL=$80032011,
      GA_TOGGLESELECT=$8003001C,
      GA_DRAWINFO=$80030021,
      GA_SPECIALINFO=$80030012,
      LORIENT_NONE=0,
      PGA_TOP=$80031009,
      GA_TOP=$80030003,
      PGA_VISIBLE=$80031008,
      STRINGA_NOFILTERMODE=$8003200F,
      STRINGA_FIXEDFIELDMODE=$8003200E,
      STRINGA_REPLACEMODE=$8003200D,
      PGA_FREEDOM=$80031001,
      GA_SELECTED=$80030013,
      GA_RELBOTTOM=$80030004,
      GA_HIGHLIGHT=$8003000D,
      GA_RELHEIGHT=$80030008,
      GA_HEIGHT=$80030007,
      GA_RELRIGHT=$80030002,
      STRINGA_EDITMODES=$8003200C,
      PGA_BORDERLESS=$80031002,
      SG_DEFAULTMAXCHARS=$80,
      STRINGA_MAXCHARS=$80032001,
      GA_LEFT=$80030001,
      PGA_TOTAL=$80031007,
      LORIENT_VERT=2,
      GMRF_REUSE=4,
      GMRF_NOREUSE=2,
      GMRB_REUSE=2,
      GMRB_NOREUSE=1,
      GMR_REUSE=4,
      GMR_NOREUSE=2,
      STRINGA_ACTIVEPENS=$8003200A,
      STRINGA_PENS=$80032009,
      GA_BOUNDS=$80030026,
      PGA_VERTBODY=$80031006,
      PGA_HORIZBODY=$80031004,
      LAYOUTA_SPACING=$80038002,
      STRINGA_EDITHOOK=$8003200B,
      GA_TABCYCLE=$80030024,
      PGA_VERTPOT=$80031005,
      GREDRAW_TOGGLE=0,
      PGA_NEWLOOK=$8003100A,
      GA_RELWIDTH=$80030006,
      GA_WIDTH=$80030005,
      GMR_GADGETHIT=4,
      STRINGA_EXITHELP=$80032013,
      GA_GADGETHELP=$80030025,
      GA_BOTTOMBORDER=$8003001B,
      GA_TOPBORDER=$8003001A,
      GA_LEFTBORDER=$80030019,
      GA_RIGHTBORDER=$80030018,
      GA_BORDER=$8003000B,
      GA_NEXT=$80030020,
      GA_PREVIOUS=$8003001F,
      GM_LAYOUT=6
@endnode
