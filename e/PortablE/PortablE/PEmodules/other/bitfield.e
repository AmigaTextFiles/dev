OPT POINTER
OPT PREPROCESS

#define NBITMASK(n) (Shl(1,(n))-1)

#define NBITSATX(n,x) (Shl(NBITMASK(n),(x)))

#define NOTNBITSATX(n,x) (Not(NBITSATX(n,x)))

#define GETNBITSATX(n,x,f) (lshr((f) AND NBITSATX(n,x), (x)))

#define SETNBITSATX(n,x,f,v) (((f) AND NOTNBITSATX(n,x)) OR Shl((v) AND NBITMASK(n), x))

PROC lshr(x,y) RETURNS result
	result := x AND $7FFFFFFF SHR y
	IF x AND $80000000 THEN result := result OR (1 SHL (31-y))
ENDPROC
