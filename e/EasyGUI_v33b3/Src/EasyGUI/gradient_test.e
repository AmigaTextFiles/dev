MODULE 'tools/EasyGUI', 'tools/exceptions',
       'plugins/gradient'

DEF disabled=FALSE, pens1, pens2

PROC main() HANDLE
  DEF g=NIL:PTR TO gradient
  pens1:=[2,0,1,-1]:INT
  pens2:=[1,0,2,-1]:INT
  NEW g.gradient(FALSE,$4444,6,pens1)
  easyguiA('BOOPSI in EasyGUI!',
    [ROWS,
      [TEXT,'GradientSlider test...',NIL,TRUE,15],
      [PLUGIN,{gradaction},g],
      [COLS,
        [BUTTON,{reset},'Reset',g],
        [BUTTON,{swap_pens},'Swap Pens',g],
        [BUTTON,{toggle_enabled},'Toggle Enabled',g]
      ]
    ])
EXCEPT DO
  report_exception()
ENDPROC

PROC gradaction(i,g:PTR TO gradient)
  WriteF('gradient value = \z$\h[4]\n', g.curval)
ENDPROC

PROC reset(g:PTR TO gradient,i)
  g.setcurval($4444)
  g.setpens(pens1)
ENDPROC

PROC swap_pens(g:PTR TO gradient,i)
  g.setpens(IF g.pens=pens1 THEN pens2 ELSE pens1)
ENDPROC

PROC toggle_enabled(g:PTR TO gradient,i)
  g.setdisabled(g.disabled=FALSE)
ENDPROC
