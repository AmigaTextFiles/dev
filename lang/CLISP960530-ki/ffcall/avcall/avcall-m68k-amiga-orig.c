#ifndef _avcall_m68k_amiga_c				/*-*- C -*-*/
#define _avcall_m68k_amiga_c "$Id: avcall-m68k-amiga.c,v 1.1.1.1 1995/09/10 10:59:00 marcus Exp $"
/**
  Copyright 1993 Bill Triggs, <bill@robots.oxford.ac.uk>,
  Oxford University Robotics Group, Oxford OX1 3PJ, U.K.

  Copyright 1995 Bruno Haible, <haible@ma2s2.mathematik.uni-karlsruhe.de>

  This is free software distributed under the GNU General Public
  Licence described in the file COPYING. Contact the author if
  you don't have this or can't live with it. There is ABSOLUTELY
  NO WARRANTY, explicit or implied, on this software.
**/
/*----------------------------------------------------------------------
  !!! THIS ROUTINE MUST BE COMPILED gcc -O !!!

  Foreign function interface for a m68k Amiga with gcc.

  This calls a C function with an argument list built up using macros
  defined in av_call.h.

  M68k Argument Passing Conventions:

  All arguments are passed on the stack with word alignment. Doubles take
  two words. Structure args are passed as true structures embedded in the
  argument stack. To return a structure, the called function copies the
  return value to the address supplied in register "a1". Gcc without
  -fpcc-struct-return returns <= 4 byte structures as integers.

  Some specific arguments may be passed in registers.

  Compile this routine with gcc -O (or -O2 or -g -O) to get the right
  register variables, or use the assembler version.
  ----------------------------------------------------------------------*/
#include "avcall.h.in"

#define RETURN(TYPE,VAL)	(*(TYPE*)l->raddr = (TYPE)(VAL))

int
__builtin_avcall(av_alist* l)
{
  register __avword*	sp	__asm__("sp");  /* C names for registers */
  register __avword*	sret	__asm__("a1");	/* structure return pointer */
  register __avword	iret	__asm__("d0");
  register __avword	iret2	__asm__("d1");
  register float	fret	__asm__("d0");	/* d0 */
  register double	dret	__asm__("d0");	/* d0,d1 */

  __avword regspace[3+4];		/* temp space for saving registers */
  __avword space[__AV_ALIST_WORDS];	/* space for callee's stack frame */
  __avword* argframe = sp;		/* stack offset for argument list */
  int arglen = l->aptr - l->args;
  int i;

  for (i = 0; i < arglen; i++)		/* push function args onto stack */
    argframe[i] = l->args[i];

  if (l->rtype == __AVstruct)		/* push struct return address */
    l->regargs[8+1] = (__avword)(l->raddr);

  /* Save some registers by hand. There is no way to persuade gcc that
   * they are clobbered by the big moveml below.
   */
  __asm__("moveml #x470f,%0" /* 0x470f == d0-d3/a0-a2/a6 */
          : "=m" (regspace[0]) : );

  __asm__("movel %0,sp@-" : : "g" (&&return_here)); /* prepare function call */
  __asm__("movel %0,sp@-" : : "g" (l->func));

					/* put some arguments into registers */
  __asm__("moveml %0,#0x7fff" /* 0x7fff == d0-d7/a0-a6 */
          :
          : "m" (l->regargs[0])
          : /*"d0","d1","d2","d3",*/"d4","d5","d6","d7",/*"a0","a1","a2",*/"a3","a4","a5"/*,"a6"*/
	    /* This long clobber list ensures that the function prologue
	     * contains a                 "moveml #0x3f3e,sp@-"  d2-d7/a2-a6
	     * and the epilogue contains  "moveml sp@+,#0x7cfc"  d2-d7/a2-a6
	     */
         );

  __asm__("rts");		/* call function */
  return_here:			/* function returns here */

  __asm__("moveml %0,#x470f" /* 0x470f == d0-d3/a0-a2/a6 */
          : : "m" (regspace[0]) );	/* restore some registers */

  switch (l->rtype)			/* save return value */
  {
  case __AVvoid:					break;
  case __AVword:	RETURN(__avword,	iret);	break;
  case __AVchar:	RETURN(char,		iret);	break;
  case __AVschar:	RETURN(signed char,	iret);	break;
  case __AVuchar:	RETURN(unsigned char,	iret);	break;
  case __AVshort:	RETURN(short,		iret);	break;
  case __AVushort:	RETURN(unsigned short,	iret);	break;
  case __AVint:		RETURN(int,		iret);	break;
  case __AVuint:	RETURN(unsigned int,	iret);	break;
  case __AVlong:	RETURN(long,		iret);	break;
  case __AVulong:	RETURN(unsigned long,	iret);	break;
  case __AVfloat:
    if (l->flags & __AV_SUNCC_FLOAT_RETURN)
      RETURN(float, (float)dret);
    else
      RETURN(float, fret);
    break;
  case __AVdouble:	RETURN(double,		dret);	break;
  case __AVvoidp:	RETURN(void*,		iret);	break;
  case __AVstruct:
    if (l->flags & __AV_PCC_STRUCT_RETURN)
    { /* pcc struct return convention: need a  *(TYPE*)l->raddr = *(TYPE*)i;  */
      switch (l->rsize)
      {
      case sizeof(char):  RETURN(char,	*(char*)iret);	break;
      case sizeof(short): RETURN(short,	*(short*)iret);	break;
      case sizeof(int):	  RETURN(int,	*(int*)iret);	break;
      case sizeof(double):
	((int*)l->raddr)[0] = ((int*)iret)[0];
	((int*)l->raddr)[1] = ((int*)iret)[1];
	break;
      default:
	{
	  int n = (l->rsize + sizeof(__avword)-1)/sizeof(__avword);
	  while (--n >= 0)
	    ((__avword*)l->raddr)[n] = ((__avword*)iret)[n];
	}
	break;
      }
    }
    else
    { /* normal struct return convention */
      if (l->flags & __AV_REGISTER_STRUCT_RETURN)
	switch (l->rsize)
	{
	case sizeof(char):  RETURN(char,  iret);	break;
	case sizeof(short): RETURN(short, iret);	break;
	case sizeof(int):   RETURN(int,   iret);	break;
	case 2*sizeof(__avword):
	  ((__avword*)l->raddr)[0] = iret;
	  ((__avword*)l->raddr)[1] = iret2;
	  break;
	default:					break;
	}
    }
    break;
  default:						break;
  }
  return 0;
}

#endif /*_avcall_m68k_amiga_c */
