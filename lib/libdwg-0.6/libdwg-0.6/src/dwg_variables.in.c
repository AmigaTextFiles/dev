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
 *     \file       dwg_variables.in.c
 *     \brief      Decoding header variables (input C file)
 *     \author     written by Felipe Castro
 *     \author     modified by Felipe Corrêa da Silva Sances
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \author     modified by Till Heuschmann
 *     \author     modified by Felipe Castro
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#define FIELD_VALUE(name) _var->name

#define FIELD(name,type)\
  FIELD_VALUE(name) = bit_read_##type(dat);\
  snprintf (tmp, 1024, "  " #name ": " FORMAT_##type "\n", FIELD_VALUE(name)); \
  LOG_TRACE (tmp);

#include "dwg_macro.h"

#define FIELD_TV(name) \
  FIELD_VALUE(name) = bit_read_TV(dat);\
  if (FIELD_VALUE(name))\
  {\
    snprintf (tmp, 1024, "  " #name ": " FORMAT_TV "\n", FIELD_VALUE(name));\
    LOG_TRACE (tmp); \
  }\
  else\
  {\
    snprintf (tmp, 1024, "  " #name ": NULL\n");\
    LOG_TRACE (tmp);\
  }
#define FIELD_T(name) FIELD_TV(name)	/*TODO: implement version dependant string fields */

#define FIELD_BD(name) FIELD(name, BD);
#define FIELD_RD(name) FIELD(name, RD);
#define FIELD_BT(name) FIELD(name, BT);

#define FIELD_HANDLE(name, handle_code)\
  bit_read_H (dat, &FIELD_VALUE(name));\
  snprintf (tmp, 1024, "  " #name ": HANDLE(%d.%d.%lu)\n",\
        FIELD_VALUE(name).code,\
        FIELD_VALUE(name).size,\
        FIELD_VALUE(name).value);\
  LOG_TRACE (tmp);

#define FIELD_CMC(name)\
  bit_read_CMC(dat, &FIELD_VALUE(name));\
  snprintf (tmp, 1024, "  " #name ": color index %d\n", FIELD_VALUE(name).index);\
  LOG_TRACE(tmp);

int
dwg_decode_variables (Bit_Chain *dat, Dwg_Struct *dwg)
{
  char tmp[1024];
  Dwg_Variables* _var = &dwg->variable;

# include "dwg_variables.spe.c"
}

