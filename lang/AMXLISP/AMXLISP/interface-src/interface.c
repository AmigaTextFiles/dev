/* interface -new functions to get this interface working */
/* (C) Copyright Francois ROUAIX 1987 */
#include "xlisp.h"


/* peeks and pokes for bytes, words, and longs */

LVAL  xli_mem_b()
{
   unsigned char *ptr;
   LVAL  val;

   ptr = (unsigned char *)getfixnum(xlgafixnum());
   if (!moreargs())  /* read */
      { return(cvfixnum((FIXTYPE)*ptr)) ; }
   else
      { val = xlgafixnum() ;
        xllastarg();
        *ptr = (unsigned char)(getfixnum(val));
        return(val);
      };
}

LVAL  xli_mem_w()
{
   unsigned short *ptr;
   LVAL  val;

   ptr = (unsigned short *)getfixnum(xlgafixnum());
   if (!moreargs())  /* read */
      { return(cvfixnum((FIXTYPE)*ptr));}
   else
      { val = xlgafixnum() ;
        xllastarg();
        *ptr = (unsigned short)(getfixnum(val));
        return(val);
      };
}

LVAL  xli_mem_l()
{
   FIXTYPE *ptr;
   LVAL  val;

   ptr = (FIXTYPE *)getfixnum(xlgafixnum());
   if (!moreargs())  /* read */
      { return(cvfixnum(*ptr));}
   else
      { val = xlgafixnum() ;
        xllastarg();
        *ptr = getfixnum(val);
        return(val);
      };
}

/* callasm: we call this function with */
/*   offset: the offset of the function in the library */
/*   base:   the base of the library, to be put in A6  */
/*   lreg:   where we shall put the arguments before calling */
/*   larg:   the list of arguments : integers (ie pointers or integers) */
/*                        and/or strings */
/* callasm always returns an XLISP object of integer type */
/*         this object in either a real integer or a pointer */
/* in C, we can do all the argument handling (especially on strings) */
/* but we'll have to call assembler to do the registers work */
extern FIXTYPE doit();

LVAL  callasm()

{  FIXTYPE offset,base;
   LVAL lreg,larg;
   FIXTYPE result;
   offset = (FIXTYPE)getfixnum(xlgafixnum()); /* get the offset */
   base   = (FIXTYPE)getfixnum(xlgafixnum()); /* get the base */
   if (moreargs())      /* there are arguments */
      {   lreg = xlgalist();
          larg = xlgalist();
          xllastarg();
          result = doit(offset,base,lreg,larg);
      }
   else {   /* no arguments */
         result = doit(offset,base,NIL,NIL);
        };
   return(cvfixnum(result));
}

LVAL  xli_ctos(args)
   LVAL  args;

{
   FIXTYPE ptr;
   ptr = (FIXTYPE)getfixnum(xlgafixnum())  ; /* get the pointer */
   xllastarg();
   return(cvstring((char *)ptr));
}


