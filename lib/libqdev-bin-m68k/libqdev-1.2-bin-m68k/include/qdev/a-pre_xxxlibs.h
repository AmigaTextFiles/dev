/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * pre_xxxlibs.h
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'QLL'    is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'QLL'    is   distributed  in  the  hope  that  it  will  be useful,
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
 * $VER: a-pre_xxxlibs.h 1.10 (27/04/2014) QLL
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * These  macros  are  useful  when either you do not need huge startup
 * code, or to fill the gap in it(in case  it  does  not  open what you
 * need). Not  all  OS libraries are here, only  the  essential  ones +
 * few  more  custom. Note  however  that  the former library table can
 * be  expanded  from the  outside  using  special  macros.  Here is an
 * example:
 *
 *    #define ___QDEV_LIBINIT_EXTBASES                            \
 *            ___QDEV_LIBINIT_ADDBASE(struct Library *mybase, 0)  \
 *            ___QDEV_LIBINIT_ADDBASE(struct Library *hisbase, 0)
 *
 *    #define ___QDEV_LIBINIT_EXTLIBS                             \
 *            ___QDEV_LIBINIT_ADDLIB("mylib.library", 6, mybase)  \
 *            ___QDEV_LIBINIT_ADDLIB("hislib.library", 7, hisbase)
 *
 *
 * The  usage  is  rather  anyone  friendly :-) .  Firstly  define what
 * libraries  you  require  by  setting  minimal version in appropriate
 * macros.  Secondly  include  this header, and  as  a  last  step call
 * magic macros like in the following example:
 *
 *    1 #define ___QDEV_LIBINIT_REPORTERR ___QDEV_LIBINIT_REPORTDEF 
 *    2 #define ___QDEV_LIBINIT_NOEXTRAS
 *    3 #define ___QDEV_LIBINIT_SYS       37
 *    4 #define ___QDEV_LIBINIT_DOS       37
 *    5
 *    6 #include <a-pre_xxxlibs.h>
 *    7
 *    8 int main(void)
 *    9 {
 *   10   if (pre_openlibs())
 *   11   {
 *   12     FPrintf(Output(), "Hellow teh world!\n");
 *   13   }
 *   14
 *   15   pre_closelibs();
 *   16
 *   17   return 0;
 *   18 }
 *
 *   gcc -nostdlib -nostartfiles -Dnostartfiles -I/gg/include/qdev \
 *   -Wall /lib/libnix/ncrt0.o myprog.c -o myprog
 *
 *
 * You  may  wonder  why  is 'pre_closelibs()' outside the conditional?
 * This   is  perfectly  okay  and  you  are  encouraged  to  write  it
 * exactly  this way!  The reason for  this  is to be able to close the
 * libraries  independently  of their  state.  Like  when  some  of the
 * very first libraries got open and the other failed.
 *
 * If  you  need  certain  libraries to be treated optionally then make
 * the  version  negative.  Things  change  a  bit  for the main kernel
 * library. If  you  stuff  negative  value in ___QDEV_LIBINIT_SYS then
 * it wont be included!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXLIBS_H_INCLUDED___
#define ___XXXLIBS_H_INCLUDED___



/*
 * This  can  be  used  to  determine what is 'libnix'
 * startup  code  supposed  to do. Well, we may wantem
 * to  do  nothing,  so  the use of 'stubs' who insert
 * library  bases(that  are uninitialised) is avoided.
 * There  is however one problem with that. If certain
 * 'libnix'  object  is braced  by its assembler macro
 * then the generated binary will be faulty, so really
 * use this only when programming using OS API!
*/
#ifdef ___QDEV_LIBINIT_NOEXTRAS
#ifdef __GNUC__
#ifndef __libnix
__attribute__((no_instrument_function, unused))
static void __main(void){}
void *__INIT_LIST__[2] = {0, 0};
void *__EXIT_LIST__[2] = {0, 0};
int __cpucheck = 0;
int __nocommandline = 1;
int __initlibraries = 0;
#endif
#endif
#endif



/*
 * If programmer wants "fat" startup code then we will
 * have to skip on certain subsystems because their
 * bases will be initialised before 'main()'!
*/
#ifndef nostartfiles
#ifdef ___QDEV_LIBINIT_REPORTERR
#define ___QDEV_LIBINIT_REPORTMSG(xtable)     \
if (___m_res == 0)                            \
{                                             \
  ___QDEV_LIBINIT_REPORTERR                   \
}
#endif

#ifdef ___QDEV_LIBINIT_SYS
#undef ___QDEV_LIBINIT_SYS
#define ___QDEV_LIBINIT_SYS -1
#include <proto/exec.h>
#include <exec/execbase.h>
#endif

#ifdef ___QDEV_LIBINIT_DOS
#undef ___QDEV_LIBINIT_DOS
#include <proto/dos.h>
#endif
#endif



/*
 * Report which library could not be opened if needed.
*/
#define ___QDEV_LIBINIT_REPORTDEF             \
FPrintf(Output(), " *** error, cannot access" \
                    " '%s' version %ld+ !\n", \
                    (LONG)___m_qlt->qlt_name, \
                   (LONG)___m_qlt->qlt_vers);
#ifdef ___QDEV_LIBINIT_REPORTERR
#ifndef ___QDEV_LIBINIT_REPORTMSG
#define ___QDEV_LIBINIT_REPORTMSG(xtable)     \
if (___m_res == 0)                            \
{                                             \
  struct ___qlt *___m_iqlt =                  \
                      (void *)((long)xtable + \
                       (long)sizeof(xtable)); \
  ___m_iqlt--; /* Terminator */               \
  ___m_iqlt--; /* DOSBase    */               \
  if ((*___m_iqlt->qlt_b[0] =                 \
                         (void *)OpenLibrary( \
                    ___m_iqlt->qlt_name, 0))) \
  {                                           \
    ___QDEV_LIBINIT_REPORTERR                 \
    CloseLibrary(                             \
               (void *)*___m_iqlt->qlt_b[0]); \
    *___m_iqlt->qlt_b[0] = 0;                 \
  }                                           \
}
#ifndef ___QDEV_LIBINIT_DOS
#define ___QDEV_LIBINIT_DOS -1
#endif
#endif
#else
#ifndef ___QDEV_LIBINIT_REPORTMSG
#define ___QDEV_LIBINIT_REPORTMSG(xtable)
#endif
#endif



/*
 * Should library bases  be uninitialized  and treated
 * as BSS?
*/
#ifdef ___QDEV_LIBINIT_BASEISCODE
#define ___QDEV_LIBINIT_ADDBASE(base, val)    \
base;
#else
#define ___QDEV_LIBINIT_ADDBASE(base, val)    \
base = val;
#endif



/*
 * "exec.library" initialisation macros.
*/
#ifdef ___QDEV_LIBINIT_SYS
#if (___QDEV_LIBINIT_SYS < 0)
#undef ___QDEV_LIBINIT_SYS
#endif
#else
#define ___QDEV_LIBINIT_SYS  0
#endif
#ifdef ___QDEV_LIBINIT_SYS
#include <proto/exec.h>
#include <exec/execbase.h>
#define ___QDEV_LIBINIT_ENTSYS                \
{                                             \
  "exec.library",                             \
  ___QDEV_LIBINIT_SYS,                        \
  {                                           \
    0                                         \
  }                                           \
},
#define ___QDEV_LIBINIT_INITSYS               \
SysBase = (*((struct ExecBase **)4));         \
if ((short)SysBase->LibNode.lib_Version >=    \
                  (short)___QDEV_LIBINIT_SYS)
#define ___QDEV_LIBINIT_KILLSYS
___QDEV_LIBINIT_ADDBASE(
                struct ExecBase *SysBase, 0)
#else
#define ___QDEV_LIBINIT_ENTSYS                \
{                                             \
  0,                                          \
  0,                                          \
  {                                           \
    0                                         \
  }                                           \
},
#define ___QDEV_LIBINIT_INITSYS
#define ___QDEV_LIBINIT_KILLSYS
#endif



/*
 * "intuition.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_INTUITION
#include <proto/intuition.h>
#define ___QDEV_LIBINIT_ENTINTUITION          \
{                                             \
  "intuition.library",                        \
  ___QDEV_LIBINIT_INTUITION,                  \
  {                                           \
    (void **)&IntuitionBase,                  \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
     struct IntuitionBase *IntuitionBase, 0)
#else
#define ___QDEV_LIBINIT_ENTINTUITION
#endif



/*
 * "graphics.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_GFX
#include <proto/graphics.h>
#define ___QDEV_LIBINIT_ENTGFX                \
{                                             \
  "graphics.library",                         \
  ___QDEV_LIBINIT_GFX,                        \
  {                                           \
    (void **)&GfxBase,                        \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
                 struct GfxBase *GfxBase, 0)
#else
#define ___QDEV_LIBINIT_ENTGFX
#endif



/*
 * "cybergraphics.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_CYBERGFX
#include <proto/cybergraphics.h>
#define ___QDEV_LIBINIT_ENTCYBERGFX           \
{                                             \
  "cybergraphics.library",                    \
  ___QDEV_LIBINIT_CYBERGFX,                   \
  {                                           \
    (void **)&CyberGfxBase,                   \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
            struct Library *CyberGfxBase, 0)
#else
#define ___QDEV_LIBINIT_ENTCYBERGFX
#endif



/*
 * "guigfx.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_GUIGFX
#include <proto/guigfx.h>
#define ___QDEV_LIBINIT_ENTGUIGFX             \
{                                             \
  "guigfx.library",                           \
  ___QDEV_LIBINIT_GUIGFX,                     \
  {                                           \
    (void **)&GuiGFXBase,                     \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
              struct Library *GuiGFXBase, 0)
#else
#define ___QDEV_LIBINIT_ENTGUIGFX
#endif



/*
 * "mysticview.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_MYSTIC
#include <proto/mysticview.h>
#define ___QDEV_LIBINIT_ENTMYSTIC             \
{                                             \
  "mysticview.library",                       \
  ___QDEV_LIBINIT_MYSTIC,                     \
  {                                           \
    (void **)&MysticBase,                     \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
              struct Library *MysticBase, 0)
#else
#define ___QDEV_LIBINIT_ENTMYSTIC
#endif



/*
 * "utility.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_UTILITY
#include <proto/utility.h>
#define ___QDEV_LIBINIT_ENTUTILITY            \
{                                             \
  "utility.library",                          \
  ___QDEV_LIBINIT_UTILITY,                    \
  {                                           \
    (void **)&UtilityBase,                    \
    (void **)&__UtilityBase,                  \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
         struct UtilityBase *UtilityBase, 0)
___QDEV_LIBINIT_ADDBASE(
       struct UtilityBase *__UtilityBase, 0)
#else
#define ___QDEV_LIBINIT_ENTUTILITY
#endif



/*
 * "diskfont.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_DISKFONT
#include <proto/diskfont.h>
#define ___QDEV_LIBINIT_ENTDISKFONT           \
{                                             \
  "diskfont.library",                         \
  ___QDEV_LIBINIT_DISKFONT,                   \
  {                                           \
    (void **)&DiskfontBase,                   \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
            struct Library *DiskfontBase, 0)
#else
#define ___QDEV_LIBINIT_ENTDISKFONT
#endif



/*
 * "layers.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_LAYERS
#include <proto/layers.h>
#define ___QDEV_LIBINIT_ENTLAYERS             \
{                                             \
  "layers.library",                           \
  ___QDEV_LIBINIT_LAYERS,                     \
  {                                           \
    (void **)&LayersBase,                     \
    0                                         \
  }                                           \
},
struct Library *LayersBase = 0;
#else
#define ___QDEV_LIBINIT_ENTLAYERS
#endif



/*
 * "mathieeedoubbas.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_MATHDOUBBAS
#include <proto/mathieeedoubbas.h>
#define ___QDEV_LIBINIT_ENTMATHDOUBBAS        \
{                                             \
  "mathieeedoubbas.library",                  \
  ___QDEV_LIBINIT_MATHDOUBBAS,                \
  {                                           \
    (void **)&MathIeeeDoubBasBase,            \
    (void **)&__MathIeeeDoubBasBase,          \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
struct MathIEEEBase *MathIeeeDoubBasBase, 0)
___QDEV_LIBINIT_ADDBASE(
struct MathIEEEBase *__MathIeeeDoubBasBase, 0)
#else
#define ___QDEV_LIBINIT_ENTMATHDOUBBAS
#endif



/*
 * "mathieeedoubtrans.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_MATHDOUBTRANS
#include <proto/mathieeedoubtrans.h>
#define ___QDEV_LIBINIT_ENTMATHDOUBTRANS      \
{                                             \
  "mathieeedoubtrans.library",                \
  ___QDEV_LIBINIT_MATHDOUBTRANS,              \
  {                                           \
    (void **)&MathIeeeDoubTransBase,          \
    (void **)&__MathIeeeDoubTransBase,        \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
struct MathIEEEBase *MathIeeeDoubTransBase, 0)
___QDEV_LIBINIT_ADDBASE(
struct MathIEEEBase *__MathIeeeDoubTransBase, 0)
#else
#define ___QDEV_LIBINIT_ENTMATHDOUBTRANS
#endif



/*
 * "mathieeesingbas.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_MATHSINGBAS
#include <proto/mathieeesingbas.h>
#define ___QDEV_LIBINIT_ENTMATHSINGBAS        \
{                                             \
  "mathieeesingbas.library",                  \
  ___QDEV_LIBINIT_MATHSINGBAS,                \
  {                                           \
    (void **)&MathIeeeSingBasBase,            \
    (void **)&__MathIeeeSingBasBase,          \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
struct MathIEEEBase *MathIeeeSingBasBase, 0)
___QDEV_LIBINIT_ADDBASE(
struct MathIEEEBase *__MathIeeeSingBasBase, 0)
#else
#define ___QDEV_LIBINIT_ENTMATHSINGBAS
#endif



/*
 * "mathieeesingtrans.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_MATHSINGTRANS
#include <proto/mathieeesingtrans.h>
#define ___QDEV_LIBINIT_ENTMATHSINGTRANS      \
{                                             \
  "mathieeesingtrans.library",                \
  ___QDEV_LIBINIT_MATHSINGTRANS,              \
  {                                           \
    (void **)&MathIeeeSingTransBase,          \
    (void **)&__MathIeeeSingTransBase,        \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
struct MathIEEEBase *MathIeeeSingTransBase, 0)
___QDEV_LIBINIT_ADDBASE(
struct MathIEEEBase *__MathIeeeSingTransBase, 0)
#else
#define ___QDEV_LIBINIT_ENTMATHSINGTRANS
#endif



/*
 * "mathffp.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_MATHFFP
#define __NOLIBBASE__
#include <proto/mathffp.h>
#undef __NOLIBBASE__
#define ___QDEV_LIBINIT_ENTMATHFFP            \
{                                             \
  "mathffp.library",                          \
  ___QDEV_LIBINIT_MATHFFP,                    \
  {                                           \
    (void **)&MathBase,                       \
    (void **)&__MathBase,                     \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
                struct MathBase *MathBase, 0)
___QDEV_LIBINIT_ADDBASE(
              struct MathBase *__MathBase, 0)
#else
#define ___QDEV_LIBINIT_ENTMATHFFP
#endif



/*
 * "mathtrans.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_MATHTRANS
#define __NOLIBBASE__
#include <proto/mathtrans.h>
#undef __NOLIBBASE__
#define ___QDEV_LIBINIT_ENTMATHTRANS          \
{                                             \
  "mathtrans.library",                        \
  ___QDEV_LIBINIT_MATHTRANS,                  \
  {                                           \
    (void **)&MathTransBase,                  \
    (void **)&__MathTransBase,                \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
      struct MathTransBase *MathTransBase, 0)
___QDEV_LIBINIT_ADDBASE(
    struct MathTransBase *__MathTransBase, 0)
#else
#define ___QDEV_LIBINIT_ENTMATHTRANS
#endif



/*
 * "icon.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_ICON
#include <proto/icon.h>
#include <workbench/workbench.h>
#define ___QDEV_LIBINIT_ENTICON               \
{                                             \
  "icon.library",                             \
  ___QDEV_LIBINIT_ICON,                       \
  {                                           \
    (void **)&IconBase,                       \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
                 struct Library *IconBase, 0)
#else
#define ___QDEV_LIBINIT_ENTICON
#endif



/*
 * "muimaster.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_MUI
#include <libraries/mui.h>
#include <proto/muimaster.h>
#define ___QDEV_LIBINIT_ENTMUI                \
{                                             \
  "muimaster.library",                        \
  ___QDEV_LIBINIT_MUI,                        \
  {                                           \
    (void **)&MUIMasterBase,                  \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
           struct Library *MUIMasterBase, 0)
#else
#define ___QDEV_LIBINIT_ENTMUI
#endif



/*
 * "bsdsocket.library" initialisation macros.
*/
#ifdef ___QDEV_LIBINIT_SOCKET
#include <proto/socket.h>
#define ___QDEV_LIBINIT_ENTSOCKET             \
{                                             \
  "bsdsocket.library",                        \
  ___QDEV_LIBINIT_SOCKET,                     \
  {                                           \
    (void **)&SocketBase,                     \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
              struct Library *SocketBase, 0)
#else
#define ___QDEV_LIBINIT_ENTSOCKET
#endif



/*
 * "asl.library" initialisation macros.
*/
#ifdef ___QDEV_LIBINIT_ASL
#include <proto/asl.h>
#define ___QDEV_LIBINIT_ENTASL                \
{                                             \
  "asl.library",                              \
  ___QDEV_LIBINIT_ASL,                        \
  {                                           \
    (void **)&AslBase,                        \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
                 struct Library *AslBase, 0)
#else
#define ___QDEV_LIBINIT_ENTASL
#endif



/*
 * "datatypes.library" initialisation macros.
*/
#ifdef ___QDEV_LIBINIT_DATATYPES
#include <proto/datatypes.h>
#define ___QDEV_LIBINIT_ENTDATATYPES          \
{                                             \
  "datatypes.library",                        \
  ___QDEV_LIBINIT_DATATYPES,                  \
  {                                           \
    (void **)&DataTypesBase,                  \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
           struct Library *DataTypesBase, 0)
#else
#define ___QDEV_LIBINIT_ENTDATATYPES
#endif



/*
 * "dos.library" initialisation macro.
*/
#ifdef ___QDEV_LIBINIT_DOS
#include <proto/dos.h>
#define ___QDEV_LIBINIT_ENTDOS                \
{                                             \
  "dos.library",                              \
  ___QDEV_LIBINIT_DOS,                        \
  {                                           \
    (void **)&DOSBase,                        \
    (void **)&__DOSBase,                      \
    0                                         \
  }                                           \
},
___QDEV_LIBINIT_ADDBASE(
              struct DosLibrary *DOSBase, 0)
___QDEV_LIBINIT_ADDBASE(
            struct DosLibrary *__DOSBase, 0)
#else
#define ___QDEV_LIBINIT_ENTDOS
#endif



/*
 * Other/custom  bases and libraries should be defined
 * here.
*/
#ifndef ___QDEV_LIBINIT_EXTBASES
#define ___QDEV_LIBINIT_EXTBASES
#endif
___QDEV_LIBINIT_EXTBASES
#ifndef ___QDEV_LIBINIT_EXTLIBS
#define ___QDEV_LIBINIT_EXTLIBS
#endif
#define ___QDEV_LIBINIT_ADDLIB(n, v, b)       \
{                                             \
  n,                                          \
  v,                                          \
  {                                           \
    (void **)&b,                              \
    0                                         \
  }                                           \
},



/*
 * Library table terminator. Note  that the very first
 * entry  which  is 'exec.library' also terminates the
 * table,  so moving from top to bottom and vice versa
 * is possible!
*/
#define ___QDEV_LIBINIT_ENTTERM               \
{                                             \
  0,                                          \
  0,                                          \
  {                                           \
    0                                         \
  }                                           \
}



/*
 * Library table structure and the table itself. Below
 * is  a  macro  that defines how many bases one entry
 * can reference. You  can increase it without getting
 * any side effects if you need more aliases, but note
 * that  once you have added more aliases somewhere it
 * is unsafe to decrease it!
*/
#ifndef ___QDEV_LIBINIT_BASES
#define ___QDEV_LIBINIT_BASES 2
#endif

struct ___qlt
{
  char   *qlt_name;        /* Library name, full name like "dos.library"    */
  long    qlt_vers;        /* Library minimal version, like 37L             */
  void  **qlt_b[(___QDEV_LIBINIT_BASES + 1)];
                           /* Lib. bases, anything but [0] is an alias!     */
};

#ifndef ___QDEV_LIBINIT_LIBTABLE
#define ___QDEV_LIBINIT_LIBTABLE ___qdev_libinit_table
struct ___qlt ___QDEV_LIBINIT_LIBTABLE[] =
{
  ___QDEV_LIBINIT_ENTSYS
  ___QDEV_LIBINIT_ENTINTUITION
  ___QDEV_LIBINIT_ENTGFX
  ___QDEV_LIBINIT_ENTCYBERGFX
  ___QDEV_LIBINIT_ENTGUIGFX
  ___QDEV_LIBINIT_ENTMYSTIC
  ___QDEV_LIBINIT_ENTUTILITY
  ___QDEV_LIBINIT_ENTDISKFONT
  ___QDEV_LIBINIT_ENTLAYERS
  ___QDEV_LIBINIT_ENTMATHDOUBBAS
  ___QDEV_LIBINIT_ENTMATHDOUBTRANS
  ___QDEV_LIBINIT_ENTMATHSINGBAS
  ___QDEV_LIBINIT_ENTMATHSINGTRANS
  ___QDEV_LIBINIT_ENTMATHFFP
  ___QDEV_LIBINIT_ENTMATHTRANS
  ___QDEV_LIBINIT_ENTICON
  ___QDEV_LIBINIT_ENTMUI
  ___QDEV_LIBINIT_ENTSOCKET
  ___QDEV_LIBINIT_ENTASL
  ___QDEV_LIBINIT_ENTDATATYPES

  /*
   * It  is  very important  to put  new entries here,
   * just  before  user  and 'dos.library' ones! Never
   * swap  these  two  entries or it  will break whole
   * library loader! A golden rule, 'dos.library' must
   * be loaded last.
  */

  ___QDEV_LIBINIT_EXTLIBS
  ___QDEV_LIBINIT_ENTDOS
  ___QDEV_LIBINIT_ENTTERM
};
#endif



/*
 * WBStartup message handling is here. Please note
 * that only the arguments get copied! Also you dont
 * reply to this copied messsage within your code!!!
*/
#ifndef ___QDEV_LIBINIT_DEFWBSTARTUP
#define ___QDEV_LIBINIT_DEFWBSTARTUP _WBenchMsg
#endif
#define ___QDEV_LIBINIT_COPYWBSTARTUP(sm)     \
({                                            \
  struct WBStartup *___m_sm = sm;             \
  struct WBStartup *___m_nsm = NULL;          \
  UBYTE *___m_sptr;                           \
  UBYTE *___m_dptr;                           \
  LONG ___m_smsize;                           \
  LONG ___m_smcnt;                            \
  if (___m_sm)                                \
  {                                           \
    ___m_smsize = sizeof(struct WBStartup);   \
    ___m_smcnt = ___m_sm->sm_NumArgs;         \
    while (___m_smcnt--)                      \
    {                                         \
      ___m_sptr =                             \
     ___m_sm->sm_ArgList[___m_smcnt].wa_Name; \
      while (*___m_sptr++);                   \
      ___m_smsize += sizeof(struct WBArg);    \
      ___m_smsize += (LONG)___m_sptr - (LONG) \
     ___m_sm->sm_ArgList[___m_smcnt].wa_Name; \
    }                                         \
    if ((___m_nsm = AllocVec(___m_smsize,     \
                  MEMF_PUBLIC | MEMF_CLEAR))) \
    {                                         \
      ___m_nsm->sm_NumArgs =                  \
                         ___m_sm->sm_NumArgs; \
      ___m_nsm->sm_ArgList =                  \
                    (void *)((LONG)___m_nsm + \
             (LONG)sizeof(struct WBStartup)); \
      ___m_dptr = (void *)(                   \
                 (LONG)___m_nsm->sm_ArgList + \
                (LONG)(sizeof(struct WBArg) * \
                      ___m_nsm->sm_NumArgs)); \
      ___m_smcnt = ___m_sm->sm_NumArgs;       \
      while (___m_smcnt--)                    \
      {                                       \
        ___m_nsm->sm_ArgList[                 \
               ___m_smcnt].wa_Lock = DupLock( \
        ___m_sm->sm_ArgList[                  \
                        ___m_smcnt].wa_Lock); \
        ___m_nsm->sm_ArgList[                 \
             ___m_smcnt].wa_Name = ___m_dptr; \
        ___m_sptr = ___m_sm->sm_ArgList[      \
                         ___m_smcnt].wa_Name; \
        while (*___m_sptr)                    \
        {                                     \
          *___m_dptr++ = *___m_sptr++;        \
        }                                     \
        *___m_dptr++ = '\0';                  \
      }                                       \
    }                                         \
  }                                           \
  ___m_nsm;                                   \
})
#define ___QDEV_LIBINIT_FREEWBSTARTUP(sm)     \
({                                            \
  struct WBStartup *___m_sm = sm;             \
  LONG ___m_smcnt;                            \
  if (___m_sm)                                \
  {                                           \
    ___m_smcnt = ___m_sm->sm_NumArgs;         \
    while (___m_smcnt--)                      \
    {                                         \
      if (___m_sm->sm_ArgList[                \
                         ___m_smcnt].wa_Lock) \
      {                                       \
        UnLock(___m_sm->sm_ArgList[           \
                        ___m_smcnt].wa_Lock); \
      }                                       \
    }                                         \
    FreeVec(___m_sm);                         \
  }                                           \
})



/*
 * Relaunch in a CLI if we were started from Workbench.
*/
#define ___QDEV_LIBINIT_CLIQUIET              \
"NIL:"
#define ___QDEV_LIBINIT_CLISTREAM             \
"CON:16384/16384/420/210/QCLI/CLOSE/AUTO/WAIT"
#ifdef ___QDEV_LIBINIT_CLIONLY
extern struct WBStartup *___QDEV_LIBINIT_DEFWBSTARTUP;
static char ___qdev_libinit_clilocal[] =
"QCLIPROGNAME";
static char ___qdev_libinit_cliinput[32] =
"QCLISTREAM\0\0\0";
static char ___qdev_libinit_clistream[128] =
___QDEV_LIBINIT_CLIONLY;
#include <dos/dostags.h>
#include <workbench/startup.h>
#define ___QDEV_LIBINIT_ADDCLISTUB            \
if (___m_res)                                 \
{                                             \
  struct Process *___m_pr =                   \
         (struct Process *)SysBase->ThisTask; \
  struct Process *___m_newpr = NULL;          \
  struct FileHandle *___m_fh;                 \
  struct WBStartup *___m_sm2 =                \
                ___QDEV_LIBINIT_DEFWBSTARTUP; \
  LONG ___m_lock;                             \
  LONG ___m_inp = 0;                          \
  LONG ___m_out;                              \
  LONG ___m_port;                             \
  if ((___m_pr->pr_Task.tc_Node.ln_Type ==    \
    NT_PROCESS) && (___m_pr->pr_CLI == NULL)) \
  {                                           \
    if ((DOSBase) &&                          \
        (___m_sm2) && (___m_sm2->sm_Segment)) \
    {                                         \
      ___m_port = (LONG)                      \
                       ___m_pr->pr_WindowPtr; \
      ___m_pr->pr_WindowPtr = (APTR)-1;       \
      GetVar(___qdev_libinit_cliinput,        \
                   ___qdev_libinit_clistream, \
       sizeof(___qdev_libinit_clistream), 0); \
      SetVar(___qdev_libinit_clilocal,        \
                                   FilePart(  \
           ___m_pr->pr_Task.tc_Node.ln_Name), \
                         -1, GVF_LOCAL_ONLY); \
      ___qdev_libinit_cliinput[10] = '_';     \
      GetVar(___qdev_libinit_clilocal,        \
               &___qdev_libinit_cliinput[11], \
       sizeof(___qdev_libinit_cliinput) - 12, \
                             GVF_LOCAL_ONLY); \
      DeleteVar(___qdev_libinit_clilocal,     \
                             GVF_LOCAL_ONLY); \
      GetVar(___qdev_libinit_cliinput,        \
                   ___qdev_libinit_clistream, \
       sizeof(___qdev_libinit_clistream), 0); \
      ___m_pr->pr_WindowPtr = (APTR)          \
                                   ___m_port; \
      if ((___m_out = Open(                   \
                   ___qdev_libinit_clistream, \
                              MODE_NEWFILE))) \
      {                                       \
        ___m_port =                           \
               (LONG)___m_pr->pr_ConsoleTask; \
        ___m_fh = (void *)BADDR(___m_out);    \
        ___m_pr->pr_ConsoleTask =             \
                      (APTR)___m_fh->fh_Type; \
        if (!(___m_inp = Open(                \
                  "CONSOLE:", MODE_OLDFILE))) \
        {                                     \
          ___m_inp = Open(                    \
                       "NIL:", MODE_OLDFILE); \
        }                                     \
        Forbid();                             \
        ___m_lock = CurrentDir(               \
                        ___m_pr->pr_HomeDir); \
        if ((___m_newpr =                     \
                   (void *)CreateNewProcTags( \
            NP_Seglist    , (ULONG)           \
                        ___m_sm2->sm_Segment, \
            NP_FreeSeglist, TRUE,             \
            NP_Error      , ___m_out,         \
            NP_Output     , ___m_out,         \
            NP_Input      , ___m_inp,         \
            NP_CloseError , FALSE,            \
            NP_CloseOutput, TRUE,             \
            NP_CloseInput , TRUE,             \
            NP_Priority   ,                   \
             ___m_pr->pr_Task.tc_Node.ln_Pri, \
            NP_Arguments  , (ULONG)"\n",      \
            NP_Name       , (ULONG)"QCLI",    \
            NP_CommandName, (ULONG)           \
            ___m_pr->pr_Task.tc_Node.ln_Name, \
            NP_StackSize  ,                   \
                       ___m_pr->pr_StackSize, \
            NP_Cli        , TRUE,             \
            TAG_DONE      , NULL)))           \
        {                                     \
          ___m_sm2->sm_Segment = NULL;        \
          Remove((struct Node *)___m_newpr);  \
          DoPkt(___m_newpr->pr_ConsoleTask,   \
                        ACTION_CHANGE_SIGNAL, \
                      (LONG)___m_fh->fh_Arg1, \
               (LONG)&___m_newpr->pr_MsgPort, \
                                    0, 0, 0); \
          ___m_newpr->pr_MsgPort.             \
                  mp_Node.ln_Name = (UBYTE *) \
               ___QDEV_LIBINIT_COPYWBSTARTUP( \
               ___QDEV_LIBINIT_DEFWBSTARTUP); \
          ___m_newpr->pr_Task.tc_State =      \
                                    TS_READY; \
          Enqueue(&SysBase->TaskReady,        \
                   (struct Node*)___m_newpr); \
        }                                     \
        else                                  \
        {                                     \
          if (___m_inp)                       \
          {                                   \
            Close(___m_inp);                  \
          }                                   \
          Close(___m_out);                    \
        }                                     \
        CurrentDir(___m_lock);                \
        ___m_pr->pr_ConsoleTask =             \
                             (APTR)___m_port; \
      }                                       \
    }                                         \
    ___m_res = 0;                             \
  }                                           \
};
#define ___QDEV_LIBINIT_REMCLISTUB            \
({                                            \
  struct Process *___m_pr =                   \
         (struct Process *)SysBase->ThisTask; \
  UBYTE *___m_ptrwbs =                        \
            ___m_pr->pr_Task.tc_Node.ln_Name; \
  if (___m_ptrwbs)                            \
  {                                           \
    if ((*___m_ptrwbs++ == 'Q')  &&           \
        (*___m_ptrwbs++ == 'C')  &&           \
        (*___m_ptrwbs++ == 'L')  &&           \
        (*___m_ptrwbs++ == 'I'))              \
    {                                         \
      ___QDEV_LIBINIT_FREEWBSTARTUP((void *)  \
        ___m_pr->pr_MsgPort.mp_Node.ln_Name); \
    }                                         \
  }                                           \
});
#else
#define ___QDEV_LIBINIT_ADDCLISTUB
#define ___QDEV_LIBINIT_REMCLISTUB
#endif



/*
 * Open  and  close macros. The essence of this tricky
 * loader.
*/
#define ___pre_openlibs(xtable)               \
({                                            \
  struct ___qlt *___m_qlt = xtable;           \
  long ___m_res = 0;                          \
  ___QDEV_LIBINIT_INITSYS                     \
  {                                           \
    ___m_res = 1;                             \
    ___m_qlt++;                               \
    while (___m_qlt->qlt_b[0])                \
    {                                         \
      if ((*___m_qlt->qlt_b[0] = OpenLibrary( \
                          ___m_qlt->qlt_name, \
                  ((___m_qlt->qlt_vers < 0) ? \
                        -___m_qlt->qlt_vers : \
                       ___m_qlt->qlt_vers)))) \
      {                                       \
        ___m_res = 1;                         \
        while (___m_qlt->qlt_b[___m_res])     \
        {                                     \
          *___m_qlt->qlt_b[___m_res] =        \
                         *___m_qlt->qlt_b[0]; \
          ___m_res++;                         \
        }                                     \
      }                                       \
      else                                    \
      {                                       \
        if (___m_qlt->qlt_vers >= 0)          \
        {                                     \
          ___m_res = 0;                       \
          break;                              \
        }                                     \
      }                                       \
      ___m_qlt++;                             \
    }                                         \
  }                                           \
  ___QDEV_LIBINIT_REPORTMSG(xtable)           \
  ___QDEV_LIBINIT_ADDCLISTUB                  \
  ___m_res;                                   \
})
#define ___pre_closelibs(xtable)              \
({                                            \
  struct ___qlt *___m_qlt = xtable;           \
  ___QDEV_LIBINIT_REMCLISTUB                  \
  ___m_qlt++;                                 \
  while (___m_qlt->qlt_b[0])                  \
  {                                           \
    if (*___m_qlt->qlt_b[0])                  \
    {                                         \
      CloseLibrary(                           \
                (void *)*___m_qlt->qlt_b[0]); \
      *___m_qlt->qlt_b[0] = 0;                \
    }                                         \
    ___m_qlt++;                               \
  }                                           \
  ___QDEV_LIBINIT_KILLSYS                     \
})



#define pre_openlibs()                        \
({                                            \
  ___pre_openlibs(___QDEV_LIBINIT_LIBTABLE);  \
})
#define pre_closelibs()                       \
({                                            \
  ___pre_closelibs(___QDEV_LIBINIT_LIBTABLE); \
})



#endif /* ___XXXLIBS_H_INCLUDED___ */
