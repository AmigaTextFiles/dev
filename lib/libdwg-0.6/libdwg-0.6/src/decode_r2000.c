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
 *     \file       decode_r2000.c
 *     \brief      R2000 (R13-R15) decode functions
 *     \author     written by Felipe Castro
 *     \author     modified by Felipe Corrêa da Silva Sances
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \author     modified by Till Heuschmann
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "dwg.h"
#include "bits.h"
#include "decode.h"
#include "decode_r2000.h"
#include "variables.h"
#include "logging.h"

extern Dwg_Header_Section header;

/** Decode R13-R15 */
int
decode_r2000 (Bit_Chain * dat, Dwg_Struct * dwg)
{
  char tmp[1024];
  unsigned char sig;
  long unsigned pvz;
  unsigned i;

  /* Codepage */
  dat->byte = 0x13;
  dwg->header.codepage = bit_read_RS (dat);
  snprintf (tmp, 1024, "Codepage: %u\n", dwg->header.codepage);
  LOG_TRACE (tmp);

  /* Section Locator Records */
  dat->byte = 0x15;
  dec_r2000_section_locator (dat, dwg);

  /* Header Variables */
  dec_r2000_variables (dat, dwg);

  /* Classes */
  dec_r2000_classes (dat, dwg);

  /* Objects scanning */
  dec_r2000_objects (dat, dwg);

  /* Section Measurement */
  dec_r2000_measurement (dat, dwg);

  return 0;
}

/** Read R2000 Section Map */
void
dec_r2000_section_locator (Bit_Chain * dat, Dwg_Struct * dwg)
{
  char tmp[1024];
  uint8_t crc, crc2;
  int i;

  header.num_sections = bit_read_RL (dat);
  header.section = (Dwg_Section *) malloc (header.num_sections * sizeof (Dwg_Section));
  snprintf (tmp, 1024, "HEADER sections: %u\n", header.num_sections);
  LOG_TRACE (tmp);

  for (i = 0; i < header.num_sections; i++)
    {
      header.section[i].number = bit_read_RC (dat);
      header.section[i].address = bit_read_RL (dat);
      header.section[i].size = bit_read_RL (dat);
      snprintf (tmp, 1024, "  [%i] Adress: 0x%X; Size: %lu\n",
		header.section[i].number, header.section[i].address, header.section[i].size);
      LOG_TRACE (tmp);
    }

  /* Check CRC */
  crc = bit_crc8 (0xc0c1, dat->chain, dat->byte);
  crc2 = bit_read_RS (dat);

  if (crc != crc2)
    {
      snprintf (tmp, 1024, "Header CRC mismatch. Read:%x; Calc:%x \n", crc, crc2);
      LOG_WARN (tmp);
      return;
    }

  if (bit_search_sentinel (dat, decode_sentinel (DWG_SENTINEL_HEADER_END)))
    {
      snprintf (tmp, 1024, "\nHEADER (end): %8X \n", (unsigned int) dat->byte);
      LOG_TRACE (tmp);
    }
}

/** Read R13-R15 Variables */
void
dec_r2000_variables (Bit_Chain * dat, Dwg_Struct * dwg)
{
  char tmp[1024];
  uint32_t size;
  uint8_t ckr, ckr2;

  snprintf (tmp, 1024, "\nVARIABLES:\t %8X \n", (unsigned int) header.section[0].address);
  LOG_TRACE (tmp);
  snprintf (tmp, 1024, "VARIABLES (end): %8X \n", (unsigned int) (header.section[0].address + header.section[0].size));
  LOG_TRACE (tmp);

  dat->byte = header.section[0].address + 16;
  size = bit_read_RL (dat);
  snprintf (tmp, 1024, "Length: %lu\n", size);
  LOG_TRACE (tmp);

  dat->bit = 0;
  dwg_decode_variables (dat, dwg);

  /* Check CRC */
  dat->byte = header.section[0].address + header.section[0].size - 18;
  dat->bit = 0;
  ckr = bit_read_RS (dat);
  ckr2 = bit_crc8 (0xc0c1, dat->chain + header.section[0].address + 16, header.section[0].size - 34);
  if (ckr != ckr2)
    {
      snprintf (tmp, 1024, "Variables CRC failed! CRC:%x CRC2:%x \n", ckr, ckr2);
      LOG_ERROR (tmp);
    }
}

/** R2000 Class Section */
void
dec_r2000_classes (Bit_Chain * dat, Dwg_Struct * dwg)
{
  char tmp[1024];
  uint32_t size, last, pvz;
  uint8_t ckr, ckr2;

  snprintf (tmp, 1024, "\nCLASS:\t %8X\n", (unsigned) header.section[1].address);
  LOG_TRACE (tmp);
  snprintf (tmp, 1024, "CLASS (end): %8X\n", (unsigned) (header.section[1].address + header.section[1].size));
  LOG_TRACE (tmp);

  dat->byte = header.section[1].address + 16;
  dat->bit = 0;
  size = bit_read_RL (dat);
  last = dat->byte + size;
  snprintf (tmp, 1024, " Length: %x\n", size);
  LOG_TRACE (tmp);

  /* Read the classes
   */
  dwg->num_classes = 0;
  do
    {
      unsigned idc;

      idc = dwg->num_classes;
      if (idc == 0)
	dwg->dwg_class = (Dwg_Class *) malloc (sizeof (Dwg_Class));
      else
	dwg->dwg_class = (Dwg_Class *) realloc (dwg->dwg_class, (idc + 1) * sizeof (Dwg_Class));

      dwg->dwg_class[idc].number = bit_read_BS (dat);
      dwg->dwg_class[idc].version = bit_read_BS (dat);
      dwg->dwg_class[idc].appname = bit_read_TV (dat);
      dwg->dwg_class[idc].cppname = bit_read_TV (dat);
      dwg->dwg_class[idc].dxfname = bit_read_TV (dat);
      dwg->dwg_class[idc].wasazombie = bit_read_B (dat);
      dwg->dwg_class[idc].item_class_id = bit_read_BS (dat);

      if (log_level_get () >= LOG_LEVEL_TRACE)
        {
          fprintf (stderr, "\n");
          fprintf (stderr, "Number: %d \n", dwg->dwg_class[idc].number);
          fprintf (stderr, "Version: %x \n", dwg->dwg_class[idc].version);
          fprintf (stderr, "Application name: %s \n", dwg->dwg_class[idc].appname);
          fprintf (stderr, "C++ class name: %s \n", dwg->dwg_class[idc].cppname);
          fprintf (stderr, "DXF record name: %s \n", dwg->dwg_class[idc].dxfname);
        }

      dwg->num_classes++;
    }
  while (dat->byte < (last - 1));

  /* Check CRC */
  dat->byte = header.section[1].address + header.section[1].size - 18;
  dat->bit = 0;
  ckr = bit_read_RS (dat);
  ckr2 = bit_crc8 (0xc0c1, dat->chain + header.section[1].address + 16, header.section[1].size - 34);
  if (ckr != ckr2)
    {
      snprintf (tmp, 1024, "Classes CRC failed! CRC:%x CRC2:%x\n", ckr, ckr2);
      LOG_ERROR (tmp);
    }

  /* Unknown bitlong inter class and object */
  dat->byte += 16;
  pvz = bit_read_RL (dat);
  snprintf (tmp, 1024, "Address: %lu / Content: 0x%#x \n", dat->byte - 4, pvz);
  LOG_TRACE (tmp);

  snprintf (tmp, 1024, "Number of classes read: %u \n", dwg->num_classes);
  LOG_TRACE (tmp);
}

#define MAX_SECTIONS_R2000 7
/** Scan R13-R15 objects */
void
dec_r2000_objects (Bit_Chain * dat, Dwg_Struct * dwg)
{
  char tmp[1024];
  uint32_t obj_begin, obj_end;
  uint16_t lastcrc;
  uint32_t adra[MAX_SECTIONS_R2000], adrb[MAX_SECTIONS_R2000];
  int i;

  for (i = 0; i < header.num_sections; i++)
    {
      adra[i] = header.section[i].address;
      adrb[i] = adra[i] + header.section[i].size;
    }
  dat->byte = 70;
  dat->bit = 0;

  obj_begin = dat->byte;
  obj_end = dat->size - 2;
  snprintf (tmp, 1024, "\n===== SCANNING ===== Begin: %04X; End: %04X\n", obj_begin, obj_end);
  LOG_TRACE (tmp);

  dwg->num_objects = 0;
  while (dat->byte < obj_end)
    {
      uint32_t prevadr, n_obj, objtype;

      /* Skip variables and class sections
       */
      for (i = 0; i < 2; i++)
	{
	  if (dat->byte > adra[i] && dat->byte < adrb[i])
	    dat->byte = adrb[i];
	}

      /* Decode next object
       */
      n_obj = dwg->num_objects;
      prevadr = dat->byte;
      dwg_object_add_from_chain (dwg, dat, prevadr);
      if (n_obj == dwg->num_objects - 1)
	{
	  snprintf (tmp, 1024, "  ====== END Objtype: %i (at %04X)\n", dwg->object[n_obj].type, dat->byte);
	  LOG_TRACE (tmp);
	}

      dat->byte++;
    }
  snprintf (tmp, 1024, "===== SCANNING ===== End\n");
  LOG_TRACE (tmp);
  snprintf (tmp, 1024, "Num objects scanned: %lu \n", dwg->num_objects);
  LOG_TRACE (tmp);
}

/** Read Section Measurement */
void
dec_r2000_measurement (Bit_Chain * dat, Dwg_Struct * dwg)
{
  char tmp[1024];

  snprintf (tmp, 1024, "\nUNKNOWN 2:\t %8X \n", (unsigned) header.section[4].address);
  LOG_TRACE (tmp);
  snprintf (tmp, 1024, "UNKNOWN 2 (end): %8X \n", (unsigned) (header.section[4].address + header.section[4].size));
  LOG_TRACE (tmp);
  dat->byte = header.section[4].address;
  dat->bit = 0;
  dwg->variable.MEASUREMENT = bit_read_RL (dat);
  snprintf (tmp, 1024, "\nSize bytes :\t%lu \n", dat->size);
  LOG_TRACE (tmp);
}
