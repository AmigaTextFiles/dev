-> testkey.e - shows use of keyboard short-cuts
MODULE 'tools/easygui',
       'exec/lists', 'exec/nodes',
       'graphics/text',
       'amigalib/lists'

CONST MAXLEN=20

DEF gad, disabled=TRUE

PROC main()
  DEF s[MAXLEN]:STRING, list:lh, choices
  newList(list)
  AddTail(list, [0,0,0,0,'Item']:ln)
  AddTail(list, [0,0,0,0,'Item-2']:ln)
  AddTail(list, [0,0,0,0,'Item-3']:ln)
  AddTail(list, [0,0,0,0,'Item-4']:ln)
  AddTail(list, [0,0,0,0,'Item-5']:ln)
  AddTail(list, [0,0,0,0,'Item-6']:ln)
  choices:=['Zero','One','Two',NIL]
  StrCopy(s,'Hello')
  easyguiA('Press Some Keys!',
          [COLS,
             [EQROWS,
                [CYCLE,{cycle},'_Cycle:',choices,1,0,"c"],
                [STR,{password},'S_tring:',s,MAXLEN,5,FALSE,0,"t"],
                [BAR],
                -> Show new CHECK and MX alignments
                [CHECK,{check},'C_heck:',TRUE,TRUE,0,"h"],
                [MX,{mx},'_MX:',choices,TRUE,0,0,"m"],
                [BAR],
                -> Show new CHECK and MX right text
                [CHECK,{check2},'Ch_eck2 (Right)',TRUE,FALSE,0,"e"],
                [MX,{mx2},'M_X2 (Right)',choices,FALSE,0,0,"x"]
             ],
             [BAR],
             [ROWS,
                -> Show new LISTV label and show selected
                [LISTV,{listv},'_List:',8,5,list,FALSE,1,0,0,"l",0],
                [SLIDE,{slide},'_Slide:',FALSE,1,8,3,3,'',0,"s"],
->                [SCROLL,{slide},FALSE,80,10,3,3,0,"i"],
                -> Show new PALETTE current field, min size and show selected
                [PALETTE,{palette},'_Palette:',3,5,2,2,0,"p"],
                gad:=[SBUTTON,{button},'_blockwin()',0,"b",0,disabled],
                [SBUTTON,{disable},'_disable()',0,"d"]
             ]
          ])
ENDPROC

PROC button(gh) HANDLE
  blockwin(gh)
  easyguiA('New GUI',
          [ROWS,
             [TEXT,'Old GUI blocked',NIL,TRUE,15],
             [BUTTON,0,'_Unblock',0,"u"]
          ])
EXCEPT DO
  unblockwin(gh)
  ReThrow()
ENDPROC

PROC disable(gh)
  disabled:=disabled=FALSE
  setdisabled(gh,gad,disabled)
ENDPROC

PROC slide(info,val) IS    PrintF('Slide has moved to \d\n', val)

PROC cycle(info,val) IS    PrintF('Cycle choice is now \d\n', val)

PROC check(info,val) IS    PrintF('Check is now \s\n',
                                 IF val THEN 'TRUE' ELSE 'FALSE')
PROC check2(info,val) IS   PrintF('Check2 is now \s\n',
                                  IF val THEN 'TRUE' ELSE 'FALSE')

PROC mx(info,val) IS       PrintF('MX choice is now \d\n', val)
PROC mx2(info,val) IS      PrintF('MX2 choice is now \d\n', val)

PROC password(info,val) IS PrintF('Password is now "\s"\n', val)

PROC palette(info,val) IS  PrintF('Palette pen is now \d\n', val)

PROC listv(info,val) IS    PrintF('List selection moved to \d\n', val)
