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
 *     \file       dwg_entity_handle.in.c
 *     \brief      Decoding entity handles (input C file)
 *     \author     written by Felipe Castro
 *     \author     modified by Felipe Corrêa da Silva Sances
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \author     modified by Till Heuschmann
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#define FIELD_VALUE(name) _ent->name

#include "dwg_macro.h"

#define FIELD_HANDLE(name, handle_code) \
  if (bit_read_H (dat, &FIELD_VALUE(name)) ) \
    return (0); \
  snprintf (tmp, 1024, "  " #name ": HANDLE(%d.%d.%lu)\n", \
        FIELD_VALUE(name).code, \
        FIELD_VALUE(name).size, \
        FIELD_VALUE(name).value); \
  LOG_TRACE(tmp);

#define ENT_REACTORS(hcode)\
  if (obj->num_reactors > 0)\
    obj->reactors = (BITCODE_H*) malloc(sizeof(BITCODE_H) * obj->num_reactors);\
  for (vcount=0; vcount < obj->num_reactors; vcount++)\
    {\
      if (bit_read_H (dat, &obj->reactors[vcount])) \
        return (0); \
      snprintf (tmp, 1024, "  reactors[%lu]: HANDLE(%X.%d.%lu)\n", \
            vcount, \
            obj->reactors[vcount].code, \
            obj->reactors[vcount].size, \
            obj->reactors[vcount].value); \
      LOG_TRACE(tmp);\
    }

#define ENT_XDICOBJHANDLE(hcode)\
  SINCE(R_2004)\
    {\
      if (!obj->xdic_missing_flag)\
        {\
          if (bit_read_H (dat, &obj->xdicobjhandle)) \
            return (0); \
          snprintf (tmp, 1024, "  xdicobjhandle: HANDLE(%X.%d.%lu)\n", \
            obj->xdicobjhandle.code, \
            obj->xdicobjhandle.size, \
            obj->xdicobjhandle.value); \
          LOG_TRACE(tmp);\
        }\
    }\
  PRIOR_VERSIONS\
    {\
      if (bit_read_H (dat, &obj->xdicobjhandle)) \
        return (0); \
      snprintf (tmp, 1024, "  xdicobjhandle: HANDLE(%X.%d.%lu)\n", \
            obj->xdicobjhandle.code, \
            obj->xdicobjhandle.size, \
            obj->xdicobjhandle.value); \
      LOG_TRACE(tmp);\
    }

/** Decode entity data */
int
dwg_decode_entity_handles (Bit_Chain * dat, Dwg_Object * obj)
{
  int i;
  char tmp[1024];
  long unsigned vcount;
  Dwg_Object_Entity *_ent;
  Dwg_Struct *dwg = obj->parent;

  _ent = &obj->as.entity;

# define IS_DECODER
# include "dwg_entity_handle.spe.c"
# undef IS_DECODER
  return (1);
}
