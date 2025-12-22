OPT     OSVERSION = 37
OPT     LARGE

MODULE 'newgui/newgui'

CONST   GUI_MAIN = 1

DEF     gui:PTR TO LONG

PROC main()
 DEF top
  top:=[COLS,
         [SPACEH],
         [BUTTON,{change},'GUI A',0],
         [SPACEH],
         [BUTTON,{change},'GUI B',1],
         [SPACEH],
         [BUTTON,{change},'GUI C',2],
         [SPACEH]
       ]
  gui:=[
         [ROWS,top,[SPACE],[SLIDE,{ignore},'Colors:',FALSE,1,8,3,5,'']],
         [ROWS,top,[SPACE],[CHECK,{ignore},'Ignore case',TRUE,FALSE]],
         [ROWS,top,[SPACE],[PALETTE,{ignore},'Palette:',3,5,2,0]]
       ]
  newguiA([
        NG_WINDOWTITLE, 'NewGUI - Demo',        -> Titel des Fensters
        NG_GUIID,       GUI_MAIN,               -> Gui-ID
        NG_GUI,         gui[],                  -> Oberflächenbeschreibung
        NIL,NIL])
ENDPROC

PROC ignore(info,x) IS EMPTY

PROC change(index,gh)
 ng_setattrsA([NG_GUI,  gh,
        NG_CHANGEGUI,   NG_NEWGUI,
        NG_GUIID,       GUI_MAIN,
        NG_NEWDATA,     gui[index],
        NIL,NIL])
ENDPROC
