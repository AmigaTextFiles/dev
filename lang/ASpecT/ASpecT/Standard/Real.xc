/*
 * This module is designed to choose between 'double' or 'float'.
 *         !! Have a look at REAL_IS_TERM below !!
 *
 * #define REAL    double
 * #define REALPIC "%lf"
 *
 */

#define REAL    float
#define REALPIC "%f"

/*
 * Define REAL_IS_TERM only if your choice of REAL has the same size as TERM
 * If REAL_IS_TERM is defined the implementation is much more efficient.
 *
 */

#define REAL_IS_TERM





#ifndef REAL_IS_TERM
static unsigned CELLSIZE;
#endif

REAL
DEFUN(toREAL,(t),
      TERM t)
#ifdef REAL_IS_TERM
{  
   return (REAL)(*((REAL *)&t));
}
#else
{  REAL r;
   memcpy(&r,t->ARGS,sizeof(REAL));
   if(DZ_REF(t)) MDEALLOC(CELLSIZE,t);
   return r;
}
#endif

TERM
DEFUN(toTERM,(r),
      REAL r)
#ifdef REAL_IS_TERM
{
   return (TERM) (*((TERM *)&r));
}
#else
{  TERM t = NEW_CELL(CELLSIZE);
   memcpy(t->ARGS,&r,sizeof(REAL));
   return t;
}
#endif

XCOPY(xcopy_Real_real)
{  
#ifdef REAL_IS_TERM
   return A;
#else
   return CP(A);
#endif
}

XFREE(xfree_Real_real)
{
#ifndef REAL_IS_TERM
   if(DZ_REF(A)) MDEALLOC(CELLSIZE,A);
#endif
}

XEQ(x_X61_X61_Real_real) 
{ 
   return (TERM)(toREAL(A1) == toREAL(A2));
}
  
void EXFUN(Realread_real_0,(TERM,TERM *,TERM *,TERM *));
TERM EXFUN(Realwrite_real_0,(TERM,TERM));

XREAD(xread_Real_real)
{
   Realread_real_0(SYSI,OK,RES,SYSO);
}

XWRITE(xwrite_Real_real)
{
   *SYSO = Realwrite_real_0(SYSI,A);
   *OK = true;
}

#define BINOP(opn,op)                     \
TERM                                      \
DEFUN(opn,(a,b),                          \
      TERM a AND                          \
      TERM b)                             \
{                                         \
   return toTERM(toREAL(a) op toREAL(b)); \
}

BINOP(xx_Real_X62_X61_0,>=)
BINOP(xx_Real_X62_0    ,> )
BINOP(xx_Real_X60_X61_0,<=)
BINOP(xx_Real_X60_0    ,< )
BINOP(xx_Real_X47_0    ,/ )
BINOP(xx_Real_X42_0    ,* )
BINOP(xx_Real_X45_0    ,- )
BINOP(xx_Real_X43_0    ,+ )

TERM
DEFUN(Realnegate_0,(a),
      TERM a)
{
   return toTERM(-toREAL(a));
}

TERM
DEFUN(Realreal_0,(s),
      TERM s)
{ 
   char c[BLKSIZE]; REAL f;
   STRING_TERM_to_CHAR_ARRAY(s,BLKSIZE,c);
   free__RUNTIME_string(s);
   sscanf(c,REALPIC,&f);
   return toTERM(f);
}

TERM
DEFUN(Realstring_0,(r),
      TERM r)
{ 
   char *c; TERM s;
   c=(char *)malloc(BLKSIZE);
   sprintf(c,"%f",toREAL(r));
   return _RUNTIME_mkSTRING(c);
}

TERM
DEFUN(Realreal_1,(i),
      TERM i)
{
   return toTERM((REAL)((int)i*1.0));
}

void
DEFUN(Realinteger_0,(r,Ok,Res),
      TERM r   AND
      TERM *Ok AND
      TERM *Res)
{
  REAL rr = toREAL(r);
  int i = (int) rr;
  if (i<0) {
    if((rr-(REAL)i) <= (REAL)(-1.0)) *Ok = false; else *Ok = true;
    *Res = (TERM) i;
  } else {
    if((rr-(REAL)i) >= (REAL) 1.0) *Ok = false; else *Ok = true;
    *Res = (TERM) i;
  }
}

unsigned __XINIT_Real = 0;
void
DEFUN(Real_Xinitialize,(MODE),unsigned MODE)
{ if(__XINIT_Real == 0)__XINIT_Real = 1;
#ifdef REAL_IS_TERM
  if(sizeof(REAL)!=sizeof(TERM)) {
    printf("The implementation of Real assumes sizeof(REAL)==sizeof(TERM)\n");
    printf("but on this machine sizeof(REAL) == %d and sizeof(TERM) == %d\n",
           sizeof(REAL),sizeof(TERM));
    printf("So do not define REAL_IS_TERM in Real.xc!\n");
    exit(255);
  }
#else
  CELLSIZE = 1;
  while((CELLSIZE*sizeof(TERM)) < sizeof(REAL)) CELLSIZE++;
#endif
}

