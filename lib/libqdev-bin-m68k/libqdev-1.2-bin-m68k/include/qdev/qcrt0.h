/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * qcrt0.h
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'QCRT0'  is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'QCRT0'  is   distributed  in  the  hope  that  it  will  be useful,
 * but  WITHOUT  ANY  WARRANTY;  without  even  the implied warranty of
 * MERCHANTABILITY  or  FITNESS  FOR  A  PARTICULAR  PURPOSE.  See  the
 * GNU General Public License for more details.
 *
 * You  should  have  received a copy of the GNU General Public License
 * along  with  'qdev';  if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301   USA
 *
 * --- VERSION --------------------------------------------------------
 *
 * $VER: qcrt0.h 1.00 (17/04/2014) QCRT0
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * Minimalistic startup code with registers preservation - header file.
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___QCRT0_H_INCLUDED___
#define ___QCRT0_H_INCLUDED___

#include <exec/execbase.h>

#define QDEV_QCRT_IDVALUE 0x51435254     /* 'QCRT' ID/argv[0]               */
#define QDEV_QCRT_DDIST   0x00007FFE     /* Data distance                   */
#define QDEV_QCRT_ENTRY   ___qcrt_entry_ /* Entry point symbol              */
#define QDEV_QCRT_INIT    ___qcrt_init_  /* High level entry                */

/*
 * Flags of 'cr_f'.
*/
#define QDEV_QCRT_F_NOA4  0x80000000     /* USER: Do not set a4 register    */

/*
 * Methods that may appear in 'cr_f' (first 8 bits).
*/
#define QDEV_QCRT_M_BOOT 1               /* Code attempted in bootstrap     */
#define QDEV_QCRT_M_CLI  2               /* Code started by the Shell       */
#define QDEV_QCRT_M_WB   4               /* Code started by the Workbench   */

/*
 * Startup type check. Pass 'argv' to this macro and
 * if true then startup is 'qcrt0.o'.
*/
#define QDEV_QCRT_CHECK(x)                    \
(x && (*(LONG *)x == (LONG)x + sizeof(LONG)))

/*
 * Simple check to see if code should be considered
 * a module.
*/
#define QDEV_QCRT_ISMOD()                     \
({                                            \
  struct ExecBase *_eb =                      \
                (*((struct ExecBase **) 4));  \
  _eb->ThisTask->tc_Node.ln_Type == NT_TASK;  \
})

/*
 * This macro allows to leave program at any time as
 * if it ended normally, except that all allocations
 * made will stay intact.
*/
#define QDEV_QCRT_EXIT(cr)                    \
({                                            \
  asm("\t	move.l	%0,sp"                \
    "\n\t	jmp	(%1)"                 \
             : : "m" ((cr)->cr.m68k->a[7]),   \
                 "a" ((cr)->cr.m68k->d[7]));  \
})

/*
 * Handy new instance macro.
*/
#define QDEV_QCRT_NEW(cr, code)               \
  if (crt_newinstance(cr))                    \
  {                                           \
    code                                      \
    crt_freeinstance(cr);                     \
  }

/*
 * Handy entry/exit method macro.
*/
#define QDEV_QCRT_METHOD(cr, code)            \
  crt_initmethod(cr);                         \
  code                                        \
  crt_exitmethod(cr);

/*
 * Handy argument parser macro.
*/
#define QDEV_QCRT_ARGV(cr, argc, argv, code)  \
  crt_createargv(cr, &argc, &argv);           \
  code                                        \
  crt_destroyargv(cr, &argc, &argv);

/*
 * Code selection macros for a given launch method.
*/
#define QDEV_QCRT_MTHEMIT(x)                  \
        QDEV_QCRT_MTHEMIT2(x)
#define QDEV_QCRT_MTHEMIT2(x) _##x##_

#define QDEV_QCRT_MTHGOTO(lab)                \
  goto QDEV_QCRT_MTHEMIT(lab)

#define QDEV_QCRT_MTHCODE(lab, code)          \
  case lab:                                   \
  QDEV_QCRT_MTHGOTO(lab);                     \
  QDEV_QCRT_MTHEMIT(lab):                     \
  {                                           \
    code                                      \
    break;                                    \
  }

#ifndef QDEV_QCRT_MTHLOCAL
#define QDEV_QCRT_MTHLOCAL(va...) __label__ va
#endif

#define QDEV_QCRT_MTHSEL(cr, code)            \
({                                            \
  QDEV_QCRT_MTHLOCAL                          \
  (                                           \
    QDEV_QCRT_MTHEMIT(QDEV_QCRT_M_BOOT),      \
    QDEV_QCRT_MTHEMIT(QDEV_QCRT_M_CLI),       \
    QDEV_QCRT_MTHEMIT(QDEV_QCRT_M_WB)         \
  );                                          \
  switch((cr)->cr_f & 0x000000FF)             \
  {                                           \
    code                                      \
    default:                                  \
  };                                          \
})

/*
 * Workbench startup message related macros. Nothing
 * fancy. Just declare a symbol and attach pointer.
*/
#define QDEV_QCRT_WBMSGDECL(sym)              \
  struct WBStartup *sym
#define QDEV_QCRT_WBMSGADDR(cr, sym)          \
sym = (struct WBStartup *)(cr)->cr.m68k->a[0]



struct qcrtregs
{
  LONG     *cr_a;                        /* Argv[0] address (compatibility) */
  LONG      cr_id;                       /* Structure identification value  */
  LONG      cr_n;                        /* NULL                            */
  LONG      cr_f;                        /* Additional control flags (feat) */
  union
  {
    struct
    {
      LONG   d[8];                       /* Motorola m68k data registers    */
      LONG  *a[8];                       /* Motorola m68k address registers */
    } *m68k;
  } cr;
};



QDEVDECL( int main(int, char **); )
QDEVDECL( LONG QDEV_QCRT_ENTRY(void); )
QDEVDECL( void QDEV_QCRT_INIT(REGARG(void *, a0)); )

QDEVDECL( LONG crt_newinstance(struct qcrtregs *); )
QDEVDECL( void crt_freeinstance(struct qcrtregs *); )

QDEVDECL( void crt_initmethod(struct qcrtregs *); )
QDEVDECL( void crt_exitmethod(struct qcrtregs *); )

QDEVDECL( LONG crt_createargv(
               struct qcrtregs *, int *, char ***); )
QDEVDECL( void crt_destroyargv(
               struct qcrtregs *, int *, char ***); )

#endif /* ___QCRT0_H_INCLUDED___ */
