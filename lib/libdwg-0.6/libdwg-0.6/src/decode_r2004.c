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
 *     \file       decode_r2004.c
 *     \brief      R2004 decode functions
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
#include <assert.h>

#include "bits.h"
#include "decode.h"
#include "decode_r2004.h"
#include "variables.h"
#include "logging.h"

extern Dwg_Header_Section header;

/** Decode R2004 version */
int
decode_r2004 (Bit_Chain * dat, Dwg_Struct * dwg)
{
  int i;
  int rseed;
  char tmp[1024];
  Dwg_Section *section;

  /* Encrypted Data */
  union _2004_header_data
  {
    unsigned char encrypted_data[0x6c];
    struct
    {
      unsigned char file_ID_string[12];
      int32_t x00;
      int32_t x6c;
      int32_t x04;
      int32_t root_tree_node_gap;
      int32_t lowermost_left_tree_node_gap;
      int32_t lowermost_right_tree_node_gap;
      int32_t unknown_long;
      int32_t last_section_id;
      int32_t last_section_address;
      int32_t x00_2;
      int32_t second_header_address;
      int32_t x00_3;
      int32_t gap_amount;
      int32_t section_amount;
      int32_t x20;
      int32_t x80;
      int32_t x40;
      int32_t section_map_id;
      int32_t section_map_address;
      int32_t x00_4;
      int32_t section_info_id;
      int32_t section_array_size;
      int32_t gap_array_size;
      int32_t CRC;
    } fields;
  } hdat;

  /* System Section */
  union _system_section
  {
    unsigned char data[0x14];
    struct
    {
      int32_t section_type;	//0x41630?3b
      int32_t decomp_data_size;
      int32_t comp_data_size;
      int32_t compression_type;
      int32_t checksum;
    } fields;
  } ss;

  /* Codepage */
  dat->byte = 0x13;
  dwg->header.codepage = bit_read_RS (dat);
  snprintf (tmp, 1024, "Codepage: %u\n", dwg->header.codepage);
  LOG_TRACE (tmp);

  /* Start of encrypted data */
  dat->byte = 0x80;
  rseed = 1;
  for (i = 0; i < 0x6c; i++)
    {
      rseed *= 0x343fd;
      rseed += 0x269ec3;
      hdat.encrypted_data[i] = bit_read_RC (dat) ^ (rseed >> 0x10);
    }

  if (log_level_get () >= LOG_LEVEL_COMPRESS)
    {
      fprintf (stderr, "\n#### File Header Data fields R2004 ####\n");
      fprintf (stderr, "File ID string (must be AcFssFcAJMB): ");
      for (i = 0; i < 12; i++)
	fprintf (stderr, "%c", hdat.fields.file_ID_string[i]);
      fprintf (stderr, "\n");
      fprintf (stderr, "0x00 (long): %x \n", (unsigned int) hdat.fields.x00);
      fprintf (stderr, "0x6c (long): %x \n", (unsigned int) hdat.fields.x6c);
      fprintf (stderr, "0x04 (long): %x \n", (unsigned int) hdat.fields.x04);
      fprintf (stderr, "Root tree node gap: %x \n", (unsigned int) hdat.fields.root_tree_node_gap);
      fprintf (stderr, "Lowermost left tree node gap: %x \n", (unsigned int) hdat.fields.lowermost_left_tree_node_gap);
      fprintf (stderr, "Lowermost right tree node gap: %x \n",
	       (unsigned int) hdat.fields.lowermost_right_tree_node_gap);
      fprintf (stderr, "Unknown long: %x \n", (unsigned int) hdat.fields.unknown_long);
      fprintf (stderr, "Last section id: %d  \n", (unsigned int) hdat.fields.last_section_id);
      fprintf (stderr, "Last section address: %x\n", (unsigned int) hdat.fields.last_section_address);
      fprintf (stderr, "0x00 (long): %x \n", (unsigned int) hdat.fields.x00_2);
      fprintf (stderr, "Second header address: %x\n", (unsigned int) hdat.fields.second_header_address);
      fprintf (stderr, "0x00 (long): %x \n", (unsigned int) hdat.fields.x00_3);
      fprintf (stderr, "Gap amount: %d \n", (unsigned int) hdat.fields.gap_amount);
      fprintf (stderr, "Section amount: %d \n", (unsigned int) hdat.fields.section_amount);
      fprintf (stderr, "0x20 (long): %x \n", (unsigned int) hdat.fields.x20);
      fprintf (stderr, "0x80 (long): %x \n", (unsigned int) hdat.fields.x80);
      fprintf (stderr, "0x40 (long): %x \n", (unsigned int) hdat.fields.x40);
      fprintf (stderr, "Section map id: %d \n", (unsigned int) hdat.fields.section_map_id);
      fprintf (stderr, "Section map address: %x \n", (unsigned int) hdat.fields.section_map_address + 0x100);
      fprintf (stderr, "0x00 (long): %x \n", (unsigned int) hdat.fields.x00_4);
      fprintf (stderr, "Section Info id: %d \n", (unsigned int) hdat.fields.section_info_id);
      fprintf (stderr, "Section array size: %d \n", (unsigned int) hdat.fields.section_array_size);
      fprintf (stderr, "Gap array size: %d \n", (unsigned int) hdat.fields.gap_array_size);
      fprintf (stderr, "CRC: %x\n", (unsigned int) hdat.fields.CRC);
    }

  /* Section Map */
  dat->byte = hdat.fields.section_map_address + 0x100;

  LOG_INSANE ("\n\n +++ Raw system section bytes:\n");
  for (i = 0; i < 0x14; i++)
    {
      ss.data[i] = bit_read_RC (dat);
      snprintf (tmp, 1024, "%x ", ss.data[i]);
      LOG_INSANE (tmp);
    }

  if (log_level_get () > LOG_LEVEL_COMPRESS)
    {
      fprintf (stderr, "\n**** Compressed Section Page Map ****\n");
      fprintf (stderr, "Section Type (should be 0x41630e3b): %x \n", ss.fields.section_type);
      fprintf (stderr, "DecompDataSize: %x \n", ss.fields.decomp_data_size);
      fprintf (stderr, "CompDataSize: %x \n", ss.fields.comp_data_size);
      fprintf (stderr, "Compression Type: %x \n", ss.fields.compression_type);
      fprintf (stderr, "Checksum: %x \n\n", ss.fields.checksum);
    }

  dec_r2004_section_map (dat, ss.fields.comp_data_size, ss.fields.decomp_data_size);

  if (header.section == NULL)
    {
      LOG_ERROR ("Failed to read R2004 Section Page Map.\n");
      return -1;
    }

  /* Section Info */
  section = find_section (hdat.fields.section_info_id);

  if (section)
    {
      dat->byte = section->address;
      LOG_INSANE ("\n\n +++ Raw system section bytes:\n");
      for (i = 0; i < 0x14; i++)
	{
	  ss.data[i] = bit_read_RC (dat);
	  snprintf (tmp, 1024, "%x ", ss.data[i]);
	  LOG_INSANE (tmp);
	}

      if (log_level_get () >= LOG_LEVEL_COMPRESS)
	{
	  fprintf (stderr, "\n**** Compressed Section Info ****\n");
	  fprintf (stderr, "Section Type (should be 0x4163003b): %x \n", ss.fields.section_type);
	  fprintf (stderr, "DecompDataSize: %ld \n", ss.fields.decomp_data_size);
	  fprintf (stderr, "CompDataSize: %ld \n", ss.fields.comp_data_size);
	  fprintf (stderr, "Compression Type: %x \n", ss.fields.compression_type);
	  fprintf (stderr, "Checksum: %x \n\n", ss.fields.checksum);
	}

      dec_r2004_section_info (dat, ss.fields.comp_data_size, ss.fields.decomp_data_size);
    }
  else
    {
       LOG_ERROR ("Section Info not found.\n");
       return -1;
    }

  /* Header Variables */
  dec_r2004_section_variables (dat, dwg);

  /* Classes */
  dec_r2004_section_classes (dat, dwg);

  /* Objects scanning */
  dec_r2004_section_handles (dat, dwg);

  /* Clean up
   */
  decode_header_free ();

  if (dwg->num_objects == 0)
    {
       LOG_ERROR ("No objects found.\n");
       return -1;
    }

  return 0;
}

/** Read R2004 Section Map */
/* The Section Map is a vector of number, size, and address triples used
 * to locate the sections in the file.
 */
void
dec_r2004_section_map (Bit_Chain * dat, uint32_t comp_data_size, uint32_t decomp_data_size)
{
  char tmp[1024];
  char *decomp, *ptr;
  uint32_t i;
  uint32_t section_address, bytes_remaining;
  uint32_t crc, crc2;

  /* Allocate memory to hold decompressed data */
  decomp = (char *) malloc (decomp_data_size * sizeof (char));

  if (decomp == 0)
    {
      LOG_WARN ("No memory to decompress Section Map\n");
      return;
    }

  decompress_r2004_section (dat, decomp, comp_data_size);

  LOG_COMPRESS ("\n#### Section Map fields R2004 ####\n");
  i = 0;
  section_address = 0x100;	// starting address
  bytes_remaining = decomp_data_size;
  ptr = decomp;
  header.num_sections = 0;
  header.section = NULL;

  while (bytes_remaining)
    {
      if (header.num_sections == 0)
	header.section = (Dwg_Section *) malloc (sizeof (Dwg_Section));
      else
	header.section = (Dwg_Section *) realloc (header.section, sizeof (Dwg_Section) * (header.num_sections + 1));

      header.section[i].number = *((int32_t *) ptr);
      header.section[i].size = *((uint32_t *) ptr + 1);
      header.section[i].address = section_address;
      section_address += header.section[i].size;
      bytes_remaining -= 8;
      ptr += 8;

      if (log_level_get () >= LOG_LEVEL_COMPRESS)
	{
	  fprintf (stderr, "SectionNumber: %ld \n", header.section[i].number);
	  fprintf (stderr, "  SectionSize: %x \n", header.section[i].size);
	  fprintf (stderr, "  SectionAddr: %x \n", header.section[i].address);
	}

      if (header.section[i].number < 0)
	{
	  header.section[i].parent = *((uint32_t *) ptr);
	  header.section[i].left = *((uint32_t *) ptr + 1);
	  header.section[i].right = *((uint32_t *) ptr + 2);
	  header.section[i].x00 = *((uint32_t *) ptr + 3);
	  bytes_remaining -= 16;
	  ptr += 16;

	  if (log_level_get () >= LOG_LEVEL_COMPRESS)
	    {
	      fprintf (stderr, "+++\n  Parent: %ld \n", header.section[i].parent);
	      fprintf (stderr, "  Left: %ld \n", header.section[i].left);
	      fprintf (stderr, "  Right: %ld \n", header.section[i].right);
	      fprintf (stderr, "  0x00: %ld \n", header.section[i].x00);
	    }
	}

      header.num_sections++;
      i++;
    }

  /* Check CRC TODO
  crc = bit_crc32 (0xc0c1, dat->chain, dat->byte);
  crc2 = bit_read_RL (dat);
  if (crc != crc2)
    {
      snprintf (tmp, 1024, "Section Map CRC failed! CRC:%x CRC2:%x\n", crc, crc2);
      LOG_ERROR (tmp);
    }
   */

  free (decomp);
}


/** Read R2004 Section Info */
void
dec_r2004_section_info (Bit_Chain * dat, uint32_t comp_data_size, uint32_t decomp_data_size)
{
  char tmp[1024];
  char *decomp, *ptr;
  unsigned start_offset, unknown;
  unsigned data_size;
  unsigned section_number;
  unsigned i, j;

  decomp = (char *) malloc (decomp_data_size * sizeof (char));
  if (decomp == 0)
    {
      LOG_INFO ("No memory to decompress Section Info\n");
      return;			// No memory
    }

  decompress_r2004_section (dat, decomp, comp_data_size);

  memcpy (&header.num_descriptions, decomp, 4);
  header.section_info = (Dwg_Section_Info *) malloc (sizeof (Dwg_Section_Info) * header.num_descriptions);

  if (log_level_get () >= LOG_LEVEL_COMPRESS)
    {
      fprintf (stderr, "\n#### Section Info fields R2004 ####\n");
      fprintf (stderr, "NumDescriptions: %d\n", *((int *) decomp));
      fprintf (stderr, "0x02:            %x\n", *((int *) decomp + 1));
      fprintf (stderr, "0x00007400:      %x\n", *((int *) decomp + 2));
      fprintf (stderr, "0x00:            %x\n", *((int *) decomp + 3));
      fprintf (stderr, "Unknown:         %x\n", *((int *) decomp + 4));
    }

  ptr = decomp + 20;
  for (i = 0; i < header.num_descriptions; ++i)
    {
      header.section_info[i].size = *((int *) ptr);
      header.section_info[i].unknown1 = *((int *) ptr + 1);
      header.section_info[i].num_sections = *((int *) ptr + 2);
      header.section_info[i].max_decomp_size = *((int *) ptr + 3);
      header.section_info[i].unknown2 = *((int *) ptr + 4);
      header.section_info[i].compressed = *((int *) ptr + 5);
      header.section_info[i].type = *((int *) ptr + 6);
      header.section_info[i].encrypted = *((int *) ptr + 7);
      ptr += 32;
      memcpy (header.section_info[i].name, ptr, 64);
      ptr += 64;

      if (log_level_get () >= LOG_LEVEL_COMPRESS)
	{
	  fprintf (stderr, "\n**** Section Info description fields ****\n");
	  fprintf (stderr, "Size: %d\n", (int) header.section_info[i].size);
	  fprintf (stderr, "Unknown: %d\n", (int) header.section_info[i].unknown1);
	  fprintf (stderr, "Number of sections:  %d\n", (int) header.section_info[i].num_sections);
	  fprintf (stderr, "Max decompressed size: %d\n", (int) header.section_info[i].max_decomp_size);
	  fprintf (stderr, "Unknown: %d\n", (int) header.section_info[i].unknown2);
	  fprintf (stderr, "Compressed (0x02): %x\n", (unsigned int) header.section_info[i].compressed);
	  fprintf (stderr, "Section Type: %d\n", (int) header.section_info[i].type);
	  fprintf (stderr, "Encrypted: %d\n", (int) header.section_info[i].encrypted);
	  fprintf (stderr, "Section Name: %s\n\n", header.section_info[i].name);
	}

      header.section_info[i].sections = (Dwg_Section **) malloc
	(header.section_info[i].num_sections * sizeof (Dwg_Section *));

      if (header.section_info[i].num_sections < 1000)
	{
	  snprintf (tmp, 1024, "Section count %ld in area %d\n", header.section_info[i].num_sections, i);
	  LOG_COMPRESS (tmp);

	  for (j = 0; j < header.section_info[i].num_sections; j++)
	    {
	      section_number = *((int *) ptr);	// Index into SectionMap
	      data_size = *((int *) ptr + 1);
	      start_offset = *((int *) ptr + 2);
	      // high 32 bits of 64-bit start offset?
	      unknown = *((int *) ptr + 3);
	      ptr += 16;

	      header.section_info[i].sections[j] = find_section (section_number);

	      if (log_level_get () >= LOG_LEVEL_COMPRESS)
		{
		  fprintf (stderr, "Section Number: %d\n", section_number);
		  fprintf (stderr, "  Data size:    %d\n", data_size);
		  fprintf (stderr, "  Start offset: %x\n", start_offset);
		  fprintf (stderr, "  Unknown:      %d\n", unknown);
		}
	    }
	}
      else /* sanity check */
	{
	  snprintf (tmp, 1024,
		    "section count %ld in area %d too high! Skipping.\n", header.section_info[i].num_sections, i);
	  LOG_ERROR (tmp);
	}
    }

  free (decomp);
}

/** R2004 Variables Section */
void
dec_r2004_section_variables (Bit_Chain * dat, Dwg_Struct * dwg)
{
  char tmp[1024];
  int error;
  uint32_t size;
  uint32_t ckr, ckr2;
  Bit_Chain sec_dat;

  error = dec_r2004_compressed_section (dat, &sec_dat, SECTION_VARIABLES);
  if (error == 1)
    {
      LOG_ERROR ("No section for Variables found!\n");
      return;
    }
  else if (error != 0)
    {
      LOG_ERROR ("Not enough memory for Variables.\n");
      return;
    }

  LOG_TRACE ("\nVARIABLES (begin)\n");

  if (bit_search_sentinel (&sec_dat, decode_sentinel (DWG_SENTINEL_VARIABLE_BEGIN)))
    {
      size = bit_read_RL (&sec_dat);
      snprintf (tmp, 1024, "Length: %lu\n", size);
      LOG_TRACE (tmp);
      dwg_decode_variables (&sec_dat, dwg);
    }

  /* Check CRC TODO
  sec_dat.byte = header.section[0].address + header.section[0].size - 18;
  sec_dat.bit = 0;
  ckr = bit_read_RL (&sec_dat);
  ckr2 = bit_crc32 (0xc0c1, sec_dat.chain + header.section[0].address + 16, header.section[0].size - 34);
  if (ckr != ckr2)
    {
      snprintf (tmp, 1024, "Variables CRC failed! CRC:%x CRC2:%x \n", header.section[0].number, ckr, ckr2);
      LOG_ERROR (tmp);
    }
   */
  LOG_TRACE ("\nVARIABLES (end)\n");

  free (sec_dat.chain);
}

/** R2004 Class Section */
void
dec_r2004_section_classes (Bit_Chain * dat, Dwg_Struct * dwg)
{
  char tmp[1024];
  int error;
  uint32_t size, max_num;
  uint32_t pvz, ckr, ckr2;
  Bit_Chain sec_dat;

  error = dec_r2004_compressed_section (dat, &sec_dat, SECTION_CLASSES);
  if (error == 1)
    {
      LOG_ERROR ("No section for Classes found!\n");
      return;
    }
  else if (error != 0)
    {
      LOG_ERROR ("Not enough memory for Classes.\n");
      return;
    }

  LOG_TRACE ("\nCLASS (begin)\n");

  if (bit_search_sentinel (&sec_dat, decode_sentinel (DWG_SENTINEL_CLASS_BEGIN)))
    {
      size = bit_read_RL (&sec_dat);	// size of class data area
      max_num = bit_read_BS (&sec_dat);	// Maximum class number
      bit_read_RC (&sec_dat);	// 0x00
      bit_read_RC (&sec_dat);	// 0x00
      bit_read_B (&sec_dat);	// 1

      dwg->num_classes = 0;
      do
	{
	  uint32_t idc;
          uint32_t num_objects, dwg_version, maint_version;

	  idc = dwg->num_classes;
	  if (idc == 0)
	    dwg->dwg_class = (Dwg_Class *) malloc (sizeof (Dwg_Class));
	  else
	    dwg->dwg_class = (Dwg_Class *) realloc (dwg->dwg_class, (idc + 1) * sizeof (Dwg_Class));

	  dwg->dwg_class[idc].number = bit_read_BS (&sec_dat);
	  dwg->dwg_class[idc].version = bit_read_BS (&sec_dat);
	  dwg->dwg_class[idc].appname = bit_read_TV (&sec_dat);
	  dwg->dwg_class[idc].cppname = bit_read_TV (&sec_dat);
	  dwg->dwg_class[idc].dxfname = bit_read_TV (&sec_dat);
	  dwg->dwg_class[idc].wasazombie = bit_read_B (&sec_dat);
	  dwg->dwg_class[idc].item_class_id = bit_read_BS (&sec_dat);

	  num_objects = bit_read_BL (&sec_dat);	// DXF 91
	  dwg_version = bit_read_BS (&sec_dat);	// Dwg Version
	  maint_version = bit_read_BS (&sec_dat);	// Maintenance release version.
	  bit_read_BL (&sec_dat);	// Unknown (normally 0L)
	  bit_read_BL (&sec_dat);	// Unknown (normally 0L)

	  if (log_level_get () >= LOG_LEVEL_TRACE)
	    {
	      fprintf (stderr, "\nNumber: %d \n", dwg->dwg_class[idc].number);
	      fprintf (stderr, "Version: %x \n", dwg->dwg_class[idc].version);
	      fprintf (stderr, "Application name: %s \n", dwg->dwg_class[idc].appname);
	      fprintf (stderr, "C++ class name: %s \n", dwg->dwg_class[idc].cppname);
	      fprintf (stderr, "DXF record name: %s \n", dwg->dwg_class[idc].dxfname);
	    }

	  dwg->num_classes++;
	}
      while (sec_dat.byte < (size - 1));
    }

  /* Check CRC TODO
  sec_dat.byte = header.section[1].address + header.section[1].size - 18;
  sec_dat.bit = 0;
  ckr = bit_read_RL (dat);
  ckr2 = bit_crc32 (0xc0c1, dat->chain + header.section[1].address + 16, header.section[1].size - 34);
  if (ckr != ckr2)
    {
      snprintf (tmp, 1024, "Section %d crc todo ckr:%x ckr2:%x \n\n", header.section[1].number, ckr, ckr2);
      LOG_ERROR (tmp);
    }
   */

  snprintf (tmp, 1024, "Number of classes read: %u\n", dwg->num_classes);
  LOG_TRACE (tmp);
  LOG_TRACE ("\nCLASS (end)\n");

  free (sec_dat.chain);
}

/** R2004 Handles Section */
void
dec_r2004_section_handles (Bit_Chain * dat, Dwg_Struct * dwg)
{
  char tmp[1024];
  int error;
  uint16_t section_size = 0;
  unsigned char sgdc[2];
  uint32_t duabyte, maplasta;
  Bit_Chain hdl_dat;
  Bit_Chain obj_dat;

  error = dec_r2004_compressed_section (dat, &obj_dat, SECTION_DBOBJECTS);
  if (error == 1)
    {
      LOG_ERROR ("No section for Objects found!\n");
      return;
    }
  else if (error != 0)
    {
      LOG_ERROR ("Not enough memory for Objects.\n");
      return;
    }

  error = dec_r2004_compressed_section (dat, &hdl_dat, SECTION_HANDLES);
  if (error == 1)
    {
      LOG_ERROR ("No section for Handles found!\n");
      free (obj_dat.chain);
      return;
    }
  else if (error != 0)
    {
      LOG_ERROR ("Not enough memory for Handles.\n");
      free (obj_dat.chain);
      return;
    }

  LOG_TRACE ("\nOBJECTS (begin)\n");

  maplasta = hdl_dat.byte + hdl_dat.size;
  dwg->num_objects = 0;

  do
    {
      uint32_t last_offset, last_handle, previous_address = 0;
      uint32_t ckr, ckr2;

      duabyte = hdl_dat.byte;
      sgdc[0] = bit_read_RC (&hdl_dat);
      sgdc[1] = bit_read_RC (&hdl_dat);
      section_size = (sgdc[0] << 8) | sgdc[1];

      if (log_level_get () >= LOG_LEVEL_TRACE)
	{
	  fprintf (stderr, "section_size: %u \n", section_size);
	  if (section_size > 2032)
	    fprintf (stderr, "[ERROR] Object-map section size greater than 2032!\n");
	}

      last_handle = 0;
      last_offset = 0;
      while (hdl_dat.byte - duabyte < section_size)
	{
	  int32_t tmphdl, tmpadr;

	  previous_address = hdl_dat.byte;

	  tmphdl = bit_read_MC (&hdl_dat);
	  last_handle += tmphdl;

	  tmpadr = bit_read_MC (&hdl_dat);
	  last_offset += tmpadr;

	  //fprintf (stderr, "Hdl: %lu\nAdr: %lu\n", last_handle, last_offset);
	  if (last_offset > obj_dat.size)
	  {
              free (hdl_dat.chain);
              free (obj_dat.chain);
	      LOG_ERROR ("Offset address greater than object section size.\n");
	      return;
	  }
	  dwg_object_add_from_chain (dwg, &obj_dat, last_offset);
	}

      if (hdl_dat.byte == previous_address)
	break;

      if (hdl_dat.bit > 0)
	{
	  hdl_dat.byte += 2;
	  hdl_dat.bit = 0;
	}
      sgdc[0] = bit_read_RC (&hdl_dat);
      sgdc[1] = bit_read_RC (&hdl_dat);
      /* Check CRC 
      ckr = (sgdc[0] << 8) | sgdc[1];
      ckr2 = bit_crc32 (0xc0c1, hdl_dat.chain + duabyte, section_size);
      if (ckr != ckr2)
	{
	  snprintf (tmp, 1024, "Section Obj-handles CRC failed! CRC:%x CRC2:%x\n", ckr, ckr2);
	  LOG_ERROR (tmp);
          free (hdl_dat.chain);
          free (obj_dat.chain);
	  return;
	}
       */

      if (hdl_dat.byte >= maplasta)
	break;
    }
  while (section_size > 2);

  snprintf (tmp, 1024, "\n Num objects: %lu \n", dwg->num_objects);
  LOG_TRACE (tmp);
  LOG_TRACE ("\nOBJECTS (end)\n");

  free (hdl_dat.chain);
  free (obj_dat.chain);
}

/** Compressed system section of a 2004 DWG file */
int
dec_r2004_compressed_section (Bit_Chain * dat, Bit_Chain * sec_dat, uint32_t section_type)
{
  unsigned i, j;
  char *decomp;
  int32_t address, sec_mask, max_decomp_size;
  Dwg_Section_Info *info = NULL;

  /* Encrypted Section Header */
  union _encrypted_section_header
  {
    uint32_t long_data[8];
    unsigned char char_data[32];
    struct
    {
      int32_t tag;
      int32_t section_type;
      int32_t data_size;
      int32_t section_size;
      int32_t start_offset;
      int32_t unknown;
      int32_t checksum_1;
      int32_t checksum_2;
    } fields;
  } es;

  for (i = 0; i < header.num_descriptions && info == 0; ++i)
    if (header.section_info[i].type == section_type)
      info = &header.section_info[i];

  if (info == 0)
    {
      return 1;
    }


  max_decomp_size = info->num_sections * info->max_decomp_size;

  decomp = (char *) malloc (max_decomp_size * sizeof (char));

  if (decomp == 0)
    return 2;			// No memory

  for (i = 0; i < info->num_sections; ++i)
    {
      address = info->sections[i]->address;
      dat->byte = address;

      for (j = 0; j < 0x20; j++)
	es.char_data[j] = bit_read_RC (dat);

      sec_mask = 0x4164536b ^ address;

      for (j = 0; j < 8; ++j)
	es.long_data[j] ^= sec_mask;

      if (log_level_get () >= LOG_LEVEL_COMPRESS)
	{
	  fprintf (stderr, "\n=== Compressed Section ===\n");
	  fprintf (stderr, "Section Tag (should be 0x41630?3b): %x \n", (unsigned int) es.fields.tag);
	  fprintf (stderr, "Section Type: %x \n", (unsigned int) es.fields.section_type);
	  // this is the number of bytes that is read in decompress_r2004_section (+ 2bytes)
	  fprintf (stderr, "Data size: %x\n", (unsigned int) es.fields.data_size);
	  fprintf (stderr, "Comp. data size: %x\n", (unsigned int) es.fields.section_size);
	  fprintf (stderr, "StartOffset: %x \n", (unsigned int) es.fields.start_offset);
	  fprintf (stderr, "Unknown: %x \n", (unsigned int) es.fields.unknown);
	  fprintf (stderr, "Checksum1: %x \n", (unsigned int) es.fields.checksum_1);
	  fprintf (stderr, "Checksum2: %x \n\n", (unsigned int) es.fields.checksum_2);
	}

      decompress_r2004_section (dat, &decomp[i * info->max_decomp_size], es.fields.data_size);
    }

  sec_dat->bit = 0;
  sec_dat->byte = 0;
  sec_dat->chain = (unsigned char *) decomp;
  sec_dat->size = max_decomp_size;
  sec_dat->version = dat->version;

  return 0;
}

/** R2004 Literal Length */
int
read_literal_length (Bit_Chain * dat, unsigned char *opcode)
{
  int total = 0;
  unsigned char byte = bit_read_RC (dat);

  *opcode = 0x00;

  if (byte >= 0x01 && byte <= 0x0F)
    return byte + 3;
  else if (byte == 0)
    {
      total = 0x0F;
      while ((byte = bit_read_RC (dat)) == 0x00)
	{
	  total += 0xFF;
	}
      return total + byte + 3;
    }
  else if (byte & 0xF0)
    *opcode = byte;

  return 0;
}

/** R2004 Long Compression Offset */
int
read_long_compression_offset (Bit_Chain * dat)
{
  int total = 0;
  unsigned char byte = bit_read_RC (dat);
  if (byte == 0)
    {
      total = 0xFF;
      while ((byte = bit_read_RC (dat)) == 0x00)
	total += 0xFF;
    }
  return total + byte;
}

/** R2004 Two Byte Offset */
int
read_two_byte_offset (Bit_Chain * dat, int *lit_length)
{
  int offset;
  unsigned char firstByte = bit_read_RC (dat);
  unsigned char secondByte = bit_read_RC (dat);
  offset = (firstByte >> 2) | (secondByte << 6);
  *lit_length = (firstByte & 0x03);
  return offset;
}

/** Decompresses a system section of a 2004 DWG flie */
int
decompress_r2004_section (Bit_Chain * dat, char *decomp, uint32_t comp_data_size)
{
  int lit_length, i;
  int comp_offset, comp_bytes;
  unsigned char opcode1 = 0, opcode2;
  int32_t start_byte = dat->byte;
  char *src, *dst = decomp;

  // length of the first sequence of uncompressed or literal data.
  lit_length = read_literal_length (dat, &opcode1);

  for (i = 0; i < lit_length; ++i)
    *dst++ = bit_read_RC (dat);

  opcode1 = 0x00;
  while (dat->byte - start_byte < comp_data_size)
    {
      if (opcode1 == 0x00)
	opcode1 = bit_read_RC (dat);

      if (opcode1 >= 0x40)
	{
	  comp_bytes = ((opcode1 & 0xF0) >> 4) - 1;
	  opcode2 = bit_read_RC (dat);
	  comp_offset = (opcode2 << 2) | ((opcode1 & 0x0C) >> 2);

	  if (opcode1 & 0x03)
	    {
	      lit_length = (opcode1 & 0x03);
	      opcode1 = 0x00;
	    }
	  else
	    lit_length = read_literal_length (dat, &opcode1);
	}
      else if (opcode1 >= 0x21 && opcode1 <= 0x3F)
	{
	  comp_bytes = opcode1 - 0x1E;
	  comp_offset = read_two_byte_offset (dat, &lit_length);

	  if (lit_length != 0)
	    opcode1 = 0x00;
	  else
	    lit_length = read_literal_length (dat, &opcode1);
	}
      else if (opcode1 == 0x20)
	{
	  comp_bytes = read_long_compression_offset (dat) + 0x21;
	  comp_offset = read_two_byte_offset (dat, &lit_length);

	  if (lit_length != 0)
	    opcode1 = 0x00;
	  else
	    lit_length = read_literal_length (dat, &opcode1);
	}
      else if (opcode1 >= 0x12 && opcode1 <= 0x1F)
	{
	  comp_bytes = (opcode1 & 0x0F) + 2;
	  comp_offset = read_two_byte_offset (dat, &lit_length) + 0x3FFF;

	  if (lit_length != 0)
	    opcode1 = 0x00;
	  else
	    lit_length = read_literal_length (dat, &opcode1);
	}
      else if (opcode1 == 0x10)
	{
	  comp_bytes = read_long_compression_offset (dat) + 9;
	  comp_offset = read_two_byte_offset (dat, &lit_length) + 0x3FFF;

	  if (lit_length != 0)
	    opcode1 = 0x00;
	  else
	    lit_length = read_literal_length (dat, &opcode1);
	}
      else if (opcode1 == 0x11)
	break;			// Terminates the input stream, everything is ok!
      else
	return 1;		// error in input stream

      // LOG_TRACE ("got compressed data %d\n",comp_bytes);
      // copy "compressed data"
      src = dst - comp_offset - 1;
      assert (src > decomp);
      for (i = 0; i < comp_bytes; ++i)
	*dst++ = *src++;

      // copy "literal data"
      // LOG_TRACE ("got literal data %d\n",lit_length);
      for (i = 0; i < lit_length; ++i)
	*dst++ = bit_read_RC (dat);
    }

  return 0;			// Success
}

Dwg_Section *
find_section (uint32_t index)
{
  int i;

  if (header.section == NULL || index == 0)
    return NULL;
  for (i = 0; i < header.num_sections; ++i)
    {
      if ((unsigned) header.section[i].number == index)
	return (&header.section[i]);
    }
  return NULL;
}

/** Section page checksum */
int32_t
page_checksum (int32_t seed, unsigned char *data, int32_t size)
{
  //seed = 0;
  int32_t sum1, sum2, opcode, chunksize;
  int i = 0;
  sum1 = seed & 0xffff;
  sum2 = seed >> 0x10;
  opcode = 0x15b0;

  while (size != 0)
    {
      //if ( &opcode > size) FIXME pppplease
      if (opcode > size)
	//return (chunksize = &opcode); FIXME pppplease
	return (chunksize = opcode);
      else
	return (chunksize = size);

      size -= chunksize;

      for (i; i < chunksize; i++)
	{
	  sum1 += *data++;
	  sum2 += sum1;
	}

      sum1 %= 0xFFF1;
      sum2 %= 0xFFF1;
    }

  return (sum2 << 0x10) | (sum1 & 0xffff);
}
