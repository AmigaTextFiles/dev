/*
 *  Little Example for some of NewGUI`s Features...
 *
 *
 *
 */

OPT     LARGE
OPT     OSVERSION = 37
OPT     PREPROCESS

#define IFF_INTERN      = 1                     -> Don`t use them together! This will never ever run,
->#define USE_OWNTASK     = 1                     -> because the IFF-Loader needs to Open() the Prefs with a DOS
                                                -> Call (Open()) and this isn`t allowed in a seperate Task!!!

MODULE  'graphics/gfxmacros'
MODULE  'graphics/rastport'
MODULE  'intuition/intuition'
MODULE  'libraries/gadtools'
MODULE  'newgui/pl_scrolltext'
MODULE  'newgui/pl_gauge'
MODULE  'newgui/newgui'
MODULE  'newgui/ng_showerror'
MODULE  'utility/tagitem'

#ifdef USE_OWNTASK
 MODULE 'newgui/ng_guitask'
#endif

#ifdef IFF_INTERN
 MODULE 'newgui/ng_prefshook_intern'
#endif
#ifndef IFF_INTERN
 MODULE 'newgui/ng_prefshook_extern'            -> This Module is actually buggy  (?! Don`t know why??)
#endif

ENUM    GUI_MAIN = 1,
        GUI_FIRST,
        GUI_FONT,
        GUI_SCREENMODE,
        GUI_MULTI,
        GUI_GAUGE,
        GUI_ABOUT

#ifdef USE_OWNTASK
 DEF    info:PTR TO guitaskinfo                 -> Guitaskinfo
#endif

DEF     gui:PTR TO guihandle,                   -> guihandle
        screen=NIL,
        menu=0,                                 -> GadTools-Menu
        tickon=FALSE,                           -> Do we want to be reported on Intuiticks?
        tick=TRUE,                              -> Bool for the Ticking-Procedure!
        main_gui=TRUE,
        scroll:PTR TO scrolltext,
        gauge:PTR TO gauge,
        iffhandle=NIL

PROC main()     HANDLE
 makemenus()                                    -> Generate then menu
  opengui()                                     -> Open the GUI

#ifdef USE_OWNTASK
   dootherthings()
#endif
EXCEPT DO
#ifdef USE_OWNTASK
  closegui()
#endif
    IF gauge THEN END gauge                     -> End the gauge
   IF scroll THEN END scroll                    -> End the scroll-plugin
  IF exception THEN ng_showerror(exception)     -> Error-handling with external Modul-Code
 CleanUp(exception)                             -> EXIT with exception as return-code
ENDPROC

PROC makemenus()
 menu:=[
        NM_TITLE,       0,      'Project',      0,      0,0,0,
        NM_ITEM,        0,      'New ...',     'n',     0,0,{new},
        NM_ITEM,        0,      'Load ...',    'l',     NM_ITEMDISABLED,0,{test1},
        NM_ITEM,        0,      'Save ...',    's',     NM_ITEMDISABLED,0,{test1},
        NM_ITEM,        0,      NM_BARLABEL,    0,      0,0,0,
        NM_ITEM,        0,      'About ...',   'a',     0,0,{about},
        NM_ITEM,        0,      'Quit ...',    'q',     0,0,0,
        NM_TITLE,       0,      'Tools',        0,      0,0,0,
        NM_ITEM,        0,      'Block Main',  '1',     0,0,{block},
        NM_ITEM,        0,      'Main',        '2',     NG_NM_CHECK AND NG_NM_CHECKED,0,{hide},  -> !!! Have a look at this 2 new Constands (my GadTools-Modul is missing them!)
        NM_END,         0,      0,              0,      0,0,0]:newmenu
ENDPROC

PROC opengui()
 DEF    gui
  gui:=[NG_WINDOWTITLE, 'NewGUI - Demo',        -> Title from the Window
        NG_PREFSPROC,   {saveprefs},            -> Procedure to save (or show) the preferences for every Window
        NG_CLONESCREEN, TRUE,                   -> Open a screen (Clone it from WB, but prefer NG_SCR_xxx-Tags!)
        NG_SCR_TITLE,   'NewGUI - ALL',         -> The Title from our Screen
        NG_SCR_PUBNAME, 'NEWGUI',               -> The Public-Screen-Name
        NG_OPENPUBSCREEN,       TRUE,           -> If there already is an Pubscreen with that name, than use it!
        NG_REXXNAME,    'NEWGUI',               -> Name for the ARexx-Port
        NG_REXXPROC,    {rexxmsg},              -> Procedure to parse ARexx-Messages (Show AFC/Rexxer for details!)
        NG_FILLHOOK,    {fillrect},             -> Procedure to fill the windows-back and/or groups
        NG_MENU,        menu,                   -> The used menu-Bar
        NG_GUIID,       GUI_MAIN,               -> Gui-ID
        NG_GUI,                                 -> (Normally) GUI-Description
                        NG_DUMMY,               -> But NG_DUMMY says that we want only a BackDrop-Window!
        NG_NEXTGUI,                             -> PTR to the next Window-Description
-> Main-Window
       [NG_WINDOWTITLE, 'NewGUI - Demo',
        NG_FILLHOOK,    {fillrect},
        NG_USEMAINMENU, TRUE,
        NG_USEMAINSCREEN, TRUE,                 -> This Window should use the Screen from the first GUI (BACKDROP)
->        NG_USEMAINFONT, TRUE,                   -> The font from the Main-GUI (BACKDROP) should be used!
        NG_ONCLOSE,     {closeall},             -> This procedure is called if this window is closed
        NG_AUTOOPEN,    TRUE,                   -> Says that this window should be already open at the beginning
        NG_GUIID,       GUI_FIRST,              -> Gui-ID
        NG_GUI,                                 -> Gui-Description!

                [ROWS,
                [BEVEL,
                [FILLGROUP1,
                [ROWS,
                        [TEXT,'Main-Window','NewGUI-Example:',TRUE,3]
                ]]],
                [BEVELR,
                [FILLGROUP1,
                [ROWS,
                        [SBUTTON,{font},'Font ...'],
                        [SBUTTON,{screenmode},'Screenmode ...'],
                        [SBUTTON,{ticker},'Ticker on/off'],
                        [SBUTTON,{showgauge},'Gauge...'],
                        [SBUTTON,{about},'About ...']
                ]]],
                [BAR],
                [BEVELR,
                [FILLGROUP1,
                [EQCOLS,
                        [SBUTTON,{closechilds},'Close all Windows'],
                        [SBUTTON,{new},'New Fenster'],
                        [SBUTTON,{prefs},'Show Prefs'],
                        [SBUTTON,{block},'Block Main'],
                        [SBUTTON,{hide},'Hide Main']]]]],
        NG_NEXTGUI,     
-> FONT-Window
       [NG_WINDOWTITLE, 'Font-Demo',
        NG_FILLHOOK,    {fillrect},
        NG_USEMAINMENU, TRUE,
->        NG_USEMAINFONT, TRUE,
        NG_USEMAINSCREEN,TRUE,
        NG_GUIID,       GUI_FONT,
        NG_GUI,
                [EQROWS,
                        [TEXT,'Selected Fonts',NIL,FALSE,3],
                [BEVELR,
                [EQROWS,
                        [TEXT,'xentiny 8','Workbench Icon Text:',FALSE,3],
                        [TEXT,'end 10','System Default Text:',FALSE,3],
                        [TEXT,'except 12','Screen text:',FALSE,3]
                ]],
                        [SBUTTON,0,'Select Workbench Icon Text...'],
                        [SBUTTON,0,'Select System Default Text...'],
                        [SBUTTON,0,'Select Screen text...'],
                [BAR],
                [COLS,
                        [BUTTON,0,'Save'],
                [SPACEH],
                        [BUTTON,0,'Use'],
                [SPACEH],
                        [BUTTON,0,'Cancel']
                ]],
        NG_NEXTGUI,     
-> Screenmode-Window
       [NG_WINDOWTITLE, 'Screenmode-Demo',
        NG_USEMAINSCREEN,TRUE,
->        NG_USEMAINFONT, TRUE,
        NG_USEMAINMENU, TRUE,
        NG_FILLHOOK,    {fillrect},
        NG_GUIID,       GUI_SCREENMODE,
        NG_GUI,
                [EQROWS,
                [COLS,
                [EQROWS,
                        [LISTV,0,'Display Mode',10,4,NIL,TRUE,0,0],
                [COLS,
                [EQROWS,
                        [INTEGER,0,'Width:',640,5],
                        [INTEGER,0,'Height:',512,5]
                ],
                [ROWS,
                        [CHECK,0,'Default',TRUE,FALSE],
                        [CHECK,0,'Default',TRUE,FALSE]
                ]],
                        [SLIDE,0,'Colors:',FALSE,1,8,3,5,''],
                        [CHECK,0,'AutoScroll:',TRUE,TRUE]
                ],
                [BEVELR,
                [EQROWS,
                        [TEXT,'688x539','Visible Size:',FALSE,3],
                        [TEXT,'640x200','Minimum Size:',FALSE,3],
                        [TEXT,'16368x16384','Maximum Size:',FALSE,3],
                        [TEXT,'256','Maximum Colors:',FALSE,3],
                [SPACE]
                ]]],
                [BAR],
                [COLS,
                        [BUTTON,0,'Save'],
                [SPACEH],
                        [BUTTON,0,'Use'],
                [SPACEH],
                        [BUTTON,0,'Cancel']
                ]],
        NG_NEXTGUI,     
->
       [NG_WINDOWTITLE, 'NewGUI - Demo',
        NG_USEMAINSCREEN,TRUE,
->        NG_USEMAINFONT, TRUE,
        NG_USEMAINMENU, TRUE,
        NG_FILLHOOK,    {fillrect},
        NG_GUIID,       GUI_MULTI,
        NG_DOUBLEGUI,   TRUE,
        NG_GUI,
                [ROWS,
                [DBEVELR,
                [FILLGROUP1,
                [ROWS,
                        [TEXT,'Another Window!','NewGUI-Example:',TRUE,3]
                ]]],
                [BAR],
                [BEVELR,
                [FILLGROUP1,
                [EQCOLS,
                        [SBUTTON,{change},'Change'],
                        [SBUTTON,{block},'Block Main'],
                        [SBUTTON,{hide},'Hide Main']]]]],
        NG_NEXTGUI,     
->
       [NG_WINDOWTITLE, 'NewGUI - Demo',
        NG_USEMAINSCREEN,TRUE,
->        NG_USEMAINFONT, TRUE,
        NG_USEMAINMENU, TRUE,
        NG_FILLHOOK,    {fillrect},
        NG_GUIID,       GUI_GAUGE,
        NG_GUI,
                [ROWS,
                [BEVELR,
                [FILLGROUP1,
                [EQROWS,
                        [GAUGE,0,NEW gauge.gauge(3,2,1,GAUGE_HOR,50,TRUE)],
                        [SLIDE,{setgauge},'     ',FALSE,0,100,50,2,'%3ld']
                ]]],
                [BEVELR,
                [FILLGROUP1,
                [EQCOLS,
                [SPACEH],
                        [SBUTTON,{hide},'Hide Main'],
                [SPACEH]
                ]]]
                ],
        NG_NEXTGUI,     
->
       [NG_WINDOWTITLE, 'About NewGUI',
        NG_USEMAINSCREEN,TRUE,
        NG_USEMAINMENU, TRUE,
->        NG_FONT_NAME,   'Webhead.font',         -> Doesn`t actually work with ng_guitask() !!!
->        NG_FONT_SIZE,   21,                     -> I have to look why  it will hang the system !!
        NG_FILLHOOK,    {fillrect},
        NG_GUIID,       GUI_ABOUT,
        NG_GUI,
                [ROWS,
                [DBEVELR,
                [FILLGROUP2,
                [EQROWS,
                        [TEXT,'NewGUI','About',FALSE,3],
                        [TEXT,' ',' ',FALSE,3]
                ]]],
                [BEVELR,
                [FILLGROUP1,
                [EQROWS,
                        [SCROLLTEXT,0,NEW scroll.scrolltext([
        1,SCRTXT_BAR,' ',
        2,SCRTXT_CENTER,'NewGUI',
        1,SCRTXT_CENTER,'was developed by',
        2,SCRTXT_CENTER,'THE DARK FRONTIER Softwareentwicklungen',
        1,SCRTXT_CENTER,'(© 1994-98)',
        1,SCRTXT_BAR,' ',
        1,SCRTXT_LEFT,'Address:',
        1,SCRTXT_CENTER,'Am Hofgraben 2',
        1,SCRTXT_CENTER,'67378 Zeiskam',
        1,SCRTXT_LEFT,'FAX:++49(0)7274-8774',
        2,SCRTXT_LEFT,'Email: frontier@starbase.inka.de',
        2,SCRTXT_LEFT,'WWW  : under development...',
        1,SCRTXT_BAR,' ',
        0,NIL],2,100,2)]
                ]]],
                [BAR],
                [BEVELR,
                [FILLGROUP1,
                [EQCOLS,
                        [SBUTTON,0,'OK']]]]],
->
        NIL,NIL],
->
        NIL,NIL],
->
        NIL,NIL],
->
        NIL,NIL],
->
        NIL,NIL],
->
        NIL,NIL],
->
        NIL,NIL]

#ifndef USE_OWNTASK 
    newguiA(gui,{guiproc})
#endif

#ifdef USE_OWNTASK
  info:=ng_newtask(gui,NG_STACK_SIZE)
   Wait(info.sig)
    gui:=info.gui
     screen:=ng_getattrsA([
        NG_GUI,         gui,
        NG_GETSCREEN,   TRUE,
        NIL,            NIL])
#endif

ENDPROC

#ifndef USE_OWNTASK
PROC guiproc(gh,scr) IS screen:=scr,gui:=gh
#endif

#ifdef USE_OWNTASK
PROC dootherthings()
 DEF    a=0
  WHILE (ng_checkgui(info)=FALSE)
   Delay(1)
    WriteF('\d ',a)
   a++
  ENDWHILE
ENDPROC
#endif

#ifdef USE_OWNTASK
PROC closegui()
 ng_endtask(info)
ENDPROC
#endif

PROC fillrect(rp,x,y,width,height,type)
 DEF    oldbpen=0,
        oldapen=1
  SELECT        type
        CASE    NG_FILL_WINDOW                          -> Window-Filling (Back)
         oldbpen:=SetBPen(rp,0)                         -> Set Backpen to gray
          oldapen:=SetAPen(rp,3)                        -> Set Frontpen to blue
           SetAfPt(rp,[$AAAA,$5555]:INT,1)              -> Set Pattern (ATTENTION! Macro-Definition in gfxmacros.m, this need OPT PREPROCESS!!!)
            RectFill(rp,x,y,width,height)               -> Now fill the Region!
           SetBPen(rp,oldbpen)                          -> Set the Backpen to the old value
          SetAPen(rp,oldapen)                           -> Set the Frontpen to the old value
        CASE    FILLGROUP1                              -> Fill the Group 1
         oldbpen:=SetBPen(rp,0)                         -> Set BackPen to gray
          oldapen:=SetAPen(rp,0)                        -> Set Frontpen to gray
           SetAfPt(rp,[$FFFF,$FFFF]:INT,1)              -> ...
            RectFill(rp,x,y,width,height)               -> ...
           SetBPen(rp,oldbpen)                          -> ...
          SetAPen(rp,oldapen)                           -> ...
        CASE    FILLGROUP2                              -> Fill the Group 2
         oldbpen:=SetBPen(rp,3)                         -> Set the Backpen to blue
          oldapen:=SetAPen(rp,2)                        -> Set the Frontpen to white
           SetAfPt(rp,[$AAAA,$5555]:INT,1)              -> ...
            RectFill(rp,x,y,width,height)               -> ...
           SetBPen(rp,oldbpen)                          -> ...
          SetAPen(rp,oldapen)                           -> ...
   ENDSELECT
ENDPROC

PROC saveprefs(screen,id,x,y,width,height,open)
 iffhandle:=ng_prefsproc('ram:all.ngp',GUI_ABOUT,iffhandle,screen,id,x,y,width,height,open)
ENDPROC

PROC prefs()                                            -> Save (show) the Prefs
 ng_setattrsA([
        NG_GUI,         gui,
        NG_SAVEPREFS,   TRUE,
        NIL,            NIL])
ENDPROC

PROC font()                                             -> Open the Font-Window
 ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_OPENGUI,
        NG_GUIID,       GUI_FONT,
        NIL,            NIL])
ENDPROC

PROC screenmode()                                       -> Open the Screenmode-Window
 ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_OPENGUI,
        NG_GUIID,       GUI_SCREENMODE,
        NIL,            NIL])
ENDPROC

PROC closechilds()                                      -> Close all Windows (NOT the first = BACKDROP!)
 ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_CLOSECHILDS,
        NIL,            NIL])
ENDPROC

PROC new()                                              -> Open the "new"-Window...
 ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_OPENGUI,
        NG_GUIID,       GUI_MULTI,
        NIL,            NIL])
ENDPROC

PROC showgauge()
 ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_OPENGUI,
        NG_GUIID,       GUI_GAUGE,
        NIL,            NIL])
ENDPROC

PROC closeall() IS 0                                    -> 0 means that all should be closed!

PROC setgauge(x,y)      IS gauge.set(y)                                      -> Set the gauge-Value to the Sliders-State

PROC change()                                           -> Change the Windows-Gui-Description
 ng_setattrsA([NG_GUI,gui,
        NG_GUIID,       GUI_MULTI,
        NG_CHANGEGUI,   NG_NEWGUI,
        NG_NEWDATA,
                [ROWS,
                [BEVELR,
                [FILLGROUP1,
                [EQCOLS,
                        [SBUTTON,{block},'Block Main'],
                        [SBUTTON,{hide},'Hide Main']]]],
                [DBEVELR,
                [FILLGROUP1,
                [ROWS,
                        [TEXT,'Another (changed) Window','NewGUI-Example:',TRUE,3]
                ]]],
                [BAR]
                ]
         ,NIL,NIL])
ENDPROC

PROC about()                                            -> Open the About-Window
 ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_OPENGUI,
        NG_GUIID,       GUI_ABOUT,
        NIL,            NIL])
ENDPROC

PROC test1()                                            -> Outputs a test-Message
 WriteF('Test!\n')
ENDPROC

PROC block()                                            -> Blocking the main-window
 DEF    a
  WriteF('\nBlocking Main-Window: ')
   ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_BLOCKGUI,
        NG_GUIID,       GUI_FIRST,
        NIL,    NIL])
    FOR a:=0 TO 50                              -> 
     Delay(1)                                   -> Do wait some time (and let other tasks have our cpu-time!)
      WriteF('.')
     guimessage(gui)                            -> Handle all gui-Messages (like resizing ect...)
    ENDFOR
   ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_UNBLOCKGUI,
        NG_GUIID,       GUI_FIRST,
        NIL,    NIL])
ENDPROC

PROC hide()                                     -> Hide the main-Window
 IF main_gui=TRUE
  ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_CLOSEGUI,
        NG_GUIID,       GUI_FIRST,
        NIL,    NIL])
  main_gui:=FALSE
 ELSE
  appear()
  main_gui:=TRUE
 ENDIF
ENDPROC

PROC appear()                                   -> Let the main-window appearing again!
 ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_OPENGUI,
        NG_GUIID,       GUI_FIRST,
        NIL,    NIL])
ENDPROC

PROC rexxmsg(s,mes=NIL)                         -> Parse all arexx-Message 
 WriteF('Rexx-Msg: "\s"\n',s)                   -> Outputs the receives String into CONsole

  mes:=NIL                                      -> Unneccesarry!
ENDPROC  StrCmp('QUIT',s),0,'Reply-Message'     -> return-Values (look under AFC/Rexxer for details!)

PROC ticker()                                   -> Turns the Ticker-Procedure on and of!
 IF tickon=TRUE
   ng_setattrsA([NG_GUI,gui,
        NG_CHANGETICKER,TRUE,NIL,NIL])          -> TRUE is necessary because FALSE means that the Tag NG_CHANGETICKER isn`t given (through GetTagData()!)
  tickon:=FALSE
 ELSE
   ng_setattrsA([NG_GUI,gui,
        NG_CHANGETICKER,{tickmsg},NIL,NIL])
  tickon:=TRUE
 ENDIF
ENDPROC

PROC tickmsg()
 IF tick=TRUE
  WriteF('Tick - ')
  tick:=FALSE
 ELSE
  WriteF('Tack!\n')
  tick:=TRUE
 ENDIF
ENDPROC

