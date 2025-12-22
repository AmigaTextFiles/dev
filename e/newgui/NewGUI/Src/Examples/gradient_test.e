OPT     OSVERSION = 37

MODULE  'newgui/newgui'
MODULE  'newgui/gradient'

DEF     g:PTR TO gradient,
        pens1,
        pens2

PROC main() HANDLE
 pens1:=[2,0,1,-1]:INT
  pens2:=[1,0,2,-1]:INT
      newguiA([
        NG_WINDOWTITLE, 'NewGUI-GradientPlugin',     
        NG_BFPATTERN,   [$AAAA,$5555]:INT,                      /* Backfillpattern (Muster)             */
        NG_BFEXP,       1,                                      /* Exponent (-> graphics/gfxmacros/SetAfPt)     */
        NG_BFBACKPEN,   3,                                      /* Hintergrundstift für den Pattern     */
        NG_BFFRONTPEN,  2,                                      /* Zeichenstift für den Pattern         */
/*                                                              /* ARexx-Port hinzufügen!               */
        NG_REXXNAME,    'NEWGUI',                               /* Name für einen ARexx-Port            */
        NG_REXXPROC,    {rexxmsg},                              /* Prozedur die ARexx-Messages auswertet*/
*/                                                              /* Durch den Port wird das EXE nicht größer!    */
        NG_GUI,
        [ROWS,
                [TEXT,'Gradient-Slider test',NIL,TRUE,1],
        [COLS,
                [GRADIENT,{gradaction},NEW g.gradient(FALSE,$4444,6,pens1)],
        [EQROWS,
                [BUTTON,{reset},'Reset'],
                [BUTTON,{swap_pens},'Swap Pens'],
                [BUTTON,{toggle_enabled},'Toggle Enabled']
        ]
        ]
        ],NIL,NIL])
EXCEPT DO
 END g
ENDPROC

PROC gradaction()
  WriteF('gradient value = \z$\h[4]\n', g.curval)
ENDPROC

PROC reset()
  g.setcurval($4444)
  g.setpens(pens1)
ENDPROC

PROC swap_pens()
  g.setpens(IF g.pens=pens1 THEN pens2 ELSE pens1)
ENDPROC

PROC toggle_enabled()
  g.setdisabled(g.disabled=FALSE)
ENDPROC
