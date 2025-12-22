/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * nfo_qversion()
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
 * $VER: i-nfo_qversion.c 1.00 (04/01/2014) QVER
 * AUTH: version
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This object is implicit and serves only as a stub so that  'version'
 * command can probe the library.
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#include "qversion.h"



static const char ___version[] = "\0$VER: " _QV_STRING "\0";



char *___nfo_qversion___(void)
{
  return (char *)___version;
}
