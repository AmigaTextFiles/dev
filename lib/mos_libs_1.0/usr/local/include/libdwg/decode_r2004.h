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
 *     \file       decode_r2004.h
 *     \brief      R2004 decode function prototypes
 *     \author     written by Felipe Castro
 *     \author     modified by Felipe Corrêa da Silva Sances
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \author     modified by Till Heuschmann
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#ifndef _DWG_R2004_H_
#define _DWG_R2004_H_

#include <stdint.h>

#include "dwg.h"

int decode_r2004 (Bit_Chain * dat, Dwg_Struct * dwg);

void dec_r2004_section_map (Bit_Chain * dat, uint32_t comp_data_size, uint32_t decomp_data_size);

void dec_r2004_section_info (Bit_Chain * dat, uint32_t comp_data_size, uint32_t decomp_data_size);

void dec_r2004_section_variables (Bit_Chain * dat, Dwg_Struct * dwg);

void dec_r2004_section_classes (Bit_Chain * dat, Dwg_Struct * dwg);

void dec_r2004_section_handles (Bit_Chain * dat, Dwg_Struct * dwg);

int dec_r2004_compressed_section (Bit_Chain * dat, Bit_Chain * sec_dat, uint32_t section_type);

int read_literal_length (Bit_Chain * dat, unsigned char *opcode);

int read_long_compression_offset (Bit_Chain * dat);

int read_two_byte_offset (Bit_Chain * dat, int *lit_length);

int decompress_r2004_section (Bit_Chain * dat, char *decomp, uint32_t comp_data_size);

Dwg_Section *find_section (uint32_t index);

int32_t page_checksum (int32_t seed, unsigned char *data, int32_t size);

#endif
