OPT MODULE

PROC swap(left, right)
  DEF temp
  temp:=^right
  ^right:=^left
  ^left:=temp
ENDPROC
