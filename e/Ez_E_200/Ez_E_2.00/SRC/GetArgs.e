/* This is the module for getting args */

OPT OSVERSION=37

PROC getargs()
  DEF myargs:PTR TO LONG,rdargs
  myargs:=[0]
  rdargs:=ReadArgs('DIR/F',myargs,NIL)
  IF myargs[0]=FALSE THEN myargs[0]:='S:'
  FreeArgs(rdargs)
ENDPROC(myargs[0])

PROC main()
  getargs()
ENDPROC