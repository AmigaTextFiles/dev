/* computes random numbers with gausian distribution (hopefully)
*/

OPT MODULE

DEF seed

EXPORT PROC setseed(seedi) IS seed:=seedi

EXPORT PROC getseed() IS seed

EXPORT PROC initgaus()
  Rnd(-VbeamPos())
  seed:=RndQ(VbeamPos())
ENDPROC

EXPORT PROC gaus(anz=6)
DEF erg=0,i
  FOR i:=1 TO anz DO erg:=erg+(seed:=RndQ(seed))-(seed:=RndQ(seed))
ENDPROC Div(erg,anz)

EXPORT PROC floatgaus(anz=6)
DEF erg=0.0,i
  FOR i:=1 TO anz DO erg:=!erg+((Rnd(10001)-Rnd(10001))!)
ENDPROC !erg/(anz!*10000.0)

