#ifndef	LIBRARIES_MATHFFP_H
#define	LIBRARIES_MATHFFP_H 1

#ifndef PI
#define PI	  ( 3.141592653589793)
#endif
#define TWO_PI	  (( 2) * PI)
#define PI2	  (PI / ( 2))
#define PI4	  (PI / ( 4))
#ifndef E
#define E	  ( 2.718281828459045)
#endif
#define LOG10	  ( 2.302585092994046)
#define FPTEN	  ( 10.0)
#define FPONE	  ( 1.0)
#define FPHALF	  ( 0.5)
#define FPZERO	  ( 0.0)
#define trunc(x)  ( (x))
#define round(x)  ( ((x) + 0.5))
#define itof(i)   ( (i))
#define	fabs	SPAbs
#define floor	SPFloor
#define	ceil	SPCeil
#define	tan	SPTan
#define	atan	SPAtan
#define cos	SPCos
#define acos	SPAcos
#define sin	SPSin
#define asin	SPAsin
#define exp	SPExp
#define pow(a,b)	SPPow((b),(a))
#define log	SPLog
#define log10	SPLog10
#define sqrt	SPSqrt
#define	sinh	SPSinh
#define cosh	SPCosh
#define tanh	SPTanh
#endif	
