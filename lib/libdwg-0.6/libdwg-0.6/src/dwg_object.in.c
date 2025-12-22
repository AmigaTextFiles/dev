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
 *     \file       dwg_objects.in.c
 *     \brief      Decoding objects (input C file)
 *     \author     written by Felipe Castro
 *     \author     modified by Felipe Corrêa da Silva Sances
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \author     modified by Till Heuschmann
 *     \author     modified by Felipe Castro
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#define FIELD_VALUE(name) _obj->name

#define FIELD(name,type)\
  FIELD_VALUE(name) = bit_read_##type(dat);\
  snprintf (tmp, 1024, "  " #name ": " FORMAT_##type "\n", FIELD_VALUE(name));\
  LOG_TRACE (tmp);

#include "dwg_macro.h"

#define SKIP(name) bit_read_##name(dat)

#define FIELD_TV(name) \
  FIELD(name, TV); \
  if (FIELD_VALUE(name) == NULL) \
    {\
      return (0);\
    }

#define FIELD_T FIELD_TV	/*TODO: implement version dependant string fields */

/* XXX: this is really dirty! */
#define MAX_POS 1.0e27 
#define MIN_POS 1.0e-31
#define MAX_NEG -1.0e-31
#define MIN_NEG -1.0e27

#define TEST_D(name) \
  if (FIELD_VALUE(name) > MAX_POS || FIELD_VALUE(name) < MIN_NEG) \
    {\
      return (0); \
    }\
  else if (FIELD_VALUE(name) < MIN_POS && FIELD_VALUE(name) > MAX_NEG && FIELD_VALUE(name) != 0) \
    {\
      return (0);\
    }\

#define FIELD_BD(name) FIELD(name, BD); TEST_D(name);
#define FIELD_RD(name) FIELD(name, RD); TEST_D(name);
#define FIELD_BT(name) FIELD(name, BT); TEST_D(name);

#define FIELD_HANDLE(name, handle_code)\
  if (bit_read_H (dat, &FIELD_VALUE(name)) )\
    {\
      return (0);\
    }\
  snprintf (tmp, 1024, "  " #name ": HANDLE(%d.%d.%lu)\n",\
        FIELD_VALUE(name).code,\
        FIELD_VALUE(name).size,\
        FIELD_VALUE(name).value);\
  LOG_TRACE(tmp);

#define FIELD_HANDLE_NGR(name)\
  if (bit_read_H (dat, &obj->as.nongraph.name) )\
    {\
      return (0);\
    }\
  snprintf (tmp, 1024, "  " #name ": HANDLE(%X.%d.%lu)\n",\
        obj->as.nongraph.name.code,\
        obj->as.nongraph.name.size,\
        obj->as.nongraph.name.value);\
  LOG_TRACE(tmp);

#define FIELD_4BITS(name) FIELD_VALUE(name) = bit_read_4BITS(dat); \
  snprintf (tmp, 1024, "  " #name ": %1X\n", FIELD_VALUE(name)); \
  LOG_TRACE (tmp);

#define FIELD_BE(name) bit_read_BE(dat, &FIELD_VALUE(name).x, &FIELD_VALUE(name).y, &FIELD_VALUE(name).z);\
  snprintf (tmp, 1024, "  " #name ".x: %g\n  " #name ".y: %g\n  " #name ".z: %g\n", \
		  FIELD_VALUE(name).x, \
		  FIELD_VALUE(name).y, \
		  FIELD_VALUE(name).z);\
  LOG_TRACE(tmp); \
  TEST_D(name.x); TEST_D(name.y); TEST_D(name.z);

#define FIELD_DD(name, _default) \
  FIELD_VALUE(name) = bit_read_DD(dat, _default); \
  TEST_D(name);
#define FIELD_2DD(name, d1, d2) FIELD_DD(name.x, d1); FIELD_DD(name.y, d2);

#define FIELD_3DPOINT(name) FIELD_3BD(name)

#define FIELD_CMC(name)\
    bit_read_CMC(dat, &FIELD_VALUE(name)); \
    if (FIELD_VALUE(name).rgb) \
      snprintf (tmp, 1024, "  " #name ": RGB %X\n", FIELD_VALUE(name).rgb); \
    else \
      snprintf (tmp, 1024, "  " #name ": index %d\n", FIELD_VALUE(name).index); \
    LOG_TRACE(tmp);

//FIELD_VECTOR_N(name, type, size):
// reads data of the type indicated by 'type' 'size' times and stores
// it all in the vector called 'name'.
#define FIELD_VECTOR_N(name, type, size)\
  if (size > 0)\
    {\
      FIELD_VALUE(name) = (BITCODE_##type*) malloc(size * sizeof(BITCODE_##type));\
      for (vcount=0; vcount < size; vcount++)\
        {\
          FIELD_VALUE(name)[vcount] = bit_read_##type(dat);\
          snprintf (tmp, 1024, "  " #name "[%d]: " FORMAT_##type "\n", vcount, FIELD_VALUE(name)[vcount]); \
          LOG_TRACE(tmp);\
        }\
    }

#define FIELD_VECTOR(name, type, size) FIELD_VECTOR_N(name, type, _obj->size)

#define FIELD_TV_VECTOR(name, size)\
  if (FIELD_VALUE(size) > 0)\
    {\
      FIELD_VALUE(name) = (BITCODE_TV*) malloc (FIELD_VALUE(size) * sizeof(BITCODE_TV*));\
      for (vcount=0; vcount < FIELD_VALUE(size); vcount++)\
        {\
          FIELD_VALUE(name)[vcount] = bit_read_TV(dat);\
          snprintf (tmp, 1024, "  " #name "[%d]: " FORMAT_TV "\n", vcount, FIELD_VALUE(name)[vcount]); \
          LOG_TRACE(tmp); \
        }\
    }

#define FIELD_2RD_VECTOR(name, size)\
  if (FIELD_VALUE(size) > 0)\
    {\
      FIELD_VALUE(name) = (BITCODE_2RD *) malloc(FIELD_VALUE(size) * sizeof(BITCODE_2RD));\
    }\
  for (vcount=0; vcount< FIELD_VALUE(size); vcount++)\
    {\
      FIELD_2RD(name[vcount]);\
    }

#define FIELD_2DD_VECTOR(name, size)\
  if (FIELD_VALUE(size) > 0)\
    {\
      FIELD_VALUE(name) = (BITCODE_2RD *) malloc(FIELD_VALUE(size) * sizeof(BITCODE_2RD));\
      FIELD_2RD(name[0]);\
      for (vcount = 1; vcount < FIELD_VALUE(size); vcount++)\
        {\
          FIELD_2DD(name[vcount], FIELD_VALUE(name[vcount - 1].x), FIELD_VALUE(name[vcount - 1].y));\
        }\
    }\

#define FIELD_3DPOINT_VECTOR(name, size)\
  if (FIELD_VALUE(size) > 0)\
    {\
      FIELD_VALUE(name) = (BITCODE_3DPOINT *) malloc(FIELD_VALUE(size) * sizeof(BITCODE_3DPOINT));\
    }\
  for (vcount=0; vcount< FIELD_VALUE(size); vcount++)\
    {\
      FIELD_3DPOINT(name[vcount]);\
    }

#define HANDLE_VECTOR_N(name, size, code)\
  if (size > 0)\
    {\
      FIELD_VALUE(name) = (BITCODE_H*) malloc(sizeof(BITCODE_H) * size);\
    }\
  for (vcount=0; vcount < size; vcount++)\
    {\
      FIELD_HANDLE(name[vcount], code);\
    }

#define HANDLE_VECTOR(name, sizefield, code) HANDLE_VECTOR_N(name, FIELD_VALUE(sizefield), code)

#define FIELD_XDATA(name, size) return(0);

#define REACTORS(hcode)\
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

#define ENT_REACTORS REACTORS

#define XDICOBJHANDLE(hcode)\
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
      else\
        LOG_TRACE ("  xdic missing flag: 1\n");\
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

#define ENT_XDICOBJHANDLE XDICOBJHANDLE

#define REPEAT_N(times, name, type) \
  FIELD_VALUE(name) = (type *) malloc(times * sizeof(type));\
  for (rcount=0; rcount < times; rcount++)

#define REPEAT(times, name, type) \
  FIELD_VALUE(name) = (type *) malloc(_obj->times * sizeof(type));\
  for (rcount=0; rcount < _obj->times; rcount++)

#define REPEAT2(times, name, type) \
  FIELD_VALUE(name) = (type *) malloc(_obj->times * sizeof(type));\
  for (rcount2=0; rcount2 < _obj->times; rcount2++)

#define REPEAT3(times, name, type) \
  FIELD_VALUE(name) = (type *) malloc(_obj->times * sizeof(type));\
  for (rcount3=0; rcount3 < _obj->times; rcount3++)

#define VECTOR_FREE(name) 

#define COMMON_ENTITY_HANDLE_DATA \
  dwg_decode_entity_handles (dat, obj)

#define DWG_ENTITY(token) \
int \
dwg_decode_##token (Bit_Chain * dat, Dwg_Object * obj)\
{\
  char tmp[1024];\
  unsigned vcount, rcount, rcount2, rcount3;\
  Dwg_Entity_##token *ent, *_obj;\
  Dwg_Struct* dwg = obj->parent;\
  memset (&obj->as.entity, 0, sizeof (Dwg_Object_Entity));\
  obj->supertype = DWG_SUPERTYPE_ENTITY;\
  obj->as.entity.parent = obj;\
  if (!dwg_decode_entity (dat, &obj->as.entity)) return(0);\
  ent = &obj->as.entity.as.token;\
  _obj = ent; \
  snprintf (tmp, 1024, "Entity " #token "\n"); \
  LOG_TRACE (tmp); \
  snprintf (tmp, 1024, "  Handle: %d.%d.%lu\n", \
    obj->handle.code, \
    obj->handle.size, \
    obj->handle.value); \
  LOG_TRACE (tmp);

#define DWG_ENTITY_END \
  snprintf (tmp, 1024, "  ENTITY SUCCESS!\n");\
  LOG_TRACE (tmp);\
  return(1);}

#define DWG_NONGRAPH(token) \
int \
dwg_decode_ ## token (Bit_Chain * dat, Dwg_Object * obj)\
{\
  char tmp[1024];\
  unsigned vcount, rcount, rcount2, rcount3;\
  Dwg_Nongraph_##token *_obj;\
  Dwg_Struct* dwg = obj->parent;\
  memset (&obj->as.nongraph, 0, sizeof (Dwg_Object_Nongraph));\
  obj->supertype = DWG_SUPERTYPE_NONGRAPH;\
  obj->as.nongraph.parent = obj;\
  if (!dwg_decode_nongraph (dat, &obj->as.nongraph)) return (0);\
  _obj = &obj->as.nongraph.as.token;\
  snprintf (tmp, 1024, "Object " #token "\n");\
  LOG_TRACE (tmp);\
  snprintf (tmp, 1024, "  Handle: %d.%d.%lu\n", \
    obj->handle.code,\
    obj->handle.size,\
    obj->handle.value);\
  LOG_TRACE (tmp);\

#define DWG_NONGRAPH_END \
  snprintf (tmp, 1024, "  NONGRAPH SUCCESS!\n");\
  LOG_TRACE (tmp);\
  return(1);}

#define IS_DECODER
#include "dwg_object.spe.c"
#undef IS_DECODER
