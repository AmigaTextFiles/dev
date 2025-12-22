OPT MODULE

MODULE 'icon','workbench/workbench'


EXPORT PROC getToolType(dob:PTR TO diskobject,name,defarg=NIL)
DEF val
IF iconbase
   RETURN IF (val:=FindToolType(dob.tooltypes,name)) THEN val ELSE defarg
ENDIF
ENDPROC NIL

