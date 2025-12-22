OPT MODULE
OPT EXPORT

/* Initializes both Rnd(n) and RndQ(seed)  */
/* Returns randomized seed  */
PROC randomize()
DEF i, currentsecs, currentmicros, seed
  CurrentTime({currentsecs},{currentmicros})
  seed:=-currentmicros
  FOR i:=0 TO currentsecs AND $FF DO seed:=RndQ(seed)
  IF seed<0 THEN Rnd(seed) ELSE Rnd(-seed)
ENDPROC seed
