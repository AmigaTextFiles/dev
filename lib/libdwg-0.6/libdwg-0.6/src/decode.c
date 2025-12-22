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
 *     \file       decode.c
 *     \brief      Decoding functions
 *     \author     written by Felipe Castro
 *     \author     modified by Felipe Corrêa da Silva Sances
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \author     modified by Till Heuschmann
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "dwg.h"
#include "bits.h"
#include "decode.h"
#include "decode_r2000.h"
#include "decode_r2004.h"
#include "logging.h"

/* Decode entity handles function (auto-generated) */
#include "auto_entity_handle.c"

/* Shared sections information struct */
Dwg_Header_Section header;

/** Decode DWG file */
int
dwg_decode_data (Bit_Chain * dat, Dwg_Struct * dwg)
{
  char version[7];
  char tmp[1024];
  dwg->num_classes = 0;
  dwg->num_objects = 0;

  /* Version */
  dat->byte = 0;
  dat->bit = 0;
  strncpy (version, (const char *) dat->chain, 6);
  version[6] = '\0';

  if (strcmp (version, dwg_version_code_from_id (R_13)) == 0)
    dwg->header.version = R_13;
  else if (strcmp (version, dwg_version_code_from_id (R_14)) == 0)
    dwg->header.version = R_14;
  else if (strcmp (version, dwg_version_code_from_id (R_2000)) == 0)
    dwg->header.version = R_2000;
  else if (strcmp (version, dwg_version_code_from_id (R_2004)) == 0)
    dwg->header.version = R_2004;
  else if (strcmp (version, dwg_version_code_from_id (R_2007)) == 0)
    dwg->header.version = R_2007;
  else if (strcmp (version, dwg_version_code_from_id (R_2010)) == 0)
    dwg->header.version = R_2010;
  else if (strcmp (version, dwg_version_code_from_id (R_2013)) == 0)
    dwg->header.version = R_2013;
  else
    {
      snprintf (tmp, 1024, "Unknown format! Is this a dwg file? Its version code is: %s\n", version);
      LOG_ERROR (tmp);
      return (-1);
    }

  snprintf (tmp, 1024, "This file's version code is: %s\n", version);
  LOG_INFO (tmp);
  dat->version = dwg->header.version;

  if (dwg->header.version == R_13)
    return (decode_r2000 (dat, dwg));

  if (dwg->header.version == R_14)
    return (decode_r2000 (dat, dwg));

  if (dwg->header.version == R_2000)
    return (decode_r2000 (dat, dwg));

  if (dwg->header.version == R_2004)
      return (decode_r2004 (dat, dwg));

  snprintf (tmp, 1024, "LibDWG does not support this version: %s.\n",
	    version);
  LOG_ERROR (tmp);
  return (-1);
}

/** Decode DWG object */
int
dwg_decode_object (Bit_Chain * dat, Dwg_Object * obj)
{
  char tmp[1024];
  int16_t len;
  int16_t len2;
  uint32_t bsize;
  Dwg_Handle hdl;
  Bit_Chain bc;

  if (dat->version >= R_2000)	// SINCE R_2000
    {
      /* Object bit-size */
      bsize = bit_read_RL (dat);
      if (bsize > 0x80000000)
       {
         LOG_INSANE ("FAIL: bit-size\n");
         return 0;
       }
    }

  if (bit_read_H (dat, &obj->handle) != 0)
    {
      LOG_INSANE ("FAIL: invalid handle\n");
      return 0;
    }
  if (obj->handle.code != 0)
    {
      LOG_INSANE ("FAIL: handle code != 0\n");
      return 0;
    }
  if (obj->handle.value > obj->parent->variable.HANDSEED.value)
    {
      LOG_INSANE ("FAIL: handle > HANDSEED\n");
      return 0;
    }
  if (obj->handle.value == 0)
    {
      LOG_INSANE ("FAIL: handle == 0\n");
      return 0;
    }

  // XXX: discarding extended data (old code was wrong, and extended data is not usable)
  while ((len = bit_read_BS (dat)) != 0)
    {
      /* Max acceptable data size (my pref) */
      if (len > 1000 || len < 0)
        {
          LOG_INSANE ("FAIL: extended data length\n");
          return 0;
        }
      /* Check valid app handle */
      if (bit_read_H (dat, &hdl) != 0)
        {
          LOG_INSANE ("FAIL: extended data, invalid handle\n");
	  return 0;
        }
      if (hdl.value > obj->parent->variable.HANDSEED.value)
        {
          LOG_INSANE ("FAIL: extended data, handle > HANDSEED\n");
	  return 0;
        }
      if (hdl.value == 0)
        {
          LOG_INSANE ("FAIL: extended data, handle == 0\n");
	  return 0;
	}
      /* Check valid DXF group-codes */
      bit_advance_position (dat, len * 8);
      bc.byte = dat->byte;
      bit_advance_position (dat, -len * 8);
      while (dat->byte < bc.byte)
	{
	  /* Read group-code */
	  switch (bit_read_RC (dat))
	    {
	    case 0:
	      if (dat->version <= R_2004)
		{
		  len2 = bit_read_RC (dat);
		  bit_read_RS (dat);
		  bit_advance_position (dat, len2 * 8);
		}
	      else
		{
		  len2 = bit_read_RS (dat);
		  bit_advance_position (dat, 2 * len2 * 8);
		}
	      break;
	    case 2:
	      bit_read_RC (dat);
	      break;
	    case 3:
	    case 5:
	      bit_advance_position (dat, 8 * 8);
	      break;
	    case 4:
	      len2 = bit_read_RC (dat);
	      bit_advance_position (dat, len2 * 8);
	      break;
	    case 10:
	    case 11:
	    case 12:
	    case 13:
	      bit_read_RD (dat);
	      bit_read_RD (dat);
	      bit_read_RD (dat);
	      break;
	    case 40:
	    case 41:
	    case 42:
	      bit_read_RD (dat);
	      break;
	    case 70:
	      bit_read_RS (dat);
	      break;
	    case 71:
	      bit_read_RL (dat);
	      break;
	    default:
              LOG_INSANE ("FAIL: extended data, unknown DXF group-code\n");
	      return 0;
	    }
	}
      dat->byte = bc.byte;
      snprintf (tmp, 1024, "Extended data: app HANDLE (%X.%d.%X), length %d.\n", hdl.code,
	      hdl.size, hdl.value, len);
      LOG_TRACE (tmp);
    }
  return 1;
}

/** Decode DWG entity */
int
dwg_decode_entity (Bit_Chain * dat, Dwg_Object_Entity * ent)
{
  char tmp[1024];
  unsigned int i;
  uint32_t size;
  uint32_t bsize;
  int error = 2;

  if (dwg_decode_object (dat, ent->parent) == 0)
  {
      //LOG_INSANE ("FAIL dwg_decode_object, from decode_entity.\n");
      return 0;
  }

  ent->picture_exists = bit_read_B (dat);
  if (ent->picture_exists)
    {
      ent->picture_size = bit_read_RL (dat);
      if (ent->picture_size < 210210)
	{
	  /* XXX: not scanning entity pictures
	     ent->picture = (char *) malloc(ent->picture_size);
	     for (i = 0; i < ent->picture_size; i++)
	     ent->picture[i] = bit_read_RC(dat);
	   */
	  dat->byte += ent->picture_size;
	  ent->picture_size = 0;
	}
      else
	{
          LOG_INSANE ("FAIL: picture_exists\n");
	  return 0;
	}
    }

  if (dat->version >= R_13 && dat->version <= R_14)	/* VERSIONS (R_13,R14) */
    {
      /* Object bit-size */
      bsize = bit_read_RL (dat);
      if (bsize > 0x80000000)
        {
          LOG_INSANE ("FAIL: bit_size\n");
          return 0;
        }
    }

  ent->entity_mode = bit_read_BB (dat);
  if (ent->entity_mode == 3)
    {
      LOG_INSANE ("FAIL: entity_mode\n");
      return 0;
    }

  ent->parent->num_reactors = bit_read_BL (dat);
  if (ent->parent->num_reactors > 0x00100000)
    {
      LOG_INSANE ("FAIL: num_reactors\n");
      return 0;
    }

  if (dat->version >= R_2004)	/* SINCE R_2004 */
    ent->parent->xdic_missing_flag = bit_read_B (dat);
  else
    ent->parent->xdic_missing_flag = 0;

  if (dat->version >= R_13 && dat->version <= R_14)	/* VERSIONS (R_13,R14) */
    ent->isbylayerlt = bit_read_B (dat);

  ent->nolinks = bit_read_B (dat);

  if (dat->version >= R_2004)	/* SINCE R_2004 */
    {
      char color_mode = 0;
      unsigned char index;
      unsigned int flags;

      if (ent->nolinks == 0)
	{
	  color_mode = bit_read_B (dat);

	  if (color_mode == 1)
	    index = bit_read_RC (dat);	// color index
	  else
	    {
	      flags = bit_read_RS (dat);

	      if (flags & 0x8000)
		{
		  unsigned char c1, c2, c3, c4;
		  BITCODE_TV name = NULL;

		  c1 = bit_read_RC (dat);	// rgb color
		  c2 = bit_read_RC (dat);
		  c3 = bit_read_RC (dat);
		  c4 = bit_read_RC (dat);

		  name = bit_read_TV (dat);
		}

	      if (flags & 0x4000)
		flags = flags;	// has AcDbColor reference (handle)

	      if (flags & 0x2000)
		{
		  int transparency = bit_read_BL (dat);
		}
	    }
	}
      else
	{
	  char color = bit_read_B (dat);
	}
    }
  else				/* OTHER VERSIONS */
    bit_read_CMC (dat, &ent->color);

  ent->linetype_scale = bit_read_BD (dat);
  if (ent->linetype_scale > 1.0e6 || ent->linetype_scale < 1.0e-6)
    {
      LOG_INSANE ("FAIL: linetype_scale\n");
      return 0;
    }

  if (dat->version >= R_2000)	/* SINCE R_2000 */
    {
      ent->linetype_flags = bit_read_BB (dat);
      ent->plotstyle_flags = bit_read_BB (dat);
    }

  if (dat->version >= R_2007)	/* SINCE R_2007 */
    {
      ent->material_flags = bit_read_BB (dat);
      ent->shadow_flags = bit_read_RC (dat);
    }

  ent->invisible = bit_read_BS (dat);

  if (dat->version >= R_2000)	/* SINCE R_2000 */
    {
      ent->lineweight = bit_read_RC (dat);
    }

  snprintf (tmp, 1024, "ObjType (Ent): %i (at %X) ===============\n",
	    ent->parent->type, dat->byte);
  LOG_TRACE (tmp);
  return 1;
}

/** Decode DWG Nongraph */
int
dwg_decode_nongraph (Bit_Chain * dat, Dwg_Object_Nongraph * ord)
{
  char tmp[1024];
  unsigned int i;
  unsigned int size;
  int error = 2;

  if (dwg_decode_object (dat, ord->parent) == 0)	/* if error */
  {
    //LOG_INSANE ("FAIL dwg_decode_object, from decode_nongraph.\n");
    return 0;
  }

  if (dat->version >= R_13 && dat->version <= R_14)	/* VERSIONS (R_13,R14) */
    {
      if (bit_read_RL (dat) > 0x10000000)
       {
         LOG_INSANE ("FAIL bit_size.\n");
	 return 0;
       }
    }

  ord->parent->num_reactors = bit_read_BL (dat);
  if (ord->parent->num_reactors > 0x00100000)
    {
      LOG_INSANE ("FAIL num_reactors.\n");
      return 0;
    }

  if (dat->version >= R_2004)	/* SINCE R_2004 */
    ord->parent->xdic_missing_flag = bit_read_B (dat);
  else
    ord->parent->xdic_missing_flag = 0;

  snprintf (tmp, 1024, "ObjType (Ngr): %i (at %X)\n", ord->parent->type,
	    dat->byte);
  LOG_TRACE (tmp);
  return 1;
}

void
decode_header_free ()
{
  int i;

  if (header.section)
    free (header.section);
  header.section = NULL;
  header.num_sections = 0;
  for (i = 0; i < header.num_descriptions; i++)
    {
      free (header.section_info[i].sections);
      header.section_info[i].sections = NULL;
      header.section_info[i].num_sections = 0;
    }
  if (header.section_info)
    free (header.section_info);
  header.section_info = NULL;
  header.num_descriptions = 0;
}

/** DWG sentinel */
unsigned char *
decode_sentinel (Dwg_Sentinel s)
{
  static unsigned char sentinels[9][16] = {
    {0x95, 0xA0, 0x4E, 0x28, 0x99, 0x82, 0x1A, 0xE5, 0x5E, 0x41, 0xE0, 0x5F,
     0x9D, 0x3A, 0x4D, 0x00},
    {0x1F, 0x25, 0x6D, 0x07, 0xD4, 0x36, 0x28, 0x28, 0x9D, 0x57, 0xCA, 0x3F,
     0x9D, 0x44, 0x10, 0x2B},
    {0xE0, 0xDA, 0x92, 0xF8, 0x2B, 0xc9, 0xD7, 0xD7, 0x62, 0xA8, 0x35, 0xC0,
     0x62, 0xBB, 0xEF, 0xD4},
    {0xCF, 0x7B, 0x1F, 0x23, 0xFD, 0xDE, 0x38, 0xA9, 0x5F, 0x7C, 0x68, 0xB8,
     0x4E, 0x6D, 0x33, 0x5F},
    {0x30, 0x84, 0xE0, 0xDC, 0x02, 0x21, 0xC7, 0x56, 0xA0, 0x83, 0x97, 0x47,
     0xB1, 0x92, 0xCC, 0xA0},
    {0x8D, 0xA1, 0xC4, 0xB8, 0xC4, 0xA9, 0xF8, 0xC5, 0xC0, 0xDC, 0xF4, 0x5F,
     0xE7, 0xCF, 0xB6, 0x8A},
    {0x72, 0x5E, 0x3B, 0x47, 0x3B, 0x56, 0x07, 0x3A, 0x3F, 0x23, 0x0B, 0xA0,
     0x18, 0x30, 0x49, 0x75},
    {0xD4, 0x7B, 0x21, 0xCE, 0x28, 0x93, 0x9F, 0xBF, 0x53, 0x24, 0x40, 0x09,
     0x12, 0x3C, 0xAA, 0x01},
    {0x2B, 0x84, 0xDE, 0x31, 0xD7, 0x6C, 0x60, 0x40, 0xAC, 0xDB, 0xBF, 0xF6,
     0xED, 0xC3, 0x55, 0xFE}
  };

  return (sentinels[s]);
}
