/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * qversion.h
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'QVER'   is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'QVER'   is   distributed  in  the  hope  that  it  will  be useful,
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
 * $VER: qversion.h 1.60 (21/09/2014) QVER
 * AUTH: version
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This file was generated automatically.
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___QVERSION_H_INCLUDED___
#define ___QVERSION_H_INCLUDED___

#define _QV_DAY        21
#define _QV_MONTH      9
#define _QV_YEAR       2014

#define _QV_BUILD      60
#define _QV_VERSION    1
#define _QV_REVISION   2
#define _QV_PATCH      0

#define _QV_GCCVER     2
#define _QV_GCCREV     95
#define _QV_GCCCPU     68020

#define _QV_PKGNAME    "qdev"
#define _QV_LIBNAME    "libqdev.a"
#define _QV_VERTEXT    "1.2"
#define _QV_DATETEXT   "(21/09/2014)"
#define _QV_BLDTEXT    "60"
#define _QV_BLDWORD    "BUILD"
#define _QV_GCCTEXT    "gcc-2.95"
#define _QV_CPUTEXT    "68020"
#define _QV_TYPERES    "resident"
#define _QV_TYPESTD    "standard"

#ifdef resident
  #define _QV_TYPEBIN    _QV_TYPERES
#else
  #define _QV_TYPEBIN    _QV_TYPESTD
#endif

#define _QV_STRING     _QV_LIBNAME  " "    \
                       _QV_VERTEXT  " "    \
                       _QV_DATETEXT " "    \
                       _QV_BLDWORD  " "    \
                       _QV_BLDTEXT  " "    \
                       _QV_TYPEBIN  " "    \
                       _QV_CPUTEXT  " "    \
                       _QV_GCCTEXT

#endif /* ___QVERSION_H_INCLUDED___ */
