OPT MODULE, PREPROCESS
OPT EXPORT

#define NBITMASK(n) (Shl(1,(n))-1)

#define NBITSATX(n,x) (Shl(NBITMASK(n),(x)))

#define NOTNBITSATX(n,x) (Not(NBITSATX(n,x)))

#define GETNBITSATX(n,x,f) (lshr((f) AND NBITSATX(n,x), (x)))

#define SETNBITSATX(n,x,f,v) (((f) AND NOTNBITSATX(n,x)) OR Shl((v) AND NBITMASK(n), x))

PROC lshr(x,y)
  MOVE.L x, D0
  MOVE.L y, D1
  LSR.L D1, D0
ENDPROC D0
