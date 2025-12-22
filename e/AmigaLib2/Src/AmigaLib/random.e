OPT MODULE

OPT PREPROCESS

DEF rangeSeed

EXPORT PROC fastRand(num) IS IF num>0 THEN num*2 ELSE Eor(num*2, $1d872b41)

#define UNSIGNED(x) (x AND $FFFF)

EXPORT PROC rangeRand(num)
  DEF max
  max:=UNSIGNED(num-1)
  REPEAT
    max:=Shr(max,1)
    rangeSeed:=fastRand(rangeSeed)
  UNTIL (max<=0)
  IF num
    RETURN UNSIGNED(Shr(Mul(UNSIGNED(num), UNSIGNED(rangeSeed)), 16))
  ELSE
    RETURN UNSIGNED(rangeSeed)
  ENDIF
ENDPROC
