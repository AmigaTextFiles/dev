/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * qdev.h
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'QHEAD'  is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'QHEAD'  is   distributed  in  the  hope  that  it  will  be useful,
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
 * $VER: qdev.h 1.506 (12/09/2014) QHEAD
 * AUTH: BCD, Contributors
 *
 * --- COMMENT --------------------------------------------------------
 *
 *                         Main library header.
 *                        ======================
 *
 * The only supported compiler is 'gcc' for now. This may change in the
 * future.
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___QDEV_H_INCLUDED___
#define ___QDEV_H_INCLUDED___



/*
 * ------------------------ Decls and protos -------------------------
*/

#include <stdarg.h>

#ifdef __amigaos__
#ifndef ___QDEV_NOEXTDECLS
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/resident.h>
#include <exec/ports.h>
#include <exec/devices.h>
#include <exec/semaphores.h>
#include <devices/trackdisk.h>
#include <dos/dosextens.h>
#include <dos/exall.h>
#include <dos/filehandler.h>
#include <intuition/intuition.h>
#include <intuition/screens.h>
#include <graphics/text.h>
#include <graphics/rastport.h>
#endif


#undef __caddr
#define __caddr __attribute__((section(".text")))
#undef __nifunc
#define __nifunc __attribute__((no_instrument_function))
#undef __register
#define __register register
#undef __inline
#define __inline inline
#ifdef resident
#undef __saveds
#define __saveds
#define __SAVEA4(val) val = QDEV_HLP_GETREG(a4)
#define __LOADA4(val) QDEV_HLP_SETREG(a4, val)
#else
#define __SAVEA4(val)
#define __LOADA4(val)
#endif

#define REGARG(var, reg)                      \
  __register var __asm(QDEV_HLP_MKSTR(reg))
#define REGVAR(var, reg)                      \
  register var asm(QDEV_HLP_MKSTR(reg))



#define LP2IEEE(offs, rt, name, t1, v1, r1,   \
                         t2, v2, r2, bt, bn)  \
({                                            \
  t1 _##name##_v1 = (v1);                     \
  t2 _##name##_v2 = (v2);                     \
  {                                           \
    register rt _##name##_re __asm("d0");     \
    register struct Library *_##name##_bn     \
       __asm("a6") = (struct Library *)(bn);  \
    register t1 _n1 __asm(                    \
         QDEV_HLP_MKSTR(r1)) = _##name##_v1;  \
    register t2 _n2 __asm(                    \
         QDEV_HLP_MKSTR(r2)) = _##name##_v2;  \
    asm volatile ("jsr a6@(-"#offs":W)"       \
    : "=r" (_##name##_re)                     \
    : "r" (_##name##_bn), "r"(_n1), "r"(_n2)  \
    : "a0", "a1", "d0", "d1", "d2", "d3",     \
              "fp0", "fp1", "cc", "memory");  \
    _##name##_re;                             \
  }                                           \
})



/*
 * This small subset of math functions helps to avoid
 * global base references 'gcc' would generate.
*/
#define _IEEEXPAdd(a, b)                      \
  (LP2IEEE(0x42, MFARITH, _IEEEXPAdd,         \
  MFARITH, a, MFREG1, MFARITH, b, MFREG2,     \
  , MFBBASE))
#define _IEEEXPSub(a, b)                      \
  (LP2IEEE(0x48, MFARITH, _IEEEXPSub,         \
  MFARITH, a, MFREG1, MFARITH, b, MFREG2,     \
  , MFBBASE))
#define _IEEEXPMul(a, b)                      \
  (LP2IEEE(0x4E, MFARITH, _IEEEXPMul,         \
  MFARITH, a, MFREG1, MFARITH, b, MFREG2,     \
  , MFBBASE))
#define _IEEEXPDiv(a, b)                      \
  (LP2IEEE(0x54, MFARITH, _IEEEXPDiv,         \
  MFARITH, a, MFREG1, MFARITH, b, MFREG2,     \
  , MFBBASE))
#define _IEEEXPFix(a)                         \
  (LP2IEEE(0x1E, LONG,    _IEEEXPFix,         \
  MFARITH, a, MFREG1, LONG,    0, MFREG2,     \
  , MFBBASE))
#define _IEEEXPFlt(a)                         \
  (LP2IEEE(0x24, MFARITH, _IEEEXPFlt,         \
  LONG,    a, MFREG1, LONG,    0, MFREG2,     \
  , MFBBASE))
#define _IEEEXPCmp(a, b)                      \
  (LP2IEEE(0x2A, LONG,    _IEEEXPCmp,         \
  MFARITH, a, MFREG1, MFARITH, b, MFREG2,     \
  , MFBBASE))
#define _IEEEXPCle(a, b)                      \
({                                            \
  MFARITH ___m_a = a;                         \
  MFARITH ___m_b = b;                         \
  ((_IEEEXPCmp(___m_a, ___m_b) == 0)   ||     \
       (_IEEEXPCmp(___m_a, ___m_b) < 0));     \
})
#define _IEEEXPCge(a, b)                      \
({                                            \
  MFARITH ___m_a = a;                         \
  MFARITH ___m_b = b;                         \
  ((_IEEEXPCmp(___m_a, ___m_b) == 0)   ||     \
       (_IEEEXPCmp(___m_a, ___m_b) > 0));     \
})



#else  /* !__amigaos__           */
#ifndef ___QDEV_NOEXTDECLS
/*
 * Stub structures so that non-Amiga platforms will
 * be able to crawl through this file without probs.
*/
struct MemChunk
{
  int dummy;
};
struct MemList
{
  int dummy;
};
struct Resident
{
  int dummy;
};
struct MsgPort;
struct IOExtTD;
struct ExAllData;
struct DosEnvec
{
  int dummy;
};
struct DosPacket;
struct DosList;
struct Screen;
struct Window;
struct TextFont;
struct TextAttr
{
  int dummy;
};
struct Library;
struct IntuiMessage;
struct BitMap;
struct Image;
struct SignalSemaphore
{
  int dummy;
};
struct RastPort;
struct ColorMap;
struct MinNode
{
  int dummy;
};
struct MinList
{
  int dummy;
};
struct Process;
struct Task;
struct List;
struct MsgPort
{
  int dummy;
};
struct Hook
{
  int dummy;
};
struct DosList
{
  int dummy;
};
struct FileSysStartupMsg
{
  int dummy;
};
struct StandardPacket
{
  int dummy;
};
#endif



#undef __caddr
#define __caddr __attribute__((section(".text")))
#undef __nifunc
#define __nifunc __attribute__((no_instrument_function))
#undef __interrupt
#define __interrupt
#undef __register
#define __register
#undef __inline
#define __inline
#undef __asm
#define __asm(reg)
#undef __saveds
#define __saveds

#define REGARG(var, reg) var
#define REGVAR(var, reg) var



#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif
#ifndef NULL
#define NULL 0L
#endif



/*
 * Small math stubs.
*/
#define _IEEEXPAdd(a, b) ((MFARITH)(a) + (MFARITH)(b))
#define _IEEEXPSub(a, b) ((MFARITH)(a) - (MFARITH)(b))
#define _IEEEXPMul(a, b) ((MFARITH)(a) * (MFARITH)(b))
#define _IEEEXPDiv(a, b) ((MFARITH)(a) / (MFARITH)(b))
#define _IEEEXPFix(a)    ((LONG)(a))
#define _IEEEXPFlt(a)    ((MFARITH)(a))
#define _IEEEXPCmp(a, b)                      \
({                                            \
  MFARITH ___m_a = (MFARITH)(a);              \
  MFARITH ___m_b = (MFARITH)(b);              \
  ((___m_a == ___m_b) ? 0 :                   \
    (___m_a < ___m_b) ? -1 : 1);              \
})
#define _IEEEXPCle(a, b) ((MFARITH)(a) <= (MFARITH)(b))
#define _IEEEXPCge(a, b) ((MFARITH)(a) >= (MFARITH)(b))



typedef void               *APTR;
typedef long               LONG;
typedef unsigned long      ULONG;
typedef short              WORD;
typedef unsigned short     UWORD;
typedef signed char        BYTE;
typedef unsigned char      UBYTE;
typedef short              BOOL;
typedef long               BPTR;

#endif /* !__amigaos__           */

#if (!defined(QUAD) && !defined(UQUAD))
#ifdef ___QDEV_NOQUADCOMPILER
typedef long               QUAD;
typedef unsigned long      UQUAD;
#else
typedef long long          QUAD;
typedef unsigned long long UQUAD;
#endif
#endif

/*
 * Virtual datatypes!
*/
struct ___VQUAD
{
  LONG  vq_hi;
  ULONG vq_lo;
};

typedef struct ___VQUAD    VQUAD;

struct ___VUQUAD
{
  ULONG vuq_hi;
  ULONG vuq_lo;
};

typedef struct ___VUQUAD   VUQUAD;

struct ___VQ128
{
  LONG  vhi_hi;
  ULONG vhi_lo;
  ULONG vlo_hi;
  ULONG vlo_lo;
};

typedef struct ___VQ128    VQ128;

struct ___VUQ128
{
  ULONG vuhi_hi;
  ULONG vuhi_lo;
  ULONG vulo_hi;
  ULONG vulo_lo;
};

typedef struct ___VUQ128   VUQ128;


#undef REGISTER
#ifdef ___QDEV_NOREGARGS
#define REGISTER
#else
#define REGISTER register
#endif

#ifdef ___QDEV_DOUBLEPREC
#define MFARITH double
#define MFBBASE MathIeeeDoubBasBase
#define MFTBASE MathIeeeDoubTransBase
#define MFREG1  d0
#define MFREG2  d2
#define MFVALUE(x) x
#else
#ifndef ___QDEV_NOIEEEMATH
#define MFARITH float
#define MFBBASE MathIeeeSingBasBase
#define MFTBASE MathIeeeSingTransBase
#define MFREG1  d0
#define MFREG2  d1
#define MFVALUE(x) x
#else
#define MFARITH float
#define MFBBASE MathBase
#define MFTBASE MathTransBase
#define MFREG1  d0
#define MFREG2  d1
#define MFVALUE QDEV_HLP_IEEETOFFP
#endif
#endif
#define MFADD   _IEEEXPAdd
#define MFSUB   _IEEEXPSub
#define MFMUL   _IEEEXPMul
#define MFDIV   _IEEEXPDiv
#define MFFIX   _IEEEXPFix
#define MFFLT   _IEEEXPFlt
#define MFCMP   _IEEEXPCmp
#define MFCLE   _IEEEXPCle
#define MFCGE   _IEEEXPCge

#ifndef ___QDEV_NOINTDECLS
#define QDEVDECL(x) x
#else
#define QDEVDECL(x)
#endif


/*
 * Unexpanded structures. Some funcs are scattered!
*/
struct mem_ifh_data;
struct nfo_sml_cb;


/*
 * Local Base Support compatibility kludge macros.
 * Following macros can be redefined by including
 * 'qlbs.h' before main library header.
*/
#ifndef QBASEDECL
#define QBASEDECL(t, b, i...) t b = ##i
#endif
#ifndef QBASEDECL2
#define QBASEDECL2(t, b, i...) t b = ##i
#endif

#ifndef QBASEASSIGN
#define QBASEASSIGN(b, i) b = i
#endif
#ifndef QBASEASSIGN2
#define QBASEASSIGN2(b, i) b = i
#endif

#ifndef QBASELOCAL
#define QBASELOCAL(b) b
#endif

#ifndef QBASEPOINTER
#define QBASEPOINTER(b) b
#endif

#ifndef QBASEJUMPTAB
#define QBASEJUMPTAB(b) b
#endif

#ifndef QBASESLOTS
#define QBASESLOTS(b, p...) (0 | ##p)
#endif

#ifndef QBASERESOLVE
#define QBASERESOLVE(sym)                     \
(*(void **)((struct Node *)sym)->ln_Pred)
#endif



/*
 * ------------------------ Debug output -----------------------------
*/

/*
 * Debugging stuff is here. There was a time when
 * it all was quite simple. Oh well... Fortunately
 * though, complex (and tricky) code pays off or
 * lets hope so :-) . No BFD involved, so interrupt
 * safe. Aside from 'QDEVDEBUG()' there are also
 * two more variants 'QDEVDEBUG_R()' which does the
 * relevance switching and 'QDEVDEBUG_N()' which is
 * totally independent from two previous.
*/
#if ___QDEV_DEBUGINFO
#define ___QDEVDEBUG(sw, fmt, va...)          \
({                                            \
  void *___m_ptr = ___QDEVDBAREAPTR();        \
  long ___m_len = ___QDEVDBAREALEN(___m_ptr); \
  ___qdevdbprintfcall(___m_ptr, ___m_len, sw, \
                                 fmt, ## va); \
})
#define QDEVDEBUG(fmt, va...)                 \
({                                            \
  ___QDEVDEBUG(                               \
              QDEVDBS_STDOUTPUT, fmt, ## va); \
})
#define QDEVDEBUG_R(fmt, va...)               \
({                                            \
  ___QDEVDEBUG(                               \
              QDEVDBS_FORCEFUNC, fmt, ## va); \
})
#define QDEVDEBUG_RR(fmt, va...)              \
({                                            \
  ___QDEVDEBUG(                               \
              QDEVDBS_FORCEFLOW, fmt, ## va); \
})
#define QDEVDEBUG_N(fmt, va...)               \
({                                            \
  txt_debugprintf(1280, fmt, ## va);          \
})
#define QDEVDEBUGIO   ___QDEVDBFUNCIO
#define QDEVDBDECL(x) x
#undef __inline
#else
#ifdef ___QDEV_DEBUGINFO
#define QDEVDEBUG     ___QDEV_DEBUGINFO
#define QDEVDEBUG_R   ___QDEV_DEBUGINFO
#define QDEVDEBUG_RR  ___QDEV_DEBUGINFO
#define QDEVDEBUG_N   ___QDEV_DEBUGINFO
#define QDEVDEBUGIO   ___QDEVDBFUNCIO
#define QDEVDBDECL(x) x
#undef __inline
#else
#define QDEVDEBUG(...)
#define QDEVDEBUG_R(...)
#define QDEVDEBUG_RR(...)
#define QDEVDEBUG_N(...)
#define QDEVDEBUGIO(...)
#define QDEVDBDECL(x) QDEVDECL(x)
#endif
#endif

#define QDEVDBIFUNC " ---> "
#define QDEVDBOFUNC " <--- "
#define QDEVDBIMESG " IMSG "
#define QDEVDBFARGS "      IN: " __FUNCTION__
#define QDEVDBSPACE "      "
#define QDEVDBSHIFT QDEVDBSPACE QDEVDBSPACE   \
                    QDEVDBSPACE QDEVDBSPACE

#ifdef ___QDEV_DEBUGNOINTS
#define QDEVDBDISABLE()                       \
({                                            \
  REGVAR(struct ExecBase *SysBase, a6) =      \
                 (*((struct ExecBase **) 4)); \
  void (*_Disable)(void) = mem_addrfromlvo(   \
                              SysBase, -120); \
  _Disable();                                 \
})
#define QDEVDBENABLE()                        \
({                                            \
  REGVAR(struct ExecBase *SysBase, a6) =      \
                 (*((struct ExecBase **) 4)); \
  void (*_Enable)(void) = mem_addrfromlvo(    \
                              SysBase, -126); \
  _Enable();                                  \
})
#else
#define QDEVDBDISABLE()
#define QDEVDBENABLE()
#endif

/*
 * Area pointer is just NULL byte. It is assumed
 * that this always points before actual function
 * address and before the debug info!
*/
#define ___QDEVDBAREAPTR()                    \
({                                            \
  static const char ___startaddr[] = "";      \
  (void *)___startaddr;                       \
})
#define ___QDEVDBAREALEN(ptr)                 \
({                                            \
  __label__ ___curraddr; ___curraddr:         \
  (long)&&___curraddr - (long)ptr;            \
})

/*
 * OBSOLETE!
 *
 * This was used long time ago with 'gensymtab'
 * utility. It is now obsolete, but should stay
 * here for compatibility reasons.
*/
struct qdevdbsymtab
{
  void *st_addr;               /* Symbol address                            */
  char *st_name;               /* Symbol name                               */
  char *st_file;               /* Symbol file                               */
};

/*
 * REPLACEMENT!
 *
 * These  are  new  fp2fn  resolving internals.
 * No need for a lookup table as all details
 * are being compiled-in just before the func.
*/
#define QDEVDBMAGICDI  0x47424544             /* 'G' 'B' 'E' 'D'            */
#define QDEVDBMAGICID  0x44454247             /* 'D' 'E' 'B' 'G'            */
#define QDEVDBTEXTLEN  64

struct qdevdbsymspace
{
  long ss_dbdi;                               /* Debug magic(keep it here!) */
  char ss_name[QDEVDBTEXTLEN];                /* Symbol name                */
  char ss_file[QDEVDBTEXTLEN];                /* Symbol file                */
  long ss_line;                               /* Symbol line                */
  long ss_flags;                              /* Debug flags                */
  long ss_last;                               /* Debug pointer              */
  long ss_dbid;                               /* Debug magic(keep it last!) */
};

/*
 * These flags may go in 'va...'.
*/
#ifndef ___QDEV_DEBUGCLEAN
#define QDEVDBF_IRRELEVANT   0x00000001       /* Info irrel. until switch   */
#define QDEVDBF_IRECURSIVE   0x00000002       /* Recurse irrelevance        */
#define QDEVDBF_OUTPUTONCE   0x00000004       /* Single info on many calls  */
#define QDEVDBF_NOVOIDTELL   0x00000008       /* Do not report void funcs   */
#define QDEVDBF_DONOTSTORE   0x00000010       /* Do not store irrelevance   */
#define QDEVDBF_STACKTRACE   0x00000020       /* Dump stack trace on entry  */
#define QDEVDBF_UPPERLEVEL   0x00000040       /* Full effect in subroutine  */
#define QDEVDBF_HEAVYSTEPS   0x00000080       /* Pause after each output    */
#define QDEVDBF_LIGHTSTEPS   0x00000100       /* Eliminate all pauses       */
#define QDEVDBF_NORMALFILL   0x00000200       /* Catch multilevel output    */
#else
#define QDEVDBF_IRRELEVANT   0
#define QDEVDBF_IRECURSIVE   0
#define QDEVDBF_OUTPUTONCE   0
#define QDEVDBF_NOVOIDTELL   0
#define QDEVDBF_DONOTSTORE   0
#define QDEVDBF_STACKTRACE   0
#define QDEVDBF_UPPERLEVEL   0
#define QDEVDBF_HEAVYSTEPS   0
#define QDEVDBF_LIGHTSTEPS   0
#define QDEVDBF_NORMALFILL   0
#endif

/*
 * This should always be at the bottom of the func.
 * so effectively it is the last possible static,
 * which is to say the very close one to the func.
 * address.
*/
#define ___QDEVDBFUNCIO(va...)                \
({                                            \
  static const volatile __caddr               \
  struct qdevdbsymspace ___qdevdbsymbuf =     \
  {                                           \
    QDEVDBMAGICDI,                            \
    {__FUNCTION__},                           \
    {__FILE__    },                           \
    __LINE__,                                 \
    0 | ## va,                                \
    0,                                        \
    QDEVDBMAGICID                             \
  };                                          \
  ___qdevdbsymspacecall(                      \
               (void *)&___qdevdbsymbuf);     \
})

/*
 * The very first function is a stub so compiler 
 * does not issue warnings about unused variables.
 * It is also used to detect void functions. The
 * other is a 'txt_[v]debugprintf()' wrapper, so
 * it is possible to replace it without the need
 * to rebuild whole library. Last function allows
 * to modfiy per function debugging flags.
*/
#define QDEVDBS_STDOUTPUT 0        /* Normal output to any stream           */
#define QDEVDBS_FORCEFUNC 1        /* Show until exit of function           */
#define QDEVDBS_FORCEFLOW 2        /* Show until program is done            */

QDEVDBDECL( __nifunc __interrupt void ___qdevdbsymspacecall(
                                      struct qdevdbsymspace *); )
QDEVDBDECL( __nifunc __interrupt void ___qdevdbprintfcall(void *,
                                      long, long, char *, ...); )
QDEVDBDECL( __nifunc __interrupt long ___qdevdbmodflagscall(
                                     void *, long, long, long); )



/*
 * ------------------------ Handy macros -----------------------------
*/

/*
 * Be extremlly careful when using this macro!
 * Its up to you to check the alignment!
*/
#define QDEV_HLP_QUICKFILL(ptr, t, val, size) \
({                                            \
  REGISTER t *___m_ptrreg = ptr;              \
  REGISTER t *___m_endreg = (t *)(            \
   (LONG)___m_ptrreg + (LONG)size);           \
  while (___m_ptrreg < ___m_endreg)           \
  {                                           \
    *___m_ptrreg++ = (t)val;                  \
  }                                           \
})


/*
 * These are bitmap related. Last two should
 * only be used to allocate the raster(s) in
 * a bitmap that will be blitted to using 4x
 * bandwidth under AGA!
*/
#define QDEV_HLP_BYTESPERROW(w)               \
            ((((ULONG)w + 15) >> 3) & 0xFFFE)

#define QDEV_HLP_RASSIZE(w ,h)                \
         (QDEV_HLP_BYTESPERROW(w) * (ULONG)h)

#define QDEV_HLP_BYTESPERROW64(w)             \
     (QDEV_HLP_BYTESPERROW(((w + 63) & ~63)))

#define QDEV_HLP_RASSIZE64(w ,h)              \
       (QDEV_HLP_BYTESPERROW64(w) * (ULONG)h)



#define QDEV_HLP_MKSTR(string)                \
        QDEV_HLP_MKSTR2(string)
#define QDEV_HLP_MKSTR2(string) #string



#ifdef ___QDEV_UTILITYCHAREQ
/*
 * This may or may not refer to the locale!
*/
#include <proto/utility.h>
#define QDEV_HLP_EQUALIZELC(chr) ToLower(chr)
#define QDEV_HLP_EQUALIZEUC(chr) ToUpper(chr)
#else
#define QDEV_HLP_EQUALIZELC(chr)              \
({                                            \
  REGISTER ULONG ___m_ichr = (ULONG)chr;      \
  if (((___m_ichr >= 'A')    &&               \
       (___m_ichr <= 'Z'))   ||               \
      ((___m_ichr >= 0xC0)   &&               \
       (___m_ichr <= 0xDE)   &&               \
       (___m_ichr != 0xD7)))                  \
  {                                           \
    ___m_ichr += 0x20;                        \
  }                                           \
  ___m_ichr;                                  \
})
#define QDEV_HLP_EQUALIZEUC(chr)              \
({                                            \
  REGISTER ULONG ___m_ichr = (ULONG)chr;      \
  if (((___m_ichr >= 'a')    &&               \
       (___m_ichr <= 'z'))   ||               \
      ((___m_ichr >= 0xE0)   &&               \
       (___m_ichr <= 0xFE)   &&               \
       (___m_ichr != 0xF7)))                  \
  {                                           \
    ___m_ichr -= 0x20;                        \
  }                                           \
  ___m_ichr;                                  \
})
#endif



#define QDEV_HLP_ITERATE(list, type, node)    \
  for (node = (type)((struct List *)(list))   \
  ->lh_Head; ((struct Node *)node)->ln_Succ;  \
  node = (type)((struct Node *)node)->ln_Succ)

#define QDEV_HLP_ISLISTEMPTY(list)            \
  ((((struct List *)list)->lh_TailPred) ==    \
                    (struct Node *)(list))



/*
 * Delta iterator with standalone delta detection/
 * condition and match macro. It is important not
 * to swap node arguments!
*/
#define QDEV_HLP_DELTAITER(lh, type, h, t)    \
 for (                                        \
 h = (type)((struct List *)(lh))->lh_Head,    \
 t = (type)((struct List *)(lh))->lh_TailPred;\
 ((struct Node *)(h))->ln_Succ;               \
 h = (type)((struct Node *)(h))->ln_Succ,     \
 t = (type)((struct Node *)(t))->ln_Pred)

#define QDEV_HLP_DELTACOND(type, h, t)        \
  ((t == h) ||                                \
   (t == (type)((struct Node *)(h))->ln_Succ))

#define QDEV_HLP_DELTAADDR(addr, h, t)        \
  ((h == addr) || (t == addr))



/*
 * DELTASCAN: Head and Tail node macros. Checking
 * the Tail node against Head is a must before
 * accessing as they can be the same!
*/
#define QDEV_HLP_DSNODEH(na) na[0]
#define QDEV_HLP_DSNODET(na) na[1]

/*
 * DELTASCAN: Use this macro to stop the looping
 * without break statement. It proves useful when
 * used in callback for instance.
*/
#define QDEV_HLP_DSBREAK(na)                  \
({                                            \
  QDEV_HLP_DSNODEH(na) = NULL;                \
  QDEV_HLP_DSNODET(na) = NULL;                \
})

/*
 * DELTASCAN: This macro allows to match the node
 * by its address. The right node pointer is ret.
 * You may also like to use QDEV_HLP_DELTAADDR()
 * which is faster.
*/
#define QDEV_HLP_DSMATCH(h, t, a)             \
  ((h == a) ? h : (t == a) ? t : NULL)

/*
 * DELTASCAN: <type> *QDEV_HLP_DSVARDECL(ln);
*/
#define QDEV_HLP_DSVARDECL(na) na[4]

/*
 * This macro caches pointers so it is possible
 * to use 'Remove()'.
*/
#define QDEV_HLP_DELTASCAN(lh, na, code)      \
({                                            \
  na[0] = ((struct List *)(lh))->lh_Head;     \
  na[1] = ((struct List *)(lh))->lh_TailPred; \
  while (((na[2] = (na[0])->ln_Succ))      && \
         ((na[3] = (na[1])->ln_Pred)))        \
  {                                           \
    code                                      \
    na[0] =                                   \
       (na[1] == na[0]) || (na[1] == na[2]) ? \
    ((struct List *)                          \
         (lh))->lh_TailPred->ln_Succ : na[2]; \
    na[1] = na[3];                            \
  }                                           \
})



/*
 * Warning! These macros may cause side effects!
*/
#define QDEV_HLP_MIN(a, b) ((a < b) ? a : b)
#define QDEV_HLP_MAX(a, b) ((a > b) ? a : b)
#define QDEV_HLP_ABS(a)    ((a < 0) ? -a : a)
#define QDEV_HLP_NEG(a)    ((a < 0) ? a : -a)
#define QDEV_HLP_FLIP(a)   (-a)



#define QDEV_HLP_BADDR(addr)                  \
  ((APTR)((ULONG)(addr) << 2))
#define QDEV_HLP_MKBADDR(var)                 \
  (((LONG)(var)) >> 2)



/*
 * This macro allows to maintain true globals in
 * resident binaries. What it does is to tell the
 * linker the data is to be put in code section.
 * Beware, do not define any system globals using
 * this macro! Use it in your private code only!
*/
#define QDEV_HLP_RESGLOB(type, name)          \
  __caddr type name



#define QDEV_HLP_ASMALIAS(new, old)           \
  asm("\t   .stabs \"_" #new "\",11,0,0,0"    \
      "\n\t .stabs \"_" #old "\",1,0,0,0")

#define	QDEV_HLP_ASMENTRY(name, code)         \
  asm("\t   .text"                            \
      "\n\t .even"                            \
      "\n\t .globl _" QDEV_HLP_MKSTR(name)    \
      "\n_" QDEV_HLP_MKSTR(name) ":" code);



/*
 * Special driver function macro to be able to put
 * selected registers on stack. This is currently
 * being used by funcs that do 'InternalLoadSeg()'.
 * Resident binaries that make their own functable
 * that references ROM code indirectly must use
 * this macro or else strange things will happen...
 * Caution! You will most likely have to restore A4
 * register per function in the table, hot vectors
 * come in handy.
*/
#define QDEV_DFREGS_USR_EXCEPT   d1-d7/a0/a2-a4/a6   /* Exception reg mask  */
#define QDEV_DFREGS_API_ALLOCMEM d2-d7/a0-a4/a6      /* AllocMem() reg mask */
#define QDEV_DFREGS_API_FREEMEM  d1-d7/a0/a2-a4/a6   /* FreeMem() reg mask  */
#define QDEV_DFREGS_API_READ     d4-d7/a0-a4/a6      /* Read() reg mask/DOS */



#define QDEV_HLP_DFUNC(r, at, dn, fn)         \
  QDEV_HLP_ASMENTRY                           \
  (                                           \
    dn,                                       \
    "\t   movem.l " QDEV_HLP_MKSTR(r) ",-(sp)"\
    "\n\t bsr     _" QDEV_HLP_MKSTR(fn)       \
    "\n\t movem.l (sp)+," QDEV_HLP_MKSTR(r)   \
    "\n\t rts"                                \
  );                                          \
  at dn();



/*
 * Register load and save macros.
*/
#define QDEV_HLP_GETREG(reg)                  \
({                                            \
  register unsigned long ___m_regp            \
                    asm(QDEV_HLP_MKSTR(reg)); \
  ___m_regp;                                  \
})

#define QDEV_HLP_SETREG(reg, val)             \
({                                            \
  asm("\t   move.l %0," QDEV_HLP_MKSTR(reg)   \
             : : "a" ((unsigned long)(val))); \
})



/*
 * Premature process termination macro. Just
 * stuff '(pr->pr_ReturnAddr - 4)' and you're
 * done.
*/
#define QDEV_HLP_PROCEXIT(ra)                 \
({                                            \
  asm("\t	move.l %0,sp"                 \
    "\n\t	rts"                          \
               : : "a" (ra));                 \
})



/*
 * Quick arbitration macros.
*/
#define QDEV_HLP_NOSWITCH(code)               \
({                                            \
  Forbid();                                   \
  code                                        \
  Permit();                                   \
})

#define QDEV_HLP_NOINTSEC(code)               \
({                                            \
  Disable();                                  \
  code                                        \
  Enable();                                   \
})



/*
 * A macro to pretend that you are someone else.
 * Never! Never, call this without arbitration or
 * system will freak out! Depending on what you
 * need to stop (task switches or interrupts) put
 * this macro in either: QDEV_HLP_NOSWITCH() or
 * QDEV_HLP_NOINTSEC() first.
*/ 
#define QDEV_HLP_REMOTE(tc, code)             \
({                                            \
  struct Task *___m_tc = SysBase->ThisTask;   \
  SysBase->ThisTask = (struct Task *)(tc);    \
  code                                        \
  SysBase->ThisTask = ___m_tc;                \
})



/*
 * LFRA task and process wrapper declarators.
*/
#define QDEV_HLP_TASKDECL(fmod, symbol, code) \
fmod void symbol##_TD(void)                   \
{                                             \
  code                                        \
}                                             \
fmod __nifunc void symbol(void)               \
{                                             \
  symbol##_TD();                              \
  {                                           \
    REGVAR(struct ExecBase *SysBase, a6) =    \
                 (*((struct ExecBase **) 4)); \
       void (*_RemTask)(REGARG(void *, a1)) = \
              mem_addrfromlvo(SysBase, -288); \
    _RemTask(SysBase->ThisTask);              \
  }                                           \
}

#define QDEV_HLP_PROCDECL(fmod, symbol, code) \
fmod void symbol##_PD(void)                   \
{                                             \
  code                                        \
}                                             \
fmod __nifunc void symbol(void)               \
{                                             \
  symbol##_PD();                              \
}



/*
 * m68020+ related multiplication/division ops.
*/
#define QDEV_HLP_ASMMULU(w1, w0, u, v)        \
  asm("\t   mulu%.l %3,%1:%0"                 \
              : "=d"  ((ULONG)(w0)),          \
                "=d"  ((ULONG)(w1))           \
              : "%0"  ((ULONG)(u)),           \
                "dmi" ((ULONG)(v)))

#define QDEV_HLP_ASMDIVU(q, r, n1, n0, d)     \
  asm("\t   divu%.l %4,%1:%0"                 \
              : "=d"  ((ULONG)(q)),           \
                "=d"  ((ULONG)(r))            \
              : "0"   ((ULONG)(n0)),          \
                "1"   ((ULONG)(n1)),          \
                "dmi" ((ULONG)(d)))



#define QDEV_HLP_DIVUQUAD(num, div)           \
({                                            \
  REGISTER ULONG ___m_num1 = (num >> 32);     \
  REGISTER ULONG ___m_num0 =                  \
                        (num & 0xFFFFFFFF);   \
  REGISTER ULONG ___m_quo =                   \
                         (___m_num1 / div);   \
  UQUAD ___m_res;                             \
  ___m_num1 -= (___m_quo * div);              \
  ___m_res = ___m_quo;                        \
  ___m_res <<= 32;                            \
  QDEV_HLP_ASMDIVU(___m_quo, ___m_num0,       \
                ___m_num1, ___m_num0, div);   \
  ___m_res |= ___m_quo;                       \
})

#define QDEV_HLP_MULUQUAD(num, mul)           \
({                                            \
  REGISTER ULONG ___m_reg1;                   \
  REGISTER ULONG ___m_reg0;                   \
  UQUAD ___m_res;                             \
  QDEV_HLP_ASMMULU(___m_reg1, ___m_reg0,      \
                                 num, mul);   \
  ___m_res = ___m_reg1;                       \
  ___m_res <<= 32;                            \
  ___m_res |= ___m_reg0;                      \
})



/*
 * Tricky, platform independent div10/mul10 ops.
 * These are slower than direct CPU division, but
 * since 'gcc' may use functions to mask platform
 * related assembly you may want to inline these.
 * The first one is especially efficient on CISC
 * machine, but input cannot exceed 2863311538!
*/
#define QDEV_HLP_E_DIVULONG10(num)            \
({                                            \
  struct ___VUQUAD ___m_ivuq;                 \
  QDEV_HLP_MULU32X32(0x66666667UL,            \
                             num, ___m_ivuq); \
  (___m_ivuq.vuq_hi >> 2);                    \
})

#define QDEV_HLP_N_DIVULONG10(num)            \
({                                            \
  (ULONG)(                                    \
  ((UQUAD)0x66666667ULL * (UQUAD)num) >> 34); \
})

#define QDEV_HLP_N_MULUXXX10(num, type)       \
({                                            \
  REGISTER type ___m_res = (type)num;         \
  ((___m_res << 3) + (___m_res << 1));        \
})



/*
 * Platform independent 32bit x 32bit == 64bit mul
 * that can operate either on an UQUAD or VUQUAD. It
 * was taken from http://www.hackersdelight.org and
 * converted to macro.
*/
#define QDEV_HLP_MULU32X32(a, b, vuq)         \
({                                            \
  struct ___VUQUAD *___m_vuq =                \
         (struct ___VUQUAD *)&(vuq);          \
  REGISTER ULONG ___m_ahi = a;                \
  REGISTER ULONG ___m_alo;                    \
  REGISTER ULONG ___m_bhi = b;                \
  REGISTER ULONG ___m_blo;                    \
  REGISTER ULONG ___m_mul;                    \
  REGISTER ULONG ___m_rlo;                    \
  REGISTER ULONG ___m_rlh;                    \
  ___m_alo = ___m_ahi & 0xFFFF;               \
  ___m_ahi >>= 16;                            \
  ___m_blo = ___m_bhi & 0xFFFF;               \
  ___m_bhi >>= 16;                            \
  ___m_mul = ___m_alo * ___m_blo;             \
  ___m_rlo = ___m_mul & 0xFFFF;               \
  ___m_mul = (___m_ahi * ___m_blo) +          \
                   (___m_mul >> 16);          \
  ___m_rlh = ___m_mul >> 16;                  \
  ___m_mul = (___m_alo * ___m_bhi) +          \
                (___m_mul & 0xFFFF);          \
  ___m_vuq->vuq_hi =                          \
                  (___m_mul >> 16) +          \
   (___m_ahi * ___m_bhi) + ___m_rlh;          \
  ___m_vuq->vuq_lo =                          \
        (___m_mul << 16) + ___m_rlo;          \
})



/*
 * Time manipulation macros.
*/
#define QDEV_HLP_SUBTV(dst, src)              \
({                                            \
  struct timeval *___m_dst = dst;             \
  struct timeval *___m_src = src;             \
  while (___m_src->tv_micro >= 1000000)       \
  {                                           \
    ___m_src->tv_secs++;                      \
    ___m_src->tv_micro -= 1000000;            \
  }                                           \
  while (___m_dst->tv_micro >= 1000000)       \
  {                                           \
    ___m_dst->tv_secs++;                      \
    ___m_dst->tv_micro -= 1000000;            \
  }                                           \
  if (___m_dst->tv_micro <                    \
                        ___m_src->tv_micro)   \
  {                                           \
    ___m_dst->tv_secs--;                      \
    ___m_dst->tv_micro += 1000000;            \
  }                                           \
  ___m_dst->tv_secs -= ___m_src->tv_secs;     \
  ___m_dst->tv_micro -= ___m_src->tv_micro;   \
})

#define QDEV_HLP_ADDTV(dst, src)              \
({                                            \
  struct timeval *___m_dst = dst;             \
  struct timeval *___m_src = src;             \
  ___m_dst->tv_secs += ___m_src->tv_secs;     \
  ___m_dst->tv_micro += ___m_src->tv_micro;   \
  while (___m_dst->tv_micro >= 1000000)       \
  {                                           \
    ___m_dst->tv_secs++;                      \
    ___m_dst->tv_micro -= 1000000;            \
  }                                           \
})



/*
 * Time conversion macros.
*/
#define QDEV_HLP_TVTODS(ds, tv)               \
({                                            \
  struct DateStamp *___m_ds = ds;             \
  struct timeval *___m_tv = tv;               \
  REGISTER ULONG ___m_secs;                   \
  ___m_secs = ___m_tv->tv_secs;               \
  ___m_ds->ds_Days = ___m_secs / 86400;       \
  ___m_secs %= 86400;                         \
  ___m_ds->ds_Minute = ___m_secs / 60;        \
  ___m_secs %= 60;                            \
  ___m_ds->ds_Tick = (___m_tv->tv_micro +     \
     ___m_secs * 1000000) / (1000000 / 50);   \
})

#define QDEV_HLP_DSTOTV(tv, ds)               \
({                                            \
  struct DateStamp *___m_ds = ds;             \
  struct timeval *___m_tv = tv;               \
  REGISTER ULONG ___m_secs;                   \
  ___m_secs = (((___m_ds->ds_Minute * 60) +   \
             (___m_ds->ds_Days * 86400)));    \
  ___m_tv->tv_secs = ___m_secs;               \
  ___m_secs %= 86400;                         \
  ___m_secs %= 60;                            \
  ___m_tv->tv_micro = (___m_ds->ds_Tick *     \
   (1000000 / 50)) - (___m_secs * 1000000);   \
})



/*
 * These convert in-place between little and big
 * endian. The last one is able to work on either
 * real or virtual quads.
*/
#define QDEV_HLP_SWAPWORD(val)                \
({                                            \
  REGISTER UWORD ___m_val = (UWORD)val;       \
  val = ((___m_val << 8) | (___m_val >> 8));  \
})

#define QDEV_HLP_SWAPLONG(val)                \
({                                            \
  REGISTER ULONG ___m_val = (ULONG)val;       \
  val = ((___m_val << 24))             |      \
        ((___m_val << 8) & 0x00FF0000) |      \
        ((___m_val >> 8) & 0x0000FF00) |      \
        ((___m_val >> 24));                   \
})

#define QDEV_HLP_SWAPQUAD(val)                \
({                                            \
  REGISTER ULONG ___m_swap;                   \
  struct ___VUQUAD *___m_vuq =                \
              (struct ___VUQUAD *)&(val);     \
  ___m_swap = QDEV_HLP_SWAPLONG(              \
                       ___m_vuq->vuq_hi);     \
  QDEV_HLP_SWAPLONG(___m_vuq->vuq_lo);        \
  ___m_vuq->vuq_hi = ___m_vuq->vuq_lo;        \
  ___m_vuq->vuq_lo = ___m_swap;               \
  val;                                        \
})



/*
 * 64bit type in-place shifting. These were taken
 * from 'longlongemul' by VZ and then converted to
 * macros.
*/
#define QDEV_HLP_RSHIFT64(val, bits)          \
({                                            \
  REGISTER ULONG ___m_ibits = bits;           \
  struct ___VUQUAD *___m_vuq =                \
               (struct ___VUQUAD *)&(val);    \
  if (___m_ibits < 32)                        \
  {                                           \
    ___m_vuq->vuq_lo >>= ___m_ibits;          \
    ___m_vuq->vuq_lo |=                       \
    ___m_vuq->vuq_hi << (32 - ___m_ibits);    \
    ___m_vuq->vuq_hi >>= ___m_ibits;          \
  }                                           \
  else                                        \
  {                                           \
    ___m_vuq->vuq_lo =                        \
    ___m_vuq->vuq_hi >> (___m_ibits - 32);    \
    ___m_vuq->vuq_hi = 0;                     \
  }                                           \
  ___m_vuq->vuq_lo | ___m_vuq->vuq_hi;        \
})

#define QDEV_HLP_LSHIFT64(val, bits)          \
({                                            \
  REGISTER ULONG ___m_ibits = bits;           \
  struct ___VUQUAD *___m_vuq =                \
               (struct ___VUQUAD *)&(val);    \
  if (___m_ibits < 32)                        \
  {                                           \
    ___m_vuq->vuq_hi <<= ___m_ibits;          \
    ___m_vuq->vuq_hi |=                       \
    ___m_vuq->vuq_lo >> (32 - ___m_ibits);    \
    ___m_vuq->vuq_lo <<= ___m_ibits;          \
  }                                           \
  else                                        \
  {                                           \
    ___m_vuq->vuq_hi =                        \
    ___m_vuq->vuq_lo << (___m_ibits - 32);    \
    ___m_vuq->vuq_lo = 0;                     \
  }                                           \
  ___m_vuq->vuq_hi | ___m_vuq->vuq_lo;        \
})



/*
 * The best 32bit hashing routine ever created.
 * Thanks to: Glenn Fowler, Landon Curt Noll and
 * Phong Vo.
*/
#define QDEV_HLP_FNV32PRIME    0x811C9DC5
#define QDEV_HLP_FNV32NOMACRO(chr)  (chr)

#define QDEV_HLP_FNV32CSUM(ics, ptr, size)    \
({                                            \
  REGISTER UBYTE *___m_ptrreg = ptr;          \
  REGISTER UBYTE *___m_endreg = (UBYTE *)(    \
          (LONG)___m_ptrreg + (LONG)size);    \
  REGISTER ULONG ___m_csum = ics;             \
  while (___m_ptrreg < ___m_endreg)           \
  {                                           \
    ___m_csum ^= *___m_ptrreg++;              \
    ___m_csum *= QDEV_HLP_FNV32PRIME;         \
  }                                           \
  ___m_csum;                                  \
})

#define _QDEV_HLP_FNV32HASH(string, macro)    \
({                                            \
  REGISTER UBYTE *___m_strreg = string;       \
  REGISTER ULONG ___m_hash = 0;               \
  while (*___m_strreg)                        \
  {                                           \
    ___m_hash ^= macro(*___m_strreg++);       \
    ___m_hash *= QDEV_HLP_FNV32PRIME;         \
  }                                           \
  ___m_hash;                                  \
})

#define QDEV_HLP_FNV32HASH(string)            \
            _QDEV_HLP_FNV32HASH(string,       \
             QDEV_HLP_FNV32NOMACRO)

#define QDEV_HLP_FNV32IHASH(string)           \
            _QDEV_HLP_FNV32HASH(string,       \
             QDEV_HLP_EQUALIZELC)



/*
 * Round to the next power of 2.
*/
#define QDEV_HLP_ROUNDPOW2(val)               \
({                                            \
  REGISTER ULONG ___m_val = val;              \
  ___m_val--;                                 \
  ___m_val |= ___m_val >> 1;                  \
  ___m_val |= ___m_val >> 2;                  \
  ___m_val |= ___m_val >> 4;                  \
  ___m_val |= ___m_val >> 8;                  \
  ___m_val |= ___m_val >> 16;                 \
  ++___m_val;                                 \
})

/*
 * Counts bits set fast in a 32bit integer.
*/
#define QDEV_HLP_POPCOUNT(x)                  \
({                                            \
  REGISTER ULONG ___m_x = x;                  \
  ___m_x = (___m_x - ((___m_x >> 1) &         \
                            0x55555555));     \
  ___m_x = ((___m_x & 0x33333333) +           \
           ((___m_x >> 2) & 0x33333333));     \
  ___m_x = ((___m_x + (___m_x >> 4)) &        \
                              0xF0F0F0F);     \
  (___m_x * 0x01010101) >> 24;                \
})



/*
 * Handy floating point format(SP) converters.
*/
#define QDEV_HLP_IEEETOFFP(x)                 \
({                                            \
  MFARITH ___m_x = (MFARITH)x;                \
  REGISTER LONG *___m_y = (LONG *)&___m_x;    \
  *___m_y = ((((*___m_y & 0x7F800000) >> 23) -\
  0x0000007E) + 0x00000040) | (*___m_y << 8) |\
  0x80000000 | ((*___m_y & 0x80000000) >> 24);\
  ___m_x;                                     \
})

#define QDEV_HLP_FFPTOIEEE(x)                 \
({                                            \
  MFARITH ___m_x = (MFARITH)x;                \
  REGISTER LONG *___m_y = (LONG *)&___m_x;    \
  *___m_y = ((((*___m_y & 0x0000007F) -       \
            0x00000040) + 0x0000007E) << 23) |\
               ((*___m_y & 0x7FFFFF00) >> 8) |\
               ((*___m_y & 0x00000080) << 24);\
  ___m_x;                                     \
})



/*
 * Fast memory copy macro that can copy upto 59
 * bytes loopless/branchless (prior to gcc-2.95)
 * when 'len' is known at compilation time! If
 * 'len' exceeds this value or must be read at
 * runtime then call to '_bcopy()' will be made.
*/
#define QDEV_HLP_LCOPYMEM(to, from, len)      \
({                                            \
  struct qdev_hlp_lcopymem                    \
  {                                           \
    long longs[(len) >> 2];                   \
  } __attribute__ ((aligned (4)));            \
  struct qdev_hlp_bcopymem                    \
  {                                           \
    char chars[(len) &  3];                   \
  } __attribute__ ((packed));                 \
  *((struct qdev_hlp_lcopymem *)(to)) =       \
  *((struct qdev_hlp_lcopymem *)(from));      \
  *((struct qdev_hlp_bcopymem *)              \
       ((long *)(to) + ((len) >> 2))) =       \
  *((struct qdev_hlp_bcopymem *)              \
       ((long *)(from) + ((len) >> 2)));      \
})



#define QDEV_HLP_ABOVE68000                   \
                  defined(__amigaos__)  &&    \
                 (defined(__mc68020__)  ||    \
                  defined(__mc68030__)  ||    \
                  defined(__mc68040__)  ||    \
                  defined(__mc68060__))



/*
 * ------------------------ Conversion stuff -------------------------
*/

/*
 * These were functions, but there was too much
 * overhead, so decided to convert to macros.
*/
#define cnv_ULONGtoBITS(val)                  \
({                                            \
  REGISTER ULONG ___m_valreg = val;           \
  REGISTER ULONG ___m_bits = 0;               \
  while (___m_valreg)                         \
  {                                           \
    ___m_valreg >>= 1;                        \
    ___m_bits++;                              \
  }                                           \
  ___m_bits;                                  \
})
#define cnv_UQUADtoBITS(val)                  \
({                                            \
  REGISTER ULONG ___m_valreg;                 \
  REGISTER ULONG ___m_bits = 0;               \
  struct ___VUQUAD *___m_vuq =                \
                 (struct ___VUQUAD *)&(val);  \
  ___m_valreg =                               \
        ___m_vuq->vuq_lo | ___m_vuq->vuq_hi;  \
  while (___m_valreg)                         \
  {                                           \
    ___m_valreg = QDEV_HLP_RSHIFT64(val, 1);  \
    ___m_bits++;                              \
  }                                           \
  ___m_bits;                                  \
})

#define cnv_LONGtoA(buffer, value, flags)     \
(                                             \
  cnv_ULONGtoA(buffer, value,                 \
              QDEV_CNV_UXXXFSIGN | flags)     \
)
#define cnv_QUADtoA(buffer, value, flags)     \
(                                             \
  cnv_UQUADtoA(buffer, value,                 \
              QDEV_CNV_UXXXFSIGN | flags)     \
)

#define cnv_AtoLONG(string, value, flags)     \
(                                             \
  cnv_AtoULONG(string, value,                 \
              QDEV_CNV_UXXXFSIGN | flags)     \
)
#define cnv_AtoQUAD(string, value, flags)     \
(                                             \
  cnv_AtoUQUAD(string, value,                 \
              QDEV_CNV_UXXXFSIGN | flags)     \
)

#define cnv_ALtoLONG(string, value, flags)    \
(                                             \
  cnv_ALtoULONG(string, value,                \
              QDEV_CNV_UXXXFSIGN | flags)     \
)
#define cnv_ALtoQUAD(string, value, flags)    \
(                                             \
  cnv_ALtoUQUAD(string, value,                \
              QDEV_CNV_UXXXFSIGN | flags)     \
)

#define QDEV_CNV_UXXXLEN    68          /* Min buf. len(64 + 2 + 1 + 1).    */
#define QDEV_CNV_UXXXFBE_B  0x00000002  /* Conv. to binary (flag/base)      */
#define QDEV_CNV_UXXXFBE_O  0x00000008  /* Conv. to octal (flag/base)       */
#define QDEV_CNV_UXXXFBE_D  0x0000000A  /* Conv. to decimal (flag/base)     */
#define QDEV_CNV_UXXXFBE_H  0x00000010  /* Conv. to hexadecimal (flag/base) */
#define QDEV_CNV_UXXXFLOCS  0x00000100  /* Lowercase hexadecimal letters    */
#define QDEV_CNV_UXXXFDSGN  0x00010000  /* Prepend single('$') char prefix  */
#define QDEV_CNV_UXXXFOSGN  0x00020000  /* Prepend double('0x') char prefix */
#define QDEV_CNV_UXXXFSIGN  0x00040000  /* Signed output or overflow det.   */
#define QDEV_CNV_UXXXFALGN  0x40000000  /* Max. zero padding/alignment      */

QDEVDECL( UBYTE *cnv_ULONGtoA(UBYTE *, ULONG, ULONG); )
QDEVDECL( UBYTE *cnv_UQUADtoA(UBYTE *, UQUAD, ULONG); )
QDEVDECL( LONG cnv_AtoULONG(UBYTE *, ULONG *, ULONG); )
QDEVDECL( LONG cnv_AtoUQUAD(UBYTE *, UQUAD *, ULONG); )
QDEVDECL( LONG cnv_ALtoULONG(UBYTE *, ULONG *, ULONG); )
QDEVDECL( LONG cnv_ALtoUQUAD(UBYTE *, UQUAD *, ULONG); )



/*
 * ------------------------ String related ---------------------------
*/

#define QDEV_TXT_STRTOKTYPE(var)              \
  ULONG var[2] = {0, 0}

#define QDEV_TXT_STRTOKINIT(str1, str2, var)  \
(                                             \
  txt_strtok(str1, str2, &var[0])             \
)

#define QDEV_TXT_STRTOKNEXT(str2, var)        \
(                                             \
  txt_strtok(NULL, str2, &var[0])             \
)

#define QDEV_TXT_STRTOKTERM(var)              \
({                                            \
  if ((var[0]) && (var[1]))                   \
  {                                           \
    (*(UBYTE *)(var[0] - 1)) = (UBYTE)var[1]; \
    var[0] = 0;                               \
    var[1] = 0;                               \
  }                                           \
})

QDEVDECL( UBYTE *txt_strtok(UBYTE *, const UBYTE *, ULONG *); )


#define QDEV_TXT_INIPARSETYPE(var)            \
  struct txt_ipe_form var

#define QDEV_TXT_INIPARSEINIT(str, c, v, f...)\
(                                             \
  txt_iniparse(str, c, &v, 0 | ## f)          \
)

#define QDEV_TXT_INIPARSETERM(var)            \
({                                            \
  if (var.ini_bck[0])                         \
  {                                           \
    (*(UBYTE *)(var.ini_bck[0])) =            \
                    (UBYTE)var.ini_bck[1];    \
    var.ini_bck[0] = 0;                       \
  }                                           \
  if (var.ini_bck[2])                         \
  {                                           \
    (*(UBYTE *)(var.ini_bck[2])) =            \
                    (UBYTE)var.ini_bck[3];    \
    var.ini_bck[2] = 0;                       \
  }                                           \
})

struct txt_ipe_form
{
  UBYTE   *ini_key;         /* Ini key string pointer, set after parsing    */
  UBYTE   *ini_data;        /* Ini data string pointer, set after parsing   */
  ULONG    ini_bck[4];      /* Address and data backup buffer               */
};

QDEVDECL( BOOL txt_iniparse(
            UBYTE *, LONG, struct txt_ipe_form *, LONG); )


#define QDEV_TXT_SKIPCCTYPE(var)              \
  struct txt_scc_form var

#define QDEV_TXT_SKIPCCINIT(var)              \
({                                            \
  var.sf_quot = 0x01000022;                   \
  var.sf_count = 0;                           \
  var.sf_comm = 0;                            \
})

#define QDEV_TXT_SKIPCCINIT2(var)             \
({                                            \
  var.sf_quot = 0x01000000;                   \
  var.sf_count = 0;                           \
  var.sf_comm = 0;                            \
})

#define QDEV_TXT_SKIPCCITER(string, var)      \
  for(var.sf_end = string; ((var.sf_end) &&   \
  (var.sf_ptr = txt_skipcc(var.sf_end,        \
  &var)));)

struct txt_scc_form
{
  UBYTE   *sf_ptr;          /* Start of the actual string                   */
  UBYTE   *sf_start;        /* Address of the start of comment              */
  UBYTE   *sf_end;          /* Address of the end of comment(circular)      */
  LONG     sf_quot;         /* Type of quotation trigger (0xbb0000ch)       */
  LONG     sf_count;        /* Overall number of comments detected          */
  LONG     sf_comm;         /* Number of comments unmatched                 */
};

QDEVDECL( UBYTE *txt_skipcc(UBYTE *, struct txt_scc_form *); )


QDEVDECL( LONG txt_psnprintf(
                         UBYTE *, LONG, const UBYTE *, ...); )
QDEVDECL( LONG txt_vpsnprintf(
                     UBYTE *, LONG, const UBYTE *, va_list); )
QDEVDECL( LONG txt_strncatlc(UBYTE *, UBYTE *, LONG); )
QDEVDECL( LONG txt_strncatuc(UBYTE *, UBYTE *, LONG); )
QDEVDECL( LONG txt_strncat(UBYTE *, UBYTE *, LONG); )
QDEVDECL( LONG txt_stricmp(const UBYTE *, const UBYTE *); )
QDEVDECL( LONG txt_pstricmp(const UBYTE *, const UBYTE *); )
QDEVDECL( LONG txt_strcmp(const UBYTE *, const UBYTE *); )
QDEVDECL( LONG txt_pstrcmp(const UBYTE *, const UBYTE *); )
QDEVDECL( UBYTE *txt_stristr(const UBYTE *, const UBYTE *); )
QDEVDECL( UBYTE *txt_pstristr(const UBYTE *, const UBYTE *); )
QDEVDECL( UBYTE *txt_strstr(const UBYTE *, const UBYTE *); )
QDEVDECL( UBYTE *txt_pstrstr(const UBYTE *, const UBYTE *); )
QDEVDECL( LONG txt_strspn(const UBYTE *, const UBYTE *); )
QDEVDECL( LONG txt_strcspn(const UBYTE *, const UBYTE *); )
QDEVDECL( UBYTE *txt_strchr(const UBYTE *, LONG); )
QDEVDECL( UBYTE *txt_strichr(const UBYTE *, LONG); )
QDEVDECL( LONG txt_strlen(const UBYTE *); )
QDEVDECL( void *txt_memfill(void *, LONG, LONG); )
QDEVDECL( UBYTE txt_needslash(UBYTE *); )
QDEVDECL( UBYTE *txt_datdat(const UBYTE *, LONG,
                                       const UBYTE *, LONG); )
QDEVDECL( UBYTE *txt_datidat(const UBYTE *, LONG,
                                       const UBYTE *, LONG); )


#define QDEV_TXT_NC_F_REW 0x00000000         /* Process backward            */
#define QDEV_TXT_NC_F_FWD 0x00000001         /* Process forward             */
#define QDEV_TXT_NC_F_NTC 0x00000100         /* Do not track chars          */
#define QDEV_TXT_NC_F_NSC 0x00000200         /* Do not skip chars           */
#define QDEV_TXT_NC_F_NCC 0x00000400         /* No C com. striping          */
#define QDEV_TXT_NC_F_NSR 0x00000800         /* Do not skip rest            */
#define QDEV_TXT_NC_F_AMI 0x00001000         /* Omit ';' com.(NTC)          */
#define QDEV_TXT_NC_F_UNI 0x00002000         /* Omit '#' com.(NTC)          */
#define QDEV_TXT_NC_F_CPP 0x00004000         /* Omit '//' com.(NTC)         */

QDEVDECL( UBYTE *txt_nocomment(UBYTE *, LONG); )


#define QDEV_TXT_TOKENSET(bold, baddr)        \
({                                            \
  bold = *((UBYTE *)baddr);                   \
  *((UBYTE *)baddr) = '\0';                   \
})

#define QDEV_TXT_TOKENCLR(bold, baddr)        \
({                                            \
  *((UBYTE *)baddr) = bold;                   \
})

QDEVDECL( UBYTE *txt_tokenify(UBYTE *, LONG *, LONG); )


QDEVDECL( LONG txt_strboth(const UBYTE *, const UBYTE *); )
QDEVDECL( LONG txt_pstrboth(const UBYTE *, const UBYTE *); )
QDEVDECL( LONG txt_striboth(const UBYTE *, const UBYTE *); )
QDEVDECL( LONG txt_pstriboth(const UBYTE *, const UBYTE *); )
QDEVDECL( LONG txt_strpat(const UBYTE *, const UBYTE *); )
QDEVDECL( LONG txt_pstrpat(const UBYTE *, const UBYTE *); )
QDEVDECL( LONG txt_stripat(const UBYTE *, const UBYTE *); )
QDEVDECL( LONG txt_pstripat(const UBYTE *, const UBYTE *); )
QDEVDECL( LONG txt_bstrncatlc(UBYTE *, LONG, LONG); )
QDEVDECL( LONG txt_bstrncatuc(UBYTE *, LONG, LONG); )
QDEVDECL( LONG txt_bstrncat(UBYTE *, LONG, LONG); )


/*
 * These are sequence detection initializers that may go
 * into datatype whose pointer will be passed to 'ptr'.
*/
#define QDEV_TXT_NA_ESC     0x1B1B0000    /* Watch for ESC seqs only (def.) */
#define QDEV_TXT_NA_CSI     0x9B9B0000    /* Watch for CSI sequences only   */
#define QDEV_TXT_NA_ALL     0x9B1B0000    /* Watch for all sequences        */

#define QDEV_TXT_NA_FSEQATT 0x00000001    /* Sequence was attempted flag    */
#define QDEV_TXT_NA_FSEQEND 0x00000002    /* Sequence is now complete flag  */
#define QDEV_TXT_NA_FSEQBRA 0x00000004    /* Sequence with introducer flag  */
#define QDEV_TXT_NA_FSEQCSI 0x00000008    /* Sequence is plain CSI flag     */
#define QDEV_TXT_NA_FSEQDIS 0x00000010    /* Sequence should be discarded   */

QDEVDECL( LONG txt_noansi(ULONG, ULONG *); )


QDEVDECL( LONG txt_stripansi(UBYTE *, UBYTE *); )
QDEVDECL( ULONG txt_quickhash(UBYTE *); )
QDEVDECL( ULONG txt_quickihash(UBYTE *); )
QDEVDECL( LONG txt_strnpcatlc(LONG *, UBYTE *, LONG *); )
QDEVDECL( LONG txt_strnpcatuc(LONG *, UBYTE *, LONG *); )
QDEVDECL( LONG txt_strnpcat(LONG *, UBYTE *, LONG *); )
QDEVDECL( LONG txt_bstrnpcatlc(LONG *, LONG, LONG *); )
QDEVDECL( LONG txt_bstrnpcatuc(LONG *, LONG, LONG *); )
QDEVDECL( LONG txt_bstrnpcat(LONG *, LONG, LONG *); )
QDEVDECL( LONG txt_strnvacat(LONG *, LONG *, UBYTE *, ...); )
QDEVDECL( ULONG txt_pjw64hash(VUQUAD *, UBYTE *); )
QDEVDECL( ULONG txt_pjw64ihash(VUQUAD *, UBYTE *); )
QDEVDECL( ULONG txt_fnv64hash(VUQUAD *, UBYTE *); )
QDEVDECL( ULONG txt_fnv64ihash(VUQUAD *, UBYTE *); )
QDEVDECL( LONG txt_memcmp(void *, void *, LONG); )
QDEVDECL( LONG txt_memicmp(void *, void *, LONG); )
QDEVDECL( LONG txt_parseline(UBYTE *, LONG **); )


/*
 * Double quotes unescaping and/or removal. It is possible
 * to set own characters in place of defines.
*/
#define QDEV_TXT_FQF_ASTERISK  0x0000002A  /* Quotes prefixed with ---> *   */
#define QDEV_TXT_FQF_BACKSLASH 0x00005C00  /* Quotes prefixed with ---> \   */
#define QDEV_TXT_FQF_SINGQUOTE 0x00270000  /* Quotes prefixed with ---> '   */
#define QDEV_TXT_FQF_REMOVE1   0x01000000  /* Rem. quotes starting with *"  */
#define QDEV_TXT_FQF_REMOVE2   0x02000000  /* Rem. quotes starting with \"  */
#define QDEV_TXT_FQF_REMOVE3   0x04000000  /* Rem. quotes starting with '"  */

QDEVDECL( void txt_fixquotes(LONG **, LONG, LONG); )


QDEVDBDECL( __nifunc __interrupt LONG txt_vcbpsnprintf(
__saveds __interrupt void(*)(REGARG(UBYTE *, a0), REGARG(LONG, d0)),
                          UBYTE *, LONG, const UBYTE *, va_list); )
QDEVDBDECL( __nifunc __interrupt LONG txt_debugprintf(
                                       LONG, const UBYTE *, ...); )
QDEVDBDECL( __nifunc __interrupt LONG txt_vdebugprintf(
                                   LONG, const UBYTE *, va_list); )


QDEVDECL( ULONG txt_fnv128hash(VUQ128 *, UBYTE *); )
QDEVDECL( ULONG txt_fnv128ihash(VUQ128 *, UBYTE *); )



/*
 * ------------------------ Memory related ---------------------------
*/

#ifdef ___QDEV_FORCEPOOLS
#undef AllocVec 
#define AllocVec mem_allocvecpooled 
#undef FreeVec
#define FreeVec  mem_freevecpooled
#undef AllocMem 
#define AllocMem mem_allocvecpooled 
#undef FreeMem
#define FreeMem(ptr, size) mem_freevecpooled(ptr)
#endif

#define QDEV_MEM_XXXVPINIT(mem, pud, tres)    \
({                                            \
  (((mem_setvecpooled(mem,                    \
                     QDEV_MEM_XXXVPI_PUD,     \
                     pud) > -1)            && \
    (mem_setvecpooled(mem,                    \
                     QDEV_MEM_XXXVPI_TRES,    \
                     ((tres > pud) ?          \
                     pud : tres)) > -1)) ?    \
  1 : 0);                                     \
})

#define QDEV_MEM_XXXVPV_NOCH -1         /* Dummy value for getting the res. */
#define QDEV_MEM_XXXVPI_REAL  1         /* Get real amount of mem used      */
#define QDEV_MEM_XXXVPI_REQ   2         /* Get requested amount of mem used */
#define QDEV_MEM_XXXVPI_AMNT  4         /* Get amount of calls to allocator */
#define QDEV_MEM_XXXVPI_ADDR  8         /* Get the address of the main pool */
#define QDEV_MEM_XXXVPI_PUD  16         /* Get/set puddle befre frst alloc. */
#define QDEV_MEM_XXXVPI_TRES 32         /* Get/set treshold bef. frst aloc. */
#define QDEV_MEM_XXXVPI_FREE 64         /* Free all memory allocs at once   */

QDEVDECL( LONG mem_setvecpooled(ULONG, ULONG, LONG); )

QDEVDECL( void *mem_allocvecpooled(ULONG, ULONG); )
QDEVDECL( void mem_freevecpooled(void *); )


#define QDEV_MEM_REGALIGN(size)               \
  ((size + ((MEM_BLOCKSIZE * 2) - 1)) &       \
                      ~MEM_BLOCKMASK)

QDEVDECL( void *mem_allocmemregion(
                          ULONG, ULONG, ULONG, ULONG); )
QDEVDECL( void mem_freememregion(void *, ULONG); )


/*
 * This was a function with some bloaty checks, now its
 * a quick macro.
*/
#define mem_addrfromlvo(libbase, offset)      \
({                                            \
  (APTR)(*(ULONG *)(((ULONG)libbase +         \
                       (LONG)offset) + 2));   \
})


QDEVDECL( LONG mem_iloadseg(void *, LONG); )
QDEVDECL( void mem_uniloadseg(LONG); )

QDEVDECL( LONG mem_iloadseg2(void *, LONG); )
QDEVDECL( void mem_uniloadseg2(LONG); )

/*
 * Virtual terminal('han_termifh()') foundation!
*/
QDEVDECL( void *mem_allocterm(LONG, LONG, LONG); )
QDEVDECL( void mem_fixterm(void *); )
QDEVDECL( void mem_freeterm(void *); )

/*
 * Packet handlers for 'mem_openifh()'.
*/
#define QDEV_HAN_SMTERM_TERM   0   /* SetMode(): 'Read()' terminal contents */
#define QDEV_HAN_SMTERM_POS    1   /* SetMode(): 'Read()' term. CPR seq.    */

QDEVDECL( __saveds __interrupt ULONG han_termifh(
                                 REGARG(ULONG, d0),
                 REGARG(struct mem_ifh_data *, a1)); )
QDEVDECL( __saveds __interrupt ULONG han_rollifh(
                                 REGARG(ULONG, d0),
                 REGARG(struct mem_ifh_data *, a1)); )
QDEVDECL( __saveds __interrupt ULONG han_binaryifh(
                                 REGARG(ULONG, d0),
                 REGARG(struct mem_ifh_data *, a1)); )
QDEVDECL( __saveds __interrupt ULONG han_rwifh(
                                 REGARG(ULONG, d0),
                 REGARG(struct mem_ifh_data *, a1)); )


QDEVDECL( LONG mem_openifh(void *, LONG,
                        ULONG (*)(REGARG(ULONG, d0),
                REGARG(struct mem_ifh_data *, a1))); )
QDEVDECL( void mem_closeifh(LONG); )


QDEVDECL( LONG mem_addexhandler(LONG,
                     ULONG (*)(/* REGARG(ULONG, d0),
                             REGARG(void *, a1) */),
                                            void *); )
QDEVDECL( void mem_remexhandler(LONG); )


struct mem_sfe_cb
{
  LONG    sc_buflen;        /* Undivided buffer length(realigned here!)     */
  LONG    sc_halflen;       /* Half of the buffer length                    */
  UBYTE  *sc_block;         /* Block of data(pointer), two halves           */
  LONG    sc_blklen;        /* Real length of the block                     */
  UBYTE  *sc_data;          /* Continuous data as returned by 'Read()'      */
  LONG    sc_datalen;       /* Length of that data                          */
  LONG    sc_total;         /* Total bytes read so far                      */
  void   *sc_userdata;      /* General purpose variable                     */
};

QDEVDECL( LONG mem_scanfile(ULONG, LONG, ULONG, void *, 
                       LONG (*)(struct mem_sfe_cb *)); )

QDEVDECL( LONG mem_findinfile(
                    ULONG, LONG, UBYTE *, LONG, LONG); )
QDEVDECL( LONG mem_findinfileq(
                 ULONG, UBYTE *, UBYTE *, LONG, LONG); )


struct mem_lbl_cb
{
  LONG    lc_buflen;        /* Length of the buffer                         */
  UBYTE  *lc_bufptr;        /* Pointer to the buffer                        */
  UBYTE  *lc_lineptr;       /* Pointer to the start of line                 */
  LONG    lc_linenum;       /* Line number(-1 == EOF)                       */
  void   *lc_userdata;      /* General purpose variable                     */
};

QDEVDECL( LONG mem_scanlbl(ULONG, LONG, ULONG, void *, 
                   LONG (*)(struct mem_lbl_cb *)); )

QDEVDECL( LONG mem_scanlblncc(ULONG, LONG, ULONG, void *, 
                   LONG (*)(struct mem_lbl_cb *)); )


QDEVDECL( struct Image *mem_copyitnimage(
                           struct Image *, ULONG); )
QDEVDECL( void mem_freeitnimage(struct Image *); )

QDEVDECL( void mem_cooperate(LONG, ULONG); )

QDEVDECL( void mem_initemptybmap(
               struct BitMap *, UWORD, UWORD, UWORD); )
QDEVDECL( void mem_convimgtobmap(
                    struct BitMap *, struct Image *,
     VUQUAD *vuq, ULONG (*)(VUQUAD *, void *, LONG)); )

QDEVDECL( struct BitMap *mem_makebmapfromimg(
                              struct Image *, ULONG); )
QDEVDECL( void mem_freebmapfromimg(struct BitMap *); )

QDEVDECL( void *mem_alloccluster(ULONG, ULONG, ULONG); )
QDEVDECL( void mem_freecluster(void *); )
QDEVDECL( void *mem_getmemcluster(void *); )
QDEVDECL( void mem_freememcluster(void *); )

QDEVDECL( ULONG mem_csumchs32(void *, LONG); )
QDEVDECL( ULONG mem_csumeor32(void *, LONG, ULONG); )
QDEVDECL( ULONG mem_csumint32(void *, LONG); )


struct mem_mtl_iter
{
  struct MinNode  mi_node;           /* Node of this structure              */
  UBYTE          *mi_token;          /* Token, as extracted from string     */
};

QDEVDECL( struct MinList *mem_maketokenlist(
                                      UBYTE *, LONG); )
QDEVDECL( void mem_freetokenlist(struct MinList *); )


#define QDEV_MEM_IFLPIC_TRANSP 0x00000100  /* Pen 0 is the transparent      */
#define QDEV_MEM_IFLPIC_SHRINK 0x00000200  /* Try to optimize animations    */
#define QDEV_MEM_IFLPIC_GGD_NO 0x00000400  /* GuiGfx dither: none           */
#define QDEV_MEM_IFLPIC_GGD_FS 0x00000800  /* GuiGfx dither: floyd          */
#define QDEV_MEM_IFLPIC_GGD_RA 0x00001000  /* GuiGfx dither: random         */
#define QDEV_MEM_IFLPIC_GGD_ED 0x00002000  /* GuiGfx dither: edd            */

QDEVDECL( struct BitMap **mem_loadpicture(
                              UBYTE *, struct ColorMap *,
                     struct RastPort *, ULONG, ULONG); )
QDEVDECL( void mem_freepicture(struct BitMap **);  )


#define QDEV_MEM_RBP_PTABSIZE 256    /* Pen table size in WORDs!            */

QDEVDECL( struct BitMap *mem_remapbitmap(
                               struct BitMap *, ULONG *,
                    struct ColorMap *, WORD *, ULONG); )
QDEVDECL( struct BitMap *mem_remapbitmap2(
                               struct BitMap *, ULONG *,
                    struct ColorMap *, WORD *, ULONG); )

QDEVDECL( void mem_freepentab(
                           struct ColorMap *, WORD *); )

QDEVDECL( struct BitMap *mem_allocbmapthere(
                          ULONG, ULONG, ULONG, ULONG); )


struct mem_pak_data
{
  UBYTE  *pd_data;              /* Pointer to data                          */
  ULONG   pd_size;              /* Size of the data                         */
};

QDEVDECL( struct mem_pak_data *mem_lzwcompress(UBYTE *, ULONG); )
QDEVDECL( struct mem_pak_data *mem_lzwdecompress(UBYTE *, ULONG); )
QDEVDECL( void mem_lzwfree(struct mem_pak_data *); )


QDEVDECL( ULONG mem_pjw64hash(VUQUAD *, void *, LONG); )
QDEVDECL( ULONG mem_fnv64hash(VUQUAD *, void *, LONG); )


/*
 * This was meant to be a function, but it would give too
 * much overhead, so i made a macro. What it returns is an
 * address as an integer! Additional typecasting is needed
 * to read or write. Use '*(<type> *)' in front of it.
*/
#define mem_accessarray(ptr, size, node)      \
({                                            \
  REGISTER ULONG *___m_addr = ptr;            \
  REGISTER ULONG ___m_total = *___m_addr++;   \
  REGISTER ULONG ___m_cell = *___m_addr++;    \
  REGISTER ULONG ___m_cpos = node * size;     \
  ___m_addr[(___m_total - ((((___m_total <<   \
   (___m_cell & 0x0000FFFF)) - (___m_cpos +   \
  1)) >> (___m_cell & 0x0000FFFF)))) - 1] +   \
           (___m_cpos & (___m_cell >> 16));   \
})

QDEVDECL( void *mem_allocarray(ULONG, ULONG, ULONG, ULONG); )
QDEVDECL( void mem_freearray(void *); )


QDEVDECL( struct nfo_sml_cb *mem_copysmlcb(
                             struct nfo_sml_cb *); )
QDEVDECL( void mem_freesmlcb(struct nfo_sml_cb *); )


QDEVDECL( LONG mem_dosynctasks(ULONG *); )
QDEVDECL( LONG mem_dosynctask(ULONG); )


QDEVDECL( void mem_growpenholder(WORD *, WORD *); )
QDEVDECL( void mem_freepenholder(
                       struct ColorMap *, WORD *); )


QDEVDECL( void *mem_getwbstartup(struct Process *); )

QDEVDECL( void *mem_grabqarea(void); )


QDEVDECL( struct Image *mem_readsrcimage(LONG *, UBYTE *); )
QDEVDECL( void mem_freesrcimage(struct Image *); )


QDEVDECL( void *mem_allochotvec(ULONG, LONG, ULONG); )
QDEVDECL( void *mem_attachhotvec(ULONG, LONG); )
QDEVDECL( void *mem_attachrelhotvec(void *, LONG); )
QDEVDECL( void mem_detachhotvec(void *); )
QDEVDECL( __saveds __interrupt ULONG mem_resolvehotvec(void *); )
QDEVDECL( __saveds __interrupt LONG **mem_obtainhotvec(
                                                  ULONG, LONG); )
QDEVDECL( __saveds __interrupt LONG **mem_obtainrelhotvec(
                                                 void *, LONG); )


/*
 * Leak Free memory allocator based on Hot Vectors!!!
*/
QDEVDECL( void *mem_alloclfvec(ULONG, ULONG); )
QDEVDECL( void mem_freelfvec(void *); )
QDEVDECL( LONG mem_checklfvec(void *); )


QDEVDECL( LONG mem_signalsafe(struct Task *, ULONG); )


/*
 * These symbols can be redefined freely. They are
 * used in function declarator macro.
*/
#ifndef QDEV_MEM_SNIFSIGS
#define QDEV_MEM_SNIFSIGS sigs
#endif
#ifndef QDEV_MEM_SNIFDATA
#define QDEV_MEM_SNIFDATA data
#endif
#ifndef QDEV_MEM_SNIFKERN
#define QDEV_MEM_SNIFKERN SysBase
#endif

/*
 * These two act as variable initializers. Both of
 * them should/must be used inside sniffer func.
*/
#define QDEV_MEM_SNIFUSER(type, sym)          \
type sym = (type)QDEV_MEM_SNIFDATA

#define QDEV_MEM_SNIFEXEC()                   \
QBASEASSIGN2                                  \
(                                             \
  struct ExecBase *, QDEV_MEM_SNIFKERN,       \
  (*((struct ExecBase **) 4))                 \
)

/*
 * As long as just message monitoring is the goal
 * this has to be used at the end of sniffer func
 * so that message(s) will actually be spotted by
 * the task that awaits them.
*/
#define QDEV_MEM_SNIFPASS()                   \
QDEV_MEM_SNIFKERN->ThisTask->tc_SigRecvd |=   \
                          QDEV_MEM_SNIFSIGS

/*
 * Sniffer function declarator aka usercode. This
 * must really be treated like an interrupt!
*/
#define QDEV_MEM_SNIFFUNC(name, code)         \
__interrupt ULONG name(                       \
       REGARG(ULONG QDEV_MEM_SNIFSIGS, d0),   \
       REGARG(void *QDEV_MEM_SNIFDATA, a1))   \
{                                             \
  code                                        \
  return QDEV_MEM_SNIFSIGS;                   \
}

QDEVDECL( void *mem_attachsniffer(
               struct MsgPort *, void *, void *); )
QDEVDECL( void mem_detachsniffer(void *); )


QDEVDECL( ULONG mem_fnv128hash(VUQ128 *, void *, LONG); )


#define QDEV_MEM_LBS_FRELCALL 0x00000001        /* Relative library calls   */
#define QDEV_MEM_LBS_FABSCALL 0x00000002        /* Cached library calls     */
#define QDEV_MEM_LBS_FNOFLUSH 0x00000004        /* Do not flush caches      */

QDEVDECL( struct Library **mem_allocjumptable(LONG, LONG); )
QDEVDECL( void mem_freejumptable(struct Library **); )
QDEVDECL( struct Library **mem_swapjumptable(
                     struct Library *, struct Library **); )
QDEVDECL( LONG mem_importjumptable(
                    struct Library **, struct Library **); )
QDEVDECL( LONG mem_filljumptable(struct Library **,
                                  LONG, LONG, LONG, LONG); )


QDEVDECL( LONG mem_setaddrjtslot(
                           struct Library **, LONG, LONG); )
QDEVDECL( void *mem_setdatajtslot(
                         struct Library **, void *, LONG); )


QDEVDECL( APTR mem_addrfrombase(void *, LONG); )



/*
 * ------------------------ Control routines -------------------------
*/

#define QDEV_CTL_CLIPATH_RESET 0   /* This will clear all path entries      */
#define QDEV_CTL_CLIPATH_FIND  1   /* Used internally, see src. for more... */
#define QDEV_CTL_CLIPATH_ADD   2   /* Add path entry to the list            */
#define QDEV_CTL_CLIPATH_REM   4   /* Remove path entry from the list       */

QDEVDECL( LONG ctl_clipath(LONG, UBYTE *); )


QDEVDECL( APTR ctl_diskreqoff(void); )
QDEVDECL( void ctl_diskreqon(APTR); )
QDEVDECL( ULONG ctl_setclistack(ULONG); )
QDEVDECL( LONG ctl_clirun(UBYTE *, UBYTE *, BOOL); )
QDEVDECL( BOOL ctl_relabel(UBYTE *, UBYTE *); )
QDEVDECL( BOOL ctl_makedir(UBYTE *); )


#define QDEV_CTL_CS_ANSIREL  8     /* Workbench palette location            */
#define QDEV_CTL_CS_ANSICMAP(var)             \
  struct ColorSpec var[] =                    \
  {                                           \
    { 0, 0x0, 0x0, 0x0},  /* ANSI Black    */ \
    { 1, 0xE, 0x0, 0x0},  /* ANSI Red      */ \
    { 2, 0x0, 0xE, 0x0},  /* ANSI Green    */ \
    { 3, 0xE, 0xE, 0x0},  /* ANSI Yellow   */ \
    { 4, 0x0, 0x0, 0xE},  /* ANSI Blue     */ \
    { 5, 0xE, 0x0, 0xE},  /* ANSI Magenta  */ \
    { 6, 0x0, 0xE, 0xE},  /* ANSI Cyan     */ \
    { 7, 0xE, 0xE, 0xE},  /* ANSI White    */ \
    { 8, 0xA, 0xA, 0xA},  /* WB Grey       */ \
    { 9, 0x0, 0x0, 0x0},  /* WB Black      */ \
    {10, 0xF, 0xF, 0xF},  /* WB White      */ \
    {11, 0x8, 0x6, 0xE},  /* WB Blue       */ \
    {-1,   0,   0,   0}   /* Terminator    */ \
  }
#define QDEV_CTL_CS_ANSIDMAP(var)             \
  UWORD var[] =                               \
  {                                           \
    8,  9,  9, 10,                            \
    9, 11, 10,  8,                            \
    10, 9, 10,  9,                            \
    ~0                                        \
  }


#define QDEV_CTL_CSN_MAXWINDOWS    4  /* Total number of consoles           */
#define QDEV_CTL_CSN_MAXINDEX     32  /* Maximum IDCMP index value          */

#define QDEV_CTL_LFLLOGO_STOP  0x00000100 /* Stop anim. if win. inactive    */
#define QDEV_CTL_LFLLOGO_PLAY  0x00000200 /* Play anim. after the call      */
#define QDEV_CTL_LFLLOGO_AREA  0x00000400 /* Do not outmask the logo        */

#define QDEV_CTL_LFLPRIV_HEAD  0x40000000 /* Private: use 'AddHead()'       */
#define QDEV_CTL_LFLPRIV_AWIN  0x80000000 /* Private: window associated     */

struct ctl_csn_feed
{
  struct TextAttr      cf_ta;       /* Std TextAttr, used for font sel.     */
  struct ColorSpec    *cf_cs;       /* Predefined colors                    */
  UWORD               *cf_drimap;   /* DrawInfo mappings                    */
  UBYTE                cf_lfirst;   /* Lock n first colors                  */
  UBYTE                cf_llast;    /* Lock n last colors                   */
  ULONG                cf_modeid;   /* Modeid value                         */
  ULONG                cf_depth;    /* Color depth of the scr., max 8 bits  */
  UBYTE               *cf_handler;  /* Handler str., like "CON:////myshell" */
  UBYTE               *cf_title;    /* Title of the screen                  */
  UBYTE               *cf_pubname;  /* Public screen name                   */
  LONG                 cf_backpen;  /* Background pen number(color)         */
  LONG                 cf_ibgpen;   /* Info background pen                  */
  LONG                 cf_ifgpen;   /* Info foreground pen                  */
  LONG                 cf_active;   /* Number of the window to be active    */
  LONG                 cf_numcon;   /* Number of consoles per screen        */
  BOOL                 cf_commo;    /* Turns on Commodore64 look and feel   */
  BOOL                 cf_behind;   /* Open behind all other screens        */
};

struct ctl_csn_cwin
{
  struct ctl_csn_data *cc_cd;       /* Screen shell back pointer            */
  struct IntuiMessage *cc_imsg;     /* Intuition message                    */
  struct Window       *cc_mainwin;  /* Main window(dont close it!)          */
  BPTR                 cc_con;      /* Console file descriptor              */
  struct MinList       cc_idcmp[QDEV_CTL_CSN_MAXINDEX];
                                    /* IDCMP entry to be executed           */
  LONG                 cc_index;    /* IDCMP index variable                 */
  LONG                 cc_numwin;   /* Number of this window                */
  LONG                 cc_zoomed;   /* Was window zoomed last time?         */
  LONG                 cc_zoomfct;  /* Current zoom factor                  */
  LONG                 cc_rpylim;   /* Reposition limit for Y axis          */
  ULONG                cc_iflags;   /* Image/color flags                    */
  ULONG                cc_lflags;   /* Logo playback flags                  */
};

struct ctl_csn_ient
{
  struct MinNode       ci_node[QDEV_CTL_CSN_MAXWINDOWS];
                                    /* Used for entry stacking              */
  LONG                 ci_idcmpev;  /* IDCMP_#? event flag(single)          */
  void               (*ci_idcmpcode)(
                       struct ctl_csn_cwin *, void *);
                                    /* IDCMP code to be executed            */
  void                *ci_idcmpdata;
                                    /* IDCMP user data (2nd arg.)           */
};

struct ctl_csn_data
{
  struct SignalSemaphore  cd_isem;     /* Intuition related semaphore       */
  WORD                    cd_spad;     /* Semaphore aligning/padding        */
  struct MsgPort          cd_smp;      /* Shared window message port        */
  WORD                    cd_mpad;     /* Message port LONG alinger         */
  struct IntuitionBase   *cd_ib;       /* IntuitionBase pointer             */
  struct GfxBase         *cd_gb;       /* GfxBase pointer                   */
  struct Library         *cd_mb;       /* MathIeeeXXXXBasBase pointer       */
  struct Library         *cd_db;       /* DiskfontBase, can be NULL!        */
  struct TextFont        *cd_tf;       /* TextFont handle, can be NULL!     */
  struct Window          *cd_actvwin;  /* Window that is active now.        */
  struct Layer           *cd_back;     /* Background masking layer          */
  struct Hook             cd_h;        /* Backfill hook carry (layer)       */
  struct Screen          *cd_screen;   /* Screen pointer                    */
  LONG                    cd_signal;   /* Screen signal                     */
  LONG                    cd_numcon;   /* Total number of consoles          */
  ULONG                   cd_winapp;   /* Windows appearance                */
  LONG                    cd_backpen;  /* Background layer pen              */
  LONG                    cd_ibgpen;   /* Info background pen               */
  LONG                    cd_ifgpen;   /* Info foreground pen               */
  WORD                    cd_xzero;    /* Real zero cooridnate for x        */
  WORD                    cd_yzero;    /* Real zero cooridnate for y        */
  struct ctl_csn_cwin     cd_cc[QDEV_CTL_CSN_MAXWINDOWS];
                                       /* Console window array              */
  struct ctl_csn_ient     cd_actidcmp; /* Active window IDCMP entry         */
};

QDEVDECL( struct ctl_csn_data *ctl_openconscreen(
                                  struct ctl_csn_feed *); )
QDEVDECL( void ctl_closeconscreen(struct ctl_csn_data *); )


QDEVDECL( void *ctl_addbartrigger(struct ctl_csn_data *); )
QDEVDECL( LONG ctl_pokebartrigger(void *, struct Window *); )
QDEVDECL( void ctl_rembartrigger(void *); )


struct ctl_csh_data
{
  LONG ct_oldtask;            /* Old console task                           */
  LONG ct_oldcon;             /* Old console output                         */
  LONG ct_newcon;             /* New console output                         */
};

QDEVDECL( void ctl_doconswitch(struct ctl_csh_data *, LONG); )
QDEVDECL( void ctl_undoconswitch(struct ctl_csh_data *); )

QDEVDECL( LONG ctl_findscreensafe(UBYTE *, UBYTE *, LONG); )
QDEVDECL( struct Screen *ctl_lockscreensafe(UBYTE *); )
QDEVDECL( void ctl_unlockscreensafe(struct Screen *); )

QDEVDECL( void ctl_relocdrimap(UWORD *, LONG, UWORD); )

QDEVDECL( void ctl_haltidcmp(struct Window *); )


QDEVDECL( void *ctl_addconlogo(struct ctl_csn_cwin *,
                        struct BitMap *, UWORD, UWORD); )
QDEVDECL( ULONG ctl_swapconlogo(
                void *, struct BitMap *, UWORD, UWORD); )
QDEVDECL( void ctl_remconlogo(void *); )

QDEVDECL( BOOL ctl_getsmparams(UBYTE *, ULONG *, UWORD *); )
QDEVDECL( BOOL ctl_setsmparams(UBYTE *, ULONG *, UWORD *); )


#define QDEV_CTL_RECON_HORIZ 0x00000100   /* Arrange windows horizontally   */
#define QDEV_CTL_RECON_VERTI 0x00000200   /* Arrange windows vertically     */
#define QDEV_CTL_RECON_TILED 0x00000400   /* Tile windows, works with 4!    */
#define QDEV_CTL_RECON_CROSS 0x00000800   /* Visual sep. between windows    */
#define QDEV_CTL_RECON_COMMO 0x00001000   /* Commodore64 alike spacing      */
#define QDEV_CTL_RECON_NOCWB 0x00002000   /* Dont call 'ChangeWindowBox()'  */

QDEVDECL( void ctl_rearrangecon(struct ctl_csn_data *, ULONG); )

QDEVDECL( LONG ctl_zoomifycon(struct ctl_csn_cwin *, LONG); )

QDEVDECL( void *ctl_addviewctrl(struct ctl_csn_data *, ULONG); )
QDEVDECL( void ctl_remviewctrl(void *); )


#define QDEV_CTL_SETCONLF_ANIMPRI 0x00000001   /* Set animation priority    */
#define QDEV_CTL_SETCONLF_ANIMLOW 0x00000002   /* Set anim priority (auto)  */

QDEVDECL( void *ctl_addconlogof(struct ctl_csn_cwin *,
                             UBYTE *, UWORD, UWORD); )
QDEVDECL( void ctl_remconlogof(void *); )
QDEVDECL( LONG ctl_setconlogof(void *, LONG, LONG); )


#define QDEV_CTL_DMT_MAGICID      0x444D5400   /* 'D' 'M' 'T' '\0'          */

#define QDEV_CTL_DMT_FKEEPGOING   0x00000001   /* Keep processing on error  */
#define QDEV_CTL_DMT_FPASSPARMS   0x00000002   /* Allow incomplete params   */
#define QDEV_CTL_DMT_FDISPFS      0x00000004   /* Hunt for filesystems only */
#define QDEV_CTL_DMT_FDISPHAN     0x00000008   /* Hunt for handlers only    */
#define QDEV_CTL_DMT_FDISPEHAN    0x00000010   /* Hunt for ehandlers only   */
#define QDEV_CTL_DMT_FNOMOUNT     0x00000020   /* Do not mount anything     */
#define QDEV_CTL_DMT_FUNIQUEDEV   0x00000040   /* Fix device name collision */
#define QDEV_CTL_DMT_FSIGCALLER   0x00000080   /* Unmount: Singal C,D,E,F   */

/*
 * Please note: The very first byte is being used by 
 * the 'nfo_grepml()' related errors!
*/
#define QDEV_CTL_DMT_ERR_ALLOK    0x00000000   /* Everything seems fine     */
#define QDEV_CTL_DMT_ERR_MOUNTED  0x00001000   /* Already mounted           */
#define QDEV_CTL_DMT_ERR_NOMEM    0x00002000   /* No memory available       */
#define QDEV_CTL_DMT_ERR_DOSLINK  0x00004000   /* DOS list linking error    */
#define QDEV_CTL_DMT_ERR_UNKNOWN  0x00008000   /* Unknown mountblock type   */
#define QDEV_CTL_DMT_ERR_UNIT     0x00010000   /* Unit not specified        */
#define QDEV_CTL_DMT_ERR_DEVICE   0x00020000   /* Device not specified      */
#define QDEV_CTL_DMT_ERR_HANDLER  0x00040000   /* Handler not specified     */
#define QDEV_CTL_DMT_ERR_BLOCK    0x00080000   /* Blocksize is invalid      */
#define QDEV_CTL_DMT_ERR_NOGROW   0x00100000   /* Hicyl lower than lowcyl   */
#define QDEV_CTL_DMT_ERR_HEADS    0x00200000   /* Surfaces is zero          */
#define QDEV_CTL_DMT_ERR_BPT      0x00400000   /* Blockpertrack is zero     */
#define QDEV_CTL_DMT_ERR_LOWSTCK  0x00800000   /* Stack is too low          */
#define QDEV_CTL_DMT_ERR_KEYS     0x01000000   /* Some keys are invalid     */
#define QDEV_CTL_DMT_ERR_IGNORED  0xFFFFFFFF   /* Entry was ignored         */

/*
 * States for 'ctl_devunmount()'(CB).
*/
#define QDEV_CTL_DMT_STATE_FAIL   0x00000000   /* Dev. cannot be unmounted  */
#define QDEV_CTL_DMT_STATE_CLEAN  0x00000001   /* Device unmounted cleanly  */
#define QDEV_CTL_DMT_STATE_FORCE  0x00000002   /* Device unmounted forcibly */

struct ctl_umn_cb
{
  UBYTE *uc_devname;                        /* Device name                  */
  LONG   uc_state;                          /* Device state                 */
  void  *uc_userdata;                       /* Private data                 */
};

QDEVDECL( LONG dmt_mountcb(struct nfo_sml_cb *); )

QDEVDECL( LONG ctl_devmount(UBYTE *, UBYTE *, LONG,
 ULONG, void *, LONG (*)(struct nfo_sml_cb *)); )
QDEVDECL( LONG ctl_devunmount(UBYTE *, ULONG,
        void *, void (*)(struct ctl_umn_cb *)); )


#define QDEV_CTL_UDS_FADD  0x00000001       /* Add multiassign entry        */
#define QDEV_CTL_UDS_FREM  0x00000002       /* Remove multiassign entry     */
#define QDEV_CTL_UDS_FLATE 0x00000004       /* Assign late(non-existant)    */
#define QDEV_CTL_UDS_FPATH 0x00000008       /* Assign path(swappable)       */

QDEVDECL( LONG ctl_udirassign(UBYTE *, UBYTE *, ULONG); )


QDEVDECL( __interrupt void ctl_addidcmphandler(
         struct ctl_csn_cwin *, struct ctl_csn_ient *); )
QDEVDECL( __interrupt void ctl_remidcmphandler(
         struct ctl_csn_cwin *, struct ctl_csn_ient *); )

QDEVDECL( void ctl_swapbackpen(struct ctl_csn_data *, ULONG); )

QDEVDECL( struct Process *ctl_newshell(LONG, UBYTE *); )



/*
 * ------------------------ Informational stuff ----------------------
*/

struct nfo_fsq_cb
{
  LONG              fc_userlen;  /* Prealloc. user space length             */
  UBYTE            *fc_userptr;  /* Prealloc. user space, min 4 bytes       */
  LONG              fc_exlen;    /* ExAll data buffer length                */
  UBYTE            *fc_file;     /* File or path to be 'Lock()'ed           */
  LONG              fc_edval;    /* ED_xxx value to request amount of data  */
  ULONG             fc_termsig;  /* UBYTE 'sig' must be (1L << sig)!        */
  void             *fc_userdata; /* General purpose variable, user data     */
  void             *fc_usercode; /* CB func. as passed to 'nfo_fsquery()'   */
  struct ExAllData *fc_ead;      /* ExAllData structure                     */
};

QDEVDECL( BOOL nfo_fsquery(ULONG, ULONG, UBYTE *, LONG, ULONG, 
               void *, BOOL (*)(struct nfo_fsq_cb *)); )


#define QDEV_NFO_ISDEV64BIT_ERR   -1                        /* Error        */
#define QDEV_NFO_ISDEV64BIT_NOPE  QDEV_DEV_DISKCMDSET_STD   /* Standard     */
#define QDEV_NFO_ISDEV64BIT_NSD64 QDEV_DEV_DISKCMDSET_NSD64 /* NSD64        */
#define QDEV_NFO_ISDEV64BIT_TD64  QDEV_DEV_DISKCMDSET_TD64  /* TD64         */

QDEVDECL( LONG nfo_isdev64bit(UBYTE *, LONG); )
QDEVDECL( LONG nfo_ispdev64bit(UBYTE *); )


#define QDEV_NFO_XXXVERCMP_DISK   0  /* Res. could be loaded or is in mem.  */
#define QDEV_NFO_XXXVERCMP_MEM    1  /* The resource should be in memory    */

QDEVDECL( WORD nfo_libvercmp(
                       LONG, UBYTE *, UWORD, UBYTE *); )
QDEVDECL( WORD nfo_devvercmp(
                  LONG, UBYTE *, LONG, UWORD, UBYTE *); )


QDEVDECL( LONG nfo_stackreport(ULONG); )
QDEVDECL( BOOL nfo_stackvalid(ULONG); )
QDEVDECL( ULONG nfo_m68kcputype(void); )
QDEVDECL( LONG nfo_isdirectory(LONG); )
QDEVDECL( BOOL nfo_ismode15khz(ULONG); )
QDEVDECL( void *nfo_fssmvalid(void *); )


#define QDEV_NFO_SCANML_PREPDE(dei)           \
({                                            \
   struct DosEnvec *___m_de = dei;            \
   ___m_de->de_TableSize = DE_BOOTBLOCKS;     \
   ___m_de->de_SizeBlock = (512 >> 2);        \
   ___m_de->de_SecOrg = 0;                    \
   ___m_de->de_Surfaces = 2;                  \
   ___m_de->de_SectorPerBlock = 1;            \
   ___m_de->de_BlocksPerTrack = 11;           \
   ___m_de->de_Reserved = 2;                  \
   ___m_de->de_PreAlloc = 0;                  \
   ___m_de->de_Interleave = 0;                \
   ___m_de->de_LowCyl = 0;                    \
   ___m_de->de_HighCyl = 79;                  \
   ___m_de->de_NumBuffers = 32;               \
   ___m_de->de_BufMemType = 3;                \
   ___m_de->de_MaxTransfer = 0x1FE00;         \
   ___m_de->de_Mask = 0xFFFFFFE;              \
   ___m_de->de_BootPri = 0;                   \
   ___m_de->de_DosType = 0x444F5300;          \
   ___m_de->de_Baud = 1200;                   \
   ___m_de->de_Control = 0;                   \
   ___m_de->de_BootBlocks = 0;                \
})

#define QDEV_NFO_SCANML_HANHAN    1     /* Handler is handler               */
#define QDEV_NFO_SCANML_HANEHAN   2     /* Handler is ehandler              */
#define QDEV_NFO_SCANML_HANFS     4     /* Handler is filesystem            */

/*
 * These are keyword presence detection flags.
*/
#define QDEV_NFO_SCANML_PF_HANDLER         0x00000001
#define QDEV_NFO_SCANML_PF_EHANDLER        0x00000002
#define QDEV_NFO_SCANML_PF_FILESYSTEM      0x00000004
#define QDEV_NFO_SCANML_PF_DEVICE          0x00000008
#define QDEV_NFO_SCANML_PF_UNIT            0x00000010
#define QDEV_NFO_SCANML_PF_FLAGS           0x00000020
#define QDEV_NFO_SCANML_PF_BLOCKSIZE       0x00000040
#define QDEV_NFO_SCANML_PF_SURFACES        0x00000080
#define QDEV_NFO_SCANML_PF_BLOCKSPERTRACK  0x00000100
#define QDEV_NFO_SCANML_PF_SECTORPERBLOCK  0x00000200
#define QDEV_NFO_SCANML_PF_RESERVED        0x00000400
#define QDEV_NFO_SCANML_PF_PREALLOC        0x00000800
#define QDEV_NFO_SCANML_PF_INTERLEAVE      0x00001000
#define QDEV_NFO_SCANML_PF_LOWCYL          0x00002000
#define QDEV_NFO_SCANML_PF_HIGHCYL         0x00004000
#define QDEV_NFO_SCANML_PF_BUFFERS         0x00008000
#define QDEV_NFO_SCANML_PF_BUFMEMTYPE      0x00010000
#define QDEV_NFO_SCANML_PF_MAXTRANSFER     0x00020000
#define QDEV_NFO_SCANML_PF_MASK            0x00040000
#define QDEV_NFO_SCANML_PF_BOOTPRI         0x00080000
#define QDEV_NFO_SCANML_PF_DOSTYPE         0x00100000
#define QDEV_NFO_SCANML_PF_BAUD            0x00200000
#define QDEV_NFO_SCANML_PF_CONTROL         0x00400000
#define QDEV_NFO_SCANML_PF_BOOTBLOCKS      0x00800000
#define QDEV_NFO_SCANML_PF_STACKSIZE       0x01000000
#define QDEV_NFO_SCANML_PF_PRIORITY        0x02000000
#define QDEV_NFO_SCANML_PF_GLOBVEC         0x04000000
#define QDEV_NFO_SCANML_PF_STARTUP         0x08000000
#define QDEV_NFO_SCANML_PF_ACTIVATE        0x10000000
#define QDEV_NFO_SCANML_PF_FORCELOAD       0x20000000

struct nfo_sml_data
{
  UBYTE  *sd_dosdevice;                 /* Dos device pointer               */
  UBYTE  *sd_handler;                   /* Handler name pointer             */
  LONG    sd_hantype;                   /* Handler type, see above          */
  UBYTE  *sd_device;                    /* Device name pointer              */
  UBYTE  *sd_unit;                      /* Unit [0] = buf, [1-4] = num.     */
  UBYTE  *sd_flags;                     /* Flags [0] = buf, [1-4] = num.    */
  UBYTE  *sd_control;                   /* Control flags pointer            */
  UBYTE  *sd_startup;                   /* Startup [0] = buf, [1-4] = num.  */
  LONG    sd_stacksize;                 /* Stack size for handler           */
  LONG    sd_priority;                  /* Priority of the handler          */
  LONG    sd_globvec;                   /* Globvec                          */
  LONG    sd_activate;                  /* Activate trigger                 */
  LONG    sd_forceload;                 /* Forceload trigger                */
  UBYTE  *sd_errors;                    /* Pointer to broken entries(text)  */
};

struct nfo_sml_cb
{
  struct DosList            sc_dol;      /* Keep it first! Not used.        */
  ULONG                     sc_fake1;    /* Fake fssm alloc length, 0       */
  ULONG                     sc_wall1;    /* Zero wall(alignment)            */
  struct FileSysStartupMsg  sc_fssm;     /* Not used by the scanner!        */
  ULONG                     sc_fake2;    /* Fake de alloc length, 0         */
  ULONG                     sc_wall2;    /* Zero wall(alignment)            */
  struct DosEnvec           sc_de;       /* Dos environment structure       */
  struct nfo_sml_data       sc_sd;       /* Other/additional Ml. data       */
  ULONG                     sc_pflags;   /* Keyword presence flags          */
  ULONG                     sc_eflags;   /* Keyword error flags             */
  LONG                      sc_gerror;   /* 'nfo_grepml()' error value      */
  UBYTE                    *sc_file;     /* Func. file name                 */
  void                     *sc_userdata; /* General purpose pointer         */
};

QDEVDECL( LONG nfo_scanml(LONG, UBYTE *, LONG, ULONG, UBYTE *, 
  struct DosEnvec *, void *, LONG (*)(struct nfo_sml_cb *)); )


#define QDEV_NFO_GREPML_ERR_ALLOK   0   /* There were no errors             */
#define QDEV_NFO_GREPML_ERR_NOPARM  1   /* Ml. lacks a must have params     */
#define QDEV_NFO_GREPML_ERR_RANGE   2   /* Ml. entry not in range           */
#define QDEV_NFO_GREPML_ERR_DEVICE  4   /* Ml. e. has no dev. or cant open  */
#define QDEV_NFO_GREPML_ERR_DEVFIT  8   /* Ml. entry doesnt fit on the dev. */
#define QDEV_NFO_GREPML_ERR_DEV64  16   /* Ml. entry requires 64bit device  */

QDEVDECL( LONG nfo_grepml(LONG, UBYTE *, LONG, ULONG, UBYTE *,
               LONG, void *, LONG (*)(struct nfo_sml_cb *)); )


#define QDEV_NFO_FGSALL(modeid)               \
  nfo_findgfxsm(modeid, 0, 0x0, 0xFFFFFFFF)

#define QDEV_NFO_FGS15KHZ(modeid)             \
  nfo_findgfxsm(modeid, 0, 0xFFFF, 0x2FFFF)       

#define QDEV_NFO_FGSNATIVE(modeid)            \
  nfo_findgfxsm(modeid, 0, 0xFFFF, 0xAFFFF)

#define QDEV_NFO_FGSBOARD(modeid)             \
  nfo_findgfxsm(modeid, 0, 0xAFFFF, 0xFFFFFFFF)

QDEVDECL( APTR nfo_findgfxsm(ULONG, ULONG, ULONG, ULONG); )

QDEVDECL( BOOL nfo_findgfxrange(UBYTE *, ULONG *, ULONG *); )


#define DIPF_IS_YCOFACT 0x00400000  /* Y reso. tolerance cofactor enable    */
#define DIPF_IS_SIMILAR 0x00800000  /* Try to match similar resolution      */

QDEVDECL( ULONG nfo_findgfxreso(ULONG, ULONG, ULONG, 
                                  ULONG, ULONG, ULONG); )

QDEVDECL( ULONG nfo_findgfxentry(UBYTE *, ULONG *); )


QDEVDECL( LONG nfo_getviscount(struct Screen *); )
QDEVDECL( BOOL nfo_getvisstate(struct Screen *); )

QDEVDECL( ULONG nfo_screencount(void); )
QDEVDECL( ULONG nfo_modeidcount(void); )


#define QDEV_NFO_DRIMAPTYPEI(var)             \
  UWORD var[QDEV_NFO_DRIMAPSIZE] =            \
  {~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0,    \
                   ~0, ~0, ~0, ~0, ~0, ~0}

#define QDEV_NFO_DRIMAPTYPE(var)              \
  UWORD var[QDEV_NFO_DRIMAPSIZE];

#define QDEV_NFO_DRIMAPSIZE 16    /* Size of the pen mapping table(rounded) */

QDEVDECL( BOOL nfo_getdrimap(UWORD *, struct Screen *); )


QDEVDECL( BOOL nfo_getscparams(
                       struct Screen *, ULONG *, UWORD *); )

QDEVDECL( ULONG nfo_typeofgfxmem(ULONG); )

QDEVDECL( LONG nfo_getcmcolors(struct ColorSpec *, 
                         struct ColorMap *, LONG, LONG); )


#define QDEV_NFO_WHICHCS_OCS 0  /* The chipset installed or emulated is OCS */
#define QDEV_NFO_WHICHCS_ECS 1  /* The chipset installed or emulated is ECS */
#define QDEV_NFO_WHICHCS_AGA 2  /* The chipset installed or emulated is AGA */

QDEVDECL( ULONG nfo_whichchipset(void); )

QDEVDECL( LONG nfo_istask(ULONG); )


struct nfo_sct_cb
{
  ULONG *tc_lists;       /* Address to the list array                        */
  ULONG *tc_listaddr;    /* Address of the current list                      */
  void  *tc_itemaddr;    /* Address of the item on the list                  */
  void  *tc_userdata;    /* Userdata pointer                                 */
};

QDEVDECL( ULONG nfo_scanlist(ULONG *, void *, 
                   ULONG (*)(struct nfo_sct_cb *)); )


#define QDEV_NFO_IDCMPMAXINDEX 32   /* Total number of flags(rounded)        */

QDEVDECL( __interrupt LONG nfo_idcmptoindex(ULONG); )


QDEVDECL( BOOL nfo_isblitable(void *, ULONG); )

QDEVDECL( LONG nfo_numdivisors(LONG); )
QDEVDECL( BOOL nfo_isprime(LONG); )
QDEVDECL( LONG nfo_nearestprime(LONG); )


QDEVDECL( BOOL nfo_isconsole(UBYTE *, LONG); )


#define QDEV_NFO_KTM_FPRIO    0x00000001   /* This f. takes arg(-128 to 127) */
#define QDEV_NFO_KTM_FSIGNAL  0x00000002   /* This f. takes signal in arg.   */
#define QDEV_NFO_KTM_FSTATE   0x00000004   /* This f. takes arg(0 = freeze). */
#define QDEV_NFO_KTM_FNOCASE  0x00000008   /* Turn off case sensitivity      */
#define QDEV_NFO_KTM_FMASS    0x00000010   /* Iterate all matching tasks     */
#define QDEV_NFO_KTM_FPORTS   0x00000020   /* Switch to ports                */
#define QDEV_NFO_KTM_FPRTOWN  0x00000040   /* Show port owners               */
#define QDEV_NFO_KTM_FICHAR   0x00000080   /* Inner character search         */

QDEVDECL( ULONG nfo_ktm(LONG, UBYTE *, ULONG, LONG); )
QDEVDECL( ULONG nfo_waitback(
                       UBYTE *, ULONG, LONG, ULONG); )


QDEVDECL( LONG nfo_ischildofproc(
                     struct Task *, struct Process *); )

QDEVDECL( LONG nfo_issegremote(struct Process *); )

QDEVDECL( LONG nfo_isinstack(struct Task *, void *); )


QDEVDECL( struct MemEntry *nfo_isonmemlist(
                            struct MemList *, void *); )
QDEVDECL( struct MemEntry *nfo_isonlistofml(
                               struct List *, void *); )

QDEVDECL( struct RDArgs *nfo_getargsource(
                            LONG *, UBYTE *, UBYTE *); )
QDEVDECL( void nfo_freeargsource(struct RDArgs *); )


QDEVDBDECL( __nifunc __interrupt void nfo_getsystime(
                            struct timeval *, void *); )

QDEVDECL( struct Window *nfo_getwinaddr(LONG); )

QDEVDECL( BOOL nfo_iswindow(struct Window *); )

QDEVDECL( struct ConUnit *nfo_getconunit(LONG ); )

QDEVDECL( struct IOStdReq *nfo_getconioreq(LONG); )


#define QDEV_NFO_STURBO_NODEH(stu) QDEV_HLP_DSNODEH(*(stu)->stu_ln)
#define QDEV_NFO_STURBO_NODET(stu) QDEV_HLP_DSNODET(*(stu)->stu_ln)
#define QDEV_NFO_STURBO_LISTA(stu) *(stu)->stu_lhtab
#define QDEV_NFO_STURBO_LISTP(stu) *QDEV_NFO_STURBO_LISTA(stu)

#define QDEV_NFO_STURBO_BREAK(stu)            \
({                                            \
  QDEV_HLP_DSBREAK(*(stu)->stu_ln);           \
  QDEV_NFO_STURBO_LISTA(stu)=(stu)->stu_btab; \
})  

#define QDEV_NFO_STURBO_MATCH(stu, addr)      \
({                                            \
  REGISTER LONG *___h___ =                    \
      (LONG *)QDEV_NFO_STURBO_NODEH(stu);     \
  REGISTER LONG *___t___ =                    \
      (LONG *)QDEV_NFO_STURBO_NODET(stu);     \
  REGISTER LONG *___a___ = (LONG *)addr;      \
  QDEV_NFO_DSMATCH(                           \
              ___h___, ___t___, ___a___);     \
})

struct nfo_stu_cb
{
  struct Node **stu_ln[4];                /* Addresses of node variables    */
  LONG        **stu_lhtab;                /* Address of list table sym.     */
  LONG         *stu_btab;                 /* Break table of 2 LONGs (NULL)  */
  void         *stu_udata;                /* User data pointer              */
  LONG          stu_ures;                 /* User result variable (func)    */
};

QDEVDECL( LONG nfo_scanturbo(
       LONG *, void *, void (*)(struct nfo_stu_cb *)); )



/*
 * ------------------------ Resident modules -------------------------
*/

#define QDEV_MOD_KTL_PTRBITMASK (1L << 31)  /* Value used to [de]scramble    */

struct mod_ktl_head
{
  struct MemChunk  kh_mc;     /* Reserved area, bootstrap alloc.             */
  ULONG           *kh_ar[2];  /* [0] = 'Resident', [1] = Next entry          */
  struct Resident  kh_rt;     /* Module parameters buffer space              */
  struct MemList   kh_ml;     /* Memory list that will be linked in          */

  /*
   * This structure is considered header thus you may enlarge the
   * effective MemEntry block by allocating more than the size of
   * struct mod_ktl_head or just stuff your data after it.
  */
};

QDEVDECL( BOOL mod_kicktaglink(struct mod_ktl_head *); )
QDEVDECL( void mod_kicktagunlink(struct mod_ktl_head *); )


#define QDEV_MOD_ADE_DUMMYCODE  0x70004E75 /* moveq #0,d0; rts              */
#define QDEV_MOD_ADE_24BITLOWER 0x00001000 /* Start addr. of the 24bit area */
#define QDEV_MOD_ADE_24BITUPPER 0x00FFFFFF /* End address of the 24bit area */
#define QDEV_MOD_ADE_32BITLOWER 0x01000000 /* Start addr. of the 32bit area */
#define QDEV_MOD_ADE_32BITUPPER 0x7FFFFFFF /* End address of the 32bit area */

struct mod_ade_feed
{
  ULONG    af_memflags;      /* Standard memory flags                       */
  ULONG    af_memstart;      /* Physical start address of possible alloc.   */
  ULONG    af_memend;        /* Physical end address of possible alloc.     */
  UBYTE   *af_dataptr;       /* Pointer to user code or data, can be NULL   */
  LONG     af_datalen;       /* Length of that code or data, can be 0       */
  ULONG    af_rtflags;       /* Standard resident flags                     */
  UBYTE    af_type;          /* Type of object NT_xxx                       */
  BYTE     af_pri;           /* Priority of the module                      */
  UBYTE    af_ver;           /* Version number of the module                */
  UBYTE   *af_nameptr;       /* Name of the module                          */
  UBYTE   *af_idstrptr;      /* Id string of the module                     */
};

QDEVDECL( void *mod_addmodule(struct mod_ade_feed *); )
QDEVDECL( void mod_delmodule(struct mod_ktl_head *); )


#define QDEV_MOD_FSB_ME_VER      -1 /* Find the mod. knowing its version    */
#define QDEV_MOD_FSB_ME_NAME     -2 /* Find the mod. knowing its name       */
#define QDEV_MOD_FSB_ME_IDSTR    -4 /* Find the mod. knowing its idstring   */
#define QDEV_MOD_FSB_ME_DATAPTR  -8 /* Find the mod. knowing its code addr. */
#define QDEV_MOD_FSB_ME_NTTYPE  -16 /* Find the mod. knowing its NT_xxx     */

QDEVDECL( struct Resident *mod_findktpresby(LONG, UBYTE *); )


QDEVDECL( BOOL mod_ktpresunlink(struct Resident *); )
QDEVDECL( struct MemList *mod_getmemlist(void *, LONG); )
QDEVDECL( LONG mod_ktprescount(void); )


QDEVDECL( struct MemList *mod_codereloc(
                                LONG, ULONG, ULONG, ULONG); )
QDEVDECL( void mod_codefree(struct MemList *); )
QDEVDECL( struct Resident *mod_codefind(struct MemEntry *); )


#define QDEV_MOD_DISKMOD_FLOADALL 0x00000001  /* Load all (CODE/DATA/BSS)   */
#define QDEV_MOD_DISKMOD_FENDSKIP 0x00000002  /* Recompute rt_EndSkip       */
#define QDEV_MOD_DISKMOD_FNULLTAG 0x00000004  /* Clear original ROMTag      */

struct mod_adi_feed
{
  ULONG    af_memflags;      /* Std. memory flags(MEMF_CHIP, MEMF_LOCAL)    */
  ULONG    af_memstart;      /* Physical start address of possible alloc.   */
  ULONG    af_memend;        /* Physical end address of possible alloc.     */
  ULONG    af_flags;         /* Loader control flags QDEV_MOD_DISKMOD_#?    */
  LONG     af_error;         /* Loader error field(non-memory err. only)    */
};

QDEVDECL( void *mod_adddiskmodule(LONG, struct mod_adi_feed *); )
QDEVDECL( void mod_deldiskmodule(struct mod_ktl_head *); )



/*
 * ------------------------ Device routines --------------------------
*/

struct dev_ddv_data
{
  struct MsgPort *dd_mp;         /* Device message port                     */
  struct IOExtTD *dd_iotd;       /* Device request space                    */
  void           *dd_usercode;   /* General puprose variable                */
  void           *dd_userdata;   /* General puprose variable                */
};

QDEVDECL( struct dev_ddv_data *dev_opendiskdev(
                                  UBYTE *, LONG, LONG); )
QDEVDECL( void dev_closediskdev(struct dev_ddv_data *); )


QDEVDECL( void *dev_getdiskrdb(struct dev_ddv_data *); )
QDEVDECL( void dev_freediskrdb(void *); )
QDEVDECL( void *dev_getdiskgeo(struct dev_ddv_data *); )
QDEVDECL( void dev_freediskgeo(void *); )


#define QDEV_DEV_DISKCMDSET_STD   0  /* The dev. doesnt support 64bit cmds  */
#define QDEV_DEV_DISKCMDSET_NSD64 2  /* The dev. supports NewStyleDevice64  */
#define QDEV_DEV_DISKCMDSET_TD64  4  /* The dev. supports TrackDisk64       */

QDEVDECL( LONG dev_getdiskcmdset(struct dev_ddv_data *); )


QDEVDECL( LONG dev_sizeingigs(LONG, LONG, LONG, LONG); )



/*
 * ------------------------ DOS device funcs -------------------------
*/

#define QDEV_DOS_MDE_MAGICID      0x4D444500   /* 'M' 'D' 'E' '\0'          */

QDEVDECL( struct DosList *dos_makedevice(UBYTE *); )
QDEVDECL( struct DosList *dos_killdevice(struct DosList *); )


QDEVDECL( UBYTE *dos_bcopydevice(UBYTE *, UBYTE *, LONG); )
QDEVDECL( struct DosList *dos_bcheckdevice(UBYTE *, LONG); )
QDEVDECL( struct DosList *dos_checkdevice(UBYTE *, LONG); )
QDEVDECL( struct DosList *dos_devbymsgport(struct MsgPort *); )


QDEVDECL( void dos_replypacket(struct DosPacket *, 
                            struct MsgPort *, LONG, LONG); )
QDEVDECL( struct DosPacket *dos_getpacket(struct MsgPort *); )
QDEVDECL( struct DosPacket *dos_waitpacket(
                                 struct MsgPort *, ULONG); )
QDEVDECL( LONG dos_dopacket(struct MsgPort *, LONG,
                            LONG, LONG, LONG, LONG, LONG); )


QDEVDECL( BOOL dos_addfdrelay(UBYTE *, ULONG); )
QDEVDECL( LONG dos_remfdrelay(UBYTE *); )

QDEVDECL( void *dos_getfmfdrelay(UBYTE *); )
QDEVDECL( void dos_freefmfdrelay(void *); )

QDEVDECL( struct MsgPort *dos_swapmpfdrelay(
                                     LONG, struct MsgPort *); )


/*
 * All these flags are ordinary switches.
*/
#define QDEV_DOS_FDR_RETURNFD         0x00000001 /* Ret. the f. d. address  */
#define QDEV_DOS_FDR_CHANNOTDEFAULT   0x00000002 /* Unset default flag      */
#define QDEV_DOS_FDR_CHANISDEFAULT    0x00000004 /* Set the default flag    */
#define QDEV_DOS_FDR_NOTERMFILES      0x00000008 /* Dont t. f. if no cli.   */
#define QDEV_DOS_FDR_TERMFILES        0x00000010 /* Term. f. if no clients  */
#define QDEV_DOS_FDR_NOCHANPIPE       0x00000020 /* Turn ch. into regular   */
#define QDEV_DOS_FDR_CHANPIPE         0x00000040 /* Turn ch. into pipe      */
#define QDEV_DOS_FDR_NOCHANROUTER     0x00000080 /* Turn ch. into regular   */
#define QDEV_DOS_FDR_CHANROUTER_P     0x00000100 /* T. ch. into pipe router */
#define QDEV_DOS_FDR_CHANROUTER_R     0x00000200 /* Turn ch. into relay r.  */
#define QDEV_DOS_FDR_NOGENEOF         0x00000400 /* Dont allow EOF gen.     */
#define QDEV_DOS_FDR_GENEOF           0x00000800 /* Allow EOF generation    */
#define QDEV_DOS_FDR_REMTHISFILE      0x00002000 /* Remove this file        */
#define QDEV_DOS_FDR_DONTCLOSEFILE    0x00004000 /* Dont close f. upon quit */
#define QDEV_DOS_FDR_CLOSEFILE        0x00008000 /* Do close f. upon quit   */
#define QDEV_DOS_FDR_NOFILEBUFFER     0x00010000 /* Forbid f. buffering     */
#define QDEV_DOS_FDR_FILEBUFFER       0x00020000 /* Permit f. buffering     */
#define QDEV_DOS_FDR_DONTSTRIPANSI    0x00040000 /* Dont strip ANSI seqs    */
#define QDEV_DOS_FDR_STRIPANSI        0x00080000 /* Do strip ANSI sequences */
#define QDEV_DOS_FDR_CSIQUERY         0x00100000 /* Allow CSI q. per file   */
#define QDEV_DOS_FDR_VCRMODE          0x00200000 /* File is a VCR tape      */
#define QDEV_DOS_FDR_WRITEFLUSH       0x00400000 /* Flush() after relaying  */

/*
 * All these flags take argument. First two in 'file'
 * and the rest in 'arg'.
*/
#define QDEV_DOS_FDR_FILEISTEXT       0x04000000 /* File is normal string   */
#define QDEV_DOS_FDR_FILEISADDR       0x08000000 /* File is address(ptr)    */
#define QDEV_DOS_FDR_SETTERMSIGNAL    0x10000000 /* Termination signal      */
#define QDEV_DOS_FDR_SETLINEFORMAT    0x20000000 /* Prefix line format      */
#define QDEV_DOS_FDR_SETROLLBUFLEN    0x40000000 /* Virtual file size       */
#define QDEV_DOS_FDR_SETFLUSHREQ      0x80000000 /* Number of reqs to flush */

QDEVDECL( LONG dos_ctrlfdrelay(UBYTE *, UBYTE *, UBYTE *,
                                     ULONG, ULONG, ULONG); )


QDEVDECL( BOOL dos_addlinkpoint(UBYTE *, UBYTE *, ULONG); )
QDEVDECL( LONG dos_remlinkpoint(UBYTE *); )
QDEVDECL( LONG dos_dclinkpoint(UBYTE *); )


/*
 * This is async enabled DOS file descriptor wrapper.
 * Use with maximum care as this is in no way the so
 * famous 'asyncio' compatible subsystem!
*/
#define QFILE_SYNC  1                    /* Descriptor in sync. mode        */
#define QFILE_ASYNC 0                    /* Descriptor in async. mode       */

struct qfile
{
  struct MsgPort        *qf_mp;          /* Message port for async ops      */
  struct StandardPacket  qf_sp;          /* Standard DOS packet             */
  LONG                   qf_in;          /* Operation status indicator      */
  LONG                   qf_mo;          /* Sync or async mode boolean      */
  LONG                   qf_er;          /* Internal I/O error latch        */
  LONG                   qf_si;          /* Operation interrupt signal      */
  LONG                   qf_ti;          /* Loop delay in ticks(async)      */
  LONG                   qf_fd;          /* Real DOS file descriptor        */
};

QDEVDECL( struct qfile *dos_qflink(BPTR); )
QDEVDECL( struct qfile *dos_qfopen(UBYTE *, LONG); )
QDEVDECL( void dos_qfclose(struct qfile *); )
QDEVDECL( LONG dos_qfwait(struct qfile *, LONG); )
QDEVDECL( LONG dos_qfabort(struct qfile *); )
QDEVDECL( LONG dos_qfispending(struct qfile *); )
QDEVDECL( void dos_qfsetmode(struct qfile *, LONG); )
QDEVDECL( void dos_qfsetintsig(struct qfile *, LONG); )
QDEVDECL( void dos_qfsetfctwait(struct qfile *, LONG); )
QDEVDECL( LONG dos_qfread(struct qfile *, void *, LONG); )
QDEVDECL( LONG dos_qfwrite(struct qfile *, void *, LONG); )
QDEVDECL( LONG dos_qfseek(struct qfile *, LONG, LONG); )



/*
 * ------------------------ Auto. code merge -------------------------
*/

#ifdef ___QDEV_CODESNIPPET
___QDEV_CODESNIPPET
#endif
#ifdef ___QDEV_FILESNIPPET
#include ___QDEV_FILESNIPPET
#endif



#endif /* ___QDEV_H_INCLUDED___ */
