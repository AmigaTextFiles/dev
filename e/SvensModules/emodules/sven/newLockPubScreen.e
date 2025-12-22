/* an LockPubScreen that has the same syntax like UnlockPubScreen
*/

OPT MODULE

MODULE 'intuition/screens'
MODULE 'sven/getPubScreenName'

EXPORT PROC newLockPubScreen(name:PTR TO CHAR,scr=NIL:PTR TO screen)
DEF newname[256]:STRING

  IF name=NIL
    name:=getPubScreenName(newname,scr)
  ENDIF

ENDPROC LockPubScreen(name)

