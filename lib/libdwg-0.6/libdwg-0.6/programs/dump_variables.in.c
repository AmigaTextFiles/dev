/*****************************************************************************/
/*  LibDWG - free implementation of the DWG file format                      */
/*                                                                           */
/*  Copyright (C) 2013 Free Software Foundation, Inc.                        */
/*                                                                           */
/*  This library is free software, licensed under the terms of the GNU       */
/*  General Public License as published by the Free Software Foundation,     */
/*  either version 3 of the License, or (at your option) any later version.  */
/*  You should have received a copy of the GNU General Public License        */
/*  along with this program.  If not, see <http://www.gnu.org/licenses/>.    */
/*                                                                           */
/*****************************************************************************/

/**
 *     \file       dump_variables.c.in
 *     \brief      Dump variables contents. It is pre-preprocessed to generate 'dump_variables.c'.
 *     \author     written by Rodrigo Rodrigues da Silva
 *     \author     modified by Felipe E. F. de Castro
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#define FIELD_VALUE(name) dwg->variable.name

#define FIELD(name,type)\
  printf ("  " #name " = " FORMAT_##type "\n", FIELD_VALUE(name));

#include "dwg_macro.h"

#define FIELD_TV(name) \
  if (FIELD_VALUE(name))\
    printf ("  " #name ": " FORMAT_TV "\n", FIELD_VALUE(name));\
  else\
    printf ("  " #name ": NULL\n");

#define FIELD_T(name) FIELD_TV(name)

#define FIELD_BD(name) FIELD(name, BD);
#define FIELD_RD(name) FIELD(name, RD);
#define FIELD_BT(name) FIELD(name, BT);

#define FIELD_HANDLE(name, handle_code)\
  printf ("  " #name " = HANDLE(%1X.%d.%lu)\n",\
        FIELD_VALUE(name).code,\
        FIELD_VALUE(name).size,\
        FIELD_VALUE(name).value);

#define FIELD_CMC(name)\
  printf ("  " #name " = color index %d\n", dwg->variable.name.index);

void
dump_variables (Dwg_Struct * dwg)
{
#  include "dwg_variables.spe.c"
}
