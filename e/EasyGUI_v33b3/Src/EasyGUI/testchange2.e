-> testchange2.e - shows use of some changeXXX() functions
MODULE 'tools/exceptions',
       'exec/lists', 'exec/nodes',
       'graphics/text', 'graphics/view',
       'libraries/gadtools',
       'amigalib/lists',
       'tools/easygui'

RAISE "SCRN" IF OpenS()=NIL

-> Index of the sub-GUI in the main GUI list.
CONST SUB_POS=3

-> The custom screen.
DEF scr=NIL

-> The main GUI, the list of sub-GUIs, the titles and the menus.
DEF gui:PTR TO LONG, subguis:PTR TO LONG, titles:PTR TO LONG, menus

-> The connected window, the main window, a gh for multiforall() and a tmp.
DEF ghconn=NIL, ghmain, forall, tmp

-> The slider in the connected and main windows, and the check in main.
DEF connsl=NIL, mainsl=NIL:PTR TO LONG, mainchk=NIL

PROC main() HANDLE
  DEF mh=NIL
  -> The list of GUIs we'll use (and change) as sub-GUIs in the main GUI.
  subguis:=[
             [COLS,
               [TEXT,'Try the menus!',NIL,TRUE,1],
               [SLIDE,{ignore},'Colors:',FALSE,1,8,3,5,'']
             ],
             [COLS,
               [SLIDE,{ignore},'Colors:',FALSE,1,8,3,5,''],
               [CHECK,{ignore},'Ignore case',TRUE,FALSE]
             ],
             [COLS,
               [CHECK,{ignore},'Ignore case',TRUE,TRUE],
               [PALETTE,{ignore},'Palette:',3,5,2,0]
             ]
           ]
  -> The main GUI.
  gui:=[ROWS,
         [COLS,
           [SPACEH],
            -> Use generic action function, with BUTTON data 0, 1 or 2.
           [BUTTON,{change_gui},'GUI _X',0,"x"],
           [SPACEH],
           [BUTTON,{change_gui},'GUI _Y',1,"y"],
           [SPACEH],
           [BUTTON,{change_gui},'GUI _Z',2,"z"],
           [SPACEH]
         ],
         [SPACE],
         0, -> The sub-GUI, initialise this below...
         [SPACE],
         [COLS,
           [SBUTTON,{block_all},'_Block All',0,"b"],
           [SBUTTON,{close_all},'_Close All',0,"c"]
         ],
         [BAR],
         mainchk:=[CHECK,{connected_win},'Create/Destroy Connected Window',
                   FALSE,FALSE],
         mainsl:=[SLIDE,{main_sl_fun},'Connected:    ',FALSE,1,20,3,5,'\d[2]']
       ]
  -> Initially, use the first sub-GUI.
  gui[SUB_POS]:=subguis[]
  titles:=['GUI X','GUI Y','GUI Z']
  -> We're going to share the menus between our two windows.
  menus:=[NM_TITLE,0,'Project',      NIL,0,0,0,
           NM_ITEM,0,'Quit',         'Q',0,0,0,
          NM_TITLE,0,'Screen',       NIL,0,0,0,
           NM_ITEM,0,'Default',      'D',0,0,{default},
           NM_ITEM,0,'Custom',       'C',0,0,{custom},
          NM_TITLE,0,'Window Type',  NIL,0,0,0,
           NM_ITEM,0,'No Border',    'N',0,0,{noborder},
           NM_ITEM,0,'Basic',        'B',0,0,{basic},
           NM_ITEM,0,'No Size',      'O',0,0,{nosize},
           NM_ITEM,0,'Size',         'S',0,0,{size},
          NM_TITLE,0,'GUI',          NIL,0,0,0,
           NM_ITEM,0,'X',            'X',0,0,{x},
           NM_ITEM,0,'Y',            'Y',0,0,{y},
           NM_ITEM,0,'Z',            'Z',0,0,{z},
          NM_TITLE,0,'Font',         NIL,0,0,0,
           NM_ITEM,0,'Screen',       'F',0,0,{font},
           NM_ITEM,0,'Topaz',        'T',0,0,{topaz},
          NM_END,  0,NIL,            NIL,0,0,0]:newmenu
  -> Start a multi-window group.
  mh:=multiinit()
  -> Open the main GUI.
  ghmain:=addmultiA(mh, 'Check out the menus...', gui,
                   [EG_MENU,menus, EG_CLOSE,{closemain}, NIL])
  -> Process messages.
  multiloop(mh)
EXCEPT DO
  cleanmulti(mh)
  -> If we opened the screen, close it.
  IF scr THEN CloseS(scr)
  report_exception()
ENDPROC


->>> Main GUI/shared action functions <<<-

-> Close all windows, prompt then reopen.
PROC close_all(gh) HANDLE
  allclose(gh)
  easyguiA('New GUI',
          [ROWS,
             [TEXT,'Old GUIs closed',NIL,TRUE,15],
             [TEXT,'Close me to reopen!',NIL,TRUE,15]
          ])
EXCEPT DO
  allopen(gh)
  ReThrow()
ENDPROC

-> Block all windows, prompt then unblock.
PROC block_all(gh:PTR TO guihandle) HANDLE
  multiforall({forall},gh.mh,`blockwin(forall))
  easyguiA('New GUI',
          [ROWS,
             [TEXT,'Old GUIs blocked',NIL,TRUE,15],
             [TEXT,'Close me to unblock!',NIL,TRUE,15]
          ])
EXCEPT DO
  multiforall({forall},gh.mh,`unblockwin(forall))
  ReThrow()
ENDPROC

-> Change the font to default (screen) or Topaz.
PROC font(info) IS change_font(info,NIL)
PROC topaz(info) IS change_font(info,['topaz.font',8,0,0]:textattr)

-> Change to the default public screen.
PROC default(gh:PTR TO guihandle) HANDLE
  allclose(gh)
  IF scr
    CloseS(scr)
    -> The screen is now invalid.
    scr:=NIL
  ENDIF
  multiforall({forall},gh.mh,`changescreen(forall,NIL))
EXCEPT DO
  allopen(gh)
  ReThrow()
ENDPROC

-> Change to a custom screen.
PROC custom(gh:PTR TO guihandle) HANDLE
  allclose(gh)
  IF scr=NIL THEN scr:=OpenS(640,400,4,V_HIRES OR V_LACE,'Custom Screen')
  tmp:=scr
  multiforall({forall},gh.mh,`changescreen(forall,tmp))
EXCEPT DO
  allopen(gh)
  ReThrow()
ENDPROC

-> Change the window type.
PROC noborder(info) IS change_type(info,WTYPE_NOBORDER)
PROC basic(info) IS change_type(info,WTYPE_BASIC)
PROC nosize(info) IS change_type(info,WTYPE_NOSIZE)
PROC size(info) IS change_type(info,WTYPE_SIZE)

-> Change the main GUI.
PROC x(info) IS change_gui(0,ghmain)
PROC y(info) IS change_gui(1,ghmain)
PROC z(info) IS change_gui(2,ghmain)

PROC change_gui(index,gh)
  changetitle(gh,titles[index])
  gui[SUB_POS]:=subguis[index]
  changegui(gh,gui)
ENDPROC

PROC ignore(info,x) IS EMPTY


->>> Connection code <<<-

-> Connected slider on main GUI.
PROC main_sl_fun(info,cur)
  IF ghconn THEN setslide(ghconn,connsl,cur)
ENDPROC

-> Connected slider on the other GUI.
PROC conn_sl_fun(info,cur)
  IF ghmain THEN setslide(ghmain,mainsl,cur)
ENDPROC


->>> Closing code <<<-

-> Closing the main GUI quits.
PROC closemain(mh,gh) IS quitgui(0)

-> Closing the other GUI destroys it.
PROC closeconn(mh,info)
  cleangui(ghconn)
  -> The guihandle is now invalid.
  ghconn:=NIL
  -> Uncheck the check in the main GUI.
  IF mainchk THEN setcheck(ghmain,mainchk,FALSE)
ENDPROC


->>> Other GUI functions <<<-

-> React to check changes on main GUI.
PROC connected_win(gh:PTR TO guihandle,bool)
  IF bool
    -> If it's been created reopen it, else create and add it to the group.
    IF ghconn
      openwin(ghconn)
    ELSE
      ghconn:=addmultiA(gh.mh, 'Connected Window',
             [ROWS,
               connsl:=[SLIDE,{conn_sl_fun},'Connected:    ',FALSE,1,20,
                        IF mainsl THEN mainsl[SLI_CURR] ELSE 3,10,'\d[2]'],
               [COLS,
                 [SBUTTON,{block_all},'_Block All',0,"b"],
                 [SBUTTON,{close_all},'_Close All',0,"c"]
               ],
               [SBUTTON,{clean_gui},'cl_eangui()',0,"e"]
             ],
             [EG_TOP,0, EG_LEFT,0, EG_MENU,menus,
              EG_SCRN,scr, EG_CLOSE,{closeconn}, NIL])
    ENDIF
  ELSEIF ghconn
    -> If it's been created, destroy it.
    cleangui(ghconn)
    -> The guihandle is now invalid.
    ghconn:=NIL
  ENDIF
ENDPROC

-> Action function for cleangui() button (reuse closeconn()).
PROC clean_gui(info) IS closeconn(0,0)


->>> Auxiliary functions <<<-

-> Close all GUIs (and update check on main GUI)
PROC allclose(gh:PTR TO guihandle)
  multiforall({forall},gh.mh,`closewin(forall))
  -> Make check false only if the other window exists
  IF ghconn THEN setcheck(ghmain,mainchk,FALSE)
ENDPROC

-> Open all GUIs (and update check on main GUI)
PROC allopen(gh:PTR TO guihandle)
  multiforall({forall},gh.mh,`openwin(forall))
  -> Make check true only if the other window exists
  IF ghconn THEN setcheck(ghmain,mainchk,TRUE)
ENDPROC

-> Change the window type.
PROC change_type(gh:PTR TO guihandle,t) HANDLE
  allclose(gh)
  tmp:=t
  multiforall({forall},gh.mh,`changewintype(forall,tmp))
EXCEPT DO
  allopen(gh)
  ReThrow()
ENDPROC

-> Change the window font.
PROC change_font(gh:PTR TO guihandle,tattr) HANDLE
  allclose(gh)
  tmp:=tattr
  multiforall({forall},gh.mh,`changefont(forall,tmp))
EXCEPT DO
  allopen(gh)
  ReThrow()
ENDPROC
