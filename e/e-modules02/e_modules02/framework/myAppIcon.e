OPT MODULE
OPT EXPORT

MODULE '*wbAppIcon'
MODULE 'workbench/workbench','workbench/startup'

OBJECT myAppIcon OF wbAppIcon
ENDOBJECT

PROC handleDroppedIcons(argList:PTR TO wbarg,n=0) OF myAppIcon
  DEF x,name[208]:STRING
  FOR x:=0 TO n-1
    WriteF('#\d name="\s"\n', x+1, argList[x].name)
    NameFromLock(argList[x].lock,name,208)
    WriteF('#\d dir="\s"\n', x+1,name)
  ENDFOR
  WriteF('\n')
ENDPROC
