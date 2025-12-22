/* Trashcan Löschprogramm */

OPT OSVERSION=37

PROC main()
 WriteF('Trashcan leeren ...\n')
 Execute('delete SYS:Trashcan/#?',0,NIL)
 WriteF('Mülleimer geleert!\n')
 CleanUp(0)
ENDPROC

CHAR '\0$VER: \e[1mHAWK`s DELTRASH\e[m 1.13 (23.01.95)\0'
