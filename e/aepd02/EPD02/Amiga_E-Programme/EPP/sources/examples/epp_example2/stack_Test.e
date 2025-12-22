PMODULE 'PMODULES:stack'

DEF stack : st_stackType

PROC main ()
  DEF i
  st_init (stack)
  FOR i := 0 TO 9
    WriteF ('pushing \d\n', i)
    st_push (stack, i)
  ENDFOR
  WHILE stack.count
    WriteF ('popping \d\n', st_pop(stack))
  ENDWHILE
ENDPROC
