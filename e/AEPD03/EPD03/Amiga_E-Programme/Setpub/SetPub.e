
/* Setzen des DefaultPubScreens */

OPT OSVERSION=37

MODULE 'intuition/intuition','intuition/screens'

PROC main()
  DEF myargs:PTR TO LONG,rdargs
  myargs:=[0,0]
  IF rdargs:=ReadArgs('SCREEN/A',myargs,NIL)
    SetDefaultPubScreen(myargs[0])
    SetPubScreenModes(SHANGHAI OR POPPUBSCREEN)
    FreeArgs(rdargs)
  ELSE
    WriteF('Usage: SetPub SCREEN/A\n')
  ENDIF
ENDPROC


/*

        mfG,
            TOB


He who reads many fortunes gets confused.

*/

