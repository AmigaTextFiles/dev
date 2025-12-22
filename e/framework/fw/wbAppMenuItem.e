
-> wbAppMenuItem is an abstraction of WB AppMenuItems.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'wb','workbench/workbench','workbench/startup'
MODULE 'fw/wbObject','fw/wbMessagePort'

OBJECT wbAppMenuItem OF wbMessagePort
  appMenuItem
ENDOBJECT

-> Create a WB AppMenuItem.
PROC create(itemText) OF wbAppMenuItem HANDLE
  IF workbenchbase=NIL THEN Raise(0)
  IF self.makePort()=FALSE THEN Raise(0)
  self.appMenuItem:=AddAppMenuItemA(0,0,itemText,self.port,NIL)
  IF self.appMenuItem=NIL THEN Raise(0)
EXCEPT
  self.remove()
  RETURN FALSE
ENDPROC TRUE

-> Handle the receipt of a message at the object's MsgPort.
PROC handleMessage(appMsg:PTR TO appmessage) OF wbAppMenuItem
  IF appMsg.numargs=0 THEN RETURN self.handleNoIconSelected()
ENDPROC self.handleSelectedIcons(appMsg.arglist)

-> Handle AppMenuItem selection without any WB Icon selected.
PROC handleNoIconSelected() OF wbAppMenuItem IS STOPALL

-> Handle selected WB Icons.
PROC handleSelectedIcons(argList:PTR TO wbarg) OF wbAppMenuItem IS PASS

-> Remove the WB AppMenuItem.
PROC remove() OF wbAppMenuItem
  IF self.appMenuItem THEN RemoveAppIcon(self.appMenuItem)
  IF self.port THEN self.deletePort()
  self.appMenuItem:=NIL
ENDPROC

