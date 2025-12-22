-> testchange.e - show use of changegui() and BUTTON data field
MODULE 'tools/easygui'

DEF gui:PTR TO LONG, titles:PTR TO LONG

PROC main()
  DEF top
  top:=[COLS,
         [SPACEH],
         -> Use generic action function, with BUTTON data 0, 1 or 2.
         [BUTTON,{change},'GUI _A',0,"a"],
         [SPACEH],
         [BUTTON,{change},'GUI _B',1,"b"],
         [SPACEH],
         [BUTTON,{change},'GUI _C',2,"c"],
         [SPACEH]
       ]
  titles:=['GUI A','GUI B','GUI C']
  gui:=[
         [ROWS,top,[SPACE],[SLIDE,{ignore},'Colors:',FALSE,1,8,3,5,'']],
         [ROWS,top,[SPACE],[CHECK,{ignore},'Ignore case',TRUE,FALSE]],
         [ROWS,top,[SPACE],[PALETTE,{ignore},'Palette:',3,5,2,0]]
       ]
  easyguiA('Change Test', gui[])
ENDPROC

PROC ignore(info,x) IS EMPTY

PROC change(index,gh)
  changegui(gh,gui[index])
  changetitle(gh,titles[index])
ENDPROC
