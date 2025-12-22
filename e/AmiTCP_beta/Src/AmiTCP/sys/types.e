OPT MODULE, PREPROCESS
OPT EXPORT

#define caddr_t PTR TO CHAR
-> daddr_t was missing, it's a disk address
#define daddr_t LONG
#define dev_t LONG
#define ino_t LONG
#define off_t LONG

#define fd_mask LONG

CONST NBBY=8,
      FD_SETSIZE=64,
      NFDBITS=32

OBJECT fd_set
  bits[2]:ARRAY OF fd_mask
ENDOBJECT

PROC fd_set(n, p:PTR TO fd_set)
  DEF x, i
  x:=p.bits[i:=Div(n,NFDBITS)] OR Shl(1,Mod(n,NFDBITS))
  p.bits[i]:=x
ENDPROC x

#define FD_SET(n,p) fd_set(n,p)

PROC fd_clr(n, p:PTR TO fd_set)
  DEF x, i
  x:=p.bits[i:=Div(n,NFDBITS)] AND Not(Shl(1,Mod(n,NFDBITS)))
  p.bits[i]:=x
ENDPROC x

#define FD_CLR(n,p) fd_clr(n,p)

PROC fd_isset(n, p:PTR TO fd_set) IS
  p.bits[Div(n,NFDBITS)] AND Shl(1,Mod(n,NFDBITS))

#define FD_ISSET(n,p) fd_isset(n,p)

PROC fd_zero(p:PTR TO fd_set)
  p.bits[]:=0
  p.bits[1]:=0
ENDPROC

#define FD_ZERO(p) fd_zero(p)
