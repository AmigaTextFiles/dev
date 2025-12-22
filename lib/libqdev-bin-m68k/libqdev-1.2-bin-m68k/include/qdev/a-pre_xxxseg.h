/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * pre_xxxseg.h
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'QSI'    is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'QSI'    is   distributed  in  the  hope  that  it  will  be useful,
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
 * $VER: a-pre_xxxseg.h 1.00 (29/02/2012) QSI
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * If  you  need  external  modules  in  your program,  but do not want
 * library complexity, then this will do nicely. What you need is  your
 * code that is ought to  be detachable and symbol definition. And that
 * is about it. Look how simple this really is:
 *
 *     1 #define ___QDEV_SEGINIT_SYMBOLS             \
 *     2         ___QDEV_SEGINIT_ADDINT(0xAABBCCDD)  \  // <data>[0]
 *     3         ___QDEV_SEGINIT_ADDSYM(myfunc)         // <data>[1]
 *     4
 *     5 #define ___QDEV_SEGINIT_VERSION             \
 *     6         ___QDEV_SEGINIT_PREPVER(            \
 *     7           "mymod", 1, 0, __DATE__, "beta")
 *     8
 *     9 #include <a-pre_xxxseg.h>
 *    10
 *    11 int myfunc(int a)
 *    12 {
 *    13   return a;
 *    14 }
 *
 *    gcc mymod.c -o mymod.so -nostartfiles -I/gg/include/qdev
 *
 *
 * If  you  do  not  want  automatic header creation then do not define
 * the  '___QDEV_SEGINIT_SYMBOLS' . As to '___QDEV_SEGINIT_VERSION', it
 * is totally optional.
 *
 * To load the module in your program use 'LoadSeg()'. An example below
 * explains cryptic '<data>[n]' comments:
 *
 *     1 #include <a-pre_xxxseg.h>
 *     2
 *     3 #include <proto/dos.h>
 *     4
 *     5 int main(void)
 *     6 {
 *     7   int (*myfunc)(int);
 *     8   LONG *data;
 *     9   LONG segs;
 *    10
 *    11   if ((segs = LoadSeg("mymod.so")))
 *    12   {
 *    13     if ((data = ___QDEV_SEGINIT_FINDPTR(segs)))
 *    14     {
 *    15       if (data[0] == 0xAABBCCDD)               // Our magic
 *    16       {
 *    17         myfunc = (void *)data[1];
 *    18
 *    19         FPrintf(Output(), "%ld\n", myfunc(2012));
 *    20       }
 *    21     }
 *    22
 *    23     UnLoadSeg(segs);
 *    24   }
 *    25
 *    26   return 0;
 *    27 }
 *
 *
 * Aside  from  static symbol references, binds are also possible. This
 * is analogous to what 'g_module_symbol()' from 'glib' does.  It finds
 * given symbol address by its literal name. Please note that resolving
 * binds is much slower than locating static references. But in general
 * no  vector  preallocation  is  necessary,  so there is great freedom
 * about the ABI and API. Static  refrences  and binds can coexist, but
 * it is preferred to choose just one method and stick to it.
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXSEG_H_INCLUDED___
#define ___XXXSEG_H_INCLUDED___



/*
 * Symbol binding macro can be used in case you need
 * automatic resolving independently of function pos.
 * Please note that this will surely require function
 * prototypes in front of '___QDEV_SEGINIT_GLOBTAB'!
 * 
*/
#define ___QDEV_SEGINIT_ADDBIND(sym)          \
{                                             \
  ___QDEV_SEGINIT_MKSTR(sym),                 \
  (void *)sym                                 \
},

/*
 * Symbol and integer insertion macros. Should be used
 * against destination macro.
*/
#define ___QDEV_SEGINIT_ADDSYM(sym)           \
"\n\t	.long 				"     \
	"_" ___QDEV_SEGINIT_MKSTR(sym)

#define ___QDEV_SEGINIT_ADDINT(int)           \
"\n\t	.long 				"     \
	___QDEV_SEGINIT_MKSTR(int)



/*
 * Version prepare macro. This will emit Amiga like
 * version information.
*/
#define ___QDEV_SEGINIT_PREPVER(n, v, r, d, c)\
"\0\0$VER: " n " " ___QDEV_SEGINIT_MKSTR(v)   \
"." ___QDEV_SEGINIT_MKSTR(r) " (" d ") " c "\0"

/*
 * Stringifier.
*/
#define ___QDEV_SEGINIT_MKSTR(str)            \
        ___QDEV_SEGINIT_MKSTR2(str)
#define ___QDEV_SEGINIT_MKSTR2(str) #str



/*
 * Main startup code for the segment. Always place it
 * before any other data or code!
*/
#define ___QDEV_SEGINIT_GLOBTAB(s, b, v)      \
asm("\t	.text				"     \
"\n\t	.even				"     \
"\n\t	.globl				"     \
	___QDEV_SEGINIT_MKSTR(                \
	___QDEV_SEGINIT_FAILSSYM)             \
"\n\t					"     \
	___QDEV_SEGINIT_MKSTR(                \
	___QDEV_SEGINIT_FAILSSYM) ":"         \
	___QDEV_SEGINIT_ADDINT(               \
	___QDEV_SEGINIT_FAILSAFE)             \
	___QDEV_SEGINIT_ADDINT(               \
	___QDEV_SEGINIT_BINDSECT)             \
	___QDEV_SEGINIT_ADDSYM(               \
	___QDEV_SEGINIT_BINDSYM)              \
	s                                     \
	___QDEV_SEGINIT_ADDINT(               \
	___QDEV_SEGINIT_TABLEEND));           \
struct ___qst ___QDEV_SEGINIT_BINDSYM[] =     \
{                                             \
  b                                           \
  {                                           \
    0,                                        \
    0                                         \
  },                                          \
  {                                           \
    v,                                        \
    0                                         \
  }                                           \
}

/*
 * Some segment initializers. Failsafe must be valid
 * op code!
*/
#ifndef ___QDEV_SEGINIT_FAILSAFE
#define ___QDEV_SEGINIT_FAILSAFE   0x70004E75
#endif
#ifndef ___QDEV_SEGINIT_FAILSSYM
#define ___QDEV_SEGINIT_FAILSSYM   ___qdev_seginit_fs
#endif
#ifndef ___QDEV_SEGINIT_BINDSECT
#define ___QDEV_SEGINIT_BINDSECT   0x42494E44
#endif
#ifndef ___QDEV_SEGINIT_BINDSYM
#define ___QDEV_SEGINIT_BINDSYM    ___qdev_seginit_binds
#endif
#ifndef ___QDEV_SEGINIT_TABLEEND
#define ___QDEV_SEGINIT_TABLEEND   0
#endif

/*
 * Symbol binding structure.
*/
struct ___qst
{
  char   *qst_name;        /* Literal symbol name                           */
  void   *qst_addr;        /* Symbol address or reference                   */
};



/*
 * Data and symbol resolvers.
*/
#define ___QDEV_SEGINIT_FINDPTR(segs)         \
({                                            \
  long *___m_data =                           \
             (long *)(((long)segs << 2) + 4); \
  if ((___m_data[0] ==                        \
                 ___QDEV_SEGINIT_FAILSAFE) && \
      (___m_data[1] ==                        \
                   ___QDEV_SEGINIT_BINDSECT)) \
  {                                           \
   ___m_data = &___m_data[3];                 \
  }                                           \
  else                                        \
  {                                           \
   ___m_data = 0;                             \
  }                                           \
  ___m_data;                                  \
})

#define ___QDEV_SEGINIT_FINDSYM(data, name)   \
({                                            \
  void *___m_ptr = 0;                         \
  struct ___qst *___m_qst =                   \
                (void *)(((long *)data)[-1]); \
  while(___m_qst->qst_addr)                   \
  {                                           \
    if (txt_strcmp(                           \
              name, ___m_qst->qst_name) == 0) \
    {                                         \
      ___m_ptr = ___m_qst->qst_addr;          \
      break;                                  \
    }                                         \
    ___m_qst++;                               \
  }                                           \
  ___m_ptr;                                   \
})



/*
 * Operation reduced init is here. You just prepare the
 * symbols or binds and maybe version and by including
 * this file, seg. table gets automatically blasted into
 * source.
*/
#if defined (___QDEV_SEGINIT_SYMBOLS) ||      \
    defined (___QDEV_SEGINIT_BINDS)
#ifndef ___QDEV_SEGINIT_SYMBOLS
#define ___QDEV_SEGINIT_SYMBOLS
#endif
#ifndef ___QDEV_SEGINIT_BINDS
#define ___QDEV_SEGINIT_BINDS
#endif
#ifndef ___QDEV_SEGINIT_VERSION
#define ___QDEV_SEGINIT_VERSION 0
#endif
___QDEV_SEGINIT_GLOBTAB(
___QDEV_SEGINIT_SYMBOLS,
___QDEV_SEGINIT_BINDS,
___QDEV_SEGINIT_VERSION);
#endif



#endif /* ___XXXSEG_H_INCLUDED___ */
