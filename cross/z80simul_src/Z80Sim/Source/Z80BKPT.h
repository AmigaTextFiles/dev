/*********************************************************
**
**    Z80BKPT.H      Z80 simulator breakpoint handling
**                   code.
**
**    PATHNAME:      CPGM/Z80/Mark2Src/Z80BKPT.h
**
**    LAST CHANGED:  04/23/98
**
***********************************************************/

#ifndef   Z80BKPT_H
# define  Z80BKPT_H  1

struct BreakPoint  {

   UWORD    BkptFlag;
   UWORD    BkptIndx;
   UWORD    reg[ 28 ];
};


#ifdef ALLOCATE

VISIBLE struct BreakPoint breakpoint[ MAXBKPT ];

#else

IMPORT  struct BreakPoint breakpoint[];

#endif

# define  SETBKPT      1     /* BkptFlag values! */
# define  CLRBKPT      2
# define  NONBKPT      3

# define  REGBC        18    /* Single registers are 0 -> 17 */
# define  REGBCP       19    /* BkptIndx values!             */
# define  REGDE        20
# define  REGDEP       21
# define  REGHL        22
# define  REGHLP       23
# define  REGIX        24
# define  REGIY        25
# define  REGSP        26
# define  REGPC        27

# define  RESET_BKPT   0xFFFF    /* Breakpoint disabled!!    */
# define  LAST_BKPT    0xFFFE
# define  BYTE_MASK    0x00FF    /* for the single registers */

#endif

/* ---------------------- End of Z80BKPT.h ------------------------- */
