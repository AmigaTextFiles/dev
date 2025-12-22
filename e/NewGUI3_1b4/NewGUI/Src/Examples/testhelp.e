OPT     OSVERSION = 37
OPT     LARGE

MODULE  'newgui/newgui'
MODULE  'newgui/ng_showerror'

CONST   GUI_MAIN = 1

DEF     gui:PTR TO LONG,
        gh=NIL

PROC main()     HANDLE
 DEF top,bottom
  top:=[COLS,
         [SPACEH],
->                                 .--------- INFO!
->                                ||  .------ HOTKEY (NOTE: "a" is diffrent to "A" - CASE INSENSITIVE)
->                                || ||    .- NODE (@node ...) of the AmigaGUIDE-Document for Online-Help
->                                \/ \/   \/
         [BUTTON,{change},'GUI _A',0,'a','CH_0A'],
         [SPACEH],
         [BUTTON,{change},'GUI _B',1,'b','CH_0B'],
         [SPACEH],
         [BUTTON,{change},'GUI _C',2,'c','CH_0C'],
         [SPACEH]
       ]
  bottom:=[BUTTON,{showguide},'_Show Guide',NIL,'s']

  gui:=[
         [ROWS,top,[SPACE],[SLIDE,{ignore},'Colors:',FALSE,1,8,3,5,'',NIL,NIL,'CH_0D'],bottom],
         [ROWS,top,[SPACE],[CHECK,{ignore},'Ignore case',TRUE,FALSE,NIL,NIL,'CH_0E'],bottom],
         [ROWS,top,[SPACE],[PALETTE,{ignore},'Palette:',3,5,2,0,0,NIL,'CH_0F'],bottom]
       ]
  newguiA([
        NG_WINDOWTITLE, 'NewGUI - Demo',
        NG_REXXNAME,    'NEWGUI',               -> Name of the ARexx-Port
        NG_REXXPROC,    {rexxmsg},              -> Procedure to parse the ARexx-Messages
        NG_HELPGUIDE,   'edocs:e.guide',        -> Name from the Amiga-Guide-Online-Help (!!!! Change to your e.doc!!!)
        NG_GUIID,       GUI_MAIN,               -> Gui-ID
        NG_GUI,         gui[],                  -> Gui-Description (PTR to a List!!)
        NIL,NIL],{getgui})
EXCEPT DO
 IF exception THEN ng_showerror(exception)
CleanUp(exception)
ENDPROC

PROC ignore()   IS EMPTY                        -> Do nothing (NOP)

PROC getgui(g,s)        IS gh:=g                -> Get the PTR to the Guihandle (s = screen-PTR!!!)

PROC change(index,g)
 ng_setattrsA([NG_GUI,  gh,                     -> NG_GUI is ALWAYS (!) the MAIN-Guihandle (the first opened!)
        NG_CHANGEGUI,   NG_NEWGUI,              -> Change the GUI, ACTION = New GUI-Description (NG_NEWGUI)
        NG_GUIID,       GUI_MAIN,               -> Guihandle from the gui to change!
        NG_NEWDATA,     gui[index],             -> The NEW Gui DESCRIPTION (!) no Guihandle!
        NIL,NIL])
ENDPROC

PROC showguide()
 ng_setattrsA([NG_GUI,  gh,                     -> NG_GUI = Mail-GUIhandle!
        NG_SHOWGUIDE,   TRUE,                   -> Show the HELP-Guide (main-node!)
        NIL,NIL])
ENDPROC

PROC rexxmsg(s,mes=NIL)                         -> Procedure to parese the ARexx-Message
 WriteF('\nRexx-Msg: "\s"',s)                   -> Display the receives String! 

  mes:=NIL                                      -> Reset the message-PTR
ENDPROC  StrCmp('QUIT',s),0,'Reply-Message'     -> Return-Codes ect... (look AFC/Rexxer-Doc for details!)
