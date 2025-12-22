
-> WB FrameWork example: AppIcon + CTRL-C

-> Copyright © Guichard Damien 01/04/1996

MODULE 'icon','wb'
MODULE 'fw/eventLoop','fw/ctrl_c','fw/wbAppIcon'

PROC main() HANDLE
  DEF break:PTR TO ctrl_c, icon:PTR TO wbAppIcon, loop:PTR TO eventLoop
  IF (iconbase:=OpenLibrary('icon.library',0))=NIL THEN Raise(0)
  IF (workbenchbase:=OpenLibrary('workbench.library',0))=NIL THEN Raise(0)
  NEW break, icon, loop
  IF icon.create('WB AppIcon','PROGDIR:myapp')=NIL THEN Raise(0)
  loop.addWBObject(break)
  loop.addWBObject(icon)
  loop.do()
EXCEPT DO
  IF workbenchbase THEN CloseLibrary(workbenchbase)
  IF iconbase THEN CloseLibrary(iconbase)
ENDPROC

