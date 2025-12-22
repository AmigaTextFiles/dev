OPT     OSVERSION = 37

MODULE  'newgui/newgui'
MODULE  'newgui/ng_showerror'

CONST   GUI_MAIN = 1

DEF     gui:PTR TO LONG

PROC main()     HANDLE
 DEF top,bottom
  top:=[COLS,
         [SPACEH],
->                                 .--------- INFO!
->                                ||  .------ HOTKEY (NOTE: "a" is diffrent to "A" - CASE INSENSITIVE)
->                                || ||    .- NODE (@node ...) in the AmigaGUIDE-Document!
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
        NG_WINDOWTITLE, 'NewGUI - Demo',        -> Titel des Fensters
        NG_REXXNAME,    'NEWGUI',               -> Name für einen ARexx-Port
        NG_REXXPROC,    {rexxmsg},              -> PTR der Prozedur die ARexx-Messages verarbeitet
        NG_HELPGUIDE,   'edocs:e.guide',        -> AmigaGUIDE-Hilfs-Datei
        NG_BFPATTERN,   [$AAAA,$5555]:INT,      -> Backfillpattern (Muster)
        NG_BFEXP,       1,                      -> Exponent für den Pattern (siehe graphics/gfxmacros/SetAfPt)
        NG_BFBACKPEN,   3,                      -> Hintergrundstift (nummer) für den Pattern
        NG_BFFRONTPEN,  0,                      -> Zeichenstift (Nummer) für den Pattern
        NG_PATTERNEXP,  1,                      -> Exponent für den Pattern
        NG_PATTERN1,    [$AAAA,$5555]:INT,      -> Muster (Pattern) für FILLPATTERN1
        NG_P1BACKPEN,   0,                      -> Hintergrundstift für das Patternfilling (Muster)
        NG_P1FRONTPEN,  0,                      -> Zeichenstift für das Muster (Patternfilling)
        NG_GUIID,       GUI_MAIN,               -> Gui-ID
        NG_GUI,         gui[],                  -> Oberflächenbeschreibung
        NIL,NIL])
EXCEPT DO
 IF exception THEN ng_showerror(exception)
CleanUp(exception)
ENDPROC

PROC ignore(info,x) IS EMPTY

PROC change(index,gh)
 ng_setattrsA([NG_GUI,  gh,                     -> NG_GUI is ALWAYS (!) the MAIN-Guihandle (the first opened!)
        NG_CHANGEGUI,   NG_NEWGUI,              -> Change the GUI, ACTION = New GUI-Description (NG_NEWGUI)
        NG_GUIVAR,      gh,                     -> Guihandle from the gui to change!
        NG_NEWDATA,     gui[index],             -> The NEW Gui DESCRIPTION (!) no Guihandle!
        NIL,NIL])
ENDPROC

PROC showguide(x,gh)
 ng_setattrsA([NG_GUI,  gh,                     -> NG_GUI = Mail-GUIhandle!
        NG_SHOWGUIDE,   TRUE,                   -> Show the HELP-Guide (main-node!)
        NIL,NIL])
ENDPROC

PROC rexxmsg(s,mes=NIL)                         -> Programm zum parsen von ARexx-Messages  (Show into the AFC-Rexxer-Class!)
 WriteF('\nRexx-Msg: "\s"',s)                   -> ARexx-String (s) ausgeben!

  mes:=NIL                                      -> Message auf NIL setzen
ENDPROC  StrCmp('QUIT',s),0,'Reply-Message'     -> Rückgabe! Format = BOOL,INT,STRING     (Beenden?,Returncode,Replystring)
