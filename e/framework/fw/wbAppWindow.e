
-> wbAppWindow is an abstraction of WB AppWindows.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'wb','workbench/workbench','workbench/startup'
MODULE 'utility/tagitem','intuition/intuition'
MODULE 'gadtools','libraries/gadtools'
MODULE 'fw/wbObject','fw/wbWindow'

OBJECT wbAppWindow OF wbWindow
  appWin
ENDOBJECT

-> Create a window.
-> Return FALSE if failed.
PROC create(menus:PTR TO newmenu,visual,taglist) OF wbAppWindow HANDLE
  IF gadtoolsbase=NIL THEN Raise(0)
  IF workbenchbase=NIL THEN Raise(0)
  IF menus
    self.menus:=CreateMenusA(menus,NIL)
    IF self.menus=NIL THEN Raise(0)
    IF LayoutMenusA(self.menus,visual,
      [GTMN_NEWLOOKMENUS,TRUE,TAG_DONE])=FALSE THEN Raise(0)
  ENDIF
  self.window:=OpenWindowTagList(NIL,taglist)
  IF self.window=NIL THEN Raise(0)
  self.port:=self.window.userport
  IF menus THEN IF SetMenuStrip(self.window,self.menus)=FALSE THEN Raise(0)
  Gt_RefreshWindow(self.window,NIL)
  self.appWin:=AddAppWindowA(0,0,self.window,self.port,NIL)
  IF self.appWin=NIL THEN Raise(0)
  RETURN TRUE
EXCEPT
  self.remove()
ENDPROC FALSE

-> Handle the receipt of a message at the object's MsgPort.
PROC handleMessage(appMsg:PTR TO appmessage) OF wbAppWindow
  IF appMsg.type=MTYPE_APPWINDOW THEN
    RETURN self.handleDroppedIcons(appMsg.arglist)
ENDPROC SUPER self.handleMessage(appMsg)

-> Handle Icons dropped into AppWindow.
PROC handleDroppedIcons(argList:PTR TO wbarg) OF wbAppWindow IS PASS

-> Remove the window.
PROC remove() OF wbAppWindow
  IF self.appWin THEN RemoveAppWindow(self.appWin)
  IF self.window THEN CloseWindow(self.window)
  IF self.menus THEN FreeMenus(self.menus)
  self.window:=NIL
ENDPROC

