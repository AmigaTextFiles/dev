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
 *     \file       object.c
 *     \brief      Object functions
 *     \author     written by Felipe Castro
 *     \author     modified by Felipe Corrêa da Silva Sances
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \author     modified by Till Heuschmann
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "object.h"
#include "dwg.h"
#include "bits.h"
#include "decode.h"
#include "logging.h"

/* Object decoding functions (auto-generated) */
//#include "auto_object.c"

/* Object freeing functions (auto-generated) */
//#include "auto_object_free.c"

static long res_obj = 0;
void
dwg_objects_reset ()
{
  res_obj = 0;
}

/** Decode object from bitchain */
void
dwg_object_add_from_chain (Dwg_Struct * dwg, Bit_Chain * dat, uint32_t address)
{
  Dwg_Object *obj;
  uint32_t previous_address, object_address;
  uint8_t previous_bit;
  int32_t i;
  int success;
  char tmp[1024];

  /* PUSH the previous bitchain address */
  previous_address = dat->byte;
  previous_bit = dat->bit;

  /* Use the indicated bitchain address for the object */
  dat->byte = address;
  dat->bit = 0;

  /* Reserve memory space for objects */
# define OBJ_CHUNK 256
  if (res_obj == 0)
    {
      dwg->object = (Dwg_Object *) calloc (OBJ_CHUNK, sizeof (Dwg_Object));
      res_obj = OBJ_CHUNK;
      snprintf (tmp, 1024, "sizeof(Dwg_Object): %lu\n", sizeof (Dwg_Object));
      LOG_MEMORY (tmp);
    }
  if ((long)dwg->num_objects >= res_obj)
    {
      res_obj += OBJ_CHUNK;
      dwg->object =
	(Dwg_Object *) realloc (dwg->object, res_obj * sizeof (Dwg_Object));
      memset (dwg->object + dwg->num_objects, 0, OBJ_CHUNK * sizeof (Dwg_Object));
    }
  obj = &dwg->object[dwg->num_objects];
  obj->index = dwg->num_objects;
  obj->parent = dwg;

  /* Skip size */
  if (dwg->header.version > R_2000)
    bit_read_MS (dat);

  /* Check the type of the object */
  obj->type = bit_read_BS (dat);
  switch (obj->type)
    {
    /* XXX Apply same action for each object type */
    OBJECT_CASE_SET (dwg_decode_)
    default:
      i = obj->type - 500;
      if (i >= dwg->num_classes || i < 0)
	success = 0;
      else if (dwg->dwg_class[i].dxfname == NULL)
	success = 0;
      /* the same, for vartypes */
      OBJECT_VARTYPE_ELSEIF_SET (dwg_decode_)
      else
        success = 0;
    }
  if (success)
    dwg->num_objects++;
  else if (dwg->header.version <= R_2000)
    {
      dwg_object_free (obj);
      memset (obj, 0, sizeof (Dwg_Object));
    }

  /* POP the previous bitchain addresses for return */
  dat->byte = previous_address;
  dat->bit = previous_bit;
}

int
dwg_object_free (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Bit_Chain *dat = NULL;
  int success;
  int32_t i;

  if (dwg == NULL)
    return (0);

  switch (obj->type)
    {
    /* XXX apply same action for each object type */
    OBJECT_CASE_SET (dwg_free_)
    default:
      i = obj->type - 500;
      if (i >= dwg->num_classes || i < 0)
	success = 0;
      /* XXX same for vartypes */
      OBJECT_VARTYPE_ELSEIF_SET (dwg_free_)
      else
        success = 0;
    }
  return (success);
}
