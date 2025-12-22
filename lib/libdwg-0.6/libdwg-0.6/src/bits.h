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
 *     \file       bits.h
 *     \brief      Low level read and write function prototypes
 *     \author     written by Felipe Castro
 *     \author     modified by Felipe Corrêa da Silva Sances
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

/**
 * The position of bits within bytes is numerically ordered as depicted below:
 *
 * position: 01234567 01234567 01234567 ...
 * bits    : 76543210 76543210 76543210 ...
 *          \______/ \______/ \______/
 *           byte 1   byte 2   byte 3  ...
 */

#ifndef BITS_H
#define BITS_H

#include <stdint.h>

#include "dwg.h"
#include "decode.h"

/* Functions for raw data manipulations
 */
void
bit_advance_position(Bit_Chain *dat, int16_t jump);

BITCODE_B
bit_read_B(Bit_Chain *bit_chain);

BITCODE_BB
bit_read_BB(Bit_Chain *bit_chain);

BITCODE_4BITS
bit_read_4BITS(Bit_Chain *dat);

BITCODE_RC
bit_read_RC(Bit_Chain *bit_chain);

BITCODE_RS
bit_read_RS(Bit_Chain *bit_chain);

BITCODE_RL
bit_read_RL(Bit_Chain *bit_chain);

BITCODE_RD
bit_read_RD(Bit_Chain *bit_chain);

/* Functions for manipulating compacted data
 */
BITCODE_BS
bit_read_BS(Bit_Chain *bit_chain);

BITCODE_BL
bit_read_BL(Bit_Chain *bit_chain);

BITCODE_BD
bit_read_BD(Bit_Chain *bit_chain);

BITCODE_MC
bit_read_MC(Bit_Chain *bit_chain);

BITCODE_MS
bit_read_MS(Bit_Chain *bit_chain);

void
bit_read_BE(Bit_Chain *bit_chain, double *x, double *y, double *z);

BITCODE_DD
bit_read_DD(Bit_Chain *bit_chain, double defaux);

BITCODE_BT
bit_read_BT(Bit_Chain *bit_chain);

int
bit_read_H(Bit_Chain *bit_chain, Dwg_Handle *handle);

uint16_t
bit_read_CRC(Bit_Chain *bit_chain);

int
bit_check_CRC(Bit_Chain *bit_chain, uint32_t start_address, uint16_t semo);

uint8_t *
bit_read_TV(Bit_Chain *dat);

uint32_t
bit_read_L(Bit_Chain *dat);

void
bit_read_CMC(Bit_Chain *dat, Dwg_Color *color);

int
bit_search_sentinel(Bit_Chain *dat, uint8_t sentinel[16]);

void
bit_chain_alloc(Bit_Chain *dat);

void
bit_print(Bit_Chain *dat, uint32_t size);

void
bit_explore_chain(Bit_Chain *dat, uint32_t size);

/* Functions for CRC 
 */ 
uint16_t
bit_crc8 (uint16_t dx, uint8_t *adr, int32_t n);

uint32_t
bit_crc32 (uint16_t seed, uint8_t *adr, uint16_t n);


/*******************************************************************
 * Writing stuff, deprecated
 */
#  ifdef ENABLE_WRITE
void
bit_write_B(Bit_Chain *bit_chain, uint8_t value);
void
bit_write_BB(Bit_Chain *bit_chain, uint8_t value);
void
bit_write_4BITS(Bit_Chain *dat, uint8_t value);
void
bit_write_RC(Bit_Chain *bit_chain, uint8_t value);
void
bit_write_RS(Bit_Chain *bit_chain, uint16_t value);
void
bit_write_RL(Bit_Chain *bit_chain, uint32_t value);
void
bit_write_RD(Bit_Chain *bit_chain, double value);
void
bit_write_BS(Bit_Chain *bit_chain, uint16_t value);
void
bit_write_BL(Bit_Chain *bit_chain, uint32_t value);
void
bit_write_BD(Bit_Chain *bit_chain, double value);
void
bit_write_MC(Bit_Chain *bit_chain, int32_t value);
void
bit_write_MS(Bit_Chain *bit_chain, uint32_t value);
void
bit_write_BE(Bit_Chain *bit_chain, double x, double y, double z);
void
bit_write_DD(Bit_Chain *bit_chain, double value, double defaux);
void
bit_write_BT(Bit_Chain *bit_chain, double value);
void
bit_write_H(Bit_Chain *dat, Dwg_Handle *handle);
uint16_t
bit_write_CRC(Bit_Chain *dat, uint32_t start_address, uint16_t seed);
void
bit_write_TV(Bit_Chain *dat, uint8_t *value);
void
bit_write_L(Bit_Chain *dat, uint32_t value);
void
bit_write_CMC(Bit_Chain *dat, Dwg_Color *color);
void
bit_write_sentinel(Bit_Chain *dat, uint8_t sentinel[16]);
#  endif

#endif
