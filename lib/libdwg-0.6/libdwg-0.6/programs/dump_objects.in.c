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
 *     \file       dump_objects.in.c
 *     \brief      Dump object contents. It is pre-preprocessed to generate 'dump_objects.c'.
 *     \author     written by Rodrigo Rodrigues da Silva
 *     \author     modified by Felipe E. F. de Castro
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#define FIELD_VALUE(name) _obj->name

#define FIELD(name,type)\
  printf ("  " #name ": " FORMAT_##type "\n", FIELD_VALUE(name))

#include "dwg_macro.h"

#define SKIP(name) dump_retzero()

#define FIELD_TV(name) FIELD(name, TV);
#define FIELD_T FIELD_TV

#define FIELD_BD(name) FIELD(name, BD);
#define FIELD_RD(name) FIELD(name, RD);
#define FIELD_BT(name) FIELD(name, BT);

#define FIELD_HANDLE(name, handle_code)\
  printf ("  " #name ": HANDLE(%1X.%d.%lu)\n",\
        FIELD_VALUE(name).code,\
        FIELD_VALUE(name).size,\
        FIELD_VALUE(name).value);

#define FIELD_HANDLE_NGR(name)\
  printf ("  " #name ": HANDLE(%1X.%d.%lu)\n",\
        obj->as.nongraph.name.code,\
        obj->as.nongraph.name.size,\
        obj->as.nongraph.name.value);

#define FIELD_4BITS(name) FIELD(name, RC);

#define FIELD_BE(name) printf ("  " #name ": (%g, %g, %g)\n", _obj->name.x, _obj->name.y, _obj->name.z);

#define FIELD_DD(name, _default) FIELD_RD(name)
#define FIELD_2DD(name, d1, d2) FIELD_DD(name.x, d1); FIELD_DD(name.y, d2);

#define FIELD_3DPOINT(name) FIELD_3BD(name)

#define FIELD_CMC(name) \
    if (_obj->name.rgb) \
      printf ("  " #name ": RGB %X\n", _obj->name.rgb); \
    else \
      printf ("  " #name ": index %d\n", _obj->name.index);

#define FIELD_VECTOR_N(name, type, size)\
    for (vcount=0; vcount< size; vcount++)\
      {\
        printf ("  " #name "[%d]: " FORMAT_##type "\n", vcount, FIELD_VALUE(name)[vcount]);\
      }\

#define FIELD_VECTOR(name, type, size) FIELD_VECTOR_N(name, type, _obj->size)

#define FIELD_2RD_VECTOR(name, size)\
  for (vcount=0; vcount< _obj->size; vcount++)\
    {\
      FIELD_2RD(name[vcount]);\
    }

#define FIELD_TV_VECTOR(name, size)\
  if (_obj->size > 0)\
    {\
      for (vcount=0; vcount < _obj->size; vcount++)\
        {\
          printf ("  " #name "[%d]: " FORMAT_TV "\n", vcount, FIELD_VALUE(name)[vcount]);\
        }\
    }

#define FIELD_2DD_VECTOR(name, size)\
  FIELD_2RD(name[0]);\
  for (vcount = 1; vcount < _obj->size; vcount++)\
    {\
      FIELD_2DD(name[vcount], FIELD_VALUE(name[vcount - 1].x), FIELD_VALUE(name[vcount - 1].y));\
    }

#define FIELD_3DPOINT_VECTOR(name, size)\
  for (vcount=0; vcount< _obj->size; vcount++)\
    {\
      FIELD_3DPOINT(name[vcount]);\
    }

#define HANDLE_VECTOR_N(name, size, code)\
  for (vcount=0; vcount < size; vcount++)\
    {\
      FIELD_HANDLE(name[vcount], code);\
    }

#define HANDLE_VECTOR(name, sizefield, code) HANDLE_VECTOR_N(name, FIELD_VALUE(sizefield), code)

#define FIELD_XDATA(name, size) return;

#define REACTORS(hcode)\
  for (vcount=0; vcount < obj->num_reactors; vcount++)\
    {\
      printf ("  reactors[%lu]: HANDLE(%1X.%d.%lu)\n", \
            vcount, \
            obj->reactors[vcount].code, \
            obj->reactors[vcount].size, \
            obj->reactors[vcount].value); \
    }

#define XDICOBJHANDLE(hcode)\
  if (obj->parent->header.version >= R_2004)\
    {\
      if (!obj->xdic_missing_flag)\
        {\
          printf ("  xdicobjhandle: HANDLE(%1X.%d.%lu)\n", \
            obj->xdicobjhandle.code, \
            obj->xdicobjhandle.size, \
            obj->xdicobjhandle.value); \
        }\
    }\
  else\
    {\
      printf ("  xdicobjhandle: HANDLE(%1X.%d.%lu)\n", \
            obj->xdicobjhandle.code, \
            obj->xdicobjhandle.size, \
            obj->xdicobjhandle.value); \
    }

#define REPEAT_N(times, name, type) \
  for (rcount=0; rcount<times; rcount++)

#define REPEAT(times, name, type) \
  for (rcount=0; rcount<_obj->times; rcount++)

#define REPEAT2(times, name, type) \
  for (rcount2=0; rcount2<_obj->times; rcount2++)

#define REPEAT3(times, name, type) \
  for (rcount3=0; rcount3<_obj->times; rcount3++)

#define VECTOR_FREE(name) 

#define COMMON_ENTITY_HANDLE_DATA \
  dump_entity_handle (dat, obj);

#define DWG_ENTITY(token) \
void \
dump_##token (Bit_Chain *dat, Dwg_Object * obj)\
{\
  char tmp[1024];\
  unsigned int vcount, rcount, rcount2, rcount3;\
  Dwg_Struct * dwg = obj->parent;\
  Dwg_Entity_##token *ent, *_obj;\
  printf ("Entity " #token ":\n");\
  ent = &obj->as.entity.as.token;\
  _obj=ent;\
  printf ("  Handle: %1X.%d.%lu\n",\
    obj->handle.code,\
    obj->handle.size,\
    obj->handle.value);

#define DWG_ENTITY_END }

#define DWG_NONGRAPH(token) \
void \
dump_##token (Bit_Chain *dat, Dwg_Object * obj) \
{ \
  char tmp[1024];\
  unsigned int vcount, rcount, rcount2, rcount3;\
  Dwg_Struct * dwg = obj->parent;\
  Dwg_Nongraph_##token *_obj;\
  printf ("Object " #token ":\n");\
  _obj = &obj->as.nongraph.as.token;\
  printf ("  Handle: %1X.%d.%lu\n",\
    obj->handle.code,\
    obj->handle.size,\
    obj->handle.value);

#define DWG_NONGRAPH_END }

int dump_retzero() {return (0);}

#define IS_PRINT
#include "dwg_object.spe.c"
#undef IS_PRINT
