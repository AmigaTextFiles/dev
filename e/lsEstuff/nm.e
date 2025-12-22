OPT MODULE

->abstract linked node

MODULE 'leifoo/object'

EXPORT OBJECT nm OF object
   next:PTR TO LONG
   prev:PTR TO LONG
ENDOBJECT

PROC getObjectName() OF nm IS 'nm'


EXPORT OBJECT nmI OF nm
   id
ENDOBJECT

PROC getObjectName() OF nmI IS 'nmI'

EXPORT OBJECT nmN OF nm
   estrname
ENDOBJECT

PROC end() OF nmN IS DisposeLink(self.estrname)

PROC getObjectName() OF nmN IS 'nmN'

PROC setNodeName(name) OF nmN
   DEF newlen
   newlen := StrLen(name)
   IF (self.estrname = NIL) OR (EstrLen(self.estrname) < newlen)
      self.estrname := String(newlen)
   ENDIF
   StrCopy(self.estrname, name)
ENDPROC

PROC getNodeName() OF nmN IS self.estrname

PROC cmpNodeName(name) OF nmN
ENDPROC IF StrCmp(name, self.estrname) THEN TRUE ELSE FALSE

EXPORT OBJECT nmIV OF nmI
   value
ENDOBJECT

PROC getObjectName() OF nmIV IS 'nmIV'
