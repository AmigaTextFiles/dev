OPT MODULE

PRIVATE
DEF rangeSeed

PROC Unsigned(x) IS x AND $FFFF
PUBLIC

PROC fastRand(num) IS IF num>0 THEN num*2 ELSE Xor(num*2, $1d872b41)

PROC rangeRand(num)
  DEF max
  max:=Unsigned(num-1)
  REPEAT
    max:=Shr(max,1)
    rangeSeed:=fastRand(rangeSeed)
  UNTIL (max<=0)
  IF num
    RETURN Unsigned(Shr(Mul(Unsigned(num), Unsigned(rangeSeed)), 16))
  ELSE
    RETURN Unsigned(rangeSeed)
  ENDIF
ENDPROC num
