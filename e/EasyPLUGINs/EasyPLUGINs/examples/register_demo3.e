/*
**
** Demo for register PLUGIN (based on tabs_test2.e shipped with easygui)
**
** Copyright: Ralph Wermke of Digital Innovations
** EMail    : wermke@gryps1.rz.uni-greifswald.de
** WWW      : http://www.user.fh-stralsund.de/~rwermke/di.html
**
** Date     : 03-Sep-1997
**
*/

MODULE 'tools/easygui', 'tools/exceptions',
       'utility/tagitem',
       'easyplugins/register'

DEF labels:PTR TO LONG, gui:PTR TO LONG

PROC main()
DEF top, r=NIL:PTR TO register_plugin

   labels:=['Slide', 'Check', 'Palette']

   NEW r.register([PLA_Register_Titles, labels, TAG_DONE])

   top:=[PLUGIN,{regsaction},r]
   gui:=[
         [ROWS,top,[SPACE],[SLIDE,{ignore},'Colors:',FALSE,1,8,3,5,'']],
         [ROWS,top,[SPACE],[CHECK,{ignore},'Ignore case',TRUE,FALSE]],
         [ROWS,top,[SPACE],[PALETTE,{ignore},'Palette:',3,5,2,0]]
       ]
   easyguiA('Register Test 2', gui[])
ENDPROC

PROC ignore(i,x) IS EMPTY

PROC regsaction(gh,r:PTR TO register_plugin)
   changegui(gh,gui[r.get(PLA_Register_ActivePage)])
   changetitle(gh,labels[r.get(PLA_Register_ActivePage)])
ENDPROC
