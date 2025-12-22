/*
 * Module EPP - AStartup - adapté de l'assembleur
 *
 * Permet d'obtenir les variables _argc, _argv pour le langage E.
 *
 * $VER: AStartup EPP 1.2 (16.04.94) (17.04.94)
 *
 * Utilisation:
 * ¯¯¯¯¯¯¯¯¯¯¯
 * 1) Appelez _startup() en premier dans votre procédure main() pour
 *    initialiser _argc & _argv,
 * 2) le programme E lui-même,
 * 3) Finir OBLIGATOIREMENT par la procédure _exit(<retcode>) pour
 *    libérer ce qui a été ouvert par _startup()
 *
 * NOTE IMPORTANTE:
 * _database EST RESERVE. NE JAMAIS LE MODIFIER, _exit(n) PLANTERAIT!!!
 *
 * _argc & _argv SONT RESERVES A LA LECTURE (READ-ONLY)
 *
 */

DEF _argc=NIL:LONG, _argv=NIL:PTR TO LONG, _database=NIL:LONG

PROC _astartup()
  DEF error
  PEA	error
  PEA	_database
  PEA	_argv
  PEA	_argc
  MOVE.L dosbase,-(A7)
  MOVE.L wbmessage,-(A7)
  PEA	arg
  INCBIN 'PMODULES:User/astartup/astartup.bin'
  LEA	28(A7),A7
ENDPROC error

PROC _exit(n)
  PEA	_database
  INCBIN 'PMODULES:User/astartup/exit.bin'
  ADDQ.L #4,A7
  CleanUp(n)
ENDPROC
