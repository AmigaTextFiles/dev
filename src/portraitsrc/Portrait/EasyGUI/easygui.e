-> EasyGui.m, constructs fast nononsense font sensitive resizable gui's.

OPT MODULE, OSVERSION=37, PREPROCESS

-> Let only one of the following be defined:

->#define EASYGUI_LITE
#define EASYGUI_FULL
->#define EASYGUI_DEBUG


-> This selects various components based on above choice.
#ifndef EASYGUI_LITE
#define EASY_KEYBOARD
#ifdef EASYGUI_DEBUG
#ifndef EASYGUI_FULL
#define EASYGUI_FULL
#endif
#endif
#ifdef EASYGUI_FULL
#define EASY_APPWINDOW
#define EASY_EXTRAS
#endif
#endif

-> This enables a descriptive message before an exception is raised.
#ifdef EASYGUI_DEBUG
#define RaiseX(x,l,s) myraise(x,l,s)
MODULE 'tools/exceptions'
#endif
#ifndef EASYGUI_DEBUG
#define RaiseX(x,l,s) Raise(x)
#endif

MODULE 'gadtools',
       'exec/libraries', 'exec/lists', 'exec/nodes', 'exec/ports',
       'graphics/rastport', 'graphics/text',
       'graphics/gfx', 'graphics/videocontrol', 'graphics/view',
       'intuition/gadgetclass', 'intuition/imageclass', 'intuition/intuition',
       'intuition/screens',
       'libraries/gadtools',
       'tools/textlen', 'amigalib/lists',
       'utility/tagitem',
       'utility'

#ifdef EASY_APPWINDOW
MODULE 'wb', 'workbench/workbench'
#endif

#ifdef EASY_KEYBOARD
MODULE 'tools/ctype'
#endif

DEF utilitybase  -> Redefine for privateness

#ifdef EASY_EXTRAS
/************ multihandle ************/
EXPORT OBJECT multihandle
  sig
  opencount
PRIVATE
#ifdef EASY_APPWINDOW
  awport:PTR TO mp
#endif
  wndport:PTR TO mp
PUBLIC
  guis:lh
ENDOBJECT
#endif

-> The offset of the `link' node in a guihandle.  Used for getting
-> back to the guihandle from the node in the list.
CONST GH_LINK_OFFSET=16

/************ guihandle ************/
EXPORT OBJECT guihandle
  -> Window, Signal Mask (not Bit), Info
  wnd:PTR TO window,sig,info
#ifdef EASY_EXTRAS
  -> Multi-Window Handle
  mh:PTR TO multihandle
#endif
#ifdef EASY_EXTRAS
  -> Node for Linking GUIs in Multi-Window GUIs
  link:ln
#endif
  -> Private Window Pointer (so that wnd is a flag for GUI validity, too)
  pwnd:PTR TO window
PRIVATE
  -> Last Gadget, VisualInfo, Font, Font_uses_screen, GT_lib_is_open
  gl:PTR TO gadget,visual,tattr:PTR TO textattr,ta_scr,gt_isopen
  -> Gadget desc, Gadget list, Screen, Screen_is_WB
  base:PTR TO g,glist,scr:PTR TO screen,is_wb
  -> Min Width and Height, X and Y Offset Past Window Borders
  xsize,ysize,xoff,yoff
  -> Menus, Plugins
  menus, plugins:PTR TO plugin
#ifndef EASY_KEYBOARD
  -> First String Gadget
  firststr
#endif
#ifdef EASY_KEYBOARD
  -> Map of Key to Gadget
  keys[26]:ARRAY OF LONG
#endif
#ifdef EASY_APPWINDOW
  -> AppWindow Port, AppWindow, WB_lib_is_open
  awport:PTR TO mp,appwin,wb_isopen
#endif
#ifdef EASY_EXTRAS
  -> Requester used for Blocking
  req:PTR TO requester
#endif
  -> GUI X and Y, GUI Desc, Window Title, Menu Desc
  x,y,gui,wtitle,awproc,newmenus
  -> Window Port, OnClose Proc, Window Type, OnClean Proc
  wndport:PTR TO mp,onclose,wtype,onclean
  -> Hack to make menu selections safe
  menuitem:PTR TO LONG
#ifdef EASY_EXTRAS
  -> Count of blockwin() calls
  blockcnt
#endif
ENDOBJECT

-> Flag set for resizing constants.
SET CRSZ_X, CRSZ_Y, UNCOND_X, UNCOND_Y

EXPORT CONST COND_RESIZEX=CRSZ_X, COND_RESIZEY=CRSZ_Y
EXPORT CONST RESIZEX=COND_RESIZEX OR UNCOND_X, RESIZEY=COND_RESIZEY OR UNCOND_Y

CONST RESIZEXANDY=RESIZEX OR RESIZEY

-> Resize testing macros.
#define DoesXResize(flag) ((flag) AND COND_RESIZEX)
#define DoesYResize(flag) ((flag) AND COND_RESIZEY)
#define DoesXUncond(flag) ((flag) AND RESIZEX=RESIZEX)
#define DoesYUncond(flag) ((flag) AND RESIZEY=RESIZEY)

-> Gadget type constants.
->          0    1      2    3      4     5
EXPORT ENUM ROWS,EQROWS,COLS,EQCOLS,BEVEL,BEVELR,
->       6      7     8       9     10 11    12      13     14    15  16   17
         BUTTON,CHECK,INTEGER,LISTV,MX,CYCLE,PALETTE,SCROLL,SLIDE,STR,TEXT,NUM,
->       18      19     20  21     22    23     24      25
         SBUTTON,PLUGIN,BAR,SPACEH,SPACE,SPACEV,RBUTTON,MAXGUI

-> ROWS...      BUTTON...   PALETTE...      SBUTTON...     RBUTTON...
-> Mapping of gadget type to GT KIND.
#define KINDTAB \
  [0,0,0,0,0,0, 1,2,3,4,5,7,8,9,11,12,13,6, 1, 0, 0,0,0,0, 1,12]:CHAR
-> Mapping of gadget type to number of required arguments.
#define MINARGS \
  [2,2,2,2,2,2, 3,5,5,9,6,4,7,7, 9, 6, 5,5, 3, 3, 1,1,1,1, 3,6]:CHAR

-> Constants to index gadget desc lists.
EXPORT ENUM BEV_GUI=1,
  BUT_ACT=1, BUT_TXT,  BUT_DATA, BUT_KEY,  BUT_APPW, BUT_DIS,
  CHK_ACT=1, CHK_TXT,  CHK_VAL,  CHK_LEFT, CHK_DATA, CHK_KEY,  CHK_DIS,
  INT_ACT=1, INT_TXT,  INT_VAL,  INT_REL,  INT_DATA, INT_KEY,  INT_DIS,
  LST_ACT=1, LST_TXT,  LST_RELX, LST_RELY, LST_LIST, LST_RO,   LST_SHOW,
             LST_CURR, LST_DATA, LST_KEY,  LST_APPW, LST_DIS,
   MX_ACT=1,  MX_TXT,   MX_LIST,  MX_LEFT,  MX_CURR,  MX_DATA,  MX_KEY,
              MX_DIS,
  CYC_ACT=1, CYC_TXT,  CYC_LIST, CYC_CURR, CYC_DATA, CYC_KEY,  CYC_DIS,
  PAL_ACT=1, PAL_TXT,  PAL_DEP,  PAL_RELX, PAL_RELY, PAL_CURR, PAL_DATA,
             PAL_KEY,  PAL_DIS,
  SCR_ACT=1, SCR_VERT, SCR_TOTL, SCR_TOP,  SCR_VIS,  SCR_REL,  SCR_DATA,
             SCR_KEY,  SCR_DIS,
  SLI_ACT=1, SLI_TXT,  SLI_VERT, SLI_MIN,  SLI_MAX,  SLI_CURR, SLI_REL,
             SLI_FMT,  SLI_DATA, SLI_KEY,  SLI_DIS,
  STR_ACT=1, STR_TXT,  STR_STR,  STR_MAX,  STR_REL,  STR_OVR,  STR_DATA,
             STR_KEY,  STR_APPW, STR_DIS,
  TXT_VAL=1, TXT_TXT,  TXT_BORD, TXT_REL,
  NUM_VAL=1, NUM_TXT,  NUM_BORD, NUM_REL,
  PLG_ACT=1, PLG_OBJ,  PLG_GT,   PLG_APPW

ENUM EG_TYPE=0, EG_ACT, EG_TXT

-> Test group type macros.
#define IsRow(type)        ((type)<=EQROWS)
#define IsCol(type)        ((type)>EQROWS)
#define IsRowOrCol(type)   ((type)<BEVEL)
#define IsBevel(type)      ((type)<BUTTON)
#define IsGroup(type)      IsBevel(type)
#define IsEqualGroup(type) (((type)=EQROWS) OR ((type)=EQCOLS))

-> Test space sizing macros.
#define HasHSpace(type)    ((type)<=SPACE)
#define HasVSpace(type)    ((type)>=SPACE)
#define HSpace(type)       (IF HasHSpace(type) THEN RESIZEX ELSE 0)
#define VSpace(type)       (IF HasVSpace(type) THEN RESIZEY ELSE 0)
#define SpaceFlags(type)   (HSpace(type) OR VSpace(type))

-> Test button sizing macros.
#define HasHButtSp(type)   ((type)>=SBUTTON)
#define HasVButtSp(type)   ((type)=RBUTTON)
#define HButtSp(type)      (IF HasHButtSp(type) THEN RESIZEX ELSE 0)
#define VButtSp(type)      (IF HasVButtSp(type) THEN RESIZEY ELSE 0)
#define ButtSpFlags(type)  (HButtSp(type) OR VButtSp(type))

CONST SP=2,YSP=3            -> very basic spacing (Y=nonsense!?!)
CONST XSPACING=YSP,YSPACING=SP,   -> basic spacing between gadgets
      SIDESPACE=YSP,TOPSPACE=SP,  -> spacing to window border
      BUTXSPACE=16,BUTYSPACE=6,   -> space around text in button (min)
      BEVELXSPACE=4,BEVELYSPACE=3,  -> between bevelbox and inner gadgets
      MXSPACE=2,CHECKSPACE=2        -> between two mx and check gads

EXPORT ENUM WTYPE_NOBORDER, WTYPE_BASIC, WTYPE_NOSIZE, WTYPE_SIZE

EXPORT CONST WTYPE_REPORTMOUSE=$80, WTYPE_MASK=$4F

-> Window flags.
CONST WIN_FBASIC=WFLG_ACTIVATE OR WFLG_NEWLOOKMENUS
CONST WIN_FNOBORD=WFLG_BORDERLESS OR WIN_FBASIC
CONST WIN_FNOSIZE=WIN_FBASIC OR WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR
                  WFLG_CLOSEGADGET
CONST WIN_FSIZE=WIN_FNOSIZE OR WFLG_SIZEBBOTTOM OR WFLG_SIZEGADGET

-> Gadget click IDCMP.
CONST GAD_IDCMP=IDCMP_GADGETDOWN OR IDCMP_GADGETUP OR IDCMP_MOUSEMOVE

-> Window IDMCP (without NEWSIZE).
CONST WIN_IDCMP_NS=GAD_IDCMP OR IDCMP_REFRESHWINDOW OR IDCMP_MOUSEBUTTONS OR
                   IDCMP_MENUPICK OR IDCMP_CLOSEWINDOW OR IDCMP_RAWKEY OR
                   IDCMP_ACTIVEWINDOW OR IDCMP_INACTIVEWINDOW OR
                   IDCMP_INTUITICKS OR IDCMP_CHANGEWINDOW OR IDCMP_VANILLAKEY OR
                   IDCMP_DISKINSERTED OR IDCMP_DISKREMOVED

-> Window IDMCP (with NEWSIZE).
CONST WIN_IDCMP=IDCMP_NEWSIZE OR WIN_IDCMP_NS

-> Message loop constants.
CONST GUI_CONT=-1, GUI_QUIT=0

-> Action function test macro.
#define IsActionFun(ret) (((ret)<0) OR ((ret)>1000))

-> Convert to unsigned INT.
#define Unsigned(x) ((x) AND $FFFF)

-> System gadget aspect ratio macro.
#define SysISize(flags) \
        (IF (flags) AND SCREENHIRES THEN SYSISIZE_MEDRES ELSE SYSISIZE_LOWRES)

-> Gadget information extraction macros.
#define GadLongInt(gad) (gad.specialinfo::stringinfo.longint)
#define GadString(gad)  (gad.specialinfo::stringinfo.buffer)
#define IsChecked(gad)  ((gad.flags AND GFLG_SELECTED)<>0)

-> Constant to mark gadget has no mid-point.
CONST NO_MID=-1

-> Gadget data (intermediate level).
OBJECT g
  -> Link, X, Y, Width, Height
  next,x,y,xs,ys
  -> Gadget Type, Gadget Desc, Flags, Mid-Point
  type,list:PTR TO LONG,flags,mid
ENDOBJECT

/************ plugin ************/
EXPORT OBJECT plugin PRIVATE
  -> Gadget Data, Link
  base:PTR TO g, next:PTR TO plugin
PUBLIC
  -> X, Y, Width, Height
  x:INT,y:INT,xs:INT,ys:INT
  -> guihandle
  gh:PTR TO guihandle
ENDOBJECT

PROC min_size(ta,fontheight) OF plugin IS fontheight,fontheight
PROC will_resize() OF plugin IS RESIZEXANDY
PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF plugin IS FALSE
PROC message_action(class,qual,code,win:PTR TO window) OF plugin IS FALSE
PROC clear_render(win:PTR TO window) OF plugin IS EMPTY

PROC render(ta:PTR TO textattr,x,y,xs,ys,win:PTR TO window) OF plugin
  fillbox(win.rport,1,x,y,x+xs-1,y+ys-1)
ENDPROC

PROC appmessage(amsg,win:PTR TO window) OF plugin IS FALSE
PROC gtrender(gl,vis,ta,x,y,xs,ys,win) OF plugin IS gl
/************ plugin end ************/

-> Magic idenitifier for AppWindow gadgets.
CONST EG_MAGIC=$EA51EA51

-> Tag list constants
CONST EG_TAGBASE=TAG_USER+$4000

EXPORT ENUM EG_TITLE=EG_TAGBASE, EG_GUI,  EG_INFO, EG_SCRN, EG_FONT, EG_NEWMENU,
            EG_GHVAR, EG_AWPROC, EG_LEFT, EG_TOP,  EG_MAXW, EG_MAXH, EG_WTYPE,
            EG_CLOSE, EG_CLEAN,  EG_HIDE, EG_MENU

-> Gadget list attribute selection.
#define ATTR(gui,n)        gui[(n)]
#define HasATTR(list,n)    (ListLen((list))>n)
#define OptATTR(list,n)    optattr(list,n)
#define OptDefATTR(list,n) optdefattr(list,n)

PROC optattr(list:PTR TO LONG,n) IS IF HasATTR(list,n) THEN ATTR(list,n) ELSE 0

PROC optdefattr(list:PTR TO LONG,n)
  DEF res=-1
  IF HasATTR(list,n) THEN res:=ATTR(list,n)
ENDPROC IF res<>-1 THEN res ELSE list

PROC indexdata(type)
  DEF index, but=FALSE, val=0
  SELECT MAXGUI OF type
  CASE BUTTON,SBUTTON,RBUTTON;  index:=BUT_DATA; but:=TRUE
  CASE CHECK;    index:=CHK_DATA; val:=CHK_VAL
  CASE LISTV;    index:=LST_DATA
  CASE MX;       index:= MX_DATA
  CASE STR;      index:=STR_DATA; val:=STR_STR
  CASE INTEGER;  index:=INT_DATA; val:=INT_VAL
  CASE CYCLE;    index:=CYC_DATA
  CASE PALETTE;  index:=PAL_DATA
  CASE SCROLL;   index:=SCR_DATA
  CASE SLIDE;    index:=SLI_DATA
  ENDSELECT
ENDPROC index, but, val

#ifndef EASY_KEYBOARD
#ifndef EASY_EXTRAS
#define EASY_NOKEYBEXTRA
#endif
#endif

#ifndef EASY_NOKEYBEXTRA
-> Optional value based on index.
PROC optindex(i:PTR TO LONG,index) IS IF index THEN OptATTR(i,index) ELSE 0
#endif

#ifdef EASY_KEYBOARD
#define optkey(t,i) optindex(i,indexkey(t))
PROC indexkey(type)
  DEF index
  SELECT MAXGUI OF type
  CASE BUTTON,SBUTTON,RBUTTON;  index:=BUT_KEY
  CASE CHECK;    index:=CHK_KEY
  CASE LISTV;    index:=LST_KEY
  CASE MX;       index:= MX_KEY
  CASE STR;      index:=STR_KEY
  CASE INTEGER;  index:=INT_KEY
  CASE CYCLE;    index:=CYC_KEY
  CASE PALETTE;  index:=PAL_KEY
  CASE SCROLL;   index:=SCR_KEY
  CASE SLIDE;    index:=SLI_KEY
  ENDSELECT
ENDPROC index
#endif

#ifndef EASY_EXTRAS
#define optdis(t,i) 0
#endif
#ifdef EASY_EXTRAS
#define optdis(t,i) optindex(i,indexdis(t))
PROC indexdis(type)
  DEF index=0
  SELECT MAXGUI OF type
  CASE BUTTON,SBUTTON,RBUTTON;  index:=BUT_DIS
  CASE CHECK;    index:=CHK_DIS
  CASE LISTV;    index:=LST_DIS
  CASE MX;       index:= MX_DIS
  CASE STR;      index:=STR_DIS
  CASE INTEGER;  index:=INT_DIS
  CASE CYCLE;    index:=CYC_DIS
  CASE PALETTE;  index:=PAL_DIS
  CASE SCROLL;   index:=SCR_DIS
  CASE SLIDE;    index:=SLI_DIS
  ENDSELECT
ENDPROC index

/********** setdisabled **********/
EXPORT PROC setdisabled(gh,gad:PTR TO LONG,disabled=TRUE)
  DEF index
  index:=indexdis(ATTR(gad,EG_TYPE))
  IF HasATTR(gad,index) THEN setattr(gh,gad,disabled,GA_DISABLED,index)
ENDPROC
#endif

-> Clear window contents and redraw frame.
PROC clearwindow(w:PTR TO window)
  fillbox(w.rport,0,w.borderleft,w.bordertop,
          w.width-w.borderright-1, w.height-w.borderbottom-1)
  RefreshWindowFrame(w)
ENDPROC

PROC fillbox(rport,pen,x,y,x2,y2)
  SetAPen(rport,pen)
  RectFill(rport,x,y,x2,y2)
ENDPROC

-> Create new gadget data.
PROC newg(xs,ys,type,list,flags=0,mid=NO_MID) IS NEW [0,0,0,xs,ys,type,list,flags,mid]:g

-> Access functions for gadget type mapping lists.
PROC minARGS() IS MINARGS
PROC kindTAB() IS KINDTAB

#ifdef EASYGUI_DEBUG
-> In debug version this will be called instead of raising an exception.
PROC myraise(x,l,s)
  exception:=x;  exceptioninfo:=0
  WriteF('Just about to raise exception:\n')
  report_exception()
  IF (l>0) AND (l<2000)
    WriteF(' Error ref \d: \s\n',l,s)
  ELSE
    WriteF(' \s (Gadget list $\h)\n',s,l)
  ENDIF
  Raise(x)
ENDPROC
#endif

/********** easyguiA() **********/
EXPORT PROC easyguiA(title,gui,tags=NIL) HANDLE
  DEF gh=NIL:PTR TO guihandle,res=-1
  gh:=guiinitA(title,gui,tags)
  WHILE res<0
    Wait(gh.sig)
    res:=guimessage(gh)
  ENDWHILE
EXCEPT DO
  cleangui(gh)
  ReThrow()
ENDPROC res

/********** easygui_fallbackA() **********/
EXPORT PROC easygui_fallbackA(title,gui,tags=NIL) HANDLE
  RETURN easyguiA(title,gui,tags)
EXCEPT
  IF exception="bigg"
    RETURN easyguiA(title,gui,[EG_FONT,['topaz.font',8,0,0]:textattr,
                               TAG_MORE,tags])
  ENDIF
  ReThrow()
ENDPROC

-> Init font.
PROC initfont(gh:PTR TO guihandle,tattr)
  gh.tattr:=tattr
  gh.ta_scr:=(tattr=NIL)
ENDPROC

-> Init screen.
PROC initscr(gh:PTR TO guihandle,scr)
  gh.scr:=scr
  gh.is_wb:=(scr=NIL)
ENDPROC

-> Set up menus.
PROC setmenus(gh:PTR TO guihandle)
  -> setup menus
  IF gh.newmenus
    gh.menus:=CreateMenusA(gh.newmenus,NIL)
    IF gh.menus=NIL THEN RaiseX("GUI",431,'Could not create menus. Bad menu description? Or out of memory?')
    IF LayoutMenusA(gh.menus,gh.visual,[GTMN_NEWLOOKMENUS,TRUE,NIL])=FALSE THEN RaiseX("GUI",432,'Could not layout menus. Out of memory?')
    IF SetMenuStrip(gh.pwnd,gh.menus)=FALSE THEN RaiseX("GUI",433,'Could not set menu strip. Should never happen!')
  ELSEIF gh.menus
    IF SetMenuStrip(gh.pwnd,gh.menus)=FALSE THEN RaiseX("GUI",435,'Could not set menu strip. Should never happen!')
  ENDIF
ENDPROC

PROC win_off(n,s:PTR TO screen)
  DEF y
  IF (n AND WTYPE_MASK)=WTYPE_NOBORDER THEN RETURN 1,1
  y:=s.wbortop+TOPSPACE
  IF (n AND WTYPE_MASK)>WTYPE_BASIC THEN y:=y+s.rastport.txheight+1
ENDPROC s.wborleft+SIDESPACE,y

PROC win_pad(n,s:PTR TO screen)
  DEF y=TOPSPACE
  IF (n AND WTYPE_MASK)=WTYPE_NOBORDER THEN RETURN 1,1
  y:=y+IF (n AND WTYPE_MASK)=WTYPE_SIZE THEN getrealbot(s) ELSE s.wborbottom
ENDPROC s.wborright+SIDESPACE,y

-> Set up GUI.
PROC setgui(gh:PTR TO guihandle)
  DEF base:PTR TO g,s:PTR TO screen,w:PTR TO window,xsize,ysize,
      cm,h=NIL:PTR TO LONG,vpe=NIL:PTR TO viewportextra,x,y
  s:=gh.scr
  w:=gh.pwnd

  -> Get gadget data and calculate minimum GUI size.
  gh.base:=base:=minsize(gh.gui,gh)
  IF w=NIL
    -> Calculate offset of borders in window.
    x,y:=win_off(gh.wtype,s)
    gh.xoff:=x
    gh.yoff:=y
  ENDIF
  -> Calculate minimum width and height of window.
  x,y:=win_pad(gh.wtype,s)
  xsize:=x+gh.xoff+base.xs
  ysize:=y+gh.yoff+base.ys

  IF (xsize>s.width) OR (ysize>s.height) THEN RaiseX("bigg",455,'Size is too big for the screen.')

#ifdef EASY_EXTRAS
  -> If window open then adjust sizing.
  IF w
    -> Calculate X size and pos delta if needed.
    cm:=IF (w.width>=xsize) AND DoesXResize(base.flags) THEN w.width ELSE xsize
    x:=IF cm+w.leftedge>s.width THEN s.width-cm ELSE w.leftedge
    -> Calculate Y size and pos delta if needed.
    h:=IF (w.height>=ysize) AND DoesYResize(base.flags) THEN w.height ELSE ysize
    y:=IF h+w.topedge>s.height THEN s.height-h ELSE w.topedge
    -> Disallow window sizing.
    ModifyIDCMP(w, WIN_IDCMP_NS)
    -> Temporarily allow window to grow as large and small as possible.
    WindowLimits(w,8,8,-1,-1)
    -> Move and size window.
    ChangeWindowBox(w,x,y,cm,h)
    -> Set window to proper limits.
    setwinlimits(w,xsize,ysize,
                   IF DoesXResize(base.flags) THEN -1 ELSE xsize,
                   IF DoesYResize(base.flags) THEN -1 ELSE ysize)
    -> Remove mess.
    clearwindow(w)
    -> Allow resizing (maybe) again.
    ModifyIDCMP(w, WIN_IDCMP)
  ELSE
#endif
  -> Window not open so create it.
    -> get visual infos
    gh.visual:=GetVisualInfoA(gh.scr,NIL)
    IF gh.visual=NIL THEN RaiseX("GUI",482,'Could not get visual info. Out of memory?')

    -> calc window position (centre of visible part of screen)
    h:=VTAG_VIEWPORTEXTRA_GET  -> Ack! VideoControl changes tag!
    IF IF cm:=s.viewport.colormap THEN VideoControl(cm, h:=[h,NIL,NIL]) BUT vpe:=h[1] ELSE vpe:=NIL
      x:=Min(vpe.displayclip.maxx-vpe.displayclip.minx+1,s.width)-xsize/2-s.viewport.dxoffset
      y:=Min(vpe.displayclip.maxy-vpe.displayclip.miny+1,s.height)-ysize/2-s.viewport.dyoffset
    ELSE
      x:=s.width-xsize/2
      y:=s.height-ysize/2
    ENDIF
    w:=s.width
    h:=s.height
    -> If position stored use that, else centred.  And adjust max size.
    IF gh.x<>-1
      x:=gh.x
      -> Offset the maximum
      w:=Bounds(w-x,xsize,w)
    ENDIF
    IF gh.y<>-1
      y:=gh.y
      h:=Bounds(h-y,ysize,h)
    ENDIF
    -> Use minimum or stored size (default is maximum).
    IF gh.xsize=0
      w:=xsize
    ELSEIF DoesXResize(base.flags)=FALSE
      w:=xsize
    ELSEIF gh.xsize<>-1
      w:=Bounds(gh.xsize,xsize,s.width)
    ENDIF
    IF gh.ysize=0
      h:=ysize
    ELSEIF DoesYResize(base.flags)=FALSE
      h:=ysize
    ELSEIF gh.ysize<>-1
      h:=Bounds(gh.ysize,ysize,s.height)
    ENDIF

    -> open the window
    gh.pwnd:=w:=OpenWindowTagList(NIL,
               [WA_LEFT,       Bounds(x,0,s.width-w),
                WA_TOP,        Bounds(y,0,s.height-h),
                WA_WIDTH,      w,
                WA_HEIGHT,     h,
                WA_IDCMP,      0, -> Was WIN_IDCMP: now ports are shared.
                WA_FLAGS,      ListItem([WIN_FNOBORD,WIN_FBASIC,
                                         WIN_FNOSIZE,WIN_FSIZE], gh.wtype AND WTYPE_MASK) OR IF gh.wtype AND WTYPE_REPORTMOUSE THEN WFLG_REPORTMOUSE ELSE NIL,
                WA_TITLE,      IF (gh.wtype AND WTYPE_MASK)>WTYPE_BASIC THEN gh.wtitle ELSE NIL,
                WA_CUSTOMSCREEN, gh.scr,
                WA_MINWIDTH,   xsize,
                WA_MINHEIGHT,  ysize,
                WA_MAXWIDTH,   IF DoesXResize(base.flags) THEN -1 ELSE xsize,
                WA_MAXHEIGHT,  IF DoesYResize(base.flags) THEN -1 ELSE ysize,
                ->WA_AUTOADJUST,1,
                NIL])
    IF w=NIL THEN RaiseX("GUI",537,'Could not open window. Too many layers?')
    w.userdata:=gh
    -> Set up window IDCMP port.
    w.userport:=gh.wndport
    ModifyIDCMP(w,WIN_IDCMP)

#ifdef EASY_APPWINDOW
    IF gh.awproc THEN gh.appwin:=AddAppWindowA(gh,gh.awproc,gh.pwnd,gh.awport,NIL)
#endif
    stdrast:=w.rport
#ifdef EASY_EXTRAS
  ENDIF
#endif
  -> Remember minimum window size.
  gh.xsize:=xsize
  gh.ysize:=ysize
  -> Now render the gadgets.
  gh.glist:=rendergui(gh)
ENDPROC

/********** guiinitA() **********/
#ifdef EASY_EXTRAS
EXPORT PROC guiinitA(title,gui,tags=NIL) IS addmultiA(NIL,title,gui,tags)
#endif
#ifndef EASY_EXTRAS
EXPORT PROC guiinitA(title,gui,tags=NIL) HANDLE
  DEF gh=NIL:PTR TO guihandle
  gh:=makehandle(title,gui,NIL,tags)
EXCEPT
  -> Stop the user cleanup in this case.
  gh.onclean:=NIL
  cleangui(gh)
  ReThrow()
ENDPROC gh
#endif

PROC openlibrary(s)
  DEF lib
  IF (lib:=OpenLibrary(s,37))=NIL THEN RaiseX("LIB",613,s)
ENDPROC lib

-> Make a handle and initialise from the tags.
PROC makehandle(title,gui,mh,tags) HANDLE
  DEF gh=NIL:PTR TO guihandle, temp:PTR TO LONG, isopen=FALSE
  NEW gh
  utilitybase:=openlibrary('utility.library')
  isopen:=TRUE
  IF temp:=GetTagData(EG_GHVAR,NIL,tags) THEN temp[]:=gh
  gh.wtype:=GetTagData(EG_WTYPE,WTYPE_SIZE,tags)
  gh.wtitle:=title
  gh.gui:=gui
  gh.info:=IF -1<>(temp:=GetTagData(EG_INFO,-1,tags)) THEN temp ELSE gh
  initscr(gh,GetTagData(EG_SCRN,NIL,tags))
  initfont(gh,GetTagData(EG_FONT,NIL,tags))
  gh.newmenus:=GetTagData(EG_NEWMENU,NIL,tags)
  gh.menus:=GetTagData(EG_MENU,NIL,tags)
  gh.awproc:=GetTagData(EG_AWPROC,NIL,tags)
  gh.x:=GetTagData(EG_LEFT,-1,tags)
  gh.y:=GetTagData(EG_TOP,-1,tags)
  gh.onclose:=GetTagData(EG_CLOSE,NIL,tags)
  gh.onclean:=GetTagData(EG_CLEAN,NIL,tags)
  IF GetTagData(EG_MAXW,FALSE,tags) THEN gh.xsize:=-1
  IF GetTagData(EG_MAXH,FALSE,tags) THEN gh.ysize:=-1
#ifdef EASY_EXTRAS
  gh.mh:=mh
#endif
  setinit(gh)
EXCEPT DO
  IF exception
    END gh
    ReThrow()
  ELSE
    IF GetTagData(EG_HIDE,FALSE,tags)=FALSE THEN openwin(gh)
  ENDIF
  IF isopen THEN CloseLibrary(utilitybase)
ENDPROC gh

-> Initialisation stuff.
PROC setinit(gh:PTR TO guihandle) HANDLE
  -> Open library safely.
  gadtoolsbase:=openlibrary('gadtools.library')
  gh.gt_isopen:=TRUE
#ifdef EASY_EXTRAS
  -> Window IDCMP port.
  IF gh.mh
    -> If multi-window then share port.
    gh.wndport:=gh.mh.wndport
    -> Also, share the *complete* signal mask.
    -> (This ensures that guimessage() works...)
    gh.sig:=gh.mh.sig
  ELSE
#endif
    gh.wndport:=makeport()
    gh.sig:=Shl(1,gh.wndport.sigbit)
#ifdef EASY_EXTRAS
  ENDIF
#endif
#ifdef EASY_APPWINDOW
  -> Open library safely.
  workbenchbase:=openlibrary('workbench.library')
  gh.wb_isopen:=TRUE
#ifdef EASY_EXTRAS
  -> AppWindow port
  IF gh.mh
    -> If multi-window then share port (even if no awproc)
    -> (This ensures that guimessage() works...)
    gh.awport:=gh.mh.awport
  ELSEIF gh.awproc
#endif
#ifndef EASY_EXTRAS
  IF gh.awproc
#endif
    gh.awport:=makeport()
    gh.sig:=gh.sig OR Shl(1,gh.awport.sigbit)
  ELSE
    gh.awport:=NIL
  ENDIF
#endif
EXCEPT
  cleaninit(gh)
  ReThrow()
ENDPROC

/********** openwin() **********/
EXPORT PROC openwin(gh:PTR TO guihandle)
  IF gh.pwnd=NIL
    -> Set up screen.
    IF gh.is_wb
      IF gh.scr=NIL THEN gh.scr:=LockPubScreen(NIL)
      IF gh.scr=NIL THEN RaiseX("GUI",417,'Could not lock default public screen (Workbench?). Is it open?')
    ENDIF
    -> Set up font.
    IF gh.ta_scr THEN gh.tattr:=gh.scr.font
    -> Set up window and GUI.
    setgui(gh)
    -> Set up menus.
    setmenus(gh)
#ifdef EASY_EXTRAS
    -> If multi then bump count of open windows.
    IF gh.mh THEN gh.mh.opencount:=gh.mh.opencount+1
#endif
  ENDIF
ENDPROC gh

#ifdef EASY_EXTRAS
/********** changescreen() **********/
EXPORT PROC changescreen(gh:PTR TO guihandle,scr=NIL)
  IF gh.wnd=NIL THEN initscr(gh,scr)
ENDPROC

/********** changefont() **********/
EXPORT PROC changefont(gh:PTR TO guihandle,tattr=NIL)
  IF gh.wnd=NIL THEN initfont(gh,tattr)
ENDPROC

/********** changewintype() **********/
EXPORT PROC changewintype(gh:PTR TO guihandle,wintype=WTYPE_SIZE)
  IF gh.wnd=NIL THEN gh.wtype:=wintype
ENDPROC

/********** changeinfo() **********/
EXPORT PROC changeinfo(gh:PTR TO guihandle,info=-1)
  gh.info:=IF info<>-1 THEN info ELSE gh
ENDPROC

/********** changetitle() **********/
EXPORT PROC changetitle(gh:PTR TO guihandle,windowtitle=NIL)
  IF gh.wnd
    IF (windowtitle=NIL) OR ((gh.wtype AND WTYPE_MASK)>WTYPE_BASIC)
      SetWindowTitles(gh.wnd, windowtitle, -1)
    ENDIF
  ENDIF
  gh.wtitle:=windowtitle
ENDPROC

/********** changemenus() **********/
EXPORT PROC changenewmenus(gh:PTR TO guihandle,newmenus=NIL) HANDLE
  IF gh.wnd THEN removemenus(gh)
  gh.newmenus:=newmenus
  IF gh.wnd THEN setmenus(gh)
EXCEPT
  removemenus(gh)
  ReThrow()
ENDPROC

/********** changegui() **********/
EXPORT PROC changegui(gh:PTR TO guihandle,gui)
  IF gui
    IF gh.pwnd THEN removegui(gh)
    gh.gui:=gui
    IF gh.pwnd THEN setgui(gh)
  ENDIF
ENDPROC

/********** movewin() **********/
EXPORT PROC movewin(gh:PTR TO guihandle,x=-1,y=-1)
  DEF w:PTR TO window
  IF w:=gh.wnd
    MoveWindow(w, IF x=-1 THEN 0 ELSE (x-w.leftedge),
                  IF y=-1 THEN 0 ELSE (y-w.topedge))
  ENDIF
ENDPROC

/********** sizewin() **********/
EXPORT PROC sizewin(gh:PTR TO guihandle,xs=-1,ys=-1)
  DEF w:PTR TO window
  IF w:=gh.wnd
    SizeWindow(w, IF xs=-1 THEN 0 ELSE (xs-w.width),
                  IF ys=-1 THEN 0 ELSE (ys-w.height))
  ENDIF
ENDPROC

-> Try setting window limits a few times.
PROC setwinlimits(w,minx,miny,maxx,maxy)
  DEF i
  FOR i:=0 TO 3
  EXIT WindowLimits(w,minx,miny,maxx,maxy)
    Delay(1)
  ENDFOR
ENDPROC

/********** blockwin() **********/
EXPORT PROC blockwin(gh:PTR TO guihandle)
  DEF lib:PTR TO lib,c,w:PTR TO window
  gh.blockcnt:=(c:=gh.blockcnt)+1
  IF c=0
    -> Only works if window open and not already blocked.
    IF (w:=gh.wnd) AND (gh.req=NIL)
      -> Only allow window refresh messages.
      ModifyIDCMP(w, IDCMP_REFRESHWINDOW)
      -> Stop window sizing.
      setwinlimits(w,w.width,w.height,w.width,w.height)
      NEW gh.req
      -> Block window with requester.
      InitRequester(gh.req)
      Request(gh.req, w)
      lib:=intuitionbase
      IF lib.version>=39 THEN SetWindowPointerA(w,[WA_BUSYPOINTER,TRUE,
                                                   WA_POINTERDELAY,TRUE,NIL])
    ENDIF
  ENDIF
ENDPROC

/********** unblockwin() **********/
EXPORT PROC unblockwin(gh:PTR TO guihandle)
  DEF lib:PTR TO lib,c,w:PTR TO window
  IF (c:=gh.blockcnt)>0
    gh.blockcnt:=c-1
    IF c=1
      -> Only works if window open and blocked.
      IF (w:=gh.wnd) AND (gh.req<>NIL)
        -> Remove requester.
        EndRequest(gh.req, w)
        -> Reset window limits.
        setwinlimits(w,gh.xsize,gh.ysize,
                       IF DoesXResize(gh.base.flags) THEN -1 ELSE gh.xsize,
                       IF DoesYResize(gh.base.flags) THEN -1 ELSE gh.ysize)
        -> Reset IDCMP.
        ModifyIDCMP(w, WIN_IDCMP)
        END gh.req
        lib:=intuitionbase
        IF lib.version>=39 THEN SetWindowPointerA(w,[WA_BUSYPOINTER,FALSE,NIL])
      ENDIF
    ENDIF
  ENDIF
ENDPROC
#endif

#ifdef EASY_APPWINDOW
-> Handle AppWindow messages.
PROC appwmessage(port) HANDLE
  DEF ret,data,list:PTR TO LONG,amsg=NIL:PTR TO appmessage,gh:PTR TO guihandle,
      pl:PTR TO plugin
  IF port
    WHILE amsg:=GetMsg(port)
      -> Get guihandle from message ID.
      gh:=amsg.id
      -> See if any PLUGIN wants it.
      pl:=gh.plugins
      WHILE pl
        IF OptATTR(pl.base.list,PLG_APPW)=NIL THEN JUMP plugin_appw_skip
      EXIT pl.appmessage(amsg,gh.pwnd)
plugin_appw_skip:
        pl:=pl.next
      ENDWHILE
      ret:=NIL
      data:=NIL
      -> Get awproc (in ret) and data.
      IF pl
        ret:=OptATTR(pl.base.list,PLG_APPW)
        data:=pl
      ELSE
        IF list:=findxy(gh,amsg.mousex,amsg.mousey)
          SELECT MAXGUI OF ATTR(list,EG_TYPE)
          CASE BUTTON, SBUTTON, RBUTTON
            ret:=OptATTR(list,BUT_APPW)
            data:=OptDefATTR(list,BUT_DATA)
          CASE LISTV
            ret:=OptATTR(list,LST_APPW)
            data:=OptDefATTR(list,LST_DATA)
          CASE STR
            ret:=OptATTR(list,STR_APPW)
            data:=OptDefATTR(list,STR_DATA)
          ENDSELECT
        ENDIF
      ENDIF
      -> If no gadget awproc then use window one.
      IF ret=NIL
        ret:=amsg.userdata
        data:=NIL
      ENDIF
      -> Call the awproc.
      IF ret THEN ret(data,gh.info,amsg)
      -> Now we can reply to the message.
      ReplyMsg(amsg)
      amsg:=NIL
    ENDWHILE
  ENDIF
EXCEPT
  -> Still need to reply if exception happened at a bad point
  IF amsg THEN ReplyMsg(amsg)
  ReThrow()
ENDPROC
#endif

-> Handle menu messages.
PROC menumessage(gh:PTR TO guihandle,code) HANDLE
  DEF ret=GUI_CONT,menunum,item:PTR TO menuitem
  menunum:=Unsigned(code)
  -> Stop if the window's gone away.
  WHILE (menunum<>MENUNULL) AND gh.pwnd
    item:=ItemAddress(gh.menus,menunum)
    -> Get action value/function.
    ret:=GTMENUITEM_USERDATA(item)
  -> Stop if action value.
  EXIT IsActionFun(ret)=FALSE
    gh.menuitem:={item}
    -> Call action function.
    ret(NIL,NIL,gh.info)
    ret:=GUI_CONT
  EXIT item=NIL
    menunum:=Unsigned(item.nextselect)
  ENDWHILE
EXCEPT DO
  gh.menuitem:=NIL
  ReThrow()
ENDPROC ret

-> Handle GadTools/window messages.
PROC gtmessage(port) HANDLE
  DEF ret=GUI_CONT,mes=NIL:PTR TO intuimessage,type,gh:PTR TO guihandle,
      gs:PTR TO gadget,list:PTR TO LONG,code,pl:PTR TO plugin,qual
  WHILE mes:=Gt_GetIMsg(port)
    -> Get guihandle from window userdata.
    gh:=mes.idcmpwindow.userdata
    -> See if any PLUGIN wants it.
    pl:=gh.plugins
    WHILE pl
    EXIT pl.message_test(mes,gh.pwnd)
      pl:=pl.next
    ENDWHILE
    -> Copy important bits of the message.
    type:=mes.class
    code:=mes.code
    gs:=mes.iaddress
    qual:=Unsigned(mes.qualifier)
    -> Now we can reply to the message.
    Gt_ReplyIMsg(mes)
    mes:=NIL
    IF pl
      -> Call the PLUGIN's action function if necessary.
      IF pl.message_action(type,qual,code,gh.pwnd)
        ret:=ATTR(pl.base.list,PLG_ACT)
        IF IsActionFun(ret)
          ret(gh.info,pl)
          ret:=GUI_CONT
        ENDIF
      ENDIF
    ELSE
      -> Gadget click.
      IF type AND GAD_IDCMP
->WriteF('type=$\h, code=$\h, gad=$\h\n', type, code, gs)
        -> Protect from stray IDCMP_MOUSEMOVE.
        IF gs AND (gs<>gh.pwnd)
          -> Get gadget description list.
          list:=gs.userdata
          -> Set new attribute.
          performset(gs,code,list)
          -> Get action value/function.
          ret:=ATTR(list,EG_ACT)
          IF IsActionFun(ret)
            performaction(ret,gs,gh.info,code,list,qual)
            ret:=GUI_CONT
          ENDIF
        ENDIF
#ifdef EASY_KEYBOARD
      -> Key press.
      ELSEIF type=IDCMP_VANILLAKEY
        ret:=performkey(gh,code)
#endif
      -> Window refresh.
      ELSEIF type=IDCMP_REFRESHWINDOW
        Gt_BeginRefresh(gh.pwnd)
        Gt_EndRefresh(gh.pwnd,TRUE)
      -> Window size change.
      ELSEIF type=IDCMP_NEWSIZE
        -> Remove the gadgets, clear and recreate.
        removegads(gh)
        clearwindow(gh.pwnd)
        gh.glist:=rendergui(gh)
      -> Close gadget click.
      ELSEIF type=IDCMP_CLOSEWINDOW
        -> Find action value/function.
        ret:=gh.onclose
        IF IsActionFun(ret)
#ifdef EASY_EXTRAS
          ret(gh.mh,gh.info)
#endif
#ifndef EASY_EXTRAS
          ret(NIL,gh.info)
#endif
          ret:=GUI_CONT
        ENDIF
      -> Menu choice(s).
      ELSEIF type=IDCMP_MENUPICK
        ret:=menumessage(gh,code)
      ENDIF
    ENDIF
  EXIT ret<>GUI_CONT
  ENDWHILE
#ifdef EASY_EXTRAS
  IF ret<>GUI_CONT THEN IF gh.mh THEN cleangui(gh)
#endif
EXCEPT
  -> Still need to reply if exception happened in PLUGIN message_test().
  IF mes THEN Gt_ReplyIMsg(mes)
  ReThrow()
ENDPROC ret

#ifdef EASY_EXTRAS
/********** multiinit() **********/
EXPORT PROC multiinit() HANDLE
  DEF mh=NIL:PTR TO multihandle
  NEW mh
  newList(mh.guis)
  mh.wndport:=makeport()
  mh.sig:=Shl(1,mh.wndport.sigbit)
#ifdef EASY_APPWINDOW
  mh.awport:=makeport()
  mh.sig:=mh.sig OR Shl(1,mh.awport.sigbit)
#endif
EXCEPT
  cleanmulti(mh)
  ReThrow()
ENDPROC mh

/********** addmultiA() **********/
EXPORT PROC addmultiA(mh:PTR TO multihandle,title,gui,tags=NIL) HANDLE
  DEF gh=NIL:PTR TO guihandle
  gh:=makehandle(title,gui,mh,tags)
  IF mh THEN AddHead(mh.guis,gh.link)
EXCEPT
  -> Stop the user cleanup in this case.
  gh.onclean:=NIL
  cleangui(gh)
  ReThrow()
ENDPROC gh

/********** multiforall() **********/
EXPORT PROC multiforall(varaddr:PTR TO LONG,mh:PTR TO multihandle,expr) IS
  multieval(varaddr,mh,expr,FALSE)

/********** multiexists() **********/
EXPORT PROC multiexists(varaddr:PTR TO LONG,mh:PTR TO multihandle,expr) IS
  multieval(varaddr,mh,expr,TRUE)

-> Evaluate and maybe stop...
PROC multieval(varaddr:PTR TO LONG,mh:PTR TO multihandle,expr,exists)
  DEF node:PTR TO ln, next, this, res
  -> If empty then TRUE for forall, but FALSE for exists
  res:=(exists=FALSE)
  IF mh
    node:=mh.guis.head
    WHILE next:=node.succ
      varaddr[]:=node-GH_LINK_OFFSET
      IF this:=Eval(expr)
        -> If exists then we've found a match.
        IF exists THEN RETURN this
      ELSE
        -> Forall is FALSE.  Exists is still FALSE.
        res:=FALSE
      ENDIF
      node:=next
    ENDWHILE
  ENDIF
  -> Invalidate for case where exists fails.
  varaddr[]:=NIL
ENDPROC res

/********** multiempty() **********/
EXPORT PROC multiempty(mh:PTR TO multihandle) IS mh.guis.tailpred=mh.guis

/********** multiloop() **********/
EXPORT PROC multiloop(mh:PTR TO multihandle)
  DEF res=-1
  WHILE res<0
  EXIT mh.opencount=0
    Wait(mh.sig)
    res:=multimessage(mh)
  ENDWHILE
ENDPROC res

/********** cleanmulti() **********/
EXPORT PROC cleanmulti(mh:PTR TO multihandle)
  IF mh
    -> Clean up any remaining guihandles.
    WHILE multiempty(mh)=FALSE DO cleangui(mh.guis.head-GH_LINK_OFFSET)
#ifdef EASY_APPWINDOW
    IF mh.awport
      DeleteMsgPort(mh.awport)
      mh.awport:=NIL
    ENDIF
#endif
    IF mh.wndport
      DeleteMsgPort(mh.wndport)
      mh.wndport:=NIL
    ENDIF
    END mh
  ENDIF
ENDPROC

/********** checkmulti() **********/
EXPORT PROC checkmulti(mh:PTR TO multihandle)
  DEF ret
  -> Check if there a message waiting on our ports.
  IF SetSignal(0,0) AND mh.sig
    IF (ret:=multimessage(mh))>=0 THEN quitgui(ret)
  ENDIF
ENDPROC
#endif

-> Note: as long as gh is valid, guimessage() can be used in place of
-> multimessage() for multi-window GUIs.  But remember that gh could
-> be invalidated by an action function when guimessage() is called.

/********** guimessage() **********/
/********** multimessage() **********/
#ifdef EASY_APPWINDOW
EXPORT PROC guimessage(gh:PTR TO guihandle)     IS message(gh.wndport,gh.awport)
#ifdef EASY_EXTRAS
EXPORT PROC multimessage(mh:PTR TO multihandle) IS message(mh.wndport,mh.awport)
#endif
#endif
#ifndef EASY_APPWINDOW
EXPORT PROC guimessage(gh:PTR TO guihandle)     IS message(gh.wndport,NIL)
#ifdef EASY_EXTRAS
EXPORT PROC multimessage(mh:PTR TO multihandle) IS message(mh.wndport,NIL)
#endif
#endif

-> Handle messages from the ports.
PROC message(wndport,awport) HANDLE
  DEF ret=-1
#ifdef EASY_APPWINDOW
  appwmessage(awport)
#endif
  ret:=gtmessage(wndport)
EXCEPT
  -> If we got "QUIT" then return value is in exceptioninfo.
  IF exception="QUIT"
    ret:=exceptioninfo
  ELSE
    ReThrow()
  ENDIF
ENDPROC ret

/********** quitgui() **********/
EXPORT PROC quitgui(ret=0) IS Throw("QUIT",ret)

-> Note: as above, checkgui() is safe for multi-window GUIs as long as
-> gh is valid.

/********** checkgui() **********/
EXPORT PROC checkgui(gh:PTR TO guihandle)
  DEF ret
  -> Check if there a message waiting on our ports.
  IF SetSignal(0,0) AND gh.sig
    IF (ret:=guimessage(gh))>=0 THEN quitgui(ret)
  ENDIF
ENDPROC

-> Remove menus and reset handle.
PROC removemenus(gh:PTR TO guihandle)
  IF gh.menus
    -> Hack to prevent the item.nextselect if closed from menu action function.
    IF gh.menuitem THEN gh.menuitem[]:=NIL
    IF gh.pwnd THEN ClearMenuStrip(gh.pwnd)
    IF gh.newmenus THEN FreeMenus(gh.menus)
    gh.menus:=NIL
  ENDIF
ENDPROC

-> Remove GUI and reset handle.
PROC removegui(gh:PTR TO guihandle)
  clean(gh.base)
  gh.base:=NIL
  removegads(gh)
  gh.glist:=NIL
  gh.plugins:=NIL
ENDPROC

-> Check if is this an IDCMP message for the window.
PROC testintuimsg(msg:PTR TO intuimessage,data) IS msg.idcmpwindow=data

#ifdef EASY_APPWINDOW
-> Check if is this an appmessage for the AppWindow.
PROC testappwmsg(msg:PTR TO appmessage,data) IS msg.id=data
#endif

-> Selectively remove messages from the port.
PROC clearmsgs(mp:PTR TO mp,f,data)
  DEF msg:PTR TO mn, succ
  -> Must be in Forbid()/Permit() brackets...
  Forbid()
  msg:=mp.msglist.head
  WHILE succ:=msg.ln.succ
    IF f(msg,data)
      Remove(msg)
      ReplyMsg(msg)
    ENDIF
    msg:=succ
  ENDWHILE
  Permit()
ENDPROC

-> Create a new message port.
PROC makeport()
  DEF port:PTR TO mp
  IF (port:=CreateMsgPort())=NIL THEN RaiseX("GUI",1065,'Could not create message port. Run out of signal bits?')
ENDPROC port

-> Clean initialisation stuff and reset handle.
PROC cleaninit(gh:PTR TO guihandle)
  -> Clean ports.
#ifdef EASY_APPWINDOW
#ifdef EASY_EXTRAS
  IF (gh.mh=NIL) AND gh.awport THEN DeleteMsgPort(gh.awport)
#endif
#ifndef EASY_EXTRAS
  IF gh.awport THEN DeleteMsgPort(gh.awport)
#endif
  gh.awport:=NIL
  IF gh.wb_isopen
    CloseLibrary(workbenchbase)
    gh.wb_isopen:=FALSE
  ENDIF
#endif
#ifdef EASY_EXTRAS
  IF (gh.mh=NIL) AND gh.wndport THEN DeleteMsgPort(gh.wndport)
#endif
#ifndef EASY_EXTRAS
  IF gh.wndport THEN DeleteMsgPort(gh.wndport)
#endif
  gh.wndport:=NIL
  IF gh.gt_isopen
    CloseLibrary(gadtoolsbase)
    gh.gt_isopen:=FALSE
  ENDIF
ENDPROC

/********** cleangui() **********/
EXPORT PROC cleangui(gh:PTR TO guihandle)
  DEF f
  IF gh
    -> Close window if necessary.
    closewin(gh)
    IF f:=gh.onclean THEN f(gh.info)
    cleaninit(gh)
#ifdef EASY_EXTRAS
    IF gh.mh
      -> Unlink from multi-window list.
      Remove(gh.link)
      gh.mh:=NIL
    ENDIF
#endif
    END gh
  ENDIF
ENDPROC

/********** closewin() **********/
EXPORT PROC closewin(gh:PTR TO guihandle)
  DEF w:PTR TO window
  IF w:=gh.wnd
    -> Remember window size and position.
    gh.x:=w.leftedge
    gh.y:=w.topedge
    gh.xsize:=w.width
    gh.ysize:=w.height
#ifdef EASY_EXTRAS
    gh.blockcnt:=1  -> Force unblock, if necessary.
    unblockwin(gh)  -> Just in case!
#endif
    removegui(gh)
    removemenus(gh)
#ifdef EASY_APPWINDOW
    IF gh.appwin
      RemoveAppWindow(gh.appwin)
      gh.appwin:=NIL
    ENDIF
    -> Remove any last minute messages safely.
    IF gh.awport THEN clearmsgs(gh.awport,{testappwmsg},gh)
#endif
    IF w
      -> Must be in Forbid()/Permit() brackets.
      Forbid()
      -> Remove any last minute messages safely.
      clearmsgs(gh.wndport,{testintuimsg},w)
      -> Make sure no more messages get sent.
      w.userport:=NIL
      ModifyIDCMP(w,0)
      Permit()
      -> Now the window can be closed safely.
      CloseWindow(w)
      gh.pwnd:=NIL
    ENDIF
    stdrast:=NIL
    IF gh.visual
      FreeVisualInfo(gh.visual)
      gh.visual:=NIL
    ENDIF
#ifdef EASY_EXTRAS
    -> If multi then decrement count of open windows.
    IF gh.mh THEN gh.mh.opencount:=gh.mh.opencount-1
#endif
    IF gh.is_wb
      IF gh.scr THEN UnlockPubScreen(NIL,gh.scr)
      gh.scr:=NIL
    ENDIF
    -> If the font is linked to the screen, it's no longer valid.
    IF gh.ta_scr THEN gh.tattr:=NIL
  ENDIF
ENDPROC

-> Render the gadgets on the window.
PROC rendergui(gh:PTR TO guihandle)
  DEF glist=0,w:PTR TO window,base:PTR TO g
  w:=gh.pwnd
  base:=gh.base
  gh.gl:=CreateContext({glist})
  IF gh.gl=NIL THEN RaiseX("GUI",1183,'Could not create gadget context. Out of memory?')
  stdrast:=w.rport
  -> Adjust intermediate gadgets to be real gadgets fitting in window.
  adjust(base, gh.xoff,gh.yoff,
         w.width-gh.xsize+base.xs,w.height-gh.ysize+base.ys, gh)
  AddGList(w,glist,-1,-1,NIL)
#ifndef EASY_KEYBOARD
  -> If no keyboard support, activate first sting gadget.
  IF gh.firststr THEN ActivateGadget(gh.firststr,w,NIL)
#endif
  RefreshGList(glist,w,NIL,-1)
  Gt_RefreshWindow(w,NIL)
  -> Set public pointer, as a flag to say it's OK to play with the GUI, now.
  gh.wnd:=w
ENDPROC glist

-> Remove PLUGINs and gadgets from window.
PROC removegads(gh:PTR TO guihandle)
  DEF pl:PTR TO plugin
  -> Set public pointer to NIL, to say it's no longer safe to play with the GUI.
  gh.wnd:=NIL
  pl:=gh.plugins
  WHILE pl
    pl.clear_render(gh.pwnd)
    pl:=pl.next
  ENDWHILE
  IF gh.glist
    RemoveGList(gh.pwnd,gh.glist,-1)
    FreeGadgets(gh.glist)
  ENDIF
ENDPROC

-> Decide what the real screen bottom is by getting size gadget height.
PROC getrealbot(s:PTR TO screen)
  DEF dri,bot,im:PTR TO image
  bot:=s.wborbottom
  IF dri:=GetScreenDrawInfo(s)
    IF im:=NewObjectA(NIL,'sysiclass',
                     [SYSIA_DRAWINFO,dri, SYSIA_WHICH,SIZEIMAGE,
                      SYSIA_SIZE,SysISize(s.flags), NIL])
      bot:=im.height
      DisposeObject(im)
    ENDIF
    FreeScreenDrawInfo(s,dri)
  ENDIF
ENDPROC bot

#ifdef EASY_KEYBOARD
-> Fiddled so actually one less than length...
PROC execlistlen(list:PTR TO mlh)
  DEF len=-1, node:PTR TO mln
  -> Catch the case where the LISTV is being cleanly updated.
  IF list<>-1
    IF list
      node:=list.head
      WHILE node:=node.succ DO len++
    ENDIF
  ENDIF
ENDPROC len

-> Do action appropriate to key press.
PROC performkey(gh:PTR TO guihandle,code)
  DEF list:PTR TO LONG,ret,val,tag,index,data,gad=NIL:PTR TO gadget,inc
  -> Look up gadget in key index.
  IF islower(code)      -> Positive action
    gad:=gh.keys[code-"a"]
    inc:=TRUE
  ELSEIF isupper(code)  -> Negative action
    gad:=gh.keys[code-"A"]
    inc:=FALSE
  ENDIF
  IF gad=NIL THEN RETURN GUI_CONT
/* Ack! Doesn't work under OS2.0...
#ifdef EASY_EXTRAS
  Gt_GetGadgetAttrsA(gad,gh.pwnd,NIL,[GA_DISABLED,{ret},NIL])
  IF ret THEN RETURN GUI_CONT
#endif
*/
  list:=gad.userdata
  ret:=ATTR(list,EG_ACT)
#ifdef EASY_EXTRAS
  -> If disabled then don't react.
  IF optdis(gad.gadgetid,list) THEN RETURN GUI_CONT
#endif
  -> Tag is TRUE if a button.
  data,tag:=indexdata(gad.gadgetid)
  data:=OptDefATTR(list,data)
  SELECT MAXGUI OF gad.gadgetid
  -> Just press button.
  -> CASE BUTTON,SBUTTON,RBUTTON
  CASE STR,INTEGER
    -> Activate string and integer gadgets.
    ActivateGadget(gad,gh.pwnd,NIL)
  CASE CHECK
    -> Toggle check gadgets.
    tag:=GTCB_CHECKED
    index:=CHK_VAL
    val:=(IsChecked(gad)=FALSE)
  CASE MX
    -> Next/prev item, wrapping.
    tag:=GTMX_ACTIVE
    index:=ListLen(ATTR(list,MX_LIST))-2
    val:=ATTR(list,MX_CURR)
    IF inc
      IF val++>=index THEN val:=0
    ELSE
      IF val--<0 THEN val:=index
    ENDIF
    index:=MX_CURR
  CASE CYCLE
    -> Next/prev item, wrapping.
    tag:=GTCY_ACTIVE
    index:=ListLen(ATTR(list,CYC_LIST))-2
    val:=ATTR(list,CYC_CURR)
    IF inc
      IF val++>=index THEN val:=0
    ELSE
      IF val--<0 THEN val:=index
    ENDIF
    index:=CYC_CURR
  CASE SCROLL
    -> Inc/dec, stopping at ends.
    tag:=GTSC_TOP
    val:=ATTR(list,SCR_TOP)
    IF inc
      IF val++>=(ATTR(list,SCR_TOTL)-ATTR(list,SCR_VIS)) THEN tag:=0
    ELSE
      IF val--<0 THEN tag:=0
    ENDIF
    index:=SCR_TOP
  CASE SLIDE
    -> Inc/dec, stopping at ends.
    tag:=GTSL_LEVEL
    val:=ATTR(list,SLI_CURR)
    IF inc
      IF val++>=ATTR(list,SLI_MAX) THEN tag:=0
    ELSE
      IF val--<ATTR(list,SLI_MIN) THEN tag:=0
    ENDIF
    index:=SLI_CURR
  CASE LISTV
    -> Next/prev, stopping at ends.
    tag:=GTLV_SELECTED
    val:=ATTR(list,LST_CURR)
    IF inc
      IF val++>=execlistlen(ATTR(list,LST_LIST)) THEN tag:=0
    ELSE
      IF val--<0 THEN tag:=0
    ENDIF
    index:=LST_CURR
  CASE PALETTE
    -> Next/prev, wrapping.
    tag:=GTPA_COLOR
    val:=ATTR(list,PAL_CURR)
    index:=Shl(1,ATTR(list,PAL_DEP))-1
    IF inc
      IF val++>=index THEN val:=0
    ELSE
      IF val--<0 THEN val:=index
    ENDIF
    index:=PAL_CURR
  ENDSELECT
  -> Perform change if required.
  IF tag
    IF tag<>TRUE  -> If not a button (non-zero is tag value).
      setgadattr(gad,gh.pwnd,list,val,tag,index)
      IF gad.gadgetid=LISTV THEN setgadattr(gad,gh.pwnd,list,val,GTLV_MAKEVISIBLE)
    ENDIF
    -> Do action.
    IF IsActionFun(ret)
      -> If button (non-zero is tag value).
      IF tag=TRUE THEN ret(0,data,gh.info) ELSE ret(0,data,gh.info,val)
      ret:=GUI_CONT
    ENDIF
  ELSE
    ret:=GUI_CONT
  ENDIF
ENDPROC ret
#endif

-> Call action function based on new code.
PROC performaction(fun,gad:PTR TO gadget,info,code,l:PTR TO LONG,qual)
  DEF data,but,val
  data,but,val:=indexdata(gad.gadgetid)
  data:=OptDefATTR(l,data)
ENDPROC (IF but THEN fun(qual,data,info) ELSE
                     fun(qual,data,info,IF val THEN ATTR(l,val) ELSE code))

/********** getstr **********/
EXPORT PROC getstr(gh,g) IS gadstr(g,findgadget(gh,g))

/********** getinteger **********/
EXPORT PROC getinteger(gh,g) IS gadinteger(g,findgadget(gh,g))

-> Copy buffer string to gadget E-string.
PROC gadstr(l:PTR TO LONG, gad:PTR TO gadget) IS
  IF gad THEN StrCopy(ATTR(l,STR_STR),GadString(gad)) ELSE 0

-> Copy buffer integer to gadget integer.
PROC gadinteger(l:PTR TO LONG, gad:PTR TO gadget)
  DEF x=0
  IF gad THEN ATTR(l,INT_VAL):=x:=GadLongInt(gad)
ENDPROC x

-> Record new gadget value.
PROC performset(gad:PTR TO gadget,code,l:PTR TO LONG)
  SELECT MAXGUI OF gad.gadgetid
  CASE STR;     gadstr(l,gad)
  CASE INTEGER; gadinteger(l,gad)
  CASE CHECK;   ATTR(l,CHK_VAL):=IsChecked(gad)
  CASE MX;      ATTR(l,MX_CURR):=code
  CASE CYCLE;   ATTR(l,CYC_CURR):=code
  CASE SCROLL;  ATTR(l,SCR_TOP):=code
  CASE SLIDE;   ATTR(l,SLI_CURR):=code
  CASE LISTV;   ATTR(l,LST_CURR):=code
  CASE PALETTE; ATTR(l,PAL_CURR):=code
  ENDSELECT
ENDPROC

-> Clean gadget description objects.
PROC clean(base:PTR TO g)
  DEF i:PTR TO g,j
  IF base
    IF IsRowOrCol(base.type)
      i:=base.list
      WHILE i
        j:=i
        i:=i.next
        clean(j)
      ENDWHILE
    ELSEIF IsBevel(base.type)
      clean(base.list)
    ENDIF
    END base
  ENDIF
ENDPROC

-> Length of text, ignoring a "_" if present.
#ifdef EASY_KEYBOARD
#define textlenkey(s,g,k) textlen_key(s,g,k)
#endif
#ifndef EASY_KEYBOARD
#define textlenkey(s,g,k) textlen(s,g)
#endif

-> Calculate minimum size for a PALETTE gadget showing depth d
-> Ack! Fiddled to compensate for OS2.0 indicator
PROC min_pal(x,y,d)
  DEF dy
  IF (x+y)=0 THEN RETURN RaiseX("Egui",1441,'Bad PALETTE gadget sizes.')
  dy:=Div(Mul(y,d),x+y)
ENDPROC Max(Mul(Shl(1,d-dy),7)+21,x), Max(Shl(4,dy)+3,y)

-> Calculate minimum size of GUI.
PROC minsize(gui:PTR TO LONG,gh:PTR TO guihandle,isinrows=TRUE,eql=FALSE)
  DEF p:PTR TO g,h,minargs,a,b:PTR TO LONG,c,pl:PTR TO plugin,type,
      ta:PTR TO textattr
  minargs:=minARGS()
  ta:=gh.tattr
  h:=ta.ysize
  type:=ATTR(gui,EG_TYPE)
  IF (type<0) OR (type>=MAXGUI) THEN RaiseX("Egui",gui,'Bad gadget type.')
  IF (ListLen(gui)<minargs[type]) THEN RaiseX("Egui",gui,'Too few arguments for gadget.')
#ifdef EASY_KEYBOARD
  a:=optkey(type,gui)
#endif
#ifndef EASY_KEYBOARD
  a:=0
#endif
  SELECT MAXGUI OF type
  CASE ROWS,EQROWS,COLS,EQCOLS
    p:=foreach(gui,type,gh,IsRow(type),IsEqualGroup(type))
  CASE BEVEL,BEVELR
    p:=minsize(ATTR(gui,BEV_GUI),gh)
    p:=newg(BEVELXSPACE*2+p.xs,BEVELYSPACE*2+p.ys,type,p,p.flags)
  CASE BUTTON,SBUTTON,RBUTTON
    p:=newg(textlenkey(ATTR(gui,BUT_TXT),ta,a)+BUTXSPACE,
            h+BUTYSPACE,type,gui,ButtSpFlags(type))
  CASE CHECK
    a:=textlenkey(ATTR(gui,CHK_TXT),ta,a)+8
    p:=newg(11+a+BUTXSPACE,h+CHECKSPACE,CHECK,gui,
            IF eql THEN COND_RESIZEX ELSE 0,IF ATTR(gui,CHK_LEFT) THEN a ELSE 0)
  CASE INTEGER
    a:=textlenkey(ATTR(gui,INT_TXT),ta,a)+8
    p:=newg(ATTR(gui,INT_REL)*textlen('5',ta)+a,h+BUTYSPACE,INTEGER,gui,
            RESIZEX,a)
  CASE LISTV
    a:=textlen(ATTR(gui,LST_TXT),ta)
    p:=newg(Max(a,ATTR(gui,LST_RELX)*h+4),
            ATTR(gui,LST_RELY)*h+(IF a THEN (h+10) ELSE 4),LISTV,gui,
            RESIZEXANDY)
  CASE MX
    c:=textlenkey(ATTR(gui,MX_TXT),ta,a)+8
    a:=0
    b:=ATTR(gui,MX_LIST)
    WHILE b[] DO a:=Max(a,textlen(b[]++,ta))
    p:=newg(8+a+c+BUTXSPACE,ListLen(ATTR(gui,MX_LIST))-1*(h+MXSPACE)-1,MX,gui,
            IF eql THEN COND_RESIZEX ELSE 0,IF ATTR(gui,MX_LEFT) THEN c ELSE 0)
  CASE CYCLE
    c:=textlenkey(ATTR(gui,CYC_TXT),ta,a)+8
    a:=0
    b:=ATTR(gui,CYC_LIST)
    WHILE b[] DO a:=Max(a,textlen(b[]++,ta))
    p:=newg(h*2+a+c+BUTXSPACE,h+BUTYSPACE,CYCLE,gui,RESIZEX,c)
  CASE PALETTE
    a:=textlenkey(ATTR(gui,PAL_TXT),ta,a)+8
    b,c:=min_pal(ATTR(gui,PAL_RELX)*h,ATTR(gui,PAL_RELY)*h,ATTR(gui,PAL_DEP))
    p:=newg(b+a,c,PALETTE,gui,RESIZEXANDY,a)
  CASE SCROLL
    a:=ATTR(gui,SCR_REL)*h
    b:=h+BUTYSPACE
    p:=newg(IF ATTR(gui,SCR_VERT) THEN b ELSE a,
            IF ATTR(gui,SCR_VERT) THEN a ELSE b,SCROLL,gui,
            IF ATTR(gui,SCR_VERT) THEN RESIZEY ELSE RESIZEX)
  CASE SLIDE
    a:=textlenkey(ATTR(gui,SLI_TXT),ta,a)+8
    b:=ATTR(gui,SLI_REL)*h
    c:=h+BUTYSPACE
    p:=newg(a+IF ATTR(gui,SLI_VERT) THEN c ELSE b,
            IF ATTR(gui,SLI_VERT) THEN b ELSE c,SLIDE,gui,
            IF ATTR(gui,SLI_VERT) THEN RESIZEY ELSE RESIZEX,a)
  CASE STR
    a:=textlenkey(ATTR(gui,STR_TXT),ta,a)+8
    p:=newg(ATTR(gui,STR_REL)*h+a,h+BUTYSPACE,STR,gui,RESIZEX,a)
  CASE TEXT,NUM
    a:=textlen(ATTR(gui,TXT_TXT),ta)+8
    b:=(IF type=NUM THEN Max(ATTR(gui,NUM_REL),2)*textlen('5',ta)
        ELSE Max(textlen(ATTR(gui,TXT_VAL),ta),ATTR(gui,TXT_REL)*h))
    p:=newg(a+b,h+IF ATTR(gui,TXT_BORD) THEN BUTYSPACE ELSE YSP,type,gui,
            RESIZEX,a)
  CASE BAR
    p:=newg(2,4,BAR,gui,IF isinrows THEN COND_RESIZEX ELSE COND_RESIZEY)
  CASE SPACEH,SPACE,SPACEV
    p:=newg(0,0,SPACE,gui,SpaceFlags(type))
  CASE PLUGIN
    IF (pl:=ATTR(gui,PLG_OBJ))=NIL THEN RaiseX("Egui",gui,'PLUGIN object is NIL.')
    a,b:=pl.min_size(ta,h)
    p:=newg(a,b,PLUGIN,gui,pl.will_resize())
    pl.next:=gh.plugins; gh.plugins:=pl
    pl.base:=p
    pl.gh:=gh
  ENDSELECT
ENDPROC p

-> Calculate minimum size of group.
PROC foreach(guilist:PTR TO LONG,type,gh:PTR TO guihandle,row,eq)
  DEF l,x=0,y=0,z=0,zmid=NO_MID,zother=0,a,p:PTR TO g,list=NIL,
      last:PTR TO g,resize=0,xs,t
  last:={list}
  l:=ListLen(guilist)-1
  FOR a:=1 TO l
    p:=minsize(guilist[a],gh,row,eq)
    resize:=resize OR p.flags
    xs:=p.xs
    IF row
      x:=Max(xs,x)
      y:=y+p.ys+IF y THEN YSPACING ELSE 0
    ELSE
      y:=Max(p.ys,y)
      x:=x+xs+IF x THEN XSPACING ELSE 0
    ENDIF
    z:=Max(z,xs)        -> for EQ(ROWS/COLS)
    t:=p.mid
    zmid:=Max(zmid,t)
    zother:=Max(zother,IF t<>NO_MID THEN (xs-t) ELSE xs)
    last.next:=p
    last:=p
  ENDFOR
  IF eq
    last:=list
    z:=IF zmid<>NO_MID THEN (zmid+zother) ELSE zother
    WHILE last
      last.xs:=z
      last.mid:=IF last.mid<>NO_MID THEN zmid ELSE 0
      last:=last.next
    ENDWHILE
    x:=IF row THEN z ELSE (z+XSPACING*l-XSPACING)
  ENDIF
  resize:=(IF DoesXUncond(resize) THEN RESIZEX ELSE 0) OR
          (IF DoesYUncond(resize) THEN RESIZEY ELSE 0)
ENDPROC newg(x,y,type,list,resize)

-> Calculate real positions and sizes, and create real gadgets.
PROC adjust(base:PTR TO g,x,y,xs,ys,gh:PTR TO guihandle,isinrow=TRUE)
  DEF pl:PTR TO plugin
  IF DoesXResize(base.flags)=FALSE THEN (x:=xs-base.xs/2+x) BUT xs:=base.xs
  IF DoesYResize(base.flags)=FALSE THEN (y:=ys-base.ys/2+y) BUT ys:=base.ys
  SELECT MAXGUI OF base.type
  CASE ROWS,EQROWS,COLS,EQCOLS
    adjustall(base,x,y,xs,ys,gh)
  CASE BEVEL,BEVELR
    adjust(base.list,BEVELXSPACE+x,BEVELYSPACE+y,
           xs-(BEVELXSPACE*2),ys-(BEVELYSPACE*2),gh)
    DrawBevelBoxA(gh.pwnd.rport,x,y,xs,ys,
                 [GT_VISUALINFO,gh.visual,GTBB_FRAMETYPE,BBFT_BUTTON,
                  IF base.type=BEVELR THEN GTBB_RECESSED ELSE TAG_IGNORE,0,NIL])
  CASE BAR
    IF isinrow
      Line(x,y+1,x+xs-1,y+1,1)
      Line(x,y+2,x+xs-1,y+2,2)
    ELSE
      Line(x+1,y,x+1,y+ys-1,1)
      Line(x+2,y,x+2,y+ys-1,2)
    ENDIF
  CASE PLUGIN
    pl:=ATTR(base.list,PLG_OBJ)
    pl.x:=x; pl.y:=y; pl.xs:=xs; pl.ys:=ys
    IF OptATTR(base.list,PLG_GT)
      gh.gl:=pl.gtrender(gh.gl,gh.visual,gh.tattr,x,y,xs,ys,gh.pwnd)
    ELSE
      pl.render(gh.tattr,x,y,xs,ys,gh.pwnd)
    ENDIF
  DEFAULT
    base.x:=x; base.y:=y
    creategadget(base,xs,ys,gh)
  ENDSELECT
ENDPROC x+xs+XSPACING,y+ys+YSPACING

-> adjust over column and row groups.
PROC adjustall(base:PTR TO g,x,y,xs,ys,gh)
  DEF p:PTR TO g,rs=0,fs=0,sp=0,ds=0,t,rg=0,u,row
  -> fs is fixed-width total, rs is resize total
  -> ds is gad count, sp is space gad count
  p:=base.list
  row:=IsRow(base.type)
  WHILE p
    t:=IF row THEN p.ys ELSE p.xs
    IF (row AND DoesYResize(p.flags)) OR (row=FALSE AND DoesXResize(p.flags))
      IF t<=0 THEN sp++ ELSE ((rs:=rs+t) BUT rg++)
    ELSE
      fs:=fs+t
    ENDIF
    p:=p.next
    ds++
  ENDWHILE
  p:=base.list
  ds:=(IF row THEN ys ELSE xs)-rs-fs-(ds-1*IF row THEN YSPACING ELSE XSPACING)
  -> ds is now difference in space reqts
  WHILE p
    t:=IF row THEN p.ys ELSE p.xs
    IF (row AND DoesYResize(p.flags)) OR (row=FALSE AND DoesXResize(p.flags))
      IF t<=0
        IF rg
          IF row THEN ys:=0 ELSE xs:=0
        ELSE  -> If only space gads can resize...
          fs:=((sp-1)/2+ds)/sp  -> Share space completely and fairly
          ds:=ds-fs
          sp--
          IF row THEN ys:=fs ELSE xs:=fs
        ENDIF
      ELSE
        fs:=((t*ds)+((rs-1)/2))/rs  -> Share space completely and fairly
        ds:=ds-fs
        rs:=rs-t
        IF row THEN ys:=t+fs ELSE xs:=t+fs
      ENDIF
    ELSE
      IF row THEN ys:=t ELSE xs:=t
    ENDIF
    t,u:=adjust(p,x,y,xs,ys,gh,row)
    IF row THEN y:=u ELSE x:=t
    p:=p.next
  ENDWHILE
ENDPROC

-> Create real gadget.
PROC creategadget(base:PTR TO g,lxs,lys,gh:PTR TO guihandle)
  DEF tl,i:PTR TO LONG,minargs,text,flags=0,kindtab,h,textl,x,y,xs,ys,
      mid,domid=FALSE,key=0,appw=0
  minargs:=minARGS()
  -> Args at least two, so not SPACE* (never called for other possibilities)
  IF minargs[base.type]>=2
    i:=base.list
    h:=gh.tattr.ysize
    flags:=PLACETEXT_RIGHT
    x:=base.x
    y:=base.y
    xs:=base.xs
    ys:=base.ys
    mid:=IF (base.mid<>NO_MID) AND base.mid THEN (base.mid) ELSE 0
    text:=ATTR(i,EG_TXT)  -> speculative
    IF text=NIL THEN text:=''
    SELECT MAXGUI OF base.type
    CASE BUTTON,SBUTTON,RBUTTON
      tl:=[NIL]
      flags:=PLACETEXT_IN
      IF HasHButtSp(base.type) THEN xs:=lxs
      IF HasVButtSp(base.type) THEN ys:=lys
#ifdef EASY_APPWINDOW
      appw:=OptATTR(i,BUT_APPW)
#endif
    CASE CHECK
      tl:=[GTCB_CHECKED,IF ATTR(i,CHK_VAL) THEN 1 ELSE 0, GTCB_SCALED,TRUE, NIL]
      textl:=IF StrLen(text) THEN mid ELSE 0
      x:=x+textl
      IF ATTR(i,CHK_LEFT) THEN flags:=PLACETEXT_LEFT
      xs:=h*2+2
      ys:=h+1
    CASE LISTV
      xs:=ATTR(i,LST_CURR)
      tl:=[GTLV_LABELS,ATTR(i,LST_LIST), GTLV_SELECTED,xs,
           IF ATTR(i,LST_SHOW)>=1 THEN GTLV_SHOWSELECTED ELSE TAG_IGNORE,NIL,
           -> GTLV_SCROLLWIDTH,h*2,
           GTLV_READONLY,ATTR(i,LST_RO),
->           IF xs<>-1 THEN GTLV_TOP ELSE TAG_IGNORE, xs,
           IF xs<>-1 THEN GTLV_MAKEVISIBLE ELSE TAG_IGNORE, xs, NIL]
      flags:=PLACETEXT_ABOVE
      xs:=lxs
      IF StrLen(text)
        ys:=lys-h-6
        y:=y+h+6
      ELSE
        ys:=lys
      ENDIF
#ifdef EASY_APPWINDOW
      appw:=OptATTR(i,LST_APPW)
#endif
    CASE MX
      tl:=[GTMX_LABELS,ATTR(i,MX_LIST), GTMX_ACTIVE,ATTR(i,MX_CURR),
           GTMX_TITLEPLACE,IF ATTR(i,MX_LEFT) THEN PLACETEXT_LEFT ELSE PLACETEXT_RIGHT,
           GTMX_SPACING,MXSPACE, GTMX_SCALED,TRUE, NIL]
      textl:=IF StrLen(text) THEN mid ELSE 0
      x:=x+textl
      IF ATTR(i,MX_LEFT)=FALSE THEN flags:=PLACETEXT_RIGHT
      xs:=h
      ys:=h
    CASE STR
      tl:=[GTST_STRING,ATTR(i,STR_STR), STRINGA_REPLACEMODE,OptATTR(i,STR_OVR),
           GTST_MAXCHARS,Min(StrMax(ATTR(i,STR_STR)),ATTR(i,STR_MAX)), NIL]
      domid:=TRUE
#ifdef EASY_APPWINDOW
      appw:=OptATTR(i,STR_APPW)
#endif
    CASE INTEGER
      tl:=[GTIN_NUMBER,ATTR(i,INT_VAL), GTIN_MAXCHARS,15, NIL]
      domid:=TRUE
      lxs--
    CASE CYCLE
      tl:=[GTCY_LABELS,ATTR(i,CYC_LIST), GTCY_ACTIVE,ATTR(i,CYC_CURR), NIL]
      domid:=TRUE
    CASE PALETTE
      -> Ack!  Indicator width is large for OS2.0 compatibility
      tl:=[GTPA_DEPTH,ATTR(i,PAL_DEP), GTPA_INDICATORWIDTH,16,
           GTPA_COLOR,ATTR(i,PAL_CURR), NIL]
      domid:=TRUE
    CASE SCROLL
      tl:=[GTSC_TOP,ATTR(i,SCR_TOP), GTSC_TOTAL,ATTR(i,SCR_TOTL),
           PGA_FREEDOM,IF ATTR(i,SCR_VERT) THEN LORIENT_VERT ELSE LORIENT_HORIZ,
           GTSC_VISIBLE,ATTR(i,SCR_VIS), GTSC_ARROWS,12, NIL]
      xs:=lxs
      ys:=lys
      text:=''
    CASE SLIDE
      tl:=[GTSL_MIN,ATTR(i,SLI_MIN), GTSL_MAX,ATTR(i,SLI_MAX),
           GTSL_LEVEL,ATTR(i,SLI_CURR), GTSL_LEVELFORMAT,ATTR(i,SLI_FMT),
           PGA_FREEDOM,IF ATTR(i,SLI_VERT) THEN LORIENT_VERT ELSE LORIENT_HORIZ,
           GTSL_MAXLEVELLEN,3, NIL]
      domid:=TRUE
    CASE TEXT
      tl:=[GTTX_TEXT,ATTR(i,TXT_VAL), GTTX_BORDER,ATTR(i,TXT_BORD), NIL]
      domid:=TRUE
    CASE NUM
      tl:=[GTNM_NUMBER,ATTR(i,NUM_VAL), GTNM_BORDER,ATTR(i,NUM_BORD), NIL]
      domid:=TRUE
    ENDSELECT
    IF domid
      flags:=PLACETEXT_LEFT
      textl:=IF StrLen(text) THEN mid ELSE 0
->      textl:=IF mid<>NO_MID THEN mid ELSE 0
      x:=x+textl
      xs:=lxs-textl
      ys:=lys
    ENDIF
#ifdef EASY_KEYBOARD
    key:=optkey(base.type,i)
#endif
    kindtab:=kindTAB()
    gh.gl:=CreateGadgetA(kindtab[base.type],gh.gl,
        [x,y,xs,ys,text,gh.tattr,base.type,flags,gh.visual,NIL]:newgadget,
        [IF key THEN GT_UNDERSCORE ELSE TAG_IGNORE,"_",
         IF optdis(base.type,i) THEN GA_DISABLED ELSE TAG_IGNORE,TRUE,
         TAG_MORE,tl])
    IF gh.gl=NIL THEN RaiseX("GUI",i,'Could not create gadget. Out of memory?')
    gh.gl.userdata:=i
#ifdef EASY_APPWINDOW
    IF appw THEN gh.gl.mutualexclude:=EG_MAGIC -> AppW magic identifier.
#endif
#ifndef EASY_KEYBOARD
    IF base.type=STR THEN IF gh.firststr=NIL THEN gh.firststr:=gh.gl
#endif
#ifdef EASY_KEYBOARD
    -> Remember gadget in key index.  Key must be lowercase.
    IF islower(key) THEN gh.keys[key-"a"]:=gh.gl
#endif
  ENDIF
ENDPROC

/********** findgadget **********/
EXPORT PROC findgadget(gh:PTR TO guihandle,list)
  DEF gad:PTR TO gadget
  IF gh.wnd
    gad:=gh.glist
    WHILE gad
      IF gad.userdata=list THEN RETURN gad
      gad:=gad.nextgadget
    ENDWHILE
  ENDIF
ENDPROC NIL

#ifdef EASY_APPWINDOW
-> Search for gadget desc list based on mouse position.
PROC findxy(gh:PTR TO guihandle,x,y)
  DEF gad:PTR TO gadget,offx=0,offy=0
  gad:=gh.glist
  WHILE gad
    IF gad.mutualexclude=EG_MAGIC  -> Then it's an EasyGUI AppW gadget...
      -> The only gadgets (so far) have a label on the left or the top,
      -> so compensate and calculate the offset.
      IF gad.gadgettext
        offx:=gad.gadgettext.leftedge
        IF offx>0 THEN offx:=0
        offy:=gad.gadgettext.topedge
        IF offy>0 THEN offy:=0
      ENDIF
      IF x>=(gad.leftedge+offx) THEN
      IF y>=(gad.topedge+offy) THEN
      IF gad.leftedge+gad.width>x THEN
      IF gad.topedge+gad.height>y THEN RETURN gad.userdata
    ENDIF
    gad:=gad.nextgadget
  ENDWHILE
ENDPROC NIL
#endif

-> Set gadget attribute based on real gadget.
PROC setgadattr(g,w,gad:PTR TO LONG,value,tag,index=0)
  IF g THEN Gt_SetGadgetAttrsA(g,w,NIL,[tag,value,NIL])
  IF index THEN ATTR(gad,index):=value
ENDPROC

-> Set gadget attribute based on gadget desc list.
PROC setattr(gh:PTR TO guihandle,gad,value,tag,index=0) IS
  setgadattr(findgadget(gh,gad),gh.wnd,gad,value,tag,index)

/********** setXXXXX **********/
EXPORT PROC setcheck(gh,gad,bool) IS setattr(gh,gad,bool,GTCB_CHECKED,CHK_VAL)
EXPORT PROC setinteger(gh,gad,new) IS setattr(gh,gad,new,GTIN_NUMBER,INT_VAL)
EXPORT PROC setmx(gh,gad,active) IS setattr(gh,gad,active,GTMX_ACTIVE,MX_CURR)
EXPORT PROC setcycle(gh,gad,active) IS setattr(gh,gad,active,GTCY_ACTIVE,CYC_CURR)
EXPORT PROC setpalette(gh,gad,colour) IS setattr(gh,gad,colour,GTPA_COLOR,PAL_CURR)
EXPORT PROC setscrolltop(gh,gad,top) IS setattr(gh,gad,top,GTSC_TOP,SCR_TOP)
EXPORT PROC setscrolltotal(gh,gad,total) IS setattr(gh,gad,total,GTSC_TOTAL,SCR_TOTL)
EXPORT PROC setscrollvisible(gh,gad,visible) IS setattr(gh,gad,visible,GTSC_VISIBLE,SCR_VIS)
EXPORT PROC setslide(gh,gad,new) IS setattr(gh,gad,new,GTSL_LEVEL,SLI_CURR)
EXPORT PROC settext(gh,gad,new) IS setattr(gh,gad,new,GTTX_TEXT,TXT_VAL)
EXPORT PROC setnum(gh,gad,new) IS setattr(gh,gad,new,GTNM_NUMBER,NUM_VAL)
EXPORT PROC setlistvlabels(gh,gad,labs) IS setattr(gh,gad,labs,GTLV_LABELS,LST_LIST)
EXPORT PROC setlistvvisible(gh:PTR TO guihandle,gad,vis) IS setattr(gh,gad,vis,GTLV_MAKEVISIBLE)

EXPORT PROC setlistvselected(gh:PTR TO guihandle,gad,active)
  DEF g
  setgadattr(g:=findgadget(gh,gad),gh.wnd,gad,active,GTLV_SELECTED,LST_CURR)
  IF active<>-1 THEN setgadattr(g,gh.wnd,gad,active,GTLV_MAKEVISIBLE)
ENDPROC

EXPORT PROC setstr(gh,gad:PTR TO LONG,new)
  setattr(gh,gad,new,GTST_STRING)
ENDPROC StrCopy(ATTR(gad,STR_STR),new)

/********** disposegui **********/
EXPORT PROC disposegui(gui:PTR TO LONG)
  DEF a,l
  IF gui
    IF IsGroup(ATTR(gui,EG_TYPE))
      l:=ListLen(gui)-1
      FOR a:=1 TO l DO disposegui(gui[a])
    ENDIF
    FastDisposeList(gui)
  ENDIF
ENDPROC
