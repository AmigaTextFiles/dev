-> testaw.e - shows use of AppWindow handling and changing GUIs

OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui'
#endif

MODULE 'workbench/startup', 'workbench/workbench'

CONST MAXLEN=20

DEF current=0, gui:PTR TO LONG

PROC main()
  DEF s[MAXLEN]:STRING
  -> Have a list of three different GUIs
  gui:=[
         [LISTV,{ignore},'Drop Icons on Me!',15,7,NIL,0,1,0,0,0,{gadappw}],
         [ROWS,[STR,{ignore},'Drop Icons on Me:',s,MAXLEN,5,0,0,0,{gadappw}],
               [SPACEV],[BUTTON,{ignore},'But Not on Me']],
         [ROWS,[BUTTON,{ignore},'Drop Icons on Me:',0,0,{gadappw}],
               [SPACEV],[STR,{ignore},'Not on Me:',s,MAXLEN,5]]
       ]
  easyguiA('Test App Window', gui[current],
          [EG_AWPROC,{winappw}, NIL])
ENDPROC

-> Ignore button presses etc.
PROC ignore(info,num) IS EMPTY

-> Show next GUI in list
PROC nextgui(gh)
  current++
  IF current>=ListLen(gui) THEN current:=0
  changegui(gh, gui[current])
ENDPROC

-> Default (window) App message handler
PROC winappw(info,awmsg)
  WriteF('You missed the gadget... try again!\n')
ENDPROC

-> App message handler for a gadget
PROC gadappw(info,awmsg)
  WriteF('You hit the gadget!  ')
  showappmsg(awmsg)
  nextgui(info)
ENDPROC

CONST NAMELEN=256

-> Show the contents of the App message
PROC showappmsg(amsg:PTR TO appmessage)
  DEF i, args:PTR TO wbarg, name[NAMELEN]:ARRAY
  WriteF('Hit at (\d,\d)\n', amsg.mousex, amsg.mousey)
  args:=amsg.arglist
  FOR i:=1 TO amsg.numargs
    NameFromLock(args.lock,name,NAMELEN)
    WriteF('   arg(\d): Name="\s", Lock=$\h ("\s")\n',
           i, args.name, args.lock, name)
    args++
  ENDFOR
  WriteF('\n')
ENDPROC
