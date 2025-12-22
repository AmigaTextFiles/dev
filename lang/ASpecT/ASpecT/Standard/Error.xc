
TERM
DEFUN(xx__Errorerror_0,(S,IR),
      TERM    S AND
      INSTREC IR)
{ TERM sysi,ok,syso;
  extern void EXFUN(exit,(unsigned));
  STDOUT= stdout;
  printf("program error: ");
  _RUNTIME_WRITE(_S_RUNTIME_string,S,sysi,&ok,&syso);
  printf("\n");
  free__RUNTIME_string(S);
  exit(1);
}

XINITIALIZE(Error_Xinitialize,__XINIT_Error)
