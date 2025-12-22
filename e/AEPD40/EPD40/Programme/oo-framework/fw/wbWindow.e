
-> wbWindow is an abstraction of WB windows.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'utility/tagitem','intuition/intuition'
MODULE 'gadtools','libraries/gadtools'
MODULE 'fw/wbGadTools'

OBJECT wbWindow OF wbGadTools
  window:PTR TO window
  menus:PTR TO menu
ENDOBJECT

-> Create a window.
-> Return FALSE if failed.
PROC create(menus:PTR TO newmenu,visual,taglist) OF wbWindow HANDLE
  IF gadtoolsbase=NIL THEN Raise(0)
  IF menus
    self.menus:=CreateMenusA(menus,NIL)
    IF self.menus=NIL THEN Raise(0)
    IF LayoutMenusA(self.menus,visual,
      [GTMN_NEWLOOKMENUS,TRUE,TAG_DONE])=FALSE THEN Raise(0)
  ENDIF
  self.window:=OpenWindowTagList(NIL,taglist)
  IF self.window=NIL THEN Raise(0)
  IF menus THEN IF SetMenuStrip(self.window,self.menus)=FALSE THEN Raise(0)
  Gt_RefreshWindow(self.window,NIL)
  RETURN TRUE
EXCEPT
  self.remove()
ENDPROC FALSE

-> Remove the window.
PROC remove() OF wbWindow
  IF self.window THEN CloseWindow(self.window)
  IF self.menus THEN FreeMenus(self.menus)
  self.window:=NIL
ENDPROC

