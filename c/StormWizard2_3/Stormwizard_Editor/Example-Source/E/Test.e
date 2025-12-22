/* very small StormWizard test in E, adaption of the Pascal version
   by Wouter van Oortmerssen   */

MODULE 'wizard', 'libraries/wizard', 'intuition/intuition', 'intuition/screens'

PROC main() HANDLE
  DEF wizgui=NIL, wizwin=NIL:PTR TO wizardwindowhandle,
      wiznewwin=NIL:PTR TO nw, wizgadgets[25]:ARRAY OF gadget,
      win=NIL:PTR TO window, wbscreen=NIL:PTR TO screen,
      msg:PTR TO intuimessage, class

  IF (wizardbase:=OpenLibrary('wizard.library',0))=NIL THEN Raise("WIZL")
  IF (wbscreen:=LockPubScreen('Workbench'))=NIL THEN Raise("WB")
  IF (wizgui:=Wz_OpenSurfaceA('PROGDIR:Test.wizard',NIL,NIL))=NIL THEN Raise("WIZF")
  IF (wizwin:=Wz_AllocWindowHandleA(wbscreen,0,wizgui,NIL))=NIL THEN Raise("WIZW")
  IF (wiznewwin:=Wz_CreateWindowObjA(wizwin,1,
       [WWH_GADGETARRAY,wizgadgets,NIL]))=NIL THEN Raise("WIZW")
  IF (win:=Wz_OpenWindowA(wizwin,wiznewwin,NIL))=NIL THEN Raise("WIZW")

  LOOP
    WaitPort(win.userport)
    msg:=GetMsg(win.userport)
    IF msg
      class:=msg.class
      ReplyMsg(msg)
      IF class=IDCMP_CLOSEWINDOW THEN Raise()
    ENDIF
  ENDLOOP

EXCEPT DO
 IF win THEN Wz_CloseWindow(wizwin)
 IF wizwin THEN Wz_FreeWindowHandle(wizwin)
 IF wizgui THEN Wz_CloseSurface(wizgui)
 IF wbscreen THEN UnlockPubScreen(NIL,wbscreen)
 IF wizardbase THEN CloseLibrary(wizardbase)
ENDPROC
