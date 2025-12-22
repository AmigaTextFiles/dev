-> Ouaaaaiii, une vrai pile en E! :-)

OPT MODULE

EXPORT OBJECT stack
  PRIVATE d:PTR TO LONG
ENDOBJECT

PROC stack() OF stack                           -> constructeur
  self.d:=NIL
ENDPROC

PROC is_empty() OF stack IS self.d=NIL

PROC push(x) OF stack
  self.d:=NEW [self.d,x]:LONG
ENDPROC

PROC pop() OF stack
  DEF a:PTR TO LONG,b
  IF a:=self.d
    self.d:=a[]; b:=a[1]
    END a[2]
  ELSE
    Raise("estk")
  ENDIF
ENDPROC b

PROC end() OF stack                             -> destructeur
  DEF a:PTR TO LONG,b:PTR TO LONG
  a:=self.d
  WHILE a
    b:=a; a:=a[]; END a[2]
  ENDWHILE
ENDPROC
