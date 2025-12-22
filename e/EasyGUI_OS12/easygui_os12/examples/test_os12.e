/* A set of test GUIs using about any features of EasyGUI and/or
   gadtools in a gallery style. TODO: plugins, EG_MAXW, EG_MAXH,
   let me know what else!

   This code was written basically to test the EasyGUI_OS12
   distribution and the gadtools13.library, but also went a good
   example how EasyGUI can be used in an OO context.

   Here a short intro:

   All windows are OO objects inherited from the "gui" object,
   which provides a polymorph interface to all windows. All window
   objects contain the entire global data they require, so running
   mutliple instances of such an object is no big deal.

   All action functions are mapped to object methods, the pointer to
   the object in question is passed as the info value to each action
   function. (also required for allowing multiple instances)

   All window objects are grouped to one "global" object, which allows
   for cloning of all GUIs in one go (as used in the changewin demo section)

   Please do not redistribute modified versions of this code. If you have
   any ideas how to make things better contact me at metamonk@yahoo.com.

   This code is Copyright (c) 2000, Ralf 'hippie2000' Steines, and
   inherits the legal state from the original EasyGUI disctribution. */


OPT PREPROCESS
OPT LARGE

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui'
#endif

MODULE 'tools/exceptions', 'tools/constructors',
       'exec/nodes', 'exec/lists',
       'libraries/gadtools', 'utility/tagitem',
       'graphics/text', 'graphics/view',
       'intuition/intuition','intuition/screens'

-> the base class of all windows (and it's methods)

OBJECT gui
  gh:PTR TO guihandle        -> the guihandle
  isopen                     -> window open bool
  top                        -> top line of gui
  gui                        -> gui definition
  title                      -> window title
/*
  init()                     constructor
  gui:=getgui(top)           create and get self.gui
  setgh(gh)                  set to external guihandle
  open()                     open the window
  clean()                    called after window closed
  disable(bool)              disable content of gui
  set(bool)                  set all possible values
  get()                      get all possible values
*/
ENDOBJECT

-> the windows classes (and their custom methods if any)

OBJECT mainwin OF gui
ENDOBJECT

OBJECT gtbuttons OF gui
  check[3]:ARRAY OF LONG     -> checkmark gads
  checkv[3]:ARRAY OF LONG    -> checkmark values
  mxlist                     -> mx selections
  mx[3]:ARRAY OF LONG        -> mx gads
  mxv[3]:ARRAY OF LONG       -> mx values
  button,sbutton,            -> button gads
  cyclelist                  -> cycle selections
  cycle[2]:ARRAY OF LONG     -> cycle gads
  cyclev[2]:ARRAY OF LONG    -> cycle values
ENDOBJECT

OBJECT gttexts OF gui
  integer[2]:ARRAY OF LONG   -> integer gads
  integerv[2]:ARRAY OF LONG  -> integer values
  str[2]:ARRAY OF LONG       -> string gads
  strv[2]:ARRAY OF LONG      -> string strings
  num[4]:ARRAY OF LONG       -> num gads
  numv[4]:ARRAY OF LONG      -> num values
  text[4]:ARRAY OF LONG      -> text gads
  textv[4]:ARRAY OF LONG     -> text pointers
ENDOBJECT

OBJECT gtscrolls OF gui
  slide[6]:ARRAY OF LONG     -> slide gads
  slidev[6]:ARRAY OF LONG    -> slide values
  scroll[6]:ARRAY OF LONG    -> scroll gads
  scrollv[6]:ARRAY OF LONG   -> scroll values
/*
  set_total(bool)            set scroller's total value
  set_visible(bool)          set scroller's visible value
*/
ENDOBJECT

OBJECT gtlistvs OF gui
  list1                      -> default list
  list2                      -> changed list
  listv[8]:ARRAY OF LONG     -> listv gads
  listvv[8]:ARRAY OF LONG    -> listv values
/*
  set_list(bool)             set listview's list
*/
ENDOBJECT

OBJECT gtpalettes OF gui
  palette[6]:ARRAY OF LONG   -> palette gads
  palettev[6]:ARRAY OF LONG  -> palette values
ENDOBJECT

OBJECT egspaces OF gui
ENDOBJECT

OBJECT egbevels OF gui
ENDOBJECT

OBJECT gtmenus OF gui
  menus1                     -> newmenu struct 1
  menus2                     -> newmenu struct 2
  menumx                     -> the mx to choose between
  menusnum                   -> the current menus
/*
  change_menus(frommx,num)   change menus of this win
*/
ENDOBJECT

OBJECT egchwin OF gui
  screenmx                   -> mx to choose screen
  screennum                  -> the current choice
  winmx                      -> mx to choose window type
  wintypenum                 -> the current choice
  fontmx                     -> mx to choose font
  fontnum                    -> the current choice
  titlemx                    -> mx to choose window title
  titlenum                   -> the current choice
/*
  change_screen(frommx,num)  change screen of all open windows
  change_wintype(frommx,num) change decoration of all open windows
  change_font(frommx,num)    change font of all open windows
  change_title(num)          change title of all open windows
  open_all(frombutton)       open all windows
  close_all()                close all windows
  block_all()                block all windows
  move_all()                 move all windows
  size_all()                 size all windows
*/
ENDOBJECT

OBJECT egchgui OF gui
  guilist                    -> list of all guis
  guilabels                  -> and their names
  guicycle                   -> cycle to choose gui
  guinum                     -> the current choice
ENDOBJECT

-> the global class containing all window objects and the global data

OBJECT global
  mh:PTR TO multihandle      -> the multihandle for all windows
  menus                      -> the menus shared to all windows
  screen                     -> the screen where all goes on
  wintype                    -> the decoration type of all windows
  font                       -> the font (textattr) of all windows
  title                      -> global title for all windows or NIL
  mainwin:PTR TO mainwin
  gtbuttons:PTR TO gtbuttons
  gttexts:PTR TO gttexts
  gtscrolls:PTR TO gtscrolls
  gtlistvs:PTR TO gtlistvs
  gtpalettes:PTR TO gtpalettes
  egspaces:PTR TO egspaces
  egbevels:PTR TO egbevels
  gtmenus:PTR TO gtmenus
  egchwin:PTR TO egchwin
  egchgui:PTR TO egchgui
/*
  init()                     constructor
  end()                      destructor
*/
ENDOBJECT

-> the two global vars :)

DEF global=NIL:PTR TO global,   -> All gui objects
    global2=NIL:PTR TO global,  -> A 2nd instance for changegui window

  -> These two are required for ForAll() and multiforall(). Using local vars
  -> instead (which i would have preferred) crashes all !?! (EC 3.3a reg)

    x:PTR TO guihandle,
    g:PTR TO gui


/********************************************************************
 * Polymorph interface to all windows + action function wrapper
 ********************************************************************/

PROC init() OF gui IS EMPTY

PROC getgui(t) OF gui RETURN NIL

PROC setgh(gh) OF gui
    self.gh:=gh
ENDPROC

PROC open(close=NIL,clean=NIL) OF gui
  DEF mygh
  IF self.isopen=FALSE
    self.isopen:=TRUE
    addmultiA(global.mh,IF global.title THEN global.title ELSE self.title,
      self.getgui([BAR]),
      [ EG_CLOSE,  close,
        EG_CLEAN,  IF clean THEN clean ELSE {gui_clean},
        EG_INFO,   self,
        EG_GHVAR,  {mygh},
        EG_MENU,   global.menus,
        EG_WTYPE,  global.wintype,
        EG_SCRN,   global.screen,
        EG_FONT,   global.font,
        EG_AWPROC, {global_awp},
        EG_LEFT,   Rnd(400),
        EG_TOP,    Rnd(400),
        TAG_DONE]
    )
    self.gh:=mygh
  ELSE
    tofront(self.gh)
  ENDIF
ENDPROC

-> clean(info)
PROC gui_clean(gui:PTR TO gui) IS gui.clean()
PROC clean() OF gui
  self.isopen:=FALSE
  self.gh:=NIL
ENDPROC

-> button(qual*,data*,info)
PROC gui_disable(d,gui:PTR TO gui) IS gui.disable(d)
PROC disable(d) OF gui IS EMPTY

-> button(qual*,data*,info)
PROC gui_set(d,gui:PTR TO gui) IS gui.set(d)
PROC set(d) OF gui IS EMPTY

-> button(qual*,data*,info)
PROC gui_get(gui:PTR TO gui) IS gui.get()
PROC get() OF gui IS EMPTY


/********************************************************************
 * Buttons window
 ********************************************************************/

PROC init() OF gtbuttons
  DEF i
  self.title:='Gadtools Buttons in EasyGUI_OS12'
  self.mxlist:=['One','Two','Three',NIL]
  self.cyclelist:=['Yep','Nope','Hmmm',NIL]
  FOR i:=0 TO 2
    self.checkv[i]:=TRUE
    self.mxv[i]:=1
  ENDFOR
  FOR i:=0 TO 1 DO self.cyclev[i]:=1
ENDPROC

PROC getgui(top) OF gtbuttons
  DEF check0,check1,check2, mx0,mx1,mx2, button,sbutton, cycle0,cycle1
  IF self.gui=NIL
    self.gui:=
      NEW [ROWS,
        top,
        NEW [TEXT,'Button and Sbutton are App-Buttons',NIL,FALSE,5],
        NEW [BAR],
        NEW [COLS,

          NEW [ROWS,

              NEW [BEVEL,
                check0:=NEW [CHECK,                         -> CHECKs
                {gtbuttons_cmv},-> action
                '_Check',       -> righttext
                self.checkv[0], -> checked
                FALSE,          -> lefttextbool
                0,              -> data
                "c",            -> key
                FALSE]          -> disabled
              ],
              NEW [BEVEL,
                check1:=NEW [CHECK,
                {gtbuttons_cmv},-> action
                'C_heck',       -> righttext
                self.checkv[1], -> checked
                TRUE,           -> lefttextbool
                1,              -> data
                "h",            -> key
                FALSE]          -> disabled
              ],
              NEW [BEVEL,
                check2:=NEW [CHECK,
                {gtbuttons_cmv},-> action
                NIL,            -> righttext
                self.checkv[2], -> checked
                FALSE,          -> lefttextbool
                2,              -> data
                NIL,            -> key
                FALSE]          -> disabled
              ],
              NEW [BEVEL,
                mx0:=NEW [MX,                               -> MXs
                {gtbuttons_mxv},-> action
                NIL,            -> righttext
                self.mxlist,    -> list
                FALSE,          -> lefttextbool
                self.mxv[0],    -> current
                0,              -> data
                NIL,            -> key
                FALSE]          -> disabled
              ]

          ],

          NEW [ROWS,

              NEW [BEVEL,
                mx1:=NEW [MX,
                {gtbuttons_mxv},-> action
                '_Mx',          -> righttext
                self.mxlist,    -> list
                FALSE,          -> lefttextbool
                self.mxv[1],    -> current
                1,              -> data
                "m",            -> key
                FALSE]          -> disabled
              ],
              NEW [BEVEL,
                mx2:=NEW [MX,
                {gtbuttons_mxv},-> action
                'M_x',          -> righttext
                self.mxlist,    -> list
                TRUE,           -> lefttextbool
                self.mxv[2],    -> current
                2,              -> data
                "x",            -> key
                FALSE]          -> disabled
              ]


          ],

          NEW [ROWS,

              NEW [BEVEL,
                button:=NEW [BUTTON,                         -> BUTTONS
                {gtbuttons_btv},-> action
                '_Button',      -> text
                '',             -> data
                "b",            -> key
                {gtbuttons_gaw},-> awproc
                FALSE]          -> disabled
              ],
              NEW [BEVEL,
                sbutton:=NEW [SBUTTON,
                {gtbuttons_btv},-> action
                '_SButton',     -> text
                's',            -> data
                "s",            -> key
                {gtbuttons_gaw},-> awproc
                FALSE]          -> disabled
              ],
              NEW [BEVEL,
                cycle0:=NEW [CYCLE,                           -> CYCLEs
                {gtbuttons_cyv},-> action
                'C_ycle',       -> lefttext
                self.cyclelist, -> list
                self.cyclev[0], -> current
                0,              -> data
                "y",            -> key
                FALSE]          -> disabled
              ],
              NEW [BEVEL,
                cycle1:=NEW [CYCLE,
                {gtbuttons_cyv},-> action
                NIL,            -> lefttext
                self.cyclelist, -> list
                self.cyclev[1], -> current
                1,              -> data
                NIL,            -> key
                FALSE]          -> disabled
              ]

          ]

        ],
        NEW [BAR],
        NEW [EQCOLS,
          NEW [BUTTON,{gui_disable},'Disable',TRUE],
          NEW [BUTTON,{gui_disable},'Enable',FALSE],
          NEW [BUTTON,{gui_set},'Set',TRUE],
          NEW [BUTTON,{gui_set},'Reset',FALSE],
          NEW [BUTTON,{gui_get},'Get',TRUE],
          NEW [BUTTON,0,'Close']
        ]
      ]
    self.check[0]:=check0; self.check[1]:=check1; self.check[2]:=check2
    self.mx[0]:=mx0; self.mx[1]:=mx1; self.mx[2]:=mx2
    self.button:=button; self.sbutton:=sbutton
    self.cycle[0]:=cycle0; self.cycle[1]:=cycle1
  ENDIF
ENDPROC self.gui

PROC disable(bool) OF gtbuttons
  DEF i
  FOR i:=0 TO 2
    setdisabled(self.gh,self.check[i],bool)
    setdisabled(self.gh,self.mx[i],bool)
  ENDFOR
  setdisabled(self.gh,self.button,bool)
  setdisabled(self.gh,self.sbutton,bool)
  FOR i:=0 TO 1
    setdisabled(self.gh,self.cycle[i],bool)
  ENDFOR
ENDPROC

PROC set(bool) OF gtbuttons
  DEF new,i
  new:=IF bool THEN FALSE ELSE TRUE
  FOR i:=0 TO 2
    self.checkv[i]:=new
    setcheck(self.gh,self.check[i],new)
  ENDFOR
  new:=IF bool THEN 2 ELSE 1
  FOR i:=0 TO 2
    self.mxv[i]:=new
    setmx(self.gh,self.mx[i],new)
  ENDFOR
  new:=IF bool THEN 0 ELSE 1
  FOR i:=0 TO 1
    self.cyclev[i]:=new
    setcycle(self.gh,self.cycle[i],new)
  ENDFOR
ENDPROC

PROC get() OF gtbuttons
  DEF i
  WriteF('---All values:\n')
  FOR i:=0 TO 2 DO WriteF('check\d: \d\n',i,self.checkv[i])
  FOR i:=0 TO 2 DO WriteF('mx\d: \d\n',i,self.mxv[i])
  FOR i:=0 TO 1 DO WriteF('cycle\d: \d\n',i,self.cyclev[i])
  WriteF('---\n')
ENDPROC

-> check(qual*,data*,info,checkedbool)
PROC gtbuttons_cmv(num,gui:PTR TO gtbuttons,val) IS setdisp('check',gui.checkv,num,val)

-> mx(qual*,data*,info,num_selected)
PROC gtbuttons_mxv(num,gui:PTR TO gtbuttons,val) IS setdisp('mx',gui.mxv,num,val)

-> button(qual*,data*,info)
PROC gtbuttons_btv(str,i) IS WriteF('\sbutton=clicked\n',str)

-> appwin(data*,info,awmsg:PTR TO appmessage)
PROC gtbuttons_gaw(str,gui:PTR TO gtbuttons,a) IS WriteF('Dropped in \sbutton\n',str)

-> cycle(qual*,data*,info,num_selected)
PROC gtbuttons_cyv(num,gui:PTR TO gtbuttons,val) IS setdisp('cycle',gui.cyclev,num,val)


/********************************************************************
 * Texts window
 ********************************************************************/

PROC init() OF gttexts
  DEF i
  self.title:='Gadtools Texts in EasyGUI_OS12'
  FOR i:=0 TO 1
    self.integerv[i]:=123
    self.strv[i]:=String(50)
    StrCopy(self.strv[i],'bla')
  ENDFOR
  FOR i:=0 TO 3
    self.numv[i]:=123
    self.textv[i]:='bla'
  ENDFOR
ENDPROC

PROC getgui(top) OF gttexts
  DEF integer0,integer1, str0,str1, num0,num1,num2,num3, text0,text1,text2,text3
  IF self.gui=NIL
    self.gui:=
      NEW [ROWS,
        top,
        NEW [TEXT,'The string gadgets are App-Gadgets',NIL,FALSE,5],
        NEW [BAR],
        NEW [COLS,

          NEW [ROWS,

              NEW [BEVEL,
                integer0:=NEW [INTEGER,                   -> INTEGERs
                {gttexts_itv},   -> action
                '_Integer',      -> lefttext
                self.integerv[0],-> value
                5,               -> relsize
                0,               -> data
                "i",             -> key
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                integer1:=NEW [INTEGER,
                {gttexts_itv},   -> action
                NIL,             -> lefttext
                self.integerv[0],-> value
                5,               -> relsize
                1,               -> data
                NIL,             -> key
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                str0:=NEW [STR,                             -> STRs
                {gttexts_stv},   -> action
                '_Str',          -> lefttext
                self.strv[0],    -> initial
                50,              -> maxchars
                5,               -> relsize
                FALSE,           -> overbool
                0,               -> data
                "s",             -> key
                {gttexts_gaw},   -> awproc
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                str1:=NEW [STR,
                {gttexts_stv},   -> action
                NIL,             -> lefttext
                self.strv[1],    -> initial
                50,              -> maxchars
                5,               -> relsize
                FALSE,           -> overbool
                1,               -> data
                NIL,             -> key
                {gttexts_gaw},   -> awproc
                FALSE]           -> disabled
              ]

          ],

          NEW [ROWS,

              NEW [BEVEL,
                num0:=NEW [NUM,                             -> NUMs
                self.numv[0],    -> value
                'Num',           -> lefttext  NO KEY!
                TRUE,            -> borderbool
                5]               -> relsize
              ],
              NEW [BEVEL,
                num1:=NEW [NUM,
                self.numv[1],    -> value
                'Num',           -> lefttext  NO KEY!
                FALSE,           -> borderbool
                5]               -> relsize
              ],
              NEW [BEVEL,
                num2:=NEW [NUM,
                self.numv[2],    -> value
                NIL,             -> lefttext  NO KEY!
                TRUE,            -> borderbool
                5]               -> relsize
              ],
              NEW [BEVEL,
                num3:=NEW [NUM,
                self.numv[3],    -> value
                NIL,             -> lefttext  NO KEY!
                FALSE,           -> borderbool
                5]               -> relsize
              ]

          ],

          NEW [ROWS,

              NEW [BEVEL,
                text0:=NEW [TEXT,                             -> TEXTs
                self.textv[0],   -> string
                'Text',          -> lefttext  NO KEY!
                TRUE,            -> borderbool
                5]               -> relsize
              ],
              NEW [BEVEL,
                text1:=NEW [TEXT,
                self.textv[1],   -> string
                'Text',          -> lefttext  NO KEY!
                FALSE,           -> borderbool
                5]               -> relsize
              ],
              NEW [BEVEL,
                text2:=NEW [TEXT,
                self.textv[2],   -> string
                NIL,             -> lefttext  NO KEY!
                TRUE,            -> borderbool
                5]               -> relsize
              ],
              NEW [BEVEL,
                text3:=NEW [TEXT,
                self.textv[3],   -> string
                NIL,             -> lefttext  NO KEY!
                FALSE,           -> borderbool
                5]               -> relsize
              ]

          ]

        ],
        NEW [BAR],
        NEW [EQCOLS,
          NEW [BUTTON,{gui_disable},'Disable',TRUE],
          NEW [BUTTON,{gui_disable},'Enable',FALSE],
          NEW [BUTTON,{gui_set},'Set',TRUE],
          NEW [BUTTON,{gui_set},'Reset',FALSE],
          NEW [BUTTON,{gui_get},'Get',TRUE],
          NEW [BUTTON,0,'Close']
        ]
      ]
    self.integer[0]:=integer0; self.integer[1]:=integer1
    self.str[0]:=str0; self.str[1]:=str1
    self.num[0]:=num0; self.num[1]:=num1; self.num[2]:=num2; self.num[3]:=num3
    self.text[0]:=text0; self.text[1]:=text1; self.text[2]:=text2; self.text[3]:=text3
  ENDIF
ENDPROC self.gui

PROC disable(bool) OF gttexts
  DEF i
  FOR i:=0 TO 1
    setdisabled(self.gh,self.integer[i],bool)
    setdisabled(self.gh,self.str[i],bool)
  ENDFOR
  FOR i:=0 TO 3
    setdisabled(self.gh,self.num[i],bool)
    setdisabled(self.gh,self.text[i],bool)
  ENDFOR
ENDPROC

PROC set(bool) OF gttexts
  DEF new,i
  new:=IF bool THEN 432 ELSE 123
  FOR i:=0 TO 1
    self.integerv[i]:=new
    setinteger(self.gh,self.integer[i],new)
  ENDFOR
  FOR i:=0 TO 3
    self.numv[i]:=new
    setnum(self.gh,self.num[i],new)
  ENDFOR
  new:=IF bool THEN 'blurp' ELSE 'bla'
  FOR i:=0 TO 1
    setstr(self.gh,self.str[i],new)
  ENDFOR
  FOR i:=0 TO 3
    self.textv[i]:=new
    settext(self.gh,self.text[i],new)
  ENDFOR
ENDPROC

PROC get() OF gttexts
  DEF i
  WriteF('---All values:\n')
  FOR i:=0 TO 1
    self.integerv[i]:=getinteger(self.gh,self.integer[i])
    WriteF('integer\d: \d\n',i,self.integerv[i])
  ENDFOR
  FOR i:=0 TO 1
    getstr(self.gh,self.str[i])
    WriteF('str\d: \s\n',i,self.strv[i])
  ENDFOR
  FOR i:=0 TO 3 DO WriteF('num\d: \d\n',i,self.numv[i])
  FOR i:=0 TO 3 DO WriteF('text\d: \s\n',i,self.textv[i])
  WriteF('---\n')
ENDPROC

-> appwin(data*,info,awmsg:PTR TO appmessage)
PROC gttexts_gaw(num,gui:PTR TO gttexts,a) IS WriteF('Dropped in str\d\n',num)

-> integer(qual*,data*,info,newnum)
PROC gttexts_itv(num,gui:PTR TO gttexts,val) IS setdisp('integer',gui.integerv,num,val)

-> (qual*,data*,info,string)
PROC gttexts_stv(num,i,str) IS dispstr('str',num,str)


/********************************************************************
 * Sliders + Scrollers window
 ********************************************************************/

PROC init() OF gtscrolls
  DEF i
  self.title:='Gadtools Sliders + Scrollers in EasyGUI_OS12'
  FOR i:=0 TO 5 DO self.slidev[i]:=20
  FOR i:=0 TO 1 DO self.scrollv[i]:=20
ENDPROC

PROC getgui(top) OF gtscrolls
  DEF scroll0,scroll1, slide0,slide1,slide2,slide3,slide4,slide5
  IF self.gui=NIL
    self.gui:=
      NEW [ROWS,
        top,
        NEW [COLS,

          NEW [BUTTON,{gtscrolls_settotal},'Set Total',TRUE],
          NEW [BUTTON,{gtscrolls_settotal},'Reset Total',FALSE],
          NEW [BUTTON,{gtscrolls_setvisible},'Set Visible',TRUE],
          NEW [BUTTON,{gtscrolls_setvisible},'Reset Visible',FALSE],
          NEW [TEXT,' keys: V+H',NIL,FALSE,5]

        ],
        NEW [BAR],
        NEW [COLS,

              NEW [BEVEL,
                scroll0:=NEW [SCROLL,                     -> SCROLLs
                {gtscrolls_scv}, -> action
                TRUE,            -> isvert
                400,             -> total
                self.scrollv[0], -> top
                20,              -> visible
                2,               -> relsize
                0,               -> data
                "v",             -> key
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                slide0:=NEW [SLIDE,                       -> SLIDEs
                {gtscrolls_slv}, -> action
                '_Slider     ',  -> lefttext
                TRUE,            -> isvert
                0,               -> min
                999,             -> max
                self.slidev[0],  -> cur
                2,               -> relsize
                '%3ld',          -> levelformat
                0,               -> data
                "s",             -> key
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                slide1:=NEW [SLIDE,
                {gtscrolls_slv}, -> action
                '    ',          -> lefttext
                TRUE,            -> isvert
                0,               -> min
                999,             -> max
                self.slidev[1],  -> cur
                2,               -> relsize
                '%3ld',          -> levelformat
                1,               -> data
                NIL,             -> key
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                slide2:=NEW [SLIDE,
                {gtscrolls_slv}, -> action
                NIL,             -> lefttext
                TRUE,            -> isvert
                0,               -> min
                999,             -> max
                self.slidev[2],  -> cur
                2,               -> relsize
                '',              -> levelformat
                2,               -> data
                NIL,             -> key
                FALSE]           -> disabled
              ],

          NEW [ROWS,

              NEW [BEVEL,
                scroll1:=NEW [SCROLL,                     -> SCROLLs
                {gtscrolls_scv}, -> action
                FALSE,           -> isvert
                400,             -> total
                self.scrollv[1], -> top
                20,              -> visible
                2,               -> relsize
                1,               -> data
                "h",             -> key
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                slide3:=NEW [SLIDE,                       -> SLIDEs
                {gtscrolls_slv}, -> action
                'S_lider     ',  -> lefttext
                FALSE,           -> isvert
                0,               -> min
                999,             -> max
                self.slidev[3],  -> cur
                2,               -> relsize
                '%3ld',          -> levelformat
                3,               -> data
                "l",             -> key
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                slide4:=NEW [SLIDE,
                {gtscrolls_slv}, -> action
                '    ',          -> lefttext
                FALSE,           -> isvert
                0,               -> min
                999,             -> max
                self.slidev[4],  -> cur
                2,               -> relsize
                '%3ld',          -> levelformat
                4,               -> data
                NIL,             -> key
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                slide5:=NEW [SLIDE,
                {gtscrolls_slv}, -> action
                NIL,             -> lefttext
                FALSE,           -> isvert
                0,               -> min
                999,             -> max
                self.slidev[5],  -> cur
                2,               -> relsize
                '',              -> levelformat
                5,               -> data
                NIL,             -> key
                FALSE]           -> disabled
              ]

          ]

        ],
        NEW [BAR],
        NEW [EQCOLS,
          NEW [BUTTON,{gui_disable},'Disable',TRUE],
          NEW [BUTTON,{gui_disable},'Enable',FALSE],
          NEW [BUTTON,{gui_set},'Set',TRUE],
          NEW [BUTTON,{gui_set},'Reset',FALSE],
          NEW [BUTTON,{gui_get},'Get',TRUE],
          NEW [BUTTON,0,'Close']
        ]
      ]
    self.scroll[0]:=scroll0; self.scroll[1]:=scroll1
    self.slide[0]:=slide0; self.slide[1]:=slide1; self.slide[2]:=slide2
    self.slide[3]:=slide3; self.slide[4]:=slide4; self.slide[5]:=slide5
  ENDIF
ENDPROC self.gui

PROC disable(bool) OF gtscrolls
  DEF i
  FOR i:=0 TO 1 DO setdisabled(self.gh,self.scroll[i],bool)
  FOR i:=0 TO 5 DO setdisabled(self.gh,self.slide[i],bool)
ENDPROC

PROC set(bool) OF gtscrolls
  DEF new,i
  new:=IF bool THEN 200 ELSE 20
  FOR i:=0 TO 1
    self.scrollv[i]:=new
    setscrolltop(self.gh,self.scroll[i],new)
  ENDFOR
  FOR i:=0 TO 5
    self.slidev[i]:=new
    setslide(self.gh,self.slide[i],new)
  ENDFOR
ENDPROC

PROC get() OF gtscrolls
  DEF i
  WriteF('---All values:\n')
  FOR i:=0 TO 1 DO WriteF('scroll\d: \d\n',i,self.scrollv[i])
  FOR i:=0 TO 5 DO WriteF('slide\d: \d\n',i,self.slidev[i])
  WriteF('---\n')
ENDPROC

-> button(qual*,data*,info)
PROC gtscrolls_settotal(bool,gui:PTR TO gtscrolls) IS gui.set_total(bool)

PROC set_total(bool) OF gtscrolls
  DEF new,i
  new:=IF bool THEN 250 ELSE 400
  FOR i:=0 TO 1 DO setscrolltotal(self.gh,self.scroll[i],new)
ENDPROC

-> button(qual*,data*,info)
PROC gtscrolls_setvisible(bool,gui:PTR TO gtscrolls) IS gui.set_visible(bool)

PROC set_visible(bool) OF gtscrolls
  DEF new,i
  new:=IF bool THEN 50 ELSE 20
  FOR i:=0 TO 1 DO setscrollvisible(self.gh,self.scroll[i],new)
ENDPROC

-> slide(qual*,data*,info,cur)
PROC gtscrolls_slv(num,gui:PTR TO gtscrolls,val) IS setdisp('slide',gui.slidev,num,val)

-> scroll(qual*,data*,info,curtop)
PROC gtscrolls_scv(num,gui:PTR TO gtscrolls,val) IS setdisp('scroll',gui.scrollv,num,val)


/********************************************************************
 * Listviews window
 ********************************************************************/

PROC init() OF gtlistvs
  DEF i
  self.title:='Gadtools Listviews in EasyGUI_OS12'
  self.list1:=makeexeclist(['zero','one','two','three','four','five','six','seven',
                            'eight','nine','ten','eleven','twelve','thirteen','fourteen'])
  self.list2:=makeexeclist(['null','eins','zwei','drei','vier','fuenf','sechs','sieben',
                            'acht','neun','zehn','elf','zwoelf','dreizehn','vierzehn'])
  FOR i:=0 TO 7 DO self.listvv[i]:=2
ENDPROC

PROC getgui(top) OF gtlistvs
  DEF listv0,listv1,listv2,listv3,listv4,listv5,listv6,listv7
  IF self.gui=NIL
    self.gui:=
      NEW [ROWS,
        top,
        NEW [COLS,

          NEW [BUTTON,{gtlistvs_setlist},'Set List',TRUE],
          NEW [BUTTON,{gtlistvs_setlist},'Reset List',FALSE],
          NEW [SPACEH],
          NEW [TEXT,'All listviews are App-Gadgets',NIL,FALSE,5]

        ],
        NEW [BAR],
        NEW [COLS,

              NEW [BEVEL,
                listv0:=NEW [LISTV,                     -> LISTVs
                {gtlistvs_lvv},  -> action
                '_Listview',     -> textabove
                5,               -> relx
                5,               -> rely
                self.list1,      -> execlist
                FALSE,           -> readbool
                0,               -> selected  0=none, 1=highlight/show selected
                self.listvv[0],  -> current
                0,               -> data
                "l",             -> key
                {gtlistvs_gaw},  -> awproc
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                listv1:=NEW [LISTV,
                {gtlistvs_lvv},  -> action
                NIL,             -> textabove
                5,               -> relx
                5,               -> rely
                self.list1,      -> execlist
                FALSE,           -> readbool
                0,               -> selected  0=none, 1=highlight/show selected
                self.listvv[1],  -> current
                1,               -> data
                NIL,             -> key
                {gtlistvs_gaw},  -> awproc
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                listv2:=NEW [LISTV,
                {gtlistvs_lvv},  -> action
                'L_istview',     -> textabove
                5,               -> relx
                5,               -> rely
                self.list1,      -> execlist
                FALSE,           -> readbool
                1,               -> selected  0=none, 1=highlight/show selected
                self.listvv[2],  -> current
                2,               -> data
                "i",             -> key
                {gtlistvs_gaw},  -> awproc
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                listv3:=NEW [LISTV,
                {gtlistvs_lvv},  -> action
                NIL,             -> textabove
                5,               -> relx
                5,               -> rely
                self.list1,      -> execlist
                FALSE,           -> readbool
                1,               -> selected  0=none, 1=highlight/show selected
                self.listvv[3],  -> current
                3,               -> data
                NIL,             -> key
                {gtlistvs_gaw},  -> awproc
                FALSE]           -> disabled
              ]

        ],
        NEW [TEXT,'Above are normal listviews, below should be "read only" ones:',NIL,FALSE,5],
        NEW [COLS,

              NEW [BEVEL,
                listv4:=NEW [LISTV,                     -> LISTVs
                {gtlistvs_lvv},  -> action
                'Li_stview',     -> textabove
                5,               -> relx
                5,               -> rely
                self.list1,      -> execlist
                TRUE,            -> readbool
                0,               -> selected  0=none, 1=highlight/show selected
                self.listvv[4],  -> current
                4,               -> data
                "s",             -> key
                {gtlistvs_gaw},  -> awproc
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                listv5:=NEW [LISTV,
                {gtlistvs_lvv},  -> action
                NIL,             -> textabove
                5,               -> relx
                5,               -> rely
                self.list1,      -> execlist
                TRUE,            -> readbool
                0,               -> selected  0=none, 1=highlight/show selected
                self.listvv[5],  -> current
                5,               -> data
                NIL,             -> key
                {gtlistvs_gaw},  -> awproc
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                listv6:=NEW [LISTV,
                {gtlistvs_lvv},  -> action
                'Lis_tview',     -> textabove
                5,               -> relx
                5,               -> rely
                self.list1,      -> execlist
                TRUE,            -> readbool
                1,               -> selected  0=none, 1=highlight/show selected
                self.listvv[6],  -> current
                6,               -> data
                "t",             -> key
                {gtlistvs_gaw},  -> awproc
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                listv7:=NEW [LISTV,
                {gtlistvs_lvv},  -> action
                NIL,             -> textabove
                5,               -> relx
                5,               -> rely
                self.list1,      -> execlist
                TRUE,            -> readbool
                1,               -> selected  0=none, 1=highlight/show selected
                self.listvv[7],  -> current
                7,               -> data
                NIL,             -> key
                {gtlistvs_gaw},  -> awproc
                FALSE]           -> disabled
              ]

        ],
        NEW [BAR],
        NEW [EQCOLS,
          NEW [BUTTON,{gui_disable},'Disable',TRUE],
          NEW [BUTTON,{gui_disable},'Enable',FALSE],
          NEW [BUTTON,{gui_set},'Set',TRUE],
          NEW [BUTTON,{gui_set},'Reset',FALSE],
          NEW [BUTTON,{gui_get},'Get',TRUE],
          NEW [BUTTON,0,'Close']
        ]
      ]
    self.listv[0]:=listv0; self.listv[1]:=listv1; self.listv[2]:=listv2; self.listv[3]:=listv3
    self.listv[4]:=listv4; self.listv[5]:=listv5; self.listv[6]:=listv6; self.listv[7]:=listv7
  ENDIF
ENDPROC self.gui

PROC disable(bool) OF gtlistvs
  DEF i
  FOR i:=0 TO 7 DO setdisabled(self.gh,self.listv[i],bool)
ENDPROC

PROC set(bool) OF gtlistvs
  DEF new,i
  new:=IF bool THEN 6 ELSE 2
  FOR i:=0 TO 7
    self.listvv[i]:=new
    setlistvselected(self.gh,self.listv[i],new)
    setlistvvisible(self.gh,self.listv[i],new)
  ENDFOR
ENDPROC

PROC get() OF gtlistvs
  DEF i
  WriteF('---All values:\n')
  FOR i:=0 TO 7 DO WriteF('listv\d: \d\n',i,self.listvv[i])
  WriteF('---\n')
ENDPROC

-> button(qual*,data*,info)
PROC gtlistvs_setlist(bool,gui:PTR TO gtlistvs) IS gui.set_list(bool)

PROC set_list(bool) OF gtlistvs
  DEF new,i
  new:=IF bool THEN self.list2 ELSE self.list1
  FOR i:=0 TO 7
    setlistvlabels(self.gh,self.listv[i],new)
  ENDFOR
ENDPROC

-> (qual*,data*,info,num_selected)
PROC gtlistvs_lvv(num,gui:PTR TO gtlistvs,val) IS setdisp('listv',gui.listvv,num,val)

-> appwin(data*,info,awmsg:PTR TO appmessage)
PROC gtlistvs_gaw(num,gui:PTR TO gtlistvs,a) IS WriteF('Dropped in listv\d\n',num)


/********************************************************************
 * Palettes window
 ********************************************************************/

PROC init() OF gtpalettes
  DEF i
  self.title:='Gadtools Palettes in EasyGUI_OS12'
  FOR i:=0 TO 5 DO self.palettev[i]:=2
ENDPROC

PROC getgui(top) OF gtpalettes
  DEF palette0,palette1,palette2,palette3,palette4,palette5
  IF self.gui=NIL
    self.gui:=
      NEW [ROWS,
        top,
        NEW [COLS,

              NEW [BEVEL,
                palette0:=NEW [PALETTE,                     -> PALETTEs
                {gtpalettes_plv},-> action
                '_Palette',      -> lefttext
                3,               -> depth
                1,               -> relx
                5,               -> rely
                self.palettev[0],-> current
                0,               -> data
                "p",             -> key
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                palette1:=NEW [PALETTE,
                {gtpalettes_plv},-> action
                NIL,             -> lefttext
                3,               -> depth
                1,               -> relx
                5,               -> rely
                self.palettev[1],-> current
                1,               -> data
                NIL,             -> key
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                palette2:=NEW [PALETTE,
                {gtpalettes_plv},-> action
                NIL,             -> lefttext
                5,               -> depth
                1,               -> relx
                5,               -> rely
                self.palettev[2],-> current
                2,               -> data
                NIL,             -> key
                FALSE]           -> disabled
              ],

          NEW [ROWS,

              NEW [BEVEL,
                palette3:=NEW [PALETTE,
                {gtpalettes_plv},-> action
                'P_alette',      -> lefttext
                3,               -> depth
                5,               -> relx
                1,               -> rely
                self.palettev[3],-> current
                4,               -> data
                "a",             -> key
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                palette4:=NEW [PALETTE,
                {gtpalettes_plv},-> action
                NIL,             -> lefttext
                3,               -> depth
                5,               -> relx
                1,               -> rely
                self.palettev[4],-> current
                5,               -> data
                NIL,             -> key
                FALSE]           -> disabled
              ],
              NEW [BEVEL,
                palette5:=NEW [PALETTE,
                {gtpalettes_plv},-> action
                NIL,             -> lefttext
                5,               -> depth
                5,               -> relx
                1,               -> rely
                self.palettev[5],-> current
                6,               -> data
                NIL,             -> key
                FALSE]           -> disabled
              ]

          ]
        ],
        NEW [BAR],
        NEW [EQCOLS,
          NEW [BUTTON,{gui_disable},'Disable',TRUE],
          NEW [BUTTON,{gui_disable},'Enable',FALSE],
          NEW [BUTTON,{gui_set},'Set',TRUE],
          NEW [BUTTON,{gui_set},'Reset',FALSE],
          NEW [BUTTON,{gui_get},'Get',TRUE],
          NEW [BUTTON,0,'Close']
        ]
      ]
    self.palette[0]:=palette0; self.palette[1]:=palette1; self.palette[2]:=palette2
    self.palette[3]:=palette3; self.palette[4]:=palette4; self.palette[5]:=palette5
  ENDIF
ENDPROC self.gui

PROC disable(bool) OF gtpalettes
  DEF i
  FOR i:=0 TO 5 DO setdisabled(self.gh,self.palette[i],bool)
ENDPROC

PROC set(bool) OF gtpalettes
  DEF new,i
  new:=IF bool THEN 3 ELSE 2
  FOR i:=0 TO 5
    self.palettev[i]:=new
    setpalette(self.gh,self.palette[i],new)
  ENDFOR
ENDPROC

PROC get() OF gtpalettes
  DEF i
  WriteF('---All values:\n')
  FOR i:=0 TO 5 DO WriteF('palette\d: \d\n',i,self.palettev[i])
  WriteF('---\n')
ENDPROC

-> palette(qual*,data*,info,colour)
PROC gtpalettes_plv(num,gui:PTR TO gtpalettes,val) IS setdisp('palette',gui.palettev,num,val)


/********************************************************************
 * Spaces window
 ********************************************************************/

PROC init() OF egspaces
  self.title:='Spaces in EasyGUI_OS12'
ENDPROC

PROC getgui(top) OF egspaces
  IF self.gui=NIL
    self.gui:=
      NEW [ROWS,
        top,
        NEW [TEXT,'xy resizable spaces using SPACE:',NIL,FALSE,5],
        NEW [COLS,

              NEW [BEVEL,
                NEW [SPACE]
              ],
              NEW [BEVEL,
                NEW [SPACE]
              ],
              NEW [BEVEL,
                NEW [SPACE]
              ],

          NEW [ROWS,

              NEW [BEVEL,
                NEW [SPACE]
              ],
              NEW [BEVEL,
                NEW [SPACE]
              ],
              NEW [BEVEL,
                NEW [SPACE]
              ]

          ]
        ],
        NEW [TEXT,'x resizable spaces using SPACEH:',NIL,FALSE,5],
        NEW [COLS,

              NEW [BEVEL,
                NEW [SPACEH]
              ],
              NEW [BEVEL,
                NEW [SPACEH]
              ],
              NEW [BEVEL,
                NEW [SPACEH]
              ],

          NEW [ROWS,

              NEW [BEVEL,
                NEW [SPACEH]
              ],
              NEW [BEVEL,
                NEW [SPACEH]
              ],
              NEW [BEVEL,
                NEW [SPACEH]
              ]

          ]
        ],
        NEW [TEXT,'y resizable spaces using SPACEV:',NIL,FALSE,5],
        NEW [COLS,

              NEW [BEVEL,
                NEW [SPACEV]
              ],
              NEW [BEVEL,
                NEW [SPACEV]
              ],
              NEW [BEVEL,
                NEW [SPACEV]
              ],

          NEW [ROWS,

              NEW [BEVEL,
                NEW [SPACEV]
              ],
              NEW [BEVEL,
                NEW [SPACEV]
              ],
              NEW [BEVEL,
                NEW [SPACEV]
              ]

          ]
        ]
      ]
  ENDIF
ENDPROC self.gui


/********************************************************************
 * Bars + Bevels window
 ********************************************************************/

PROC init() OF egbevels
  self.title:='Bars + Bevels in EasyGUI_OS12'
ENDPROC

PROC getgui(top) OF egbevels
  DEF g
  IF self.gui=NIL
    self.gui:=
      NEW [ROWS,
        top,
        NEW [TEXT,'normal bevels using BEVEL:',NIL,FALSE,5],
        NEW [COLS,

              NEW [BEVEL,
                NEW [SPACE]
              ],
              NEW [BEVEL,
                NEW [SPACE]
              ],
              NEW [BEVEL,
                NEW [SPACE]
              ],

          NEW [ROWS,

              NEW [BEVEL,
                NEW [SPACE]
              ],
              NEW [BEVEL,
                NEW [SPACE]
              ],
              NEW [BEVEL,
                NEW [SPACE]
              ]

          ]
        ],
        NEW [TEXT,'recessed bevels using BEVELR:',NIL,FALSE,5],
        NEW [COLS,

              NEW [BEVELR,
                NEW [SPACE]
              ],
              NEW [BEVELR,
                NEW [SPACE]
              ],
              NEW [BEVELR,
                NEW [SPACE]
              ],

          NEW [ROWS,

              NEW [BEVELR,
                NEW [SPACE]
              ],
              NEW [BEVELR,
                NEW [SPACE]
              ],
              NEW [BEVELR,
                NEW [SPACE]
              ]

          ]
        ],
        NEW [TEXT,'bars:',NIL,FALSE,5],
        NEW [BAR],
        NEW [BAR],
        NEW [BAR]
      ]
  ENDIF
ENDPROC self.gui


/********************************************************************
 * Menus window
 ********************************************************************/

PROC init() OF gtmenus
  self.title:='Gadtools Menus in EasyGUI_OS12'
  self.menus1:=[NM_TITLE,0,'Menus 1', NIL,0,0,0,
                NM_ITEM,0,'Menus 0',  NIL,0,0,{gtmenus_menus0},
                NM_ITEM,0,'Menus 2',  NIL,0,0,{gtmenus_menus2},
                NM_END,  0,NIL,       NIL,0,0,0]:newmenu
  self.menus2:=[NM_TITLE,0,'Menus 2', NIL,0,0,0,
                NM_ITEM,0,'Menus 0',  NIL,0,0,{gtmenus_menus0},
                NM_ITEM,0,'Menus 1',  NIL,0,0,{gtmenus_menus1},
                NM_END,  0,NIL,       NIL,0,0,0]:newmenu
  self.menusnum:=0
ENDPROC

PROC getgui(top) OF gtmenus
  DEF menumx
  IF self.gui=NIL
    self.gui:=
      NEW [ROWS,
        top,
        NEW [TEXT,'Menus 0 are shared across all windows!',NIL,FALSE,5],
        NEW [BAR],
          NEW [BEVEL,
          NEW [ROWS,
            NEW [TEXT,'Choose Menus for this window:',NIL,FALSE,5],
            NEW [BEVEL,
              menumx:=NEW [MX,{gtmenus_change},NIL,['Menus 0','Menus 1','Menus 2',NIL],FALSE,self.menusnum,TRUE]
            ]
          ]
        ],
        NEW [BAR],
        NEW [SBUTTON,0,'Close']
      ]
    self.menumx:=menumx
  ENDIF
ENDPROC self.gui

-> menu(qual*=NIL,data*=NIL,info)
PROC gtmenus_menus0(gui:PTR TO gtmenus) IS gui.change_menus(FALSE,0)
PROC gtmenus_menus1(gui:PTR TO gtmenus) IS gui.change_menus(FALSE,1)
PROC gtmenus_menus2(gui:PTR TO gtmenus) IS gui.change_menus(FALSE,2)

-> mx(qual*,data*,info,num_selected)
PROC gtmenus_change(gui:PTR TO gtmenus,num) IS gui.change_menus(TRUE,num)

PROC change_menus(frommx,num) OF gtmenus
  DEF new
  self.menusnum:=num
  new:=ListItem([global.menus,self.menus1,self.menus2],num)
  -> the following line crashes/raises "gui":
  ->multiforall({x},global.mh,`changemenus(x,new))
  -> so for now just change menus of this window:
  changemenus(self.gh,new)
  IF frommx=FALSE THEN setmx(self.gh,self.menumx,num)
ENDPROC


/********************************************************************
 * Window Manipulation window
 ********************************************************************/

PROC init() OF egchwin
  self.title:='Window Manipulation in EasyGUI_OS12'
  self.screennum:=0
  self.wintypenum:=3
  self.fontnum:=0
ENDPROC

PROC getgui(top) OF egchwin
  DEF screenmx,winmx,fontmx,titlemx
  IF self.gui=NIL
    self.gui:=
      NEW [ROWS,
        top,
        NEW [TEXT,'Can also be called from the menus:',NIL,FALSE,5],
        NEW [BAR],
        NEW [COLS,
          NEW [BEVEL,
            NEW [ROWS,
              NEW [TEXT,'Screen:',NIL,FALSE,5],
              NEW [BEVEL,
                screenmx:=NEW [MX,{egchwin_changescreen},NIL,['Default','Custom',NIL],FALSE,self.screennum]
              ]
            ]
          ],
          NEW [BEVEL,
            NEW [ROWS,
              NEW [TEXT,'Decoration:',NIL,FALSE,5],
              NEW [BEVEL,
                winmx:=NEW [MX,{egchwin_changewintype},NIL,['No Border','Basic','No Size','Size',NIL],FALSE,self.wintypenum]
              ]
            ]
          ],
          NEW [BEVEL,
            NEW [ROWS,
              NEW [TEXT,'Font:',NIL,FALSE,5],
              NEW [BEVEL,
                fontmx:=NEW [MX,{egchwin_changefont},NIL,['Screen','Topaz 8','Topaz 10',NIL],FALSE,self.fontnum]
              ]
            ]
          ],
          NEW [BEVEL,
            NEW [ROWS,
              NEW [TEXT,'Title:',NIL,FALSE,5],
              NEW [BEVEL,
                titlemx:=NEW [MX,{egchwin_changetitle},NIL,['Info','Nonsens',NIL],FALSE,self.titlenum]
              ]
            ]
          ]
        ],
        NEW [BAR],
        NEW [EQCOLS,
            NEW [SBUTTON,{egchwin_moveall},'Move All'],
            NEW [SBUTTON,{egchwin_sizeall},'Size All'],
            NEW [SBUTTON,{egchwin_blockall},'Block All'],
            NEW [SBUTTON,{egchwin_openall},'Open All'],
            NEW [SBUTTON,{egchwin_closeall},'Close All']
        ]
      ]
    self.screenmx:=screenmx; self.winmx:=winmx; self.fontmx:=fontmx; self.titlemx:=titlemx
  ENDIF
ENDPROC self.gui

-> menu(qual*=NIL,data*=NIL,info)
PROC global_defaultscreen(i) IS global.egchwin.change_screen(FALSE,0)
PROC global_customscreen(i) IS global.egchwin.change_screen(FALSE,1)

-> mx(qual*,data*,info,num_selected)
PROC egchwin_changescreen(gui:PTR TO egchwin,num) IS gui.change_screen(TRUE,num)

PROC change_screen(frommx,num) OF egchwin HANDLE
  multiforall({x},global.mh,`closewin(x))
  self.screennum:=num
  IF num
    IF global.screen=NIL THEN global.screen:=OpenS(640,400,4,V_HIRES OR V_LACE,'Custom Screen')
  ELSE
    IF global.screen
      CloseS(global.screen)
      global.screen:=NIL
    ENDIF
  ENDIF
  multiforall({x},global.mh,`changescreen(x,global.screen))
EXCEPT DO
  multiforall({x},global.mh,`openwin(x))
  IF frommx THEN tofront(self.gh) ELSE setmx(self.gh,self.screenmx,num)
  ReThrow()
ENDPROC

-> menu(qual*=NIL,data*=NIL,info)
PROC global_noborderwin(i) IS global.egchwin.change_wintype(FALSE,0)
PROC global_basicwin(i) IS global.egchwin.change_wintype(FALSE,1)
PROC global_nosizewin(i) IS global.egchwin.change_wintype(FALSE,2)
PROC global_sizewin(i) IS global.egchwin.change_wintype(FALSE,3)

-> mx(qual*,data*,info,num_selected)
PROC egchwin_changewintype(gui:PTR TO egchwin,num) IS gui.change_wintype(TRUE,num)

PROC change_wintype(frommx,num) OF egchwin HANDLE
  multiforall({x},global.mh,`closewin(x))
  self.wintypenum:=num
  global.wintype:=ListItem([WTYPE_NOBORDER,WTYPE_BASIC,WTYPE_NOSIZE,WTYPE_SIZE],num)
  multiforall({x},global.mh,`changewintype(x,global.wintype))
EXCEPT DO
  multiforall({x},global.mh,`openwin(x))
  IF frommx THEN tofront(self.gh) ELSE setmx(self.gh,self.winmx,num)
  ReThrow()
ENDPROC

-> menu(qual*=NIL,data*=NIL,info)
PROC global_screenfont(i) IS global.egchwin.change_font(FALSE,0)
PROC global_topaz8font(i) IS global.egchwin.change_font(FALSE,1)
PROC global_topaz10font(i) IS global.egchwin.change_font(FALSE,2)

-> mx(qual*,data*,info,num_selected)
PROC egchwin_changefont(gui:PTR TO egchwin,num) IS gui.change_font(TRUE,num)

PROC change_font(frommx,num) OF egchwin HANDLE
  multiforall({x},global.mh,`closewin(x))
  self.fontnum:=num
  global.font:=ListItem([NIL,['topaz.font',8,0,0]:textattr,['topaz.font',10,0,0]:textattr],num)
  multiforall({x},global.mh,`changefont(x,global.font))
EXCEPT DO
  multiforall({x},global.mh,`openwin(x))
  IF frommx THEN tofront(self.gh) ELSE setmx(self.gh,self.fontmx,num)
  ReThrow()
ENDPROC

-> menu(qual*=NIL,data*=NIL,info)
PROC global_infotitle(i) IS global.egchwin.change_title(0)
PROC global_nonsensetitle(i) IS global.egchwin.change_title(1)

-> mx(qual*,data*,info,num_selected)
PROC egchwin_changetitle(gui:PTR TO egchwin,num) IS gui.change_title(num)

PROC change_title(num) OF egchwin
  self.titlenum:=num
  global.title:=IF num THEN 'Nonsense' ELSE NIL
  multiforall({x},global.mh,`changetitle(x,IF global.title THEN global.title ELSE x.info::gui.title))
ENDPROC


-> menu(qual*=NIL,data*=NIL,info)
PROC global_moveall(i) IS global.egchwin.move_all()

-> button(qual*,data*,info)
PROC egchwin_moveall(gui:PTR TO egchwin) IS gui.move_all()

PROC move_all() OF egchwin
  multiforall({x},global.mh,`movewin(x,Rnd(400),Rnd(400)))
ENDPROC

-> menu(qual*=NIL,data*=NIL,info)
PROC global_sizeall(i) IS global.egchwin.size_all()

-> button(qual*,data*,info)
PROC egchwin_sizeall(gui:PTR TO egchwin) IS gui.size_all()

PROC size_all() OF egchwin
  multiforall({x},global.mh,`sizewin(x,x.wnd.minwidth+Rnd(100),x.wnd.minheight+Rnd(100)))
ENDPROC

-> menu(qual*=NIL,data*=NIL,info)
PROC global_openall(i) IS global.egchwin.open_all(FALSE)

-> button(qual*,data*,info)
PROC egchwin_openall(gui:PTR TO egchwin) IS gui.open_all(TRUE)

PROC open_all(frombutton) OF egchwin
  DEF gui:PTR TO gui
  ForAll({gui},[global.gtbuttons,global.gttexts,global.gtscrolls,global.gtlistvs,
                global.gtpalettes,global.egspaces,global.egbevels,global.gtmenus,
                global.egchwin],`gui.open())
  IF frombutton THEN tofront(self.gh)
ENDPROC

-> menu(qual*=NIL,data*=NIL,info)
PROC global_closeall(i) IS global.egchwin.close_all()

-> button(qual*,data*,info)
PROC egchwin_closeall(gui:PTR TO egchwin) IS gui.close_all()

PROC close_all() OF egchwin
  multiforall({x},global.mh,`IF x<>global.mainwin.gh THEN cleangui(x) ELSE EMPTY)
ENDPROC

-> menu(qual*=NIL,data*=NIL,info)
PROC global_blockall(i) IS global.egchwin.block_all()

-> button(qual*,data*,info)
PROC egchwin_blockall(gui:PTR TO egchwin) IS gui.block_all()

PROC block_all() OF egchwin
  multiforall({x},global.mh,`blockwin(x))
  easyguiA('Blocked',
    [ROWS,
      [TEXT,'All GUIs blocked',NIL,FALSE,1],
      [BUTTON,NIL,'Unblock GUIs',TRUE]
    ],
    [ EG_SCRN,   global.screen,
      EG_FONT,   global.font,
      TAG_DONE
    ]
  )
  multiforall({x},global.mh,`unblockwin(x))
ENDPROC

/********************************************************************
 * GUI Manipulation window
 ********************************************************************/

/* this is the most tricky section of all. global2 is a second instance
  of all window objects, which are not accessed by the open() method,
  just we take the gui by getgui() and place it into our window.
  To make all action functions work on the right instance of the gui
  the info must be changed on each gui change to point at the right
  gui. Because of that we must NOT use the gui pointer passed through
  the info value to refer to the cycle's action-method, but the global
  pointer to ourself. Same applies to the gui clean action-funtion.
  That's why this window can not be run in a second instance. */

PROC init() OF egchgui
  self.title:='GUI Manipulation in EasyGUI_OS12'
  self.guilist:=[ global2.gtbuttons,global2.gttexts,global2.gtscrolls,global2.gtlistvs,
                  global2.gtpalettes,global2.egspaces,global2.egbevels,global2.gtmenus,
                  global2.egchwin ]
  self.guilabels:=['Buttons','Texts','Sliders + Scrollers','Listviews',
                   'Palettes','Spaces','Bars + Bevels','Menus',
                   'Window Manipulation',NIL]
ENDPROC

PROC getgui(top) OF egchgui
  self.gui:=global2.gtbuttons.getgui(self.topgui(0))
ENDPROC self.gui

PROC topgui(num) OF egchgui
  DEF tg
  tg:=[CYCLE,{egchgui_change},'Change _GUI',self.guilabels,num,NIL,"g"]
ENDPROC tg

PROC open(close=NIL,clean=NIL) OF egchgui
  SUPER self.open(close,{gui_clean2})
  ForAll({g},self.guilist,`g.setgh(self.gh))
  changeinfo(self.gh,global2.gtbuttons)
ENDPROC

-> clean(info)
PROC gui_clean2(i) IS global.egchgui.clean() -> ignore the GUI pointer passed!!!

-> cycle(qual*,data*,info,num_selected)
PROC egchgui_change(i,num) IS global.egchgui.change_gui(num) -> ignore the GUI pointer passed!!!

PROC change_gui(num) OF egchgui
  DEF gui:PTR TO gui
  gui:=ListItem(self.guilist,num)
  changegui(self.gh,gui.getgui(self.topgui(num)))
  changeinfo(self.gh,gui)
ENDPROC

/********************************************************************
 * Main window
 ********************************************************************/

PROC init() OF mainwin
  self.title:='EasyGUI_OS12 Tests'
ENDPROC

PROC getgui(top) OF mainwin
  IF self.gui=NIL
    self.gui:=
      NEW [ROWS,
        NEW [BEVEL,
          NEW [EQROWS,
            NEW [SBUTTON,{global_gtbuttons},'Buttons'],
            NEW [SBUTTON,{global_gttexts},'Texts'],
            NEW [SBUTTON,{global_gtscrolls},'Sliders + Scrollers'],
            NEW [SBUTTON,{global_gtlistvs},'Listviews'],
            NEW [SBUTTON,{global_gtpalettes},'Palettes'],
            NEW [SBUTTON,{global_egspaces},'Spaces'],
            NEW [SBUTTON,{global_egbevels},'Bars + Bevels'],
            NEW [SBUTTON,{global_gtmenus},'Menus'],
            NEW [SBUTTON,{global_egchwin},'Window Manipulation'],
            NEW [SBUTTON,{global_egchgui},'GUI Manipulation']
          ]
        ]
      ]
  ENDIF
ENDPROC self.gui

/********************************************************************
 * Global stuff
 ********************************************************************/

PROC init() OF global
  NEW self.mainwin.init(),self.gtbuttons.init(), self.gttexts.init(), self.gtscrolls.init(),
      self.gtlistvs.init(),self.gtpalettes.init(),self.egspaces.init(),self.egbevels.init(),
      self.gtmenus.init(),self.egchwin.init(),self.egchgui.init()
ENDPROC

PROC end() OF global
  END self.mainwin,self.gtbuttons,self.gttexts,self.gtscrolls,
      self.gtlistvs,self.gtpalettes,self.egspaces,self.egbevels,
      self.gtmenus,self.egchwin,self.egchgui
ENDPROC

/*******
 ATTENTION! All funtions starting with global_ may be called from any GUI
 (or instance), so they must not use the gui object pointer passed through
 info!!!
 *******/

PROC main() HANDLE
  NEW global.init(),global2.init()

  global.mh:=multiinit()
  global.wintype:=WTYPE_SIZE
  global.menus:=[NM_TITLE,0,'Project',      NIL,0,0,0,
                  NM_ITEM,0,'Block All',    'L',0,0,{global_blockall},
                  NM_ITEM,0,NM_BARLABEL,    NIL,0,0,0,
                  NM_ITEM,0,'Open All',     'O',0,0,{global_openall},
                  NM_ITEM,0,'Close All',    'C',0,0,{global_closeall},
                  NM_ITEM,0,NM_BARLABEL,    NIL,0,0,0,
                  NM_ITEM,0,'Move All',     'M',0,0,{global_moveall},
                  NM_ITEM,0,'Size All',     'M',0,0,{global_sizeall},
                  NM_ITEM,0,NM_BARLABEL,    NIL,0,0,0,
                  NM_ITEM,0,'Quit',         'Q',0,0,{global_quit},
                 NM_TITLE,0,'Windows',      NIL,0,0,0,
                  NM_ITEM,0,'Buttons',      '0',0,0,{global_gtbuttons},
                  NM_ITEM,0,'Texts',        '1',0,0,{global_gttexts},
                  NM_ITEM,0,'Sliders',      '2',0,0,{global_gtscrolls},
                  NM_ITEM,0,'Scrollers',    '2',0,0,{global_gtscrolls},
                  NM_ITEM,0,'Listviews',    '3',0,0,{global_gtlistvs},
                  NM_ITEM,0,'Palettes',     '4',0,0,{global_gtpalettes},
                  NM_ITEM,0,'Spaces',       '5',0,0,{global_egspaces},
                  NM_ITEM,0,'Bars',         '6',0,0,{global_egbevels},
                  NM_ITEM,0,'Bevels',       '6',0,0,{global_egbevels},
                  NM_ITEM,0,'Menus',        '7',0,0,{global_gtmenus},
                  NM_ITEM,0,'ChangeWin',    '8',0,0,{global_egchwin},
                  NM_ITEM,0,'ChangeGUI',    '9',0,0,{global_egchgui},
                 NM_TITLE,0,'Screen',       NIL,0,0,0,
                  NM_ITEM,0,'Default',      'D',0,0,{global_defaultscreen},
                  NM_ITEM,0,'Custom',       'C',0,0,{global_customscreen},
                 NM_TITLE,0,'Decoration',   NIL,0,0,0,
                  NM_ITEM,0,'No Border',    'N',0,0,{global_noborderwin},
                  NM_ITEM,0,'Basic',        'B',0,0,{global_basicwin},
                  NM_ITEM,0,'No Size',      'O',0,0,{global_nosizewin},
                  NM_ITEM,0,'Size',         'S',0,0,{global_sizewin},
                 NM_TITLE,0,'Font',         NIL,0,0,0,
                  NM_ITEM,0,'Screen',       'R',0,0,{global_screenfont},
                  NM_ITEM,0,'Topaz 8',      '8',0,0,{global_topaz8font},
                  NM_ITEM,0,'Topaz 10',     '1',0,0,{global_topaz10font},
                 NM_TITLE,0,'Title',         NIL,0,0,0,
                  NM_ITEM,0,'Info',         'I',0,0,{global_infotitle},
                  NM_ITEM,0,'Nonsense',     'N',0,0,{global_nonsensetitle},
                 NM_END,  0,NIL,            NIL,0,0,0]:newmenu

  global.mainwin.open({global_quit})

  REPEAT
    multiloop(global.mh)
  UNTIL global.mh.opencount=0
EXCEPT DO
  IF global.screen
    CloseS(global.screen)
    global.screen:=NIL
  ENDIF
  cleanmulti(global.mh)
  report_exception()
  END global,global2
ENDPROC

-> button(qual*,data*,info)
-> menu(qual*=NIL,data*=NIL,info)
PROC global_gtbuttons(i) IS global.gtbuttons.open()
PROC global_gttexts(i) IS global.gttexts.open()
PROC global_gtscrolls(i) IS global.gtscrolls.open()
PROC global_gtlistvs(i) IS global.gtlistvs.open()
PROC global_gtpalettes(i) IS global.gtpalettes.open()
PROC global_egspaces(i) IS global.egspaces.open()
PROC global_egbevels(i) IS global.egbevels.open()
PROC global_gtmenus(i) IS global.gtmenus.open()
PROC global_egchwin(i) IS global.egchwin.open()
PROC global_egchgui(i) IS global.egchgui.open()

-> close(mh*,info)
-> button(qual*,data*,info)
-> menu(qual*=NIL,data*=NIL,info)
PROC global_quit(i)
  multiforall({x},global.mh,`cleangui(x))
ENDPROC

-> appwin(data*,info,awmsg:PTR TO appmessage)
PROC global_awp(i,a) IS WriteF('Dropped in window\n')

/********************************************************************
 * Misc support stuff
 ********************************************************************/

PROC makeexeclist(nodes) -> derived from the dclisview plugin demo code by Ali Graham
  DEF list
  list:=newlist()
  ForAll({x}, nodes, `AddTail(list, newnode(NIL, x)))
ENDPROC list

PROC tofront(gh:PTR TO guihandle)
  IF gh
    WindowToFront(gh.wnd)
    ActivateWindow(gh.wnd)
  ENDIF
ENDPROC

PROC setdisp(name,array:PTR TO LONG,num,val)
  WriteF('\s\d=\d\n',name,num,val)
  array[num]:=val
ENDPROC

PROC dispstr(name,num,str) IS WriteF('\s\d=\s\n',name,num,str)

