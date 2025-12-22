
-> wbAppIcon is an abstraction of WB AppIcons.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'wb','workbench/workbench','icon','workbench/startup'
MODULE 'fw/wbObject','fw/wbMessagePort'

OBJECT wbAppIcon OF wbMessagePort
  diskObject
  appIcon
ENDOBJECT

-> Create a WB AppIcon.
-> Return FALSE if failed.
PROC create(name,iconName) OF wbAppIcon HANDLE
  IF iconbase=NIL THEN Raise(0)
  IF workbenchbase=NIL THEN Raise(0)
  IF self.makePort()=FALSE THEN Raise(0)
  self.diskObject:=GetDiskObjectNew(iconName)
  IF self.diskObject=NIL THEN Raise(0)
  self.appIcon:=AddAppIconA(0,0,name,self.port,NIL,self.diskObject,NIL)
  IF self.appIcon=NIL THEN Raise(0)
  RETURN TRUE
EXCEPT
  self.remove()
ENDPROC FALSE

-> Handle the receipt of a message at the object's MsgPort.
PROC handleMessage(appMsg:PTR TO appmessage) OF wbAppIcon
  IF appMsg.numargs=0 THEN RETURN self.handleDoubleClik()
ENDPROC self.handleDroppedIcons(appMsg.arglist)

-> Handle double click on the AppIcon.
PROC handleDoubleClik() OF wbAppIcon IS STOPALL

-> Handle Icons dropped into AppIcon.
PROC handleDroppedIcons(argList:PTR TO wbarg) OF wbAppIcon IS PASS

-> Remove the WB AppIcon.
PROC remove() OF wbAppIcon
  IF self.appIcon THEN RemoveAppIcon(self.appIcon)
  IF self.diskObject THEN FreeDiskObject(self.diskObject)
  IF self.port THEN self.deletePort()
  self.appIcon:=NIL
  self.diskObject:=NIL
ENDPROC

