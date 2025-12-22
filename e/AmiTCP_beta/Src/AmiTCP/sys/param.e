OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/sys/types'

CONST BSD=199402,
      BSD4_3=1,
      BSD4_4=1

CONST NOFILE=FD_SETSIZE,
      BIG_ENDIAN=4321

CONST BYTE_ORDER=BIG_ENDIAN,
      MAXHOSTNAMELEN=64,
      MAXLOGNAME=32

PROC setbit(a,i)
  DEF x, d
  d:=Div(i,NBBY)
  a[d]:=(x:=a[d] OR Shl(1, Mod(i,NBBY)))
ENDPROC x

PROC clrbit(a,i)
  DEF x, d
  d:=Div(i,NBBY)
  a[d]:=(x:=a[d] AND Not(Shl(1, Mod(i,NBBY))))
ENDPROC x

PROC isset(a,i) IS a[Div(i,NBBY)] AND Shl(1, Mod(i,NBBY))
PROC isclr(a,i) IS (a[Div(i,NBBY)] AND Shl(1, Mod(i,NBBY)))=0

PROC howmany(x,y) IS Div(x+y-1,y)
PROC roundup(x,y) IS Div(x+y-1,y)*y
PROC powerof2(x) IS ((x-1) AND x)=0
