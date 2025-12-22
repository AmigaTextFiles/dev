OPT MODULE

/*EXPORT PROC alternative(what,defi) IS
  IF what THEN what ELSE defi*/

EXPORT PROC alternative(what,defi)
  MOVE.L  what,D0
  BNE.S   alt_skip
  MOVE.L  defi,D0
alt_skip:
ENDPROC D0

