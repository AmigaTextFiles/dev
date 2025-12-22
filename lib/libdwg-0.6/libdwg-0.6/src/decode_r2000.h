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
 *     \file       decode_r2000.h
 *     \brief      R2000 (R15) decode function prototypes
 *     \author     written by Felipe Castro
 *     \author     modified by Felipe Corrêa da Silva Sances
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \author     modified by Till Heuschmann
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#ifndef _DWG_R2000_H_
#define _DWG_R2000_H_

#include "dwg.h"

int decode_r2000 (Bit_Chain *dat, Dwg_Struct *dwg);

void dec_r2000_section_locator (Bit_Chain *dat, Dwg_Struct *dwg);

void dec_r2000_variables (Bit_Chain *dat, Dwg_Struct *dwg);

void dec_r2000_classes (Bit_Chain *dat, Dwg_Struct *dwg);

void dec_r2000_objects (Bit_Chain * dat, Dwg_Struct * dwg);

void dec_r2000_measurement (Bit_Chain *dat, Dwg_Struct *dwg);

#endif
