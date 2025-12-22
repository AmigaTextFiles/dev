OPT MODULE, OSVERSION = 37, REG = 5

MODULE 'exec/ports',          -> Ports
       'icon',                -> Diskobj
       'intuition/intuition', -> Window
       'wb',                  -> Appmenu
       'workbench/workbench'  -> Diskobj

EXPORT OBJECT appitem PRIVATE
  appmenu
  appicon
  appwin

  diskobj:PTR TO diskobject

  appmenuport:PTR TO mp
  appiconport:PTR TO mp
  appwinport:PTR TO mp
ENDOBJECT

RAISE "APIC" IF AddAppIconA() = NIL,
      "APMN" IF AddAppMenuItemA() = NIL,
      "APWN" IF AddAppWindowA() = NIL,
      "PORT" IF CreateMsgPort()=NIL

->> initappitem()
PROC initappitem() OF appitem
  IF (iconbase      := OpenLibrary('icon.library', 36))      = NIL THEN Throw("LIB", 'icon.library')
  IF (workbenchbase := OpenLibrary('workbench.library', 37)) = NIL THEN Throw("LIB", 'workbench.library')
ENDPROC
-><
->> endappitem()
PROC endappitem() OF appitem
  IF iconbase      THEN CloseLibrary(iconbase)
  IF workbenchbase THEN CloseLibrary(workbenchbase)
ENDPROC
-><

->> addappmenu()
PROC addappmenu(name) OF appitem HANDLE
  IF self.appmenu THEN self.removeappmenu()

  self.appmenuport := CreateMsgPort()
  self.appmenu     := AddAppMenuItemA(0,                     -> Our ID# for item
                                      0,                     -> Our UserData
                                      name,                  -> MenuItem Text
                                      self.appmenuport, NIL) -> MsgPort, no tags
  RETURN TRUE
EXCEPT
  self.removeappmenu()
  ReThrow()
ENDPROC
-><
->> removeappmenu()
PROC removeappmenu() OF appitem
  DEF appmsg:PTR TO appmessage
  IF self.appmenu
    RemoveAppMenuItem(self.appmenu)
    self.appmenu := NIL
  ENDIF
  IF self.appmenuport
    -> Clear away any messages that arrived at the last moment
    WHILE appmsg := GetMsg(self.appmenuport) DO ReplyMsg(appmsg)
    DeleteMsgPort(self.appmenuport)
    self.appmenuport := NIL
  ENDIF
ENDPROC
-><

->> addappicon()
PROC addappicon(progpath, name, x, y) OF appitem HANDLE
  IF self.appicon THEN self.removeappicon()

  IF self.diskobj = NIL THEN self.diskobj := GetDiskObjectNew(progpath)
  self.diskobj.type     := NIL
  self.diskobj.currentx := x
  self.diskobj.currenty := y

  self.appiconport := CreateMsgPort()
  self.appicon     := AddAppIconA(0,
                                  0,
                                  name,
                                  self.appiconport,  NIL,
                                  self.diskobj, NIL)
  RETURN TRUE
EXCEPT
  self.removeappicon()
  ReThrow()
ENDPROC
-><
->> removeappicon()
PROC removeappicon() OF appitem
  DEF appmsg:PTR TO appmessage
  IF self.appicon
    RemoveAppIcon(self.appicon)
    self.appicon := NIL
  ENDIF
  IF self.diskobj
    FreeDiskObject(self.diskobj)
    self.diskobj := NIL
  ENDIF
  IF self.appiconport
    -> Clear away any messages that arrived at the last moment
    WHILE appmsg := GetMsg(self.appiconport) DO ReplyMsg(appmsg)
    DeleteMsgPort(self.appiconport)
    self.appiconport := NIL
  ENDIF
ENDPROC
-><

->> openappwindow()
PROC openappwindow(win_ptr:PTR TO window) OF appitem HANDLE
  IF self.appwin THEN self.closeappwindow()

  self.appwinport := CreateMsgPort()
  self.appwin     := AddAppWindowA(1, 0, win_ptr, self.appwinport, NIL)
EXCEPT
  self.closeappwindow()
  ReThrow()
ENDPROC
-><
->> closeappwindow()
PROC closeappwindow() OF appitem
  DEF appmsg:PTR TO appmessage
  IF self.appwin
    RemoveAppWindow(self.appwin)
    self.appwin := NIL
  ENDIF
  IF self.appwinport
    -> Clear away any messages that arrived at the last moment
    WHILE appmsg := GetMsg(self.appwinport) DO ReplyMsg(appmsg)
    DeleteMsgPort(self.appwinport)
    self.appwinport := NIL
  ENDIF
ENDPROC
-><

PROC menusigbit() OF appitem
  IF self.appmenuport THEN RETURN Shl(1, self.appmenuport.sigbit), self.appmenuport
ENDPROC FALSE
PROC iconsigbit() OF appitem
  IF self.appiconport THEN RETURN Shl(1, self.appiconport.sigbit), self.appiconport
ENDPROC FALSE
PROC winsigbit()  OF appitem
  IF self.appwinport THEN RETURN Shl(1, self.appwinport.sigbit),  self.appwinport
ENDPROC FALSE
