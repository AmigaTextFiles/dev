MODULE 'tools/easygui', 'tools/exceptions',
       'gadgets/tabs',
       'plugins/tabs'

DEF labels:PTR TO tablabel, gui:PTR TO LONG

PROC main()
  DEF top, t=NIL:PTR TO tabs
  labels:=['Slide',   -1,-1,-1,-1, NIL,
           'Check',   -1,-1,-1,-1, NIL,
           'Palette', -1,-1,-1,-1, NIL,
            NIL]:tablabel
  NEW t.tabs(labels)
  top:=[PLUGIN,{tabsaction},t]
  gui:=[
         [ROWS,top,[SPACE],[SLIDE,{ignore},'Colors:',FALSE,1,8,3,5,'']],
         [ROWS,top,[SPACE],[CHECK,{ignore},'Ignore case',TRUE,FALSE]],
         [ROWS,top,[SPACE],[PALETTE,{ignore},'Palette:',3,5,2,0]]
       ]
  easyguiA('Tabs Test 2', gui[])
ENDPROC

PROC ignore(i,x) IS EMPTY

PROC tabsaction(gh,t:PTR TO tabs)
  changegui(gh,gui[t.current])
  changetitle(gh,labels[t.current].label)
ENDPROC
