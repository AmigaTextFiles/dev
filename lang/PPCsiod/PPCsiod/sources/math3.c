/* Scheme In One Define.
 
The garbage collector, the name and other parts of this program are

 *                     COPYRIGHT (c) 1989 BY                              *
 *      PARADIGM ASSOCIATES INCORPORATED, CAMBRIDGE, MASSACHUSETTS.       *

Conversion  to  full scheme standard, characters, vectors, ports, complex &
rational numbers, and other major enhancments by

 *      Scaglione Ermanno, v. Pirinoli 16 IMPERIA P.M. 18100 ITALY        * 

Permission  to use, copy, modify, distribute and sell this software and its
documentation  for  any purpose and without fee is hereby granted, provided
that  the  above  copyright  notice appear in all copies and that both that
copyright   notice   and   this  permission  notice  appear  in  supporting
documentation,  and that the name of Paradigm Associates Inc not be used in
advertising or publicity pertaining to distribution of the software without
specific, written prior permission.

PARADIGM  DISCLAIMS  ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
ALL  IMPLIED  WARRANTIES  OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL
PARADIGM  BE  LIABLE  FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER
IN  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

*/

#include <stdio.h>
#include <error.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <setjmp.h>
#include <signal.h>
#include <math.h>
#include <limits.h>

#include "siod.h"

LISP plus(LISP args)
{LISP l,s,res;
 res=intcons(0);
 for(l=args;NNULLP(l);l=cdr(l))
   {s = car(l);
    if (NNUMBERP(s))
      err("+",s,ERR_GEN_ARG | ERR_NNUM);
    res=plus2(res,s);}
 return(res);}

LISP ltimes(LISP args)
{LISP l,s,res;
 res=intcons(1);
 for(l=args;NNULLP(l);l=cdr(l))
   {s = car(l);
    if (NNUMBERP(s))
      err("*",s,ERR_GEN_ARG | ERR_NNUM);
    res=times2(res,s);}
 return(res);}

LISP difference(LISP args)
{LISP l,s,res;
 if(NULLP(args))
  err("-",NIL,ERR_FIRST | ERR_NNUM);
 if(NULLP(cdr(args)))
   res=flocons(0.);
 else
   {res=car(args);
    if (NNUMBERP(res))
      err("-",res,ERR_GEN_ARG | ERR_NNUM);
    args=cdr(args);}
 for(l=args;NNULLP(l);l=cdr(l))
   {s = car(l);
    if (NNUMBERP(s))
      err("-",s,ERR_GEN_ARG | ERR_NNUM);
    res=minus2(res,s);}
 return(res);}

LISP quotient(LISP args)
{LISP l,s,res;
 if(NULLP(args))
   err("/",NIL,ERR_FIRST | ERR_NNUM);
 if(NULLP(cdr(args)))
   res=flocons(1.);
 else
  {res=car(args);
   args=cdr(args);}
 for(l=args;NNULLP(l);l=cdr(l))
   {s = car(l);
    if (NNUMBERP(s))
      err("/",s,ERR_GEN_ARG | ERR_NNUM);
    res=divide2(res,s);}
 return(res);}

LISP remainder(LISP x,LISP y)
{LISP res;
 double tmp;
 x = tofloat(x);
 y = tofloat(y);
 if (NFLONUMP(x)||(modf(FLONM(x),&tmp)!=0.)) 
  err("remainder",x,ERR_FIRST | ERR_NINT);
 if (NFLONUMP(y)||(modf(FLONM(y),&tmp)!=0.)) 
  err("remainder",y,ERR_SECOND | ERR_NINT);
 res=flocons(fmod(FLONM(x),FLONM(y)));
 return (res);}

LISP modulo(LISP x,LISP y)
{LISP z;
 double res;
 x = tofloat(x);
 y = tofloat(y);
 if (NFLONUMP(x)||(modf(FLONM(x),&res)!=0.)) 
  err("modulo",x,ERR_FIRST | ERR_NINT);
 if (NFLONUMP(y)||(modf(FLONM(y),&res)!=0.)) 
  err("modulo",y,ERR_SECOND | ERR_NINT);
 res=fmod(fabs(FLONM(x)),fabs(FLONM(y)));
 if(FLONM(y)<0)
   res=-res;
 z=flocons(res);
 return(z);}

LISP expt(LISP x,LISP y)
{LISP z;
 errno=0;
 if(RATNUMP(x))
   {if(RATNUMP(y))
      {if((RATNUM(x)<0))
         {z = demoivre(pow((double)((double)RATNUM(x)/(double)RATDEN(y)),
                           (double)RATNUM(y)),
                       0.,
                       (double)(1./(double)RATDEN(y)));}
       else
         z = ratcons(pow((double)RATNUM(x),
                         (double)RATNUM(y)/(double)RATDEN(y)),
                     pow((double)RATDEN(x),
                         (double)RATNUM(y)/(double)RATDEN(y)));}
    else
      {y = tofloat(y);
       if(FLONUMP(y))
         {z = ratcons(pow((double)RATNUM(x),FLONM(y)),
                      pow((double)RATDEN(x),FLONM(y)));}
       else
         err("expt",y,ERR_SECOND | ERR_NNUM);}}
 else
   {x = tofloat(x);
    if(FLONUMP(x))
      {if(RATNUMP(y))
         {if((FLONM(x)<0))
             {z = demoivre(pow(FLONM(x),(double)RATNUM(y)),
                           0.,
                           (double)(1./(double)RATDEN(y)));}
          else
              z = flocons(pow(FLONM(x),
                          (double)RATNUM(y)/(double)RATDEN(y)));}
       else
         {y = tofloat(y);
          if(FLONUMP(y))
            {z = flocons(pow(FLONM(x),FLONM(y)));}
          else
            err("expt",y,ERR_SECOND | ERR_NNUM);}}
    else
      {y = tofloat(y);
       if(NFLONUMP(y))err("expt",y,ERR_SECOND | ERR_NNUM);
       if(COMPNUMP(x))
         {z = demoivre((double)COMPRE(x),(double)COMPIM(x),FLONM(y));}
       else
          err("expt",y,ERR_FIRST | ERR_NNUM);}}
 if(errno!=0)
   raise(SIGFPE);
 return(z);}

LISP demoivre(double ar,double ai,double e)
{double tmp1,tmp2,tmp3,tmp4;
 tmp1 = sqrt(pow((( ar*ar)+(ai*ai)),e));
 tmp2 = atan2(ai,ar)*e;
 tmp3 = cos(tmp2);
 tmp4 = sin(tmp2);
 return(compcons((float)(tmp1*tmp3),(float)(tmp1*tmp4)));}

LISP random(LISP x)
{LISP z;
 double r;
 x = tofloat(x);
 if (NFLONUMP(x)) err("random",x,ERR_GEN_ARG | ERR_NNUM);
 r = (double) rand();
 z = flocons(fmod(r,FLONM(x)));  
 return (z);}

LISP randomize(LISP x)
{
 x = tofloat(x);
 if (NFLONUMP(x)) err("randomize",x,ERR_GEN_ARG | ERR_NNUM);
 if(FLONM(x)==0.)
   srand(clock());
 else
   srand((unsigned long)FLONM(x));
 return (truth);}
