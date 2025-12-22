/* vacall function for m68k CPU */

/*
 * Copyright 1995 Bruno Haible, <haible@ma2s2.mathematik.uni-karlsruhe.de>
 *
 * This is free software distributed under the GNU General Public Licence
 * described in the file COPYING. Contact the author if you don't have this
 * or can't live with it. There is ABSOLUTELY NO WARRANTY, explicit or implied,
 * on this software.
 */

#include "vacall.h.in"

register void*	sret	__asm__("a1");
register int	iret	__asm__("d0");
register int	iret2	__asm__("d1");
register int	pret	__asm__("a0");	/* some compilers return pointers in a0 */
register float	fret	__asm__("d0");	/* d0 */
register double	dret	__asm__("d0");	/* d0,d1 */

void /* the return type is variable, not void! */
vacall (__vaword firstword)
{
  __va_alist list;
  /* Prepare the va_alist. */
  list.flags = 0;
  list.aptr = (long)&firstword;
  list.raddr = (void*)0;
  list.rtype = __VAvoid;
  list.structraddr = sret;
  /* Call vacall_function. The macros do all the rest. */
  (*vacall_function) (&list);
  /* Put return value into proper register. */
  switch (list.rtype)
    {
      case __VAvoid:	break;
      case __VAchar:	iret = list.tmp._char; break;
      case __VAschar:	iret = list.tmp._schar; break;
      case __VAuchar:	iret = list.tmp._uchar; break;
      case __VAshort:	iret = list.tmp._short; break;
      case __VAushort:	iret = list.tmp._ushort; break;
      case __VAint:	iret = list.tmp._int; break;
      case __VAuint:	iret = list.tmp._uint; break;
      case __VAlong:	iret = list.tmp._long; break;
      case __VAulong:	iret = list.tmp._ulong; break;
      case __VAfloat:
        if (list.flags & __VA_SUNCC_FLOAT_RETURN)
          dret = (double)list.tmp._float;
        else
          fret = list.tmp._float;
        break;
      case __VAdouble:	dret = list.tmp._double; break;
      case __VAvoidp:	pret = iret = (long)list.tmp._ptr; break;
      case __VAstruct:
        if (list.flags & __VA_PCC_STRUCT_RETURN)
          { /* pcc struct return convention */
            pret = iret = (long) list.raddr;
          }
        else
          { /* normal struct return convention */
            if (list.flags & __VA_REGISTER_STRUCT_RETURN)
              switch (list.rsize)
                { case sizeof(char):  iret = *(unsigned char *) list.raddr; break;
                  case sizeof(short): iret = *(unsigned short *) list.raddr; break;
                  case sizeof(int):   iret = *(unsigned int *) list.raddr; break;
                  case 2*sizeof(__vaword):
                    iret  = ((__vaword *) list.raddr)[0];
                    iret2 = ((__vaword *) list.raddr)[1];
                    break;
                  default:            break;
                }
          }
        break;
    }
}
