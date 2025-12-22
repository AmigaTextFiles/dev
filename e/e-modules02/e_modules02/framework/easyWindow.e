-> moduî OO definiujâcy dostëp do easygui z poziomu FW!
-> abstrakcyjna klasa do obsîugi okienek tworzonych za pomocâ EasyGui
-> (c)'96 Piotr Gapiïski (31.03.96)

OPT MODULE
OPT EXPORT, OSVERSION=37

MODULE 'tools/easygui','fw/wbObject',
       'intuition/intuition','exec/ports'

OBJECT easyWindow OF wbObject
  window: PTR TO window
  handle: PTR TO guihandle
ENDOBJECT

-> konstruktor
-> zwraca FALSE w przypadku niepowodzenia
PROC create(windowtitle,gui,info=NIL,screen=NIL,
     textattr=NIL,newmenus=NIL) OF easyWindow HANDLE
  self.handle:=guiinit(windowtitle,gui,info,screen,textattr,newmenus)
  self.window:=self.handle.wnd
  IF newmenus=NIL THEN self.window.flags:=self.window.flags OR WFLG_RMBTRAP
  RETURN TRUE
EXCEPT
  self.remove()
ENDPROC FALSE

-> destruktor
PROC remove() OF easyWindow
  IF self.handle THEN cleangui(self.handle)
  self.handle:=NIL
  self.window:=NIL
ENDPROC

-> bit sygnalizacyjny EXECa naleûâcy do obiektu
PROC signal() OF easyWindow IS self.window.userport.sigbit

-> obsîuguje zdarzenia gdy obiekt jest aktywowany
PROC handleActivation() OF easyWindow
  DEF res
  res:=guimessage(self.handle)
  IF res>-1 THEN res:=self.handleMessage(res)
ENDPROC res

-> obsîuguje wiadomoôci napîywajâce do obiektu
PROC handleMessage(info) OF easyWindow IS STOPALL
