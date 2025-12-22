/* new random number generator
*/

OPT MODULE

DEF seed,multiplier,increment,modu


EXPORT PROC auto_init() IS init_seed(103,25137,13849,37419)

EXPORT PROC init_seed(a,b,c,d)
  seed      :=a AND $FFFF
  multiplier:=b AND $FFFF
  increment :=c AND $FFFF
  modu      :=d
ENDPROC

EXPORT PROC calc_seedQ()
       MOVE.W  seed.W,D0       -> get seed
       MULU.W  multiplier.W,D0
       ADD.L   increment,D0
       MOVE.W  D0,seed
ENDPROC seed

EXPORT PROC calc_seed() IS seed:=Mod(Mul(multiplier,seed)+increment,modu)

