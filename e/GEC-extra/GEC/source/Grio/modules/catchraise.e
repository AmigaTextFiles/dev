OPT MODULE

EXPORT PROC catchRaise(func_addr,error_result=0) HANDLE
  func_addr()
EXCEPT
  VOID error_result
ENDPROC D0
