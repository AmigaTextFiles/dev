-> très petit exemple utilisant EasyGUI.m

OPT OSVERSION=37
MODULE 'tools/EasyGUI'

PROC main() HANDLE
  easygui('Euh..',[BUTTON,0,'Ah Que...'])
EXCEPT
  WriteF('"\s"\n',[exception,0])
ENDPROC
