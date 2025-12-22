OPT     OSVERSION=37

MODULE  'newgui/newgui'
MODULE  'gadgets/tabs'
MODULE  'newgui/tabs'

DEF     guihandle:PTR TO guihandle,
        t=NIL:PTR TO tabs,
        gui:PTR TO LONG

PROC main() HANDLE
 DEF    top
  NEW t.tabs(['Slide',   -1,-1,-1,-1, NIL,
           'Check',   -1,-1,-1,-1, NIL,
           'Palette', -1,-1,-1,-1, NIL,
            NIL]:tablabel)
   top:=[PLUGIN,{tabsaction},t]
    gui:=[
         [ROWS,top,[SPACE],[SLIDE,{ignore},'Colors:',FALSE,1,8,3,5,'']],
         [ROWS,top,[SPACE],[CHECK,{ignore},'Ignore case',TRUE,FALSE]],
         [ROWS,top,[SPACE],[PALETTE,{ignore},'Palette:',3,5,2,0]]
       ]
     newguiA([
        NG_WINDOWTITLE, 'NewGUI-Button-Plugin',     
        NG_BFPATTERN,   [$AAAA,$5555]:INT,                      /* Backfillpattern (Muster)             */
        NG_BFEXP,       1,                                      /* Exponent (-> graphics/gfxmacros/SetAfPt)     */
        NG_BFBACKPEN,   0,                                      /* Hintergrundstift für den Pattern     */
        NG_BFFRONTPEN,  0,                                      /* Zeichenstift für den Pattern         */
        NG_GUI,
                        gui[],NIL,NIL],{getguihandle})
EXCEPT DO
  END t
ENDPROC

PROC getguihandle(gh) IS guihandle:=gh

PROC tabsaction(gh,t:PTR TO tabs)
 ng_setattrsA([NG_GUI,  guihandle,
        NG_CHANGEGUI,   NG_NEWGUI,
        NG_GUIVAR,      guihandle,
        NG_NEWDATA,     gui[t.current],
        NIL,NIL])
   WriteF('tabs value = \d\n',t.current)
ENDPROC

PROC ignore() IS EMPTY
