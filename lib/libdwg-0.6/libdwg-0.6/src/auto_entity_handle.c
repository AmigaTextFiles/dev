#include "dwg.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
 *     \file       dwg_macros.h
 *     \brief      Common macros used to generate ".c" from ".in.c" and ".spe.c"
 *     \author     written by Felipe Castro
 *     \author     modified by Felipe Corrêa da Silva Sances
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \author     modified by Till Heuschmann
 *     \author     modified by Felipe Castro
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#ifndef _DWG_MACROS_H_
#define _DWG_MACROS_H_

#define PRE(v) if (dwg->header.version < v)
#define UNTIL(v) if (dwg->header.version <= v)
#define LATER_VERSIONS else
#define VERSION(v) if (dwg->header.version == v)
#define VERSIONS(v1,v2) if (dwg->header.version >= v1 && dwg->header.version <= v2)
#define OTHER_VERSIONS else
#define SINCE(v) if (dwg->header.version >= v)
#define PRIOR_VERSIONS else

#define ANYCODE -1

#define FIELD_B(name) FIELD(name, B);
#define FIELD_BB(name) FIELD(name, BB);
#define FIELD_BS(name) FIELD(name, BS);
#define FIELD_BL(name) FIELD(name, BL);
#define FIELD_RC(name) FIELD(name, RC);
#define FIELD_RS(name) FIELD(name, RS);
#define FIELD_RL(name) FIELD(name, RL);

#define FIELD_2RD(name) FIELD_RD(name.x); FIELD_RD(name.y);
#define FIELD_2BD(name) FIELD_BD(name.x); FIELD_BD(name.y);
#define FIELD_3RD(name) FIELD_RD(name.x); FIELD_RD(name.y); FIELD_RD(name.z);
#define FIELD_3BD(name) FIELD_BD(name.x); FIELD_BD(name.y); FIELD_BD(name.z);

#endif


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

  if (FIELD_VALUE(entity_mode) == 0)
    {
      FIELD_HANDLE(subentity, 3);
    }

  ENT_REACTORS(4)
  ENT_XDICOBJHANDLE(3)

  VERSIONS(R_13, R_14)
    {
      FIELD_HANDLE(layer, 5);
      if (!FIELD_VALUE(isbylayerlt))
        {
          FIELD_HANDLE(ltype, 5);
        }
    }

  UNTIL(R_2000)
    {
      if (!FIELD_VALUE(nolinks))
        { // TODO: in R13, R14 these are optional. Look at page 53 in the spec for condition.
              FIELD_HANDLE(prev_entity, 4);
              FIELD_HANDLE(next_entity, 4);
            }
        }

  SINCE(R_2000)
    {
      FIELD_HANDLE(layer, 5);
      if (FIELD_VALUE(linetype_flags) == 3)
        {
          FIELD_HANDLE(ltype, 5);
        }
    }

  SINCE(R_2007)
    {
      if (FIELD_VALUE(material_flags)==3)
        {
          FIELD_HANDLE(material, ANYCODE);
        }
    }

  SINCE(R_2000)
    {
      if (FIELD_VALUE(plotstyle_flags)==3)
        {
          FIELD_HANDLE(plotstyle, 5);
        }
    }

# undef IS_DECODER
  return (1);
}



