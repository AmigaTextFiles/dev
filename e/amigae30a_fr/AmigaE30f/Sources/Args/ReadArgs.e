/* Utilise readargs() pour prendre des parameters au lieu d'utiliser 'arg'.
   C'est d'autant mieux qu'un seul argument est demandé.
   Utilise le kick 2.0 */

OPT OSVERSION=37

PROC main()
  DEF myargs:PTR TO LONG,rdargs
  myargs:=[0,0,0]
  IF rdargs:=ReadArgs('UNIT/N,DISK/A,NEW/S',myargs,NIL)
    WriteF('UNIT=\d\n',Long(myargs[0]))      /* entier */
    WriteF('DISK=\s\n',myargs[1])            /* chaine */
    WriteF('NEW=\d\n',myargs[2])             /* booléen */
    FreeArgs(rdargs)
  ELSE
    WriteF('Mauvais arguments!\n')
  ENDIF
ENDPROC
