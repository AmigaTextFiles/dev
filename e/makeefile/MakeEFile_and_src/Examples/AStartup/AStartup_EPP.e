/*
 * Astartup
 *
 * Test pour astartup.e
 *
 */
PMODULE 'PMODULES:User/astartup'
MODULE	'workbench/startup','exec/ports'

PROC main() HANDLE
  DEF wbargs:PTR TO wbarg, nbargs, args:PTR TO wbstartup
  DEF i, str:PTR TO CHAR
  IF _astartup()<>NIL THEN Raise("STRT")	/* erreur -> _exit(20) */
  WriteF('argc=\d\nargv=\h\n',_argc,_argv)
  IF _argc>0 /* we are run from the CLI */
    FOR i:=0 TO _argc-1 DO WriteF('argv[\d]=\s\n',i,_argv[i])
  ELSE /* wa are run from the Workbench */
    args:=_argv
    wbargs:=args.arglist
    nbargs:=args.numargs
    WriteF('\d argument(s) en \h\n',nbargs,wbargs)
    FOR i:=0 TO nbargs-1
      str:=wbargs[i].name
      IF Or(str[0]=0,str=NIL) THEN str:='(dir)'
      WriteF('arg[\d]=\s\n',i,str)
    ENDFOR
  ENDIF
  Raise(NIL)
  EXCEPT
  IF exception=NIL THEN _exit(0) ELSE _exit(20)
ENDPROC /* CleanUp() inclus dans _exit() */
