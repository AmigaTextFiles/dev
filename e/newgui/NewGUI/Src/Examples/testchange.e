OPT     OSVERSION = 37

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
ENDPROC

PROC ignore(info,x) IS EMPTY

PROC change(index,gh)
 ng_setattrsA([NG_GUI,  gh,
        NG_CHANGEGUI,   NG_NEWGUI,
        NG_GUIVAR,      gh,
        NG_NEWDATA,     gui[index],
        NIL,NIL])
ENDPROC
