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
 *     \file       dwg_objects_free.in.c
 *     \brief      Freeing data in objects (input C file)
 *     \author     written by Felipe Castro
 *     \author     modified by Felipe Corrêa da Silva Sances
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \author     modified by Till Heuschmann
 *     \author     modified by Felipe Castro
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#define FIELD_VALUE(name) _obj->name

#define FIELD(name,type) 

#include "dwg_macro.h"

#define SKIP(name) obj_free_retzero() 

#define FIELD_TV(name) \
	if (FIELD_VALUE(name)) \
        {\
          free (FIELD_VALUE(name)); \
          FIELD_VALUE(name) = NULL;\
        }

#define FIELD_T FIELD_TV

#define FIELD_BD(name) 
#define FIELD_RD(name) 
#define FIELD_BT(name) 

#define FIELD_HANDLE(name, handle_code) 
#define FIELD_HANDLE_NGR(name) 
#define FIELD_HANDLE_OBJ(name) 
#define FIELD_4BITS(name) 
#define FIELD_BE(name) 
#define FIELD_DD(name, _default) 
#define FIELD_2DD(name, d1, d2) 
#define FIELD_3DPOINT(name) 

#define FIELD_CMC(token) \
	FIELD_TV(token.name); \
	FIELD_TV(token.book_name);

#define FIELD_VECTOR_N(name, type, size) FIELD_TV(name)

#define FIELD_VECTOR(name, type, size) FIELD_TV(name)

#define FIELD_TV_VECTOR(name, size)\
      for (vcount=0; vcount < FIELD_VALUE(size); vcount++)\
        {\
          FIELD_TV(name[vcount]);\
        }\
      FIELD_TV(name);

#define FIELD_2RD_VECTOR(name, size) FIELD_TV(name)

#define FIELD_2DD_VECTOR(name, size) FIELD_TV(name)

#define FIELD_3DPOINT_VECTOR(name, size) FIELD_TV(name)

#define HANDLE_VECTOR_N(name, size, code) FIELD_TV(name)

#define HANDLE_VECTOR(name, sizefield, code) FIELD_TV(name)

#define FIELD_XDATA(name, size) return;

#define REACTORS(code) \
  if (obj->reactors)\
    {\
      free (obj->reactors);\
      obj->reactors = NULL;\
    }

#define ENT_REACTORS REACTORS

#define XDICOBJHANDLE(code) 

#define ENT_XDICOBJHANDLE(code) 

#define REPEAT_N(times, name, type) \
  for (rcount=0; rcount < times; rcount++)

#define REPEAT(times, name, type) \
  for (rcount=0; rcount < FIELD_VALUE(times); rcount++)

#define REPEAT2(times, name, type) \
  for (rcount2=0; rcount2 < FIELD_VALUE(times); rcount2++)

#define REPEAT3(times, name, type) \
  for (rcount3=0; rcount3 < FIELD_VALUE(times); rcount3++)

#define VECTOR_FREE(name) FIELD_TV(name)

#define COMMON_ENTITY_HANDLE_DATA \
  if (obj->reactors)\
    {\
      free (obj->reactors);\
      obj->reactors = NULL;\
    }

#define DWG_ENTITY(token) \
int \
dwg_free_##token (Bit_Chain * dat, Dwg_Object * obj)\
{\
  char tmp[1024]; \
  unsigned vcount, rcount, rcount2, rcount3;\
  if (obj == NULL) return (0);\
  Dwg_Struct * dwg = obj->parent;\
  Dwg_Entity_##token *ent, *_obj;\
  ent = &obj->as.entity.as.token;\
  _obj = ent;\
  snprintf (tmp, 1024, "Freeing ENT: " #token "; Handle: 0x%X; index: %lu\n",\
    obj->handle.value, obj->index); \
  LOG_MEMORY (tmp);

#define DWG_ENTITY_END return(1);}

#define DWG_NONGRAPH(token) \
int \
dwg_free_##token (Bit_Chain * dat, Dwg_Object * obj)\
{\
  char tmp[1024]; \
  unsigned vcount, rcount, rcount2, rcount3;\
  if (obj == NULL) return (0);\
  Dwg_Struct * dwg = obj->parent;\
  Dwg_Nongraph_##token *_obj;\
  _obj = &obj->as.nongraph.as.token;\
  snprintf (tmp, 1024, "Freeing NGR: " #token "; Handle: 0x%X; index: %lu\n",\
    obj->handle.value, obj->index); \
  LOG_MEMORY (tmp);

#define DWG_NONGRAPH_END return(1);}

int obj_free_retzero() {return (0);}

#define OBJECT_FREE
#include "dwg_object.spe.c"
#undef OBJECT_FREE
