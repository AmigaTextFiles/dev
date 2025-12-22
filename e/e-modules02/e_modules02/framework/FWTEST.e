OPT OSVERSION=37
OPT PREPROCESS

-> WB FrameWork example: AppIcon + CTRL-C + EasyGui + EasyRexx
-> $VER: FWtest v1.0 (31.03.96)
-> based on myapp (c) Guichard Damien

MODULE 'icon','wb','tools/easygui','utility/tagitem'
MODULE 'fw/wbObject','fw/ctrl_c',
       '*myWindow','*myRexx','*myAppIcon','*newEventLoop'


#define PROGRAMVERSION   '$VER: FWtest v1.0 (31.03.96)'
#define MSG_CLI_NOLIBS   'Couldn\at open libraries...\n'
#define MSG_CLI_NOWINDOW 'Couldn\at open window...!\n'

PROC main() HANDLE
  DEF mywin: PTR TO myWindow,myrexx: PTR TO myRexx
  DEF break:PTR TO ctrl_c,
      icon:PTR TO myAppIcon,
      mainLoop:PTR TO newEventLoop

  IF (iconbase:=OpenLibrary('icon.library',0))=NIL THEN Raise(MSG_CLI_NOLIBS)
  IF (workbenchbase:=OpenLibrary('workbench.library',0))=NIL THEN Raise(MSG_CLI_NOLIBS)
  NEW mainLoop,break,icon.create('WB AppIcon','PROGDIR:FWtest')

  IF break THEN mainLoop.addWBObject(break)
  IF icon THEN mainLoop.addWBObject(icon)

  easyrexxbase:=OpenLibrary('easyrexx.library',0)
  IF easyrexxbase<>NIL
    NEW myrexx
    IF myrexx
      myrexx.open()
      WriteF('rexx port:="\s"\n',myrexx.portname)
      mainLoop.addWBObject(myrexx)
    ENDIF
  ENDIF

  NEW mywin
  IF mywin=NIL THEN Raise(MSG_CLI_NOWINDOW)
  mywin.open()
  mainLoop.addWBObject(mywin)
  mainLoop.do()

EXCEPT DO
  IF exception
    WriteF(exception)
    mainLoop.discard()
  ENDIF
  IF workbenchbase THEN CloseLibrary(workbenchbase)
  IF iconbase THEN CloseLibrary(iconbase)
  IF easyrexxbase THEN CloseLibrary(easyrexxbase)
ENDPROC

CHAR '$VER: ',PROGRAMVERSION,0
