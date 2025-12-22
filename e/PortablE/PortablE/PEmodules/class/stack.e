-> Jaaaa, a true STACK in E! :-)

OPT MODULE, POINTER

CLASS stack
  PRIVATE
  d:ARRAY OF VALUE
ENDCLASS

PROC stack() OF stack				-> constructor
  self.d:=NILA
ENDPROC

PROC is_empty() OF stack IS self.d=NIL

PROC push(x) OF stack
  self.d:=NEW [self.d,x]:VALUE
ENDPROC

PROC pop() OF stack
  DEF a:ARRAY OF VALUE,b
  IF a:=self.d
    self.d:=a[0]!!ARRAY OF VALUE; b:=a[1]
    END a
  ELSE
    Raise("estk")
  ENDIF
ENDPROC b

PROC end() OF stack				-> destructor
  DEF a:ARRAY OF VALUE,b:ARRAY OF VALUE
  a:=self.d
  WHILE a
    b:=a; a:=a[0]!!ARRAY OF VALUE; END b
  ENDWHILE
ENDPROC
